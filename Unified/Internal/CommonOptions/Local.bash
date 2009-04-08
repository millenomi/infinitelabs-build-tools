#!/bin/bash

LOCAL_OPTIONS_FILE="$INFINITELABS_UNIFIED_DIR"/"$INFINITELABS_UNIFIED_PROJECT_STYLE"/BuildOptions-Local.bash

ILUnifiedLog "Will load local settings at: $LOCAL_OPTIONS_FILE"

if [ -f "$LOCAL_OPTIONS_FILE" ]; then
	. "$LOCAL_OPTIONS_FILE"
else
	echo "note: No local options found for this style. Create a file at $LOCAL_OPTIONS_FILE to add local options for this style." >&2
fi
