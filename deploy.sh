docker build -t aishwarydhare/hellonode:latest -t aishwarydhare/hellonode:$SHA .
docker build -t aishwarydhare/helloredis:latest -t aishwarydhare/helloredis:$SHA -f Dockerfile.redis .
docker push aishwarydhare/hellonode:latest
docker push aishwarydhare/helloredis:latest
docker push aishwarydhare/hellonode:$SHA
docker push aishwarydhare/helloredis:$SHA
kubectl apply -f k8s
kubectl set image deployments/node-server-deployment server=aishwarydhare/hellonode:$SHA
kubectl set image deployments/redis-server-deployment server=aishwarydhare/hellonode:$SHA