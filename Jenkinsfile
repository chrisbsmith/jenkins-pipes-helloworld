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
    }
    stage('Deploy') {
      sh 'oc apply -f hello-world.yaml'
    }
  } finally {
    stage('Cleanup') {
      echo "doing some cleanup..."
    }
  }
}
