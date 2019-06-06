 terraform {
    backend "s3" {
        region = "us-east-2"#us-east-2, eu-west-1
        bucket = "sqs_state" ## vpc_bucket, terra_bucket .. 
        profile = "profile"
        key    = "sqs_state/base.tfstate"
    }
    }

    provider "aws" {
        profile = "profile"
       region = "region" #us-east-2
    }
