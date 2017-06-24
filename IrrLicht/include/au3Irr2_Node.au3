#include-once

#include "au3Irr2_constants.au3"

; #INDEX# =======================================================================================================================
; Title .........: Node
; AutoIt Version : v3.3.6.1
; Language ......: English
; Description ...: Calls for manipulating, texturing and getting information from nodes in the scene.
; Author(s) .....: jRowe, linus.
;                  DLL functionality by Frank Dodd and IrrlichtWrapper for FreeBasic team (IrrlichtWrapper.dll),
;                  and Nikolaus Gebhardt and Irrlicht team (Irrlicht.dll).
; Dll(s) ........: IrrlichtWrapper.dll, Irrlicht.dll, msvcp71.dll, msvcr71.dll, msvcr71.dll
; ===============================================================================================================================

; #NO_DOC_FUNCTION# =============================================================================================================
; Not working/documented/implemented at this time
;_IrrSetNodeParent
;_IrrGetNodeID
;_IrrGetNodeBoundingBox
;_IrrSetNodeRotationPositionChange
;xxx_IrrSetNodeRotationPositionChange
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;_IrrGetNodeName
;_IrrSetNodeName
;_IrrGetNodeMesh
;_IrrGetMaterialCount
;_IrrGetMaterial
;_IrrSetNodeMaterialTexture
;_IrrSetNodeMaterialFlag
;_IrrSetNodeMaterialType
;_IrrSetNodePosition
;_IrrSetNodeRotation
;_IrrSetNodeScale
;_IrrDebugDataVisible
;_IrrGetNodePosition
;_IrrGetNodeAbsolutePosition
;_IrrGetNodeRotation
;_IrrGetJointNode
;_IrrAddChildToParent
;_IrrGetNodeFirstChild
;_IrrGetNodeNextChild
;_IrrIsNodeLastChild
;_IrrAddNodeShadow
;_IrrSetNodeVisibility
;_IrrRemoveNode
;_IrrRemoveAllNodes
;_IrrSetNodeID
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; ===============================================================================================================================

; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetNodeName
; Description ...: [todo]
; Syntax.........: _IrrGetNodeName($h_Node)
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
Func _IrrGetNodeName($h_Node)
	Local $aResult
	$aResult = DllCall($_irrDll, "str:cdecl", "IrrGetNodeName", "ptr", $h_Node)
	If @error Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrGetNodeName


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetNodeName
; Description ...: [todo]
; Syntax.........: _IrrSetNodeName($h_Node, $s_Name)
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
Func _IrrSetNodeName($h_Node, $s_Name)
	DllCall($_irrDll, "none:cdecl", "IrrSetNodeName", "ptr", $h_Node, "str", $s_Name)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetNodeName


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetNodeMesh
; Description ...: [todo]
; Syntax.........: _IrrGetNodeMesh ($h_Node)
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
Func _IrrGetNodeMesh($h_Node)
	; Get the mesh assiciated with a given node
	Local $aResult
	$aResult = DllCall($_irrDll, "ptr:cdecl", "IrrGetNodeMesh", "ptr", $h_Node)
	If @error Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrGetNodeMesh


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetMaterialCount
; Description ...: [todo]
; Syntax.........: _IrrGetMaterialCount($h_Node)
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
Func _IrrGetMaterialCount($h_Node)
	Local $aResult
	$aResult = DllCall($_irrDll, "uint:cdecl", "IrrGetMaterialCount", "ptr", $h_Node)
	If @error Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrGetMaterialCount


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetMaterial
; Description ...: [todo]
; Syntax.........: _IrrGetMaterial($h_Node, $i_Material)
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
Func _IrrGetMaterial($h_Node, $i_Material)
	Local $aResult
	$aResult = DllCall($_irrDll, "ptr:cdecl", "IrrGetMaterial", "ptr", $h_Node, "uint", $i_Material)
	If @error Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrGetMaterial


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetNodeMaterialTexture
; Description ...: Applys a texture to a node in the scene.
; Syntax.........: _IrrSetNodeMaterialTexture($h_Node, $h_Texture, $i_Index)
; Parameters ....: $h_Node - Handle of a node in the scene
;                  $h_Texture - Handle of a texture object
;                  $i_Index - Material index number of the material layer, usually 0 or 1.
; Return values .: Success - True
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: How the texture is applied across the surface of the node will depend on the texturing coordinates in each of the vectors of the mesh and how they are plotted across the surface of the texture.
;                  Some nodes can have several textures applied to them to create special material effects.
; Related .......: _IrrSetNodeMaterialFlag, _IrrSetNodeMaterialType
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrSetNodeMaterialTexture($h_Node, $h_Texture, $i_Index)
	DllCall($_irrDll, "none:cdecl", "IrrSetNodeMaterialTexture", "UINT_PTR", $h_Node, "UINT_PTR", $h_Texture, "int", $i_Index)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetNodeMaterialTexture


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetNodeMaterialFlag
; Description ...: Sets material properies of a node that will effect its appearance on the screen.
; Syntax.........: _IrrSetNodeMaterialFlag($h_Node, $i_Type, $i_Flag)
; Parameters ....: $h_Node - Handle of a node in the scene
;                  $i_Type - Material type is one of the following properties:
;                  |$IRR_EMF_WIREFRAME - Render as wireframe outline
;                  |$IRR_EMF_GOURAUD_SHADING - Render smoothly across polygons
;                  |$IRR_EMF_LIGHTING - Material is effected by lighting
;                  |$IRR_EMF_ZBUFFER - Enable z buffer
;                  |$IRR_EMF_ZWRITE_ENABLE - Can write as well as read z buffer
;                  |$IRR_EMF_BACK_FACE_CULLING - Cull polygons facing away
;                  |$IRR_EMF_BILINEAR_FILTER - Enable bilinear filtering
;                  |$IRR_EMF_TRILINEAR_FILTER - Enable trilinear filtering
;                  |$IRR_EMF_ANISOTROPIC_FILTER - Reduce blur in distant textures
;                  |$IRR_EMF_FOG_ENABLE - Enable fogging in the distance
;                  |$IRR_EMF_NORMALIZE_NORMALS - Use when scaling dynamically lighted models
;                  $i_Flag - Switches selected property on or off:
;                  |$IRR_ON
;                  |$IRR_OFF
; Return values .: Success - True
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: None.
; Related .......: _IrrSetNodeMaterialTexture, _IrrSetNodeMaterialType
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrSetNodeMaterialFlag($h_Node, $i_Type, $i_Flag)
	DllCall($_irrDll, "none:cdecl", "IrrSetNodeMaterialFlag", "UINT_PTR", $h_Node, "int", $i_Type, "uint", $i_Flag)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetNodeMaterialFlag


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetNodeMaterialType
; Description ...: Set the way that materials are applied to a scene node
; Syntax.........: _IrrSetNodeMaterialType($h_Node, $i_Type)
; Parameters ....: $h_Node - Handle of a scene node
;                  $i_Type - Material property to apply to the scene node (see table in remarks)
; Return values .: success - True
;                  failure - False
; Author ........:
; Modified.......:
; Remarks .......: <b>Valid material properties:</b>
;                  @@StandardTable@@
;                  $IRR_EMT_SOLID	Standard solid rendering uses one texture
;                  $IRR_EMT_SOLID_2_LAYER	2 blended textures using vertex alpha value
;                  $IRR_EMT_LIGHTMAP	2 textures: 0=color 1=lighting level and ignores vertex lighting
;                  $IRR_EMT_LIGHTMAP_ADD	... as above but adds levels instead of modulating between them
;                  $IRR_EMT_LIGHTMAP_M2	... as above but color levels are multiplied by 2 for brightening
;                  $IRR_EMT_LIGHTMAP_M4	... as above but color leels are multiplied by 4 for brightening
;                  $IRR_EMT_LIGHTMAP_LIGHTING	2 textures: 0=color 1=lighting level but supports dynamic lighting
;                  $IRR_EMT_LIGHTMAP_LIGHTING_M2	... as above but color levels are multiplied by 2 for brightening
;                  $IRR_EMT_LIGHTMAP_LIGHTING_M4	... as above but color levels are multiplied by 4 for brightening
;                  $IRR_EMT_DETAIL_MAP	2 blended textures: the first is a color map the second at a different scale adds and subtracts from the color to add detail
;                  $IRR_EMT_SPHERE_MAP	makes the material appear reflective
;                  $IRR_EMT_REFLECTION_2_LAYER	a reflective material blended with a color texture
;                  $IRR_EMT_TRANSPARENT_ADD_COLOR	a transparency effect that simply adds a color texture to the background. the darker the color the more transparent it is.
;                  $IRR_EMT_TRANSPARENT_ALPHA_CHANNEL	a transparency effect that uses the color textures alpha as a transparency level
;                  $IRR_EMT_TRANSPARENT_ALPHA_CHANNEL_REF	a transparency effect that uses the color textures alpha, the pixel is only drawn if the alpha is > 127. this is a fast effect that does not blur edges and is ideal for leaves & grass etc.
;                  $IRR_EMT_TRANSPARENT_VERTEX_ALPHA	a transparency effect that uses the vertex alpha value
;                  $IRR_EMT_TRANSPARENT_REFLECTION_2_LAYER	a transparent & reflecting effect. the first texture is a reflection map, the second a color map. transparency is from vertex alpha
;                  $IRR_EMT_NORMAL_MAP_SOLID	A solid normal map renderer. First texture is color, second is normal map. Only use nodes added with IrrAddStaticMeshForNormalMappingToScene. Only supports nearest two lights. Requires vertex and pixel shaders 1.1
;                  $IRR_EMT_NORMAL_MAP_TRANSPARENT_ADD_COLOR	... as above only with a transparency effect that simply adds the color to the background. the darker the color the more transparent it is.
;                  $IRR_EMT_NORMAL_MAP_TRANSPARENT_VERTEX_ALPHA	... as above only with a transparency effect that uses the vertex alpha value
;                  $IRR_EMT_PARALLAX_MAP_SOLID	similar to the solid normal map but more realistic providing virtual displacement of the surface. Uses the alpha channel of the normal map for height field displacement. Requires vertex shader 1.1 and pixel shader 1.4.
;                  $IRR_EMT_PARALLAX_MAP_TRANSPARENT_ADD_COLOR	... as above only with a transparency effect that simply adds the color to the background. the darker the color the more transparent it is.
;                  $IRR_EMT_PARALLAX_MAP_TRANSPARENT_VERTEX_ALPHA	... as above only with a transparency effect that uses the vertex alpha value
;                  @@End@@
; Related .......: _IrrSetNodeMaterialTexture, _IrrSetNodeMaterialFlag
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrSetNodeMaterialType($h_Node, $i_Type)
	DllCall($_irrDll, "none:cdecl", "IrrSetNodeMaterialType", "UINT_PTR", $h_Node, "int", $i_Type)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetNodeMaterialType


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetNodePosition
; Description ...: Moves the node to the specified position
; Syntax.........: _IrrSetNodePosition($h_Node, $f_X, $f_Y, $f_Z)
; Parameters ....: $h_Node - Handle of a scene node
;                  $f_X, $f_Y, $f_Z - X, Y, Z values of new position
; Return values .: Success - True
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: None
; Related .......: _IrrGetNodePosition, _IrrGetNodeRotation, _IrrSetNodeRotation, _IrrGetNodeAbsolutePosition
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrSetNodePosition($h_Node, $f_X, $f_Y, $f_Z)
	DllCall($_irrDll, "none:cdecl", "IrrSetNodePosition", "UINT_PTR", $h_Node, "float", $f_X, "float", $f_Y, "float", $f_Z)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetNodePosition


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetNodeRotation
; Description ...: Rotate a node to the specified orientation through its X, Y and Z axis
; Syntax.........: _IrrSetNodeRotation($h_Node, $f_X, $f_Y, $f_Z)
; Parameters ....: $h_Node - Handle of a scene node
;                  $f_X, $f_Y, $f_Z - Values of rotation along X, Y, Z axes in degrees (0-360)
; Return values .: Success - True
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: None
; Related .......: _IrrGetNodePosition, _IrrSetNodePosition, _IrrGetNodeRotation, _IrrGetNodeAbsolutePosition
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrSetNodeRotation($h_Node, $f_X, $f_Y, $f_Z)
	DllCall($_irrDll, "none:cdecl", "IrrSetNodeRotation", "ptr", $h_Node, "float", $f_X, "float", $f_Y, "float", $f_Z)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetNodeRotation


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetNodeScale
; Description ...: Sets the scale of the scene node
; Syntax.........: _IrrSetNodeScale($h_Node, $f_X, $f_Y, $f_Z)
; Parameters ....: $h_Node - Handle of a scene node
;                  $f_X, $f_Y, $f_Z - Scaling factors for X, Y, Z axes.
; Return values .: Success - True
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: None
; Related .......: _IrrSetNodePosition, _IrrSetNodeRotation
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrSetNodeScale($h_Node, $f_X, $f_Y, $f_Z)
	DllCall($_irrDll, "none:cdecl", "IrrSetNodeScale", "UINT_PTR", $h_Node, "float", $f_X, "float", $f_Y, "float", $f_Z)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetNodeScale


