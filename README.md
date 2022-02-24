# WordPress AWS with Terrform

#### With this repo you can create highly available Wordpress installation on AWS

It's going to deploy the following resources:
1. VPC
2. Subnets, routing tables, Internat Gateway, NAT Gateway
3. Aplication Load Balancer
4. Elastic File System
5. EC2 instances for Bastion host, Web servers, MySQL server

## Usage

The variables used for database password and AWS credentials are imported from enviroment variable, since they are sensitive information. Do not forget to define them prior to deployment.

```
TF_VAR_db_password
TF_VAR_aws_access_key
TF_VAR_aws_secret_key
```

1. git clone https://github.com/stefan-kolev/aws-ha-wordpress.git
2. cd aws-ha-wordpress
3. export TF_VAR_db_password=some_secret_password
4. export TF_VAR_aws_access_key=your_aws_access_key
5. export TF_VAR_aws_secret_key=your_aws_secret_key
6. terraform init
7. terraform plan
8. terraform apply -auto-approve

#### After terraform succesfully deploys all resources you will get the Wordpress's URL as output from terraform:
