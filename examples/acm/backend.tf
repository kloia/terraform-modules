 terraform {
    backend "s3" {
        region = "us-east-2"#us-east-2, eu-west-1
        bucket = "acmterraformstate" ## vpc_bucket, terra_bucket .. 
        key    = "acmterraformstate/base.tfstate"
    }
    }


