{{/* vim: set filetype=mustache: */}}

{{- define "turing.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "turing.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version -}}
{{- end -}}

{{- define "turing.labels" -}}
app: {{ include "turing.fullname" . }}
chart: {{ include "turing.chart" . }}
release: {{ .Release.Name }}
heritage: {{ .Release.Service }}
{{- if .Values.deployment.labels }}
{{ toYaml .Values.deployment.labels -}}
{{- end }}
{{- end -}}

{{- define "turing.fullname" -}}
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

{{- define "turing.image" -}}
{{- $registryName := .Values.deployment.image.registry -}}
{{- $repositoryName := .Values.deployment.image.repository -}}
{{- $tag := .Values.deployment.image.tag | toString -}}
{{- if $registryName }}
    {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- else -}}
    {{- printf "%s:%s" $repositoryName $tag -}}
{{- end -}}
{{- end -}}

{{- define "turing.authorization.server.url" -}}
    {{- $protocol := (default "http" .Values.global.protocol ) }}
    {{- $globalAuthzUrl := "" }}
    {{- if and .Values.global (hasKey .Values.global "authz") }}
        {{- if .Values.global.authz.serviceName }}
            {{- $globalAuthzUrl = (printf "%s://%s" $protocol (include "common.get-component-value" (list .Values.global "authz" (list "serviceName")))) }}
        {{- end }}
    {{- end }}
    {{- printf "%s" (include "common.set-value" (list .Values.config.AuthConfig.URL $globalAuthzUrl)) -}}
{{- end -}}

{{- define "turing.environment" -}}
{{- .Values.environment | default "dev" -}}
{{- end -}}

{{- define "turing.encryption.key" -}}
{{- .Values.config.TuringEncryptionKey | default (randAlpha 12) -}}
{{- end -}}

{{- define "turing.serviceAccount.name" -}}
{{- include "turing.fullname" . -}}
{{- end -}}

{{- define "turing.mlp.encryption.key" -}}
{{- .Values.config.MLPConfig.MLPEncryptionKey -}}
{{- end -}}

{{- define "turing.sentry.dsn" -}}
{{- .Values.sentry.dsn -}}
{{- end -}}

{{- define "turing.plugins.directory" -}}
/app/plugins
{{- end -}}

{{- define "turing.plugins.initContainers" -}}
{{ if .Values.experimentEngines }}
initContainers:
{{ range $expEngine := .Values.experimentEngines }}
{{ if eq (toString $expEngine.type) "rpc-plugin" }}
- name: {{ $expEngine.name }}-plugin
  image: {{ $expEngine.rpcPlugin.image }}
  env:
  - name: PLUGIN_NAME
    value: "{{ $expEngine.name }}"
  - name: PLUGINS_DIR
    value: {{ include "turing.plugins.directory" . }}
  volumeMounts:
  - name: plugins-volume
    mountPath: {{ include "turing.plugins.directory" . }}
{{ end }}
{{ end }}
{{ end }}
{{- end -}}

{{- define "turing.initContainers" -}}
initContainers:
{{ with (include "turing.plugins.initContainers" . | fromYaml) -}}
{{ if .initContainers }}
{{- toYaml .initContainers -}}
{{ end }}
{{- end }}
{{ with .Values.deployment.extraInitContainers }}
{{- toYaml . -}}
{{- end }}
{{- end -}}

{{- define "turing.environments" -}}
{{ .Values.environmentConfigs | toYaml }}
{{- end -}}

{{- define "turing.environments.directory" -}}
/app/cluster-env
{{- end -}}

{{- define "turing.environments.absolutePath" -}}
{{- $base := include "turing.environments.directory" . -}}
{{- $path := ternary .Values.mlp.environmentConfigSecret.envKey .Values.clusterConfig.environmentConfigPath (ne "" .Values.mlp.environmentConfigSecret.name) -}}
{{- printf "%s/%s" $base $path -}}
{{- end -}}

{{/*
Postgres related
*/}}

{{- define "turing-postgresql.host" -}}
{{- if index .Values "turing-postgresql" "enabled" -}}
  {{- printf "%s-turing-postgresql.%s.svc.cluster.local" .Release.Name .Release.Namespace -}}
{{- else if .Values.turingExternalPostgresql.enabled -}}
  {{- .Values.turingExternalPostgresql.address -}}
{{- else -}}
  {{- printf "%s-postgresql.%s.svc.cluster.local" .Release.Name .Release.Namespace -}}
{{- end -}}
{{- end -}}

{{- define "turing-postgresql.username" -}}
  {{- if index .Values "turing-postgresql" "enabled" -}}
    {{- index .Values "turing-postgresql" "postgresqlUsername" -}}
  {{- else if .Values.turingExternalPostgresql.enabled -}}
    {{- .Values.turingExternalPostgresql.username -}}
  {{- else -}}
    {{- .Values.global.postgresqlUsername -}}
  {{- end -}}
{{- end -}}

