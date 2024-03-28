
# "Automating AWS Infrastructure Deployment and Configuration with Terraform"


![Screenshot 2024-03-18 155915](https://github.com/Pratikshinde55/Terraform-AWSprovider-webserver-configuration/assets/145910708/457bebee-36f7-4817-8f79-2677c334bd45)

🌟Terraform :(IaC)

Terraform is a tool used for managing infrastructure as code,Terraform can easily create, update, and delete infrastructure resources using a declarative configuration language. It supports multiple cloud providers like AWS, Azure, and Google Cloud Platform, as well as on-premises solutions. This vendor-neutral approach gives you flexibility and consistency in managing your infrastructure across different environments.

🌟vendor-neutral: 

Terraform is vendor-neutral, meaning it supports multiple cloud providers, as well as on-premises infrastructure providers, without locking you into a specific vendor's ecosystem.

🌟Declarative Configuration Language:

Terraform uses a declarative language called HashiCorp Configuration Language (HCL) to define infrastructure resources and their configurations.


🌟Terraform Registry : "registry.terrafrom.io"

The Terraform Registry is a centralized repository for discovering, sharing, and managing Terraform modules and providers.


❄️Using Terraform, plugin with AWS provider & Configure Webserver ❄️ 

I installed Terraform in my Local machine , 'Terraform Binary download for window 386

(link: https://developer.hashicorp.com/terraform/install#windows)

To check terraform is installed or not :


     #terraform version


Create Folder and here i put my HCL code:

![Screenshot 2024-03-17 175311](https://github.com/Pratikshinde55/Terraform-AWSprovider-webserver-configuration/assets/145910708/9cd9079a-0af4-4743-ab05-74366dc5865f)


⚡Step-1 : (Plugin with AWS provider)⚡

In Terraform, the "terraform" block is a mandatory block that is used to define Terraform-specific settings and configurations for a Terraform project,

required_providers: To plugin with provider

required_version: specifies the minimum Terraform version required to apply the configuration.

![pro-plugin](https://github.com/Pratikshinde55/Terraform-AWSprovider-webserver-configuration/assets/145910708/252be755-95e4-462a-a4fc-d16d11b9b7c2)


⚡Step-2 :(AWS login-credentials)⚡

Create "IAM" user in AWS console & attach "PowerUseraAccess".

![Screenshot 2024-03-26 204826](https://github.com/Pratikshinde55/Terraform-AWS-EC2_EBS_provisioner/assets/145910708/492fb75c-82e3-4807-8e86-7f02b4017c6a)

Go to created user in my case "pratikuser" , Click on access key & press "create access key" .

'Use case' interface show select "application running on aws compute service". Here get access_key, secret_key ,copy this keys.


![Screenshot 2024-03-26 205028](https://github.com/Pratikshinde55/Terraform-AWS-EC2_EBS_provisioner/assets/145910708/f5206676-d631-41fd-87d9-c5b795bf75d1)


Here i use "AWS CLI " tool for login , for this i create IAM user on AWS & get access_key, secret_key and paste on cli .Use Default profile:
(static credential)

![acees-aws-cli](https://github.com/Pratikshinde55/Terraform-AWSprovider-webserver-configuration/assets/145910708/011c43cd-e582-4ef1-be97-e6a494095077)

Now , Create provider block:


    #notepad provider_cre.tf
    
"aws" is the name of the provider. This name must match the provider's name specified in the required_providers block.

region specifies the AWS region,

profile specifies the name of the AWS profile, Terraform will use the access key ID and secret access key associated with this profile for authentication.

![login-terrs](https://github.com/Pratikshinde55/Terraform-AWSprovider-webserver-configuration/assets/145910708/da4df432-6953-4e43-999e-f2301a956dce)


⚡Step-3 : (terraform init)⚡

"terraform init" command initializes a Terraform working directory, installing necessary plugins and initializing backend configurations.


       #terraform init

 ![teraf](https://github.com/Pratikshinde55/Terraform-AWSprovider-webserver-configuration/assets/145910708/02a301de-75e0-4bde-8d33-bbfd7f03fd7f)


 ⚡Step-4 : (EC2-instance block)⚡

ami : specifies the Amazon Machine Image (AMI) ID to use for launching the EC2 instance.

key_name : This specifies the name of the key pair to use for SSH authentication when accessing the EC2 instance.

vpc_security_group_ids : Security groups control inbound and outbound traffic to the instance.

instance_type : This specifies the instance type for the EC2 instance.


      #notepad resource_ec2.tf

![ec2-file](https://github.com/Pratikshinde55/Terraform-AWSprovider-webserver-configuration/assets/145910708/ffea9e24-62b9-4738-9668-efb83635eacf)


⚡Step-5 :(variable for resources)⚡

Here i put varibles which call in resource.

"default" : attribute specifies the default value.

"type" : The type attribute specifies the "type" of the variable, which is string.


      #notepad variables.tf

![variable-tera](https://github.com/Pratikshinde55/Terraform-AWSprovider-webserver-configuration/assets/145910708/79721873-987a-449f-a5f2-0bca02401de8)

 
⚡Step-6 : (create 'ebs' volume and 'attached' with 'ec2')⚡

"aws_ebs_volume" : this is resource type for create EBS volume.
 
 availability_zone = It is attribute that define zone where we want to create EBS volume such as ap-south-1a ,ap-south-1b , ap-south-1c.
 here use attribute referance 'aws_instance.os1.availability_zone' it means after launching EC2 instance it automatically take its  availability_zone.

 size = Size attribute  specifies size of volume .

 tag = tags attribute specifies the tags to apply to the EBS volume.
 
 "aws_volume_attachment" : It is resource Type for attaching EBS volume to EC2 instance.

 device_name = device_name attribute specifies the device name on the EC2 instance where the EBS volume will be attached.(this name for in EC2 instance view)

 volume_id = The volume_id attribute specifies the ID of the EBS volume to attach. & here use "attribute references" it means when EBS_volume craete this 
   attribute references automatic take volume id.

 instance_id : The volume_id attribute specifies the ID of the EBS volume to attach, & here i use "attribute references" aws_instance.os1.id it defines 
 when instance launch it automatically take instance id.


     #notepad resource_ebs.tf


![ebs-tera](https://github.com/Pratikshinde55/Terraform-AWSprovider-webserver-configuration/assets/145910708/4273526b-8987-4d70-98c8-e5404d2bba5f)
 

⚡Step-7 : (Configuration-install httpd and start service)⚡

"null_resource" : It is a type of resource that doesn't correspond to any specific infrastructure component.
 A "null_resource" in Terraform is like an empty container that allows you to execute custom commands or scripts without directly creating any infrastructure. 
 It's useful for performing tasks like initializing configurations or running commands on local or remote systems.

 connection = is sub block in null resource where put connection information. 
 
 private_key = file("C:/psAWS.pem") : here write of my private key which is used to create instance and which instance want to connect by ssh.

 host = is attribute where put public ip of instance & here use attribute referance aws_instance.os1.public_i

 provisioner  : It is sub block and use "remote-exec" provisioner type for remote configuration.

  inline = The inline attribute contains a list of commands to be executed.

  depends_on = The depends_on attribute specifies that this null_resource depends on the completion of the resource defined by aws_volume_attachment.my_ec2_ebs
 
     
     #notepad null_httpd.tf


![null-httpd](https://github.com/Pratikshinde55/Terraform-AWSprovider-webserver-configuration/assets/145910708/4ac99df2-c457-45fd-b381-36b15ce28c5a)


⚡Step-8 : (mount ebs volume & Deploy webpage)⚡

Here use null_resource for provisioner remote configuration,

 provisioner inline [] =  inline attribute,it formats the attached EBS volume (sudo mkfs.exf4 /dev/sdh/), mounts it to a directory (sudo mount /dev/xvdh 
 /var/www/html), and creates an index.html file with the content "Hi welcome..." in the mounted directory (sudo sh -c 'echo "Hi welcome..." > 
 /var/www/html/index.html').

depends_on = it is attribute, Here give referance this null resource run only when ec2 and EBS volume ia attached  aws_volume_attachment.my_ec2_ebs. 


    #notepad null_resource.tf

![null-volume-webpage](https://github.com/Pratikshinde55/Terraform-AWSprovider-webserver-configuration/assets/145910708/c5355acf-d075-458d-bff5-376641d77594)

⚡Step-9 : (use local-exec provisioner)⚡

Here use null resource & sub block is  provisioner and provisioner type is "local-exec".

when = The when attribute is set to "destroy", specifying that the command should be executed only when the resource is being destroyed.

command = The command attribute specifies the command to be executed locally when the resource is destroyed.(when terrafrom destroy use then it automatically save file in local machine)


    #notepad null_resource_local.tf

![destroy](https://github.com/Pratikshinde55/Terraform-AWSprovider-webserver-configuration/assets/145910708/4df26a8b-df40-4de4-9954-a60c893892f7)


⚡Step-10 : (Terraforn apply)⚡

now apply terraform in one command the whole infrastructure and configuration.

Note:

Null is one kind of provider to use null resource need to install null ,


    #terraform init -upgrade

command for syntax is correct or not :


    #terraform validate

command for check plan :


    #terraform plan

command for run file :


     #terraform apply
     #terraform.exe apply

command for run file with non-interactive :


      #terraform apply -auto-approve

![terraform-applycmd](https://github.com/Pratikshinde55/Terraform-AWSprovider-webserver-configuration/assets/145910708/e6e33887-6bd3-4ff4-aa95-714d49567340)


💫complete formation of infrastucture and configuration:💫

check on Browser (public ip of instance)

 ![Screenshot 2024-03-17 201220](https://github.com/Pratikshinde55/Terraform-AWSprovider-webserver-configuration/assets/145910708/346cf40e-f297-427d-bb13-63b9ef5d7630)


Here :
On AWS console see instance and volume created:

![Screenshot 2024-03-17 200520](https://github.com/Pratikshinde55/Terraform-AWSprovider-webserver-configuration/assets/145910708/5f30561e-71b3-4af9-a671-3b4d017da2b7)


 ![Screenshot 2024-03-17 200443](https://github.com/Pratikshinde55/Terraform-AWSprovider-webserver-configuration/assets/145910708/f558e46b-2637-443b-a059-120589cd7f20)



💥After destroy 💥

After terraform destroy command use then automatically local-exec provisioner run and store file in local machine .


     #terraform destroy
     
![Terraform-destry](https://github.com/Pratikshinde55/Terraform-AWSprovider-webserver-configuration/assets/145910708/af017c5e-7c3b-4ea2-b0c1-e15ee3d4875b)



☀️ All files put in same folder then run all set-up:

![list-tera-manifest](https://github.com/Pratikshinde55/Terraform-AWSprovider-webserver-configuration/assets/145910708/419d7b2d-b7da-4b9c-bf9c-de47d0bc0d69)


Here, terraform.tfstate file automatic created by terraform: in this file state are collected (current state )
