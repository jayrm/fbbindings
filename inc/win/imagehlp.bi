#pragma once

#include once "_mingw_unicode.bi"
#include once "wintrust.bi"

#ifdef __FB_64BIT__
	'' The following symbols have been renamed:
	''     inside struct _tagSTACKFRAME64:
	''         field KdHelp => KdHelp_
	''     #define PSYMBOL_FUNCENTRY_CALLBACK => PSYMBOL_FUNCENTRY_CALLBACK_
	''     inside struct _IMAGEHLP_SYMBOL64:
	''         field Address => Address_
	''     inside struct _IMAGEHLP_LINE64:
	''         field Address => Address_
	''     inside struct _IMAGEHLP_LINEW64:
	''         field Address => Address_
	''     inside struct _SRCCODEINFO:
	''         field Address => Address_
	''     inside struct _SRCCODEINFOW:
	''         field Address => Address_
	''     inside struct _SYMBOL_INFO:
	''         field Address => Address_
	''     inside struct _SYMBOL_INFOW:
	''         field Address => Address_

	extern "C"
#else
	extern "Windows"
#endif

#define _IMAGEHLP_

#ifdef __FB_64BIT__
	#define _IMAGEHLP64
#endif

#define IMAGE_SEPARATION (64 * 1024)

type _LOADED_IMAGE
	ModuleName as PSTR
	hFile as HANDLE
	MappedAddress as PUCHAR

	#ifdef __FB_64BIT__
		FileHeader as PIMAGE_NT_HEADERS64
	#else
		FileHeader as PIMAGE_NT_HEADERS32
	#endif

	LastRvaSection as PIMAGE_SECTION_HEADER
	NumberOfSections as ULONG
	Sections as PIMAGE_SECTION_HEADER
	Characteristics as ULONG
	fSystemImage as BOOLEAN
	fDOSImage as BOOLEAN
	fReadOnly as BOOLEAN
	Version as UCHAR
	Links as LIST_ENTRY
	SizeOfImage as ULONG
end type

type LOADED_IMAGE as _LOADED_IMAGE
type PLOADED_IMAGE as _LOADED_IMAGE ptr

#define MAX_SYM_NAME 2000

type _MODLOAD_DATA
	ssize as DWORD
	ssig as DWORD
	data as PVOID
	size as DWORD
	flags as DWORD
end type

type MODLOAD_DATA as _MODLOAD_DATA
type PMODLOAD_DATA as _MODLOAD_DATA ptr

type _IMAGEHLP_STATUS_REASON as long
enum
	BindOutOfMemory
	BindRvaToVaFailed
	BindNoRoomInImage
	BindImportModuleFailed
	BindImportProcedureFailed
	BindImportModule
	BindImportProcedure
	BindForwarder
	BindForwarderNOT
	BindImageModified
	BindExpandFileHeaders
	BindImageComplete
	BindMismatchedSymbols
	BindSymbolsNotUpdated
	BindImportProcedure32
	BindImportProcedure64
	BindForwarder32
	BindForwarder64
	BindForwarderNOT32
	BindForwarderNOT64
end enum

type IMAGEHLP_STATUS_REASON as _IMAGEHLP_STATUS_REASON
type PIMAGEHLP_STATUS_ROUTINE as function(byval Reason as IMAGEHLP_STATUS_REASON, byval ImageName as PCSTR, byval DllName as PCSTR, byval Va as ULONG_PTR, byval Parameter as ULONG_PTR) as WINBOOL
type PIMAGEHLP_STATUS_ROUTINE32 as function(byval Reason as IMAGEHLP_STATUS_REASON, byval ImageName as PCSTR, byval DllName as PCSTR, byval Va as ULONG, byval Parameter as ULONG_PTR) as WINBOOL
type PIMAGEHLP_STATUS_ROUTINE64 as function(byval Reason as IMAGEHLP_STATUS_REASON, byval ImageName as PCSTR, byval DllName as PCSTR, byval Va as ULONG64, byval Parameter as ULONG_PTR) as WINBOOL

#define BIND_NO_BOUND_IMPORTS &h00000001
#define BIND_NO_UPDATE &h00000002
#define BIND_ALL_IMAGES &h00000004
#define BIND_CACHE_IMPORT_DLLS &h00000008
#define BIND_REPORT_64BIT_VA &h00000010
#define CHECKSUM_SUCCESS 0
#define CHECKSUM_OPEN_FAILURE 1
#define CHECKSUM_MAP_FAILURE 2
#define CHECKSUM_MAPVIEW_FAILURE 3
#define CHECKSUM_UNICODE_FAILURE 4
#define SPLITSYM_REMOVE_PRIVATE &h00000001
#define SPLITSYM_EXTRACT_ALL &h00000002
#define SPLITSYM_SYMBOLPATH_IS_SRC &h00000004

#ifdef UNICODE
	#define MapFileAndCheckSum MapFileAndCheckSumW
#else
	#define MapFileAndCheckSum MapFileAndCheckSumA
#endif

declare function BindImage(byval ImageName as PCSTR, byval DllPath as PCSTR, byval SymbolPath as PCSTR) as WINBOOL
declare function BindImageEx(byval Flags as DWORD, byval ImageName as PCSTR, byval DllPath as PCSTR, byval SymbolPath as PCSTR, byval StatusRoutine as PIMAGEHLP_STATUS_ROUTINE) as WINBOOL
declare function ReBaseImage(byval CurrentImageName as PCSTR, byval SymbolPath as PCSTR, byval fReBase as WINBOOL, byval fRebaseSysfileOk as WINBOOL, byval fGoingDown as WINBOOL, byval CheckImageSize as ULONG, byval OldImageSize as ULONG ptr, byval OldImageBase as ULONG_PTR ptr, byval NewImageSize as ULONG ptr, byval NewImageBase as ULONG_PTR ptr, byval TimeStamp as ULONG) as WINBOOL
declare function ReBaseImage64(byval CurrentImageName as PCSTR, byval SymbolPath as PCSTR, byval fReBase as WINBOOL, byval fRebaseSysfileOk as WINBOOL, byval fGoingDown as WINBOOL, byval CheckImageSize as ULONG, byval OldImageSize as ULONG ptr, byval OldImageBase as ULONG64 ptr, byval NewImageSize as ULONG ptr, byval NewImageBase as ULONG64 ptr, byval TimeStamp as ULONG) as WINBOOL
declare function GetImageConfigInformation(byval LoadedImage as PLOADED_IMAGE, byval ImageConfigInformation as PIMAGE_LOAD_CONFIG_DIRECTORY) as WINBOOL
declare function GetImageUnusedHeaderBytes(byval LoadedImage as PLOADED_IMAGE, byval SizeUnusedHeaderBytes as PDWORD) as DWORD
declare function SetImageConfigInformation(byval LoadedImage as PLOADED_IMAGE, byval ImageConfigInformation as PIMAGE_LOAD_CONFIG_DIRECTORY) as WINBOOL
declare function CheckSumMappedFile(byval BaseAddress as PVOID, byval FileLength as DWORD, byval HeaderSum as PDWORD, byval CheckSum as PDWORD) as PIMAGE_NT_HEADERS
declare function MapFileAndCheckSumA(byval Filename as PCSTR, byval HeaderSum as PDWORD, byval CheckSum as PDWORD) as DWORD
declare function MapFileAndCheckSumW(byval Filename as PCWSTR, byval HeaderSum as PDWORD, byval CheckSum as PDWORD) as DWORD

#define CERT_PE_IMAGE_DIGEST_DEBUG_INFO &h01
#define CERT_PE_IMAGE_DIGEST_RESOURCES &h02
#define CERT_PE_IMAGE_DIGEST_ALL_IMPORT_INFO &h04
#define CERT_PE_IMAGE_DIGEST_NON_PE_INFO &h08
#define CERT_SECTION_TYPE_ANY &hFF

type DIGEST_HANDLE as PVOID
type DIGEST_FUNCTION as function(byval refdata as DIGEST_HANDLE, byval pData as PBYTE, byval dwLength as DWORD) as WINBOOL

declare function ImageGetDigestStream(byval FileHandle as HANDLE, byval DigestLevel as DWORD, byval DigestFunction as DIGEST_FUNCTION, byval DigestHandle as DIGEST_HANDLE) as WINBOOL
declare function ImageAddCertificate(byval FileHandle as HANDLE, byval Certificate as LPWIN_CERTIFICATE, byval Index as PDWORD) as WINBOOL
declare function ImageRemoveCertificate(byval FileHandle as HANDLE, byval Index as DWORD) as WINBOOL
declare function ImageEnumerateCertificates(byval FileHandle as HANDLE, byval TypeFilter as WORD, byval CertificateCount as PDWORD, byval Indices as PDWORD, byval IndexCount as DWORD) as WINBOOL
declare function ImageGetCertificateData(byval FileHandle as HANDLE, byval CertificateIndex as DWORD, byval Certificate as LPWIN_CERTIFICATE, byval RequiredLength as PDWORD) as WINBOOL
declare function ImageGetCertificateHeader(byval FileHandle as HANDLE, byval CertificateIndex as DWORD, byval Certificateheader as LPWIN_CERTIFICATE) as WINBOOL
declare function ImageLoad(byval DllName as PCSTR, byval DllPath as PCSTR) as PLOADED_IMAGE
declare function ImageUnload(byval LoadedImage as PLOADED_IMAGE) as WINBOOL
declare function MapAndLoad(byval ImageName as PCSTR, byval DllPath as PCSTR, byval LoadedImage as PLOADED_IMAGE, byval DotDll as WINBOOL, byval ReadOnly as WINBOOL) as WINBOOL
declare function UnMapAndLoad(byval LoadedImage as PLOADED_IMAGE) as WINBOOL
declare function TouchFileTimes(byval FileHandle as HANDLE, byval pSystemTime as PSYSTEMTIME) as WINBOOL
declare function SplitSymbols(byval ImageName as PSTR, byval SymbolsPath as PCSTR, byval SymbolFilePath as PSTR, byval Flags as DWORD) as WINBOOL
declare function UpdateDebugInfoFile(byval ImageFileName as PCSTR, byval SymbolPath as PCSTR, byval DebugFilePath as PSTR, byval NtHeaders as PIMAGE_NT_HEADERS32) as WINBOOL
declare function UpdateDebugInfoFileEx(byval ImageFileName as PCSTR, byval SymbolPath as PCSTR, byval DebugFilePath as PSTR, byval NtHeaders as PIMAGE_NT_HEADERS32, byval OldChecksum as DWORD) as WINBOOL

type PFIND_DEBUG_FILE_CALLBACK as function(byval FileHandle as HANDLE, byval FileName as PCSTR, byval CallerData as PVOID) as WINBOOL
type PFIND_DEBUG_FILE_CALLBACKW as function(byval FileHandle as HANDLE, byval FileName as PCWSTR, byval CallerData as PVOID) as WINBOOL
type PFINDFILEINPATHCALLBACK as function(byval filename as PCSTR, byval context as PVOID) as WINBOOL
type PFINDFILEINPATHCALLBACKW as function(byval filename as PCWSTR, byval context as PVOID) as WINBOOL
type PFIND_EXE_FILE_CALLBACK as function(byval FileHandle as HANDLE, byval FileName as PCSTR, byval CallerData as PVOID) as WINBOOL
type PFIND_EXE_FILE_CALLBACKW as function(byval FileHandle as HANDLE, byval FileName as PCWSTR, byval CallerData as PVOID) as WINBOOL
type PSYMBOLSERVERPROC as function(byval as LPCSTR, byval as LPCSTR, byval as PVOID, byval as DWORD, byval as DWORD, byval as LPSTR) as WINBOOL
type PSYMBOLSERVEROPENPROC as function() as WINBOOL
type PSYMBOLSERVERCLOSEPROC as function() as WINBOOL
type PSYMBOLSERVERSETOPTIONSPROC as function(byval as UINT_PTR, byval as ULONG64) as WINBOOL
type PSYMBOLSERVERCALLBACKPROC as function(byval action as UINT_PTR, byval data_ as ULONG64, byval context as ULONG64) as WINBOOL
type PSYMBOLSERVERGETOPTIONSPROC as function() as UINT_PTR
type PSYMBOLSERVERPINGPROC as function(byval as LPCSTR) as WINBOOL

declare function FindDebugInfoFile(byval FileName as PCSTR, byval SymbolPath as PCSTR, byval DebugFilePath as PSTR) as HANDLE
declare function FindDebugInfoFileEx(byval FileName as PCSTR, byval SymbolPath as PCSTR, byval DebugFilePath as PSTR, byval Callback as PFIND_DEBUG_FILE_CALLBACK, byval CallerData as PVOID) as HANDLE
declare function FindDebugInfoFileExW(byval FileName as PCWSTR, byval SymbolPath as PCWSTR, byval DebugFilePath as PWSTR, byval Callback as PFIND_DEBUG_FILE_CALLBACKW, byval CallerData as PVOID) as HANDLE

#ifdef UNICODE
	declare function SymFindFileInPath(byval hprocess as HANDLE, byval SearchPathW as PCSTR, byval FileName as PCSTR, byval id as PVOID, byval two as DWORD, byval three as DWORD, byval flags as DWORD, byval FoundFile as LPSTR, byval callback as PFINDFILEINPATHCALLBACK, byval context as PVOID) as WINBOOL
	declare function SymFindFileInPathW(byval hprocess as HANDLE, byval SearchPathW as PCWSTR, byval FileName as PCWSTR, byval id as PVOID, byval two as DWORD, byval three as DWORD, byval flags as DWORD, byval FoundFile as LPSTR, byval callback as PFINDFILEINPATHCALLBACKW, byval context as PVOID) as WINBOOL
#else
	declare function SymFindFileInPath(byval hprocess as HANDLE, byval SearchPathA as PCSTR, byval FileName as PCSTR, byval id as PVOID, byval two as DWORD, byval three as DWORD, byval flags as DWORD, byval FoundFile as LPSTR, byval callback as PFINDFILEINPATHCALLBACK, byval context as PVOID) as WINBOOL
	declare function SymFindFileInPathW(byval hprocess as HANDLE, byval SearchPathA as PCWSTR, byval FileName as PCWSTR, byval id as PVOID, byval two as DWORD, byval three as DWORD, byval flags as DWORD, byval FoundFile as LPSTR, byval callback as PFINDFILEINPATHCALLBACKW, byval context as PVOID) as WINBOOL
#endif

declare function FindExecutableImage(byval FileName as PCSTR, byval SymbolPath as PCSTR, byval ImageFilePath as PSTR) as HANDLE
declare function FindExecutableImageEx(byval FileName as PCSTR, byval SymbolPath as PCSTR, byval ImageFilePath as PSTR, byval Callback as PFIND_EXE_FILE_CALLBACK, byval CallerData as PVOID) as HANDLE
declare function FindExecutableImageExW(byval FileName as PCWSTR, byval SymbolPath as PCWSTR, byval ImageFilePath as PWSTR, byval Callback as PFIND_EXE_FILE_CALLBACKW, byval CallerData as PVOID) as HANDLE
declare function ImageNtHeader(byval Base_ as PVOID) as PIMAGE_NT_HEADERS
declare function ImageDirectoryEntryToDataEx(byval Base_ as PVOID, byval MappedAsImage as BOOLEAN, byval DirectoryEntry as USHORT, byval Size as PULONG, byval FoundHeader as PIMAGE_SECTION_HEADER ptr) as PVOID
declare function ImageDirectoryEntryToData(byval Base_ as PVOID, byval MappedAsImage as BOOLEAN, byval DirectoryEntry as USHORT, byval Size as PULONG) as PVOID
declare function ImageRvaToSection(byval NtHeaders as PIMAGE_NT_HEADERS, byval Base_ as PVOID, byval Rva as ULONG) as PIMAGE_SECTION_HEADER
declare function ImageRvaToVa(byval NtHeaders as PIMAGE_NT_HEADERS, byval Base_ as PVOID, byval Rva as ULONG, byval LastRvaSection as PIMAGE_SECTION_HEADER ptr) as PVOID

