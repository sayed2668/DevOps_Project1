pipeline {
    agent any

    environment {
        REPO = "https://github.com/sayed2668/DevOps_Project1.git"
        IMAGE = "my-static-website"
        PORT = "8080"
        REMOTE_USER = "sayed"
        REMOTE_IP = "107.20.40.238"
        TARGET_DIR = "/home/${REMOTE_USER}/project"
    }

    stages {

        stage('Clone Project') {
            steps {
                echo "Cloning repository..."
                git url: "${REPO}"
            }
        }

        stage('Install Docker on QA Node') {
            steps {
                echo "Installing Docker if not already installed..."
                sh """
                ansible all -i /etc/ansible/hosts -m shell -a \\
                "which docker || (sudo apt update && sudo apt install -y docker.io && sudo usermod -aG docker ${REMOTE_USER})"
                """
            }
        }

        stage('Copy Project to QA Node') {
            steps {
                echo "Copying project files to QA node..."
                sh """
                ansible all -i /etc/ansible/hosts -m file -a "path=${TARGET_DIR} state=directory mode=0755"
                ansible all -i /etc/ansible/hosts -m copy -a "src=. dest=${TARGET_DIR} owner=${REMOTE_USER} mode=0755"
                """
            }
        }

        stage('Build Docker Image on QA') {
            steps {
                echo "Building Docker image on QA node..."
                sh """
                ansible all -i /etc/ansible/hosts -m shell -a \\
                "cd ${TARGET_DIR} && docker build -t ${IMAGE} ."
                """
            }
        }

        stage('Run Docker Container on QA') {
            steps {
                echo "Running Docker container on QA node..."
                sh """
                ansible all -i /etc/ansible/hosts -m shell -a \\
                "docker rm -f webapp || true && docker run -d --name webapp -p ${PORT}:80 ${IMAGE}"
                """
            }
        }
    }

    post {
        success {
            echo "✅ Website successfully deployed: http://${REMOTE_IP}:${PORT}"
        }
        failure {
            echo "❌ Deployment failed. Check console output for details."
        }
    }
}
