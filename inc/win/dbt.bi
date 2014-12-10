#pragma once

#include once "crt/wchar.bi"
#include once "_mingw_unicode.bi"
#include once "guiddef.bi"

#define _DBT_H
#define WM_DEVICECHANGE &h0219
#define DBTFAR far
#define BSF_QUERY &h00000001
#define BSF_IGNORECURRENTTASK &h00000002
#define BSF_FLUSHDISK &h00000004
#define BSF_NOHANG &h00000008
#define BSF_POSTMESSAGE &h00000010
#define BSF_FORCEIFHUNG &h00000020
#define BSF_NOTIMEOUTIFNOTHUNG &h00000040
#define BSF_MSGSRV32ISOK &h80000000
#define BSF_MSGSRV32ISOK_BIT 31
#define BSM_ALLCOMPONENTS &h00000000
#define BSM_VXDS &h00000001
#define BSM_NETDRIVER &h00000002
#define BSM_INSTALLABLEDRIVERS &h00000004
#define BSM_APPLICATIONS &h00000008
#define DBT_APPYBEGIN &h0000
#define DBT_APPYEND &h0001
#define DBT_DEVNODES_CHANGED &h0007
#define DBT_QUERYCHANGECONFIG &h0017
#define DBT_CONFIGCHANGED &h0018
#define DBT_CONFIGCHANGECANCELED &h0019
#define DBT_MONITORCHANGE &h001B
#define DBT_SHELLLOGGEDON &h0020
#define DBT_CONFIGMGAPI32 &h0022
#define DBT_VXDINITCOMPLETE &h0023
#define DBT_VOLLOCKQUERYLOCK &h8041
#define DBT_VOLLOCKLOCKTAKEN &h8042
#define DBT_VOLLOCKLOCKFAILED &h8043
#define DBT_VOLLOCKQUERYUNLOCK &h8044
#define DBT_VOLLOCKLOCKRELEASED &h8045
#define DBT_VOLLOCKUNLOCKFAILED &h8046

type _DEV_BROADCAST_HDR
	dbch_size as DWORD
	dbch_devicetype as DWORD
	dbch_reserved as DWORD
end type

type DEV_BROADCAST_HDR as _DEV_BROADCAST_HDR
type PDEV_BROADCAST_HDR as DEV_BROADCAST_HDR ptr
type pVolLockBroadcast as VolLockBroadcast ptr

type VolLockBroadcast
	vlb_dbh as _DEV_BROADCAST_HDR
	vlb_owner as DWORD
	vlb_perms as BYTE_
	vlb_lockType as BYTE_
	vlb_drive as BYTE_
	vlb_flags as BYTE_
end type

#define LOCKP_ALLOW_WRITES &h01
#define LOCKP_FAIL_WRITES &h00
#define LOCKP_FAIL_MEM_MAPPING &h02
#define LOCKP_ALLOW_MEM_MAPPING &h00
#define LOCKP_USER_MASK &h03
#define LOCKP_LOCK_FOR_FORMAT &h04
#define LOCKF_LOGICAL_LOCK &h00
#define LOCKF_PHYSICAL_LOCK &h01
#define DBT_NO_DISK_SPACE &h0047
#define DBT_LOW_DISK_SPACE &h0048
#define DBT_CONFIGMGPRIVATE &h7FFF
#define DBT_DEVICEARRIVAL &h8000
#define DBT_DEVICEQUERYREMOVE &h8001
#define DBT_DEVICEQUERYREMOVEFAILED &h8002
#define DBT_DEVICEREMOVEPENDING &h8003
#define DBT_DEVICEREMOVECOMPLETE &h8004
#define DBT_DEVICETYPESPECIFIC &h8005
#define DBT_CUSTOMEVENT &h8006
#define DBT_DEVTYP_OEM &h00000000
#define DBT_DEVTYP_DEVNODE &h00000001
#define DBT_DEVTYP_VOLUME &h00000002
#define DBT_DEVTYP_PORT &h00000003
#define DBT_DEVTYP_NET &h00000004
#define DBT_DEVTYP_DEVICEINTERFACE &h00000005
#define DBT_DEVTYP_HANDLE &h00000006

type _DEV_BROADCAST_HEADER
	dbcd_size as DWORD
	dbcd_devicetype as DWORD
	dbcd_reserved as DWORD
end type

type _DEV_BROADCAST_OEM
	dbco_size as DWORD
	dbco_devicetype as DWORD
	dbco_reserved as DWORD
	dbco_identifier as DWORD
	dbco_suppfunc as DWORD
end type

type DEV_BROADCAST_OEM as _DEV_BROADCAST_OEM
type PDEV_BROADCAST_OEM as DEV_BROADCAST_OEM ptr

type _DEV_BROADCAST_DEVNODE
	dbcd_size as DWORD
	dbcd_devicetype as DWORD
	dbcd_reserved as DWORD
	dbcd_devnode as DWORD
end type

type DEV_BROADCAST_DEVNODE as _DEV_BROADCAST_DEVNODE
type PDEV_BROADCAST_DEVNODE as DEV_BROADCAST_DEVNODE ptr

type _DEV_BROADCAST_VOLUME
	dbcv_size as DWORD
	dbcv_devicetype as DWORD
	dbcv_reserved as DWORD
	dbcv_unitmask as DWORD
	dbcv_flags as WORD
end type

type DEV_BROADCAST_VOLUME as _DEV_BROADCAST_VOLUME
type PDEV_BROADCAST_VOLUME as DEV_BROADCAST_VOLUME ptr

