#! /bin/bash
set -ex

which kubectl > /dev/null 2>&1|| { echo "Kubectl not installed"; exit 1; }

cat << EOF > /tmp/knative_service.yaml
apiVersion: serving.knative.dev/v1
kind: Service
metadata:
  name: hello
spec:
  template:
    spec:
      containers:
        - image: gcr.io/knative-samples/helloworld-go
          ports:
            - containerPort: 8080
          env:
            - name: TARGET
              value: "World"
EOF

kubectl apply -f /tmp/knative_service.yaml

kubectl wait ksvc/hello --for=condition=Ready --timeout=60s

HOSTNAME=$(kubectl get ksvc hello -o jsonpath='{.status.url}' | awk -F '//' '{print $2}')
LOAD_BALANCER_IP=$(kubectl get services -n istio-system istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

output=$(curl $LOAD_BALANCER_IP -o /dev/null -w "%{http_code}" -H "Host: $HOSTNAME")

kubectl delete -f /tmp/knative_service.yaml

if [[ $output != "200" ]]; then
  echo "status code $output is not 200"
  exit 1;
fi
echo "Test pass"
exit 0
