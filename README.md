# Terraform and Ansible Deployment of EC2 with NAT with GHA
Terraform and Ansible Deployment with GitHub Actions

This repository contains code to deploy two EC2 instances with Terraform and configure them using Ansible. The first instance will act as a server for the second instance (client). The server have public and private subnet. The second instance have private subnet only. The first instance is being named "server" and the second instance is being named "client". Both instances have the default user "sysadmin" and SSHD service enabled. Additionally, there is a bash script with a cron job that checks the availability of its default gateway hourly and provides output in the shell.

Prerequisites

Before you proceed, make sure you have the following installed on your local machine:

    Terraform
    Ansible
    Git
    AWS CLI configured with appropriate access credentials

Deployment Steps
1. Clone the Repository

Clone this repository to your local machine:

```
git clone https://github.com/penevpt/tf-ansible-nat.git
cd tf-ansible-nat
```

2. Configure AWS Credentials

Ensure that you have the AWS CLI configured with the necessary credentials to deploy resources on AWS.

3. Deploy EC2 Instances with Terraform

To provision the EC2 instances, use Terraform:
```
terraform init
terraform apply -auto-approve
```
Terraform will prompt you to confirm the deployment. Enter "yes" to proceed with the deployment.

4. Run Ansible Playbook

Now, run the Ansible playbook to configure the instances:
```
ansible-playbook -i ansible/inventory.yml ansible/server.yml ansible/client.yml
```
This playbook will install Docker on the server, run a Docker container with Nginx, and perform necessary configurations.

5. Set Up GitHub Actions

GitHub Actions are configured to automatically deploy the infrastructure and run the Ansible playbook when you push changes to the main branch. Ensure you have the necessary AWS credentials set as GitHub Secrets.

6. Access Nginx from Client Instance

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
terraform destroy -auto-approve
```
This will remove all the created resources.


Contributions

Contributions to this repository are welcome. If you find any issues or have suggestions for improvements, feel free to create a pull request.

References

https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html

License

This repository is licensed under the MIT License. See LICENSE for more information.