#define SSRVOPT_CALLBACK &h0001
#define SSRVOPT_DWORD &h0002
#define SSRVOPT_DWORDPTR &h0004
#define SSRVOPT_GUIDPTR &h0008
#define SSRVOPT_OLDGUIDPTR &h0010
#define SSRVOPT_UNATTENDED &h0020
#define SSRVOPT_NOCOPY &h0040
#define SSRVOPT_PARENTWIN &h0080
#define SSRVOPT_PARAMTYPE &h0100
#define SSRVOPT_SECURE &h0200
#define SSRVOPT_TRACE &h0400
#define SSRVOPT_SETCONTEXT &h0800
#define SSRVOPT_PROXY &h1000
#define SSRVOPT_DOWNSTREAM_STORE &h2000
#define SSRVOPT_RESET cast(ULONG_PTR, -1)
#define SSRVACTION_TRACE 1
#define SSRVACTION_QUERYCANCEL 2
#define SSRVACTION_EVENT 3

#ifndef __FB_64BIT__
	type _IMAGE_DEBUG_INFORMATION
		List as LIST_ENTRY
		ReservedSize as DWORD
		ReservedMappedBase as PVOID
		ReservedMachine as USHORT
		ReservedCharacteristics as USHORT
		ReservedCheckSum as DWORD
		ImageBase as DWORD
		SizeOfImage as DWORD
		ReservedNumberOfSections as DWORD
		ReservedSections as PIMAGE_SECTION_HEADER
		ReservedExportedNamesSize as DWORD
		ReservedExportedNames as PSTR
		ReservedNumberOfFunctionTableEntries as DWORD
		ReservedFunctionTableEntries as PIMAGE_FUNCTION_ENTRY
		ReservedLowestFunctionStartingAddress as DWORD
		ReservedHighestFunctionEndingAddress as DWORD
		ReservedNumberOfFpoTableEntries as DWORD
		ReservedFpoTableEntries as PFPO_DATA
		SizeOfCoffSymbols as DWORD
		CoffSymbols as PIMAGE_COFF_SYMBOLS_HEADER
		ReservedSizeOfCodeViewSymbols as DWORD
		ReservedCodeViewSymbols as PVOID
		ImageFilePath as PSTR
		ImageFileName as PSTR
		ReservedDebugFilePath as PSTR
		ReservedTimeDateStamp as DWORD
		ReservedRomImage as WINBOOL
		ReservedDebugDirectory as PIMAGE_DEBUG_DIRECTORY
		ReservedNumberOfDebugDirectories as DWORD
		ReservedOriginalFunctionTableBaseAddress as DWORD
		Reserved(0 to 1) as DWORD
	end type

	type IMAGE_DEBUG_INFORMATION as _IMAGE_DEBUG_INFORMATION
	type PIMAGE_DEBUG_INFORMATION as _IMAGE_DEBUG_INFORMATION ptr

	declare function MapDebugInformation(byval FileHandle as HANDLE, byval FileName as PSTR, byval SymbolPath as PSTR, byval ImageBase as DWORD) as PIMAGE_DEBUG_INFORMATION
	declare function UnmapDebugInformation(byval DebugInfo as PIMAGE_DEBUG_INFORMATION) as WINBOOL
#endif

type PENUMDIRTREE_CALLBACK as function(byval FilePath as LPCSTR, byval CallerData as PVOID) as WINBOOL

declare function SearchTreeForFile(byval RootPath as PSTR, byval InputPathName as PSTR, byval OutputPathBuffer as PSTR) as WINBOOL
declare function SearchTreeForFileW(byval RootPath as PWSTR, byval InputPathName as PWSTR, byval OutputPathBuffer as PWSTR) as WINBOOL
declare function EnumDirTree(byval hProcess as HANDLE, byval RootPath as PSTR, byval InputPathName as PSTR, byval OutputPathBuffer as PSTR, byval Callback as PENUMDIRTREE_CALLBACK, byval CallbackData as PVOID) as WINBOOL
declare function MakeSureDirectoryPathExists(byval DirPath as PCSTR) as WINBOOL

#define UNDNAME_COMPLETE &h0000
#define UNDNAME_NO_LEADING_UNDERSCORES &h0001
#define UNDNAME_NO_MS_KEYWORDS &h0002
#define UNDNAME_NO_FUNCTION_RETURNS &h0004
#define UNDNAME_NO_ALLOCATION_MODEL &h0008
#define UNDNAME_NO_ALLOCATION_LANGUAGE &h0010
#define UNDNAME_NO_MS_THISTYPE &h0020
#define UNDNAME_NO_CV_THISTYPE &h0040
#define UNDNAME_NO_THISTYPE &h0060
#define UNDNAME_NO_ACCESS_SPECIFIERS &h0080
#define UNDNAME_NO_THROW_SIGNATURES &h0100
#define UNDNAME_NO_MEMBER_TYPE &h0200
#define UNDNAME_NO_RETURN_UDT_MODEL &h0400
#define UNDNAME_32_BIT_DECODE &h0800
#define UNDNAME_NAME_ONLY &h1000
#define UNDNAME_NO_ARGUMENTS &h2000
#define UNDNAME_NO_SPECIAL_SYMS &h4000

declare function UnDecorateSymbolName(byval DecoratedName as PCSTR, byval UnDecoratedName as PSTR, byval UndecoratedLength as DWORD, byval Flags as DWORD) as DWORD
declare function UnDecorateSymbolNameW(byval DecoratedName as PCWSTR, byval UnDecoratedName as PWSTR, byval UndecoratedLength as DWORD, byval Flags as DWORD) as DWORD

#define DBHHEADER_DEBUGDIRS &h1
#define DBHHEADER_CVMISC &h2

type _MODLOAD_CVMISC
	oCV as DWORD
	cCV as uinteger
	oMisc as DWORD
	cMisc as uinteger
	dtImage as DWORD
	cImage as DWORD
end type

type MODLOAD_CVMISC as _MODLOAD_CVMISC
type PMODLOAD_CVMISC as _MODLOAD_CVMISC ptr

type ADDRESS_MODE as long
enum
	AddrMode1616
	AddrMode1632
	AddrModeReal
	AddrModeFlat
end enum

type _tagADDRESS64
	Offset as DWORD64
	Segment as WORD
	Mode as ADDRESS_MODE
end type

type ADDRESS64 as _tagADDRESS64
type LPADDRESS64 as _tagADDRESS64 ptr

#ifdef __FB_64BIT__
	#define ADDRESS ADDRESS64
	#define LPADDRESS LPADDRESS64
#else
	type _tagADDRESS
		Offset as DWORD
		Segment as WORD
		Mode as ADDRESS_MODE
	end type

	type ADDRESS as _tagADDRESS
	type LPADDRESS as _tagADDRESS ptr

	private sub Address32To64 cdecl(byval a32 as LPADDRESS, byval a64 as LPADDRESS64)
		a64->Offset
		'' TODO: a64->Offset = (ULONG64)(LONG64)(LONG)a32->Offset;
		a64->Segment
		'' TODO: a64->Segment = a32->Segment;
		a64->Mode
		'' TODO: a64->Mode = a32->Mode;
	end sub

	private sub Address64To32 cdecl(byval a64 as LPADDRESS64, byval a32 as LPADDRESS)
		a32->Offset
		'' TODO: a32->Offset = (ULONG)a64->Offset;
		a32->Segment
		'' TODO: a32->Segment = a64->Segment;
		a32->Mode
		'' TODO: a32->Mode = a64->Mode;
	end sub
#endif

type _KDHELP64
	Thread as DWORD64
	ThCallbackStack as DWORD
	ThCallbackBStore as DWORD
	NextCallback as DWORD
	FramePointer as DWORD
	KiCallUserMode as DWORD64
	KeUserCallbackDispatcher as DWORD64
	SystemRangeStart as DWORD64
	KiUserExceptionDispatcher as DWORD64
	StackBase as DWORD64
	StackLimit as DWORD64
	Reserved(0 to 4) as DWORD64
end type

type KDHELP64 as _KDHELP64
type PKDHELP64 as _KDHELP64 ptr

#ifdef __FB_64BIT__
	#define KDHELP KDHELP64
	#define PKDHELP PKDHELP64
#else
	type _KDHELP
		Thread as DWORD
		ThCallbackStack as DWORD
		NextCallback as DWORD
		FramePointer as DWORD
		KiCallUserMode as DWORD
		KeUserCallbackDispatcher as DWORD
		SystemRangeStart as DWORD
		ThCallbackBStore as DWORD
		KiUserExceptionDispatcher as DWORD
		StackBase as DWORD
		StackLimit as DWORD
		Reserved(0 to 4) as DWORD
	end type

	type KDHELP as _KDHELP
	type PKDHELP as _KDHELP ptr

	private sub KdHelp32To64 cdecl(byval p32 as PKDHELP, byval p64 as PKDHELP64)
		p64->Thread
		'' TODO: p64->Thread = p32->Thread;
		p64->ThCallbackStack
		'' TODO: p64->ThCallbackStack = p32->ThCallbackStack;
		p64->NextCallback
		'' TODO: p64->NextCallback = p32->NextCallback;
		p64->FramePointer
		'' TODO: p64->FramePointer = p32->FramePointer;
		p64->KiCallUserMode
		'' TODO: p64->KiCallUserMode = p32->KiCallUserMode;
		p64->KeUserCallbackDispatcher
		'' TODO: p64->KeUserCallbackDispatcher = p32->KeUserCallbackDispatcher;
		p64->SystemRangeStart
		'' TODO: p64->SystemRangeStart = p32->SystemRangeStart;
		p64->KiUserExceptionDispatcher
		'' TODO: p64->KiUserExceptionDispatcher = p32->KiUserExceptionDispatcher;
		p64->StackBase
		'' TODO: p64->StackBase = p32->StackBase;
		p64->StackLimit
		'' TODO: p64->StackLimit = p32->StackLimit;
	end sub
#endif

type _tagSTACKFRAME64
	AddrPC as ADDRESS64
	AddrReturn as ADDRESS64
	AddrFrame as ADDRESS64
	AddrStack as ADDRESS64
	AddrBStore as ADDRESS64
	FuncTableEntry as PVOID
	Params(0 to 3) as DWORD64
	Far as WINBOOL
	Virtual as WINBOOL
	Reserved(0 to 2) as DWORD64

	#ifdef __FB_64BIT__
		KdHelp_ as KDHELP64
	#else
		KdHelp as KDHELP64
	#endif
end type

type STACKFRAME64 as _tagSTACKFRAME64
type LPSTACKFRAME64 as _tagSTACKFRAME64 ptr

#ifdef __FB_64BIT__
	#define STACKFRAME STACKFRAME64
	#define LPSTACKFRAME LPSTACKFRAME64
#else
	type _tagSTACKFRAME
		AddrPC as ADDRESS
		AddrReturn as ADDRESS
		AddrFrame as ADDRESS
		AddrStack as ADDRESS
		FuncTableEntry as PVOID
		Params(0 to 3) as DWORD
		Far as WINBOOL
		Virtual as WINBOOL
		Reserved(0 to 2) as DWORD
		KdHelp as KDHELP
		AddrBStore as ADDRESS
	end type

	type STACKFRAME as _tagSTACKFRAME
	type LPSTACKFRAME as _tagSTACKFRAME ptr
#endif

type PREAD_PROCESS_MEMORY_ROUTINE64 as function(byval hProcess as HANDLE, byval qwBaseAddress as DWORD64, byval lpBuffer as PVOID, byval nSize as DWORD, byval lpNumberOfBytesRead as LPDWORD) as WINBOOL
type PFUNCTION_TABLE_ACCESS_ROUTINE64 as function(byval hProcess as HANDLE, byval AddrBase as DWORD64) as PVOID

#ifdef __FB_64BIT__
	type PGET_MODULE_BASE_ROUTINE64 as function(byval hProcess as HANDLE, byval Address_ as DWORD64) as DWORD64
#else
	type PGET_MODULE_BASE_ROUTINE64 as function(byval hProcess as HANDLE, byval Address as DWORD64) as DWORD64
#endif

type PTRANSLATE_ADDRESS_ROUTINE64 as function(byval hProcess as HANDLE, byval hThread as HANDLE, byval lpaddr as LPADDRESS64) as DWORD64

#ifdef __FB_64BIT__
	declare function StackWalk64(byval MachineType as DWORD, byval hProcess as HANDLE, byval hThread as HANDLE, byval StackFrame_ as LPSTACKFRAME64, byval ContextRecord as PVOID, byval ReadMemoryRoutine as PREAD_PROCESS_MEMORY_ROUTINE64, byval FunctionTableAccessRoutine as PFUNCTION_TABLE_ACCESS_ROUTINE64, byval GetModuleBaseRoutine as PGET_MODULE_BASE_ROUTINE64, byval TranslateAddress as PTRANSLATE_ADDRESS_ROUTINE64) as WINBOOL

	#define PREAD_PROCESS_MEMORY_ROUTINE PREAD_PROCESS_MEMORY_ROUTINE64
	#define PFUNCTION_TABLE_ACCESS_ROUTINE PFUNCTION_TABLE_ACCESS_ROUTINE64
	#define PGET_MODULE_BASE_ROUTINE PGET_MODULE_BASE_ROUTINE64
	#define PTRANSLATE_ADDRESS_ROUTINE PTRANSLATE_ADDRESS_ROUTINE64
	#define StackWalk StackWalk64
#else
	declare function StackWalk64(byval MachineType as DWORD, byval hProcess as HANDLE, byval hThread as HANDLE, byval StackFrame as LPSTACKFRAME64, byval ContextRecord as PVOID, byval ReadMemoryRoutine as PREAD_PROCESS_MEMORY_ROUTINE64, byval FunctionTableAccessRoutine as PFUNCTION_TABLE_ACCESS_ROUTINE64, byval GetModuleBaseRoutine as PGET_MODULE_BASE_ROUTINE64, byval TranslateAddress as PTRANSLATE_ADDRESS_ROUTINE64) as WINBOOL

	type PREAD_PROCESS_MEMORY_ROUTINE as function(byval hProcess as HANDLE, byval lpBaseAddress as DWORD, byval lpBuffer as PVOID, byval nSize as DWORD, byval lpNumberOfBytesRead as PDWORD) as WINBOOL
	type PFUNCTION_TABLE_ACCESS_ROUTINE as function(byval hProcess as HANDLE, byval AddrBase as DWORD) as PVOID
	type PGET_MODULE_BASE_ROUTINE as function(byval hProcess as HANDLE, byval Address as DWORD) as DWORD
	type PTRANSLATE_ADDRESS_ROUTINE as function(byval hProcess as HANDLE, byval hThread as HANDLE, byval lpaddr as LPADDRESS) as DWORD

	declare function StackWalk(byval MachineType as DWORD, byval hProcess as HANDLE, byval hThread as HANDLE, byval StackFrame as LPSTACKFRAME, byval ContextRecord as PVOID, byval ReadMemoryRoutine as PREAD_PROCESS_MEMORY_ROUTINE, byval FunctionTableAccessRoutine as PFUNCTION_TABLE_ACCESS_ROUTINE, byval GetModuleBaseRoutine as PGET_MODULE_BASE_ROUTINE, byval TranslateAddress as PTRANSLATE_ADDRESS_ROUTINE) as WINBOOL
#endif

#define API_VERSION_NUMBER 11

type API_VERSION
	MajorVersion as USHORT
	MinorVersion as USHORT
	Revision as USHORT
	Reserved as USHORT
end type

