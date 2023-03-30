# authz

![Version: 0.1.8](https://img.shields.io/badge/Version-0.1.8-informational?style=flat-square) ![AppVersion: 0.4.3](https://img.shields.io/badge/AppVersion-0.4.3-informational?style=flat-square)

Helm chart for deploying Ory Keto

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| caraml-dev | <caraml-dev@caraml.dev> |  |

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://caraml-dev.github.io/helm-charts | common | 0.2.8 |
| https://charts.bitnami.com/bitnami | caraml-authz-postgresql(postgresql) | 11.8.2 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| bootstrap.policies | string | `nil` |  |
| bootstrap.resources.limits.cpu | string | `"100m"` |  |
| bootstrap.resources.limits.memory | string | `"200Mi"` |  |
| bootstrap.resources.requests.cpu | string | `"10m"` |  |
| bootstrap.resources.requests.memory | string | `"50Mi"` |  |
| bootstrap.roles | string | `nil` |  |
| caraml-authz-postgresql.auth | object | `{"database":"oryketo","username":"oryketo"}` | Postgres chart 11.8 needs username and database to be specified in under `auth` to create them when initialized. |
| caraml-authz-postgresql.enabled | bool | `true` |  |
| caraml-authz-postgresql.nameOverride | string | `"authz-postgresql"` |  |
| caraml-authz-postgresql.persistence.accessMode | string | `"ReadWriteOnce"` |  |
| caraml-authz-postgresql.persistence.enabled | bool | `true` |  |
| caraml-authz-postgresql.persistence.size | string | `"1Gi"` |  |
| caraml-authz-postgresql.postgresqlDatabase | string | `"oryketo"` |  |
| caraml-authz-postgresql.postgresqlUsername | string | `"oryketo"` |  |
| caraml-authz-postgresql.replicaCount | int | `1` |  |
| caraml-authz-postgresql.resources.requests.cpu | string | `"500m"` |  |
| caraml-authz-postgresql.resources.requests.memory | string | `"512Mi"` |  |
| caraml-authz-postgresql.service.port | int | `5432` |  |
| caramlAuthzExternalPostgresql.address | string | `"127.0.0.1"` | Host address for the External postgres |
| caramlAuthzExternalPostgresql.createSecret | bool | `false` |  |
| caramlAuthzExternalPostgresql.database | string | `"oryketo"` | External postgres database schema |
| caramlAuthzExternalPostgresql.enableProxySidecar | bool | `false` | Enable if you want to configure a sidecar for creating a proxy for your db connections. |
| caramlAuthzExternalPostgresql.enabled | bool | `false` | If you would like to use an external postgres database, enable it here using this |
| caramlAuthzExternalPostgresql.password | string | `"password"` |  |
| caramlAuthzExternalPostgresql.proxyType | string | `"cloudSqlProxy"` | Type of sidecar to be created, mentioned type needs to have the spec below. |
| caramlAuthzExternalPostgresql.secretKey | string | `""` | If a secret is created by external systems (eg. Vault)., mention the key under which password is stored in secret (eg. postgresql-password) |
| caramlAuthzExternalPostgresql.secretName | string | `""` | If a secret is created by external systems (eg. Vault)., mention the secret name here |
| caramlAuthzExternalPostgresql.sidecarSpec | object | `{"cloudSqlProxy":{"dbConnectionName":"asia-east-1:caraml-db","dbPort":5432,"image":{"tag":"1.33.2"},"resources":{"limits":{"cpu":"1000m","memory":"1G"},"requests":{"cpu":"200m","memory":"512Mi"}},"spec":[{"command":["/cloud_sql_proxy","-ip_address_types=PRIVATE","-instances={{ .Values.caramlAuthzExternalPostgresql.sidecarSpec.cloudSqlProxy.dbConnectionName }}=tcp:{{ .Values.caramlAuthzExternalPostgresql.sidecarSpec.cloudSqlProxy.dbPort }}"],"image":"gcr.io/cloudsql-docker/gce-proxy:{{ .Values.caramlAuthzExternalPostgresql.sidecarSpec.cloudSqlProxy.image.tag }}","name":"cloud-sql-proxy","resources":{"limits":{"cpu":"1000m","memory":"1G"},"requests":{"cpu":"200m","memory":"512Mi"}},"securityContext":{"runAsNonRoot":true}}]}}` | container spec for the sidecar |
| caramlAuthzExternalPostgresql.sidecarSpec.cloudSqlProxy | object | `{"dbConnectionName":"asia-east-1:caraml-db","dbPort":5432,"image":{"tag":"1.33.2"},"resources":{"limits":{"cpu":"1000m","memory":"1G"},"requests":{"cpu":"200m","memory":"512Mi"}},"spec":[{"command":["/cloud_sql_proxy","-ip_address_types=PRIVATE","-instances={{ .Values.caramlAuthzExternalPostgresql.sidecarSpec.cloudSqlProxy.dbConnectionName }}=tcp:{{ .Values.caramlAuthzExternalPostgresql.sidecarSpec.cloudSqlProxy.dbPort }}"],"image":"gcr.io/cloudsql-docker/gce-proxy:{{ .Values.caramlAuthzExternalPostgresql.sidecarSpec.cloudSqlProxy.image.tag }}","name":"cloud-sql-proxy","resources":{"limits":{"cpu":"1000m","memory":"1G"},"requests":{"cpu":"200m","memory":"512Mi"}},"securityContext":{"runAsNonRoot":true}}]}` | container spec for the Google CloudSQL auth proxy sidecar, ref: https://cloud.google.com/sql/docs/postgres/connect-kubernetes-engine |
| caramlAuthzExternalPostgresql.sidecarSpec.cloudSqlProxy.spec | list | `[{"command":["/cloud_sql_proxy","-ip_address_types=PRIVATE","-instances={{ .Values.caramlAuthzExternalPostgresql.sidecarSpec.cloudSqlProxy.dbConnectionName }}=tcp:{{ .Values.caramlAuthzExternalPostgresql.sidecarSpec.cloudSqlProxy.dbPort }}"],"image":"gcr.io/cloudsql-docker/gce-proxy:{{ .Values.caramlAuthzExternalPostgresql.sidecarSpec.cloudSqlProxy.image.tag }}","name":"cloud-sql-proxy","resources":{"limits":{"cpu":"1000m","memory":"1G"},"requests":{"cpu":"200m","memory":"512Mi"}},"securityContext":{"runAsNonRoot":true}}]` | Container spec for the sidecar |
| caramlAuthzExternalPostgresql.username | string | `"oryketo"` | External postgres database user |
| deployment.image.pullPolicy | string | `"IfNotPresent"` |  |
| deployment.image.repository | string | `"oryd/keto"` |  |
| deployment.image.tag | string | `"v0.5.4"` |  |
| deployment.initResources.requests.cpu | string | `"250m"` |  |
| deployment.initResources.requests.memory | string | `"128Mi"` |  |
| deployment.replicaCount | int | `1` |  |
| deployment.resources.requests.cpu | string | `"250m"` |  |
| deployment.resources.requests.memory | string | `"128Mi"` |  |
| deployment.service.port | int | `80` |  |
| deployment.service.type | string | `"ClusterIP"` |  |
| global | object | `{}` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `"mlp-authz"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
