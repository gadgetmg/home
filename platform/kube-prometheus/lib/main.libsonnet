// Base document from kube-prometheus project
(import 'github.com/prometheus-operator/kube-prometheus/jsonnet/kube-prometheus/main.libsonnet') +
// Add-on to support picking up ServiceMonitor/PodMonitors from all namespaces
(import 'github.com/prometheus-operator/kube-prometheus/jsonnet/kube-prometheus/addons/all-namespaces.libsonnet') +
// Add-on for anti-affinity rules
(import 'github.com/prometheus-operator/kube-prometheus/jsonnet/kube-prometheus/addons/anti-affinity.libsonnet') +
// Additional monitoring mixins (Prometheus alerts + Grafana dashboards)
(import 'patches/mixins.libsonnet') +
// Patch namespace labels
(import 'patches/namespace.libsonnet') +
// Gateway resource
(import 'patches/gateway.libsonnet') +
// HTTPRoute resource for Grafana
(import 'patches/grafana-httproute.libsonnet') +
// Configures OIDC client secret for Grafana
(import 'patches/grafana-oidc-secret.libsonnet') +
// Persists Prometheus metrics
(import 'patches/prometheus-pvc.libsonnet') +
{
  values+:: {
    common+: {
      namespace: 'monitoring',
      platform: 'kubeadm',  // Determines how core k8s resources are scraped
      clusterIssuer: 'letsencrypt',
    },
    grafana+: {
      hostname: 'grafana.seigra.net',
      config+: {
        sections+: {
          auth: {
            disable_login_form: true,
          },
          'auth.generic_oauth': {
            enabled: true,
            auto_login: true,
            name: 'seigra.net',
            allow_sign_up: true,
            client_id: 'grafana',
            scopes: 'openid email profile offline_access roles',
            email_attribute_path: 'email',
            login_attribute_path: 'username',
            name_attribute_path: 'full_name',
            auth_url: 'https://auth.seigra.net/realms/home/protocol/openid-connect/auth',
            token_url: 'https://auth.seigra.net/realms/home/protocol/openid-connect/token',
            api_url: 'https://auth.seigra.net/realms/home/protocol/openid-connect/userinfo',
            role_attribute_path: "contains(roles[*], 'admin') && 'Admin' || contains(roles[*], 'editor') && 'Editor' || contains(roles[*], 'viewer') && 'Viewer'",
            role_attribute_strict: true,
            tls_skip_verify_insecure: true,
          },
          server: {
            root_url: 'https://grafana.seigra.net',
          },
        },
      },
    },
    alertmanager+: {
      name: 'main',
      replicas: 1,
    },
    prometheus+: {
      name: 'main',
      replicas: 1,
      retention: '30d',
      storage: {
        size: '100Gi',
        storageClassName: 'ssd-r3',
      },
    },
  },
}
