local root =
  (import '../lib/root.libsonnet') +
  {
    config+:: {
      environment: 'dev',
      repoURL: 'file:///tmp/local-repo',
    },
  };

// Outputs flat array of manifests
std.objectValues(root)
