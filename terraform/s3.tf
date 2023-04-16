resource "aws_s3_bucket" "animalrekog-bucket" {
  bucket = "animalrekog-bucket"

  lifecycle {
    prevent_destroy = false
  }
}