; #FUNCTION# =============================================================================================================
; Name...........: _IrrDebugDataVisible
; Description ...: Displays debugging data around a node (typically the bounding box around edges of the node).
; Syntax.........: _IrrDebugDataVisible($h_Node, $i_Visible = $EDS_BBOX)
; Parameters ....: $h_Node - Handle of a scene node.
;                  $i_Visible - Type of debugging information (not all of them are supported on all node types):
;                  |$EDS_OFF: No Debugging
;                  |$EDS_BBOX: Bounding Box
;                  |$EDS_NORMALS: Normals
;                  |$EDS_SKELETON: Skeleton
;                  |$EDS_MESH_WIRE_OVERLAY: Wireframe
;                  |$EDS_HALF_TRANSPARENCY: Transparency
;                  |$EDS_BBOX_BUFFERS: Bounding Box Buffers
;                  |$EDS_FULL: Everything
; Return values .: None.
; Author ........:
; Modified.......:
; Remarks .......: None.
; Related .......: None.
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrDebugDataVisible($h_Node, $i_Visible = $EDS_BBOX)
	DllCall($_irrDll, "none:cdecl", "IrrDebugDataVisible", "ptr", $h_Node, "int", $i_Visible)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrDebugDataVisible


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetNodePosition
; Description ...: Returns array with position coordinates of a scene node.
; Syntax.........: _IrrGetNodePosition($h_Node)
; Parameters ....: $h_Node - Handle of a scene node
; Return values .: success - 0-based array with three elements for X, Y, Z coordinates.
;                  failure - False
; Author ........:
; Modified.......:
; Remarks .......: None.
; Related .......: _IrrSetNodePosition, _IrrGetNodeRotation, _IrrSetNodeRotation, _IrrGetNodeAbsolutePosition
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrGetNodePosition($h_Node)
	Dim $a_Vector3df[3], $aResult
	$aResult = DllCall($_irrDll, "none:cdecl", "IrrGetNodePosition", "ptr", $h_Node, "float*", $a_Vector3df[0], "float*", $a_Vector3df[1], "float*", $a_Vector3df[2])
	If @error Or Not IsArray($aResult) Then Return SetError(1, 0, False)
	$a_Vector3df[0] = $aResult[2]
	$a_Vector3df[1] = $aResult[3]
	$a_Vector3df[2] = $aResult[4]
	Return SetError(0, 0, $a_Vector3df)
