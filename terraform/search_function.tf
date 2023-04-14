data "aws_caller_identity" "current" {}

data "archive_file" "search_function" {
  type        = "zip"
  output_path = "${path.module}/search_function.zip"

  source {
    content  = file("src/search_function.py")
    filename = "search_function.py"
  }

  source {
    content  = file("src/rekognition_image.py")
    filename = "rekognition_image.py"
  }
}

resource "aws_lambda_function" "search_function" {

  function_name = "personnel-recognition-searcher"
  role          = aws_iam_role.search_function.arn
  publish       = true
  runtime       = "python3.8"
  handler       = "search_function.lambda_handler"
  memory_size   = 512
  timeout       = 60

  filename         = data.archive_file.search_function.output_path
  source_code_hash = data.archive_file.search_function.output_base64sha256

  environment {
    variables = {
      MAX_FACES_COUNT = var.max_faces_count
      FACE_DETECT_THRESHOLD = var.face_detect_threshold
      COLLECTION_ID = var.collection_id
      TABLE_ID = local.table_name
    }
  }
}

data "aws_iam_policy_document" "search_role_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "rekognition:DescribeCollection",
      "rekognition:SearchFacesByImage",
      "dynamodb:GetItem",
    ]
    resources = [
      "arn:aws:logs:*:*:*",
      "arn:aws:rekognition:*:*:collection/${var.collection_id}",
      "arn:aws:dynamodb:*:*:table/${local.table_name}"
    ]
  }
}

resource "aws_iam_role" "search_function" {
  name               = "faces-search-function-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy" "search_function" {
  name   = "cloudwatch_search"
  role   = aws_iam_role.search_function.id
  policy = data.aws_iam_policy_document.search_role_policy.json
}