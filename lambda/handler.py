import json 
import boto3
import psycopg2

# Receive database credentials from Secrets Manager.
def get_db_credentials():
    client = boto3.client('secretsmanager', region_name='us-east-1')
    response = client.get_secret_value(SecretId='pipelineiq/db')
    return json.loads(response['SecretString'])

# Create a connection to postgres using the credentials from Secrets Manager. 
def get_db_connection(creds):
    return psycopg2.connect(
        host=creds['host'],
        port=creds['port'],
        dbname=creds['dbname'],
        user=creds['username'],
        password=creds['password']
    )

# Tell Rekognition the s3 bucket the user image is located in and returns labels to Lambda.
def analyze_image(bucket, key):
    client = boto3.client('rekognition', region_name='us-east-1')
    response = client.detect_labels(
        Image={'S3Object': {'Bucket': bucket, 'Name': key}},
        MaxLabels=10,
        MinConfidence=75.0
    )
    return response['Labels']

# S3 notifying lambda an image has been uploaded, the results will be stored in Postgres.
def lambda_handler(event, context):
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']
    labels = analyze_image(bucket, key)
    creds = get_db_credentials()
    conn = get_db_connection(creds)
    cursor = conn.cursor()
    cursor.execute(
        "INSERT INTO uploads (filename, s3_key) VALUES (%s, %s) RETURNING id",
        (key.split('/')[-1], key)
    )
    upload_id = cursor.fetchone()[0]

    for label in labels:
        cursor.execute(
            "INSERT INTO results (upload_id, label, confidence) VALUES (%s, %s, %s)",
            (upload_id, label['Name'], label['Confidence'])
        )
    
    conn.commit()
    cursor.close()
    conn.close()

    return {'statusCode': 200, 'body': f'Processed {key} with {len(labels)} labels'}