# terraform-route53-module

You can provision your own route53 stack.

## Supported Resources : 
* Route53 Hosted Zone
* Route53 DNS Records

You can check the route53 module from <a href="/main.tf"></a> . That is the simple usage of route53 module .

## Usage of the module 

### Hosted Zone : 

```
module "route53-k8s" {
  source = "git::https://github.com/kloia/terraform-modules.git//route53?ref=v0.0.1"
  domain = "${var.route53_domain}"

}
```

### DNS Records : 

For manage and customize your CNAME records you must define `record_cname` value as 1 for define the count of the records .

You can define <b>A</b>,<b>MX</b>, <b>AAA</b> .. etc records to your domain and define multiple value for records define a list of values to the `records` key . 

```
module "my_route53" {
  source = "../../route53"
  domain = "mydomain.online"
  name = "cdn"
  records = "cloudfront.muybucket.online"
  type = "CNAME"
  record_cname = 1
}
```

