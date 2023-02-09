{{/*
Return the proper wasp-authentication-service image name
*/}}
{{- define "wasp-authentication-service.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper init container image name
*/}}
{{- define "wasp-authentication-service.initDbCreate.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.initDbCreate.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "wasp-authentication-service.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.initDbCreate.image ) "global" .Values.global) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "wasp-authentication-service.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the jwt secret
*/}}
{{- define "wasp-authentication-service.jwtSecretName" -}}
{{- if .Values.existingJwtSecret -}}
    {{- printf "%s" (tpl .Values.existingJwtSecret $) -}}
{{- else -}}
    {{- printf "%s-jwt" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Retrieve jwtsecret key
*/}}
{{- define "wasp-authentication-service.jwtSecretKey" -}}
    {{- if .Values.existingJwtSecret -}}
        {{- printf "%s" .Values.existingJwtSecretKey -}}
    {{- else -}}
        {{- print "jwt-secret" -}}
    {{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "wasp-authentication-service.postgresql.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "postgresql" "chartValues" .Values.postgresql "context" $) -}}
{{- end -}}

{{/*
Return the Postgresql hostname
*/}}
{{- define "wasp-authentication-service.databaseHost" -}}
{{- ternary (include "wasp-authentication-service.postgresql.fullname" .) .Values.externalDatabase.host .Values.postgresql.enabled | quote -}}
{{- end -}}

{{/*
Return the Postgresql port
*/}}
{{- define "wasp-authentication-service.databasePort" -}}
{{- ternary "5432" .Values.externalDatabase.port .Values.postgresql.enabled | quote -}}
{{- end -}}

{{/*
Return the Postgresql database name
*/}}
{{- define "wasp-authentication-service.databaseName" -}}
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
{{- define "wasp-authentication-service.databaseUser" -}}
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
{{- define "wasp-authentication-service.databaseSecretName" -}}
{{- if .Values.postgresql.enabled -}}
    {{- if .Values.global.postgresql -}}
        {{- if .Values.global.postgresql.auth -}}
            {{- if .Values.global.postgresql.auth.existingSecret -}}
                {{- tpl .Values.global.postgresql.auth.existingSecret $ -}}
            {{- else -}}
                {{- default (include "wasp-authentication-service.postgresql.fullname" .) (tpl .Values.postgresql.auth.existingSecret $) -}}
            {{- end -}}
        {{- else -}}
            {{- default (include "wasp-authentication-service.postgresql.fullname" .) (tpl .Values.postgresql.auth.existingSecret $) -}}
        {{- end -}}
    {{- else -}}
        {{- default (include "wasp-authentication-service.postgresql.fullname" .) (tpl .Values.postgresql.auth.existingSecret $) -}}
    {{- end -}}
{{- else -}}
    {{- default (printf "%s-externaldb" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-") (tpl .Values.externalDatabase.existingSecret $) -}}
{{- end -}}
{{- end -}}

{{/*
Add environment variables to configure database values
*/}}
{{- define "wasp-authentication-service.databaseSecretPasswordKey" -}}
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
{{- define "wasp-authentication-service.databaseSecretPostgresPasswordKey" -}}
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
{{- define "wasp-authentication-service.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "wasp-authentication-service.validateValues.databaseName" .) -}}
{{- $messages := append $messages (include "wasp-authentication-service.validateValues.databaseUser" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate database name */}}
{{- define "wasp-authentication-service.validateValues.databaseName" -}}
{{- if and (not .Values.postgresql.enabled) .Values.externalDatabase.create -}}
{{- $db_name := (include "wasp-authentication-service.databaseName" .) -}}
{{- if not (regexMatch "^[a-zA-Z_]+$" $db_name) -}}
wasp-authentication-service:
    When creating a database the database name must consist of the characters a-z, A-Z and _ only
{{- end -}}
{{- end -}}
{{- end -}}

{{/* Validate database username */}}
{{- define "wasp-authentication-service.validateValues.databaseUser" -}}
{{- if and (not .Values.postgresql.enabled) .Values.externalDatabase.create -}}
{{- $db_user := (include "wasp-authentication-service.databaseUser" .) -}}
{{- if not (regexMatch "^[a-zA-Z_]+$" $db_user) -}}
wasp-authentication-service:
    When creating a database the username must consist of the characters a-z, A-Z and _ only
{{- end -}}
{{- end -}}
{{- end -}}
