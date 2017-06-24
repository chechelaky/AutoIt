#include-once

#include "au3Irr2_constants.au3"

; #INDEX# =======================================================================================================================
; Title .........: Collision
; AutoIt Version : v3.3.6.1
; Language ......: English
; Description ...: Calls for creating collision groups and for calculating collisions in the scene.
; Author(s) .....: jRowe, linus.
;                  DLL functionality by Frank Dodd and IrrlichtWrapper for FreeBasic team (IrrlichtWrapper.dll),
;                  and Nikolaus Gebhardt and Irrlicht team (Irrlicht.dll).
; Dll(s) ........: IrrlichtWrapper.dll, Irrlicht.dll, msvcp71.dll, msvcr71.dll
; ===============================================================================================================================

; #NO_DOC_FUNCTION# =============================================================================================================
; Not working/documented/implemented at this time
;_IrrGetCollisionGroupFromTerrain
;_IrrRemoveCollisionGroup
;_IrrRemoveAllCollisionGroupsFromCombination
;_IrrRemoveCollisionGroupFromCombination
;_IrrGetRayFromScreenCoordinates
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;_IrrGetCollisionGroupFromMesh
;_IrrGetCollisionGroupFromComplexMesh
;_IrrGetCollisionGroupFromBox
;_IrrCreateCombinedCollisionGroup
;_IrrAddCollisionGroupToCombination
;_IrrGetCollisionPoint
;_IrrGetCollisionNodeFromCamera
;_IrrGetCollisionNodeFromRay
;_IrrGetCollisionNodeFromScreenCoordinates
;_IrrGetScreenCoordinatesFrom3DPosition
;_IrrGet3DPositionFromScreenCoordinates
;_IrrGet2DPositionFromScreenCoordinates
;_IrrGetChildCollisionNodeFromRay
;_IrrGetChildCollisionNodeFromPoint
;_IrrGetNodeAndCollisionPointFromRay
;_IrrGetDistanceBetweenNodes
;_IrrAreNodesIntersecting
;_IrrIsPointInsideNode
;_IrrGetCollisionResultPosition
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; ===============================================================================================================================

; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetCollisionGroupFromMesh
; Description ...: [todo]
; Syntax.........: _IrrGetCollisionGroupFromMesh($h_Mesh, $h_Node, $i_Frame = 0)
; Parameters ....: [param1] - [explanation]
;                  |[moreTextForParam1]
;                  [param2] - [explanation]
; Return values .: [success] - [explanation]
;                  [failure] - [explanation]
;                  |[moreExplanationIndented]
; Author ........: [todo]
; Modified.......:
; Remarks .......: [todo]
; Related .......: _IrrGetCollisionGroupFromComplexMesh, _IrrGetCollisionGroupFromBox, _IrrGetCollisionGroupFromTerrain, _IrrRemoveCollisionGroup, _IrrCreateCombinedCollisionGroup
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrGetCollisionGroupFromMesh($h_Mesh, $h_Node, $i_Frame = 0)
; gets a collision object from an animated mesh
	$result = DllCall($_irrDll, "UINT_PTR:cdecl", "IrrGetCollisionGroupFromMesh", "UINT_PTR", $h_Mesh, "UINT_PTR", $h_Node, "int", $i_Frame)
	if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrGetCollisionGroupFromMesh



; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetCollisionGroupFromComplexMesh
; Description ...: Creates an optimized triangle selection group from a large complex mesh like a map.
; Syntax.........: _IrrGetCollisionGroupFromComplexMesh($h_Mesh, $h_Node, $i_Frame = 0)
; Parameters ....: $h_Mesh - Handle of mesh the node was created from.
;                  $h_Node - Handle of the node to create a selector from.
;                  $i_Frame - [optional] Number of mesh frame to use.
; Return values .: success - Handle to a selector object
;                  failure - False
; Author ........:
; Modified.......:
; Remarks .......: The returned triangle selection group can then be used in collision functions to collide objects against this node.
; Related .......: _IrrGetCollisionGroupFromMesh, _IrrGetCollisionGroupFromBox, _IrrGetCollisionGroupFromTerrain, _IrrRemoveCollisionGroup, _IrrCreateCombinedCollisionGroup
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrGetCollisionGroupFromComplexMesh($h_Mesh, $h_Node, $i_Frame = 0)
	$result = DllCall($_irrDll, "UINT_PTR:cdecl", "IrrGetCollisionGroupFromComplexMesh", "UINT_PTR", $h_Mesh, "UINT_PTR", $h_Node, "int", $i_Frame)
	if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrGetCollisionGroupFromComplexMesh


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetCollisionGroupFromBox
; Description ...: [todo]
; Syntax.........: _IrrGetCollisionGroupFromBox($h_Node)
; Parameters ....: [param1] - [explanation]
;                  |[moreTextForParam1]
;                  [param2] - [explanation]
; Return values .: [success] - [explanation]
;                  [failure] - [explanation]
;                  |[moreExplanationIndented]
; Author ........: [todo]
; Modified.......:
; Remarks .......: [todo]
; Related .......: _IrrGetCollisionGroupFromMesh, _IrrGetCollisionGroupFromComplexMesh, _IrrGetCollisionGroupFromTerrain, _IrrRemoveCollisionGroup, _IrrCreateCombinedCollisionGroup
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrGetCollisionGroupFromBox($h_Node)
	$result = DllCall($_irrDll, "ptr:cdecl", "IrrGetCollisionGroupFromBox", "ptr", $h_Node)
	if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrGetCollisionGroupFromBox


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrGetCollisionGroupFromTerrain
; Description ...: [todo]
; Syntax.........: _IrrGetCollisionGroupFromTerrain($h_Node, $i_Lod)
; Parameters ....: [param1] - [explanation]
;                  |[moreTextForParam1]
;                  [param2] - [explanation]
; Return values .: [success] - [explanation]
;                  [failure] - [explanation]
;                  |[moreExplanationIndented]
; Author ........: [todo]
; Modified.......:
; Remarks .......: [todo]
; Related .......: _IrrGetCollisionGroupFromMesh, _IrrGetCollisionGroupFromComplexMesh, _IrrGetCollisionGroupFromBox, _IrrRemoveCollisionGroup, _IrrCreateCombinedCollisionGroup
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrGetCollisionGroupFromTerrain($h_Node, $i_Lod)
	$result = DllCall($_irrDll, "ptr:cdecl", "IrrGetCollisionGroupFromTerrain", "ptr", $h_Node, "int", $i_Lod)
	if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrGetCollisionGroupFromTerrain


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrRemoveCollisionGroup
; Description ...: [todo]
; Syntax.........: _IrrRemoveCollisionGroup($h_CollisionGroup, $h_Node)
; Parameters ....: [param1] - [explanation]
;                  |[moreTextForParam1]
;                  [param2] - [explanation]
; Return values .: [success] - [explanation]
;                  [failure] - [explanation]
;                  |[moreExplanationIndented]
; Author ........: [todo]
; Modified.......:
; Remarks .......: [todo]
; Related .......: _IrrGetCollisionGroupFromMesh, _IrrGetCollisionGroupFromComplexMesh, _IrrGetCollisionGroupFromBox, _IrrGetCollisionGroupFromTerrain, _IrrCreateCombinedCollisionGroup
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrRemoveCollisionGroup($h_CollisionGroup, $h_Node)
	DllCall($_irrDll, "none:cdecl", "IrrRemoveCollisionGroup", "ptr", $h_CollisionGroup, "ptr", $h_Node)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrRemoveCollisionGroup


; #FUNCTION# =============================================================================================================
; Name...........: _IrrCreateCombinedCollisionGroup
; Description ...: [todo]
; Syntax.........: _IrrCreateCombinedCollisionGroup()
; Parameters ....: [param1] - [explanation]
;                  |[moreTextForParam1]
;                  [param2] - [explanation]
; Return values .: [success] - [explanation]
;                  [failure] - [explanation]
;                  |[moreExplanationIndented]
; Author ........: [todo]
; Modified.......:
; Remarks .......: [todo]
; Related .......: _IrrGetCollisionGroupFromMesh, _IrrGetCollisionGroupFromComplexMesh, _IrrGetCollisionGroupFromBox, _IrrGetCollisionGroupFromTerrain, _IrrRemoveCollisionGroup
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrCreateCombinedCollisionGroup()
	$result = DllCall($_irrDll, "ptr:cdecl", "IrrCreateCombinedCollisionGroup")
	if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrCreateCombinedCollisionGroup


; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddCollisionGroupToCombination
; Description ...: [todo]
; Syntax.........: _IrrAddCollisionGroupToCombination($h_CombinedCollisionGroup, $h_CollisionGroup)
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
Func _IrrAddCollisionGroupToCombination($h_CombinedCollisionGroup, $h_CollisionGroup)
	$result = DllCall($_irrDll, "ptr:cdecl", "IrrAddCollisionGroupToCombination", "ptr", $h_CombinedCollisionGroup, "ptr", $h_CollisionGroup)
	if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrAddCollisionGroupToCombination


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrRemoveAllCollisionGroupsFromCombination
; Description ...: [todo]
; Syntax.........: _IrrRemoveAllCollisionGroupsFromCombination($h_CombinedCollisionGroup)
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
Func _IrrRemoveAllCollisionGroupsFromCombination($h_CombinedCollisionGroup)
	DllCall($_irrDll, "none:cdecl", "IrrRemoveAllCollisionGroupsFromCombination", "ptr", $h_CombinedCollisionGroup)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrRemoveAllCollisionGroupsFromCombination


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrRemoveCollisionGroupFromCombination
; Description ...: [todo]
; Syntax.........: _IrrRemoveCollisionGroupFromCombination($h_CombinedCollisionGroup, $h_CollisionGroup)
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
Func _IrrRemoveCollisionGroupFromCombination($h_CombinedCollisionGroup, $h_CollisionGroup)
	DllCall($_irrDll, "none:cdecl", "IrrRemoveCollisionGroupFromCombination", "ptr", $h_CombinedCollisionGroup, "ptr", $h_CollisionGroup)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrRemoveCollisionGroupFromCombination



; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetCollisionPoint
; Description ...: [todo]
; Syntax.........: _IrrGetCollisionPoint($a_StartVector, $a_EndVector, $h_CollisionGroup, byRef $a_CollisionVector)
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
Func _IrrGetCollisionPoint($a_StartVector, $a_EndVector, $h_CollisionGroup, byRef $a_CollisionVector)

	Local $StartVectorStruct = DllStructCreate("float;float;float")
	DllStructSetData($StartVectorStruct, 1, $a_StartVector[0])
	DllStructSetData($StartVectorStruct, 2, $a_StartVector[1])
	DllStructSetData($StartVectorStruct, 3, $a_StartVector[2])
	Local $EndVectorStruct = DllStructCreate("float;float;float")
	DllStructSetData($EndVectorStruct, 1, $a_EndVector[0])
	DllStructSetData($EndVectorStruct, 2, $a_EndVector[1])
	DllStructSetData($EndVectorStruct, 3, $a_EndVector[2])

	Local $CollisionVectorStruct = DllStructCreate("float;float;float")
	$result = DllCall($_irrDll, "int:cdecl", "IrrGetCollisionPoint", "ptr", DllStructGetPtr($StartVectorStruct), _
				"ptr", DllStructGetPtr($EndVectorStruct), "ptr", $h_CollisionGroup, "ptr", DllStructGetPtr($CollisionVectorStruct))
	if @error Then
		Return Seterror(1,0,False)
	Else
		dim $a_CollisionVector[3] = [DllStructGetData($CollisionVectorStruct, 1), DllStructGetData($CollisionVectorStruct, 2), DllStructGetData($CollisionVectorStruct, 3)]
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrGetCollisionPoint



; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrGetRayFromScreenCoordinates
; Description ...: [todo]
; Syntax.........: _IrrGetRayFromScreenCoordinates($i_X, $i_Y, $h_Camera)
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
Func _IrrGetRayFromScreenCoordinates($i_X, $i_Y, $h_Camera)
	Local $StartVectorStruct = DllStructCreate("float;float;float")
	Local $EndVectorStruct = DllStructCreate("float;float;float")
	DllCall($_irrDll, "none:cdecl", "IrrGetRayFromScreenCoordinates", "int", $i_X, "int", $i_Y, "ptr", $h_Camera, "ptr", DllStructGetPtr($StartVectorStruct), "ptr", DllStructGetPtr($EndVectorStruct))
	Local $result[2][3] = [[DllStructGetData($StartVectorStruct, 1), DllStructGetData($StartVectorStruct, 2), DllStructGetData($StartVectorStruct, 3)],[DllStructGetData($EndVectorStruct, 1), DllStructGetData($EndVectorStruct, 2), DllStructGetData($EndVectorStruct, 3)]]
	Return $result
