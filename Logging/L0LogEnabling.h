/*
 *  L0LogEnabling.h
 *  Logging
 *
 *  Created by ∞ on 20/04/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */


#ifndef L0LogEnabling_H
#define L0LogEnabling_H
	
#define kL0LogShowOnRequestEnvironmentVariable "ILABS_L0ShowOnRequestLogging"

#if !L0LogUseOnRequestLogging
#error You must set L0LogUseOnRequestLogging to 1, or the functions in libLogging won't work.
#endif

L0QualifyCallAsC
int L0PrintfShouldShowOnRequestLogging();

#endif // L0LogEnabling_H