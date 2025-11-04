#!/usr/bin/env bats

bats_load_library bats-detik/detik.bash
load ../helpers
DETIK_CLIENT_NAME="kubectl"

setup_file() {
  setup_kind_cluster
  kapp deploy -y -a setup \
    -f crds/test \
    -f manifests/test/cert-manager \
    -f manifests/test/cnpg
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

@test "verify a postgresql cluster can be created" {
  create $BATS_TEST_DIRNAME/resources/cnpg-cluster.yaml
  verify "there is 1 cluster named 'test'"
  try "at most 20 times every 5s" \
    "to get cluster named 'test'" \
    "and verify that '.status.conditions[?(@.type==\"Ready\")].status' is 'True'"
}
