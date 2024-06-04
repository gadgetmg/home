#!/usr/bin/env bash

if [ -f $1/kustomization.yaml ]; then
    kustomize build --enable-alpha-plugins --enable-exec --enable-helm $1
elif [ -f $1/main.jsonnet ]; then
    jsonnet -J vendor $1/main.jsonnet -y
fi
