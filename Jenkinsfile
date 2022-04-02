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
          dockerImage = docker.build("$imagename", "--no-cache .")
        }
      }
    }
    stage('Deploy Image') {
      steps{
        script {
          docker.withRegistry( '', registryCredential ) {
            dockerImage.push("$CADDY_VERSION")
            dockerImage.push("latest")
          }
        }
        sh "docker tag $imagename $imagename:latest"
        sh "docker tag $imagename $imagename:$CADDY_VERSION"
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
