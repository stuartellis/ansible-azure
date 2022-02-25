# Ansible for Azure

This project enables [Ansible](https://www.ansible.com/) on Azure.

## Setting Up

Ansible requires Python 3. You may run Ansible on Linux, macOS or WSL.

To set up Ansible, run these commands in a terminal window:

    pip3 install --user -r requirements-ansible.txt
    ansible-galaxy install -r requirements.yml
    pip3 install --user -r $HOME/.ansible/collections/ansible_collections/azure/azcollection/requirements-azure.txt

> Some Microsoft tasks for Ansible are currently not compatible with pipx and other Python environment isolation tools. For this reason, we install Ansible and the required Python modules to your home directory.

To set up code checks for development, run *npm install*:

    npm install

## Connecting to Azure

### Service Principal

To run operations with Ansible, you need a Service Principal in Azure Active Directory. This Service Principal must be a member of the *Contributors* role on the subscriptions in Azure.

Set the service principal details in either the configuration file *$HOME/.azure/credentials*, or as environment variables:

- AZURE_CLIENT_ID
- AZURE_SECRET
- AZURE_SUBSCRIPTION_ID
- AZURE_TENANT

## Usage

This project uses the dynamic inventory *inventories/azure_rm.yml*. The dynamic inventory automatically finds the virtual machines on Azure. It defines groups of computers by location and tags. These groups can be used as targets for Ansible commands.

## Querying Virtual Machines

To list the available Virtual Machines:

    ansible-inventory -i inventories/azure_rm.yml --graph

To test Ansible access to Windows VMs on Azure:

    ansible-playbook --ask-pass --user testadmin -i inventories/azure_rm.yml ./ping_windows_vm.yml

## Running Commands on Computers

Use playbooks to define a set of commands. For example, this project includes the playbook *apply_windows_devtools* to install and update a collection of standard developer tools on the target Windows computers, and the playbook *apply_windows_updates.yml* to run Windows Update on target computers.

To carry out a dry-run of a playbook, use *--check* to enable *check mode*:

    ansible-playbook --ask-pass --user testadmin --check -i inventories/azure_rm.yml ./apply_windows_updates.yml

To run a playbook on the target computers, use *ansible-playbook* without *--check*:

    ansible-playbook --ask-pass --user testadmin -i inventories/azure_rm.yml ./apply_windows_updates.yml

## Deploying New Virtual Machines on Azure

To deploy a new Windows VM:

    ansible-playbook -i inventories/localhost ./deploy_public_windows_vm.yml --extra-vars "@examples/answers/example_windows_vm.yml"

This playbook creates copies of the WinRM server certificates for new virtual machines in the *tmp/* directory of this project.

## Working with Azure Resource Groups

> We use the *localhost* inventory to run commands on Azure itself.

To create an empty resource group:

    ansible-playbook -i inventories/localhost ./deploy_resource_group.yml --extra-vars "group_name=test-0030-rg location=uksouth"

To delete a resource group and all of the resources in it:

    ansible-playbook -i inventories/localhost ./delete_resource_group.yml --extra-vars "group_name=test-0030-rg location=uksouth"

## Deploying Other Azure Resources

This project also includes playbooks for deploying several types of resources on Azure. These playbooks are useful for setting up resources for testing.

To deploy a Virtual Network:

    ansible-playbook -i inventories/localhost ./deploy_minimal_vnet.yml --extra-vars "@examples/answers/example_minimal_vnet.yml"

To deploy an Azure Key Vault:

    ansible-playbook -i inventories/localhost ./deploy_minimal_key_vault.yml --extra-vars "@examples/answers/example_minimal_key_vault.yml"

To deploy a Storage Account for VM diagnostics:

    ansible-playbook -i inventories/localhost ./deploy_vm_diag_storage.yml --extra-vars "@examples/answers/example_vm_diag_storage.yml"

## Developing Ansible Code

### Tools

Install [Ansible Lint](https://ansible-lint.readthedocs.io/en/latest/usage.html) and [the Visual Studio Code extension for Ansible](https://marketplace.visualstudio.com/items?itemName=redhat.ansible).

To install Ansible Lint, run these commands in a terminal window:

    pipx install ansible-lint
    pipx inject ansible-lint ansible-core yamllint

To check the roles with Ansible Lint:

    ansible-lint roles/

Always use *syntax-check* to validate a new playbook before you run it:

    ansible-playbook --syntax-check deploy_resource_group.yml

### Examples

This project includes examples of using Ansible to deploy ARM templates and run the Azure CLI. See the role *key_vault_secret* for an example of running the Azure CLI in an Ansible task.

### Running New ARM Templates

Use the playbook *deploy_arm_template.yml* to run any ARM template. This may be useful to test ARM templates as you develop roles and playbooks.

## Documentation

### Ansible

- [Azure Documentation for Ansible](https://docs.microsoft.com/en-us/azure/developer/ansible/)
- [Ansible Collection for Azure](https://docs.ansible.com/ansible/latest/collections/azure/azcollection/)

### ARM

- [Azure Resource Manager templates](https://docs.microsoft.com/en-gb/azure/azure-resource-manager/templates/)

### WinRM

- [Set up WinRM access for an Azure VM](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/winrm)
- [How to Set up PSRemoting with WinRM and SSL](https://adamtheautomator.com/winrm-ssl/)
- [Configure Powershell WinRM to use OpenSSL generated self-signed certificate](http://vcloud-lab.com/entries/powershell/configure-powershell-winrm-to-use-openssl-generated-self-signed-certificate)
