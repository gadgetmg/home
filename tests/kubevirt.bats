#!/usr/bin/env bats

bats_load_library bats-detik/detik.bash
load helpers
DETIK_CLIENT_NAME="kubectl"

setup_file() {
  setup_kind_cluster
  kapp deploy -y -a setup \
    -f manifests/kind/infrastructure/crds \
    -f manifests/kind/infrastructure/controllers/kubevirt-operator \
    -f manifests/kind/infrastructure/configs/kubevirt
}

teardown_file() {
  teardown_kind_cluster
}

@test "verify configured kubevirt instance is available" {
  DETIK_CLIENT_NAMESPACE="kubevirt"
  try "at most 20 times every 10s" \
    "to get kubevirt named 'kubevirt'" \
    "and verify that '.status.conditions[?(@.type==\"Available\")].status' is 'True'"
}
