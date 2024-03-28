###..."Automating AWS Infrastructure Deployment and Configuration with Terraform"...###

################ "File for plugin with AWS provider"#####################
                 # File name:-- provider_aws.tf
terraform {
     required_providers {
         aws = {
            source =  "hashicorp/aws"
            version = "~> 4.16"
           }
      }
}



#################### "File for login with AWS , i use AWS CLI tool for local access and secret key access:"##########
                    # File name:-- provider_cre.tf
provider "aws" {
        region = "ap-south-1"
        profile = "default"

}



############################"Varibles for resource atribute"###############################
                           #file name:-- variables.tf
variable "amiID" {
      default = "ami-013168dc3850ef002"
}

variable "instanceName" {
  default = "myterraformOS"
}

variable "ebsName" {
  default = "myebs_pratik"
  type    = string
}



######################### File for Launch EC2 instance  ####################### Note : give own "vpc_security_group_ids", and also key name
                         # File name:-- resource_ec2.tf
resource "aws_instance" "os1" {
      ami = var.amiID
      key_name = "psAWS"
      vpc_security_group_ids = ["sg-0f26bac4363bd94df"]
      instance_type = "t2.micro"
      tags = {
         name = var.instanceName
      }
}



######################### "create ebs volume and attach with ec2" ###########################
                         # file name:-- cat resource_ebs.tf
resource "aws_ebs_volume" "myvol" {
  availability_zone = aws_instance.os1.availability_zone
  size             = 1
  tags = {
    name = var.ebsName
  }
}
resource "aws_volume_attachment" "my_ec2_ebs" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.myvol.id
  instance_id = aws_instance.os1.id
}



######################### "Using null_resource & provisioner for httpd install and start service"##########################  
                         # File name:--- null_httpd.tf
                         # NOTE --- "# terraform init -upgrade "  << -- file upgarte terraform will update the dependency lock file
resource "null_resource" "Ec2_config" {
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("C:/psAWS.pem")
    host        = aws_instance.os1.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd -y",
      "sudo systemctl enable httpd --now"
    ]
  }

  depends_on = [
    aws_volume_attachment.my_ec2_ebs
  ]
}




################################# "null resource and provisioner for creating webpage and mount folder" ###############################
                                #    File name:-- " null_resource.tf"
resource "null_resource" "volumenull" {
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("C:/psAWS.pem")
    host        = aws_instance.os1.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkfs.exf4  /dev/sdh/",
      "sudo mount /dev/xvdh /var/www/html",
      "sudo sh -c 'echo \"Hi welcome...\" > /var/www/html/index.html'"
    ]
  }

  depends_on = [
    aws_volume_attachment.my_ec2_ebs
  ]
}


######################### "local configuration - "local-exec" provisioner <<--- this work when destroy setup" #############################
                        # File name :--  "null_resource_loacl.tf"
resource "null_resource" "localCALL" {

       provisioner "local-exec" {
            when = destroy
            command = "echo hi setup is destroying and it will destroyed.... > destroyCall.txt"
       }
}