EndFunc   ;==>_IrrGetRayFromScreenCoordinates


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetCollisionNodeFromCamera
; Description ...: [todo]
; Syntax.........: _IrrGetCollisionNodeFromCamera($h_Camera)
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
Func _IrrGetCollisionNodeFromCamera($h_Camera)
	$result = DllCall($_irrDll, "ptr:cdecl", "IrrGetCollisionNodeFromCamera", "ptr", $h_Camera)
	if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrGetCollisionNodeFromCamera



; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetCollisionNodeFromRay
; Description ...: [todo]
; Syntax.........: _IrrGetCollisionNodeFromRay(byRef $h_StartVector, byRef $h_EndVector)
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
Func _IrrGetCollisionNodeFromRay(byRef $h_StartVector, byRef $h_EndVector)
; a ray is cast through the supplied coordinates and the nearest node that is
; hit by the ray is returned. if no node is hit zero is returned for the object

local $structStartVector = DllStructCreate("float;float;float")
DllStructSetData($structStartVector, 1, $h_StartVector[0])
DllStructSetData($structStartVector, 2, $h_StartVector[1])
DllStructSetData($structStartVector, 3, $h_StartVector[2])
local $structEndVector = DllStructCreate("float;float;float")
DllStructSetData($structEndVector, 1, $h_EndVector[0])
DllStructSetData($structEndVector, 2, $h_EndVector[1])
DllStructSetData($structEndVector, 3, $h_EndVector[2])

$result = DllCall($_irrDll, "UINT_PTR:cdecl", "IrrGetCollisionNodeFromRay", "ptr", _
					DllStructGetPtr($structStartVector), "ptr", DllStructGetPtr($structEndVector) )
	if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrGetCollisionNodeFromRay



; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetCollisionNodeFromScreenCoordinates
; Description ...: [todo]
; Syntax.........: _IrrGetCollisionNodeFromScreenCoordinates($i_X, $i_Y)
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
Func _IrrGetCollisionNodeFromScreenCoordinates($i_X, $i_Y)
; a ray is cast through the screen at the specified co-ordinates and the nearest
; node that is hit by the ray is returned. if no node is hit zero is returned
; for the object
	$result = DllCall($_irrDll, "UINT_PTR:cdecl", "IrrGetCollisionNodeFromScreenCoordinates", "int", $i_X, "int", $i_Y)
	if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrGetCollisionNodeFromScreenCoordinates



; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetScreenCoordinatesFrom3DPosition
; Description ...: Screen co-ordinates are returned for the position of the specified 3D co-ordinates.
; Syntax.........: _IrrGetScreenCoordinatesFrom3DPosition(ByRef $i_ScreenX, ByRef $i_ScreenY, $a_3DPositionVector)
; Parameters ....: $i_ScreenX, $i_ScreenY - Variables which will contain coordinates after call of the function.
;                  $a_3DPositionVector - 1D array with three elements for x, y, z values of a position in space.
; Return values .: Success - True and sets passed $i_ScreenX and $i_ScreenY
;                  Failure - False and @error = 1
; Author ........:
; Modified.......:
; Remarks .......: Screen co-ordinates are returned for the position of the specified 3D co-ordinates as if an object were drawn at them on the screen, this is ideal for drawing 2D bitmaps or text around or on your 3D object on the screen for example in the HUD of an aircraft.
; Related .......: _IrrGet3DPositionFromScreenCoordinates, _IrrGet2DPositionFromScreenCoordinates
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrGetScreenCoordinatesFrom3DPosition(ByRef $i_ScreenX, ByRef $i_ScreenY, $a_3DPositionVector)
	if not UBound($a_3DPositionVector) = 3 then Return Seterror(2,0,False)

	$result = DllCall($_irrDll, "none:cdecl", "IrrGetScreenCoordinatesFrom3DPosition", "int*", $i_ScreenX, "int*", $i_ScreenY, _
						"float", $a_3DPositionVector[0], "float", $a_3DPositionVector[1], "float", $a_3DPositionVector[2])
	if @error Then
		Return Seterror(1,0,False)
	Else
		$i_ScreenX = $result[1]
		$i_ScreenY = $result[2]
		Return true
	EndIf
EndFunc   ;==>_IrrGetScreenCoordinatesFrom3DPosition



