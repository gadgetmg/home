#!/usr/bin/env bats

bats_load_library bats-detik/detik.bash
load ../helpers
DETIK_CLIENT_NAME="kubectl"

setup_file() {
  setup_kind_cluster
  kapp deploy -y -a setup \
    -f manifests/kind/infrastructure/crds \
    -f manifests/kind/infrastructure/controllers/cert-manager \
    -f manifests/kind/infrastructure/configs/clusterissuers
}

teardown_file() {
  teardown_kind_cluster
}

setup() {
  setup_temp_namespace
}

teardown() {
  teardown_temp_namespace
}

@test "verify a certificate can be issued with the selfsigned ClusterIssuer" {
  create $BATS_TEST_DIRNAME/resources/selfsigned-cert.yaml
  verify "there is 1 certificate named 'test'"
  try "at most 5 times every 2s" \
    "to get certificate named 'test'" \
    "and verify that '.status.conditions[?(@.type==\"Ready\")].status' is 'True'"
  verify "there is 1 secret named 'test-tls'"
}

@test "verify a certificate can be issued with the cluster-ca ClusterIssuer" {
  create $BATS_TEST_DIRNAME/resources/cluster-ca-cert.yaml
  verify "there is 1 certificate named 'test'"
  try "at most 5 times every 2s" \
    "to get certificate named 'test'" \
    "and verify that '.status.conditions[?(@.type==\"Ready\")].status' is 'True'"
  verify "there is 1 secret named 'test-tls'"
}
