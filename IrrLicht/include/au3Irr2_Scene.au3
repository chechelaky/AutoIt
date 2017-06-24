#include-once

#include "au3Irr2_constants.au3"
#include "au3Irr2_system.au3"

; #INDEX# =======================================================================================================================
; Title .........: Scene
; AutoIt Version : v3.3.6.1
; Language ......: English
; Description ...: Calls for managing the scene, loading and creating mesh objects and then adding them to the scene
;                  as nodes to be rendered on the screen.
; Author(s) .....: jRowe, linus.
;                  DLL functionality by Frank Dodd and IrrlichtWrapper for FreeBasic team (IrrlichtWrapper.dll),
;                  and Nikolaus Gebhardt and Irrlicht team (Irrlicht.dll).
; Dll(s) ........: IrrlichtWrapper.dll, Irrlicht.dll, msvcp71.dll, msvcr71.dll
; ===============================================================================================================================

; #NO_DOC_FUNCTION# =============================================================================================================
; Not working/documented/implemented at this time
;_IrrAddSphereSceneMesh
;_IrrGetMeshFrameCount
;_IrrGetMeshBufferCount
;_IrrSetMeshVertexColors
;_IrrSetMeshVertexCoords
;_IrrSetMeshVertexSingleColor
;_IrrAddEmptySceneNode
;_IrrSetZoneManagerAttachTerrain
;_IrrGetGrassDrawCount
;_IrrSetFlareScale
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;_IrrGetRootSceneNode
;_IrrGetMesh
;_IrrCreateMesh
;_IrrAddHillPlaneMesh
;_IrrWriteMesh
;_IrrRemoveMesh
;_IrrClearUnusedMeshes
;_IrrSetMeshHardwareAccelerated
;_IrrGetMeshIndexCount
;_IrrGetMeshIndices
;_IrrSetMeshIndices
;_IrrGetMeshVertexCount
;_IrrGetMeshVertices
;_IrrSetMeshVertices
;_IrrAddMeshToScene
;_IrrAddMeshToSceneAsOcttree
;_IrrAddStaticMeshForNormalMappingToScene
;_IrrLoadScene
;_IrrSaveScene
;_IrrGetSceneNodeFromId
;_IrrGetSceneNodeFromName
;_IrrAddBillBoardToScene
;_IrrSetBillBoardSize
;_IrrAddBillboardTextSceneNode
;_IrrAddParticleSystemToScene
;_IrrAddSkyBoxToScene
;_IrrAddSkyDomeToScene
;_IrrAddTestSceneNode
;_IrrAddCubeSceneNode
;_IrrAddSphereSceneNode
;_IrrAddWaterSurfaceSceneNode
;_IrrAddZoneManager
;_IrrAddClouds
;_IrrAddLensFlare
;_IrrAddGrass
;_IrrSetShadowColor
;_IrrSetFog
;_IrrDraw3DLine
;_IrrSetSkyDomeColor
;_IrrSetSkyDomeColorBand
;_IrrSetSkyDomeColorPoint
;_IrrSetZoneManagerProperties
;_IrrSetZoneManagerBoundingBox
;_IrrSetGrassDensity
;_IrrSetGrassWind
;_IrrCreateBatchingMesh
;_IrrAddToBatchingMesh
;_IrrFinalizeBatchingMesh
;_IrrSetMeshMaterialTexture
;_IrrScaleMesh
;_IrrAddBeamSceneNode
;_IrrSetBeamSize
;_IrrSetBeamPosition
;_IrrAddBoltSceneNode
;_IrrSetBoltProperties
;_IrrSetBillBoardColor
;_IrrAddBillBoardGroupToScene
;_IrrAddBillBoardToGroup
;_IrrAddBillBoardByAxisToGroup
;_IrrRemoveBillBoardFromGroup
;_IrrBillBoardGroupShadows
;_IrrGetBillBoardGroupCount
;_IrrBillBoardForceUpdate
;_IrrAddLODManager
;_IrrAddLODMesh
;_IrrSetLODMaterialMap
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; ===============================================================================================================================

; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetRootSceneNode
; Description ...: Get the scenes root node, all scene nodes are children of this node.
; Syntax.........: _IrrGetRootSceneNode()
; Parameters ....: None.
; Return values .: Success - Handle of root node in the scene
;                  Failure - False and @error 1
; Author ........:
; Modified.......:
; Remarks .......: [todo]
; Related .......: _IrrAddMeshToScene
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _IrrGetRootSceneNode()
	Local $aResult
	$aResult = DllCall($_irrDll, "ptr:cdecl", "IrrGetRootSceneNode")
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrGetRootSceneNode


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetMesh
; Description ...: Loads the specified mesh ready to be added to the scene.
; Syntax.........: _IrrGetMesh($s_MeshFile)
; Parameters ....: $s_MeshFile - Filename of the mesh object to load
; Return values .: Success - Handle of the loaded mesh object
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: The Irrlicht engine supports a wide range of mesh types.
;                  <br><b>Static objects:</b>
;                  @@StandardTable@@
;                  Irrlicht static meshes (.irrmesh, r/w)	3D Studio meshes (.3ds, r)
;                  |Alias Wavefront Maya (.obj, r/w)	Lightwave Objects (.lwo, r)
;                  |COLLADA 1.4 (.xml, .dae, r/w)	OGRE meshes (.mesh, r)
;                  |My3DTools 3 (.my3D, r)	LMTools (.lmts, r)
;                  |Quake 3 levels (.bsp, r)	DeleD (.dmf, r)
;                  |FSRad oct (.oct, r)	Cartography shop 4 (.csm, r)
;                  |STL 3D files (.stl, r/w)	PLY 3D files (.ply, r/w)
;                  @@End@@
;                  <br><b>Animated objects:</b>
;                  @@StandardTable@@
;                  B3D files (.b3d, r, skeleton)	Microsoft DirectX (.x, r) (binary & text, skeleton)
;                  |Milkshape (.ms3d, r, skeleton)	Quake 3 models (.md3, r, morph)
;                  |Quake 2 models (.md2, r, morph)
;                  @@End@@
; Related .......: _IrrAddMeshToScene, _IrrRemoveMesh
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrGetMesh($s_MeshFile)
	Local $aResult
	$aResult = DllCall($_irrDll, "ptr:cdecl", "IrrGetMesh", "str", $s_MeshFile)
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrGetMesh



; #FUNCTION# =============================================================================================================
; Name...........: _IrrCreateMesh
; Description ...: Create a new mesh from lists of vertices and indices.
; Syntax.........: _IrrCreateMesh($s_MeshName, $tVertexArray, $a_Indices)
; Parameters ....: $s_MeshName - String name for the newly created mesh object.
;                  $tVertexArray - Vertex array struct  as created with __CreateVertStruct or returned from _IrrGetMeshVertices.
;                  $a_Indices - 3D-array with list of indices as returned from _IrrGetMeshIndices or created e.g. with DIM $aIndices[indicesNumber] = [0,1,4,  1,2,4,  ...]
; Return values .: Success - Handle to the newly created mesh object
;                  Failure - False and set @error:
;                  |@error 1 : either AutoIt DllCall or IrrCreateMesh call failed
;                  |@error 2 : $tVertexArray param is not a Struct
;                  |@error 2 : $a_Indices param is not an Array
; Author ........:
; Modified.......:
; Remarks .......: You must supply a list of vertices inside a vertex array struct and an array of indices that refer to these vertices.
;                  The indices are taken in groups of three joining up the dots defined by the verticies and forming a collection of triangles.
; Related .......: _IrrGetMeshVertices, _IrrGetMeshIndices, _IrrAddMeshToScene, __CreateVertStruct
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrCreateMesh($s_MeshName, $tVertexArray, $a_Indices)
	If Not IsDllStruct($tVertexArray) Then Return SetError(2, 0, False)
	If Not IsArray($a_Indices) Then Return SetError(3, 0, False)

	Local $iVerts, $iIndices, $tIndices, $aResult
	$iVerts = DllStructGetSize($tVertexArray) / DllStructGetSize(DllStructCreate($tagIRR_VERTEX))
	$iIndices = UBound($a_Indices)
	$tIndices = DllStructCreate("ushort[" & $iIndices & "]")

	For $i = 1 To $iIndices
		DllStructSetData($tIndices, 1, $a_Indices[$i - 1], $i)
	Next

	$aResult = DllCall($_irrDll, "ptr:cdecl", "IrrCreateMesh", "str", $s_MeshName, "int", $iVerts, "ptr", DllStructGetPtr($tVertexArray), "int", $iIndices, "ptr", DllStructGetPtr($tIndices))
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrCreateMesh




; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrAddSphereSceneMesh
; Description ...: [todo]
; Syntax.........: _IrrAddSphereSceneMesh($s_MeshName, $f_Radius, $i_PolyCount)
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
Func _IrrAddSphereSceneMesh($s_MeshName, $f_Radius, $i_PolyCount)
	local $aResult
	$aResult = DllCall($_irrDll, "ptr:cdecl", "IrrAddSphereSceneMesh", "str", $s_MeshName, "float", $f_Radius, "int", $i_PolyCount)
	If @error Then
		Return SetError(1, 0, False)
	Else
		Return $aResult[0]
	EndIf
EndFunc   ;==>_IrrAddSphereSceneMesh



; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddHillPlaneMesh
; Description ...: Creates a hill plane mesh that represents a simple terrain.
; Syntax.........: _IrrAddHillPlaneMesh($s_Name, $f_TileSizeX, $f_TileSizeY, $i_TileCountX, $i_TileCountY, $h_Material = 0, $f_HillHeight = 0, $f_CountHillsX = 0, $f_CountHillsY = 0, $f_TextureRepeatCountX = 1, $f_TextureRepeatCountY = 1)
; Parameters ....: $s_Name -
;                  $f_TileSizeX -
;                  $f_TileSizeY -
;                  $i_TileCountX -
;                  $i_TileCountY -
;                  $h_Material -
;                  $f_HillHeight -
;                  $f_CountHillsX -
;                  $f_CountHillsY -
;                  $f_TextureRepeatCountX -
;                  $f_TextureRepeatCountY -
; Return values .: Success - Handle to a Terrain Mesh
;                  Failure - False and @error 1
; Author ........:
; Modified.......:
; Remarks .......: Many properties have default values allowing a mesh to be created with a simple call.
; Related .......: [todo: functionName, functionName]
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrAddHillPlaneMesh($s_Name, $f_TileSizeX, $f_TileSizeY, $i_TileCountX, $i_TileCountY, $h_Material = 0, $f_HillHeight = 0, $f_CountHillsX = 0, $f_CountHillsY = 0, $f_TextureRepeatCountX = 1, $f_TextureRepeatCountY = 1)
	Local $aResult
	$aResult = DllCall($_irrDll, "ptr:cdecl", "IrrAddHillPlaneMesh", "str", $s_Name, "float", $f_TileSizeX, "float", $f_TileSizeY, "int", $i_TileCountX, "int", $i_TileCountY, "ptr", $h_Material, "float", $f_HillHeight, "float", $f_CountHillsX, "float", $f_CountHillsY, "float", $f_TextureRepeatCountX, "float", $f_TextureRepeatCountY)
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrAddHillPlaneMesh


