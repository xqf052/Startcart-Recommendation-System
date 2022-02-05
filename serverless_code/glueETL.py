import json
import os
import boto3


glue_client = boto3.client('glue')
glueJobName = os.environ["glue_job_name"]


def run(event, context):
    
    try:
        glue_client.start_job_run(
            JobName = glueJobName
            )
    except Exception as e:
        if e.response['Error']['Code'] == 'EntityNotFoundException':
            print(f'Glue job {glueJobName} was not found, please recheck the glue job name')