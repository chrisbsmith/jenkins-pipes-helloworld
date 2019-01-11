import groovy.json.JsonOutput
import groovy.json.JsonSlurper

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
          if (!openshift.selector("bc", "hello-world").exists()) {
          //  This should be the equivelant of the below lines that were initially executed
          // sh "oc new-build --strategy docker --binary --docker-image golang:1.11-alpine --name ${name}"
            def newBuild = openshift.newBuild("--name ${name}", "--strategy docker", "--binary")
          }

          def build = openshift.startBuild("${name} --from-dir .")
          build.untilEach{
            return it.object().status.phase == "Complete"
          }
          build.logs("-f")
        }
        stage('Move Image') {
          withCredentials([file(credentialsId: 'jenkins-dockerhub-jsonfile', variable: 'DOCKERHUBCREDS')]) {
            sh '''
              #!/bin/bash
              mkdir ~/.docker
              cp ${DOCKERHUBCREDS} ~/.docker/config.json
            '''
            sh "oc image mirror docker.io/chrismith/${name}:openshift docker.io/chrismith/${name}:${tag}"
          }
        }
        try {
          stage('Deploy') {
            def dc = openshift.selector("dc", "${name}")
            def patcher = [spec:[template:[spec:[containers:[["name": "${name}", "image": "docker.io/chrismith/${name}:${tag}"]]]]]]
            def patchCmd = ["'", JsonOutput.toJson(patcher), "'"]
            println patchCmd.join(" ")
            def patch = patchCmd.join(" ")
            dc.patch("${patch}")
          }
        }
        catch (err) {
          if (err.getMessage().contains('not patched')) {
            echo "Deployment was not patched"
            currentBuild.result = 'SUCCESS'
          }
          else { 
            echo "Caught error deploying"
            currentBuild.result = 'UNSTABLE'
            throw err
          }
        }
      }
    }
  } 
  catch ( e ) {
    echo "Caught: ${e}"
    currentBuild.result = 'FAILURE'
    throw e
  }
  finally {
    stage('Cleanup') {
      echo "doing some cleanup..."
      sh 'rm -rf ~/.docker'
    }
  }
}
