<p align="center">
<img src="https://github.com/kura-labs-org/kuralabs_deployment_1/blob/main/Kuralogo.png">
</p>

## Deployment Instructions:
1. Follow the naming convention below for all resources created in AWS:
```
VPC:
- deplpoyment#-vpc-region, example: deployment6-vpc-east
Instances:
- Function#-region, example: applicationServer01-east, applicationServer02-east
Security Groups:
- purposeSG, example: HttpAcessSG
Subnets:
- purposeSubnet#, example: publicSubnet01
Load Balancer:
- purpose-region, example: ALB-east
```
2.  Use Terraform to create 2 instances in your default VPC for a Jenkins manager and agent architecture (see below for more information)
3. The following must be installed:
```
Instance 1:
- Jenkins, software-properties-common, add-apt-repository -y ppa:deadsnakes/ppa, python3.7, python3.7-venv, build-essential, libmysqlclient-dev, python3.7-dev
Instance 2:
- Terraform and default-jre
```
4. Create two VPCs with Terraform, 1 VPC in US-east-1 and the other VPC in US-west-2. **MUST** have the following components in each VPC:
    - 2 AZ's
    - 2 Public Subnets
    - 2 EC2's
    - 1 Route Table
    - Security Group Ports: 8000 and 22     
5. Create a user data script that will install the dependencies below and deploy the Banking application:
```
- The following must be installed for the application to run: software-properties-common, add-apt-repository -y ppa:deadsnakes/ppa, python3.7, python3.7-venv, build-essential, libmysqlclient-dev, python3.7-dev
- Once you activate the virtual environment, the following must be installed: pip install mysqlclient, pip install gunicorn
```
6. Now create an RDS database: [instructions here](https://scribehow.com/shared/How_to_Create_an_AWS_RDS_Database__zqPZ-jdRTHqiOGdhjMI8Zw)
7. Change the following MySQL endpoints to your endpoints for each file listed below:
   - The red, blue, and green areas of the DATABASE_URL you'll need to edit:
       ![image](https://github.com/kura-labs-org/c4_deployment-6/blob/main/format.png)
   - database.py:
     ![image](https://github.com/kura-labs-org/c4_deployment-6/blob/main/database.png)
     
   - load_data.py
     ![image](https://github.com/kura-labs-org/c4_deployment-6/blob/main/load.png)
     
   - app.py
     ![image](https://github.com/kura-labs-org/c4_deployment-6/blob/main/app.png)
     
8. **Note:** Once you've deployed the application the first time, you will not need to load the database files again (database.py and load_data.py)
9. Configure your AWS credentials in Jenkins: [instructions here](https://scribehow.com/shared/How_to_Securely_Configure_AWS_Access_Keys_in_Jenkins__MNeQvA0RSOWj4Ig3pdzIPw)
10. Now place your Terraform files and user data script in the initTerraform directory
11. Create a multibranch pipeline and run the Jenkinsfile 
12. Check your infrastructures and applications
15. Once you've deployed to both regions, create an application load balancer for US-east-1 and US-west-2: [instructions here](https://scribehow.com/shared/Creating_Load_Balancer_with_Target_Groups_for_EC2_Instances__WjPUNqE4SLCpkcYRouPjjA)
16. With both infrastructures deployed, is there anything else we should add to our infrastructure?  