; #FUNCTION# =============================================================================================================
; Name...........: _IrrWriteMesh
; Description ...: Write the first frame of the supplied animated mesh out to a file using the specified file format.
; Syntax.........: _IrrWriteMesh($h_Mesh, $i_FileFormat, $s_Filename)
; Parameters ....: $h_Mesh - Handle to mesh object
;                  $i_FileFormat - Format to write the file as:
;                  |$EMWT_IRR_MESH - Irrlicht Native mesh writer, for static .irrmesh files.
;                  |$EMWT_COLLADA - COLLADA mesh writer for .dae and .xml files.
;                  |$EMWT_STL - STL mesh writer for .stl files.
;                  $s_Filename - File name to save as.
; Return values .: Success - True
;                  Failure - False and set @error
;                  |@error 1 - AutoIt DllCall failed.
;                  |@error 2 - Could not get mesh writer object.
;                  |@error 3 - Could not open file.
; Author ........:
; Modified.......:
; Remarks .......: None
; Related .......: _IrrCreateMesh, _IrrGetMesh
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrWriteMesh($h_Mesh, $i_FileFormat, $s_Filename)
	Local $aResult, $iError
	$aResult = DllCall($_irrDll, "int:cdecl", "IrrWriteMesh", "ptr", $h_Mesh, "int", $i_FileFormat, "str", $s_Filename)
	If @error Or Not IsArray($aResult) Then Return SetError(1, 0, False)
	Switch $aResult[0]
		Case 0
			$iError = 2
		Case 1
			$iError = 3
		Case 2
			$iError = 4
		Case 3
			$iError = 0
	EndSwitch
	Return SetError($iError, 0, $aResult[0] = 3)
EndFunc   ;==>_IrrWriteMesh


; #FUNCTION# =============================================================================================================
; Name...........: _IrrRemoveMesh
; Description ...: Removes a mesh from the scene cache, freeing up resources.
; Syntax.........: _IrrRemoveMesh($h_Mesh)
; Parameters ....: $h_Mesh - Handle of a mesh object
; Return values .: Success - True
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: None
; Related .......: _IrrGetMesh
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrRemoveMesh($h_Mesh)
    DllCall($_irrDll, "none:cdecl", "IrrRemoveMesh", "ptr", $h_Mesh)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrRemoveMesh


; #FUNCTION# =============================================================================================================
; Name...........: _IrrClearUnusedMeshes
; Description ...: Clears all meshes that are held in the mesh cache but not used anywhere else.
; Syntax.........: _IrrClearUnusedMeshes()
; Parameters ....: None.
; Return values .: Success - True
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: Any references to these meshes will become invalid.
; Related .......: [todo: functionName, functionName]
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrClearUnusedMeshes()
	DllCall($_irrDll, "none:cdecl", "IrrClearUnusedMeshes")
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrClearUnusedMeshes


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetMeshHardwareAccelerated
; Description ...: Set the supplied mesh as a Hardware Accelerated object.
; Syntax.........: _IrrSetMeshHardwareAccelerated($h_mesh, $i_frame = 0)
; Parameters ....: $h_mesh - Handle of a mesh object
;                  $i_frame - Frame number
; Return values .: Success - True
;                  Failure] - False
; Author ........: [todo]
; Modified.......:
; Remarks .......: This offloads the verticies and indicies to hardware support on the graphics card, making the process of rendering those meshes much faster.
;                  The feature must be supported on the graphics card and the object must contain over 500 vertices for the operation to be successful.
;                  This operation is applied to all mesh buffers in the mesh.
; Related .......: [todo: functionName, functionName]
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrSetMeshHardwareAccelerated($h_Mesh, $i_frame = 0)
	DllCall($_irrDll, "none:cdecl", "IrrSetMeshHardwareAccelerated", "ptr", $h_Mesh, "int", $i_frame)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetMeshHardwareAccelerated



; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrGetMeshFrameCount
; Description ...: Gets the number of frames in the supplied mesh.
; Syntax.........: _IrrGetMeshFrameCount($h_Mesh)
; Parameters ....: $h_Mesh - Handle to a mesh object
;                  $i_frame - Frame number of the mesh to retrieve the buffer count.
; Return values .: Success - Number of frames
;                  Failure - False and @error 1
; Author ........:
; Modified.......:
; Remarks .......: You can use this value to traverse the indicies and vertices in a mesh containing a number of frames.
; Related .......: [todo: functionName, functionName]
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrGetMeshFrameCount($h_Mesh)
	Local $aResult
	$aResult = DllCall($_irrDll, "int:cdecl", "IrrGetMeshFrameCount", "ptr", $h_Mesh)
	If @error Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])

EndFunc   ;==>_IrrGetMeshFrameCount


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrGetMeshBufferCount
; Description ...: Gets the number of mesh buffers in the supplied mesh.
; Syntax.........: _IrrGetMeshBufferCount($h_Mesh, $i_FrameNumber)
; Parameters ....: $h_Mesh - Handle to a mesh object
;                  $i_FrameNumber - Frame number of the mesh to retrieve the buffer count.
; Return values .: Success - Number of buffers
;                  Failure - False and @error 1
; Author ........:
; Modified.......:
; Remarks .......: You can use this value to traverse the indicies and vertices in a mesh containing a number of mesh buffers.
;                  If the mesh is animated frame number indicates the number of the frame to recover mesh data for if it is not animated this value should be set to 0.
; Related .......: [todo: functionName, functionName]
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrGetMeshBufferCount($h_Mesh, $i_FrameNumber)
	Local $aResult
	$aResult = DllCall($_irrDll, "int:cdecl", "IrrGetMeshBufferCount", "ptr", $h_Mesh, "int", $i_FrameNumber)
	If @error Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrGetMeshBufferCount


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetMeshIndexCount
; Description ...: [todo]
; Syntax.........: _IrrGetMeshIndexCount($h_Mesh, $i_Frame, $i_MeshBuffer = 0)
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
Func _IrrGetMeshIndexCount($h_Mesh, $i_frame, $i_MeshBuffer = 0)
	Local $aResult
	$aResult = DllCall($_irrDll, "int:cdecl", "IrrGetMeshIndexCount", "ptr", $h_Mesh, "int", $i_frame, "int", $i_MeshBuffer)
	If @error Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrGetMeshIndexCount



; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetMeshIndices
; Description ...: Gets the list of indices in a mesh and copies them into the supplied variable.
; Syntax.........: _IrrGetMeshIndices($h_Mesh, $i_FrameNumber, ByRef $a_IndicesArray, $i_MeshBuffer = 0)
; Parameters ....: $h_Mesh - Handle to a mesh object
;                  $i_FrameNumber - Frame number of the mesh to get indices from (should be 0 for static meshes).
;                  ByRef $tVertex - Any variable. Will be returned as array with indices.
;                  $i_MeshBuffer - [optional] Mesh buffer to access.
; Return values .: Success - Number of indices returned in the array $a_IndicesArray.
;                  Failure - False and @error = 1
; Author ........:
; Modified.......:
; Remarks .......: [todo]
; Related .......: _IrrSetMeshIndices, _IrrGetMeshIndexCount, _IrrGetMeshVertices
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrGetMeshIndices($h_Mesh, $i_FrameNumber, ByRef $a_IndicesArray, $i_MeshBuffer = 0)

	Local $iIndices = _IrrGetMeshIndexCount($h_Mesh, $i_FrameNumber, $i_MeshBuffer)
	Dim $a_IndicesArray[$iIndices]
	Local $tIndices = DllStructCreate("USHORT[" & $iIndices & "]")
	Local $ret = DllCall($_irrDll, "none:cdecl", "IrrGetMeshIndices", "UINT_PTR", $h_Mesh, "int", $i_FrameNumber, "ptr", DllStructGetPtr($tIndices), "int", $i_MeshBuffer)
	If @error Then
		Return SetError(1, 0, False)
	Else
		Local $i
		For $i = 1 To $iIndices
			$a_IndicesArray[$i - 1] = DllStructGetData($tIndices, 1, $i)
		Next ; $i
		Return $iIndices
	EndIf
EndFunc   ;==>_IrrGetMeshIndices


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetMeshIndices
; Description ...: [todo]
; Syntax.........: _IrrSetMeshIndices($h_Mesh, $i_FrameNumber, ByRef $a_IndicesArray, $i_MeshBuffer = 0)
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
Func _IrrSetMeshIndices($h_Mesh, $i_FrameNumber, ByRef $a_IndicesArray, $i_MeshBuffer = 0)
	if not IsArray($a_IndicesArray) then Return SetError(2, 0, False)

	local $i, $iIndices = UBound($a_IndicesArray)
	Local $tIndices = DllStructCreate("USHORT[" & $iIndices & "]")
	for $i = 1 to $iIndices
		DllStructSetData($tIndices, 1, $a_IndicesArray[$i-1], $i)
	Next ; $i

	DllCall($_irrDll, "none:cdecl", "IrrSetMeshIndices", "ptr", $h_Mesh, "int", $i_FrameNumber, "ptr", DllStructGetPtr($tIndices), "int", $i_MeshBuffer)
	If @error Then
		Return SetError(1, 0, False)
	Else
		Return True
	EndIf
EndFunc   ;==>_IrrSetMeshIndices


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetMeshVertexCount
; Description ...: [todo]
; Syntax.........: _IrrGetMeshVertexCount($h_Mesh, $i_Frame, $i_MeshBuffer = 0)
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
Func _IrrGetMeshVertexCount($h_Mesh, $i_frame, $i_MeshBuffer = 0)
	Local $aResult
	$aResult = DllCall($_irrDll, "int:cdecl", "IrrGetMeshVertexCount", "ptr", $h_Mesh, "int", $i_frame, "int", $i_MeshBuffer)
	If @error Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrGetMeshVertexCount


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetMeshVertices
; Description ...: Gets the list of vertices in a mesh and copies them into the supplied variable.
; Syntax.........: _IrrGetMeshVertices($h_Mesh, $i_FrameNumber, ByRef $tVertex, $i_MeshBuffer = 0)
; Parameters ....: $h_Mesh - Handle to a mesh object
;                  $i_FrameNumber - Frame number of the mesh to get vertices from (should be 0 for static meshes).
;                  ByRef $tVertex - Any variable. Will be returned as vertex array struct.
;                  $i_MeshBuffer - [optional] Mesh buffer to access.
; Return values .: Success - Number of vertices returned in the vertex array struct $tVertex.
;                  Failure - False and @error = 1
; Author ........:
; Modified.......:
; Remarks .......: Each vertex represents a point in the mesh that is the corner of one of the group of triangles that is used to construct the mesh.
;                  If the mesh is animated frame number indicates the number of the frame to recover mesh data for if it is not animated this value should be set to 0.
;                  If the mesh contains a number of mesh buffers you can specific which mesh buffer you want to access, if you omit this parameter mesh buffer 0 will be used.
; Related .......: __SetVertStruct, __GetVertStruct, _IrrSetMeshVertices, _IrrGetMeshVertexCount, _IrrGetMeshIndices
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrGetMeshVertices($h_Mesh, $i_FrameNumber, ByRef $tVertex, $i_MeshBuffer = 0)
	Local $iVertices = _IrrGetMeshVertexCount($h_Mesh, $i_FrameNumber, $i_MeshBuffer)
	$tVertex = __CreateVertStruct($iVertices)

	DllCall($_irrDll, "none:cdecl", "IrrGetMeshVertices", "ptr", $h_Mesh, "int", $i_FrameNumber, "ptr", DllStructGetPtr($tVertex), "int", $i_MeshBuffer)
	If @error Then
		Return SetError(1, 0, False)
	Else
		Return $iVertices
	EndIf
