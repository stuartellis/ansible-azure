# ansible-azure

Ansible for Azure.

## Installation

> Create a Service Principal in Azure to run Ansible operations.

To set up Ansible on a Linux system:

    pip3 install --user pipx
    pipx install ansible-core
    pipx install ansible-lint
    pipx inject ansible-lint ansible-core yamllint

To add support for Azure:

    ansible-galaxy collection install azure.azcollection
    pipx runpip ansible-core install -r ~/.ansible/collections/ansible_collections/azure/azcollection/requirements-azure.txt

## Usage

To create an empty resource group:

    ansible-playbook --connection=local ./playbooks/apply_resource_group.yml --extra-vars "group_name=test-0030-rg location=uksouth"

To delete a resource group:

    ansible-playbook --connection=local ./playbooks/delete_resource_group.yml --extra-vars "group_name=test-0030-rg location=uksouth"

## Resources

- [Azure Documentation for Ansible](https://docs.microsoft.com/en-us/azure/developer/ansible/)
- [Ansible Lint](https://ansible-lint.readthedocs.io/en/latest/usage.html)
