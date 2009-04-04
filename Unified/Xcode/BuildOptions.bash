#!/bin/bash

FAST=NO
STYLES=()
ALL_STYLES=( Debug Release )
BUILD_SETTINGS=( INFINITELABS_TOOLS="$INFINITELABS_UNIFIED_DIR"/.. )

while [ "$1" != "" ]; do
	case "$1" in
		--fast|-f)
			FAST_IF_USUAL_FOR_STYLE=YES
			;;
		
		--very-fast|-F)
			FAST=YES
			;;
		
		--local|-L)
			. "$INFINITELABS_UNIFIED_DIR"/Internal/CommonOptions/Local.bash
			;;
		
		--xcode-setting)
			BUILD_SETTINGS=( "${BUILD_SETTINGS[@]}" "$2" )
			shift
			;;
		
		--all|-a)
			STYLES=( "${ALL_STYLES[@]}" )
			;;
			
		--debug|-d)
			STYLES=( "${STYLES[@]}" Debug )
			;;
			
		--release|-r)
			STYLES=( "${STYLES[@]}" Release )
			;;
			
		--style|-s)
			STYLES=( "${STYLES[@]}" "$2" )
			shift
			;;
			
		*)
			echo "error: Unrecognized option $1." >&2
			exit 1
			;;
	esac
	shift
done

if [ "${#STYLES[@]}" == "0" ]; then
	STYLES=( "${ALL_STYLES[@]}" )
fi


ILUnifiedLog "Will build with styles: ${STYLES[@]}"
ILUnifiedLog "Will build with actions: ${ACTIONS[@]}"
