import boto3

s3 = boto3.resource('s3')

# Get list of objects for indexing
images=[('image1.jpg','Cat'),
      ('image2.jpg','Cat'),
      ('image3.jpg','Cat'),
      ('image4.jpg','Cat'),
      ('image5.jpg','Cat'),
      ('image6.jpg','Cat'),
      ('image7.jpg','Dog'),
      ('image8.jpg','Dog'),
      ('image9.jpg','Dog'),
      ('image10.jpg','SDog'),
      ('image11.jpg','Dog'),
      ('image12.jpg','Dog')
      ]

# Iterate through list to upload objects to S3   
for image in images:
    file = open(image[0],'rb')
    object = s3.Object('my-company-personnel-storage-optimal-starling', image[0])
    ret = object.put(Body=file,
                    Metadata={'FullName':image[1]})
