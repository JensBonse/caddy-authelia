pipeline {
  environment {
    imagename = "jbhome/caddy-authelia"
    registryCredential = 'hub.docker.com'
    dockerImage = ''
    caddyVersion = ''
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
        sh "caddyVersion=\$(curl --silent \"https://api.github.com/repos/caddyserver/caddy/releases/latest\" | grep -Po \'\"tag_name\": \"\\K.*?(?=\")\')"
        script {
          docker.withRegistry( '', registryCredential ) {
            dockerImage.push('latest')
            dockerImage.push($caddyVersion)
          }
        }
      }
    }
    stage('Remove Unused docker image') {
      steps{
        sh "docker rmi $imagename:latest"
        sh "docker rmi caddy:builder-alpine"
        sh "docker rmi caddy:latest"
        sh "docker rmi \$(docker images -f dangling=true -q)"
      }
    }
  }
}