EndFunc   ;==>_IrrGetNodePosition


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetNodeAbsolutePosition
; Description ...: Get the absoloute position of the node in the scene.
; Syntax.........: _IrrGetNodeAbsolutePosition($h_Node)
; Parameters ....: $h_Node - Handle of a scene node
; Return values .: success - 0-based array with three elements for X, Y, Z coordinates.
;                  failure - False
; Author ........:
; Modified.......:
; Remarks .......: The absolute postion includes the position changes of all of the nodes parents too.
; Related .......: _IrrGetNodePosition, _IrrSetNodePosition, _IrrGetNodeRotation, _IrrSetNodeRotation
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _IrrGetNodeAbsolutePosition($h_Node)
	Dim $a_Vector3df[3], $aResult
	$aResult = DllCall($_irrDll, "none:cdecl", "IrrGetNodeAbsolutePosition", "ptr", $h_Node, "float*", $a_Vector3df[0], "float*", $a_Vector3df[1], "float*", $a_Vector3df[2])
	If @error Or Not IsArray($aResult) Then Return SetError(1, 0, False)
	$a_Vector3df[0] = $aResult[2]
	$a_Vector3df[1] = $aResult[3]
	$a_Vector3df[2] = $aResult[4]
	Return SetError(0, 0, $a_Vector3df)
