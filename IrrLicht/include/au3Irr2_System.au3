#include-once

#include "au3Irr2_constants.au3"

; #INDEX# =======================================================================================================================
; Title .........: System
; AutoIt Version : v3.3.6.1
; Language ......: English
; Description ...: These calls deal with starting, running and stopping the Irrlicht engine,
;                  it also includes calls that get system metrics and some other miscellaneous tools.
; Author(s) .....: jRowe, linus.
;                  DLL functionality by Frank Dodd and IrrlichtWrapper for FreeBasic team (IrrlichtWrapper.dll),
;                  and Nikolaus Gebhardt and Irrlicht team (Irrlicht.dll).
; Dll(s) ........: IrrlichtWrapper.dll, Irrlicht.dll, msvcp71.dll, msvcr71.dll
; ===============================================================================================================================

; #NO_DOC_FUNCTION# =============================================================================================================
; Not working/documented/implemented at this time
;_IrrIsFullscreen
;_IrrIsWindowActive
;_IrrIsWindowFocused
;_IrrIsWindowMinimized
;_IrrDisableFeature
;_IrrSetTime
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;_IrrStart
;_IrrStartAdvanced
;_IrrRunning
;_IrrSetViewPort
;_IrrBeginScene
;_IrrBeginSceneAdvanced
;_IrrDrawScene
;_IrrDrawSceneToTexture
;_IrrSetRenderTarget
;_IrrDrawGUI
;_IrrEndScene
;_IrrStop
;_IrrTransparentZWrite
;_IrrGetFPS
;_IrrGetPrimitivesDrawn
;_IrrSetWindowCaption
;_IrrGetScreenSize
;_IrrMaximizeWindow
;_IrrMinimizeWindow
;_IrrRestoreWindow
;_IrrSetResizableWindow
;_IrrMakeARGB
;_IrrQueryFeature
;_IrrGetTime
;__CreateVertStruct
;__GetVertStruct
;__SetVertStruct
;__CreateVectStruct
;__GetVectStruct
;__SetVectStruct
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; ===============================================================================================================================

