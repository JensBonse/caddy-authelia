pipeline {
  environment {
    imagename = "jbhome/caddy-authelia"
    registryCredential = 'hub.docker.com'
    dockerImage = ''
  }
  agent any
  stages {
    stage('Building image') {
      steps{
        sh "chmod +x ./get-version.sh"
        sh "./get-version.sh"	// Get caddy version and store in version.properties
        load "./version.properties"
        script {
          dockerImage = docker.build imagename + ":$CADDY_VERSION"
        }
      }
    }
    stage('Deploy Image') {
      steps{
        sh "docker tag $imagename:$CADDY_VERSION $imagename:latest"
        script {
          docker.withRegistry( '', registryCredential ) {
            dockerImage.push()
          }
        }
      }
    }
    stage('Remove Unused docker image') {
      steps{
        sh "docker rmi caddy:builder-alpine"
        sh "docker rmi caddy:latest"
        catchError(buildResult: 'SUCCESS', stageResult: 'SUCCESS')
        {
          sh "docker rmi \$(docker images -f dangling=true -q)"
        }
      }
    }
  }
}
