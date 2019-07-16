#!/usr/bin/env bash

terraform init
terraform apply -auto-approve

ls -d ../stages/stage* | while read stage; do
    echo "Running stage: $(basename ${stage})"

    cp -R ${stage}/* .

    terraform init
    terraform apply -auto-approve
done
