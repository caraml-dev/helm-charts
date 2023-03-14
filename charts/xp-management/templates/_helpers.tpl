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
{{ eq ((.Values.deployment.apiConfig.sentryConfig).enabled | toString) "true" }}
{{- end -}}

{{- define "management-svc.sentry.dsn" -}}
{{- .Values.global.sentry.dsn | default .Values.deployment.sentry.dsn -}}
{{- end -}}

{{- define "management-svc.ui.defaultConfig" -}}
{{- if .Values.uiConfig -}}
appConfig:
  environment: {{ .Values.uiConfig.appConfig.environment | default (include "management-svc.environment" .) }}
authConfig:
  oauthClientId: {{ .Values.global.oauthClientId | default .Values.uiConfig.authConfig.oauthClientId | quote }}
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

{{- define "management-svc.mlp.server.url" -}}
{{- $protocol := (default "http" .Values.global.protocol ) }}
{{- $globalMLPUrl := "" }}
{{- if and .Values.global (hasKey .Values.global "mlp") }}
  {{- if .Values.global.mlp.serviceName }}
    {{- $globalMLPUrl = (printf "%s://%s" $protocol (include "common.get-component-value" (list .Values.global "mlp" (list "serviceName")))) }}
  {{- end }}
{{- end }}
{{- printf "%s" (include "common.set-value" (list .Values.deployment.apiConfig.mlpConfig.url $globalMLPUrl)) -}}
{{- end -}}

{{- define "management-svc.defaultConfig" -}}
port: 8080
allowedOrigins: "*"
authorizationConfig:
  enabled: false
dbConfig:
  host: {{ include "common.postgres-host" (list .Values.postgresql .Values.externalPostgresql .Release .Chart ) }}
  port: 5432
  database: {{ include "common.postgres-database" (list .Values.postgresql .Values.externalPostgresql .Values.global "mlp" "postgresqlDatabase") }}
  user: {{ include "common.postgres-username" (list .Values.postgresql .Values.externalPostgresql .Values.global ) }}
  connMaxIdleTime: {{ .Values.deployment.apiConfig.dbConfig.connMaxIdleTime }}
  connMaxLifetime: {{ .Values.deployment.apiConfig.dbConfig.connMaxLifetime }}
  maxIdleConns: {{ .Values.deployment.apiConfig.dbConfig.maxIdleConns }}
  maxOpenConns: {{ .Values.deployment.apiConfig.dbConfig.maxOpenConns }}
deploymentConfig:
  dnvironmentType: dev
segmenterConfig:
  s2_ids:
    minS2CellLevel: 10
    maxS2CellLevel: 14
mlpConfig:
  url: {{ .Values.deployment.apiConfig.mlpConfig.url | default (include "management-svc.mlp.server.url" .) | quote }}
newRelicConfig:
  enabled: false
sentryConfig:
  enabled: false
xpUIConfig:
  appDirectory: /app/xp-ui
{{- end -}}

{{- define "management-svc.config" -}}
{{- $defaultConfig := include "management-svc.defaultConfig" . | fromYaml -}}
{{ .Values.deployment.apiConfig | merge $defaultConfig | toYaml }}
{{- end -}}
