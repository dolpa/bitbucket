
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
        
        stage('Get Version') {
            steps {
                script {
                    env.version = getVersion()
                }
            }
        }

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

def getVersion() {
    branchName = env.BRANCH_NAME.trim()

    if( branchName == "master" ) {
        version = "master-SNAPSHOT"
    }
    else if(branchName.startsWith("feature") ) {
        version = branchName.split('/')[1]+"-SNAPSHOT"
    }
    else if( branchName.startsWith("hotfix")) {
        versin = branchName.split('/')[1]+"-SNAPSHOT"
    }
    else if( branchName.startsWith("release") ) {
        version = branchName.split('/')[1]
    }

    return version
}
