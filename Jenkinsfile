pipeline {
    agent any
    environment {
        IMAGE = "minimalci/myapp"   // 本地测试时可改为 myapp:local
        TAG = "${env.BUILD_NUMBER}"
    }
    stages {
        stage('Checkout') {
            steps {
                echo "Checking out repository..."
                checkout scm
                sh 'pwd && ls -la'
            }
        }

        stage('Build (cmake)') {
            agent {
                docker {
                    image 'ubuntu-build'
                    // args '-v /var/run/docker.sock:/var/run/docker.sock -v /usr/local/bin/docker:/usr/local/bin/docker'
                }
            }
            // options {
            //     skipDefaultCheckout(false)
            // }
            steps {
                sh '''
                  echo "🚧 Building project in ubuntu-build container..."
                  cmake -S . -B build && cmake --build build --config Release
                  echo "🧪 Running tests..."
                  ctest --test-dir build --output-on-failure || true
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                  echo "🐳 Building final Docker image..."
                  docker build -t ${IMAGE}:${TAG} .
                '''
            }
        }

        stage('Push Image (optional)') {
            when {
                expression { return env.PUSH_TO_REMOTE == 'true' }
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds',
                                                 usernameVariable: 'DOCKER_USER',
                                                 passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh "docker tag ${IMAGE}:${TAG} ${DOCKER_USER}/${IMAGE}:${TAG}"
                    sh "docker push ${DOCKER_USER}/${IMAGE}:${TAG}"
                }
            }
        }

        stage('Deploy (local demo)') {
            steps {
                // 这里示例部署到当前 Jenkins 节点（本地演示）
                sh '''
                  docker rm -f myapp || true
                  docker run -d --name myapp -p 8080:8080 ${IMAGE}:${TAG}
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline succeeded. App should be reachable if deploy succeeded."
        }
        failure {
            echo "❌ Pipeline failed. Check logs."
        }
    }
}
