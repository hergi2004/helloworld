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
        stage('Set Kubernetes Context') {
            steps {
                script {
                    // Set the Kubernetes context to 'rancher-demo'
                    sh 'export KUBECONFIG=/home/rancher/.kube/kube_config_cluster.yml'
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    // Deploy using Helm with the specified context
                    sh 'helm upgrade --install helloworld ./charts/helloworld --namespace helloworld --create-namespace --set image.repository=hergi2004/helloworld,image.tag=1.0.0'
                }
            }
        }
    }
}
