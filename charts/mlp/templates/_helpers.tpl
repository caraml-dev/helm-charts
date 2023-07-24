{{/* vim: set filetype=mustache: */}}


{{/*
Generated names
*/}}


{{/*
Expand the name of the chart.
*/}}
{{- define "mlp.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "mlp.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
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

{{- define "mlp.resource-prefix-with-release-name" -}}
    {{- (include "mlp.fullname" .) -}}
{{- end -}}

{{- define "mlp.resource-prefix" -}}
    {{- (include "mlp.name" .) -}}
{{- end -}}

{{- define "mlp.config-cm-name" -}}
    {{- printf "%s-config" (include "mlp.resource-prefix-with-release-name" .) | trunc 63 | trimSuffix "-" -}}
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

{{- define "mlp.config.applications" -}}
    {{- $globFeastApi := include "common.get-component-value" (list .Values.global "feast" (list "vsPrefix" "apiPrefix")) }}
    {{- $globMerlinApi := include "common.get-component-value" (list .Values.global "merlin" (list "vsPrefix" "apiPrefix")) }}
    {{- $globTuringApi := include "common.get-component-value" (list .Values.global "turing" (list "vsPrefix" "apiPrefix")) }}
    {{- $globFeastUI := include "common.get-component-value" (list .Values.global "feast" (list "uiPrefix")) }}
    {{- $globMerlinUI := include "common.get-component-value" (list .Values.global "merlin" (list "uiPrefix")) }}
    {{- $globTuringUI := include "common.get-component-value" (list .Values.global "turing" (list "uiPrefix")) }}
    {{- $applications := default (list) .Values.config.applications -}}
    {{- $modifiedApps := (list) -}}
    {{- range $applications -}}
        {{- $name := .name -}}
        {{- $homepage := .homepage -}}
        {{- $api := .configuration.api -}}
        {{- if eq $name "Merlin" -}}
            {{- $homepage = include "common.set-value" (list .homepage $globMerlinUI) -}}
            {{- $api = include "common.set-value" (list $api $globMerlinApi) -}}
        {{- else if eq $name "Turing" -}}
            {{- $homepage = include "common.set-value" (list .homepage $globTuringUI) -}}
            {{- $api = include "common.set-value" (list $api $globTuringApi) -}}
        {{- else if eq $name "Feast" -}}
            {{- $homepage = include "common.set-value" (list .homepage $globFeastUI) -}}
            {{- $api = include "common.set-value" (list $api $globFeastApi) -}}
        {{- end -}}
        {{- $_ := set . "homepage" $homepage -}}
        {{- $_ := set .configuration "api" $api -}}
    {{- end -}}
    {{ toYaml $applications }}
{{- end -}}

{{- define "mlp.defaultConfig" -}}
{{- $globOauthClientID := include "common.get-oauth-client" .Values.global }}
{{- $globApiHost := include "common.get-component-value" (list .Values.global "mlp"  (list "vsPrefix")) }}
apiHost: {{ include "common.set-value" (list .Values.config.apiHost $globApiHost) | quote }}
port: {{ .Values.service.internalPort }}
sentryDSN: {{ .Values.sentry.dsn }}
oauthClientID: {{ include "common.set-value" (list .Values.config.oauthClientID $globOauthClientID) | quote }}
applications:
      {{- include "mlp.config.applications" . | nindent 6 }}
authorization:
    enabled: {{ .Values.config.authorization.enabled }}
    {{- if and .Values.config.authorization.enabled .Values.keto.enabled }}
    {{- if not .Values.config.authorization.ketoRemoteRead }}
    ketoRemoteRead: http://{{ template "keto.fullname" .Subcharts.keto}}-read:80
    {{- end }}
    {{- if not .Values.config.authorization.ketoRemoteWrite }}
    ketoRemoteWrite: http://{{ template "keto.fullname" .Subcharts.keto}}-write:80
    {{- end }}
    {{- end }}
database:
    host: {{ include "common.postgres-host" (list .Values.postgresql .Values.externalPostgresql .Release .Chart ) }}
    user: {{ include "common.postgres-username" (list .Values.postgresql .Values.externalPostgresql .Values.global ) }}
    database: {{ include "common.postgres-database" (list .Values.postgresql .Values.externalPostgresql .Values.global "mlp" "postgresqlDatabase") }}
{{- end -}}

{{- define "mlp.config" -}}
{{- $defaultConfig := include "mlp.defaultConfig" . | fromYaml -}}
{{ .Values.config | merge $defaultConfig | toYaml }}
{{- end -}}
