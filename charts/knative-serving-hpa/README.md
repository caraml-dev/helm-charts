# knative-serving-hpa

---
![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square)
![AppVersion: v1.0.1](https://img.shields.io/badge/AppVersion-v1.0.1-informational?style=flat-square)

Installs Knative Serving HPA Component

## Introduction

This Helm chart installs [Knative Serving HPA](https://knative.dev/docs/install/yaml-install/serving/install-serving-with-yaml/#install-optional-serving-extensions).

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

NOTE: `knative-serving-core` must be installed first.

This command will install Knative release named `knative-serving-hpa` in the `knative-serving` namespace.
Do not try to install into other namespaces as it will break with other installations like Kserve.
Default chart values will be used for the installation:
```shell
$ helm install knative-serving-hpa dsp/knative-serving-hpa --namespace knative-serving
```

You can (and most likely, should) override the default configuration with values suitable for your installation.
Refer to [Configuration](#configuration) section for the detailed description of available configuration keys.

### Uninstalling the chart

To uninstall `knative-serving-hpa` release:
```shell
$ helm uninstall -n knative-serving knative-serving-hpa
```

The command removes all the Kubernetes components associated with the chart and deletes the release,
except for postgresql PVC, those will have to be removed manually.

## Configuration

The following table lists the configurable parameters of the Knative Serving Core chart and their default values.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| autoscalerHpa.image.repository | string | `"gcr.io/knative-releases/knative.dev/serving/cmd/autoscaler-hpa"` | Repository of the autoscaler image |
| autoscalerHpa.image.sha | string | `"c7020d14b51862fae8e92da7b0442aa7843eb81c32699d158a3b24c19d5af8d4"` | SHA256 of the autoscaler image, either provide tag or SHA (SHA will be given priority) |
| autoscalerHpa.image.tag | string | `""` | Tag of the autoscaler image, either provide tag or SHA (SHA will be given priority) |
| autoscalerHpa.replicaCount | int | `1` | Number of replicas for the autoscaler deployment. |
| autoscalerHpa.resources | object | `{}` | Resources requests and limits for autoscaler. This should be set according to your cluster capacity and service level objectives. Reference: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ |
| global.affinity | object | `{}` | Assign custom affinity rules to the prometheus operator ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/ |
| global.extraPodLabels | object | `{}` | Extra pod labels in a map[string]string format, most likely to be used for the costing labels. |
| global.nodeSelector | object | `{}` | Define which Nodes the Pods are scheduled on. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| global.tolerations | list | `[]` | If specified, the pod's tolerations. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
