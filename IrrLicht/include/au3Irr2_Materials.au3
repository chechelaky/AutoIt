#include-once

#include "au3Irr2_constants.au3"

; #INDEX# =======================================================================================================================
; Title .........: System
; AutoIt Version : v3.3.6.1
; Language ......: English
; Description ...: Calls for creating and manipulating materials that can be applied to a node to color and texture the object.
;                  Basic Materials set common properties like the shininess and reflective color of the objects. Advanced
;                  Materials use GPU programs to create sophisticated texturing effects that can greatly add to the realism of
;                  the scene but are only supported by modern graphics cards with Pixel and Vertex shader support. Currently
;                  Irrlicht supports Vertex Shaders, Pixel Shaders, ARB Vertex programs, ARB Fragment programs,
;                  HLSL (DirectX 9) and GLSL (OpenGL).
; Author(s) .....: jRowe, linus.
;                  DLL functionality by Frank Dodd and IrrlichtWrapper for FreeBasic team (IrrlichtWrapper.dll),
;                  and Nikolaus Gebhardt and Irrlicht team (Irrlicht.dll).
; Dll(s) ........: IrrlichtWrapper.dll, Irrlicht.dll, msvcp71.dll, msvcr71.dll
; ===============================================================================================================================

; #NO_DOC_FUNCTION# =============================================================================================================
; Not working/documented/implemented at this time
;_IrrSetMaterialLineThickness
;_IrrAddHighLevelShaderMaterial
;_IrrAddHighLevelShaderMaterialFromFiles
;_IrrAddShaderMaterial
;_IrrAddShaderMaterialFromFiles
;_IrrCreateNamedVertexShaderConstant
;_IrrCreateNamedPixelShaderConstant
;_IrrCreateAddressedVertexShaderConstant
;_IrrCreateAddressedPixelShaderConstant
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;_IrrSetNodeAmbientColor
;_IrrSetNodeDiffuseColor
;_IrrSetNodeSpecularColor
;_IrrSetNodeEmissiveColor
;_IrrSetNodeColorByVertex
;_IrrMaterialVertexColorAffects
;_IrrSetMaterialBlend
;_IrrMaterialSetShininess
;_IrrMaterialSetSpecularColor
;_IrrMaterialSetDiffuseColor
;_IrrMaterialSetAmbientColor
;_IrrMaterialSetEmissiveColor
;_IrrMaterialSetMaterialTypeParam
;_IrrXEffectsStart
;_IrrXEffectsAddShadowToNode
;_IrrXEffectsAddShadowLight
;_IrrXEffectsSetAmbientColor
;_IrrXEffectsSetClearColor
;_IrrXEffectsSetShadowLightPosition
;_IrrXEffectsEnableDepthPass
;_IrrXEffectsAddPostProcessingFromFile
;_IrrXEffectsAddNodeToDepthPass
;_IrrXEffectsSetPostProcessingUserTexture
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; ===============================================================================================================================

; ////////////////////////////////////////////////////////////////////////////
; Material and GPU Programming Functions


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetNodeAmbientColor
; Description ...: [todo]
; Syntax.........: _IrrSetNodeAmbientColor($h_Node, $i_Color)
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
Func _IrrSetNodeAmbientColor($h_Node, $i_Color)
	DllCall($_irrDll, "none:cdecl", "IrrSetNodeAmbientColor", "ptr", $h_Node, "uint", $i_Color)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrSetNodeAmbientColor


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetNodeDiffuseColor
; Description ...: [todo]
; Syntax.........: _IrrSetNodeDiffuseColor($h_Node, $i_Color)
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
Func _IrrSetNodeDiffuseColor($h_Node, $i_Color)
	DllCall($_irrDll, "none:cdecl", "IrrSetNodeDiffuseColor", "ptr", $h_Node, "uint", $i_Color)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrSetNodeDiffuseColor


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetNodeSpecularColor
; Description ...: [todo]
; Syntax.........: _IrrSetNodeSpecularColor($h_Node, $i_Color)
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
Func _IrrSetNodeSpecularColor($h_Node, $i_Color)
	DllCall($_irrDll, "none:cdecl", "IrrSetNodeSpecularColor", "ptr", $h_Node, "uint", $i_Color)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrSetNodeSpecularColor


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetNodeEmissiveColor
; Description ...: [todo]
; Syntax.........: _IrrSetNodeEmissiveColor($h_Node, $i_Color)
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
Func _IrrSetNodeEmissiveColor($h_Node, $i_Color)
	DllCall($_irrDll, "none:cdecl", "IrrSetNodeEmissiveColor", "ptr", $h_Node, "uint", $i_Color)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrSetNodeEmissiveColor



; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetNodeColorByVertex
; Description ...: [todo]
; Syntax.........: _IrrSetNodeColorByVertex($h_Node, $i_ColorMaterial)
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
Func _IrrSetNodeColorByVertex($h_Node, $i_ColorMaterial)
; Set whether vertex color or material color is used to shade the surface of a node
	DllCall($_irrDll, "none:cdecl", "IrrSetNodeColorByVertex", "ptr", $h_Node, "uint", $i_ColorMaterial)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrSetNodeColorByVertex


;Materials functions

; #FUNCTION# =============================================================================================================
; Name...........: _IrrMaterialVertexColorAffects
; Description ...: [todo]
; Syntax.........: _IrrMaterialVertexColorAffects($h_Material, $i_AffectedProperty)
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
Func _IrrMaterialVertexColorAffects($h_Material, $i_AffectedProperty)
	DllCall($_irrDll, "none:cdecl", "IrrMaterialVertexColorAffects", "ptr", $h_Material, "int", $i_AffectedProperty)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrMaterialVertexColorAffects


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetMaterialBlend
; Description ...: [todo]
; Syntax.........: _IrrSetMaterialBlend($h_Material, $i_SrcBlend, $i_DstBlend)
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
Func _IrrSetMaterialBlend($h_Material, $i_SrcBlend, $i_DstBlend)
	DllCall($_irrDll, "none:cdecl", "IrrSetMaterialBlend", "ptr", $h_Material, "int", $i_SrcBlend, "int", $i_DstBlend)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrSetMaterialBlend


; #FUNCTION# =============================================================================================================
; Name...........: _IrrMaterialSetShininess
; Description ...: [todo]
; Syntax.........: _IrrMaterialSetShininess($h_Material, $f_Shininess)
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
Func _IrrMaterialSetShininess($h_Material, $f_Shininess)
	DllCall($_irrDll, "none:cdecl", "IrrMaterialSetShininess", "ptr", $h_Material, "float", $f_Shininess)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrMaterialSetShininess


; #FUNCTION# =============================================================================================================
; Name...........: _IrrMaterialSetSpecularColor
; Description ...: [todo]
; Syntax.........: _IrrMaterialSetSpecularColor($h_Material, $i_Alpha, $i_Red, $i_Green, $i_Blue)
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
Func _IrrMaterialSetSpecularColor($h_Material, $i_Alpha, $i_Red, $i_Green, $i_Blue)
	DllCall($_irrDll, "none:cdecl", "IrrMaterialSetSpecularColor", "ptr", $h_Material, "uint", $i_Alpha, "uint", $i_Red, "uint", $i_Green, "uint", $i_Blue)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrMaterialSetSpecularColor


; #FUNCTION# =============================================================================================================
; Name...........: _IrrMaterialSetDiffuseColor
; Description ...: [todo]
; Syntax.........: _IrrMaterialSetDiffuseColor($h_Material, $i_Alpha, $i_Red, $i_Green, $i_Blue)
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
Func _IrrMaterialSetDiffuseColor($h_Material, $i_Alpha, $i_Red, $i_Green, $i_Blue)
	DllCall($_irrDll, "none:cdecl", "IrrMaterialSetDiffuseColor", "ptr", $h_Material, "uint", $i_Alpha, "uint", $i_Red, "uint", $i_Green, "uint", $i_Blue)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrMaterialSetDiffuseColor


; #FUNCTION# =============================================================================================================
; Name...........: _IrrMaterialSetAmbientColor
; Description ...: [todo]
; Syntax.........: _IrrMaterialSetAmbientColor($h_Material, $i_Alpha, $i_Red, $i_Green, $i_Blue)
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
Func _IrrMaterialSetAmbientColor($h_Material, $i_Alpha, $i_Red, $i_Green, $i_Blue)
	DllCall($_irrDll, "none:cdecl", "IrrMaterialSetAmbientColor", "ptr", $h_Material, "uint", $i_Alpha, "uint", $i_Red, "uint", $i_Green, "uint", $i_Blue)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrMaterialSetAmbientColor


