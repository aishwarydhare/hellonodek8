node {
  try {
    stage('Checkout') {
        checkout scm
    }
    stage('Environment') {
        sh 'git --version'
        echo "Branch: ${env.BRANCH_NAME}"
        sh 'docker -v'
        sh 'printenv' 
    }
    stage('Create ENV Variables') {
        sh 'SHA=$(git rev-parse HEAD)'
        sh 'CLOUDSDK_CORE_DISABLE_PROMPTS=1'
    }
    stage('Set Up GCloud') {
        // sh 'rm -rf /var/lib/jenkins/google-cloud-sdk'
        // sh 'curl https://sdk.cloud.google.com | bash > /dev/null;'
        sh 'PATH=$PATH:/home/ubuntu/google-cloud-sdk/bin/gcloud'
        sh 'export PATH'
        sh 'gcloud components update kubectl'
        sh 'gcloud auth activate-service-account --key-file constant-crow-222204-2b2a815bdea2.json'
        sh 'gcloud config set project constant-crow-222204'
        sh 'gcloud config set compute/zone asia-south1-a'
        sh 'gcloud container clusters get-credentials standard-cluster-1'
    }
    stage('Build Docker'){
        sh 'echo $USER'
        sh 'echo "mytempdockerpass" | docker login -u "aishwarydhare" --password-stdin'
        sh 'docker build -t aishwarydhare/hellonode .'
        sh 'docker build -t aishwarydhare/helloredis -f Dockerfile.redis .'
    }
    stage('Docker Image Test'){
        sh 'docker run --name m-node-512 aishwarydhare/hellonode echo 1'
        sh 'docker run --name m-redis-512 aishwarydhare/hellonode echo 2'
    }
    stage('Deploy'){
        sh 'docker build -t aishwarydhare/hellonode:latest -t aishwarydhare/hellonode:$SHA .'
        sh 'docker build -t aishwarydhare/helloredis:latest -t aishwarydhare/helloredis:$SHA -f Dockerfile.redis .'
        sh 'docker push aishwarydhare/hellonode:latest'
        sh 'docker push aishwarydhare/helloredis:latest'
        sh 'docker push aishwarydhare/hellonode:$SHA'
        sh 'docker push aishwarydhare/helloredis:$SHA'
        sh 'kubectl apply -f k8s'
        sh 'kubectl set image deployments/node-server-deployment node-server-deployment=aishwarydhare/hellonode:$SHA'
        sh 'kubectl set image deployments/redis-server-deployment redis-server-deployment=aishwarydhare/helloredis:$SHA'
    }
    stage('Clean Docker test'){
      sh 'docker stop m-node-512'
      sh 'docker container rm m-node-512'
      sh 'docker stop m-redis-512'
      sh 'docker container rm m-redis-512'
    }
  }
  catch (err) {
    throw err
    stage('Clean Docker test'){
      sh 'docker stop m-node-512'
      sh 'docker container rm m-node-512'
      sh 'docker stop m-redis-512'
      sh 'docker container rm m-redis-512'
    }
  }
}

