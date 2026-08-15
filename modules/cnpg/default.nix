{
  charts,
  pkgs,
  ...
}: {
  applications.cnpg = {
    namespace = "cnpg-system";
    createNamespace = true;
    helm.releases.cnpg = {
      chart = charts.cloudnative-pg;
      values = {
        replicaCount = 1;
      };
    };
    objectTransforms = [
      {
        match.kind = "CustomResourceDefinition";
        rewrite = _: null;
      }
    ];
    yamls = map builtins.readFile [
      (pkgs.fetchurl {
        url = "https://github.com/cloudnative-pg/plugin-barman-cloud/releases/download/v0.13.0/manifest.yaml";
        hash = "sha256-0uceewaCJEjxpCHwV4GEbP25zGIefvMu714gxRMyE7A=";
      })
    ];
  };
}
