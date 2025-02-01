#!/usr/bin/env bats

bats_load_library bats-detik/detik.bash
load helpers
DETIK_CLIENT_NAME="kubectl"

setup_file() {
  setup_kind_cluster
  kapp deploy -y -a setup \
    -f manifests/kind/infrastructure/crds \
    -f manifests/kind/infrastructure/controllers/crossplane
  kapp deploy -y -a setup \
    -f manifests/kind/infrastructure/crds \
    -f manifests/kind/infrastructure/controllers/crossplane \
    -f manifests/kind/infrastructure/configs/crossplane-keycloak
}

teardown_file() {
  teardown_kind_cluster
}

@test "verify configured keycloak provider is healthy" {
  try "at most 20 times every 5s" \
    "to get provider named 'provider-keycloak'" \
    "and verify that '.status.conditions[?(@.type==\"Healthy\")].status' is 'True'"
}
