import json
import boto3
import os


stepFunction_client = boto3.client('stepfunctions')
account_id = os.environ["account_ID"]
region = os.environ["region"]
step_function_name = os.environ["stepfunction_name"]
stateMachineArn=f'arn:aws:states:{region}:{account_id}:stateMachine:{step_function_name}'
input_string = "{}"

def run(event, context):
    try:
        stepFunction_client.start_execution(
            stateMachineArn = stateMachineArn,
            input = input_string,
        )
    except Exception as e:
        if e.response['Error']['Code'] == 'EntityNotFoundException':
            print(f'State machine {stateMachineArn} was not found, please recheck the state machine ARN')