; #FUNCTION# =============================================================================================================
; Name...........: _IrrGet3DPositionFromScreenCoordinates
; Description ...: [todo]
; Syntax.........: _IrrGet3DPositionFromScreenCoordinates($i_X, $i_Y, ByRef $a_Vector3df, $h_Camera, $f_NormalX=0.0, $f_NormalY=0.0, $f_NormalZ=1.0, $f_DistanceFromOrigin=0.0)
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
Func _IrrGet3DPositionFromScreenCoordinates($i_X, $i_Y, ByRef $a_Vector3df, $h_Camera, $f_NormalX=0.0, $f_NormalY=0.0, $f_NormalZ=1.0, $f_DistanceFromOrigin=0.0)
; Calculates the intersection between a ray projected through the specified
; screen co-ordinates and a plane defined a normal and distance from the
; world origin (contributed by agamemnus)
	$result = DllCall($_irrDll, "none:cdecl", "IrrGet3DPositionFromScreenCoordinates", "int", $i_X, "int", $i_Y, _
				"float*", $a_Vector3df[0], "float*", $a_Vector3df[1], "float*", $a_Vector3df[2], _
				"ptr", $h_Camera, "float", $f_NormalX, "float", $f_NormalY, "float", $f_NormalZ, "float", $f_DistanceFromOrigin)

	if @error Then
		Return Seterror(1,0,False)
	Else
		$a_Vector3df[0] = $result[3]
		$a_Vector3df[1] = $result[4]
		$a_Vector3df[2] = $result[5]
		Return $a_Vector3df
	EndIf
EndFunc   ;==>_IrrGet3DPositionFromScreenCoordinates



; #FUNCTION# =============================================================================================================
; Name...........: _IrrGet2DPositionFromScreenCoordinates
; Description ...: [todo]
; Syntax.........: _IrrGet2DPositionFromScreenCoordinates($i_X, $i_Y, ByRef $f_X, ByRef $f_Y, $h_Camera)
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
Func _IrrGet2DPositionFromScreenCoordinates($i_X, $i_Y, ByRef $f_X, ByRef $f_Y, $h_Camera)
; Calculates the intersection between a ray projected through the specified
; screen co-ordinates and a flat surface plane (contributed by agamemnus)
	$result = DllCall($_irrDll, "none:cdecl", "IrrGet2DPositionFromScreenCoordinates", "int", $i_X, "int", $i_Y, _
				"float*", $f_X, "float*", $f_Y, "ptr", $h_Camera)

	if @error Then
		Return Seterror(1,0,False)
	Else
		$f_X = $result[3]
		$f_Y = $result[4]
		Return true
	EndIf
EndFunc   ;==>_IrrGet2DPositionFromScreenCoordinates



; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetChildCollisionNodeFromRay
; Description ...: [todo]
; Syntax.........: _IrrGetChildCollisionNodeFromRay($h_Node, $i_Mask, $i_Recurse, $a_StartVector, $a_EndVector)
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
Func _IrrGetChildCollisionNodeFromRay($h_Node, $i_Mask, $i_Recurse, $a_StartVector, $a_EndVector)
	Local $StartVectorStruct = DllStructCreate("float;float;float")
	DllStructSetData($StartVectorStruct, 1, $a_StartVector[0])
	DllStructSetData($StartVectorStruct, 2, $a_StartVector[1])
	DllStructSetData($StartVectorStruct, 3, $a_StartVector[2])
	Local $EndVectorStruct = DllStructCreate("float;float;float")
	DllStructSetData($EndVectorStruct, 1, $a_EndVector[0])
	DllStructSetData($EndVectorStruct, 2, $a_EndVector[1])
	DllStructSetData($EndVectorStruct, 3, $a_EndVector[2])
	$result = DllCall($_irrDll, "ptr:cdecl", "IrrGetChildCollisionNodeFromRay", "ptr", $h_Node, "int", $i_Mask, "int", $i_Recurse, "ptr", DllStructGetPtr($StartVectorStruct), "ptr", DllStructGetPtr($EndVectorStruct) )
	if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrGetChildCollisionNodeFromRay


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetChildCollisionNodeFromPoint
; Description ...: [todo]
; Syntax.........: _IrrGetChildCollisionNodeFromPoint($h_Node, $i_Mask, $i_Recurse, $a_PointVector)
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
Func _IrrGetChildCollisionNodeFromPoint($h_Node, $i_Mask, $i_Recurse, $a_PointVector)
	Local $PointVectorStruct = DllStructCreate("float;float;float")
	DllStructSetData($PointVectorStruct, 1, $a_PointVector[0])
	DllStructSetData($PointVectorStruct, 2, $a_PointVector[1])
	DllStructSetData($PointVectorStruct, 3, $a_PointVector[2])
	$result = DllCall($_irrDll, "ptr:cdecl", "IrrGetChildCollisionNodeFromPoint", "ptr", $h_Node, "int", $i_Mask, "int", $i_Recurse, "ptr", DllStructGetPtr($PointVectorStruct))
	if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrGetChildCollisionNodeFromPoint



; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetNodeAndCollisionPointFromRay
; Description ...: [todo]
; Syntax.........: _IrrGetNodeAndCollisionPointFromRay($a_StartVector, $a_EndVector, ByRef $h_Node, ByRef $f_PosX, ByRef $f_PosY, ByRef $f_PosZ, ByRef $f_NormalX, ByRef $f_NormalY, ByRef $f_NormalZ, $i_ID = 0, $h_RootNode = $IRR_NO_OBJECT)
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
Func _IrrGetNodeAndCollisionPointFromRay($a_StartVector, $a_EndVector, ByRef $h_Node, ByRef $f_PosX, ByRef $f_PosY, ByRef $f_PosZ, ByRef $f_NormalX, ByRef $f_NormalY, ByRef $f_NormalZ, $i_ID = 0, $h_RootNode = $IRR_NO_OBJECT)
; a ray is cast through the specified co-ordinates and the nearest node that has
; a collision selector object that is hit by the ray is returned along with the
; coordinate of the collision and the normal of the triangle that is hit. if no
; node is hit zero is returned for the object
	Local $StartVectorStruct = DllStructCreate("float;float;float")
	DllStructSetData($StartVectorStruct, 1, $a_StartVector[0])
	DllStructSetData($StartVectorStruct, 2, $a_StartVector[1])
	DllStructSetData($StartVectorStruct, 3, $a_StartVector[2])
	Local $EndVectorStruct = DllStructCreate("float;float;float")
	DllStructSetData($EndVectorStruct, 1, $a_EndVector[0])
	DllStructSetData($EndVectorStruct, 2, $a_EndVector[1])
	DllStructSetData($EndVectorStruct, 3, $a_EndVector[2])
 	$h_Node = DllStructCreate("UINT_PTR")
	$result = DllCall($_irrDll, "none:cdecl", "IrrGetNodeAndCollisionPointFromRay", _
			"ptr", DllStructGetPtr($StartVectorStruct), "ptr", DllStructGetPtr($EndVectorStruct), "ptr*", $h_Node, _
			"float*", $f_PosX, "float*", $f_PosY, "float*", $f_PosZ, _
			"float*", $f_NormalX, "float*", $f_NormalY, "float*", $f_NormalZ, _
			"int", $i_ID, "ptr", $h_Node)

	if @error Then
		Return Seterror(1,0,False)
	Elseif $result[3] = 0 Then
		return 0
	Else
		$h_Node = $result[3]
		$f_PosX = $result[4]
		$f_PosY = $result[5]
		$f_PosZ = $result[6]
		$f_NormalX = $result[7]
		$f_NormalY = $result[8]
		$f_NormalZ = $result[9]
		Return $h_Node
	EndIf

EndFunc   ;==>_IrrGetNodeAndCollisionPointFromRay



; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetDistanceBetweenNodes
; Description ...: [todo]
; Syntax.........: _IrrGetDistanceBetweenNodes($h_NodeA, $h_NodeB)
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
Func _IrrGetDistanceBetweenNodes($h_NodeA, $h_NodeB)
	$result = DllCall($_irrDll, "float:cdecl", "IrrGetDistanceBetweenNodes", "ptr", $h_NodeA, "ptr", $h_NodeB)
	if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrGetDistanceBetweenNodes


