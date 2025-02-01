#!/usr/bin/env bats

bats_load_library bats-detik/detik.bash
load ../helpers
DETIK_CLIENT_NAME="kubectl"

setup_file() {
  setup_kind_cluster
  kapp deploy -y -a setup \
    -f manifests/kind/infrastructure/crds \
    -f manifests/kind/infrastructure/controllers/envoy-gateway \
    -f manifests/kind/infrastructure/configs/gatewayclasses
}

teardown_file() {
  teardown_kind_cluster
}

@test "verify configured GatewayClass is accepted" {
  try "at most 5 times every 2s" \
    "to get gatewayclass named 'envoy-gateway'" \
    "and verify that '.status.conditions[?(@.type==\"Accepted\")].status' is 'True'"
}
