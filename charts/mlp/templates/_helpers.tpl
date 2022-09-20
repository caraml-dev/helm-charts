{{/* vim: set filetype=mustache: */}}


{{/*
Generated names
*/}}

{{- define "mlp.chart-version" -}}
    {{- $chartVersion := .Chart.Version | replace "." "-" }}
    {{- printf "%s" $chartVersion}}
{{- end }}

{{- define "mlp.resource-prefix" -}}
    {{- $deployedChart := .Chart.Name -}}
    {{- $chartVersion := .Chart.Version | replace "." "-" -}}
    {{- $deployedReleaseName := .Release.Name -}}
    {{ printf "mlp-%s-%s-%s"  $deployedChart $chartVersion $deployedReleaseName }}
{{- end }}


{{- define "mlp.name" -}}
    {{- printf "%s" (include "mlp.resource-prefix" .) | trunc 63 | trimSuffix "-"}}
{{- end }}

{{- define "mlp.job-name" -}}
    {{- printf "%s-job" (include "mlp.resource-prefix" .) | trunc 63 | trimSuffix "-"}}
{{- end }}

{{- define "mlp.cm-name" -}}
    {{- printf "%s-cm" (include "mlp.resource-prefix" .) | trunc 63 | trimSuffix "-"}}
{{- end }}


{{- define "mlp.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version -}}
{{- end -}}

{{- define "mlp.fullname" -}}
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

{{- define "postgres.host" -}}
{{ if .Values.postgresql.enabled }}
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
