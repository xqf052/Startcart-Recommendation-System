provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region                  = "ap-southeast-2"
  profile                 = "default"
}

data "archive_file" "lambda_my_function" {
  type             = "zip"
  source_file      = "${path.module}/main.py"
  output_file_mode = "0666"
  output_path      = "${path.module}/prediction.zip"
}


resource "aws_s3_bucket_object" "object" {
  bucket = var.s3_bucket
  key    = "v${var.app_version}/example.zip"
  source = "${path.module}/prediction.zip"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  # etag = filemd5(local.lambda_function_zip)

  depends_on = [data.archive_file.lambda_my_function]
}