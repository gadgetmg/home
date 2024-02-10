local kp =
  (import '../lib/kube-prometheus.libsonnet') +
  {
    values+:: {
      common+: {
        clusterIssuer: 'letsencrypt',
      },
      grafana+: {
        hostname: 'grafana.seigra.net',
      },
    },
  };

// Outputs flat array of manifests
std.flatMap(std.objectValues, std.objectValues(kp))
