{{/* vim: set filetype=mustache: */}}


{{/*
Generated names
*/}}

{{- define "mlp.resource-prefix-with-release-name" -}}
    {{- $deployedChart := .Chart.Name -}}
    {{- $chartVersion := .Chart.Version | replace "." "-" -}}
    {{- $deployedReleaseName := .Release.Name -}}
    {{ printf "%s-%s-%s"  $deployedChart $chartVersion $deployedReleaseName }}
{{- end -}}

{{- define "mlp.resource-prefix" -}}
    {{- $deployedChart := .Chart.Name -}}
    {{- $chartVersion := .Chart.Version | replace "." "-" -}}
    {{ printf "%s-%s"  $deployedChart $chartVersion }}
{{- end -}}


{{- define "mlp.name" -}}
    {{- if .Values.nameOverride -}}
        {{- .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
        {{- printf "%s" (include "mlp.resource-prefix" .) | trunc 63 | trimSuffix "-" -}}
    {{- end -}}
{{- end -}}

{{- define "mlp.encryption-key-name" -}}
    {{- printf "%s-encryption-key" (include "mlp.resource-prefix" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{- define "mlp.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version -}}
{{- end -}}

{{- define "mlp.fullname" -}}
    {{- if .Values.fullnameOverride -}}
        {{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
        {{- printf "%s" (include "mlp.resource-prefix-with-release-name" .) | trunc 63 | trimSuffix "-" -}}
    {{- end -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "mlp.labels" -}}
app.kubernetes.io/name: {{ template "mlp.name" . }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | quote}}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: caraml
{{- end }}


{{/*
Postgres related
*/}}
{{- define "postgres.host" -}}
{{- if .Values.postgresql.enabled -}}
    {{- printf "%s-%s-postgresql.%s.svc.cluster.local" .Release.Name .Chart.Name .Release.Namespace -}}
{{- else if .Values.externalPostgresql.enabled -}}
    {{- .Values.externalPostgresql.address -}}
{{- else -}}
    {{- printf "%s-postgresql.%s.svc.cluster.local" .Release.Name .Release.Namespace -}}
{{- end -}}
{{- end -}}

{{- define "postgres.username" -}}
    {{- if .Values.postgresql.enabled -}}
        {{- .Values.postgresql.postgresqlUsername -}}
    {{- else if .Values.externalPostgresql.enabled -}}
        {{- .Values.externalPostgresql.username -}}
    {{- else -}}
        {{- .Values.global.postgresqlUsername -}}
    {{- end -}}
{{- end -}}

{{- define "postgres.database" -}}
    {{- if .Values.postgresql.enabled -}}
        {{- .Values.postgresql.postgresqlDatabase -}}
    {{- else if .Values.externalPostgresql.enabled -}}
        {{- .Values.externalPostgresql.database -}}
    {{- else -}}
        {{- .Values.global.postgresqlDatabase -}}
    {{- end -}}
{{- end -}}

{{- define "postgres.password-secret-name" -}}
    {{- if .Values.postgresql.enabled -}}
        {{- printf "%s-%s-postgresql" .Release.Name .Chart.Name -}}
    {{- else if .Values.externalPostgresql.enabled -}}
        {{- printf "%s-%s-external-postgresql" .Release.Name .Chart.Name -}}
    {{- else -}}
        {{- printf "%s-postgresql" .Release.Name -}}
    {{- end -}}
{{- end -}}
