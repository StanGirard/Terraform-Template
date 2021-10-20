DIR_GIT=$(shell sh -c "git rev-parse --show-toplevel")

all: help

##@ Docs Generation
docs: ## Generates Terraform docs for modules
	$(call info_colors,blue,📄 Terraform docs)
	@terraform-docs markdown table --recursive-path ./modules/ --output-file README.md ./modules/
	@terraform-docs markdown table --output-file README.md ./terraform/

##@ Checks
precommit: ## Runs precommit on all files
	$(call info_colors,green,👍 Pre-commit checks)
	@pre-commit run --all-files && echo "Pre-commit checks passed" || echo "Pre-commit checks failed"

checkov: ## Runs Checkov
	$(call info_colors,purple,🚨 Checkov)
	@cd $(DIR_GIT)/terraform && terraform init && \
	terraform plan -out tf.plan && \
	terraform show -json tf.plan  > tf.json && \
	checkov -f tf.json && echo "Checkov Success!" || echo "Checkov Failure!"
	@rm -f $(DIR_GIT)/terraform/tf.json && rm -f $(DIR_GIT)/terraform/tf.plan
	@echo "Checkov Complete & Deleted Files"

infracost: ## Runs Infracost Estimate
	$(call info_colors,purple,🚨 Infra Cost Estimate)
	@cd $(DIR_GIT)/terraform && \
	infracost breakdown --path .

##@ Commit
commit: ## Commits all files
	$(call info_colors,purple,🛍 Commits Changed files)
	@git add .
	@echo "Modified files:"
	@git status -s
	@git cz

force: docs precommit ## Amend all files to last commit & force push to current branch
	@git add .
	$(call info_colors,purple, 🛍 Force push & Commit)
	@git status -s
	@echo -n "Are you sure? [y/N] " && read ans && [ $${ans:-N} = y ]

	@git commit -v --amend --no-edit
	@git push -f

cz: docs precommit commit  ## Runs Docs, precommit and commits

##@ Terraform
plan: ## Plan in the terraform folder
	$(call info_colors,green,🗺 Terraform Plan)
	@cd $(DIR_GIT)/terraform && terraform init && terraform plan

apply: ## Apply in the terraform folder
	$(call info_colors,green,👏 Terraform Apply)
	@cd $(DIR_GIT)/terraform && terraform init && terraform apply



include $(DIR_GIT)/prettier.mk


.PHONY: docs precommit commit force plan apply checkov cz
