import boto3

dynamodb_resource = boto3.resource('dynamodb')
table = dynamodb_resource.Table('dynamodb_table_gp5')
ssm = boto3.client('ssm')
endPoint = ssm.get_parameter(Name='model_endpoint')['Parameter']['Value']
# print(endPoint)



def lambda_handler(event, context):

    # body = event['body']
    body = str(event['body'])

    # print(body)
    user_id = body.split(',')[0]
    product_id = body.split(',')[1]

    # print(user_id)
    # print(product_id)

    response = table.get_item(
        Key={'user_id': user_id, 'product_id': product_id})
    # print(response)
    body = response['Item']['feature']

    # The SageMaker runtime is what allows us to invoke the endpoint that we've created.
    runtime = boto3.Session().client('sagemaker-runtime')

    # Now we use the SageMaker runtime to invoke our endpoint, sending the review we were given
    response = runtime.invoke_endpoint(EndpointName=endPoint,  # The name of the endpoint we created
                                       ContentType='text/csv',                 # The data format that is expected
                                       Body=body
                                       )

    # The response is an HTTP response whose body contains the result of our inference
    result = response['Body'].read().decode('utf-8')

    # Round the result so that our web app only gets '1' or '0' as a response.
    result = float(result)

    return {
        'statusCode': 200,
        'headers': {'Content-Type': 'text/plain', 'Access-Control-Allow-Origin': '*', "Access-Control-Allow-Methods": "OPTIONS,POST,GET"},
        'body': str(result)
    }
