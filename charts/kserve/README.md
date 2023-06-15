# kserve

---
![Version: 0.8.22](https://img.shields.io/badge/Version-0.8.22-informational?style=flat-square)
![AppVersion: 0.8.0](https://img.shields.io/badge/AppVersion-0.8.0-informational?style=flat-square)

A Helm chart for installing Kserve

## Introduction

This Helm chart installs [Kserve](https://kserve.github.io/website/0.8/) and it's CRDs. It also installs the dependencies that Kserve requires, unless disabled.
See `Chart.yaml` for full list of dependencies.

## Prerequisites

To use the charts here, [Helm](https://helm.sh/) must be configured for your
Kubernetes cluster. Setting up Kubernetes and Helm is outside the scope of
this README. Please refer to the Kubernetes and Helm documentation.

- **Helm 3.0+** – This chart was tested with Helm v3.9.0, but it is also expected to work with earlier Helm versions
- **Kubernetes 1.22+** – This chart was tested with Kind v1.22.7 and minikube kubernetes version 1.22.*
- When installing on minikube, please run in a separate shell:
  ```sh
  minikube tunnel
  ```
  This is to enable istio loadbalancer services to be allocated an IP address.

## Installation

### Add Helm repository

```shell
helm repo add caraml https://caraml-dev.github.io/helm-charts
```

### Installing the chart

This chart MUST be installed in the `kserve` namespace.
This command will install Kserve release named `kserve` in the `kserve` namespace.
Do not try to install into other namespaces as it will break with other installations.
Default chart values will be used for the installation:
```shell
$ helm install caraml/kserve --namespace kserve --create-namespace
```

You can (and most likely, should) override the default configuration with values suitable for your installation.
Refer to [Configuration](#configuration) section for the detailed description of available configuration keys.

### Uninstalling the chart

To uninstall `kserve` release:
```shell
$ helm uninstall -n kserve kserve
```

The command removes all the Kubernetes components associated with the chart and deletes the release.
This includes the dependencies that were installed for Kserve, e.g. Istio, Cert-Manager.

## Configuration

The following table lists the configurable parameters of the Kserve chart and their default values.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| agent.image.registry | string | `""` |  |
| agent.image.repository | string | `"kserve/agent"` |  |
| agent.image.tag | string | `"v0.8.0"` |  |
| agent.resources.limits.cpu | string | `"1000m"` |  |
| agent.resources.limits.memory | string | `"1Gi"` |  |
| agent.resources.requests.cpu | string | `"100m"` |  |
| agent.resources.requests.memory | string | `"100Mi"` |  |
| batcher.image.registry | string | `""` |  |
| batcher.image.repository | string | `"kserve/agent"` |  |
| batcher.image.tag | string | `"v0.8.0"` |  |
| batcher.resources.limits.cpu | string | `"1000m"` |  |
| batcher.resources.limits.memory | string | `"1Gi"` |  |
| batcher.resources.requests.cpu | string | `"1000m"` |  |
| batcher.resources.requests.memory | string | `"1Gi"` |  |
| cert-manager.enabled | bool | `true` |  |
| cert-manager.fullnameOverride | string | `"cert-manager"` |  |
| certManagerBase.enabled | bool | `true` |  |
| clusterServingRuntimes[0].name | string | `"kserve-lgbserver"` |  |
| clusterServingRuntimes[0].spec.containers[0].args[0] | string | `"--model_name={{.Name}}"` |  |
| clusterServingRuntimes[0].spec.containers[0].args[1] | string | `"--model_dir=/mnt/models"` |  |
| clusterServingRuntimes[0].spec.containers[0].args[2] | string | `"--http_port=8080"` |  |
| clusterServingRuntimes[0].spec.containers[0].args[3] | string | `"--nthread=1"` |  |
| clusterServingRuntimes[0].spec.containers[0].image | string | `"kserve/lgbserver:v0.8.0"` |  |
| clusterServingRuntimes[0].spec.containers[0].name | string | `"kserve-container"` |  |
| clusterServingRuntimes[0].spec.containers[0].resources.limits.cpu | string | `"1"` |  |
| clusterServingRuntimes[0].spec.containers[0].resources.limits.memory | string | `"2Gi"` |  |
| clusterServingRuntimes[0].spec.containers[0].resources.requests.cpu | string | `"1"` |  |
| clusterServingRuntimes[0].spec.containers[0].resources.requests.memory | string | `"2Gi"` |  |
| clusterServingRuntimes[0].spec.supportedModelFormats[0].autoSelect | bool | `true` |  |
| clusterServingRuntimes[0].spec.supportedModelFormats[0].name | string | `"lightgbm"` |  |
| clusterServingRuntimes[0].spec.supportedModelFormats[0].version | string | `"2"` |  |
| clusterServingRuntimes[1].name | string | `"kserve-mlserver"` |  |
| clusterServingRuntimes[1].spec.containers[0].env[0].name | string | `"MLSERVER_MODEL_IMPLEMENTATION"` |  |
| clusterServingRuntimes[1].spec.containers[0].env[0].value | string | `"{{.Labels.modelClass}}"` |  |
| clusterServingRuntimes[1].spec.containers[0].env[1].name | string | `"MLSERVER_HTTP_PORT"` |  |
| clusterServingRuntimes[1].spec.containers[0].env[1].value | string | `"8080"` |  |
| clusterServingRuntimes[1].spec.containers[0].env[2].name | string | `"MLSERVER_GRPC_PORT"` |  |
| clusterServingRuntimes[1].spec.containers[0].env[2].value | string | `"9000"` |  |
| clusterServingRuntimes[1].spec.containers[0].env[3].name | string | `"MODELS_DIR"` |  |
| clusterServingRuntimes[1].spec.containers[0].env[3].value | string | `"/mnt/models"` |  |
| clusterServingRuntimes[1].spec.containers[0].image | string | `"docker.io/seldonio/mlserver:0.5.3"` |  |
| clusterServingRuntimes[1].spec.containers[0].name | string | `"kserve-container"` |  |
| clusterServingRuntimes[1].spec.containers[0].resources.limits.cpu | string | `"1"` |  |
| clusterServingRuntimes[1].spec.containers[0].resources.limits.memory | string | `"2Gi"` |  |
| clusterServingRuntimes[1].spec.containers[0].resources.requests.cpu | string | `"1"` |  |
| clusterServingRuntimes[1].spec.containers[0].resources.requests.memory | string | `"2Gi"` |  |
| clusterServingRuntimes[1].spec.supportedModelFormats[0].name | string | `"sklearn"` |  |
| clusterServingRuntimes[1].spec.supportedModelFormats[0].version | string | `"0"` |  |
| clusterServingRuntimes[1].spec.supportedModelFormats[1].name | string | `"xgboost"` |  |
| clusterServingRuntimes[1].spec.supportedModelFormats[1].version | string | `"1"` |  |
| clusterServingRuntimes[1].spec.supportedModelFormats[2].name | string | `"lightgbm"` |  |
| clusterServingRuntimes[1].spec.supportedModelFormats[2].version | string | `"3"` |  |
| clusterServingRuntimes[1].spec.supportedModelFormats[3].autoSelect | bool | `true` |  |
| clusterServingRuntimes[1].spec.supportedModelFormats[3].name | string | `"mlflow"` |  |
| clusterServingRuntimes[1].spec.supportedModelFormats[3].version | string | `"1"` |  |
| clusterServingRuntimes[2].name | string | `"kserve-paddleserver"` |  |
| clusterServingRuntimes[2].spec.containers[0].args[0] | string | `"--model_name={{.Name}}"` |  |
| clusterServingRuntimes[2].spec.containers[0].args[1] | string | `"--model_dir=/mnt/models"` |  |
| clusterServingRuntimes[2].spec.containers[0].args[2] | string | `"--http_port=8080"` |  |
| clusterServingRuntimes[2].spec.containers[0].image | string | `"kserve/paddleserver:v0.8.0"` |  |
| clusterServingRuntimes[2].spec.containers[0].name | string | `"kserve-container"` |  |
| clusterServingRuntimes[2].spec.containers[0].resources.limits.cpu | string | `"1"` |  |
| clusterServingRuntimes[2].spec.containers[0].resources.limits.memory | string | `"2Gi"` |  |
| clusterServingRuntimes[2].spec.containers[0].resources.requests.cpu | string | `"1"` |  |
| clusterServingRuntimes[2].spec.containers[0].resources.requests.memory | string | `"2Gi"` |  |
| clusterServingRuntimes[2].spec.supportedModelFormats[0].autoSelect | bool | `true` |  |
| clusterServingRuntimes[2].spec.supportedModelFormats[0].name | string | `"paddle"` |  |
| clusterServingRuntimes[2].spec.supportedModelFormats[0].version | string | `"2"` |  |
| clusterServingRuntimes[3].name | string | `"kserve-pmmlserver"` |  |
| clusterServingRuntimes[3].spec.containers[0].args[0] | string | `"--model_name={{.Name}}"` |  |
| clusterServingRuntimes[3].spec.containers[0].args[1] | string | `"--model_dir=/mnt/models"` |  |
| clusterServingRuntimes[3].spec.containers[0].args[2] | string | `"--http_port=8080"` |  |
| clusterServingRuntimes[3].spec.containers[0].image | string | `"kserve/pmmlserver:v0.8.0"` |  |
| clusterServingRuntimes[3].spec.containers[0].name | string | `"kserve-container"` |  |
| clusterServingRuntimes[3].spec.containers[0].resources.limits.cpu | string | `"1"` |  |
| clusterServingRuntimes[3].spec.containers[0].resources.limits.memory | string | `"2Gi"` |  |
| clusterServingRuntimes[3].spec.containers[0].resources.requests.cpu | string | `"1"` |  |
| clusterServingRuntimes[3].spec.containers[0].resources.requests.memory | string | `"2Gi"` |  |
| clusterServingRuntimes[3].spec.supportedModelFormats[0].autoSelect | bool | `true` |  |
| clusterServingRuntimes[3].spec.supportedModelFormats[0].name | string | `"pmml"` |  |
| clusterServingRuntimes[3].spec.supportedModelFormats[0].version | string | `"3"` |  |
| clusterServingRuntimes[3].spec.supportedModelFormats[1].autoSelect | bool | `true` |  |
| clusterServingRuntimes[3].spec.supportedModelFormats[1].name | string | `"pmml"` |  |
| clusterServingRuntimes[3].spec.supportedModelFormats[1].version | string | `"4"` |  |
| clusterServingRuntimes[4].name | string | `"kserve-sklearnserver"` |  |
| clusterServingRuntimes[4].spec.containers[0].args[0] | string | `"--model_name={{.Name}}"` |  |
| clusterServingRuntimes[4].spec.containers[0].args[1] | string | `"--model_dir=/mnt/models"` |  |
| clusterServingRuntimes[4].spec.containers[0].args[2] | string | `"--http_port=8080"` |  |
| clusterServingRuntimes[4].spec.containers[0].image | string | `"kserve/sklearnserver:v0.8.0"` |  |
| clusterServingRuntimes[4].spec.containers[0].name | string | `"kserve-container"` |  |
| clusterServingRuntimes[4].spec.containers[0].resources.limits.cpu | string | `"1"` |  |
| clusterServingRuntimes[4].spec.containers[0].resources.limits.memory | string | `"2Gi"` |  |
| clusterServingRuntimes[4].spec.containers[0].resources.requests.cpu | string | `"1"` |  |
| clusterServingRuntimes[4].spec.containers[0].resources.requests.memory | string | `"2Gi"` |  |
| clusterServingRuntimes[4].spec.supportedModelFormats[0].autoSelect | bool | `true` |  |
| clusterServingRuntimes[4].spec.supportedModelFormats[0].name | string | `"sklearn"` |  |
| clusterServingRuntimes[4].spec.supportedModelFormats[0].version | string | `"1"` |  |
| clusterServingRuntimes[5].name | string | `"kserve-tensorflow-serving"` |  |
| clusterServingRuntimes[5].spec.containers[0].args[0] | string | `"--model_name={{.Name}}"` |  |
| clusterServingRuntimes[5].spec.containers[0].args[1] | string | `"--port=9000"` |  |
| clusterServingRuntimes[5].spec.containers[0].args[2] | string | `"--rest_api_port=8080"` |  |
| clusterServingRuntimes[5].spec.containers[0].args[3] | string | `"--model_base_path=/mnt/models"` |  |
| clusterServingRuntimes[5].spec.containers[0].args[4] | string | `"--rest_api_timeout_in_ms=60000"` |  |
| clusterServingRuntimes[5].spec.containers[0].command[0] | string | `"/usr/bin/tensorflow_model_server"` |  |
| clusterServingRuntimes[5].spec.containers[0].image | string | `"tensorflow/serving:2.6.2"` |  |
| clusterServingRuntimes[5].spec.containers[0].name | string | `"kserve-container"` |  |
| clusterServingRuntimes[5].spec.containers[0].resources.limits.cpu | string | `"1"` |  |
| clusterServingRuntimes[5].spec.containers[0].resources.limits.memory | string | `"2Gi"` |  |
| clusterServingRuntimes[5].spec.containers[0].resources.requests.cpu | string | `"1"` |  |
| clusterServingRuntimes[5].spec.containers[0].resources.requests.memory | string | `"2Gi"` |  |
| clusterServingRuntimes[5].spec.supportedModelFormats[0].autoSelect | bool | `true` |  |
| clusterServingRuntimes[5].spec.supportedModelFormats[0].name | string | `"tensorflow"` |  |
| clusterServingRuntimes[5].spec.supportedModelFormats[0].version | string | `"1"` |  |
| clusterServingRuntimes[5].spec.supportedModelFormats[1].autoSelect | bool | `true` |  |
| clusterServingRuntimes[5].spec.supportedModelFormats[1].name | string | `"tensorflow"` |  |
| clusterServingRuntimes[5].spec.supportedModelFormats[1].version | string | `"2"` |  |
| clusterServingRuntimes[6].name | string | `"kserve-torchserve"` |  |
| clusterServingRuntimes[6].spec.containers[0].args[0] | string | `"torchserve"` |  |
| clusterServingRuntimes[6].spec.containers[0].args[1] | string | `"--start"` |  |
| clusterServingRuntimes[6].spec.containers[0].args[2] | string | `"--model-store=/mnt/models/model-store"` |  |
| clusterServingRuntimes[6].spec.containers[0].args[3] | string | `"--ts-config=/mnt/models/config/config.properties"` |  |
| clusterServingRuntimes[6].spec.containers[0].env[0].name | string | `"TS_SERVICE_ENVELOPE"` |  |
| clusterServingRuntimes[6].spec.containers[0].env[0].value | string | `"{{.Labels.serviceEnvelope}}"` |  |
| clusterServingRuntimes[6].spec.containers[0].image | string | `"kserve/torchserve-kfs:0.5.3"` |  |
| clusterServingRuntimes[6].spec.containers[0].name | string | `"kserve-container"` |  |
| clusterServingRuntimes[6].spec.containers[0].resources.limits.cpu | string | `"1"` |  |
| clusterServingRuntimes[6].spec.containers[0].resources.limits.memory | string | `"2Gi"` |  |
| clusterServingRuntimes[6].spec.containers[0].resources.requests.cpu | string | `"1"` |  |
| clusterServingRuntimes[6].spec.containers[0].resources.requests.memory | string | `"2Gi"` |  |
| clusterServingRuntimes[6].spec.supportedModelFormats[0].autoSelect | bool | `true` |  |
| clusterServingRuntimes[6].spec.supportedModelFormats[0].name | string | `"pytorch"` |  |
| clusterServingRuntimes[6].spec.supportedModelFormats[0].version | string | `"1"` |  |
| clusterServingRuntimes[7].name | string | `"kserve-tritonserver"` |  |
| clusterServingRuntimes[7].spec.containers[0].args[0] | string | `"tritonserver"` |  |
| clusterServingRuntimes[7].spec.containers[0].args[1] | string | `"--model-store=/mnt/models"` |  |
| clusterServingRuntimes[7].spec.containers[0].args[2] | string | `"--grpc-port=9000"` |  |
| clusterServingRuntimes[7].spec.containers[0].args[3] | string | `"--http-port=8080"` |  |
| clusterServingRuntimes[7].spec.containers[0].args[4] | string | `"--allow-grpc=true"` |  |
| clusterServingRuntimes[7].spec.containers[0].args[5] | string | `"--allow-http=true"` |  |
| clusterServingRuntimes[7].spec.containers[0].image | string | `"nvcr.io/nvidia/tritonserver:21.09-py3"` |  |
| clusterServingRuntimes[7].spec.containers[0].name | string | `"kserve-container"` |  |
| clusterServingRuntimes[7].spec.containers[0].resources.limits.cpu | string | `"1"` |  |
| clusterServingRuntimes[7].spec.containers[0].resources.limits.memory | string | `"2Gi"` |  |
| clusterServingRuntimes[7].spec.containers[0].resources.requests.cpu | string | `"1"` |  |
| clusterServingRuntimes[7].spec.containers[0].resources.requests.memory | string | `"2Gi"` |  |
| clusterServingRuntimes[7].spec.supportedModelFormats[0].name | string | `"tensorrt"` |  |
| clusterServingRuntimes[7].spec.supportedModelFormats[0].version | string | `"8"` |  |
| clusterServingRuntimes[7].spec.supportedModelFormats[1].name | string | `"tensorflow"` |  |
| clusterServingRuntimes[7].spec.supportedModelFormats[1].version | string | `"1"` |  |
| clusterServingRuntimes[7].spec.supportedModelFormats[2].name | string | `"tensorflow"` |  |
| clusterServingRuntimes[7].spec.supportedModelFormats[2].version | string | `"2"` |  |
| clusterServingRuntimes[7].spec.supportedModelFormats[3].autoSelect | bool | `true` |  |
| clusterServingRuntimes[7].spec.supportedModelFormats[3].name | string | `"onnx"` |  |
| clusterServingRuntimes[7].spec.supportedModelFormats[3].version | string | `"1"` |  |
| clusterServingRuntimes[7].spec.supportedModelFormats[4].name | string | `"pytorch"` |  |
| clusterServingRuntimes[7].spec.supportedModelFormats[4].version | string | `"1"` |  |
| clusterServingRuntimes[7].spec.supportedModelFormats[5].autoSelect | bool | `true` |  |
| clusterServingRuntimes[7].spec.supportedModelFormats[5].name | string | `"triton"` |  |
| clusterServingRuntimes[7].spec.supportedModelFormats[5].version | string | `"2"` |  |
| clusterServingRuntimes[8].name | string | `"kserve-xgbserver"` |  |
| clusterServingRuntimes[8].spec.containers[0].args[0] | string | `"--model_name={{.Name}}"` |  |
| clusterServingRuntimes[8].spec.containers[0].args[1] | string | `"--model_dir=/mnt/models"` |  |
| clusterServingRuntimes[8].spec.containers[0].args[2] | string | `"--http_port=8080"` |  |
| clusterServingRuntimes[8].spec.containers[0].args[3] | string | `"--nthread=1"` |  |
| clusterServingRuntimes[8].spec.containers[0].image | string | `"kserve/xgbserver:v0.8.0"` |  |
| clusterServingRuntimes[8].spec.containers[0].name | string | `"kserve-container"` |  |
| clusterServingRuntimes[8].spec.containers[0].resources.limits.cpu | string | `"1"` |  |
| clusterServingRuntimes[8].spec.containers[0].resources.limits.memory | string | `"2Gi"` |  |
| clusterServingRuntimes[8].spec.containers[0].resources.requests.cpu | string | `"1"` |  |
| clusterServingRuntimes[8].spec.containers[0].resources.requests.memory | string | `"2Gi"` |  |
| clusterServingRuntimes[8].spec.supportedModelFormats[0].autoSelect | bool | `true` |  |
| clusterServingRuntimes[8].spec.supportedModelFormats[0].name | string | `"xgboost"` |  |
| clusterServingRuntimes[8].spec.supportedModelFormats[0].version | string | `"1"` |  |
| controller.affinity | object | `{}` |  |
| controller.image.pullPolicy | string | `"IfNotPresent"` |  |
| controller.image.registry | string | `""` |  |
| controller.image.repository | string | `"kserve/kserve-controller"` |  |
| controller.image.tag | string | `"v0.8.0"` |  |
| controller.nodeSelector | object | `{}` |  |
| controller.resources | object | `{"limits":{"cpu":"1000m","memory":"512Mi"},"requests":{"cpu":"500m","memory":"512Mi"}}` | These are example resource values set for the controller, please override accordingly |
| controller.tolerations | list | `[]` |  |
| defaultDeploymentMode | string | `"Serverless"` | Specify how inference service is deployed: - Serverless, use Knative - RawDeployment, use K8S Deployment |
| ingress | object | `{"domainTemplate":"{{ .Name }}-{{ .Namespace }}.{{ .IngressDomain }}","ingressClassName":"istio","ingressDomain":"example.com","ingressGateway":"knative-serving/knative-ingress-gateway","ingressService":"istio-ingressgateway.istio-system.svc.cluster.local","localGateway":"knative-serving/knative-local-gateway","localGatewayService":"cluster-local-gateway.istio-system.svc.cluster.local"}` | Ingress configuration |
| ingress.ingressDomain | string | `"example.com"` | domain used for inferenceservice deployments |
| ingress.ingressGateway | string | `"knative-serving/knative-ingress-gateway"` | ingressGateway refers to the Istio Gateway resource name. Assumed to be in knative-serving namespace by default. |
| ingress.ingressService | string | `"istio-ingressgateway.istio-system.svc.cluster.local"` | ingressService refers to the ingressgateway service name. Assumed to be in istio-system namespace by default. |
| ingress.localGateway | string | `"knative-serving/knative-local-gateway"` | localGateway refers to the Istio Gateway resource name. Assumed to in knative-serving namespace by default. |
| ingress.localGatewayService | string | `"cluster-local-gateway.istio-system.svc.cluster.local"` | ingressService refers to the local ingressgateway service name. Assumed to be in istio-system namespace by default and called cluster-local-gateway. |
| knativeServingIstio.enabled | bool | `true` |  |
| knativeServingIstio.helmChart.chart | string | `"knative-serving-istio"` |  |
| knativeServingIstio.helmChart.createNamespace | bool | `true` |  |
| knativeServingIstio.helmChart.namespace | string | `"knative-serving"` |  |
| knativeServingIstio.helmChart.release | string | `"knative-serving"` |  |
| knativeServingIstio.helmChart.repository | string | `"https://caraml-dev.github.io/helm-charts"` |  |
| knativeServingIstio.helmChart.version | string | `"1.7.4"` |  |
| labels | object | `{"common":{}}` | For release specific common labels |
| logger.defaultUrl | string | `"http://default-broker"` |  |
| logger.image.registry | string | `""` |  |
| logger.image.repository | string | `"kserve/agent"` |  |
| logger.image.tag | string | `"v0.8.0"` |  |
| logger.resources.limits.cpu | string | `"1000m"` |  |
| logger.resources.limits.memory | string | `"1Gi"` |  |
| logger.resources.requests.cpu | string | `"100m"` |  |
| logger.resources.requests.memory | string | `"100Mi"` |  |
| predictors.lightgbm.defaultImageVersion | string | `"v0.8.0"` |  |
| predictors.lightgbm.image | string | `"kserve/lgbserver"` |  |
| predictors.lightgbm.multiModelServer | bool | `false` |  |
| predictors.lightgbm.supportedFrameworks[0] | string | `"lightgbm"` |  |
| predictors.onnx.defaultImageVersion | string | `"v1.0.0"` |  |
| predictors.onnx.image | string | `"mcr.microsoft.com/onnxruntime/server"` |  |
| predictors.onnx.multiModelServer | bool | `false` |  |
| predictors.onnx.supportedFrameworks[0] | string | `"onnx"` |  |
| predictors.paddle.defaultImageVersion | string | `"v0.8.0"` |  |
| predictors.paddle.image | string | `"kserve/paddleserver"` |  |
| predictors.paddle.multiModelServer | bool | `false` |  |
| predictors.paddle.supportedFrameworks[0] | string | `"paddle"` |  |
| predictors.pmml.defaultImageVersion | string | `"v0.8.0"` |  |
| predictors.pmml.image | string | `"kserve/pmmlserver"` |  |
| predictors.pmml.multiModelServer | bool | `false` |  |
| predictors.pmml.supportedFrameworks[0] | string | `"pmml"` |  |
| predictors.pytorch.v1.defaultGpuImageVersion | string | `"0.5.3-gpu"` |  |
| predictors.pytorch.v1.defaultImageVersion | string | `"0.5.3"` |  |
| predictors.pytorch.v1.image | string | `"kserve/torchserve-kfs"` |  |
| predictors.pytorch.v1.multiModelServer | bool | `false` |  |
| predictors.pytorch.v1.supportedFrameworks[0] | string | `"pytorch"` |  |
| predictors.pytorch.v2.defaultGpuImageVersion | string | `"0.5.3-gpu"` |  |
| predictors.pytorch.v2.defaultImageVersion | string | `"0.5.3"` |  |
| predictors.pytorch.v2.image | string | `"kserve/torchserve-kfs"` |  |
| predictors.pytorch.v2.multiModelServer | bool | `false` |  |
| predictors.pytorch.v2.supportedFrameworks[0] | string | `"pytorch"` |  |
| predictors.sklearn.v1.defaultImageVersion | string | `"v0.8.0"` |  |
| predictors.sklearn.v1.image | string | `"kserve/sklearnserver"` |  |
| predictors.sklearn.v1.multiModelServer | bool | `true` |  |
| predictors.sklearn.v1.supportedFrameworks[0] | string | `"sklearn"` |  |
| predictors.sklearn.v2.defaultImageVersion | string | `"0.5.3"` |  |
| predictors.sklearn.v2.image | string | `"docker.io/seldonio/mlserver"` |  |
| predictors.sklearn.v2.multiModelServer | bool | `true` |  |
| predictors.sklearn.v2.supportedFrameworks[0] | string | `"sklearn"` |  |
| predictors.tensorflow.defaultGpuImageVersion | string | `"2.6.2-gpu"` |  |
| predictors.tensorflow.defaultImageVersion | string | `"2.6.2"` |  |
| predictors.tensorflow.defaultTimeout | string | `"60"` |  |
| predictors.tensorflow.image | string | `"tensorflow/serving"` |  |
| predictors.tensorflow.multiModelServer | bool | `false` |  |
| predictors.tensorflow.supportedFrameworks[0] | string | `"tensorflow"` |  |
| predictors.triton.defaultImageVersion | string | `"21.09-py3"` |  |
| predictors.triton.image | string | `"nvcr.io/nvidia/tritonserver"` |  |
| predictors.triton.multiModelServer | bool | `true` |  |
| predictors.triton.supportedFrameworks[0] | string | `"tensorrt"` |  |
| predictors.triton.supportedFrameworks[1] | string | `"tensorflow"` |  |
| predictors.triton.supportedFrameworks[2] | string | `"onnx"` |  |
| predictors.triton.supportedFrameworks[3] | string | `"pytorch"` |  |
| predictors.xgboost.v1.defaultImageVersion | string | `"v0.8.0"` |  |
| predictors.xgboost.v1.image | string | `"kserve/xgbserver"` |  |
| predictors.xgboost.v1.multiModelServer | bool | `true` |  |
| predictors.xgboost.v1.supportedFrameworks[0] | string | `"xgboost"` |  |
| predictors.xgboost.v2.defaultImageVersion | string | `"0.5.3"` |  |
| predictors.xgboost.v2.image | string | `"docker.io/seldonio/mlserver"` |  |
| predictors.xgboost.v2.multiModelServer | bool | `true` |  |
| predictors.xgboost.v2.supportedFrameworks[0] | string | `"xgboost"` |  |
| storageInitializer.image.registry | string | `""` |  |
| storageInitializer.image.repository | string | `"kserve/storage-initializer"` |  |
| storageInitializer.image.tag | string | `"v0.8.0"` |  |
| storageInitializer.resources.limits.cpu | string | `"1000m"` |  |
| storageInitializer.resources.limits.memory | string | `"1Gi"` |  |
| storageInitializer.resources.requests.cpu | string | `"100m"` |  |
| storageInitializer.resources.requests.memory | string | `"100Mi"` |  |
