def name = "hello-world"
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
          // sh "oc new-build --strategy docker --binary --docker-image golang:1.11-alpine --name ${name}"
          //sh "oc start-build ${name} --from-dir . --follow"

          echo "I'm using the ${openshift.project()} project"

          def build = openshift.startBuild("${name} --from-dir .")
          build.untilEach{
            echo "phase = ${it.object().status.phase}"
            return it.object().status.phase == "Complete"
          }
          build.logs("-f")

          withCredentials([file(credentialsId: 'jenkins-dockerhub-jsonfile', variable: 'DOCKERHUBCREDS')]) {
            sh '''
              #!/bin/bash
              mkdir ~/.docker
              cp ${DOCKERHUBCREDS} ~/.docker/config.json
            '''
            sh "oc image mirror docker.io/chrismith/${name}:openshift docker.io/chrismith/${name}:${tag}"
          }
            
          
        }

        stage('Deploy') {
          // sh "sleep 10 && oc rollout latest dc/${name}"
          def dc = openshift.selector("dc", "${name}")
          dc.patch("\"{'spec':{'template':{'spec':{'containers':[{'name': '${name}', 'image':'chrismith/${name}:${tag}'}]}}}}\"")
          dc.rollout().latest()
          // dc.rollout().status()
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
