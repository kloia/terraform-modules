# terraform-acm-module

You can provision your own ACM stack .

## Supported Resources : 
* ACM Certs

You can check the acm module from <a href="/main.tf"></a> . 

Usage of the ACM module . You can make validation optionally <b>DNS</b> or <b>e-mail</b>.

### Usage of the ACM module : 

```terraform
    module "my_acm" {
        source = "../../acm"
        domain_name = "*.elespanyol.online."
        validation_method = "DNS"
    }

```