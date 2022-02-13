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

## Resources

- [Azure Documentation for Ansible](https://docs.microsoft.com/en-us/azure/developer/ansible/)
- [Ansible Lint](https://ansible-lint.readthedocs.io/en/latest/usage.html)
