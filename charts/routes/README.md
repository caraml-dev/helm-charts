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
| feast | object | `{"enabled":true,"feastUI":{"match":[{"uri":{"prefix":"/feast/"}}],"route":[{"destination":{"host":"feast-ui","port":{"number":8080}}}]},"feastUIBackend":{"match":[{"uri":{"prefix":"/feast/api/"}},{"uri":{"prefix":"/feast/api"}}],"rewrite":{"uri":"/api/"},"route":[{"destination":{"host":"feast-ui","port":{"number":8080}}}]},"feastUIRedirect":{"match":[{"uri":{"exact":"/feast"}}],"redirect":"/feast/"}}` | Configuration for feast |
| https.enabled | bool | `true` |  |
| https.tls.credentialName | string | `"mlp-tls-cert"` |  |
| https.tls.mode | string | `"SIMPLE"` |  |
| istioIngressGateway.global.enabled | bool | `false` |  |
| istioLookUp | object | `{"name":"istio-ingressgateway","namespace":"istio-system"}` | istioIngressIP takes precedence over domain. Used for local deployment |
| istiod.enabled | bool | `false` | Set to false if there is an existing istio deployment |
| merlin | object | `{"api":{"appName":"merlin","authHeader":false,"destHost":"merlin","prefixMatch":"/api/merlin/","rewriteUri":"/"},"docs":{"app":"merlin","destHost":"merlin-swagger","destPort":8080,"redirectMatch":"/merlin/rest-api","rewriteUri":"/"},"enabled":true,"merlinUI":{"match":[{"uri":{"prefix":"/merlin"}}],"route":[{"destination":{"host":"merlin","port":{"number":8080}}}]}}` | Configuration for merlin |
| merlin.api | object | `{"appName":"merlin","authHeader":false,"destHost":"merlin","prefixMatch":"/api/merlin/","rewriteUri":"/"}` | Config to route requests to merlin api |
| merlin.docs | object | `{"app":"merlin","destHost":"merlin-swagger","destPort":8080,"redirectMatch":"/merlin/rest-api","rewriteUri":"/"}` | Config to route requests to merlin docs |
| merlin.merlinUI | object | `{"match":[{"uri":{"prefix":"/merlin"}}],"route":[{"destination":{"host":"merlin","port":{"number":8080}}}]}` | Config to route requests to merlin UI |
| mlflow | object | `{"enabled":true,"vs":{"hosts":["mlflow"],"route":{"destination":"merlin-mlflow","port":80}}}` | Configuration for mlflow |
| mlp | object | `{"api":{"appName":"mlp","authHeader":false,"destHost":"mlp","prefixMatch":"/api/","rewriteUri":"/"},"enabled":true,"mlpUIConsole":{"route":[{"destination":{"host":"mlp","port":{"number":8080}}}]},"vs":{"hosts":["console"]}}` | Configuration for mlp |
| mlpDocs | object | `{"vs":{"hosts":["docs"]}}` | Configuration for mlpDocs hosts |
| mlpGateway | object | `{"hosts":["console","docs","mlflow"],"name":"mlp-gateway","selector":{"istio":"ingressgateway"}}` | Configuration for mlp |
| mlpGateway.hosts | list | `["console","docs","mlflow"]` | hosts will be concatenated with domain or ingress IP address |
| pipeline | object | `{"enabled":true,"pipelineUI":{"match":[{"uri":{"prefix":"/pipeline"}}],"route":[{"destination":{"host":"pipeline-ui","port":{"number":8080}}}]}}` | Configuration for pipeline |
| pipeline.pipelineUI | object | `{"match":[{"uri":{"prefix":"/pipeline"}}],"route":[{"destination":{"host":"pipeline-ui","port":{"number":8080}}}]}` | Config to route requests to pipeline UI |
| turing | object | `{"api":{"appName":"turing","authHeader":false,"destHost":"turing","prefixMatch":"/api/turing/","rewriteUri":"/"},"docs":{"app":"turing","destHost":"turing","destPort":8080,"redirectMatch":"/turing/rest-api","rewriteUri":"/api-docs"},"enabled":true,"turingUI":{"match":[{"uri":{"prefix":"/turing"}}],"route":[{"destination":{"host":"turing","port":{"number":8080}}}]}}` | Configuration for turing |
| turing.api | object | `{"appName":"turing","authHeader":false,"destHost":"turing","prefixMatch":"/api/turing/","rewriteUri":"/"}` | Config to route requests to turing api |
| turing.docs | object | `{"app":"turing","destHost":"turing","destPort":8080,"redirectMatch":"/turing/rest-api","rewriteUri":"/api-docs"}` | Config to route requests to turing docs |
| turing.turingUI | object | `{"match":[{"uri":{"prefix":"/turing"}}],"route":[{"destination":{"host":"turing","port":{"number":8080}}}]}` | Config to route requests to turing UI |
| xp | object | `{"api":{"appName":"xp","authHeader":false,"destHost":"xp-management","prefixMatch":"/api/xp/","rewriteUri":"/"},"enabled":true,"managementDocs":{"app":"xp-management","destHost":"xp-management-swagger","destPort":8080,"redirectMatch":"/xp/rest-api","rewriteUri":"/"},"treatmentDocs":{"app":"xp-treatment","destHost":"xp-treatment-swagger","destPort":8080,"redirectMatch":"/xp/treatment-api","rewriteUri":"/"},"turingXpUI":{"match":[{"uri":{"prefix":"/xp"}}],"route":[{"destination":{"host":"xp-management","port":{"number":8080}}}]}}` | Configuration for xp |
| xp.api | object | `{"appName":"xp","authHeader":false,"destHost":"xp-management","prefixMatch":"/api/xp/","rewriteUri":"/"}` | Config to route requests to xp api |
| xp.managementDocs | object | `{"app":"xp-management","destHost":"xp-management-swagger","destPort":8080,"redirectMatch":"/xp/rest-api","rewriteUri":"/"}` | Config to route requests to xp management docs |
| xp.treatmentDocs | object | `{"app":"xp-treatment","destHost":"xp-treatment-swagger","destPort":8080,"redirectMatch":"/xp/treatment-api","rewriteUri":"/"}` | Config to route requests to xp treatment docs |
| xp.turingXpUI | object | `{"match":[{"uri":{"prefix":"/xp"}}],"route":[{"destination":{"host":"xp-management","port":{"number":8080}}}]}` | Config to route requests to xp UI |
