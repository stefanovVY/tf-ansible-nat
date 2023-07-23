# tf-ansible-nat
Terraform and Ansible Deployment with GitHub Actions

This repository contains code to deploy two EC2 instances with Terraform and configure them using Ansible. The first instance will act as a server for the second instance (client). The server will have internet access and a private network. The second instance will connect to the internet via NAT through the server instance. The server instance will be named "server" and the client instance will be named "client". Both instances will have the default user "sysadmin" and SSHD service enabled. Additionally, there will be a bash script with a cron job that checks the availability of its default gateway (Server- VMNIC2) once a week and provides output in the shell.
Prerequisites

Before you proceed, make sure you have the following installed on your local machine:

    Terraform
    Ansible
    Git
    AWS CLI configured with appropriate access credentials

Deployment Steps
1. Clone the Repository

Clone this repository to your local machine:

git clone https://github.com/penevpt/tf-ansible-nat.git
cd tf-ansible-nat

2. Configure AWS Credentials

Ensure that you have the AWS CLI configured with the necessary credentials to deploy resources on AWS.

3. Deploy EC2 Instances with Terraform

To provision the EC2 instances, use Terraform:
```
cd terraform
terraform init
terraform apply -auto-approve
```
Terraform will prompt you to confirm the deployment. Enter "yes" to proceed with the deployment.
4. Configure Ansible Inventory

After the Terraform deployment is complete, update the Ansible inventory file to include the server and client instances' information:

```
cp ansible/inventory.example.yml ansible/inventory.yml
```
Edit the ansible/inventory.yml file and replace <SERVER_PUBLIC_IP> with the public IP address of the server instance and <CLIENT_PRIVATE_IP> with the private IP address of the client instance.

5. Run Ansible Playbook

Now, run the Ansible playbook to configure the instances:
```
ansible-playbook -i ansible/inventory.yml ansible/server.yml
```
This playbook will install Docker on the server, run a Docker container with Nginx, and perform necessary configurations.

6. Set Up GitHub Actions

GitHub Actions are configured to automatically deploy the infrastructure and run the Ansible playbook when you push changes to the main branch. Ensure you have the necessary AWS credentials set as GitHub Secrets.

7. Access Nginx from Client Instance

You can access the Nginx web server running on the server instance from the client instance using Lynx:
```
ssh sysadmin@<CLIENT_PRIVATE_IP>
sudo apt-get update
sudo apt-get install lynx
lynx <SERVER_PUBLIC_IP>
```
8. Bash Script with Cron Job

The bash script that checks the availability of the default gateway on the client instance and provides output in the shell is already installed. It runs hourly and logs its results.

Clean Up

To clean up and destroy the EC2 instances, run:
```
cd terraform
terraform destroy -auto-approve
```
This will remove all the created resources.


Contributions

Contributions to this repository are welcome. If you find any issues or have suggestions for improvements, feel free to create a pull request.


License

This repository is licensed under the MIT License. See LICENSE for more information.
