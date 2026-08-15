{charts, ...}: {
  applications.cert-manager = {
    namespace = "cert-manager";
    createNamespace = true;
    helm.releases.cert-manager = {
      chart = charts.cert-manager;
      values = {
        config = {
          apiVersion = "controller.config.cert-manager.io/v1alpha1";
          enableGatewayAPI = true;
          kind = "ControllerConfiguration";
        };
        dns01RecursiveNameservers = "1.1.1.1:53,1.0.0.1:53";
        podDisruptionBudget.enabled = true;
        prometheus.servicemonitor.enabled = true;
        replicaCount = 2;
        webhook = {
          podDisruptionBudget.enabled = true;
          replicaCount = 2;
        };
      };
    };
  };
}
