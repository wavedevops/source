apply:
	rm -rf .terraform .terraform.lock.hcl
	terraform init -backend-config=state.tfvars
	terraform apply -auto-approve
	rm -rf .terraform .terraform.lock.hcl
destroy:
	terraform init -backend-config=state.tfvars
	terraform destroy -auto-approve
	rm -rf .terraform .terraform.lock.hcl
