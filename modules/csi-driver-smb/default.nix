{charts, ...}: {
  applications.csi-driver-smb = {
    namespace = "kube-system";
    helm.releases.csi-driver-smb = {
      chart = charts.csi-driver-smb;
    };
  };
}
