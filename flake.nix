{
  description = "Talos";

  inputs = {
    nixpkgs = { url = github:NixOS/nixpkgs/nixos-unstable; };  # NixOS 23.11
    krewfile = { url = github:brumhard/krewfile/v0.2.0; };
    talhelper = { url = "github:budimanjojo/talhelper"; };
  };

  outputs = { self, nixpkgs, ... }@inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; config.allowUnfree = true; config.allowBroken = true; };
    kubernetes-helm = pkgs.kubernetes-helm.overrideAttrs (prev: {
      ldflags = prev.ldflags ++ [
        "-X helm.sh/helm/v3/pkg/chartutil.k8sVersionMajor=1"
        "-X helm.sh/helm/v3/pkg/chartutil.k8sVersionMinor=29"
      ];
      doCheck = false;
    });
    kustomize-sops = pkgs.kustomize-sops.overrideAttrs ({
      installPhase = ''
        mkdir -p $out/bin
        mv $GOPATH/bin/kustomize-sops $out/bin/ksops
      '';
    });
  in rec {
    # Devshell for bootstrapping
    # Accessible via 'nix develop'
    devShells.${system} = {
      default = pkgs.mkShell {
        NIX_CONFIG = "extra-experimental-features = nix-command flakes repl-flake";
        nativeBuildInputs = with pkgs; [
          talosctl
          kubectl
          clusterctl
          terraform
          kubernetes-helm
          argocd
          cilium-cli
          kubeseal
          krew
          yq-go
          sops
          age
          ssh-to-age
          kind
          kfilt
          kustomize
          kustomize-sops
          inputs.krewfile.packages.${system}.default
          inputs.talhelper.packages.${system}.default
        ];
        shellHook = '' 
          export PATH="$HOME/.krew/bin:$PATH"
          krewfile
        '';
      };
    };
  };
}
