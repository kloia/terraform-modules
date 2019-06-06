 terraform {
    backend "s3" {
        bucket = "sqs" ## vpc_bucket, terra_bucket .. 
        key    = "sqsterraform/base.tfstate"
    }
    }

