pipeline{
    agent {
        label 'AGENT-1'
    }
    environment{
        appVersion=''
    }
    stages{
        stage('Reading version'){
            steps{
                script{
                def package_info = readJSON file: 'package.json'
                appVersion = package_info.version
                echo "version is: ${appVersion}"
                }
            }
        }
        stage('install dependencies'){
            steps{
                sh 'npm install'
            }
        }
        stage('Dockerbuild'){
            steps{
                withAWS(region: 'us-east-1', credentials: 'aws-creds'){
                sh """
                aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 147997135309.dkr.ecr.us-east-1.amazonaws.com
                docker build -t expense/dev/backend .
                docker tag expense/dev/backend:latest 147997135309.dkr.ecr.us-east-1.amazonaws.com/expense/dev/backend:${appVersion}
    
                docker images
                docker push 147997135309.dkr.ecr.us-east-1.amazonaws.com/expense/dev/backend:${appVersion}


                """
                }
            }
        }
        stage('Deploy'){
            steps{
                withAWS(region: 'us-east-1', credentials: 'aws-creds'){
                sh """
                aws eks update-kubeconfig --region us-east-1 --name expense-dev
                cd helm
                sed -i 's/IMAGE_VERSION/${appVersion}/g' values-dev.yaml
                cat values-dev.yaml
                helm upgrade --install backend -n expense -f values-dev.yaml .

                """
                }
            }
        }

    }
}