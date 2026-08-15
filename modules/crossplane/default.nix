{
  charts,
  generators,
  pkgs,
  ...
}: {
  nixidy.applicationImports = [
    (generators.fromCRDModule {
      name = "crossplane";
      src = pkgs.fetchFromGitHub {
        owner = "crossplane";
        repo = "crossplane";
        rev = "v2.3.4";
        hash = "sha256-/wmFQPB+59+gduqwzK1UTDGZOaL9ovsR8/zow6ANwjo=";
      };
      crdFiles = [
        "cluster/crds/apiextensions.crossplane.io_compositeresourcedefinitions.yaml"
        "cluster/crds/apiextensions.crossplane.io_compositionrevisions.yaml"
        "cluster/crds/apiextensions.crossplane.io_compositions.yaml"
        "cluster/crds/apiextensions.crossplane.io_environmentconfigs.yaml"
        "cluster/crds/apiextensions.crossplane.io_managedresourceactivationpolicies.yaml"
        "cluster/crds/apiextensions.crossplane.io_managedresourcedefinitions.yaml"
        "cluster/crds/apiextensions.crossplane.io_usages.yaml"
        "cluster/crds/ops.crossplane.io_cronoperations.yaml"
        "cluster/crds/ops.crossplane.io_operations.yaml"
        "cluster/crds/ops.crossplane.io_watchoperations.yaml"
        "cluster/crds/pkg.crossplane.io_configurationrevisions.yaml"
        "cluster/crds/pkg.crossplane.io_configurations.yaml"
        "cluster/crds/pkg.crossplane.io_deploymentruntimeconfigs.yaml"
        "cluster/crds/pkg.crossplane.io_functionrevisions.yaml"
        "cluster/crds/pkg.crossplane.io_functions.yaml"
        "cluster/crds/pkg.crossplane.io_imageconfigs.yaml"
        "cluster/crds/pkg.crossplane.io_locks.yaml"
        "cluster/crds/pkg.crossplane.io_providerrevisions.yaml"
        "cluster/crds/pkg.crossplane.io_providers.yaml"
        "cluster/crds/protection.crossplane.io_clusterusages.yaml"
        "cluster/crds/protection.crossplane.io_usages.yaml"
      ];
    })
  ];
  applications.crossplane = {
    namespace = "crossplane-system";
    createNamespace = true;
    helm.releases.crossplane = {
      chart = charts.crossplane;
      values = {
        image.repository = "ghcr.io/crossplane/crossplane";
        metrics.enabled = true;
        podSecurityContextCrossplane = {
          runAsNonRoot = true;
          seccompProfile.type = "RuntimeDefault";
        };
        podSecurityContextRBACManager = {
          runAsNonRoot = true;
          seccompProfile.type = "RuntimeDefault";
        };
        provider.defaultActivations = [];
        securityContextCrossplane.capabilities.drop = ["ALL"];
        securityContextRBACManager.capabilities.drop = ["ALL"];
      };
    };
  };
}
