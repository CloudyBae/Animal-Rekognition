data "archive_file" "index_function" {
  type        = "zip"
  output_path = "${path.module}/index_function.zip"

  source {
    content  = file("src/index_function.py")
    filename = "index_function.py"
  }

  source {
    content  = file("src/rekognition_image.py")
    filename = "rekognition_image.py"
  }
}

resource "aws_lambda_function" "index_function" {

  function_name = "personnel-recognition-indexer"
  role          = aws_iam_role.index_function.arn
  publish       = true
  runtime       = "python3.8"
  handler       = "index_function.lambda_handler"
  memory_size   = 128
  timeout       = 5

  filename         = data.archive_file.index_function.output_path
  source_code_hash = data.archive_file.index_function.output_base64sha256

  environment {
    variables = {
      MAX_FACES_COUNT = var.max_faces_count
      COLLECTION_ID = var.collection_id
      TABLE_ID = local.table_name
    }
  }
}

data "aws_iam_policy_document" "assume_role_policy" {
  version = "2012-10-17"
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
  }
}

data "aws_iam_policy_document" "index_role_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "rekognition:DescribeCollection",
      "rekognition:IndexFaces",
      "dynamodb:PutItem",
      "s3:GetObject",
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:logs:*:*:*",
      "arn:aws:rekognition:*:*:collection/${var.collection_id}",
      "arn:aws:dynamodb:*:*:table/${local.table_name}",
      module.personnel_bucket.s3_bucket_arn,
      "${module.personnel_bucket.s3_bucket_arn}/*"
    ]
  }
}

resource "aws_iam_role" "index_function" {
  name               = "faces-index-function-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy" "index_function" {
  name   = "cloudwatch_index"
  role   = aws_iam_role.index_function.id
  policy = data.aws_iam_policy_document.index_role_policy.json
}

resource "aws_lambda_permission" "s3_permission_to_trigger_lambda" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.index_function.arn
  principal     = "s3.amazonaws.com"
  source_arn    = module.personnel_bucket.s3_bucket_arn
}

resource "aws_s3_bucket_notification" "incoming" {
  bucket = module.personnel_bucket.s3_bucket_id

  lambda_function {
    lambda_function_arn = aws_lambda_function.index_function.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "photos/portrait"
    filter_suffix       = ".jpg"
  }

  depends_on = [aws_lambda_permission.s3_permission_to_trigger_lambda]
}