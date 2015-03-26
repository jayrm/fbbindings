#pragma once

#ifdef __FB_LINUX__
	#include once "endian.bi"
#endif

#define _XARCH_H_
const LITTLE_ENDIAN = 1234
const BIG_ENDIAN = 4321
#define X_BYTE_ORDER BYTE_ORDER
#define X_BIG_ENDIAN BIG_ENDIAN
#define X_LITTLE_ENDIAN LITTLE_ENDIAN