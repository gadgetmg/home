local k = import 'github.com/jsonnet-libs/k8s-libsonnet/1.28/main.libsonnet';

{
  kubePrometheus+: {
    local ns = k.core.v1.namespace,
    // Add labels to privilege namespace
    namespace+: ns.metadata.withLabelsMixin({
      'pod-security.kubernetes.io/enforce': 'privileged',
      'pod-security.kubernetes.io/enforce-version': 'latest',
    }),
  },
}
