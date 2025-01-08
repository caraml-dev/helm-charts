# merlin

---
![Version: 0.13.24](https://img.shields.io/badge/Version-0.13.24-informational?style=flat-square)
![AppVersion: v0.42.0](https://img.shields.io/badge/AppVersion-v0.42.0-informational?style=flat-square)

Kubernetes-friendly ML model management, deployment, and serving.

## Introduction

This Helm chart installs Merlin. I can also install the dependencies it requires, such as Kserve, MLP, etc.
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

This command will install Merlin release named `merlin` in the `default` namespace.
Default chart values will be used for the installation:
```shell
$ helm install caraml/merlin
```

You can (and most likely, should) override the default configuration with values suitable for your installation.
Refer to [Configuration](#configuration) section for the detailed description of available configuration keys.

### Uninstalling the chart

To uninstall `merlin` release:
```shell
$ helm uninstall merlin
```

The command removes all the Kubernetes components associated with the chart and deletes the release.
This includes the dependencies that were installed by the chart. Note that, any PVCs created by the chart will have to be deleted manually.

### Rendered field
* The purpose of `.Values.rendered.*` is to configure parts of the helm chart that use the field * from 1 place
* For example, `.Values.rendered.releasedVersion` is used in rendering `merlin.config` partial template and `merlin.deploymentTag` partial template
* `.Values.rendered.releasedVersion` should be a git release or tag. If the git release is `v1.0.4` then the `.Values.rendered.releasedVersion` should be `v1.0.4` (keep the v prefix)
* If `.Values.deployment.image.tag` is specified, it will overwrite the value in `.Values.releasedVersion`
* The values in `.Values.rendered` will overwrite values in `.Values.config`

## Configuration
The following table lists the configurable parameters of the Merlin chart and their default values.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| clusterConfig.environmentConfigPath | string | `"environments.yaml"` | environmentConfigPath is a path to a file that contains environmentConfigs. See api/environments-dev.yaml for example contents |
| clusterConfig.useInClusterConfig | bool | `false` | Configuration to tell Merlin API how it should authenticate with deployment k8s cluster By default, Merlin API expects to use a remote k8s cluster for deployment and to do so, it requires cluster access configurations to be configured as part of values.yaml |
| config.AuthorizationConfig.AuthorizationEnabled | bool | `true` |  |
| config.AuthorizationConfig.Caching.CacheCleanUpIntervalSeconds | int | `900` | Cache clean up interval, after which expired keys are removed |
| config.AuthorizationConfig.Caching.Enabled | bool | `false` | Whether local in-memory caching of authorization responses should be enabled |
| config.AuthorizationConfig.Caching.KeyExpirySeconds | int | `600` | Cache key expiry duration |
| config.AuthorizationConfig.KetoRemoteRead | string | `"http://mlp-keto-read:80"` |  |
| config.AuthorizationConfig.KetoRemoteWrite | string | `"http://mlp-keto-write:80"` |  |
| config.BatchConfig.Tolerations[0].Effect | string | `"NoSchedule"` |  |
| config.BatchConfig.Tolerations[0].Key | string | `"batch-job"` |  |
| config.BatchConfig.Tolerations[0].Operator | string | `"Equal"` |  |
| config.BatchConfig.Tolerations[0].Value | string | `"true"` |  |
| config.DbConfig.Database | string | `"merlin"` |  |
| config.DbConfig.Host | string | `"localhost"` |  |
| config.DbConfig.Password | string | `"merlin"` |  |
| config.DbConfig.Port | int | `5432` |  |
| config.DbConfig.User | string | `"merlin"` |  |
| config.DeploymentLabelPrefix | string | `"gojek.com/"` |  |
| config.Environment | string | `"dev"` |  |
| config.FeatureToggleConfig.AlertConfig.AlertEnabled | bool | `false` | To enable/disable creation/modification of the alerts and dashboards for the deployed models via merlin. |
| config.FeatureToggleConfig.AlertConfig.GitlabConfig.AlertBranch | string | `"master"` |  |
| config.FeatureToggleConfig.AlertConfig.GitlabConfig.AlertRepository | string | `"lens/artillery/datascience"` |  |
| config.FeatureToggleConfig.AlertConfig.GitlabConfig.BaseURL | string | `"https://gitlab.com/"` |  |
| config.FeatureToggleConfig.AlertConfig.GitlabConfig.DashboardBranch | string | `"master"` |  |
| config.FeatureToggleConfig.AlertConfig.GitlabConfig.DashboardRepository | string | `"data-science/slo-specs"` |  |
| config.FeatureToggleConfig.AlertConfig.WardenConfig.APIHost | string | `""` |  |
| config.FeatureToggleConfig.MonitoringConfig.MonitoringBaseURL | string | `""` |  |
| config.FeatureToggleConfig.MonitoringConfig.MonitoringEnabled | bool | `false` |  |
| config.FeatureToggleConfig.MonitoringConfig.MonitoringJobBaseURL | string | `""` |  |
| config.LoggerDestinationURL | string | `"http://yourDestinationLogger"` |  |
| config.MlpAPIConfig.APIHost | string | `"http://mlp:8080"` |  |
| config.NewRelic.AppName | string | `"merlin-api-dev"` |  |
| config.NewRelic.Enabled | bool | `false` |  |
| config.NewRelic.IgnoreStatusCodes[0] | int | `400` |  |
| config.NewRelic.IgnoreStatusCodes[1] | int | `401` |  |
| config.NewRelic.IgnoreStatusCodes[2] | int | `403` |  |
| config.NewRelic.IgnoreStatusCodes[3] | int | `404` |  |
| config.NewRelic.IgnoreStatusCodes[4] | int | `405` |  |
| config.NewRelic.IgnoreStatusCodes[5] | int | `412` |  |
| config.NewRelic.License | string | `"newrelic-license-secret"` |  |
| config.NumOfQueueWorkers | int | `2` |  |
| config.ObservabilityPublisher.DefaultResources.Limits.CPU | string | `"2"` |  |
| config.ObservabilityPublisher.DefaultResources.Limits.Memory | string | `"1Gi"` |  |
| config.ObservabilityPublisher.DefaultResources.Requests.CPU | string | `"1"` |  |
| config.ObservabilityPublisher.DefaultResources.Requests.Memory | string | `"1Gi"` |  |
| config.ObservabilityPublisher.EnvironmentName | string | `"id-dev"` |  |
| config.ObservabilityPublisher.KafkaConsumer.Brokers | string | `"kafka-brokers"` |  |
| config.Port | int | `8080` |  |
| config.PyFuncPublisherConfig.Kafka.Acks | int | `0` |  |
| config.PyFuncPublisherConfig.Kafka.AdditionalConfig | string | `"{}"` |  |
| config.PyFuncPublisherConfig.Kafka.Brokers | string | `"kafka-brokers"` |  |
| config.PyFuncPublisherConfig.Kafka.LingerMS | int | `100` |  |
| config.PyFuncPublisherConfig.Kafka.MaxMessageSizeBytes | string | `"1048588"` |  |
| config.PyFuncPublisherConfig.SamplingRatioRate | float | `0.01` |  |
| config.PyfuncGRPCOptions | string | `"{}"` |  |
| config.ReactAppConfig.CPUCost | string | `nil` |  |
| config.ReactAppConfig.DocURL[0].Href | string | `"https://github.com/gojek/merlin/blob/main/docs/getting-started/README.md"` |  |
| config.ReactAppConfig.DocURL[0].Label | string | `"Getting Started with Merlin"` |  |
| config.ReactAppConfig.DockerRegistries | string | `"ghcr.io/gojek,ghcr.io/your-company"` | Comma-separated value of Docker registries that can be chosen in deployment page |
| config.ReactAppConfig.Environment | string | `"dev"` |  |
| config.ReactAppConfig.FeastCoreURL | string | `"http://feast-core.mlp:8080/v1"` |  |
| config.ReactAppConfig.HomePage | string | `"/merlin"` |  |
| config.ReactAppConfig.MaxAllowedReplica | int | `20` |  |
| config.ReactAppConfig.MemoryCost | string | `nil` |  |
| config.ReactAppConfig.MerlinURL | string | `"/api/merlin/v1"` |  |
| config.ReactAppConfig.MlpURL | string | `"/api"` |  |
| config.ReactAppConfig.OauthClientID | string | `nil` |  |
| config.ReactAppConfig.UPIDocumentation | string | `"https://github.com/caraml-dev/universal-prediction-interface/blob/main/docs/api_markdown/caraml/upi/v1/index.md"` |  |
| config.Sentry.DSN | string | `""` |  |
| config.Sentry.Enabled | bool | `false` |  |
| config.StandardTransformerConfig.BigtableCredential | string | `nil` |  |
| config.StandardTransformerConfig.DefaultFeastSource | int | `2` |  |
| config.StandardTransformerConfig.DefaultServingURL | string | `"online-serving-redis.feast.dev"` |  |
| config.StandardTransformerConfig.EnableAuth | bool | `false` |  |
| config.StandardTransformerConfig.FeastBigtableConfig.Instance | string | `"instance"` |  |
| config.StandardTransformerConfig.FeastBigtableConfig.PoolSize | int | `5` |  |
| config.StandardTransformerConfig.FeastBigtableConfig.Project | string | `"gcp-project"` |  |
| config.StandardTransformerConfig.FeastBigtableConfig.ServingURL | string | `"online-serving-bigtable.feast.dev"` |  |
| config.StandardTransformerConfig.FeastCoreAuthAudience | string | `"core.feast.dev"` |  |
| config.StandardTransformerConfig.FeastCoreURL | string | `"core.feast.dev"` |  |
| config.StandardTransformerConfig.FeastServingKeepAlive.Enabled | bool | `false` |  |
| config.StandardTransformerConfig.FeastServingKeepAlive.Time | string | `"60s"` |  |
| config.StandardTransformerConfig.FeastServingKeepAlive.Timeout | string | `"5s"` |  |
| config.StandardTransformerConfig.FeastServingURLs[0].Host | string | `"online-serving-redis.feast.dev"` |  |
| config.StandardTransformerConfig.FeastServingURLs[0].Icon | string | `"redis"` |  |
| config.StandardTransformerConfig.FeastServingURLs[0].Label | string | `"Online Serving with Redis"` |  |
| config.StandardTransformerConfig.FeastServingURLs[0].SourceType | string | `"REDIS"` |  |
| config.StandardTransformerConfig.FeastServingURLs[1].Host | string | `"online-serving-bigtable.feast.dev"` |  |
| config.StandardTransformerConfig.FeastServingURLs[1].Icon | string | `"bigtable"` |  |
| config.StandardTransformerConfig.FeastServingURLs[1].Label | string | `"Online Serving with BigTable"` |  |
| config.StandardTransformerConfig.FeastServingURLs[1].SourceType | string | `"BIGTABLE"` |  |
| config.StandardTransformerConfig.ImageName | string | `"ghcr.io/caraml-dev/merlin-transformer:1.0.0"` |  |
| config.StandardTransformerConfig.Jaeger.CollectorURL | string | `"http://jaeger-tracing-collector.infrastructure:14268/api/traces"` |  |
| config.StandardTransformerConfig.Jaeger.Disabled | bool | `false` |  |
| config.StandardTransformerConfig.Jaeger.SamplerParam | int | `1` |  |
| config.StandardTransformerConfig.Kafka.Acks | int | `0` |  |
| config.StandardTransformerConfig.Kafka.AdditionalConfig | string | `"{}"` |  |
| config.StandardTransformerConfig.Kafka.Brokers | string | `"kafka-brokers"` |  |
| config.StandardTransformerConfig.Kafka.LingerMS | int | `100` |  |
| config.StandardTransformerConfig.Kafka.MaxMessageSizeBytes | string | `"1048588"` |  |
| config.StandardTransformerConfig.ModelClientKeepAlive.Enabled | bool | `false` |  |
| config.StandardTransformerConfig.ModelClientKeepAlive.Time | string | `"60s"` |  |
| config.StandardTransformerConfig.ModelClientKeepAlive.Timeout | string | `"5s"` |  |
| config.StandardTransformerConfig.ModelServerConnCount | int | `10` |  |
| config.StandardTransformerConfig.SimulationFeast.FeastBigtableURL | string | `"online-serving-bt.feast.dev"` |  |
| config.StandardTransformerConfig.SimulationFeast.FeastRedisURL | string | `"online-serving-redis.feast.dev"` |  |
| deployment.annotations | object | `{}` |  |
| deployment.extraArgs | list | `[]` | List of string containing additional Merlin API server arguments. For example, multiple "-config" can be specified to use multiple config files |
| deployment.extraContainers | list | `[]` | List of sidecar containers to attach to the Pod. For example, you can attach sidecar container that forward logs or dynamically update some configuration files. |
| deployment.extraEnvs | list | `[]` | List of extra environment variables to add to Merlin API server container |
| deployment.extraInitContainers | list | `[]` | List of extra initContainers to add to the Pod. For example, you need to run some init scripts to fetch credentials from a remote server |
| deployment.extraVolumeMounts | list | `[]` | Extra volume mounts to attach to Merlin API server container. For example to mount the extra volume containing secrets |
| deployment.extraVolumes | list | `[]` | Extra volumes to attach to the Pod. For example, you can mount additional secrets to these volumes |
| deployment.image.pullPolicy | string | `"IfNotPresent"` |  |
| deployment.image.registry | string | `"ghcr.io"` |  |
| deployment.image.repository | string | `"caraml-dev/merlin"` |  |
| deployment.image.tag | string | `""` |  |
| deployment.labels | object | `{}` |  |
| deployment.podLabels | object | `{}` |  |
| deployment.replicaCount | string | `"2"` |  |
| deployment.resources.limits.cpu | string | `"1"` |  |
| deployment.resources.limits.memory | string | `"1Gi"` |  |
| deployment.resources.requests.cpu | string | `"500m"` |  |
| deployment.resources.requests.memory | string | `"1Gi"` |  |
| deployment.tolerations | list | `[]` |  |
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
| environmentConfigs[0].k8s_config | object | `{}` |  |
| environmentConfigs[0].max_cpu | string | `"8"` |  |
| environmentConfigs[0].max_memory | string | `"8Gi"` |  |
| environmentConfigs[0].name | string | `"id-dev"` |  |
| environmentConfigs[0].namespace_timeout | string | `"2m"` |  |
| environmentConfigs[0].queue_resource_percentage | string | `"20"` |  |
| environmentConfigs[0].region | string | `"id"` |  |
| global.protocol | string | `"http"` |  |
| imageBuilder.builderConfig.ArtifactServiceType | string | `"nop"` |  |
| imageBuilder.builderConfig.BaseImage.BuildContextSubPath | string | `"python"` |  |
| imageBuilder.builderConfig.BaseImage.BuildContextURI | string | `"git://github.com/caraml-dev/merlin.git#refs/tags/v0.45.3"` |  |
| imageBuilder.builderConfig.BaseImage.DockerfilePath | string | `"pyfunc-server/docker/Dockerfile"` |  |
| imageBuilder.builderConfig.BaseImage.ImageName | string | `"ghcr.io/caraml-dev/merlin/merlin-pyfunc-base:0.45.3"` |  |
| imageBuilder.builderConfig.BuildNamespace | string | `"mlp"` |  |
| imageBuilder.builderConfig.BuildTimeout | string | `"30m"` |  |
| imageBuilder.builderConfig.DefaultResources.Limits.CPU | string | `"1"` |  |
| imageBuilder.builderConfig.DefaultResources.Limits.Memory | string | `"1Gi"` |  |
| imageBuilder.builderConfig.DefaultResources.Requests.CPU | string | `"1"` |  |
| imageBuilder.builderConfig.DefaultResources.Requests.Memory | string | `"512Mi"` |  |
| imageBuilder.builderConfig.DockerRegistry | string | `"dockerRegistry"` |  |
| imageBuilder.builderConfig.KanikoAdditionalArgs[0] | string | `"--cache=true"` |  |
| imageBuilder.builderConfig.KanikoAdditionalArgs[1] | string | `"--compressed-caching=false"` |  |
| imageBuilder.builderConfig.KanikoAdditionalArgs[2] | string | `"--snapshot-mode=redo"` |  |
| imageBuilder.builderConfig.KanikoAdditionalArgs[3] | string | `"--use-new-run"` |  |
| imageBuilder.builderConfig.KanikoAdditionalArgs[4] | string | `"--log-timestamp"` |  |
| imageBuilder.builderConfig.KanikoImage | string | `"gcr.io/kaniko-project/executor:v1.18.0"` |  |
| imageBuilder.builderConfig.KanikoPushRegistryType | string | `"gcr"` |  |
| imageBuilder.builderConfig.MaximumRetry | int | `3` |  |
| imageBuilder.builderConfig.NodeSelectors | object | `{}` |  |
| imageBuilder.builderConfig.PredictionJobBaseImage.BuildContextSubPath | string | `"python"` |  |
| imageBuilder.builderConfig.PredictionJobBaseImage.BuildContextURI | string | `"git://github.com/caraml-dev/merlin.git#refs/tags/v0.45.3"` |  |
| imageBuilder.builderConfig.PredictionJobBaseImage.DockerfilePath | string | `"batch-predictor/docker/app.Dockerfile"` |  |
| imageBuilder.builderConfig.PredictionJobBaseImage.ImageName | string | `"ghcr.io/caraml-dev/merlin/merlin-pyspark-base:0.45.3"` |  |
| imageBuilder.builderConfig.PredictionJobBaseImage.MainAppPath | string | `"/home/spark/merlin-spark-app/main.py"` |  |
| imageBuilder.builderConfig.Retention | string | `"48h"` |  |
| imageBuilder.builderConfig.SafeToEvict | bool | `false` |  |
| imageBuilder.builderConfig.Tolerations | list | `[]` |  |
| imageBuilder.clusterName | string | `"test"` |  |
| imageBuilder.contextRef | string | `""` |  |
| imageBuilder.k8sConfig | object | `{}` |  |
| imageBuilder.serviceAccount.annotations | object | `{}` |  |
| imageBuilder.serviceAccount.create | bool | `true` |  |
| imageBuilder.serviceAccount.labels | object | `{}` |  |
| imageBuilder.serviceAccount.name | string | `"kaniko"` |  |
| ingress.enabled | bool | `false` |  |
| kserve.chartValues.knativeServingIstio.chartValues.istioIngressGateway.helmChart.namespace | string | `"istio-system"` |  |
| kserve.enabled | bool | `true` |  |
| kserve.helmChart.chart | string | `"kserve"` |  |
| kserve.helmChart.createNamespace | bool | `true` |  |
| kserve.helmChart.namespace | string | `"kserve"` |  |
| kserve.helmChart.release | string | `"kserve"` |  |
| kserve.helmChart.repository | string | `"https://caraml-dev.github.io/helm-charts"` |  |
| kserve.helmChart.version | string | `"0.8.22"` |  |
| kserve.hook.weight | string | `"-2"` |  |
| merlin-postgresql.enabled | bool | `true` |  |
| merlin-postgresql.persistence.size | string | `"10Gi"` |  |
| merlin-postgresql.postgresqlDatabase | string | `"merlin"` |  |
| merlin-postgresql.postgresqlUsername | string | `"merlin"` |  |
| merlin-postgresql.resources.requests.cpu | string | `"100m"` |  |
| merlin-postgresql.resources.requests.memory | string | `"512Mi"` |  |
| merlinExternalPostgresql.address | string | `"127.0.0.1"` | Host address for the External postgres |
| merlinExternalPostgresql.connMaxIdleTime | string | `"0s"` | Connection pooling settings |
| merlinExternalPostgresql.connMaxLifetime | string | `"0s"` |  |
| merlinExternalPostgresql.createSecret | bool | `false` | Enable this if you need the chart to create a secret when you provide the password above. |
| merlinExternalPostgresql.database | string | `"merlin"` | External postgres database schema |
| merlinExternalPostgresql.enableProxySidecar | bool | `false` | Enable if you want to configure a sidecar for creating a proxy for your db connections. |
| merlinExternalPostgresql.enabled | bool | `false` | If you would like to use an external postgres database, enable it here using this |
| merlinExternalPostgresql.maxIdleConns | int | `0` |  |
| merlinExternalPostgresql.maxOpenConns | int | `0` |  |
| merlinExternalPostgresql.password | string | `"password"` |  |
| merlinExternalPostgresql.proxyType | string | `"cloudSqlProxy"` | Type of sidecar to be created, mentioned type needs to have the spec below. |
| merlinExternalPostgresql.secretKey | string | `""` | If a secret is created by external systems (eg. Vault)., mention the key under which password is stored in secret (eg. postgresql-password) |
| merlinExternalPostgresql.secretName | string | `""` | If a secret is created by external systems (eg. Vault)., mention the secret name here |
| merlinExternalPostgresql.sidecarSpec | object | `{"cloudSqlProxy":{"dbConnectionName":"asia-east-1:merlin-db","dbPort":5432,"image":{"tag":"1.33.2"},"resources":{"limits":{"cpu":"1000m","memory":"1G"},"requests":{"cpu":"200m","memory":"512Mi"}},"spec":[{"command":["/cloud_sql_proxy","-ip_address_types=PRIVATE","-log_debug_stdout","-instances={{ .Values.merlinExternalPostgresql.sidecarSpec.cloudSqlProxy.dbConnectionName }}=tcp:{{ .Values.merlinExternalPostgresql.sidecarSpec.cloudSqlProxy.dbPort }}"],"image":"gcr.io/cloudsql-docker/gce-proxy:{{ .Values.merlinExternalPostgresql.sidecarSpec.cloudSqlProxy.image.tag }}","name":"cloud-sql-proxy","resources":{"limits":{"cpu":"1000m","memory":"1G"},"requests":{"cpu":"200m","memory":"512Mi"}},"securityContext":{"runAsNonRoot":true}}]}}` | container spec for the sidecar |
| merlinExternalPostgresql.sidecarSpec.cloudSqlProxy | object | `{"dbConnectionName":"asia-east-1:merlin-db","dbPort":5432,"image":{"tag":"1.33.2"},"resources":{"limits":{"cpu":"1000m","memory":"1G"},"requests":{"cpu":"200m","memory":"512Mi"}},"spec":[{"command":["/cloud_sql_proxy","-ip_address_types=PRIVATE","-log_debug_stdout","-instances={{ .Values.merlinExternalPostgresql.sidecarSpec.cloudSqlProxy.dbConnectionName }}=tcp:{{ .Values.merlinExternalPostgresql.sidecarSpec.cloudSqlProxy.dbPort }}"],"image":"gcr.io/cloudsql-docker/gce-proxy:{{ .Values.merlinExternalPostgresql.sidecarSpec.cloudSqlProxy.image.tag }}","name":"cloud-sql-proxy","resources":{"limits":{"cpu":"1000m","memory":"1G"},"requests":{"cpu":"200m","memory":"512Mi"}},"securityContext":{"runAsNonRoot":true}}]}` | container spec for the Google CloudSQL auth proxy sidecar, ref: https://cloud.google.com/sql/docs/postgres/connect-kubernetes-engine |
| merlinExternalPostgresql.sidecarSpec.cloudSqlProxy.spec | list | `[{"command":["/cloud_sql_proxy","-ip_address_types=PRIVATE","-log_debug_stdout","-instances={{ .Values.merlinExternalPostgresql.sidecarSpec.cloudSqlProxy.dbConnectionName }}=tcp:{{ .Values.merlinExternalPostgresql.sidecarSpec.cloudSqlProxy.dbPort }}"],"image":"gcr.io/cloudsql-docker/gce-proxy:{{ .Values.merlinExternalPostgresql.sidecarSpec.cloudSqlProxy.image.tag }}","name":"cloud-sql-proxy","resources":{"limits":{"cpu":"1000m","memory":"1G"},"requests":{"cpu":"200m","memory":"512Mi"}},"securityContext":{"runAsNonRoot":true}}]` | Container spec for the sidecar |
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
| minio.helmChart.repository | string | `"https://charts.min.io/"` | "https://helm.min.io/" is no longer valid. TODO: Check if the chart coming from below is correct for this usecase, version also changed to latest in the below charts url. |
| minio.helmChart.version | string | `"5.0.15"` |  |
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
| mlflow.artifactServiceType | string | `"nop"` |  |
| mlflow.deploymentLabels | object | `{}` |  |
| mlflow.extraEnvs | list | `[]` |  |
| mlflow.host | string | `"0.0.0.0"` |  |
| mlflow.image.pullPolicy | string | `"Always"` |  |
| mlflow.image.registry | string | `"ghcr.io"` |  |
| mlflow.image.repository | string | `"caraml-dev/mlflow"` |  |
| mlflow.image.tag | string | `"1.26.1"` |  |
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
| mlflow.serviceAccount.annotations | object | `{}` |  |
| mlflow.serviceAccount.create | bool | `true` |  |
| mlflow.serviceAccount.name | string | `"mlflow"` |  |
| mlflow.statefulset.updateStrategy | string | `"RollingUpdate"` |  |
| mlflow.tolerations | list | `[]` |  |
| mlflow.trackingURL | string | `"http://www.example.com"` |  |
| mlflowExternalPostgresql.address | string | `"127.0.0.1"` | Host address for the External postgres |
| mlflowExternalPostgresql.createSecret | bool | `false` | Enable this if you need the chart to create a secret when you provide the password above. |
| mlflowExternalPostgresql.database | string | `"mlflow"` | External postgres database schema |
| mlflowExternalPostgresql.enableProxySidecar | bool | `false` | Enable if you want to configure a sidecar for creating a proxy for your db connections. |
| mlflowExternalPostgresql.enabled | bool | `false` | If you would like to use an external postgres database, enable it here using this |
| mlflowExternalPostgresql.password | string | `"password"` |  |
| mlflowExternalPostgresql.proxyType | string | `"cloudSqlProxy"` | Type of sidecar to be created, mentioned type needs to have the spec below. |
| mlflowExternalPostgresql.secretKey | string | `""` | If a secret is created by external systems (eg. Vault)., mention the key under which password is stored in secret (eg. postgresql-password) |
| mlflowExternalPostgresql.secretName | string | `""` | If a secret is created by external systems (eg. Vault)., mention the secret name here |
| mlflowExternalPostgresql.sidecarSpec | object | `{"cloudSqlProxy":{"dbConnectionName":"asia-east-1:mlflow-db","dbPort":5432,"image":{"tag":"1.33.2"},"resources":{"limits":{"cpu":"1000m","memory":"1G"},"requests":{"cpu":"200m","memory":"512Mi"}},"spec":[{"command":["/cloud_sql_proxy","-ip_address_types=PRIVATE","-log_debug_stdout","-instances={{ .Values.mlflowExternalPostgresql.sidecarSpec.cloudSqlProxy.dbConnectionName }}=tcp:{{ .Values.mlflowExternalPostgresql.sidecarSpec.cloudSqlProxy.dbPort }}"],"image":"gcr.io/cloudsql-docker/gce-proxy:{{ .Values.mlflowExternalPostgresql.sidecarSpec.cloudSqlProxy.image.tag }}","name":"cloud-sql-proxy","resources":{"limits":{"cpu":"1000m","memory":"1G"},"requests":{"cpu":"200m","memory":"512Mi"}},"securityContext":{"runAsNonRoot":true}}]}}` | container spec for the sidecar |
| mlflowExternalPostgresql.sidecarSpec.cloudSqlProxy | object | `{"dbConnectionName":"asia-east-1:mlflow-db","dbPort":5432,"image":{"tag":"1.33.2"},"resources":{"limits":{"cpu":"1000m","memory":"1G"},"requests":{"cpu":"200m","memory":"512Mi"}},"spec":[{"command":["/cloud_sql_proxy","-ip_address_types=PRIVATE","-log_debug_stdout","-instances={{ .Values.mlflowExternalPostgresql.sidecarSpec.cloudSqlProxy.dbConnectionName }}=tcp:{{ .Values.mlflowExternalPostgresql.sidecarSpec.cloudSqlProxy.dbPort }}"],"image":"gcr.io/cloudsql-docker/gce-proxy:{{ .Values.mlflowExternalPostgresql.sidecarSpec.cloudSqlProxy.image.tag }}","name":"cloud-sql-proxy","resources":{"limits":{"cpu":"1000m","memory":"1G"},"requests":{"cpu":"200m","memory":"512Mi"}},"securityContext":{"runAsNonRoot":true}}]}` | container spec for the Google CloudSQL auth proxy sidecar, ref: https://cloud.google.com/sql/docs/postgres/connect-kubernetes-engine |
| mlflowExternalPostgresql.sidecarSpec.cloudSqlProxy.spec | list | `[{"command":["/cloud_sql_proxy","-ip_address_types=PRIVATE","-log_debug_stdout","-instances={{ .Values.mlflowExternalPostgresql.sidecarSpec.cloudSqlProxy.dbConnectionName }}=tcp:{{ .Values.mlflowExternalPostgresql.sidecarSpec.cloudSqlProxy.dbPort }}"],"image":"gcr.io/cloudsql-docker/gce-proxy:{{ .Values.mlflowExternalPostgresql.sidecarSpec.cloudSqlProxy.image.tag }}","name":"cloud-sql-proxy","resources":{"limits":{"cpu":"1000m","memory":"1G"},"requests":{"cpu":"200m","memory":"512Mi"}},"securityContext":{"runAsNonRoot":true}}]` | Container spec for the sidecar |
| mlflowExternalPostgresql.username | string | `"mlflow"` | External postgres database user |
| mlp.enabled | bool | `true` |  |
| mlp.environmentConfigSecret.name | string | `""` |  |
| mlp.fullnameOverride | string | `"mlp"` |  |
| mlp.keto.enabled | bool | `true` |  |
| mlp.keto.fullnameOverride | string | `"mlp-keto"` |  |
| rendered.overrides | object | `{}` |  |
| rendered.releasedVersion | string | `"v0.45.3"` |  |
| service.externalPort | int | `8080` |  |
| service.internalPort | int | `8080` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `"merlin"` |  |
| serviceAccount.rbac.create | bool | `false` |  |
| swagger.apiHost | string | `"merlin.dev"` |  |
| swagger.basePath | string | `"/api/merlin/v1"` |  |
| swagger.enabled | bool | `true` |  |
| swagger.image.tag | string | `"v3.23.5"` |  |
| swagger.service.externalPort | int | `8080` |  |
| swagger.service.internalPort | int | `8081` |  |
| ui.apiHost | string | `"/api/merlin/v1"` |  |
| ui.dockerRegistries | string | `"ghcr.io/gojek,ghcr.io/your-company"` | Comma-separated value of Docker registries that can be chosen in deployment page |
| ui.docsURL[0].href | string | `"https://github.com/gojek/merlin/blob/main/docs/getting-started/README.md"` |  |
| ui.docsURL[0].label | string | `"Getting Started with Merlin"` |  |
| ui.homepage | string | `"/merlin"` |  |
| ui.maxAllowedReplica | int | `20` |  |
| ui.mlp.apiHost | string | `"/api"` |  |
| ui.oauthClientID | string | `""` |  |
| ui.upiDocURL | string | `"https://github.com/caraml-dev/universal-prediction-interface/blob/main/docs/api_markdown/caraml/upi/v1/index.md"` |  |
