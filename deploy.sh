# Build images and tag them with respective pwd
docker build -t armansiyami/multi-client:latest -t armansiyami/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t armansiyami/multi-server:latest -t armansiyami/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t armansiyami/multi-worker:latest -t armansiyami/multi-worker:$SHA -f ./worker/Dockerfile ./worker

# Push images to docker hub
docker push armansiyami/multi-client:latest
docker push armansiyami/multi-server:latest
docker push armansiyami/multi-worker:latest

docker push armansiyami/multi-client:$SHA
docker push armansiyami/multi-server:$SHA
docker push armansiyami/multi-worker:$SHA

# Apply config files from kubernetes directory
kubectl apply -f k8s
kubectl set image deployments/server-deployment server=armansiyami/multi-server:$SHA
kubectl set image deployments/client-deployment client=armansiyami/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=armansiyami/multi-worker:$SHA

