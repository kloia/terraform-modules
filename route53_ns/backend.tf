 terraform {
    backend "s3" {
        region = "us-east-2"#us-east-2, eu-west-1
        bucket = "route53_ns" ## vpc_bucket, terra_bucket .. 
        profile = "profile"
        key    = "route53_ns/base.tfstate"
    }
    }

    provider "aws" {
        profile = "profile"
       region = "us-east-2" #us-east-2
    }
