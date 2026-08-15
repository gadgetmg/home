{pkgs, ...}: {
  applications.csi-snapshotter = {
    namespace = "kube-system";
    kustomize.applications.csi-snapshotter.kustomization = {
      src = pkgs.fetchFromGitHub {
        owner = "kubernetes-csi";
        repo = "external-snapshotter";
        rev = "v8.6.0";
        hash = "sha256-9WSflI44XhecRqBWGKDfeMMHqOBwyInX9w2qMLDPylA=";
      };
      path = "deploy/kubernetes/snapshot-controller";
    };
  };
}
