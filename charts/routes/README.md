# caraml-routes

![Version: 0.2.1](https://img.shields.io/badge/Version-0.2.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0.0](https://img.shields.io/badge/AppVersion-1.0.0-informational?style=flat-square)

A Helm chart for deploying CaraML networking resources

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| caraml-dev | <caraml-dev@caraml.dev> |  |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| domain | string | `"ai.golabs.io"` |  |
| https.enabled | bool | `true` |  |
| https.tls.credentialName | string | `"mlp-tls-cert"` |  |
| https.tls.mode | string | `"SIMPLE"` |  |
| istioIngressIP | string | `""` |  |
| mlflow.routes.hosts[0] | string | `"mlflow"` |  |
| mlp.routes.feastUIBackend.enabled | bool | `true` |  |
| mlp.routes.feastUIBackend.match[0].uri.prefix | string | `"/feast/api/"` |  |
| mlp.routes.feastUIBackend.match[1].uri.prefix | string | `"/feast/api"` |  |
| mlp.routes.feastUIBackend.rewrite.uri | string | `"/api/"` |  |
| mlp.routes.feastUIBackend.route[0].destination.host | string | `"feast-ui"` |  |
| mlp.routes.feastUIBackend.route[0].destination.port.number | int | `8080` |  |
| mlp.routes.hosts[0] | string | `"console"` |  |
| mlp.routes.mlp.feastUI.enabled | bool | `true` |  |
| mlp.routes.mlp.feastUI.match[0].uri.prefix | string | `"/feast/"` |  |
| mlp.routes.mlp.feastUI.route[0].destination.host | string | `"feast-ui"` |  |
| mlp.routes.mlp.feastUI.route[0].destination.port.number | int | `8080` |  |
| mlp.routes.mlp.feastUIRedirect.enabled | bool | `true` |  |
| mlp.routes.mlp.feastUIRedirect.match[0].uri.prefix | string | `"/feast"` |  |
| mlp.routes.mlp.feastUIRedirect.redirect | string | `"/feast/"` |  |
| mlp.routes.mlp.merlinUI.enabled | bool | `true` |  |
| mlp.routes.mlp.merlinUI.match[0].uri.prefix | string | `"/merlin"` |  |
| mlp.routes.mlp.merlinUI.route[0].destination.host | string | `"merlin"` |  |
| mlp.routes.mlp.merlinUI.route[0].destination.port.number | int | `8080` |  |
| mlp.routes.mlp.mlpUIConsole.enabled | bool | `true` |  |
| mlp.routes.mlp.mlpUIConsole.route[0].destination.host | string | `"mlp"` |  |
| mlp.routes.mlp.mlpUIConsole.route[0].destination.port.number | int | `8080` |  |
| mlp.routes.mlp.pipelineUI.enabled | bool | `true` |  |
| mlp.routes.mlp.pipelineUI.match[0].uri.prefix | string | `"/pipeline"` |  |
| mlp.routes.mlp.pipelineUI.route[0].destination.host | string | `"pipeline-ui"` |  |
| mlp.routes.mlp.pipelineUI.route[0].destination.port.number | int | `8080` |  |
| mlp.routes.mlp.turingUI.enabled | bool | `true` |  |
| mlp.routes.mlp.turingUI.match[0].uri.prefix | string | `"/turing"` |  |
| mlp.routes.mlp.turingUI.route[0].destination.host | string | `"turing"` |  |
| mlp.routes.mlp.turingUI.route[0].destination.port.number | int | `8080` |  |
| mlp.routes.mlp.turingXpUI.enabled | bool | `true` |  |
| mlp.routes.mlp.turingXpUI.match[0].uri.prefix | string | `"/xp"` |  |
| mlp.routes.mlp.turingXpUI.route[0].destination.host | string | `"xp-management"` |  |
| mlp.routes.mlp.turingXpUI.route[0].destination.port.number | int | `8080` |  |
| mlp.routes.mlpAuthGateway.allowHeaders[0] | string | `"Authorization"` |  |
| mlp.routes.mlpAuthGateway.allowHeaders[1] | string | `"Content-Type"` |  |
| mlp.routes.mlpAuthGateway.allowMethods[0] | string | `"POST"` |  |
| mlp.routes.mlpAuthGateway.allowMethods[1] | string | `"GET"` |  |
| mlp.routes.mlpAuthGateway.allowMethods[2] | string | `"PUT"` |  |
| mlp.routes.mlpAuthGateway.allowMethods[3] | string | `"DELETE"` |  |
| mlp.routes.mlpAuthGateway.allowOrigins[0].exact | string | `"*"` |  |
| mlp.routes.mlpAuthGateway.enabled | bool | `true` |  |
| mlp.routes.mlpAuthGateway.match[0].uri.prefix | string | `"/api/"` |  |
| mlp.routes.mlpAuthGateway.rewrite.uri | string | `"/"` |  |
| mlp.routes.mlpAuthGateway.route[0].destination.host | string | `"mlp-authentication"` |  |
| mlp.routes.mlpAuthGateway.route[0].destination.port.number | int | `8080` |  |
| mlpDocs.routes.hosts[0] | string | `"docs"` |  |
| mlpDocs.routes.merlin.app | string | `"merlin"` |  |
| mlpDocs.routes.merlin.destHost | string | `"merlin-swagger"` |  |
| mlpDocs.routes.merlin.destPort | int | `8080` |  |
| mlpDocs.routes.merlin.enabled | bool | `true` |  |
| mlpDocs.routes.merlin.redirectMatch | string | `"/merlin/rest-api"` |  |
| mlpDocs.routes.merlin.rewriteUri | string | `"/"` |  |
| mlpDocs.routes.turing.app | string | `"turing"` |  |
| mlpDocs.routes.turing.destHost | string | `"turing"` |  |
| mlpDocs.routes.turing.destPort | int | `8080` |  |
| mlpDocs.routes.turing.enabled | bool | `true` |  |
| mlpDocs.routes.turing.redirectMatch | string | `"/turing/rest-api"` |  |
| mlpDocs.routes.turing.rewriteUri | string | `"/api-docs"` |  |
| mlpDocs.routes.xpManagement.app | string | `"xp-management"` |  |
| mlpDocs.routes.xpManagement.destHost | string | `"xp-management-swagger"` |  |
| mlpDocs.routes.xpManagement.destPort | int | `8080` |  |
| mlpDocs.routes.xpManagement.enabled | bool | `true` |  |
| mlpDocs.routes.xpManagement.redirectMatch | string | `"/xp/rest-api"` |  |
| mlpDocs.routes.xpManagement.rewriteUri | string | `"/"` |  |
| mlpDocs.routes.xpTreatment.app | string | `"xp-treatment"` |  |
| mlpDocs.routes.xpTreatment.destHost | string | `"xp-treatment-swagger"` |  |
| mlpDocs.routes.xpTreatment.destPort | int | `8080` |  |
| mlpDocs.routes.xpTreatment.enabled | bool | `true` |  |
| mlpDocs.routes.xpTreatment.redirectMatch | string | `"/xp/treatment-api"` |  |
| mlpDocs.routes.xpTreatment.rewriteUri | string | `"/"` |  |
| mlpGateway.hosts[0] | string | `"console"` |  |
| mlpGateway.hosts[1] | string | `"docs"` |  |
| mlpGateway.hosts[2] | string | `"mlflow"` |  |
| mlpGateway.name | string | `"mlp-gateway"` |  |
| mlpGateway.selector.istio | string | `"ingressgateway"` |  |
| namespace | string | `"mlp"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
