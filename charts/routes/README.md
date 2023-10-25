# caraml-routes

---
![Version: 0.3.2](https://img.shields.io/badge/Version-0.3.2-informational?style=flat-square)
![AppVersion: 1.0.0](https://img.shields.io/badge/AppVersion-1.0.0-informational?style=flat-square)

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

The following table lists the configurable parameters of the Routes chart and their default values. The `global` field in `values.yaml` is used to by default in this chart.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| base.enabled | bool | `false` |  |
| cert-manager.enabled | bool | `true` |  |
| certManagerBase.enabled | bool | `true` |  |
| common.enabled | bool | `true` |  |
| extraMappings | list | `[]` |  |
| feast.enabled | bool | `true` |  |
| global.authz.externalPort | string | `"80"` |  |
| global.authz.serviceName | string | `"caraml-authz"` |  |
| global.domain | string | `""` |  |
| global.feast.apiPrefix | string | `"/api"` |  |
| global.feast.externalPort | string | `"8080"` |  |
| global.feast.serviceName | string | `"feast-ui"` |  |
| global.feast.uiServiceName | string | `"feast-ui"` |  |
| global.feast.useServiceFqdn | bool | `true` |  |
| global.feast.vsPrefix | string | `"/feast"` |  |
| global.hosts.mlflow[0] | string | `"mlflow"` |  |
| global.hosts.mlp[0] | string | `"console"` |  |
| global.hosts.mlpdocs[0] | string | `"docs"` |  |
| global.ingressIP | string | `""` |  |
| global.istioLookUp | object | `{"name":"istio-ingressgateway","namespace":"istio-system"}` | istioIngressIP takes precedence over domain. Used for local deployment |
| global.merlin.apiPrefix | string | `"/v1"` |  |
| global.merlin.externalPort | string | `"8080"` |  |
| global.merlin.serviceName | string | `"merlin"` |  |
| global.merlin.uiPrefix | string | `"/merlin"` |  |
| global.merlin.uiServiceName | string | `"merlin"` |  |
| global.merlin.useServiceFqdn | bool | `true` |  |
| global.merlin.vsPrefix | string | `"/api/merlin"` |  |
| global.mlflow.externalPort | string | `"80"` |  |
| global.mlflow.serviceName | string | `"merlin-mlflow"` |  |
| global.mlp.apiPrefix | string | `"/v1"` |  |
| global.mlp.createProjectAdminOnly | bool | `false` |  |
| global.mlp.externalPort | string | `"8080"` |  |
| global.mlp.serviceName | string | `"mlp"` |  |
| global.mlp.uiPrefix | string | `"/"` |  |
| global.mlp.uiServiceName | string | `"mlp"` |  |
| global.mlp.useServiceFqdn | bool | `false` |  |
| global.mlp.vsPrefix | string | `"/api"` |  |
| global.oauthClientID | string | `"test-client-123"` |  |
| global.pipeline.externalPort | string | `"8080"` |  |
| global.pipeline.serviceName | string | `"pipeline-ui"` |  |
| global.pipeline.uiPrefix | string | `"/pipeline"` |  |
| global.protocol | string | `"https"` |  |
| global.turing.apiPrefix | string | `"/v1"` |  |
| global.turing.externalPort | string | `"8080"` |  |
| global.turing.serviceName | string | `"turing"` |  |
| global.turing.uiPrefix | string | `"/turing"` |  |
| global.turing.uiServiceName | string | `"turing"` |  |
| global.turing.useServiceFqdn | bool | `true` |  |
| global.turing.vsPrefix | string | `"/api/turing"` |  |
| global.xp.apiPrefix | string | `"/v1"` |  |
| global.xp.externalPort | string | `"8080"` |  |
| global.xp.serviceName | string | `"xp-management"` |  |
| global.xp.uiPrefix | string | `"/xp"` |  |
| global.xp.uiServiceName | string | `"xp-management"` |  |
| global.xp.useServiceFqdn | bool | `true` |  |
| global.xp.vsPrefix | string | `"/api/xp"` |  |
| https.certificateIssuer.create | bool | `true` |  |
| https.certificateIssuer.external.kind | string | `"ClusterIssuer"` |  |
| https.certificateIssuer.external.name | string | `"default"` |  |
| https.enableRedirect | bool | `true` |  |
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
| oathkeeper.deployment.serviceAccount.create | bool | `false` |  |
| oathkeeper.enabled | bool | `false` |  |
| oathkeeper.fullnameOverride | string | `"oathkeeper"` |  |
| oathkeeper.hook.weight | int | `0` |  |
| oathkeeper.maester.enabled | bool | `true` |  |
| oathkeeper.mutatorIdTokenJWKs | string | `""` |  |
| oathkeeper.oathkeeper-maester.fullnameOverride | string | `"oathkeeper-maester"` |  |
| oathkeeper.oathkeeper-maester.oathkeeperFullnameOverride | string | `"oathkeeper"` |  |
| oathkeeper.oathkeeper-maester.singleNamespaceMode | bool | `true` |  |
| oathkeeper.oathkeeper.config.authenticators.jwt.config.jwks_urls[0] | string | `"https://www.googleapis.com/oauth2/v3/certs"` |  |
| oathkeeper.oathkeeper.config.authenticators.jwt.enabled | bool | `true` |  |
| oathkeeper.oathkeeper.config.authorizers.allow.enabled | bool | `true` |  |
| oathkeeper.oathkeeper.config.authorizers.remote_json.config.payload | string | `"{}"` |  |
| oathkeeper.oathkeeper.config.authorizers.remote_json.config.remote | string | `"http://localhost:4456/relation-tuples/check"` |  |
| oathkeeper.oathkeeper.config.authorizers.remote_json.enabled | bool | `true` |  |
| oathkeeper.oathkeeper.config.mutators.noop.enabled | bool | `true` |  |
| oathkeeper.oathkeeper.managedAccessRules | bool | `false` |  |
| oathkeeper.secret.enabled | bool | `true` |  |
| oathkeeper.service.metrics.enabled | bool | `false` |  |
| oathkeeper.service.proxy.enabled | bool | `false` |  |
| oathkeeperRules.enabled | bool | `false` |  |
| pipeline.enabled | bool | `true` |  |
| turing.api.appName | string | `"turing"` |  |
| turing.api.authHeader | bool | `false` |  |
| turing.api.rewriteUri | string | `"/"` |  |
| turing.docs.app | string | `"turing"` |  |
| turing.docs.destHost | string | `"turing"` |  |
| turing.docs.destPort | int | `8080` |  |
| turing.docs.redirectMatch | string | `"/turing/rest-api"` |  |
| turing.docs.rewriteUri | string | `"/api-docs/"` |  |
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
