#!/usr/bin/env bash

# clear existing hydrated manifests
rm -r manifests/**

# find all kustomize overlays
roots=("infrastructure/controllers" "infrastructure" "platform" "apps")
targets=$(find ${roots[*]} -maxdepth 3 -name kustomization.yaml ! -path '*/base/*' | xargs dirname)

# build each kustomization to corresponding directory under manifests/
for t in $targets; do
  env=$(basename $t)
  app=$(dirname $t)
  outdir="manifests/$env/$app"

  echo "building $outdir"
  mkdir -p $outdir
  kustomize build --enable-helm $t -o $outdir/
done

# replace any colons in file names
find manifests -name '*:*.yaml' -exec bash -c 'mv $0 $(echo $0 | tr ":" "-")' {} \;

# add geneated manifests to git tree
git add --intent-to-add manifests/
