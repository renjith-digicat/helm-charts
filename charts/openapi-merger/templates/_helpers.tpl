
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

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "openapi-merger.validateValues" -}}
{{- $messages := list -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}
