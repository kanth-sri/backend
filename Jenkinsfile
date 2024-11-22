pipeline{
    agent any
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
                sh """
                docker build -t sri8008/backend:${appVersion} .
                docker images

                """
            }
        }
    }
}