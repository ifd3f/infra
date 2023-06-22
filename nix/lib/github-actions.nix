{ lib }:
with lib; rec {
  ghexpr = v: "\${{ ${v} }}";

  makeGithubWorkflow = { nodes, cachix, cronSchedule, known_hosts }: {
    name = "Build and deploy";
    run-name = "Build and deploy (${ghexpr "inputs.sha || github.sha"})";

    on = {
      schedule = [{ cron = cronSchedule; }];
      push = { };
      workflow_dispatch = { };
      workflow_call.inputs = {
        sha = {
          description = "SHA to run on";
          required = true;
          type = "string";
        };
        deploy = {
          description = "Whether to deploy or not";
          default = false;
          type = "boolean";
        };
      };
      workflow_call.secrets.SSH_PRIVATE_KEY = {
        description = "SSH key to use for deployment";
        required = true;
      };
    };

    env = {
      KNOWN_HOSTS = known_hosts;
      TARGET_FLAKE = let
        repo = ghexpr "github.repository";
        sha = ghexpr "inputs.sha || github.sha";
        p = ghexpr "inputs.sha || github.sha";
      in "github:${repo}/${sha}";
    };

    jobs = mapAttrs (makeJob { inherit nodes cachix; }) nodes;
  };

  makeJob = envargs: key:
    { name ? key, system, needs ? [ ], prune-runner ? false, build ? [ ]
    , run ? null, deploy ? null }@spec:
    let info = systems.elaborate system;
    in if info.isx86_64 then
      makex86Job envargs key spec
    else # TODO: support aarch64 jobs
      abort "${key} requests unsupported system ${system}";

  makex86Job = { nodes, cachix }:
    key:
    { name ? key, system, needs ? [ ], prune-runner ? false, build ? [ ]
    , run ? null, deploy ? null, extraPreBuildSteps ? [ ] }:
    if build == [ ] && run == null && deploy == null then
      abort (toString "${key} did not specify a run, build, or deploy")
    else {
      inherit name;
      strategy.fail-fast = false;

      runs-on =
        if system == "x86_64-darwin" then "macos-latest" else "ubuntu-latest";

      needs = let missingDeps = filter (d: !(hasAttr d nodes)) needs;
      in if missingDeps != [ ] then
        abort "${key} requests nodes that do not exist: ${toString missingDeps}"
      else
        needs;

      steps = let
        pruneStep = {
          name = "Remove unneccessary packages";
          run = ''
            echo "=== Before pruning ==="
            df -h
            sudo rm -rf /usr/share /usr/local /opt || true
            echo
            echo "=== After pruning ==="
            df -h
          '';
        };

        setupSteps = [
          {
            "uses" = "webfactory/ssh-agent@v0.8.0";
            "with".ssh-private-key = ghexpr "secrets.SSH_PRIVATE_KEY";
          }
          {
            name = "Append to known_hosts";
            run = ''
              echo '\n' >> ~/.ssh/known_hosts
              echo "$KNOWN_HOSTS" >> ~/.ssh/known_hosts
            '';
            env.KNOWN_HOSTS = ghexpr "env.KNOWN_HOSTS";
          }
          {
            "uses" = "cachix/install-nix-action@v22";
            "with" = {
              nix_path = "nixpkgs=channel:nixos-unstable";
              extra_nix_config = ''
                experimental-features = nix-command flakes
                access-tokens = github.com=${ghexpr "secrets.GITHUB_TOKEN"}
              '';
            };
          }
          {
            "uses" = "cachix/cachix-action@v12";
            "with" = {
              name = cachix;
              authToken = ghexpr "secrets.CACHIX_AUTH_TOKEN";
            };
          }
        ];

        buildStep = {
          name = "Build targets";
          run = let
            buildList = if isString build then [ build ] else build;
            installables =
              map (attr: ''"$TARGET_FLAKE#"'' + escapeShellArg attr) buildList;
            args = concatStringsSep " " installables;
          in "GC_DONT_GC=1 nix build --show-trace --log-lines 10000 --fallback ${args}";
          env.TARGET_FLAKE = ghexpr "env.TARGET_FLAKE";
        };

        runStep = {
          name = "Run ${run}";
          run = ''
            GC_DONT_GC=1 nix run --show-trace "$TARGET_FLAKE#$run_flake_attr"'';
          env = {
            run_flake_attr = run;
            TARGET_FLAKE = ghexpr "env.TARGET_FLAKE";
          };
        };

        deployStep = {
          name = "Deploy with ${deploy}";
          run = ''
            GC_DONT_GC=1 nix run --show-trace "$TARGET_FLAKE#$deploy_flake_attr"'';
          "if" = ghexpr
            "github.event_name == 'push' && github.ref == 'refs/heads/main'";
          env = {
            deploy_flake_attr = deploy;
            TARGET_FLAKE = ghexpr "env.TARGET_FLAKE";
          };
        };

        logStep = {
          name = "Log remaining space";
          "if" = ghexpr "always()";
          run = ''
            echo "=== Space left after build ==="
            df -h
          '';
        };
      in flatten [
        (optional prune-runner pruneStep)
        setupSteps
        extraPreBuildSteps
        (optional (build != [ ]) buildStep)
        (optional (run != null) runStep)
        (optional (deploy != null) deployStep)
        logStep
      ];
    };

}
