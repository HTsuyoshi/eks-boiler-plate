#!/bin/bash

terraform-docs markdown table --output-file README.md --output-mode inject './'

modules=("ansible" "bastion" "eks" "network")

for v in "${modules[@]}"; do
    terraform-docs markdown table --output-file README.md --output-mode inject "./modules/${v}"
done

