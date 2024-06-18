local kp =
  (import '../lib/kube-prometheus.libsonnet') +
  {
    values+:: {
      common+: {
        clusterIssuer: 'selfsigned',
      },
      grafana+: {
        hostname: 'grafana.dev.local',
        config+: {
          sections+: {
            'auth.generic_oauth'+: {
              auth_url: 'https://auth.dev.local/realms/home/protocol/openid-connect/auth',
              token_url: 'https://auth.dev.local/realms/home/protocol/openid-connect/token',
              api_url: 'https://auth.dev.local/realms/home/protocol/openid-connect/userinfo',
              tls_skip_verify_insecure: true,
            },
            server: {
              root_url: 'https://grafana.dev.local',
            },
          },
        },
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
