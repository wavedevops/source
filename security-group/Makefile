apply:
	rm -rf .terraform
	terraform init -backend-config=state.tfvars
	terraform apply -auto-approve
	rm -rf .terraform .terraform.lock.hcl
destroy:
	terraform destroy -auto-approve
