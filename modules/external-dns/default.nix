{charts, ...}: {
  applications.external-dns = {
    namespace = "external-dns";
    createNamespace = true;
    helm.releases.external-dns = {
      chart = charts.external-dns;
      values = {
        sources = [
          "gateway-grpcroute"
          "gateway-httproute"
          "gateway-tlsroute"
          "gateway-tcproute"
          "gateway-udproute"
        ];
      };
    };
    objectTransforms = [
      {
        match.kind = "CustomResourceDefinition";
        rewrite = _: null;
      }
    ];
  };
}
