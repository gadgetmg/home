#!/usr/bin/env python

# Original author: https://github.com/tignis/crd2jsonschema

import yaml  # https://pyyaml.org/wiki/PyYAMLDocumentation
from deepdiff import DeepDiff  # https://pypi.org/project/deepdiff/
import json
import os
import re
from pprint import pprint
import shutil


dns_1123_regex = re.compile('[a-z0-9]([-a-z0-9]*[a-z0-9])?')


def generate_filename(crd_dictionary, version_name=None):
    """
    Given a dictionary loaded from a CRD yaml, extract the resource group, version, kind. Return a filename in the format "kind_ver".
    https://github.com/instrumenta/kubeval/blob/8c40ed5d2110c5dd7fe45d6a429f16170c9910d1/kubeval/kubeval.go#L40

    >>> s = '''
    ... apiVersion: apiextensions.k8s.io/v1beta1
    ... kind: CustomResourceDefinition
    ... metadata:
    ...   name: whatever.example.com
    ... spec:
    ...   group: example.com
    ...   names:
    ...     kind: Thing
    ...     listKind: ThingList
    ...     plural: things
    ...     singular: thing
    ...   scope: Namespaced
    ...   version: v1alpha2
    ...   validation:
    ...     openAPIV3Schema: {}
    ... '''
    >>> d = yaml.safe_load(s)
    >>> generate_filename(d)
    'thing-example-v1alpha2.json'

    >>> d['spec']['version'] = 'v1/v2'
    >>> generate_filename(d)
    Traceback (most recent call last):
       ...
    ValueError: ('Invalid version', 'v1/v2')

    :param crd_dictionary: a dictionary from yaml.safe_load_all(f)[]
    :return: A proposed filename.
    """

    try:
        kind = crd_dictionary['spec']['names']['singular'].lower()
    except KeyError:
        kind = crd_dictionary['spec']['names']['kind'].lower()

    group_parts = crd_dictionary['spec']['group'].split('/')[0].split('.')

    version_part = version_name or crd_dictionary['spec']['version']

    if not dns_1123_regex.fullmatch(kind):
        raise ValueError('Invalid kind', kind)
    if not dns_1123_regex.fullmatch(version_part):
        raise ValueError('Invalid version', version_part)

    r = '%s_%s.json' % (
        kind,
        version_part
    )
    print("Generated name", r)
    return r


def process_yaml_file(yaml_in, output_directory):
    print("Reading", yaml_in)
    yaml_object = yaml.safe_load_all(yaml_in) # yaml_object will be a list or a dict

    for document in yaml_object:
        if document is None: continue  # skip empty yaml document

        if document['kind'] != 'CustomResourceDefinition':
            continue

        # A CRD may list multiple versions, or just one. Which is it?
        # Assume multiple.
        versions_chunks = document['spec']['versions']

        print("Found versions", [x['name'] for x in versions_chunks])

        for version_chunk in versions_chunks:
            try:
                schema_part = version_chunk['schema']['openAPIV3Schema']
            except:
                continue

            filename = generate_filename(document, version_chunk['name'])

            # Patch the schema with kubernetes extensions
            schema_part['x-kubernetes-group-version-kind'] = [{
                'kind': [document['spec']['names']['kind']],
                'version': version_chunk['name'],
                'group': document['spec']['group'],
            }]

            # This is json-schema, even though the CRD didn't state that explicitly.
            schema_part['$schema'] = 'http://json-schema.org/schema#'

            emit_file(output_directory, filename, schema_part)

        # One mega version, not in the list of multiple versions

        if 'version' in document['spec']:
            filename = generate_filename(document)
            try:
                schema_part = document['spec']['validation']['openAPIV3Schema']
            except KeyError:
                print("No schema found in spec.validation.openAPIV3Schema")
                schema_part = {
                    "type": "object",
                    "additionalProperties": True,
                }

            # Patch the schema with kubernetes extensions
            schema_part['x-kubernetes-group-version-kind'] = [{
                'kind': [document['spec']['names']['kind']],
                'version': document['spec']['version'],
                'group': document['spec']['group'],
            }]

            # This is json-schema, even though the CRD didn't state that explicitly.
            schema_part['$schema'] = 'http://json-schema.org/schema#'

            emit_file(output_directory, filename, schema_part)


def emit_file(output_directory, filename, schema_part):
    try:
        with open(os.path.join(output_directory, filename), 'x') as json_out:
            json.dump(schema_part, json_out, indent=2)
        print("Wrote %s" % filename)

    except FileExistsError as e:

        with open(os.path.join(output_directory, filename), 'r') as json_comparison:
            existing_file_content = json.load(json_comparison)

        ddiff = DeepDiff(schema_part, existing_file_content, ignore_order=True)

        if ddiff:
            print("Existing %s already exists, with different content. Delete it and recreate?" % filename)
            #pprint(ddiff, indent=1, width=min([80, shutil.get_terminal_size().columns]), compact=False)
        else:
            print("Existing %s already correct" % filename)


if __name__ == '__main__':
    import argparse

    parser = argparse.ArgumentParser(description=(
        'Given a list of yaml files containing Kubernetes Custom Resource Definitions (CRDs), '
        'extract the embedded openAPIV3Schema into a standalone file usable by http://kubeval.instrumenta.dev'
    ))
    parser.add_argument('--output-directory', default=os.getcwd(), help="Write json-schema files to this directory")
    parser.add_argument('yaml_files', metavar='yaml file', nargs='+', type=argparse.FileType('r'))

    args = parser.parse_args()

    for yaml_file_handle in args.yaml_files:
        process_yaml_file(yaml_file_handle, args.output_directory)
