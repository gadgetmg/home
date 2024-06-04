#!/bin/sh

yq -PM '.cluster.inlineManifests[0].contents = strenv(MANIFESTS)' << 'EOF' > $1
cluster:
  network:
    cni:
      name: none
  proxy:
    disabled: true
  inlineManifests:
  - name: Cilium
EOF