; #FUNCTION# =============================================================================================================
; Name...........: _IrrMaterialSetEmissiveColor
; Description ...: [todo]
; Syntax.........: _IrrMaterialSetEmissiveColor($h_Material, $i_Alpha, $i_Red, $i_Green, $i_Blue)
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
Func _IrrMaterialSetEmissiveColor($h_Material, $i_Alpha, $i_Red, $i_Green, $i_Blue)
	DllCall($_irrDll, "none:cdecl", "IrrMaterialSetEmissiveColor", "ptr", $h_Material, "uint", $i_Alpha, "uint", $i_Red, "uint", $i_Green, "uint", $i_Blue)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrMaterialSetEmissiveColor


; #FUNCTION# =============================================================================================================
; Name...........: _IrrMaterialSetMaterialTypeParam
; Description ...: [todo]
; Syntax.........: _IrrMaterialSetMaterialTypeParam($h_Material, $f_Param)
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
Func _IrrMaterialSetMaterialTypeParam($h_Material, $f_Param)
	DllCall($_irrDll, "none:cdecl", "IrrMaterialSetMaterialTypeParam", "ptr", $h_Material, "float", $f_Param)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrMaterialSetMaterialTypeParam


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrSetMaterialLineThickness
; Description ...: [todo]
; Syntax.........: _IrrSetMaterialLineThickness($h_Material, $f_Thickness)
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
Func _IrrSetMaterialLineThickness($h_Material, $f_Thickness)
	DllCall($_irrDll, "none:cdecl", "IrrSetMaterialLineThickness", "ptr", $h_Material, "float", $f_Thickness)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrSetMaterialLineThickness


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrAddHighLevelShaderMaterial
; Description ...: [todo]
; Syntax.........: _IrrAddHighLevelShaderMaterial($h_VertexProgram, $s_StartFunction, $i_ProgType, $s_pixelProg, $s_PixelStartFunction, $i_PixelProgTpe, $i_MaterialType)
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
Func _IrrAddHighLevelShaderMaterial($h_VertexProgram, $s_StartFunction, $i_ProgType, $s_pixelProg, $s_PixelStartFunction, $i_PixelProgTpe, $i_MaterialType);IrrAddHighLevelShaderMaterial
	$result = DllCall($_irrDll, "int:cdecl", "IrrAddHighLevelShaderMaterial", "ptr", $h_VertexProgram, "str", $s_StartFunction, "int", $i_ProgType, "str", $s_pixelProg, "str", $s_PixelStartFunction, "int", $i_PixelProgTpe, "int", $i_MaterialType)
	if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
	;potentially screwed up
EndFunc   ;==>_IrrAddHighLevelShaderMaterial


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrAddHighLevelShaderMaterialFromFiles
; Description ...: [todo]
; Syntax.........: _IrrAddHighLevelShaderMaterialFromFiles($s_VertexProgram, $s_StartFunction, $i_ProgType, $s_pixelProg, $s_PixelStartFunction, $i_PixelProgTpe, $i_MaterialType)
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
Func _IrrAddHighLevelShaderMaterialFromFiles($s_VertexProgram, $s_StartFunction, $i_ProgType, $s_pixelProg, $s_PixelStartFunction, $i_PixelProgTpe, $i_MaterialType);IrrAddHighLevelShaderMaterial
	$result = DllCall($_irrDll, "int:cdecl", "IrrAddHighLevelShaderMaterialFromFiles", "str", $s_VertexProgram, "str", $s_StartFunction, "int", $i_ProgType, "str", $s_pixelProg, "str", $s_PixelStartFunction, "int", $i_PixelProgTpe, "int", $i_MaterialType)
	if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
	;potentially screwed up
EndFunc   ;==>_IrrAddHighLevelShaderMaterialFromFiles


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrAddShaderMaterial
; Description ...: [todo]
; Syntax.........: _IrrAddShaderMaterial($h_VertexProgram, $h_PixelProgram, $i_MaterialType)
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
Func _IrrAddShaderMaterial($h_VertexProgram, $h_PixelProgram, $i_MaterialType)
	$result = DllCall($_irrDll, "int:cdecl", "IrrAddShaderMaterial", "ptr", $h_VertexProgram, "ptr", $h_PixelProgram, "int", $i_MaterialType)
	if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrAddShaderMaterial


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrAddShaderMaterialFromFiles
; Description ...: [todo]
; Syntax.........: _IrrAddShaderMaterialFromFiles($s_VertexProgram, $s_PixelProgram, $i_MaterialType)
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
Func _IrrAddShaderMaterialFromFiles($s_VertexProgram, $s_PixelProgram, $i_MaterialType)
	$result = DllCall($_irrDll, "int:cdecl", "IrrAddShaderMaterialFromFiles", "str", $s_VertexProgram, "str", $s_PixelProgram, "int", $i_MaterialType)
	if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrAddShaderMaterialFromFiles


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrCreateNamedVertexShaderConstant
; Description ...: [todo]
; Syntax.........: _IrrCreateNamedVertexShaderConstant($s_VertexProgram, $s_PixelProgram, $i_MaterialType)
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
Func _IrrCreateNamedVertexShaderConstant($s_VertexProgram, $s_PixelProgram, $i_MaterialType)
	$result = DllCall($_irrDll, "int:cdecl", "IrrCreateNamedVertexShaderConstant", "str", $s_VertexProgram, "str", $s_PixelProgram, "int", $i_MaterialType)
	if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrCreateNamedVertexShaderConstant


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrCreateNamedPixelShaderConstant
; Description ...: [todo]
; Syntax.........: _IrrCreateNamedPixelShaderConstant($h_Shader, $s_Name, $i_Preset, $i_Data, $i_Count)
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
Func _IrrCreateNamedPixelShaderConstant($h_Shader, $s_Name, $i_Preset, $i_Data, $i_Count)
	$result = DllCall($_irrDll, "int:cdecl", "IrrCreateNamedPixelShaderConstant", "ptr", $h_Shader, "str", $s_Name, "int", $i_Preset, "int", $i_Data, "int", $i_Count)
	if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrCreateNamedPixelShaderConstant


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrCreateAddressedVertexShaderConstant
; Description ...: [todo]
; Syntax.........: _IrrCreateAddressedVertexShaderConstant($h_Shader, $i_Address, $i_Preset, $i_Data, $i_Count)
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
Func _IrrCreateAddressedVertexShaderConstant($h_Shader, $i_Address, $i_Preset, $i_Data, $i_Count)
	$result = DllCall($_irrDll, "int:cdecl", "IrrCreateAddressedVertexShaderConstant", "ptr", $h_Shader, "int", $i_Address, "int", $i_Preset, "int", $i_Data, "int", $i_Count)
	if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrCreateAddressedVertexShaderConstant


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrCreateAddressedPixelShaderConstant
; Description ...: [todo]
; Syntax.........: _IrrCreateAddressedPixelShaderConstant($h_Shader, $i_Address, $i_Preset, $i_Data, $i_Count)
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
Func _IrrCreateAddressedPixelShaderConstant($h_Shader, $i_Address, $i_Preset, $i_Data, $i_Count)
	$result = DllCall($_irrDll, "int:cdecl", "IrrCreateAddressedPixelShaderConstant", "ptr", $h_Shader, "int", $i_Address, "int", $i_Preset, "int", $i_Data, "int", $i_Count)
	if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrCreateAddressedPixelShaderConstant


; ////////////////////////////////////////////////////////////////////////////
; Bitplanes XEffect Extension


; #FUNCTION# =============================================================================================================
; Name...........: _IrrXEffectsStart
; Description ...: [todo]
; Syntax.........: _IrrXEffectsStart($i_Vsm=$IRR_OFF, $i_SoftShadows=$IRR_OFF, $iBitdepth32=$IRR_OFF)
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
Func _IrrXEffectsStart($i_Vsm=$IRR_OFF, $i_SoftShadows=$IRR_OFF, $iBitdepth32=$IRR_OFF)
; start the XEffects system
	$result = DllCall($_irrDll, "none:cdecl", "IrrXEffectsStart", "int", $i_Vsm, "int", $i_SoftShadows, "int", $iBitdepth32)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrXEffectsStart


; #FUNCTION# =============================================================================================================
; Name...........: _IrrXEffectsAddShadowToNode
; Description ...: [todo]
; Syntax.........: _IrrXEffectsAddShadowToNode($h_Node, $i_FilterType=$EFT_NONE, $i_shadowType=$ESM_BOTH)
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
Func _IrrXEffectsAddShadowToNode($h_Node, $i_FilterType=$EFT_NONE, $i_shadowType=$ESM_BOTH)
; start the XEffects system
	$result = DllCall($_irrDll, "ptr:cdecl", "IrrXEffectsAddShadowToNode", "ptr", $h_Node, "int", $i_FilterType, "int", $i_shadowType)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return $result[0]
	EndIf
