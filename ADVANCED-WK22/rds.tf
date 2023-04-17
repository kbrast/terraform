# rds.tf - RDS MySQL instance
resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "my-rds-subnet-group"
  subnet_ids  = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
  description = "Subnets available for the RDS MySQL instance"
}

resource "aws_db_instance" "rds_mysql" {
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  identifier             = "my-rds-mysql-instance"
  db_name                = "my_rds_mysql_instance"
  username               = "admin"
  password               = "password"
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_security_group.id]

  skip_final_snapshot = true  # Add this line to skip creating a final snapshot when deleting the RDS instance

  tags = {
    Name = "My RDS MySQL Instance"
  }
}