EndFunc   ;==>_IrrGetNodeAbsolutePosition


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetNodeRotation
; Description ...: Returns array with rotation values of a scene node.
; Syntax.........: _IrrGetNodeRotation($h_Node)
; Parameters ....: $h_Node - Handle of a scene node
; Return values .: success - 0-based array with three elements for X, Y, Z rotation.
;                  failure - False
; Author ........:
; Modified.......:
; Remarks .......: None.
; Related .......: _IrrGetNodePosition, _IrrSetNodePosition, _IrrSetNodeRotation, _IrrGetNodeAbsolutePosition
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrGetNodeRotation($h_Node)
	Dim $a_Vector3df[3], $aResult
	$aResult = DllCall($_irrDll, "none:cdecl", "IrrGetNodeRotation", "ptr", $h_Node, "float*", $a_Vector3df[0], "float*", $a_Vector3df[1], "float*", $a_Vector3df[2])
	If @error Or Not IsArray($aResult) Then Return SetError(1, 0, False)
	$a_Vector3df[0] = Number($aResult[2])
	$a_Vector3df[1] = Number($aResult[3])
	$a_Vector3df[2] = Number($aResult[4])
	Return SetError(0, 0, $a_Vector3df)
EndFunc   ;==>_IrrGetNodeRotation


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetJointNode
; Description ...: [todo]
; Syntax.........: _IrrGetJointNode($h_Node, $s_Joint)
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
Func _IrrGetJointNode($h_Node, $s_Joint)
	Local $aResult
	$aResult = DllCall($_irrDll, "ptr:cdecl", "IrrGetJointNode", "ptr", $h_Node, "str", $s_Joint)
	If @error Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrGetJointNode


; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddChildToParent
; Description ...: [todo]
; Syntax.........: _IrrAddChildToParent($h_ChildNode, $h_ParentNode)
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
Func _IrrAddChildToParent($h_ChildNode, $h_ParentNode)
	DllCall($_irrDll, "none:cdecl", "IrrAddChildToParent", "ptr", $h_ChildNode, "ptr", $h_ParentNode)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrAddChildToParent


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetNodeFirstChild
; Description ...: [todo]
; Syntax.........: _IrrGetNodeFirstChild($h_Node, ByRef $h_Position)
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
Func _IrrGetNodeFirstChild($h_Node, ByRef $h_Position)
	; get the first child node of this node, returns 0 if there is no child
	Local $aResult
	$aResult = DllCall($_irrDll, "UINT_PTR:cdecl", "IrrGetNodeFirstChild", "UINT_PTR", $h_Node, "UINT_PTR*", $h_Position)
	If @error Or Not IsArray($aResult) Then Return SetError(1, 0, False)
	$h_Position = $aResult[2]
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrGetNodeFirstChild


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetNodeNextChild
; Description ...: Get the next child node of this node, returns 0 if there is no child.
; Syntax.........: _IrrGetNodeNextChild($h_Node, ByRef $h_Position)
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
Func _IrrGetNodeNextChild($h_Node, ByRef $h_Position)
	Local $aResult
	$aResult = DllCall($_irrDll, "UINT_PTR:cdecl", "IrrGetNodeNextChild", "UINT_PTR", $h_Node, "UINT_PTR*", $h_Position)
	If @error Then Return SetError(1, 0, False)
	$h_Position = $aResult[2]
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrGetNodeNextChild

; #FUNCTION# =============================================================================================================
; Name...........: _IrrIsNodeLastChild
; Description ...: [todo]
; Syntax.........: _IrrIsNodeLastChild($h_Node, ByRef $h_Position)
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
Func _IrrIsNodeLastChild($h_Node, ByRef $h_Position)
	; returns true if this is the last child of the parent
	Local $aResult
	$aResult = DllCall($_irrDll, "UINT_PTR:cdecl", "IrrIsNodeLastChild", "UINT_PTR", $h_Node, "ptr*", $h_Position)
	If @error Or Not IsArray($aResult) Then Return SetError(1, 0, False)
	$h_Position = $aResult[2]
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrIsNodeLastChild


; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddNodeShadow
; Description ...: Adds shadows to a node that are cast across other nodes in the scene.
; Syntax.........: _IrrAddNodeShadow($h_Node, $h_mesh = 0)
; Parameters ....: $h_Node - Handle of a node in the scene
;                  $h_mesh - [optional] Handle of mesh casting the shadow (0 uses mesh of h_Node, see remarks)
; Return values .: Success - True
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: _IrrAddShadows will only work when shadowing has been activated with _IrrStart or _IrrStartAdvanced.
;                  You should analyse the performance of your scene carefully when using this function as it can have a significant effect on your frame rate.
;                  You can supply a different mesh to the one used to display the node, this shadow mesh could be a much lower resoloution than that used for your model thereby improving performance.
;                  <br><b>_IrrAddNodeShadow does NOT work with buildin nodes types _IrrAddTestSceneNode, _IrrAddCubeSceneNode, and _IrrAddSphereSceneNode. If you need a cube or a sphere casting shadows, create a node from a loaded cube or sphere mesh as workaround.</b>
; Related .......: _IrrStart, _IrrStartAdvanced, _IrrSetShadowColor, _IrrAddLight, _IrrSetAmbientLight
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrAddNodeShadow($h_Node, $h_mesh = 0)
	DllCall($_irrDll, "none:cdecl", "IrrAddNodeShadow", "ptr", $h_Node, "ptr", $h_mesh)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrAddNodeShadow


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetNodeVisibility
; Description ...: [todo]
; Syntax.........: _IrrSetNodeVisibility($h_Node, $i_Visible)
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
Func _IrrSetNodeVisibility($h_Node, $i_Visible)
	DllCall($_irrDll, "none:cdecl", "IrrSetNodeVisibility", "ptr", $h_Node, "int", $i_Visible)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetNodeVisibility


; #FUNCTION# =============================================================================================================
; Name...........: _IrrRemoveNode
; Description ...: Removes a node from the scene deleting it.
; Syntax.........: _IrrRemoveNode($h_Node)
; Parameters ....: $h_Node - Handle of a scene node
; Return values .: Success - True
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: None
; Related .......: None
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrRemoveNode($h_Node)
	DllCall($_irrDll, "none:cdecl", "IrrRemoveNode", "ptr", $h_Node)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrRemoveNode


