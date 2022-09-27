#! /bin/bash
set -ex

which kubectl > /dev/null 2>&1|| { echo "Kubectl not installed"; exit 1; }

MODEL_NAME=flower-sample-test
cat << EOF > /tmp/kserve.yaml
apiVersion: "serving.kserve.io/v1beta1"
kind: "InferenceService"
metadata:
  name: $MODEL_NAME
spec:
  predictor:
    tensorflow:
      storageUri: "gs://kfserving-examples/models/tensorflow/flowers"
EOF

kubectl apply -f /tmp/kserve.yaml

kubectl wait isvc/$MODEL_NAME --for=condition=Ready --timeout=180s

INPUT_PATH=input.json
curl https://raw.githubusercontent.com/kserve/kserve/master/docs/samples/v1beta1/tensorflow/input.json -o ${INPUT_PATH}
INPUT_PATH=@./${INPUT_PATH}
HOSTNAME=$(kubectl get isvc ${MODEL_NAME} -o jsonpath='{.status.url}' | awk -F '//' '{print $2}')
LOAD_BALANCER_IP=$(kubectl get services -n istio-system istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

output=$(curl -X POST -vv -H "content-type: application/json" ${LOAD_BALANCER_IP}/v1/models/${MODEL_NAME}:predict -d $INPUT_PATH -o /tmp/output.json -w "%{http_code}" -H "Host: $HOSTNAME")

kubectl delete -f /tmp/kserve.yaml

cat /tmp/output.json
if [[ $output != "200" ]]; then
  echo "status code $output is not 200"
  exit 1;
fi
echo "Test pass"
exit 0
