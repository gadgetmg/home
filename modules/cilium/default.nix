{charts, ...}: {
  applications.cilium = {
    namespace = "kube-system";
    helm.releases.cilium = {
      chart = charts.cilium;
      extraOpts = [
        "--api-versions=monitoring.coreos.com/v1,gateway.networking.k8s.io/v1/GatewayClass"
      ];
      values = {
        autoDirectNodeRoutes = true;
        bgpControlPlane.enabled = true;
        bpf = {
          datapathMode = "netkit-l2";
          distributedLRU.enabled = true;
          mapDynamicSizeRatio = 0.08;
          masquerade = true;
        };
        cgroup = {
          autoMount.enabled = false;
          hostRoot = "/sys/fs/cgroup";
        };
        cni.exclusive = false;
        devices = "br-cluster";
        enableIPv4BIGTCP = true;
        envoy = {
          prometheus = {
            enabled = true;
            serviceMonitor.enabled = true;
          };
          rollOutPods = true;
        };
        gatewayAPI = {
          enableAlpn = true;
          enabled = true;
        };
        hubble = {
          enabled = true;
          metrics = {
            enabled = [
              "dns"
              "drop"
              "tcp"
              "flow"
              "port-distribution"
              "icmp"
              "httpV2:labelsContext=source_ip,source_namespace,source_workload,destination_ip,destination_namespace,destination_workload,traffic_direction"
            ];
            serviceMonitor.enabled = true;
          };
          relay = {
            enabled = true;
            prometheus = {
              enabled = true;
              serviceMonitor.enabled = true;
            };
            rollOutPods = true;
          };
          tls = {
            auto.method = "cronJob";
          };
          ui = {
            enabled = true;
            rollOutPods = true;
          };
        };
        ingressController = {
          default = true;
          enabled = true;
        };
        ipam.mode = "kubernetes";
        ipv4NativeRoutingCIDR = "0.0.0.0/0";
        k8sServiceHost = "localhost";
        k8sServicePort = 7445;
        kubeProxyReplacement = true;
        l2announcements.enabled = true;
        operator = {
          prometheus = {
            enabled = true;
            serviceMonitor.enabled = true;
          };
          rollOutPods = true;
        };
        prometheus = {
          enabled = true;
          serviceMonitor.enabled = true;
        };
        rollOutCiliumPods = true;
        routingMode = "native";
        securityContext = {
          capabilities = {
            ciliumAgent = [
              "CHOWN"
              "KILL"
              "NET_ADMIN"
              "NET_RAW"
              "IPC_LOCK"
              "SYS_ADMIN"
              "SYS_RESOURCE"
              "DAC_OVERRIDE"
              "FOWNER"
              "SETGID"
              "SETUID"
            ];
            cleanCiliumState = [
              "NET_ADMIN"
              "SYS_ADMIN"
              "SYS_RESOURCE"
            ];
          };
        };
      };
    };
  };
}
