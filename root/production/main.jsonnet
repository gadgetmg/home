local root =
  (import '../lib/root.libsonnet') +
  {
    config+:: {
      environment: 'production',
      repoURL: 'git@github.com:gadgetmg/home.git',
    },
  };

// Outputs flat array of manifests
std.objectValues(root)
