{
  lib,
  generators,
  pkgs,
  ...
}: {
  nixidy.applicationImports = [
    (generators.fromCRDModule {
      name = "crossplane";
      src = pkgs.fetchFromGitHub {
        owner = "crossplane-contrib";
        repo = "provider-keycloak";
        rev = "v2.24.0";
        hash = "sha256-mw3GcCd1pbRG2Lboi2GsAQs7TiOF1aT1BOqXzXI6DE0=";
      };
      namePrefix = "keycloak";
      crdFiles = [
        "package/crds/authenticationflow.keycloak.m.crossplane.io_bindings.yaml"
        "package/crds/authenticationflow.keycloak.m.crossplane.io_executions.yaml"
        "package/crds/authenticationflow.keycloak.m.crossplane.io_flows.yaml"
        "package/crds/authenticationflow.keycloak.m.crossplane.io_subflows.yaml"
        "package/crds/openidclient.keycloak.m.crossplane.io_clients.yaml"
        "package/crds/group.keycloak.m.crossplane.io_groups.yaml"
        "package/crds/group.keycloak.m.crossplane.io_memberships.yaml"
        "package/crds/client.keycloak.m.crossplane.io_protocolmappers.yaml"
        "package/crds/realm.keycloak.m.crossplane.io_realms.yaml"
        "package/crds/group.keycloak.m.crossplane.io_roles.yaml"
        "package/crds/role.keycloak.m.crossplane.io_roles.yaml"
        "package/crds/user.keycloak.m.crossplane.io_users.yaml"
      ];
    })
  ];
  applications.crossplane-keycloak = {
    yamls = map builtins.readFile [
      ./mrap.yaml
      ./deploymentruntimeconfig.yaml
      ./provider.yaml
    ];
    resources.providers.provider-keycloak.spec.package = lib.mkForce "ghcr.io/crossplane-contrib/provider-keycloak:v2.24.0@sha256:d8ac64a848745724dc200b749949c750472fcccf1a65b07348f60285a498e19e";
  };
}
