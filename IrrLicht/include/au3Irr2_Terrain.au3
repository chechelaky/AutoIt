#include-once

#include "au3Irr2_constants.au3"

; #INDEX# =======================================================================================================================
; Title .........: Terrain
; AutoIt Version : v3.3.6.1
; Language ......: English
; Description ...: Calls to create and alter the properties of terrain meshes,
;                  special nodes that are used to create large expansive landscapes.
; Author(s) .....: jRowe, linus.
;                  DLL functionality by Frank Dodd and IrrlichtWrapper for FreeBasic team (IrrlichtWrapper.dll),
;                  and Nikolaus Gebhardt and Irrlicht team (Irrlicht.dll).
; Dll(s) ........: IrrlichtWrapper.dll, Irrlicht.dll, msvcp71.dll, msvcr71.dll
; ===============================================================================================================================

; #NO_DOC_FUNCTION# =============================================================================================================
; Not working/documented/implemented at this time
;_IrrAttachTile
;_IrrSetTileStructure
;_IrrSetSphericalTerrainTexture
;_IrrLoadSphericalTerrainVertexColor
;_IrrGetSphericalTerrainSurfacePosition
;_IrrGetSphericalTerrainSurfacePositionAndAngle
;_IrrGetSphericalTerrainLogicalSurfacePosition
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;_IrrAddTerrain
;_IrrAddTerrainTile
;_IrrAddSphericalTerrain
;_IrrGetTerrainHeight
;_IrrScaleTexture
;_IrrGetTerrainTileHeight
;_IrrScaleTileTexture
;_IrrSetTileColor
;_IrrScaleSphericalTexture
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; ===============================================================================================================================

;Terrain functions

; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddTerrain
; Description ...: Creates a terrain object from a gray scale bitmap.
; Syntax.........: _IrrAddTerrain($s_Path, $f_PosX = 0.0, $f_PosY = 0.0, $f_PosZ = 0.0, $f_RotX = 0.0, $f_RotY = 0.0, $f_RotZ = 0.0, $f_ScaleX = 1.0, $f_ScaleY = 1.0, $f_ScaleZ = 1.0, $i_VertexAlpha = 255, $i_VertexRed = 255, $i_VertexGreen = 255, $i_VertexBlue = 255, $i_Smoothing = 0, $i_MaxLOD = 5, $i_PatchSize = $ETPS_17)
; Parameters ....: $s_Path - Filename of a gray scale image used to define the contours of the surface
;                  $f_PosX, $f_PosY, $f_PosZ - [optional] Define position of the terrain
;                  $f_RotX, $f_RotY, $f_RotZ - [optional] Define rotation of the terrain
;                  $f_ScaleX, $f_ScaleY, $f_ScaleZ - [optional] Define scaling of the terrain
;                  $i_VertexAlpha - [optional] Alpha value for the vertex colour from 0 to 255.
;                  $i_VertexRed, $i_VertexGreen, $i_VertexBlue - [optional] Define the vertex colour of all points in the terrain (values from 0 to 255)
;                  $i_Smoothing - [optional] True or false defines whether the contours of the surface of the terrain are smoothed over.
;                  $i_MaxLOD, $i_PatchSize - [optional] Control the properties of the level of detail calculations applied to the terrain.
;                  |It is recommended that these are left at default values.
;                  |<br><u>Valid values for $i_PatchSize:</u>
;                  |$ETPS_9 (patch size of 9, at most, use 4 levels of detail with this patch size)
;                  |$ETPS_17 (patch size of 17, at most, use 5 levels of detail with this patch size)
;                  |$ETPS_33 (patch size of 33, at most, use 6 levels of detail with this patch size)
;                  |$ETPS_65 (patch size of 65, at most, use 7 levels of detail with this patch size)
;                  |$ETPS_129 (patch size of 129, at most, use 8 levels of detail with this patch size)
; Return values .: success - Handle of the terrain object
;                  failure - false
; Author ........:
; Modified.......:
; Remarks .......: The terrain is created from a gray scale bitmap where bright pixels are high points on the terrain and black pixels are low points.
;                  You will inevitablly have to rescale the terrain during the call or after it is created.
;                  The Terrain object is a special dynamic mesh whose resoloution is reduced in the distance to reduce the number of triangles it consumes.
; Related .......: _IrrScaleTexture
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrAddTerrain($s_Path, $f_PosX = 0.0, $f_PosY = 0.0, $f_PosZ = 0.0, $f_RotX = 0.0, $f_RotY = 0.0, $f_RotZ = 0.0, $f_ScaleX = 1.0, $f_ScaleY = 1.0, $f_ScaleZ = 1.0, $i_VertexAlpha = 255, $i_VertexRed = 255, $i_VertexGreen = 255, $i_VertexBlue = 255, $i_Smoothing = 0, $i_MaxLOD = 5, $i_PatchSize = $ETPS_17)
	$result = DllCall($_irrDll, "ptr:cdecl", "IrrAddTerrain", "str", $s_Path, "float", $f_PosX, "float", $f_PosY, "float", $f_PosZ, "float", $f_RotX, "float", $f_RotY, "float", $f_RotZ, "float", $f_ScaleX, "float", $f_ScaleY, "float", $f_ScaleZ, "int", $i_VertexAlpha, "int", $i_VertexRed, "int", $i_VertexGreen, "int", $i_VertexBlue, "int", $i_Smoothing, "int", $i_MaxLOD, "int", $i_PatchSize)
	if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrAddTerrain


; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddTerrainTile
; Description ...: [todo]
; Syntax.........: _IrrAddTerrainTile($h_Image, $i_TileSize = 256, $i_DataX = 0, $i_DataY = 0, $f_PosX = 0.0, $f_PosY = 0.0, $f_PosZ = 0.0, $f_RotX = 0.0, $f_RotY = 0.0, $f_RotZ = 0.0, $f_ScaleX = 1.0, $f_ScaleY = 1.0, $f_ScaleZ = 1.0, $i_Smoothing = 1, $i_MaxLOD = 5, $i_PatchSize = $ETPS_17)
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
Func _IrrAddTerrainTile($h_Image, $i_TileSize = 256, $i_DataX = 0, $i_DataY = 0, $f_PosX = 0.0, $f_PosY = 0.0, $f_PosZ = 0.0, $f_RotX = 0.0, $f_RotY = 0.0, $f_RotZ = 0.0, $f_ScaleX = 1.0, $f_ScaleY = 1.0, $f_ScaleZ = 1.0, $i_Smoothing = 1, $i_MaxLOD = 5, $i_PatchSize = $ETPS_17)
	$result = DllCall($_irrDll, "UINT_PTR:cdecl", "IrrAddTerrainTile", "UINT_PTR", $h_Image, "int", $i_TileSize, _
				"int", $i_DataX, "int", $i_DataY, "float", $f_PosX, "float", $f_PosY, "float", $f_PosZ, _
				"float", $f_RotX, "float", $f_RotY, "float", $f_RotZ, "float", _
				$f_ScaleX, "float", $f_ScaleY, "float", $f_ScaleZ, "int", $i_Smoothing, "int", $i_MaxLOD, "int", $i_PatchSize)
	if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrAddTerrainTile



; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddSphericalTerrain
; Description ...: [todo]
; Syntax.........: _IrrAddSphericalTerrain($s_TopPath, $s_FrontPath, $s_BackPath, $s_LeftPath, $RightPath, $s_BottomPath, $f_PosX = 0.0, $f_PosY = 0.0, $f_PosZ = 0.0, $f_RotX = 0.0, $f_RotY = 0.0, $f_RotZ = 0.0, $f_ScaleX = 1.0, $f_ScaleY = 1.0, $f_ScaleZ = 1.0, $i_VertexAlpha = 255, $i_VertexRed = 255, $i_VertexGreen = 255, $i_VertexBlue = 255, $i_Smoothing = 0, $i_Spherical = 0, $i_MaxLOD = 5, $i_PatchSize = $ETPS_17)
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
Func _IrrAddSphericalTerrain($s_TopPath, $s_FrontPath, $s_BackPath, $s_LeftPath, $RightPath, $s_BottomPath, $f_PosX = 0.0, $f_PosY = 0.0, $f_PosZ = 0.0, $f_RotX = 0.0, $f_RotY = 0.0, $f_RotZ = 0.0, $f_ScaleX = 1.0, $f_ScaleY = 1.0, $f_ScaleZ = 1.0, $i_VertexAlpha = 255, $i_VertexRed = 255, $i_VertexGreen = 255, $i_VertexBlue = 255, $i_Smoothing = 0, $i_Spherical = 0, $i_MaxLOD = 5, $i_PatchSize = $ETPS_17)
	$result = DllCall($_irrDll, "UINT_PTR:cdecl", "IrrAddSphericalTerrain", _
		"str", $s_TopPath, "str", $s_FrontPath, "str", $s_BackPath, "str", $s_LeftPath, "str", $RightPath, "str", $s_BottomPath, _
		"float", $f_PosX, "float", $f_PosY, "float", $f_PosZ, "float", $f_RotX, "float", $f_RotY, "float", $f_RotZ, _
		"float", $f_ScaleX, "float", $f_ScaleY, "float", $f_ScaleZ, _
		"int", $i_VertexAlpha, "int", $i_VertexRed, "int", $i_VertexGreen, "int", $i_VertexBlue, _
		"int", $i_Smoothing, "int", $i_Spherical, "int", $i_MaxLOD, "int", $i_PatchSize)
	if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrAddSphericalTerrain


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetTerrainHeight
; Description ...: [todo]
; Syntax.........: _IrrGetTerrainHeight($h_Terrain, $f_X, $f_Y)
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
Func _IrrGetTerrainHeight($h_Terrain, $f_X, $f_Y)
	$result = DllCall($_irrDll, "float:cdecl", "IrrGetTerrainHeight", "ptr", $h_Terrain, "float", $f_X, "float", $f_Y)
	if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrGetTerrainHeight


; #FUNCTION# =============================================================================================================
; Name...........: _IrrScaleTexture
; Description ...: Specifies the scaling of a terrain object detail texture
; Syntax.........: _IrrScaleTexture($h_Terrain, $f_X, $f_Y)
; Parameters ....: $h_Terrain - Handle of a terrain object
;                  $f_X, $f_Y - Scaling values for detail texture along x and y axis
; Return values .: success - True
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: As a terrain object is a particularly huge mesh when textures are applied to it they look extremely pixelated.
;                  To get over this effect a terrain object can have two materials applied to it, one to give general surface color and a second that is copied across the surface like tiles to give a rough detailed texture.
;                  This call specifies the scaling of this detail texture.
; Related .......: _IrrAddTerrain
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrScaleTexture($h_Terrain, $f_X, $f_Y)
	DllCall($_irrDll, "none:cdecl", "IrrScaleTexture", "ptr", $h_Terrain, "float", $f_X, "float", $f_Y)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrScaleTexture


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetTerrainTileHeight
; Description ...: [todo]
; Syntax.........: _IrrGetTerrainTileHeight($h_Terrain, $f_X, $f_Y)
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
Func _IrrGetTerrainTileHeight($h_Terrain, $f_X, $f_Y)
	$result = DllCall($_irrDll, "float:cdecl", "IrrGetTerrainTileHeight", "ptr", $h_Terrain, "float", $f_X, "float", $f_Y)
	if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrGetTerrainTileHeight


; #FUNCTION# =============================================================================================================
; Name...........: _IrrScaleTileTexture
; Description ...: [todo]
; Syntax.........: _IrrScaleTileTexture($h_Terrain, $f_X, $f_Y)
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
Func _IrrScaleTileTexture($h_Terrain, $f_X, $f_Y)
	DllCall($_irrDll, "none:cdecl", "IrrScaleTileTexture", "UINT_PTR", $h_Terrain, "float", $f_X, "float", $f_Y)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrScaleTileTexture


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrAttachTile
; Description ...: [todo]
; Syntax.........: _IrrAttachTile($h_Terrain, $h_Neighbor, $i_Edge)
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
Func _IrrAttachTile($h_Terrain, $h_Neighbor, $i_Edge)
	DllCall($_irrDll, "none:cdecl", "IrrAttachTile", "UINT_PTR", $h_Terrain, "UINT_PTR", $h_Neighbor, "uint", $i_Edge)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrAttachTile


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrSetTileStructure
; Description ...: [todo]
; Syntax.........: _IrrSetTileStructure($h_Terrain, $h_Image, $i_X, $i_Y)
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
Func _IrrSetTileStructure($h_Terrain, $h_Image, $i_X, $i_Y)
	DllCall($_irrDll, "none:cdecl", "IrrSetTileStructure", "UINT_PTR", $h_Terrain, "UINT_PTR", $h_Image, "int", $i_X, "int", $i_Y)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrSetTileStructure



; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetTileColor
; Description ...: [todo]
; Syntax.........: _IrrSetTileColor($h_Terrain, $h_Image, $i_X=0, $i_Y=0)
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
Func _IrrSetTileColor($h_Terrain, $h_Image, $i_X=0, $i_Y=0)
	DllCall($_irrDll, "none:cdecl", "IrrSetTileColor", "UINT_PTR", $h_Terrain, "UINT_PTR", $h_Image, "int", $i_X, "int", $i_Y)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrSetTileColor


; #FUNCTION# =============================================================================================================
; Name...........: _IrrScaleSphericalTexture
; Description ...: [todo]
; Syntax.........: _IrrScaleSphericalTexture($h_Terrain, $f_X, $f_Y)
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
Func _IrrScaleSphericalTexture($h_Terrain, $f_X, $f_Y)
	DllCall($_irrDll, "none:cdecl", "IrrScaleSphericalTexture", "UINT_PTR", $h_Terrain, "float", $f_X, "float", $f_Y)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrScaleSphericalTexture


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrSetSphericalTerrainTexture
; Description ...: [todo]
; Syntax.........: _IrrSetSphericalTerrainTexture($h_Terrain, $s_Top, $s_Front, $s_Back, $s_Left, $s_Right, $s_Bottom, $i_MaterialIndex)
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
Func _IrrSetSphericalTerrainTexture($h_Terrain, $s_Top, $s_Front, $s_Back, $s_Left, $s_Right, $s_Bottom, $i_MaterialIndex)
	DllCall($_irrDll, "none:cdecl", "IrrSetSphericalTerrainTexture", "UINT_PTR", $h_Terrain, "str", $s_Top, "str", $s_Front, "str", $s_Back, "str", $s_Left, "str", $s_Right, "str", $s_Bottom, "int", $i_MaterialIndex)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrSetSphericalTerrainTexture


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrLoadSphericalTerrainVertexColor
; Description ...: [todo]
; Syntax.........: _IrrLoadSphericalTerrainVertexColor($h_Terrain, $s_Top, $s_Front, $s_Back, $s_Left, $s_Right, $s_Bottom)
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
Func _IrrLoadSphericalTerrainVertexColor($h_Terrain, $s_Top, $s_Front, $s_Back, $s_Left, $s_Right, $s_Bottom)
	DllCall($_irrDll, "none:cdecl", "IrrLoadSphericalTerrainVertexColor", "ptr", $h_Terrain, "str", $s_Top, "str", $s_Front, "str", $s_Back, "str", $s_Left, "str", $s_Right, "str", $s_Bottom)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrLoadSphericalTerrainVertexColor


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrGetSphericalTerrainSurfacePosition
; Description ...: Get the surface position of a logical point on the terrain.
; Syntax.........: _IrrGetSphericalTerrainSurfacePosition($h_Terrain, $i_Face, $f_LogicalX, $f_LogicalZ)
; Parameters ....: $h_Terrain - Handle to a Spherical Terrain object as returned by _IrrAddSphericalTerrain function
;                  $i_Face - Integer value of a Face to calculate for.
;                  $f_LogicalX - Float value for Logical X position.
;                  $f_LogicalZ - Float value for Logical Z position.
; Return values .: Success - 1D Array with the returned values
;                  |$Array[0] = X float value
;                  |$Array[1] = Y float value
;                  |$Array[2] = Z float value
;                  Failure - False and set @error 1
; Author ........: [todo]
; Modified.......:
; Remarks .......: You supply a face number and a logical X, Y position on that face and this call will return the height of that point on the terrain sphere.
;                  X, Y, Z is returned in a 1D Array.
;                  Note: By subtracting the center of the sphere from this co-ordinate and converting this vector to angles you can find the upward direction of the point on the surface.
; Related .......: _IrrAddSphericalTerrain
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrGetSphericalTerrainSurfacePosition($h_Terrain, $i_Face, $f_LogicalX, $f_LogicalZ)
    Local $aResult, $aReturn[3]
    $aResult = DllCall($_irrDll, "none:cdecl", "IrrGetSphericalTerrainSurfacePosition", "ptr", $h_Terrain, "int", $i_Face, "float", $f_LogicalX, "float", $f_LogicalZ, "float*", 0, "float*", 0, "float*", 0)
    If @error Or Not IsArray($aResult) Then Return SetError(1, 0, False)
    For $i = 0 To 2
        $aReturn[$i] = $aResult[$i + 5]
    Next
    Return SetError(0, 0, $aReturn)
EndFunc   ;==>_IrrGetSphericalTerrainSurfacePosition


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrGetSphericalTerrainSurfacePositionAndAngle
; Description ...: [todo]
; Syntax.........: _IrrGetSphericalTerrainSurfacePositionAndAngle($h_Terrain, $i_Face, $f_LogicalX, $f_LogicalY, $f_LogicalZ)
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
Func _IrrGetSphericalTerrainSurfacePositionAndAngle($h_Terrain, $i_Face, $f_LogicalX, $f_LogicalY, $f_LogicalZ)
	Local $X = DllStructCreate("float")
	Local $Y = DllStructCreate("float")
	Local $Z = DllStructCreate("float")
	Local $RotX = DllStructCreate("float")
	Local $RotY = DllStructCreate("float")
	Local $RotZ = DllStructCreate("float")
	DllCall($_irrDll, "none:cdecl", "IrrGetSphericalTerrainSurfacePositionAndAngle", "ptr", $h_Terrain, "int", $i_Face, "float", $f_LogicalX, "float", $f_LogicalY, "float", $f_LogicalZ, "float*", DllStructGetPtr($X), "float*", DllStructGetPtr($Y), "float*", DllStructGetPtr($Z), "float*", DllStructGetPtr($RotX), "float*", DllStructGetPtr($RotY), "float*", DllStructGetPtr($RotZ))
	Local $result[2][3] = [[DllStructGetData($X, 1), DllStructGetData($Y, 1), DllStructGetData($Z, 1)],[DllStructGetData($RotX, 1), DllStructGetData($RotY, 1), DllStructGetData($RotZ, 1)]]
EndFunc   ;==>_IrrGetSphericalTerrainSurfacePositionAndAngle


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrGetSphericalTerrainLogicalSurfacePosition
; Description ...: [todo]
; Syntax.........: _IrrGetSphericalTerrainLogicalSurfacePosition($h_Terrain, $i_Face, $f_LogicalX, $f_LogicalY, $f_LogicalZ)
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
Func _IrrGetSphericalTerrainLogicalSurfacePosition($h_Terrain, $i_Face, $f_LogicalX, $f_LogicalY, $f_LogicalZ)
	Local $X = DllStructCreate("float")
	Local $Y = DllStructCreate("float")
	Local $Z = DllStructCreate("float")
	DllCall($_irrDll, "none:cdecl", "IrrGetSphericalTerrainLogicalSurfacePosition", "ptr", $h_Terrain, "int", $i_Face, "float", $f_LogicalX, "float", $f_LogicalY, "float", $f_LogicalZ, "float*", DllStructGetPtr($X), "float*", DllStructGetPtr($Y), "float*", DllStructGetPtr($Z))
	Local $result[3] = [DllStructGetData($X, 1), DllStructGetData($Y, 1), DllStructGetData($Z, 1)]
EndFunc   ;==>_IrrGetSphericalTerrainLogicalSurfacePosition
