'' FreeBASIC binding for glibc-2.21

#pragma once

#ifdef __FB_64BIT__
	const __WORDSIZE = 64
#else
	const __WORDSIZE = 32
#endif