; #FUNCTION# =============================================================================================================
; Name...........: _IrrAreNodesIntersecting
; Description ...: [todo]
; Syntax.........: _IrrAreNodesIntersecting($h_NodeA, $h_NodeB)
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
Func _IrrAreNodesIntersecting($h_NodeA, $h_NodeB)
	$result = DllCall($_irrDll, "int:cdecl", "IrrAreNodesIntersecting", "ptr", $h_NodeA, "ptr", $h_NodeB)
	if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrAreNodesIntersecting


; #FUNCTION# =============================================================================================================
; Name...........: _IrrIsPointInsideNode
; Description ...: [todo]
; Syntax.........: _IrrIsPointInsideNode($h_NodeA, $f_X, $f_Y, $f_Z)
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
Func _IrrIsPointInsideNode($h_NodeA, $f_X, $f_Y, $f_Z)
	$result = DllCall($_irrDll, "int:cdecl", "IrrIsPointInsideNode", "ptr", $h_NodeA, "float", $f_X, "float", $f_Y, "float", $f_Z)
	if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrIsPointInsideNode



; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetCollisionResultPosition
; Description ...: [todo]
; Syntax.........: _IrrGetCollisionResultPosition($h_Selector, ByRef $a_EllipsoidPosition, ByRef $a_EllipsoidRadius, ByRef $a_Velocity, ByRef $a_Gravity, $f_SlidingSpeed, ByRef $a_OutPosition, ByRef $a_OutHitPosition, ByRef $i_OutFalling)
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
Func _IrrGetCollisionResultPosition($h_Selector, ByRef $a_EllipsoidPosition, ByRef $a_EllipsoidRadius, ByRef $a_Velocity, ByRef $a_Gravity, $f_SlidingSpeed, ByRef $a_OutPosition, ByRef $a_OutHitPosition, ByRef $i_OutFalling)
; Collides a moving ellipsoid with a 3d world with gravity and returns the
; resulting new position of the ellipsoid. (contributed by The Car)
	Local $structEllipsoidPosition = DllStructCreate("float;float;float")
	DllStructSetData($structEllipsoidPosition, 1, $a_EllipsoidPosition[0])
	DllStructSetData($structEllipsoidPosition, 2, $a_EllipsoidPosition[1])
	DllStructSetData($structEllipsoidPosition, 3, $a_EllipsoidPosition[2])
	Local $structEllipsoidRadius = DllStructCreate("float;float;float")
	DllStructSetData($structEllipsoidRadius, 1, $a_EllipsoidRadius[0])
	DllStructSetData($structEllipsoidRadius, 2, $a_EllipsoidRadius[1])
	DllStructSetData($structEllipsoidRadius, 3, $a_EllipsoidRadius[2])
	Local $structVelocity = DllStructCreate("float;float;float")
	DllStructSetData($structVelocity, 1, $a_Velocity[0])
	DllStructSetData($structVelocity, 2, $a_Velocity[1])
	DllStructSetData($structVelocity, 3, $a_Velocity[2])
	Local $structGravity = DllStructCreate("float;float;float")
	DllStructSetData($structGravity, 1, $a_Gravity[0])
	DllStructSetData($structGravity, 2, $a_Gravity[1])
	DllStructSetData($structGravity, 3, $a_Gravity[2])
	Local $structOutPosition = DllStructCreate("float;float;float")
	Local $structOutHitPosition = DllStructCreate("float;float;float")

	$result = DllCall($_irrDll, "none:cdecl", "IrrGetCollisionResultPosition", "ptr", $h_Selector, "ptr", DllStructGetPtr($structEllipsoidPosition), "ptr", DllStructGetPtr($structEllipsoidRadius), _
			"ptr", DllStructGetPtr($structVelocity), "ptr", DllStructGetPtr($structGravity), "float", $f_SlidingSpeed, _
			"ptr", DllStructGetPtr($structOutPosition), "ptr", DllStructGetPtr($structOutHitPosition), "int*", $i_OutFalling)

	if @error Then
		Return Seterror(1,0,False)
	Else
		dim $a_OutPosition[3] = [ DllStructGetData($structOutPosition, 1), DllStructGetData($structOutPosition, 2), DllStructGetData($structOutPosition, 3) ]
		dim $a_OutHitPosition[3] = [ DllStructGetData($structOutHitPosition, 1), DllStructGetData($structOutHitPosition, 2), DllStructGetData($structOutHitPosition, 3) ]
		$i_OutFalling = $result[9]
		Return True
	EndIf
EndFunc   ;==>_IrrGetCollisionResultPosition
