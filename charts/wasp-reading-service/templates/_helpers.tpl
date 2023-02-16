
{{/*
Return the proper wasp-reading-service image name
*/}}
{{- define "wasp-reading-service.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper init container image name
*/}}
{{- define "wasp-reading-service.initDbCreate.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.initDbCreate.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "wasp-reading-service.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.initDbCreate.image .Values.initReadings.image ) "global" .Values.global) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "wasp-reading-service.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "wasp-reading-service.postgresql.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "postgresql" "chartValues" .Values.postgresql "context" $) -}}
{{- end -}}

{{/*
Create a default fully qualified app name for Kafka subchart
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "wasp-reading-service.kafka.fullname" -}}
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
{{ include "wasp-reading-service.listenerType" ( dict "protocol" .Values.path.to.the.Value ) }}
*/}}
{{- define "wasp-reading-service.listenerType" -}}
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
{{- define "wasp-reading-service.kafka.brokers" -}}
{{- $releaseNamespace := .Release.Namespace -}}
{{- $clusterDomain := .Values.clusterDomain -}}
{{- $kafkaReplicaCount := int .Values.kafka.replicaCount -}}
{{- $kafkaFullname := include "wasp-reading-service.kafka.fullname" . -}}
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
{{- define "wasp-reading-service.kafka.bootstrapBroker" -}}
{{- $releaseNamespace := .Release.Namespace -}}
{{- $clusterDomain := .Values.clusterDomain -}}
{{- $kafkaFullname := include "wasp-reading-service.kafka.fullname" . -}}
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
{{- define "wasp-reading-service.initReadings.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.initReadings.image "global" .Values.global) }}
{{- end -}}


{{/*
Return the Postgresql hostname
*/}}
{{- define "wasp-reading-service.databaseHost" -}}
{{- ternary (include "wasp-reading-service.postgresql.fullname" .) .Values.externalDatabase.host .Values.postgresql.enabled | quote -}}
{{- end -}}

{{/*
Return the Postgresql port
*/}}
{{- define "wasp-reading-service.databasePort" -}}
{{- ternary "5432" .Values.externalDatabase.port .Values.postgresql.enabled | quote -}}
{{- end -}}

{{/*
Return the Postgresql database name
*/}}
{{- define "wasp-reading-service.databaseName" -}}
{{- if .Values.postgresql.enabled -}}
    {{- if .Values.global.postgresql -}}
        {{- if .Values.global.postgresql.auth -}}
            {{- coalesce .Values.global.postgresql.auth.database .Values.postgresql.auth.database -}}
        {{- else -}}
            {{- .Values.postgresql.auth.database -}}
        {{- end -}}
    {{- else -}}
        {{- .Values.postgresql.auth.database -}}
    {{- end -}}
{{- else -}}
    {{- .Values.externalDatabase.database -}}
{{- end -}}
{{- end -}}

{{/*
Return the Postgresql user
*/}}
{{- define "wasp-reading-service.databaseUser" -}}
{{- if .Values.postgresql.enabled -}}
    {{- if .Values.global.postgresql -}}
        {{- if .Values.global.postgresql.auth -}}
            {{- coalesce .Values.global.postgresql.auth.username .Values.postgresql.auth.username -}}
        {{- else -}}
            {{- .Values.postgresql.auth.username -}}
        {{- end -}}
    {{- else -}}
        {{- .Values.postgresql.auth.username -}}
    {{- end -}}
{{- else -}}
    {{- .Values.externalDatabase.user -}}
{{- end -}}
{{- end -}}

{{/*
Return the PostgreSQL Secret Name
*/}}
{{- define "wasp-reading-service.databaseSecretName" -}}
{{- if .Values.postgresql.enabled -}}
    {{- if .Values.global.postgresql -}}
        {{- if .Values.global.postgresql.auth -}}
            {{- if .Values.global.postgresql.auth.existingSecret -}}
                {{- tpl .Values.global.postgresql.auth.existingSecret $ -}}
            {{- else -}}
                {{- default (include "wasp-reading-service.postgresql.fullname" .) (tpl .Values.postgresql.auth.existingSecret $) -}}
            {{- end -}}
        {{- else -}}
            {{- default (include "wasp-reading-service.postgresql.fullname" .) (tpl .Values.postgresql.auth.existingSecret $) -}}
        {{- end -}}
    {{- else -}}
        {{- default (include "wasp-reading-service.postgresql.fullname" .) (tpl .Values.postgresql.auth.existingSecret $) -}}
    {{- end -}}
{{- else -}}
    {{- default (printf "%s-externaldb" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-") (tpl .Values.externalDatabase.existingSecret $) -}}
{{- end -}}
{{- end -}}

{{/*
Add environment variables to configure database values
*/}}
{{- define "wasp-reading-service.databaseSecretPasswordKey" -}}
{{- if .Values.postgresql.enabled -}}
    {{- print "password" -}}
{{- else -}}
    {{- if .Values.externalDatabase.existingSecret -}}
        {{- if .Values.externalDatabase.existingSecretPasswordKey -}}
            {{- printf "%s" .Values.externalDatabase.existingSecretPasswordKey -}}
        {{- else -}}
            {{- print "password" -}}
        {{- end -}}
    {{- else -}}
        {{- print "password" -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Add environment variables to configure database values
*/}}
{{- define "wasp-reading-service.databaseSecretPostgresPasswordKey" -}}
{{- if .Values.postgresql.enabled -}}
    {{- print "postgres-password" -}}
{{- else -}}
    {{- if .Values.externalDatabase.existingSecret -}}
        {{- if .Values.externalDatabase.existingSecretPostgresPasswordKey -}}
            {{- printf "%s" .Values.externalDatabase.existingSecretPostgresPasswordKey -}}
        {{- else -}}
            {{- print "postgres-password" -}}
        {{- end -}}
    {{- else -}}
        {{- print "postgres-password" -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "wasp-reading-service.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "wasp-reading-service.validateValues.databaseName" .) -}}
{{- $messages := append $messages (include "wasp-reading-service.validateValues.databaseUser" .) -}}
{{- $messages := append $messages (include "wasp-reading-service.validateValues.authentication.sasl" .) -}}
{{- $messages := append $messages (include "wasp-reading-service.validateValues.authentication.tls" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate database name */}}
{{- define "wasp-reading-service.validateValues.databaseName" -}}
{{- if and (not .Values.postgresql.enabled) .Values.externalDatabase.create -}}
{{- $db_name := (include "wasp-reading-service.databaseName" .) -}}
{{- if not (regexMatch "^[a-zA-Z_]+$" $db_name) -}}
wasp-reading-service:
    When creating a database the database name must consist of the characters a-z, A-Z and _ only
{{- end -}}
{{- end -}}
{{- end -}}

{{/* Validate database username */}}
{{- define "wasp-reading-service.validateValues.databaseUser" -}}
{{- if and (not .Values.postgresql.enabled) .Values.externalDatabase.create -}}
{{- $db_user := (include "wasp-reading-service.databaseUser" .) -}}
{{- if not (regexMatch "^[a-zA-Z_]+$" $db_user) -}}
wasp-reading-service:
    When creating a database the username must consist of the characters a-z, A-Z and _ only
{{- end -}}
{{- end -}}
{{- end -}}


{{/* Validate values of Schema Registry - SASL authentication */}}
{{- define "wasp-reading-service.validateValues.authentication.sasl" -}}
{{- $kafkaProtocol := include "wasp-reading-service.listenerType" ( dict "protocol" (ternary .Values.kafka.auth.clientProtocol .Values.externalKafka.auth.protocol .Values.kafka.enabled) ) -}}
{{- if .Values.kafka.enabled }}
{{- if and (contains "SASL" $kafkaProtocol) (or (not .Values.kafka.auth.sasl.jaas.clientUsers) (not .Values.kafka.auth.sasl.jaas.clientPasswords)) }}
wasp-reading-service: kafka.auth.jaas.clientUsers kafka.auth.jaas.clientPasswords
    It's mandatory to set the SASL credentials when enabling SASL authentication with Kafka brokers.
    You can specify these credentials setting the parameters below:
      - kafka.auth.jaas.clientUsers
      - kafka.auth.jaas.clientPasswords
{{- end }}
{{- else if and (contains "SASL" $kafkaProtocol) (or (not .Values.externalKafka.auth.jaas.user) (not .Values.externalKafka.auth.jaas.password)) }}
wasp-reading-service: externalKafka.auth.jaas.user externalKafka.auth.jaas.password
    It's mandatory to set the SASL credentials when enabling SASL authentication with Kafka brokers.
    You can specify these credentials setting the parameters below:
      - externalKafka.auth.jaas.user
      - externalKafka.auth.jaas.password
{{- end -}}
{{- end -}}

{{/* Validate values of Schema Registry - TLS authentication */}}
{{- define "wasp-reading-service.validateValues.authentication.tls" -}}
{{- $kafkaProtocol := include "wasp-reading-service.listenerType" ( dict "protocol" (ternary .Values.kafka.auth.clientProtocol .Values.externalKafka.auth.protocol .Values.kafka.enabled) ) -}}
{{- if and (contains "SSL" $kafkaProtocol) (not .Values.kafka.auth.jksSecret) }}
kafka: auth.kafka.jksSecret
    A secret containing the Schema Registry JKS files is required when TLS encryption in enabled
{{- end -}}
{{- end -}}
