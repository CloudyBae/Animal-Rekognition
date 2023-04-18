# Animal-Rekognition is a Machine Learning Application that uses AI analysis to tell you what the top 5 objects are in the photo (preferably an animal photo haha, but it can use AI analysis for anything). 

This was one of the first projects I did while I was studying DevOps Engineering in school. Since then I have learned many new skills and wanted to use them to advance one of my favorite first projects. 

First I implemented infrastructure-as-code to my AWS resources with the use of Terraform and HCL.   
![Screenshot_1](https://user-images.githubusercontent.com/109190196/232643561-9a32919b-5ec5-4b37-8ce5-de5b2f451705.jpg)

Before my project used "Custom Labels" in Amazon Rekognition and I have to label each photo 1 by 1 on the console. I didn't want to do this so I decided that I wanted to code something to take advantage of Rekognition's API. 

First I made tested a Lambda function that got triggered by objects added to an S3 bucket. From there it would take those objects and let Rekognition label them and it returns it back to the S3 bucket. This concept was okay but I decided to actually code the use of Rekognition's API directly into my Flask app. I did some testing in my terminal to make sure the flask app was working as intended.  
![InkedScreenshot_10](https://user-images.githubusercontent.com/109190196/232644675-95ec4045-47d3-4c38-a388-acc49bab279d.jpg)

After the flask app was working as intended, I created a Jenkins pipeline with a webhook to my GitHub repo to automatically build a Docker image of my flask app and push it into AWS ECR whenever there are new changes to my GitHub repo.   
![Screenshot_7](https://user-images.githubusercontent.com/109190196/232644851-78c46427-478e-4364-b05c-96e54afaa6cc.jpg)

Once the Docker image gets pushed into ECR, I deployed the image into AWS ECS Fargate. Below you can see the photos of the web app working.
![Screenshot_8](https://user-images.githubusercontent.com/109190196/232651242-a1002393-4694-495a-9309-79d6932e65b8.jpg)

I uploaded this photo below.
![image6](https://user-images.githubusercontent.com/109190196/232651267-68bf1a78-3939-493f-9fe1-755a3671aaec.jpg)

This is what the AI listed as the top 5 objects in the photo are.
![Screenshot_9](https://user-images.githubusercontent.com/109190196/232651370-9c5df49b-deb9-4db3-99b1-e76d6b73edae.jpg)



