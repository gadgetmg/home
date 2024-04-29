#!/bin/sh

yq -PM '.cluster.inlineManifests[0].contents = strenv(MANIFESTS)' << 'EOF' > hack/patches/cilium-cni.yaml
cluster:
  network:
    cni:
      name: none
  proxy:
    disabled: true
  inlineManifests:
  - name: Cilium
EOF
