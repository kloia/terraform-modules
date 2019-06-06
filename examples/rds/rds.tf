module "my_rds" {
    source = "../../rds/"
    database_name = "example_db_2"
    environment = "development"
    enabled = "true"
    #db_password = "SECURE_PASSWORD"
    database_user = "admin"
    storage_type  = "gp2"
    allocated_storage  = "20"
    storage_encrypted  = "false"
    engine  = "mariadb"
    engine_version = "10.1.34"
    major_engine_version = "10.1"
    instance_class = "db.t2.micro"
    vpc_id = "vpc-ee4d9586"
    subnet_group_name = "subnet_group_db_3"
    subnet_ids  = ["subnet-035f9f160dc06a516", "subnet-bbacf1f6"]
    
    option_group_description = "TimeZone Set"
    options = [
        {
        option_name = "MARIADB_AUDIT_PLUGIN"

        option_settings = [
            {
            name  = "SERVER_AUDIT_EVENTS"
            value = "CONNECT"
            },
            {
            name  = "SERVER_AUDIT_FILE_ROTATIONS"
            value = "37"
            },
        ]
        },
    ]


}
