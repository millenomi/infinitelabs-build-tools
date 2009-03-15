#!/bin/bash

INFINITELABS_UNIFIED_DIR="`dirname "$0"`"

. "$INFINITELABS_UNIFIED_DIR"/Internal/CommonFunctions.bash
ILUnifiedLog "Unified build scripts directory set to $INFINITELABS_UNIFIED_DIR" || exit 1
