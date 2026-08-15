_: {
  nixidy.target.rootPath = "manifests/production";
  applications = {
    actual.kustomize.applications.actual.kustomization.path = "environments/production";
    argocd.yamls = map builtins.readFile [
      ./argocd/secrets/argocd-notifications-secret.yaml
      ./argocd/secrets/github-token.yaml
      ./argocd/secrets/home-ssh-creds.yaml
    ];
    backups.yamls = map builtins.readFile [
      ./backups/backupstoragelocation.yaml
      ./backups/volumesnapshotclass.yaml
      ./backups/schedules/actual.yaml
      ./backups/schedules/harbor.yaml
      ./backups/schedules/monitoring.yaml
      ./backups/schedules/paperless-ngx.yaml
    ];
    cloudflare-gateway.yamls = map builtins.readFile [
      ./cloudflare-gateway/gatewayclass.yaml
      ./cloudflare-gateway/secrets.yaml
    ];
    clusterissuers.yamls = map builtins.readFile [
      ./clusterissuers/cluster-ca.yaml
      ./clusterissuers/letsencrypt.yaml
    ];
    external-dns = {
      helm.releases.external-dns.values = {
        provider = {
          name = "webhook";
          webhook = {
            env = [
              {
                name = "PROVIDER_OPENWRT_LUCIRPC_HOSTNAME";
                value = "router.lan.seigra.net";
              }
              {
                name = "PROVIDER_OPENWRT_LUCIRPC_AUTH_USERNAME";
                valueFrom = {
                  secretKeyRef = {
                    key = "username";
                    name = "openwrt-provider-lucirpc-auth";
                  };
                };
              }
              {
                name = "PROVIDER_OPENWRT_LUCIRPC_AUTH_PASSWORD";
                valueFrom = {
                  secretKeyRef = {
                    key = "password";
                    name = "openwrt-provider-lucirpc-auth";
                  };
                };
              }
            ];
            image = {
              repository = "docker.io/renanqts/external-dns-openwrt-webhook";
              tag = "v0.1.0@sha256:a356eb7ead234dc673108c30de761ed9f9542709fc0d8cc8332f81dd53a74d63";
            };
            livenessProbe = {
              httpGet = {
                path = "/ping";
                port = 8888;
              };
              initialDelaySeconds = 10;
              timeoutSeconds = 5;
            };
            readinessProbe = {
              httpGet = {
                path = "/ping";
                port = 8888;
              };
              initialDelaySeconds = 10;
              timeoutSeconds = 5;
            };
            securityContext = {
              allowPrivilegeEscalation = false;
              capabilities.drop = ["ALL"];
              privileged = false;
              readOnlyRootFilesystem = true;
              runAsGroup = 65532;
              runAsNonRoot = true;
              runAsUser = 65532;
            };
          };
        };
      };
      yamls = map builtins.readFile [
        ./external-dns/secret.yaml
      ];
    };
    ezxss.kustomize.applications.ezxss.kustomization.path = "production";
    harbor.kustomize.applications.harbor.kustomization.path = "production";
  };
}
