{ lib }:
with lib;
let
  ghexpr = v: "\${{ ${v} }}";
  jobname = node: "build-${node}";
in { nodes, cachix, cronSchedule }: {
  on = {
    schedule.cron = cronSchedule;
    push = { };
    workflow_dispatch = { };
    workflow_call.inputs.sha = {
      required = true;
      type = "string";
    };
  };

  env.target_flake = let
    owner = ghexpr "github.repository_owner";
    repo = ghexpr "github.repository";
    sha = ghexpr "inputs.sha || github.sha";
  in "github:${owner}/${repo}/${sha}";

  jobs = mapAttrs (key:
    { runsOn ? "ubuntu-latest", needs ? [ ], pruneRunner ? false, build ? [ ]
    , run ? null }: {
      ${jobname key} = if build == [ ] && run == null then
        abort (toString "${key} did not specify a run or a build")
      else {
        name = "Build node ${key}";
        runs-on = runsOn;
        strategy.fail-fast = false;

        needs = let missingDeps = filter (d: !(hasAttr d nodes)) needs;
        in if missingDeps != [ ] then
          abort
          "${key} requests nodes that do not exist: ${toString missingDeps}"
        else
          map jobname needs;

        steps = (optional pruneRunner {
          name = "Remove unneccessary packages";
          run = ''
            echo "=== Before pruning ==="
            df -h
            sudo rm -rf /usr/share /usr/local /opt || true
            echo
            echo "=== After pruning ==="
            df -h
          '';
        }) ++ [
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
        ] ++ (optional (build != [ ]) {
          name = "Build targets";
          run = let
            buildList = if isString build then [ build ] else build;
            installables =
              map (attr: ''"$target_flake#"'' + escapeShellArg attr) buildList;
            args = concatStringsSep " " installables;
          in "GC_DONT_GC=1 nix build --show-trace ${args}";
          env.target_flake = ghexpr "env.target_flake";
        }) ++ (optional (run != null) {
          name = "Run ${run}";
          run =
            ''GC_DONT_GC=1 nix run --show-trace "$target_flake#$flake_attr"'';
          env = {
            flake_attr = run;
            target_flake = ghexpr "env.target_flake";
          };
        });
      };
    }) nodes;
}
