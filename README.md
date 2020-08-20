### About
Automated provisioning of EC2 instances (webserver and DB) and configuration using Ansible.


### Prerequisites
- Ansible
- Terraform
- Python 3.6 or higher as default
- Authenticate to AWS via awscli


### Usage
1) Clone repository:
`git clone https://gitlab.com/metfan1981/test-task.git`

2) Edit Terraform template at **terraform/template/main.tf**:
> All of options can be leaved default except of **ssh_key = 'guest'**
> Choose your own SSH public key for AWS instances.

3) Edit **ansible/ansible.cfg**:
> **private_key_file** represents local path to your SSH private key for provisioned instances. 

4) Change default MySQL root password:

`ansible-vault edit ansible/sql_pass.yml`
> Vault password is '**root**'
> Also will be used during playbook run.

5) Run script to automate instances provisioning and configuration:

`./build.sh`


### Cleanup
`cd terraform/template && terraform destroy -auto-approve`

