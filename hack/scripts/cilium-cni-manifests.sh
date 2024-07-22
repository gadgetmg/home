#!/bin/sh

kustomize build \
    --enable-helm system/cilium/$1 | \
kfilt \
    -N \*gateway.networking.k8s.io \
    -N hubble\* \
    -N cilium-envoy\* \
    -x group=cilium.io \
    -x group=monitoring.coreos.com \
    -K GatewayClass \
    -L grafana_dashboard | \
yq | yamlfmt -in
