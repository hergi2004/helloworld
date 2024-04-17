pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'hergi2004/helloworld:latest'
        REGISTRY = 'docker.io'
        VERSION = '1.0.0'
    }
    stages {
        stage('Build') {
            steps {
                script {
                    // Build the Docker image
                    VERSION = sh(script: 'echo $((`echo $VERSION | cut -d "." -f 3` + 1))', returnStdout: true).trim()
                    def customImage = docker.build("${REGISTRY}/${env.DOCKER_IMAGE}:${VERSION}")
                }
            }
        }
        stage('Push') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-registry-credentials') {                        
                        def image = docker.image("${REGISTRY}/hergi2004/helloworld:${VERSION}")
                        echo "Pushing image: ${image.id}"
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
                        sh 'helm upgrade --install helloworld ./charts/helloworld --namespace helloworld --create-namespace --set image.repository=hergi2004/helloworld,image.tag=${VERSION}'
                    }
                }
            }
        }
    }
}
