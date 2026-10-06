{{- define "tls-ingress.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "tls-ingress.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else if contains (include "tls-ingress.name" .) .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name (include "tls-ingress.name" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{- define "tls-ingress.labels" -}}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version }}
{{ include "tls-ingress.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "tls-ingress.selectorLabels" -}}
app.kubernetes.io/name: {{ include "tls-ingress.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "tls-ingress.issuerName" -}}
{{- $env := .Values.certIssuer.environment -}}
{{- if not (has $env (list "staging" "production")) -}}
{{- fail "certIssuer.environment must be 'staging' or 'production'" -}}
{{- end -}}
letsencrypt-{{ $env }}
{{- end }}
