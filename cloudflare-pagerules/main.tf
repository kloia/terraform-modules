resource "cloudflare_page_rule" "foobar" {
  zone = "${var.cloudflare_zone}"
  target = "${var.sub_domain}.${var.cloudflare_zone}/${var.target_prefix}"
  priority = 1

  actions {
    ssl = "${var.ssl_state}"
    always_use_https = "${var.always_use_https}"
    email_obfuscation = "${var.email_obfuscation}"
    minify {
      html = "${var.minify_html}"
      css  = "${var.minify_css}"
      js   = "${var.minify_js}"
    }
    rocket_loader = "${var.rocket_loader}"
  }
}