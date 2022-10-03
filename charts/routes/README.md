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
* For local installation of CaraML, this chart should be installed after installing the main Caraml chart.
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
| domain | string | `"ai.golabs.io"` | Domain used to configure gateway and virtual service |
| https.enabled | bool | `true` |  |
| https.tls.credentialName | string | `"mlp-tls-cert"` |  |
| https.tls.mode | string | `"SIMPLE"` |  |
| istioIngressGateway.global.enabled | bool | `false` |  |
| istioIngressIP | string | `""` | istioIngressIP takes precedence over domain. Used for local deployment |
| istiod.enabled | bool | `false` | Set to false if there is an existing istio deployment |
| mlflow.vs.hosts[0] | string | `"mlflow"` |  |
| mlflow.vs.route.destination | string | `"merlin-mlflow"` |  |
| mlflow.vs.route.port | int | `80` |  |
| mlp.vs.feastUIBackend.enabled | bool | `true` |  |
| mlp.vs.feastUIBackend.match[0].uri.prefix | string | `"/feast/api/"` |  |
| mlp.vs.feastUIBackend.match[1].uri.prefix | string | `"/feast/api"` |  |
| mlp.vs.feastUIBackend.rewrite.uri | string | `"/api/"` |  |
| mlp.vs.feastUIBackend.route[0].destination.host | string | `"feast-ui"` |  |
| mlp.vs.feastUIBackend.route[0].destination.port.number | int | `8080` |  |
| mlp.vs.hosts[0] | string | `"console"` |  |
| mlp.vs.mlp.feastUI.enabled | bool | `true` |  |
| mlp.vs.mlp.feastUI.match[0].uri.prefix | string | `"/feast/"` |  |
| mlp.vs.mlp.feastUI.route[0].destination.host | string | `"feast-ui"` |  |
| mlp.vs.mlp.feastUI.route[0].destination.port.number | int | `8080` |  |
| mlp.vs.mlp.feastUIRedirect.enabled | bool | `true` |  |
| mlp.vs.mlp.feastUIRedirect.match[0].uri.prefix | string | `"/feast"` |  |
| mlp.vs.mlp.feastUIRedirect.redirect | string | `"/feast/"` |  |
| mlp.vs.mlp.merlinUI.enabled | bool | `true` |  |
| mlp.vs.mlp.merlinUI.match[0].uri.prefix | string | `"/merlin"` |  |
| mlp.vs.mlp.merlinUI.route[0].destination.host | string | `"merlin"` |  |
| mlp.vs.mlp.merlinUI.route[0].destination.port.number | int | `8080` |  |
| mlp.vs.mlp.mlpUIConsole.enabled | bool | `true` |  |
| mlp.vs.mlp.mlpUIConsole.route[0].destination.host | string | `"mlp"` |  |
| mlp.vs.mlp.mlpUIConsole.route[0].destination.port.number | int | `8080` |  |
| mlp.vs.mlp.pipelineUI.enabled | bool | `true` |  |
| mlp.vs.mlp.pipelineUI.match[0].uri.prefix | string | `"/pipeline"` |  |
| mlp.vs.mlp.pipelineUI.route[0].destination.host | string | `"pipeline-ui"` |  |
| mlp.vs.mlp.pipelineUI.route[0].destination.port.number | int | `8080` |  |
| mlp.vs.mlp.turingUI.enabled | bool | `true` |  |
| mlp.vs.mlp.turingUI.match[0].uri.prefix | string | `"/turing"` |  |
| mlp.vs.mlp.turingUI.route[0].destination.host | string | `"turing"` |  |
| mlp.vs.mlp.turingUI.route[0].destination.port.number | int | `8080` |  |
| mlp.vs.mlp.turingXpUI.enabled | bool | `true` |  |
| mlp.vs.mlp.turingXpUI.match[0].uri.prefix | string | `"/xp"` |  |
| mlp.vs.mlp.turingXpUI.route[0].destination.host | string | `"xp-management"` |  |
| mlp.vs.mlp.turingXpUI.route[0].destination.port.number | int | `8080` |  |
| mlp.vs.mlpAuthGateway.allowHeaders[0] | string | `"Authorization"` |  |
| mlp.vs.mlpAuthGateway.allowHeaders[1] | string | `"Content-Type"` |  |
| mlp.vs.mlpAuthGateway.allowMethods[0] | string | `"POST"` |  |
| mlp.vs.mlpAuthGateway.allowMethods[1] | string | `"GET"` |  |
| mlp.vs.mlpAuthGateway.allowMethods[2] | string | `"PUT"` |  |
| mlp.vs.mlpAuthGateway.allowMethods[3] | string | `"DELETE"` |  |
| mlp.vs.mlpAuthGateway.allowOrigins[0].exact | string | `"*"` |  |
| mlp.vs.mlpAuthGateway.enabled | bool | `true` |  |
| mlp.vs.mlpAuthGateway.match[0].uri.prefix | string | `"/api/"` |  |
| mlp.vs.mlpAuthGateway.rewrite.uri | string | `"/"` |  |
| mlp.vs.mlpAuthGateway.route[0].destination.host | string | `"mlp-authentication"` |  |
| mlp.vs.mlpAuthGateway.route[0].destination.port.number | int | `8080` |  |
| mlpDocs.vs.hosts[0] | string | `"docs"` |  |
| mlpDocs.vs.merlin.app | string | `"merlin"` |  |
| mlpDocs.vs.merlin.destHost | string | `"merlin-swagger"` |  |
| mlpDocs.vs.merlin.destPort | int | `8080` |  |
| mlpDocs.vs.merlin.enabled | bool | `true` |  |
| mlpDocs.vs.merlin.redirectMatch | string | `"/merlin/rest-api"` |  |
| mlpDocs.vs.merlin.rewriteUri | string | `"/"` |  |
| mlpDocs.vs.turing.app | string | `"turing"` |  |
| mlpDocs.vs.turing.destHost | string | `"turing"` |  |
| mlpDocs.vs.turing.destPort | int | `8080` |  |
| mlpDocs.vs.turing.enabled | bool | `true` |  |
| mlpDocs.vs.turing.redirectMatch | string | `"/turing/rest-api"` |  |
| mlpDocs.vs.turing.rewriteUri | string | `"/api-docs"` |  |
| mlpDocs.vs.xpManagement.app | string | `"xp-management"` |  |
| mlpDocs.vs.xpManagement.destHost | string | `"xp-management-swagger"` |  |
| mlpDocs.vs.xpManagement.destPort | int | `8080` |  |
| mlpDocs.vs.xpManagement.enabled | bool | `true` |  |
| mlpDocs.vs.xpManagement.redirectMatch | string | `"/xp/rest-api"` |  |
| mlpDocs.vs.xpManagement.rewriteUri | string | `"/"` |  |
| mlpDocs.vs.xpTreatment.app | string | `"xp-treatment"` |  |
| mlpDocs.vs.xpTreatment.destHost | string | `"xp-treatment-swagger"` |  |
| mlpDocs.vs.xpTreatment.destPort | int | `8080` |  |
| mlpDocs.vs.xpTreatment.enabled | bool | `true` |  |
| mlpDocs.vs.xpTreatment.redirectMatch | string | `"/xp/treatment-api"` |  |
| mlpDocs.vs.xpTreatment.rewriteUri | string | `"/"` |  |
| mlpGateway.hosts[0] | string | `"console"` |  |
| mlpGateway.hosts[1] | string | `"docs"` |  |
| mlpGateway.hosts[2] | string | `"mlflow"` |  |
| mlpGateway.name | string | `"mlp-gateway"` |  |
| mlpGateway.selector.istio | string | `"ingressgateway"` |  |
