_: {
  applications.clusterissuers.yamls = map builtins.readFile [
    ./cluster-ca.yaml
    ./selfsigned.yaml
  ];
}