type LPAPI_VERSION as API_VERSION ptr

declare function ImagehlpApiVersion() as LPAPI_VERSION
declare function ImagehlpApiVersionEx(byval AppVersion as LPAPI_VERSION) as LPAPI_VERSION
declare function GetTimestampForLoadedLibrary(byval Module as HMODULE) as DWORD

type PSYM_ENUMMODULES_CALLBACK64 as function(byval ModuleName as PCSTR, byval BaseOfDll as DWORD64, byval UserContext as PVOID) as WINBOOL
type PSYM_ENUMMODULES_CALLBACKW64 as function(byval ModuleName as PCWSTR, byval BaseOfDll as DWORD64, byval UserContext as PVOID) as WINBOOL
type PSYM_ENUMSYMBOLS_CALLBACK64 as function(byval SymbolName as PCSTR, byval SymbolAddress as DWORD64, byval SymbolSize as ULONG, byval UserContext as PVOID) as WINBOOL
type PSYM_ENUMSYMBOLS_CALLBACK64W as function(byval SymbolName as PCWSTR, byval SymbolAddress as DWORD64, byval SymbolSize as ULONG, byval UserContext as PVOID) as WINBOOL
type PENUMLOADED_MODULES_CALLBACK64 as function(byval ModuleName as PCSTR, byval ModuleBase as DWORD64, byval ModuleSize as ULONG, byval UserContext as PVOID) as WINBOOL
type PENUMLOADED_MODULES_CALLBACKW64 as function(byval ModuleName as PCWSTR, byval ModuleBase as DWORD64, byval ModuleSize as ULONG, byval UserContext as PVOID) as WINBOOL
type PSYMBOL_REGISTERED_CALLBACK64 as function(byval hProcess as HANDLE, byval ActionCode as ULONG, byval CallbackData as ULONG64, byval UserContext as ULONG64) as WINBOOL
type PSYMBOL_FUNCENTRY_CALLBACK as function(byval hProcess as HANDLE, byval AddrBase as DWORD, byval UserContext as PVOID) as PVOID
type PSYMBOL_FUNCENTRY_CALLBACK64 as function(byval hProcess as HANDLE, byval AddrBase as ULONG64, byval UserContext as ULONG64) as PVOID

#ifdef __FB_64BIT__
	#define PSYM_ENUMMODULES_CALLBACK PSYM_ENUMMODULES_CALLBACK64
	#define PSYM_ENUMSYMBOLS_CALLBACK PSYM_ENUMSYMBOLS_CALLBACK64
	#define PSYM_ENUMSYMBOLS_CALLBACKW PSYM_ENUMSYMBOLS_CALLBACK64W
	#define PENUMLOADED_MODULES_CALLBACK PENUMLOADED_MODULES_CALLBACK64
	#define PSYMBOL_REGISTERED_CALLBACK PSYMBOL_REGISTERED_CALLBACK64
	#define PSYMBOL_FUNCENTRY_CALLBACK_ PSYMBOL_FUNCENTRY_CALLBACK64
#else
	type PSYM_ENUMMODULES_CALLBACK as function(byval ModuleName as PCSTR, byval BaseOfDll as ULONG, byval UserContext as PVOID) as WINBOOL
	type PSYM_ENUMSYMBOLS_CALLBACK as function(byval SymbolName as PCSTR, byval SymbolAddress as ULONG, byval SymbolSize as ULONG, byval UserContext as PVOID) as WINBOOL
	type PSYM_ENUMSYMBOLS_CALLBACKW as function(byval SymbolName as PCWSTR, byval SymbolAddress as ULONG, byval SymbolSize as ULONG, byval UserContext as PVOID) as WINBOOL
	type PENUMLOADED_MODULES_CALLBACK as function(byval ModuleName as PCSTR, byval ModuleBase as ULONG, byval ModuleSize as ULONG, byval UserContext as PVOID) as WINBOOL
	type PSYMBOL_REGISTERED_CALLBACK as function(byval hProcess as HANDLE, byval ActionCode as ULONG, byval CallbackData as PVOID, byval UserContext as PVOID) as WINBOOL
#endif

type SYM_TYPE as long
enum
	SymNone = 0
	SymCoff
	SymCv
	SymPdb
	SymExport
	SymDeferred
	SymSym
	SymDia
	SymVirtual
	NumSymTypes
end enum

type _IMAGEHLP_SYMBOL64
	SizeOfStruct as DWORD

	#ifdef __FB_64BIT__
		Address_ as DWORD64
	#else
		Address as DWORD64
	#endif

	Size as DWORD
	Flags as DWORD
	MaxNameLength as DWORD
	Name as zstring * 1
end type

type IMAGEHLP_SYMBOL64 as _IMAGEHLP_SYMBOL64
type PIMAGEHLP_SYMBOL64 as _IMAGEHLP_SYMBOL64 ptr

type _IMAGEHLP_SYMBOL64_PACKAGE
	sym as IMAGEHLP_SYMBOL64
	name as zstring * 2000 + 1
end type

type IMAGEHLP_SYMBOL64_PACKAGE as _IMAGEHLP_SYMBOL64_PACKAGE
type PIMAGEHLP_SYMBOL64_PACKAGE as _IMAGEHLP_SYMBOL64_PACKAGE ptr

#ifdef __FB_64BIT__
	#define IMAGEHLP_SYMBOL IMAGEHLP_SYMBOL64
	#define PIMAGEHLP_SYMBOL PIMAGEHLP_SYMBOL64
	#define IMAGEHLP_SYMBOL_PACKAGE IMAGEHLP_SYMBOL64_PACKAGE
	#define PIMAGEHLP_SYMBOL_PACKAGE PIMAGEHLP_SYMBOL64_PACKAGE
#else
	type _IMAGEHLP_SYMBOL
		SizeOfStruct as DWORD
		Address as DWORD
		Size as DWORD
		Flags as DWORD
		MaxNameLength as DWORD
		Name as zstring * 1
	end type

	type IMAGEHLP_SYMBOL as _IMAGEHLP_SYMBOL
	type PIMAGEHLP_SYMBOL as _IMAGEHLP_SYMBOL ptr

	type _IMAGEHLP_SYMBOL_PACKAGE
		sym as IMAGEHLP_SYMBOL
		name as zstring * 2000 + 1
	end type

	type IMAGEHLP_SYMBOL_PACKAGE as _IMAGEHLP_SYMBOL_PACKAGE
	type PIMAGEHLP_SYMBOL_PACKAGE as _IMAGEHLP_SYMBOL_PACKAGE ptr
#endif

type _IMAGEHLP_MODULE64
	SizeOfStruct as DWORD
	BaseOfImage as DWORD64
	ImageSize as DWORD
	TimeDateStamp as DWORD
	CheckSum as DWORD
	NumSyms as DWORD
	SymType as SYM_TYPE
	ModuleName as zstring * 32
	ImageName as zstring * 256
	LoadedImageName as zstring * 256
	LoadedPdbName as zstring * 256
	CVSig as DWORD
	CVData as zstring * 260 * 3
	PdbSig as DWORD
	PdbSig70 as GUID
	PdbAge as DWORD
	PdbUnmatched as WINBOOL
	DbgUnmatched as WINBOOL
	LineNumbers as WINBOOL
	GlobalSymbols as WINBOOL
	TypeInfo as WINBOOL
	SourceIndexed as WINBOOL
	Publics as WINBOOL
end type

type IMAGEHLP_MODULE64 as _IMAGEHLP_MODULE64
type PIMAGEHLP_MODULE64 as _IMAGEHLP_MODULE64 ptr

type _IMAGEHLP_MODULE64W
	SizeOfStruct as DWORD
	BaseOfImage as DWORD64
	ImageSize as DWORD
	TimeDateStamp as DWORD
	CheckSum as DWORD
	NumSyms as DWORD
	SymType as SYM_TYPE
	ModuleName as wstring * 32
	ImageName as wstring * 256
	LoadedImageName as wstring * 256
	LoadedPdbName as wstring * 256
	CVSig as DWORD
	CVData as wstring * 260 * 3
	PdbSig as DWORD
	PdbSig70 as GUID
	PdbAge as DWORD
	PdbUnmatched as WINBOOL
	DbgUnmatched as WINBOOL
	LineNumbers as WINBOOL
	GlobalSymbols as WINBOOL
	TypeInfo as WINBOOL
	SourceIndexed as WINBOOL
	Publics as WINBOOL
end type

type IMAGEHLP_MODULEW64 as _IMAGEHLP_MODULE64W
type PIMAGEHLP_MODULEW64 as _IMAGEHLP_MODULE64W ptr

#ifdef __FB_64BIT__
	#define IMAGEHLP_MODULE IMAGEHLP_MODULE64
	#define PIMAGEHLP_MODULE PIMAGEHLP_MODULE64
	#define IMAGEHLP_MODULEW IMAGEHLP_MODULEW64
	#define PIMAGEHLP_MODULEW PIMAGEHLP_MODULEW64
#else
	type _IMAGEHLP_MODULE
		SizeOfStruct as DWORD
		BaseOfImage as DWORD
		ImageSize as DWORD
		TimeDateStamp as DWORD
		CheckSum as DWORD
		NumSyms as DWORD
		SymType as SYM_TYPE
		ModuleName as zstring * 32
		ImageName as zstring * 256
		LoadedImageName as zstring * 256
	end type

	type IMAGEHLP_MODULE as _IMAGEHLP_MODULE
	type PIMAGEHLP_MODULE as _IMAGEHLP_MODULE ptr

	type _IMAGEHLP_MODULEW
		SizeOfStruct as DWORD
		BaseOfImage as DWORD
		ImageSize as DWORD
		TimeDateStamp as DWORD
		CheckSum as DWORD
		NumSyms as DWORD
		SymType as SYM_TYPE
		ModuleName as wstring * 32
		ImageName as wstring * 256
		LoadedImageName as wstring * 256
	end type

	type IMAGEHLP_MODULEW as _IMAGEHLP_MODULEW
	type PIMAGEHLP_MODULEW as _IMAGEHLP_MODULEW ptr
#endif

type _IMAGEHLP_LINE64
	SizeOfStruct as DWORD
	Key as PVOID
	LineNumber as DWORD
	FileName as PCHAR

	#ifdef __FB_64BIT__
		Address_ as DWORD64
	#else
		Address as DWORD64
	#endif
end type

type IMAGEHLP_LINE64 as _IMAGEHLP_LINE64
type PIMAGEHLP_LINE64 as _IMAGEHLP_LINE64 ptr

type _IMAGEHLP_LINEW64
	SizeOfStruct as DWORD
	Key as PVOID
	LineNumber as DWORD
	FileName as PWSTR

	#ifdef __FB_64BIT__
		Address_ as DWORD64
	#else
		Address as DWORD64
	#endif
end type

type IMAGEHLP_LINEW64 as _IMAGEHLP_LINEW64
type PIMAGEHLP_LINEW64 as _IMAGEHLP_LINEW64 ptr

#ifdef __FB_64BIT__
	#define IMAGEHLP_LINE IMAGEHLP_LINE64
	#define PIMAGEHLP_LINE PIMAGEHLP_LINE64
#else
	type _IMAGEHLP_LINE
		SizeOfStruct as DWORD
		Key as PVOID
		LineNumber as DWORD
		FileName as PCHAR
		Address as DWORD
	end type

	type IMAGEHLP_LINE as _IMAGEHLP_LINE
	type PIMAGEHLP_LINE as _IMAGEHLP_LINE ptr
#endif

type _SOURCEFILE
	ModBase as DWORD64
	FileName as PCHAR
end type

type SOURCEFILE as _SOURCEFILE
type PSOURCEFILE as _SOURCEFILE ptr

type _SOURCEFILEW
	ModBase as DWORD64
	FileName as PWCHAR
end type

type SOURCEFILEW as _SOURCEFILEW
type PSOURCEFILEW as _SOURCEFILEW ptr

#define CBA_DEFERRED_SYMBOL_LOAD_START &h00000001
#define CBA_DEFERRED_SYMBOL_LOAD_COMPLETE &h00000002
#define CBA_DEFERRED_SYMBOL_LOAD_FAILURE &h00000003
#define CBA_SYMBOLS_UNLOADED &h00000004
#define CBA_DUPLICATE_SYMBOL &h00000005
#define CBA_READ_MEMORY &h00000006
#define CBA_DEFERRED_SYMBOL_LOAD_CANCEL &h00000007
#define CBA_SET_OPTIONS &h00000008
#define CBA_EVENT &h00000010
#define CBA_DEFERRED_SYMBOL_LOAD_PARTIAL &h00000020
#define CBA_DEBUG_INFO &h10000000
#define CBA_SRCSRV_INFO &h20000000
#define CBA_SRCSRV_EVENT &h40000000

type _IMAGEHLP_CBA_READ_MEMORY
	addr as DWORD64
	buf as PVOID
	bytes as DWORD
	bytesread as DWORD ptr
end type

type IMAGEHLP_CBA_READ_MEMORY as _IMAGEHLP_CBA_READ_MEMORY
type PIMAGEHLP_CBA_READ_MEMORY as _IMAGEHLP_CBA_READ_MEMORY ptr

enum
	sevInfo = 0
	sevProblem
	sevAttn
	sevFatal
	sevMax
end enum

type _IMAGEHLP_CBA_EVENT
	severity as DWORD
	code as DWORD
	desc as PCHAR
	object as PVOID
end type

type IMAGEHLP_CBA_EVENT as _IMAGEHLP_CBA_EVENT
type PIMAGEHLP_CBA_EVENT as _IMAGEHLP_CBA_EVENT ptr

type _IMAGEHLP_DEFERRED_SYMBOL_LOAD64
	SizeOfStruct as DWORD
	BaseOfImage as DWORD64
	CheckSum as DWORD
	TimeDateStamp as DWORD
	FileName as zstring * 260
	Reparse as BOOLEAN
	hFile as HANDLE
	Flags as DWORD
end type

type IMAGEHLP_DEFERRED_SYMBOL_LOAD64 as _IMAGEHLP_DEFERRED_SYMBOL_LOAD64
type PIMAGEHLP_DEFERRED_SYMBOL_LOAD64 as _IMAGEHLP_DEFERRED_SYMBOL_LOAD64 ptr

#define DSLFLAG_MISMATCHED_PDB &h1
#define DSLFLAG_MISMATCHED_DBG &h2

#ifdef __FB_64BIT__
	#define IMAGEHLP_DEFERRED_SYMBOL_LOAD IMAGEHLP_DEFERRED_SYMBOL_LOAD64
	#define PIMAGEHLP_DEFERRED_SYMBOL_LOAD PIMAGEHLP_DEFERRED_SYMBOL_LOAD64
#else
	type _IMAGEHLP_DEFERRED_SYMBOL_LOAD
		SizeOfStruct as DWORD
		BaseOfImage as DWORD
		CheckSum as DWORD
		TimeDateStamp as DWORD
		FileName as zstring * 260
		Reparse as BOOLEAN
		hFile as HANDLE
	end type

	type IMAGEHLP_DEFERRED_SYMBOL_LOAD as _IMAGEHLP_DEFERRED_SYMBOL_LOAD
	type PIMAGEHLP_DEFERRED_SYMBOL_LOAD as _IMAGEHLP_DEFERRED_SYMBOL_LOAD ptr
#endif

type _IMAGEHLP_DUPLICATE_SYMBOL64
	SizeOfStruct as DWORD
	NumberOfDups as DWORD
	Symbol as PIMAGEHLP_SYMBOL64
	SelectedSymbol as DWORD
end type

type IMAGEHLP_DUPLICATE_SYMBOL64 as _IMAGEHLP_DUPLICATE_SYMBOL64
type PIMAGEHLP_DUPLICATE_SYMBOL64 as _IMAGEHLP_DUPLICATE_SYMBOL64 ptr

