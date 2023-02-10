# knative-serving-istio

---
![Version: 1.7.2](https://img.shields.io/badge/Version-1.7.2-informational?style=flat-square)
![AppVersion: v1.7.1](https://img.shields.io/badge/AppVersion-v1.7.1-informational?style=flat-square)

Installs Knative-serving for Istio

## Introduction

This Helm chart installs [Knative Serving Istio](https://knative.dev/docs/serving/) and it's CRDs.

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

This command will install Knative release named `knative-serving` in the `knative-serving` namespace.
Do not try to install into other namespaces as it will break with other installations like Kserve.
Default chart values will be used for the installation:
```shell
$ helm install caraml/knative-serving-istio --namespace knative-serving
```

You can (and most likely, should) override the default configuration with values suitable for your installation.
Refer to [Configuration](#configuration) section for the detailed description of available configuration keys.

### Uninstalling the chart

To uninstall `knative-net-istio` release:
```shell
$ helm uninstall -n knative-serving knative-serving-istio
```

The command removes all the Kubernetes components associated with the chart and deletes the release,
except for postgresql PVC, those will have to be removed manually.

## Configuration

The following table lists the configurable parameters of the Knative Net Istio chart and their default values.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| base.enabled | bool | `true` | Set to false if there is an existing istio deployment |
| base.global.istioNamespace | string | `"istio-system"` |  |
| base.validationURL | string | `""` |  |
| clusterLocalGateway.chartValues.autoscaling.enabled | bool | `false` |  |
| clusterLocalGateway.chartValues.env.ISTIO_METAJSON_STATS | string | `"{\\\"sidecar.istio.io/statsInclusionSuffixes\\\": \\\"upstream_rq_1xx,upstream_rq_2xx,upstream_rq_3xx,upstream_rq_4xx,upstream_rq_5xx,upstream_rq_time,upstream_cx_tx_bytes_total,upstream_cx_rx_bytes_total,upstream_cx_total,downstream_rq_1xx,downstream_rq_2xx,downstream_rq_3xx,downstream_rq_4xx,downstream_rq_5xx,downstream_rq_time,downstream_cx_tx_bytes_total,downstream_cx_rx_bytes_total,downstream_cx_total\\\"}\n"` |  |
| clusterLocalGateway.chartValues.global.enabled | bool | `true` | Controls deployment of cluster-local-gateway. Set to false if there is an existing istio deployment |
| clusterLocalGateway.chartValues.labels.app | string | `"cluster-local-gateway"` |  |
| clusterLocalGateway.chartValues.labels.istio | string | `"cluster-local-gateway"` |  |
| clusterLocalGateway.chartValues.name | string | `"cluster-local-gateway"` | Specify name here so each gateway installation has its own unique name |
| clusterLocalGateway.chartValues.resources.limits.cpu | string | `"2000m"` |  |
| clusterLocalGateway.chartValues.resources.limits.memory | string | `"2048Mi"` |  |
| clusterLocalGateway.chartValues.resources.requests.cpu | string | `"1000m"` |  |
| clusterLocalGateway.chartValues.resources.requests.memory | string | `"1024Mi"` |  |
| clusterLocalGateway.chartValues.service.ports[0].name | string | `"http2"` |  |
| clusterLocalGateway.chartValues.service.ports[0].port | int | `80` |  |
| clusterLocalGateway.chartValues.service.ports[0].targetPort | int | `80` |  |
| clusterLocalGateway.chartValues.service.ports[1].name | string | `"https"` |  |
| clusterLocalGateway.chartValues.service.ports[1].port | int | `443` |  |
| clusterLocalGateway.chartValues.service.type | string | `"ClusterIP"` |  |
| clusterLocalGateway.chartValues.serviceAccount.create | bool | `true` |  |
| clusterLocalGateway.chartValues.serviceAccount.name | string | `"cluster-local-gateway"` |  |
| clusterLocalGateway.global.enabled | bool | `true` | Controls deployment of cluster-local-gateway. Set to false if there is an existing istio deployment |
| clusterLocalGateway.helmChart.chart | string | `"gateway"` |  |
| clusterLocalGateway.helmChart.createNamespace | bool | `false` |  |
| clusterLocalGateway.helmChart.namespace | string | `"istio-system"` |  |
| clusterLocalGateway.helmChart.release | string | `"cluster-local-gateway"` |  |
| clusterLocalGateway.helmChart.repository | string | `"https://istio-release.storage.googleapis.com/charts"` |  |
| clusterLocalGateway.helmChart.version | string | `"1.13.9"` |  |
| clusterLocalGateway.hook.weight | int | `1` |  |
| clusterLocalGatewayIstioSelector | string | `"cluster-local-gateway"` |  |
| config | object | `{"istio":{"enable-virtualservice-status":"false","gateway.{{ .Release.Namespace }}.knative-ingress-gateway":"istio-ingressgateway.istio-system.svc.cluster.local","local-gateway.{{ .Release.Namespace }}.knative-local-gateway":"cluster-local-gateway.istio-system.svc.cluster.local"}}` | Please check out the Knative documentation in https://github.com/knative-sandbox/net-istio/releases/download/knative-v1.0.0/net-istio.yaml |
| controller.autoscaling.enabled | bool | `false` | Enables autoscaling for net-istio-controller deployment. |
| controller.image.repository | string | `"gcr.io/knative-releases/knative.dev/net-istio/cmd/controller"` | Repository of the controller image |
| controller.image.sha | string | `"c110b0b5d545561f220d23bdb48a6c75f5591d068de9fb079baad47c82903e28"` | SHA256 of the controller image, either provide tag or SHA (SHA will be given priority) |
| controller.image.tag | string | `""` | Tag of the controller image, either provide tag or SHA (SHA will be given priority) |
| controller.replicaCount | int | `1` | Number of replicas for the net-istio-controller deployment. |
| controller.resources | object | `{"limits":{"cpu":"1000m","memory":"512Mi"},"requests":{"cpu":"500m","memory":"512Mi"}}` | Resources requests and limits for net-istio-controller. This should be set according to your cluster capacity and service level objectives. Reference: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ |
| global.affinity | object | `{}` | Assign custom affinity rules to the prometheus operator ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/ |
| global.extraPodLabels | object | `{}` | Extra pod labels in a map[string]string format, most likely to be used for the costing labels. |
| global.nodeSelector | object | `{}` | Define which Nodes the Pods are scheduled on. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| global.tolerations | list | `[]` | If specified, the pod's tolerations. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| istioIngressGateway.chartValues.autoscaling.enabled | bool | `false` |  |
| istioIngressGateway.chartValues.env.ISTIO_METAJSON_STATS | string | `"{\\\"sidecar.istio.io/statsInclusionSuffixes\\\": \\\"upstream_rq_1xx,upstream_rq_2xx,upstream_rq_3xx,upstream_rq_4xx,upstream_rq_5xx,upstream_rq_time,upstream_cx_tx_bytes_total,upstream_cx_rx_bytes_total,upstream_cx_total,downstream_rq_1xx,downstream_rq_2xx,downstream_rq_3xx,downstream_rq_4xx,downstream_rq_5xx,downstream_rq_time,downstream_cx_tx_bytes_total,downstream_cx_rx_bytes_total,downstream_cx_total\\\"}\n"` |  |
| istioIngressGateway.chartValues.env.ISTIO_META_ROUTER_MODE | string | `"standard"` |  |
| istioIngressGateway.chartValues.name | string | `"istio-ingressgateway"` | Specify name here so each gateway installation has its own unique name |
| istioIngressGateway.chartValues.resources.limits.cpu | string | `"2000m"` |  |
| istioIngressGateway.chartValues.resources.limits.memory | string | `"2048Mi"` |  |
| istioIngressGateway.chartValues.resources.requests.cpu | string | `"1000m"` |  |
| istioIngressGateway.chartValues.resources.requests.memory | string | `"1024Mi"` |  |
| istioIngressGateway.chartValues.serviceAccount.create | bool | `true` |  |
| istioIngressGateway.chartValues.serviceAccount.name | string | `"istio-ingressgateway"` |  |
| istioIngressGateway.global.enabled | bool | `true` | Controls deployment of istio-ingressgateway. Set to false if there is an existing istio deployment |
| istioIngressGateway.helmChart.chart | string | `"gateway"` |  |
| istioIngressGateway.helmChart.createNamespace | bool | `false` |  |
| istioIngressGateway.helmChart.namespace | string | `"istio-system"` |  |
| istioIngressGateway.helmChart.release | string | `"istio-ingress-gateway"` |  |
| istioIngressGateway.helmChart.repository | string | `"https://istio-release.storage.googleapis.com/charts"` |  |
| istioIngressGateway.helmChart.version | string | `"1.13.9"` |  |
| istioIngressGateway.hook.weight | int | `1` |  |
| istiod.chartValues.configValidation | bool | `true` |  |
| istiod.chartValues.deployInReleaseNs | bool | `false` |  |
| istiod.chartValues.global.configValidation | bool | `true` |  |
| istiod.chartValues.global.istioNamespace | string | `"istio-system"` |  |
| istiod.chartValues.meshConfig.enableTracing | bool | `false` |  |
| istiod.chartValues.pilot.autoscaleEnabled | bool | `false` |  |
| istiod.chartValues.pilot.cpu.targetAverageUtilization | int | `80` |  |
| istiod.chartValues.pilot.resources.limits.cpu | string | `"1000m"` |  |
| istiod.chartValues.pilot.resources.limits.memory | string | `"1024Mi"` |  |
| istiod.chartValues.pilot.resources.requests.cpu | string | `"500m"` |  |
| istiod.chartValues.pilot.resources.requests.memory | string | `"512Mi"` |  |
| istiod.enabled | bool | `true` | Set to false if there is an existing istio deployment |
| istiod.helmChart.chart | string | `"istiod"` |  |
| istiod.helmChart.namespace | string | `"istio-system"` |  |
| istiod.helmChart.release | string | `"istiod"` |  |
| istiod.helmChart.repository | string | `"https://istio-release.storage.googleapis.com/charts"` |  |
| istiod.helmChart.version | string | `"1.13.9"` |  |
| istiod.hook.weight | int | `0` |  |
| knativeServingCore.activator.autoscaling.enabled | bool | `false` | Enables autoscaling for activator deployment. |
| knativeServingCore.activator.image.repository | string | `"gcr.io/knative-releases/knative.dev/serving/cmd/activator"` | Repository of the activator image |
| knativeServingCore.activator.image.sha | string | `"ca607f73e5daef7f3db0358e145220f8423e93c20ee7ea9f5595f13bd508289a"` | SHA256 of the activator image, either provide tag or SHA (SHA will be given priority) |
| knativeServingCore.activator.image.tag | string | `""` | Tag of the activator image, either provide tag or SHA (SHA will be given priority) |
| knativeServingCore.activator.replicaCount | int | `1` | Number of replicas for the activator deployment. |
| knativeServingCore.activator.resources | object | `{"limits":{"cpu":"1000m","memory":"600Mi"},"requests":{"cpu":"300m","memory":"100Mi"}}` | Resources requests and limits for activator. This should be set according to your cluster capacity and service level objectives. Reference: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ |
| knativeServingCore.autoscaler.image.repository | string | `"gcr.io/knative-releases/knative.dev/serving/cmd/autoscaler"` | Repository of the autoscaler image |
| knativeServingCore.autoscaler.image.sha | string | `"31aed8b5b241147585cb0e48366451a96354fc6036d6a5667997237c1d302d98"` | SHA256 of the autoscaler image, either provide tag or SHA (SHA will be given priority) |
| knativeServingCore.autoscaler.image.tag | string | `""` | Tag of the autoscaler image, either provide tag or SHA (SHA will be given priority) |
| knativeServingCore.autoscaler.replicaCount | int | `1` | Number of replicas for the autoscaler deployment. |
| knativeServingCore.autoscaler.resources | object | `{"limits":{"cpu":"1000m","memory":"1000Mi"},"requests":{"cpu":"500m","memory":"500Mi"}}` | Resources requests and limits for autoscaler. This should be set according to your cluster capacity and service level objectives. Reference: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ |
| knativeServingCore.autoscalerHpa.enabled | bool | `true` |  |
| knativeServingCore.autoscalerHpa.image.repository | string | `"gcr.io/knative-releases/knative.dev/serving/cmd/autoscaler-hpa"` | Repository of the autoscaler image |
| knativeServingCore.autoscalerHpa.image.sha | string | `"c7020d14b51862fae8e92da7b0442aa7843eb81c32699d158a3b24c19d5af8d4"` | SHA256 of the autoscaler image, either provide tag or SHA (SHA will be given priority) |
| knativeServingCore.autoscalerHpa.image.tag | string | `""` | Tag of the autoscaler image, either provide tag or SHA (SHA will be given priority) |
| knativeServingCore.autoscalerHpa.replicaCount | int | `1` | Number of replicas for the autoscaler deployment. |
| knativeServingCore.autoscalerHpa.resources | object | `{"limits":{"cpu":"1000m","memory":"128Mi"},"requests":{"cpu":"500m","memory":"128Mi"}}` | Resources requests and limits for autoscaler. This should be set according to your cluster capacity and service level objectives. Reference: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ |
| knativeServingCore.config | object | `{"autoscaler":{},"buckets":"1","defaults":{},"deployment":{"queueSidecarImage":"gcr.io/knative-releases/knative.dev/serving/cmd/queue@sha256:80dfb4568e08e43093f93b2cae9401f815efcb67ad8442d1f7f4c8a41e071fbe"},"domain":{},"features":{},"gc":{},"leaderElection":{"lease-duration":"15s","renew-deadline":"10s","retry-period":"2s"},"logging":{"logging.request-log-template":""},"network":{},"observability":{},"tracing":{}}` | Please check out the Knative documentation in https://github.com/knative/serving/releases/download/knative-v1.0.1/serving-core.yaml |
| knativeServingCore.controller.autoscaling.enabled | bool | `false` | Enables autoscaling for controller deployment. |
| knativeServingCore.controller.image.repository | string | `"gcr.io/knative-releases/knative.dev/serving/cmd/controller"` | Repository of the controller image |
| knativeServingCore.controller.image.sha | string | `"c5a77d5642065ff3452d9b043a7226b85bfc81dc068f8dded905abf88d917a4d"` | SHA256 of the controller image, either provide tag or SHA (SHA will be given priority) |
| knativeServingCore.controller.image.tag | string | `""` | Tag of the controller image, either provide tag or SHA (SHA will be given priority) |
| knativeServingCore.controller.replicaCount | int | `1` | Number of replicas for the controller deployment. |
| knativeServingCore.controller.resources | object | `{"limits":{"cpu":"1000m","memory":"1000Mi"},"requests":{"cpu":"500m","memory":"500Mi"}}` | Resources requests and limits for controller. This should be set according to your cluster capacity and service level objectives. Reference: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ |
| knativeServingCore.domainMapping.image.repository | string | `"gcr.io/knative-releases/knative.dev/serving/cmd/domain-mapping"` | Repository of the domain mapping image |
| knativeServingCore.domainMapping.image.sha | string | `"6b5356cf3a2b64d52cbbf1bc0de376b816c4d3f610ccc8ff2dabf3d259c0996b"` | SHA256 of the domain mapping image, either provide tag or SHA (SHA will be given priority) |
| knativeServingCore.domainMapping.image.tag | string | `""` | Tag of the domain mapping image, either provide tag or SHA (SHA will be given priority) |
| knativeServingCore.domainMapping.replicaCount | int | `1` | Number of replicas for the domain mapping deployment. |
| knativeServingCore.domainMapping.resources | object | `{"limits":{"cpu":"300m","memory":"400Mi"},"requests":{"cpu":"30m","memory":"40Mi"}}` | Resources requests and limits for domain mapping. This should be set according to your cluster capacity and service level objectives. Reference: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ |
| knativeServingCore.domainMappingWebhook.image.repository | string | `"gcr.io/knative-releases/knative.dev/serving/cmd/domain-mapping-webhook"` | Repository of the domain mapping webhook image |
| knativeServingCore.domainMappingWebhook.image.sha | string | `"d0cc86f2002660c4804f6e0aed8218d39384c73a8b5006c9ac558becd8f48aa6"` | SHA256 of the domain mapping webhook image, either provide tag or SHA (SHA will be given priority) |
| knativeServingCore.domainMappingWebhook.image.tag | string | `""` | Tag of the domain mapping webhook image, either provide tag or SHA (SHA will be given priority) |
| knativeServingCore.domainMappingWebhook.replicaCount | int | `1` | Number of replicas for the domain mapping webhook deployment. |
| knativeServingCore.domainMappingWebhook.resources | object | `{"limits":{"cpu":"500m","memory":"500Mi"},"requests":{"cpu":"100m","memory":"100Mi"}}` | Resources requests and limits for domain mapping webhook. This should be set according to your cluster capacity and service level objectives. Reference: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ |
| knativeServingCore.enabled | bool | `true` |  |
| knativeServingCore.global.affinity | object | `{}` | Assign custom affinity rules to the prometheus operator ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/ |
| knativeServingCore.global.extraPodLabels | object | `{}` | Extra pod labels in a map[string]string format, most likely to be used for the costing labels. |
| knativeServingCore.global.nodeSelector | object | `{}` | Define which Nodes the Pods are scheduled on. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| knativeServingCore.global.tolerations | list | `[]` | If specified, the pod's tolerations. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| knativeServingCore.monitoring.enabled | bool | `false` |  |
| knativeServingCore.queueProxy.image.repository | string | `"gcr.io/knative-releases/knative.dev/serving/cmd/queue"` | Repository of the queue proxy image |
| knativeServingCore.queueProxy.image.sha | string | `"80dfb4568e08e43093f93b2cae9401f815efcb67ad8442d1f7f4c8a41e071fbe"` | SHA256 of the queue proxy image, either provide tag or SHA (SHA will be given priority) |
| knativeServingCore.queueProxy.image.tag | string | `""` | Tag of the queue proxy image, either provide tag or SHA (SHA will be given priority) |
| knativeServingCore.webhook.autoscaling.enabled | bool | `false` | Enables autoscaling for webhook deployment. |
| knativeServingCore.webhook.image.repository | string | `"gcr.io/knative-releases/knative.dev/serving/cmd/webhook"` | Repository of the webhook image |
| knativeServingCore.webhook.image.sha | string | `"bd954ec8ced56e359bd4f60ee1886b20000df14126688c796383a3ae40cfffc0"` | SHA256 of the webhook image, either provide tag or SHA (SHA will be given priority) |
| knativeServingCore.webhook.image.tag | string | `""` | Tag of the webhook image, either provide tag or SHA (SHA will be given priority) |
| knativeServingCore.webhook.replicaCount | int | `1` | Number of replicas for the webhook deployment. |
| knativeServingCore.webhook.resources | object | `{"limits":{"cpu":"200m","memory":"500Mi"},"requests":{"cpu":"100m","memory":"100Mi"}}` | Resources requests and limits for webhook. This should be set according to your cluster capacity and service level objectives. Reference: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ |
| monitoring.enabled | bool | `false` |  |
| monitoring.istioEnvoy.envoyStats[0].path | string | `"/stats/prometheus"` |  |
| monitoring.istioEnvoy.envoyStats[0].port | string | `".*-envoy-prom"` |  |
| monitoring.istioEnvoy.namespaceSelector | object | `{}` |  |
| monitoring.istioEnvoy.selector.matchExpressions[0].key | string | `"service.istio.io/canonical-name"` |  |
| monitoring.istioEnvoy.selector.matchExpressions[0].operator | string | `"Exists"` |  |
| monitoring.istiod.namespace | string | `"istio-system"` |  |
| monitoring.istiod.selector.matchLabels.app | string | `"istiod"` |  |
| monitoring.serving.allNamespaces | bool | `true` |  |
| monitoring.serving.podMonitor.selector.matchExpressions[0].key | string | `"serving.knative.dev/revision"` |  |
| monitoring.serving.podMonitor.selector.matchExpressions[0].operator | string | `"Exists"` |  |
| monitoring.serving.podMonitor.userMetricPortName | string | `"http-usermetric"` |  |
| monitoring.serving.podMonitor.userPortName | string | `"user-port"` |  |
| revision | string | `""` |  |
| webhook.image.repository | string | `"gcr.io/knative-releases/knative.dev/net-istio/cmd/webhook"` | Repository of the webhook image |
| webhook.image.sha | string | `"d74e79f7db426c1d24e060009e31344cad2d6e8c7e161184f121fde78b2f4a1d"` | SHA256 of the webhook image, either provide tag or SHA (SHA will be given priority) |
| webhook.image.tag | string | `""` | Tag of the webhook image, either provide tag or SHA (SHA will be given priority) |
| webhook.replicaCount | int | `1` | Number of replicas for the net-istio-webhook deployment. |
| webhook.resources | object | `{"limits":{"cpu":"200m","memory":"500Mi"},"requests":{"cpu":"100m","memory":"100Mi"}}` | Resources requests and limits for net-istio-webhook. This should be set according to your cluster capacity and service level objectives. Reference: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ |
