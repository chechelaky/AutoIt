#include-once

#include "au3Irr2_constants.au3"

; #INDEX# =======================================================================================================================
; Title .........: Camera
; AutoIt Version : v3.3.6.1
; Language ......: English
; Description ...: Calls for creating and controlling cameras in the scene. The camera objects are used for
;                  defining a view point and a target point which is used to render the scene.
; Author(s) .....: jRowe, linus.
;                  DLL functionality by Frank Dodd and IrrlichtWrapper for FreeBasic team (IrrlichtWrapper.dll),
;                  and Nikolaus Gebhardt and Irrlicht team (Irrlicht.dll).
; Dll(s) ........: IrrlichtWrapper.dll, Irrlicht.dll, msvcp71.dll, msvcr71.dll
; ===============================================================================================================================

; #NO_DOC_FUNCTION# =============================================================================================================
; Not working/documented/implemented at this time
;_IrrGetCameraUpDirection
;_IrrSetCameraUpDirection
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;_IrrAddFPSCamera
;_IrrAddCamera
;_IrrAddMayaCamera
;_IrrSetCameraTarget
;_IrrGetCameraTarget
;_IrrGetCameraOrientation
;_IrrRevolveCamera
;_IrrSetCameraUpAtRightAngle
;_IrrSetCameraOrthagonal
;_IrrSetCameraClipDistance
;_IrrSetActiveCamera
;_IrrSetCameraFOV
;_IrrSetCameraAspectRatio
;__CreatePtrKeyMapArray
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; ===============================================================================================================================

; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddFPSCamera
; Description ...: Adds a 'first person shooter' style camera with mouse and keyboard control into the scene.
; Syntax.........: _IrrAddFPSCamera($h_ParentNode = 0, $f_RotateSpeed = 100.0, $f_MoveSpeed = 0.5, $i_ID = -1, $h_KeyMapArray = 0, $i_KeyMapSize = 0, $i_NoVerticalMovement = 0, $f_JumpSpeed = 0.0)
; Parameters ....: $h_ParentNode - [optional] Parent scene node of the camera. Can be null.
;                  $f_RotateSpeed - [optional] Speed in degress with which the camera is rotated. This can be done only with the mouse.
;                  $f_MoveSpeed - [optional] Speed in units per millisecond with which the camera is moved. Movement is done with the cursor keys.
;                  $i_ID - [optional] 	id of the camera. This id can be used to identify the camera.
;                  $h_KeyMapArray - [optional] Adress of a key map as created with __CreatePtrKeyMapArray, specifying what keys should be used to move the camera. If this is null, the default keymap is used.
;                  |You can define actions more then one time in the array, to bind multiple keys to the same action.
;                  $i_KeyMapSize - [optional] Amount of items in the keymap array.
;                  $b_NoVerticalMovement - [optional] Setting this to true makes the camera only move within a horizontal plane, and disables vertical movement as known from most ego shooters.
;                  |Default is 'false', with which it is possible to fly around in space, if no gravity is there.
;                  $f_JumpSpeed - [optional] Speed with which the camera is moved when jumping.
; Return values..: Success - Handle of the camera object
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: Adds a camera scene node with an animator which provides mouse and keyboard control appropriate for first person shooters (FPS).
;                  If however you capture events when starting irrlicht this will become a normal camera that can only be moved by code.
;                  This FPS camera is intended to provide a demonstration of a camera that behaves like a typical First Person Shooter.
;                  It is useful for simple demos and prototyping but is not intended to provide a full solution for a production quality game.
;                  It binds the camera scene node rotation to the look-at target.
; Related .......: __CreatePtrKeyMapArray, _IrrAddCamera, _IrrAddMayaCamera
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrAddFPSCamera($h_ParentNode = 0, $f_RotateSpeed = 100.0, $f_MoveSpeed = 0.5, $i_ID = -1, $h_KeyMapArray = 0, $i_KeyMapSize = 0, $b_NoVerticalMovement = False, $f_JumpSpeed = 0.0)
	Local $aResult
	$aResult = DllCall($_irrDll, "UINT_PTR:cdecl", "IrrAddFPSCamera", "UINT_PTR", $h_ParentNode, "float", $f_RotateSpeed, "float", $f_MoveSpeed, "int", $i_ID, "ptr", $h_KeyMapArray, "int", $i_KeyMapSize, "byte", $b_NoVerticalMovement, "float", $f_JumpSpeed)
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrAddFPSCamera


; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddCamera
; Description ...: Adds a camera into the scene.
; Syntax.........: _IrrAddCamera($f_CamX, $f_CamY, $f_CamZ, $f_TargetX, $f_TargetY, $f_TargetZ)
; Parameters ....: $f_CamX - X value for view point of the camera.
;                  $f_CamY - Y value for view point of the camera.
;                  $f_CamZ - Z value for view point of the camera.
;                  $f_TargetX - X value for target of camera.
;                  $f_TargetY - Y value for target of camera.
;                  $f_TargetZ - Z value for target of camera.
; Return values .: Success - Handle of the camera object
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......:  The camera will be used to define the view point and target point and other attributes of the view into the 3D scene.
;                   Animators and other node functions can be applied to this node.
; Related .......: _IrrAddFPSCamera, _IrrAddMayaCamera
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrAddCamera($f_CamX, $f_CamY, $f_CamZ, $f_TargetX, $f_TargetY, $f_TargetZ)
	Local $aResult
	$aResult = DllCall($_irrDll, "ptr:cdecl", "IrrAddCamera", "float", $f_CamX, "float", $f_CamY, "float", $f_CamZ, "float", $f_TargetX, "float", $f_TargetY, "float", $f_TargetZ)
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrAddCamera


; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddMayaCamera
; Description ...: Adds a Maya style camera to into the scene.
; Syntax.........: _IrrAddMayaCamera($h_Node = $IRR_NO_OBJECT, $f_Rotate = 100.0, $f_Zoom = 100.0, $f_Move = 100.0)
; Parameters ....: $h_Node - Handle parent irr node, if no parent is needed then use $IRR_NO_OBJECT.
;                  $f_Rotate - Speed at which the camera revolves.
;                  $f_Zoom - Speed at which the camera zooms in and out.
;                  $f_Move - Speed at which the camera moves.
; Return values .: Success - Handle of the camera object
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: The user can click with the left, middle and right mouse buttons to move, zoom and rotate the camera.
; Related .......: _IrrAddCamera, _IrrAddFPSCamera
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrAddMayaCamera($h_Node = $IRR_NO_OBJECT, $f_Rotate = 100.0, $f_Zoom = 100.0, $f_Move = 100.0)
	Local $aResult
	$aResult = DllCall($_irrDll, "ptr:cdecl", "IrrAddMayaCamera", "ptr", $h_Node, "float", $f_Rotate, "float", $f_Zoom, "float", $f_Move)
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrAddMayaCamera


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetCameraTarget
; Description ...: Sets the point in space that the camera is looking at.
; Syntax.........: _IrrSetCameraTarget($h_Camera, $f_CamX, $f_CamY, $f_CamZ)
; Parameters ....: $h_Camera - Handle of a camera object
;                  $f_CamX, $f_CamY, $f_CamZ - Position in the scene to target with the camera.
; Return values .: Success - True
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: The camera view point can be moved by simply using the _IrrSetNodePosition function but this operation will change the point that the camera is pointing at.
; Related .......: _IrrGetCameraTarget, _IrrSetCameraUpAtRightAngle, _IrrSetCameraUpDirection, _IrrGetCameraOrientation, _IrrGetCameraUpDirection
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrSetCameraTarget($h_Camera, $f_CamX, $f_CamY, $f_CamZ)
	DllCall($_irrDll, "none:cdecl", "IrrSetCameraTarget", "ptr", $h_Camera, "float", $f_CamX, "float", $f_CamY, "float", $f_CamZ)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetCameraTarget


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetCameraTarget
; Description ...: Returns array with coordinates of point in space that the camera is looking at.
; Syntax.........: _IrrGetCameraTarget($h_Camera)
; Parameters ....: $h_Camera - Handle of a camera object
; Return values .: success - Array with three elements for X, Y, Z.
;                  failure - False
; Author ........:
; Modified.......:
; Remarks .......: None.
; Related .......: _IrrSetCameraTarget, _IrrSetCameraUpAtRightAngle, _IrrSetCameraUpDirection, _IrrGetCameraOrientation, _IrrGetCameraUpDirection
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrGetCameraTarget($h_Camera)
	Dim $a_Vector3df[3], $aResult
	$aResult = DllCall($_irrDll, "none:cdecl", "IrrGetCameraTarget", "ptr", $h_Camera, "float*", $a_Vector3df[0], "float*", $a_Vector3df[1], "float*", $a_Vector3df[2])
	If @error Then Return SetError(1, 0, False)
	$a_Vector3df[0] = $aResult[2]
	$a_Vector3df[1] = $aResult[3]
	$a_Vector3df[2] = $aResult[4]
	Return $a_Vector3df
