// Base document from kube-prometheus project
(import 'github.com/prometheus-operator/kube-prometheus/jsonnet/kube-prometheus/main.libsonnet') +
// Add-on to support picking up ServiceMonitor/PodMonitors from all namespaces
(import 'github.com/prometheus-operator/kube-prometheus/jsonnet/kube-prometheus/addons/all-namespaces.libsonnet') +
// Add-on for anti-affinity rules
(import 'github.com/prometheus-operator/kube-prometheus/jsonnet/kube-prometheus/addons/anti-affinity.libsonnet') +
(import 'mixins.libsonnet') +  // Additional monitoring mixins (Prometheus alerts + Grafana dashboards)
(import 'namespace.libsonnet') +  // Patch namespace labels
(import 'gateway.libsonnet') +  // Gateway resource
(import 'grafana-httproute.libsonnet') +  // HTTPRoute resource for Grafana
(import 'grafana-oidc-secret.libsonnet') +  // Configures OIDC client secret for Grafana
{
  values+:: {
    common+: {
      namespace: 'monitoring',
      platform: 'kubeadm',  // Determines how core k8s resources are scraped
      clusterIssuer: error 'must provide cluster issuer in overlay',
    },
    grafana+: {
      hostname: error 'must provide hostname for grafana in overlay',
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
            auth_url: error 'must provide generic OAuth auth_url for grafana in overlay',
            token_url: error 'must provide generic OAuth token_url for grafana in overlay',
            api_url: error 'must provide generic OAuth api_url for grafana in overlay',
            role_attribute_path: "contains(roles[*], 'admin') && 'Admin' || contains(roles[*], 'editor') && 'Editor' || contains(roles[*], 'viewer') && 'Viewer'",
            role_attribute_strict: true,
            tls_skip_verify_insecure: true,
          },
          server: {
            root_url: error 'must provide server root URL for grafana in overlay',
          },
        },
      },
    },
    // Requires pod anti-affinity by node
    alertmanager+: {
      podAntiAffinity: 'hard',
    },
    prometheus+: {
      podAntiAffinity: 'hard',
    },
    blackboxExporter+: {
      podAntiAffinity: 'hard',
    },
    prometheusAdapter+: {
      podAntiAffinity: 'hard',
    },
  },
}
