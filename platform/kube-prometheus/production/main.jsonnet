local kp =
  (import '../lib/kube-prometheus.libsonnet') +
  {
    values+:: {
      common+: {
        clusterIssuer: 'letsencrypt',
      },
      grafana+: {
        hostname: 'grafana.seigra.net',
        config+: {
          sections+: {
            'auth.generic_oauth'+: {
              auth_url: 'https://auth.seigra.net/realms/home/protocol/openid-connect/auth',
              token_url: 'https://auth.seigra.net/realms/home/protocol/openid-connect/token',
              api_url: 'https://auth.seigra.net/realms/home/protocol/openid-connect/userinfo',
            },
            server: {
              root_url: 'https://grafana.seigra.net',
            },
          },
        },
      },
    },
  };

// Outputs flat array of manifests
std.flatMap(std.objectValues, std.objectValues(kp))
