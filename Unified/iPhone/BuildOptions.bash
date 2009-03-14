#!/bin/bash

FAST=NO
STYLES=()
ALL_STYLES=( Debug AdHoc AppStore )
while [ "$1" != "" ]; do
	case "$1" in
		--fast|-f)
			FAST=YES
			;;
		
		--iphone-development-profile)
			DEVELOPMENT_PROFILE="$2"
			shift
			;;
			
		--iphone-local)
			ILUnifiedLog "Will load local settings at: "$INFINITELABS_UNIFIED_DIR"/iPhone/BuildOptions-Local.bash"
		
			if [ -e "$INFINITELABS_UNIFIED_DIR"/iPhone/BuildOptions-Local.bash ]; then
				. "$INFINITELABS_UNIFIED_DIR"/iPhone/BuildOptions-Local.bash
			else
				echo "error: No local iPhone settings have been found. To use local settings, create a Bash script at "$INFINITELABS_UNIFIED_DIR"/iPhone/BuildOptions-Local.bash which sets the desired option values." >&2
				exit 1
			fi
			;;
		
		--iphone-app-store-profile)
			APP_STORE_PROFILE="$2"
			shift
			;;
		
		--iphone-ad-hoc-profile)
			AD_HOC_PROFILE="$2"
			shift
			;;
			
		--iphone-development-identity)
			DEVELOPMENT_IDENTITY="$2"
			shift
			;;
			
		--iphone-distribution-identity)
			DISTRIBUTION_IDENTITY="$2"
			shift
			;;
			
		--all|-a)
			STYLES="${ALL_STYLES[@]}"
			;;
			
		--debug|-d)
			STYLES=( "${STYLES[@]}" Debug )
			;;
			
		--release|-r)
			STYLES=( "${STYLES[@]}" AdHoc AppStore )
			;;
			
		--style|-s)
			STYLES=( "${STYLES[@]}" "$2" )
			shift
			;;
			
		--iphone-ad-hoc)
			STYLES=( "${STYLES[@]}" AdHoc )
			shift
			;;
			
		--iphone-app-store)
			STYLES=( "${STYLES[@]}" AppStore )
			shift
			;;
			
		*)
			echo "error: Unrecognized option $1." >&2
			exit 1
			;;
	esac
	shift
done

if [ "$FAST" == "YES" ]; then
	ACTIONS=( build )
else
	ACTIONS=( clean build )
fi

if [ "${#STYLES[@]}" == "0" ]; then
	STYLES="${ALL_STYLES[@]}"
fi

BUILD_SETTINGS=( INFINITELABS_TOOLS="$INFINITELABS_UNIFIED_DIR"/.. )

ILUnifiedLog "Will build with styles: ${STYLES[@]}"
ILUnifiedLog "Will build with actions: ${ACTIONS[@]}"
ILUnifiedLog "Will build with development identity '$DEVELOPMENT_IDENTITY', development profile '$DEVELOPMENT_PROFILE' (empty means default)"
ILUnifiedLog "Will build with distribution identity '$DISTRIBUTION_IDENTITY', development profiles: ad hoc '$AD_HOC_PROFILE', App Store '$APP_STORE_PROFILE' (empty means default)"
