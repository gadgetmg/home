#!/bin/sh

cd "$(dirname "$0")/.."

talosctl cluster create \
    --cpus 0 --memory 0 \
    --controlplanes 1 --workers 0 \
    --image ghcr.io/siderolabs/talos:$TALOS_VERSION \
    --kubernetes-version $KUBERNETES_VERSION \
    --config-patch @clusterconfig/patches/no-cni.yaml \
    --config-patch @clusterconfig/patches/kubelet-config.yaml \
    --config-patch-control-plane @clusterconfig/patches/pod-security.yaml \
    --config-patch-control-plane @clusterconfig/patches/schedule-controlplanes.yaml \
    --skip-k8s-node-readiness-check
talosctl -n 10.5.0.2 kubeconfig