#ifdef __FB_64BIT__
	#define IMAGEHLP_DUPLICATE_SYMBOL IMAGEHLP_DUPLICATE_SYMBOL64
	#define PIMAGEHLP_DUPLICATE_SYMBOL PIMAGEHLP_DUPLICATE_SYMBOL64
#else
	type _IMAGEHLP_DUPLICATE_SYMBOL
		SizeOfStruct as DWORD
		NumberOfDups as DWORD
		Symbol as PIMAGEHLP_SYMBOL
		SelectedSymbol as DWORD
	end type

	type IMAGEHLP_DUPLICATE_SYMBOL as _IMAGEHLP_DUPLICATE_SYMBOL
	type PIMAGEHLP_DUPLICATE_SYMBOL as _IMAGEHLP_DUPLICATE_SYMBOL ptr
#endif

type _SYMSRV_INDEX_INFO
	sizeofstruct as DWORD
	file as zstring * 260 + 1
	stripped as WINBOOL
	timestamp as DWORD
	size as DWORD
	dbgfile as zstring * 260 + 1
	pdbfile as zstring * 260 + 1
	guid as GUID
	sig as DWORD
	age as DWORD
end type

type SYMSRV_INDEX_INFO as _SYMSRV_INDEX_INFO
type PSYMSRV_INDEX_INFO as _SYMSRV_INDEX_INFO ptr

type _SYMSRV_INDEX_INFOW
	sizeofstruct as DWORD
	file as wstring * 260 + 1
	stripped as WINBOOL
	timestamp as DWORD
	size as DWORD
	dbgfile as wstring * 260 + 1
	pdbfile as wstring * 260 + 1
	guid as GUID
	sig as DWORD
	age as DWORD
end type

type SYMSRV_INDEX_INFOW as _SYMSRV_INDEX_INFOW
type PSYMSRV_INDEX_INFOW as _SYMSRV_INDEX_INFOW ptr

declare function SymSetParentWindow(byval hwnd as HWND) as WINBOOL
declare function SymSetHomeDirectory(byval hProcess as HANDLE, byval dir_ as PCSTR) as PCHAR
declare function SymSetHomeDirectoryW(byval hProcess as HANDLE, byval dir_ as PCWSTR) as PCHAR
declare function SymGetHomeDirectory(byval type_ as DWORD, byval dir_ as PSTR, byval size as uinteger) as PCHAR
declare function SymGetHomeDirectoryW(byval type_ as DWORD, byval dir_ as PWSTR, byval size as uinteger) as PWCHAR

#define hdBase 0
#define hdSym 1
#define hdSrc 2
#define hdMax 3
#define SYMOPT_CASE_INSENSITIVE &h00000001
#define SYMOPT_UNDNAME &h00000002
#define SYMOPT_DEFERRED_LOADS &h00000004
#define SYMOPT_NO_CPP &h00000008
#define SYMOPT_LOAD_LINES &h00000010
#define SYMOPT_OMAP_FIND_NEAREST &h00000020
#define SYMOPT_LOAD_ANYTHING &h00000040
#define SYMOPT_IGNORE_CVREC &h00000080
#define SYMOPT_NO_UNQUALIFIED_LOADS &h00000100
#define SYMOPT_FAIL_CRITICAL_ERRORS &h00000200
#define SYMOPT_EXACT_SYMBOLS &h00000400
#define SYMOPT_ALLOW_ABSOLUTE_SYMBOLS &h00000800
#define SYMOPT_IGNORE_NT_SYMPATH &h00001000
#define SYMOPT_INCLUDE_32BIT_MODULES &h00002000
#define SYMOPT_PUBLICS_ONLY &h00004000
#define SYMOPT_NO_PUBLICS &h00008000
#define SYMOPT_AUTO_PUBLICS &h00010000
#define SYMOPT_NO_IMAGE_SEARCH &h00020000
#define SYMOPT_SECURE &h00040000
#define SYMOPT_NO_PROMPTS &h00080000
#define SYMOPT_ALLOW_ZERO_ADDRESS &h01000000
#define SYMOPT_DISABLE_SYMSRV_AUTODETECT &h02000000
#define SYMOPT_FAVOR_COMPRESSED &h00800000
#define SYMOPT_FLAT_DIRECTORY &h00400000
#define SYMOPT_IGNORE_IMAGEDIR &h00200000
#define SYMOPT_OVERWRITE &h00100000
#define SYMOPT_DEBUG &h80000000

declare function SymSetOptions(byval SymOptions as DWORD) as DWORD
declare function SymGetOptions() as DWORD
declare function SymCleanup(byval hProcess as HANDLE) as WINBOOL
declare function SymMatchString(byval string_ as PCSTR, byval expression as PCSTR, byval fCase as WINBOOL) as WINBOOL
declare function SymMatchStringW(byval string_ as PCWSTR, byval expression as PCWSTR, byval fCase as WINBOOL) as WINBOOL

type PSYM_ENUMSOURCEFILES_CALLBACK as function(byval pSourceFile as PSOURCEFILE, byval UserContext as PVOID) as WINBOOL
type PSYM_ENUMSOURCEFILES_CALLBACKW as function(byval pSourceFile as PSOURCEFILEW, byval UserContext as PVOID) as WINBOOL

#define PSYM_ENUMSOURCFILES_CALLBACK PSYM_ENUMSOURCEFILES_CALLBACK

declare function SymEnumSourceFiles(byval hProcess as HANDLE, byval ModBase as ULONG64, byval Mask as PCSTR, byval cbSrcFiles as PSYM_ENUMSOURCEFILES_CALLBACK, byval UserContext as PVOID) as WINBOOL
declare function SymEnumSourceFilesW(byval hProcess as HANDLE, byval ModBase as ULONG64, byval Mask as PCWSTR, byval cbSrcFiles as PSYM_ENUMSOURCEFILES_CALLBACKW, byval UserContext as PVOID) as WINBOOL
declare function SymEnumerateModules64(byval hProcess as HANDLE, byval EnumModulesCallback as PSYM_ENUMMODULES_CALLBACK64, byval UserContext as PVOID) as WINBOOL
declare function SymEnumerateModulesW64(byval hProcess as HANDLE, byval EnumModulesCallback as PSYM_ENUMMODULES_CALLBACKW64, byval UserContext as PVOID) as WINBOOL

#ifdef __FB_64BIT__
	#define SymEnumerateModules SymEnumerateModules64
#else
	declare function SymEnumerateModules(byval hProcess as HANDLE, byval EnumModulesCallback as PSYM_ENUMMODULES_CALLBACK, byval UserContext as PVOID) as WINBOOL
#endif

declare function SymEnumerateSymbols64(byval hProcess as HANDLE, byval BaseOfDll as DWORD64, byval EnumSymbolsCallback as PSYM_ENUMSYMBOLS_CALLBACK64, byval UserContext as PVOID) as WINBOOL
declare function SymEnumerateSymbolsW64(byval hProcess as HANDLE, byval BaseOfDll as DWORD64, byval EnumSymbolsCallback as PSYM_ENUMSYMBOLS_CALLBACK64W, byval UserContext as PVOID) as WINBOOL

#ifdef __FB_64BIT__
	#define SymEnumerateSymbols SymEnumerateSymbols64
	#define SymEnumerateSymbolsW SymEnumerateSymbolsW64
#else
	declare function SymEnumerateSymbols(byval hProcess as HANDLE, byval BaseOfDll as DWORD, byval EnumSymbolsCallback as PSYM_ENUMSYMBOLS_CALLBACK, byval UserContext as PVOID) as WINBOOL
	declare function SymEnumerateSymbolsW(byval hProcess as HANDLE, byval BaseOfDll as DWORD, byval EnumSymbolsCallback as PSYM_ENUMSYMBOLS_CALLBACKW, byval UserContext as PVOID) as WINBOOL
#endif

declare function EnumerateLoadedModules64(byval hProcess as HANDLE, byval EnumLoadedModulesCallback as PENUMLOADED_MODULES_CALLBACK64, byval UserContext as PVOID) as WINBOOL
declare function EnumerateLoadedModulesW64(byval hProcess as HANDLE, byval EnumLoadedModulesCallback as PENUMLOADED_MODULES_CALLBACKW64, byval UserContext as PVOID) as WINBOOL

#ifdef __FB_64BIT__
	#define EnumerateLoadedModules EnumerateLoadedModules64
#else
	declare function EnumerateLoadedModules(byval hProcess as HANDLE, byval EnumLoadedModulesCallback as PENUMLOADED_MODULES_CALLBACK, byval UserContext as PVOID) as WINBOOL
#endif

declare function SymFunctionTableAccess64(byval hProcess as HANDLE, byval AddrBase as DWORD64) as PVOID

#ifdef __FB_64BIT__
	#define SymFunctionTableAccess SymFunctionTableAccess64
#else
	declare function SymFunctionTableAccess(byval hProcess as HANDLE, byval AddrBase as DWORD) as PVOID
#endif

declare function SymGetModuleInfo64(byval hProcess as HANDLE, byval qwAddr as DWORD64, byval ModuleInfo as PIMAGEHLP_MODULE64) as WINBOOL
declare function SymGetModuleInfoW64(byval hProcess as HANDLE, byval qwAddr as DWORD64, byval ModuleInfo as PIMAGEHLP_MODULEW64) as WINBOOL

#ifdef __FB_64BIT__
	#define SymGetModuleInfo SymGetModuleInfo64
	#define SymGetModuleInfoW SymGetModuleInfoW64
#else
	declare function SymGetModuleInfo(byval hProcess as HANDLE, byval dwAddr as DWORD, byval ModuleInfo as PIMAGEHLP_MODULE) as WINBOOL
	declare function SymGetModuleInfoW(byval hProcess as HANDLE, byval dwAddr as DWORD, byval ModuleInfo as PIMAGEHLP_MODULEW) as WINBOOL
#endif

declare function SymGetModuleBase64(byval hProcess as HANDLE, byval qwAddr as DWORD64) as DWORD64

#ifdef __FB_64BIT__
	#define SymGetModuleBase SymGetModuleBase64
#else
	declare function SymGetModuleBase(byval hProcess as HANDLE, byval dwAddr as DWORD) as DWORD
#endif

declare function SymGetSymNext64(byval hProcess as HANDLE, byval Symbol as PIMAGEHLP_SYMBOL64) as WINBOOL

#ifdef __FB_64BIT__
	#define SymGetSymNext SymGetSymNext64
#else
	declare function SymGetSymNext(byval hProcess as HANDLE, byval Symbol as PIMAGEHLP_SYMBOL) as WINBOOL
#endif

declare function SymGetSymPrev64(byval hProcess as HANDLE, byval Symbol as PIMAGEHLP_SYMBOL64) as WINBOOL

#ifdef __FB_64BIT__
	#define SymGetSymPrev SymGetSymPrev64
#else
	declare function SymGetSymPrev(byval hProcess as HANDLE, byval Symbol as PIMAGEHLP_SYMBOL) as WINBOOL
#endif

type _SRCCODEINFO
	SizeOfStruct as DWORD
	Key as PVOID
	ModBase as DWORD64
	Obj as zstring * 260 + 1
	FileName as zstring * 260 + 1
	LineNumber as DWORD

	#ifdef __FB_64BIT__
		Address_ as DWORD64
	#else
		Address as DWORD64
	#endif
end type

type SRCCODEINFO as _SRCCODEINFO
type PSRCCODEINFO as _SRCCODEINFO ptr

type _SRCCODEINFOW
	SizeOfStruct as DWORD
	Key as PVOID
	ModBase as DWORD64
	Obj as wstring * 260 + 1
	FileName as wstring * 260 + 1
	LineNumber as DWORD

	#ifdef __FB_64BIT__
		Address_ as DWORD64
	#else
		Address as DWORD64
	#endif
end type

type SRCCODEINFOW as _SRCCODEINFOW
type PSRCCODEINFOW as _SRCCODEINFOW ptr
type PSYM_ENUMLINES_CALLBACK as function(byval LineInfo as PSRCCODEINFO, byval UserContext as PVOID) as WINBOOL
type PSYM_ENUMLINES_CALLBACKW as function(byval LineInfo as PSRCCODEINFOW, byval UserContext as PVOID) as WINBOOL

declare function SymEnumLines(byval hProcess as HANDLE, byval Base_ as ULONG64, byval Obj as PCSTR, byval File as PCSTR, byval EnumLinesCallback as PSYM_ENUMLINES_CALLBACK, byval UserContext as PVOID) as WINBOOL
declare function SymEnumLinesW(byval hProcess as HANDLE, byval Base_ as ULONG64, byval Obj as PCWSTR, byval File as PCSTR, byval EnumLinesCallback as PSYM_ENUMLINES_CALLBACKW, byval UserContext as PVOID) as WINBOOL
declare function SymGetLineFromAddr64(byval hProcess as HANDLE, byval qwAddr as DWORD64, byval pdwDisplacement as PDWORD, byval Line64 as PIMAGEHLP_LINE64) as WINBOOL
declare function SymGetLineFromAddrW64(byval hProcess as HANDLE, byval qwAddr as DWORD64, byval pdwDisplacement as PDWORD, byval Line64 as PIMAGEHLP_LINEW64) as WINBOOL

#ifdef __FB_64BIT__
	#define SymGetLineFromAddr SymGetLineFromAddr64
#else
	declare function SymGetLineFromAddr(byval hProcess as HANDLE, byval dwAddr as DWORD, byval pdwDisplacement as PDWORD, byval Line_ as PIMAGEHLP_LINE) as WINBOOL
#endif

declare function SymGetLineFromName64(byval hProcess as HANDLE, byval ModuleName as PCSTR, byval FileName as PCSTR, byval dwLineNumber as DWORD, byval plDisplacement as PLONG, byval Line_ as PIMAGEHLP_LINE64) as WINBOOL
declare function SymGetLineFromNameW64(byval hProcess as HANDLE, byval ModuleName as PCWSTR, byval FileName as PCWSTR, byval dwLineNumber as DWORD, byval plDisplacement as PLONG, byval Line_ as PIMAGEHLP_LINEW64) as WINBOOL

#ifdef __FB_64BIT__
	#define SymGetLineFromName SymGetLineFromName64
#else
	declare function SymGetLineFromName(byval hProcess as HANDLE, byval ModuleName as PCSTR, byval FileName as PCSTR, byval dwLineNumber as DWORD, byval plDisplacement as PLONG, byval Line_ as PIMAGEHLP_LINE) as WINBOOL
#endif

declare function SymGetLineNext64(byval hProcess as HANDLE, byval Line_ as PIMAGEHLP_LINE64) as WINBOOL
declare function SymGetLineNextW64(byval hProcess as HANDLE, byval Line_ as PIMAGEHLP_LINEW64) as WINBOOL

#ifdef __FB_64BIT__
	#define SymGetLineNext SymGetLineNext64
#else
	declare function SymGetLineNext(byval hProcess as HANDLE, byval Line_ as PIMAGEHLP_LINE) as WINBOOL
#endif

declare function SymGetLinePrev64(byval hProcess as HANDLE, byval Line_ as PIMAGEHLP_LINE64) as WINBOOL
declare function SymGetLinePrevW64(byval hProcess as HANDLE, byval Line_ as PIMAGEHLP_LINEW64) as WINBOOL

#ifdef __FB_64BIT__
	#define SymGetLinePrev SymGetLinePrev64
#else
	declare function SymGetLinePrev(byval hProcess as HANDLE, byval Line_ as PIMAGEHLP_LINE) as WINBOOL
#endif

