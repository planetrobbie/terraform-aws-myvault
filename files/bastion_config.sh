#!/bin/bash

# Wait until boot finish its own apt-get update.
sleep 30

# Latest Ansible install
sudo apt-get install software-properties-common --yes
sudo apt-add-repository --update ppa:ansible/ansible --yes
sudo apt-get install ansible --yes

# Ansible Playbook execution
cd /home/${ssh_user}
/usr/bin/ansible-playbook -i hosts playbook.yml