pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'hergi2004/helloworld:1.0.0'
        REGISTRY = 'docker.io'
    }
    stages {
        stage('Build') {
            steps {
                script {
                    def customImage = docker.build(env.DOCKER_IMAGE)
                }
            }
        }
        stage('Push') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-registry-credentials') {
                        def image = docker.image(env.DOCKER_IMAGE)
                        echo "Pushing image: ${env.DOCKER_IMAGE}"
                        image.push()
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Load the kubeconfig from Jenkins credentials
                    withCredentials([file(credentialsId: 'kubeconfig_id', variable: 'KUBECONFIG')]) {
                        // Now run kubectl commands, Helm commands, or other Kubernetes interactions
                        sh 'kubectl get ns'
                        // Example Helm command
                        sh 'helm upgrade --install helloworld ./charts/helloworld --namespace helloworld --create-namespace --set image.repository=hergi2004/helloworld,image.tag=latest'
                    }
                }
            }
        }
    }
}
