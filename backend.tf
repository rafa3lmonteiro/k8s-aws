terraform {
    backend "s3" {
        region = "sa-east-1"
        bucket = "k8s-backend-rafael"
        encrypt = "true"
        key = "terraform.tfstate"    
    } 
}  