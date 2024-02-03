#/usr/bin/env bash
#
# testgen.sh
#
# Generates a basic set of asserts for kuttl based on the resources output by
# `kustomize build`. The output is filtered to only include apiVersion, kind,
# and metadata fields. Asserts are separated into individual test cases by
# their "app.kubernetes.io/component" label. Unlabeled resources will go into
# a folder named "null"

# Build the current directory into out.yaml
kustomize build --enable-alpha-plugins --enable-exec --enable-helm |
    yq '. |= with_entries(select(.key == "apiVersion" or .key == "kind" or .key == "metadata"))' \
    > out.yaml

# Get all the values of "app.kubernetes.io/component" remove null, sort, and
# remove duplicates. Finally, run each line through mkdir and yq to create
# directories and split out.yaml.
yq -N '.metadata.labels."app.kubernetes.io/component"' out.yaml |
    grep -v null | sort | uniq |
    xargs -i sh -c "mkdir -p tests/unit/{} && \
        yq '. | select(.metadata.labels.\"app.kubernetes.io/component\" == \"{}\")' \
            out.yaml > tests/unit/{}/00-assert.yaml
        "

# Add any unlabeled resources to a "null" folder
mkdir -p tests/unit/null
yq '. | select(.metadata.labels."app.kubernetes.io/component" == null)' \
    out.yaml > tests/unit/null/00-assert.yaml

# Remove temporary out.yaml file
rm -f out.yaml

# Make environment-specific unit tests (empty)
mkdir -p ../dev/tests/unit/environment
touch ../dev/tests/unit/environment/00-assert.yaml
mkdir -p ../production/tests/unit/environment
touch ../production/tests/unit/environment/00-assert.yaml