declare function SymMatchFileName(byval FileName as PCSTR, byval Match as PCSTR, byval FileNameStop as PSTR ptr, byval MatchStop as PSTR ptr) as WINBOOL
declare function SymMatchFileNameW(byval FileName as PCWSTR, byval Match as PCWSTR, byval FileNameStop as PWSTR ptr, byval MatchStop as PWSTR ptr) as WINBOOL
declare function SymInitialize(byval hProcess as HANDLE, byval UserSearchPath as PCSTR, byval fInvadeProcess as WINBOOL) as WINBOOL
declare function SymInitializeW(byval hProcess as HANDLE, byval UserSearchPath as PCWSTR, byval fInvadeProcess as WINBOOL) as WINBOOL

#ifdef UNICODE
	declare function SymGetSearchPath(byval hProcess as HANDLE, byval SearchPathW as PSTR, byval SearchPathLength as DWORD) as WINBOOL
	declare function SymGetSearchPathW(byval hProcess as HANDLE, byval SearchPathW as PWSTR, byval SearchPathLength as DWORD) as WINBOOL
	declare function SymSetSearchPath(byval hProcess as HANDLE, byval SearchPathW as PCSTR) as WINBOOL
	declare function SymSetSearchPathW(byval hProcess as HANDLE, byval SearchPathW as PCWSTR) as WINBOOL
#else
	declare function SymGetSearchPath(byval hProcess as HANDLE, byval SearchPathA as PSTR, byval SearchPathLength as DWORD) as WINBOOL
	declare function SymGetSearchPathW(byval hProcess as HANDLE, byval SearchPathA as PWSTR, byval SearchPathLength as DWORD) as WINBOOL
	declare function SymSetSearchPath(byval hProcess as HANDLE, byval SearchPathA as PCSTR) as WINBOOL
	declare function SymSetSearchPathW(byval hProcess as HANDLE, byval SearchPathA as PCWSTR) as WINBOOL
#endif

declare function SymLoadModule64(byval hProcess as HANDLE, byval hFile as HANDLE, byval ImageName as PSTR, byval ModuleName as PSTR, byval BaseOfDll as DWORD64, byval SizeOfDll as DWORD) as DWORD64

#define SLMFLAG_VIRTUAL &h1

declare function SymLoadModuleEx(byval hProcess as HANDLE, byval hFile as HANDLE, byval ImageName as PCSTR, byval ModuleName as PCSTR, byval BaseOfDll as DWORD64, byval DllSize as DWORD, byval Data_ as PMODLOAD_DATA, byval Flags as DWORD) as DWORD64
declare function SymLoadModuleExW(byval hProcess as HANDLE, byval hFile as HANDLE, byval ImageName as PCWSTR, byval ModuleName as PCWSTR, byval BaseOfDll as DWORD64, byval DllSize as DWORD, byval Data_ as PMODLOAD_DATA, byval Flags as DWORD) as DWORD64

#ifdef __FB_64BIT__
	#define SymLoadModule SymLoadModule64
#else
	declare function SymLoadModule(byval hProcess as HANDLE, byval hFile as HANDLE, byval ImageName as PCSTR, byval ModuleName as PCSTR, byval BaseOfDll as DWORD, byval SizeOfDll as DWORD) as DWORD
#endif

declare function SymUnloadModule64(byval hProcess as HANDLE, byval BaseOfDll as DWORD64) as WINBOOL

#ifdef __FB_64BIT__
	#define SymUnloadModule SymUnloadModule64
#else
	declare function SymUnloadModule(byval hProcess as HANDLE, byval BaseOfDll as DWORD) as WINBOOL
#endif

declare function SymUnDName64(byval sym as PIMAGEHLP_SYMBOL64, byval UnDecName as PSTR, byval UnDecNameLength as DWORD) as WINBOOL

#ifdef __FB_64BIT__
	#define SymUnDName SymUnDName64
#else
	declare function SymUnDName(byval sym as PIMAGEHLP_SYMBOL, byval UnDecName as PSTR, byval UnDecNameLength as DWORD) as WINBOOL
#endif

declare function SymRegisterCallback64(byval hProcess as HANDLE, byval CallbackFunction as PSYMBOL_REGISTERED_CALLBACK64, byval UserContext as ULONG64) as WINBOOL
declare function SymRegisterCallback64W(byval hProcess as HANDLE, byval CallbackFunction as PSYMBOL_REGISTERED_CALLBACK64, byval UserContext as ULONG64) as WINBOOL
declare function SymRegisterFunctionEntryCallback64(byval hProcess as HANDLE, byval CallbackFunction as PSYMBOL_FUNCENTRY_CALLBACK64, byval UserContext as ULONG64) as WINBOOL

#ifdef __FB_64BIT__
	#define SymRegisterCallback SymRegisterCallback64
	#define SymRegisterFunctionEntryCallback SymRegisterFunctionEntryCallback64
#else
	declare function SymRegisterCallback(byval hProcess as HANDLE, byval CallbackFunction as PSYMBOL_REGISTERED_CALLBACK, byval UserContext as PVOID) as WINBOOL
	declare function SymRegisterFunctionEntryCallback(byval hProcess as HANDLE, byval CallbackFunction as PSYMBOL_FUNCENTRY_CALLBACK, byval UserContext as PVOID) as WINBOOL
#endif

type _IMAGEHLP_SYMBOL_SRC
	sizeofstruct as DWORD
	as DWORD type
	file as zstring * 260
end type

type IMAGEHLP_SYMBOL_SRC as _IMAGEHLP_SYMBOL_SRC
type PIMAGEHLP_SYMBOL_SRC as _IMAGEHLP_SYMBOL_SRC ptr

type _MODULE_TYPE_INFO
	dataLength as USHORT
	leaf as USHORT
	data(0 to 0) as UBYTE
end type

type MODULE_TYPE_INFO as _MODULE_TYPE_INFO
type PMODULE_TYPE_INFO as _MODULE_TYPE_INFO ptr

type _SYMBOL_INFO
	SizeOfStruct as ULONG
	TypeIndex as ULONG
	Reserved(0 to 1) as ULONG64
	info as ULONG
	Size as ULONG
	ModBase as ULONG64
	Flags as ULONG
	Value as ULONG64

	#ifdef __FB_64BIT__
		Address_ as ULONG64
	#else
		Address as ULONG64
	#endif

	Register as ULONG
	Scope as ULONG
	Tag as ULONG
	NameLen as ULONG
	MaxNameLen as ULONG
	Name as zstring * 1
end type

type SYMBOL_INFO as _SYMBOL_INFO
type PSYMBOL_INFO as _SYMBOL_INFO ptr

type _SYMBOL_INFOW
	SizeOfStruct as ULONG
	TypeIndex as ULONG
	Reserved(0 to 1) as ULONG64
	info as ULONG
	Size as ULONG
	ModBase as ULONG64
	Flags as ULONG
	Value as ULONG64

	#ifdef __FB_64BIT__
		Address_ as ULONG64
	#else
		Address as ULONG64
	#endif

	Register as ULONG
	Scope as ULONG
	Tag as ULONG
	NameLen as ULONG
	MaxNameLen as ULONG
	Name as wstring * 1
end type

type SYMBOL_INFOW as _SYMBOL_INFOW
type PSYMBOL_INFOW as _SYMBOL_INFOW ptr

#define SYMFLAG_CLR_TOKEN &h00040000
#define SYMFLAG_CONSTANT &h00000100
#define SYMFLAG_EXPORT &h00000200
#define SYMFLAG_FORWARDER &h00000400
#define SYMFLAG_FRAMEREL &h00000020
#define SYMFLAG_FUNCTION &h00000800
#define SYMFLAG_ILREL &h00010000
#define SYMFLAG_LOCAL &h00000080
#define SYMFLAG_METADATA &h00020000
#define SYMFLAG_PARAMETER &h00000040
#define SYMFLAG_REGISTER &h00000008
#define SYMFLAG_REGREL &h00000010
#define SYMFLAG_SLOT &h00008000
#define SYMFLAG_THUNK &h00002000
#define SYMFLAG_TLSREL &h00004000
#define SYMFLAG_VALUEPRESENT &h00000001
#define SYMFLAG_VIRTUAL &h00001000

type _SYMBOL_INFO_PACKAGE
	si as SYMBOL_INFO
	name as zstring * 2000 + 1
end type

type SYMBOL_INFO_PACKAGE as _SYMBOL_INFO_PACKAGE
type PSYMBOL_INFO_PACKAGE as _SYMBOL_INFO_PACKAGE ptr

type _IMAGEHLP_STACK_FRAME
	InstructionOffset as ULONG64
	ReturnOffset as ULONG64
	FrameOffset as ULONG64
	StackOffset as ULONG64
	BackingStoreOffset as ULONG64
	FuncTableEntry as ULONG64
	Params(0 to 3) as ULONG64
	Reserved(0 to 4) as ULONG64
	Virtual as WINBOOL
	Reserved2 as ULONG
end type

type IMAGEHLP_STACK_FRAME as _IMAGEHLP_STACK_FRAME
type PIMAGEHLP_STACK_FRAME as _IMAGEHLP_STACK_FRAME ptr
type IMAGEHLP_CONTEXT as any
type PIMAGEHLP_CONTEXT as any ptr

#ifdef __FB_64BIT__
	declare function SymSetContext(byval hProcess as HANDLE, byval StackFrame_ as PIMAGEHLP_STACK_FRAME, byval Context as PIMAGEHLP_CONTEXT) as WINBOOL
	declare function SymFromAddr(byval hProcess as HANDLE, byval Address_ as DWORD64, byval Displacement as PDWORD64, byval Symbol as PSYMBOL_INFO) as WINBOOL
	declare function SymFromAddrW(byval hProcess as HANDLE, byval Address_ as DWORD64, byval Displacement as PDWORD64, byval Symbol as PSYMBOL_INFOW) as WINBOOL
#else
	declare function SymSetContext(byval hProcess as HANDLE, byval StackFrame as PIMAGEHLP_STACK_FRAME, byval Context as PIMAGEHLP_CONTEXT) as WINBOOL
	declare function SymFromAddr(byval hProcess as HANDLE, byval Address as DWORD64, byval Displacement as PDWORD64, byval Symbol as PSYMBOL_INFO) as WINBOOL
	declare function SymFromAddrW(byval hProcess as HANDLE, byval Address as DWORD64, byval Displacement as PDWORD64, byval Symbol as PSYMBOL_INFOW) as WINBOOL
#endif

declare function SymFromToken(byval hProcess as HANDLE, byval Base_ as DWORD64, byval Token as DWORD, byval Symbol as PSYMBOL_INFO) as WINBOOL
declare function SymFromTokenW(byval hProcess as HANDLE, byval Base_ as DWORD64, byval Token as DWORD, byval Symbol as PSYMBOL_INFOW) as WINBOOL
declare function SymFromName(byval hProcess as HANDLE, byval Name_ as PCSTR, byval Symbol as PSYMBOL_INFO) as WINBOOL
declare function SymFromNameW(byval hProcess as HANDLE, byval Name_ as PCWSTR, byval Symbol as PSYMBOL_INFOW) as WINBOOL

type PSYM_ENUMERATESYMBOLS_CALLBACK as function(byval pSymInfo as PSYMBOL_INFO, byval SymbolSize as ULONG, byval UserContext as PVOID) as WINBOOL
type PSYM_ENUMERATESYMBOLS_CALLBACKW as function(byval pSymInfo as PSYMBOL_INFOW, byval SymbolSize as ULONG, byval UserContext as PVOID) as WINBOOL

declare function SymEnumSymbols(byval hProcess as HANDLE, byval BaseOfDll as ULONG64, byval Mask as PCSTR, byval EnumSymbolsCallback as PSYM_ENUMERATESYMBOLS_CALLBACK, byval UserContext as PVOID) as WINBOOL
declare function SymEnumSymbolsW(byval hProcess as HANDLE, byval BaseOfDll as ULONG64, byval Mask as PCWSTR, byval EnumSymbolsCallback as PSYM_ENUMERATESYMBOLS_CALLBACKW, byval UserContext as PVOID) as WINBOOL

#ifdef __FB_64BIT__
	declare function SymEnumSymbolsForAddr(byval hProcess as HANDLE, byval Address_ as DWORD64, byval EnumSymbolsCallback as PSYM_ENUMERATESYMBOLS_CALLBACK, byval UserContext as PVOID) as WINBOOL
	declare function SymEnumSymbolsForAddrW(byval hProcess as HANDLE, byval Address_ as DWORD64, byval EnumSymbolsCallback as PSYM_ENUMERATESYMBOLS_CALLBACKW, byval UserContext as PVOID) as WINBOOL
#else
	declare function SymEnumSymbolsForAddr(byval hProcess as HANDLE, byval Address as DWORD64, byval EnumSymbolsCallback as PSYM_ENUMERATESYMBOLS_CALLBACK, byval UserContext as PVOID) as WINBOOL
	declare function SymEnumSymbolsForAddrW(byval hProcess as HANDLE, byval Address as DWORD64, byval EnumSymbolsCallback as PSYM_ENUMERATESYMBOLS_CALLBACKW, byval UserContext as PVOID) as WINBOOL
#endif

#define SYMENUMFLAG_FULLSRCH 1
#define SYMENUMFLAG_SPEEDSRCH 2

type _IMAGEHLP_SYMBOL_TYPE_INFO as long
enum
	TI_GET_SYMTAG
	TI_GET_SYMNAME
	TI_GET_LENGTH
	TI_GET_TYPE
	TI_GET_TYPEID
	TI_GET_BASETYPE
	TI_GET_ARRAYINDEXTYPEID
	TI_FINDCHILDREN
	TI_GET_DATAKIND
	TI_GET_ADDRESSOFFSET
	TI_GET_OFFSET
	TI_GET_VALUE
	TI_GET_COUNT
	TI_GET_CHILDRENCOUNT
	TI_GET_BITPOSITION
	TI_GET_VIRTUALBASECLASS
	TI_GET_VIRTUALTABLESHAPEID
	TI_GET_VIRTUALBASEPOINTEROFFSET
	TI_GET_CLASSPARENTID
	TI_GET_NESTED
	TI_GET_SYMINDEX
	TI_GET_LEXICALPARENT
	TI_GET_ADDRESS
	TI_GET_THISADJUST
	TI_GET_UDTKIND
	TI_IS_EQUIV_TO
	TI_GET_CALLING_CONVENTION
end enum

type IMAGEHLP_SYMBOL_TYPE_INFO as _IMAGEHLP_SYMBOL_TYPE_INFO

type _TI_FINDCHILDREN_PARAMS
	Count as ULONG
	Start as ULONG
	ChildId(0 to 0) as ULONG
end type

type TI_FINDCHILDREN_PARAMS as _TI_FINDCHILDREN_PARAMS

declare function SymGetTypeInfo(byval hProcess as HANDLE, byval ModBase as DWORD64, byval TypeId as ULONG, byval GetType as IMAGEHLP_SYMBOL_TYPE_INFO, byval pInfo as PVOID) as WINBOOL
declare function SymEnumTypes(byval hProcess as HANDLE, byval BaseOfDll as ULONG64, byval EnumSymbolsCallback as PSYM_ENUMERATESYMBOLS_CALLBACK, byval UserContext as PVOID) as WINBOOL
declare function SymEnumTypesW(byval hProcess as HANDLE, byval BaseOfDll as ULONG64, byval EnumSymbolsCallback as PSYM_ENUMERATESYMBOLS_CALLBACKW, byval UserContext as PVOID) as WINBOOL
declare function SymGetTypeFromName(byval hProcess as HANDLE, byval BaseOfDll as ULONG64, byval Name_ as PCSTR, byval Symbol as PSYMBOL_INFO) as WINBOOL
declare function SymGetTypeFromNameW(byval hProcess as HANDLE, byval BaseOfDll as ULONG64, byval Name_ as PCWSTR, byval Symbol as PSYMBOL_INFOW) as WINBOOL

