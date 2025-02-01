# Development environment

Tools for working with Talos Linux, Kubernetes, etc, are managed by this
project's [`flake.nix`](https://nixos.org/). With [direnv](https://direnv.net/),
all tools are installed and ready to use when navigating to the folder in a
terminal.

Task `clusters:dev:create` provisions a local development cluster using a
[`containerized version of Talos`](https://www.talos.dev/latest/talos-guides/install/local-platforms/docker/).

> 💡 Note: To successfully deploy LINSTOR in the development cluster, the host
> Linux system must have the DRBD 9 kernel module installed.
