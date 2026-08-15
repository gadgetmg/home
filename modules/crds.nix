{
  pkgs,
  generators,
  charts,
  lib,
  ...
}: let
  buildCrd = spec: let
    buildFromChart = {
      module = generators.fromChartCRDModule spec;
      objects = generators.crdObjectsFromChart (removeAttrs spec ["namePrefix"]);
    };
    buildFromSrc = {
      module = generators.fromCRDModule spec;
      objects = generators.crdObjects (removeAttrs spec ["name" "namePrefix"]);
    };
  in
    if spec.chart or null != null
    then buildFromChart
    else buildFromSrc;

  built = map buildCrd crds;
  crds = [
    {
      name = "cert-manager";
      chart = charts.cert-manager;
      values.crds.enabled = true;
    }
    {
      name = "external-secrets";
      chart = charts.external-secrets;
    }
    {
      name = "prometheus-operator-crds";
      chart = charts.prometheus-operator-crds;
    }
    {
      name = "velero";
      chart = charts.velero;
    }
    {
      name = "trust-manager";
      chart = charts.trust-manager;
    }
    {
      name = "kyverno";
      chart = charts.kyverno;
    }
    {
      name = "cloudnative-pg";
      chart = charts.cloudnative-pg;
      namePrefix = "postgres";
    }
    {
      name = "mariadb-operator";
      chart = charts.mariadb-operator;
      values.crds.enabled = true;
      namePrefix = "mariadb";
    }
    {
      name = "piraeus";
      chart = charts.piraeus;
      values.installCRDs = true;
    }
    {
      name = "redis-operator";
      chart = charts.redis-operator;
    }
    {
      name = "sealed-secrets";
      chart = charts.sealed-secrets;
    }
    {
      name = "gateway-api";
      src = pkgs.fetchurl {
        url = "https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.6.1/experimental-install.yaml";
        sha256 = "sha256-1/p3ZQ5O8o/KBBFTb8teI33rTVAwHP3tO+Sdmht7vQI=";
      };
      dontUnpack = true;
    }
    {
      name = "cdi";
      src = pkgs.fetchurl {
        url = "https://github.com/kubevirt/containerized-data-importer/releases/download/v1.64.0/cdi-operator.yaml";
        sha256 = "sha256-lUCsr9hez2Uj63fJdZok5tAtdJTiU7qmkwqQ8Lj61jw=";
      };
      dontUnpack = true;
    }
    {
      name = "kubevirt";
      src = pkgs.fetchurl {
        url = "https://github.com/kubevirt/kubevirt/releases/download/v1.8.4/kubevirt-operator.yaml";
        sha256 = "sha256-0dgmTuxbgCwSK+xsVNjDsR4RnuKlx1YCqqi1PqOFfto=";
      };
      dontUnpack = true;
    }
    {
      name = "multus";
      src = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/k8snetworkplumbingwg/multus-cni/v4.3.0/deployments/multus-daemonset-thick.yml";
        sha256 = "sha256-LWIvaXgJZEoScESXu/XDJWrcHn9bVQRlXkmTdDZRtYU=";
      };
      dontUnpack = true;
    }
    {
      name = "barman";
      src = pkgs.fetchurl {
        url = "https://github.com/cloudnative-pg/plugin-barman-cloud/releases/download/v0.13.0/manifest.yaml";
        sha256 = "sha256-0uceewaCJEjxpCHwV4GEbP25zGIefvMu714gxRMyE7A=";
      };
      dontUnpack = true;
    }
    {
      name = "external-snapshotter";
      src = pkgs.fetchFromGitHub {
        owner = "kubernetes-csi";
        repo = "external-snapshotter";
        rev = "v8.6.0";
        sha256 = "sha256-9WSflI44XhecRqBWGKDfeMMHqOBwyInX9w2qMLDPylA=";
      };
      crdFiles = [
        "client/config/crd/groupsnapshot.storage.k8s.io_volumegroupsnapshotclasses.yaml"
        "client/config/crd/groupsnapshot.storage.k8s.io_volumegroupsnapshotcontents.yaml"
        "client/config/crd/groupsnapshot.storage.k8s.io_volumegroupsnapshots.yaml"
        "client/config/crd/snapshot.storage.k8s.io_volumesnapshotclasses.yaml"
        "client/config/crd/snapshot.storage.k8s.io_volumesnapshotcontents.yaml"
        "client/config/crd/snapshot.storage.k8s.io_volumesnapshots.yaml"
      ];
    }
  ];
in {
  nixidy.applicationImports = map (b: b.module) built;
  applications.crds.objects =
    (lib.concatMap (b: b.objects) built)
    # Nixidy already includes resource options for Argo CD, but we still need to
    # push its CRD objects to the clusters
    ++ generators.crdObjectsFromChart {
      name = "argo-cd";
      chart = charts.argo-cd;
    };
}