#ifdef __FB_64BIT__
	declare function SymAddSymbol(byval hProcess as HANDLE, byval BaseOfDll as ULONG64, byval Name_ as PCSTR, byval Address_ as DWORD64, byval Size as DWORD, byval Flags as DWORD) as WINBOOL
	declare function SymAddSymbolW(byval hProcess as HANDLE, byval BaseOfDll as ULONG64, byval Name_ as PCWSTR, byval Address_ as DWORD64, byval Size as DWORD, byval Flags as DWORD) as WINBOOL
	declare function SymDeleteSymbol(byval hProcess as HANDLE, byval BaseOfDll as ULONG64, byval Name_ as PCSTR, byval Address_ as DWORD64, byval Flags as DWORD) as WINBOOL
	declare function SymDeleteSymbolW(byval hProcess as HANDLE, byval BaseOfDll as ULONG64, byval Name_ as PCWSTR, byval Address_ as DWORD64, byval Flags as DWORD) as WINBOOL
#else
	declare function SymAddSymbol(byval hProcess as HANDLE, byval BaseOfDll as ULONG64, byval Name_ as PCSTR, byval Address as DWORD64, byval Size as DWORD, byval Flags as DWORD) as WINBOOL
	declare function SymAddSymbolW(byval hProcess as HANDLE, byval BaseOfDll as ULONG64, byval Name_ as PCWSTR, byval Address as DWORD64, byval Size as DWORD, byval Flags as DWORD) as WINBOOL
	declare function SymDeleteSymbol(byval hProcess as HANDLE, byval BaseOfDll as ULONG64, byval Name_ as PCSTR, byval Address as DWORD64, byval Flags as DWORD) as WINBOOL
	declare function SymDeleteSymbolW(byval hProcess as HANDLE, byval BaseOfDll as ULONG64, byval Name_ as PCWSTR, byval Address as DWORD64, byval Flags as DWORD) as WINBOOL
#endif

type PDBGHELP_CREATE_USER_DUMP_CALLBACK as function(byval DataType as DWORD, byval Data_ as PVOID ptr, byval DataLength as LPDWORD, byval UserData as PVOID) as WINBOOL

declare function DbgHelpCreateUserDump(byval FileName as LPCSTR, byval Callback as PDBGHELP_CREATE_USER_DUMP_CALLBACK, byval UserData as PVOID) as WINBOOL
declare function DbgHelpCreateUserDumpW(byval FileName as LPCWSTR, byval Callback as PDBGHELP_CREATE_USER_DUMP_CALLBACK, byval UserData as PVOID) as WINBOOL
declare function SymGetSymFromAddr64(byval hProcess as HANDLE, byval qwAddr as DWORD64, byval pdwDisplacement as PDWORD64, byval Symbol as PIMAGEHLP_SYMBOL64) as WINBOOL

#ifdef __FB_64BIT__
	#define SymGetSymFromAddr SymGetSymFromAddr64
#else
	declare function SymGetSymFromAddr(byval hProcess as HANDLE, byval dwAddr as DWORD, byval pdwDisplacement as PDWORD, byval Symbol as PIMAGEHLP_SYMBOL) as WINBOOL
#endif

declare function SymGetSymFromName64(byval hProcess as HANDLE, byval Name_ as PCSTR, byval Symbol as PIMAGEHLP_SYMBOL64) as WINBOOL

#ifdef __FB_64BIT__
	#define SymGetSymFromName SymGetSymFromName64
#else
	declare function SymGetSymFromName(byval hProcess as HANDLE, byval Name_ as PCSTR, byval Symbol as PIMAGEHLP_SYMBOL) as WINBOOL
#endif

#ifdef UNICODE
	declare function FindFileInPath(byval hprocess as HANDLE, byval SearchPathW as PCSTR, byval FileName as PCSTR, byval id as PVOID, byval two as DWORD, byval three as DWORD, byval flags as DWORD, byval FilePath as PSTR) as WINBOOL
	declare function FindFileInSearchPath(byval hprocess as HANDLE, byval SearchPathW as PCSTR, byval FileName as PCSTR, byval one as DWORD, byval two as DWORD, byval three as DWORD, byval FilePath as PSTR) as WINBOOL
#else
	declare function FindFileInPath(byval hprocess as HANDLE, byval SearchPathA as PCSTR, byval FileName as PCSTR, byval id as PVOID, byval two as DWORD, byval three as DWORD, byval flags as DWORD, byval FilePath as PSTR) as WINBOOL
	declare function FindFileInSearchPath(byval hprocess as HANDLE, byval SearchPathA as PCSTR, byval FileName as PCSTR, byval one as DWORD, byval two as DWORD, byval three as DWORD, byval FilePath as PSTR) as WINBOOL
#endif

declare function SymEnumSym(byval hProcess as HANDLE, byval BaseOfDll as ULONG64, byval EnumSymbolsCallback as PSYM_ENUMERATESYMBOLS_CALLBACK, byval UserContext as PVOID) as WINBOOL

#define SYMF_OMAP_GENERATED &h00000001
#define SYMF_OMAP_MODIFIED &h00000002
#define SYMF_REGISTER &h00000008
#define SYMF_REGREL &h00000010
#define SYMF_FRAMEREL &h00000020
#define SYMF_PARAMETER &h00000040
#define SYMF_LOCAL &h00000080
#define SYMF_CONSTANT &h00000100
#define SYMF_EXPORT &h00000200
#define SYMF_FORWARDER &h00000400
#define SYMF_FUNCTION &h00000800
#define SYMF_VIRTUAL &h00001000
#define SYMF_THUNK &h00002000
#define SYMF_TLSREL &h00004000
#define IMAGEHLP_SYMBOL_INFO_VALUEPRESENT 1
#define IMAGEHLP_SYMBOL_INFO_REGISTER SYMF_REGISTER
#define IMAGEHLP_SYMBOL_INFO_REGRELATIVE SYMF_REGREL
#define IMAGEHLP_SYMBOL_INFO_FRAMERELATIVE SYMF_FRAMEREL
#define IMAGEHLP_SYMBOL_INFO_PARAMETER SYMF_PARAMETER
#define IMAGEHLP_SYMBOL_INFO_LOCAL SYMF_LOCAL
#define IMAGEHLP_SYMBOL_INFO_CONSTANT SYMF_CONSTANT
#define IMAGEHLP_SYMBOL_FUNCTION SYMF_FUNCTION
#define IMAGEHLP_SYMBOL_VIRTUAL SYMF_VIRTUAL
#define IMAGEHLP_SYMBOL_THUNK SYMF_THUNK
#define IMAGEHLP_SYMBOL_INFO_TLSRELATIVE SYMF_TLSREL

type RVA as DWORD

#define MINIDUMP_SIGNATURE asc("PMDM")
#define MINIDUMP_VERSION 42899

type RVA64 as ULONG64

type _MINIDUMP_LOCATION_DESCRIPTOR field = 4
	DataSize as ULONG32
	Rva as RVA
end type

type MINIDUMP_LOCATION_DESCRIPTOR as _MINIDUMP_LOCATION_DESCRIPTOR

type _MINIDUMP_LOCATION_DESCRIPTOR64 field = 4
	DataSize as ULONG64
	Rva as RVA64
end type

type MINIDUMP_LOCATION_DESCRIPTOR64 as _MINIDUMP_LOCATION_DESCRIPTOR64

type _MINIDUMP_MEMORY_DESCRIPTOR field = 4
	StartOfMemoryRange as ULONG64
	Memory as MINIDUMP_LOCATION_DESCRIPTOR
end type

type MINIDUMP_MEMORY_DESCRIPTOR as _MINIDUMP_MEMORY_DESCRIPTOR
type PMINIDUMP_MEMORY_DESCRIPTOR as _MINIDUMP_MEMORY_DESCRIPTOR ptr

type _MINIDUMP_MEMORY_DESCRIPTOR64 field = 4
	StartOfMemoryRange as ULONG64
	DataSize as ULONG64
end type

type MINIDUMP_MEMORY_DESCRIPTOR64 as _MINIDUMP_MEMORY_DESCRIPTOR64
type PMINIDUMP_MEMORY_DESCRIPTOR64 as _MINIDUMP_MEMORY_DESCRIPTOR64 ptr

type _MINIDUMP_HEADER field = 4
	Signature as ULONG32
	Version as ULONG32
	NumberOfStreams as ULONG32
	StreamDirectoryRva as RVA
	CheckSum as ULONG32

	union field = 4
		Reserved as ULONG32
		TimeDateStamp as ULONG32
	end union

	Flags as ULONG64
end type

type MINIDUMP_HEADER as _MINIDUMP_HEADER
type PMINIDUMP_HEADER as _MINIDUMP_HEADER ptr

type _MINIDUMP_DIRECTORY field = 4
	StreamType as ULONG32
	Location as MINIDUMP_LOCATION_DESCRIPTOR
end type

type MINIDUMP_DIRECTORY as _MINIDUMP_DIRECTORY
type PMINIDUMP_DIRECTORY as _MINIDUMP_DIRECTORY ptr

type _MINIDUMP_STRING field = 4
	Length as ULONG32
	Buffer as wstring * 0
end type

type MINIDUMP_STRING as _MINIDUMP_STRING
type PMINIDUMP_STRING as _MINIDUMP_STRING ptr

type _MINIDUMP_STREAM_TYPE as long
enum
	UnusedStream = 0
	ReservedStream0 = 1
	ReservedStream1 = 2
	ThreadListStream = 3
	ModuleListStream = 4
	MemoryListStream = 5
	ExceptionStream = 6
	SystemInfoStream = 7
	ThreadExListStream = 8
	Memory64ListStream = 9
	CommentStreamA = 10
	CommentStreamW = 11
	HandleDataStream = 12
	FunctionTableStream = 13
	UnloadedModuleListStream = 14
	MiscInfoStream = 15
	MemoryInfoListStream = 16
	ThreadInfoListStream = 17
	HandleOperationListStream = 18
	TokenStream = 19
	ceStreamNull = &h8000
	ceStreamSystemInfo = &h8001
	ceStreamException = &h8002
	ceStreamModuleList = &h8003
	ceStreamProcessList = &h8004
	ceStreamThreadList = &h8005
	ceStreamThreadContextList = &h8006
	ceStreamThreadCallStackList = &h8007
	ceStreamMemoryVirtualList = &h8008
	ceStreamMemoryPhysicalList = &h8009
	ceStreamBucketParameters = &h800a
	ceStreamProcessModuleMap = &h800b
	ceStreamDiagnosisList = &h800c
	LastReservedStream = &hffff
end enum

type MINIDUMP_STREAM_TYPE as _MINIDUMP_STREAM_TYPE

type ___CPU_INFORMATION_X86CpuInfo field = 4
	VendorId(0 to 2) as ULONG32
	VersionInformation as ULONG32
	FeatureInformation as ULONG32
	AMDExtendedCpuFeatures as ULONG32
end type

type ___CPU_INFORMATION_OtherCpuInfo field = 4
	ProcessorFeatures(0 to 1) as ULONG64
end type

union _CPU_INFORMATION field = 4
	X86CpuInfo as ___CPU_INFORMATION_X86CpuInfo
	OtherCpuInfo as ___CPU_INFORMATION_OtherCpuInfo
end union

type CPU_INFORMATION as _CPU_INFORMATION
type PCPU_INFORMATION as _CPU_INFORMATION ptr

type _MINIDUMP_SYSTEM_INFO field = 4
	ProcessorArchitecture as USHORT
	ProcessorLevel as USHORT
	ProcessorRevision as USHORT

	union field = 4
		Reserved0 as USHORT

		type field = 4
			NumberOfProcessors as UCHAR
			ProductType as UCHAR
		end type
	end union

	MajorVersion as ULONG32
	MinorVersion as ULONG32
	BuildNumber as ULONG32
	PlatformId as ULONG32
	CSDVersionRva as RVA

	union field = 4
		Reserved1 as ULONG32

		type field = 4
			SuiteMask as USHORT
			Reserved2 as USHORT
		end type
	end union

	Cpu as CPU_INFORMATION
end type

type MINIDUMP_SYSTEM_INFO as _MINIDUMP_SYSTEM_INFO
type PMINIDUMP_SYSTEM_INFO as _MINIDUMP_SYSTEM_INFO ptr

declare sub __C_ASSERT__ cdecl(byval as long ptr)

type _MINIDUMP_THREAD field = 4
	ThreadId as ULONG32
	SuspendCount as ULONG32
	PriorityClass as ULONG32
	Priority as ULONG32
	Teb as ULONG64
	Stack as MINIDUMP_MEMORY_DESCRIPTOR
	ThreadContext as MINIDUMP_LOCATION_DESCRIPTOR
end type

type MINIDUMP_THREAD as _MINIDUMP_THREAD
type PMINIDUMP_THREAD as _MINIDUMP_THREAD ptr

type _MINIDUMP_THREAD_LIST field = 4
	NumberOfThreads as ULONG32
	Threads(0 to -1) as MINIDUMP_THREAD
end type

type MINIDUMP_THREAD_LIST as _MINIDUMP_THREAD_LIST
type PMINIDUMP_THREAD_LIST as _MINIDUMP_THREAD_LIST ptr

type _MINIDUMP_THREAD_EX field = 4
	ThreadId as ULONG32
	SuspendCount as ULONG32
	PriorityClass as ULONG32
	Priority as ULONG32
	Teb as ULONG64
	Stack as MINIDUMP_MEMORY_DESCRIPTOR
	ThreadContext as MINIDUMP_LOCATION_DESCRIPTOR
	BackingStore as MINIDUMP_MEMORY_DESCRIPTOR
end type

type MINIDUMP_THREAD_EX as _MINIDUMP_THREAD_EX
type PMINIDUMP_THREAD_EX as _MINIDUMP_THREAD_EX ptr

type _MINIDUMP_THREAD_EX_LIST field = 4
	NumberOfThreads as ULONG32
	Threads(0 to -1) as MINIDUMP_THREAD_EX
end type

type MINIDUMP_THREAD_EX_LIST as _MINIDUMP_THREAD_EX_LIST
type PMINIDUMP_THREAD_EX_LIST as _MINIDUMP_THREAD_EX_LIST ptr

type _MINIDUMP_EXCEPTION field = 4
	ExceptionCode as ULONG32
	ExceptionFlags as ULONG32
	ExceptionRecord as ULONG64
	ExceptionAddress as ULONG64
	NumberParameters as ULONG32
	__unusedAlignment as ULONG32
	ExceptionInformation(0 to 14) as ULONG64
end type

type MINIDUMP_EXCEPTION as _MINIDUMP_EXCEPTION
type PMINIDUMP_EXCEPTION as _MINIDUMP_EXCEPTION ptr

type MINIDUMP_EXCEPTION_STREAM field = 4
	ThreadId as ULONG32
	__alignment as ULONG32
	ExceptionRecord as MINIDUMP_EXCEPTION
	ThreadContext as MINIDUMP_LOCATION_DESCRIPTOR
end type

type PMINIDUMP_EXCEPTION_STREAM as MINIDUMP_EXCEPTION_STREAM ptr

type _MINIDUMP_MODULE field = 4
	BaseOfImage as ULONG64
	SizeOfImage as ULONG32
	CheckSum as ULONG32
	TimeDateStamp as ULONG32
	ModuleNameRva as RVA
	VersionInfo as VS_FIXEDFILEINFO
	CvRecord as MINIDUMP_LOCATION_DESCRIPTOR
	MiscRecord as MINIDUMP_LOCATION_DESCRIPTOR
	Reserved0 as ULONG64
	Reserved1 as ULONG64
end type

type MINIDUMP_MODULE as _MINIDUMP_MODULE
type PMINIDUMP_MODULE as _MINIDUMP_MODULE ptr

