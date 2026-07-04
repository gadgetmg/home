# Evacuating a LINSTOR Satellite

There is no automated trigger to evacuate a LINSTOR satellite when a node is to
be removed from the cluster. Therefore, custom logic is configured on the
`linstorcluster` `LinstorCluster` resource to provision satellites on nodes
without the label `linstor.seigra.net/evacuate`. This allows an administrator to
manually label a node when the node needs evacuated.

## Prepring a node for evacuation

1. Cordon and drain the node:

   ```bash
   kubectl cordon production-controlplane-1
   kubectl drain --delete-emptydir-data=true --ignore-daemonsets=true production-controlplane-1
   ```

1. Label the node with `linstor.seigra.net/evacuate`:

   ```bash
   kubectl label node/production-controlplane-1 linstor.seigra.net/evacuate=true
   ```
