import json
import boto3
import os
from pytz import timezone
from datetime import datetime


s3_client = boto3.client('s3')
tz_sydney = timezone(os.environ['TZ_LOCAL'])
date = datetime.now(tz_sydney).strftime("%Y-%m-%d")

def run(event, context):
    records = event['Records']
    for record in records:
        src_bucket = record['s3']['bucket']['name']
        src_key = record['s3']['object']['key']
        copy_source = {
            'Bucket': src_bucket,
            'Key': src_key
        }
        dest_bucket = src_bucket
        dest_key = os.environ['ml_data_folder'] + date + '/data.csv' 
        s3_client.copy(copy_source, dest_bucket, dest_key)