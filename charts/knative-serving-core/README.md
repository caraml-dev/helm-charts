# knative-serving-core

---
![Version: 1.7.4](https://img.shields.io/badge/Version-1.7.4-informational?style=flat-square)
![AppVersion: v1.7.4](https://img.shields.io/badge/AppVersion-v1.7.4-informational?style=flat-square)

Installs Knative Serving core and CRDs.

## Introduction

This Helm chart installs [Knative Serving Core](https://knative.dev/docs/serving/) and it's CRDs.

## Prerequisites

To use the charts here, [Helm](https://helm.sh/) must be configured for your
Kubernetes cluster. Setting up Kubernetes and Helm is outside the scope of
this README. Please refer to the Kubernetes and Helm documentation.

- **Helm 3.0+** – This chart was tested with Helm v3.9.0, but it is also expected to work with earlier Helm versions
- **Kubernetes 1.22+** – This chart was tested with GKE v1.22.x

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
$ helm install caraml/knative-serving-core --namespace knative-serving
```

You can (and most likely, should) override the default configuration with values suitable for your installation.
Refer to [Configuration](#configuration) section for the detailed description of available configuration keys.

### Uninstalling the chart

To uninstall `knative-serving-core` release:
```shell
$ helm uninstall -n knative-serving knative-serving-core
```

The command removes all the Kubernetes components associated with the chart and deletes the release,
except for postgresql PVC, those will have to be removed manually.

## Configuration

The following table lists the configurable parameters of the Knative Serving Core chart and their default values.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| activator.autoscaling.enabled | bool | `true` | Enables autoscaling for activator deployment. |
| activator.autoscaling.maxReplicas | int | `20` | Maximum number of replicas for activator. |
| activator.autoscaling.minReplicas | int | `1` | Minimum number of replicas for activator. |
| activator.autoscaling.targetCPUUtilizationPercentage | int | `50` | Target CPU utlisation before it scales up/down. |
| activator.image.repository | string | `"gcr.io/knative-releases/knative.dev/serving/cmd/activator"` | Repository of the activator image |
| activator.image.sha | string | `"2a71f86db077e2af4dc02cd8662c545b8206c6d5c853056225967c719251cc20"` | SHA256 of the activator image, either provide tag or SHA (SHA will be given priority) |
| activator.image.tag | string | `""` | Tag of the activator image, either provide tag or SHA (SHA will be given priority) |
| activator.replicaCount | int | `1` | Number of replicas for the activator deployment. |
| activator.resources | object | `{"limits":{"cpu":"1000m","memory":"600Mi"},"requests":{"cpu":"300m","memory":"100Mi"}}` | Resources requests and limits for activator. This should be set according to your cluster capacity and service level objectives. Reference: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ |
| autoscaler.image.repository | string | `"gcr.io/knative-releases/knative.dev/serving/cmd/autoscaler"` | Repository of the autoscaler image |
| autoscaler.image.sha | string | `"cbc663928cc3e3dc60c1d6cdd054d203895c4ee0ebe2b19d86804bd708f3fa2e"` | SHA256 of the autoscaler image, either provide tag or SHA (SHA will be given priority) |
| autoscaler.image.tag | string | `""` | Tag of the autoscaler image, either provide tag or SHA (SHA will be given priority) |
| autoscaler.replicaCount | int | `1` | Number of replicas for the autoscaler deployment. |
| autoscaler.resources | object | `{"limits":{"cpu":"1000m","memory":"1000Mi"},"requests":{"cpu":"500m","memory":"500Mi"}}` | Resources requests and limits for autoscaler. This should be set according to your cluster capacity and service level objectives. Reference: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ |
| autoscalerHpa.enabled | bool | `true` |  |
| autoscalerHpa.image.repository | string | `"gcr.io/knative-releases/knative.dev/serving/cmd/autoscaler-hpa"` | Repository of the autoscaler image |
| autoscalerHpa.image.sha | string | `"f81c354e13768a11ecdcb84c512af339a0cef596a418daa932e378c6c9c2c87e"` | SHA256 of the autoscaler image, either provide tag or SHA (SHA will be given priority) |
| autoscalerHpa.image.tag | string | `""` | Tag of the autoscaler image, either provide tag or SHA (SHA will be given priority) |
| autoscalerHpa.replicaCount | int | `1` | Number of replicas for the autoscaler deployment. |
| autoscalerHpa.resources | object | `{"limits":{"cpu":"1000m","memory":"256Mi"},"requests":{"cpu":"500m","memory":"128Mi"}}` | Resources requests and limits for autoscaler. This should be set according to your cluster capacity and service level objectives. Reference: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ |
| config | object | `{"autoscaler":{},"defaults":{},"deployment":{"queueSidecarImage":"gcr.io/knative-releases/knative.dev/serving/cmd/queue@sha256:fec35c5d66dad3d520e39de7f4f75ec6057962401f85761c143efc902f34efe7"},"domain":{},"features":{},"gc":{},"leaderElection":{"buckets":"1","lease-duration":"60s","renew-deadline":"40s","retry-period":"10s"},"logging":{"logging.request-log-template":""},"network":{},"observability":{},"tracing":{}}` | Please check out the Knative documentation in https://github.com/knative/serving/releases/download/knative-v1.0.1/serving-core.yaml |
| controller.autoscaling.enabled | bool | `true` | Enables autoscaling for controller deployment. |
| controller.autoscaling.maxReplicas | int | `20` | Maximum number of replicas for controller. |
| controller.autoscaling.minReplicas | int | `1` | Minimum number of replicas for controller. |
| controller.autoscaling.targetCPUUtilizationPercentage | int | `50` | Target CPU utlisation before it scales up/down. |
| controller.image.repository | string | `"gcr.io/knative-releases/knative.dev/serving/cmd/controller"` | Repository of the controller image |
| controller.image.sha | string | `"97125c7b1ee8c188ddb9d39786161f18bc9166d4a81a01ceae320863c9d3c4e6"` | SHA256 of the controller image, either provide tag or SHA (SHA will be given priority) |
| controller.image.tag | string | `""` | Tag of the controller image, either provide tag or SHA (SHA will be given priority) |
| controller.replicaCount | int | `1` | Number of replicas for the controller deployment. |
| controller.resources | object | `{"limits":{"cpu":"1000m","memory":"1000Mi"},"requests":{"cpu":"500m","memory":"500Mi"}}` | Resources requests and limits for controller. This should be set according to your cluster capacity and service level objectives. Reference: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ |
| domainMapping.image.repository | string | `"gcr.io/knative-releases/knative.dev/serving/cmd/domain-mapping"` | Repository of the domain mapping image |
| domainMapping.image.sha | string | `"ff5c657ea01d3377be33d88bd3756f3fde49d99b1796c7adf5463b4eb20f37af"` | SHA256 of the domain mapping image, either provide tag or SHA (SHA will be given priority) |
| domainMapping.image.tag | string | `""` | Tag of the domain mapping image, either provide tag or SHA (SHA will be given priority) |
| domainMapping.replicaCount | int | `1` | Number of replicas for the domain mapping deployment. |
| domainMapping.resources | object | `{"limits":{"cpu":"300m","memory":"400Mi"},"requests":{"cpu":"30m","memory":"40Mi"}}` | Resources requests and limits for domain mapping. This should be set according to your cluster capacity and service level objectives. Reference: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ |
| domainMappingWebhook.image.repository | string | `"gcr.io/knative-releases/knative.dev/serving/cmd/domain-mapping-webhook"` | Repository of the domain mapping webhook image |
| domainMappingWebhook.image.sha | string | `"ed47da2c95a9bf73dd3b511323023578e15730864852fb0c869f8f64a2bab39f"` | SHA256 of the domain mapping webhook image, either provide tag or SHA (SHA will be given priority) |
| domainMappingWebhook.image.tag | string | `""` | Tag of the domain mapping webhook image, either provide tag or SHA (SHA will be given priority) |
| domainMappingWebhook.replicaCount | int | `1` | Number of replicas for the domain mapping webhook deployment. |
| domainMappingWebhook.resources | object | `{"limits":{"cpu":"500m","memory":"500Mi"},"requests":{"cpu":"100m","memory":"100Mi"}}` | Resources requests and limits for domain mapping webhook. This should be set according to your cluster capacity and service level objectives. Reference: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ |
| global.affinity | object | `{}` | Assign custom affinity rules to the prometheus operator ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/ |
| global.extraPodLabels | object | `{}` | Extra pod labels in a map[string]string format, most likely to be used for the costing labels. |
| global.nodeSelector | object | `{}` | Define which Nodes the Pods are scheduled on. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| global.tolerations | list | `[]` | If specified, the pod's tolerations. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| monitoring.allNamespaces | bool | `true` |  |
| monitoring.enabled | bool | `false` |  |
| monitoring.podMonitor.metricPortName | string | `"metrics"` |  |
| monitoring.podMonitor.metricRelabelings | object | `{}` |  |
| monitoring.podMonitor.selector.matchExpressions[0].key | string | `"{{ .Values.monitoring.selectorKey }}"` |  |
| monitoring.podMonitor.selector.matchExpressions[0].operator | string | `"Exists"` |  |
| monitoring.selectorKey | string | `"serving.knative.dev/release"` |  |
| queueProxy.image.repository | string | `"gcr.io/knative-releases/knative.dev/serving/cmd/queue"` | Repository of the queue proxy image |
| queueProxy.image.sha | string | `"fec35c5d66dad3d520e39de7f4f75ec6057962401f85761c143efc902f34efe7"` | SHA256 of the queue proxy image, either provide tag or SHA (SHA will be given priority) |
| queueProxy.image.tag | string | `""` | Tag of the queue proxy image, either provide tag or SHA (SHA will be given priority) |
| webhook.autoscaling.enabled | bool | `true` | Enables autoscaling for webhook deployment. |
| webhook.autoscaling.maxReplicas | int | `20` | Maximum number of replicas for webhook. |
| webhook.autoscaling.minReplicas | int | `1` | Minimum number of replicas for webhook. |
| webhook.autoscaling.targetCPUUtilizationPercentage | int | `50` | Target CPU utlisation before it scales up/down. |
| webhook.image.repository | string | `"gcr.io/knative-releases/knative.dev/serving/cmd/webhook"` | Repository of the webhook image |
| webhook.image.sha | string | `"1dc88f22b885d56efc88aae8f0b3160d9bd9632bd0256847eed774e68b3a769b"` | SHA256 of the webhook image, either provide tag or SHA (SHA will be given priority) |
| webhook.image.tag | string | `""` | Tag of the webhook image, either provide tag or SHA (SHA will be given priority) |
| webhook.replicaCount | int | `1` | Number of replicas for the webhook deployment. |
| webhook.resources | object | `{"limits":{"cpu":"200m","memory":"500Mi"},"requests":{"cpu":"100m","memory":"100Mi"}}` | Resources requests and limits for webhook. This should be set according to your cluster capacity and service level objectives. Reference: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ |
