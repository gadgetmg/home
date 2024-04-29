local root =
  (import '../lib/root.libsonnet') +
  {
    config+:: {
      environment: 'dev',
      repoURL: 'http://10.5.0.254/git/repo.git',
    },
  };

// Outputs flat array of manifests
std.objectValues(std.prune(root))