#define DBTF_MEDIA &h0001
#define DBTF_NET &h0002

type _DEV_BROADCAST_PORT_A
	dbcp_size as DWORD
	dbcp_devicetype as DWORD
	dbcp_reserved as DWORD
	dbcp_name as zstring * 1
end type

type DEV_BROADCAST_PORT_A as _DEV_BROADCAST_PORT_A
type PDEV_BROADCAST_PORT_A as _DEV_BROADCAST_PORT_A ptr

type _DEV_BROADCAST_PORT_W
	dbcp_size as DWORD
	dbcp_devicetype as DWORD
	dbcp_reserved as DWORD
	dbcp_name as wstring * 1
end type

type DEV_BROADCAST_PORT_W as _DEV_BROADCAST_PORT_W
type PDEV_BROADCAST_PORT_W as _DEV_BROADCAST_PORT_W ptr

#ifdef UNICODE
	type DEV_BROADCAST_PORT as DEV_BROADCAST_PORT_W
	type PDEV_BROADCAST_PORT as PDEV_BROADCAST_PORT_W
#else
	type DEV_BROADCAST_PORT as DEV_BROADCAST_PORT_A
	type PDEV_BROADCAST_PORT as PDEV_BROADCAST_PORT_A
#endif

type _DEV_BROADCAST_NET
	dbcn_size as DWORD
	dbcn_devicetype as DWORD
	dbcn_reserved as DWORD
	dbcn_resource as DWORD
	dbcn_flags as DWORD
end type

type DEV_BROADCAST_NET as _DEV_BROADCAST_NET
type PDEV_BROADCAST_NET as DEV_BROADCAST_NET ptr

type _DEV_BROADCAST_DEVICEINTERFACE_A
	dbcc_size as DWORD
	dbcc_devicetype as DWORD
	dbcc_reserved as DWORD
	dbcc_classguid as GUID
	dbcc_name as zstring * 1
end type

type DEV_BROADCAST_DEVICEINTERFACE_A as _DEV_BROADCAST_DEVICEINTERFACE_A
type PDEV_BROADCAST_DEVICEINTERFACE_A as _DEV_BROADCAST_DEVICEINTERFACE_A ptr

type _DEV_BROADCAST_DEVICEINTERFACE_W
	dbcc_size as DWORD
	dbcc_devicetype as DWORD
	dbcc_reserved as DWORD
	dbcc_classguid as GUID
	dbcc_name as wstring * 1
end type

type DEV_BROADCAST_DEVICEINTERFACE_W as _DEV_BROADCAST_DEVICEINTERFACE_W
type PDEV_BROADCAST_DEVICEINTERFACE_W as _DEV_BROADCAST_DEVICEINTERFACE_W ptr

#ifdef UNICODE
	type DEV_BROADCAST_DEVICEINTERFACE as DEV_BROADCAST_DEVICEINTERFACE_W
	type PDEV_BROADCAST_DEVICEINTERFACE as PDEV_BROADCAST_DEVICEINTERFACE_W
#else
	type DEV_BROADCAST_DEVICEINTERFACE as DEV_BROADCAST_DEVICEINTERFACE_A
	type PDEV_BROADCAST_DEVICEINTERFACE as PDEV_BROADCAST_DEVICEINTERFACE_A
#endif

type _DEV_BROADCAST_HANDLE
	dbch_size as DWORD
	dbch_devicetype as DWORD
	dbch_reserved as DWORD
	dbch_handle as HANDLE
	dbch_hdevnotify as HDEVNOTIFY
	dbch_eventguid as GUID
	dbch_nameoffset as LONG_
	dbch_data(0 to 0) as BYTE_
end type

type DEV_BROADCAST_HANDLE as _DEV_BROADCAST_HANDLE
type PDEV_BROADCAST_HANDLE as _DEV_BROADCAST_HANDLE ptr

type _DEV_BROADCAST_HANDLE32
	dbch_size as DWORD
	dbch_devicetype as DWORD
	dbch_reserved as DWORD
	dbch_handle as ULONG32
	dbch_hdevnotify as ULONG32
	dbch_eventguid as GUID
	dbch_nameoffset as LONG_
	dbch_data(0 to 0) as BYTE_
end type

type DEV_BROADCAST_HANDLE32 as _DEV_BROADCAST_HANDLE32
type PDEV_BROADCAST_HANDLE32 as _DEV_BROADCAST_HANDLE32 ptr

type _DEV_BROADCAST_HANDLE64
	dbch_size as DWORD
	dbch_devicetype as DWORD
	dbch_reserved as DWORD
	dbch_handle as ULONG64
	dbch_hdevnotify as ULONG64
	dbch_eventguid as GUID
	dbch_nameoffset as LONG_
	dbch_data(0 to 0) as BYTE_
end type

type DEV_BROADCAST_HANDLE64 as _DEV_BROADCAST_HANDLE64
type PDEV_BROADCAST_HANDLE64 as _DEV_BROADCAST_HANDLE64 ptr

#define DBTF_RESOURCE &h00000001
#define DBTF_XPORT &h00000002
#define DBTF_SLOWNET &h00000004
#define DBT_VPOWERDAPI &h8100
#define DBT_USERDEFINED &hFFFF

type _DEV_BROADCAST_USERDEFINED
	dbud_dbh as _DEV_BROADCAST_HDR
	dbud_szName as zstring * 1
end type