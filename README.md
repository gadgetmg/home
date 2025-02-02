# My Kubernetes Homelab

This is the source repository for my homelab
[Kubernetes](https://kubernetes.io/) infrastructure built from repurposed HP
ProDesk 600 G3 Desktop Mini PCs. The cluster runs
[Talos Linux](https://www.talos.dev/), a minimal and immutable operating system
designed exclusively for Kubernetes. The purpose of this project is to both gain
useful experience with Kubernetes, but also to build a platform for providing
legitimate production-quality applications and services in my home.

## Stacks

The project is organized into different "stacks" of components based on their
function in the cluster.

### Infrastructure stack

System stack components are fundamental to the cluster delivering core
functionality including networking and persistent storage to applications.

- [`infrastructure/crds`](infrastructure/crds) - Various CRDs used by
  controllers in the cluster
- [`infrastructure/controllers/argocd`](infrastructure/controllers/argocd) -
  Continuous delivery of this repository using
  [Argo CD](https://argo-cd.readthedocs.io/en/stable/)
- [`infrastructure/controllers/cert-manager`](infrastructure/controllers/cert-manager) -
  Manages PKI certificate issuance in the cluster with the
  [cert-manager](https://cert-manager.io/) controller
- [`infrastructure/controllers/cilium`](infrastructure/controllers/cilium) -
  [Cilium](https://cilium.io/) Container Network Interface (CNI) plugin handling
  all networking including access from outside the cluster using BGP.
- [`infrastructure/controllers/cloudflare-gateway`](infrastructure/controllers/cloudflare-gateway) -
  [Cloudflare Gateway](https://github.com/pl4nty/cloudflare-kubernetes-gateway/tree/main)
  for Cloudflare tunnels via
  [cloudflared](https://github.com/cloudflare/cloudflared) and the Gateway API.
- [`infrastructure/controllers/cnpg`](infrastructure/controllers/cnpg) -
  [CloudNativePG](https://cloudnative-pg.io/) operator for PostgreSQL databases
- [`infrastructure/controllers/crossplane`](infrastructure/controllers/crossplane) -
  [Crossplane](https://www.crossplane.io/) control plane for managing
  non-Kubernetes resources
- [`infrastructure/controllers/csi-snapshotter`](infrastructure/controllers/csi-snapshotter) -
  [CSI Snapshotter](https://github.com/kubernetes-csi/external-snapshotter)
  component to implement volume snapshots.
- [`infrastructure/controllers/envoy-gateway`](infrastructure/controllers/envoy-gateway) -
  [Envoy Gateway](https://gateway.envoyproxy.io/) for handling ingress
  connections into the cluster via the Gateway API.
- [`infrastructure/controllers/external-secrets`](infrastructure/controllers/external-secrets) -
  [External Secrets Operator](https://external-secrets.io/) for secrets
  management
- [`infrastructure/controllers/kubevirt-operator`](infrastructure/controllers/kubevirt-operator) -
  Virtualization platform with [KubeVirt](https://kubevirt.io/)
- [`infrastructure/controllers/kyverno`](infrastructure/controllers/kyverno) -
  [Kyverno](https://kyverno.io) Kubernetes policy engine
- [`infrastructure/controllers/local-path-provisioner`](infrastructure/controllers/local-path-provisioner) -
  [Local Path Provisioner](https://github.com/rancher/local-path-provisioner)
  for simple `PersistentVolumeClaim` support in development
- [`infrastructure/controllers/mariadb-operator`](infrastructure/controllers/mariadb-operator) -
  [MariaDB Operator](https://github.com/mariadb-operator/mariadb-operator) for
  MariaDB databases.
- [`infrastructure/controllers/piraeus-operator`](infrastructure/controllers/piraeus-operator) -
  Container Storage Interface (CSI) plugin and [operator](https://piraeus.io/)
  for [LINSTOR](https://linbit.com/linstor/)
- [`infrastructure/controllers/sealed-secrets`](infrastructure/controllers/sealed-secrets) -
  [Sealed Secrets](https://github.com/bitnami-labs/sealed-secrets) controller to
  safely encrypt and store secrets in source control
- [`infrastructure/controllers/trust-manager`](infrastructure/controllers/trust-manager) -
  Provides ability to create CA bundles for trusting local authorities with the
  [trust-manager](https://cert-manager.io/docs/trust/trust-manager/) controller
- [`infrastructure/controllers/velero`](infrastructure/controllers/velero) -
  [Velero](https://velero.io/) for Kubernetes resource and persistent volume
  backups
- [`infrastructure/configs`](infrastructure/configs) - Configuration of
  controllers specific to the cluster

### Platform stack

Platform stack components are services which are used by applications or provide
some global utility to the services providing them.

- [`platform/idp`](platform/idp) - [Keycloak](https://www.keycloak.org/) for
  identity and access management (IAM)
- [`platform/monitoring`](platform/monitoring) - Kubernetes monitoring platform
  with the [Prometheus operator](https://prometheus-operator.dev/)

### Application stack

Application stack components provide usable functionality to end users and rely
on components in the platform and system stacks.

- [`apps/actual`](apps/actual) - [Actual Budget](https://actualbudget.org/)
  personal finance application practicing the envelope budgeting method.
- [`apps/ezxss`](apps/ezxss) - [ezXSS](https://github.com/ssl/ezXSS) platform
  for testing for XSS vulnerabilities, particularly useful for blind XSS
  injections.
- [`apps/paperless-ngx`](apps/paperless-ngx) -
  [Paperless-ngx](https://docs.paperless-ngx.com/) document management system

## Secrets management

Secrets in this repository not managed by Sealed Secrets are encrypted with
[SOPS](https://getsops.io/) and applied via Kustomize with the
[SOPS KRM function](https://catalog.kpt.dev/contrib/sops/v0.3/). These secrets
are only used for bootstrapping.
