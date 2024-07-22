{
  prometheus+: {
    prometheus+: {
      spec+: {
        retention: $.values.prometheus.retention,
        storage: {
          volumeClaimTemplate: {
            apiVersion: 'v1',
            kind: 'PersistentVolumeClaim',
            spec: {
              accessModes: ['ReadWriteOnce'],
              resources: { requests: { storage: $.values.prometheus.storage.size } },
              storageClassName: $.values.prometheus.storage.storageClassName,
            },
          },
        },
      },
    },
  },
}
