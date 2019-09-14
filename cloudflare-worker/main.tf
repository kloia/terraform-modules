resource "cloudflare_worker_script" "worker_script" {
  name = "${var.worker_name}"
  content = "${file("${var.script_path}")}"
}

resource "cloudflare_worker_route" "worker_route" {
  zone = "${var.zone_name}"
  pattern = "${var.pattern}"

  script_name = "${cloudflare_worker_script.worker_script.name}"

  depends_on = ["cloudflare_worker_script.worker_script"]
}

