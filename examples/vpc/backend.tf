 terraform {
    backend "s3" {
        bucket = "vpc" ## vpc_bucket, terra_bucket .. 
        key    = "vpcterraform/base.tfstate"
    }
    }

