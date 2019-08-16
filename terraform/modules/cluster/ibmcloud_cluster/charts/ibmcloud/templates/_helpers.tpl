{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "ibmcloud.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ibmcloud.fullname" -}}
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

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "ibmcloud.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "ibmcloud.registry_namespace" -}}
{{ .Values.registry_namespace | default .Values.resource_group | quote }}
{{- end -}}

{{- define "ibmcloud.cluster_name" -}}
{{- if .Values.cluster_name -}}
{{- .Values.cluster_name -}}
{{- else -}}
{{- printf "%s-%s" .Values.resource_group "cluster" | quote -}}
{{- end -}}
{{- end -}}

{{- define "ibmcloud.tls_secret_name" -}}
{{- if .Values.tls_secret_name -}}
{{- .Values.tls_secret_name -}}
{{- else -}}
{{- include "ibmcloud.cluster_name" . -}}
{{- end -}}
{{- end -}}
