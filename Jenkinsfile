
pipeline {
    
    agent any

    triggers {
        pollSCM('H/4 0 * * *')
    }
    
    options {
        timestamps()
        ansiColor('xterm')
    }

    stages {

        stage('Build') {
            steps {
                // TODO: Need to ran gradle script with will build all docker images
                echo 'Building Docker Images ... '
            }
        }

        stage('Deploy') {
            steps {
                // TODO: need to push all images to Docker Hub
                echo 'Pushing Docker Images to Hub ...'
            }
        }
    }
}