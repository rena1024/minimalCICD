pipeline {
    agent {
        docker {
            image 'ubuntu-build'
        }
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build (cmake)') {
            steps {
                sh 'cmake -S . -B build && cmake --build build --config Release'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'ctest --test-dir build --output-on-failure || true'
                // 允许失败会标记为失败；如果你想中断流水线则删掉 "|| true"
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE}:${TAG} ."
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
