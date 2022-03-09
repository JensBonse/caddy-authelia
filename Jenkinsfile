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
        script {
          dockerImage = docker.build imagename
        }
      }
    }
    stage('Deploy Image') {
      steps{
        script {
          docker.withRegistry( '', registryCredential ) {
            dockerImage.push('latest')
          }
        }
      }
    }
    stage('Remove Unused docker image') {
      steps{
        sh "docker rmi $imagename:latest"
        sh "docker rmi caddy:builder-alpine"
        sh "docker rmi caddy:latest"
        sh "docker rmi $(docker images -f dangling=true -q)"
      }
    }
  }
}
