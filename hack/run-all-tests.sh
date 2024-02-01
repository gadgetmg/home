#/usr/bin/env sh

# Find all kuttl-test.yaml files, cd to each, and run kuttl
find . -iname kuttl-test.yaml |
    xargs dirname |
    xargs -i sh -c 'pushd {} && kubectl kuttl test && popd'
