{
  local d = (import 'doc-util/main.libsonnet'),
  '#':: d.pkg(name='v1', url='', help=''),
  gateway: (import 'gateway.libsonnet'),
  gatewayClass: (import 'gatewayClass.libsonnet'),
  httpRoute: (import 'httpRoute.libsonnet'),
}
