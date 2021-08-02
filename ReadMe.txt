In this branch there is terraform code which build VPC with two public and private subnets and route tables for each subnet and security groups to allow port 80 and 443 from the internet.I have created different variables for that.
ELB is listening on ports 80 & 443 and public route53 hosted zone and CNAME entry for the ELB.
I added the Route53 domain by adding the SSL certificate of my name themashoodkhan.co.uk and I issued by going it to the AWS Certificate manager and then I did some DNS changes by going into the GODADDY.com and then I recieved the Certificate and then I added that certificate in the ELB for 443 port.
In the Actual Scenario this domain will hit route53 and from route53 it will hit cloudfront and from there on It will go inside the VPC and there elastic load balancer take it to different EC2 instances and auto scalling group will also be there inside the VPC and for storage there will be S3.

