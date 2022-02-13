# ansible-azure

Ansible for Azure.

## Installation

To set up Ansible on a Linux system:

    pip3 install --user pipx
    pipx install ansible-core
    pipx install ansible-lint
    pipx inject ansible-lint ansible-core yamllint

To add support for Azure:

    ansible-galaxy collection install azure.azcollection
    pipx runpip ansible-core install -r ~/.ansible/collections/ansible_collections/azure/azcollection/requirements-azure.txt
