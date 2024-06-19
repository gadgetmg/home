local kp =
  (import '../lib/main.libsonnet');

// Outputs flat array of manifests
std.flatMap(std.objectValues, std.objectValues(kp))
