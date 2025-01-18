#!/bin/sh

cd "$(dirname "$0")/.."

kustomize build --enable-alpha-plugins --env SOPS_IMPORT_AGE="$(cat ~/.config/sops/age/keys.txt)" | kubectl apply --server-side --force-conflicts -f -
