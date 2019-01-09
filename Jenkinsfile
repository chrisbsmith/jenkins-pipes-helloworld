node {
  try {
    stage('Checkout') {
      checkout scm
    }
    stage('Prepare') {
      sh "git clean -fdx"
    }
    stage('Build Image') {
      // Need to put some logic here to determine if it is a new build or an existing build and skip this step if existing.
      // sh "oc new-build --strategy docker --binary --docker-image golang:1.11-alpine --name hello-world"
      sh "oc start-build hello-world --from-dir . --follow"
      sh "docker tag chrismith/hello-world:openshift chrismith/hello-world:openshift-tagged"
    }
    stage('Deploy') {
      sh "sleep 30 && oc rollout latest dc/hello-world"
    }
  } finally {
    stage('Cleanup') {
      echo "doing some cleanup..."
    }
  }
}
