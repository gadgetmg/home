#!/usr/bin/env bats

bats_load_library bats-detik/detik.bash
load ../helpers
DETIK_CLIENT_NAME="kubectl"

setup_file() {
  setup_kind_cluster
  kapp deploy -y -a setup \
    -f crds/test \
    -f manifests/test/cert-manager \
    -f manifests/test/clusterissuers \
    -f manifests/test/trust-manager
}

teardown_file() {
  teardown_kind_cluster
}

setup() {
  setup_temp_namespace
}

teardown() {
  teardown_temp_namespace
  kubectl delete -f $BATS_TEST_DIRNAME/resources/bundle.yaml
}

@test "verify a bundle creates a configmap with the CA certificate" {
  create $BATS_TEST_DIRNAME/resources/bundle.yaml
  kubectl label namespace $DETIK_CLIENT_NAMESPACE tests/name=trust-manager
  verify "there is 1 bundle named 'test'"
  try "at most 5 times every 2s" \
    "to get bundle named 'test'" \
    "and verify that '.status.conditions[?(@.type==\"Synced\")].status' is 'True'"
  verify "there is 1 configmap named 'test'"
}
