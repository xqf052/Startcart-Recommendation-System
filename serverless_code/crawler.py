import json
import boto3
import os


glue_client = boto3.client('glue')
crawler_name = os.environ['crawler_name'] 

def run(event, context):
    
    try:
        glue_client.start_crawler(
        Name= crawler_name
        )
    except Exception as e:
        if e.response['Error']['Code'] == 'EntityNotFoundException':
            print(f'Crawler {crawler_name} was not found, please recheck the crawler name')