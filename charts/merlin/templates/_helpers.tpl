{{/* vim: set filetype=mustache: */}}


{{/*
Generated names
*/}}

{{- define "merlin.resource-prefix-with-release-name" -}}
    {{- $deployedChart := .Chart.Name -}}
    {{- $chartVersion := .Chart.Version | replace "." "-" -}}
    {{- $deployedReleaseName := .Release.Name -}}
    {{ printf "%s-%s-%s"  $deployedChart $chartVersion $deployedReleaseName }}
{{- end -}}

{{- define "merlin.resource-prefix" -}}
    {{- $deployedChart := .Chart.Name -}}
    {{- $chartVersion := .Chart.Version | replace "." "-" -}}
    {{ printf "%s-%s"  $deployedChart $chartVersion }}
{{- end -}}


{{- define "merlin.name" -}}
    {{- if .Values.nameOverride -}}
        {{- .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
        {{- printf "%s" (include "merlin.resource-prefix" .) | trunc 63 | trimSuffix "-" -}}
    {{- end -}}
{{- end -}}

{{- define "merlin.envs-cm-name" -}}
    {{- printf "%s-environments" (include "merlin.resource-prefix" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "merlin.mlp-api-encryption-key-name" -}}
    {{- printf "%s-mlp-api-encryption-key" (include "merlin.resource-prefix" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "merlin.swagger-name" -}}
    {{- printf "%s-swagger" (include "merlin.resource-prefix" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "merlin.alerts-repo-secret-name" -}}
    {{- printf "%s-%s-token" (include "merlin.resource-prefix" .) .Values.alerts.alertsRepoPlatform | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "merlin.alerts-repo-secret-key-name" -}}
    {{- printf "%s-token" .Values.alerts.alertsRepoPlatform | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{- define "merlin.chart" -}}
    {{- printf "%s-%s" .Chart.Name .Chart.Version -}}
{{- end -}}

{{- define "merlin.fullname" -}}
    {{- if .Values.fullnameOverride -}}
        {{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
        {{- printf "%s" (include "merlin.resource-prefix-with-release-name" .) | trunc 63 | trimSuffix "-" -}}
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
app.kubernetes.io/name: {{ template "merlin.name" . }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | quote}}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: caraml
{{- end }}



{{- define "merlin-postgresql.host" -}}
{{- if index .Values "merlin-postgresql" "enabled" -}}
{{- printf "%s-merlin-postgresql.%s.svc.cluster.local" .Release.Name .Release.Namespace -}}
{{- else -}}
{{- index .Values "merlin-postgresql" "postgresqlHost" -}}
{{- end -}}
{{- end -}}

{{/*
Merlin Postgres related
*/}}

{{- define "merlin-postgres.host" -}}
{{- if index .Values "merlin-postgresql" "enabled" -}}
    {{- printf "%s-merlin-postgresql.%s.svc.cluster.local" .Release.Name .Chart.Name .Release.Namespace -}}
{{- else if .Values.merlinExternalPostgresql.enabled -}}
    {{- .Values.merlinExternalPostgresql.address -}}
{{- else -}}
    {{- printf "%s-postgresql.%s.svc.cluster.local" .Release.Name .Release.Namespace -}}
{{- end -}}
{{- end -}}


{{- define "merlin-postgres.username" -}}
    {{- if index .Values "merlin-postgresql" "enabled" -}}
        {{- index .Values "merlin-postgresql" "postgresqlUsername" -}}
    {{- else if .Values.merlinExternalPostgresql.enabled -}}
        {{- .Values.merlinExternalPostgresql.username -}}
    {{- else -}}
        {{- .Values.global.postgresqlUsername -}}
    {{- end -}}
{{- end -}}

{{- define "merlin-postgres.database" -}}
    {{- if index .Values "merlin-postgresql" "enabled" -}}
        {{- index .Values "merlin-postgresql" "postgresqlDatabase" -}}
    {{- else if .Values.merlinExternalPostgresql.enabled -}}
        {{- .Values.merlinExternalPostgresql.database -}}
    {{- else -}}
        {{- .Values.global.merlin.postgresqlDatabase -}}
    {{- end -}}
{{- end -}}

{{- define "merlin-postgres.password-secret-name" -}}
    {{- if .Values.postgresql.enabled -}}
        {{- printf "%s-%s-postgresql" .Release.Name .Chart.Name -}}
    {{- else if .Values.merlinExternalPostgresql.enabled -}}
        {{- default (printf "%s-%s-external-postgresql" .Release.Name .Chart.Name) .Values.externalPostgresql.secretName -}}
    {{- else -}}
        {{- printf "%s-postgresql" .Release.Name -}}
    {{- end -}}
{{- end -}}

{{- define "merlin-postgres.password-secret-key" -}}
    {{- if and .Values.merlinExternalPostgresql.enabled -}}
        {{- default "postgresql-password" .Values.externalPostgresql.secretKey  -}}
    {{- else -}}
        {{- printf "postgresql-password" -}}
    {{- end -}}
{{- end -}}

{{/*
MLflow Postgres related
*/}}

{{- define "mlflow-postgres.host" -}}
{{- if index .Values "mlflow-postgresql" "enabled" -}}
    {{- printf "%s-mlflow-postgresql.%s.svc.cluster.local" .Release.Name .Chart.Name .Release.Namespace -}}
{{- else if .Values.mlflowExternalPostgresql.enabled -}}
    {{- .Values.mlflowExternalPostgresql.address -}}
{{- else -}}
    {{- printf "%s-postgresql.%s.svc.cluster.local" .Release.Name .Release.Namespace -}}
{{- end -}}
{{- end -}}


{{- define "mlflow-postgres.username" -}}
    {{- if index .Values "mlflow-postgresql" "enabled" -}}
        {{- .Values.postgresql.postgresqlUsername -}}
    {{- else if .Values.mlflowExternalPostgresql.enabled -}}
        {{- .Values.mlflowExternalPostgresql.username -}}
    {{- else -}}
        {{- .Values.global.postgresqlUsername -}}
    {{- end -}}
{{- end -}}

{{- define "mlflow-postgres.database" -}}
    {{- if index .Values "mlflow-postgresql" "enabled" -}}
        {{- .Values.postgresql.postgresqlDatabase -}}
    {{- else if .Values.mlflowExternalPostgresql.enabled -}}
        {{- .Values.mlflowExternalPostgresql.database -}}
    {{- else -}}
        {{- .Values.global.merlin.postgresqlDatabase -}}
    {{- end -}}
{{- end -}}

{{- define "mlflow.backendStoreUri" -}}
    {{- if .Values.mlflow.backendStoreUri -}}
        {{- printf .Values.mlflow.backendStoreUri -}}
    {{- else -}}
        {{- printf "postgresql://%s:%s@%s:5432/%s" (include "mlflow-postgresql.username" .) (index .Values "mlflow-postgresql" "postgresqlPassword") (include "mlflow-postgresql.host" .) (include "mlflow-postgresql.database" .) -}}
    {{- end -}}
{{- end -}}


# TODO: replace hardcoded password with secrets
# {{- define "mlflow-postgres.password-secret-name" -}}
#     {{- if index .Values "mlflow-postgresql" "enabled" -}}
#         {{- printf "%s-%s-postgresql" .Release.Name .Chart.Name -}}
#     {{- else if .Values.mlflowExternalPostgresql.enabled -}}
#         {{- default (printf "%s-%s-external-postgresql" .Release.Name .Chart.Name) .Values.externalPostgresql.secretName -}}
#     {{- else -}}
#         {{- printf "%s-postgresql" .Release.Name -}}
#     {{- end -}}
# {{- end -}}

# {{- define "mlflow-postgres.password-secret-key" -}}
#     {{- if and .Values.mlflowExternalPostgresql.enabled -}}
#         {{- default "postgresql-password" .Values.externalPostgresql.secretKey  -}}
#     {{- else -}}
#         {{- printf "postgresql-password" -}}
#     {{- end -}}
# {{- end -}}
