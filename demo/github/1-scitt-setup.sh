#!/bin/bash
# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

set -ex 

mkdir -p tmp

SCITT_URL="https://127.0.0.1:8000"

curl -o tmp/cacert.pem "https://ccadb-public.secure.force.com/mozilla/IncludedRootsPEMTxt?TrustBitsInclude=Websites"
scitt governance propose_ca_certs \
    --ca-certs tmp/cacert.pem \
    --url $SCITT_URL \
    --member-key workspace/sandbox_common/member0_privk.pem \
    --member-cert workspace/sandbox_common/member0_cert.pem \
    --development

echo '{ "authentication": { "allow_unauthenticated": true } }' > tmp/configuration.json
scitt governance propose_configuration \
    --configuration tmp/configuration.json \
    --member-key workspace/sandbox_common/member0_privk.pem \
    --member-cert workspace/sandbox_common/member0_cert.pem \
    --development

TRUST_STORE=tmp/trust_store
mkdir -p $TRUST_STORE

curl -k -f $SCITT_URL/app/parameters > $TRUST_STORE/scitt.json
