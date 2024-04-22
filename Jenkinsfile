pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'hergi2004/helloworld'
        REGISTRY = 'docker.io'
        VERSION = ''
        CUSTOM_IMAGE = ''

        IS_MAJOR = false
        IS_MINOR = false
        IS_PATCH = true
    }
    stages {
        stage('Get Current Version') {
            steps {
                script {
                    // Get the current version of the Docker image
                    def currentVersion = sh(script: "docker pull $DOCKER_IMAGE | grep 'Status:' | cut -d ' ' -f3", returnStdout: true).trim()
                    
                    // Extract version number from the tag
                    def splitVersion = currentVersion.split('\\.')
                    def major = splitVersion[0] as Integer
                    def minor = splitVersion[1] as Integer
                    def patch = splitVersion[2] as Integer

                    if(env.BUILD_ID == null) {
                        env.BUILD_ID = 1
                    }

                    if(IS_MAJOR) {
                        major += 1
                        minor = 0
                        patch = 0
                    } else if(IS_MINOR) {
                        minor += 1
                        patch = 0
                    } else if(IS_PATCH) {
                        patch = env.BUILD_ID
                    }

                    // Set the new version number
                    VERSION = "${major}.${minor}.${patch}"

                    echo "Current version: $VERSION"
                }
            }
        }
        stage('Build') {
            steps {
                script {
                    // Build the Docker image 
                    // using the latest version number 
                    CUSTOM_IMAGE = docker.build("${REGISTRY}/${DOCKER_IMAGE}:${VERSION}")
                }
            }
        }
        stage('Push') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-registry-credentials') {                        
                        def image = docker.image(CUSTOM_IMAGE)
                        image.tag("latest")
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
                        sh "helm upgrade --install helloworld ./charts/helloworld --namespace helloworld --create-namespace --set image.repository=${DOCKER_IMAGE},image.tag=${VERSION}"
                    }

                }
            }
        }
    }
}
