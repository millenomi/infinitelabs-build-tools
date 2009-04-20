//
//  L0Log.h
//  Logging
//
//  Created by ∞ on 20/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// This header amends Common/Mac/Common.h by adding the function that actually
// implements on-request logging. See that header for details.

#define kL0LogShowOnRequestDefaultsKey @"L0ShowOnRequestLogging"

L0QualifyCallAsC
BOOL L0LogShouldShowOnRequestLogging();

L0QualifyCallAsC
void L0ImplementationOfLogOnRequest(NSString* format, ...);

#if L0LogUseOnRequestLogging
#define L0Log(format, ...) L0ImplementationOfLogOnRequest("<DEBUG: %s>" format, __func__, ## __VA_ARGS__)
#endif
