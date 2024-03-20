# turing

---
![Version: 0.3.19](https://img.shields.io/badge/Version-0.3.19-informational?style=flat-square)
![AppVersion: v1.17.2](https://img.shields.io/badge/AppVersion-v1.17.2-informational?style=flat-square)

Kubernetes-friendly multi-model orchestration and experimentation system.

## Introduction

This Helm chart installs Turing. I can also install the dependencies it requires, such as Merlin and MLP.
See `Chart.yaml` for full list of dependencies.

## Prerequisites

To use the charts here, [Helm](https://helm.sh/) must be configured for your
Kubernetes cluster. Setting up Kubernetes and Helm is outside the scope of
this README. Please refer to the Kubernetes and Helm documentation.

- **Helm 3.0+** – This chart was tested with Helm v3.9.0, but it is also expected to work with earlier Helm versions
- **Kubernetes 1.22+** – This chart was tested with Kind v1.22.7 and minikube kubernetes version 1.22.*
- When installing on minikube, please run in a separate shell:
  ```sh
  minikube tunnel
  ```
  This is to enable istio loadbalancer services to be allocated an IP address.

## Installation

### Add Helm repository

```shell
helm repo add caraml https://caraml-dev.github.io/helm-charts
```

### Installing the chart

This command will install Turing release named `turing` in the `default` namespace.
Default chart values will be used for the installation:
```shell
$ helm install caraml/turing
```

You can (and most likely, should) override the default configuration with values suitable for your installation.
Refer to [Configuration](#configuration) section for the detailed description of available configuration keys.

### Uninstalling the chart

To uninstall `turing` release:
```shell
$ helm uninstall turing
```

The command removes all the Kubernetes components associated with the chart and deletes the release.
This includes the dependencies that were installed by the chart. Note that, any PVCs created by the chart will have to be deleted manually.

### Rendered field
* The purpose of `.Values.rendered.*` is to configure parts of the helm chart that use the field * from 1 place
* For example, `.Values.rendered.releasedVersion` is used in rendering `turing.config` partial template and `turing.image` partial template
* `.Values.rendered.releasedVersion` should be a git release or tag. If the git release is `v1.0.4` then the `.Values.rendered.releasedVersion` should be `v1.0.4` (keep the v prefix)
* If `.Values.deployment.image.tag` is specified, it will overwrite the value in `.Values.releasedVersion`
* The values in `.Values.rendered` will overwrite values in `.Values.config`

## Configuration

The following table lists the configurable parameters of the Turing chart and their default values.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| clusterConfig.environmentConfigPath | string | `"environments.yaml"` | environmentConfigPath is a path to a file that contains environmentConfigs. See api/environments-dev.yaml for example contents |
| clusterConfig.useInClusterConfig | bool | `false` | Configuration to tell Turing API how it should authenticate with deployment k8s cluster By default, Turing API expects to use a remote k8s cluster for deployment and to do so, it requires cluster access configurations to be configured as part of values.yaml |
| config | object | computed value | Turing API server configuration. Please refer to https://github.com/caraml-dev/turing/blob/main/api/turing/config/example.yaml for the detailed explanation on Turing API config options |
| deployment.annotations | object | `{}` |  |
| deployment.extraArgs | list | `[]` | List of string containing additional Turing API server arguments. For example, multiple "-config" can be specified to use multiple config files |
| deployment.extraContainers | list | `[]` | List of sidecar containers to attach to the Pod. For example, you can attach sidecar container that forward logs or dynamically update some configuration files. |
| deployment.extraEnvs | list | `[]` | List of extra environment variables to add to Turing API server container |
| deployment.extraInitContainers | list | `[]` | List of extra initContainers to add to the Pod. For example, you need to run some init scripts to fetch credentials from a remote server |
| deployment.extraVolumeMounts | list | `[]` | Extra volume mounts to attach to Turing API server container. For example to mount the extra volume containing secrets |
| deployment.extraVolumes | list | `[]` | Extra volumes to attach to the Pod. For example, you can mount additional secrets to these volumes |
| deployment.image.registry | string | `"ghcr.io"` | Docker registry for Turing image |
| deployment.image.repository | string | `"caraml-dev/turing"` | Docker image repository for Turing image |
| deployment.image.tag | string | `""` | Docker image tag for Turing image |
| deployment.labels | object | `{}` |  |
| deployment.livenessProbe.path | string | `"/v1/internal/live"` | HTTP path for liveness check |
| deployment.readinessProbe.path | string | `"/v1/internal/ready"` | HTTP path for readiness check |
| deployment.resources | object | `{}` | Resources requests and limits for Turing API. This should be set according to your cluster capacity and service level objectives. Reference: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ |
| environmentConfigs | list | `[{"k8s_config":{"cluster":{},"name":"dev-cluster","user":{}},"name":"dev"}]` | Set this field to configure environment configs. See api/environments-dev.yaml for sample structure |
| experimentEngines | list | `[]` | Turing Experiment Engines configuration |
| global.protocol | string | `"http"` |  |
| imageBuilder.clusterName | string | `"test"` |  |
| imageBuilder.k8sConfig | object | `{}` |  |
| imageBuilder.serviceAccount.annotations | object | `{}` |  |
| imageBuilder.serviceAccount.create | bool | `true` |  |
| imageBuilder.serviceAccount.labels | object | `{}` |  |
| imageBuilder.serviceAccount.name | string | `"kaniko"` |  |
| ingress.annotations | object | `{}` |  |
| ingress.class | string | `""` | Ingress class annotation to add to this Ingress rule, useful when there are multiple ingress controllers installed |
| ingress.enabled | bool | `false` | Enable ingress to provision Ingress resource for external access to Turing API |
| ingress.host | string | `""` | Set host value to enable name based virtual hosting. This allows routing HTTP traffic to multiple host names at the same IP address. If no host is specified, the ingress rule applies to all inbound HTTP traffic through the IP address specified. https://kubernetes.io/docs/concepts/services-networking/ingress/#name-based-virtual-hosting |
| ingress.useV1Beta1 | bool | `false` | Whether to use networking.k8s.io/v1 (k8s version >= 1.19) or networking.k8s.io/v1beta1 (1.16 >= k8s version >= 1.22) |
| merlin.enabled | bool | `true` |  |
| merlin.mlp.enabled | bool | `false` |  |
| mlp.enabled | bool | `true` |  |
| mlp.environmentConfigSecret.name | string | `""` |  |
| openApiSpecOverrides | object | `{}` | Override OpenAPI spec as long as it follows the OAS3 specifications. A common use for this is to set the enums of the ExperimentEngineType. See api/api/override-sample.yaml for an example. |
| rendered.ensemblerTag | string | `"v0.0.0-build.327-ca712a6"` | ensemblerTag refers to the docker image tag |
| rendered.overrides | object | `{}` |  |
| rendered.releasedVersion | string | `"v1.16.0"` | releasedVersion refers to the git release or tag |
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