; #FUNCTION# =============================================================================================================
; Name...........: _IrrStart
; Description ...: Opens the IrrlichtWrapper.dll, starts Irrlicht interface and opens a window for rendering.
; Syntax.........: _IrrStart($i_DeviceType=$IRR_EDT_DIRECT3D9, $i_ScreenWidth=800, $i_ScreenHeight=600, $i_BitsPerPixel=$IRR_BITS_PER_PIXEL_32, $b_FullScreen=$IRR_WINDOWED, $b_Shadows=$IRR_NO_SHADOWS, $b_InputCapture=$IRR_IGNORE_EVENTS, $b_VSync=$IRR_VERTICAL_SYNC_OFF)
; Parameters ....: $i_DeviceType - [optional] specifies the renderer to use when drawing to the display this may be one of the following types:
;                  |$IRR_EDT_NULL - A NULL device with no display
;                  |$IRR_EDT_SOFTWARE - Irrlichts default software renderer
;                  |$IRR_EDT_SOFTWARE2 - An improved quality software renderer
;                  |$IRR_EDT_OPENGL - Hardware accelerated OpenGL renderer
;                  |$IRR_EDT_DIRECT3D8 - Hardware accelerated DirectX 8 renderer
;                  |$IRR_EDT_DIRECT3D9 - Hardware accelerated DirectX 9 renderer
;                  $i_ScreenWidth - [optional] Screen width specifies the width of the viewport in pixels
;                  $i_ScreenHeight - [optional] Screen height specifies the height of the viewport in pixels
;                  $i_BitsPerPixel - [optional] The number of color bits that is used for each pixel 32 bit color gives 24 million different colors whereas 16 bit color gives only 32,000 colors. However the advantage of 16 bit color is that some operations use half the memory and can run at up to twice the speed.
;                  +This setting can be either of:
;                  |$IRR_BITS_PER_PIXEL_16
;                  |$IRR_BITS_PER_PIXEL_32
;                  $b_FullScreen - [optional] Specifies whether the display is to opened in full screen mode or in a window:
;                  |$IRR_WINDOWED - For window mode
;                  |$IRR_FULLSCREEN - For fullscreen mode. When using full screen mode you will need to adjust the window size to the same dimensions as a supported screen resolution on the target display 640x400 for example.
;                  $b_Shadows - [optional] Use shadows starts the engine in a mode that supports the rendering of stencil shadows.
;                  |$IRR_NO_SHADOWS - For a display that does not support shadows.
;                  |$IRR_SHADOWS - For a display that supports shadows.
;                  $b_InputCapture - [optional] Capture mouse and keyboard specified whether you want to capture keyboard and mouse events, if you choose to ignore them they will be handled by Irrlicht for FPS camera control. This parameter should be either of:
;                  |$IRR_IGNORE_EVENTS
;                  |$IRR_CAPTURE_EVENTS
;                  $b_VSync - [optional] Vertical syncronisation specifies whether the display of each new frame is syncronised with vertical refresh of the graphics card. This produces a smoother display and avoids 'tearing' where the viewer can see parts of two different frames at the same time. The setting can be either of:
;                  |$IRR_VERTICAL_SYNC_OFF
;                  |$IRR_VERTICAL_SYNC_ON
; Return values .: Success		- True
;                  Failure		- False and sets @error:
;                  |1 - error occured on dll call
;                  |2 - IrrlichtWrapper.dll not found
; Author ........:
; Modified.......:
; Remarks .......: if .dll cannot be opened, path environment is extended with:
;                  - <b>.\bin</b> (allows an au3Irr2 script to have its binaries in a subdir) and
;                  - <b>.\..</b>  (allows au3Irr2 examples to be started from their \include subdir).
;                  Nevertheless, ensuring DLL's in a permanent dir reachable via path may be the better way, as the temporary update of environment can be time-consuming.
;+
;                  <b>Other needed .dll's</b> (Irrlicht.dll + maybe msvcp71.dll, msvcr71.dll) <b>are NOT checked</b> but simply expected to be at last in same dir as the IrrlichtWrapper.dll.
; Related .......: _IrrStartAdvanced, _IrrRunning, _IrrStop
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrStart($i_DeviceType = $IRR_EDT_DIRECT3D9, $i_ScreenWidth = 800, $i_ScreenHeight = 600, $i_BitsPerPixel=$IRR_BITS_PER_PIXEL_32, $b_FullScreen=$IRR_WINDOWED, $b_Shadows=$IRR_NO_SHADOWS, $b_InputCapture=$IRR_IGNORE_EVENTS, $b_VSync=$IRR_VERTICAL_SYNC_OFF)

	$_irrDll = DllOpen("IrrlichtWrapper.dll")
	if $_irrDll = -1 Then ; .dll cannot be opened - try to get it by extending %path%:
		EnvSet("PATH", @ScriptDir & "\bin;" & @ScriptDir & "\..\bin;" & EnvGet("PATH"))
		EnvUpdate()

		$_irrDll = DllOpen("IrrlichtWrapper.dll")
		if $_irrDll = -1 Then ; no chance, so return error:
			Return Seterror(2,0,False)
		EndIf
	EndIf

	DllCall($_irrDll, "none:cdecl", "IrrStart", "int", $i_DeviceType, "int", $i_ScreenWidth, "int", $i_ScreenHeight, "int", $i_BitsPerPixel, "uint", $b_FullScreen, "int", $b_Shadows, "int", $b_InputCapture, "int", $b_VSync)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrStart



