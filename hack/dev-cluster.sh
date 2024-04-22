#!/usr/bin/env bash
cd "$(dirname "$0")"

# renovate: datasource=github-releases depName=siderolabs/talos
TALOS_VERSION=v1.6.7
# renovate: datasource=github-releases depName=kubernetes/kubernetes
KUBERNETES_VERSION=v1.29.4

# Bring up Talos cluster
docker compose up --detach
# Generate configuration for Talos
talosctl gen config dev-talos https://10.5.0.2:6443 \
  --talos-version $TALOS_VERSION \
  --kubernetes-version $KUBERNETES_VERSION \
  --config-patch @patches/cilium-cni.yaml \
  --config-patch @patches/crds.yaml \
  --config-patch @patches/local-repo.yaml \
  --config-patch-control-plane @patches/pod-security.yaml \
  --config-patch-control-plane @patches/schedule-controlplanes.yaml \
  --output-types controlplane,talosconfig \
  --output config --force
# Apply and bootstrap the Talos cluster
while ! talosctl apply-config --nodes 10.5.0.2 --file config/controlplane.yaml --insecure &> /dev/null; do sleep 1 && echo -n .; done;
while ! talosctl bootstrap --nodes 10.5.0.2 --endpoints 10.5.0.2 --talosconfig config/talosconfig &> /dev/null; do sleep 1 && echo -n .; done;
while ! talosctl kubeconfig --nodes 10.5.0.2 --endpoints 10.5.0.2 --talosconfig config/talosconfig &> /dev/null; do sleep 1 && echo -n .; done;
while ! kubectl wait --for=condition=Ready=false node/dev-controlplane-1 --timeout=600s &> /dev/null; do sleep 1 && echo -n .; done; echo
# Patch CoreDNS configuration to resolve .dev.local domains with k8s_gateway
kubectl apply -f local-dns.yaml
kubectl rollout restart deployment.apps/coredns -n kube-system

cd ..
# Install Cilium CNI
kubectl create namespace monitoring
kustomize build --enable-helm system/cilium/dev | kfilt -K CiliumLoadBalancerIPPool -K CiliumL2AnnouncementPolicy | kubectl apply -f -
kubectl wait --for=condition=Available deployment.apps/cilium-operator -n kube-system --timeout=10m
kustomize build --enable-helm system/cilium/dev | kfilt -k CiliumLoadBalancerIPPool -k CiliumL2AnnouncementPolicy | kubectl apply -f -
kubectl wait --for=condition=Ready nodes --all --timeout=600s
# Install Argo CD
kubectl apply --server-side -k system/argocd/dev
kubectl config set-context --namespace=argocd --current
kubectl wait --for=condition=Available deployment.apps/argocd-repo-server --timeout=10m
# Install root app
jsonnet -J vendor root/dev/main.jsonnet -y | kubectl apply -f -
# Wait for Argo CD initial password
kubectl wait --for=condition=Available deployment.apps/argocd-server --timeout=10m
argocd --core admin initial-password
