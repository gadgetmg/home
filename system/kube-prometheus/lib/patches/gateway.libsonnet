local gateway_api = import 'github.com/jsonnet-libs/gateway-api-libsonnet/1.0/main.libsonnet';

{
  kubePrometheus+: {
    local gw = gateway_api.gateway.v1beta1.gateway,
    local l = gw.spec.listeners,
    gateway:
      gw.new('kube-prometheus') +
      gw.metadata.withNamespace($.values.common.namespace) +
      gw.metadata.withAnnotations({
        'cert-manager.io/cluster-issuer': $.values.common.clusterIssuer,
        'argocd.argoproj.io/sync-wave': '1',
      }) +
      gw.spec.withGatewayClassName('envoy-gateway') +
      gw.spec.withListeners(
        [
          l.withName($.grafana._metadata.name) +
          l.withHostname($.values.grafana.hostname) +
          // Allow routes only from this namespace
          l.allowedRoutes.namespaces.withFrom('Same') +
          l.withProtocol('HTTPS') +
          l.withPort(443) +
          l.tls.withCertificateRefs([
            // Secret will be created by cert-manager
            l.tls.certificateRefs.withGroup('') +
            l.tls.certificateRefs.withKind('Secret') +
            l.tls.certificateRefs.withName(
              $.grafana._metadata.name + '-gateway-tls'
            ),
          ]) +
          l.tls.withMode('Terminate'),
        ]
      ),
  },
}
