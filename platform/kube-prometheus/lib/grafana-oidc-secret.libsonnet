{
  grafana+: {
    deployment+: {
      spec+: {
        template+: {
          spec+: {
            containers: [
              if c.name == 'grafana'
              then c {
                env: [
                  {
                    name: 'GF_AUTH_GENERIC_OAUTH_CLIENT_SECRET',
                    valueFrom: {
                      secretKeyRef: {
                        name: 'grafana-oidc-secret',
                        key: 'attribute.client_secret',
                        optional: true,
                      },
                    },
                  },
                ],
              }
              else c
              for c in super.containers
            ],
          },
        },
      },
    },
  },
}
