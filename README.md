Step : Initialize and Apply Terraform Configuration
Initialize Terraform

terraform init
Apply the Terraform Plan

terraform apply
This will prompt you to confirm the creation of the resources. Type yes to proceed.

Step : Verify MongoDB Authentication
Connect to the EC2 Instance

ssh -i path/to/your/private-key.pem ec2-user@<instance-public-ip>
Test MongoDB Authentication

mongo -u admin -p password --authenticationDatabase admin
This should connect you to the MongoDB server with the admin user created in the Terraform script.
