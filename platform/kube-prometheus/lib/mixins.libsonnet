// Import mixin function
local mixin = import 'github.com/prometheus-operator/kube-prometheus/jsonnet/kube-prometheus/lib/mixin.libsonnet';

local etcd = mixin({
  name: 'etcd',
  mixin: (import 'github.com/etcd-io/etcd/contrib/mixin/mixin.libsonnet'),
});

local coredns = mixin({
  name: 'coredns',
  mixin: (import 'github.com/povilasv/coredns-mixin/mixin.libsonnet'),
});

local certmanager = mixin({
  name: 'cert-manager',
  mixin: (import 'github.com/imusmanmalik/cert-manager-mixin/mixin.libsonnet'),
});

local argocd = mixin({
  name: 'argocd',
  mixin: (import 'github.com/grafana/jsonnet-libs/argocd-mixin/mixin.libsonnet'),
});

local cilium = mixin({
  name: 'cilium',
  mixin: (import 'github.com/grafana/jsonnet-libs/cilium-enterprise-mixin/mixin.libsonnet'),
});

{
  values+:: {
    grafana+: {
      dashboards+: etcd.grafanaDashboards +
                   coredns.grafanaDashboards +
                   certmanager.grafanaDashboards +
                   argocd.grafanaDashboards,
    },
  },
  // Creates new top-level keys for mixins to fit structure used by kube-prometheus
  etcd:
    { prometehusRule: etcd.prometheusRules },
  coredns:
    { prometehusRule: coredns.prometheusRules },
  certmanager:
    { prometehusRule: certmanager.prometheusRules },
  argocd:
    { prometehusRule: argocd.prometheusRules },
  cilium:
    { prometehusRule: cilium.prometheusRules },
}
