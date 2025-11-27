{
  description = "Home";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    talhelper = {
      url = "github:budimanjojo/talhelper";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    krewfile = {
      url = "github:brumhard/krewfile";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      perSystem =
        {
          config,
          self',
          inputs',
          pkgs,
          system,
          ...
        }:
        let
          krewfile = inputs.krewfile.packages.${system}.default;
          talhelper = inputs.talhelper.packages.${system}.default;
        in
        {
          devShells = {
            ci =
              with pkgs;
              mkShell {
                packages = [
                  pre-commit
                  kustomize
                  kubernetes-helm
                  kubeconform
                  go-task
                  kind
                  kapp
                  (bats.withLibraries (p: [
                    p.bats-detik
                  ]))
                ];
              };
            default =
              with pkgs;
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
                  krew
                  krewfile
                  kubeconform
                  kubectl
                  kubernetes-helm
                  kubeseal
                  kubevirt
                  kustomize
                  kyverno-chainsaw
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
                  (python3.withPackages (
                    python-pkgs: with python-pkgs; [
                      pyaml
                      deepdiff
                    ]
                  ))
                ];
                shellHook = ''
                  export PATH="$HOME/.krew/bin:$PATH"
                  krewfile
                '';
              };
          };
        };
    };
}
