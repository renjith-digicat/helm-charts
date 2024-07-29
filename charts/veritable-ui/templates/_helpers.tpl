{{/*
Return the proper veritable-ui image name
*/}}
{{- define "veritable-ui.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper init container image name
*/}}
{{- define "veritable-ui.initDbCreate.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.initDbCreate.image "global" .Values.global) }}
{{- end -}}


{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "veritable-ui.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.initDbCreate.image ) "global" .Values.global) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "veritable-ui.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name for the session cookies.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "veritable-ui.cookieSessionKeys.fullname" -}}
{{- printf "%s-cookie-session-keys" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-"  -}}
{{- end -}}

{{/*
Return the cookie session keys Secret Name
*/}}
{{- define "veritable-ui.cookieSessionKeysSecretName" -}}
{{- if .Values.cookieSessionKeys.existingSecret -}}
    {{- tpl .Values.cookieSessionKeys.existingSecret $ -}}
{{- else -}}
    {{- include "veritable-ui.cookieSessionKeys.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Add environment variables to configure cookie session keys 
*/}}
{{- define "veritable-ui.cookieSessionKeysSecretKey" -}}
{{- if .Values.cookieSessionKeys.existingSecretKey -}}
    {{- printf "%s" .Values.cookieSessionKeys.existingSecretKey -}}
{{- else -}}
    {{- print "secret" -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name for the session cookies.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "veritable-ui.invitationPin.fullname" -}}
{{- printf "%s-invitation-pin" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-"  -}}
{{- end -}}

{{/*
Return the invitation pin Secret Name
*/}}
{{- define "veritable-ui.invitationPinSecretName" -}}
{{- if .Values.invitationPin.existingSecret -}}
    {{- tpl .Values.invitationPin.existingSecret $ -}}
{{- else -}}
    {{- include "veritable-ui.invitationPin.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Add environment variables to configure invitation pin keys 
*/}}
{{- define "veritable-ui.invitationPinSecretKey" -}}
{{- if .Values.invitationPin.existingSecretKey -}}
    {{- printf "%s" .Values.invitationPin.existingSecretKey -}}
{{- else -}}
    {{- print "pin" -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name for the company house.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "veritable-ui.companysHouseApiKey.fullname" -}}
{{- printf "%s-company-house-api-key" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-"  -}}
{{- end -}}


{{/*
Return the company profile API key secret name
*/}}
{{- define "veritable-ui.companyHouseApiKeySecretName" -}}
{{- if .Values.companysHouseApiKey.existingSecret -}}
    {{- tpl .Values.companysHouseApiKey.existingSecret $ -}}
{{- else -}}
    {{- include "veritable-ui.companysHouseApiKey.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Add environment variables to configure company house api secret key
*/}}
{{- define "veritable-ui.companyHouseApiKeySecretKey" -}}
{{- if .Values.companysHouseApiKey.existingSecretKey -}}
    {{- printf "%s" .Values.companysHouseApiKey.existingSecretKey -}}
{{- else -}}
    {{- print "secret" -}}
{{- end -}}
{{- end -}}


{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "veritable-ui.postgresql.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "postgresql" "chartValues" .Values.postgresql "context" $) -}}
{{- end -}}

{{/*
Return the Postgresql hostname
*/}}
{{- define "veritable-ui.databaseHost" -}}
{{- ternary (include "veritable-ui.postgresql.fullname" .) .Values.externalDatabase.host .Values.postgresql.enabled | quote -}}
{{- end -}}


{{/*
Return the Postgresql port
*/}}
{{- define "veritable-ui.databasePort" -}}
{{- ternary "5432" .Values.externalDatabase.port .Values.postgresql.enabled | quote -}}
{{- end -}}

{{/*
Return the Postgresql database name
*/}}
{{- define "veritable-ui.databaseName" -}}
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
{{- define "veritable-ui.databaseUser" -}}
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
{{- define "veritable-ui.databaseSecretName" -}}
{{- if .Values.postgresql.enabled -}}
    {{- if .Values.global.postgresql -}}
        {{- if .Values.global.postgresql.auth -}}
            {{- if .Values.global.postgresql.auth.existingSecret -}}
                {{- tpl .Values.global.postgresql.auth.existingSecret $ -}}
            {{- else -}}
                {{- default (include "veritable-ui.postgresql.fullname" .) (tpl .Values.postgresql.auth.existingSecret $) -}}
            {{- end -}}
        {{- else -}}
            {{- default (include "veritable-ui.postgresql.fullname" .) (tpl .Values.postgresql.auth.existingSecret $) -}}
        {{- end -}}
    {{- else -}}
        {{- default (include "veritable-ui.postgresql.fullname" .) (tpl .Values.postgresql.auth.existingSecret $) -}}
    {{- end -}}
{{- else -}}
    {{- default (printf "%s-externaldb" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-") (tpl .Values.externalDatabase.existingSecret $) -}}
{{- end -}}
{{- end -}}

{{/*
Add environment variables to configure database values
*/}}
{{- define "veritable-ui.databaseSecretPasswordKey" -}}
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
{{- define "veritable-ui.databaseSecretPostgresPasswordKey" -}}
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
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "veritable-ui.cloudagent.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "cloudagent" "chartValues" .Values.cloudagent "context" $) -}}
{{- end -}}

{{/*
Return the veritable-cloudagent hostname
*/}}
{{- define "veritable-ui.cloudagentHost" -}}
{{- ternary (printf "%s-admin" (include "veritable-ui.cloudagent.fullname" . )) .Values.externalCloudagent.host .Values.cloudagent.enabled -}}
{{- end -}}


{{/*
return the veritable-cloudagent admin http uri
*/}}
{{- define "veritable-ui.cloudagentAdminHttpUri" -}}
{{- $host := include "veritable-ui.cloudagentHost" . -}}
{{- $port := include "veritable-ui.cloudagentPort" . | replace "\"" "" -}}
{{- printf "http://%s:%s" $host $port -}}
{{- end -}}

{{/*
return the veritable-cloudagent admin ws uri
*/}}
{{- define "veritable-ui.cloudagentAdminWsUri" -}}
{{- $host := include "veritable-ui.cloudagentHost" . -}}
{{- $port := include "veritable-ui.cloudagentPort" . | replace "\"" "" -}}
{{- printf "ws://%s:%s" $host $port -}}
{{- end -}}

{{/*
Return the veritable-cloudagent port
*/}}
{{- define "veritable-ui.cloudagentPort" -}}
{{- ternary "3000" .Values.externalCloudagent.port .Values.cloudagent.enabled | quote -}}
{{- end -}}



{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "veritable-ui.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "veritable-ui.validateValues.databaseName" .) -}}
{{- $messages := append $messages (include "veritable-ui.validateValues.databaseUser" .) -}}
{{- $messages := append $messages (include "veritable-ui.validateSecretKeys" .) -}}
{{- $messages := append $messages (include "veritable-ui.validateSecretValues" .) -}}
{{- $messages := append $messages (include "veritable-ui.validateCloudagentHost" . ) -}}
{{- $messages := append $messages (include "veritable-ui.validateCloudagentPort" . ) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate database name */}}
{{- define "veritable-ui.validateValues.databaseName" -}}
{{- if and (not .Values.postgresql.enabled) .Values.externalDatabase.create -}}
{{- $db_name := (include "veritable-ui.databaseName" .) -}}
{{- if not (regexMatch "^[a-zA-Z_]+$" $db_name) -}}
veritable-ui:
    When creating a database the database name must consist of the characters a-z, A-Z and _ only
{{- end -}}
{{- end -}}
{{- end -}}

{{/* Validate database username */}}
{{- define "veritable-ui.validateValues.databaseUser" -}}
{{- if and (not .Values.postgresql.enabled) .Values.externalDatabase.create -}}
{{- $db_user := (include "veritable-ui.databaseUser" .) -}}
{{- if not (regexMatch "^[a-zA-Z_]+$" $db_user) -}}
veritable-ui:
    When creating a database the username must consist of the characters a-z, A-Z and _ only
{{- end -}}
{{- end -}}
{{- end -}}



{{/* Validate if secret keys are being set or if a pre-existing secret is being used*/}}
{{- define "veritable-ui.validateSecretKeys" -}}
{{- if .Values.cookieSessionKeys.existingSecret -}}
{{- if not .Values.cookieSessionKeys.existingSecretKey -}}
veritable-ui:
    If an existing secret is being used for the cookie session keys, a key must be provided
{{- end -}}
{{- end -}}
{{- if .Values.invitationPin.existingSecret -}}
{{- if not .Values.invitationPin.existingSecretKey -}}
veritable-ui:
    If an existing secret is being used for the invitation pin, a key must be provided
{{- end -}}
{{- end -}}
{{- if .Values.companysHouseApiKey.existingSecret -}}
{{- if not .Values.companysHouseApiKey.existingSecretKey -}}
veritable-ui:
    If an existing secret is being used for the company house api key, a key must be provided
{{- end -}}
{{- end -}}
{{- end -}}

{{/* Validate if the value of a secret is being set, if it is not, the existing secret must be set instead*/}}
{{- define "veritable-ui.validateSecretValues" -}}
{{- if not .Values.cookieSessionKeys.existingSecret -}}
{{- if not .Values.cookieSessionKeys.secret -}}
veritable-ui:
    If a secret is not being used for the cookie session keys, a value must be provided
{{- end -}}
{{- end -}}
{{- if not .Values.invitationPin.existingSecret -}}
{{- if not .Values.invitationPin.secret -}}
veritable-ui:
    If a secret is not being used for the invitation pin, a value must be provided
{{- end -}}
{{- end -}}
{{- if not .Values.companysHouseApiKey.existingSecret -}}
{{- if not .Values.companysHouseApiKey.secret -}}
veritable-ui:
    If a secret is not being used for the company house api key, a value must be provided
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Validate if either the cloudagent has been enabled or if an externalCloudagent.host has been set
*/}}
{{- define "veritable-ui.validateCloudagentHost" -}}
{{- if not (or .Values.cloudagent.enabled .Values.externalCloudagent.host) -}}
veritable-ui:
    Either cloudagent.enabled must be true or externalCloudagent.host must be set.
{{- end -}}
{{- end -}}

{{/*
Validate if either the cloudagent has been enabled or if an externalCloudagent.port has been set
*/}}
{{- define "veritable-ui.validateCloudagentPort" -}}
{{- if not (or .Values.cloudagent.enabled .Values.externalCloudagent.port) -}}
veritable-ui:
    Either cloudagent.enabled must be true or externalCloudagent.port must be set.
{{- end -}}
{{- end -}}