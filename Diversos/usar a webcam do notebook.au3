#include <GUIConstants.au3>

;~ $destination = @TempDir & "\mySplash.bmp"
;~ FileInstall("C:\Documents and Settings\Mike\My Documents\Scripts\Projects\Pongsplash.bmp", $destination) ;source must be literal string

;~ SplashImageOn("Splash Screen", $destination, 500, 200, -1, -1, 1)

Sleep(1000) ; Set to 3 later
SplashOff()

Global $Paused
Global $DISPSIZE

HotKeySet("{ESC}", "Terminate")
HotKeySet("{TAB}", "TogglePause")

MsgBox(0, "Attention!", "Please make sure the webcam is not in use by any other applications, as it might result in errors.")

$WM_CAP_START = 0x400
$WM_CAP_UNICODE_START = $WM_CAP_START + 100
$WM_CAP_PAL_SAVEA = $WM_CAP_START + 81
$WM_CAP_PAL_SAVEW = $WM_CAP_UNICODE_START + 81
$WM_CAP_UNICODE_END = $WM_CAP_PAL_SAVEW
$WM_CAP_ABORT = $WM_CAP_START + 69
$WM_CAP_DLG_VIDEOCOMPRESSION = $WM_CAP_START + 46
$WM_CAP_DLG_VIDEODISPLAY = $WM_CAP_START + 43
$WM_CAP_DLG_VIDEOFORMAT = $WM_CAP_START + 41
$WM_CAP_DLG_VIDEOSOURCE = $WM_CAP_START + 42
$WM_CAP_DRIVER_CONNECT = $WM_CAP_START + 10
$WM_CAP_DRIVER_DISCONNECT = $WM_CAP_START + 11
$WM_CAP_DRIVER_GET_CAPS = $WM_CAP_START + 14
$WM_CAP_DRIVER_GET_NAMEA = $WM_CAP_START + 12
$WM_CAP_DRIVER_GET_NAMEW = $WM_CAP_UNICODE_START + 12
$WM_CAP_DRIVER_GET_VERSIONA = $WM_CAP_START + 13
$WM_CAP_DRIVER_GET_VERSIONW = $WM_CAP_UNICODE_START + 13
$WM_CAP_EDIT_COPY = $WM_CAP_START + 30
$WM_CAP_END = $WM_CAP_UNICODE_END
$WM_CAP_FILE_ALLOCATE = $WM_CAP_START + 22
$WM_CAP_FILE_GET_CAPTURE_FILEA = $WM_CAP_START + 21
$WM_CAP_FILE_GET_CAPTURE_FILEW = $WM_CAP_UNICODE_START + 21
$WM_CAP_FILE_SAVEASA = $WM_CAP_START + 23
$WM_CAP_FILE_SAVEASW = $WM_CAP_UNICODE_START + 23
$WM_CAP_FILE_SAVEDIBA = $WM_CAP_START + 25
$WM_CAP_FILE_SAVEDIBW = $WM_CAP_UNICODE_START + 25
$WM_CAP_FILE_SET_CAPTURE_FILEA = $WM_CAP_START + 20
$WM_CAP_FILE_SET_CAPTURE_FILEW = $WM_CAP_UNICODE_START + 20
$WM_CAP_FILE_SET_INFOCHUNK = $WM_CAP_START + 24
$WM_CAP_GET_AUDIOFORMAT = $WM_CAP_START + 36
$WM_CAP_GET_CAPSTREAMPTR = $WM_CAP_START + 1
$WM_CAP_GET_MCI_DEVICEA = $WM_CAP_START + 67
$WM_CAP_GET_MCI_DEVICEW = $WM_CAP_UNICODE_START + 67
$WM_CAP_GET_SEQUENCE_SETUP = $WM_CAP_START + 65
$WM_CAP_GET_STATUS = $WM_CAP_START + 54
$WM_CAP_GET_USER_DATA = $WM_CAP_START + 8
$WM_CAP_GET_VIDEOFORMAT = $WM_CAP_START + 44
$WM_CAP_GRAB_FRAME = $WM_CAP_START + 60
$WM_CAP_GRAB_FRAME_NOSTOP = $WM_CAP_START + 61
$WM_CAP_PAL_AUTOCREATE = $WM_CAP_START + 83
$WM_CAP_PAL_MANUALCREATE = $WM_CAP_START + 84
$WM_CAP_PAL_OPENA = $WM_CAP_START + 80
$WM_CAP_PAL_OPENW = $WM_CAP_UNICODE_START + 80
$WM_CAP_PAL_PASTE = $WM_CAP_START + 82
$WM_CAP_SEQUENCE = $WM_CAP_START + 62
$WM_CAP_SEQUENCE_NOFILE = $WM_CAP_START + 63
$WM_CAP_SET_AUDIOFORMAT = $WM_CAP_START + 35
$WM_CAP_SET_CALLBACK_CAPCONTROL = $WM_CAP_START + 85
$WM_CAP_SET_CALLBACK_ERRORA = $WM_CAP_START + 2
$WM_CAP_SET_CALLBACK_ERRORW = $WM_CAP_UNICODE_START + 2
$WM_CAP_SET_CALLBACK_FRAME = $WM_CAP_START + 5
$WM_CAP_SET_CALLBACK_STATUSA = $WM_CAP_START + 3
$WM_CAP_SET_CALLBACK_STATUSW = $WM_CAP_UNICODE_START + 3
$WM_CAP_SET_CALLBACK_VIDEOSTREAM = $WM_CAP_START + 6
$WM_CAP_SET_CALLBACK_WAVESTREAM = $WM_CAP_START + 7
$WM_CAP_SET_CALLBACK_YIELD = $WM_CAP_START + 4
$WM_CAP_SET_MCI_DEVICEA = $WM_CAP_START + 66
$WM_CAP_SET_MCI_DEVICEW = $WM_CAP_UNICODE_START + 66
$WM_CAP_SET_OVERLAY = $WM_CAP_START + 51
$WM_CAP_SET_PREVIEW = $WM_CAP_START + 50
$WM_CAP_SET_PREVIEWRATE = $WM_CAP_START + 52
$WM_CAP_SET_SCALE = $WM_CAP_START + 53
$WM_CAP_SET_SCROLL = $WM_CAP_START + 55
$WM_CAP_SET_SEQUENCE_SETUP = $WM_CAP_START + 64
$WM_CAP_SET_USER_DATA = $WM_CAP_START + 9
$WM_CAP_SET_VIDEOFORMAT = $WM_CAP_START + 45
$WM_CAP_SINGLE_FRAME = $WM_CAP_START + 72
$WM_CAP_SINGLE_FRAME_CLOSE = $WM_CAP_START + 71
$WM_CAP_SINGLE_FRAME_OPEN = $WM_CAP_START + 70
$WM_CAP_STOP = $WM_CAP_START + 68



