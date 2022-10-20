# merlin

![Version: 0.9.0](https://img.shields.io/badge/Version-0.8.0-informational?style=flat-square) ![AppVersion: 0.22.0](https://img.shields.io/badge/AppVersion-0.22.0-informational?style=flat-square)

Kubernetes-friendly ML model management, deployment, and serving.

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| caraml-dev | <caraml-dev@caraml.dev> |  |

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://caraml-dev.github.io/helm-charts | vault(generic-dep-installer) | 0.1.1 |
| https://caraml-dev.github.io/helm-charts | kserve(generic-dep-installer) | 0.1.1 |
| https://caraml-dev.github.io/helm-charts | minio(generic-dep-installer) | 0.1.1 |
| https://caraml-dev.github.io/helm-charts | mlp | 0.2.0 |
| https://charts.helm.sh/stable | merlin-postgresql(postgresql) | 7.0.0 |
| https://charts.helm.sh/stable | mlflow-postgresql(postgresql) | 7.0.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| alerts.alertBranch | string | `"master"` |  |
| alerts.alertRepository | string | `"lens/artillery/datascience"` |  |
| alerts.alertsRepoPlatform | string | `"gitlab"` | Repository platform where the created Alerts and Dashboards need to be pushed. Platforms supported as of now: Gitlab |
| alerts.baseURL | string | `"https://gitlab.com/"` |  |
| alerts.dashboardBranch | string | `"master"` |  |
| alerts.dashboardRepository | string | `"data-science/slo-specs"` |  |
| alerts.enabled | bool | `false` | To enable/disable creation/modification of the alerts and dashboards for the deployed models via merlin. |
| alerts.warden.apiHost | string | `""` |  |
| authorization.enabled | bool | `true` |  |
| authorization.serverUrl | string | `"http://mlp-authorization-keto"` |  |
| deployment.image.pullPolicy | string | `"IfNotPresent"` |  |
| deployment.image.registry | string | `"ghcr.io"` |  |
| deployment.image.repository | string | `"gojek/merlin"` |  |
| deployment.image.tag | string | `"0.23.0-rc1"` |  |
| deployment.labels | object | `{}` |  |
| deployment.podLabels | object | `{}` |  |
| deployment.replicaCount | string | `"2"` |  |
| deployment.resources.limits.cpu | string | `"1"` |  |
| deployment.resources.limits.memory | string | `"1Gi"` |  |
| deployment.resources.requests.cpu | string | `"500m"` |  |
| deployment.resources.requests.memory | string | `"1Gi"` |  |
| encryption.key | string | `"password"` |  |
| environment | string | `"dev"` |  |
| environmentConfigs[0].cluster | string | `"test"` |  |
| environmentConfigs[0].default_deployment_config.cpu_request | string | `"500m"` |  |
| environmentConfigs[0].default_deployment_config.max_replica | int | `1` |  |
| environmentConfigs[0].default_deployment_config.memory_request | string | `"500Mi"` |  |
| environmentConfigs[0].default_deployment_config.min_replica | int | `0` |  |
| environmentConfigs[0].default_prediction_job_config.driver_cpu_request | string | `"2"` |  |
| environmentConfigs[0].default_prediction_job_config.driver_memory_request | string | `"2Gi"` |  |
| environmentConfigs[0].default_prediction_job_config.executor_cpu_request | string | `"2"` |  |
| environmentConfigs[0].default_prediction_job_config.executor_memory_request | string | `"2Gi"` |  |
| environmentConfigs[0].default_prediction_job_config.executor_replica | int | `3` |  |
| environmentConfigs[0].default_transformer_config.cpu_request | string | `"500m"` |  |
| environmentConfigs[0].default_transformer_config.max_replica | int | `1` |  |
| environmentConfigs[0].default_transformer_config.memory_request | string | `"500Mi"` |  |
| environmentConfigs[0].default_transformer_config.min_replica | int | `0` |  |
| environmentConfigs[0].deployment_timeout | string | `"10m"` |  |
| environmentConfigs[0].gcp_project | string | `"gcp-project"` |  |
| environmentConfigs[0].is_default | bool | `true` |  |
| environmentConfigs[0].is_default_prediction_job | bool | `true` |  |
| environmentConfigs[0].is_prediction_job_enabled | bool | `true` |  |
| environmentConfigs[0].max_cpu | string | `"8"` |  |
| environmentConfigs[0].max_memory | string | `"8Gi"` |  |
| environmentConfigs[0].name | string | `"id-dev"` |  |
| environmentConfigs[0].namespace_timeout | string | `"2m"` |  |
| environmentConfigs[0].queue_resource_percentage | string | `"20"` |  |
| environmentConfigs[0].region | string | `"id"` |  |
| feastCoreApi.apiHost | string | `"http://feast-core.mlp:8080/v1"` |  |
| imageBuilder.clusterName | string | `"test"` |  |
| imageBuilder.dockerRegistry | string | `"dockerRegistry"` |  |
| imageBuilder.kanikoImage | string | `"gcr.io/kaniko-project/executor:v1.6.0"` |  |
| imageBuilder.maxRetry | int | `3` |  |
| imageBuilder.namespace | string | `"mlp"` |  |
| imageBuilder.nodeSelectors | object | `{}` |  |
| imageBuilder.baseImages | object | `{}` |  |
| imageBuilder.predictionJobBaseImages | object | `{}` |  |
| imageBuilder.predictionJobContextSubPath | string | `""` |  |
| imageBuilder.retention | string | `"48h"` |  |
| imageBuilder.timeout | string | `"30m"` |  |
| imageBuilder.tolerations | list | `[]` |  |
| ingress.enabled | bool | `false` |  |
| kserve.enabled | bool | `true` |  |
| kserve.helmChart.chart | string | `"kserve"` |  |
| kserve.helmChart.createNamespace | bool | `true` |  |
| kserve.helmChart.namespace | string | `"kserve"` |  |
| kserve.helmChart.release | string | `"kserve"` |  |
| kserve.helmChart.repository | string | `"https://caraml-dev.github.io/helm-charts"` |  |
| kserve.helmChart.version | string | `"0.8.5"` |  |
| kserve.hook.weight | string | `"-2"` |  |
| loggerDestinationURL | string | `"http://yourDestinationLogger"` |  |
| merlin-postgresql.enabled | bool | `true` |  |
| merlin-postgresql.persistence.size | string | `"10Gi"` |  |
| merlin-postgresql.postgresqlDatabase | string | `"merlin"` |  |
| merlin-postgresql.postgresqlUsername | string | `"merlin"` |  |
| merlin-postgresql.resources.requests.cpu | string | `"100m"` |  |
| merlin-postgresql.resources.requests.memory | string | `"512Mi"` |  |
| merlinExternalPostgresql.address | string | `"127.0.0.1"` | Host address for the External postgres |
| merlinExternalPostgresql.database | string | `"merlin"` | External postgres database schema |
| merlinExternalPostgresql.enabled | bool | `false` | If you would like to use an external postgres database, enable it here using this |
| merlinExternalPostgresql.password | string | `"password"` |  |
| merlinExternalPostgresql.secretKey | string | `""` | If a secret is created by external systems (eg. Vault)., mention the key under which password is stored in secret (eg. postgresql-password) |
| merlinExternalPostgresql.secretName | string | `""` | If a secret is created by external systems (eg. Vault)., mention the secret name here |
| merlinExternalPostgresql.username | string | `"merlin"` | External postgres database user |
| minio.chartValues.defaultBucket.enabled | bool | `true` |  |
| minio.chartValues.defaultBucket.name | string | `"mlflow"` |  |
| minio.chartValues.ingress.annotations."kubernetes.io/ingress.class" | string | `"istio"` |  |
| minio.chartValues.ingress.enabled | bool | `false` |  |
| minio.chartValues.ingress.path | string | `"/*"` |  |
| minio.chartValues.livenessProbe.initialDelaySeconds | int | `30` |  |
| minio.chartValues.persistence.enabled | bool | `false` |  |
| minio.chartValues.replicas | int | `1` |  |
| minio.chartValues.resources.requests.cpu | string | `"25m"` |  |
| minio.chartValues.resources.requests.memory | string | `"64Mi"` |  |
| minio.enabled | bool | `true` |  |
| minio.helmChart.chart | string | `"minio"` |  |
| minio.helmChart.createNamespace | bool | `true` |  |
| minio.helmChart.namespace | string | `"minio"` |  |
| minio.helmChart.release | string | `"minio"` |  |
| minio.helmChart.repository | string | `"https://helm.min.io/"` |  |
| minio.helmChart.version | string | `"7.0.2"` |  |
| minio.hook.weight | string | `"-2"` |  |
| mlflow-postgresql.enabled | bool | `true` |  |
| mlflow-postgresql.persistence.enabled | bool | `true` |  |
| mlflow-postgresql.persistence.size | string | `"10Gi"` |  |
| mlflow-postgresql.postgresqlDatabase | string | `"mlflow"` |  |
| mlflow-postgresql.postgresqlUsername | string | `"mlflow"` |  |
| mlflow-postgresql.replicaCount | int | `1` |  |
| mlflow-postgresql.resources.requests.cpu | string | `"500m"` |  |
| mlflow-postgresql.resources.requests.memory | string | `"512Mi"` |  |
| mlflow.artifactRoot | string | `"/data/artifacts"` |  |
| mlflow.deploymentLabels | object | `{}` |  |
| mlflow.extraEnvs.MLFLOW_S3_ENDPOINT_URL | string | `"http://minio.minio.svc.cluster.local:9000"` |  |
| mlflow.host | string | `"0.0.0.0"` |  |
| mlflow.image.pullPolicy | string | `"Always"` |  |
| mlflow.image.registry | string | `"ghcr.io"` |  |
| mlflow.image.repository | string | `"gojek/mlflow"` |  |
| mlflow.image.tag | string | `"1.3.0"` |  |
| mlflow.ingress.class | string | `"nginx"` |  |
| mlflow.ingress.enabled | bool | `false` |  |
| mlflow.livenessProbe.initialDelaySeconds | int | `30` |  |
| mlflow.livenessProbe.periodSeconds | int | `10` |  |
| mlflow.livenessProbe.successThreshold | int | `1` |  |
| mlflow.livenessProbe.timeoutSeconds | int | `30` |  |
| mlflow.name | string | `"mlflow"` |  |
| mlflow.podLabels | object | `{}` |  |
| mlflow.readinessProbe.initialDelaySeconds | int | `30` |  |
| mlflow.readinessProbe.periodSeconds | int | `10` |  |
| mlflow.readinessProbe.successThreshold | int | `1` |  |
| mlflow.readinessProbe.timeoutSeconds | int | `30` |  |
| mlflow.replicaCount | int | `1` |  |
| mlflow.resources.limits.memory | string | `"2048Mi"` |  |
| mlflow.resources.requests.cpu | string | `"500m"` |  |
| mlflow.resources.requests.memory | string | `"512Mi"` |  |
| mlflow.rollingUpdate.maxSurge | int | `1` |  |
| mlflow.rollingUpdate.maxUnavailable | int | `0` |  |
| mlflow.service.externalPort | int | `80` |  |
| mlflow.service.internalPort | int | `5000` |  |
| mlflow.service.type | string | `"ClusterIP"` |  |
| mlflow.statefulset.updateStrategy | string | `"RollingUpdate"` |  |
| mlflow.trackingURL | string | `"http://www.example.com"` |  |
| mlflowExternalPostgresql.address | string | `"127.0.0.1"` | Host address for the External postgres |
| mlflowExternalPostgresql.database | string | `"mlflow"` | External postgres database schema |
| mlflowExternalPostgresql.enabled | bool | `false` | If you would like to use an external postgres database, enable it here using this |
| mlflowExternalPostgresql.password | string | `"password"` |  |
| mlflowExternalPostgresql.secretKey | string | `""` | If a secret is created by external systems (eg. Vault)., mention the key under which password is stored in secret (eg. postgresql-password) |
| mlflowExternalPostgresql.secretName | string | `""` | If a secret is created by external systems (eg. Vault)., mention the secret name here |
| mlflowExternalPostgresql.username | string | `"mlflow"` | External postgres database user |
| mlpApi.apiHost | string | `"http://mlp.mlp:8080/v1"` |  |
| mlpApi.encryptionKey | string | `"secret-encyrption"` |  |
| monitoring.enabled | bool | `false` |  |
| newrelic.appname | string | `"merlin-api-dev"` |  |
| newrelic.enabled | bool | `false` |  |
| newrelic.licenseSecretName | string | `"newrelic-license-secret"` |  |
| queue.numOfWorkers | int | `1` |  |
| sentry.dsn | string | `""` |  |
| sentry.enabled | bool | `false` |  |
| service.externalPort | int | `8080` |  |
| service.internalPort | int | `8080` |  |
| setupScript.clusterType | string | `"kind"` |  |
| setupScript.enabled | bool | `true` |  |
| setupScript.image | string | `"bitnami/kubectl:latest"` | Image used to for setup scripts job |
| swagger.apiHost | string | `"merlin.dev"` |  |
| swagger.basePath | string | `"/api/merlin/v1"` |  |
| swagger.enabled | bool | `true` |  |
| swagger.image.tag | string | `"v3.23.5"` |  |
| swagger.service.externalPort | int | `8080` |  |
| swagger.service.internalPort | int | `8081` |  |
| transformer.feast.authEnabled | bool | `false` |  |
| transformer.feast.bigtableCredential | string | `nil` |  |
| transformer.feast.coreAuthAudience | string | `"core.feast.dev"` |  |
| transformer.feast.coreURL | string | `"core.feast.dev"` |  |
| transformer.feast.defaultFeastSource | string | `"BIGTABLE"` |  |
| transformer.feast.defaultServingURL | string | `"online-serving-redis.feast.dev"` |  |
| transformer.feast.servingURLs[0].host | string | `"online-serving-redis.feast.dev"` |  |
| transformer.feast.servingURLs[0].icon | string | `"redis"` |  |
| transformer.feast.servingURLs[0].label | string | `"Online Serving with Redis"` |  |
| transformer.feast.servingURLs[0].source_type | string | `"REDIS"` |  |
| transformer.feast.servingURLs[1].host | string | `"online-serving-bigtable.feast.dev"` |  |
| transformer.feast.servingURLs[1].icon | string | `"bigtable"` |  |
| transformer.feast.servingURLs[1].label | string | `"Online Serving with BigTable"` |  |
| transformer.feast.servingURLs[1].source_type | string | `"BIGTABLE"` |  |
| transformer.image | string | `"merlin-transformer:1.0.0"` |  |
| transformer.jaeger.agentHost | string | `"localhost"` |  |
| transformer.jaeger.agentPort | int | `6831` |  |
| transformer.jaeger.disabled | bool | `false` |  |
| transformer.jaeger.samplerParam | int | `1` |  |
| transformer.jaeger.samplerType | string | `"const"` |  |
| transformer.simulation.feastBigtableServingURL | string | `"online-serving-bt.feast.dev"` |  |
| transformer.simulation.feastRedisServingURL | string | `"online-serving-redis.feast.dev"` |  |
| ui.apiHost | string | `"/api/merlin/v1"` |  |
| ui.dockerRegistries | string | `"ghcr.io/gojek,ghcr.io/your-company"` |  |
| ui.docsURL[0].href | string | `"https://github.com/gojek/merlin/blob/main/docs/getting-started/README.md"` |  |
| ui.docsURL[0].label | string | `"Getting Started with Merlin"` |  |
| ui.homepage | string | `"/merlin"` |  |
| ui.maxAllowedReplica | int | `20` |  |
| ui.mlp.apiHost | string | `"/api/v1"` |  |
| ui.oauthClientID | string | `""` |  |
| vault.chartValues.injector.enabled | bool | `false` |  |
| vault.chartValues.server.affinity | string | `nil` |  |
| vault.chartValues.server.dataStore.enabled | bool | `false` |  |
| vault.chartValues.server.dev | object | `{"enabled":true}` | This is just for quick install. For a production, NEVER EVER use the vault server in dev mode. |
| vault.chartValues.server.resources.requests.cpu | string | `"25m"` |  |
| vault.chartValues.server.resources.requests.memory | string | `"64Mi"` |  |
| vault.chartValues.server.tolerations | string | `nil` |  |
| vault.enabled | bool | `true` |  |
| vault.helmChart.chart | string | `"vault"` |  |
| vault.helmChart.createNamespace | bool | `true` |  |
| vault.helmChart.namespace | string | `"vault"` |  |
| vault.helmChart.release | string | `"vault"` |  |
| vault.helmChart.repository | string | `"https://helm.releases.hashicorp.com"` |  |
| vault.helmChart.version | string | `"0.19.0"` |  |
| vault.hook.weight | string | `"-2"` |  |
| vault.secretName | string | `"vault-secret"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
