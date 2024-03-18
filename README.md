
# Terraform-AWSprovider-webserver-configuration


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


⚡Step-1 : (Plugin with AWS provider)

In Terraform, the "terraform" block is a mandatory block that is used to define Terraform-specific settings and configurations for a Terraform project,

required_providers: To plugin with provider

required_version: specifies the minimum Terraform version required to apply the configuration.

![pro-plugin](https://github.com/Pratikshinde55/Terraform-AWSprovider-webserver-configuration/assets/145910708/252be755-95e4-462a-a4fc-d16d11b9b7c2)


⚡Step-2 :(AWS login-credentials)

Here i use "AWS CLI " tool for login , for this i create IAM user on AWS & get access_key, secret_key and paste on cli .Use Default profile:

![acees-aws-cli](https://github.com/Pratikshinde55/Terraform-AWSprovider-webserver-configuration/assets/145910708/011c43cd-e582-4ef1-be97-e6a494095077)

Now , Create provider block:


    #notepad provider_cre.tf
    
"aws" is the name of the provider. This name must match the provider's name specified in the required_providers block.

region specifies the AWS region,

profile specifies the name of the AWS profile, Terraform will use the access key ID and secret access key associated with this profile for authentication.

![login-terrs](https://github.com/Pratikshinde55/Terraform-AWSprovider-webserver-configuration/assets/145910708/da4df432-6953-4e43-999e-f2301a956dce)


⚡Step-3 : (terraform init)

"terraform init" command initializes a Terraform working directory, installing necessary plugins and initializing backend configurations.


       #terraform init

 ![teraf](https://github.com/Pratikshinde55/Terraform-AWSprovider-webserver-configuration/assets/145910708/02a301de-75e0-4bde-8d33-bbfd7f03fd7f)


 ⚡Step-4 : (EC2-instance block)

ami : specifies the Amazon Machine Image (AMI) ID to use for launching the EC2 instance.

key_name : This specifies the name of the key pair to use for SSH authentication when accessing the EC2 instance.

vpc_security_group_ids : Security groups control inbound and outbound traffic to the instance.

instance_type : This specifies the instance type for the EC2 instance.


      #notepad resource_ec2.tf

![ec2-file](https://github.com/Pratikshinde55/Terraform-AWSprovider-webserver-configuration/assets/145910708/ffea9e24-62b9-4738-9668-efb83635eacf)


⚡Step-5 :(variable for resources)

Here i put varibles which call in resource.

"default" : attribute specifies the default value.

"type" : The type attribute specifies the "type" of the variable, which is string.


      #notepad variables.tf

![variable-tera](https://github.com/Pratikshinde55/Terraform-AWSprovider-webserver-configuration/assets/145910708/79721873-987a-449f-a5f2-0bca02401de8)

 























