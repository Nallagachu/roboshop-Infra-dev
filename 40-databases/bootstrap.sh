#!/bin/bash
component=$1
env=$2
dnf install ansible -y
ansible-pull -U https://github.com/Nallagachu/ansible-roboshp.git -e component=$component -e env=$env ansible.roles/main.yaml
