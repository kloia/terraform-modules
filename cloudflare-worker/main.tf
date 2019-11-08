resource "cloudflare_worker_script" "worker_script" {
  name = "${var.worker_name}"
  content = "${file("${var.script_path}")}"
}


resource "cloudflare_worker_route" "worker_route" {
  zone_id = "${lookup(data.cloudflare_zones.zone_id.zones[0], "id")}"
  pattern = "${var.pattern}"
  script_name = "${cloudflare_worker_script.worker_script.name}"
  depends_on = ["cloudflare_worker_script.worker_script"]
}


data "cloudflare_zones" "zone_id" {
  filter {
    name   = "${var.zone_name}"
    status = "${var.status}"
    paused = "${var.paused}"
  }
}



