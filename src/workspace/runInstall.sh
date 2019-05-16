#!/bin/bash
set -e

cp -R ../stages/stage1/* .
terraform init
terraform apply -auto-approve

cp -R ../stages/stage2/* .
terraform init
terraform apply -auto-approve

cp -R ../stages/stage3/* .
terraform init
terraform apply -auto-approve

cp -R ../stages/stage4/* .
terraform init
terraform apply -auto-approve
