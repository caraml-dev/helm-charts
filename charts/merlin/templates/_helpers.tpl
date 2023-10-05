{{/* vim: set filetype=mustache: */}}


{{/*
Generated names
*/}}

{{- define "merlin.resource-prefix-with-release-name" -}}
    {{- if .Values.fullnameOverride -}}
        {{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
        {{- $name := default .Chart.Name .Values.nameOverride -}}
        {{- if contains $name .Release.Name -}}
            {{- .Release.Name | trunc 63 | trimSuffix "-" -}}
        {{- else -}}
            {{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{- define "merlin.resource-prefix" -}}
    {{- if .Values.nameOverride -}}
        {{- .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
        {{- $deployedChart := .Chart.Name -}}
        {{ printf "%s"  $deployedChart | trunc 63 | trimSuffix "-" }}
    {{- end -}}
{{- end -}}


{{- define "merlin.name" -}}
    {{- printf "%s" (include "merlin.resource-prefix" .) -}}
{{- end -}}

{{- define "merlin.fullname" -}}
    {{- printf "%s" (include "merlin.resource-prefix-with-release-name" .) -}}
{{- end -}}

{{- define "merlin.envs-cm-name" -}}
    {{- printf "%s-config" (include "merlin.resource-prefix-with-release-name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "merlin.scripts-cm-name" -}}
    {{- printf "%s-scripts" (include "merlin.resource-prefix" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "merlin.swagger-name" -}}
    {{- printf "%s-swagger" (include "merlin.resource-prefix" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "merlin.environment" -}}
{{- .Values.environment | default "dev" -}}
{{- end -}}

{{- define "merlin.serviceAccountName" -}}
{{- default (include "merlin.fullname" .) .Values.serviceAccount.name }}
{{- end }}

{{- define "merlin.chart" -}}
    {{- printf "%s-%s" .Chart.Name .Chart.Version -}}
{{- end -}}

{{- define "mlflow.name" -}}
    {{- if .Values.mlflow.nameOverride -}}
        {{- .Values.mlflow.nameOverride | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
        {{- printf "%s-%s" .Chart.Name .Values.mlflow.name | trunc 63 | trimSuffix "-" -}}
    {{- end -}}
{{- end -}}

{{- define "mlflow.fullname" -}}
    {{- if .Values.mlflow.fullnameOverride -}}
        {{- .Values.mlflow.fullnameOverride | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
        {{- printf "%s-%s" (include "merlin.resource-prefix-with-release-name" .) .Values.mlflow.name | trunc 63 | trimSuffix "-" -}}
    {{- end -}}
{{- end -}}


{{/*
Common labels
*/}}
{{- define "merlin.labels" -}}
app: {{ template "merlin.name" .}}
release: {{ .Release.Name }}
app.kubernetes.io/name: {{ template "merlin.name" . }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | quote}}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: caraml
{{- end }}


{{/*
MLflow Postgres related
*/}}

{{- define "mlflow-postgresql.host" -}}
{{- if index .Values "mlflow-postgresql" "enabled" -}}
    {{- printf "%s-mlflow-postgresql.%s.svc.cluster.local" .Release.Name .Release.Namespace -}}
{{- else if .Values.mlflowExternalPostgresql.enabled -}}
    {{- .Values.mlflowExternalPostgresql.address -}}
{{- else -}}
    {{- printf "%s-postgresql.%s.svc.cluster.local" .Release.Name .Release.Namespace -}}
{{- end -}}
{{- end -}}

{{- define "mlflow-postgresql.username" -}}
    {{- if index .Values "mlflow-postgresql" "enabled" -}}
        {{- index .Values "mlflow-postgresql" "postgresqlUsername" -}}
    {{- else if .Values.mlflowExternalPostgresql.enabled -}}
        {{- .Values.mlflowExternalPostgresql.username -}}
    {{- else -}}
        {{- .Values.global.postgresqlUsername -}}
    {{- end -}}
{{- end -}}

{{- define "mlflow-postgresql.database" -}}
    {{- if index .Values "mlflow-postgresql" "enabled" -}}
        {{- index .Values "mlflow-postgresql" "postgresqlDatabase" -}}
    {{- else if .Values.mlflowExternalPostgresql.enabled -}}
        {{- .Values.mlflowExternalPostgresql.database -}}
    {{- else -}}
        {{- .Values.global.merlin.mlflow.postgresqlDatabase -}}
    {{- end -}}
{{- end -}}

{{- define "mlflow.backendStoreUri" -}}
    {{- if .Values.mlflow.backendStoreUri -}}
        {{- printf .Values.mlflow.backendStoreUri -}}
    {{- else -}}
        {{- printf "postgresql://%s:$(DATABASE_PASSWORD)@%s:5432/%s" (include "mlflow-postgresql.username" .) (include "mlflow-postgresql.host" .) (include "mlflow-postgresql.database" .) -}}
    {{- end -}}
{{- end -}}


{{- define "mlflow-postgresql.password-secret-name" -}}
    {{- if index .Values "mlflow-postgresql" "enabled" -}}
        {{- printf "%s-mlflow-postgresql" .Release.Name -}}
    {{- else if .Values.mlflowExternalPostgresql.enabled -}}
        {{- default (printf "%s-mlflow-external-postgresql" .Release.Name) .Values.mlflowExternalPostgresql.secretName -}}
    {{- else -}}
        {{- printf "%s-postgresql" .Release.Name -}}
    {{- end -}}
{{- end -}}

{{- define "mlflow-postgresql.password-secret-key" -}}
    {{- if and .Values.mlflowExternalPostgresql.enabled -}}
        {{- default "postgresql-password" .Values.mlflowExternalPostgresql.secretKey  -}}
    {{- else -}}
        {{- printf "postgresql-password" -}}
    {{- end -}}
{{- end -}}


{{- define "merlin.initContainers" -}}
initContainers:
{{ with .Values.deployment.extraInitContainers }}
{{- toYaml . -}}
{{- end }}
{{- end -}}


{{- define "merlin.environments" -}}
{{ .Values.environmentConfigs | toYaml }}
{{- end -}}

{{- define "merlin.environments.directory" -}}
/app/cluster-env
{{- end -}}

{{- define "merlin.environments.absolutePath" -}}
{{- $base := include "merlin.environments.directory" . -}}
{{- $path := ternary .Values.mlp.environmentConfigSecret.envKey .Values.clusterConfig.environmentConfigPath (ne "" .Values.mlp.environmentConfigSecret.name) -}}
{{- printf "%s/%s" $base $path -}}
{{- end -}}


{{- define "merlin.get-workload-host" }}
{{- $global := index . 0}}
{{- $relNs := index . 1}}
{{- $key := index . 2}}
{{- $values := get $global $key}}
{{- if not (hasKey $global $key) }}
  {{- printf "" }}
{{- else }}
  {{- $values := get $global $key}}
  {{- $host := "" }}
  {{- with $values }}
    {{- if .useServiceFqdn }}
      {{- $host = printf "http://%s.%s.svc.cluster.local:%s%s" .serviceName $relNs .externalPort .apiPrefix}}
    {{- else }}
      {{- $inClusterPrefix := printf "%s%s" .vsPrefix .apiPrefix }}
      {{- $host = printf "%s://%s%s" $global.protocol (include "common.get-external-hostname" $global) $inClusterPrefix }}
    {{- end }}
    {{- end }}
  {{- printf "%s" $host }}
  {{- end }}
{{- end }}


{{- define "merlin.get-feast-api-host"}}
{{- $protocol := (default "http" (get . "protocol")) }}
{{- $hostname := include "common.get-external-hostname" . }}
{{- if $hostname }}
{{- printf "%s://%s" $protocol $hostname}}
{{- else }}
{{- printf ""}}
{{- end }}
{{- end }}

{{- define "merlin.authorization.server.url" -}}
    {{- $protocol := (default "http" .Values.global.protocol ) }}
    {{- $globalAuthzUrl := "" }}
    {{- if and .Values.global (hasKey .Values.global "authz") }}
        {{- if .Values.global.authz.serviceName }}
            {{- $globalAuthzUrl = (printf "%s://%s" $protocol (include "common.get-component-value" (list .Values.global "authz" (list "serviceName")))) }}
        {{- end }}
    {{- end }}
    {{- printf "%s" (include "common.set-value" (list .Values.config.AuthorizationConfig.AuthorizationServerURL $globalAuthzUrl)) -}}
{{- end -}}

{{- define "merlin.environmentsSecretName" -}}
{{- if .Values.mlp.environmentConfigSecret.name }}
{{- printf "%s" .Values.mlp.environmentConfigSecret.name }}
{{- else }}
{{- printf "%s-environments" (include "merlin.fullname" .) }}
{{- end -}}
{{- end -}}


{{- define "merlin.kaniko-sa" -}}
{{- if .Values.imageBuilder.serviceAccount.create }}
{{- printf  "%s-%s" (default "kaniko" .Values.imageBuilder.serviceAccount.name) (include "merlin.fullname" . ) }}
{{- else }}
{{- printf "%s" .Values.imageBuilder.serviceAccount.name }}
{{- end }}
{{- end }}


{{- define "merlin.defaultConfig" -}}
{{- $globMerlinApiHost := include "merlin.get-workload-host" (list .Values.global .Release.Namespace "merlin") -}}
{{- $globMlpApiHost := include "merlin.get-workload-host" (list .Values.global .Release.Namespace "mlp") -}}
{{- $globOauthClientID := include "common.get-oauth-client" .Values.global -}}
Environment: {{ .Values.config.Environment | default (include "merlin.environment" .) }}
Port: {{ .Values.service.internalPort | default "8080" }}
LoggerDestinationURL: {{ .Values.config.LoggerDestinationURL }}
Sentry:
  Enabled:  {{ .Values.config.Sentry.Enabled | default "false" }}
  DSN: {{ .Values.config.Sentry.DSN }}
NewRelic:
  Enabled: {{ .Values.config.NewRelic.Enabled | default "false" }}
  AppName: {{ .Values.config.NewRelic.AppName }}
  License: {{ .Values.config.NewRelic.License }}
NumOfQueueWorkers: {{ .Values.config.NumOfQueueWorkers | default 2 }}
DbConfig:
  Host: {{ include "common.postgres-host" (list (index .Values "merlin-postgresql") .Values.merlinExternalPostgresql .Release .Chart ) }}
  Port: 5432
  Database: {{ include "common.postgres-database" (list (index .Values "merlin-postgresql") .Values.merlinExternalPostgresql .Values.global "merlin" "postgresqlDatabase") }}
  User: {{ include "common.postgres-username" (list (index .Values "merlin-postgresql") .Values.merlinExternalPostgresql .Values.global ) }}
ClusterConfig:
  InClusterConfig: {{ .Values.clusterConfig.useInClusterConfig }}
  EnvironmentConfigPath: {{ include "merlin.environments.absolutePath" . }}
ImageBuilderConfig:
  ClusterName: {{ .Values.imageBuilder.clusterName }}
  K8sConfig:
{{ .Values.imageBuilder.k8sConfig | toYaml | indent 4 }}
  {{- if (or .Values.imageBuilder.serviceAccount.create .Values.imageBuilder.serviceAccount.name) }}
  KanikoServiceAccount: {{ include "merlin.kaniko-sa" . }}
  {{- end }}
{{ .Values.imageBuilder.builderConfig | toYaml | indent 2 }}
AuthorizationConfig:
  AuthorizationServerURL: {{ include "merlin.authorization.server.url" . | quote }}
MlpAPIConfig:
  APIHost: {{ include "common.set-value" (list .Values.config.MlpAPIConfig.APIHost $globMlpApiHost) }}
FeatureToggleConfig:
  MonitoringConfig:
    MonitoringEnabled: {{ .Values.config.FeatureToggleConfig.MonitoringConfig.MonitoringEnabled | default "false" }}
  AlertConfig:
    AlertEnabled: {{ .Values.config.FeatureToggleConfig.AlertConfig.AlertEnabled | default "false" }}
ReactAppConfig:
  Environment: {{ .Values.config.Environment | default (include "merlin.environment" .) }}
  Test: {{ .Values.config.Sentry.Enabled }}
  {{- if .Values.config.Sentry.Enabled }}
  SentryDSN: {{ .Values.config.Sentry.DSN }}
  {{- end }}
StandardTransformerConfig:
  ImageName: {{ .Values.config.StandardTransformerConfig.ImageName }}
  DefaultFeastSource: {{ .Values.config.StandardTransformerConfig.DefaultFeastSource | default 2 }}
  EnableAuth: {{ .Values.config.StandardTransformerConfig.EnableAuth | default false }}
MlflowConfig:
  TrackingURL: {{ .Values.mlflow.trackingURL }}
  ArtifactServiceType: {{ .Values.mlflow.artifactServiceType | default "nop" }}
{{- end -}}


{{- define "merlin.config" -}}
{{- $defaultConfig := include "merlin.defaultConfig" . | fromYaml -}}
{{/* get original configuration first */}}
{{- $original := merge $defaultConfig .Values.config }}
{{/* Generate rendered template if set */}}
{{- if ne ( len .Values.rendered ) 0 }}
{{- $renderedConfig := include "merlin.renderedConfig" (list $ . .Values.rendered ) | fromYaml -}}
{{/* Use overrides in rendered to overwrite rendered config */}}
{{- $config := mergeOverwrite $renderedConfig .Values.rendered.overrides }}
{{/* Overwrite original with config */}}
{{- mergeOverwrite $original $config | toYaml }}
{{- else }}
{{- $original | toYaml }}
{{- end -}}
{{- end -}}


{{- define "merlin.deploymentTag" -}}
{{- $ := index . 0 -}}
{{- $rendered := index . 2 -}}
{{/* If deployment tag is set, use it */}}
{{- if ne $.Values.deployment.image.tag "" -}}
{{ printf "%s%s:%s" (ternary (printf "%s/" $.Values.deployment.image.registry) "" (ne $.Values.deployment.image.registry "")) $.Values.deployment.image.repository $.Values.deployment.image.tag }}
{{- else -}}
{{- with index . 1 }}
{{- $tag :=  ternary $.Values.deployment.image.tag (substr 1 (len $rendered.releasedVersion) $rendered.releasedVersion) (ne $.Values.deployment.image.tag "") -}}
{{ printf "%s%s:%s" (ternary (printf "%s/" $.Values.deployment.image.registry) "" (ne $.Values.deployment.image.registry "")) $.Values.deployment.image.repository $tag }}
{{- end -}}
{{- end -}}
{{- end -}}