type _MINIDUMP_MODULE_LIST field = 4
	NumberOfModules as ULONG32
	Modules(0 to -1) as MINIDUMP_MODULE
end type

type MINIDUMP_MODULE_LIST as _MINIDUMP_MODULE_LIST
type PMINIDUMP_MODULE_LIST as _MINIDUMP_MODULE_LIST ptr

type _MINIDUMP_MEMORY_LIST field = 4
	NumberOfMemoryRanges as ULONG32
	MemoryRanges(0 to -1) as MINIDUMP_MEMORY_DESCRIPTOR
end type

type MINIDUMP_MEMORY_LIST as _MINIDUMP_MEMORY_LIST
type PMINIDUMP_MEMORY_LIST as _MINIDUMP_MEMORY_LIST ptr

type _MINIDUMP_MEMORY64_LIST field = 4
	NumberOfMemoryRanges as ULONG64
	BaseRva as RVA64
	MemoryRanges(0 to -1) as MINIDUMP_MEMORY_DESCRIPTOR64
end type

type MINIDUMP_MEMORY64_LIST as _MINIDUMP_MEMORY64_LIST
type PMINIDUMP_MEMORY64_LIST as _MINIDUMP_MEMORY64_LIST ptr

type _MINIDUMP_EXCEPTION_INFORMATION field = 4
	ThreadId as DWORD
	ExceptionPointers as PEXCEPTION_POINTERS
	ClientPointers as WINBOOL
end type

type MINIDUMP_EXCEPTION_INFORMATION as _MINIDUMP_EXCEPTION_INFORMATION
type PMINIDUMP_EXCEPTION_INFORMATION as _MINIDUMP_EXCEPTION_INFORMATION ptr

type _MINIDUMP_EXCEPTION_INFORMATION64 field = 4
	ThreadId as DWORD
	ExceptionRecord as ULONG64
	ContextRecord as ULONG64
	ClientPointers as WINBOOL
end type

type MINIDUMP_EXCEPTION_INFORMATION64 as _MINIDUMP_EXCEPTION_INFORMATION64
type PMINIDUMP_EXCEPTION_INFORMATION64 as _MINIDUMP_EXCEPTION_INFORMATION64 ptr

type _MINIDUMP_HANDLE_DESCRIPTOR field = 4
	Handle as ULONG64
	TypeNameRva as RVA
	ObjectNameRva as RVA
	Attributes as ULONG32
	GrantedAccess as ULONG32
	HandleCount as ULONG32
	PointerCount as ULONG32
end type

type MINIDUMP_HANDLE_DESCRIPTOR as _MINIDUMP_HANDLE_DESCRIPTOR
type PMINIDUMP_HANDLE_DESCRIPTOR as _MINIDUMP_HANDLE_DESCRIPTOR ptr

type _MINIDUMP_HANDLE_DATA_STREAM field = 4
	SizeOfHeader as ULONG32
	SizeOfDescriptor as ULONG32
	NumberOfDescriptors as ULONG32
	Reserved as ULONG32
end type

type MINIDUMP_HANDLE_DATA_STREAM as _MINIDUMP_HANDLE_DATA_STREAM
type PMINIDUMP_HANDLE_DATA_STREAM as _MINIDUMP_HANDLE_DATA_STREAM ptr

type _MINIDUMP_FUNCTION_TABLE_DESCRIPTOR field = 4
	MinimumAddress as ULONG64
	MaximumAddress as ULONG64
	BaseAddress as ULONG64
	EntryCount as ULONG32
	SizeOfAlignPad as ULONG32
end type

type MINIDUMP_FUNCTION_TABLE_DESCRIPTOR as _MINIDUMP_FUNCTION_TABLE_DESCRIPTOR
type PMINIDUMP_FUNCTION_TABLE_DESCRIPTOR as _MINIDUMP_FUNCTION_TABLE_DESCRIPTOR ptr

type _MINIDUMP_FUNCTION_TABLE_STREAM field = 4
	SizeOfHeader as ULONG32
	SizeOfDescriptor as ULONG32
	SizeOfNativeDescriptor as ULONG32
	SizeOfFunctionEntry as ULONG32
	NumberOfDescriptors as ULONG32
	SizeOfAlignPad as ULONG32
end type

type MINIDUMP_FUNCTION_TABLE_STREAM as _MINIDUMP_FUNCTION_TABLE_STREAM
type PMINIDUMP_FUNCTION_TABLE_STREAM as _MINIDUMP_FUNCTION_TABLE_STREAM ptr

type _MINIDUMP_UNLOADED_MODULE field = 4
	BaseOfImage as ULONG64
	SizeOfImage as ULONG32
	CheckSum as ULONG32
	TimeDateStamp as ULONG32
	ModuleNameRva as RVA
end type

type MINIDUMP_UNLOADED_MODULE as _MINIDUMP_UNLOADED_MODULE
type PMINIDUMP_UNLOADED_MODULE as _MINIDUMP_UNLOADED_MODULE ptr

type _MINIDUMP_UNLOADED_MODULE_LIST field = 4
	SizeOfHeader as ULONG32
	SizeOfEntry as ULONG32
	NumberOfEntries as ULONG32
end type

type MINIDUMP_UNLOADED_MODULE_LIST as _MINIDUMP_UNLOADED_MODULE_LIST
type PMINIDUMP_UNLOADED_MODULE_LIST as _MINIDUMP_UNLOADED_MODULE_LIST ptr

#define MINIDUMP_MISC1_PROCESS_ID &h00000001
#define MINIDUMP_MISC1_PROCESS_TIMES &h00000002
#define MINIDUMP_MISC1_PROCESSOR_POWER_INFO &h00000004

type _MINIDUMP_MISC_INFO field = 4
	SizeOfInfo as ULONG32
	Flags1 as ULONG32
	ProcessId as ULONG32
	ProcessCreateTime as ULONG32
	ProcessUserTime as ULONG32
	ProcessKernelTime as ULONG32
end type

type MINIDUMP_MISC_INFO as _MINIDUMP_MISC_INFO
type PMINIDUMP_MISC_INFO as _MINIDUMP_MISC_INFO ptr

type _MINIDUMP_USER_RECORD field = 4
	as ULONG32 Type
	Memory as MINIDUMP_LOCATION_DESCRIPTOR
end type

type MINIDUMP_USER_RECORD as _MINIDUMP_USER_RECORD
type PMINIDUMP_USER_RECORD as _MINIDUMP_USER_RECORD ptr

type _MINIDUMP_USER_STREAM field = 4
	as ULONG32 Type
	BufferSize as ULONG
	Buffer as PVOID
end type

type MINIDUMP_USER_STREAM as _MINIDUMP_USER_STREAM
type PMINIDUMP_USER_STREAM as _MINIDUMP_USER_STREAM ptr

type _MINIDUMP_USER_STREAM_INFORMATION field = 4
	UserStreamCount as ULONG
	UserStreamArray as PMINIDUMP_USER_STREAM
end type

type MINIDUMP_USER_STREAM_INFORMATION as _MINIDUMP_USER_STREAM_INFORMATION
type PMINIDUMP_USER_STREAM_INFORMATION as _MINIDUMP_USER_STREAM_INFORMATION ptr

type _MINIDUMP_CALLBACK_TYPE as long
enum
	ModuleCallback
	ThreadCallback
	ThreadExCallback
	IncludeThreadCallback
	IncludeModuleCallback
	MemoryCallback
	CancelCallback
	WriteKernelMinidumpCallback
	KernelMinidumpStatusCallback
	RemoveMemoryCallback
	IncludeVmRegionCallback
	IoStartCallback
	IoWriteAllCallback
	IoFinishCallback
	ReadMemoryFailureCallback
	SecondaryFlagsCallback
end enum

type MINIDUMP_CALLBACK_TYPE as _MINIDUMP_CALLBACK_TYPE

type _MINIDUMP_THREAD_CALLBACK field = 4
	ThreadId as ULONG
	ThreadHandle as HANDLE
	Context as CONTEXT
	SizeOfContext as ULONG
	StackBase as ULONG64
	StackEnd as ULONG64
end type

type MINIDUMP_THREAD_CALLBACK as _MINIDUMP_THREAD_CALLBACK
type PMINIDUMP_THREAD_CALLBACK as _MINIDUMP_THREAD_CALLBACK ptr

type _MINIDUMP_THREAD_EX_CALLBACK field = 4
	ThreadId as ULONG
	ThreadHandle as HANDLE
	Context as CONTEXT
	SizeOfContext as ULONG
	StackBase as ULONG64
	StackEnd as ULONG64
	BackingStoreBase as ULONG64
	BackingStoreEnd as ULONG64
end type

type MINIDUMP_THREAD_EX_CALLBACK as _MINIDUMP_THREAD_EX_CALLBACK
type PMINIDUMP_THREAD_EX_CALLBACK as _MINIDUMP_THREAD_EX_CALLBACK ptr

type _MINIDUMP_INCLUDE_THREAD_CALLBACK field = 4
	ThreadId as ULONG
end type

type MINIDUMP_INCLUDE_THREAD_CALLBACK as _MINIDUMP_INCLUDE_THREAD_CALLBACK
type PMINIDUMP_INCLUDE_THREAD_CALLBACK as _MINIDUMP_INCLUDE_THREAD_CALLBACK ptr

type _THREAD_WRITE_FLAGS as long
enum
	ThreadWriteThread = &h0001
	ThreadWriteStack = &h0002
	ThreadWriteContext = &h0004
	ThreadWriteBackingStore = &h0008
	ThreadWriteInstructionWindow = &h0010
	ThreadWriteThreadData = &h0020
	ThreadWriteThreadInfo = &h0040
end enum

type THREAD_WRITE_FLAGS as _THREAD_WRITE_FLAGS

type _MINIDUMP_MODULE_CALLBACK field = 4
	FullPath as PWCHAR
	BaseOfImage as ULONG64
	SizeOfImage as ULONG
	CheckSum as ULONG
	TimeDateStamp as ULONG
	VersionInfo as VS_FIXEDFILEINFO
	CvRecord as PVOID
	SizeOfCvRecord as ULONG
	MiscRecord as PVOID
	SizeOfMiscRecord as ULONG
end type

type MINIDUMP_MODULE_CALLBACK as _MINIDUMP_MODULE_CALLBACK
type PMINIDUMP_MODULE_CALLBACK as _MINIDUMP_MODULE_CALLBACK ptr

type _MINIDUMP_INCLUDE_MODULE_CALLBACK field = 4
	BaseOfImage as ULONG64
end type

type MINIDUMP_INCLUDE_MODULE_CALLBACK as _MINIDUMP_INCLUDE_MODULE_CALLBACK
type PMINIDUMP_INCLUDE_MODULE_CALLBACK as _MINIDUMP_INCLUDE_MODULE_CALLBACK ptr

type _MODULE_WRITE_FLAGS as long
enum
	ModuleWriteModule = &h0001
	ModuleWriteDataSeg = &h0002
	ModuleWriteMiscRecord = &h0004
	ModuleWriteCvRecord = &h0008
	ModuleReferencedByMemory = &h0010
	ModuleWriteTlsData = &h0020
	ModuleWriteCodeSegs = &h0040
end enum

type MODULE_WRITE_FLAGS as _MODULE_WRITE_FLAGS

type _MINIDUMP_SECONDARY_FLAGS as long
enum
	MiniSecondaryWithoutPowerInfo = &h00000001
end enum

type MINIDUMP_SECONDARY_FLAGS as _MINIDUMP_SECONDARY_FLAGS

type _MINIDUMP_CALLBACK_INPUT field = 4
	ProcessId as ULONG
	ProcessHandle as HANDLE
	CallbackType as ULONG

	union field = 4
		Thread as MINIDUMP_THREAD_CALLBACK
		ThreadEx as MINIDUMP_THREAD_EX_CALLBACK
		Module as MINIDUMP_MODULE_CALLBACK
		IncludeThread as MINIDUMP_INCLUDE_THREAD_CALLBACK
		IncludeModule as MINIDUMP_INCLUDE_MODULE_CALLBACK
	end union
end type

type MINIDUMP_CALLBACK_INPUT as _MINIDUMP_CALLBACK_INPUT
type PMINIDUMP_CALLBACK_INPUT as _MINIDUMP_CALLBACK_INPUT ptr

type _MINIDUMP_MEMORY_INFO field = 4
	BaseAddress as ULONG64
	AllocationBase as ULONG64
	AllocationProtect as ULONG32
	__alignment1 as ULONG32
	RegionSize as ULONG64
	State as ULONG32
	Protect as ULONG32
	as ULONG32 Type
	__alignment2 as ULONG32
end type

type MINIDUMP_MEMORY_INFO as _MINIDUMP_MEMORY_INFO
type PMINIDUMP_MEMORY_INFO as _MINIDUMP_MEMORY_INFO ptr

type _MINIDUMP_MISC_INFO_2 field = 4
	SizeOfInfo as ULONG32
	Flags1 as ULONG32
	ProcessId as ULONG32
	ProcessCreateTime as ULONG32
	ProcessUserTime as ULONG32
	ProcessKernelTime as ULONG32
	ProcessorMaxMhz as ULONG32
	ProcessorCurrentMhz as ULONG32
	ProcessorMhzLimit as ULONG32
	ProcessorMaxIdleState as ULONG32
	ProcessorCurrentIdleState as ULONG32
end type

type MINIDUMP_MISC_INFO_2 as _MINIDUMP_MISC_INFO_2
type PMINIDUMP_MISC_INFO_2 as _MINIDUMP_MISC_INFO_2 ptr

type _MINIDUMP_MEMORY_INFO_LIST field = 4
	SizeOfHeader as ULONG
	SizeOfEntry as ULONG
	NumberOfEntries as ULONG64
end type

type MINIDUMP_MEMORY_INFO_LIST as _MINIDUMP_MEMORY_INFO_LIST
type PMINIDUMP_MEMORY_INFO_LIST as _MINIDUMP_MEMORY_INFO_LIST ptr

type _MINIDUMP_CALLBACK_OUTPUT field = 4
	union field = 4
		ModuleWriteFlags as ULONG
		ThreadWriteFlags as ULONG
		SecondaryFlags as ULONG

		type field = 4
			MemoryBase as ULONG64
			MemorySize as ULONG
		end type

		type field = 4
			CheckCancel as WINBOOL
			Cancel as WINBOOL
		end type

		Handle as HANDLE
	end union

	union
		type field = 4
			VmRegion as MINIDUMP_MEMORY_INFO
			Continue as WINBOOL
		end type
	end union

	Status as HRESULT
end type

type MINIDUMP_CALLBACK_OUTPUT as _MINIDUMP_CALLBACK_OUTPUT
type PMINIDUMP_CALLBACK_OUTPUT as _MINIDUMP_CALLBACK_OUTPUT ptr

type _MINIDUMP_TYPE as long
enum
	MiniDumpNormal = &h00000000
	MiniDumpWithDataSegs = &h00000001
	MiniDumpWithFullMemory = &h00000002
	MiniDumpWithHandleData = &h00000004
	MiniDumpFilterMemory = &h00000008
	MiniDumpScanMemory = &h00000010
	MiniDumpWithUnloadedModules = &h00000020
	MiniDumpWithIndirectlyReferencedMemory = &h00000040
	MiniDumpFilterModulePaths = &h00000080
	MiniDumpWithProcessThreadData = &h00000100
	MiniDumpWithPrivateReadWriteMemory = &h00000200
	MiniDumpWithoutOptionalData = &h00000400
	MiniDumpWithFullMemoryInfo = &h00000800
	MiniDumpWithThreadInfo = &h00001000
	MiniDumpWithCodeSegs = &h00002000
	MiniDumpWithoutAuxiliaryState = &h00004000
	MiniDumpWithFullAuxiliaryState = &h00008000
	MiniDumpWithPrivateWriteCopyMemory = &h00010000
	MiniDumpIgnoreInaccessibleMemory = &h00020000
	MiniDumpWithTokenInformation = &h00040000
