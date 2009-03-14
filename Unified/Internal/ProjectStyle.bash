#!/bin/bash

ILUnifiedLog "Will read the style from $INFINITELABS_UNIFIED_PROJECT_DIR/ProjectStyle"

if [ ! -f "$INFINITELABS_UNIFIED_PROJECT_DIR"/ProjectStyle ]; then
	echo "error: The project has no set style. Use Unified/SetStyle <style> to set the style." >&2
	exit 1
fi

INFINITELABS_UNIFIED_PROJECT_STYLE="`cat "$INFINITELABS_UNIFIED_PROJECT_DIR"/ProjectStyle`"

if [ "$INFINITELABS_UNIFIED_PROJECT_STYLE" == "Internal" ]; then
	echo "error: The project has a reserved project style ('Internal'). Set it to something else using Unified/SetStyle <style>." >&2
	exit 1
fi

if [ ! -d "$INFINITELABS_UNIFIED_DIR"/"$INFINITELABS_UNIFIED_PROJECT_STYLE" ]; then
	echo "error: The style named '$INFINITELABS_UNIFIED_PROJECT_STYLE' is unknown." >&2
	ILUnifiedLog directory "$INFINITELABS_UNIFIED_DIR"/"$INFINITELABS_UNIFIED_PROJECT_STYLE" not found.
	exit 1
fi
