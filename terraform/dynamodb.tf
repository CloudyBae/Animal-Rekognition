locals {
   table_name = "Faces_${random_pet.bucket_name.id}"
}

resource "aws_dynamodb_table" "personnel-faces-table" {
  name           = local.table_name
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "FaceId"

  attribute {
    name = "FaceId"
    type = "S"
  }
}