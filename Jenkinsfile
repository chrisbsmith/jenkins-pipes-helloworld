
def tag

node {
  try {
    stage('Checkout') {
      checkout scm
    }
    stage('Prepare') {
      sh "git clean -fdx"
      tag = readFile('VERSION').trim()
    }
    openshift.withCluster() {
      openshift.withProject() {
        stage('Build Image') {
          // Need to put some logic here to determine if it is a new build or an existing build and skip this step if existing.
          // sh "oc new-build --strategy docker --binary --docker-image golang:1.11-alpine --name hello-world"
          //sh "oc start-build hello-world --from-dir . --follow"

          echo "I'm using the ${openshift.project()} project"

          def build = openshift.startBuild("hello-world --from-dir .")
          build.untilEach{
            echo "phase = ${it.object().status.phase}"
            return it.object().status.phase == "Complete"
          }
          build.logs("-f")

          // withCredentials([usernamePassword(credentialsId: 'jenkins-dockerhub-userpass',
          //                     usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {

          
          // println(env.USERNAME)
          //   }
          // withCredentials([file(credentialsId: 'jenkins-dockerhub-jsonfile', variable: 'DOCKERHUBCREDS')]) {
          //   sh '''
          //     #!/bin/bash
          //     mkdir ~/.docker
          //     cp ${DOCKERHUBCREDS} ~/.docker/config.json
          //   '''
          //   sh "oc image mirror docker.io/chrismith/hello-world:openshift docker.io/chrismith/hello-world:${tag}"
          // }
            
          
        }

        stage('Deploy') {
          // sh "sleep 10 && oc rollout latest dc/hello-world"
          def dc = openshift.selector("dc", "hello-worl")
          // dc.rollout().latest()
          dc.rollout().status()
        }
      }
    }
    

  } finally {
    stage('Cleanup') {
      echo "doing some cleanup..."
      sh 'rm -rf ~/.docker'
    }
  }
}
