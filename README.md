# DevSecOps pipeline project
-----------------------------------------------------------------------------------
## Phase 1: Initial Setup 
### Step 1: Install Terraform on the local machine
- Haer some Installation steps for MacOS, Windows, Linux & Chocolatey package manager.
- [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

 ### Step 2: Clone the GitHub Repository.
 - Clone this Git Repo on the locale machine.
```bash
git clone https://github.com/darjidhruv26/YouTube-DevSecOps.git
```
- Open this repository in the code editor.
- Open the terminal and change the directory to `jenkins_terraform`.
```bash
cd jenkins_terraform
 ```
- The `terraform init` command initializes a working directory for Terraform configuration files.
```bash
terraform init
```
- The `Terraform plan` command compares the current state of resources with the desired state and generates a plan of action.
```bash
terraform plan
```
- The `Terraform apply` command executes the actions proposed in a Terraform plan. It is used to deploy infrastructure.
```bash
terrafrom apply
```

![terraforn apply](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/c68d9909-efe0-48c2-9350-58296ebd843b)

- There is one file `install_jenkins.sh` puts all commands for installing `jdk`,`Jenkins`, `Docker`, `SonarQube`, `trivy`, `aws cli`,`kubectl` and `eksctl`in this directory.
- So that, when Terraform provisions all resources at that time all the tools will install automatically on EC2.
   
![aws ec2](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/f76bda08-fa79-4f42-bf42-49ed854e26de)

- Go to EC2 Instance details and connect with ssh or putty.
- run this all commands --

```bash
jenkins --version
docker --version
trivy --version
aws --version
kubectl --version
eksctl --version
```

- Also `SonarQube` is running in a Docker container.
- To check this run `docker ps` and see sonarqube docker container is running.
- After that, access SonarQube in a web browser using public IP of your EC2 instance.

  `<EC2-Public-IP:9000>`
- After, Popup one massage for `Username` and `Password`.
- Username: `admin`
- password: `admin`

### SonarQube Dashboard
![3](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/e5fe5174-eb13-4d71-bc4c-bc19dbcad04d)

- Acces Jenkins in a web browser using EC2 public IP.
 
  `<EC2-Public-IP:8080>`
  
- Unlock Jenkins
- Run this below command.
  
```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

- Run this command, After that you will see the Administrator password
- Copy and past pop message and local in a notepad.
  
![jenkins Unlock](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/00bc29db-db91-4faa-ac23-215126524445)

- Now, Install the suggested plugins.
- Jenkins will now get installed and install all the libraries.
- After, Create an admin user (Optional step)
  
### Jenkins Dashboard
![4](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/c83c71f5-13b0-44ca-9b05-5c1dc6e5b9dd)

### Install Necessary Plugins in Jenkins:
- Gotot Manage Jenkins -> Plugins -> Available Plugins ->
  Install this below plugins
1. `Eclipse Temurin Installer`
2. `SonarQube Scanner`
3. `Sonar Quality Gates`
4. `Quality Gates`
5. `NodeJS`
6. `Docker`
7. `Docker Commons`
8. `Docker Pipeline`
9. `Docker API`
10. `docker-build-step`
And then click `Install`

![5](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/8848203b-1234-4023-ae8d-2613421246b5)

### Configure Java JDK, NodeJs, SonarQube Scanner and Docker in Jenkins Global tool Configuretion.

- Goto Manage Jenkins -> Tools -> Install JDK(17), NodeJs(16), SonarQube Scanner and Docker.
  
![install JDK17](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/69e7f97d-e3e0-444b-a0ae-ab105b6afe3d)

![install Nodejs16](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/fc5df70f-3cc6-4ee4-8fc0-b5eecc1881b4)
-> Click on Apply and Save

### Configure Sonar Server in Manage Jenkins

- Goto SonarQube Dashboard home page
- Click on Administration -> Security -> Users -> Click on Tokens and Update Token -> Give it a name -> Generate Token.
  
![sonar 1](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/782b76f4-864c-4404-b218-bcc186f968ee)

- Click on Generate Token
- Copy Token
  
![sonar token](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/90a0adc3-95a4-409f-8b34-7c9f7ab720d8)

- Goto Jenkins Dashboard -> Manage Jenkins -> Credentials -> Add Secret Text
  
![cred sonar jen](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/21590c55-03bc-471c-ab75-2518f59b8513)

- Now, go to Dashboard -> Manage Jenkins -> System and Add SoanarQube server credentials
- Name: `SonarQube-Server`,
- Server URL: `http://<EC2-Public-IP:9000>`
- Server authentication token: `SonarQube-Token`

Clik on Apply and Save

### Create a Quality gate

- Goto SonarQube dashboard and Click on Quality Gates
- Click on Create -> name `SonarQube-Quality-Gate` -> Save
  
![sonar quality gate](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/0e9a7e01-08bb-471c-8d7d-b1c2a06ac334)

### Now create a webhook between SonarQube and Jenkins

- Goto SonarQube dashboard -> Administration -> Configuration -> Webhooks -> Click on `create`
- Name: `jenkins`
- URL: `http://<ec2-public-ip:8080>/sonarqube-webhook/`
- And click on `Create`
                         
![sonar webhook](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/29edb5b3-a3e9-4680-ba01-8be77d068999)

### Create a project on SonarQube server

- Goto SonarQube dashboard -> click on `Manually`
- Create a project
- Project display name: `Youtube-CICD`
- Project key name: `Youtube-CICD`
- Main branch name: `main`
- Click on Set-up
  
![sonar project](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/38e192ed-505a-4787-891b-13e53bc9b7bf)

- Now you can see Analyze your project page
  
![Sonar project token](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/60b83ec4-df8b-4eea-80aa-f27c8b48846e)

- Click on `Generate` -> Continue -> Other (for JS, TS, Go, Python, PHP,...) -> OS `Linux`
-> Copy commands for the script.

## Create a Jenkins pipeline

- Goto Jenkins dashboard -> click on +New Item
- Job Name: `Youtube-CICD`
- Click on Pipeline -> OK

### Configuration

- Click on Discard old builds -> Max# build to keep `2`
- Now apply & save this script
- Click on Build Now
  
```bash
pipeline{
    agent any
    tools{
        jdk 'jdk17'
        nodejs 'node16'
    }
    environment {
        SCANNER_HOME=tool 'sonar-scanner'
    }
    stages {
        stage('clean workspace'){
            steps{
                cleanWs()
            }
        }
        stage('Checkout from Git'){
            steps{
                git branch: 'main', url: 'https://github.com/darjidhruv26/YouTube-DevSecOps.git'
            }
        }
        stage("Sonarqube Analysis "){
            steps{
                withSonarQubeEnv('SonarQube-Server') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Youtube-CICD \
                    -Dsonar.projectKey=Youtube-CICD '''
                }
            }
        }
        stage("quality gate"){
           steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'SonarQube-Token' 
                }
            } 
        }
        stage('Install Dependencies') {
            steps {
                sh "npm install"
            }
        }
        stage('TRIVY FS SCAN') {
            steps {
                sh "trivy fs . > trivyfs.txt"
            }
        }
     }
  }
}

```

### 1st pipeline output

![jenkins 1 pipeline](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/b9b54709-7d75-46f6-a232-418a88e79eab)

### SonarQube scan output

![sonar dashbord af pip](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/70757b9b-1af0-4405-b6e5-d8e8cdc11dc4)

## Docker Image Build and Push

### Create DockerHub access token
- Goto DockerHub -> My Account -> Security -> Create New access token and save it.
### Add DockerHub Credentials
- Goto Jenkins Dashboard -> Manage Jenkins -> Manage Credentials
- Click on `System` and then `Global Credentials`.
- Click on `Add Credentials` -> `Secret text` -> Enter your DockerHub credentials (`Username` & `Password`)
- And Save it.

## Create an API key from RapidAPI
### - [Rapid API](https://rapidapi.com/hub)
- Create an account
![rapidapi](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/5575da39-ec82-48e8-ab6d-4466dee6e698)

![Api](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/b9efed7d-b702-4a5e-b801-5e85035d6904)

```
pipeline{
    agent any
    tools{
        jdk 'jdk17'
        nodejs 'node16'
    }
    environment {
        SCANNER_HOME=tool 'sonar-scanner'
    }
    stages {
        stage('clean workspace'){
            steps{
                cleanWs()
            }
        }
        stage('Checkout from Git'){
            steps{
                git branch: 'main', url: 'https://github.com/darjidhruv26/YouTube-DevSecOps.git'
            }
        }
        stage("Sonarqube Analysis "){
            steps{
                withSonarQubeEnv('SonarQube-Server') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Youtube-CICD \
                    -Dsonar.projectKey=Youtube-CICD '''
                }
            }
        }
        stage("quality gate"){
           steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'SonarQube-Token' 
                }
            } 
        }
        stage('Install Dependencies') {
            steps {
                sh "npm install"
            }
        }
        stage('TRIVY FS SCAN') {
            steps {
                sh "trivy fs . > trivyfs.txt"
            }
        }
        stage("Docker Build & Push"){
            steps{
                script{
                   withDockerRegistry(credentialsId: 'dockerhub', toolName: 'docker'){   
                       sh "docker build --build-arg REACT_APP_RAPID_API_KEY=a578815c0fmsh92bedc0fa0c572dp1b3ea3jsnd22c4b326093 -t youtube ."
                       sh "docker tag youtube dhruvdarji123/youtube:latest "
                       sh "docker push dhruvdarji123/youtube:latest "
                    }
                }
            }
        }
        stage("TRIVY Image Scan"){
            steps{
                sh "trivy image dhruvdarji123/youtube:latest > trivyimage.txt" 
            }
         }
       }
    }
}

```

![jenkins 2 pipeline af docker push](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/df43132f-f73f-48bb-86f3-ee5f0c0c418c)


got to the `monitoring-server` directory

```bash
cd monitoring-server
```

```bash
terraform init
```

```bash
terraform plan
```

```bash
terraform apply
```

![monitoring server](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/0ddf4ae0-447e-4796-9cae-86d92d9ecc7f)

```bash
sudo systemctl status prometheus
```

![promethuse](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/09b5bceb-bf41-47b2-90d4-b8628f5da499)

```bash
sudo systemctl status grafana-server
```

![grafana server](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/dba92ed9-ba6d-4102-a920-d786832a5a6b)

```bash
sudo systemctl status node_exporter
```

![node-expo](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/e5ea7a84-838b-4626-9fbf-a6b3517b6ca9)

![prometuse 1](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/8e844446-1c97-4714-9f89-3ed75ba7be06)

![prometuse target](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/06fc4791-665d-4cf4-8114-ae562449eb79)

```bash
cd /etc/prometheus/
```

```ls```

```bash
sudo nano prometheus.yml
```

```bash
  - job_name: 'node_exporter'
    static_configs:
      - targets: ['IP-Address:9100']
```
![nodemode config](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/1198185d-addb-449a-ad25-8f609c017034)

```bash
promtool check config /etc/prometheus/prometheus.yml
```

![prom indentetion](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/2699cd2c-949c-4f15-b9cd-d070e2f86f5e)

```bash
curl -X POST http://localhost:9090/-/reload
```

![node-exporter dash](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/28801d50-a4ee-4958-acbe-be36a25277f7)


![Grafana dashbord](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/3c63a4b0-9e45-4db7-aca8-dcd9d7e70fdb)

![graf con pro](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/3a46b613-ff50-4076-9678-f756536e9bac)

![Grafana dashbord af node](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/4bf1f002-6dbd-4100-88a0-a38b8ffb3ee6)

```bash
cd /etc/prometheus/ & $ sudo nano prometheus.yml
```
```bash
- job_name: 'jenkins'
    metrics_path: '/prometheus'
    static_configs:
      - targets: ['IP-Address:8080']
```
![promet jenkins](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/db40d086-1f63-4f95-8332-5ab3b47c01e0)

![prom jen 1](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/e4639c48-6c11-4325-912f-bce8f9abf3d7)

![Grafana jenkins dashbord](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/66f6ed48-85a2-4d23-a045-6a2114272eb4)

```bash
post {
     always {
        emailext attachLog: true,
            subject: "'${currentBuild.result}'",
            body: "Project: ${env.JOB_NAME}<br/>" +
                "Build Number: ${env.BUILD_NUMBER}<br/>" +
                "URL: ${env.BUILD_URL}<br/>",
            to: 'dhruvdarji145@gmail.com',
            attachmentsPattern: 'trivyfs.txt,trivyimage.txt'
        }
    }
```

![jenkins Email send](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/5b954bb2-ae31-420d-9ae5-ca5be95d42a8)

```bash
sudo apt update
```

```bash
sudo apt install curl
```

```bash
curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
```

```bash
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```

```bash
kubectl version --client
```

## Installing eksctl

```bash
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
```

```bash
cd /tmp
```

```bash
sudo mv /tmp/eksctl /bin
```

```bash
eksctl version
```

![eks install](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/914f651b-b938-4712-baf9-b5162545f493)

```bash
cd ..
```

```bash
eksctl create cluster --name youtube-cluster \
--region ap-south-1 \
--node-type t2.small \
--nodes 3 \
```

![Eks Cluster dashbord](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/17d90c8c-d7c1-46ab-95e8-0a7032bd768e)

![eks cluster command](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/b8e0f227-b46a-4339-863c-08f64b022d50)

```bash
kubectl get nodes
```
![eks nodes](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/88be794b-69b7-45b8-be5b-ffeafbe7d513)

```bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
```

```bash
chmod 700 get_helm.sh
```

```bash
./get_helm.sh
```

```bash
helm version
```

![helm install](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/2e96012a-c3dd-4fe4-93c9-10058938e5bf)

```bash
helm repo add stable https://charts.helm.sh/stable
```

![helm stable](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/70ac23d8-bf9f-4e45-8920-9f0ab4b6eceb)

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
```

![helm promet](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/a61171a5-6a0c-4aa7-bc62-c3cd3f5038ce)

```bash
kubectl create namespace prometheus
```

![helm namespace](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/67321f1b-a51f-496d-8793-d5a42d8de000)

```bash
helm install stable prometheus-community/kube-prometheus-stack -n prometheus
```

![helm pro stack](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/520487bc-2e2e-494b-bce0-e323c797bd08)

```bash
kubectl get pods -n prometheus
```

![helm pro nodes](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/d270d880-4611-459d-8920-917c6fda8bf1)

```bash
kubectl get svc -n prometheus
```

![helm service](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/2b80bade-90d6-4dc5-b546-2e783365f673)

```bash
kubectl edit svc stable-kube-prometheus-sta-prometheus -n prometheus 
```
![helm pro file edite](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/9b006747-a4ee-4515-85fe-c36a5ba6cb4d)

![pro load added](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/b1546fba-14c1-462b-93a0-1144d4835c78)

![eks prometh run](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/97d72702-1587-4997-9ea9-f5a0e4743db6)

```bash
kubectl get svc -n prometheus
```
![eks prometh servise](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/663ec21f-5171-445d-983f-f2dd6826cde7)

![prom-EKS grafana](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/03cff7db-8ee3-4a3d-b183-e71676960a47)

![promth eks graf dashbord](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/09f7459b-38c4-4435-9aff-6586e3ba7be7)

![k8s promth dash](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/33bedae6-a6a3-4d1d-bf25-5d27e610af1a)

![Grafana dashbords](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/6eb4af7b-0356-4ac7-a1c7-1ed3ebcaaa1e)


![k8s install on Jenkins](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/95e55c27-8183-4e0c-aaa5-23cb428575a3)


![ls -a](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/e144017b-2da9-4363-b351-8c7555a7e209)


![cat config](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/8b59c3ef-03c7-45bb-95f5-c42e8c6b381e)


```
pipeline{
    agent any
    tools{
        jdk 'jdk17'
        nodejs 'node16'
    }
    environment {
        SCANNER_HOME=tool 'sonar-scanner'
    }
    stages {
        stage('clean workspace'){
            steps{
                cleanWs()
            }
        }
        stage('Checkout from Git'){
            steps{
                git branch: 'main', url: 'https://github.com/darjidhruv26/YouTube-DevSecOps.git'
            }
        }
        stage("Sonarqube Analysis "){
            steps{
                withSonarQubeEnv('SonarQube-Server') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Youtube-CICD \
                    -Dsonar.projectKey=Youtube-CICD '''
                }
            }
        }
        stage("quality gate"){
           steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'SonarQube-Token' 
                }
            } 
        }
        stage('Install Dependencies') {
            steps {
                sh "npm install"
            }
        }
        stage('TRIVY FS SCAN') {
            steps {
                sh "trivy fs . > trivyfs.txt"
            }
        }
        stage("Docker Build & Push"){
            steps{
                script{
                   withDockerRegistry(credentialsId: 'dockerhub', toolName: 'docker'){   
                       sh "docker build --build-arg REACT_APP_RAPID_API_KEY=a578815c0fmsh92bedc0fa0c572dp1b3ea3jsnd22c4b326093 -t youtube ."
                       sh "docker tag youtube dhruvdarji123/youtube:latest "
                       sh "docker push dhruvdarji123/youtube:latest "
                    }
                }
            }
        }
        stage("TRIVY Image Scan"){
            steps{
                sh "trivy image dhruvdarji123/youtube:latest > trivyimage.txt" 
            }
        }
        stage('Deploy to Kubernets'){
        steps{
            script{
                dir('Kubernetes') {
                     withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'kubernetes', namespace: '', restrictKubeConfigAccess: false, serverUrl: '')  {
                     sh 'kubectl delete --all pods'
                     sh 'kubectl apply -f deployment.yml'
                     sh 'kubectl apply -f service.yml'
                    }   
                }
            }
        }
    }
    }
    
    post {
     always {
        emailext attachLog: true,
            subject: "'${currentBuild.result}'",
            body: "Project: ${env.JOB_NAME}<br/>" +
                "Build Number: ${env.BUILD_NUMBER}<br/>" +
                "URL: ${env.BUILD_URL}<br/>",
            to: 'dhruvdarji145@gmail.com',
            attachmentsPattern: 'trivyfs.txt,trivyimage.txt'
        }
    }
}

```

![finel jenkins pipeline](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/4fc8e760-a126-43df-be2c-f9f0b094780f)

![grafana finel](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/7c9f85e1-060c-44ed-bd6d-0ff328c004ae)

![grafana fi](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/bbeef79b-f85e-4f6b-a302-654dfa006b89)

![get svc finel](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/36d1d302-f314-4ebc-b3e2-8a0bf51a2eb9)

![finel output](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/05b8424f-881a-4ec3-996e-342a70bb55b0)

![finel output 1](https://github.com/darjidhruv26/YouTube-DevSecOps/assets/90086813/7d8e2792-268e-4f7b-aa9d-f062a892b955)
