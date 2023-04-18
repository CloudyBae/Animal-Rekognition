# Animal-Rekognition is a Machine Learning Application that uses AI analysis to tell you what the top 5 objects are in the photo (preferably an animal photo haha, but it can use AI analysis for anything). 

Created 2 datasets, 1 with 100+ dog photos, and the other with 100+ cat photos to train the Rekognition model. Labeled each image either "Cat" or "Dog" according to the type of animal they are in the photo. 
![Screenshot_1](https://user-images.githubusercontent.com/109190196/214764547-3f8b1428-fe96-4152-9b38-3bb452252782.jpg)

Used Session Manager in the EC2 instance created from the CloudFormation template to create a Docker image from the contents in "app" and push it into an ECR repository. Created an ECS cluster, Task definitions, and a Service. The Task definition also had 2 enviornment keys, 1 pointing at the s3 bucket deployed from the CloudFormation stack, and another pointing at the ARN of the Rekognition model. Once deployed, use the public ip to access the application.
![Screenshot_3](https://user-images.githubusercontent.com/109190196/214764998-e7bf611e-c146-4b05-ac36-3dd0510866bd.jpg)
![Screenshot_2](https://user-images.githubusercontent.com/109190196/214765008-77cdb664-1981-4a2c-a8db-22a9d18cc71c.jpg)

You are able to upload either a JPG or PNG file of either a cat OR dog (you cannot use a photo with both). The maximum file size is 15MB and the maximum width and height for the image is 4096 pixels. The application will determine if it is a cat or dog with a percentage of how sure the application is.

I uploaded the following image (was not used in the dataset) of my cat and this was the result.
![KakaoTalk_20230125_225622769](https://user-images.githubusercontent.com/109190196/214765198-66db298c-8a5f-42a6-92f9-61f1ae6267d7.jpg)
![Screenshot_4](https://user-images.githubusercontent.com/109190196/214765208-162f8c64-9b1b-4353-9e1b-c0afa0f21100.jpg)
