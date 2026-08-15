{
  description = "Home";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixidy.url = "github:gadgetmg/nixidy";
    talhelper = {
      url = "github:budimanjojo/talhelper";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    krew2nix = {
      url = "github:a1994sc/krew2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      imports = [inputs.flake-parts.flakeModules.modules];
      debug = true;
      flake.nixidyEnvs.x86_64-linux = inputs.nixidy.lib.mkEnvs {
        pkgs = import inputs.nixpkgs {system = "x86_64-linux";};
        modules = [
          ./modules/nixidy.nix
          ./modules/crds.nix
          ./modules/actual
          ./modules/argocd
          ./modules/cdi
          ./modules/cert-manager
          ./modules/cilium
          ./modules/cloudflare-gateway
          ./modules/clusterissuers
        ];
        envs = {
          production.modules = [./envs/production];
          test.modules = [./envs/test];
        };
      };
      perSystem = {
        pkgs,
        system,
        ...
      }: let
        talosctl = pkgs.talosctl.overrideAttrs (finalAttrs: prevAttrs: {
          version = "1.14.0-alpha.2";
          src = pkgs.fetchFromGitHub {
            owner = "siderolabs";
            repo = "talos";
            tag = "v${finalAttrs.version}";
            hash = "sha256-if9XR9d003mr+TIw8s4wPuNMovfzP+4aPh1kXvTBpyQ=";
          };
          vendorHash = "sha256-gi/pr9HaGwdwBeGB9XcetovPdp4FZvJZ5p/C4nnNY+8=";
        });
        talhelper = inputs.talhelper.packages.${system}.default;
        kubectl = inputs.krew2nix.packages.${system}.kubectl;
        nixidy = inputs.nixidy.packages.${system}.default;
      in {
        apps.updateCharts = {
          type = "app";
          program =
            pkgs.lib.getExe (inputs.nixidy.packages.${system}.mkChartsUpdateScript
              (inputs.nixidy.packages.${system}.mkChartAttrs ./charts));
        };
        devShells = let
          kapp = pkgs.kapp.overrideAttrs {
            patches = [
              (pkgs.fetchpatch {
                url = "https://github.com/carvel-dev/kapp/pull/1124.patch";
                hash = "sha256-tm7oxtpenGpRbfkUkic5NqwhORUxGU7/HeRHVMupLww=";
              })
            ];
          };
        in {
          ci = with pkgs;
            mkShell {
              packages = [
                pre-commit
                kustomize
                kubernetes-helm
                kubeconform
                go-task
                kind
                kapp
                nixidy
                (bats.withLibraries (p: [
                  p.bats-detik
                ]))
              ];
            };
          default = with pkgs;
            mkShell {
              packages = [
                age
                argocd
                (bats.withLibraries (p: [
                  p.bats-detik
                ]))
                cilium-cli
                crossplane-cli
                go-task
                hubble
                k9s
                kapp
                kfilt
                kind
                kopia
                kubeconform
                (kubectl.withKrewPlugins (p: [
                  p.cilium
                  p.cnpg
                  p.ctx
                  p.images
                  p.linstor
                  p.ns
                  p.oidc-login
                  p.pv-migrate
                  p.resource-capacity
                  p.sniff
                  p.tree
                  p.view-secret
                  p.kor
                ]))
                kubernetes-helm
                kubeseal
                kubevirt
                kustomize
                nixidy
                pre-commit
                qemu
                renovate
                sops
                ssh-to-age
                talhelper
                talosctl
                vcluster
                velero
                yamlfmt
                yq-go
                (python3.withPackages (p: [
                  p.pyaml
                  p.deepdiff
                ]))
              ];
            };
        };
      };
    };
}
