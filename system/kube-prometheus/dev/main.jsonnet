local kp =
  (import '../lib/main.libsonnet') +
  {
    values+:: {
      common+: {
        clusterIssuer: 'cluster-ca',
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
        retention: '1h',
        storage: {
          size: '1Gi',
          storageClassName: 'local-path',
        },
      },
    },
  };

// Outputs flat array of manifests
std.flatMap(std.objectValues, std.objectValues(kp))
