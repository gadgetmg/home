{
  grafana+: {
    clusterPolicy: {
      apiVersion: 'kyverno.io/v1',
      kind: 'ClusterPolicy',
      metadata: {
        name: 'keycloak-grafana-secret-sync',
        annotations: {
          'argocd.argoproj.io/sync-options': 'Replace=true',
        },
      },
      spec: {
        generateExisting: true,
        rules: [
          {
            name: 'sync-secret',
            match: {
              resources: {
                kinds: [
                  'Client',
                ],
                names: [
                  'grafana',
                ],
              },
            },
            context: [
              {
                name: 'secret_name',
                variable: {
                  jmesPath: 'request.object.spec.publishConnectionDetailsTo.name',
                },
              },
              {
                name: 'client_secret',
                apiCall: {
                  method: 'GET',
                  urlPath: '/api/v1/namespaces/crossplane-system/secrets/{{secret_name}}',
                  jmesPath: 'data."attribute.client_secret" | base64_decode(@)',
                },
              },
            ],
            generate: {
              apiVersion: 'v1',
              kind: 'Secret',
              name: 'grafana-oidc-secret',
              namespace: 'monitoring',
              synchronize: true,
              data: {
                type: 'Opaque',
                data: {
                  client_secret: '{{ client_secret | base64_encode(@) }}',
                },
              },
            },
          },
        ],
      },
    },
    client: {
      apiVersion: 'openidclient.keycloak.crossplane.io/v1alpha1',
      kind: 'Client',
      metadata: {
        name: 'grafana',
      },
      spec: {
        deletionPolicy: 'Delete',
        forProvider: {
          accessType: 'CONFIDENTIAL',
          clientId: 'grafana',
          realmIdRef: {
            name: 'home',
          },
          standardFlowEnabled: true,
          rootUrl: 'https://' + $.values.grafana.hostname,
          validRedirectUris: [
            self.rootUrl + '/login/generic_oauth',
          ],
        },
        publishConnectionDetailsTo: {
          name: 'grafana-oidc-secret',
        },
      },
    },
    protocolMapper: {
      apiVersion: 'client.keycloak.crossplane.io/v1alpha1',
      kind: 'ProtocolMapper',
      metadata: {
        name: 'grafana-roles',
      },
      spec: {
        forProvider: {
          config: {
            'usermodel.clientRoleMapping.clientId': 'grafana',
            multivalued: 'true',
            'claim.name': 'roles',
            'id.token.claim': 'true',
            'access.token.claim': 'false',
            'userinfo.token.claim': 'false',
            'introspection.token.claim': 'false',
          },
          realmIdRef: {
            name: 'home',
          },
          clientIdRef: {
            name: 'grafana',
          },
          name: 'client roles',
          protocol: 'openid-connect',
          protocolMapper: 'oidc-usermodel-client-role-mapper',
        },
      },
    },
    roleAdmin: {
      apiVersion: 'role.keycloak.crossplane.io/v1alpha1',
      kind: 'Role',
      metadata: {
        name: 'grafana-admin',
        labels: {
          'seigra.net/roles': 'admin',
        },
      },
      spec: {
        forProvider: {
          description: 'Has access to all organization resources, including dashboards, users, and teams.',
          name: 'admin',
          realmIdRef: {
            name: 'home',
          },
          clientIdRef: {
            name: 'grafana',
          },
        },
      },
    },
    roleEditor: {
      apiVersion: 'role.keycloak.crossplane.io/v1alpha1',
      kind: 'Role',
      metadata: {
        name: 'grafana-editor',
        labels: {
          'seigra.net/roles': 'editor',
        },
      },
      spec: {
        forProvider: {
          description: 'Can view and edit dashboards, folders, and playlists.',
          name: 'editor',
          realmIdRef: {
            name: 'home',
          },
          clientIdRef: {
            name: 'grafana',
          },
        },
      },
    },
    roleViewer: {
      apiVersion: 'role.keycloak.crossplane.io/v1alpha1',
      kind: 'Role',
      metadata: {
        name: 'grafana-viewer',
        labels: {
          'seigra.net/roles': 'readonly',
        },
      },
      spec: {
        forProvider: {
          description: 'Can view dashboards, playlists, and query data sources.',
          name: 'viewer',
          realmIdRef: {
            name: 'home',
          },
          clientIdRef: {
            name: 'grafana',
          },
        },
      },
    },
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
                        key: 'client_secret',
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
