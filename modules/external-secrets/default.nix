{charts, ...}: {
  applications.external-secrets = {
    namespace = "external-secrets";
    createNamespace = true;
    helm.releases.external-secrets = {
      chart = charts.external-secrets;
      values = {
        serviceMonitor = {
          enabled = true;
          renderMode = "alwaysRender";
        };
        webhook.certManager = {
          cert = {
            issuerRef = {
              kind = "ClusterIssuer";
              name = "cluster-ca";
            };
          };
          enabled = true;
        };
      };
    };
    objectTransforms = [
      {
        match.kind = "CustomResourceDefinition";
        rewrite = _: null;
      }
    ];
  };
}
