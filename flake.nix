{
  description = "Home";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    talhelper.url = "github:budimanjojo/talhelper";
    krewfile.url = "github:brumhard/krewfile";
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
                ];
              };
            default =
              with pkgs;
              mkShell {
                packages = [
                  age
                  argocd
                  cilium-cli
                  crossplane-cli
                  go
                  go-jsonnet
                  go-task
                  hubble
                  jsonnet-bundler
                  k9s
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
