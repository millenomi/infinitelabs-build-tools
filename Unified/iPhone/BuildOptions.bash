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