EndFunc   ;==>_IrrGetMeshVertices


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetMeshVertices
; Description ...: This sets the value of the list of vertices in a mesh copying them from the supplied vertex array struct.
; Syntax.........: _IrrSetMeshVertices($h_Mesh, $i_FrameNumber, ByRef $tVertex, $i_MeshBuffer = 0)
; Parameters ....: $h_Mesh - Handle to a mesh object
;                  $i_FrameNumber - Frame number of the mesh to write vertices to (should be 0 for static meshes).
;                  ByRef $tVertex - Vertex array struct as created with __CreateVertStruct or returned from _IrrGetMeshVertices.
;                  $i_MeshBuffer - [optional] Mesh buffer to access.
; Return values .: Success - None.
;                  Failure - False and @error = 1
; Author ........:
; Modified.......:
; Remarks .......: Each vertex represents a point in the mesh that is the corner of one of the group of triangles that is used to construct the mesh.
;                  If the mesh is animated frame number indicates the number of the frame to recover mesh data for if it is not animated this value should be set to 0.
;                  If the mesh contains a number of mesh buffers you can specific which mesh buffer you want to access, if you omit this parameter mesh buffer 0 will be used.
; Related .......: _IrrGetMeshVertices, __CreateVertStruct
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrSetMeshVertices($h_Mesh, $i_FrameNumber, ByRef $tVertex, $i_MeshBuffer = 0)
	if not IsDllStruct($tVertex) then Return SetError(2, 0, False)
	DllCall($_irrDll, "none:cdecl", "IrrSetMeshVertices", "ptr", $h_Mesh, "int", $i_FrameNumber, "ptr", DllStructGetPtr($tVertex), "int", $i_MeshBuffer)
	If @error Then
		Return SetError(1, 0, False)
	Else
		Return True
	EndIf
EndFunc   ;==>_IrrSetMeshVertices


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrSetMeshVertexColors
; Description ...: [todo]
; Syntax.........: _IrrSetMeshVertexColors($h_Mesh, $i_FrameNumber, $h_VertexColourArrayStruct, $h_VertexGroupStartIndices, $h_VertexGroupEndIndices, $i_NumberOfGroups, $i_MeshBuffer)
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
Func _IrrSetMeshVertexColors($h_Mesh, $i_FrameNumber, $h_VertexColourArrayStruct, $h_VertexGroupStartIndices, $h_VertexGroupEndIndices, $i_NumberOfGroups, $i_MeshBuffer)
	;RETURN TO THIS;
	DllCall($_irrDll, "none:cdecl", "IrrSetMeshVertexColors", "ptr", $h_Mesh, "int", $i_FrameNumber, "ptr", $h_VertexColourArrayStruct, "ptr", $h_VertexGroupStartIndices, "ptr", $h_VertexGroupEndIndices, "int", $i_NumberOfGroups, "int", $i_MeshBuffer)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetMeshVertexColors


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrSetMeshVertexCoords
; Description ...: [todo]
; Syntax.........: _IrrSetMeshVertexCoords($h_Mesh, $i_FrameNumber, $h_VertexCoordArrayStruct, $h_VertexGroupStartIndices, $h_VertexGroupEndIndices, $i_NumberOfGroups, $i_MeshBuffer)
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
Func _IrrSetMeshVertexCoords($h_Mesh, $i_FrameNumber, $h_VertexCoordArrayStruct, $h_VertexGroupStartIndices, $h_VertexGroupEndIndices, $i_NumberOfGroups, $i_MeshBuffer)
	;RETURN TO THIS;
	DllCall($_irrDll, "none:cdecl", "IrrSetMeshVertexCoords", "ptr", $h_Mesh, "int", $i_FrameNumber, "ptr", $h_VertexCoordArrayStruct, "ptr", $h_VertexGroupStartIndices, "ptr", $h_VertexGroupEndIndices, "int", $i_NumberOfGroups, "int", $i_MeshBuffer)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetMeshVertexCoords


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrSetMeshVertexSingleColor
; Description ...: [todo]
; Syntax.........: _IrrSetMeshVertexSingleColor($h_Mesh, $i_FrameNumber, $h_VertexColourStruct, $h_VertexGroupStartIndices, $h_VertexGroupEndIndices, $i_NumberOfGroups, $i_MeshBuffer)
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
Func _IrrSetMeshVertexSingleColor($h_Mesh, $i_FrameNumber, $h_VertexColourStruct, $h_VertexGroupStartIndices, $h_VertexGroupEndIndices, $i_NumberOfGroups, $i_MeshBuffer)
	;RETURN TO THIS;
	DllCall($_irrDll, "none:cdecl", "IrrSetMeshVertexSingleColor", "ptr", $h_Mesh, "int", $i_FrameNumber, "ptr", $h_VertexColourStruct, "ptr", $h_VertexGroupStartIndices, "ptr", $h_VertexGroupEndIndices, "int", $i_NumberOfGroups, "int", $i_MeshBuffer)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetMeshVertexSingleColor





; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddMeshToScene
; Description ...: Adds a mesh to the scene as a new 3D node.
; Syntax.........: _IrrAddMeshToScene($h_Mesh)
; Parameters ....: $h_Mesh - Handle of a mesh object
; Return values .: Success - Handle of the new node in the scene
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: None
; Related .......: _IrrGetMesh
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrAddMeshToScene($h_Mesh)
	Local $aResult
	$aResult = DllCall($_irrDll, "UINT_PTR:cdecl", "IrrAddMeshToScene", "UINT_PTR", $h_Mesh)
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrAddMeshToScene


; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddMeshToSceneAsOcttree
; Description ...: Adds a mesh to the scene as a new 3D node, optimised with an Octtree.
; Syntax.........: _IrrAddMeshToSceneAsOcttree($h_Mesh)
; Parameters ....: $h_Mesh - Handle of an mesh object
; Return values .: Success - Handle to the irrlicht node object
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: This method optimise's the mesh with an Octtree, this is particularly useful for maps where there is a lot of geometry in the mesh but little of it can be seen at any one time.
;                  Optimizing your node with this function will result in a large increase in performance.
; Related .......: None
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrAddMeshToSceneAsOcttree($h_Mesh)
	Local $aResult
	$aResult = DllCall($_irrDll, "UINT_PTR:cdecl", "IrrAddMeshToSceneAsOcttree", "UINT_PTR", $h_Mesh)
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrAddMeshToSceneAsOcttree


; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddStaticMeshForNormalMappingToScene
; Description ...: [todo]
; Syntax.........: _IrrAddStaticMeshForNormalMappingToScene($h_Mesh)
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
Func _IrrAddStaticMeshForNormalMappingToScene($h_Mesh)
	Local $aResult
	$aResult = DllCall($_irrDll, "UINT_PTR:cdecl", "IrrAddStaticMeshForNormalMappingToScene", "UINT_PTR", $h_Mesh)
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrAddStaticMeshForNormalMappingToScene


; #FUNCTION# =============================================================================================================
; Name...........: _IrrLoadScene
; Description ...: [todo]
; Syntax.........: _IrrLoadScene($s_Filename)
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
Func _IrrLoadScene($s_Filename)
	DllCall($_irrDll, "none:cdecl", "IrrLoadScene", "str", $s_Filename)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrLoadScene


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSaveScene
; Description ...: [todo]
; Syntax.........: _IrrSaveScene($s_Filename)
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
Func _IrrSaveScene($s_Filename)
	DllCall($_irrDll, "none:cdecl", "IrrSaveScene", "str", $s_Filename)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrSaveScene


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetSceneNodeFromId
; Description ...: [todo]
; Syntax.........: _IrrGetSceneNodeFromId($i_ID)
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
Func _IrrGetSceneNodeFromId($i_ID)
	; get a scene node based on its ID and returns null if no node is found
	Local $aResult
	$aResult = DllCall($_irrDll, "ptr:cdecl", "IrrGetSceneNodeFromId", "int", $i_ID)
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrGetSceneNodeFromId



; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetSceneNodeFromName
; Description ...: [todo]
; Syntax.........: _IrrGetSceneNodeFromName($s_Name)
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
Func _IrrGetSceneNodeFromName($s_Name)
	Local $aResult
	$aResult = DllCall($_irrDll, "ptr:cdecl", "IrrGetSceneNodeFromName", "str", $s_Name)
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrGetSceneNodeFromName


; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddBillBoardToScene
; Description ...: Adds a billboard to the scene of the specified size and at the specified position.
; Syntax.........: _IrrAddBillBoardToScene($f_XSize, $f_YSize, $f_XPos = 0.0, $f_YPos = 0.0, $f_ZPos = 0.0)
; Parameters ....: $f_XSize - X size of the node
;                  $f_YSize - Y size of the node
;                  $f_XPos - [optional] X position
;                  $f_YPos - [optional] Y position
;                  $f_ZPos - [optional] Z position
; Return values .: Success - Handle of the new billboard scene node
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: A billboard is a flat 3D textured sprite that always faces towards the camera. You need to texture this element with a separate command.
; Related .......: _IrrSetNodeMaterialTexture, _IrrSetNodeMaterialFlag
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrAddBillBoardToScene($f_XSize, $f_YSize, $f_XPos = 0.0, $f_YPos = 0.0, $f_ZPos = 0.0)
	Local $aResult
	$aResult = DllCall($_irrDll, "ptr:cdecl", "IrrAddBillBoardToScene", "float", $f_XSize, "float", $f_YSize, "float", $f_XPos, "float", $f_YPos, "float", $f_ZPos)
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrAddBillBoardToScene



; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetBillBoardSize
; Description ...: [todo]
; Syntax.........: _IrrSetBillBoardSize($h_Node, $f_Width, $f_Height)
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
Func _IrrSetBillBoardSize($h_Node, $f_Width, $f_Height)
	DllCall($_irrDll, "none:cdecl", "IrrSetBillBoardSize", "ptr", $h_Node, "float", $f_Width, "float", $f_Height)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetBillBoardSize



; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddBillboardTextSceneNode
; Description ...: [todo]
; Syntax.........: _IrrAddBillboardTextSceneNode($h_Font, $s_Text, $f_XSize, $f_YSize, $f_XPos=0, $f_YPos=0, $f_ZPos=0, $h_Parent=0, $i_TopRGBA=0xFFFFFFFF, $i_BottomRGBA=0xFFFFFFFF)
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
; Example .......: Yes
; ===============================================================================================================================
Func _IrrAddBillboardTextSceneNode($h_Font, $s_Text, $f_XSize, $f_YSize, $f_XPos = 0, $f_YPos = 0, $f_ZPos = 0, $h_Parent = 0, $i_TopRGBA = 0xFFFFFFFF, $i_BottomRGBA = 0xFFFFFFFF)
	Local $aResult
	$aResult = DllCall($_irrDll, "ptr:cdecl", "IrrAddBillboardTextSceneNode", "ptr", $h_Font, "wstr", $s_Text, _
			"float", $f_XSize, "float", $f_YSize, "float", $f_XPos, "float", $f_YPos, "float", $f_ZPos, _
			"ptr", $h_Parent, "uint", $i_TopRGBA, "uint", $i_BottomRGBA)
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrAddBillboardTextSceneNode



; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddParticleSystemToScene
; Description ...: Adds a particle system to the irrlicht scene manager.
; Syntax.........: _IrrAddParticleSystemToScene($b_AddEmitter, $h_Parent = 0, $i_Id = -1, $f_PosX = 0, $f_PosY = 0, $f_PosZ = 0, $f_RotX = 0, $f_RotY = 0, $f_RotZ = 0, $f_ScaleX = 1, $f_ScaleY = 1, $f_ScaleZ = 1)
; Parameters ....: $b_AddEmitter - Whether default emitter shall be created or not:
;                  |$IRR_NO_EMITTER - For no default emitter (this is probably the option you will use and you will then add a specific emitter later).
;                  |IRR_DEFAULT_EMITTER - To create a default emitter that ejects a thin vertical stream of particles.
;                  $h_Parent - [optional] Handle of scene node the particle shall be attached to (0 means attach to the root scene node)
;                  $i_Id  - [optional] Assigns given integer as ID to the created particle system.
;                  $f_PosX, $f_PosY, $f_PosZ - [optional] Set position of particle system in the Irrlicht scene.
;                  $f_RotX, $f_RotY, $f_RotZ - [optional] Rotate the particle system along x, y, z axes (0-360).
;                  $f_ScaleX, $f_ScaleY, $f_ScaleZ - [optional] Scaling factors for created particle system.
; Return values .: success - Handle of the created particle system.
;                  failure - False
; Author ........:
; Modified.......:
; Remarks .......: A particle system is an object that creates and manages hundreds of small billboard like objects that are used to represent smoke, rain and other natural effects.
;                  Once created you then need to add emitters and affectors to create and control the particles.
; Related .......: _IrrAddParticleEmitter, _IrrAddFadeOutParticleAffector, _IrrAddGravityParticleAffector, _IrrAddParticleAttractionAffector, _IrrAddRotationAffector
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrAddParticleSystemToScene($b_AddEmitter, $h_Parent = 0, $i_ID = -1, $f_PosX = 0, $f_PosY = 0, $f_PosZ = 0, $f_RotX = 0, $f_RotY = 0, $f_RotZ = 0, $f_ScaleX = 1, $f_ScaleY = 1, $f_ScaleZ = 1)
	Local $aResult
	$aResult = DllCall($_irrDll, "UINT_PTR:cdecl", "IrrAddParticleSystemToScene", "int", $b_AddEmitter, "UINT_PTR", $h_Parent, "int", $i_ID, _
			"float", $f_PosX = 0, "float", $f_PosY, "float", $f_PosZ, "float", $f_RotX, "float", $f_RotY, "float", $f_RotZ, _
			"float", $f_ScaleX, "float", $f_ScaleY, "float", $f_ScaleZ)
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrAddParticleSystemToScene


; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddSkyBoxToScene
; Description ...: Adds a skybox node to the scene.
; Syntax.........: _IrrAddSkyBoxToScene($h_UpTexture, $h_DownTexture, $h_LeftTexture, $h_RightTexture, $h_FrontTexture, $h_BackTexture)
; Parameters ....: $h_UpTexture - Handle of the top side texture
;                  $h_DownTexture - Handle of the bottom side texture
;                  $h_LeftTexture - Handle of the left side texture
;                  $h_RightTexture - Handle of the right side texture
;                  $h_FrontTexture - Handle of the front side texture
;                  $h_BackTexture - Handle of the back side texture
; Return values .: success - Handle of the skybox node
;                  failure - False
; Author ........:
; Modified.......:
; Remarks .......: A skybox is a huge hollow cube that encapsulates the entire scene and has a different texture applied to each of its six surfaces to represent a distant sky or matte scene.
; Related .......: _IrrAddSkyDomeToScene
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrAddSkyBoxToScene($h_UpTexture, $h_DownTexture, $h_LeftTexture, $h_RightTexture, $h_FrontTexture, $h_BackTexture)
	Local $aResult
	$aResult = DllCall($_irrDll, "ptr:cdecl", "IrrAddSkyBoxToScene", "ptr", $h_UpTexture, "ptr", $h_DownTexture, "ptr", $h_LeftTexture, "ptr", $h_RightTexture, "ptr", $h_FrontTexture, "ptr", $h_BackTexture)
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrAddSkyBoxToScene


; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddSkyDomeToScene
; Description ...: [todo]
; Syntax.........: _IrrAddSkyDomeToScene($h_Texture, $i_HorizontalRes, $i_VerticalRes, $d_TexturePercent, $d_SpherePercent, $d_SphereRadius = 1000.0)
; Parameters ....: [param1] - [explanation]
;                  |[moreTextForParam1]
;                  [param2] - [explanation]
; Return values .: [success] - [explanation]
;                  [failure] - [explanation]
;                  |[moreExplanationIndented]
; Author ........: [todo]
; Modified.......:
; Remarks .......: [todo]
; Related .......: _IrrAddSkyBoxToScene, _IrrSetSkyDomeColor, _IrrSetSkyDomeColorBand, _IrrSetSkyDomeColorPoint
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrAddSkyDomeToScene($h_Texture, $i_HorizontalRes, $i_VerticalRes, $d_TexturePercent, $d_SpherePercent, $d_SphereRadius = 1000.0)
	Local $aResult
	$aResult = DllCall($_irrDll, "ptr:cdecl", "IrrAddSkyDomeToScene", "ptr", $h_Texture, "uint", $i_HorizontalRes, "uint", $i_VerticalRes, "double", $d_TexturePercent, "double", $d_SpherePercent, "double", $d_SphereRadius)
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrAddSkyDomeToScene


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrAddEmptySceneNode
; Description ...: [todo]
; Syntax.........: _IrrAddEmptySceneNode()
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
Func _IrrAddEmptySceneNode()
	Local $aResult
	$aResult = DllCall($_irrDll, "ptr:cdecl", "IrrAddEmptySceneNode")
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrAddEmptySceneNode


; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddTestSceneNode
; Description ...: Adds a simple cube node to the scene
; Syntax.........: _IrrAddTestSceneNode()
; Parameters ....: None
; Return values .: success - Handle of the cube scene node
;                  failure - False
; Author ........:
; Modified.......:
; Remarks .......: The test scene node is a cube with fixed dimensions mainly for test purposes.
; Related .......: _IrrAddCubeSceneNode, _IrrAddSphereSceneNode
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrAddTestSceneNode()
	Local $aResult
	$aResult = DllCall($_irrDll, "UINT_PTR:cdecl", "IrrAddTestSceneNode")
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrAddTestSceneNode


; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddCubeSceneNode
; Description ...: Adds a cube object to the scene with the specified dimensions.
; Syntax.........: _IrrAddCubeSceneNode($f_Size)
; Parameters ....: $f_Size - Edge length of the cube.
; Return values .: success - Handle of the cube scene node
;                  failure - False
; Author ........:
; Modified.......:
; Remarks .......: None
; Related .......: _IrrAddTestSceneNode, _IrrAddSphereSceneNode
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrAddCubeSceneNode($f_Size)
	Local $aResult
	$aResult = DllCall($_irrDll, "ptr:cdecl", "IrrAddCubeSceneNode", "float", $f_Size)
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrAddCubeSceneNode


; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddSphereSceneNode
; Description ...: Adds a simple sphere object to the scene
; Syntax.........: _IrrAddSphereSceneNode($f_Size, $i_PolyCount = 16)
; Parameters ....: $f_Size - Radius of the sphere
;                  $i_PolyCount - [optional] Level of detail for the sphere.
;                  |Too high values could produce a very high density mesh and affect your frame rate adversely.
; Return values .: success - Handle of the sphere scene node
;                  failure - False
; Author ........:
; Modified.......:
; Remarks .......: None
; Related .......: _IrrAddTestSceneNode, _IrrAddCubeSceneNode
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrAddSphereSceneNode($f_Size, $i_PolyCount = 16)
	Local $aResult
	$aResult = DllCall($_irrDll, "ptr:cdecl", "IrrAddSphereSceneNode", "float", $f_Size, "int", $i_PolyCount)
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrAddSphereSceneNode



; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddWaterSurfaceSceneNode
; Description ...: [todo]
; Syntax.........: _IrrAddWaterSurfaceSceneNode($h_Mesh, $f_WaveHeight = 2.0, $f_WaveSpeed = 300.0, $f_WaveLength = 10.0, $h_Parent = 0, $i_ID = -1, $f_PosX = 0, $f_PosY = 0, $f_PosZ = 0, $f_RotX = 0, $f_RotY = 0, $f_RotZ = 0, $f_ScaleX = 1.0, $f_ScaleY = 1.0, $f_ScaleZ = 1.0)
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
Func _IrrAddWaterSurfaceSceneNode($h_Mesh, $f_WaveHeight = 2.0, $f_WaveSpeed = 300.0, $f_WaveLength = 10.0, $h_Parent = 0, $i_ID = -1, $f_PosX = 0, $f_PosY = 0, $f_PosZ = 0, $f_RotX = 0, $f_RotY = 0, $f_RotZ = 0, $f_ScaleX = 1.0, $f_ScaleY = 1.0, $f_ScaleZ = 1.0)
	Local $aResult
	$aResult = DllCall($_irrDll, "ptr:cdecl", "IrrAddWaterSurfaceSceneNode", "ptr", $h_Mesh, "float", $f_WaveHeight, "float", $f_WaveSpeed, "float", $f_WaveLength, "ptr", $h_Parent, "int", $i_ID, "float", $f_PosX, "float", $f_PosY, "float", $f_PosZ, "float", $f_RotX, "float", $f_RotY, "float", $f_RotZ, "float", $f_ScaleX, "float", $f_ScaleY, "float", $f_ScaleZ)
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrAddWaterSurfaceSceneNode


; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddZoneManager
; Description ...: [todo]
; Syntax.........: _IrrAddZoneManager($f_NearDistance=0, $f_FarDistance=12000)
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
Func _IrrAddZoneManager($f_NearDistance = 0, $f_FarDistance = 12000)
	Local $aResult
	$aResult = DllCall($_irrDll, "UINT_PTR:cdecl", "IrrAddZoneManager", "float", $f_NearDistance, "float", $f_FarDistance)
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrAddZoneManager


; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddClouds
; Description ...: [todo]
; Syntax.........: _IrrAddClouds($h_Texture, $i_Lod, $i_Depth, $i_Density)
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
Func _IrrAddClouds($h_Texture, $i_Lod, $i_Depth, $i_Density)
	Local $aResult
	$aResult = DllCall($_irrDll, "ptr:cdecl", "IrrAddClouds", "ptr", $h_Texture, "int", $i_Lod, "int", $i_Depth, "int", $i_Density)
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrAddClouds


; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddLensFlare
; Description ...: Adds a lens flare patch object to the scene, this object simulates the effect of bright lights on the optics of a camera.
; Syntax.........: _IrrAddLensFlare($h_Texture)
; Parameters ....: $h_Texture - Handle to texture (image containing a series of 128x128 images representing stages of the the lens flare).
; Return values .: Success - Handle to a flare node
;                  Failure - False and @error 1
; Author ........:
; Modified.......:
; Remarks .......: [todo]
; Related .......: _IrrSetFlareScale, _IrrGetTexture
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrAddLensFlare($h_Texture)
	Local $aResult
	$aResult = DllCall($_irrDll, "ptr:cdecl", "IrrAddLensFlare", "ptr", $h_Texture)
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrAddLensFlare


; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddGrass
; Description ...: Adds a grass object to the scene.
; Syntax.........: _IrrAddGrass($h_Terrain, $i_X, $i_Y, $i_PatchSize, $f_FadeDistance, $i_Crossed, $f_GrassScale, $i_MaxDensity, $i_DataPosX, $i_DataPosY, $h_HeightMap, $h_TextureMap, $h_GrassMap, $h_GrassTexture)
; Parameters ....: $h_Terrain - [explanation]
;                  $i_X - X Positon of grass patch.
;                  $i_Y - Y  Positon of grass patch.
;                  $i_PatchSize - Size of grass patch
;                  $f_FadeDistance - Distance at which the number of displayed grass elements in that patch are reduced.
;                  |If this is set to 1.0 then when the cameral is inside the patch all of grass will be displayed but once outside less and less will be shown.
;                  |By increasing this to 2.0 then all of the grass is shown until the camera is two patches distant.
;                  |This gives a better appearence but reduces performance as more grass has to be drawn.
;                  $i_Crossed - IRR_ON or IRR_OFF.
;                  |When off each piece of grass is a separate entity with its own position and rotation.
;                  |When On grass is paired up and placed to form a cross. Crossed grass can have a better appearance as you rotate around it.
;                  |However individual grass can give the impression that there is more of it and you can therefore reduce the number of grass blades and increase performance.
;                  $f_GrassScale - Scale of a grass patch.
;                  $i_MaxDensity - number of individual clumps of folliage that are created.
;                  $i_DataPosX - X position of large bitmap associated with a tiled terrain and allow the color information to be taken from an offset position on the bitmap.
;                  $i_DataPosY - Y position of large bitmap associated with a tiled terrain and allow the color information to be taken from an offset position on the bitmap.
;                  $h_TextureMap - Handle to an image that contains the height of the terrain onto which the grass is placed.
;                  $h_GrassMap - Handle to an image used to adjust the height and density of the grass. For example you might have a patch where you dont want to see any grass or a barren patch where you want short stubble.
;                  $h_GrassTexture - Handle to a Texture used for the grass. This RGBA image is automatically broken up into a number of sections that are used to texure different clumps of grass.
; Return values .: Success - Handle to a Grass node.
;                  Failure - False and @error 1
; Author ........: [todo]
; Modified.......:
; Remarks .......: Grass objects are associated with terrain and tile terrain objects and are used to place small billboard objects into the scene representing folliage,
;                  this implementation of grass creates a large number of grass objects already positioned across the terrain and then dynamically shows or hides them depending on where the camera is within the scene.
;                  The grass is also affected with a wind modifier that gently moves the grass as if it were caught in the wind.
;                  By setting the speed of the wind to zero the grass will become static and you will see an increase in performance.
;                  Grass usually looks best when it is closely matched to the color of the terrain and to assist with this a new Material Type has been
;                  added IRR_EMT_TRANSPARENT_ADD_ALPHA_CHANNEL_REF that adds the color of grass texture to the color of the grass which is automatically set to the color of the terrain that it lies upon.
; Related .......: _IrrGetGrassDrawCount, _IrrSetGrassDensity, _IrrSetGrassWind
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrAddGrass($h_Terrain, $i_X, $i_Y, $i_PatchSize, $f_FadeDistance, $i_Crossed, $f_GrassScale, $i_MaxDensity, $i_DataPosX, $i_DataPosY, $h_HeightMap, $h_TextureMap, $h_GrassMap, $h_GrassTexture)
	Local $aResult
	$aResult = DllCall($_irrDll, "ptr:cdecl", "IrrAddGrass", "ptr", $h_Terrain, "int", $i_X, "int", $i_Y, "int", $i_PatchSize, _
			"float", $f_FadeDistance, "int", $i_Crossed, "float", $f_GrassScale, "int", $i_MaxDensity, "int", $i_DataPosX, "int", $i_DataPosY, _
			"ptr", $h_HeightMap, "ptr", $h_TextureMap, "ptr", $h_GrassMap, "ptr", $h_GrassTexture)
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrAddGrass


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetShadowColor
; Description ...: Sets the colour of shadows cast by objects in the scene.
; Syntax.........: _IrrSetShadowColor($i_Alpha, $i_Red, $i_Green, $i_Blue)
; Parameters ....: $i_Alpha - Alpha blend for the shadow.
;                  |Value of 128 would mean a half washed out shadow which gives the appearence of ambient light in the room illuminating the shadowed surface.
;                  $i_Red, $i_Green, $i_Blue - Colour values for shadow colour from 0 to 255.
; Return values .: Success - True
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: The shadow colour is a global property for the whole scene (however you can change it when moving into different areas of your scene).
;                  If you are observing a bright scene you might use a light grey shadow instead of a heavy black shadow to add to realism.
; Related .......: _IrrAddNodeShadow, _IrrAddLight
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrSetShadowColor($i_Alpha, $i_Red, $i_Green, $i_Blue)
	DllCall($_irrDll, "none:cdecl", "IrrSetShadowColor", "int", $i_Alpha, "int", $i_Red, "int", $i_Green, "int", $i_Blue)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetShadowColor


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetFog
; Description ...: Set the properties of fog in the scene
; Syntax.........: _IrrSetFog($i_Red, $i_Green, $i_Blue, $i_FogType, $f_FogStart, $f_FogEnd, $f_Density = 0.025)
; Parameters ....: $i_Red, $i_Green, $i_Blue - Define colour of the fog (0-255).
;                  |Should be set to the same colour as the scene sky so the scene fogs out nicely into nothing.
;                  $i_FogType - Defines how the fog is calculated:
;                  |$IRR_LINEAR_FOG - computed as [end - distance / end - start], density value is not used.
;                  |$IRR_EXPONENTIAL_FOG - computed as [1 / (2.718^(distance * densitiy))], both start and end values are not used.
;                  $f_FogStart, $f_FogEnd - Distances at which the fog starts and at which it reaches its maximum density.
;                  |Values are ignored for exponential fog.
;                  $f_Density - [optional] Determines how quickly the exponential change takes place, with value from 0 to 1.
;                  |Example: A value of 0.025 equals 20% visibility at 50 units distance. Value is ignored for linear fog.
; Return values .: success - True
;                  failure - False
; Author ........:
; Modified.......:
; Remarks .......: None.
; Related .......: None.
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrSetFog($i_Red, $i_Green, $i_Blue, $i_FogType, $f_FogStart, $f_FogEnd, $f_Density = 0.001)
	DllCall($_irrDll, "none:cdecl", "IrrSetFog", "int", $i_Red, "int", $i_Green, "int", $i_Blue, "int", $i_FogType, "float", $f_FogStart, "float", $f_FogEnd, "float", $f_Density)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetFog


