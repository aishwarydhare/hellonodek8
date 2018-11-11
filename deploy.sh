docker build -t aishwarydhare/hellonode:latest -t aishwarydhare/hellonode:$SHA .
docker build -t aishwarydhare/helloredis:latest -t aishwarydhare/helloredis:$SHA -f Dockerfile.redis .
docker push aishwarydhare/hellonode:latest
docker push aishwarydhare/helloredis:latest
docker push aishwarydhare/hellonode:$SHA
docker push aishwarydhare/helloredis:$SHA
kubectl apply -f k8s
kubectl set image deployments/node-server-deployment node-server-deployment=aishwarydhare/hellonode:$SHA
kubectl set image deployments/redis-server-deployment redis-server-deployment=aishwarydhare/helloredis:$SHA