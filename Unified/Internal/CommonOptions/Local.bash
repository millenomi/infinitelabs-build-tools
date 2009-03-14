#!/bin/bash

LOCAL_OPTIONS_FILE="$INFINITELABS_UNIFIED_DIR"/"$INFINITELABS_UNIFIED_PROJECT_STYLE"/BuildOptions-Local.bash

ILUnifiedLog "Will load local settings at: $LOCAL_OPTIONS_FILE"

if [ -f "$LOCAL_OPTIONS_FILE" ]; then
	. "$LOCAL_OPTIONS_FILE"
else
	echo "error: No local settings have been found. To use local settings, create a Bash script at $LOCAL_OPTIONS_FILE which sets the desired option values." >&2
	exit 1
fi
