#!/usr/bin/env bash

# Original author: https://github.com/datreeio/CRDs-catalog

cd "$(dirname "$0")/.."

# Create temp folder for CRDs
TMP_CRD_DIR=$TEMP/crds
mkdir -p $TMP_CRD_DIR

# Create final schemas directory
SCHEMAS_DIR=schemas

# Extract CRDs from cluster
while read -r crd
do
    crdname=${crd%% *}
    crdfile="$TMP_CRD_DIR/$crdname.yaml"
    kubectl get crds "$crdname" -o yaml > $crdfile 2>&1

    # Extract metadata from the CRD yaml
    resourceKind=$(yq -r '.spec.names.singular' $crdfile)
    resourceGroup=$(yq -r '.spec.group' $crdfile)

    # Convert the CRD yaml to a JSON schema
    outdir="$SCHEMAS_DIR/$resourceGroup"
    mkdir -p $outdir
    python3 hack/crd2jsonschema.py $crdfile --output-directory $outdir
done < <(kubectl get crds 2>&1 | sed -n '/NAME/,$p' | tail -n +2)

rm -rf $TMP_CRD_DIR
