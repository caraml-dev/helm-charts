# caraml-routes

---
![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square)
![AppVersion: 0.1.0](https://img.shields.io/badge/AppVersion-0.1.0-informational?style=flat-square)

A Helm chart for deploying CaraML networking resources

## Introduction

This Helm chart installs Caraml Routes.

## Installation

### Add Helm repository

```shell
helm repo add caraml https://caraml-dev.github.io/helm-charts
```

### Installing the chart
* For installation of CaraML into local or managed K8s clusters,
  * this chart must be installed after installing the main Caraml chart, and
  * installed in the SAME K8s Namespace as the main Caraml Chart
* It assumes that Istio will be installed together with the main Caraml chart, or is already installed the cluster
* This is because we need the local istio ingress's load balancer IP address, to enable successful routing of requests
* Routes will be exposed at `<component>.<INGRESS_IP>.nip.io`

```shell
$ helm install routes caraml/caraml-routes
```

### Installation of Routes chart with Istio
* If istio is not installed together with the main Caraml chart or for testing purposes, Istio can be installed together with the routes chart.
```sh
$ helm install routes charts/routes --values charts/routes/ci/test-values.yaml --wait
```
* Once the chart is installed successfully, run this command to update the hostnames to use the correct istio ingress IP.
```sh
$ helm upgrade routes
```

## Configuration

The following table lists the configurable parameters of the Routes chart and their default values.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| base.enabled | bool | `false` |  |
| cert-manager.enabled | bool | `true` |  |
| certManagerBase.enabled | bool | `true` |  |
| common.enabled | bool | `true` |  |
| feast.enabled | bool | `true` |  |
| global.domain | string | `""` |  |
| global.feast.apiPrefix | string | `"/api"` |  |
| global.feast.serviceName | string | `"feast-ui"` |  |
| global.feast.uiServiceName | string | `"feast-ui"` |  |
| global.feast.useServiceFqdn | bool | `true` |  |
| global.feast.vsPrefix | string | `"/feast"` |  |
| global.hosts.mlflow[0] | string | `"mlflow"` |  |
| global.hosts.mlp[0] | string | `"console"` |  |
| global.hosts.mlpdocs[0] | string | `"docs"` |  |
| global.ingressIP | string | `"127.0.0.1"` |  |
| global.istioLookUp | object | `{"name":"istio-ingressgateway","namespace":"istio-system"}` | istioIngressIP takes precedence over domain. Used for local deployment |
| global.merlin.apiPrefix | string | `"/v1"` |  |
| global.merlin.serviceName | string | `"merlin"` |  |
| global.merlin.uiPrefix | string | `"/merlin"` |  |
| global.merlin.uiServiceName | string | `"merlin"` |  |
| global.merlin.useServiceFqdn | bool | `true` |  |
| global.merlin.vsPrefix | string | `"/api/merlin"` |  |
| global.mlflow.hosts[0] | string | `"mlflow"` |  |
| global.mlflow.port | int | `80` |  |
| global.mlflow.serviceName | string | `"merlin-mlflow"` |  |
| global.mlp.apiPrefix | string | `"/v1"` |  |
| global.mlp.serviceName | string | `"mlp"` |  |
| global.mlp.uiPrefix | string | `"/"` |  |
| global.mlp.uiServiceName | string | `"mlp"` |  |
| global.mlp.useServiceFqdn | bool | `false` |  |
| global.mlp.vsPrefix | string | `"/api"` |  |
| global.oauthclient | string | `"test-client-123"` |  |
| global.pipeline.serviceName | string | `"pipeline-ui"` |  |
| global.pipeline.uiPrefix | string | `"/pipeline"` |  |
| global.turing.apiPrefix | string | `"/v1"` |  |
| global.turing.serviceName | string | `"turing"` |  |
| global.turing.uiPrefix | string | `"/turing"` |  |
| global.turing.uiServiceName | string | `"turing"` |  |
| global.turing.useServiceFqdn | bool | `true` |  |
| global.turing.vsPrefix | string | `"/api/turing"` |  |
| global.xp.apiPrefix | string | `"/"` |  |
| global.xp.serviceName | string | `"xp-management"` |  |
| global.xp.uiPrefix | string | `"/xp"` |  |
| global.xp.uiServiceName | string | `"xp-management"` |  |
| global.xp.useServiceFqdn | bool | `true` |  |
| global.xp.vsPrefix | string | `"/api/xp"` |  |
| https.enabled | bool | `true` |  |
| https.tls.credentialName | string | `"mlp-tls-cert"` |  |
| https.tls.mode | string | `"SIMPLE"` |  |
| istioIngressGateway.global.enabled | bool | `false` |  |
| istiod.enabled | bool | `false` |  |
| merlin.api.appName | string | `"merlin"` |  |
| merlin.api.authHeader | bool | `false` |  |
| merlin.api.rewriteUri | string | `"/"` |  |
| merlin.docs.app | string | `"merlin"` |  |
| merlin.docs.destHost | string | `"merlin-swagger"` |  |
| merlin.docs.destPort | int | `8080` |  |
| merlin.docs.redirectMatch | string | `"/merlin/rest-api"` |  |
| merlin.docs.rewriteUri | string | `"/"` |  |
| merlin.enabled | bool | `true` |  |
| mlflow.enabled | bool | `true` |  |
| mlp.api.appName | string | `"mlp"` |  |
| mlp.api.authHeader | bool | `false` |  |
| mlp.api.rewriteUri | string | `"/"` |  |
| mlp.enabled | bool | `true` |  |
| mlpGateway.name | string | `"mlp-gateway"` |  |
| mlpGateway.selector.istio | string | `"ingressgateway"` |  |
| pipeline.enabled | bool | `true` |  |
| turing.api.appName | string | `"turing"` |  |
| turing.api.authHeader | bool | `false` |  |
| turing.api.rewriteUri | string | `"/"` |  |
| turing.docs.app | string | `"turing"` |  |
| turing.docs.destHost | string | `"turing"` |  |
| turing.docs.destPort | int | `8080` |  |
| turing.docs.redirectMatch | string | `"/turing/rest-api"` |  |
| turing.docs.rewriteUri | string | `"/api-docs"` |  |
| turing.enabled | bool | `true` |  |
| xp.api.appName | string | `"xp"` |  |
| xp.api.authHeader | bool | `false` |  |
| xp.api.rewriteUri | string | `"/"` |  |
| xp.enabled | bool | `true` |  |
| xp.managementDocs.app | string | `"xp-management"` |  |
| xp.managementDocs.destHost | string | `"xp-management-swagger"` |  |
| xp.managementDocs.destPort | int | `8080` |  |
| xp.managementDocs.redirectMatch | string | `"/xp/rest-api"` |  |
| xp.managementDocs.rewriteUri | string | `"/"` |  |
| xp.treatmentDocs.app | string | `"xp-treatment"` |  |
| xp.treatmentDocs.destHost | string | `"xp-treatment-swagger"` |  |
| xp.treatmentDocs.destPort | int | `8080` |  |
| xp.treatmentDocs.redirectMatch | string | `"/xp/treatment-api"` |  |
| xp.treatmentDocs.rewriteUri | string | `"/"` |  |
