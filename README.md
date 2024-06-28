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


> getUsers()
uncaught exception: ReferenceError: getUsers is not defined :
@(shell):1:1
> use admin
switched to db admin
> getUsers()
uncaught exception: ReferenceError: getUsers is not defined :
@(shell):1:1
> show dbs
admin   0.000GB
config  0.000GB
local   0.000GB
> db.createCollection("posts")
{ "ok" : 1 }
> show collections
posts
system.users
system.version
> show dbs
admin   0.000GB
config  0.000GB
local   0.000GB
> use test
switched to db test
> show dbs
admin   0.000GB
config  0.000GB
local   0.000GB
> show collections
> use pink
switched to db pink
> db.createCollection("tommy")
{ "ok" : 1 }
> show users
> use admin
switched to db admin
> show users
{
        "_id" : "admin.admin",
        "userId" : UUID("d945b672-3133-4de4-9fd1-458521c11185"),
        "user" : "admin",
        "db" : "admin",
        "roles" : [
                {
                        "role" : "userAdminAnyDatabase",
                        "db" : "admin"
                }
        ],
        "mechanisms" : [
                "SCRAM-SHA-1",
                "SCRAM-SHA-256"
        ]
}
