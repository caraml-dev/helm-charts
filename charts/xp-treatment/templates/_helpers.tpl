{{/*
Expand the name of the chart.
*/}}

{{- define "treatment-svc.resource-prefix-with-release-name" -}}
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

{{- define "treatment-svc.resource-prefix" -}}
    {{- if .Values.nameOverride -}}
        {{- .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
        {{- $deployedChart := .Chart.Name -}}
        {{ printf "%s"  $deployedChart | trunc 63 | trimSuffix "-" }}
    {{- end -}}
{{- end -}}

{{- define "treatment-svc.name" -}}
    {{- printf "%s" (include "treatment-svc.resource-prefix" .) -}}
{{- end }}

{{- define "treatment-svc.fullname" -}}
    {{- printf "%s" (include "treatment-svc.resource-prefix-with-release-name" .) -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "treatment-svc.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "treatment-svc.labels" -}}
release: {{ .Release.Name }}
app.kubernetes.io/name: {{ template "treatment-svc.name" . }}
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
{{- define "treatment-svc.selectorLabels" -}}
app.kubernetes.io/name: {{ include "treatment-svc.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
API config related
*/}}

{{- define "treatment-svc.defaultConfig" -}}
deploymentConfig:
  environmentType: dev
managementService:
  url: http://xp-management:8080/v1
  authorizationEnabled: false
newRelicConfig:
  enabled: false
sentryConfig:
  enabled: false
segmenterConfig:
  s2_ids:
    minS2CellLevel: 10
    maxS2CellLevel: 14
port: 8080
{{- end -}}

{{- define "treatment-svc.config" -}}
{{- $defaultConfig := include "treatment-svc.defaultConfig" . | fromYaml -}}
{{ .Values.deployment.apiConfig | merge $defaultConfig | toYaml }}
{{- end -}}
