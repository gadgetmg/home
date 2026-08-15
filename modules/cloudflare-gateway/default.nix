{
  pkgs,
  lib,
  ...
}: {
  applications.cloudflare-gateway = {
    namespace = "cloudflare-gateway";
    kustomize.applications = let
      src = pkgs.fetchFromGitHub {
        owner = "pl4nty";
        repo = "cloudflare-kubernetes-gateway";
        rev = "v0.10.1";
        hash = "sha256-zb6peTL5tsED+luo8wKwrRRafADPliJ4RC3xlGNFuFg=";
      };
    in {
      default = {
        kustomization = {
          inherit src;
          path = "config/default";
        };
      };
      prometheus = {
        kustomization = {
          inherit src;
          path = "config/prometheus";
        };
      };
    };
    resources = {
      namespaces.cloudflare-gateway.metadata.labels."pod-security.kubernetes.io/enforce" = "baseline";
      # renovate: datasource=docker depName=cloudflare/cloudflared
      deployments.cloudflare-controller-manager.spec.template.spec.containers.manager.env.GATEWAY_IMAGE.value = lib.mkForce "docker.io/cloudflare/cloudflared:2025.11.1@sha256:89ee50efb1e9cb2ae30281a8a404fed95eb8f02f0a972617526f8c5b417acae2";
    };
  };
}
