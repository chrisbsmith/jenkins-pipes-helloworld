node {
  try {
    stage('checkout') {
      checkout scm
    }
    stage('prepare') {
      sh "git clean -fdx"
    }
    stage('build image') {
      sh "oc new-build hello-world --from-file=Dockerfile --follow"
    }
    stage('deploy') {
      sh 'oc apply -f hello-world.yaml'
    }
  } finally {
    stage('cleanup') {
      echo "doing some cleanup..."
    }
  }
}
