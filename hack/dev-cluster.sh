#!/usr/bin/env sh
cd "$(dirname "$0")"

# create kind cluster
kind create cluster --config=kind-config.yaml

# pre-install CRDs
# renovate: datasource=helm depName=cilium registryUrl=https://helm.cilium.io
kubectl apply -f https://github.com/cilium/cilium/raw/v1.15.1/pkg/k8s/apis/cilium.io/client/crds/v2alpha1/ciliumloadbalancerippools.yaml
# renovate: datasource=helm depName=cilium registryUrl=https://helm.cilium.io
kubectl apply -f https://github.com/cilium/cilium/raw/v1.15.1/pkg/k8s/apis/cilium.io/client/crds/v2alpha1/ciliuml2announcementpolicies.yaml
# renovate: datasource=helm depName=cert-manager registryUrl=https://charts.jetstack.io
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.2/cert-manager.crds.yaml
# renovate: datasource=github-releases depName=prometheus-operator/prometheus-operator
kubectl apply -f https://github.com/prometheus-operator/prometheus-operator/releases/download/v0.71.2/stripped-down-crds.yaml
# renovate: datasource=github-releases depName=kubernetes-sigs/gateway-api
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/raw/v1.0.0/config/crd/standard/gateway.networking.k8s.io_gatewayclasses.yaml

# install cilium CNI
kustomize build --enable-helm ../system/cilium/dev | kubectl apply -f -

# install cert-manager
kustomize build --enable-helm ../system/cert-manager/dev | kubectl apply -f -

# install Argo CD
kustomize build ../system/argocd/dev | kubectl apply -f -

# Install root app
jsonnet -J ../vendor ../root/dev/main.jsonnet -y | kubectl apply -f -

# Wait for Argo CD initial password
kubectl config set-context --namespace='argocd' --current
kubectl wait --for=condition=Available deployment.apps/argocd-server --timeout=10m
argocd --core admin initial-password
