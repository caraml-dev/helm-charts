# caraml

![Version: 0.8.20](https://img.shields.io/badge/Version-0.8.20-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0.0](https://img.shields.io/badge/AppVersion-1.0.0-informational?style=flat-square)

A Helm chart for deploying CaraML components

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| caraml-dev | <caraml-dev@caraml.dev> |  |

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://caraml-dev.github.io/helm-charts | caraml-authz(authz) | 0.1.12 |
| https://caraml-dev.github.io/helm-charts | caraml-routes | 0.3.3 |
| https://caraml-dev.github.io/helm-charts | certManagerBase(cert-manager-base) | 1.8.1 |
| https://caraml-dev.github.io/helm-charts | common | 0.2.9 |
| https://caraml-dev.github.io/helm-charts | clusterLocalGateway(generic-dep-installer) | 0.2.1 |
| https://caraml-dev.github.io/helm-charts | istioIngressGateway(generic-dep-installer) | 0.2.1 |
| https://caraml-dev.github.io/helm-charts | istiod(generic-dep-installer) | 0.2.1 |
| https://caraml-dev.github.io/helm-charts | merlin | 0.13.6 |
| https://caraml-dev.github.io/helm-charts | mlp | 0.6.4 |
| https://caraml-dev.github.io/helm-charts | turing | 0.3.7 |
| https://caraml-dev.github.io/helm-charts | xp-management | 0.2.10 |
| https://caraml-dev.github.io/helm-charts | xp-treatment | 0.1.26 |
| https://charts.helm.sh/stable | postgresql | 7.0.2 |
| https://charts.jetstack.io | cert-manager | v1.8.2 |
| https://istio-release.storage.googleapis.com/charts | base(base) | 1.13.9 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| base.enabled | bool | `true` | Set to false if there is an existing istio deployment |
| base.global.istioNamespace | string | `"istio-system"` |  |
| base.validationURL | string | `""` |  |
| caraml-authz.enabled | bool | `false` |  |
| caraml-routes.cert-manager.enabled | bool | `false` |  |
| caraml-routes.certManagerBase.enabled | bool | `false` |  |
| caraml-routes.enabled | bool | `true` |  |
| cert-manager.enabled | bool | `false` |  |
| cert-manager.fullnameOverride | string | `"cert-manager"` |  |
| certManagerBase.enabled | bool | `true` |  |
| clusterLocalGateway.chartValues.autoscaling.enabled | bool | `false` |  |
| clusterLocalGateway.chartValues.env.ISTIO_METAJSON_STATS | string | `"{\\\"sidecar.istio.io/statsInclusionSuffixes\\\": \\\"upstream_rq_1xx,upstream_rq_2xx,upstream_rq_3xx,upstream_rq_4xx,upstream_rq_5xx,upstream_rq_time,upstream_cx_tx_bytes_total,upstream_cx_rx_bytes_total,upstream_cx_total,downstream_rq_1xx,downstream_rq_2xx,downstream_rq_3xx,downstream_rq_4xx,downstream_rq_5xx,downstream_rq_time,downstream_cx_tx_bytes_total,downstream_cx_rx_bytes_total,downstream_cx_total\\\"}\n"` |  |
| clusterLocalGateway.chartValues.global.enabled | bool | `true` | Controls deployment of cluster-local-gateway. Set to false if there is an existing istio deployment |
| clusterLocalGateway.chartValues.labels.app | string | `"cluster-local-gateway"` |  |
| clusterLocalGateway.chartValues.labels.istio | string | `"cluster-local-gateway"` |  |
| clusterLocalGateway.chartValues.name | string | `"cluster-local-gateway"` | Specify name here so each gateway installation has its own unique name |
| clusterLocalGateway.chartValues.resources.limits.cpu | string | `"1000m"` |  |
| clusterLocalGateway.chartValues.resources.limits.memory | string | `"1024Mi"` |  |
| clusterLocalGateway.chartValues.resources.requests.cpu | string | `"250m"` |  |
| clusterLocalGateway.chartValues.resources.requests.memory | string | `"256Mi"` |  |
| clusterLocalGateway.chartValues.service.ports[0].name | string | `"http2"` |  |
| clusterLocalGateway.chartValues.service.ports[0].port | int | `80` |  |
| clusterLocalGateway.chartValues.service.ports[0].targetPort | int | `80` |  |
| clusterLocalGateway.chartValues.service.ports[1].name | string | `"https"` |  |
| clusterLocalGateway.chartValues.service.ports[1].port | int | `443` |  |
| clusterLocalGateway.chartValues.service.type | string | `"ClusterIP"` |  |
| clusterLocalGateway.chartValues.serviceAccount.create | bool | `true` |  |
| clusterLocalGateway.chartValues.serviceAccount.name | string | `"cluster-local-gateway"` |  |
| clusterLocalGateway.global.enabled | bool | `true` | Controls deployment of cluster-local-gateway. Set to false if there is an existing istio deployment |
| clusterLocalGateway.helmChart.chart | string | `"gateway"` |  |
| clusterLocalGateway.helmChart.createNamespace | bool | `false` |  |
| clusterLocalGateway.helmChart.namespace | string | `"istio-system"` |  |
| clusterLocalGateway.helmChart.release | string | `"cluster-local-gateway"` |  |
| clusterLocalGateway.helmChart.repository | string | `"https://istio-release.storage.googleapis.com/charts"` |  |
| clusterLocalGateway.helmChart.version | string | `"1.13.9"` |  |
| clusterLocalGateway.hook.weight | int | `1` |  |
| global.dbSecretKey | string | `"postgresql-password"` |  |
| global.hosts.mlflow[0] | string | `"mlflow"` |  |
| global.hosts.mlp[0] | string | `"console"` |  |
| global.hosts.mlpdocs[0] | string | `"docs"` |  |
| global.istioLookUp | object | `{"name":"istio-ingressgateway","namespace":"istio-system"}` | istioIngressIP takes precedence over domain. Used for local deployment |
| global.merlin.apiPrefix | string | `"/v1"` |  |
| global.merlin.externalPort | string | `"8080"` |  |
| global.merlin.mlflow.postgresqlDatabase | string | `"mlflow"` |  |
| global.merlin.postgresqlDatabase | string | `"merlin"` |  |
| global.merlin.serviceName | string | `"merlin"` |  |
| global.merlin.uiPrefix | string | `"/merlin"` |  |
| global.merlin.uiServiceName | string | `"merlin"` |  |
| global.merlin.useServiceFqdn | bool | `true` |  |
| global.merlin.vsPrefix | string | `"/api/merlin"` |  |
| global.mlflow.externalPort | string | `"80"` |  |
| global.mlflow.serviceName | string | `"merlin-mlflow"` |  |
| global.mlp.apiPrefix | string | `""` |  |
| global.mlp.externalPort | string | `"8080"` |  |
| global.mlp.postgresqlDatabase | string | `"mlp"` |  |
| global.mlp.serviceName | string | `"mlp"` |  |
| global.mlp.uiPrefix | string | `"/"` |  |
| global.mlp.uiServiceName | string | `"mlp"` |  |
| global.mlp.useServiceFqdn | bool | `true` |  |
| global.mlp.vsPrefix | string | `"/api"` |  |
| global.postgresqlDatabase | string | `"caraml"` |  |
| global.postgresqlUsername | string | `"caraml"` |  |
| global.protocol | string | `"http"` |  |
| global.turing.postgresqlDatabase | string | `"turing"` |  |
| global.xp.apiPrefix | string | `"/v1"` |  |
| global.xp.externalPort | string | `"8080"` |  |
| global.xp.postgresqlDatabase | string | `"xp"` |  |
| global.xp.serviceName | string | `"xp-management"` |  |
| global.xp.uiPrefix | string | `"/xp"` |  |
| global.xp.uiServiceName | string | `"xp-management"` |  |
| global.xp.useServiceFqdn | bool | `true` |  |
| global.xp.vsPrefix | string | `"/api/xp"` |  |
| istioIngressGateway.chartValues.autoscaling.enabled | bool | `false` |  |
| istioIngressGateway.chartValues.env.ISTIO_METAJSON_STATS | string | `"{\\\"sidecar.istio.io/statsInclusionSuffixes\\\": \\\"upstream_rq_1xx,upstream_rq_2xx,upstream_rq_3xx,upstream_rq_4xx,upstream_rq_5xx,upstream_rq_time,upstream_cx_tx_bytes_total,upstream_cx_rx_bytes_total,upstream_cx_total,downstream_rq_1xx,downstream_rq_2xx,downstream_rq_3xx,downstream_rq_4xx,downstream_rq_5xx,downstream_rq_time,downstream_cx_tx_bytes_total,downstream_cx_rx_bytes_total,downstream_cx_total\\\"}\n"` |  |
| istioIngressGateway.chartValues.env.ISTIO_META_ROUTER_MODE | string | `"standard"` |  |
| istioIngressGateway.chartValues.name | string | `"istio-ingressgateway"` | Specify name here so each gateway installation has its own unique name |
| istioIngressGateway.chartValues.resources.limits.cpu | string | `"1000m"` |  |
| istioIngressGateway.chartValues.resources.limits.memory | string | `"2048Mi"` |  |
| istioIngressGateway.chartValues.resources.requests.cpu | string | `"250m"` |  |
| istioIngressGateway.chartValues.resources.requests.memory | string | `"256Mi"` |  |
| istioIngressGateway.chartValues.serviceAccount.create | bool | `true` |  |
| istioIngressGateway.chartValues.serviceAccount.name | string | `"istio-ingressgateway"` |  |
| istioIngressGateway.global.enabled | bool | `true` | Controls deployment of istio-ingressgateway. Set to false if there is an existing istio deployment |
| istioIngressGateway.helmChart.chart | string | `"gateway"` |  |
| istioIngressGateway.helmChart.createNamespace | bool | `false` |  |
| istioIngressGateway.helmChart.namespace | string | `"istio-system"` |  |
| istioIngressGateway.helmChart.release | string | `"istio-ingress-gateway"` |  |
| istioIngressGateway.helmChart.repository | string | `"https://istio-release.storage.googleapis.com/charts"` |  |
| istioIngressGateway.helmChart.version | string | `"1.13.9"` |  |
| istioIngressGateway.hook.weight | int | `1` |  |
| istiod.chartValues.configValidation | bool | `true` |  |
| istiod.chartValues.deployInReleaseNs | bool | `false` |  |
| istiod.chartValues.global.configValidation | bool | `true` |  |
| istiod.chartValues.global.istioNamespace | string | `"istio-system"` |  |
| istiod.chartValues.meshConfig.enableTracing | bool | `false` |  |
| istiod.chartValues.pilot.autoscaleEnabled | bool | `false` |  |
| istiod.chartValues.pilot.cpu.targetAverageUtilization | int | `80` |  |
| istiod.chartValues.pilot.resources.limits.cpu | int | `1` |  |
| istiod.chartValues.pilot.resources.limits.memory | string | `"1024Mi"` |  |
| istiod.chartValues.pilot.resources.requests.cpu | string | `"250m"` |  |
| istiod.chartValues.pilot.resources.requests.memory | string | `"256Mi"` |  |
| istiod.enabled | bool | `true` | Set to false if there is an existing istio deployment |
| istiod.helmChart.chart | string | `"istiod"` |  |
| istiod.helmChart.namespace | string | `"istio-system"` |  |
| istiod.helmChart.release | string | `"istiod"` |  |
| istiod.helmChart.repository | string | `"https://istio-release.storage.googleapis.com/charts"` |  |
| istiod.helmChart.version | string | `"1.13.9"` |  |
| istiod.hook.weight | int | `-3` |  |
| merlin.deployment.resources.limits.cpu | string | `"500m"` |  |
| merlin.deployment.resources.limits.memory | string | `"512Mi"` |  |
| merlin.deployment.resources.requests.cpu | string | `"250m"` |  |
| merlin.deployment.resources.requests.memory | string | `"256Mi"` |  |
| merlin.enabled | bool | `true` | To enable/disable merlin chart installation. |
| merlin.kserve.chartValues.cert-manager.enabled | bool | `true` |  |
| merlin.kserve.chartValues.knativeServingIstio.chartValues.base.enabled | bool | `false` |  |
| merlin.kserve.chartValues.knativeServingIstio.chartValues.clusterLocalGateway.global.enabled | bool | `false` |  |
| merlin.kserve.chartValues.knativeServingIstio.chartValues.controller.resources.limits.cpu | string | `"1000m"` |  |
| merlin.kserve.chartValues.knativeServingIstio.chartValues.controller.resources.limits.memory | string | `"512Mi"` |  |
| merlin.kserve.chartValues.knativeServingIstio.chartValues.controller.resources.requests.cpu | string | `"200m"` |  |
| merlin.kserve.chartValues.knativeServingIstio.chartValues.controller.resources.requests.memory | string | `"256Mi"` |  |
| merlin.kserve.chartValues.knativeServingIstio.chartValues.istioIngressGateway.global.enabled | bool | `false` |  |
| merlin.kserve.chartValues.knativeServingIstio.chartValues.istioIngressGateway.helmChart.namespace | string | `"istio-system"` |  |
| merlin.kserve.chartValues.knativeServingIstio.chartValues.istiod.enabled | bool | `false` |  |
| merlin.kserve.chartValues.knativeServingIstio.chartValues.knativeServingCore.autoscaler.resources.limits.cpu | string | `"1000m"` |  |
| merlin.kserve.chartValues.knativeServingIstio.chartValues.knativeServingCore.autoscaler.resources.limits.memory | string | `"1000Mi"` |  |
| merlin.kserve.chartValues.knativeServingIstio.chartValues.knativeServingCore.autoscaler.resources.requests.cpu | string | `"250m"` |  |
| merlin.kserve.chartValues.knativeServingIstio.chartValues.knativeServingCore.autoscaler.resources.requests.memory | string | `"256Mi"` |  |
| merlin.kserve.chartValues.knativeServingIstio.chartValues.knativeServingCore.autoscalerHpa.resources.limits.cpu | string | `"500m"` |  |
| merlin.kserve.chartValues.knativeServingIstio.chartValues.knativeServingCore.autoscalerHpa.resources.limits.memory | string | `"256Mi"` |  |
| merlin.kserve.chartValues.knativeServingIstio.chartValues.knativeServingCore.autoscalerHpa.resources.requests.cpu | string | `"250m"` |  |
| merlin.kserve.chartValues.knativeServingIstio.chartValues.knativeServingCore.autoscalerHpa.resources.requests.memory | string | `"128Mi"` |  |
| merlin.kserve.chartValues.knativeServingIstio.chartValues.knativeServingCore.controller.resources.limits.cpu | string | `"1000m"` |  |
| merlin.kserve.chartValues.knativeServingIstio.chartValues.knativeServingCore.controller.resources.limits.memory | string | `"512Mi"` |  |
| merlin.kserve.chartValues.knativeServingIstio.chartValues.knativeServingCore.controller.resources.requests.cpu | string | `"200m"` |  |
| merlin.kserve.chartValues.knativeServingIstio.chartValues.knativeServingCore.controller.resources.requests.memory | string | `"256Mi"` |  |
| merlin.kserve.chartValues.knativeServingIstio.chartValues.webhook.resources.limits.cpu | string | `"300m"` |  |
| merlin.kserve.chartValues.knativeServingIstio.chartValues.webhook.resources.limits.memory | string | `"512Mi"` |  |
| merlin.kserve.chartValues.knativeServingIstio.chartValues.webhook.resources.requests.cpu | string | `"100m"` |  |
| merlin.kserve.chartValues.knativeServingIstio.chartValues.webhook.resources.requests.memory | string | `"256Mi"` |  |
| merlin.kserve.enabled | bool | `true` |  |
| merlin.merlin-postgresql.enabled | bool | `false` | To enable/disable merlin specific postgres |
| merlin.mlflow-postgresql.enabled | bool | `false` | To enable/disable mlflow specific postgres |
| merlin.mlflow.resources.limits.cpu | string | `"500m"` |  |
| merlin.mlflow.resources.limits.memory | string | `"512Mi"` |  |
| merlin.mlflow.resources.requests.cpu | string | `"250m"` |  |
| merlin.mlflow.resources.requests.memory | string | `"256Mi"` |  |
| merlin.mlp.enabled | bool | `false` |  |
| mlp.deployment.authorization.enabled | bool | `true` |  |
| mlp.enabled | bool | `true` | To enable/disable MLP chart installation. |
| mlp.fullnameOverride | string | `"mlp"` |  |
| mlp.keto.deployment.resources.limits.memory | string | `"256Mi"` |  |
| mlp.keto.deployment.resources.requests.cpu | string | `"250m"` |  |
| mlp.keto.deployment.resources.requests.memory | string | `"256Mi"` |  |
| mlp.keto.enabled | bool | `true` |  |
| mlp.keto.fullnameOverride | string | `"mlp-keto"` |  |
| mlp.postgresql.enabled | bool | `false` | To enable/disable MLP specific postgres |
| postgresql.enabled | bool | `true` | To enable/disable CaraML specific postgres |
| postgresql.initdbScripts."init.sql" | string | `"CREATE DATABASE mlp;\nCREATE DATABASE merlin;\nCREATE DATABASE mlflow;\nCREATE DATABASE authz;\nCREATE DATABASE turing;\nCREATE DATABASE xp;\n"` |  |
| postgresql.persistence.size | string | `"10Gi"` |  |
| postgresql.postgresqlDatabase | string | `"caraml"` | To set the database schema name created in postgres |
| postgresql.postgresqlUsername | string | `"caraml"` | To set the user name for the database instance |
| postgresql.resources | object | `{}` | Configure resource requests and limits, Ref: http://kubernetes.io/docs/user-guide/compute-resources/ |
| turing.config.AuthConfig.Enabled | bool | `false` |  |
| turing.deployment.resources.limits.cpu | string | `"500m"` |  |
| turing.deployment.resources.limits.memory | string | `"512Mi"` |  |
| turing.deployment.resources.requests.cpu | string | `"250m"` |  |
| turing.deployment.resources.requests.memory | string | `"256Mi"` |  |
| turing.enabled | bool | `true` |  |
| turing.merlin.enabled | bool | `false` |  |
| turing.mlp.enabled | bool | `false` |  |
| turing.turing-postgresql.enabled | bool | `false` | To enable/disable turing specific postgresql |
| xp-management.enabled | bool | `true` |  |
| xp-management.mlp.enabled | bool | `false` |  |
| xp-management.xp-management-postgresql.enabled | bool | `false` |  |
| xp-treatment.enabled | bool | `true` |  |
| xp-treatment.xp-management.enabled | bool | `false` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)