#!/usr/bin/env bats

bats_load_library bats-detik/detik.bash
load ../helpers
DETIK_CLIENT_NAME="kubectl"

setup_file() {
  setup_kind_cluster
  kapp deploy -y -a setup \
    -f crds/test \
    -f manifests/test/cert-manager \
    -f manifests/test/clusterissuers
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
  verify "there is 1 certificate named 'selfsigned'"
  try "at most 5 times every 2s" \
    "to get certificate named 'selfsigned'" \
    "and verify that '.status.conditions[?(@.type==\"Ready\")].status' is 'True'"
  verify "there is 1 secret named 'selfsigned-tls'"
}

@test "verify a certificate can be issued with the cluster-ca ClusterIssuer" {
  create $BATS_TEST_DIRNAME/resources/cluster-ca-cert.yaml
  verify "there is 1 certificate named 'casigned'"
  try "at most 5 times every 2s" \
    "to get certificate named 'casigned'" \
    "and verify that '.status.conditions[?(@.type==\"Ready\")].status' is 'True'"
  verify "there is 1 secret named 'casigned-tls'"
}
