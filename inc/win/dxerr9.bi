#pragma once

#include once "crt/wchar.bi"
#include once "_mingw_unicode.bi"

#ifdef __FB_64BIT__
	extern "C"
#else
	extern "Windows"
#endif

#define __WINE_DXERR9_H

declare function DXGetErrorString9A(byval hr as HRESULT) as const zstring ptr
declare function DXGetErrorString9W(byval hr as HRESULT) as const WCHAR ptr

#define DXGetErrorString9 __MINGW_NAME_AW(DXGetErrorString9)

declare function DXGetErrorDescription9A(byval hr as HRESULT) as const zstring ptr
declare function DXGetErrorDescription9W(byval hr as HRESULT) as const WCHAR ptr

#define DXGetErrorDescription9 __MINGW_NAME_AW(DXGetErrorDescription9)

declare function DXTraceA(byval strFile as const zstring ptr, byval dwLine as DWORD, byval hr as HRESULT, byval strMsg as const zstring ptr, byval bPopMsgBox as WINBOOL) as HRESULT
declare function DXTraceW(byval strFile as const zstring ptr, byval dwLine as DWORD, byval hr as HRESULT, byval strMsg as const WCHAR ptr, byval bPopMsgBox as WINBOOL) as HRESULT

#define DXTrace __MINGW_NAME_AW(DXTrace)
#define DXTRACE_MSG(str) __MSABI_LONG(0)
#define DXTRACE_ERR(str, hr) (hr)
#define DXTRACE_ERR_NOMSGBOX(str, hr) (hr)

end extern