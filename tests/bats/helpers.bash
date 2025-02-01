#!/usr/bin/env bash

setup_kind_cluster() {
  export KUBECONFIG=$(mktemp)
  export KIND_CLUSTER_NAME=$RANDOM
  kind create cluster --config clusters/kind/kind-config.yaml
}

teardown_kind_cluster() {
  kind delete cluster
  rm $KUBECONFIG
}

setup_temp_namespace() {
  DETIK_CLIENT_NAMESPACE="test-$RANDOM"
  kubectl create namespace $DETIK_CLIENT_NAMESPACE
}

teardown_temp_namespace() {
  kubectl delete namespace $DETIK_CLIENT_NAMESPACE
}

create() {
  kubectl create -n $DETIK_CLIENT_NAMESPACE -f $1
}