end enum

type MINIDUMP_TYPE as _MINIDUMP_TYPE

#define MINIDUMP_THREAD_INFO_ERROR_THREAD &h00000001
#define MINIDUMP_THREAD_INFO_WRITING_THREAD &h00000002
#define MINIDUMP_THREAD_INFO_EXITED_THREAD &h00000004
#define MINIDUMP_THREAD_INFO_INVALID_INFO &h00000008
#define MINIDUMP_THREAD_INFO_INVALID_CONTEXT &h00000010
#define MINIDUMP_THREAD_INFO_INVALID_TEB &h00000020

type _MINIDUMP_THREAD_INFO field = 4
	ThreadId as ULONG32
	DumpFlags as ULONG32
	DumpError as ULONG32
	ExitStatus as ULONG32
	CreateTime as ULONG64
	ExitTime as ULONG64
	KernelTime as ULONG64
	UserTime as ULONG64
	StartAddress as ULONG64
	Affinity as ULONG64
end type

type MINIDUMP_THREAD_INFO as _MINIDUMP_THREAD_INFO
type PMINIDUMP_THREAD_INFO as _MINIDUMP_THREAD_INFO ptr

type _MINIDUMP_THREAD_INFO_LIST field = 4
	SizeOfHeader as ULONG
	SizeOfEntry as ULONG
	NumberOfEntries as ULONG
end type

type MINIDUMP_THREAD_INFO_LIST as _MINIDUMP_THREAD_INFO_LIST
type PMINIDUMP_THREAD_INFO_LIST as _MINIDUMP_THREAD_INFO_LIST ptr

type _MINIDUMP_HANDLE_OPERATION_LIST field = 4
	SizeOfHeader as ULONG32
	SizeOfEntry as ULONG32
	NumberOfEntries as ULONG32
	Reserved as ULONG32
end type

type MINIDUMP_HANDLE_OPERATION_LIST as _MINIDUMP_HANDLE_OPERATION_LIST
type PMINIDUMP_HANDLE_OPERATION_LIST as _MINIDUMP_HANDLE_OPERATION_LIST ptr
type MINIDUMP_CALLBACK_ROUTINE as function(byval CallbackParam as PVOID, byval CallbackInput as const PMINIDUMP_CALLBACK_INPUT, byval CallbackOutput as PMINIDUMP_CALLBACK_OUTPUT) as WINBOOL

type _MINIDUMP_CALLBACK_INFORMATION field = 4
	CallbackRoutine as MINIDUMP_CALLBACK_ROUTINE
	CallbackParam as PVOID
end type

type MINIDUMP_CALLBACK_INFORMATION as _MINIDUMP_CALLBACK_INFORMATION
type PMINIDUMP_CALLBACK_INFORMATION as _MINIDUMP_CALLBACK_INFORMATION ptr

#define RVA_TO_ADDR(Mapping, Rva) cast(PVOID, cast(ULONG_PTR, (Mapping)) + (Rva))

declare function MiniDumpWriteDump(byval hProcess as HANDLE, byval ProcessId as DWORD, byval hFile as HANDLE, byval DumpType as MINIDUMP_TYPE, byval ExceptionParam as const PMINIDUMP_EXCEPTION_INFORMATION, byval UserStreamParam as const PMINIDUMP_USER_STREAM_INFORMATION, byval CallbackParam as const PMINIDUMP_CALLBACK_INFORMATION) as WINBOOL
declare function MiniDumpReadDumpStream(byval BaseOfDump as PVOID, byval StreamNumber as ULONG, byval Dir_ as PMINIDUMP_DIRECTORY ptr, byval StreamPointer as PVOID ptr, byval StreamSize as ULONG ptr) as WINBOOL
declare function EnumerateLoadedModulesEx(byval hProcess as HANDLE, byval EnumLoadedModulesCallback as PENUMLOADED_MODULES_CALLBACK64, byval UserContext as PVOID) as WINBOOL
declare function EnumerateLoadedModulesExW(byval hProcess as HANDLE, byval EnumLoadedModulesCallback as PENUMLOADED_MODULES_CALLBACKW64, byval UserContext as PVOID) as WINBOOL
declare function SymAddSourceStream(byval hProcess as HANDLE, byval Base_ as ULONG64, byval StreamFile as PCSTR, byval Buffer as PBYTE, byval Size as uinteger) as WINBOOL
declare function SymAddSourceStreamW(byval hProcess as HANDLE, byval Base_ as ULONG64, byval StreamFile as PCWSTR, byval Buffer as PBYTE, byval Size as uinteger) as WINBOOL
declare function SymEnumSourceLines(byval hProcess as HANDLE, byval Base_ as ULONG64, byval Obj as PCSTR, byval File as PCSTR, byval Line_ as DWORD, byval Flags as DWORD, byval EnumLinesCallback as PSYM_ENUMLINES_CALLBACK, byval UserContext as PVOID) as WINBOOL
declare function SymEnumSourceLinesW(byval hProcess as HANDLE, byval Base_ as ULONG64, byval Obj as PCWSTR, byval File as PCWSTR, byval Line_ as DWORD, byval Flags as DWORD, byval EnumLinesCallback as PSYM_ENUMLINES_CALLBACKW, byval UserContext as PVOID) as WINBOOL
declare function SymEnumTypesByName(byval hProcess as HANDLE, byval BaseOfDll as ULONG64, byval mask as PCSTR, byval EnumSymbolsCallback as PSYM_ENUMERATESYMBOLS_CALLBACK, byval UserContext as PVOID) as WINBOOL
declare function SymEnumTypesByNameW(byval hProcess as HANDLE, byval BaseOfDll as ULONG64, byval mask as PCSTR, byval EnumSymbolsCallback as PSYM_ENUMERATESYMBOLS_CALLBACKW, byval UserContext as PVOID) as WINBOOL
declare function SymFindDebugInfoFile(byval hProcess as HANDLE, byval FileName as PCSTR, byval DebugFilePath as PSTR, byval Callback as PFIND_DEBUG_FILE_CALLBACK, byval CallerData as PVOID) as HANDLE
declare function SymFindDebugInfoFileW(byval hProcess as HANDLE, byval FileName as PCWSTR, byval DebugFilePath as PWSTR, byval Callback as PFIND_DEBUG_FILE_CALLBACKW, byval CallerData as PVOID) as HANDLE
declare function SymFindExecutableImage(byval hProcess as HANDLE, byval FileName as PCSTR, byval ImageFilePath as PSTR, byval Callback as PFIND_EXE_FILE_CALLBACK, byval CallerData as PVOID) as HANDLE
declare function SymFindExecutableImageW(byval hProcess as HANDLE, byval FileName as PCWSTR, byval ImageFilePath as PWSTR, byval Callback as PFIND_EXE_FILE_CALLBACKW, byval CallerData as PVOID) as HANDLE
declare function SymFromIndex(byval hProcess as HANDLE, byval BaseOfDll as ULONG64, byval Index as DWORD, byval Symbol as PSYMBOL_INFO) as WINBOOL
declare function SymFromIndexW(byval hProcess as HANDLE, byval BaseOfDll as ULONG64, byval Index as DWORD, byval Symbol as PSYMBOL_INFOW) as WINBOOL
declare function SymGetScope(byval hProcess as HANDLE, byval BaseOfDll as ULONG64, byval Index as DWORD, byval Symbol as PSYMBOL_INFO) as WINBOOL
declare function SymGetScopeW(byval hProcess as HANDLE, byval BaseOfDll as ULONG64, byval Index as DWORD, byval Symbol as PSYMBOL_INFOW) as WINBOOL
declare function SymGetSourceFileFromToken(byval hProcess as HANDLE, byval Token as PVOID, byval Params as PCSTR, byval FilePath as PSTR, byval Size as DWORD) as WINBOOL
declare function SymGetSourceFileFromTokenW(byval hProcess as HANDLE, byval Token as PVOID, byval Params as PCWSTR, byval FilePath as PWSTR, byval Size as DWORD) as WINBOOL
declare function SymGetSourceFileToken(byval hProcess as HANDLE, byval Base_ as ULONG64, byval FileSpec as PCSTR, byval Token as PVOID ptr, byval Size as DWORD ptr) as WINBOOL
declare function SymGetSourceFileTokenW(byval hProcess as HANDLE, byval Base_ as ULONG64, byval FileSpec as PCWSTR, byval Token as PVOID ptr, byval Size as DWORD ptr) as WINBOOL
declare function SymGetSourceFile(byval hProcess as HANDLE, byval Base_ as ULONG64, byval Params as PCSTR, byval FileSpec as PCSTR, byval FilePath as PSTR, byval Size as DWORD) as WINBOOL
declare function SymGetSourceFileW(byval hProcess as HANDLE, byval Base_ as ULONG64, byval Params as PCWSTR, byval FileSpec as PCWSTR, byval FilePath as PWSTR, byval Size as DWORD) as WINBOOL
declare function SymGetSourceVarFromToken(byval hProcess as HANDLE, byval Token as PVOID, byval Params as PCSTR, byval VarName as PCSTR, byval Value as PSTR, byval Size as DWORD) as WINBOOL
declare function SymGetSourceVarFromTokenW(byval hProcess as HANDLE, byval Token as PVOID, byval Params as PCWSTR, byval VarName as PCWSTR, byval Value as PWSTR, byval Size as DWORD) as WINBOOL
declare function SymGetSymbolFile(byval hProcess as HANDLE, byval SymPath as PCSTR, byval ImageFile as PCSTR, byval Type_ as DWORD, byval SymbolFile as PSTR, byval cSymbolFile as uinteger, byval DbgFile as PSTR, byval cDbgFile as uinteger) as WINBOOL
declare function SymGetSymbolFileW(byval hProcess as HANDLE, byval SymPath as PCWSTR, byval ImageFile as PCWSTR, byval Type_ as DWORD, byval SymbolFile as PWSTR, byval cSymbolFile as uinteger, byval DbgFile as PWSTR, byval cDbgFile as uinteger) as WINBOOL
declare function SymNext(byval hProcess as HANDLE, byval Symbol as PSYMBOL_INFO) as WINBOOL
declare function SymNextW(byval hProcess as HANDLE, byval Symbol as PSYMBOL_INFOW) as WINBOOL
declare function SymPrev(byval hProcess as HANDLE, byval Symbol as PSYMBOL_INFO) as WINBOOL
declare function SymPrevW(byval hProcess as HANDLE, byval Symbol as PSYMBOL_INFOW) as WINBOOL
declare function SymRefreshModuleList(byval hProcess as HANDLE) as WINBOOL

#define SYMSEARCH_MASKOBJS &h01
#define SYMSEARCH_RECURSE &h02
#define SYMSEARCH_GLOBALSONLY &h04
#define SYMSEARCH_ALLITEMS &h08

#ifdef __FB_64BIT__
	declare function SymSearch(byval hProcess as HANDLE, byval BaseOfDll as ULONG64, byval Index as DWORD, byval SymTag as DWORD, byval Mask as PCSTR, byval Address_ as DWORD64, byval EnumSymbolsCallback as PSYM_ENUMERATESYMBOLS_CALLBACK, byval UserContext as PVOID, byval Options as DWORD) as WINBOOL
	declare function SymSearchW(byval hProcess as HANDLE, byval BaseOfDll as ULONG64, byval Index as DWORD, byval SymTag as DWORD, byval Mask as PCWSTR, byval Address_ as DWORD64, byval EnumSymbolsCallback as PSYM_ENUMERATESYMBOLS_CALLBACKW, byval UserContext as PVOID, byval Options as DWORD) as WINBOOL
#else
	declare function SymSearch(byval hProcess as HANDLE, byval BaseOfDll as ULONG64, byval Index as DWORD, byval SymTag as DWORD, byval Mask as PCSTR, byval Address as DWORD64, byval EnumSymbolsCallback as PSYM_ENUMERATESYMBOLS_CALLBACK, byval UserContext as PVOID, byval Options as DWORD) as WINBOOL
	declare function SymSearchW(byval hProcess as HANDLE, byval BaseOfDll as ULONG64, byval Index as DWORD, byval SymTag as DWORD, byval Mask as PCWSTR, byval Address as DWORD64, byval EnumSymbolsCallback as PSYM_ENUMERATESYMBOLS_CALLBACKW, byval UserContext as PVOID, byval Options as DWORD) as WINBOOL
#endif

declare function SymSrvGetFileIndexString(byval hProcess as HANDLE, byval SrvPath as PCSTR, byval File as PCSTR, byval Index as PSTR, byval Size as uinteger, byval Flags as DWORD) as WINBOOL
declare function SymSrvGetFileIndexStringW(byval hProcess as HANDLE, byval SrvPath as PCWSTR, byval File as PCWSTR, byval Index as PWSTR, byval Size as uinteger, byval Flags as DWORD) as WINBOOL
declare function SymSrvGetFileIndexInfo(byval File as PCSTR, byval Info as PSYMSRV_INDEX_INFO, byval Flags as DWORD) as WINBOOL
declare function SymSrvGetFileIndexInfoW(byval File as PCWSTR, byval Info as PSYMSRV_INDEX_INFOW, byval Flags as DWORD) as WINBOOL
declare function SymSrvGetFileIndexes(byval File as PCTSTR, byval Id as GUID ptr, byval Val1 as DWORD ptr, byval Val2 as DWORD ptr, byval Flags as DWORD) as WINBOOL
declare function SymSrvGetFileIndexesW(byval File as PCWSTR, byval Id as GUID ptr, byval Val1 as DWORD ptr, byval Val2 as DWORD ptr, byval Flags as DWORD) as WINBOOL
declare function SymSrvGetSupplement(byval hProcess as HANDLE, byval SymPath as PCSTR, byval Node as PCSTR, byval File as PCSTR) as PCSTR
declare function SymSrvGetSupplementW(byval hProcess as HANDLE, byval SymPath as PCWSTR, byval Node as PCWSTR, byval File as PCWSTR) as PCWSTR
declare function SymSrvIsStore(byval hProcess as HANDLE, byval path as PCSTR) as WINBOOL
declare function SymSrvIsStoreW(byval hProcess as HANDLE, byval path as PCWSTR) as WINBOOL
declare function SymSrvStoreFile(byval hProcess as HANDLE, byval SrvPath as PCSTR, byval File as PCSTR, byval Flags as DWORD) as PCSTR
declare function SymSrvStoreFileW(byval hProcess as HANDLE, byval SrvPath as PCWSTR, byval File as PCWSTR, byval Flags as DWORD) as PCWSTR

#define SYMSTOREOPT_COMPRESS &h01
#define SYMSTOREOPT_OVERWRITE &h02
#define SYMSTOREOPT_RETURNINDEX &h04
#define SYMSTOREOPT_POINTER &h08
#define SYMSTOREOPT_PASS_IF_EXISTS &h40

declare function SymSrvStoreSupplement(byval hProcess as HANDLE, byval SymPath as const PCTSTR, byval Node as PCSTR, byval File as PCSTR, byval Flags as DWORD) as PCSTR
declare function SymSrvStoreSupplementW(byval hProcess as HANDLE, byval SymPath as const PCWSTR, byval Node as PCWSTR, byval File as PCWSTR, byval Flags as DWORD) as PCWSTR
declare function SymSrvDeltaName(byval hProcess as HANDLE, byval SymPath as PCSTR, byval Type_ as PCSTR, byval File1 as PCSTR, byval File2 as PCSTR) as PCSTR
declare function SymSrvDeltaNameW(byval hProcess as HANDLE, byval SymPath as PCWSTR, byval Type_ as PCWSTR, byval File1 as PCWSTR, byval File2 as PCWSTR) as PCWSTR

end extern
