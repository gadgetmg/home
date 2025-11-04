#!/usr/bin/env bats

bats_load_library bats-detik/detik.bash
load ../helpers
DETIK_CLIENT_NAME="kubectl"

setup_file() {
  setup_kind_cluster
  kapp deploy -y -a setup \
    -f crds/test \
    -f manifests/test/envoy-gateway \
    -f manifests/test/gatewayclasses
}

teardown_file() {
  teardown_kind_cluster
}

@test "verify configured GatewayClass is accepted" {
  try "at most 5 times every 2s" \
    "to get gatewayclass named 'envoy-gateway'" \
    "and verify that '.status.conditions[?(@.type==\"Accepted\")].status' is 'True'"
}
