# My Kubernetes Homelab

This is the source repository for my homelab
[Kubernetes](https://kubernetes.io/) infrastructure built from repurposed mini
PCs. The cluster runs [Talos Linux](https://www.talos.dev/), a minimal and
immutable operating system designed exclusively for Kubernetes, and uses
[Argo CD](https://argo-cd.readthedocs.io) for fully GitOps-driven operation.

The purpose of this project is to both gain useful experience with Kubernetes,
but also to build a platform for providing legitimate production-quality
applications and services in my home.

## Applications

Components are organized in applications. Applications are contained groups of
manifests that are represented by an Argo CD `Application` resource.

### Infrastructure

Infrastructure components are fundamental to the cluster delivering core
functionality including networking and persistent storage to applications.

- [`argocd`](apps/argocd) - Continuous delivery of this repository using
  [Argo CD](https://argo-cd.readthedocs.io/en/stable/).
- [`backups`](apps/backups) - Configured backups for applications in the
  cluster.
- [`cdi`](apps/cdi) -
  [Containerized Data Importer](https://kubevirt.io/user-guide/storage/containerized_data_importer)
  tool for facilitating management of `DataVolumes` for use with KubeVirt.
- [`cert-manager`](apps/cert-manager) - Manages PKI certificate issuance in the
  cluster with the [cert-manager](https://cert-manager.io/) controller.
- [`cilium`](apps/cilium) - [Cilium](https://cilium.io/) Container Network
  Interface (CNI) plugin handling all networking including access from outside
  the cluster using BGP.
- [`cloudflare-gateway`](apps/cloudflare-gateway) -
  [Cloudflare Gateway](https://github.com/pl4nty/cloudflare-kubernetes-gateway/tree/main)
  for Cloudflare tunnels via
  [cloudflared](https://github.com/cloudflare/cloudflared) and the Gateway API.
- [`clusterissuers`](apps/clusterissuers) - Cluster-wide certificate issuers
  using self-signed CAs and [Let's Encrypt](https://letsencrypt.org).
- [`cnpg`](apps/cnpg) - [CloudNativePG](https://cloudnative-pg.io/) operator for
  PostgreSQL databases.
- [`crossplane`](apps/crossplane) - [Crossplane](https://www.crossplane.io/)
  control plane for managing non-Kubernetes resources
- [`crossplane-keycloak`](apps/crossplane-keycloak) - Crossplane provider for
  Keycloak management.
- [`csi-driver-smb`](apps/csi-driver-smb) -
  [CSI driver](https://github.com/kubernetes-csi/csi-driver-smb) for mounting
  remote SMB shares into pods.
- [`csi-snapshotter`](apps/csi-snapshotter) -
  [CSI Snapshotter](https://github.com/kubernetes-csi/external-snapshotter)
  component to implement volume snapshots.
- [`external-dns`](apps/external-dns) -
  [ExternalDNS](https://kubernetes-sigs.github.io/external-dns/latest/) for
  adding DNS records from Gateway API routes.
- [`external-secrets`](apps/external-secrets) -
  [External Secrets Operator](https://external-secrets.io/) for secrets
  management.
- [`gatewayclasses`](apps/gatewayclasses) - Gateway API providers'
  configurations for the cluster.
- [`ipam`](apps/ipam) - IP Address Management using Cilium.
- [`kubevirt`](apps/kubevirt) - [KubeVirt](https://kubevirt.io) for
  virtualization capability.
- [`kyverno`](apps/kyverno) - [Kyverno](https://kyverno.io) Kubernetes policy
  engine.
- [`mariadb-operator`](apps/mariadb-operator) -
  [MariaDB Operator](https://github.com/mariadb-operator/mariadb-operator) for
  MariaDB databases.
- [`multus`](apps/multus) -
  [Multus CNI](https://github.com/k8snetworkplumbingwg/multus-cni) to support
  additional networking options for pods.
- [`oidc`](apps/oidc) - OIDC configuration for the Kubernetes API to support SSO
  with Keycloak.
- [`piraeus-operator`](apps/piraeus-operator) - Container Storage Interface
  (CSI) plugin and [operator](https://piraeus.io/) for
  [LINSTOR](https://linbit.com/linstor/).
- [`redis-operator`](apps/redis-operator) -
  [Redis Operator](https://github.com/freshworks/redis-operator) for Redis
  databases.
- [`sealed-secrets`](apps/sealed-secrets) -
  [Sealed Secrets](https://github.com/bitnami-labs/sealed-secrets) controller to
  safely encrypt and store secrets in source control.
- [`storage`](apps/storage) - Configuration of LINSTOR pools and cluster
  `StorageClasses`.
- [`trust-manager`](apps/trust-manager) - Provides ability to create CA bundles
  for trusting local authorities with the
  [trust-manager](https://cert-manager.io/docs/trust/trust-manager/) controller.
- [`velero`](apps/velero) - [Velero](https://velero.io/) for Kubernetes resource
  and persistent volume backups.

### Platform services

Platform services are used by user applications or provide some global utility
to the cluster's services.

- [`headlamp`](apps/headlamp) - [Headlamp](https://headlamp.dev/) Kubernetes UI
- [`idp`](apps/idp) - [Keycloak](https://www.keycloak.org/) for identity and
  access management (IAM)
- [`monitoring`](apps/monitoring) - Kubernetes monitoring platform with the
  [Prometheus operator](https://prometheus-operator.dev/)

### User applications

User applications provide direct functionality to end users.

- [`actual`](apps/actual) - [Actual Budget](https://actualbudget.org/) personal
  finance application practicing the envelope budgeting method.
- [`ezxss`](apps/ezxss) - [ezXSS](https://github.com/ssl/ezXSS) platform for
  testing for XSS vulnerabilities, particularly useful for blind XSS injections.
- [`paperless-ngx`](apps/paperless-ngx) -
  [Paperless-ngx](https://docs.paperless-ngx.com/) document management system
- [`virtualmachines`](apps/virtualmachines) - Namespace for creating virtual
  machines

## Rendered manifests pattern

This project follows the
[rendered manifests pattern](https://akuity.io/blog/the-rendered-manifests-pattern)
to address many of the pain points of keeping third-party resources (Helm
charts, etc) up to date and maintaining atomicity. To accomplish this,
pre-commit hooks and CI jobs automatically render out DRY `Kustomizations` to
the `manifests` and `crds` folders before a pull request can be merged. This
ensures the diff reflects the actual changes to the cluster, prevents breakages
from silent upstream changes, and significantly improves sync performance of
Argo CD.

## Secrets management

Secrets in this repository not managed by Sealed Secrets are encrypted with
[SOPS](https://getsops.io/) and applied via Kustomize with the
[SOPS KRM function](https://catalog.kpt.dev/contrib/sops/v0.3/). These secrets
are only used for bootstrapping, primarily for loading the sealing key for
git-committed `SealedSecrets`.
