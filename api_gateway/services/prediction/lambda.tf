# IAM role which dictates what other AWS services the Lambda function
# may access.
resource "aws_iam_role" "lambda_exec" {
  name = "prediction_lambda"
  # Each Lambda function must have an associated IAM role which dictates what access it has to other AWS services.
  # The above configuration specifies a role with no access policy,
  # effectively giving the function no access to any AWS services,
  # since our example application requires no such access.
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

# Created Policy for IAM Role
resource "aws_iam_policy" "policy"{
  name = "lambda_function_s3"
  description = "access to s3 bucket"
  policy=<<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Action": [
              "s3:*"
          ],
          "Resource": "arn:aws:s3:::${var.s3_bucket}"
      }
]
}
EOF
}
#Attached IAM Role and the new created Policy
resource "aws_iam_role_policy_attachment" "lambda-attach" {
  role       = "${aws_iam_role.lambda_exec.name}"
  policy_arn = "${aws_iam_policy.policy.arn}"
}

resource "aws_iam_role_policy_attachment" "basic" {
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaExecute"
  role       = "${aws_iam_role.lambda_exec.name}"
}
resource "aws_iam_role_policy_attachment" "sagemaker" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
  role       = "${aws_iam_role.lambda_exec.name}"
}
resource "aws_iam_role_policy_attachment" "dynamodb" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
  role       = "${aws_iam_role.lambda_exec.name}"
}
resource "aws_iam_role_policy_attachment" "ssm-parameter" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
  role       = "${aws_iam_role.lambda_exec.name}"
}
resource "aws_ssm_parameter" "model_endpoint" {
  name  = "model_endpoint"
  type  = "String"
  value = "model_endpoint"
}

resource "aws_lambda_function" "example" {
  function_name = "prediction"

  # The bucket name as created earlier with "aws s3api create-bucket"
  s3_bucket = var.s3_bucket

  # Change the version to be 1.0.0
  s3_key    = "v${var.app_version}/example.zip"

  # "main" is the filename within the zip file (main.js) and "handler"
  # is the name of the property under which the handler function was
  # exported in that file.
  handler = "main.lambda_handler"
  runtime = "python3.8"
  role=aws_iam_role.lambda_exec.arn

  depends_on = [aws_s3_bucket_object.object]
}



# By default any two AWS services have no access to one another, until access is explicitly granted.
resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.example.function_name
  principal     = "apigateway.amazonaws.com"

  # The "/*/*" portion grants access from any method on any resource
  # within the API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.example.execution_arn}/*/*"
}