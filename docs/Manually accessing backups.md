# Manually accessing backups

Velero ships the contents of `PersistentVolumeClaim` backups to a Kopia
repository. It is possible to manually connect to this repository with the
following command:

```bash
kopia repository connect s3 --readonly \
  --bucket=velero --prefix=kopia/[namespace]/ \
  --access-key=... --secret-access-key=... \
  --override-username=default --override-hostname=default \
  --password=static-passw0rd \
  --endpoint=truenas.lan.seigra.net:9000 \
```

Then it's possible to list the snapshots in the repository using:

```bash
kopia snapshot list
```

```
default@default:snapshot-data-upload-download/kopia/paperless-ngx/paperless-ngx-data
  ...

default@default:snapshot-data-upload-download/kopia/paperless-ngx/paperless-ngx-media
  ...
```

Finally, to list files inside of snapshots use:

```bash
kopia ls ...
```
