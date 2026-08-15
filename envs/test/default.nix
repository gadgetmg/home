{lib, ...}: {
  nixidy.target.rootPath = "manifests/test";
  applications = {
    actual.kustomize.applications.actual.kustomization.path = "environments/test";
    argocd = let
      ip = "10.5.0.53";
      newHost = "argocd.${ip}.nip.io";
      idpHost = "auth.10.5.0.54.nip.io";
    in {
      yamls = map builtins.readFile [
        ./argocd/dex-bundle.yaml
      ];
      resources = {
        gateways.argocd = {
          metadata.annotations."cert-manager.io/cluster-issuer" = lib.mkForce "cluster-ca";
          spec = {
            infrastructure.annotations."lbipam.cilium.io/ips" = lib.mkForce ip;
            listeners.argocd.hostname = lib.mkForce newHost;
          };
        };
        configMaps.argocd-cm.data = {
          url = lib.mkForce "https://${newHost}";
          "dex.config" = lib.mkForce ''
            connectors:
            - type: oidc
              id: keycloak
              name: seigra.net
              config:
                issuer: https://${idpHost}/realms/home
                clientID: argocd
                clientSecret: $KEYCLOAK_CLIENT_SECRET
                scopes:
                - openid
                - profile
                - email
                getUserInfo: true
                userNameKey: preferred_username
                insecureEnableGroups: true
          '';
        };
        deployments.argocd-dex-server.spec.template.spec = {
          containers.dex-server.volumeMounts = [
            {
              name = "ca-bundle";
              mountPath = "/etc/ssl/certs/ca-certificates.crt";
              subPath = "ca-certificates.crt";
            }
          ];
          volumes.ca-bundle.configMap.name = "argocd-dex-server-cluster-ca";
        };
      };
    };
    cdi = let
      ip = "10.5.0.56";
      newHost = "cdi-uploadproxy.${ip}.nip.io";
    in {
      objectTransforms = [
        {
          match.kind = "Ingress";
          rewrite = ingress:
            ingress
            // {
              spec = {
                tls = [{hosts = [newHost];}];
                rules = map (rule: rule // {host = newHost;}) ingress.spec.rules;
                infrastructure.annotations."lbipam.cilium.io/ips" = ip;
              };
            };
        }
      ];
    };
    clusterissuers.yamls = map builtins.readFile [
      ./clusterissuers/cluster-ca.yaml
    ];
  };
}
