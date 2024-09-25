# Terraform-Infrastructure-Scaling
Terraform-Infrastructure-Scaling

Understanding Scaling
Scaling is the process of adding or removing resources to match the changing demands of your application. As your application grows, you will need to add more resources to handle the increased load. And as the load decreases, you can remove the extra resources to save costs.
Terraform makes it easy to scale your infrastructure by providing a declarative way to define your resources. You can define the number of resources you need and Terraform will automatically create or destroy the resources as needed.

Task 1: Create an Auto Scaling Group
Auto Scaling Groups are used to automatically add or remove EC2 instances based on the current demand. Follow these steps to create an Auto Scaling Group:
In your main.tf file, add the following code to create an Auto Scaling Group:

Run terraform init and terraform apply to create the autoscaling group using the Terraform configuration.
![alt text](image.png) 

By Using Terraform validate we can check the syntaxical errors, As result Success / failure
![alt text](image-1.png)

By Using Terraform fmt command we can use for indentation of file.
![alt text](image-2.png)

By using Terraform Plan we will check the plan what ever desired in main.tf file. 
![alt text](image-3.png)

![alt text](image-4.png)
By using Terraform Apply -auto-approve command we can create the infrastrature.  Verify the EC2 instance has been successfully created.
![alt text](image-5.png)
Task 2: Test Scaling
Go to the AWS Management Console and select the Auto Scaling Groups service.
In the left side panel, scroll down until you see the autoscaling group. Click on it and then click on the autoscaling group you created.
![alt text](image-6.png)
Select the Auto Scaling Group you just created and click on the Group details "Edit" button.
Navigate to Group details and click on the Edit button.
![alt text](image-7.png)
Wait a few minutes for the new instances to be launched.
![alt text](image-8.png)

Go to the EC2 Instances service and verify that the new instances have been launched.
Navigate to the EC2 Instances service and verify that our 3 instances have been created. 

![alt text](image-9.png)

Go to the EC2 Instances service and verify that the extra instances have been terminated.
Navigate to the EC2 Instances service and verify that the extra instances have been terminated.
![alt text](image-10.png)

To verify if Auto Scaling is happening when an EC2 instance is terminated, you can follow these steps in Terraform. We'll ensure that the Auto Scaling Group (ASG) replaces any terminated instance automatically.