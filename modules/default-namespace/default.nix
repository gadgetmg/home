_: {
  applications.default-namespace = {
    namespace = "default";
    yamls = map builtins.readFile [
      ./networkpolicies.yaml
    ];
  };
}
