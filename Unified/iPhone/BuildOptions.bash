#!/bin/bash

FAST=NO
STYLES=()
ALL_STYLES=( Debug "Ad Hoc" "App Store" )
BUILD_SETTINGS=( INFINITELABS_TOOLS="$INFINITELABS_UNIFIED_DIR"/.. )

while [ "$1" != "" ]; do
	case "$1" in
		--fast|-f)
			FAST=YES
			;;
		
		--iphone-development-profile)
			DEVELOPMENT_PROFILE="$2"
			shift
			;;
			
		--local|-L)
			. "$INFINITELABS_UNIFIED_DIR"/Internal/CommonOptions/Local.bash
			;;
			
		--xcode-setting)
			BUILD_SETTINGS=( "${BUILD_SETTINGS[@]}" "$2" )
			shift
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
			STYLES=( "${ALL_STYLES[@]}" )
			;;
			
		--debug|-d)
			STYLES=( "${STYLES[@]}" Debug )
			;;
			
		--release|-r)
			STYLES=( "${STYLES[@]}" "Ad Hoc" "App Store" )
			;;
			
		--style|-s)
			STYLES=( "${STYLES[@]}" "$2" )
			shift
			;;
			
		--iphone-ad-hoc)
			STYLES=( "${STYLES[@]}" "Ad Hoc" )
			;;
			
		--iphone-app-store)
			STYLES=( "${STYLES[@]}" "App Store" )
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
	STYLES=( "${ALL_STYLES[@]}" )
fi

ILUnifiedLog "Will build with styles (${#STYLES[@]}): ${STYLES[@]}"
ILUnifiedLog "Will build with actions (${#ACTIONS[@]}): ${ACTIONS[@]}"
ILUnifiedLog "Will build with development identity '$DEVELOPMENT_IDENTITY', development profile '$DEVELOPMENT_PROFILE' (empty means default)"
ILUnifiedLog "Will build with distribution identity '$DISTRIBUTION_IDENTITY', development profiles: ad hoc '$AD_HOC_PROFILE', App Store '$APP_STORE_PROFILE' (empty means default)"
