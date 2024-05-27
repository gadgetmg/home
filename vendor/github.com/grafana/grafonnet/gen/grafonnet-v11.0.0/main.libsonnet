// This file is generated, do not manually edit.
{
  '#': {
    filename: 'main.libsonnet',
    help: 'Jsonnet library for rendering Grafana resources\n## Install\n\n```\njb install github.com/grafana/grafonnet/gen/grafonnet-v11.0.0@main\n```\n\n## Usage\n\n```jsonnet\nlocal grafonnet = import "github.com/grafana/grafonnet/gen/grafonnet-v11.0.0/main.libsonnet"\n```\n',
    'import': 'github.com/grafana/grafonnet/gen/grafonnet-v11.0.0/main.libsonnet',
    installTemplate: '\n## Install\n\n```\njb install %(url)s@%(version)s\n```\n',
    name: 'grafonnet',
    url: 'github.com/grafana/grafonnet/gen/grafonnet-v11.0.0',
    usageTemplate: '\n## Usage\n\n```jsonnet\nlocal %(name)s = import "%(import)s"\n```\n',
    version: 'main',
  },
  accesspolicy: import 'accesspolicy.libsonnet',
  dashboard: import 'dashboard.libsonnet',
  librarypanel: import 'librarypanel.libsonnet',
  preferences: import 'preferences.libsonnet',
  publicdashboard: import 'publicdashboard.libsonnet',
  role: import 'role.libsonnet',
  rolebinding: import 'rolebinding.libsonnet',
  team: import 'team.libsonnet',
  folder: import 'folder.libsonnet',
  panel: import 'panelindex.libsonnet',
  query: import 'query.libsonnet',
  util: import 'custom/util/main.libsonnet',
  alerting: import 'alerting.libsonnet',
}
