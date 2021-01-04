provider "aws" {
  version = "~> 3.0"
  region  = var.region
}

resource "aws_db_instance" "od-database" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "sqlserver-ee"
  license_model        = "license-included"
  instance_class       = "db.t3.xlarge"
  username             = var.dbUsername
  password             = var.dbPassword
  db_subnet_group_name = var.subnetGroup
  skip_final_snapshot  = true
}

output "endpoint" {
  value = aws_db_instance.od-database.endpoint
}