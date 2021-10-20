# Terraform-Template


## Description

This is a Terraform template for a Terraform Project


## Features

### Makefile

The Makefile has all the commands required.

You can simply run `make` to get all the commands

The available commands are:
- `make help`: Prints the help
- `make docs`: Generates the documentation
- `make precommit`: Runs the tests in `.pre-commit-config.yaml`
- `make checkov`: Runs Checkov on code
- `make infracost`: Gives you an estimate of the cost of your infrastructure
- `make commit`: runs `docs`, `precommit` and `git cz`
- `make plan`: Runs `terraform plan`
- `make apply`: Runs `terraform apply`
- `make install_prerequesites`: Installs the prerequesites for the project
- `make colors`: Prints all the colors available in makefile

There is a `prettier.mk` that is included in the Makefile that adds helper functions to make the Makefile prettier.
