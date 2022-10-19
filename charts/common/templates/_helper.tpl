{{/* vim: set filetype=mustache: */}}
{{/*
Receives 2 arguments,
Returns store if value supplied is ""
*/}}
{{- define "common.set-value"}}
{{- $store := index . 0 }}
{{- $value := index . 1 }}
{{- printf "%s" (ternary $value $store (ne $value ""))}}
{{- end }}
