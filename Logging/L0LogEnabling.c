/*
 *  L0LogEnabling.c
 *  Logging
 *
 *  Created by ∞ on 20/04/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "L0LogEnabling.h"
#include <stdlib.h>
#include <string.h>

int L0PrintfShouldShowOnRequestLogging() {
	static int checked = 0, enabled;
	if (!checked) {
		char* envValue = getenv(kL0LogShowOnRequestEnvironmentVariable);
		enabled = envValue != NULL && (strcmp(envValue, "YES") == 0);
		checked = 1;
	}
	
	return enabled;
}
