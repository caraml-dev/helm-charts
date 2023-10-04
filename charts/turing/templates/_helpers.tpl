{{/* vim: set filetype=mustache: */}}

{{- define "turing.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "turing.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version -}}
{{- end -}}

{{- define "turing.labels" -}}
app: {{ include "turing.name" . }}
chart: {{ include "turing.chart" . }}
release: {{ .Release.Name }}
heritage: {{ .Release.Service }}
{{- if .Values.deployment.labels }}
{{ toYaml .Values.deployment.labels -}}
{{- end }}
{{- end -}}

{{- define "turing.resource-prefix-with-release-name" -}}
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

{{- define "turing.fullname" -}}
    {{- printf "%s" (include "turing.resource-prefix-with-release-name" .) -}}
{{- end -}}

{{- define "turing.image" -}}
{{- $registryName := .Values.deployment.image.registry -}}
{{- $repositoryName := .Values.deployment.image.repository -}}
{{- $tag :=  (ternary .Values.deployment.image.tag .Values.rendered.releasedVersion (ne .Values.deployment.image.tag "")) | toString -}}
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

{{- define "turing.serviceAccountName" -}}
{{- default (include "turing.fullname" .) .Values.serviceAccount.name }}
{{- end }}

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

{{- define "turing.kaniko-sa" -}}
{{- if .Values.imageBuilder.serviceAccount.create }}
{{- printf  "%s-%s" (default "kaniko" .Values.imageBuilder.serviceAccount.name) (include "turing.fullname" . ) }}
{{- else }}
{{- printf "%s" .Values.imageBuilder.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "turing.get-workload-host" }}
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

{{/*
UI config related
*/}}

{{- define "turing.ui.defaultConfig" -}}
{{- $globOauthClientID := include "common.get-oauth-client" .Values.global }}
{{- if .Values.uiConfig -}}
alertConfig:
  enabled: {{ eq (quote .Values.uiConfig.alertConfig.enabled) "" | ternary .Values.config.AlertConfig.Enabled .Values.uiConfig.alertConfig.enabled }}
appConfig:
  environment: {{ .Values.uiConfig.appConfig.environment | default (include "turing.environment" .) }}
authConfig:
  oauthClientId: {{ include "common.set-value" (list .Values.uiConfig.authConfig.oauthClientId $globOauthClientID) | quote }}
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
{{- $globMerlinApiHost := include "turing.get-workload-host" (list .Values.global .Release.Namespace "merlin")}}
{{- $globMlpApiHost := include "turing.get-workload-host" (list .Values.global .Release.Namespace "mlp")}}
AuthConfig:
  URL: {{ include "turing.authorization.server.url" . | quote }}
{{ if and (.Values.config.BatchEnsemblingConfig.Enabled) (or .Values.imageBuilder.serviceAccount.create .Values.imageBuilder.serviceAccount.name) }}
BatchEnsemblingConfig:
  ImageBuildingConfig:
    KanikoConfig:
      ServiceAccount: {{ include "turing.kaniko-sa" . }}
{{ end }}
EnsemblerServiceBuilderConfig:
  ClusterName: {{ .Values.imageBuilder.clusterName }}
{{ if (or .Values.imageBuilder.serviceAccount.create .Values.imageBuilder.serviceAccount.name) }}
  ImageBuildingConfig:
    KanikoConfig:
      ServiceAccount: {{ include "turing.kaniko-sa" . }}
{{ end }}
ClusterConfig:
  InClusterConfig: {{ .Values.clusterConfig.useInClusterConfig }}
  EnvironmentConfigPath: {{ include "turing.environments.absolutePath" . }}
  EnsemblingServiceK8sConfig:
{{ .Values.imageBuilder.k8sConfig | toYaml | indent 4}}
DbConfig:
  Host: {{ include "common.postgres-host" (list (index .Values "turing-postgresql") .Values.turingExternalPostgresql .Release .Chart ) }}
  Port: 5432
  Database: {{ include "common.postgres-database" (list (index .Values "turing-postgresql") .Values.turingExternalPostgresql .Values.global "turing" "postgresqlDatabase") }}
  User: {{ include "common.postgres-username" (list (index .Values "turing-postgresql") .Values.turingExternalPostgresql .Values.global ) }}
  ConnMaxIdleTime: {{ .Values.config.DbConfig.ConnMaxIdleTime }}
  ConnMaxLifetime: {{ .Values.config.DbConfig.ConnMaxLifetime }}
  MaxIdleConns: {{ .Values.config.DbConfig.MaxIdleConns }}
  MaxOpenConns: {{ .Values.config.DbConfig.MaxOpenConns }}
DeployConfig:
  EnvironmentType: {{ .Values.config.DeployConfig.EnvironmentType | default (include "turing.environment" .) }}
KubernetesLabelConfigs:
  Environment: {{ .Values.config.KubernetesLabelConfigs.Environment | default (include "turing.environment" .) }}
MLPConfig:
  MerlinURL: {{ include "common.set-value" (list .Values.config.MLPConfig.MerlinURL $globMerlinApiHost) }}
  MLPURL: {{ include "common.set-value" (list .Values.config.MLPConfig.MLPURL $globMlpApiHost) }}
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
{{- $renderedConfig := include "turing.renderedConfig" (list $ . .Values.rendered ) | fromYaml -}}
{{- merge $renderedConfig $defaultConfig  .Values.config  | toYaml }}
{{- end -}}
