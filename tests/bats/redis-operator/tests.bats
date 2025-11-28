#!/usr/bin/env bats

bats_load_library bats-detik/detik.bash
load ../helpers
DETIK_CLIENT_NAME="kubectl"

setup_file() {
  setup_kind_cluster
  kapp deploy -y -a setup \
    -f crds/test \
    -f manifests/test/redis-operator
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

@test "verify a RedisFailover resource creates a replication StatefulSet and sentinel Deployment" {
  create $BATS_TEST_DIRNAME/resources/secret.yaml
  create $BATS_TEST_DIRNAME/resources/redisfailover.yaml
  verify "there is 1 redisfailover named 'test-redis'"
  try "at most 24 times every 5s" \
    "to get statefulset named 'rfr-test-redis'" \
    "and verify that '.status.readyReplicas' is '3'"
  try "at most 24 times every 5s" \
    "to get deployment named 'rfs-test-redis'" \
    "and verify that '.status.readyReplicas' is '3'"
}
