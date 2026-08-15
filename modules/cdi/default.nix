{pkgs, ...}: {
  applications.cdi = {
    yamls = map builtins.readFile [
      (pkgs.fetchurl {
        url = "https://github.com/kubevirt/containerized-data-importer/releases/download/v1.64.0/cdi-operator.yaml";
        hash = "sha256-lUCsr9hez2Uj63fJdZok5tAtdJTiU7qmkwqQ8Lj61jw=";
      })
      (pkgs.fetchurl {
        url = "https://github.com/kubevirt/containerized-data-importer/releases/download/v1.64.0/cdi-cr.yaml";
        hash = "sha256-Mt+aWhGO/UhskYoTl5WiIAo3WeHMVbBTeYZ5cSDnXzI=";
      })
      ./ingress.yaml
    ];
    resources.cdis.cdi.spec.config = {
      podResourceRequirements = {
        limits.memory = "1G";
        requests.memory = "500M";
      };
      scratchSpaceStorageClass = "ssd-r1";
    };
    objectTransforms = [
      {
        match.kind = "CustomResourceDefinition";
        rewrite = _: null;
      }
    ];
  };
}
