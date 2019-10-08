
variable "object_names" {
  type = "list"
}

locals {
  queue_names = "${var.object_names}"
}

resource "null_resource" "queue_mappings" {
  count = "${length(local.queue_names)}"

  triggers {
    queue_name     = "${element(local.queue_names, count.index)}"
    max_message_size=262144
    vis_timeout_sec=43200
    mes_ret_sec=1209600
    rec_wait_time_sec=0
    fifo_queue=false
    delaysec = 90
  }
}
output "queue_mappings" {
  value = "${null_resource.queue_mappings.*.triggers}"
}

resource "null_resource" "dead_letter_queue_mappings" {
  count = "${length(local.queue_names)}"

  triggers {
    queue_name     = "${element(local.queue_names, count.index)}_dlx"
    max_message_size=262144
    vis_timeout_sec=43200
    mes_ret_sec=1209600
    rec_wait_time_sec=0
    fifo_queue=false
    delaysec = 90

  }
}
output "dead_letter_queue_mappings" {
  value = "${null_resource.dead_letter_queue_mappings.*.triggers}"
}