{{- define "turing.renderedConfig" -}}
{{- $ := index . 0 }}
{{- $rendered := index . 2}}
{{- if $rendered }}
{{- $tag := $rendered.releasedVersion}}
{{- $ensemblerTag := $rendered.ensemblerTag }}
{{- $imagePrefix := "ghcr.io/caraml-dev/turing/pyfunc-ensembler-job-py" -}}
{{- $imagePrefix2 := "ghcr.io/caraml-dev/turing/pyfunc-ensembler-service-py" -}}
BatchEnsemblingConfig:
  ImageBuildingConfig: &imageBuildingConfig
    DestinationRegistry: asia.gcr.io/gods-production/turing/ensemblers
    BaseImageRef:
      3.7.*: {{ printf "%s%s:%s" $imagePrefix "3.7" $ensemblerTag }}
      3.8.*: {{ printf "%s%s:%s" $imagePrefix "3.8" $ensemblerTag }}
      3.9.*: {{printf "%s%s:%s" $imagePrefix "3.9" $ensemblerTag }}
      3.10.*: {{ printf "%s%s:%s" $imagePrefix "3.10" $ensemblerTag }}
  KanikoConfig: &kanikoConfig
    BuildContextURI: {{ printf "%s/%s" "git://github.com/caraml-dev/turing.git#refs/tags/v" $tag }}
EnsemblerServiceBuilderConfig:
  ClusterName: products-production
  ImageBuildingConfig:
    BaseImageRef:
        3.7.*: {{ printf "%s%s:%s" $imagePrefix2 "3.7" $ensemblerTag }}
        3.8.*: {{ printf "%s%s:%s" $imagePrefix2 "3.8" $ensemblerTag }}
        3.9.*: {{printf "%s%s:%s" $imagePrefix2 "3.9" $ensemblerTag }}
        3.10.*: {{ printf "%s%s:%s" $imagePrefix2 "3.10" $ensemblerTag }}
    KanikoConfig:
      <<: *kanikoConfig
RouterDefaults:
  Image: ghcr.io/caraml-dev/turing/turing-router:v{{ printf "%s" $tag }}
{{- end -}}
{{- end -}}
