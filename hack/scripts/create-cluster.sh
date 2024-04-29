#!/bin/sh

talosctl cluster create \
    --name dev \
    --cpus 0 --memory 0 \
    --controlplanes 1 --workers 0 \
    --image ghcr.io/siderolabs/talos:$TALOS_VERSION \
    --kubernetes-version $KUBERNETES_VERSION \
    --config-patch @hack/patches/cilium-cni.yaml \
    --config-patch @hack/patches/kubelet-config.yaml \
    --config-patch-control-plane @hack/patches/pod-security.yaml \
    --config-patch-control-plane @hack/patches/schedule-controlplanes.yaml
