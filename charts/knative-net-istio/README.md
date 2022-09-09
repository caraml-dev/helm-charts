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
| clusterLocalGateway.autoscaling.enabled | bool | `true` |  |
| clusterLocalGateway.autoscaling.maxReplicas | int | `4` |  |
| clusterLocalGateway.autoscaling.minReplicas | int | `1` |  |
| clusterLocalGateway.autoscaling.targetCPUUtilizationPercentage | int | `60` |  |
| clusterLocalGateway.env.ISTIO_METAJSON_STATS | string | `"{\\\"sidecar.istio.io/statsInclusionSuffixes\\\": \\\"upstream_rq_1xx,upstream_rq_2xx,upstream_rq_3xx,upstream_rq_4xx,upstream_rq_5xx,upstream_rq_time,upstream_cx_tx_bytes_total,upstream_cx_rx_bytes_total,upstream_cx_total,downstream_rq_1xx,downstream_rq_2xx,downstream_rq_3xx,downstream_rq_4xx,downstream_rq_5xx,downstream_rq_time,downstream_cx_tx_bytes_total,downstream_cx_rx_bytes_total,downstream_cx_total\\\"}\n"` |  |
| clusterLocalGateway.global.enabled | bool | `true` | Controls deployment of cluster-local-gateway. Set to false if there is an existing istio deployment |
| clusterLocalGateway.labels.app | string | `"cluster-local-gateway"` |  |
| clusterLocalGateway.labels.istio | string | `"cluster-local-gateway"` |  |
| clusterLocalGateway.resources | object | `{}` |  |
| clusterLocalGateway.service.ports[0].name | string | `"http2"` |  |
| clusterLocalGateway.service.ports[0].port | int | `80` |  |
| clusterLocalGateway.service.ports[0].targetPort | int | `80` |  |
| clusterLocalGateway.service.ports[1].name | string | `"https"` |  |
| clusterLocalGateway.service.ports[1].port | int | `443` |  |
| clusterLocalGateway.service.type | string | `"ClusterIP"` |  |
| clusterLocalGatewayIstioSelector | string | `"cluster-local-gateway"` |  |
| config | object | `{"istio":{"enable-virtualservice-status":"false","gateway.knative-serving.knative-ingress-gateway":"istio-ingressgateway.istio-system.svc.cluster.local","local-gateway.knative-serving.knative-local-gateway":"cluster-local-gateway.istio-system.svc.cluster.local","local-gateway.mesh":"mesh"}}` | Please check out the Knative documentation in https://github.com/knative-sandbox/net-istio/releases/download/knative-v1.0.0/net-istio.yaml |
| controller.autoscaling.enabled | bool | `true` | Enables autoscaling for net-istio-controller deployment. |
| controller.autoscaling.maxReplicas | int | `20` | Maximum number of replicas for net-istio-controller. |
| controller.autoscaling.minReplicas | int | `1` | Minimum number of replicas for net-istio-controller. |
| controller.autoscaling.targetCPUUtilizationPercentage | int | `100` | Target CPU utlisation before it scales up/down. |
| controller.image.repository | string | `"gcr.io/knative-releases/knative.dev/net-istio/cmd/controller"` | Repository of the controller image |
| controller.image.sha | string | `"1ef74af101cc89d86a2e6b37b9a74545bfd9892d48b1b036d419a635a19c0081"` | SHA256 of the controller image, either provide tag or SHA (SHA will be given priority) |
| controller.image.tag | string | `""` | Tag of the controller image, either provide tag or SHA (SHA will be given priority) |
| controller.replicaCount | int | `1` | Number of replicas for the net-istio-controller deployment. |
| controller.resources | object | `{}` | Resources requests and limits for net-istio-controller. This should be set according to your cluster capacity and service level objectives. Reference: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ |
| global.affinity | object | `{}` | Assign custom affinity rules to the prometheus operator ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/ |
| global.extraPodLabels | object | `{}` | Extra pod labels in a map[string]string format, most likely to be used for the costing labels. |
| global.nodeSelector | object | `{}` | Define which Nodes the Pods are scheduled on. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| global.tolerations | list | `[]` | If specified, the pod's tolerations. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| istioBase.enabled | bool | `true` | Set to false if there is an existing istio deployment |
| istioBase.global.istioNamespace | string | `"istio-system"` |  |
| istioIngressGateway.autoscaling.enabled | bool | `true` |  |
| istioIngressGateway.autoscaling.maxReplicas | int | `4` |  |
| istioIngressGateway.autoscaling.minReplicas | int | `1` |  |
| istioIngressGateway.autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| istioIngressGateway.env.ISTIO_METAJSON_STATS | string | `"{\\\"sidecar.istio.io/statsInclusionSuffixes\\\": \\\"upstream_rq_1xx,upstream_rq_2xx,upstream_rq_3xx,upstream_rq_4xx,upstream_rq_5xx,upstream_rq_time,upstream_cx_tx_bytes_total,upstream_cx_rx_bytes_total,upstream_cx_total,downstream_rq_1xx,downstream_rq_2xx,downstream_rq_3xx,downstream_rq_4xx,downstream_rq_5xx,downstream_rq_time,downstream_cx_tx_bytes_total,downstream_cx_rx_bytes_total,downstream_cx_total\\\"}\n"` |  |
| istioIngressGateway.env.ISTIO_META_ROUTER_MODE | string | `"standard"` |  |
| istioIngressGateway.global.enabled | bool | `true` | Controls deployment of istio-ingressgateway. Set to false if there is an existing istio deployment |
| istioIngressGateway.resources.limits.cpu | string | `"4"` |  |
| istioIngressGateway.resources.limits.memory | string | `"1Gi"` |  |
| istioIngressGateway.resources.requests.cpu | string | `"2"` |  |
| istioIngressGateway.resources.requests.memory | string | `"1Gi"` |  |
| istiod.enabled | bool | `true` | Set to false if there is an existing istio deployment |
| istiod.meshConfig.enableTracing | bool | `false` |  |
| istiod.pilot.autoscaleEnabled | bool | `true` |  |
| istiod.pilot.autoscaleMax | int | `5` |  |
| istiod.pilot.autoscaleMin | int | `1` |  |
| istiod.pilot.cpu.targetAverageUtilization | int | `80` |  |
| istiod.pilot.resources.limits.cpu | int | `1` |  |
| istiod.pilot.resources.limits.memory | string | `"1024Mi"` |  |
| istiod.pilot.resources.requests.cpu | string | `"500m"` |  |
| istiod.pilot.resources.requests.memory | string | `"512Mi"` |  |
| istiod.pilot.rollingMaxSurge | string | `"100%"` |  |
| istiod.pilot.rollingMaxUnavailable | string | `"25%"` |  |
| webhook.image.repository | string | `"gcr.io/knative-releases/knative.dev/net-istio/cmd/webhook"` | Repository of the webhook image |
| webhook.image.sha | string | `"ab3dfcf1574780448b3453cc717d6eb2bc33e794d36c090eff1076aa65f05ca0"` | SHA256 of the webhook image, either provide tag or SHA (SHA will be given priority) |
| webhook.image.tag | string | `""` | Tag of the webhook image, either provide tag or SHA (SHA will be given priority) |
| webhook.replicaCount | int | `1` | Number of replicas for the net-istio-webhook deployment. |
| webhook.resources | object | `{}` | Resources requests and limits for net-istio-webhook. This should be set according to your cluster capacity and service level objectives. Reference: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ |
