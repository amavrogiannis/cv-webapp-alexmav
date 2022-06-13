+++
title = "Site operation"
date = "2022-04-17"
[ author ]
  name = "AlexMav"
+++

As you can see the operation for this website, is fast, secure and reliable. The structure was simple, which I use Hugo configuration to apply my changes and then Huogo takes over in loading the template and make it look nice. 

The stack behind the scenes, is AWS. In this stage, the site is hosted via AWS S3 Static hosting but the complicated part comes from the CI/CD pipeline being set up. 

What is the saving cost, by automating it? 

Lets overview it by giving an example how its done manually: 
* Create GitHub repo with a config file, then clone remote the theme repo. 
* Configure the website as you want, adding the content and making changes. 
* Test the website deploying it to your localhost. 
* Export the website to HTML and then upload the HTML files on AWS S3. 
    * AWS S3 bucket and CloudFront is configured before hand. Change will apply when uploading the content. 
* Then the CloudFront will pickup the new HTML files uploaded to s3 and you will get deployed to the world wide web (www). 

How does automation simplifies the process, and saves time: 
* Clone repository, create the config file and apply your changes. 
* Upload your config file changes on GitHub. 
* CI/CD (GitHub Actions) YAML specifies the above steps: 
    * Checkout code
    * Build the website with Hugo plugin (marketplace)
    * Export and zip html files and upload to artifacts
    * Pull the zip folder artifacts and export the files and sync them to S3

Here is an architecture image that you might find useful: 
![arch_pic](/post/arch_pic.png)


Categorised Tech stack: 

* Hosting this website using AWS:
    * Route 53
    * CloudFront
    * S3 Bucket
    * Certificate Manager
* CI/CD Pipeline method: 
    * Terraform
    * GitHub Actions
* Website Framework:
    * [Hugo](https://gohugo.io)
    * [Template](https://themes.gohugo.io/themes/hugo-theme-hello-friend-ng/#how-to-edit-the-theme)

Here is a link to my [GitHub](https://github.com/amavrogiannis).