; #FUNCTION# =============================================================================================================
; Name...........: _IrrRemoveAllNodes
; Description ...: [todo]
; Syntax.........: _IrrRemoveAllNodes()
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
Func _IrrRemoveAllNodes()
	DllCall($_irrDll, "none:cdecl", "IrrRemoveAllNodes")
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrRemoveAllNodes


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrSetNodeParent
; Description ...: [todo]
; Syntax.........: _IrrSetNodeParent($h_Node, $h_Parent)
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
Func _IrrSetNodeParent($h_Node, $h_Parent)
	DllCall($_irrDll, "none:cdecl", "IrrSetNodeParent", "ptr", $h_Node, "ptr", $h_Parent)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetNodeParent


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrGetNodeID
; Description ...: [todo]
; Syntax.........: _IrrGetNodeID($h_Node)
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
Func _IrrGetNodeID($h_Node)
	; get the ID of this node
	Local $aResult
	$aResult = DllCall($_irrDll, "int:cdecl", "IrrGetNodeID", "ptr", $h_Node)
	If @error Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrGetNodeID


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetNodeID
; Description ...: [todo]
; Syntax.........: _IrrSetNodeID($h_Node, $i_ID)
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
Func _IrrSetNodeID($h_Node, $i_ID)
	; set the ID of this node
	DllCall($_irrDll, "none:cdecl", "IrrSetNodeID", "ptr", $h_Node, "int", $i_ID)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetNodeID


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrGetNodeBoundingBox
; Description ...: [todo]
; Syntax.........: _IrrGetNodeBoundingBox($h_Node, ByRef $a_VectorA3df, ByRef $a_VectorB3df)
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
Func _IrrGetNodeBoundingBox($h_Node, ByRef $a_VectorA3df, ByRef $a_VectorB3df)
	Dim $a_VectorA3df[3], $a_VectorB3df[3], $aResult
	$aResult = DllCall($_irrDll, "none:cdecl", "IrrGetNodeBoundingBox", "ptr", $h_Node, "float*", $a_VectorA3df[0], "float*", $a_VectorA3df[1], "float*", $a_VectorA3df[2], "float*", $a_VectorB3df[0], "float*", $a_VectorB3df[1], "float*", $a_VectorB3df[2])
	If @error Then Return SetError(1, 0, False)
	$a_VectorA3df[0] = $aResult[2]
	$a_VectorA3df[1] = $aResult[3]
	$a_VectorA3df[2] = $aResult[4]
	$a_VectorB3df[0] = $aResult[5]
	$a_VectorB3df[1] = $aResult[6]
	$a_VectorB3df[2] = $aResult[7]
	Return SetError(0, 0, True)
