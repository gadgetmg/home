// Import mixin function
local mixin = import 'github.com/prometheus-operator/kube-prometheus/jsonnet/kube-prometheus/lib/mixin.libsonnet';

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
  mixin: (import 'github.com/grafana/jsonnet-libs/cilium-enterprise-mixin/mixin.libsonnet') {
    local grafanaDashboards = super.grafanaDashboards,
    grafanaDashboards: {
      [std.asciiLower(filename)]: grafanaDashboards[filename]
      for filename in std.objectFields(grafanaDashboards)
    },
  },
});

local externalsecrets = mixin({
  name: 'external-secrets',
  mixin: {
    grafanaDashboards: {
      'external-secrets.json': (import 'github.com/external-secrets/external-secrets/docs/snippets/dashboard.json'),
    },
  },
});

{
  values+:: {
    grafana+: {
      dashboards+: coredns.grafanaDashboards +
                   certmanager.grafanaDashboards +
                   argocd.grafanaDashboards +
                   cilium.grafanaDashboards +
                   externalsecrets.grafanaDashboards,
    },
  },
  // Creates new top-level keys for mixins to fit structure used by kube-prometheus
  coredns:
    { prometehusRule: coredns.prometheusRules },
  certmanager:
    { prometehusRule: certmanager.prometheusRules },
  argocd:
    { prometehusRule: argocd.prometheusRules },
  cilium:
    { prometehusRule: cilium.prometheusRules },
}
