// Debug-only logging.

#if DEBUG
	#define L0Printf(x, ...) printf("%s: " x, ## __VA_ARGS__)
	#define L0PrintfIf(cond, x, ...) do { if (cond) printf(x, ## __VA_ARGS__); } while (0)
#else
	#define L0Printf(...)
	#define L0PrintfIf(...)
#endif // def DEBUG