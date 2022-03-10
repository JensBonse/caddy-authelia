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
        //sh "caddyVersion=\$(curl --silent \"https://api.github.com/repos/caddyserver/caddy/releases/latest\" | grep -Po \'\"tag_name\": \"\\K.*?(?=\")\')"
        caddyVersion = sh( returnStdout: true, 'echo \$(curl --silent \"https://api.github.com/repos/caddyserver/caddy/releases/latest\" | grep -Po \'\"tag_name\": \"\\K.*?(?=\")\')' )
        //sh "curl --silent \"https://api.github.com/repos/caddyserver/caddy/releases/latest\" | grep -Po \'\"tag_name\": \"\\K.*?(?=\")\'"
        sh "docker tag $imagename $imagename:latest"
        sh "docker tag $imagename $imagename:Caddy-$caddyVersion"
        script {
          docker.withRegistry( '', registryCredential ) {
            dockerImage.push('latest')
            dockerImage.push('Caddy-$caddyVersion')
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
