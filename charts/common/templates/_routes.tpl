{{/* vim: set filetype=mustache: */}}

{{- define "common.get-external-host" }}
{{- if .domain }}
{{- printf "%s" .domain }}
{{- else if ne .ingressIP "" }}
{{- printf "%s" .ingressIP }}
{{- else }}
{{- include "common.istio-lookup" . }}
{{- end }}
{{- end }}

{{/*
Function to add nip.io to domain
Takes in 3 arguments:
subdomain, ingressIp, domain
Usage:
{{- include "common.localiseDomain" (list $val1 $val2 $val3 ) }}
IngressIP takes precedence over domain
*/}}
{{- define "common.localiseDomain" -}}
{{- $subdomain := index . 0 }}
{{- $ingressIP := index . 1 }}
{{- $domain := index . 2 }}
{{- if ne $domain "" }}
{{- ternary (printf "%s.%s" $subdomain $domain) (printf "%s" $subdomain) (ne $domain "") }}
{{- else }}
{{- printf "%s.%s.nip.io" $subdomain (ternary $ingressIP "example" (ne $ingressIP "")) }}
{{- end }}
{{- end }}

{{- define "common.istio-lookup" }}
{{- $istioLookupResult := (lookup "v1" "Service" .istioLookUp.namespace .istioLookUp.name ) }}
{{- if $istioLookupResult }}
{{- printf "%s" (index $istioLookupResult.status.loadBalancer.ingress 0).ip }}
{{- else }}
{{- printf "" }}
{{- end }}
{{- end }}


{{- define "common.get-prefix-match" }}
{{- printf "%s/" .vsPrefix }}
{{- end }}

{{- define "common.get-workload-host" }}
{{- $relNs := index . 1}}
{{- $values := index . 0}}
{{- with $values }}
{{- $inClusterPrefix := printf "%s%s" .vsPrefix .apiPrefix }}
{{- $host := "" }}
{{- if .useServiceFqdn }}
{{- $host = printf "%s.%s.svc.cluster.local%s" .serviceName $relNs .apiPrefix}}
{{- else }}
{{- $host = printf "%s%s" (include "common.get-external-host" $) $inClusterPrefix }}
{{- end }}
{{- end }}
{{- end }}
