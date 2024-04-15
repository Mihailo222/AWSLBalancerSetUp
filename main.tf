resource "aws_vpc" "myvpc" {
 cidr_block = var.cidr  
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id  
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id  

  }
}

resource "aws_subnet" "sub1" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.sub1_cidr
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true 

}

resource "aws_subnet" "sub2" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.sub2_cidr 
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true 
}


resource "aws_route_table_association" "rta1" {
  subnet_id = aws_subnet.sub1.id
  route_table_id = aws_route_table.rt.id
}



resource "aws_route_table_association" "rta2" {
  subnet_id = aws_subnet.sub2.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "mysg" {
  name_prefix = "websg"
  vpc_id = aws_vpc.myvpc.id

  ingress {
    description = "HTTP for VPC"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress  {
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}

resource "aws_s3_bucket" "s3bck" {
  bucket = "our_terraform_bucket_for_project"
}

resource "aws_instance" "webServerOne" {
  ami = var.ubuntu_ami
  instance_type = var.instance
  vpc_security_group_ids = [aws_security_group.mysg.id]
  subnet_id = aws_subnet.sub1.id
  user_data = base64decode(file(machine1.sh))
}

resource "aws_instance" "webServerTwo" {
  ami = var.ubuntu_ami
  instance_type = var.instance
  vpc_security_group_ids = [aws_security_group.mysg.id]
  subnet_id = aws_subnet.sub2.id
  user_data = base64decode(file(machine2.sh))
}

#load balancer - L7 lb


resource "aws_lb" "mylb" {
  name = "mylb"
  internal = false #
  load_balancer_type = "application"

  security_groups = [aws_security_group.mysg.id]
  subnets = [aws_subnet.sub1.id, aws_subnet.sub2.id]

  tags = {
    Name = "web"
  }
}

#target grupa kojoj se obraca lb i koja prosledjuje request do resursa
resource "aws_lb_target_group" "tg" {
  name = "myTG"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.myvpc.id

  health_check {
    path = "/"
    port = "traffic-port"
  }
}

#attach boath web servers to a load balancer target group
resource "aws_lb_target_group_attachment" "attach1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id = aws_instance.webServerOne.id
  port = 80
}

resource "aws_lb_target_group_attachment" "attach2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id = aws_instance.webServerTwo
  port = 80
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.mylb
  port = 80
  protocol = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.tg.arn
    type="forward"
  }
}










