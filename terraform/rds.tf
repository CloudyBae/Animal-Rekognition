# create rds subnet group
resource "aws_db_subnet_group" "animalrekog_db_subnet_group" {
  name       = "animalrekog_db_subnet_group"
  subnet_ids = aws_subnet.private_subnet.*.id

  tags = {
    Name = "animalrekog_db_subnet_group"
  }
}

# create rds mysql db
resource "aws_db_instance" "animalrekog_db" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t2.micro"
  db_name                 = "animalrekog_db"
  username             = "${var.db_username}"
  password             = "${var.db_password}"
  publicly_accessible = false
  storage_type         = "gp2"
  vpc_security_group_ids = [aws_security_group.animalrekog_db_sg.id]
  
  db_subnet_group_name = aws_db_subnet_group.animalrekog_db_subnet_group.name

  tags = {
    Name = "animalrekog_db"
  }
}

# rds security group
resource "aws_security_group" "animalrekog_db_sg" {
  name_prefix = "animalrekog_db_sg"
  vpc_id      = aws_vpc.animalrekog_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }

  tags = {
    Name = "animalrekog_db_sg"
  }
}