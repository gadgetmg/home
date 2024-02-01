{
  description = "Home";

  inputs = {
    nixpkgs = { url = github:NixOS/nixpkgs/nixos-unstable; };
    talhelper = { url = "github:budimanjojo/talhelper"; };
    krewfile = { url = github:brumhard/krewfile; };
  };

  outputs = { self, nixpkgs, ... }@inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
    krewfile = inputs.krewfile.packages.${system}.default;
    talhelper = inputs.talhelper.packages.${system}.default;
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
        TEST_ASSET_ETCD = "${pkgs.etcd}/bin/etcd";
        TEST_ASSET_KUBE_APISERVER = "${pkgs.kubernetes}/bin/kube-apiserver";
        NIX_CONFIG = "extra-experimental-features = nix-command flakes repl-flake";
        nativeBuildInputs = with pkgs; [
          age
          argocd
          cilium-cli
          kfilt
          kind
          krew
          krewfile
          kubectl
          kubernetes-helm
          kubevirt
          kustomize
          kustomize-sops
          kuttl
          sops
          ssh-to-age
          talhelper
          talosctl
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
