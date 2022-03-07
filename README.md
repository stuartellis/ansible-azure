# Ansible for Azure

This project enables [Ansible](https://www.ansible.com/) on Azure.

Ansible can run on any computer or group of computers that it finds, provided that WinRM or SSH are enabled on those computers. This project includes a dynamic inventory for Ansible, which automatically groups virtual machines on Azure by location and tags.

## Setting Up

You may run Ansible on Linux or macOS, or in WSL. Ansible requires Python 3.

To set up Ansible, run these commands in a terminal window:

    pip3 install --user -r requirements-ansible.txt
    ansible-galaxy install -r requirements.yml
    pip3 install --user -r $HOME/.ansible/collections/ansible_collections/azure/azcollection/requirements-azure.txt

> Ensure that the *bin* directory for Python is on your PATH. On macOS, this is *$HOME/Library/Python/3.9/bin*.

Some Microsoft tasks for Ansible are currently not compatible with pipx and other Python environment isolation tools. For this reason, these commands install Ansible and the required Python modules to your home directory.

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

## Finding Virtual Machines

To list the available Virtual Machines:

    ansible-inventory -i inventories/azure_rm.yml --graph

## Running a Command on Remote Computers

Ansible provides [specific modules for Windows](https://docs.ansible.com/ansible/latest/collections/ansible/windows/index.html#plugins-in-ansible-windows). For example, *win_command* runs a command on Windows computers, and *win_copy* copies files from your systems to Windows computers.

To run an Ansible task on one computer, use the name of the computer. This command specifies the computer *example-vm-0001*:

    ansible example-vm-0001 --ask-pass --user vmadmin -i inventories/azure_rm.yml -m win_copy -a "src=example.txt dest=C:\Temp"

To run an Ansible task on a group of computers, specify the group. This command specifies the group *tag_environment_dev*:

    ansible tag_environment_dev --ask-pass --user vmadmin -i inventories/azure_rm.yml -m win_copy -a "src=example.txt dest=C:\Temp"

To get information about computers, use *setup*:

    ansible example-vm-0001 --ask-pass --user vmadmin -i inventories/azure_rm.yml -m setup

To check whether Ansible can access Windows computers without making any changes, use *win_ping*:

    ansible example-vm-0001 --ask-pass --user vmadmin -i inventories/azure_rm.yml -m win_ping

## Running Playbooks on Remote Computers

Use playbooks to define a set of commands that execute on a group of computers. This project includes several playbooks.

- *ping_azure_windows* checks that Ansible can connect to all available Windows computers on Azure
- *apply_windows_devtools* installs and updates a collection of standard tools on Windows development machines
- *apply_windows_updates.yml* runs Windows Update on all target computers

To carry out a dry-run of a playbook, use *--check* to enable *check mode*:

    ansible-playbook --ask-pass --user vmadmin --check -i inventories/azure_rm.yml ./apply_windows_updates.yml

To run a playbook on the target computers, use *ansible-playbook* without *--check*:

    ansible-playbook --ask-pass --user vmadmin -i inventories/azure_rm.yml ./ping_azure_windows.yml

Use the [--limit option](https://docs.ansible.com/ansible/latest/user_guide/intro_patterns.html#patterns-and-ansible-playbook-flags) to change which computers a playbook runs on:

    ansible-playbook --ask-pass --user vmadmin -i inventories/azure_rm.yml --limit tag_environment_dev ./ping_azure_windows.yml

If Ansible fails on some computers, it creates a list of these computers as a *.retry* file. You can use *--limit* to run a playbook on the computers where Ansible failed:

    ansible-playbook --ask-pass --user vmadmin -i inventories/azure_rm.yml --limit @apply_windows_updates.retry ./apply_windows_updates.yml

## Deploying New Virtual Machines on Azure

To deploy a new Windows VM:

    ansible-playbook -i inventories/localhost ./deploy_disposable_public_win_vm.yml --extra-vars "@examples/answers/disposable_public_win_vm.yml"

This playbook creates copies of the WinRM server certificates for new virtual machines in the *tmp/* directory of this project.

To deploy a new Linux VM:

    ansible-playbook -i inventories/localhost ./deploy_disposable_public_ubuntu_vm.yml --extra-vars "@examples/answers/disposable_public_ubuntu_vm.yml"

## Working with Azure Resource Groups

> We use the *localhost* inventory to run commands on Azure itself.

To create an empty resource group:

    ansible-playbook -i inventories/localhost ./create_resource_group.yml --extra-vars "resource_group_name=example-hosts-0040-rg location=uksouth"

To create a resource group with resources for testing and prototyping:

    ansible-playbook -i inventories/localhost ./deploy_lab_resource_group.yml --extra-vars "@examples/answers/lab_resource_group.yml"

To delete a resource group and all of the resources in it:

    ansible-playbook -i inventories/localhost ./delete_resource_group.yml --extra-vars "resource_group_name=example-hosts-0040-rg location=uksouth"

## Deploying Other Azure Resources

This project also includes playbooks for deploying several types of resources on Azure. These playbooks are useful for setting up resources for testing.

To deploy a Virtual Network:

    ansible-playbook -i inventories/localhost ./deploy_minimal_vnet.yml --extra-vars "@examples/answers/minimal_vnet.yml"

To deploy an Azure Key Vault:

    ansible-playbook -i inventories/localhost ./deploy_minimal_key_vault.yml --extra-vars "@examples/answers/minimal_key_vault.yml"

To deploy a Storage Account for VM diagnostics:

    ansible-playbook -i inventories/localhost ./deploy_vm_diag_storage.yml --extra-vars "@examples/answers/vm_diag_storage.yml"

## Developing Ansible Code

### Tools

Install [Ansible Lint](https://ansible-lint.readthedocs.io/en/latest/usage.html) and [the Visual Studio Code extension for Ansible](https://marketplace.visualstudio.com/items?itemName=redhat.ansible). The Visual Studio Code extension automatically checks roles and playbooks with Ansible Lint.

To install Ansible Lint, run these commands in a terminal window:

    pipx install ansible-lint
    pipx inject ansible-lint ansible-core yamllint

### Examples

This project includes examples of using Ansible to deploy ARM templates and run the Azure CLI. The roles used by the *deploy_* playbooks provide examples of how to deploy ARM templates. The role *key_vault_secret* provides an example of running the Azure CLI in an Ansible task.

### Running New ARM Templates

Use the playbooks *create_resource_group.yml* and *delete_resource_group.yml* to create and delete resource groups for testing. You can then use the playbook *deploy_arm_template.yml* to deploy any ARM template into your resource groups.

        ansible-playbook -i inventories/localhost ./deploy_arm_template.yml --extra-vars "template_file_path=examples/arm/storage/store-deployment-template.json parameters_file_path=examples/arm/storage/store-deployment-parameters.json deployment_name=example-0010 resource_group_name=example-hosts-0040-rg location=uksouth"

## Documentation

## Ansible with Windows

- [Ansible Collection for Windows](https://docs.ansible.com/ansible/latest/collections/ansible/windows/index.html#plugins-in-ansible-windows)
- [Using Ansible with Windows](https://docs.ansible.com/ansible/latest/user_guide/windows.html)

### Ansible with Azure

- [Azure Documentation for Ansible](https://docs.microsoft.com/en-us/azure/developer/ansible/)
- [Ansible Collection for Azure](https://docs.ansible.com/ansible/latest/collections/azure/azcollection/)

### Azure Resource Manager (ARM)

- [Azure Resource Manager templates](https://docs.microsoft.com/en-gb/azure/azure-resource-manager/templates/)

### Linux with Azure

- [Access to Linux VMs with Key Vault](https://github.com/starkfell/100DaysOfIaC/blob/master/articles/day.68.manage.access.to.linux.vms.using.key.vault.part.1.md)

### WinRM

- [Set up WinRM access for an Azure VM](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/winrm)
- [How to Set up PSRemoting with WinRM and SSL](https://adamtheautomator.com/winrm-ssl/)
- [Configure Powershell WinRM to use OpenSSL generated self-signed certificate](http://vcloud-lab.com/entries/powershell/configure-powershell-winrm-to-use-openssl-generated-self-signed-certificate)
