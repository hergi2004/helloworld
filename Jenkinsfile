pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'hergi2004/helloworld'
        REGISTRY = 'docker.io'
        VERSION = '1.0.0'
        VERSION_FORMAT='yyyy.MM.ddHH'
    }
    stages {
        stage('Build') {
            steps {
                script {
                    // Generate version based on current date and time
                    def currentDate = new Date().format(env.VERSION_FORMAT)
                    if(currentDate.isEmpty()) {
                        currentDate = "0.0.0"
                    }

                    echo "Current date: ${currentDate}"
                    echo "Build number: ${BUILD_NUMBER}"

                    // Concatenate the first two segments with the incremented last segment
                    VERSION = currentDate
                    
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

        // stage('Set Kubernetes Context') {
        //     steps {
        //         script {
        //             // Set the Kubernetes context to 'rancher-demo'
        //             sh 'export KUBECONFIG=/home/rancher/.kube/kube_config_cluster.yml && kubectl get ns'
        //         }
        //     }
        // }
        // stage('Deploy') {
        //     steps {
        //         script {
        //             // Deploy using Helm with the specified context
        //             sh 'helm upgrade --install helloworld ./charts/helloworld --namespace helloworld --create-namespace --set image.repository=hergi2004/helloworld,image.tag=1.0.0'
        //         }
        //     }
        // }

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