; #FUNCTION# =============================================================================================================
; Name...........: _IrrDraw3DLine
; Description ...: Draws a line onto the display using 3D co-ordinates and a specified colour.
; Syntax.........: _IrrDraw3DLine($f_XStart, $f_YStart, $f_ZStart, $f_XEnd, $f_YEnd, $f_ZEnd, $i_Red, $i_Green, $i_Blue)
; Parameters ....: $f_XStart, $f_YStart, $f_ZStart - Defines start point for the 3D-line.
;                  $f_XEnd, $f_YEnd, $f_ZEnd - Defines end point for the 3D-line.
;                  $i_Red, $i_Green, $i_Blue - Colour values for the 3D-Line (0-255).
; Return values .: success - True
;                  failure - False
; Author ........:
; Modified.......:
; Remarks .......: The lines are not part of the Irrlicht scene but drawn before and separately. They need to be redrawn for every new frame.
; Related .......: _IrrBeginScene, _IrrEndScene()
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrDraw3DLine($f_XStart, $f_YStart, $f_ZStart, $f_XEnd, $f_YEnd, $f_ZEnd, $i_Red, $i_Green, $i_Blue)
	DllCall($_irrDll, "none:cdecl", "IrrDraw3DLine", "float", $f_XStart, "float", $f_YStart, "float", $f_ZStart, "float", $f_XEnd, "float", $f_YEnd, "float", $f_ZEnd, "int", $i_Red, "int", $i_Green, "int", $i_Blue)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrDraw3DLine


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetSkyDomeColor
; Description ...: Set the color of the verticies in the skydome.
; Syntax.........: _IrrSetSkyDomeColor($h_Dome, $i_HorizontalRed, $i_HorizontalGreen, $i_HorizontalBlue, $i_ZenithRed, $i_ZenithGreen, $i_ZenithBlue)
; Parameters ....: $h_Dome - [explanation]
;                  $i_HorizontalRed - Red color 0 - 255
;                  $i_HorizontalGreen - Green color 0 - 255
;                  $i_HorizontalBlue - Blue color 0 - 255
;                  $i_ZenithRed - Red color 0 - 255
;                  $i_ZenithGreen - Green color 0 - 255
;                  $i_ZenithBlue - Blue color 0 - 255
; Return values .: Success - True
;                  Failure - False
; Author ........: [todo]
; Modified.......:
; Remarks .......: Two colors are defined one for the horizon and another for the top of the sky dome, this simulates the type of coloring effects you see in the sky.
;                  If you are using a full spherical skydome the horizontal color will be the color at the bottom of the skydome.
; Related .......: _IrrSetSkyDomeColorPoint, _IrrSetSkyDomeColorBand, _IrrSAddSkyDome
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrSetSkyDomeColor($h_Dome, $i_HorizontalRed, $i_HorizontalGreen, $i_HorizontalBlue, $i_ZenithRed, $i_ZenithGreen, $i_ZenithBlue)
	DllCall($_irrDll, "none:cdecl", "IrrSetSkyDomeColor", "ptr", $h_Dome, "int", $i_HorizontalRed, "int", $i_HorizontalGreen, "int", $i_HorizontalBlue, "int", $i_ZenithRed, "int", $i_ZenithGreen, "int", $i_ZenithBlue)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetSkyDomeColor


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetSkyDomeColorBand
; Description ...: Creates a horizontal band of color in the skydome.
; Syntax.........: _IrrSetSkyDomeColorBand($h_Dome, $i_HorizontalRed, $i_HorizontalGreen, $i_HorizontalBlue, $i_BandVerticalPosition, $f_BandFade, $i_Additive)
; Parameters ....: $h_Dome - [explanation]
;                  $i_HorizontalRed - Red color 0 - 255
;                  $i_HorizontalGreen - Green color 0 - 255
;                  $i_HorizontalBlue - Blue color 0 - 255
;                  $i_BandVerticalPosition - Vertex at which you wish to create the band.
;                  $f_BandFade - Amount that the band is faded into the existing skydome color.
;                  $i_Additive - IRR_ON to add the color of the band to the existing color of the skydome or IRR_OFF to replace it.
; Return values .: Success - True
;                  Failure - False
; Author ........: [todo]
; Modified.......:
; Remarks .......: This is mainly useful for creating additional bands of color at the horizon,
;                  where your sky is a graduation of blues and then in the morning you have a brighter golden band as the sun rises.
; Related .......: _IrrSetSkyDomeColorPoint, _IrrSetSkyDomeColor, _IrrSAddSkyDome
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrSetSkyDomeColorBand($h_Dome, $i_HorizontalRed, $i_HorizontalGreen, $i_HorizontalBlue, $i_BandVerticalPosition, $f_BandFade, $i_Additive)
	DllCall($_irrDll, "none:cdecl", "IrrSetSkyDomeColorBand", "ptr", $h_Dome, "int", $i_HorizontalRed, "int", $i_HorizontalGreen, "int", $i_HorizontalBlue, "int", $i_BandVerticalPosition, "float", $f_BandFade, "int", $i_Additive)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetSkyDomeColorBand


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetSkyDomeColorPoint
; Description ...: Set the color of the verticies in the skydome radiating out from a point.
; Syntax.........: _IrrSetSkyDomeColorPoint($h_Dome, $i_Red, $i_Green, $i_Blue, $f_PosX, $f_PosY, $f_PosZ, $f_Radius, $f_PointFade, $i_Additive)
; Parameters ....: $h_Dome - Handle to a SkyDome node.
;                  $i_Red - Red color 0 - 255
;                  $i_Green - Green color 0 - 255
;                  $i_Blue - Blue color 0 - 255
;                  $f_PosX - X position.
;                  $f_PosY - Y position.
;                  $f_PosZ - Z position.
;                  $f_Radius - Limit the distance of the coloring
;                  $f_PointFade - Amount that the band is faded into the existing skydome color.
;                  $i_Additive - IRR_ON to add the color of the band to the existing color of the skydome or IRR_OFF to replace it.
; Return values .: Success - True
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: This is powerful effect that can be used to color parts of the skydome and create effects to represent the glows of the rising sun or the moon in the sky.
; Related .......: _IrrSetSkyDomeColorBand, _IrrSetSkyDomeColor, _IrrSAddSkyDome
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrSetSkyDomeColorPoint($h_Dome, $i_Red, $i_Green, $i_Blue, $f_PosX, $f_PosY, $f_PosZ, $f_Radius, $f_PointFade, $i_Additive)
	DllCall($_irrDll, "none:cdecl", "IrrSetSkyDomeColorPoint", "ptr", $h_Dome, "int", $i_Red, "int", $i_Green, "int", $i_Blue, "float", $f_PosX, "float", $f_PosY, "float", $f_Radius, "float", $f_PointFade, "int", $i_Additive)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetSkyDomeColorPoint


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetZoneManagerProperties
; Description ...: Sets the draw distances of nodes in the zone/distance management node and whether or not the zone manager is to accumulate the bounding boxes of its children as they are added.
; Syntax.........: _IrrSetZoneManagerProperties($h_ZoneManager, $f_NearDistance, $f_FarDistance, $i_AccumulateBoxes)
; Parameters ....: $h_ZoneManager - Handle to the zone node.
;                  $f_NearDistance -
;                  $f_FarDistance -
;                  $i_AccumulateBoxes -
; Return values .: Success - True
;                  Failure - False
; Author ........: [todo]
; Modified.......:
; Remarks .......: [todo]
; Related .......: [todo: functionName, functionName]
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrSetZoneManagerProperties($h_ZoneManager, $f_NearDistance, $f_FarDistance, $i_AccumulateBoxes)
	DllCall($_irrDll, "none:cdecl", "IrrSetZoneManagerProperties", "ptr", $h_ZoneManager, "float", $f_NearDistance, "float", $f_FarDistance, "int", $i_AccumulateBoxes)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetZoneManagerProperties


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetZoneManagerBoundingBox
; Description ...: Allows the user to manually set the bounding box of a zone manager node.
; Syntax.........: _IrrSetZoneManagerBoundingBox($h_ZoneManager, $f_X, $f_Y, $f_Z, $f_BoxWidth, $f_BoxHeight, $f_BoxDepth)
; Parameters ....: $h_ZoneManager - Handle to the zone node.
;                  $f_X - X position.
;                  $f_Y - Y position.
;                  $f_Z - Z position.
;                  $f_BoxWidth - Width of zone box.
;                  $f_BoxHeight - Height of zone box.
;                  $f_BoxDepth - Depth of zone box.
; Return values .: Success - True
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: None.
; Related .......: [todo: functionName, functionName]
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrSetZoneManagerBoundingBox($h_ZoneManager, $f_X, $f_Y, $f_Z, $f_BoxWidth, $f_BoxHeight, $f_BoxDepth)
	DllCall($_irrDll, "none:cdecl", "IrrSetZoneManagerBoundingBox", "ptr", $h_ZoneManager, "float", $f_X, "float", $f_Y, "float", $f_Z, "float", $f_BoxWidth, "float", $f_BoxHeight, "float", $f_BoxDepth)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetZoneManagerBoundingBox


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrSetZoneManagerAttachTerrain
; Description ...: Attach a terrain node to a the zone manager.
; Syntax.........: _IrrSetZoneManagerAttachTerrain($h_ZoneNode, $h_Terrain, $s_StructureMapFile, $s_ColorMapFile, $s_DetailMapFile, $i_ImageX, $i_ImageY, $i_SliceSize)
; Parameters ....: $h_ZoneNode - Handle to a zone node.
;                  $h_Terrain - Handle to an irr terrain object.
;                  $s_StructureMapFile - Name of an RGBA bitmap file that is to be used to set the structure of the terrain.
;                  |The Alpha channel is used to set the height and the RGB channels are used to set the color of the vertex at that position.
;                  |This can be used to load lighting into the scene or to load detail map blending into the scene for simple terrain spattering
;                  $s_ColorMapFile - Color map file to apply new color to the terrain, if not need use $IRR_NO_OBJECT
;                  $s_DetailMapFile - Detail map file to apply new detail to the terrain, if not need use $IRR_NO_OBJECT
;                  $i_ImageX - X, $i_ImageY - X and Y position of this tile on the structure and color images,
;                  |so you could load a 1024x1024 structure image and a 1024x1024 detail image in and have your zones form a grid across these large bitmaps.
;                  $i_SliceSize - Allows you to only process a slice of the terrain on each frame,
;                  |as a tile is swapped loading in bitmaps and then adjusting what could be 65,000 vertices in a single frame will cause a noticable hiccup in the smooth running of the scene,
;                  |so by setting the SliceSize you can define how many rows of the terrain are to be processed on each frame.
;                  |For example if your tile is 128x128 you might process 32 rows, the tile would then be restructured over 4 frames instead of trying to do it all in one.
; Return values .: Success - True
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: A special feature of the zone manager is its ability to manage tiled terrain nodes, a zone does this by taking position of an attached terrain object that it shares with other zone objects whenever the camera starts to come into range.
;                  The terrain object is loaded with new height information, color and detail ready for when it becomes visible to the camera.
;                  You can load your images manually to save them with IrrGetImage and IrrGetTexture and let them stay in memory to avoid having to load images while the scene is running however you should stay aware of how much memory you are using especially the graphics card memory used by IrrGetTexture.
; Related .......: [todo: functionName, functionName]
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrSetZoneManagerAttachTerrain($h_ZoneNode, $h_Terrain, $s_StructureMapFile, $s_ColorMapFile, $s_DetailMapFile, $i_ImageX, $i_ImageY, $i_SliceSize)
	DllCall($_irrDll, "none:cdecl", "IrrSetZoneManagerAttachTerrain", "UINT_PTR", $h_ZoneNode, "UINT_PTR", $h_Terrain, _
			"str", $s_StructureMapFile, "str", $s_ColorMapFile, "str", $s_DetailMapFile, "int", $i_ImageX, "int", $i_ImageY, "int", $i_SliceSize)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetZoneManagerAttachTerrain


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetGrassDensity
; Description ...: Set the grass density.
; Syntax.........: _IrrSetGrassDensity($h_Grass, $f_Density, $f_Distance)
; Parameters ....: $h_Grass - Handle to the grass node.
;                  $f_Density - Number of grass nodes visible in the scene.
;                  $f_Distance - Distance at which they can be seen.
; Return values .: Success - True
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: None.
; Related .......: _IrrAddGrass, _IrrGetGrassDrawCount, _IrrSetGrassWind
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrSetGrassDensity($h_Grass, $f_Density, $f_Distance)
	DllCall($_irrDll, "none:cdecl", "IrrSetGrassDensity", "ptr", $h_Grass, "float", $f_Density, "float", $f_Distance)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetGrassDensity


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetGrassWind
; Description ...: Set the grass wind effect.
; Syntax.........: _IrrSetGrassWind($h_Grass, $f_Strength, $f_Resolution)
; Parameters ....: $h_Grass - Handle to the grass node.
;                  $f_Strength - Strength of the wind.
;                  $f_Resolution - How often the effect is calculated.
; Return values .: Success - True
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: By setting the resoloution to zero the wind effect will be stopped and there will be a performance increase,
;                  however the wind effect adds significantly to the subtle atmosphere of the scene.
; Related .......: _IrrAddGrass, _IrrGetGrassDrawCount, _IrrSetGrassDensity
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrSetGrassWind($h_Grass, $f_Strength, $f_Resolution)
	DllCall($_irrDll, "none:cdecl", "IrrSetGrassWind", "ptr", $h_Grass, "float", $f_Strength, "float", $f_Resolution)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetGrassWind


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrGetGrassDrawCount
; Description ...: Get the number of grass objects drawn.
; Syntax.........: _IrrGetGrassDrawCount($h_Grass)
; Parameters ....: $h_Grass - Handle to the grass node.
; Return values .: Success - Number of grass objects drawn
;                  Failure - False and @error 1
; Author ........: [todo]
; Modified.......:
; Remarks .......: None
; Related .......: _IrrAddGrass, _IrrSetGrassWind, _IrrSetGrassDensity
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrGetGrassDrawCount($h_Grass)
	Local $aResult
	$aResult = DllCall($_irrDll, "int:cdecl", "IrrGetGrassDrawCount", "ptr", $h_Grass)
	If @error Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrGetGrassDrawCount


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrSetFlareScale
; Description ...: Sets the scale of optics in the scene.
; Syntax.........: _IrrSetFlareScale($h_Flare, $f_Source, $f_Optics)
; Parameters ....: $h_Flare - Handle to a flare node
;                  $f_Source - The source is the texture used to surround the light source (affects the size at the source of the flare)
;                  $f_Optics - Scale of textures in the optics of the camera.
; Return values .: Success - True
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: Sometimes it is effected to make the scale of the source considerably larger than those of the optics and to scale the effect in the optics down so that their appearence is more subtle.
; Related .......: _IrrAddLensFlare
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrSetFlareScale($h_Flare, $f_Source, $f_Optics)
	DllCall($_irrDll, "none:cdecl", "IrrSetFlareScale", "ptr", $h_Flare, "float", $f_Source, "float", $f_Optics)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetFlareScale




; #FUNCTION# =============================================================================================================
; Name...........: _IrrCreateBatchingMesh
; Description ...: Create a batching mesh that will be a collection of other meshes into a single source mesh.
; Syntax.........: _IrrCreateBatchingMesh()
; Parameters ....: None.
; Return values .: Success - Handle to a bactching mesh.
;                  Failure - False and @error 1
; Author ........: [todo]
; Modified.......:
; Remarks .......: The function of the batching mesh is to avoid the use of large numbers of nodes that adds an overhead to the rendering process that can significantly slow it down.
;                  Where you have a forest with a thousand trees you will see a significant increase in performance by batching all of those trees into a smaller number of node.
;                  While this is handled as an irr_mesh it should only be used with batching mesh commands.
; Related .......: [todo: functionName, functionName]
; Link ..........: _IrrAddToBatchingMesh, _IrrFinalizeBatchingMesh
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrCreateBatchingMesh()
	Local $aResult
	$aResult = DllCall($_irrDll, "ptr:cdecl", "IrrCreateBatchingMesh")
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrCreateBatchingMesh


; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddToBatchingMesh
; Description ...: Adds a mesh to the batching mesh at the specified position, rotation and scale.
; Syntax.........: _IrrAddToBatchingMesh($h_meshBatch, $h_mesh, $f_posX = 0.0, $f_posY = 0.0, $f_posZ = 0.0, $f_rotX = 0.0, $f_rotY = 0.0, $f_rotZ = 0.0, $f_scaleX = 1.0, $f_scaleY = 1.0, $f_scaleZ = 1.0)
; Parameters ....: $h_meshBatch - Handle to a bactching mesh as returned by _IrrCreateBatchingMesh.
;                  $h_mesh - Handle to the meash to add.
;                  $f_posX - X position
;                  $f_posY - Y position
;                  $f_posZ - Z position
;                  $f_rotX - X rotation
;                  $f_rotY - Y rotation
;                  $f_rotZ - Z rotation
;                  $f_scaleX - X scale
;                  $f_scaleY - Y scale
;                  $f_scaleZ - Z scale
; Return values .: Success - True
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: If each of your meshes requires a different texture you should call IrrSetMeshMaterialTexture for the mesh you are about to add prior to adding the mesh to the batch.
; Related .......: _IrrCreateBatchingMesh, _IrrFinalizeBatchingMesh
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrAddToBatchingMesh($h_meshBatch, $h_Mesh, $f_PosX = 0.0, $f_PosY = 0.0, $f_PosZ = 0.0, $f_RotX = 0.0, $f_RotY = 0.0, $f_RotZ = 0.0, $f_ScaleX = 1.0, $f_ScaleY = 1.0, $f_ScaleZ = 1.0)
	DllCall($_irrDll, "none:cdecl", "IrrAddToBatchingMesh", "ptr", $h_meshBatch, "ptr", $h_Mesh, _
			"float", $f_PosX, "float", $f_PosY, "float", $f_PosZ, _
			"float", $f_RotX, "float", $f_RotY, "float", $f_RotZ, _
			"float", $f_ScaleX, "float", $f_ScaleY, "float", $f_ScaleZ)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrAddToBatchingMesh


; #FUNCTION# =============================================================================================================
; Name...........: _IrrFinalizeBatchingMesh
; Description ...: Finalises the batching mesh.
; Syntax.........: _IrrFinalizeBatchingMesh($h_meshBatch)
; Parameters ....: $h_meshBatch - Handle to a bactching mesh as returned by _IrrCreateBatchingMesh.
; Return values .: Success - Handle to a new mesh
;                  Failure - False and @error 1
; Author ........:
; Modified.......:
; Remarks .......: This should be called once all of the meshes have been added to the batching mesh.
;                  The function returns a new mesh object that can be used in all standard mesh calls..
; Related .......: _IrrCreateBatchingMesh, _IrrAddToBatchingMesh
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrFinalizeBatchingMesh($h_meshBatch)
	Local $aResult
	$aResult = DllCall($_irrDll, "ptr:cdecl", "IrrFinalizeBatchingMesh", "ptr", $h_meshBatch)
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrFinalizeBatchingMesh



; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetMeshMaterialTexture
; Description ...: [todo]
; Syntax.........: _IrrSetMeshMaterialTexture($h_mesh, $h_texture, $i_index, $i_buffer = 0)
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
Func _IrrSetMeshMaterialTexture($h_Mesh, $h_Texture, $i_index, $i_buffer = 0)
	DllCall($_irrDll, "none:cdecl", "IrrSetMeshMaterialTexture", "ptr", $h_Mesh, "ptr", $h_Texture, "int", $i_index, "int", $i_buffer)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetMeshMaterialTexture



; #FUNCTION# =============================================================================================================
; Name...........: _IrrScaleMesh
; Description ...: [todo]
; Syntax.........: _IrrScaleMesh($h_mesh, $f_scale, $i_frame = 0, $i_meshBuffer = 0, $h_sourceMesh = 0)
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
Func _IrrScaleMesh($h_Mesh, $f_scale, $i_frame = 0, $i_MeshBuffer = 0, $h_sourceMesh = 0)
	DllCall($_irrDll, "none:cdecl", "IrrScaleMesh", "ptr", $h_Mesh, "float", $f_scale, "int", $i_frame, "int", $i_MeshBuffer, "ptr", $h_sourceMesh)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrScaleMesh

; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddBeamSceneNode
; Description ...: Add a beam scene node.
; Syntax.........: _IrrAddBeamSceneNode()
; Parameters ....: None.
; Return values .: Success - Handle to a beam node.
;                  Failure - False and @error 1
; Author ........:
; Modified.......:
; Remarks .......: The beam is a special scene node that can be used to replicate beam effects like lasers and tracer gun fire.
;                  This command simply adds the beam you should then make calls to set the beams properties.
; Related .......: _IrrSetBeamSize, _IrrSetBeamPosition
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrAddBeamSceneNode()
	Local $aResult
	$aResult = DllCall($_irrDll, "ptr:cdecl", "IrrAddBeamSceneNode")
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrAddBeamSceneNode



; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetBeamSize
; Description ...: Sets the width of a beam node.
; Syntax.........: _IrrSetBeamSize($h_BeamNode, $f_Size)
; Parameters ....: $h_BeamNode - Handle to a beam node.
;                  $f_Size - Width of the beam node.
; Return values .: Success - True
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: None.
; Related .......: _IrrAddBeamSceneNode, _IrrSetBeamPosition
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrSetBeamSize($h_BeamNode, $f_Size)
	DllCall($_irrDll, "none:cdecl", "IrrSetBeamSize", "ptr", $h_BeamNode, "float", $f_Size)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetBeamSize


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetBeamPosition
; Description ...: Sets the start and end positions of a beam node. The beam will stretch between the two nodes.
; Syntax.........: _IrrSetBeamPosition($h_BeamNode, $f_SX, $f_SY, $f_SZ, $f_EX, $f_EY, $f_EZ)
; Parameters ....: $h_BeamNode - Handle to a beam node.
;                  $f_SX - X start position
;                  $f_SY - Y start position
;                  $f_SZ - Z start position
;                  $f_EX - X end position
;                  $f_EY - X end position
;                  $f_EZ - X end position
; Return values .: Success - True
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: None.
; Related .......: _IrrAddBeamSceneNode, _IrrSetBeamSize
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrSetBeamPosition($h_BeamNode, $f_SX, $f_SY, $f_SZ, $f_EX, $f_EY, $f_EZ)
	DllCall($_irrDll, "none:cdecl", "IrrSetBeamPosition", "ptr", $h_BeamNode, _
			"float", $f_SX, "float", $f_SY, "float", $f_SZ, "float", $f_EX, "float", $f_EY, "float", $f_EZ)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetBeamPosition


; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddBoltSceneNode
; Description ...: The bolt is a special scene node that can be used to replicate electrical effects.
; Syntax.........: _IrrAddBoltSceneNode()
; Parameters ....: None.
; Return values .: Success - Handle to a Bolt node
;                  Failure - False and @error 1
; Author ........:
; Modified.......:
; Remarks .......: This command simply adds the bolt you should then make a call to set the bolts properties.
;                  This node can be used to simulate lightning and other electrical effects.
; Related .......: _IrrSetBoltProperties
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrAddBoltSceneNode()
	Local $aResult
	$aResult = DllCall($_irrDll, "ptr:cdecl", "IrrAddBoltSceneNode")
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrAddBoltSceneNode


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetBoltProperties
; Description ...: This sets the properties of a bolt node that simulates an electrical effect.
; Syntax.........: _IrrSetBoltProperties($h_BoltNode, $f_SX, $f_SY, $f_SZ, $f_EX, $f_EY, $f_EZ, $i_UpdateTime=50, $i_Height=10, $f_Thickness=5.0, $i_Parts=10, $i_Bolts=6, $i_Steadyend=$IRR_OFF, $i_Color=0x0000FFFF)
; Parameters ....: $h_BoltNode - [explanation]
;                  $f_SX, $f_SY, $f_SZ - Starting point that the bolt origionates from.
;                  $f_EX, $f_EY, $f_EZ - End terminating point for the bolt.
;                  $i_UpdateTime - Number of miliseconds between updates to the appearence of the bolt.
;                  $i_Height - Radius is the radius of the entire bolt effect.
;                  $f_Thickness - Thickness of a single electrical element in the bolt.
;                  $i_Parts - Number of segments the bolt is divided into.
;                  $i_Bolts - Number of individual electrical arcs that are rendered.
;                  $i_Steadyend - Set to IRR_ON ends in a tight point, Set to IRR_OFF it ends with the same width as the rest of the bolt.
;                  $i_Color - Diffuse color that is applied to the bolt.
; Return values .: Success - True
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: There are a number of properties that control many aspects of the bolt to produce a wide range of appearences.
; Related .......: _IrrAddBoltSceneNode
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrSetBoltProperties($h_BoltNode, $f_SX, $f_SY, $f_SZ, $f_EX, $f_EY, $f_EZ, $i_UpdateTime = 50, $i_Height = 10, $f_Thickness = 5.0, $i_Parts = 10, $i_Bolts = 6, $i_Steadyend = $IRR_OFF, $i_Color = 0x0000FFFF)
	DllCall($_irrDll, "none:cdecl", "IrrSetBoltProperties", "ptr", $h_BoltNode, _
			"float", $f_SX, "float", $f_SY, "float", $f_SZ, "float", $f_EX, "float", $f_EY, "float", $f_EZ, _
			"int", $i_UpdateTime, "int", $i_Height, "float", $f_Thickness, "int", $i_Parts, _
			"int", $i_Bolts, "int", $i_Steadyend, "UINT", $i_Color)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetBoltProperties




; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetBillBoardColor
; Description ...: [todo]
; Syntax.........: _IrrSetBillBoardColor($h_Node, $i_TopColor, $i_BottomColor)
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
Func _IrrSetBillBoardColor($h_Node, $i_TopColor, $i_BottomColor)
	DllCall($_irrDll, "none:cdecl", "IrrSetBillBoardColor", "ptr", $h_Node, "UINT", $i_TopColor, "UINT", $i_BottomColor)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetBillBoardColor




; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddBillBoardGroupToScene
; Description ...: Adds a billboard group to the scene.
; Syntax.........: _IrrAddBillBoardGroupToScene()
; Parameters ....: None.
; Return values .: Success - Handle to an irr node object.
;                  Failure - False and @error 1
; Author ........: smashly
; Modified.......:
; Remarks .......: This is a special object that can have billboard like objects added and removed from it and rendered in a very quick an efficient manner.
;                  They are all treated as a single object rather than as many individual nodes. This is particuallarly useful for custom particle effects.
; Related .......: _IrrAddBillBoardToGroup, _IrrRemoveBillBoardFromGroup, _IrrAddBillBoardByAxisToGroup, _IrrGetBillBoardGroupCount, IrrBillBoardGroupShadows, , _IrrBillBoardForceUpdate
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrAddBillBoardGroupToScene()
	; In the wrapper reference docs this function doesn't have any params.
	; Looking at the source of the wrapper, I can see this dll call expects 5 paramaters..
	; When you see what the function call is doing, it doesn't actually use the parameters at all.
	; I still pass the 5 params as 0 so the call will proceed without error.
	Local $aResult
	$aResult = DllCall($_irrDll, "ptr:cdecl", "IrrAddBillBoardGroupToScene", "float", 0, "float", 0, "float", 0, "float", 0, "float", 0)
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrAddBillBoardGroupToScene


; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddBillBoardToGroup
; Description ...: Adds a billboard to a billboard group. There are a number of properties that are used to specify the billboard
; Syntax.........: _IrrAddBillBoardToGroup($h_BillboardGroup, $f_XSize, $f_YSize, $f_XPos, $f_YPos, $f_ZPos, $f_Roll, $u_Alpha, $u_Red , $u_Green, $u_Blue)
; Parameters ....: $h_BillboardGroup - Handle to the Billboard Group as returned by _IrrAddBillBoardGroupToScene
;                  $f_XSize - Width of the billboard
;                  $f_YSize - Height of the billboard
;                  $f_XPos - X position of the billboard
;                  $f_YPos - Y position of the billboard
;                  $f_ZPos - Z position of the billboard
;                  $f_Roll - Specifies the number of degrees that the billboard is spun around its center
;                  $u_Alpha - Alpha color used for the billboard 0 - 255
;                  $u_Red - Red color used for the billboard 0 - 255
;                  $u_Green - Green color used for the billboard 0 - 255
;                  $u_Blue - Blue color used for the billboard 0 - 255
; Return values .: Success - Handle to the billbord scene node address in the billbord group
;                  Failure - False and @error 1
; Author ........: smashly
; Modified.......:
; Remarks .......: None
; Related .......: _IrrAddBillBoardGroupToScene, _IrrRemoveBillBoardFromGroup, _IrrGetBillBoardGroupCount, _IrrAddBillBoardByAxisToGroup, _IrrBillBoardForceUpdate
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrAddBillBoardToGroup($h_BillboardGroup, $f_XSize, $f_YSize, $f_XPos, $f_YPos, $f_ZPos, $f_Roll = 0, $u_Alpha = 255, $u_Red = 255, $u_Green = 255, $u_Blue = 255)
	Local $aResult
	$aResult = DllCall($_irrDll, "ptr:cdecl", "IrrAddBillBoardToGroup", "ptr", $h_BillboardGroup, "float", $f_XSize, "float", $f_YSize, "float", $f_XPos, "float", $f_YPos, "float", $f_ZPos, _
			"float", $f_Roll, "uint", $u_Alpha, "uint", $u_Red, "uint", $u_Green, "uint", $u_Blue)
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrAddBillBoardToGroup


; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddBillBoardByAxisToGroup
; Description ...: Adds a billboard to a billboard group that is fixed to a particular axis.
; Syntax.........: _IrrAddBillBoardByAxisToGroup($h_BillboardGroup, $f_XSize, $f_YSize, $f_XPos, $f_YPos, $f_ZPos, $f_Roll, $u_Alpha, $u_Red , $u_Green, $u_Blue, $f_XAxis, $f_YAxis, $f_ZAxis)
; Parameters ....: $h_BillboardGroup - Handle to the Billboard Group as returned by _IrrAddBillBoardGroupToScene
;                  $f_XSize - Width of the billboard
;                  $f_YSize - Height of the billboard
;                  $f_XPos - X position of the billboard
;                  $f_YPos - Y position of the billboard
;                  $f_ZPos - Z position of the billboard
;                  $f_Roll - Specifies the number of degrees that the billboard is spun around its center
;                  $u_Alpha - Alpha color used for the billboard 0 - 255
;                  $u_Red - Red color used for the billboard 0 - 255
;                  $u_Green - Green color used for the billboard 0 - 255
;                  $u_Blue - Blue color used for the billboard 0 - 255
;                  $f_XAxis - X direction around which the billboard is spun to face the camera.
;                  $f_YAxis - Y direction around which the billboard is spun to face the camera.
;                  $f_ZAxis - Z direction around which the billboard is spun to face the camera
; Return values .: Success - Handle to the billbord scene node address in the billbord group
;                  Failure - False and @error 1
; Author ........: smashly
; Modified.......:
; Remarks .......: These billboards are particularly useful for things like grass.
;                  There are a number of properties that are used to specify the billboard.
; Related .......: _IrrAddBillBoardGroupToScene, _IrrRemoveBillBoardFromGroup, _IrrGetBillBoardGroupCount, _IrrBillBoardForceUpdate
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrAddBillBoardByAxisToGroup($h_BillboardGroup, $f_XSize, $f_YSize, $f_XPos, $f_YPos, $f_ZPos, $f_Roll, $u_Alpha, $u_Red, $u_Green, $u_Blue, $f_XAxis, $f_YAxis, $f_ZAxis)
	Local $aResult
	$aResult = DllCall($_irrDll, "ptr:cdecl", "IrrAddBillBoardByAxisToGroup", "ptr", $h_BillboardGroup, _
			"float", $f_XSize, "float", $f_YSize, _
			"float", $f_XPos, "float", $f_YPos, "float", $f_ZPos, "float", $f_Roll, _
			"uint", $u_Alpha, "uint", $u_Red, "uint", $u_Green, "uint", $u_Blue, _
			"float", $f_XAxis, "float", $f_YAxis, "float", $f_ZAxis)
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrAddBillBoardByAxisToGroup




; #FUNCTION# =============================================================================================================
; Name...........: _IrrRemoveBillBoardFromGroup
; Description ...: Removes the specified billboard from the billboard group.
; Syntax.........: _IrrRemoveBillBoardFromGroup($h_BillboardGroup, $h_BillboardGroupSceneNode)
; Parameters ....: $h_BillboardGroup - Handle to the Billboard Group as returned by _IrrAddBillBoardGroupToScene
;                  $h_BillboardGroupSceneNode - Handle to the billbord scene node address in the billbord group as returned by _IrrAddBillBoardToGroup
; Return values .: Success - True
;                  Failure - False
; Author ........: smashly
; Modified.......:
; Remarks .......:
; Related .......: _IrrAddBillBoardGroupToScene, _IrrAddBillBoardToGroup
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrRemoveBillBoardFromGroup($h_BillboardGroup, $h_BillboardGroupSceneNode)
	DllCall($_irrDll, "none:cdecl", "IrrRemoveBillBoardFromGroup", "ptr", $h_BillboardGroup, "ptr", $h_BillboardGroupSceneNode)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrRemoveBillBoardFromGroup






; #FUNCTION# =============================================================================================================
; Name...........: _IrrBillBoardGroupShadows
; Description ...: Applies lighting to the billboards in a cluster of billboards.
; Syntax.........: _IrrBillBoardGroupShadows($h_BillboardGroup, $f_X, $f_Y, $f_Z, $f_Intensity, $f_Ambient)
; Parameters ....: $h_BillboardGroup - Handle to the Billboard Group as returned by _IrrAddBillBoardGroupToScene
;                  $f_X - X direction from which the light is arriving.
;                  $f_Y - Y direction from which the light is arriving.
;                  $f_Z - Z direction from which the light is arriving.
;                  $f_Intensity - Strength of the light
;                  $f_Ambient - Strength of ambient light in the billboard group
; Return values .: Success - True
;                  Failure - False
; Author ........: smashly
; Modified.......:
; Remarks .......: This can be used for example to shade the particles in a group of billboards representing a cloud.
; Related .......: _IrrAddBillBoardGroupToScene, _IrrAddBillBoardToGroup
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrBillBoardGroupShadows($h_BillboardGroup, $f_X, $f_Y, $f_Z, $f_Intensity, $f_Ambient)
	DllCall($_irrDll, "none:cdecl", "IrrBillBoardGroupShadows", "ptr", $h_BillboardGroup, "float", $f_X, "float", $f_Y, "float", $f_Z, "float", $f_Intensity, "float", $f_Ambient)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrBillBoardGroupShadows


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetBillBoardGroupCount
; Description ...: Get the number of billboards in the billboard group.
; Syntax.........: _IrrGetBillBoardGroupCount($h_BillboardGroup)
; Parameters ....: $h_BillboardGroup - Handle to the Billboard Group as returned by _IrrAddBillBoardGroupToScene
; Return values .: Success - The number of billboards in the billboard group
;                  Failure - False and @error 1
; Author ........: smashly
; Modified.......:
; Remarks .......:
; Related .......: _IrrAddBillBoardGroupToScene, _IrrAddBillBoardToGroup, _IrrRemoveBillBoardFromGroup
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrGetBillBoardGroupCount($h_BillboardGroup)
	Local $aResult
	$aResult = DllCall($_irrDll, "int:cdecl", "IrrGetBillBoardGroupCount", "ptr", $h_BillboardGroup)
	If @error Or Not IsArray($aResult) Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrGetBillBoardGroupCount


; #FUNCTION# =============================================================================================================
; Name...........: _IrrBillBoardForceUpdate
; Description ...: Force the billboard group update the scene. (see remarks for further explanation)
; Syntax.........: _IrrBillBoardForceUpdate($h_BillboardGroup)
; Parameters ....: $h_BillboardGroup - Handle to the Billboard Group as returned by _IrrAddBillBoardGroupToScene
; Return values .: Success - True
;                  Failure - False
; Author ........: smashly
; Modified.......:
; Remarks .......: Unlike regular billboards the billboard group does not always update the orientation of the billboards every frame.
;                  If you are a long distance away from the billboard group the camera needs to travel a significant distance before the
;                  angle has changed enough to warrent an update of all of the billboards verticies to make them point to the camera once more.
;                  You may want to force a refresh at some point with this call.
; Related .......: _IrrAddBillBoardGroupToScene, _IrrAddBillBoardToGroup, _IrrAddBillBoardByAxisToGroup, _IrrRemoveBillBoardFromGroup
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _IrrBillBoardForceUpdate($h_BillboardGroup)
	DllCall($_irrDll, "none:cdecl", "IrrBillBoardForceUpdate", "ptr", $h_BillboardGroup)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrBillBoardForceUpdate



; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddLODManager
; Description ...: Adds a level of detail manager to the scene.
; Syntax.........: _IrrAddLODManager($u_FadeScale, $u_UseAlpha[, $p_Callback = 0])
; Parameters ....: $u_FadeScale - Number of 1/4 seconds that the node takes to fade out or in. 4 units equals 1 second.
;                  $u_UseAlpha - Specifies whether or not the Alpha color of the object is faded too.
;                  $p_Callback - [Optional] Register a callback function that is called whenever a node is made invisible or visible.
;                  |This allows you to stop processing hidden nodes.
; Return values .: Success - Handle to the LOD Manager node
;                  Failure - False and @error 1
; Author ........: smashly
; Modified.......:
; Remarks .......: The primary use for this node is to add other scene nodes to it as children and have their level of detail controlled automatically.
;                  If those nodes are made from loaded meshs different meshes containing different amounts of detail can be displayed at different distances.
;                  The other function of the LOD manager is to fade nodes in an out at a specific distance so they gradually fade rather than disappear abruptly.
;                  This is achieved by applying a distance without supplying a mesh.
; Related .......: _IrrAddLODMesh, _IrrSetLODMaterialMap
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrAddLODManager($u_FadeScale, $u_UseAlpha, $p_Callback = 0)
	Local $aResult
	$aResult = DllCall($_irrDll, "ptr:cdecl", "IrrAddLODManager", "uint", $u_FadeScale, "uint", $u_UseAlpha, "ptr", $p_Callback)
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrAddLODManager


; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddLODMesh
; Description ...: Set the distance at which a particular mesh is to be applied to child mesh nodes.
; Syntax.........: _IrrAddLODMesh($h_LODManager, $f_Distance, $h_Mesh)
; Parameters ....: $h_LODManager - Handle to the LOD Manager node.
;                  $f_Distance - Distance at which this effect will be applied.
;                  $h_Mesh - Handle to an irr mesh object
; Return values .: Success - True
;                  Failure - False
; Author ........: smashly
; Modified.......:
; Remarks .......: If no mesh is supplied it specifies the distance at which the node should be faded in an out.
; Related .......: _IrrAddLODManager, _IrrSetLODMaterialMap
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrAddLODMesh($h_LODManager, $f_Distance, $h_Mesh)
	DllCall($_irrDll, "none:cdecl", "IrrAddLODMesh", "ptr", $h_LODManager, "float", $f_Distance, "ptr", $h_Mesh)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrAddLODMesh


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetLODMaterialMap
; Description ...: Specifies which material is used to apply the fade effect for another material type.
; Syntax.........: _IrrSetLODMaterialMap($h_LODManager, $i_SourceType, $i_TargetType)
; Parameters ....: $h_LODManager - Handle to the LOD Manager node.
;                  $u_SourceType - The irr material type your node uses
;                  $u_TargetType - The material type used for the fade effect.
; Return values .: Success - True
;                  Failure - False
; Author ........: smashly
; Modified.......:
; Remarks .......: How this is used will depend on the effect that you want to achieve.
;                  By default fading is applied with the $IRR_EMT_TRANSPARENT_VERTEX_ALPHA material.
; Related .......: _IrrAddLODManager, _IrrAddLODMesh
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrSetLODMaterialMap($h_LODManager, $i_SourceType, $i_TargetType)
	DllCall($_irrDll, "none:cdecl", "IrrSetLODMaterialMap", "uint_ptr", $h_LODManager, "uint", $i_SourceType, "uint", $i_TargetType)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetLODMaterialMap


