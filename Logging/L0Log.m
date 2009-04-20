//
//  L0Log.m
//  Logging
//
//  Created by ∞ on 20/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "L0Log.h"
#import "L0LogEnabling.h"

BOOL L0LogShouldShowOnRequestLogging() {
	static BOOL checked = NO, enabled;
	if (!checked) {
		if (L0PrintfShouldShowOnRequestLogging())
			enabled = YES;
		else
			enabled = [[NSUserDefaults standardUserDefaults] boolForKey:kL0LogShowOnRequestDefaultsKey];

		checked = YES;
	}
	
	return enabled;
}

void L0ImplementationOfLogOnRequest(NSString* format, ...) {
	va_list l;
	va_start(l, format);
	NSString* toBeLogged = [[NSString alloc] initWithFormat:format arguments:l];
	NSLog(@"%@", toBeLogged);
	[toBeLogged release];
	va_end(l);
}
