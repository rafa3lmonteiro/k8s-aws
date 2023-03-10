provider "aws" {
  region = "sa-east-1"
}

resource "aws_key_pair" "k8s-key" {
  key_name = "k8s-key"
  public_key = file("${path.module}/id_rsa.pub")
}

resource "aws_security_group" "k8s-sg" {
  
    ingress { 
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self = true
  }
  
    ingress { 
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }
  
}

resource "aws_instance" "kubernetes-worker" {
  ami       = "ami-019e9884d49f70483"   
  instance_type = "t2.micro"
  key_name = "k8s-key"
  count = 2
  tags = {
    Name = "k8s-worker-${count.index}"
    type = "worker"
    env = "k8s"
  }
  security_groups = ["${aws_security_group.k8s-sg.name}"]
}

resource "aws_instance" "kubernetes-master" {
  ami       = "ami-019e9884d49f70483"   
  instance_type = "t2.micro"
  key_name = "k8s-key"
  count = 1
  tags = {
    Name = "k8s-master-${count.index}"
    type = "master"
    env = "k8s"
  }
  security_groups = ["${aws_security_group.k8s-sg.name}"]
}

output "k8s-master" {
  value = aws_instance.kubernetes-master[*].public_ip
}

output "k8s-worker" {
  value = aws_instance.kubernetes-worker[*].public_ip
}

