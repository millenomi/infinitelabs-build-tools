// Logging for debug builds only.

#include "../POSIX/Common.h"

#ifdef __OBJC__

// This header sets up L0Log() the same way POSIX/Common.h sets up L0Printf.
// See that header for details.

#import <Foundation/Foundation.h>

// This macro should not be referenced outside this .h.
// Use L0Log, L0LogDebug or L0LogAlways instead.
#define L0Log_PerformInline(x, ...) \
	NSLog(@"<DEBUG: %s>" x, __func__, ## __VA_ARGS__);

#define L0LogDebug(x, ...) L0InsertIfDebug(L0Log_PerformInline(x, ## __VA_ARGS__))
#define L0LogAlways(x, ...) L0Log_PerformInline(x, ## __VA_ARGS__)

#if !L0LogUseOnRequestLogging
// #warning Defining L0Log as L0LogDebug -- use libLogging.a instead if you want real on-request logging.
#define L0Log(x, ...) L0LogDebug(x, ## __VA_ARGS__)

// L0LogShouldShowOnRequestLoggingObjC in libLogging* can access defaults,
// not just the environment. Use it if you want to control L0Log rather than L0Printf.
#if DEBUG
#define L0LogShouldShowOnRequestLogging() YES
#else
#define L0LogShouldShowOnRequestLogging() NO
#endif

#else
// This is a hack to build the logging library
#if !L0LogIsBuilding
#include <L0Log/L0Log.h>
#endif
#endif // !L0LogUseOnRequestLogging

#define L0LogDebugIf(cond, x, ...) L0InsertIfDebug(if (cond) L0Log_PerformInline(x, ## __VA_ARGS__))

#endif // def __OBJC__