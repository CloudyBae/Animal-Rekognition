from flask import Flask, render_template, request, jsonify
from werkzeug.utils import secure_filename
import boto3
import os

# set up flask app
app = Flask(__name__)

# set up flask environment variables
app.config['MAX_SIZE'] = 15 * 1024 * 1024 # 15MB
app.config['UPLOAD_EXTENSIONS'] = ['jpg', 'png', 'jpeg']
app.config['MAX_WIDTH_HEIGHT'] = 4096

# set up the Amazon S3 client
s3 = boto3.client('s3', region_name='us-east-1')

rekognition = boto3.client('rekognition', region_name='us-east-1')

# AWS S3 bucket configuration
BUCKET_NAME = os.environ.get("BUCKET_NAME")


def allowed_file(filename):
    return '.' in filename and filename.rsplit('.')[-1].lower() in app.config['UPLOAD_EXTENSIONS']


@app.route('/', methods=['GET', 'POST'])
def upload_file():
    if request.method == 'POST':
        file = request.files['file']
        if file.filename == '':
            return render_template('index.html', error='No file selected')

        if not allowed_file(file.filename):
            return render_template('index.html', error='Invalid file extension')

        # Save the file to local disk
        filename = secure_filename(file.filename)
        file.save(os.path.join(app.config['UPLOAD_PATH'], filename))

        # Upload the file to S3
        s3.upload_file(os.path.join(app.config['UPLOAD_PATH'], filename),
                       app.config['S3_BUCKET'], filename)

        # Call Amazon Rekognition to detect labels
        response = rekognition.detect_labels(
            Image={
                'S3Object': {
                    'Bucket': BUCKET_NAME,
                    'Name': filename
                }
            },
            MaxLabels=5,
            MinConfidence=50
        )

        labels = []
        for label in response['Labels']:
            labels.append(f"{label['Name']} - {label['Confidence']:.2f}%")

        return render_template('index.html', success='File uploaded successfully', labels=labels)

    return render_template('index.html')


if __name__ == '__main__':
  app.run()