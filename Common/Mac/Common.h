// Logging for debug builds only.

#include "../POSIX/Common.h"

#ifdef __OBJC__

// ===========
// = Logging =
// ===========

// This header sets up L0Log() the same way POSIX/Common.h sets up L0Printf.
// See that header for details.

#import <Foundation/Foundation.h>

// This macro should not be referenced outside this .h.
// Use L0Log, L0LogDebug or L0LogAlways instead.
#define L0Log_PerformInline(x, ...) \
	NSLog(@"<DEBUG: %s> " x, __func__, ## __VA_ARGS__)

#if DEBUG
#define L0LogDebug(x, ...) L0Log_PerformInline(x, ## __VA_ARGS__)
#else
#define L0LogDebug(x, ...)
#endif

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

#if DEBUG
#define L0LogDebugIf(cond, x, ...) do { if (cond) L0Log_PerformInline(x, ## __VA_ARGS__); } while (0)
#else
#define L0LogDebugIf(...)
#endif

#define L0Note() L0Log(@" -- entered --")

// ==============
// = Assertions =
// ==============

#define L0AssertOutlet(x) NSAssert((x), @"Missing outlet: " #x)


// =============
// = Shorthand =
// =============

#define L0ObjCSingletonMethod(name) \
	+ (id) name {\
		static id myself = nil;\
		if (!myself)\
			myself = [[self alloc] init];\
		return myself;\
	}
	
// Required for the __LINE__ uniquing trick.
#define L0ConcatMacroAfterExpanding(a, b) a ## b
#define L0ConcatMacro(a, b) L0ConcatMacroAfterExpanding(a, b)
	
#define L0UniquePointerConstant(name) \
	static const int L0ConcatMacro(L0UniqueIntConstant, __LINE__) = 0;\
	static void* name = (void*) &L0ConcatMacro(L0UniqueIntConstant, __LINE__)

#endif // def __OBJC__