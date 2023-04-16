import json
import boto3

s3 = boto3.client('s3')
rekognition = boto3.client('rekognition')

def lambda_handler(event, context):
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']
    
    response = rekognition.detect_labels(
        Image={
            'S3Object': {
                'Bucket': bucket,
                'Name': key,
            }
        },
        MaxLabels=10,
        MinConfidence=90
    )
    
    labels = [label['Name'] for label in response['Labels']]
    
    s3.put_object(
        Bucket=bucket,
        Key=f"{key}-labels.json",
        Body=json.dumps(labels)
    )
    
    return {
        'statusCode': 200,
        'body': json.dumps(f"{len(labels)} labels detected and saved to S3!")
    }