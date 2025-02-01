#!/usr/bin/env bats

bats_load_library bats-detik/detik.bash
load ../helpers
DETIK_CLIENT_NAME="kubectl"

setup_file() {
  setup_kind_cluster
  kapp deploy -y -a setup \
    -f manifests/kind/infrastructure/crds \
    -f manifests/kind/infrastructure/controllers/kyverno
}

teardown_file() {
  teardown_kind_cluster
}

setup() {
  setup_temp_namespace
}

teardown() {
  teardown_temp_namespace
  kubectl delete -f $BATS_TEST_DIRNAME/resources/secret-to-sync.yaml -n default
  kubectl delete -f $BATS_TEST_DIRNAME/resources/secret-sync-clusterpolicy.yaml
}

@test "verify a clusterpolicy can be used to sync a secret" {
  kubectl create -f $BATS_TEST_DIRNAME/resources/secret-to-sync.yaml -n default
  create $BATS_TEST_DIRNAME/resources/secret-sync-clusterpolicy.yaml
  verify "there is 1 clusterpolicy named 'secret-sync'"
  try "at most 3 times every 1s" \
    "to get secret named 'generated'" \
    "and verify that '.data.test' is 'c2VjcmV0'"
}
