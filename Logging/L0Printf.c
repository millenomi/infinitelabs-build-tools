/*
 *  L0Printf.c
 *  Logging
 *
 *  Created by ∞ on 20/04/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "L0Printf.h"
#include <stdio.h>
#include <stdarg.h>

#include "L0LogEnabling.h"

void L0ImplementationOfPrintfOnRequest(const char* format, ...) {
	if (L0PrintfShouldShowOnRequestLogging()) {
		va_list l;
		va_start(l, format);
		vfprintf(stderr, format, l);
		va_end(l);
	}
}