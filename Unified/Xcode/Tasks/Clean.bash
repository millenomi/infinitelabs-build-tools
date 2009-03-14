#!/bin/bash

for STYLE in "${STYLES[@]}"; do
	(cd "$INFINITELABS_UNIFIED_PROJECT_DIR" && \
		xcodebuild -configuration "$STYLE" clean \
	) || exit 1
done
