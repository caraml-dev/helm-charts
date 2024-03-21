{{- define "merlin.contextRef" -}}
{{- $ := index . 0 }}
{{- $reference := index . 1 }}
{{ $.Values.imageBuilder.contextRef | default (printf "refs/tags/%s" $reference) }}
{{- end -}}

{{- define "merlin.renderedConfig" -}}
{{- $ := index . 0 }}
{{- $rendered := index . 2}}
{{- if len $rendered | ne 0 }}
# this is because merlin artifact versions have no v prefix
# NOTE: Remove the substr once merlin artifacts are released with v prefix
{{- $tag := $rendered.releasedVersion | substr 1 (len $rendered.releasedVersion) }}
{{- $reference := include "merlin.contextRef" (list $ $rendered.releasedVersion) | trim }}
{{ with index . 1 }}
# Now we have access to the "real" root and current contexts
# just as if we were outside of include/define:
ImageBuilderConfig:
  BaseImage:
    ImageName: {{ .Values.deployment.image.registry }}/caraml-dev/merlin/merlin-pyfunc-base:{{ printf "%s" $tag }}
    DockerfilePath: "pyfunc-server/docker/Dockerfile"
    BuildContextURI: "git://github.com/caraml-dev/merlin.git#{{ printf "%s" $reference }}"
    BuildContextSubPath: "python"
  PredictionJobBaseImage:
    ImageName: {{ .Values.deployment.image.registry }}/caraml-dev/merlin/merlin-pyspark-base:{{ printf "%s" $tag }}
    DockerfilePath: "batch-predictor/docker/app.Dockerfile"
    BuildContextURI: "git://github.com/caraml-dev/merlin.git#{{ printf "%s" $reference }}"
    BuildContextSubPath: "python"
    MainAppPath: "/home/spark/main.py"
StandardTransformerConfig:
  ImageName: {{ .Values.deployment.image.registry }}/caraml-dev/merlin-transformer:{{ printf "%s" $tag }}
ObservabilityPublisher:
  ImageName: {{ .Values.deployment.image.registry }}/caraml-dev/merlin/merlin-observation-publisher:{{ printf "%s" $tag }}
{{- end -}}
{{- end -}}
{{- end -}}
