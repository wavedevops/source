apply:
	terraform init -backend-config=provider.tf
	terraform apply -auto-approve
	rm -rf .terraform
	rm -rf .terraform.lock.hcl


destroy:
	terraform init -backend-config=provider.tf
	terraform destroy -auto-approve
	rm -rf .terraform
	rm -rf .terraform.lock.hcl
