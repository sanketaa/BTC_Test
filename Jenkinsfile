// // Uses Declarative syntax to run commands inside a container.
// pipeline {
//     agent any
//     stages {
//         stage('checkout') {
//             steps {
//                 checkout scm
//             }
//         }

//         stage('Run terraform') {
//             steps {
//                 withAWS(credentials:'jenkins-aws-cred-v2', region:'us-east-1'){
//                  } 
//             }
//         }
//     }
// }


pipeline {
    agent any
    stages {
        stage('checkout') {
            steps {
                checkout scm
            }
        }
        stage('Create Zip') {
            steps {
                sh '''
                pip -V 
                echo "Installing Python modules"
                pip3 install boto3
                python3 -m venv dep-package
                pwd
                cd dep-package/bin/
                chmod +x activate
                // - . ./activate
                pip3 install requests_aws4auth
                pip3 install requests
                pip install virtualenv &&
                virtualenv –p /usr/bin/python3 btc &&
                source btc/bin/activate &&
                zip -r ~/terraform/btc.zip btc.py
                zip -r ~/terraform/btc.zip btc/lib/python3.9/site-packages/*  
                ''' 
            }
        }

        stage('Run Terraform') {
            steps {
                withAWS(credentials:'jenkins-aws-cred', region:'us-east-1'){
                sh   "terraform init"
                sh   "terraform apply -auto-approve"
                 }
            }
        }
    }
}