; #FUNCTION# =============================================================================================================
; Name...........: _IrrStartAdvanced
; Description ...: Opens the IrrlichtWrapper.dll and starts Irrlicht engine with advanced method.
; Syntax.........: _IrrStartAdvanced($i_DeviceType=$IRR_EDT_DIRECT3D9, $i_ScreenWidth=800, $i_ScreenHeight=600, $i_BitsPerPixel=$IRR_BITS_PER_PIXEL_32, $b_FullScreen=$IRR_WINDOWED, $b_Shadows=$IRR_NO_SHADOWS, $b_InputCapture=$IRR_IGNORE_EVENTS, $b_VSync=$IRR_VERTICAL_SYNC_OFF, $i_TypeOfDevice=0, $b_DoublebufferEnabled=$IRR_OFF, $i_AntialiasEnabled=0, $b_HighPrecisionFpu=$IRR_OFF)
; Parameters ....: $i_DeviceType - [optional] specifies the renderer to use when drawing to the display this may be one of the following types:
;                  |$IRR_EDT_NULL - A NULL device with no display
;                  |$IRR_EDT_SOFTWARE - Irrlichts default software renderer
;                  |$IRR_EDT_SOFTWARE2 - An improved quality software renderer
;                  |$IRR_EDT_OPENGL - Hardware accelerated OpenGL renderer
;                  |$IRR_EDT_DIRECT3D8 - Hardware accelerated DirectX 8 renderer
;                  |$IRR_EDT_DIRECT3D9 - Hardware accelerated DirectX 9 renderer
;                  $i_ScreenWidth - [optional] Screen width specifies the width of the viewport in pixels
;                  $i_ScreenHeight - [optional] Screen height specifies the height of the viewport in pixels
;                  $i_BitsPerPixel - [optional] The number of color bits that is used for each pixel 32 bit color gives 24 million different colors whereas 16 bit color gives only 32,000 colors. However the advantage of 16 bit color is that some operations use half the memory and can run at up to twice the speed.
;                  +This setting can be either of:
;                  |$IRR_BITS_PER_PIXEL_16
;                  |$IRR_BITS_PER_PIXEL_32
;                  $b_FullScreen - [optional] Specifies whether the display is to opened in full screen mode or in a window:
;                  |$IRR_WINDOWED - For window mode
;                  |$IRR_FULLSCREEN - For fullscreen mode. When using full screen mode you will need to adjust the window size to the same dimensions as a supported screen resolution on the target display 640x400 for example.
;                  $b_Shadows - [optional] Use shadows starts the engine in a mode that supports the rendering of stencil shadows.
;                  |$IRR_NO_SHADOWS - For a display that does not support shadows.
;                  |$IRR_SHADOWS - For a display that supports shadows.
;                  $b_InputCapture - [optional] Capture mouse and keyboard specified whether you want to capture keyboard and mouse events, if you choose to ignore them they will be handled by Irrlicht for FPS camera control. This parameter should be either of:
;                  |$IRR_IGNORE_EVENTS
;                  |$IRR_CAPTURE_EVENTS
;                  $b_VSync - [optional] Vertical syncronisation specifies whether the display of each new frame is syncronised with vertical refresh of the graphics card. This produces a smoother display and avoids 'tearing' where the viewer can see parts of two different frames at the same time. The setting can be either of:
;                  |$IRR_VERTICAL_SYNC_OFF
;                  |$IRR_VERTICAL_SYNC_ON
;                  $i_TypeOfDevice - [optional] Devicetype allows a specific type of device for example a windows screen or a console to be selected. For the time being this should be set to 0 which automatically selects the best device.
;                  $b_DoublebufferEnabled - [optional] Doublebufferenabled is used to control whether double buffering is used. When double buffering is used two drawing surfaces are created one for display and the other that is used for drawing too. Double buffering is required for anit-aliasing the options are:
;                  |$IRR_ON or $IRR_OFF
;                  $i_AntialiasEnabled - [optional] Antialiasenabled is used to enable the antialiasing effect, this effect produces a blurring at the edges of object giving their lines a smooth natural appearence. There is usually a big penalty for using this effect though sometimes as high as 30%  of the frame rate or more. This is a value for the anti-aliasing and should be a power of 2.
;                  |(e.g: 2, 4, 8, 16)
;                  $b_HighPrecisionFpu - [optional] Highprecisionfpu is used to enable high precision Floating point calculations, that produce more accurate result at the expense of a slower operating speed.
; Return values .: Success		- True
;                  Failure		- False and sets @error:
;                  |1 - error occured on dll call
;                  |2 - IrrlichtWrapper.dll not found
; Author ........:
; Modified.......:
; Remarks .......: if .dll cannot be opened, path environment is extended with:
;                  - <b>.\bin</b> (allows an au3Irr2 script to have its binaries in a subdir) and
;                  - <b>.\..</b>  (allows au3Irr2 examples to be started from their \include subdir).
;                  Nevertheless, ensuring DLL's in a permanent dir reachable via path may be the better way, as the temporary update of environment can be time-consuming.
;+
;                  <b>Other needed .dll's</b> (Irrlicht.dll + maybe msvcp71.dll, msvcr71.dll) <b>are NOT checked</b> but simply expected to be at last in same dir as the IrrlichtWrapper.dll.
; Related .......: _IrrStart, _IrrRunning, _IrrStop
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrStartAdvanced($i_DeviceType=$IRR_EDT_DIRECT3D9, $i_ScreenWidth=800, $i_ScreenHeight=600, $i_BitsPerPixel=$IRR_BITS_PER_PIXEL_32, $b_FullScreen=$IRR_WINDOWED, $b_Shadows=$IRR_NO_SHADOWS, $b_InputCapture=$IRR_IGNORE_EVENTS, $b_VSync=$IRR_VERTICAL_SYNC_OFF, $i_TypeOfDevice=0, $b_DoublebufferEnabled=$IRR_OFF, $i_AntialiasEnabled=0, $b_HighPrecisionFpu=$IRR_OFF)

	$_irrDll = DllOpen("IrrlichtWrapper.dll")
	if $_irrDll = -1 Then ; .dll cannot be opened - try to get it by extending %path%:
		EnvSet("PATH", @ScriptDir & "\bin;" & @ScriptDir & "\..\bin;" & EnvGet("PATH"))
		EnvUpdate()

		$_irrDll = DllOpen("IrrlichtWrapper.dll")
		if $_irrDll = -1 Then ; no chance, so return error:
			Return Seterror(2,0,False)
		EndIf
	EndIf

	$result = DllCall($_irrDll, "uint:cdecl", "IrrStart", "int", $i_DeviceType, "int", $i_ScreenWidth, "int", $i_ScreenHeight, _
			"int", $i_BitsPerPixel, "uint", $b_FullScreen, "uint", $b_Shadows, "uint", $b_InputCapture, "uint", $b_VSync, _
			"uint", $i_TypeOfDevice, "uint", $b_DoublebufferEnabled, "uint", $i_AntialiasEnabled, "uint", $b_HighPrecisionFpu)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return $result[0]
	EndIf
