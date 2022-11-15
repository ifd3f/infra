{ lib }:
with lib; rec {
  ghexpr = v: "\${{ ${v} }}";

  makeGithubWorkflow = { nodes, cachix, cronSchedule }: {
    name = "Build and deploy";
    run-name = "Build and deploy (${ghexpr "inputs.sha || github.sha"})";

    on = {
      schedule = [{ cron = cronSchedule; }];
      push = { };
      workflow_dispatch = { };
      workflow_call.inputs.sha = {
        required = true;
        type = "string";
      };
    };

    env.target_flake = let
      repo = ghexpr "github.repository";
      sha = ghexpr "inputs.sha || github.sha";
    in "github:${repo}/${sha}";

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
    if build == [ ] && run == null then
      abort (toString "${key} did not specify a run or a build")
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
            "uses" = "webfactory/ssh-agent@v0.7.0";
            "if" = ghexpr "github.ref == 'refs/heads/main'";
            "with".ssh-private-key = ghexpr "secrets.SSH_PRIVATE_KEY";
          }
          {
            "uses" = "cachix/install-nix-action@v16";
            "with" = {
              nix_path = "nixpkgs=channel:nixos-unstable";
              extra_nix_config = ''
                experimental-features = nix-command flakes
                access-tokens = github.com=${ghexpr "secrets.GITHUB_TOKEN"}
              '';
            };
          }
          {
            "uses" = "cachix/cachix-action@v10";
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
              map (attr: ''"$target_flake#"'' + escapeShellArg attr) buildList;
            args = concatStringsSep " " installables;
          in "GC_DONT_GC=1 nix build --show-trace ${args}";
          env.target_flake = ghexpr "env.target_flake";
        };

        runStep = {
          name = "Run ${run}";
          run =
            ''GC_DONT_GC=1 nix run --show-trace "$target_flake#$flake_attr"'';
          env = {
            flake_attr = run;
            target_flake = ghexpr "env.target_flake";
          };
        };

        deployStep = {
          name = "Deploy with ${deploy}";
          run =
            ''GC_DONT_GC=1 nix run --show-trace "$target_flake#$flake_attr"'';
          "if" = ghexpr "github.ref == 'refs/heads/main'";
          env = {
            flake_attr = deploy;
            target_flake = ghexpr "env.target_flake";
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
        (logStep)
      ];
    };

}
