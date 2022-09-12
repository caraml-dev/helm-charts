# knative-net-istio

---
![Version: 1.0.1](https://img.shields.io/badge/Version-1.0.1-informational?style=flat-square)
![AppVersion: v1.0.0](https://img.shields.io/badge/AppVersion-v1.0.0-informational?style=flat-square)

Installs Net Istio for KNative

## Introduction

This Helm chart installs [Knative Net Istio](https://knative.dev/docs/serving/) and it's CRDs.

## Prerequisites

To use the charts here, [Helm](https://helm.sh/) must be configured for your
Kubernetes cluster. Setting up Kubernetes and Helm is outside the scope of
this README. Please refer to the Kubernetes and Helm documentation.

- **Helm 3.0+** – This chart was tested with Helm v3.6.3, but it is also expected to work with earlier Helm versions
- **Kubernetes 1.22+** – This chart was tested with GKE v1.22.x

## Installation

### Add Helm repository

```shell
$ helm repo add dsp http://artifactory-gojek.golabs.io/artifactory/generic-local/dsp-charts/
```

### Installing the chart

This command will install Knative release named `knative-serving` in the `knative-serving` namespace.
Do not try to install into other namespaces as it will break with other installations like Kserve.
Default chart values will be used for the installation:
```shell
$ helm install dsp/knative-net-istio --namespace knative-serving
```

You can (and most likely, should) override the default configuration with values suitable for your installation.
Refer to [Configuration](#configuration) section for the detailed description of available configuration keys.

### Uninstalling the chart

To uninstall `knative-net-istio` release:
```shell
$ helm uninstall -n knative-serving knative-net-istio
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
| clusterLocalGateway.autoscaling.enabled | bool | `false` |  |
| clusterLocalGateway.env.ISTIO_METAJSON_STATS | string | `"{\\\"sidecar.istio.io/statsInclusionSuffixes\\\": \\\"upstream_rq_1xx,upstream_rq_2xx,upstream_rq_3xx,upstream_rq_4xx,upstream_rq_5xx,upstream_rq_time,upstream_cx_tx_bytes_total,upstream_cx_rx_bytes_total,upstream_cx_total,downstream_rq_1xx,downstream_rq_2xx,downstream_rq_3xx,downstream_rq_4xx,downstream_rq_5xx,downstream_rq_time,downstream_cx_tx_bytes_total,downstream_cx_rx_bytes_total,downstream_cx_total\\\"}\n"` |  |
| clusterLocalGateway.global.enabled | bool | `true` | Controls deployment of cluster-local-gateway. Set to false if there is an existing istio deployment |
| clusterLocalGateway.labels.app | string | `"cluster-local-gateway"` |  |
| clusterLocalGateway.labels.istio | string | `"cluster-local-gateway"` |  |
| clusterLocalGateway.name | string | `"cluster-local-gateway"` | Specify name here so each gateway installation has its own unique name |
| clusterLocalGateway.resources | object | `{}` |  |
| clusterLocalGateway.service.ports[0].name | string | `"http2"` |  |
| clusterLocalGateway.service.ports[0].port | int | `80` |  |
| clusterLocalGateway.service.ports[0].targetPort | int | `80` |  |
| clusterLocalGateway.service.ports[1].name | string | `"https"` |  |
| clusterLocalGateway.service.ports[1].port | int | `443` |  |
| clusterLocalGateway.service.type | string | `"ClusterIP"` |  |
| clusterLocalGateway.serviceAccount.create | bool | `true` |  |
| clusterLocalGateway.serviceAccount.name | string | `"cluster-local-gateway"` |  |
| clusterLocalGatewayIstioSelector | string | `"cluster-local-gateway"` |  |
| config | object | `{"istio":{"enable-virtualservice-status":"false","gateway.knative-serving.knative-ingress-gateway":"istio-ingressgateway.istio-system.svc.cluster.local","local-gateway.knative-serving.knative-local-gateway":"cluster-local-gateway.istio-system.svc.cluster.local","local-gateway.mesh":"mesh"}}` | Please check out the Knative documentation in https://github.com/knative-sandbox/net-istio/releases/download/knative-v1.0.0/net-istio.yaml |
| controller.autoscaling.enabled | bool | `false` | Enables autoscaling for net-istio-controller deployment. |
| controller.image.repository | string | `"gcr.io/knative-releases/knative.dev/net-istio/cmd/controller"` | Repository of the controller image |
| controller.image.sha | string | `"1ef74af101cc89d86a2e6b37b9a74545bfd9892d48b1b036d419a635a19c0081"` | SHA256 of the controller image, either provide tag or SHA (SHA will be given priority) |
| controller.image.tag | string | `""` | Tag of the controller image, either provide tag or SHA (SHA will be given priority) |
| controller.replicaCount | int | `1` | Number of replicas for the net-istio-controller deployment. |
| controller.resources | object | `{}` | Resources requests and limits for net-istio-controller. This should be set according to your cluster capacity and service level objectives. Reference: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ |
| global.affinity | object | `{}` | Assign custom affinity rules to the prometheus operator ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/ |
| global.extraPodLabels | object | `{}` | Extra pod labels in a map[string]string format, most likely to be used for the costing labels. |
| global.nodeSelector | object | `{}` | Define which Nodes the Pods are scheduled on. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| global.tolerations | list | `[]` | If specified, the pod's tolerations. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| istioIngressGateway.autoscaling.enabled | bool | `false` |  |
| istioIngressGateway.env.ISTIO_METAJSON_STATS | string | `"{\\\"sidecar.istio.io/statsInclusionSuffixes\\\": \\\"upstream_rq_1xx,upstream_rq_2xx,upstream_rq_3xx,upstream_rq_4xx,upstream_rq_5xx,upstream_rq_time,upstream_cx_tx_bytes_total,upstream_cx_rx_bytes_total,upstream_cx_total,downstream_rq_1xx,downstream_rq_2xx,downstream_rq_3xx,downstream_rq_4xx,downstream_rq_5xx,downstream_rq_time,downstream_cx_tx_bytes_total,downstream_cx_rx_bytes_total,downstream_cx_total\\\"}\n"` |  |
| istioIngressGateway.env.ISTIO_META_ROUTER_MODE | string | `"standard"` |  |
| istioIngressGateway.global.enabled | bool | `true` | Controls deployment of istio-ingressgateway. Set to false if there is an existing istio deployment |
| istioIngressGateway.name | string | `"istio-ingressgateway"` | Specify name here so each gateway installation has its own unique name |
| istioIngressGateway.resources | object | `{}` |  |
| istioIngressGateway.serviceAccount.create | bool | `true` |  |
| istioIngressGateway.serviceAccount.name | string | `"istio-ingressgateway"` |  |
| istiod.configValidation | bool | `true` |  |
| istiod.deployInReleaseNs | bool | `true` |  |
| istiod.enabled | bool | `true` | Set to false if there is an existing istio deployment |
| istiod.global.configValidation | bool | `false` |  |
| istiod.global.istioNamespace | string | `"istio-system"` |  |
| istiod.meshConfig.enableTracing | bool | `false` |  |
| istiod.pilot.autoscaleEnabled | bool | `false` |  |
| istiod.pilot.cpu.targetAverageUtilization | int | `80` |  |
| istiod.pilot.resources.limits.cpu | int | `1` |  |
| istiod.pilot.resources.limits.memory | string | `"1024Mi"` |  |
| istiod.pilot.resources.requests.cpu | string | `"500m"` |  |
| istiod.pilot.resources.requests.memory | string | `"512Mi"` |  |
| knativeServingCore.activator.autoscaling.enabled | bool | `false` | Enables autoscaling for activator deployment. |
| knativeServingCore.activator.image.repository | string | `"gcr.io/knative-releases/knative.dev/serving/cmd/activator"` | Repository of the activator image |
| knativeServingCore.activator.image.sha | string | `"ca607f73e5daef7f3db0358e145220f8423e93c20ee7ea9f5595f13bd508289a"` | SHA256 of the activator image, either provide tag or SHA (SHA will be given priority) |
| knativeServingCore.activator.image.tag | string | `""` | Tag of the activator image, either provide tag or SHA (SHA will be given priority) |
| knativeServingCore.activator.replicaCount | int | `1` | Number of replicas for the activator deployment. |
| knativeServingCore.activator.resources | object | `{}` | Resources requests and limits for activator. This should be set according to your cluster capacity and service level objectives. Reference: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ |
| knativeServingCore.autoscaler.image.repository | string | `"gcr.io/knative-releases/knative.dev/serving/cmd/autoscaler"` | Repository of the autoscaler image |
| knativeServingCore.autoscaler.image.sha | string | `"31aed8b5b241147585cb0e48366451a96354fc6036d6a5667997237c1d302d98"` | SHA256 of the autoscaler image, either provide tag or SHA (SHA will be given priority) |
| knativeServingCore.autoscaler.image.tag | string | `""` | Tag of the autoscaler image, either provide tag or SHA (SHA will be given priority) |
| knativeServingCore.autoscaler.replicaCount | int | `1` | Number of replicas for the autoscaler deployment. |
| knativeServingCore.autoscaler.resources | object | `{}` | Resources requests and limits for autoscaler. This should be set according to your cluster capacity and service level objectives. Reference: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ |
| knativeServingCore.autoscalerHpa.enabled | bool | `true` |  |
| knativeServingCore.autoscalerHpa.image.repository | string | `"gcr.io/knative-releases/knative.dev/serving/cmd/autoscaler-hpa"` | Repository of the autoscaler image |
| knativeServingCore.autoscalerHpa.image.sha | string | `"c7020d14b51862fae8e92da7b0442aa7843eb81c32699d158a3b24c19d5af8d4"` | SHA256 of the autoscaler image, either provide tag or SHA (SHA will be given priority) |
| knativeServingCore.autoscalerHpa.image.tag | string | `""` | Tag of the autoscaler image, either provide tag or SHA (SHA will be given priority) |
| knativeServingCore.autoscalerHpa.replicaCount | int | `1` | Number of replicas for the autoscaler deployment. |
| knativeServingCore.autoscalerHpa.resources | object | `{}` | Resources requests and limits for autoscaler. This should be set according to your cluster capacity and service level objectives. Reference: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ |
| knativeServingCore.config | object | `{"autoscaler":{},"buckets":"1","defaults":{},"deployment":{"queueSidecarImage":"gcr.io/knative-releases/knative.dev/serving/cmd/queue@sha256:80dfb4568e08e43093f93b2cae9401f815efcb67ad8442d1f7f4c8a41e071fbe"},"domain":{},"features":{},"gc":{},"leaderElection":{"lease-duration":"15s","renew-deadline":"10s","retry-period":"2s"},"logging":{"logging.request-log-template":""},"network":{},"observability":{},"tracing":{}}` | Please check out the Knative documentation in https://github.com/knative/serving/releases/download/knative-v1.0.1/serving-core.yaml |
| knativeServingCore.controller.autoscaling.enabled | bool | `false` | Enables autoscaling for controller deployment. |
| knativeServingCore.controller.image.repository | string | `"gcr.io/knative-releases/knative.dev/serving/cmd/controller"` | Repository of the controller image |
| knativeServingCore.controller.image.sha | string | `"c5a77d5642065ff3452d9b043a7226b85bfc81dc068f8dded905abf88d917a4d"` | SHA256 of the controller image, either provide tag or SHA (SHA will be given priority) |
| knativeServingCore.controller.image.tag | string | `""` | Tag of the controller image, either provide tag or SHA (SHA will be given priority) |
| knativeServingCore.controller.replicaCount | int | `1` | Number of replicas for the controller deployment. |
| knativeServingCore.controller.resources | object | `{}` | Resources requests and limits for controller. This should be set according to your cluster capacity and service level objectives. Reference: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ |
| knativeServingCore.domainMapping.image.repository | string | `"gcr.io/knative-releases/knative.dev/serving/cmd/domain-mapping"` | Repository of the domain mapping image |
| knativeServingCore.domainMapping.image.sha | string | `"6b5356cf3a2b64d52cbbf1bc0de376b816c4d3f610ccc8ff2dabf3d259c0996b"` | SHA256 of the domain mapping image, either provide tag or SHA (SHA will be given priority) |
| knativeServingCore.domainMapping.image.tag | string | `""` | Tag of the domain mapping image, either provide tag or SHA (SHA will be given priority) |
| knativeServingCore.domainMapping.replicaCount | int | `1` | Number of replicas for the domain mapping deployment. |
| knativeServingCore.domainMapping.resources | object | `{}` | Resources requests and limits for domain mapping. This should be set according to your cluster capacity and service level objectives. Reference: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ |
| knativeServingCore.domainMappingWebhook.image.repository | string | `"gcr.io/knative-releases/knative.dev/serving/cmd/domain-mapping-webhook"` | Repository of the domain mapping webhook image |
| knativeServingCore.domainMappingWebhook.image.sha | string | `"d0cc86f2002660c4804f6e0aed8218d39384c73a8b5006c9ac558becd8f48aa6"` | SHA256 of the domain mapping webhook image, either provide tag or SHA (SHA will be given priority) |
| knativeServingCore.domainMappingWebhook.image.tag | string | `""` | Tag of the domain mapping webhook image, either provide tag or SHA (SHA will be given priority) |
| knativeServingCore.domainMappingWebhook.replicaCount | int | `1` | Number of replicas for the domain mapping webhook deployment. |
| knativeServingCore.domainMappingWebhook.resources | object | `{}` | Resources requests and limits for domain mapping webhook. This should be set according to your cluster capacity and service level objectives. Reference: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ |
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
| knativeServingCore.webhook.resources | object | `{}` | Resources requests and limits for webhook. This should be set according to your cluster capacity and service level objectives. Reference: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ |
| revision | string | `""` |  |
| webhook.image.repository | string | `"gcr.io/knative-releases/knative.dev/net-istio/cmd/webhook"` | Repository of the webhook image |
| webhook.image.sha | string | `"ab3dfcf1574780448b3453cc717d6eb2bc33e794d36c090eff1076aa65f05ca0"` | SHA256 of the webhook image, either provide tag or SHA (SHA will be given priority) |
| webhook.image.tag | string | `""` | Tag of the webhook image, either provide tag or SHA (SHA will be given priority) |
| webhook.replicaCount | int | `1` | Number of replicas for the net-istio-webhook deployment. |
| webhook.resources | object | `{}` | Resources requests and limits for net-istio-webhook. This should be set according to your cluster capacity and service level objectives. Reference: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ |
