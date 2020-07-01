#! /bin/bash

echo ""
echo "Listing current state"
terraform state list

terraform destroy -auto-approve
