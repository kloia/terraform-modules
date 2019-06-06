
module "queue_map" {
  source = "../mapping"
  queue_names = "${var.queue_names}"
  
}

module "global"  {
  source = "../globalvariable"
  tag_name = "${var.tag_name}"
  tag_deployment = "${var.tag_deployment}"
  tag_kubernetes_cluster = "${var.tag_kubernetes_cluster}"
  tag_organisation =  "${var.tag_organisation}"
  tag_project = "${var.tag_project}"
  tag_deployment_code =  "${var.tag_deployment_code}"

}

resource "aws_sqs_queue" "dead_letter_queue" {
  count = "${module.queue_map.queue_names}"
  name                      = "${lookup(module.queue_map.dead_letter_queue_mappings[count.index],"queue_name")}"
  delay_seconds             = "${lookup(module.queue_map.dead_letter_queue_mappings[count.index],"delaysec")}"
  max_message_size          = "${lookup(module.queue_map.dead_letter_queue_mappings[count.index],"max_message_size")}"
  message_retention_seconds = "${lookup(module.queue_map.dead_letter_queue_mappings[count.index],"mes_ret_sec")}"
  receive_wait_time_seconds = "${lookup(module.queue_map.dead_letter_queue_mappings[count.index],"rec_wait_time_sec")}"
  fifo_queue = "${lookup(module.queue_map.dead_letter_queue_mappings[count.index],"fifo_queue")}"

  tags = "${module.global.tags}"
}

resource "aws_sqs_queue" "queue" {
  count = "${module.queue_map.queue_names}"

  name                      = "${lookup(module.queue_map.queue_mappings[count.index],"queue_name")}"
  delay_seconds             = "${lookup(module.queue_map.queue_mappings[count.index],"delaysec")}"
  max_message_size          = "${lookup(module.queue_map.queue_mappings[count.index],"max_message_size")}"
  message_retention_seconds = "${lookup(module.queue_map.queue_mappings[count.index],"mes_ret_sec")}"
  receive_wait_time_seconds = "${lookup(module.queue_map.queue_mappings[count.index],"rec_wait_time_sec")}"
  fifo_queue = "${lookup(module.queue_map.queue_mappings[count.index],"fifo_queue")}"
  tags = "${module.global.tags}"

  redrive_policy  = <<EOF
    {"deadLetterTargetArn":"arn:aws:sqs:${var.aws["region"]}:${var.aws["accountId"]}:${lookup(module.queue_map.dead_letter_queue_mappings[count.index],"queue_name")}","maxReceiveCount":10}
    EOF



depends_on = ["aws_sqs_queue.dead_letter_queue"]


}
