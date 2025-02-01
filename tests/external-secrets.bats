#!/usr/bin/env bats

bats_load_library bats-detik/detik.bash
load helpers
DETIK_CLIENT_NAME="kubectl"

setup_file() {
  setup_kind_cluster
  kapp deploy -y -a setup \
    -f manifests/kind/infrastructure/crds \
    -f manifests/kind/infrastructure/controllers/cert-manager \
    -f manifests/kind/infrastructure/controllers/external-secrets \
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

@test "verify an externalsecret can be created from a generator" {
  create $BATS_TEST_DIRNAME/resources/password-generator.yaml
  verify "there is 1 password named 'test'"
  create $BATS_TEST_DIRNAME/resources/external-secret.yaml
  verify "there is 1 externalsecret named 'test'"
  try "at most 5 times every 2s" \
    "to get externalsecret named 'test'" \
    "and verify that '.status.conditions[?(@.type==\"Ready\")].status' is 'True'"
  verify "there is 1 secret named 'test'"
}
