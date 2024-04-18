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
                    def lastSegment = sh(script: 'echo $VERSION | awk -F "." \'{print $3}\'', returnStdout: true).trim()

                    if(lastSegment.isEmpty()) {
                        lastSegment = "0"
                    }

                    // Increment the last segment by 1
                    def nextVersion = lastSegment.toInteger() + 1
                    
                    // Concatenate the first two segments with the incremented last segment
                    VERSION = VERSION.replaceAll(/\d+$/, nextVersion.toString())
                    
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
