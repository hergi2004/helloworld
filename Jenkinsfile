pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'helloworld:1.0.0'
        REGISTRY = 'yourdockerregistry.com'
    }
    stages {
        stage('Build') {
            steps {
                script {
                    docker.build(env.DOCKER_IMAGE)
                }
            }
        }
        stage('Push') {
            steps {
                script {
                    docker.withRegistry('https://'+env.REGISTRY, 'docker-registry-credentials') {
                        docker.image(env.DOCKER_IMAGE).push()
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    sh 'helm upgrade --install helloworld ./charts/helloworld --set image.repository=${env.REGISTRY}/helloworld,image.tag=1.0.0'
                }
            }
        }
    }
}
