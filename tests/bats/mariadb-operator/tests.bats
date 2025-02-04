#!/usr/bin/env bats

bats_load_library bats-detik/detik.bash
load ../helpers
DETIK_CLIENT_NAME="kubectl"

setup_file() {
  setup_kind_cluster
  kapp deploy -y -a setup \
    -f manifests/kind/infrastructure/crds \
    -f manifests/kind/infrastructure/controllers/mariadb-operator
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

@test "verify a mariadb cluster can be created" {
  create $BATS_TEST_DIRNAME/resources/mariadb-cluster.yaml
  verify "there is 1 mariadb named 'test'"
  try "at most 20 times every 10s" \
    "to get mariadb named 'test'" \
    "and verify that '.status.conditions[?(@.type==\"Ready\")].status' is 'True'"
}
