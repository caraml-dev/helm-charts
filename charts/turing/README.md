# turing

![Version: 0.2.18](https://img.shields.io/badge/Version-0.2.18-informational?style=flat-square) ![AppVersion: 1.9.2](https://img.shields.io/badge/AppVersion-1.9.2-informational?style=flat-square)

Kubernetes-friendly multi-model orchestration and experimentation system.

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| caraml-dev | <caraml-dev@caraml.dev> |  |

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://caraml-dev.github.io/helm-charts | common | 0.2.8 |
| https://caraml-dev.github.io/helm-charts | merlin | 0.10.8 |
| https://caraml-dev.github.io/helm-charts | mlp | 0.4.16 |
| https://charts.helm.sh/stable | turing-postgresql(postgresql) | 7.0.2 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| clusterConfig.environmentConfigPath | string | `"environments.yaml"` | environmentConfigPath is a path to a file that contains environmentConfigs. See api/environments-dev.yaml for example contents |
| clusterConfig.useInClusterConfig | bool | `false` | Configuration to tell Turing API how it should authenticate with deployment k8s cluster By default, Turing API expects to use a remote k8s cluster for deployment and to do so, it requires cluster access configurations to be configured as part of values.yaml |
| config | object | computed value | Turing API server configuration. Please refer to https://github.com/caraml-dev/turing/blob/main/api/turing/config/example.yaml for the detailed explanation on Turing API config options |
| deployment.extraArgs | list | `[]` | List of string containing additional Turing API server arguments. For example, multiple "-config" can be specified to use multiple config files |
| deployment.extraContainers | list | `[]` | List of sidecar containers to attach to the Pod. For example, you can attach sidecar container that forward logs or dynamically update some configuration files. |
| deployment.extraEnvs | list | `[]` | List of extra environment variables to add to Turing API server container |
| deployment.extraInitContainers | list | `[]` | List of extra initContainers to add to the Pod. For example, you need to run some init scripts to fetch credentials from a remote server |
| deployment.extraVolumeMounts | list | `[]` | Extra volume mounts to attach to Turing API server container. For example to mount the extra volume containing secrets |
| deployment.extraVolumes | list | `[]` | Extra volumes to attach to the Pod. For example, you can mount additional secrets to these volumes |
| deployment.image.registry | string | `"ghcr.io"` | Docker registry for Turing API image. User is required to override the registry for now as there is no publicly available Turing image |
| deployment.image.repository | string | `"caraml-dev/turing"` | Docker image repository for Turing API |
| deployment.image.tag | string | `"v1.9.2-build.7-b9139be"` | Docker image tag for Turing API |
| deployment.labels | object | `{}` |  |
| deployment.livenessProbe.path | string | `"/v1/internal/live"` | HTTP path for liveness check |
| deployment.readinessProbe.path | string | `"/v1/internal/ready"` | HTTP path for readiness check |
| deployment.resources | object | `{}` | Resources requests and limits for Turing API. This should be set according to your cluster capacity and service level objectives. Reference: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ |
| environmentConfigs | list | `[{"k8s_config":{"cluster":{},"name":"dev-cluster","user":{}},"name":"dev"}]` | Set this field to configure environment configs. See api/environments-dev.yaml for sample structure |
| experimentEngines | list | `[]` | Turing Experiment Engines configuration |
| global.protocol | string | `"http"` |  |
| imageBuilder.clusterName | string | `"test"` |  |
| imageBuilder.k8sConfig | string | `""` |  |
| ingress.class | string | `""` | Ingress class annotation to add to this Ingress rule, useful when there are multiple ingress controllers installed |
| ingress.enabled | bool | `false` | Enable ingress to provision Ingress resource for external access to Turing API |
| ingress.host | string | `""` | Set host value to enable name based virtual hosting. This allows routing HTTP traffic to multiple host names at the same IP address. If no host is specified, the ingress rule applies to all inbound HTTP traffic through the IP address specified. https://kubernetes.io/docs/concepts/services-networking/ingress/#name-based-virtual-hosting |
| ingress.useV1Beta1 | bool | `false` | Whether to use networking.k8s.io/v1 (k8s version >= 1.19) or networking.k8s.io/v1beta1 (1.16 >= k8s version >= 1.22) |
| merlin.enabled | bool | `true` |  |
| merlin.mlp.enabled | bool | `false` |  |
| mlp.enabled | bool | `true` |  |
| mlp.environmentConfigSecret.name | string | `""` |  |
| openApiSpecOverrides | object | `{}` | Override OpenAPI spec as long as it follows the OAS3 specifications. A common use for this is to set the enums of the ExperimentEngineType. See api/api/override-sample.yaml for an example. |
| sentry.dsn | string | `""` | Sentry DSN value used by both Turing API and Turing UI |
| service.externalPort | int | `8080` | Turing API Kubernetes service port number |
| service.internalPort | int | `8080` | Turing API container port number |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `"turing"` |  |
| turing-postgresql.enabled | bool | `true` |  |
| turing-postgresql.persistence.size | string | `"10Gi"` |  |
| turing-postgresql.postgresqlDatabase | string | `"turing"` |  |
| turing-postgresql.postgresqlUsername | string | `"turing"` |  |
| turing-postgresql.resources.requests.cpu | string | `"100m"` |  |
| turing-postgresql.resources.requests.memory | string | `"512Mi"` |  |
| turingExternalPostgresql.address | string | `"127.0.0.1"` | Host address for the External postgres |
| turingExternalPostgresql.createSecret | bool | `false` | Enable this if you need the chart to create a secret when you provide the password above. To be used together with password. |
| turingExternalPostgresql.database | string | `"turing"` | External postgres database schema |
| turingExternalPostgresql.enabled | bool | `false` | If you would like to use an external postgres database, enable it here using this |
| turingExternalPostgresql.password | string | `"password"` |  |
| turingExternalPostgresql.secretKey | string | `""` | If a secret is created by external systems (eg. Vault)., mention the key under which password is stored in secret (eg. postgresql-password) |
| turingExternalPostgresql.secretName | string | `""` | If a secret is created by external systems (eg. Vault)., mention the secret name here |
| turingExternalPostgresql.username | string | `"turing"` | External postgres database user |
| uiConfig | object | computed value | Turing UI configuration. Please Refer to https://github.com/caraml-dev/turing/blob/main/ui/public/app.config.js for the detailed explanation on Turing UI config options |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
