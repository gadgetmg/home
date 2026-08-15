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
  };
}
