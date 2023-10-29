# Automated Terraform Deployment Documentation

## Purpose
This documentation provides an overview of deploying a Banking Application using a Jenkins manager to a Jenkins Agent using Terraform to deploy the App. The goal is to create the necessary Terraform files with specific components and set up Jenkins for continuous integration, enabling the deployment of an application across multiple EC2 instances in different regions.

## Issues
Had an issue with Jenkins not deploying due to credential errors during the "plan" stage on the East EC2 instances. No issues were encountered on the West EC2s.  Have been unable to resolve credential error. I manually deployed the application by running the "Jenkinsfile" line by line and the ec2 instance deployed successfully.
![image](Deployment5.1/Deployment5.1server1.png)

## Steps

### Step 1: Terraform Creation
1. On an instance with Terraform already installed. I created 2 instances along with its Infrastructure with the specified components:
   - Default VPC
   - Existing Security Group with port 8080 and 22 open.
   - 1 EC2 instance with Jenkins Manager install script in the "user_data" block.
   - 1 EC2 instance with Terraform installed along with dependencies.
      During this stage, I implemented a JenkinsManagerInstall.sh and TerraformInstall.sh script in the User Data prompt. That script will install the dependencies and enable Jenkins and Terraform to their respective instances.
2. Created 2 additional Terraform main.tf files that will build the Infrastructure for the Banking Application in 2 regions. One is going to the EAST Region and the other to the WEST Region.   
This deployment needs these in each Region:
- 1 Virtual Private Cloud
- 2 Availability Zones
- 2 Public Subnets
- 2 EC2 Instances
- 1 Route Table
- Security Group Ports: 8000, 22
  During this stage, I implemented a BankAppDeploy.sh script in the User Data prompt. That script will install the dependencies and deploy the Banking application. 
   
### Step 2: EC2 Instance Setup
**For the first EC2 instance (Instance 1):**
1. Once Jenkins is installed.
2. Create a Jenkins user password and log into the Jenkins user.
3. Installed "Pipeline keep running step" plugin.
4. Added AWS Access Key and Secret Key to the credentials under "secret text"

### Step 3: Made Jenkins agents
1. Following these Steps:
    - Select "Build Executor Status"
    - Click "New Node"
    - Choose a node name that will correspond with the Jenkins agent defined in our Jenkins file
    - Select permenant Agent
    - Create the node
    - Use the same name for the name field
    - Enter "/home/ubuntu/agent1" as the "Remote root directory"
    - Use the same name for the labels field
    - Click the dropdown menu and select "only build jobs with label expressions matching this node"
    - Click the dropdown menu and select "launch agent via SSH"
    - Enter the public IP address of the instance you want to install the agent on, in the "Host" field
    - Click "Add" to add Jenkins credentials
    - Click the dropdown menu and select "select SSH username with private key"
    - Use the same name for the ID field 
    - Use "ubuntu" for the username
    - Enter directly & add the private key by pasting it into the box
    - Click "Add" and select the Ubuntu credentials
    - Click the dropdown menu and select "non verifying verification strategy"
    - Click save & check in Jenkins UI for a successful installation by clicking "Log"

### Step 4: Created a RDS database:
1. Following these Steps:
   - Navigated to Amazon RDS
   - Click "Create database"
   - Select "MySQL"
   - Select "Free tier"
   - Click the "DB instance identifierInfo:" field and change it to "mydatabase"
   - Click the "Master password" and create an easy password
   - Click the "Confirm master passwordInfo:" field.
   - Select "YES" for public access
   - Click Additional configuration
   - Click the "Initial database name" type "banking"
   - Click on the checkbox to deselect encryption
   - Click "Create database"
   - Click "Connectivity & security" There was a default Security Group created, you'll need to edit that default SG and add the rule open port 3306 to everyone
2. Change the following MySQL endpoints to your endpoints for each file listed below:
   - database.py
   - load_data.py
   - app.py
   Note: Once you've deployed the application the first time, you will not need to load the database files again (database.py and load_data.py)
     
### Step 5: Jenkins Multibranch Pipeline
1. Now place your Terraform files created earlier and user data script (BankAppDeploy.sh) in the initTerraform directory
2. Create a Jenkins multibranch pipeline.
3. Run the Jenkinsfilev.

### Step 6: Application Testing
1. Check the application on all instances.
2. Observed all applications running on port 8000
Note: Encountered Credential Errors for East Region. Had to deploy manually to East Region. West Region Deployed Successfully.
### Step 7: Create an application load balancer
1. Once you've deployed to both regions I created a load balancer.
2. One load balancer for US-East-1 Region
3. One load balancer for US-West-2 Region

## FAQ

### What should be added to the infrastructure to make the application more available to users?
- Setting up auto-scaling groups to adjust the number of ec2 instances that will handle more requests during peak times and scaling down during low traffic periods
- A CDN like AWS CloudFront could deliver content from edge locations reducing latency and making the application more available to users.
  
### System Diagram
![image](Deployment5.1/Deployment5.1.png)

### Optimization
To make this deployment more efficient, I would implement the following:

1. **Use Terraform Modules:** Break down the Terraform configuration into reusable modules for VPC components, security groups, and EC2 instances to improve code maintainability.

2. **Implement Autoscaling:** Set up auto-scaling groups for EC2 instances to automatically adjust the number of instances based on traffic demands.

3. **Containerization:** Consider containerizing the banking application using Docker and deploying it on an orchestration platform like Kubernetes for more efficient management and scalability.

![image](Deployment5.1/Deployment5.1server1.png)
![image](Deployment5.1/Deployment5.1server2.png)
![image](Deployment5.1/Deployment5.1Jenkins.png)
