provider "aws" {
  region = "sa-east-1"
}

resource "aws_key_pair" "k8s-key" {
  key_name = "k8s-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDebnUNi8cZyersnoGfXkyRDGYVXRtdX2/0ySF0T5uHlZiHk/tnvzOS+o0cBcQLyPZHpxLUHKEFEHlm4EvN12T+ZpANNeP3Vu7mauzGdnK1RmvwMAaTnbIrT4dwXeJvTBaCVhHvXIQOyDqiszUxv3ECG9TeN177l9meo8rG/6L+7y3MJKYsYZ7Wu3Pe7fPp2Uqy1t0dUnSm2SF4mIUIY1FB/Z7MSQ9N4BkvvVsFQ2QhdIFk76KjZib9UcPJhXCXzk6J3jpL/nVnZfo1VmJCey/s3SSEkXydjUm3lyDBwESAiFt193TegsN4qKDs2EzgJb4t0PeaCIuJoX7X/T8kHnh2b1t7Qs8P/5X3sSmGg7qE9VQG3+FOZPe1SP4Jj1CZKbrSM6r2VdFnb1Ih/UyPqkXZkC71MUnWNqMhnj1oNKCCDRxLEIOkfY/r/aVxA0Yjk+vcSN4+5tU4dXwlAGt10uirIF/Lj6vS49juDkwBRGM+uRtNDA4w1RR6Yl11uPVRQk8gTG1JWSArAy8C1goaglv5dzbH/GOhCTZaMTJJaGrAilENpASi+r04EFR0ZusDos8LuMGPjlArgI8URu+A0tubfD8ZMfOXNRBUcbOwXytCpzq0oWZNlZtkQlA6qEBe3DOfyd2jzpvqjnhtNaFmBLdPLeyzmDOvwgDGt4M0kEjtew== rafael@LAPTOP-G30P01EC"
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
  ami       = "ami-04473c3d3be6a927f"
  instance_type = "t2.micro"
  key_name = "k8s-key"
  count = 2
  tags = {
    name = "k8s"
    type = "worker"
  }
  security_groups = ["${aws_security_group.k8s-sg.name}"]
}

resource "aws_instance" "kubernetes-master" {
  ami       = "ami-04473c3d3be6a927f"
  instance_type = "t2.micro"
  key_name = "k8s-key"
  count = 1
  tags = {
    name = "k8s"
    type = "master"
  }
  security_groups = ["${aws_security_group.k8s-sg.name}"]
}