Const $a = 110 * 4
Const $c = 131 * 4
Const $qn = (1000 / 4)



#include <GUIConstants.au3>
$avi = DllOpen("avicap32.dll")
$user = DllOpen("user32.dll")



; Load Camera
$Main = GUICreate("Camera", 455, 290, 0, 0, $WS_DLGFRAME)
$cap = DllCall($avi, "int", "capCreateCaptureWindow", "str", "cap", "int", BitOR($WS_CHILD, $WS_VISIBLE), "int", 15, "int", 15, "int", 320, "int", 240, "hwnd", $Main, "int", 1)
$track1 = GUICtrlCreateButton("Track Player 1", 345, 15, 100)
$track2 = GUICtrlCreateButton("Track Player 2", 345, 45, 100)
$START = GUICtrlCreateButton("Start Pong", 345, 105, 100)
$Quit = GUICtrlCreateButton("Quit", 345, 167.5, 100)
$ABOUT = GUICtrlCreateButton("About", 345, 230, 100)


AutoItSetOption("MouseCoordMode", 0)
AutoItSetOption("PixelCoordMode", 0)

DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_DRIVER_CONNECT, "int", 0, "int", 0)
DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_SET_SCALE, "int", 1, "int", 0)
DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_SET_OVERLAY, "int", 1, "int", 0)
DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_SET_PREVIEW, "int", 1, "int", 0)
DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_SET_PREVIEWRATE, "int", 1, "int", 0)

GUISetState(@SW_SHOW)

GUISetState()
; Setup
Do
	$msg = GUIGetMsg()


	If $msg = $track1 Then
		MsgBox(0, "Instructions", "To track Player 1's color, Place the mouse over the color you would like to track and press enter to exit this Message Box.")
		$Mousecol = MouseGetPos()
		$P1col = PixelGetColor($Mousecol[0], $Mousecol[1])
		MsgBox(0, "Player 1's color is", Hex($P1col, 6))
		GUICtrlDelete($track1)
	EndIf

	If $msg = $track2 Then
		MsgBox(0, "Instructions", "To track Player 2's color, Place the mouse over the color you would like to track and press enter to exit this Message Box.")
		$Mousecol = MouseGetPos()
		$P2col = PixelGetColor($Mousecol[0], $Mousecol[1])
		MsgBox(0, "Player 2's color is", Hex($P2col, 6))
		GUICtrlDelete($track2)
	EndIf

	If $msg = $ABOUT Then
		MsgBox(0, "About", "Tracking Program and GUI programmed by MikeFez. Camera script by rysiora.")
	EndIf

	If $msg = $Quit Then
		Terminate()
	EndIf
Until $msg = $START
WinSetOnTop("Camera", "", 1)
GUICtrlDelete($START)
GUICtrlDelete($Quit)
GUICtrlDelete($ABOUT)
GUISetState()

; Find Players
While 1

	Sleep(1)
	; Find Player 1
	$coord = PixelSearch(15, 15, 320, 240, $P1col, 5)
	If Not @error Then
		MouseMove($coord[0], $coord[1], 0)
		ToolTip("Player1 Found", 0, 0)
		Beep(($a * 2), $qn)
	EndIf
	; Find Player 2
	$coord2 = PixelSearch(15, 15, 320, 240, $P2col, 5)
	If Not @error Then
		MouseMove($coord2[0], $coord2[1], 0)
		ToolTip("Player2 Found", 0, 0)
		Beep(($c * 2), $qn)
	EndIf

	$ball = GUICreate("", 20, 31, 10, 10, $WS_POPUP, BitOR($WS_EX_LAYERED, $WS_EX_MDICHILD))
	GUICtrlCreatePic(@SystemDir & "\oobe\images\wpaflag.jpg", 40, 40, 10, 10)
WEnd

; Detect Goal
While 2


WEnd


; ----------- Pause and Exit
Func TogglePause()
	$Paused = Not $Paused
	While $Paused
		Sleep(100)
		ToolTip('Pong is "Paused"', 0, 0)
	WEnd
	ToolTip("")
EndFunc   ;==>TogglePause
Func Terminate()

	;DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_SET_CALLBACK_FRAME, "int", 0, "int", 0)
	DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_END, "int", 0, "int", 0)
	DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_DRIVER_DISCONNECT, "int", 0, "int", 0)
	;DllClose($avi)
	DllClose($user)
	Exit 0
EndFunc   ;==>Terminate
