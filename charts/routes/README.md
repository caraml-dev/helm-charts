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
* For local installation of CaraML,
  * this chart must be installed after installing the main Caraml chart, and
  * installed in the SAME K8s Namespace as the main Caraml Chart
* This is because we need the local istio ingress's load balancer IP address, to enable successful routing of requests
* Routes will be exposed at `<component>.<INGRESS_IP>.nip.io`

```shell
$ INGRESS_IP=$(k get services -n istio-system istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
$ helm install routes caraml/caraml-routes --set istioIngressIP=$INGRESS_IP
```

## Configuration

The following table lists the configurable parameters of the Routes chart and their default values.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| base.enabled | bool | `false` | Set to false if there is an existing istio deployment |
| cert-manager.enabled | bool | `true` |  |
| certManagerBase.enabled | bool | `true` |  |
| domain | string | `""` | Domain used to configure gateway and virtual service |
| feast.enabled | bool | `true` |  |
| feast.feastUI.match[0].uri.prefix | string | `"/feast/"` |  |
| feast.feastUI.route[0].destination.host | string | `"feast-ui"` |  |
| feast.feastUI.route[0].destination.port.number | int | `8080` |  |
| feast.feastUIBackend.match[0].uri.prefix | string | `"/feast/api/"` |  |
| feast.feastUIBackend.match[1].uri.prefix | string | `"/feast/api"` |  |
| feast.feastUIBackend.rewrite.uri | string | `"/api/"` |  |
| feast.feastUIBackend.route[0].destination.host | string | `"feast-ui"` |  |
| feast.feastUIBackend.route[0].destination.port.number | int | `8080` |  |
| feast.feastUIRedirect.match[0].uri.prefix | string | `"/feast"` |  |
| feast.feastUIRedirect.redirect | string | `"/feast/"` |  |
| https.enabled | bool | `false` |  |
| https.tls.credentialName | string | `"mlp-tls-cert"` |  |
| https.tls.mode | string | `"SIMPLE"` |  |
| istioIngressGateway.global.enabled | bool | `false` |  |
| istioLookUp | object | `{"name":"istio-ingressgateway","namespace":"istio-system"}` | istioIngressIP takes precedence over domain. Used for local deployment |
| istiod.enabled | bool | `false` | Set to false if there is an existing istio deployment |
| merlin.api.appName | string | `"merlin"` |  |
| merlin.api.authHeader | bool | `false` |  |
| merlin.api.destHost | string | `"merlin"` |  |
| merlin.api.prefixMatch | string | `"/api/merlin/"` |  |
| merlin.api.rewriteUri | string | `"/"` |  |
| merlin.docs.app | string | `"merlin"` |  |
| merlin.docs.destHost | string | `"merlin-swagger"` |  |
| merlin.docs.destPort | int | `8080` |  |
| merlin.docs.redirectMatch | string | `"/merlin/rest-api"` |  |
| merlin.docs.rewriteUri | string | `"/"` |  |
| merlin.enabled | bool | `true` |  |
| merlin.merlinUI.match[0].uri.prefix | string | `"/merlin"` |  |
| merlin.merlinUI.route[0].destination.host | string | `"merlin"` |  |
| merlin.merlinUI.route[0].destination.port.number | int | `8080` |  |
| mlflow.enabled | bool | `true` |  |
| mlflow.vs.hosts[0] | string | `"mlflow"` |  |
| mlflow.vs.route.destination | string | `"merlin-mlflow"` |  |
| mlflow.vs.route.port | int | `80` |  |
| mlp.api.appName | string | `"mlp"` |  |
| mlp.api.authHeader | bool | `false` |  |
| mlp.api.destHost | string | `"mlp"` |  |
| mlp.api.prefixMatch | string | `"/api/"` |  |
| mlp.api.rewriteUri | string | `"/"` |  |
| mlp.enabled | bool | `true` |  |
| mlp.mlpUIConsole.route[0].destination.host | string | `"mlp"` |  |
| mlp.mlpUIConsole.route[0].destination.port.number | int | `8080` |  |
| mlp.vs.hosts[0] | string | `"console"` |  |
| mlpDocs.vs.hosts[0] | string | `"docs"` |  |
| mlpGateway.hosts[0] | string | `"console"` |  |
| mlpGateway.hosts[1] | string | `"docs"` |  |
| mlpGateway.hosts[2] | string | `"mlflow"` |  |
| mlpGateway.name | string | `"mlp-gateway"` |  |
| mlpGateway.selector.istio | string | `"ingressgateway"` |  |
| pipeline.enabled | bool | `true` |  |
| pipeline.pipelineUI.match[0].uri.prefix | string | `"/pipeline"` |  |
| pipeline.pipelineUI.route[0].destination.host | string | `"pipeline-ui"` |  |
| pipeline.pipelineUI.route[0].destination.port.number | int | `8080` |  |
| turing.api.appName | string | `"turing"` |  |
| turing.api.authHeader | bool | `false` |  |
| turing.api.destHost | string | `"turing"` |  |
| turing.api.prefixMatch | string | `"/api/turing/"` |  |
| turing.api.rewriteUri | string | `"/"` |  |
| turing.docs.app | string | `"turing"` |  |
| turing.docs.destHost | string | `"turing"` |  |
| turing.docs.destPort | int | `8080` |  |
| turing.docs.redirectMatch | string | `"/turing/rest-api"` |  |
| turing.docs.rewriteUri | string | `"/api-docs"` |  |
| turing.enabled | bool | `true` |  |
| turing.turingUI.match[0].uri.prefix | string | `"/turing"` |  |
| turing.turingUI.route[0].destination.host | string | `"turing"` |  |
| turing.turingUI.route[0].destination.port.number | int | `8080` |  |
| turing.turingXpUI.match[0].uri.prefix | string | `"/xp"` |  |
| turing.turingXpUI.route[0].destination.host | string | `"xp-management"` |  |
| turing.turingXpUI.route[0].destination.port.number | int | `8080` |  |
| xp.api.appName | string | `"xp"` |  |
| xp.api.destHost | string | `"xp-management"` |  |
| xp.api.headerMatch | bool | `false` |  |
| xp.api.prefixMatch | string | `"/api/xp/"` |  |
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
| xp.turingXpUI.match[0].uri.prefix | string | `"/xp"` |  |
| xp.turingXpUI.route[0].destination.host | string | `"xp-management"` |  |
| xp.turingXpUI.route[0].destination.port.number | int | `8080` |  |
