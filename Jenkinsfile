
pipeline {
    
    agent any

    triggers {
        pollSCM('H/4 0 * * *')
    }

    environment {
        version     = ''
        app_version = '7.6.7'
    }
    
    options {
        timestamps()
        ansiColor('xterm')
    }

    stages {
        
        stage('Get Version') {
            steps {
                script {
                    setVersion()
                }
            }
        }

        stage('Build') {
            steps {
                // TODO: Need to ran gradle script with will build all docker images
                echo 'Building Docker Images ... '
                sh "./gradlew -Pversion=${env.app_version} docker --debug"
            }
        }

        stage('Deploy') {
            when {
                // Only say hello if a "greeting" is requested
                expression { env.BRANCH_NAME.trim().startsWith("release") == 'greeting' }
            }
            steps {
                // TODO: need to push all images to Docker Hub
                echo 'Pushing Docker Images to Hub ...'
            }
        }
    }
}

def setVersion() {
    branchName = env.BRANCH_NAME.trim()

    if( branchName == "master" ) {
        env.version = "master-SNAPSHOT"
    }
    else if(branchName.startsWith("feature") ) {
        env.version = branchName.split('/')[1]+"-SNAPSHOT"
    }
    else if( branchName.startsWith("hotfix")) {
        env.versin = branchName.split('/')[1]+"-SNAPSHOT"
    }
    else if( branchName.startsWith("release") ) {
        env.version = branchName.split('/')[1]
        env.app_version = version
    }
}