EndFunc   ;==>_IrrGetNodeBoundingBox


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrSetNodeRotationPositionChange
; Description ...: [todo]
; Syntax.........: Func _IrrSetNodeRotationPositionChange($h_Camera, $f_Yaw, $f_Pitch, $f_Roll, $f_Drive, $f_Strafe, $f_Elevate, _
; Parameters ....: [param1] - [explanation]
;                  |[moreTextForParam1]
;                  [param2] - [explanation]
; Return values .: [success] - [explanation]
;                  [failure] - [explanation]
;                  |[moreExplanationIndented]
; Author ........: [todo]
; Modified.......:
; Remarks .......:
; Related .......: __CreateVectStruct, __SetVectStruct, __GetVectStruct
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrSetNodeRotationPositionChange($h_Camera, $f_Yaw, $f_Pitch, $f_Roll, $f_Drive, $f_Strafe, $f_Elevate, _
	ByRef $tForwardVect, ByRef $tUpVector, ByRef $tOffsetVect)

	If Not IsDllStruct($tForwardVect) Then Return SetError(2, 0, False)
	If Not IsDllStruct($tUpVector) Then Return SetError(3, 0, False)
	If Not IsDllStruct($tOffsetVect) Then Return SetError(4, 0, False)
	Local $iOffsetVect, $aResult
	$iOffsetVect = DllStructGetSize($tOffsetVect) / DllStructGetSize(DllStructCreate($tagIRR_VECTOR))
	$aResult = DllCall($_irrDll, "none:cdecl", "IrrSetNodeRotationPositionChange", "ptr", $h_Camera, _
			"float", $f_Yaw, "float", $f_Pitch, "float", $f_Roll, "float", $f_Drive, "float", $f_Strafe, "float", $f_Elevate, _
			"ptr", DllStructGetPtr($tForwardVect), "ptr", DllStructGetPtr($tUpVector), _
			"uint", $iOffsetVect, "ptr", DllStructGetPtr($tOffsetVect))
	If @error Or Not IsArray($aResult) Then Return SetError(1, 0, False)
;~ 		$aForwardVect[0] = DllStructGetData($tForwardV, 1, 1)
;~ 		$aForwardVect[1] = DllStructGetData($tForwardV, 1, 2)
;~ 		$aForwardVect[2] = DllStructGetData($tForwardV, 1, 3)
;~ 		$aUpVector[0] = DllStructGetData($tUpV, 1, 1)
;~ 		$aUpVector[1] = DllStructGetData($tUpV, 1, 2)
;~ 		$aUpVector[2] = DllStructGetData($tUpV, 1, 3)
	$tForwardVect = DllStructGetPtr($aResult[8]) ;DllStructCreate($tagIRR_VECTOR, $aResult[8])
	$tUpVector = DllStructGetPtr($aResult[9]); DllStructCreate($tagIRR_VECTOR,$aResult[9])
	$tOffsetVect = DllStructGetPtr($aResult[11]);DllStructCreate("float;float;float;float;float;float", $aResult[11])
	Return SetError(0, 0, True)
EndFunc   ;==>_IrrSetNodeRotationPositionChange


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: xxx_IrrSetNodeRotationPositionChange
; Description ...: [todo]
; Syntax.........: Func xxx_IrrSetNodeRotationPositionChange($h_Camera, $f_Yaw, $f_Pitch, $f_Roll, $f_Drive, $f_Strafe, $f_Elevate, _
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
Func xxx_IrrSetNodeRotationPositionChange($h_Camera, $f_Yaw, $f_Pitch, $f_Roll, $f_Drive, $f_Strafe, $f_Elevate, _
		ByRef $aForwardVect, ByRef $aUpVector, ByRef $aOffsetVect)

	Local $i_NumOffsetVectors, $tForwardV, $tUpV
	$i_NumOffsetVectors = UBound($aOffsetVect)
	$tForwardV = DllStructCreate("float[3]")
	$tUpV = DllStructCreate("float[3]")
	For $i = 1 To 3
		DllStructSetData($tForwardV, 1, $aForwardVect[0], $i)
		DllStructSetData($tUpV, 1, $aUpVector[0], $i)
	Next
	DllCall($_irrDll, "none:cdecl", "IrrSetNodeRotationPositionChange", "ptr", $h_Camera, _
			"float", $f_Yaw, "float", $f_Pitch, "float", $f_Roll, "float", $f_Drive, "float", $f_Strafe, "float", $f_Elevate, _
			"ptr", DllStructGetPtr($tForwardV), "ptr", DllStructGetPtr($tUpV), _
			"uint", $i_NumOffsetVectors, "float*", $aOffsetVect) ; $h_OffsetVect[0][0])
	If @error Then Return SetError(1, 0, False)
	For $i = 1 To 3
		$aForwardVect[$i - 1] = DllStructGetData($tForwardV, 1, $i)
		$aUpVector[$i - 1] = DllStructGetData($tUpV, 1, $i)
	Next
	Return SetError(0, 0, True)

EndFunc   ;==>xxx_IrrSetNodeRotationPositionChange
