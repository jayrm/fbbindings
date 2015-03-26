#pragma once

#include once "crt/long.bi"
#include once "X11/Xauth.bi"
#include once "X11/extensions/secur.bi"

extern "C"

#define _SECURITY_H
#define _XAUTH_STRUCT_ONLY
declare function XSecurityQueryExtension(byval dpy as Display ptr, byval major_version_return as long ptr, byval minor_version_return as long ptr) as long
declare function XSecurityAllocXauth() as Xauth ptr
declare sub XSecurityFreeXauth(byval auth as Xauth ptr)
type XSecurityAuthorization as culong

type XSecurityAuthorizationAttributes
	timeout as ulong
	trust_level as ulong
	group as XID
	event_mask as clong
end type

declare function XSecurityGenerateAuthorization(byval dpy as Display ptr, byval auth_in as Xauth ptr, byval valuemask as culong, byval attributes as XSecurityAuthorizationAttributes ptr, byval auth_id_return as XSecurityAuthorization ptr) as Xauth ptr
declare function XSecurityRevokeAuthorization(byval dpy as Display ptr, byval auth_id as XSecurityAuthorization) as long

type XSecurityAuthorizationRevokedEvent
	as long type
	serial as culong
	send_event as long
	display as Display ptr
	auth_id as XSecurityAuthorization
end type

end extern