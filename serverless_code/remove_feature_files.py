import json
import boto3
import os

def run(event, context):
 # TODO implement
 bucket = os.environ["Project_bucket"]
 prefix = os.environ["feature_folder"]
 s3 = boto3.resource('s3')
 bucket = s3.Bucket(bucket)
 for key in bucket.objects.filter(Prefix=prefix):
  key.delete()
 return {
 'statusCode': 200
}
