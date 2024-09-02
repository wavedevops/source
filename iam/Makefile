apply:
	terraform init
	terraform apply -auto-approve
	rm -rf .terraform
	rm -rf .terraform.lock.hcl


destroy:
	terraform init
	terraform destroy -auto-approve
	rm -rf .terraform
	rm -rf .terraform.lock.hcl
