# ansible-azure

Ansible for Azure.

## Installation

> To run Ansible operations, you need a Service Principal in Azure Active Directory. The Service Principal must be a member of the *Contributors* role on subscriptions in Azure.

To set up Ansible on a Linux system:

    pip3 install --user pipx
    pipx install ansible-core
    pipx install ansible-lint
    pipx inject ansible-lint ansible-core yamllint
    ansible-galaxy install -r requirements.yml

## Usage

To list the available Virtual Machines, use the *azure_rm.yml* dynamic inventory:

    ansible-inventory -i azure_rm.yml --graph

To create an empty resource group:

    ansible-playbook --connection=local ./playbooks/apply_resource_group.yml --extra-vars "group_name=test-0030-rg location=uksouth"

To delete a resource group and all of the resources in it:

    ansible-playbook --connection=local ./playbooks/delete_resource_group.yml --extra-vars "group_name=test-0030-rg location=uksouth"

To deploy an Azure Key Vault:

    ansible-playbook --connection=local ./apply_key_vault.yml --extra-vars "@examples/extra_vars/example_az_key_vault.yml"

To deploy a Windows VM:

    ansible-playbook --connection=local ./example_windows_vm.yml --extra-vars "@examples/extra_vars/example_windows_vm.yml"

To install developer tools on a Windows VM:

    no_proxy=*
    ansible-playbook -i azure_rm.yml ./apply_windows_devtools.yml

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
- [Set up WinRM access for an Azure VM](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/winrm)
