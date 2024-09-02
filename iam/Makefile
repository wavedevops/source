dev:
	terraform init -backend-config=state.tfvars
	terraform apply -auto-approve
	rm -rf .terraform
	rm -rf .terraform.lock.hcl


dev-destroy:
	terraform init -backend-config=env-dev/state.tfvars
	terraform destroy -auto-approve -var-file=env-dev/inputs.tfvars
	rm -rf .terraform
	rm -rf .terraform.lock.hcl
