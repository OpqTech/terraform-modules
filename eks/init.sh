#!/bin/bash

application=`jq -r '.application' ../config.json`
bucket=`jq -r '.bucket' ../config.json`
ticket=`jq -r '.ticket' ../config.json`
region=`jq -r '.region' ../config.json`
tf_lock=`jq -r '.dynamodb_table' ../config.json`

echo $application
echo $bucket
echo $ticket
echo $region
echo $tf_lock

terraform init -upgrade\
    -backend-config="bucket=$bucket" \
    -backend-config="key=$application/$ticket/eks.tfstate" \
    -backend-config="dynamodb_table=$tf_lock" \
    -backend-config="region=$region" \
    -backend-config="encrypt=true"             