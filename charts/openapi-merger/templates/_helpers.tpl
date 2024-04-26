
{{/*
Return the proper openapi-merger image name
*/}}
{{- define "openapi-merger.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "openapi-merger.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.cronjob.initImage .Values.cronjob.image ) "global" .Values.global) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "openapi-merger.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the proper cronjob init container image name
*/}}
{{- define "openapi-merger.cronjob.initImage" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.cronjob.initImage "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper cronjob container image name
*/}}
{{- define "openapi-merger.cronjob.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.cronjob.image "global" .Values.global) }}
{{- end -}}

{{- define "openapi-merger.base.securitySchemes" -}}
{{- $output := dict -}}
{{- if .Values.securitySchema.enabled -}}
    {{- $securitySchema := dict .Values.securitySchema.name (omit .Values.securitySchema "name") -}}
    {{- range $securityScheme := .Values.extraSecuritySchemas -}}
        {{- $_ := set $securitySchema $securityScheme.name (omit . "name") -}}
    {{- end -}}

    {{- range $name, $scheme := $securitySchema -}}
        {{- if eq $scheme.type "bearer" -}}
            {{- $value := dict "type" "http" "scheme" "bearer" "bearerFormat" $scheme.bearer.format -}}
            {{- $_ := set $output $name $value -}}
        {{- end -}}

        {{- if eq $scheme.type "oauth2" -}}
            {{- $flowsValue := dict -}}
            {{- range $flow := $scheme.oauth2.flows -}}
                {{- if eq $flow "authorizationCode" -}}
                    {{- $flowValue := dict -}}
                    {{- $_ := set $flowValue "authorizationUrl" $scheme.oauth2.authorizationUrl -}}
                    {{- $_ := set $flowValue "tokenUrl" $scheme.oauth2.tokenUrl -}}
                    {{- if $scheme.oauth2.refreshUrl -}}
                        {{- $_ := set $flowValue "refreshUrl" $scheme.oauth2.refreshUrl -}}
                    {{- end -}}
                    {{- if $scheme.oauth2.scopes -}}
                        {{- $_ := set $flowValue "scopes" $scheme.oauth2.scopes -}}
                    {{- end -}}
                    {{ $_ := set $flowsValue $flow $flowValue }}
                {{- end -}}

                {{- if eq $flow "implicit" -}}
                    {{- $flowValue := dict -}}
                    {{- $_ := set $flowValue "authorizationUrl" $scheme.oauth2.authorizationUrl -}}
                    {{- if $scheme.oauth2.refreshUrl -}}
                        {{- $_ := set $flowValue "refreshUrl" $scheme.oauth2.refreshUrl -}}
                    {{- end -}}
                    {{- if $scheme.oauth2.scopes -}}
                        {{- $_ := set $flowValue "scopes" $scheme.oauth2.scopes -}}
                    {{- end -}}
                    {{ $_ := set $flowsValue $flow $flowValue }}
                {{- end -}}

                {{- if or (eq $flow "password") (eq $flow "clientCredentials") -}}
                    {{- $flowValue := dict -}}
                    {{- $_ := set $flowValue "tokenUrl" $scheme.oauth2.tokenUrl -}}
                    {{- if $scheme.oauth2.refreshUrl -}}
                        {{- $_ := set $flowValue "refreshUrl" $scheme.oauth2.refreshUrl -}}
                    {{- end -}}
                    {{- if $scheme.oauth2.scopes -}}
                        {{- $_ := set $flowValue "scopes" $scheme.oauth2.scopes -}}
                    {{- end -}}
                    {{ $_ := set $flowsValue $flow $flowValue }}
                {{- end -}}
            {{- end -}}

            {{- $value := dict "type" "oauth2" "flows" $flowsValue -}}
            {{- $_ := set $output $name $value -}}
        {{- end -}}
    {{- end -}}
{{- end -}}
{{- $output | toJson -}}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "openapi-merger.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "openapi-merger.validateValues.securitySchema" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{- define "openapi-merger.validateValues.securitySchema" -}}
{{- if .Values.securitySchema.enabled -}}
{{- include "openapi-merger.validateValues.securitySchema.names" . }}
{{- include "openapi-merger.validateValues.securitySchema.types" . }}
{{- include "openapi-merger.validateValues.securitySchema.oauth2" . }}
{{- include "openapi-merger.validateValues.securitySchema.bearer" . }}
{{- end -}}
{{- end -}}

{{- define "openapi-merger.validateValues.securitySchema.names" -}}
    {{- $securitySchema := dict .Values.securitySchema.name "" -}}
    {{- range $securityScheme := .Values.extraSecuritySchemas -}}
        {{- if hasKey $securitySchema $securityScheme.name -}}
securitySchema.names:
    duplicate security schema name detected "{{ $securityScheme.name }}"
        {{- end -}}
    {{- end -}}
{{- end -}}

{{- define "openapi-merger.validateValues.securitySchema.types" -}}
    {{- $securitySchema := dict .Values.securitySchema.name (omit .Values.securitySchema "name") -}}
    {{- range $securityScheme := .Values.extraSecuritySchemas -}}
        {{- $_ := set $securitySchema $securityScheme.name (omit . "name") -}}
    {{- end -}}

    {{- range $name, $securityScheme := $securitySchema -}}
        {{- if and (ne $securityScheme.type "bearer") (ne $securityScheme.type "oauth2") -}}
securitySchema.types:
    invalid security schema type "{{ $securityScheme.type }}" on securityScheme "{{ $name }}"
        {{- end -}}
    {{- end -}}
{{- end -}}

{{- define "openapi-merger.validateValues.securitySchema.oauth2" -}}
    {{- $securitySchema := dict .Values.securitySchema.name (omit .Values.securitySchema "name") -}}
    {{- range $securityScheme := .Values.extraSecuritySchemas -}}
        {{- $_ := set $securitySchema $securityScheme.name (omit . "name") -}}
    {{- end -}}

    {{- range $name, $securityScheme := $securitySchema -}}
        {{- if eq $securityScheme.type "oauth2" -}}
            {{- if not $securityScheme.oauth2 -}}
securitySchema.oauth2:
    Missing oauth2 configuration for {{ $name }}
            {{- else -}}
                {{- if ne 0 (len (without $securityScheme.oauth2.flows "authorizationCode" "implicit" "password" "clientCredentials")) -}}
securitySchema.oauth2:
    Invalid oauth2 flows provided {{ without $securityScheme.oauth2.flows "authorizationCode" "implicit" "password" "clientCredentials" }} for {{ $name }}
                {{- end -}}

                {{- if and (or (has "authorizationCode" $securityScheme.oauth2.flows) (has "implicit" $securityScheme.oauth2.flows)) (not (hasKey $securityScheme.oauth2 "authorizationUrl")) -}}
securitySchema.oauth2:
    Missing oauth2 parameter "authorizationUrl" for scheme {{ $name }}. This error has occured because flows contains either "authorizationCode" or "implicit"
                {{- end -}}

                {{- if and (or (has "authorizationCode" $securityScheme.oauth2.flows) (has "password" $securityScheme.oauth2.flows) (has "clientCredentials" $securityScheme.oauth2.flows)) (not (hasKey $securityScheme.oauth2 "tokenUrl")) -}}
securitySchema.oauth2:
    Missing oauth2 parameter "tokenUrl" for scheme {{ $name }}. This error has occured because flows contains either "authorizationCode", "password" or "clientCredentials"
                {{- end -}}
            {{- end -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{- define "openapi-merger.validateValues.securitySchema.bearer" -}}
    {{- $securitySchema := dict .Values.securitySchema.name (omit .Values.securitySchema "name") -}}
    {{- range $securityScheme := .Values.extraSecuritySchemas -}}
        {{- $_ := set $securitySchema $securityScheme.name (omit . "name") -}}
    {{- end -}}

    {{- range $name, $securityScheme := $securitySchema -}}
        {{- if eq $securityScheme.type "bearer" -}}
            {{- if not $securityScheme.bearer -}}
securitySchema.bearer:
    Missing bearer configuration for {{ $name }}
            {{- else -}}
                {{- if not (hasKey $securityScheme.bearer "format") -}}
securitySchema.bearer:
    Missing bearer parameter "format" for scheme {{ $name }}.
                {{- end -}}
            {{- end -}}
        {{- end -}}
    {{- end -}}
{{- end -}}
