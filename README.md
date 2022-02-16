# ansible-azure

Ansible for Azure.

## Installation

> Create a Service Principal in Azure to run Ansible operations.

To set up Ansible on a Linux system:

    pip3 install --user pipx
    pipx install ansible-core
    pipx install ansible-lint
    pipx inject ansible-lint ansible-core yamllint
    ansible-galaxy install -r requirements.yml

## Usage

To create an empty resource group:

    ansible-playbook --connection=local ./playbooks/apply_resource_group.yml --extra-vars "group_name=test-0030-rg location=uksouth"

To delete a resource group and all of the resources in it:

    ansible-playbook --connection=local ./playbooks/delete_resource_group.yml --extra-vars "group_name=test-0030-rg location=uksouth"

To deploy a Windows VM:

    ansible-playbook --connection=local ./example_windows_vm.yml --extra-vars "@examples/example_windows_vm.yml"

## Testing

Run *ansible-lint* to check the roles:

    ansible-lint roles

Always use *syntax-check* to validate a playbook before you run it:

    ansible-playbook --syntax-check --connection=local apply_resource_group.yml

To carry out a dry-run of a playbook, use *--check* to enable *check mode*:

    ansible-playbook --check --connection=local apply_resource_group.yml

## Resources

- [Azure Documentation for Ansible](https://docs.microsoft.com/en-us/azure/developer/ansible/)
- [Ansible Lint](https://ansible-lint.readthedocs.io/en/latest/usage.html)
