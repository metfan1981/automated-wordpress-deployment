#!/bin/bash

WORKDIR=$(pwd)
TF_DIR=$WORKDIR/terraform/template

function play_ansible() {
  cd $WORKDIR/ansible
  ansible-playbook $1 -i $TF_DIR/tf-inventory.ini --vault-password-file=vault_pass
  # may not work after initial playbook run
  if [ $? -ne 0 ]; then
    ansible-playbook $1 -i $TF_DIR/tf-inventory.ini --vault-password-file=vault_pass
  fi
}

cd $TF_DIR
terraform init
terraform apply -auto-approve
# error handling
if [ $? -ne 0 ]; then
  echo "error during TF initialization has occurred!"  
  exit
fi

# Parsing terraform.tfstate to gather hosts' IP addresses and create ansible inventory
cd $WORKDIR
python parser-tfstate.py -p $TF_DIR

# Configure Webserver and DB
play_ansible "web-setup.yml"
play_ansible "db-setup.yml"
if [ $? -eq 0 ]; then
  echo "Instances have been provisioned and configured successfully!"
fi

echo "Installing WordPress on Webservers..."
play_ansible "wordpress-setup.yml"
if [ $? -eq 0 ]; then
  echo "Wordpress has been installed successfully!"
fi

echo "done"
