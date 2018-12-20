node {
  try {
    stage('checkout') {
      checkout scm
    }
    stage('prepare') {
      sh "git clean -fdx"
    }
    stage('compile') {
      docker build -t chrismith/hello-world:openshift
    }
    stage('push') {
      docker push chrismith/hello-world:openshift
    }
    stage('deploy') {
      oc apply -f hello-world.yaml
    }
  } finally {
    stage('cleanup') {
      echo "doing some cleanup..."
    }
  }
}
