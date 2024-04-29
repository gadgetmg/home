{
  description = "Home";

  inputs = {
    nixpkgs = { url = github:NixOS/nixpkgs/nixos-unstable; };
    talhelper = { url = "github:budimanjojo/talhelper"; };
    krewfile = { url = github:brumhard/krewfile; };
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      krewfile = inputs.krewfile.packages.${system}.default;
      talhelper = inputs.talhelper.packages.${system}.default;
    in
    rec {
      # Accessible via 'nix develop' or 'nix shell'
      packages.${system} = {
        default = pkgs.mkShell {
          buildInputs = with pkgs; [
            age
            argocd
            cilium-cli
            crossplane-cli
            go
            go-jsonnet
            go-task
            jsonnet-bundler
            kfilt
            kind
            krew
            krewfile
            kubectl
            kubernetes-helm
            kubevirt
            kustomize
            kustomize-sops
            kyverno-chainsaw
            sops
            ssh-to-age
            # talhelper
            talosctl
            yamlfmt
            yq-go
          ];
          shellHook = '' 
            export PATH="$HOME/.krew/bin:$PATH"
            krewfile
          '';
        };
      };
    };
}
