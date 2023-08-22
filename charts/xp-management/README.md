# xp-management

---
![Version: 0.2.6](https://img.shields.io/badge/Version-0.2.6-informational?style=flat-square)
![AppVersion: 0.12.1](https://img.shields.io/badge/AppVersion-0.12.1-informational?style=flat-square)

Management service - A part of XP system that is used to configure experiments

## Introduction

This Helm chart installs [XP Management-Service](https://github.com/caraml-dev/xp-management-service) and all its dependencies in a Kubernetes cluster.

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| caraml-dev | <caraml-dev@caraml.dev> |  |

## Prerequisites

To use the charts here, [Helm](https://helm.sh/) must be configured for your
Kubernetes cluster. Setting up Kubernetes and Helm is outside the scope of
this README. Please refer to the Kubernetes and Helm documentation.

- **Helm 3.0+** – This chart was tested with Helm v3.7.1, but it is also expected to work with earlier Helm versions
- **Kubernetes 1.18+** – This chart was tested with GKE v1.20.x and with [Minikube](https://github.com/kubernetes/minikube) v1.27.x,
but it's possible it works with earlier k8s versions too

## Configuration

The following table lists the configurable parameters of the XP Management Service chart and their default values.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| deployment.annotations | object | `{}` | Annotations to add to Management Service pod |
| deployment.apiConfig | object | `{"AllowedOrigins":"*","AuthorizationConfig":{"Enabled":false},"DbConfig":{"ConnMaxIdleTime":"0s","ConnMaxLifetime":"0s","MaxIdleConns":0,"MaxOpenConns":0},"DeploymentConfig":{"EnvironmentType":"dev"},"MlpConfig":{"URL":"http://mlp:8080"},"NewRelicConfig":{"AppName":"xp-management-service","Enabled":false,"License":""},"Port":8080,"SegmenterConfig":{"S2_IDs":{"MaxS2CellLevel":14,"MinS2CellLevel":10}},"SentryConfig":{"DSN":"","Enabled":false,"Labels":{"App":"xp-management-service"}},"XpUIConfig":{"appDirectory":"/app/xp-ui"}}` | XP Management Service server configuration. Please refer to https://github.com/caraml-dev/xp/blob/main/management-service/config/example.yaml for the detailed explanation on XP Management API config options |
| deployment.extraArgs | list | `[]` | List of string containing additional XP Management Service server arguments. For example, multiple "-config" can be specified to use multiple config files |
| deployment.extraEnvs | list | `[]` | List of extra environment variables to add to XP Management Service server container |
| deployment.extraVolumeMounts | list | `[]` | Extra volume mounts to attach to XP Management Service server container. For example to mount the extra volume containing secrets |
| deployment.extraVolumes | list | `[]` | Extra volumes to attach to the Pod. For example, you can mount additional secrets to these volumes |
| deployment.image.pullPolicy | string | `"IfNotPresent"` | Docker image pull policy |
| deployment.image.registry | string | `"ghcr.io"` | Docker registry for XP Management Service image |
| deployment.image.repository | string | `"caraml-dev/xp/xp-management"` | Docker image repository for XP Management Service |
| deployment.image.tag | string | `"v0.12.1-build.1-064655f"` | Docker image tag for XP Management Service |
| deployment.labels | object | `{}` | Labels to attach to the deployment. |
| deployment.livenessProbe.initialDelaySeconds | int | `60` | Liveness probe delay and thresholds |
| deployment.livenessProbe.path | string | `"/v1/internal/live"` | HTTP path for liveness check |
| deployment.livenessProbe.periodSeconds | int | `10` |  |
| deployment.livenessProbe.successThreshold | int | `1` |  |
| deployment.livenessProbe.timeoutSeconds | int | `5` |  |
| deployment.readinessProbe.initialDelaySeconds | int | `60` | Liveness probe delay and thresholds |
| deployment.readinessProbe.path | string | `"/v1/internal/ready"` | HTTP path for readiness check |
| deployment.readinessProbe.periodSeconds | int | `10` |  |
| deployment.readinessProbe.successThreshold | int | `1` |  |
| deployment.readinessProbe.timeoutSeconds | int | `5` |  |
| deployment.replicaCount | int | `1` |  |
| deployment.resources | object | `{}` | Resources requests and limits for XP Management Service. This should be set according to your cluster capacity and service level objectives. Reference: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ |
| deployment.sentry.dsn | string | `""` | Sentry DSN value used by both XP Management Service and XP UI |
| deployment.sentry.enabled | bool | `false` |  |
| deployment.service.externalPort | int | `8080` | XP Management Service Kubernetes service port number |
| deployment.service.internalPort | int | `8080` | XP Management Service container port number |
| deployment.serviceAccount.annotations | object | `{}` |  |
| deployment.serviceAccount.create | bool | `true` |  |
| deployment.serviceAccount.name | string | `""` |  |
| global.environment | string | `"dev"` | Environment of Management Service deployment |
| global.mlp.apiPrefix | string | `""` |  |
| global.mlp.externalPort | string | `"8080"` |  |
| global.mlp.serviceName | string | `"mlp"` |  |
| global.mlp.useServiceFqdn | bool | `true` |  |
| global.protocol | string | `"http"` |  |
| global.sentry.dsn | string | `nil` | Global Sentry DSN value |
| swaggerUi.apiServer | string | `"http://127.0.0.1/v1"` | URL of API server |
| swaggerUi.enabled | bool | `true` |  |
| swaggerUi.image | object | `{"tag":"v3.47.1"}` | Docker tag for Swagger UI https://hub.docker.com/r/swaggerapi/swagger-ui |
| swaggerUi.service.externalPort | int | `3000` | Swagger UI Kubernetes service port number |
| swaggerUi.service.internalPort | int | `8081` | Swagger UI container port number |
| uiConfig | object | `{"apiConfig":{"mlpApiUrl":"/api/v1","xpApiUrl":"/api/xp/v1"},"appConfig":{"docsUrl":[{"href":"https://github.com/caraml-dev/xp/tree/main/docs","label":"XP User Guide"}]},"authConfig":{"oauthClientId":""},"sentryConfig":{}}` | XP UI configuration. |
| xp-management-postgresql | object | `{"containerPorts":{"postgresql":5432},"enabled":true,"persistence":{"enabled":true,"size":"10Gi"},"postgresqlDatabase":"xp","postgresqlPassword":"xp","postgresqlUsername":"xp","resources":{"requests":{"cpu":"100m","memory":"256Mi"}},"tls":{"enabled":false}}` | Postgresql configuration to be applied to XP Management Service's postgresql database deployment Reference: https://artifacthub.io/packages/helm/bitnami/postgresql/10.16.2#parameters |
| xp-management-postgresql.persistence.enabled | bool | `true` | Persist Postgresql data in a Persistent Volume Claim |
| xp-management-postgresql.postgresqlPassword | string | `"xp"` | Password for XP Management Service Postgresql database |
| xp-management-postgresql.resources | object | `{"requests":{"cpu":"100m","memory":"256Mi"}}` | Resources requests and limits for XP Management Service database. This should be set according to your cluster capacity and service level objectives. Reference: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ |
| xpManagementExternalPostgresql.address | string | `"127.0.0.1"` | Host address for the External postgres |
| xpManagementExternalPostgresql.createSecret | bool | `false` | Enable this if you need the chart to create a secret when you provide the password above. To be used together with password. |
| xpManagementExternalPostgresql.database | string | `"xp"` | External postgres database schema |
| xpManagementExternalPostgresql.enabled | bool | `false` | If you would like to use an external postgres database, enable it here using this |
| xpManagementExternalPostgresql.password | string | `"password"` |  |
| xpManagementExternalPostgresql.secretKey | string | `""` | Secret key in Secret which contains postgresql credentials |
| xpManagementExternalPostgresql.secretName | string | `""` | Secret name which contains credentials to access externalPostgresql |
| xpManagementExternalPostgresql.username | string | `"xp"` | External postgres database user |
