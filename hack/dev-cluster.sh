#!/bin/sh
cd "$(dirname "$0")"

# create kind cluster
kind create cluster --config=kind-config.yaml

# install cilium CNI less custom resources (cilium-operator is responsible for installing CRDs)
kustomize build --enable-alpha-plugins --enable-exec --enable-helm --load-restrictor LoadRestrictionsNone ../system/cilium/dev | kfilt -x kind=CiliumLoadBalancerIPPool -x kind=CiliumL2AnnouncementPolicy -x kind=GatewayClass | kubectl apply -f -

# bootstrap Argo CD CRDs
kustomize build --enable-alpha-plugins --enable-exec --enable-helm --load-restrictor LoadRestrictionsNone ../system/argocd/dev | kfilt -i kind=CustomResourceDefinition | kubectl apply -f -

# bootstrap Argo CD
kustomize build --enable-alpha-plugins --enable-exec --enable-helm --load-restrictor LoadRestrictionsNone ../system/argocd/dev | kfilt -x kind=CustomResourceDefinition | kubectl apply -f -
