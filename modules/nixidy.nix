{lib, ...}: {
  nixidy = {
    k8sVersion = "1.36";
    chartsDir = ../charts;
    target = {
      repository = "https://github.com/gadgetmg/home.git";
      branch = "main";
    };
    defaults = {
      helm.transformer = map (lib.kube.removeLabels [
        "app.kubernetes.io/app-version"
        "app.kubernetes.io/managed-by"
        "app.kubernetes.io/version"
        "chart"
        "helm.sh/chart"
        "heritage"
      ]);
    };
  };
}
