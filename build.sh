#!/bin/bash

WORKDIR=$(pwd)
TF_DIR=$WORKDIR/terraform/template

function ansible-playbook() {
  ansible-playbook $1 -i $TF_DIR/tf-inventory.ini --ask-vault-pass
  # may not work after initial playbook run
  if [ $? -ne 0 ]; then
    ansible-playbook $1 -i $TF_DIR/tf-inventory.ini --ask-vault-pass
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
cd ansible
ansible-playbook web-db.yml

echo
echo
echo "Instances have been provisioned and configured successfully!"
echo
echo "Installing WordPress on Webservers..."
ansible-playbook wp.yml
echo
echo
echo "Wordpress has been installed successfully!"


