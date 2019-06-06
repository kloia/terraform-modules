locals {
  queue_names = ["q1", "q2", "q3"]
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
  }
}
output "queue_mappings" {
  value = "${null_resource.queue_mappings.*.triggers}"
}