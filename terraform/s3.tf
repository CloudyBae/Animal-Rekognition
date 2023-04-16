resource "aws_s3_bucket" "animalrekog_bucket" {
  bucket = "animalrekog_bucket"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_s3_bucket_object" "metadata" {
  bucket = aws_s3_bucket.animalrekog_bucket.id
  key    = "metadata/"

  content_type = "application/x-directory"
}

resource "aws_s3_bucket_object" "flask" {
  bucket = aws_s3_bucket.animalrekog_bucket.id
  key    = "flask/"

  content_type = "application/x-directory"
}