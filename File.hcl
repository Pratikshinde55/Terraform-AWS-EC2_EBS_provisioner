#"Automating AWS Infrastructure Deployment and Configuration with Terraform"

# "File for plugin with AWS provider"
# File name:-- provider_aws.tf
terraform {
     required_providers {
         aws = {
            source =  "hashicorp/aws"
            version = "~> 4.16"
           }
      }
}



# "File for login with AWS , i use AWS CLI tool for local access and secret key access:"
# File name:-- provider_cre.tf
provider "aws" {
        region = "ap-south-1"
        profile = "default"

}



#"Varibles for resource atribute"
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



#Launch EC2 instance 
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



# file name:-- cat resource_ebs.tf
# "create ebs volume and attach with ec2"
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



# File name:--- null_httpd.tf
#null resource for" httpd install and start service"
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




# File name:-- " null_resource.tf"
# null resource  for creating webpage and mount folder
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


# File name :--  "null_resource_loacl.tf"
# local configuration - "local-exec" <<--- this work when destroy setup
resource "null_resource" "localCALL" {

       provisioner "local-exec" {
            when = destroy
            command = "echo hi setup is destroying and it will destroyed.... > destroyCall.txt"
       }
}


