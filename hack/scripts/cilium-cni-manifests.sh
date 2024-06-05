#!/bin/sh

kustomize build \
    --enable-helm system/cilium/$1 | \
kfilt \
    -N \*gateway.networking.k8s.io \
    -N hubble\* \
    -x group=cilium.io \
    -x group=monitoring.coreos.com \
    -K GatewayClass \
    -L grafana_dashboard
