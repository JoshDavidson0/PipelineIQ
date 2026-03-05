import boto3
import json
import psycopg2
from psycopg2.extras import RealDictCursor

def get_connection():
    client = boto3.client("secretsmanager", region_name="us-east-1")
    secret = client.get_secret_value(SecretId="pipelineiq/db")
    creds = json.loads(secret["SecretString"])

    return psycopg2.connect(
        host=creds["host"],
        port=creds["port"],
        dbname=creds["dbname"],
        user=creds["username"],
        password=creds["password"],
        cursor_factory=RealDictCursor
    )