EndFunc   ;==>_IrrStartAdvanced



; #FUNCTION# =============================================================================================================
; Name...........: _IrrRunning
; Description ...: Used to determine if the Irrlicht engine is still running.
; Syntax.........: _IrrRunning()
; Parameters ....: None
; Return values .: True if running - False if not.
;                  |Sets @error to true on failures.
; Author ........:
; Modified.......:
; Remarks .......: None
; Related .......: _IrrStart, _IrrStartAdvanced, _IrrStop
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrRunning()
	$result = DllCall($_irrDll, "int:cdecl", "IrrRunning")
	if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrRunning


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetViewPort
; Description ...: [todo]
; Syntax.........: _IrrSetViewPort($i_TopX, $i_TopY, $i_BottomX, $i_BottomY)
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
Func _IrrSetViewPort($i_TopX, $i_TopY, $i_BottomX, $i_BottomY)
	DllCall($_irrDll, "none:cdecl", "IrrSetViewPort", "int", $i_TopX, "int", $i_TopY, "int", $i_BottomX, "int", $i_BottomY)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrSetViewPort


; #FUNCTION# =============================================================================================================
; Name...........: _IrrBeginScene
; Description ...: Starts to draw a frame, erasing the canvas with the specified color.
; Syntax.........: _IrrBeginScene($i_Red, $i_Green, $i_Blue)
; Parameters ....: $i_Red -  Red value from 0 to 255 (full intensity)
;                  $i_Green - Green value from 0 to 255 (full intensity)
;                  $i_Blue - Blue value from 0 to 255 (full intensity)
; Return values .: Success - True
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: None
; Related .......: _IrrBeginSceneAdvanced, _IrrDrawScene, _IrrDrawGUI, _IrrEndScene
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrBeginScene($i_Red, $i_Green, $i_Blue)
; initialise the frame drawing cycle, erasing the canvas ready for drawing
	DllCall($_irrDll, "none:cdecl", "IrrBeginScene", "int", $i_Red, "int", $i_Green, "int", $i_Blue)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrBeginScene



; #FUNCTION# =============================================================================================================
; Name...........: _IrrBeginSceneAdvanced
; Description ...: [todo]
; Syntax.........: _IrrBeginSceneAdvanced($i_SceneBGColor, $b_ClearBackBuffer = $IRR_ON, $b_ClearZBuffer = $IRR_ON)
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
Func _IrrBeginSceneAdvanced($i_SceneBGColor, $b_ClearBackBuffer = $IRR_ON, $b_ClearZBuffer = $IRR_ON)
	DllCall($_irrDll, "none:cdecl", "IrrBeginSceneAdvanced", "UINT", $i_SceneBGColor, "byte", $b_ClearBackBuffer, "byte", $b_ClearZBuffer)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrBeginSceneAdvanced



