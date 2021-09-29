# Install Jenkins on AWS EC2 Instance using Terraform

```html
├── ec2.tf
├── main.tf
├── outputs.tf
├── README.md
├── sg.tf
├── subnets.tf
├── variables.tf
└── vpc.tf
```


Steps:
1. Changes variables in variables.tf
2. Change public key in ec2.tf specify the path for id_rda in ec2.tf (line 43)
3. You need to have profile setuped in ~/.aws/credentials
4. After terraform apply you can connect to our EC2 instance over SSH via public DNS/IP name.
5. Access the Jenkins Web portal - http://IP:8080
6. Admin password is created and stored in the log file “/var/lib/jenkins/secrets/initialAdminPassword “.