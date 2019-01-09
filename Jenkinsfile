node {
  try {
    stage('Checkout') {
      checkout scm
    }
    stage('Prepare') {
      sh "git clean -fdx"
    }
    stage('Build Image') {
      sh "oc new-build hello-world --from-file=Dockerfile --follow"
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
