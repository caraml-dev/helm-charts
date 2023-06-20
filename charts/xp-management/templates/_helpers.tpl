{{/*
Expand the name of the chart.
*/}}

{{- define "management-svc.resource-prefix-with-release-name" -}}
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

{{- define "management-svc.resource-prefix" -}}
    {{- if .Values.nameOverride -}}
        {{- .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
        {{- $deployedChart := .Chart.Name -}}
        {{ printf "%s"  $deployedChart | trunc 63 | trimSuffix "-" }}
    {{- end -}}
{{- end -}}

{{- define "management-svc.name" -}}
    {{- printf "%s" (include "management-svc.resource-prefix" .) -}}
{{- end }}

{{- define "management-svc.fullname" -}}
    {{- printf "%s" (include "management-svc.resource-prefix-with-release-name" .) -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "management-svc.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "management-svc.labels" -}}
release: {{ .Release.Name }}
app.kubernetes.io/name: {{ template "management-svc.name" . }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | quote}}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: caraml
{{ if .Values.extraLabels -}}
    {{ toYaml .Values.extraLabels -}}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "management-svc.selectorLabels" -}}
app.kubernetes.io/name: {{ include "management-svc.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "management-svc.serviceAccountName" -}}
{{- if .Values.deployment.serviceAccount.create }}
{{- default (include "management-svc.fullname" .) .Values.deployment.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.deployment.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "management-svc.environment" -}}
{{- .Values.global.environment | default .Values.deployment.environment | default "dev" -}}
{{- end -}}

{{- define "management-svc.sentry.enabled" -}}
{{ eq ((.Values.deployment.apiConfig.SentryConfig).enabled | toString) "true" }}
{{- end -}}

{{- define "management-svc.sentry.dsn" -}}
{{- .Values.global.sentry.dsn | default .Values.deployment.sentry.dsn -}}
{{- end -}}

{{- define "management-svc.ui.defaultConfig" -}}
{{- $globOauthClientID := include "common.get-oauth-client" .Values.global }}
{{- if .Values.uiConfig -}}
appConfig:
  environment: {{ .Values.uiConfig.appConfig.environment | default (include "management-svc.environment" .) }}
authConfig:
  oauthClientId: {{ include "common.set-value" (list .Values.uiConfig.authConfig.oauthClientId $globOauthClientID) | quote }}
{{- if (include "management-svc.sentry.enabled" .) }}
sentryConfig:
  environment: {{ .Values.uiConfig.sentryConfig.environment | default (include "management-svc.environment" .) }}
  dsn: {{ .Values.uiConfig.sentryConfig.dsn | default (include "management-svc.sentry.dsn" .) | quote }}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "management-svc.ui.config" -}}
{{- $defaultConfig := include "management-svc.ui.defaultConfig" . | fromYaml -}}
{{ .Values.uiConfig | merge $defaultConfig | toPrettyJson }}
{{- end -}}

{{/*
API config related
*/}}

{{- define "management-svc.get-workload-host" }}
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

{{- define "management-svc.defaultConfig" -}}
{{- $globMlpApiHost := include "management-svc.get-workload-host" (list .Values.global .Release.Namespace "mlp")}}
Glob: {{ include "common.set-value" (list .Values.deployment.apiConfig.MlpConfig.URL $globMlpApiHost) }}
Port: 8080
AllowedOrigins: "*"
AuthorizationConfig:
  Enabled: false
DbConfig:
  Host: {{ include "common.postgres-host" (list (index .Values "xp-management-postgresql") .Values.xpManagementExternalPostgresql .Release .Chart ) }}
  Port: 5432
  Database: {{ include "common.postgres-database" (list (index .Values "xp-management-postgresql") .Values.xpManagementExternalPostgresql .Values.global "xp" "postgresqlDatabase") }}
  User: {{ include "common.postgres-username" (list (index .Values "xp-management-postgresql") .Values.xpManagementExternalPostgresql .Values.global ) }}
  ConnMaxIdleTime: {{ .Values.deployment.apiConfig.DbConfig.ConnMaxIdleTime }}
  ConnMaxLifetime: {{ .Values.deployment.apiConfig.DbConfig.ConnMaxLifetime }}
  MaxIdleConns: {{ .Values.deployment.apiConfig.DbConfig.MaxIdleConns }}
  MaxOpenConns: {{ .Values.deployment.apiConfig.DbConfig.MaxOpenConns }}
DeploymentConfig:
  EnvironmentType: dev
SegmenterConfig:
  S2_IDs:
    MinS2CellLevel: 10
    MaxS2CellLevel: 14
MlpConfig:
  URL: {{ include "common.set-value" (list .Values.deployment.apiConfig.MlpConfig.URL $globMlpApiHost) }}
NewRelicConfig:
  Enabled: false
SentryConfig:
  Enabled: false
XpUIConfig:
  AppDirectory: /app/xp-ui
{{- end -}}

{{- define "management-svc.config" -}}
{{- $defaultConfig := include "management-svc.defaultConfig" . | fromYaml -}}
{{ .Values.deployment.apiConfig | mergeOverwrite $defaultConfig | toYaml }}
{{- end -}}
