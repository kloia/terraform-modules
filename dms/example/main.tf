module "dms-mongo" {
  source = "../"
  replication_task_id = "repltask"  
  map_rule_path = "${path.module}/config/map_rule.json"
  mongodb_server_name = "ec2-34-253-225-6.eu-west-1.compute.amazonaws.com"
  

}
