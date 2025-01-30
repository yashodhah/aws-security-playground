resource "aws_lambda_function" "copy_s3_objects_function" {
  function_name = "CopyS3ObjectsFunction"
  description   = "Copies objects into buckets"
  handler       = "index.handler"
  runtime       = "python3.9"
  role          = aws_iam_role.s3_copy_role.arn
  timeout       = 120

  source_code_hash = filebase64sha256("function.zip") # Upload your Python function as a zip file

  # Adjust the zip file or S3 source as needed
  filename = "function.zip"
}

resource "aws_iam_role" "s3_copy_role" {
  name               = "S3CopyRole"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  inline_policy {
    name   = "S3Access"
    policy = jsonencode({
      Version   = "2012-10-17"
      Statement = [
        {
          Sid      = "AllowLogging"
          Effect   = "Allow"
          Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
          Resource = "*"
        },
        {
          Sid      = "ReadFromLCBucket"
          Effect   = "Allow"
          Action   = ["s3:ListBucket", "s3:GetObject"]
          Resource = [
            "arn:aws:s3:::${var.labss3contentbucket}",
            "arn:aws:s3:::${var.labss3contentbucket}/*"
          ]
        },
        {
          Sid      = "WriteToStudentBuckets"
          Effect   = "Allow"
          Action   = [
            "s3:ListBucket", "s3:GetObject", "s3:PutObject", "s3:PutObjectAcl",
            "s3:PutObjectVersionAcl", "s3:DeleteObject", "s3:DeleteObjectVersion", "s3:CopyObject"
          ]
          Resource = [
            aws_s3_bucket.appbucket.arn,
            "${aws_s3_bucket.appbucket.arn}/*",
            aws_s3_bucket.patchesprivatebucket.arn,
            "${aws_s3_bucket.patchesprivatebucket.arn}/*"
          ]
        }
      ]
    })
  }
}
