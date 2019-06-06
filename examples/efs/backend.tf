 terraform {
    backend "s3" {
        bucket = "efs" ## vpc_bucket, terra_bucket .. 
        key    = "efsterraform/base.tfstate"
    }
    }

