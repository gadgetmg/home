// Base document from kube-prometheus project
(import 'github.com/prometheus-operator/kube-prometheus/jsonnet/kube-prometheus/main.libsonnet') +
// Add-on to support picking up ServiceMonitor/PodMonitors from all namespaces
(import 'github.com/prometheus-operator/kube-prometheus/jsonnet/kube-prometheus/addons/all-namespaces.libsonnet') +
// Add-on for anti-affinity rules
(import 'github.com/prometheus-operator/kube-prometheus/jsonnet/kube-prometheus/addons/anti-affinity.libsonnet') +
(import 'mixins.libsonnet') +  // Additional monitoring mixins (Prometheus alerts + Grafana dashboards)
(import 'namespace.libsonnet') +  // Patch namespace labels
(import 'gateway.libsonnet') +  // Gateway resource
(import 'grafana-httproute.libsonnet') +  // HTTPRoute resource for Graana
{
  values+:: {
    common+: {
      namespace: 'monitoring',
      platform: 'kubeadm',  // Determines how core k8s resources are scraped
      clusterIssuer: error 'must provide cluster issuer in overlay',
    },
    grafana+: {
      hostname: error 'must provide hostname for grafana in overlay',
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
