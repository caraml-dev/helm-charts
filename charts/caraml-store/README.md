# caraml-store

![Version: 0.1.8](https://img.shields.io/badge/Version-0.1.8-informational?style=flat-square) ![AppVersion: 0.1.3](https://img.shields.io/badge/AppVersion-0.1.3-informational?style=flat-square)

CaraML store registry: Feature registry for CaraML store.

**Homepage:** <https://github.com/caraml-dev/caraml-store>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| caraml-dev | <caraml-dev@caraml.dev> |  |

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | postgresql | 11.9.13 |
| https://charts.bitnami.com/bitnami | redis | 17.3.10 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| postgresql.enabled | bool | `true` |  |
| redis.auth.enabled | bool | `false` |  |
| redis.enabled | bool | `true` |  |
| redis.master.persistence.enabled | bool | `false` |  |
| redis.replica.replicaCount | int | `0` |  |
| registry."application-generated.yaml".enabled | bool | `true` | Flag to include Helm generated configuration for database URL. This is useful for deployment that uses default configuration for Postgres. Please set `application-override.yaml` to override this configuration. |
| registry."application-override.yaml" | object | `{"enabled":true}` | Configuration to override the default application.yaml. Will be created as a ConfigMap. `application-override.yaml` has a higher precedence than `application-secret.yaml` |
| registry."application-secret.yaml" | object | `{"enabled":true}` | Configuration to override the default application.yaml. Will be created as a Secret. `application-override.yaml` has a higher precedence than `application-secret.yaml`. It is recommended to either set `application-override.yaml` or `application-secret.yaml` only to simplify config management. |
| registry."application.yaml".enabled | bool | `true` | Flag to include the default configuration. Please set `application-override.yaml` to override this configuration. |
| registry.actuator.port | int | `8080` | Port for Spring actuator endpoint |
| registry.affinity | object | `{}` |  |
| registry.enabled | bool | `true` |  |
| registry.env.postgresql | object | `{"enabled":true,"key":"postgres-password","secret":""}` | Existing secret to use for authenticating to a postgres database. Will be provided as environment variable. |
| registry.envOverrides | object | `{}` |  |
| registry.fullnameOverride | string | `""` |  |
| registry.image.pullPolicy | string | `"IfNotPresent"` |  |
| registry.image.repository | string | `"ghcr.io/caraml-dev/caraml-store-registry"` |  |
| registry.image.tag | string | `""` |  |
| registry.imagePullSecrets | list | `[]` |  |
| registry.javaOpts | string | `nil` |  |
| registry.name | string | `"registry"` |  |
| registry.nameOverride | string | `""` |  |
| registry.nodeSelector | object | `{}` |  |
| registry.podAnnotations | object | `{}` |  |
| registry.podLabels | object | `{}` |  |
| registry.prometheus.monitor.enabled | bool | `false` | Create a ServiceMonitor resource to expose Prometheus metrics |
| registry.readinessProbe.enabled | bool | `true` | Flag to enable the probe |
| registry.readinessProbe.failureThreshold | int | `5` | Min consecutive failures for the probe to be considered failed |
| registry.readinessProbe.initialDelaySeconds | int | `20` | Delay before the probe is initiated |
| registry.readinessProbe.periodSeconds | int | `10` | How often to perform the probe |
| registry.readinessProbe.successThreshold | int | `1` | Min consecutive success for the probe to be considered successful |
| registry.readinessProbe.timeoutSeconds | int | `10` | When the probe times out |
| registry.replicaCount | int | `1` |  |
| registry.resources | object | `{}` |  |
| registry.secrets | list | `[]` |  |
| registry.service.grpc.nodePort | string | `nil` |  |
| registry.service.grpc.port | int | `6565` | Service port for GRPC requests |
| registry.service.grpc.targetPort | int | `6565` | Container port serving GRPC requests |
| registry.service.type | string | `"ClusterIP"` | Kubernetes service type |
| registry.tolerations | list | `[]` |  |
| serving."application-generated.yaml".enabled | bool | `true` | Flag to include Helm generated configuration for database URL. This is useful for deployment that uses default configuration for Postgres. Please set `application-override.yaml` to override this configuration. |
| serving."application-override.yaml" | object | `{"enabled":true}` | Configuration to override the default application.yaml. Will be created as a ConfigMap. `application-override.yaml` has a higher precedence than `application-secret.yaml` |
| serving."application-secret.yaml" | object | `{"enabled":true}` | Configuration to override the default application.yaml. Will be created as a Secret. `application-override.yaml` has a higher precedence than `application-secret.yaml`. It is recommended to either set `application-override.yaml` or `application-secret.yaml` only to simplify config management. |
| serving."application.yaml".enabled | bool | `true` | Flag to include the default configuration. Please set `application-override.yaml` to override this configuration. |
| serving.actuator.port | int | `8080` | Port for Spring actuator endpoint |
| serving.affinity | object | `{}` |  |
| serving.enabled | bool | `true` |  |
| serving.envOverrides | object | `{}` |  |
| serving.fullnameOverride | string | `""` |  |
| serving.image.pullPolicy | string | `"IfNotPresent"` |  |
| serving.image.repository | string | `"ghcr.io/caraml-dev/caraml-store-serving"` |  |
| serving.image.tag | string | `""` |  |
| serving.imagePullSecrets | list | `[]` |  |
| serving.javaOpts | string | `nil` |  |
| serving.name | string | `"serving"` |  |
| serving.nameOverride | string | `""` |  |
| serving.nodeSelector | object | `{}` |  |
| serving.podAnnotations | object | `{}` |  |
| serving.podLabels | object | `{}` |  |
| serving.prometheus.monitor.enabled | bool | `false` | Create a ServiceMonitor resource to expose Prometheus metrics |
| serving.readinessProbe.enabled | bool | `true` | Flag to enable the probe |
| serving.readinessProbe.failureThreshold | int | `5` | Min consecutive failures for the probe to be considered failed |
| serving.readinessProbe.initialDelaySeconds | int | `20` | Delay before the probe is initiated |
| serving.readinessProbe.periodSeconds | int | `10` | How often to perform the probe |
| serving.readinessProbe.successThreshold | int | `1` | Min consecutive success for the probe to be considered successful |
| serving.readinessProbe.timeoutSeconds | int | `10` | When the probe times out |
| serving.replicaCount | int | `1` |  |
| serving.resources | object | `{}` |  |
| serving.secrets | list | `[]` |  |
| serving.service.grpc.nodePort | string | `nil` | Port number that each cluster node will listen to |
| serving.service.grpc.port | int | `6566` | Service port for GRPC requests |
| serving.service.grpc.targetPort | int | `6566` | Container port serving GRPC requests |
| serving.service.type | string | `"ClusterIP"` | Kubernetes service type |
| serving.tolerations | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
