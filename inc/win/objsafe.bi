#pragma once

#include once "crt/wchar.bi"
#include once "rpc.bi"
#include once "rpcndr.bi"
#include once "ole2.bi"
#include once "unknwn.bi"

#ifdef __FB_64BIT__
	extern "C"
#else
	extern "Windows"
#endif

type IObjectSafety as IObjectSafety_

#define __REQUIRED_RPCNDR_H_VERSION__ 440
#define __objsafe_h__
#define __IObjectSafety_FWD_DEFINED__
#define _LPSAFEOBJECT_DEFINED
#define INTERFACESAFE_FOR_UNTRUSTED_CALLER &h00000001
#define INTERFACESAFE_FOR_UNTRUSTED_DATA &h00000002
#define INTERFACE_USES_DISPEX &h00000004
#define INTERFACE_USES_SECURITY_MANAGER &h00000008

extern IID_IObjectSafety as const GUID
extern CATID_SafeForScripting as GUID
extern CATID_SafeForInitializing as GUID
extern __MIDL_itf_objsafe_0000_v0_0_c_ifspec as RPC_IF_HANDLE
extern __MIDL_itf_objsafe_0000_v0_0_s_ifspec as RPC_IF_HANDLE

#define __IObjectSafety_INTERFACE_DEFINED__

type IObjectSafetyVtbl
	QueryInterface as function(byval This as IObjectSafety ptr, byval riid as const IID const ptr, byval ppvObject as any ptr ptr) as HRESULT
	AddRef as function(byval This as IObjectSafety ptr) as ULONG_
	Release as function(byval This as IObjectSafety ptr) as ULONG_
	GetInterfaceSafetyOptions as function(byval This as IObjectSafety ptr, byval riid as const IID const ptr, byval pdwSupportedOptions as DWORD ptr, byval pdwEnabledOptions as DWORD ptr) as HRESULT
	SetInterfaceSafetyOptions as function(byval This as IObjectSafety ptr, byval riid as const IID const ptr, byval dwOptionSetMask as DWORD, byval dwEnabledOptions as DWORD) as HRESULT
end type

type IObjectSafety_
	lpVtbl as IObjectSafetyVtbl ptr
end type

declare function IObjectSafety_GetInterfaceSafetyOptions_Proxy(byval This as IObjectSafety ptr, byval riid as const IID const ptr, byval pdwSupportedOptions as DWORD ptr, byval pdwEnabledOptions as DWORD ptr) as HRESULT
declare sub IObjectSafety_GetInterfaceSafetyOptions_Stub(byval This as IRpcStubBuffer ptr, byval _pRpcChannelBuffer as IRpcChannelBuffer ptr, byval _pRpcMessage as PRPC_MESSAGE, byval _pdwStubPhase as DWORD ptr)
declare function IObjectSafety_SetInterfaceSafetyOptions_Proxy(byval This as IObjectSafety ptr, byval riid as const IID const ptr, byval dwOptionSetMask as DWORD, byval dwEnabledOptions as DWORD) as HRESULT
declare sub IObjectSafety_SetInterfaceSafetyOptions_Stub(byval This as IRpcStubBuffer ptr, byval _pRpcChannelBuffer as IRpcChannelBuffer ptr, byval _pRpcMessage as PRPC_MESSAGE, byval _pdwStubPhase as DWORD ptr)

type LPOBJECTSAFETY as IObjectSafety ptr

extern __MIDL_itf_objsafe_0009_v0_0_c_ifspec as RPC_IF_HANDLE
extern __MIDL_itf_objsafe_0009_v0_0_s_ifspec as RPC_IF_HANDLE

end extern