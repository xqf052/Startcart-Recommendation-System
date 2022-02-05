resource "aws_s3_bucket" "backend-bucket" {
    bucket = "backend-bucket-de-grp5"
    force_destroy = true
    versioning {
        enabled = true 
    }
}


resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name         = "terraform-state-lock-dynamodb"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_iam_role" "backend-s3" {
    name = aws_s3_bucket.backend-bucket.id
    assume_role_policy=<<EOF
{
    
    "Version": "2012-10-17",
    "Statement": [
    {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "lambda.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
    }
    ]
    
}
EOF
}
