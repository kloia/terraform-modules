 terraform {
    backend "s3" {
        bucket = "s3" ## vpc_bucket, terra_bucket .. 
        key    = "s3terraform/base.tfstate"
    }
    }

