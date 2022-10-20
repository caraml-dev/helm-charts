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


{{/*
Takes 3 arguments:
1) global object
2) key name in global object
3) list of fields in global.key to use
*/}}
{{- define "common.get-component-value" }}
{{- $store := index . 0 }}
{{- $key := index . 1 }}
{{- $fields := index . 2}}
{{- if and $store (hasKey $store $key) }}
{{- $component := get $store $key}}
{{- $result := "" }}
{{- range $fields }}
{{- $result = printf "%s%s" $result (get $component .)}}
{{- end }}
{{- printf "%s" $result }}
{{- else }}
{{- printf "" }}
{{- end }}
{{- end }}

{{/*
1st arg is global map object, 2nd arg is value in values.yaml
*/}}
{{- define "common.get-oauth-client" }}
{{- $store := index . 0 }}
{{- $val := index . 1 }}
{{- if $store }}
{{- $temp := printf "%s" $store.oauthclient }}
{{- include "common.set-value" (list $temp $val)}}
{{- else }}
{{- printf "%s" $val}}
{{- end }}
{{- end }}