EndFunc   ;==>_IrrGetCameraTarget


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrGetCameraUpDirection
; Description ...: Returns the up vector of a camera object as an array.
; Syntax.........: _IrrGetCameraUpDirection($h_Camera)
; Parameters ....: $h_Camera - Handle of a camera node.
; Return values .: Success - 0-bases array with x, y, z coordinates.
;                  Failure - False and @error 1
; Author ........: [todo]
; Modified.......:
; Remarks .......: [todo]
; Related .......: [todo: functionName, functionName]
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrGetCameraUpDirection($h_Camera)
	Dim $a_Vector3df[3], $aResult
	$aResult = DllCall($_irrDll, "none:cdecl", "IrrGetCameraUpDirection", "ptr", $h_Camera, "float*", $a_Vector3df[0], "float*", $a_Vector3df[1], "float*", $a_Vector3df[2])
	If @error Then Return SetError(1, 0, False)
	$a_Vector3df[0] = $aResult[2]
	$a_Vector3df[1] = $aResult[3]
	$a_Vector3df[2] = $aResult[4]
	Return $a_Vector3df
EndFunc   ;==>_IrrGetCameraUpDirection


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrSetCameraUpDirection
; Description ...: Set the up vector of a camera object.
; Syntax.........: _IrrSetCameraUpDirection($h_Camera, $f_CamX, $f_CamY, $f_CamZ)
; Parameters ....: $h_Camera - Handle of a camera node.
;                  $f_CamX -
;                  $f_CamY -
;                  $f_CamZ -
; Return values .: Success - True
;                  Failure - False
; Author ........: [todo]
; Modified.......:
; Remarks .......: This controls the upward direction of the camera and allows you to roll it for free flight action.
;                  This specifies a point in space at which the top of the camera points.
; Related .......: [todo: functionName, functionName]
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrSetCameraUpDirection($h_Camera, $f_CamX, $f_CamY, $f_CamZ)
	DllCall($_irrDll, "none:cdecl", "IrrSetCameraUpDirection", "UINT_PTR", $h_Camera, "float", $f_CamX, "float", $f_CamY, "float", $f_CamZ)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetCameraUpDirection


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetCameraOrientation
; Description ...: Gets the camera orientation (forward, upward and sideways vectors of the camera)
; Syntax.........: _IrrGetCameraOrientation($h_Camera, ByRef $a_Vector1, ByRef $a_Vector2, ByRef $a_Vector3)
; Parameters ....: $h_Camera - Handle of a camera object
;                  $a_Vector1, $a_Vector2, $a_Vector3 - Any variables to populate with the camera orientation vectors, must not explicitly be arrays.
;                  The passed variables will be re-dimed to arrays each with the X, Y, Z vector values stored in their three elements.
; Return values .: Success - True
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: Returned vectors will be different lengths depending on how much the camera is rotated The described camera direction is useful after the camera has been revolved.
; Related .......: _IrrGetCameraTarget, _IrrSetCameraTarget, _IrrSetCameraUpAtRightAngle, _IrrSetCameraUpDirection, _IrrGetCameraUpDirection
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrGetCameraOrientation($h_Camera, ByRef $a_Vector1, ByRef $a_Vector2, ByRef $a_Vector3)
	Local $v1, $v2, $v3
	$v1 = DllStructCreate("float;float;float")
	$v2 = DllStructCreate("float;float;float")
	$v3 = DllStructCreate("float;float;float")
	DllCall($_irrDll, "none:cdecl", "IrrGetCameraOrientation", "UINT_PTR", $h_Camera, _
			"ptr", DllStructGetPtr($v1), "ptr", DllStructGetPtr($v2), "ptr", DllStructGetPtr($v3))
	If @error Then Return SetError(1, 0, False)
	Dim $a_Vector1[3], $a_Vector2[3], $a_Vector3[3]
	For $i = 1 To 3
		$a_Vector1[$i - 1] = DllStructGetData($v1, $i)
		$a_Vector2[$i - 1] = DllStructGetData($v2, $i)
		$a_Vector3[$i - 1] = DllStructGetData($v3, $i)
	Next
	Return SetError(0, 0, True)
EndFunc   ;==>_IrrGetCameraOrientation


