node {
  try {
    stage('checkout') {
      checkout scm
    }
    stage('prepare') {
      sh "git clean -fdx"
    }
    // stage('build and push') {
    //   def hw = docker.build("chrismith/hello-world:openshift")
    //   hw.push("openshift")
    // }
    stage('deploy') {
      oc apply -f hello-world.yaml
    }
  } finally {
    stage('cleanup') {
      echo "doing some cleanup..."
    }
  }
}
