# My Kubernetes Homelab

This is the source repository for my homelab [Kubernetes](https://kubernetes.io/) infrastructure built from repurposed HP ProDesk 600 G3 Desktop Mini PCs. The cluster runs [Talos Linux](https://www.talos.dev/), a minimal and immutable operating system designed exclusively for Kubernetes. The purpose of this project is to both gain useful experience with Kubernetes, but also to build a platform for providing legitimate production-quality applications and services in my home.

The project is organized into different "stacks" of components based on their function in the cluster.

### System stack

System stack components are fundamental to the cluster delivering core functionality including networking and persistent storage to applications.

- [`system/argocd`](system/argocd) - Continuous delivery of this repository using [Argo CD](https://argo-cd.readthedocs.io/en/stable/)
- [`system/cert-manager`](system/cert-manager) - Manages PKI certificates in the cluster with the [cert-manager](https://cert-manager.io/) and [trust-manager](https://cert-manager.io/docs/trust/trust-manager/) projects
- [`system/cilium`](system/cilium) - [Cilium](https://cilium.io/) Container Network Interface (CNI) plugin handling all networking including access from outside the cluster using BGP.
- [`system/cloudflare-gateway`](system/cloudflare-gateway) - [Cloudflare Gateway](https://github.com/pl4nty/cloudflare-kubernetes-gateway/tree/main) for Cloudflare tunnels via [cloudflared](https://github.com/cloudflare/cloudflared) and the Gateway API.
- [`system/cnpg`](system/cnpg) - [CloudNativePG](https://cloudnative-pg.io/) operator for PostgreSQL databases
- [`system/crossplane`](system/crossplane) - [Crossplane](https://www.crossplane.io/) control plane for managing non-Kubernetes resources
- [`system/envoy-gateway`](system/envoy-gateway) - [Envoy Gateway](https://gateway.envoyproxy.io/) for handling ingress connections into the cluster via the Gateway API.
- [`system/external-secrets`](system/external-secrets) - [External Secrets Operator](https://external-secrets.io/) for secrets management
- [`system/gateway-api`](system/gateway-api) - [Gateway API](https://gateway-api.sigs.k8s.io/) CRDs used by Envoy Gateway
- [`system/k8s-gateway`](system/k8s-gateway) - An outside-facing instance of [CoreDNS with the k8s_gateway plugin](https://ori-edge.github.io/k8s_gateway/) for resolving DNS names from the LAN
- [`system/keycloak`](system/keycloak) - [Keycloak](https://www.keycloak.org/) for identity and access management (IAM)
- [`system/kube-prometheus`](system/kube-prometheus) - Kubernetes monitoring platform with the [Prometheus operator](https://prometheus-operator.dev/)
- [`system/kubevirt`](system/kubevirt) - Virtualization platform with [KubeVirt](https://kubevirt.io/)
- [`system/kyverno`](system/kyverno) - [Kyverno](https://kyverno.io) Kubernetes policy engine
- [`system/mariadb-operator`](system/mariadb-operator) - [MariaDB Operator](https://github.com/mariadb-operator/mariadb-operator) for MariaDB databases.
- [`system/piraeus`](system/piraeus) - Container Storage Interface (CSI) plugin for [LINSTOR](https://linbit.com/linstor/) managed with the [Piraeus](https://piraeus.io/) operator
- [`system/velero`](system/velero) - [Velero](https://velero.io/) for Kubernetes resource and persistent volume backups

### Application stack

Application stack components provide usable functionality to end users and rely on components in the platform and system stacks.

- [`apps/actual`](apps/actual) - [Actual Budget](https://actualbudget.org/) personal finance application practicing the envelope budgeting method.
- [`apps/ezxss`](apps/ezxss) - [ezXSS](https://github.com/ssl/ezXSS) platform for testing for XSS vulnerabilities, particularly useful for blind XSS injections.
- [`apps/paperless-ngx`](apps/paperless-ngx) - [Paperless-ngx](https://docs.paperless-ngx.com/) document management system

### Root app

Following Argo CD's [app of apps pattern](https://argo-cd.readthedocs.io/en/stable/operator-manual/cluster-bootstrapping/#app-of-apps-pattern), apps for which Argo CD should sync are managed by an app themselves. This is controlled by the [`root`](root) app which generates the desired manifests with [Jsonnet](https://jsonnet.org/) to avoid duplication.

## Secrets management

Secrets in this repository are encrypted with [SOPS](https://getsops.io/) and applied via Kustomize with the [KSOPS](https://github.com/viaduct-ai/kustomize-sops) plugin. Secrets are readable with my personal AGE private key as well as a private key created for the production Argo CD deployment.

## Development environment

Tools for working with Talos Linux, Kubernetes, etc, are managed by this project's [`flake.nix`](https://nixos.org/). With [direnv](https://direnv.net/), all tools are installed and ready to use when navigating to the folder in a terminal.

A rudimentary shell script, `hack/dev-cluster.sh`, provisions a local development cluster using a [`containerized version of Talos`](https://www.talos.dev/latest/talos-guides/install/local-platforms/docker/).

> 💡 Note: To successfully deploy LINSTOR in the development cluster, the host Linux system must have the DRBD 9 kernel module installed.

## Talos configuration

The production cluster's configuration is generated with [`talhelper genconfig`](https://github.com/budimanjojo/talhelper) based on the `talconfig.yaml` and `talsecret.sops.yaml` files. `talosctl` is used to apply configuration, upgrade Talos Linux, and upgrade the Kubernetes version on the cluster based on the configuration generated by `talhelper`.

> 💡 Note: When booted from the installation media, the nodes will run in "maintenance" mode. Applying a configuration to them with `talosctl` will install Talos to the disk and attempt to join the cluster.

The [first node of the `etcd` cluster must be bootstrapped](https://www.talos.dev/v1.6/learn-more/control-plane/#cluster-bootstrapping) manually with `talosctl`. Other nodes will then automatically join the cluster based on their applied configuration.

### Disk encryption and UEFI Secure Boot

Working Secure Boot is required to enable [secure TPM-backed disk encryption](https://www.talos.dev/v1.6/talos-guides/configuration/disk-encryption/).

#### Node preparation

The nodes must be prepared to accept the Secure Boot keys provided by the Talos installer. The UEFI firmware must be configured to clear all existing Secure Boot keys to allow the Talos installer to apply Sidero's platform key to the system.

> 💡 Note: It is important to retain the Microsoft UEFI CA certificate in the signature database to continue to allow option ROMs (such as for display adapters) to load. **On HP systems specifically, failing to do so will prevent normal access to the UEFI firmware interface.**

Talos also requires TPM 2.0 to support TPM-backed disk encryption. While the HP ProDesk 600 G3 ships with TPM 1.2, [HP provides a firmware update](https://support.hp.com/us-en/document/c05381064) to convert to TPM 2.0.

#### Talos installer

The Secure Boot installation image must be obtained from the Talos [Image Factory](https://factory.talos.dev/).

On first boot of the installer, [use the `Enroll Secure Boot keys: auto` option in the boot options](https://www.talos.dev/v1.6/talos-guides/install/bare-metal-platforms/secureboot/#booting-talos-linux-in-secureboot-mode). Once applied, the node will verify it is running in Secure Boot mode from the dashboard as well as with the `talosctl get securitystate` command.

### Image Factory schematic

The Talos Image Factory generates and signs images with a configurable set of extensions and kernel parameters. The following customization generates the schematic ID of `a13c1e1cdb9e135b5ae8ca3e977a5bee91bb4a503493d9204b6433239f462799` used in the cluster:

```
customization:
  systemExtensions:
    officialExtensions:
    - siderolabs/drbd
    - siderolabs/i915-ucode
    - siderolabs/intel-ucode
```

### Network configuration

The nodes are configured for DHCP and configured with reservations from the upstream server. The nodes are configured to [share a virtual IP](https://www.talos.dev/v1.6/talos-guides/network/vip/) which is used to ensure highly available access to the Kubernetes API.

### CNI configuration

By default, Talos installs Flannel as the cluster's CNI. This repository depends on Cilium. Cilium cannot be installed directly by the Talos installer. Instead, the cluster is [created with no CNI and then manually bootstrapped with Cilium](https://www.talos.dev/v1.6/kubernetes-guides/network/deploying-cilium/).

### Control plane scheduling

For high-availability of the Kubernetes API, but also to limit the required number of nodes, `talconfig.yaml` configures all three nodes as control plane nodes, but allows scheduling workloads on them.

> 💡 Note: While this is not strictly best practice, the alternative is losing high availability or purchasing additional worker nodes.

### Pod security

The default [Pod Security Standards](https://www.talos.dev/latest/kubernetes-guides/configuration/pod-security) profile is hardened to the `restricted` profile with a configuration patch in `talconfig.yaml`. This is increased from the default `baseline` set by Talos.