; #FUNCTION# =============================================================================================================
; Name...........: _IrrDrawScene
; Description ...: This renders the 3D scene to the canvas, drawing all 3D elements: nodes, particles, billboards, etc .
; Syntax.........: _IrrDrawScene()
; Parameters ....: None
; Return values .: Success - True
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: None
; Related .......: _IrrBeginScene, _IrrBeginSceneAdvanced, _IrrDrawGUI, _IrrEndScene
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrDrawScene()
	DllCall($_irrDll, "none:cdecl", "IrrDrawScene")
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrDrawScene


; #FUNCTION# =============================================================================================================
; Name...........: _IrrDrawSceneToTexture
; Description ...: [todo]
; Syntax.........: _IrrDrawSceneToTexture($h_RenderTargetTexture)
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
Func _IrrDrawSceneToTexture($h_RenderTargetTexture)
;use IrrCreateRenderTargetTexture to get $h_RenderTargetTexture
	$result = DllCall($_irrDll, "ptr:cdecl", "IrrDrawSceneToTexture", "ptr", $h_RenderTargetTexture)
	if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrDrawSceneToTexture



; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetRenderTarget
; Description ...: [todo]
; Syntax.........: _IrrSetRenderTarget($h_Texture, $i_SceneBGColor = 0, $b_ClearBackBuffer = $IRR_ON, $b_ClearZBuffer = $IRR_ON)
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
Func _IrrSetRenderTarget($h_Texture, $i_SceneBGColor = 0, $b_ClearBackBuffer = $IRR_ON, $b_ClearZBuffer = $IRR_ON)
; Sets a texture as a render target, or sets the device if the pointer is 0.
	DllCall($_irrDll, "none:cdecl", "IrrSetRenderTarget", "ptr", $h_Texture, "uint", $i_SceneBGColor, _
			"byte", $b_ClearBackBuffer, "byte", $b_ClearZBuffer)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrSetRenderTarget



; #FUNCTION# =============================================================================================================
; Name...........: _IrrDrawGUI
; Description ...: This renders the 2D graphical user interface that has been created to the scene.
; Syntax.........: _IrrDrawGUI()
; Parameters ....: None
; Return values .: Success - True
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: None
; Related .......: _IrrBeginScene, _IrrBeginSceneAdvanced, _IrrDrawScene, _IrrEndScene
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrDrawGUI()
	DllCall($_irrDll, "none:cdecl", "IrrDrawGUI")
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrDrawGUI


; #FUNCTION# =============================================================================================================
; Name...........: _IrrEndScene
; Description ...: This renders the 3D scene to the canvas, drawing all 3D elements: nodes, particles, billboards, etc .
; Syntax.........: _IrrEndScene()
; Parameters ....: None
; Return values .: Success - True
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: None
; Related .......: _IrrBeginScene, _IrrBeginSceneAdvanced, _IrrDrawScene, _IrrDrawGUI
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrEndScene()
	DllCall($_irrDll, "none:cdecl", "IrrEndScene")
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrEndScene


; #FUNCTION# =============================================================================================================
; Name...........: _IrrStop
; Description ...: Stops the Irrlicht Engine freeing all of the resources, closing the display window and IrrlichtWrapper.dll.
; Syntax.........: _IrrStop()
; Parameters ....: None
; Return values .: Success - True
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: None.
; Related .......: _IrrStart, _IrrStartAdvanced, _IrrRunning
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrStop()

	DllCall($_irrDll, "none:cdecl", "IrrStop")
	if @error Then
		Return Seterror(1,0,False)
	Else
		DllClose($_irrDll)
		Return true
	EndIf
EndFunc   ;==>_IrrStop


; #FUNCTION# =============================================================================================================
; Name...........: _IrrTransparentZWrite
; Description ...: [todo]
; Syntax.........: _IrrTransparentZWrite()
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
Func _IrrTransparentZWrite()
	DllCall($_irrDll, "none:cdecl", "IrrTransparentZWrite")
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrTransparentZWrite


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetFPS
; Description ...: [todo]
; Syntax.........: _IrrGetFPS()
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
Func _IrrGetFPS()
	$result = DllCall($_irrDll, "int:cdecl", "IrrGetFPS")
		if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrGetFPS


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetPrimitivesDrawn
; Description ...: [todo]
; Syntax.........: _IrrGetPrimitivesDrawn()
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
Func _IrrGetPrimitivesDrawn()
	$result = DllCall($_irrDll, "int:cdecl", "IrrGetPrimitivesDrawn")
		if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrGetPrimitivesDrawn


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetWindowCaption
; Description ...: Set the caption in the Irrlicht window title bar.
; Syntax.........: _IrrSetWindowCaption($s_Caption)
; Parameters ....: $s_Caption - String for the title bar.
; Return values .: Success - True
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: None.
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrSetWindowCaption($s_Caption)
	DllCall($_irrDll, "none:cdecl", "IrrSetWindowCaption", "wstr", $s_Caption)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrSetWindowCaption



; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrIsFullscreen
; Description ...: [todo]
; Syntax.........: _IrrIsFullscreen()
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
Func _IrrIsFullscreen()
; Checks if the Irrlicht window is running in fullscreen mode.
	$result = DllCall($_irrDll, "int:cdecl", "IrrIsFullscreen")
		if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrIsFullscreen


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrIsWindowActive
; Description ...: [todo]
; Syntax.........: _IrrIsWindowActive()
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
Func _IrrIsWindowActive()
; Returns if the window is active.
	$result = DllCall($_irrDll, "int:cdecl", "IrrIsWindowActive")
		if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrIsWindowActive


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrIsWindowFocused
; Description ...: [todo]
; Syntax.........: _IrrIsWindowFocused()
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
Func _IrrIsWindowFocused()
; Checks if the Irrlicht window has focus.
	$result = DllCall($_irrDll, "int:cdecl", "IrrIsWindowFocused")
		if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrIsWindowFocused


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrIsWindowMinimized
; Description ...: [todo]
; Syntax.........: _IrrIsWindowMinimized()
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
Func _IrrIsWindowMinimized()
; Checks if the Irrlicht window is minimized.
	$result = DllCall($_irrDll, "int:cdecl", "IrrIsWindowMinimized")
		if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrIsWindowMinimized


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetScreenSize
; Description ...: [todo]
; Syntax.........: _IrrGetScreenSize(ByRef $i_Width, ByRef $i_Height)
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
Func _IrrGetScreenSize(ByRef $i_Width, ByRef $i_Height)
; Gets the screen size.
	$result = DllCall($_irrDll, "none:cdecl", "IrrGetScreenSize", "int*", $i_Width, "int*", $i_Height)
		if @error Then
		Return Seterror(1,0,False)
	Else
		$i_Width = $result[1]
		$i_Height = $result[2]
		Return true
	EndIf
EndFunc   ;==>_IrrGetScreenSize


; #FUNCTION# =============================================================================================================
; Name...........: _IrrMaximizeWindow
; Description ...: [todo]
; Syntax.........: _IrrMaximizeWindow()
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
Func _IrrMaximizeWindow()
; Maximizes the window if possible.
	$result = DllCall($_irrDll, "none:cdecl", "IrrMaximizeWindow")
		if @error Then
		Return Seterror(1,0,False)
	Else
		Return true
	EndIf
EndFunc   ;==>_IrrMaximizeWindow


; #FUNCTION# =============================================================================================================
; Name...........: _IrrMinimizeWindow
; Description ...: [todo]
; Syntax.........: _IrrMinimizeWindow()
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
Func _IrrMinimizeWindow()
; Minimizes the window if possible.
	$result = DllCall($_irrDll, "none:cdecl", "IrrMinimizeWindow")
		if @error Then
		Return Seterror(1,0,False)
	Else
		Return true
	EndIf
EndFunc   ;==>_IrrMinimizeWindow


; #FUNCTION# =============================================================================================================
; Name...........: _IrrRestoreWindow
; Description ...: [todo]
; Syntax.........: _IrrRestoreWindow()
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
Func _IrrRestoreWindow()
; Restore the window to normal size if possible.
	$result = DllCall($_irrDll, "none:cdecl", "IrrRestoreWindow")
		if @error Then
		Return Seterror(1,0,False)
	Else
		Return true
	EndIf
EndFunc   ;==>_IrrRestoreWindow


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetResizableWindow
; Description ...: [todo]
; Syntax.........: _IrrSetResizableWindow($i_Resizable)
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
Func _IrrSetResizableWindow($i_Resizable)
; Make the window resizable.
	$result = DllCall($_irrDll, "none:cdecl", "IrrSetResizableWindow")
		if @error Then
		Return Seterror(1,0,False)
	Else
		Return true
	EndIf
EndFunc   ;==>_IrrSetResizableWindow



