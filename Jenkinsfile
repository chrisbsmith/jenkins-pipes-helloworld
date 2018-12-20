node {
  def hw
  try {
    stage('checkout') {
      checkout scm
    }
    stage('prepare') {
      sh "git clean -fdx"
    }
    stage('compile') {
      hw = docker.build{"chrismith/hello-world:openshift"}
    }
    stage('push') {
      hw.push()
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
