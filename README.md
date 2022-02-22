# Ansible for Azure

[Ansible](https://www.ansible.com/) playbooks and roles for Azure.

Use [Ansible Lint](https://ansible-lint.readthedocs.io/en/latest/usage.html) to check the roles.

## Setting Up

Ansible requires Python 3. You may run Ansible on Linux, macOS or WSL.

To set up Ansible, run these commands in a terminal window:

    pip3 install --user pipx
    pipx install ansible --include-deps
    pipx inject ansible pywinrm
    ansible-galaxy install -r requirements.yml
    pipx runpip ansible install -r $HOME/.ansible/collections/ansible_collections/azure/azcollection/requirements-azure.txt

To install Ansible Lint, run these commands in a terminal window:

    pipx install ansible-lint
    pipx inject ansible-lint ansible-core yamllint

## Connecting to Azure

### Service Principal

To run operations with Ansible, you need a Service Principal in Azure Active Directory. This Service Principal must be a member of the *Contributors* role on the subscriptions in Azure.

Set the service principal details in either the configuration file *$HOME/.azure/credentials*, or as environment variables:

- AZURE_CLIENT_ID
- AZURE_SECRET
- AZURE_SUBSCRIPTION_ID
- AZURE_TENANT

### Certificates for WinRM

You also need certificates to connect to Windows Virtual Machines with WinRM. The roles for deploying Windows Virtual Machines enable access for WinRM, with certificates from an Azure Key Vault.

> To install a certificate for WinRM on a Virtual Machine from a Key Vault, it must be uploaded as [a JSON object](https://docs.microsoft.com/en-us/javascript/api/@azure/arm-compute/winrmlistener?view=azure-node-latest).

### Configuring the Inventories

This project includes one dynamic inventory for Azure. This inventory is *inventories/azure_rm.yml*.

Enter this command for documentation on dynamic inventory configuration files:

    ansible-doc -t inventory azure_rm

## Usage

> Use the *localhost* inventory to run commands on Azure APIs.

To create an empty resource group:

    ansible-playbook -i inventories/localhost ./apply_resource_group.yml --extra-vars "group_name=test-0030-rg location=uksouth"

To delete a resource group and all of the resources in it:

    ansible-playbook -i inventories/localhost ./delete_resource_group.yml --extra-vars "group_name=test-0030-rg location=uksouth"

To deploy an Azure Key Vault:

    ansible-playbook -i inventories/localhost ./apply_key_vault.yml --extra-vars "@examples/extra_vars/example_az_key_vault.yml"

To deploy a Windows VM:

    ansible-playbook -i inventories/localhost ./deploy_public_windows_vm.yml --extra-vars "@examples/extra_vars/example_windows_vm.yml"

### Running Playbooks on Azure Virtual Machines

To list the available Virtual Machines, use the *azure_rm.yml* dynamic inventory:

    ansible-inventory -i inventories/azure_rm.yml --graph

To test Ansible access to Windows VMs:

    export no_proxy=*
    ansible-playbook --ask-pass --user testadmin -i inventories/azure_rm.yml ./ping_windows_vm.yml

To install developer tools on a Windows VM:

    export no_proxy=*
    ansible-playbook --ask-pass --user testadmin -i inventories/azure_rm.yml ./apply_windows_devtools.yml

## Testing

Run *ansible-lint* to check the roles:

    ansible-lint roles

Always use *syntax-check* to validate a playbook before you run it:

    ansible-playbook --syntax-check apply_resource_group.yml

To carry out a dry-run of a playbook, use *--check* to enable *check mode*:

    ansible-playbook --check apply_resource_group.yml

## Resources

- [Azure Documentation for Ansible](https://docs.microsoft.com/en-us/azure/developer/ansible/)
- [Ansible Collection for Azure](https://docs.ansible.com/ansible/latest/collections/azure/azcollection/)
- [Azure Resource Manager templates](https://docs.microsoft.com/en-gb/azure/azure-resource-manager/templates/)
- [Set up WinRM access for an Azure VM](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/winrm)
- [How to Set up PSRemoting with WinRM and SSL](https://adamtheautomator.com/winrm-ssl/)
- [Configure Powershell WinRM to use OpenSSL generated Self-Signed certificate](http://vcloud-lab.com/entries/powershell/configure-powershell-winrm-to-use-openssl-generated-self-signed-certificate)
