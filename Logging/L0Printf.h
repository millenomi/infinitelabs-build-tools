/*
 *  L0Printf.h
 *  Logging
 *
 *  Created by ∞ on 20/04/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#ifndef L0Printf_H
#define L0Printf_H

// This header amends Common/POSIX/Common.h by adding the function that actually
// implements on-request logging. See that header for details.

L0QualifyCallAsC
void L0ImplementationOfPrintfOnRequest(const char* format, ...) L0AttributeLikePrintf(1, 2);

#if L0LogUseOnRequestLogging
#define L0Printf(format, ...) L0ImplementationOfPrintfOnRequest("<DEBUG: %s>" format, __func__, __VA_ARGS__)
#endif

#endif // L0Printf_H