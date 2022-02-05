from confluent_kafka import Producer
#from confluent_kafka.schema_registry import RegisteredSchema
import boto3
import io
import gzip
import logging
import urllib.parse
import os
import time
import json
#import ujson
import re
import boto3


s3=boto3.client('s3')
bootstrap_server_name = os.environ['Bootstrap_server_name']
kafka_api_key = os.environ['kafka_api_key']
kafka_api_secret = os.environ['kafka_api_secret']
Project_bucket = os.environ['Project_bucket']
topic_name=os.environ['topic_name']
test_file_key = os.environ['test_output_folder'] + 'test_final.csv'

logging.basicConfig(format='%(levelname)s:%(message)s', level=logging.INFO)


p = Producer({
               'bootstrap.servers': bootstrap_server_name,
               'batch.num.messages': 500,
               #'batch.size' : 100,
                'linger.ms':5,
               'compression.type':'zstd',
               'security.protocol': 'SASL_SSL',
               'sasl.mechanisms' : 'PLAIN',
               'sasl.username': kafka_api_key,
               'sasl.password': kafka_api_secret
               #'auto.register.schemas':'true' ## this doesnt work in confluent cloud?         
                })




def delivery_report(err, msg):
    """ Called once for each message produced to indicate delivery result.
        Triggered by poll() or flush(). """
    if err is not None:
        logging.error('Message delivery failed: {}'.format(err))
    else:
        pass
        #logging.info('Message delivered to {} [{}]'.format(msg.topic(), msg.partition()))




def run(event, context):
    

                 

    s3 = boto3.client('s3')
    s3.download_file(Project_bucket, test_file_key, '/tmp/test_final.csv')
    with open('/tmp/test_final.csv', 'r') as f:
        i = 0
        for line in f:
            #print(line)
            tokens = line.split(',',2)
            p.produce(topic_name, value = json.dumps({'user_id':tokens[1], 'product_id':tokens[0],'feature':tokens[2].rstrip()}) , on_delivery = None, callback=delivery_report)
            i += 1
            if i == 1000:
                break

    p.poll(0)

    
    # Wait for any outstanding messages to be delivered and delivery report
    # callbacks to be triggered.
    p.flush()
   
   
    return {'submit' : 'ok'}