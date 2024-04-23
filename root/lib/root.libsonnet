local argo_cd = import 'github.com/jsonnet-libs/argo-cd-libsonnet/2.9/main.libsonnet';
local app = argo_cd.argoproj.v1alpha1.application;

{
  config:: {
    environment: error 'environment must be defined',
    repoURL: error 'repoURL must be defined',
  },

  defaults::
    app.metadata.withNamespace('argocd') +
    app.metadata.withFinalizers('resources-finalizer.argocd.argoproj.io') +
    app.spec.withProject('default') +
    app.spec.withRevisionHistoryLimit(10) +
    app.spec.destination.withName('in-cluster') +
    app.spec.source.withRepoURL($.config.repoURL) +
    app.spec.source.withTargetRevision('HEAD') +
    app.spec.syncPolicy.automated.withPrune(true) +
    app.spec.syncPolicy.automated.withSelfHeal(true) +
    app.spec.syncPolicy.retry.backoff.withDuration('5s') +
    app.spec.syncPolicy.retry.backoff.withFactor(2) +
    app.spec.syncPolicy.retry.backoff.withMaxDuration('3m') +
    app.spec.syncPolicy.retry.withLimit(5) +
    app.spec.syncPolicy.withSyncOptions('ServerSideApply=true'),

  jsonnet::
    app.spec.source.directory.jsonnet.withLibs('vendor'),

  root:
    app.new('root') + self.defaults + self.jsonnet +
    app.spec.source.withPath('root/' + $.config.environment),
  argocd:
    app.new('argocd') + self.defaults +
    app.spec.source.withPath('system/argocd/' + $.config.environment),
  'cert-manager':
    app.new('cert-manager') + self.defaults +
    app.spec.source.withPath('system/cert-manager/' + $.config.environment),
  cilium:
    app.new('cilium') + self.defaults +
    app.spec.source.withPath('system/cilium/' + $.config.environment),
  'k8s-gateway':
    app.new('k8s-gateway') + self.defaults +
    app.spec.source.withPath('system/k8s-gateway/' + $.config.environment),
  piraeus:
    app.new('piraeus') + self.defaults +
    app.spec.source.withPath('system/piraeus/' + $.config.environment),
  'cloudflare-operator':
    app.new('cloudflare-operator') + self.defaults +
    app.spec.source.withPath('platform/cloudflare-operator/' + $.config.environment),
  cnpg:
    app.new('cnpg') + self.defaults +
    app.spec.source.withPath('platform/cnpg/' + $.config.environment),
  crossplane:
    app.new('crossplane') + self.defaults +
    app.spec.source.withPath('platform/crossplane/' + $.config.environment),
  'external-secrets':
    app.new('external-secrets') + self.defaults +
    app.spec.source.withPath('platform/external-secrets/' + $.config.environment),
  keycloak:
    app.new('keycloak') + self.defaults +
    app.spec.source.withPath('platform/keycloak/' + $.config.environment),
  'kube-prometheus':
    app.new('kube-prometheus') + self.defaults + self.jsonnet +
    app.spec.source.withPath('platform/kube-prometheus/' + $.config.environment),
  kubevirt:
    app.new('kubevirt') + self.defaults +
    app.spec.source.withPath('platform/kubevirt/' + $.config.environment),
  'mariadb-operator':
    app.new('mariadb-operator') + self.defaults +
    app.spec.source.withPath('platform/mariadb-operator/' + $.config.environment),
  ezxss:
    app.new('ezxss') + self.defaults +
    app.spec.source.withPath('apps/ezxss/' + $.config.environment),
}
