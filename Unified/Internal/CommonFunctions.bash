#!/bin/bash

function ILUnifiedLog
{
	if [ "$INFINITELABS_UNIFIED_DEBUG" == "YES" ]; then
		echo debug: "$@"
	fi
}

function ILUnifiedRunByStyle
{
	ILUnifiedLog "$INFINITELABS_UNIFIED_DIR"
	
	ACTION_NAME="$1"
	ACTION_FILE="$INFINITELABS_UNIFIED_DIR"/"$INFINITELABS_UNIFIED_PROJECT_STYLE"/"$1"
	shift
	
	if [ ! -x "$ACTION_FILE" ]; then
		echo "error: Action $ACTION_NAME is unavailable for project style $INFINITELABS_UNIFIED_PROJECT_STYLE." >&2
		ILUnifiedLog file "$ACTION_FILE" not found or not executable.
		exit 1
	fi
	
	export INFINITELABS_UNIFIED_PROJECT_DIR
	export INFINITELABS_UNIFIED_PROJECT_STYLE
	export INFINITELABS_UNIFIED_DIR
	export INFINITELABS_UNIFIED_DEBUG
	"$ACTION_FILE" "$@"
}