from flask import Flask, render_template, request, json
from werkzeug.utils import secure_filename
from PIL import Image
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
BUCKET_NAME = "animalrekog-bucket"

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.')[-1].lower() in app.config['UPLOAD_EXTENSIONS']

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.')[-1].lower() in app.config['UPLOAD_EXTENSIONS']


@app.route('/', methods=['GET', 'POST'])
def upload_file():
    if request.method == 'POST':
        if "file" not in request.files:
            msg = "No file selected"
            return render_template("index.html", msg=msg)

        file = request.files["file"]

        if file.filename == "":
            msg = "No file selected"
            return render_template("index.html", msg=msg)

        if file and allowed_file(file.filename):
            file.seek(0, os.SEEK_END)
            file_size = file.tell()
            if file_size > app.config['MAX_SIZE']:
                msg = "File size must be less than 15MB"
                return render_template("index.html", msg=msg)
            file.seek(0)
            img = Image.open(file)
            if img.width > app.config['MAX_WIDTH_HEIGHT'] or img.height > app.config['MAX_WIDTH_HEIGHT']:
                msg = "Height and width must be less than 4096px"
                return render_template("index.html", msg=msg)
        else:
            msg = "File type not supported. Must be .jpg, .jpeg, or .png"
            return render_template("index.html", msg=msg)

        filename = secure_filename(file.filename)
        file.seek(0)
        s3.upload_fileobj(file, BUCKET_NAME, filename)

        # detect labels using rekognition
        response = rekognition.detect_labels(
            Image={
                'S3Object': {
                    'Bucket': BUCKET_NAME,
                    'Name': filename
                }
            },
            MaxLabels=5
        )
    
        return render_template("index.html", labels=response['Labels'], prediction=True)
    
    return render_template("index.html")

if __name__ == '__main__':
  app.run(host='0.0.0.0')