#!/bin/bash

WORKDIR=$(pwd)
TF_DIR=$WORKDIR/terraform/template

cd $TF_DIR
terraform init
terraform apply -auto-approve

cd $WORKDIR
python parser-tfstate.py -p $TF_DIR
cd ansible
ansible-playbook web-db.yml -i $TF_DIR/tf-inventory.ini --ask-vault-pass
