# terraform-cloudfront-module

You can provision your own Cloudfront stack .

## Supported Resources : 
* Cloudfront Origin Server
* S3 Bucket

You can check the cloudfront module from <a href="/main.tf"></a> . 

Notice : Usage of the Cloudfront module . You can define you cache behaviours and also create S3 bucket with our s3-module.

### Usage of the Cloudfront module : 

```terraform
    module "my_cdn" {
        source = "../../cloudfront/"
        default_root_object = "index.html"
        locations        = ["", "", ""]
        allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
        cached_methods   = ["GET", "HEAD"]
        headers = ["Origin"]
        .....
        ...
        ..
        .
    }
```