EndFunc   ;==>_IrrXEffectsAddShadowToNode


; #FUNCTION# =============================================================================================================
; Name...........: _IrrXEffectsAddShadowLight
; Description ...: [todo]
; Syntax.........: _IrrXEffectsAddShadowLight($i_ShadowDimen, $f_PosX, $f_PosY, $f_PosZ, $f_TargetX, $f_TargetY, $f_TargetZ, $f_R, $f_G, $f_B, $f_Alpha, $f_LightNearDist, $f_LightFarDist, $f_AngleDegrees )
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
Func _IrrXEffectsAddShadowLight($i_ShadowDimen, $f_PosX, $f_PosY, $f_PosZ, $f_TargetX, $f_TargetY, $f_TargetZ, $f_R, $f_G, $f_B, $f_Alpha, $f_LightNearDist, $f_LightFarDist, $f_AngleDegrees )
; Add a special dynamic shadow casting light
; The first parameter specifies the shadow map resolution for the shadow light.
; The shadow map is always square, so you need only pass 1 dimension, preferably
; a power of two between 512 and 2048, maybe larger depending on your quality
; requirements and target hardware.
; The second parameter is the light position, the third parameter is the (look at)
; target, the next is the light color, and the next two are very important
; values, the nearValue and farValue, be sure to set them appropriate to the current
; scene. The last parameter is the FOV (Field of view), since the light is similar to
; a spot light, the field of view will determine its area of influence. Anything that
; is outside of a lights frustum (Too close, too far, or outside of it's field of view)
; will be unlit by this particular light, similar to how a spot light works.
	$result = DllCall($_irrDll, "none:cdecl", "IrrXEffectsAddShadowLight", "int", $i_ShadowDimen, _
					"float", $f_PosX, "float", $f_PosY, "float", $f_PosZ, _
					"float", $f_TargetX, "float", $f_TargetY, "float", $f_TargetZ, _
					"float", $f_R, "float", $f_G, "float", $f_B, "float", $f_Alpha, _
					"float", $f_LightNearDist, "float", $f_LightFarDist, "float", $f_AngleDegrees )
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrXEffectsAddShadowLight


; #FUNCTION# =============================================================================================================
; Name...........: _IrrXEffectsSetAmbientColor
; Description ...: [todo]
; Syntax.........: _IrrXEffectsSetAmbientColor($i_R, $i_G, $i_B, $i_Alpha)
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
Func _IrrXEffectsSetAmbientColor($i_R, $i_G, $i_B, $i_Alpha)
; sets the ambient lighting procuded in the scene by the XEffects system
	$result = DllCall($_irrDll, "none:cdecl", "IrrXEffectsSetAmbientColor", "uint", $i_R, "uint", $i_G, "uint", $i_B, "uint", $i_Alpha)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrXEffectsSetAmbientColor


; #FUNCTION# =============================================================================================================
; Name...........: _IrrXEffectsSetClearColor
; Description ...: [todo]
; Syntax.........: _IrrXEffectsSetClearColor($i_R, $i_G, $i_B, $i_Alpha)
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
Func _IrrXEffectsSetClearColor($i_R, $i_G, $i_B, $i_Alpha)
; the XEffects system uses a different background color to the one specified in
; the IrrBeginScene call use this call to set this default background color
	$result = DllCall($_irrDll, "none:cdecl", "IrrXEffectsSetClearColor", "float", $i_R, "uint", $i_G, "uint", $i_B, "uint", $i_Alpha)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrXEffectsSetClearColor


; #FUNCTION# =============================================================================================================
; Name...........: _IrrXEffectsSetShadowLightPosition
; Description ...: [todo]
; Syntax.........: _IrrXEffectsSetShadowLightPosition($i_Index, $f_PosX, $f_PosY, $f_PosZ)
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
Func _IrrXEffectsSetShadowLightPosition($i_Index, $f_PosX, $f_PosY, $f_PosZ)
; Set the position of a shadow light. the index refers to the numerical order
; in which the lights were added.
	$result = DllCall($_irrDll, "none:cdecl", "IrrXEffectsSetShadowLightPosition", "int", $i_Index, _
				"float", $f_PosX, "float", $f_PosY, "float", $f_PosZ)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrXEffectsSetShadowLightPosition


; #FUNCTION# =============================================================================================================
; Name...........: _IrrXEffectsEnableDepthPass
; Description ...: [todo]
; Syntax.........: _IrrXEffectsEnableDepthPass($i_Enable)
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
Func _IrrXEffectsEnableDepthPass($i_Enable)
; enable XEffects depth pass
	$result = DllCall($_irrDll, "none:cdecl", "IrrXEffectsEnableDepthPass", "int", $i_Enable)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrXEffectsEnableDepthPass


; #FUNCTION# =============================================================================================================
; Name...........: _IrrXEffectsAddPostProcessingFromFile
; Description ...: [todo]
; Syntax.........: _IrrXEffectsAddPostProcessingFromFile($s_Name, $i_Enable=0)
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
Func _IrrXEffectsAddPostProcessingFromFile($s_Name, $i_Enable=0)
; enable XEffects depth pass
	$result = DllCall($_irrDll, "none:cdecl", "IrrXEffectsAddPostProcessingFromFile", "str", $s_Name, "int", $i_Enable)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrXEffectsAddPostProcessingFromFile


; #FUNCTION# =============================================================================================================
; Name...........: _IrrXEffectsAddNodeToDepthPass
; Description ...: [todo]
; Syntax.........: _IrrXEffectsAddNodeToDepthPass($h_Node)
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
Func _IrrXEffectsAddNodeToDepthPass($h_Node)
; adds a node to the list of nodes used for calculating the depth pass
	$result = DllCall($_irrDll, "none:cdecl", "IrrXEffectsAddNodeToDepthPass", "ptr", $h_Node)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrXEffectsAddNodeToDepthPass


; #FUNCTION# =============================================================================================================
; Name...........: _IrrXEffectsSetPostProcessingUserTexture
; Description ...: [todo]
; Syntax.........: _IrrXEffectsSetPostProcessingUserTexture($h_Texture)
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
Func _IrrXEffectsSetPostProcessingUserTexture($h_Texture)
; Sets the user defined post processing texture. This is used internally for
; the SSAO shader but is used primarily for the water shader where it defines
; the specular surface pattern of the water.
	$result = DllCall($_irrDll, "none:cdecl", "IrrXEffectsSetPostProcessingUserTexture", "ptr", $h_Texture)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrXEffectsSetPostProcessingUserTexture


#cs - TODO of bitplanes XEffect Extension:
'' ////////////////////////////////////////////////////////////////////////////
'' Bitplanes XEffect Extension

' remove a shadowing effect from a node
declare sub IrrXEffectsRemoveShadowFromNode alias "IrrXEffectsRemoveShadowFromNode" ( _
        byval node as irr_node )

' exclude a node from being calculated in shadowing equations
declare sub IrrXEffectsExcludeNodeFromLightingCalculations alias "IrrXEffectsExcludeNodeFromLightingCalculations" ( _
        byval node as irr_node )

' Get the position of a shadow light. the index refers to the numerical order
' in which the lights were added.
declare sub IrrXEffectsGetShadowLightPosition alias "IrrXEffectsGetShadowLightPosition" ( _
	byval index as uinteger, byref posX as single, byref posY as single, byref posZ as single )

' Set the target location of a shadow light. the index refers to the numerical
' order in which the lights were added.
declare sub IrrXEffectsSetShadowLightTarget alias "IrrXEffectsSetShadowLightTarget" ( _
	byval index as uinteger, byVal posX as single, byVal posY as single, byVal posZ as single )

' Get the target location of a shadow light. the index refers to the numerical
' order in which the lights were added.
declare sub IrrXEffectsGetShadowLightTarget alias "IrrXEffectsGetShadowLightTarget" ( _
	byval index as uinteger, byref posX as single, byref posY as single, byref posZ as single )

' Set the target location of a shadow light. the index refers to the numerical
' order in which the lights were added.
declare sub IrrXEffectsSetShadowLightColor alias "IrrXEffectsSetShadowLightColor" ( _
	byval index as uinteger, byval R as single, byval G as single, byval B as single, _
    byval Alpha as single )

' Get the target location of a shadow light. the index refers to the numerical
' order in which the lights were added.
declare sub IrrXEffectsGetShadowLightColor alias "IrrXEffectsGetShadowLightColor" ( _
	byval index as uinteger, byref R as single, byref G as single, byref B as single, _
    byref Alpha as single )
#ce
; end of definitions: Bitplanes XEffect Extension
; ////////////////////////////////////////////////////////////////////////////

