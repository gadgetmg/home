local k = import 'github.com/jsonnet-libs/k8s-libsonnet/1.28/main.libsonnet';

{
  grafana+: {
    deployment+: {
      spec+: {
        template+: {
          spec+: {
            local c = k.core.v1.container,
            local m = k.core.v1.volumeMount,
            containers: [
              if container.name == 'grafana'
              then container + c.withVolumeMountsMixin(
                m.new('cilium-dashboard', '/grafana-dashboard-definitions/0/cilium-dashboard', false)
              ) + c.withVolumeMountsMixin(
                m.new('cilium-operator-dashboard', '/grafana-dashboard-definitions/0/cilium-operator-dashboard', false)
              )
              else container
              for container in super.containers
            ],

            local v = k.core.v1.volume,
            volumes+: [
              v.withName('cilium-dashboard') +
              v.configMap.withName('cilium-dashboard'),
            ] + [
              v.withName('cilium-operator-dashboard') +
              v.configMap.withName('cilium-operator-dashboard'),
            ],
          },
        },
      },
    },
  },
}
