 terraform {
    backend "s3" {
        bucket = "elasticsearch" ## vpc_bucket, terra_bucket .. 
        key    = "elasticsearchterraform/base.tfstate"
    }
    }

