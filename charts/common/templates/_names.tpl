{{/* vim: set filetype=mustache: */}}

{{/*
Get postgres host name in the following order of precendence: Chart specific postgresql > Chart external Postgresql > Global postgresql, Arguments:
1) postgresql object
2) external postgresql object
3) Release object
4) Chart object
*/}}
{{- define "common.postgres-host" -}}
{{- $postgresql := index . 0 -}}
{{- $externalPostgresql := index . 1 -}}
{{- $release := index . 2 -}}
{{- $chart := index . 3 -}}
{{- if $postgresql.enabled -}}
    {{- printf "%s-%s-postgresql.%s.svc.cluster.local" $release.Name $chart.Name $release.Namespace -}}
{{- else if $externalPostgresql.enabled -}}
    {{- $externalPostgresql.address -}}
{{- else -}}
    {{- printf "%s-postgresql.%s.svc.cluster.local" $release.Name $release.Namespace -}}
{{- end -}}
{{- end -}}


{{/*
Get postgres user name in the following order of precendence: Chart specific postgresql > Chart external Postgresql > Global postgresql, Arguments:
1) postgresql object
2) external postgresql object
3) global object
*/}}
{{- define "common.postgres-username" -}}
{{- $postgresql := index . 0 -}}
{{- $externalPostgresql := index . 1 -}}
{{- $global := index . 2 -}}
    {{- if $postgresql.enabled -}}
        {{- $postgresql.postgresqlUsername -}}
    {{- else if $externalPostgresql.enabled -}}
        {{- $externalPostgresql.username -}}
    {{- else -}}
        {{- $global.postgresqlUsername -}}
    {{- end -}}
{{- end -}}


{{/*
Get postgres database name in the following order of precendence: Chart specific postgresql > Chart external Postgresql > Global postgresql, Arguments:
1) postgresql object
2) external postgresql object
3) global object
*/}}
{{- define "common.postgres-database" -}}
{{- $postgresql := index . 0 -}}
{{- $externalPostgresql := index . 1 -}}
{{- $global := index . 2 -}}
    {{- if $postgresql.enabled -}}
        {{- $postgresql.postgresqlDatabase -}}
    {{- else if $externalPostgresql.enabled -}}
        {{- $externalPostgresql.database -}}
    {{- else -}}
        {{- $global.mlp.postgresqlDatabase -}}
    {{- end -}}
{{- end -}}
