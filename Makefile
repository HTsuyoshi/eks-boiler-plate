SHELL := /bin/bash

.PHONY: all setup start ssh stop

all: setup start

setup:
	@echo 'Initializing terraform...'
	@terraform init

start:
	@echo 'Applying terraform...'
	@terraform \
		apply \
		--auto-approve \
		-var-file='development.tfvars' \
		-parallelism=10

ssh:
	@echo 'Trying to reach bastion...'
	@ssh -i ~/.ssh/ec2_aws ubuntu@$$(terraform output | grep bastion_public_ip | cut -d ' ' -f 3 | tr -d '"')

stop:
	@echo 'Destroying terraform...'
	@terraform destroy --auto-approve -var-file='development.tfvars'
