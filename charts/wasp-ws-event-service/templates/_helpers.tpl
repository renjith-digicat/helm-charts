
{{/*
Return the proper wasp-ws-event-service image name
*/}}
{{- define "wasp-ws-event-service.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "wasp-ws-event-service.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.initEventNotifications.image ) "global" .Values.global) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "wasp-ws-event-service.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name for Kafka subchart
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "wasp-ws-event-service.kafka.fullname" -}}
{{- if .Values.kafka.fullnameOverride -}}
{{- .Values.kafka.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "kafka" .Values.kafka.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return the type of listener
Usage:
{{ include "wasp-ws-event-service.kafka.listenerType" ( dict "protocol" .Values.path.to.the.Value ) }}
*/}}
{{- define "wasp-ws-event-service.kafka.listenerType" -}}
{{- if eq .protocol "plaintext" -}}
PLAINTEXT
{{- else if or (eq .protocol "tls") (eq .protocol "mtls") -}}
SSL
{{- else if eq .protocol "sasl_tls" -}}
SASL_SSL
{{- else if eq .protocol "sasl" -}}
SASL_PLAINTEXT
{{- end -}}
{{- end -}}

{{/*
Create a comma separated list of kafka brokers to be used as the brokers list
*/}}
{{- define "wasp-ws-event-service.kafka.brokers" -}}
{{- $releaseNamespace := .Release.Namespace -}}
{{- $clusterDomain := .Values.clusterDomain -}}
{{- $kafkaReplicaCount := int .Values.kafka.replicaCount -}}
{{- $kafkaFullname := include "wasp-ws-event-service.kafka.fullname" . -}}
{{- $kafkaPort := int .Values.kafka.service.ports.client -}}
{{- if .Values.kafka.enabled -}}
{{- $brokers := list -}}
{{- range $e, $i := until $kafkaReplicaCount -}}
{{- $brokers = append $brokers (printf "%s-%d.%s-headless.%s.svc.%s:%d" $kafkaFullname $i $kafkaFullname $releaseNamespace $clusterDomain $kafkaPort) -}}
{{- end -}}
{{- join "," $brokers | quote -}}
{{- else -}}
{{- join "," .Values.externalKafka.brokers | quote -}}
{{- end -}}
{{- end -}}

{{/*
Kafka broker to be used to bootstrap initialisation
*/}}
{{- define "wasp-ws-event-service.kafka.bootstrapBroker" -}}
{{- $releaseNamespace := .Release.Namespace -}}
{{- $clusterDomain := .Values.clusterDomain -}}
{{- $kafkaFullname := include "wasp-ws-event-service.kafka.fullname" . -}}
{{- $kafkaPort := int .Values.kafka.service.ports.client -}}
{{- if .Values.kafka.enabled -}}
{{- printf "%s-%d.%s-headless.%s.svc.%s:%d" $kafkaFullname 0 $kafkaFullname $releaseNamespace $clusterDomain $kafkaPort -}}
{{- else -}}
{{- first .Values.externalKafka.brokers -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper init container image name
*/}}
{{- define "wasp-ws-event-service.initEventNotifications.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.initEventNotifications.image "global" .Values.global) }}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "wasp-ws-event-service.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "wasp-ws-event-service.validateValues.authentication.sasl" .) -}}
{{- $messages := append $messages (include "wasp-ws-event-service.validateValues.authentication.tls" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Schema Registry - SASL authentication */}}
{{- define "wasp-ws-event-service.validateValues.authentication.sasl" -}}
{{- $kafkaProtocol := include "wasp-ws-event-service.kafka.listenerType" ( dict "protocol" (ternary .Values.kafka.auth.clientProtocol .Values.externalKafka.auth.protocol .Values.kafka.enabled) ) -}}
{{- if .Values.kafka.enabled }}
{{- if and (contains "SASL" $kafkaProtocol) (or (not .Values.kafka.auth.sasl.jaas.clientUsers) (not .Values.kafka.auth.sasl.jaas.clientPasswords)) }}
wasp-ws-event-service: kafka.auth.jaas.clientUsers kafka.auth.jaas.clientPasswords
    It's mandatory to set the SASL credentials when enabling SASL authentication with Kafka brokers.
    You can specify these credentials setting the parameters below:
      - kafka.auth.jaas.clientUsers
      - kafka.auth.jaas.clientPasswords
{{- end }}
{{- else if and (contains "SASL" $kafkaProtocol) (or (not .Values.externalKafka.auth.jaas.user) (not .Values.externalKafka.auth.jaas.password)) }}
wasp-ws-event-service: externalKafka.auth.jaas.user externalKafka.auth.jaas.password
    It's mandatory to set the SASL credentials when enabling SASL authentication with Kafka brokers.
    You can specify these credentials setting the parameters below:
      - externalKafka.auth.jaas.user
      - externalKafka.auth.jaas.password
{{- end -}}
{{- end -}}

{{/* Validate values of Schema Registry - TLS authentication */}}
{{- define "wasp-ws-event-service.validateValues.authentication.tls" -}}
{{- $kafkaProtocol := include "wasp-ws-event-service.kafka.listenerType" ( dict "protocol" (ternary .Values.kafka.auth.clientProtocol .Values.externalKafka.auth.protocol .Values.kafka.enabled) ) -}}
{{- if and (contains "SSL" $kafkaProtocol) (not .Values.kafka.auth.jksSecret) }}
kafka: auth.kafka.jksSecret
    A secret containing the Schema Registry JKS files is required when TLS encryption in enabled
{{- end -}}
{{- end -}}
