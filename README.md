# parser-tfstate
Python3.6 script intended to parse terraform.tfstate file to retrieve EC2 public IP addresses and create Ansible inventory file that is ready to work.

# Usage

    terraform apply -auto-approve \ 
    && python parser-tfstate.py \ 
    && ansible-playbook <compose-play.yml> -i tf-inventory.ini
*Where <compose-play.yml> is playbook to deploy Docker containers. More details at https://github.com/metfan1981/ansible/tree/master/docker-plays
