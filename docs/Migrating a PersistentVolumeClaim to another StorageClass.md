# Migrating a `PersistentVolumeClaim` to another `StorageClass`

Kubernetes does not have a native way to change the backing storage class of a
`PersistentVolumeClaim`. Instead, the pod mounting the volume must be taken
offline and the data must be moved out-of-band, like with a backup tool. With
support from the CSI provider and a backup system like Velero, the process can
be reasonably automated.

## Prerequisites

To use Velero to migrate PVCs, some existing infrastructure must be in place.

- Velero must be installed and configured to snapshot data inside PVs during
  backups by integrating it with a CSI plugin. Ref:
  <https://linbit.com/blog/using-velero-linbit-sds-to-back-up-restore-a-kubernetes-deployment/>
- The PVC to be moved must be covered by a `Backup` object, preferably as part
  of a `Schedule`

## Process

1. Scale down the `Deployment` or similar resource that references the
   `PersistentVolumeClaim` to be moved:

   ```bash
   kubectl scale deployment/paperless-ngx --replicas=0
   ```

1. Initiate a one-off backup that will cover the `PersistentVolumeClaim`:

   ```bash
   velero backup create --from-schedule paperless-ngx-daily
   ```

1. Disable auto sync on the appliation in Argo CD.

1. Once successful, delete the `PersistentVolumeClaim`:

   ```bash
   kubectl delete pvc/paperless-ngx-data
   kubectl delete pvc/paperless-ngx-media
   ```

1. Create a `ConfigMap` in the `velero` namespace with a map of the
   `StorageClass` to migrate:

   ```yaml
   apiVersion: v1
   kind: ConfigMap
   metadata:
     name: storage-class-migration
     namespace: velero
     labels:
       velero.io/change-storage-class: RestoreItemAction
       velero.io/plugin-config: ""
   data:
     hdd-r2: ssd-r2
   ```

1. Initiate a restore:

   ```bash
   velero restore create --from-backup paperless-ngx-daily-2026070323011
   ```

1. Scale up the `Deployment` to get the `PersistentVolumeClaim` resources to
   provision:

   ```bash
   kubectl scale deployment/paperless-ngx --replicas=1
   ```
