from flask import Flask, request, jsonify
import os
import uuid
import io
from minio import Minio
from minio.error import S3Error
from prometheus_client import Counter, generate_latest, REGISTRY

app = Flask(__name__)

MINIO_ENDPOINT = os.getenv('MINIO_ENDPOINT', 'minio:9000')
MINIO_ACCESS_KEY = os.getenv('MINIO_ACCESS_KEY', 'minioadmin')
MINIO_SECRET_KEY = os.getenv('MINIO_SECRET_KEY', 'minioadmin')
BUCKET_NAME = 'images'

client = Minio(
    MINIO_ENDPOINT,
    access_key=MINIO_ACCESS_KEY,
    secret_key=MINIO_SECRET_KEY,
    secure=False
)

http_requests_total = Counter(
    'http_requests_total',
    'Total HTTP requests',
    ['method', 'endpoint', 'service']
)

@app.before_request
def before_request():
    http_requests_total.labels(method=request.method, endpoint=request.path, service='uploader').inc()

@app.route('/v1/upload', methods=['POST'])
def upload():
    file_data = request.get_data()
    if not file_data:
        return jsonify({'error': 'no file data'}), 400
    filename = str(uuid.uuid4()) + '.jpg'
    content_type = request.headers.get('Content-Type', 'application/octet-stream')
    try:
        if not client.bucket_exists(BUCKET_NAME):
            client.make_bucket(BUCKET_NAME)
        file_stream = io.BytesIO(file_data)
        client.put_object(
            BUCKET_NAME, filename, file_stream, len(file_data),
            content_type=content_type
        )
        return jsonify({'filename': filename}), 201
    except S3Error as e:
        return jsonify({'error': str(e)}), 500

@app.route('/metrics')
def metrics():
    return generate_latest(REGISTRY), 200, {'Content-Type': 'text/plain; version=0.0.4'}

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
