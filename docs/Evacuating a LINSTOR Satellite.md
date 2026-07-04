# Evacuating a LINSTOR Satellite

There is no automated trigger to evacuate a LINSTOR satellite when a node is to
be removed from the cluster. Therefore, custom logic is configured on the
`linstorcluster` `LinstorCluster` resource to provision satellites on nodes
without the label `linstor.seigra.net/evacuate`. This allows an administrator to
manually label a node when the node needs evacuated.

## Labeling a node for evacuation

Label the node with `linstor.seigra.net/evacuate`:

```bash
kubectl label node/production-controlplane-1 linstor.seigra.net/evacuate=true
```
