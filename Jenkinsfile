pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'hergi2004/helloworld:1.0.0'
        REGISTRY = 'docker.io/hergi2004/helloworld'
    }
    stages {
        stage('Build') {
            steps {
                script {
                    docker.build(env.DOCKER_IMAGE)
                }
            }
        }
        // stage('Push') {
        //     steps {
        //         script {
        //             docker.withRegistry('https://'+env.REGISTRY, 'docker-registry-credentials') {
        //                 docker.image(env.DOCKER_IMAGE).push()
        //             }
        //         }
        //     }
        // }

        stage('Push image') {
            withCredentials([usernamePassword( credentialsId: 'docker-registry-credentials', usernameVariable: 'hergi2004', passwordVariable: 'ttherve1987')]) {
                def registry_url = "docker.io/hergi2004/helloworld"
                bat "docker login -u $USER -p $PASSWORD ${registry_url}"
                docker.withRegistry("http://${registry_url}", "docker-registry-credentials") {
                    // Push your image now
                    bat "docker push hergi2004/helloworld:1.0.0"
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
