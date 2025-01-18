#!/bin/sh

cd "$(dirname "$0")/.."

talosctl cluster create \
    --name dev \
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
cilium install \
    --set ipam.mode=kubernetes \
    --set securityContext.capabilities.ciliumAgent="{CHOWN,KILL,NET_ADMIN,NET_RAW,IPC_LOCK,SYS_ADMIN,SYS_RESOURCE,DAC_OVERRIDE,FOWNER,SETGID,SETUID}" \
    --set securityContext.capabilities.cleanCiliumState="{NET_ADMIN,SYS_ADMIN,SYS_RESOURCE}" \
    --set cgroup.autoMount.enabled=false \
    --set cgroup.hostRoot=/sys/fs/cgroup \
    --set k8sServiceHost=localhost \
    --set k8sServicePort=7445
