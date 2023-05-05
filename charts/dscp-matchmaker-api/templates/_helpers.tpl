{{/*
Return the proper dscp-matchmaker-api image name
*/}}
{{- define "dscp-matchmaker-api.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper init container image name
*/}}
{{- define "dscp-matchmaker-api.initDbCreate.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.initDbCreate.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "dscp-matchmaker-api.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.initDbCreate.image ) "global" .Values.global) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "dscp-matchmaker-api.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name for dscp-node subchart
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "dscp-matchmaker-api.dscpNode.fullname" -}}
{{- if .Values.node.fullnameOverride -}}
{{- .Values.node.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "dscpnode-0" .Values.node.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}


{{/*
Return the dscp-node api hostname
*/}}
{{- define "dscp-matchmaker-api.dscpNodeHost" -}}
{{- ternary (include "dscp-matchmaker-api.dscpNode.fullname" .) .Values.externalDscpNode.host .Values.node.enabled | quote -}}
{{- end -}}

{{/*
Return the dscp-node API port
*/}}
{{- define "dscp-matchmaker-api.dscpNodePort" -}}
{{- ternary "9944" .Values.externalDscpNode.port .Values.node.enabled | quote -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "dscp-matchmaker-api.postgresql.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "postgresql" "chartValues" .Values.postgresql "context" $) -}}
{{- end -}}

{{/*
Return the Postgresql hostname
*/}}
{{- define "dscp-matchmaker-api.databaseHost" -}}
{{- ternary (include "dscp-matchmaker-api.postgresql.fullname" .) .Values.externalDatabase.host .Values.postgresql.enabled | quote -}}
{{- end -}}

{{/*
Return the Postgresql port
*/}}
{{- define "dscp-matchmaker-api.databasePort" -}}
{{- ternary "5432" .Values.externalDatabase.port .Values.postgresql.enabled | quote -}}
{{- end -}}

{{/*
Return the Postgresql database name
*/}}
{{- define "dscp-matchmaker-api.databaseName" -}}
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
{{- define "dscp-matchmaker-api.databaseUser" -}}
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
{{- define "dscp-matchmaker-api.databaseSecretName" -}}
{{- if .Values.postgresql.enabled -}}
    {{- if .Values.global.postgresql -}}
        {{- if .Values.global.postgresql.auth -}}
            {{- if .Values.global.postgresql.auth.existingSecret -}}
                {{- tpl .Values.global.postgresql.auth.existingSecret $ -}}
            {{- else -}}
                {{- default (include "dscp-matchmaker-api.postgresql.fullname" .) (tpl .Values.postgresql.auth.existingSecret $) -}}
            {{- end -}}
        {{- else -}}
            {{- default (include "dscp-matchmaker-api.postgresql.fullname" .) (tpl .Values.postgresql.auth.existingSecret $) -}}
        {{- end -}}
    {{- else -}}
        {{- default (include "dscp-matchmaker-api.postgresql.fullname" .) (tpl .Values.postgresql.auth.existingSecret $) -}}
    {{- end -}}
{{- else -}}
    {{- default (printf "%s-externaldb" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-") (tpl .Values.externalDatabase.existingSecret $) -}}
{{- end -}}
{{- end -}}

{{/*
Add environment variables to configure database values
*/}}
{{- define "dscp-matchmaker-api.databaseSecretPasswordKey" -}}
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
{{- define "dscp-matchmaker-api.databaseSecretPostgresPasswordKey" -}}
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
{{- define "dscp-matchmaker-api.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "dscp-matchmaker-api.validateValues.databaseName" .) -}}
{{- $messages := append $messages (include "dscp-matchmaker-api.validateValues.databaseUser" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate database name */}}
{{- define "dscp-matchmaker-api.validateValues.databaseName" -}}
{{- if and (not .Values.postgresql.enabled) .Values.externalDatabase.create -}}
{{- $db_name := (include "dscp-matchmaker-api.databaseName" .) -}}
{{- if not (regexMatch "^[a-zA-Z_]+$" $db_name) -}}
dscp-matchmaker-api:
    When creating a database the database name must consist of the characters a-z, A-Z and _ only
{{- end -}}
{{- end -}}
{{- end -}}

{{/* Validate database username */}}
{{- define "dscp-matchmaker-api.validateValues.databaseUser" -}}
{{- if and (not .Values.postgresql.enabled) .Values.externalDatabase.create -}}
{{- $db_user := (include "dscp-matchmaker-api.databaseUser" .) -}}
{{- if not (regexMatch "^[a-zA-Z_]+$" $db_user) -}}
dscp-matchmaker-api:
    When creating a database the username must consist of the characters a-z, A-Z and _ only
{{- end -}}
{{- end -}}
{{- end -}}
