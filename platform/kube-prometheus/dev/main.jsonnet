local kp =
  (import '../lib/kube-prometheus.libsonnet') +
  {
    values+:: {
      common+: {
        clusterIssuer: 'selfsigned',
      },
      grafana+: {
        hostname: 'grafana.dev.local',
      },
      prometheus+: {
        replicas: 1,
      },
      alertmanager+: {
        replicas: 1,
      },
      prometheusAdapter+: {
        replicas: 1,
      },
    },
  };

// Outputs flat array of manifests
std.flatMap(std.objectValues, std.objectValues(kp))
