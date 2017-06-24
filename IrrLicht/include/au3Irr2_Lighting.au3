#include-once

#include "au3Irr2_constants.au3"

; #INDEX# =======================================================================================================================
; Title .........: Lighting
; AutoIt Version : v3.3.6.1
; Language ......: English
; Description ...: Calls to create and effect lighting in the scene.
; Author(s) .....: jRowe, linus.
;                  DLL functionality by Frank Dodd and IrrlichtWrapper for FreeBasic team (IrrlichtWrapper.dll),
;                  and Nikolaus Gebhardt and Irrlicht team (Irrlicht.dll).
; Dll(s) ........: IrrlichtWrapper.dll, Irrlicht.dll, msvcp71.dll, msvcr71.dll
; ===============================================================================================================================

; #NO_DOC_FUNCTION# =============================================================================================================
; Not working/documented/implemented at this time
;_IrrSetLightCastShadows
;_IrrSetLightRadius
;_IrrSetLightSpecularColor
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;_IrrAddLight
;_IrrSetAmbientLight
;_IrrSetLightAmbientColor
;_IrrSetLightAttenuation
;_IrrSetLightDiffuseColor
;_IrrSetLightFalloff
;_IrrSetLightInnerCone
;_IrrSetLightOuterCone
;_IrrSetLightType
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; ===============================================================================================================================

;Lighting functions

; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddLight
; Description ...: Adds a light node into scene to naturally illuminate your scene.
; Syntax.........: _IrrAddLight($h_parentNode, $f_X, $f_Y, $f_Z, $f_Red, $f_Green, $f_Blue, $f_Size)
; Parameters ....: $h_parentNode - Handle of the node to attach the light to.
;                  |$IRR_NO_PARENT attaches to the root node of the scene.
;                  $f_X, $f_Y, $f_Z - Coordinates of the light in the scene
;                  $f_Red, $f_Green, $f_Blue - Intensity of the light.
;                  |<b>Red/green/blue are fractional values from 0 to 1!</b>
;                  $f_Size - Radius of effect of the light
; Return values .: Success - Handle of light node in the scene
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: When using shadows you probably only want one or two lights - they can be time consuming.
; Related .......: _IrrAddNodeShadow, _IrrSetAmbientLight
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrAddLight($h_parentNode, $f_X, $f_Y, $f_Z, $f_Red, $f_Green, $f_Blue, $f_Size)
	$result = DllCall($_irrDll, "UINT_PTR:cdecl", "IrrAddLight", "UINT_PTR", $h_parentNode, "float", $f_X, "float", $f_Y, "float", $f_Z, "float", $f_Red, "float", $f_Green, "float", $f_Blue, "float", $f_Size)
	If @error Then
		Return SetError(1, 0, False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrAddLight


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetAmbientLight
; Description ...: Sets the ambient lighting level across entire scene.
; Syntax.........: _IrrSetAmbientLight($f_Red, $f_Green, $f_Blue)
; Parameters ....: $i_Red, $i_Green, $i_Blue - Colour values for ambient lighting.
;                  |<b>Red/green/blue are fractional values from 0 to 1!</b>
; Return values .: Success - True
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: Ambient light illuminates all surfaces in the scene uniformly. This is usually a low value to increase the overall lighting level.
;                  It should never be greater than the brightness of the darkest area of your scene, it can however reduce the number of lights you need in the scene.
; Related .......: _IrrAddLight, _IrrSetLightAmbientColor
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrSetAmbientLight($f_Red, $f_Green, $f_Blue)
	DllCall($_irrDll, "none:cdecl", "IrrSetAmbientLight", "float", $f_Red, "float", $f_Green, "float", $f_Blue)
	If @error Then
		Return SetError(1, 0, False)
	Else
		Return True
	EndIf
EndFunc   ;==>_IrrSetAmbientLight


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetLightAmbientColor
; Description ...: [todo]
; Syntax.........: _IrrSetLightAmbientColor($h_Light, $f_Red, $f_Green, $f_Blue)
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
Func _IrrSetLightAmbientColor($h_Light, $f_Red, $f_Green, $f_Blue)
	DllCall($_irrDll, "none:cdecl", "IrrSetLightAmbientColor", "ptr", $h_Light, "float", $f_Red, "float", $f_Green, "float", $f_Blue)
	If @error Then
		Return SetError(1, 0, False)
	Else
		Return True
	EndIf
EndFunc   ;==>_IrrSetLightAmbientColor


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetLightAttenuation
; Description ...: [todo]
; Syntax.........: _IrrSetLightAttenuation($h_Light, $f_Red, $f_Green, $f_Blue)
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
Func _IrrSetLightAttenuation($h_Light, $f_Red, $f_Green, $f_Blue)
	DllCall($_irrDll, "none:cdecl", "IrrSetLightAttenuation", "ptr", $h_Light, "float", $f_Red, "float", $f_Green, "float", $f_Blue)
	If @error Then
		Return SetError(1, 0, False)
	Else
		Return True
	EndIf
EndFunc   ;==>_IrrSetLightAttenuation


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrSetLightCastShadows
; Description ...: [todo]
; Syntax.........: _IrrSetLightCastShadows($h_Light, $i_Shadows)
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
Func _IrrSetLightCastShadows($h_Light, $i_Shadows)
	DllCall($_irrDll, "none:cdecl", "IrrSetLightCastShadows", "ptr", $h_Light, "int", $i_Shadows)
	If @error Then
		Return SetError(1, 0, False)
	Else
		Return True
	EndIf
EndFunc   ;==>_IrrSetLightCastShadows


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetLightDiffuseColor
; Description ...: [todo]
; Syntax.........: _IrrSetLightDiffuseColor($h_Light, $f_Red, $f_Green, $f_Blue)
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
Func _IrrSetLightDiffuseColor($h_Light, $f_Red, $f_Green, $f_Blue)
	DllCall($_irrDll, "none:cdecl", "IrrSetLightDiffuseColor", "ptr", $h_Light, "float", $f_Red, "float", $f_Green, "float", $f_Blue)
	If @error Then
		Return SetError(1, 0, False)
	Else
		Return True
	EndIf
EndFunc   ;==>_IrrSetLightDiffuseColor


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetLightFalloff
; Description ...: [todo]
; Syntax.........: _IrrSetLightFalloff($h_Light, $f_Falloff)
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
Func _IrrSetLightFalloff($h_Light, $f_Falloff)
	DllCall($_irrDll, "none:cdecl", "IrrSetLightFalloff", "ptr", $h_Light, "float", $f_Falloff)
	If @error Then
		Return SetError(1, 0, False)
	Else
		Return True
	EndIf
EndFunc   ;==>_IrrSetLightFalloff


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetLightInnerCone
; Description ...: [todo]
; Syntax.........: _IrrSetLightInnerCone($h_Light, $f_InnerCone)
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
Func _IrrSetLightInnerCone($h_Light, $f_InnerCone)
	DllCall($_irrDll, "none:cdecl", "IrrSetLightInnerCone", "ptr", $h_Light, "float", $f_InnerCone)
	If @error Then
		Return SetError(1, 0, False)
	Else
		Return True
	EndIf
EndFunc   ;==>_IrrSetLightInnerCone


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetLightOuterCone
; Description ...: [todo]
; Syntax.........: _IrrSetLightOuterCone($h_Light, $f_OuterCone)
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
Func _IrrSetLightOuterCone($h_Light, $f_OuterCone)
	DllCall($_irrDll, "none:cdecl", "IrrSetLightOuterCone", "ptr", $h_Light, "float", $f_OuterCone)
	If @error Then
		Return SetError(1, 0, False)
	Else
		Return True
	EndIf
EndFunc   ;==>_IrrSetLightOuterCone


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrSetLightRadius
; Description ...: [todo]
; Syntax.........: _IrrSetLightRadius($h_Light, $f_Radius)
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
Func _IrrSetLightRadius($h_Light, $f_Radius)
	DllCall($_irrDll, "none:cdecl", "IrrSetLightRadius", "ptr", $h_Light, "float", $f_Radius)
	If @error Then
		Return SetError(1, 0, False)
	Else
		Return True
	EndIf
EndFunc   ;==>_IrrSetLightRadius


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrSetLightSpecularColor
; Description ...: [todo]
; Syntax.........: _IrrSetLightSpecularColor($h_Light, $f_Red, $f_Green, $f_Blue)
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
Func _IrrSetLightSpecularColor($h_Light, $f_Red, $f_Green, $f_Blue)
	DllCall($_irrDll, "none:cdecl", "IrrSetLightSpecularColor", "ptr", $h_Light, "float", $f_Red, "float", $f_Green, "float", $f_Blue)
	If @error Then
		Return SetError(1, 0, False)
	Else
		Return True
	EndIf
EndFunc   ;==>_IrrSetLightSpecularColor


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetLightType
; Description ...: [todo]
; Syntax.........: _IrrSetLightType($h_Light, $i_Type)
; Parameters ....: [param1] - [explanation]
;                  |[moreTextForParam1]
;                  [param2] - [explanation]
;                  $ELT_POINT
;                  $ELT_SPOT
;                  $ELT_DIRECTIONAL
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
Func _IrrSetLightType($h_Light, $i_Type)
	DllCall($_irrDll, "none:cdecl", "IrrSetLightType", "ptr", $h_Light, "int", $i_Type)
	If @error Then
		Return SetError(1, 0, False)
	Else
		Return True
	EndIf
EndFunc   ;==>_IrrSetLightType