; #FUNCTION# =============================================================================================================
; Name...........: _IrrRevolveCamera
; Description ...: Revolve the camera using quaternion calculations.
; Syntax.........: _IrrRevolveCamera($h_Camera, $f_Yaw, $f_Pitch, $f_Roll, $f_Drive, $f_Strafe, $f_Elevate)
; Parameters ....: $h_Camera - Handle of a camera node.
;                  $f_Yaw - Affects turning left and right.
;                  $f_Pitch - Affects tilting up and down.
;                  $f_Roll - Affects rolling left and right.
;                  $f_Drive - Affects moving forwards and backward.
;                  $f_Strafe - Affects moving left and right.
;                  $f_Elevate - Affects moving up and down.
; Return values .: Success - True
;                  Failure - False
; Author ........: [todo]
; Modified.......:
; Remarks .......: This will help avoid gimbal lock associated with normal Rotations and is ideal for spacecraft and aircraft.
; Related .......: [todo: functionName, functionName]
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrRevolveCamera($h_Camera, $f_Yaw, $f_Pitch, $f_Roll, $f_Drive, $f_Strafe, $f_Elevate)
	DllCall($_irrDll, "none:cdecl", "IrrRevolveCamera", "UINT_PTR", $h_Camera, "float", $f_Yaw, "float", $f_Pitch, "float", $f_Roll, "float", $f_Drive, "float", $f_Strafe, "float", $f_Elevate)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrRevolveCamera


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetCameraUpAtRightAngle
; Description ...: Set the camera up at a right angle to the camera vector.
; Syntax.........: _IrrSetCameraUpAtRightAngle($h_Camera)
; Parameters ....: $h_Camera - Handle of a camera node.
; Return values .: Success - True
;                  Failure - False
; Author ........: [todo]
; Modified.......:
; Remarks .......: [todo]
; Related .......: [todo: functionName, functionName]
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrSetCameraUpAtRightAngle($h_Camera)
	DllCall($_irrDll, "none:cdecl", "IrrSetCameraUpAtRightAngle", "UINT_PTR", $h_Camera)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetCameraUpAtRightAngle


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetCameraOrthagonal
; Description ...: Set the projection of the camera to an orthagonal view, where there is no sense of perspective.
; Syntax.........: _IrrSetCameraOrthagonal($h_Camera, $f_DistanceX, $f_DistanceY, $f_DistanceZ)
; Parameters ....: $h_Camera - Handle of a camera node.
;                  $f_DistanceX - X Distance
;                  $f_DistanceY - Y Distance
;                  $f_DistanceZ - Z Distance
; Return values .: Success - True
;                  Failure - False
; Author ........: [todo]
; Modified.......:
; Remarks .......: The distance to the target adjusts the width and height of the camera view, essentially the smaller it is the larger the object will appear.
; Related .......: [todo: functionName, functionName]
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrSetCameraOrthagonal($h_Camera, $f_DistanceX, $f_DistanceY, $f_DistanceZ)
	DllCall($_irrDll, "none:cdecl", "IrrSetCameraOrthagonal", "UINT_PTR", $h_Camera, "float", $f_DistanceX, "float", $f_DistanceY, "float", $f_DistanceZ)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetCameraOrthagonal


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetCameraClipDistance
; Description ...: Defines far and near distances for camera clipping
; Syntax.........: _IrrSetCameraClipDistance($h_Camera, $f_Distance, $f_NearDistance = 1.0)
; Parameters ....: $h_Camera - Handle of a camera node
;                  $f_Distance - Defines the far distance for clipping
;                  $f_NearDistance - [optional] Defines the near distance for clipping (towards the camera)
; Return values .: Success - True
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: The clipping distances of a camera are the distances beyond and before which no triangles are rendered. Default clipping is before 1.0 and behind 2000.0.
;                  This speeds the scene up by not showing geometry that is beyond or before the defined distances and increases rendering performance without requiring you to manage adding and deleting the objects from the view.
;                  To make the far distance clipping less abrupt you can use it in combination with _IrrSetFog.
; Related .......: _IrrAddCamera, _IrrAddFPSCamera, _IrrSetFog
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrSetCameraClipDistance($h_Camera, $f_Distance, $f_NearDistance = 1.0)
	DllCall($_irrDll, "none:cdecl", "IrrSetCameraClipDistance", "ptr", $h_Camera, "float", $f_Distance, "float", $f_NearDistance)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetCameraClipDistance


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetActiveCamera
; Description ...: When you have several camera objects in the scene you can use this call to define which of them is to be used to look through when drawing the scene.
; Syntax.........: _IrrSetActiveCamera($h_Camera)
; Parameters ....: $h_Camera - Handle of a camera node.
; Return values .: Success - True
;                  Failure - False
; Author ........: [todo]
; Modified.......:
; Remarks .......: None.
; Related .......: [todo: functionName, functionName]
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrSetActiveCamera($h_Camera)
	DllCall($_irrDll, "none:cdecl", "IrrSetActiveCamera", "UINT_PTR", $h_Camera)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetActiveCamera


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetCameraFOV
; Description ...: Sets the field of vision of the camera.
; Syntax.........: _IrrSetCameraFOV($h_Camera, $f_FOV)
; Parameters ....: $h_Camera - Handle of a camera node.
;                  $f_FOV - The value is in radians and has a default value of PI / 2.5
; Return values .: Success - True
;                  Failure - False
; Author ........: [todo]
; Modified.......:
; Remarks .......: A wide field of vision will give a distorted perspective, if the angle is too narrow the display will feel restricted.
; Related .......: [todo: functionName, functionName]
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrSetCameraFOV($h_Camera, $f_FOV)
	DllCall($_irrDll, "none:cdecl", "IrrSetCameraFOV", "ptr", $h_Camera, "float", $f_FOV)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetCameraFOV


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetCameraAspectRatio
; Description ...: Sets the aspect ratio of the camera in the same way you think of standard screens and widescreens.
; Syntax.........: _IrrSetCameraAspectRatio($h_Camera, $f_AspectRatio)
; Parameters ....: $h_Camera - Handle of a camera node.
;                  $f_AspectRatio - Aspect ratio as a float value.
; Return values .: Success - True
;                  Failure - False
; Author ........: [todo]
; Modified.......:
; Remarks .......: A widescreen usually has an aspect ratio of 16:9 or 16/9 = 1.78. The camera apect ratio is set up automatically.
;                  However if you are using split screen effects you may need to change the camera aspect ratio.
; Related .......: [todo: functionName, functionName]
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func _IrrSetCameraAspectRatio($h_Camera, $f_AspectRatio)
	DllCall($_irrDll, "none:cdecl", "IrrSetCameraAspectRatio", "ptr", $h_Camera, "float", $f_AspectRatio)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetCameraAspectRatio


; #FUNCTION# =============================================================================================================
; Name...........: __CreatePtrKeyMapArray
; Description ...: Helper function: returns pointer to a keymap for _IrrAddFPSCamera.
; Syntax.........: __CreatePtrKeyMapArray(ByRef $keyStruct, $i_kForward = $KEY_KEY_W, $i_kBackward = $KEY_KEY_S, $i_kLeft = $KEY_KEY_A, $i_kRight = $KEY_KEY_D, $i_kJump = $KEY_SPACE)
; Parameters ....: $keyStruct - Any variable which is then returned as a a keymap for _IrrAddFPSCamera.
;                  $i_kForward - Key for forward movement, default is $KEY_KEY_W
;                  $i_kBackward - Key for backward movement, default is $KEY_KEY_S
;                  $i_kLeft - Key for left movement, default is $KEY_KEY_A
;                  $i_kRight - Key for right movement, default is $KEY_KEY_D
;                  $i_kJump - Key for jumping, default is $KEY_SPACE
; Return values .: Success - Pointer to Dllstruct containing key struct useable by _IrrAddFpsCamera.
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: $keyStruct can be set to '0' after call of _IrraddFPSCamera to delete the Dllstruct. Usage with defaults creates WASD keys, e.g.:
;                  <i>_IrrAddFPSCamera (..., __CreatePtrKeyMapArray($keyStruct), 4, ...)</i>
; Related .......: _IrraddFPSCamera
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func __CreatePtrKeyMapArray(ByRef $keyStruct, $i_kForward = $KEY_KEY_W, $i_kBackward = $KEY_KEY_S, $i_kLeft = $KEY_KEY_A, $i_kRight = $KEY_KEY_D, $i_kJump = $KEY_SPACE)
	$keyStruct = DllStructCreate("int action1;int key1;int action2;int key2;int action3;int key3;int action4;int key4;int action5;int key5")
	DllStructSetData($keyStruct, "action1", 0)
	DllStructSetData($keyStruct, "key1", $i_kForward)
	DllStructSetData($keyStruct, "action2", 1)
	DllStructSetData($keyStruct, "key2", $i_kBackward)
	DllStructSetData($keyStruct, "action3", 2)
	DllStructSetData($keyStruct, "key3", $i_kLeft)
	DllStructSetData($keyStruct, "action4", 3)
	DllStructSetData($keyStruct, "key4", $i_kRight)
	DllStructSetData($keyStruct, "action5", 4)
	DllStructSetData($keyStruct, "key5", $i_kJump)
	Return DllStructGetPtr($keyStruct)
EndFunc   ;==>__CreatePtrKeyMapArray