; #FUNCTION# =============================================================================================================
; Name...........: _IrrMakeARGB
; Description ...: Computes valid 32bit color value including alpha (translucency) as expected from several functions.
; Syntax.........: _IrrMakeARGB($i_Alpha, $i_Red, $i_Green, $i_Blue)
; Parameters ....: $i_Alpha - Alpha component of the colour.
;                  $i_Red, $i_Green, $i_Blue - Red, green and blue components (0-255).
; Return values .: success - 32bit unsigned int colour value including alpha.
; Author ........:
; Modified.......:
; Remarks .......: None.
; Related .......: None.
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrMakeARGB($i_Alpha, $i_Red, $i_Green, $i_Blue)
	return int( ( "0x" & Hex($i_Alpha, 2) & Hex($i_Red, 2) & Hex($i_Green, 2) & Hex($i_Blue, 2) ) )
EndFunc   ;==>_IrrMakeARGB


; #FUNCTION# =============================================================================================================
; Name...........: _IrrQueryFeature
; Description ...: [todo]
; Syntax.........: _IrrQueryFeature($i_Feature)
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
Func _IrrQueryFeature($i_Feature)
	$result = DllCall($_irrDll, "int:cdecl", "IrrQueryFeature", "int", $i_Feature)
		if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrQueryFeature


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrDisableFeature
; Description ...: [todo]
; Syntax.........: _IrrDisableFeature($i_Feature, $i_Flag)
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
Func _IrrDisableFeature($i_Feature, $i_Flag)
	DllCall($_irrDll, "int:cdecl", "IrrDisableFeature", "int", $i_Feature, "int", $i_Flag)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrDisableFeature


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetTime
; Description ...: [todo]
; Syntax.........: _IrrGetTime()
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
Func _IrrGetTime()
	$result = DllCall($_irrDll, "int:cdecl", "IrrGetTime")
	Return $result[0]
EndFunc   ;==>_IrrGetTime


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrSetTime
; Description ...: [todo]
; Syntax.........: _IrrSetTime($i_Time)
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
Func _IrrSetTime($i_Time)
	DllCall($_irrDll, "none:cdecl", "IrrSetTime", "int", $i_Time)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrSetTime



; #FUNCTION# =============================================================================================================
; Name...........: __CreateVertStruct
; Description ...: Helper function: creates a structure array of vertices as expected from some functions.
; Syntax.........: __CreateVertStruct($iVert)
; Parameters ....: $iVert - Number of vertex elements the struct array shall contain.
; Return values .: Success - The created vertex array struct
; Author ........:
; Modified.......:
; Remarks .......: None
; Related .......: __GetVertStruct, __SetVertStruct, __CreateVectStruct
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func __CreateVertStruct($iVert)
    Local $iSize = DllStructGetSize(DllStructCreate($tagIRR_VERTEX))
    Return DllStructCreate("byte[" & $iSize * $iVert & "]")
EndFunc ;==>__CreateVertStruct



; #FUNCTION# =============================================================================================================
; Name...........: __GetVertStruct
; Description ...: Helper function: Returns a specific value from a structure array of vertices.
; Syntax.........: __GetVertStruct(ByRef $tVertex, $iVertex, $vMember)
; Parameters ....: $tVertex - Structure array of vertices as created with __CreateVertStruct
;                  $iVertex - Vertex element from which value shall be returned (0-based!)
;                  $vMember - One of following values to return:
;                  |$VERT_X
;                  |$VERT_Y
;                  |$VERT_Z
;                  |$VERT_NORMALX
;                  |$VERT_NORMALY
;                  |$VERT_NORMALZ
;                  |$VERT_VCOLOR
;                  |$VERT_TEXTUREX
;                  |$VERT_TEXTUREY
; Return values .: Success - Requested $vMember
; Author ........:
; Modified.......:
; Remarks .......: None
; Related .......: __CreateVertStruct, __SetVertStruct, __CreateVectStruct
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func __GetVertStruct(ByRef $tVertex, $iVertex, $vMember)
    Local $iSize = DllStructGetSize(DllStructCreate($tagIRR_VERTEX))
	Return DllStructGetData(DllStructCreate($tagIRR_VERTEX, DllStructGetPtr($tVertex) + $iSize*$iVertex), $vMember)
EndFunc ;==>__GetVertStruct


