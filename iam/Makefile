apply:
	terraform init -backend-config=state.tf
	terraform apply -auto-approve
	rm -rf .terraform
	rm -rf .terraform.lock.hcl


destroy:
	terraform init -backend-config=state.tf
	terraform destroy -auto-approve
	rm -rf .terraform
	rm -rf .terraform.lock.hcl