{{- define "turing-postgresql.database" -}}
  {{- if index .Values "turing-postgresql" "enabled" -}}
    {{- index .Values "turing-postgresql" "postgresqlDatabase" -}}
  {{- else if .Values.turingExternalPostgresql.enabled -}}
    {{- .Values.turingExternalPostgresql.database -}}
  {{- else -}}
    {{- .Values.global.turing.postgresqlDatabase -}}
  {{- end -}}
{{- end -}}

{{/*
UI config related
*/}}

{{- define "turing.ui.defaultConfig" -}}
{{- if .Values.uiConfig -}}
alertConfig:
  enabled: {{ eq (quote .Values.uiConfig.alertConfig.enabled) "" | ternary .Values.config.AlertConfig.Enabled .Values.uiConfig.alertConfig.enabled }}
appConfig:
  environment: {{ .Values.uiConfig.appConfig.environment | default (include "turing.environment" .) }}
authConfig:
  oauthClientId: {{ .Values.uiConfig.authConfig.oauthClientId | quote }}
sentryConfig:
  environment: {{ .Values.uiConfig.sentryConfig.environment | default (include "turing.environment" .) }}
  dsn: {{ .Values.uiConfig.sentryConfig.dsn | default (include "turing.sentry.dsn" .) | quote }}
{{- end -}}
{{- end -}}

{{- define "turing.ui.config" -}}
{{- $defaultConfig := include "turing.ui.defaultConfig" . | fromYaml -}}
{{ .Values.uiConfig | merge $defaultConfig | toPrettyJson }}
{{- end -}}

{{/*
API config related
*/}}

{{- define "turing.defaultConfig" -}}
AuthConfig:
  URL: {{ include "turing.authorization.server.url" . | quote }}
EnsemblerServiceBuilderConfig:
  ClusterName: {{ .Values.imageBuilder.clusterName }}
ClusterConfig:
  InClusterConfig: {{ .Values.clusterConfig.useInClusterConfig }}
  EnvironmentConfigPath: {{ include "turing.environments.absolutePath" . }}
  EnsemblingServiceK8sConfig: 
{{ .Values.imageBuilder.k8sConfig | fromJson | toYaml | indent 4}}
DbConfig:
  Host: {{ include "turing-postgresql.host" . | quote }}
  Port: 5432
  Database:  {{ include "turing-postgresql.database" . }}
  User:  {{ include "turing-postgresql.username" . }}
  ConnMaxIdleTime: {{ .Values.config.DbConfig.ConnMaxIdleTime }}
  ConnMaxLifetime: {{ .Values.config.DbConfig.ConnMaxLifetime }}
  MaxIdleConns: {{ .Values.config.DbConfig.MaxIdleConns }}
  MaxOpenConns: {{ .Values.config.DbConfig.MaxOpenConns }}
DeployConfig:
  EnvironmentType: {{ .Values.config.DeployConfig.EnvironmentType | default (include "turing.environment" .) }}
KubernetesLabelConfigs:
  Environment: {{ .Values.config.KubernetesLabelConfigs.Environment | default (include "turing.environment" .) }}
MLPConfig:
  MLPEncryptionKey: {{ include "turing.mlp.encryption.key" . | quote }}
TuringEncryptionKey: {{ include "turing.encryption.key" . | quote }}
Sentry:
  DSN: {{ .Values.config.Sentry.DSN | default (include "turing.sentry.dsn" .) | quote }}
{{ if .Values.experimentEngines }}
Experiment:
{{ range $expEngine := .Values.experimentEngines }}
  {{ $expEngine.name }}:
{{ if $expEngine.options }}
{{ toYaml $expEngine.options | indent 4 }}
{{ end }}
{{ if eq (toString $expEngine.type) "rpc-plugin" }}
    plugin_binary: {{ include "turing.plugins.directory" . }}/{{ $expEngine.name }}
{{ end }}
{{ end }}
RouterDefaults:
  ExperimentEnginePlugins:
{{ range $expEngine := .Values.experimentEngines }}
    {{ $expEngine.name }}:
{{ if eq (toString $expEngine.type) "rpc-plugin" }}
      PluginConfig:
        Image: {{ $expEngine.rpcPlugin.image }}
        LivenessPeriodSeconds: {{ $expEngine.rpcPlugin.livenessPeriodSeconds | default 10 }}
{{ end }}
      ServiceAccountKeyFilePath: {{ $expEngine.serviceAccountKeyFilePath }}
{{- end -}}
{{ end }}
{{- if .Values.openApiSpecOverrides }}
OpenapiConfig:
  SpecOverrideFile: /etc/openapi/override.yaml
{{- end -}}
{{- end -}}

{{- define "turing.config" -}}
{{- $defaultConfig := include "turing.defaultConfig" . | fromYaml -}}
{{ .Values.config | merge $defaultConfig | toYaml }}
{{- end -}}
