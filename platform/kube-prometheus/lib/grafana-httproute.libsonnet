local gateway_api = import 'github.com/jsonnet-libs/gateway-api-libsonnet/1.0/main.libsonnet';
local k = import 'github.com/jsonnet-libs/k8s-libsonnet/1.28/main.libsonnet';

{
  grafana+: {
    local hr = gateway_api.gateway.v1beta1.httpRoute,
    local pr = hr.spec.parentRefs,
    local br = hr.spec.rules.backendRefs,
    local m = hr.spec.rules.matches,
    local svc = self.service,  // Backend service for Grafana
    httpRoute:
      hr.new(self._metadata.name) +  // Name common to grafana resources
      hr.metadata.withNamespace($.values.common.namespace) +
      hr.metadata.withLabels(self._metadata.labels) +  // Labels common to grafana resources
      hr.spec.withHostnames($.values.grafana.hostname) +
      hr.spec.withParentRefs(  // Connects to gateway resource
        pr.withGroup('gateway.networking.k8s.io') +
        pr.withKind($.kubePrometheus.gateway.kind) +
        pr.withName($.kubePrometheus.gateway.metadata.name) +
        pr.withSectionName(self._metadata.name)
      ) +
      hr.spec.withRules(
        hr.spec.rules.withBackendRefs(  // Connect to backend service
          br.withGroup('') +
          br.withKind(svc.kind) +
          br.withName(svc.metadata.name) +
          br.withNamespace(svc.metadata.namespace) +
          br.withPort(svc.spec.ports[0].port) +
          br.withWeight(1)
        ) +
        hr.spec.rules.withMatches(
          m.path.withType('PathPrefix') +
          m.path.withValue('/')
        )
      ),

    local np = k.networking.v1.networkPolicy,
    // Allow all ingress traffic into Grafana
    // FIXME: Constrain to only default + what's necessary for the gateway
    networkPolicy+: np.spec.withIngress({}),
  },
}