; #FUNCTION# =============================================================================================================
; Name...........: __SetVertStruct
; Description ...: Helper function: Sets a value into a structure array of vertices.
; Syntax.........: __SetVertStruct(ByRef $tVertex, $iVertex, $vMember, $vData)
; Parameters ....: $tVertex - Structure array of vertices as created with __CreateVertStruct
;                  $iVertex - Vertex element where specific value shall be set (0-based!)
;                  $vMember - One of following values to set:
;                  |$VERT_X
;                  |$VERT_Y
;                  |$VERT_Z
;                  |$VERT_NORMALX
;                  |$VERT_NORMALY
;                  |$VERT_NORMALZ
;                  |$VERT_VCOLOR
;                  |$VERT_TEXTUREX
;                  |$VERT_TEXTUREY
; Return values .: None
; Author ........:
; Modified.......:
; Remarks .......: None
; Related .......: __CreateVertStruct, __GetVertStruct, __CreateVectStruct
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func __SetVertStruct(ByRef $tVertex, $iVertex, $vMember, $vData)
    Local $iSize = DllStructGetSize(DllStructCreate($tagIRR_VERTEX))
    DllStructSetData(DllStructCreate($tagIRR_VERTEX, DllStructGetPtr($tVertex) + $iSize*$iVertex), $vMember, $vData)

EndFunc ;==>__SetVertStruct



; #FUNCTION# =============================================================================================================
; Name...........: __CreateVectStruct
; Description ...: Helper function: creates a structure array of vectors as expected from some functions.
; Syntax.........: __CreateVectStruct($iVect)
; Parameters ....: $iVect - Number of vector elements the created struct array shall contain.
; Return values .: Success - The created vector struct.
; Author ........:
; Modified.......:
; Remarks .......: None
; Related .......: __SetVectStruct, __GetVectStruct, __CreateVertStruct
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func __CreateVectStruct($iVect)
    Local $iSize = DllStructGetSize(DllStructCreate($tagIRR_VECTOR))
    Return DllStructCreate("byte[" & $iSize * $iVect & "]")
EndFunc ;==>__CreateVectStruct



; #FUNCTION# =============================================================================================================
; Name...........: __GetVectStruct
; Description ...: Helper function: Returns a specific value from a structure array of vectors.
; Syntax.........: __GetVectStruct(ByRef $tVector, $iVector, $vMember)
; Parameters ....: $tVector - Structure array of vectors as created with __CreateVectStruct
;                  $iVector - Vector element from which value shall be returned (0-based!)
;                  $vMember - One of following values to return:
;                  |$VECT_X
;                  |$VECT_Y
;                  |$VECT_Z
; Return values .: Success - Requested $vMember
; Author ........:
; Modified.......:
; Remarks .......: None
; Related .......: __CreateVectStruct, __SetVectStruct, __CreateVertStruct
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func __GetVectStruct(ByRef $tVector, $iVector, $vMember)
    Local $iSize = DllStructGetSize(DllStructCreate($tagIRR_VECTOR))
	Return DllStructGetData(DllStructCreate($tagIRR_VECTOR, DllStructGetPtr($tVector) + $iSize*$iVector), $vMember)
EndFunc ;==>__GetVectStruct


; #FUNCTION# =============================================================================================================
; Name...........: __SetVectStruct
; Description ...: Helper function: Sets x, y, z values into a structure array of vectors.
; Syntax.........: __SetVectStruct(ByRef $tVector, $iVector, $fX, $fY, $fZ)
; Parameters ....: $tVector - Structure array of vectors as created with __CreateVectStruct
;                  $iVector - Vector element to set (0-based!)
;                  $fX, $fY, $fZ - X, Y, Z values of the vector
; Return values .: None
; Author ........:
; Modified.......:
; Remarks .......: None
; Related .......: __CreateVectStruct, __GetVectStruct, __CreateVertStruct
; Link ..........:
; Example .......: [todo: Yes, No]
; ===============================================================================================================================
Func __SetVectStruct(ByRef $tVector, $iVector, $fX, $fY, $fZ)
    Local $iSize = DllStructGetSize(DllStructCreate($tagIRR_VECTOR))
    DllStructSetData(DllStructCreate($tagIRR_VECTOR, DllStructGetPtr($tVector) + $iSize*$iVector), $VECT_X, $fX)
	DllStructSetData(DllStructCreate($tagIRR_VECTOR, DllStructGetPtr($tVector) + $iSize*$iVector), $VECT_Y, $fY)
	DllStructSetData(DllStructCreate($tagIRR_VECTOR, DllStructGetPtr($tVector) + $iSize*$iVector), $VECT_Z, $fZ)
EndFunc ;==>__SetVectStruct


