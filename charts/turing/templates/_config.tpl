{{- define "turing.renderedConfig" -}}
{{- $ := index . 0 }}
{{- $rendered := index . 2}}
{{- if $rendered }}
{{- $tag := $rendered.releasedVersion}}
{{- $ensemblerJobPrefix := printf "%s/caraml-dev/turing/pyfunc-ensembler-job-py" $.Values.deployment.image.registry -}}
{{- $servicePrefix := printf "%s/caraml-dev/turing/pyfunc-ensembler-service-py" $.Values.deployment.image.registry -}}
# Now we have access to the "real" root and current contexts
# just as if we were outside of include/define:
{{ with index . 1 }}
{{- if $.Values.config.BatchEnsemblingConfig.Enabled }}
BatchEnsemblingConfig:
  ImageBuildingConfig:
    KanikoConfig:
      BuildContextURI: {{ printf "%s/%s" "git://github.com/caraml-dev/turing.git#refs/tags" $tag }}
{{- end }}
EnsemblerServiceBuilderConfig:
  ImageBuildingConfig:
    KanikoConfig: &kanikoConfig
      BuildContextURI: {{ printf "%s/%s" "git://github.com/caraml-dev/turing.git#refs/tags" $tag }}
RouterDefaults:
  Image: {{ .Values.deployment.image.registry }}/caraml-dev/turing/turing-router:{{ printf "%s" $tag }}
{{- end }}
{{- end }}
{{- end }}
