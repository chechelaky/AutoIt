#include-once

#include "au3Irr2_constants.au3"

; #INDEX# =======================================================================================================================
; Title .........: Filling System
; AutoIt Version : v3.3.6.1
; Language ......: English
; Description ...: These calls deal with the way irrlicht operates with the filing system and adds archives to its
;                  a virtual filling system allowing you to compress data into zipfiles that you can access without
;                  decompressing them.
; Author(s) .....: jRowe, linus.
;                  DLL functionality by Frank Dodd and IrrlichtWrapper for FreeBasic team (IrrlichtWrapper.dll),
;                  and Nikolaus Gebhardt and Irrlicht team (Irrlicht.dll).
; Dll(s) ........: IrrlichtWrapper.dll, Irrlicht.dll, msvcp71.dll, msvcr71.dll
; ===============================================================================================================================

; #NO_DOC_FUNCTION# =============================================================================================================
; Not working/documented/implemented at this time
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;_IrrAddZipFile
;_IrrChangeWorkingDirectory
;_IrrGetWorkingDirectory
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; ===============================================================================================================================

; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddZipFile
; Description ...: Adds a zip archive to the filing system allowing to load files out of the zip file.
; Syntax.........: _IrrAddZipFile($s_Zipfile, $i_IgnoreCase, $i_IgnorePaths)
; Parameters ....: $s_ZipFile - Path to the zipfile (or pk3 file)
;                  $i_IgnoreCase - Should be one of the following values:
;                  |$IRR_USE_CASE
;                  |$IRR_IGNORE_CASE
;                  $i_IgnorePaths - Ignore paths allows you to simply use the filename without the path, the filename should always be unique in the archive when using this option. The value should be one of the following:
;                  |$IRR_USE_PATHS
;                  |$IRR_IGNORE_PATHS
; Return values .: Success - True
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: Files inside the .zip can be opened as if they were in the current working directory.
;                  Common pk3 files are simply zip files.
; Related .......: None
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrAddZipFile($s_Zipfile, $i_IgnoreCase, $i_IgnorePaths)
	DllCall($_irrDll, "none:cdecl", "IrrAddZipFile", "str", $s_Zipfile, "int", $i_IgnoreCase, "int", $i_IgnorePaths)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrAddZipFile


; #FUNCTION# =============================================================================================================
; Name...........: _IrrChangeWorkingDirectory
; Description ...: [todo]
; Syntax.........: _IrrChangeWorkingDirectory($s_WorkingDir)
; Parameters ....: [param1] - [explanation]
;                  |[moreTextForParam1]
;                  [param2] - [explanation]
; Return values .: [success] - [explanation]
;                  [failure] - [explanation]
;                  |[moreExplanationIndented]
; Author ........: [todo]
; Modified.......:
; Remarks .......: [todo]
; Related .......: [todo: functionName, functionName]
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrChangeWorkingDirectory($s_WorkingDir)
	DllCall($_irrDll, "none:cdecl", "IrrChangeWorkingDirectory", "str", $s_WorkingDir)
	if @error Then
		Return Seterror(1,0,False)
	Else
		Return true
	EndIf
EndFunc   ;==>_IrrChangeWorkingDirectory


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetWorkingDirectory
; Description ...: [todo]
; Syntax.........: _IrrGetWorkingDirectory()
; Parameters ....: [param1] - [explanation]
;                  |[moreTextForParam1]
;                  [param2] - [explanation]
; Return values .: [success] - [explanation]
;                  [failure] - [explanation]
;                  |[moreExplanationIndented]
; Author ........: [todo]
; Modified.......:
; Remarks .......: [todo]
; Related .......: [todo: functionName, functionName]
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrGetWorkingDirectory()
	$result = DllCall($_irrDll, "str:cdecl", "IrrGetWorkingDirectory")
	if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrGetWorkingDirectory
