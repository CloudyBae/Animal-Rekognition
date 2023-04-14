module "personnel_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "${var.company}-personnel-storage-${random_pet.bucket_name.id}"
  

  versioning = {
    enabled = true
  }
}