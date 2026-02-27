# rds.tf defines the postgres database where all processed results will reside

resource "aws_db_instance" "postgres" {
    # the goal here is to tell AWS how to reference this database instance in the console and logs.
    identifier = "${var.project_name}-db"

    # the goal here is to tell AWS whcich software to install.
    engine = "postgres"
    engine_version = "15"

    # the goal here is to define the cpu and memory of the underlying server running postgres with 20 GiB of storage.
    # t3 micro is the smallest free tier option.
    instance_class = "db.t3.micro"
    allocated_storage = 20

    db_name = "pipelineiq"
    username = var.db_username
    password = var.db_password
    db_subnet_group_name = aws_db_subnet_group.main.name
    vpc_security_group_ids = [aws_security_group.rds.id]

    # fianl snapshot wont be necessary because terraform destroy will be used at the end of every session.
    skip_final_snapshot = true
    publicly_accessible = false

    tags = {
        Project = var.project_name
    }
  
}