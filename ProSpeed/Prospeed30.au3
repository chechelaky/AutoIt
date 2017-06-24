;###################################################################################################################################
; Prospeed 3.0
; UDF Prospeed  ;  Image manipulation , Sprites , DirectXSound , Joystick and Mouse functions
; Author        ;  JPAM
; Email         ;  jpamvanderouderaa@orange.nl
; Contributions ;  Frank Abbing for creating Prospeed.dll
;###################################################################################################################################

#include-once

;Opt("OnExitFunc", "Close_DLL")
OnAutoItExitRegister("Close_DLL")

Dim $S_fensterkopie1[2], $S_fensterkopie2[2] ,$hdc
Dim $S_Struct_data, $S_Rz, $PNG_struct, $S_ReadStruct[10]
Dim $S_Destination=$hdc
Dim $S_CopieMode=0
Dim $PNG_struct[10]
Dim $S_WIDTH[1]
Dim $S_HEIGHT[1]

$S_DLL = DllOpen(@ScriptDir & "\ProSpeed3.0.dll")

GUIRegisterMsg(0x000F, "PaintNew")

;###################################################################################################################################
; IMAGES
;###################################################################################################################################

;###################################################################################################################################
;	LoadImage
;	syntax : $dino = LoadImage("Imagefile", POS X, POS Y, $N_WIDTH, $N_HEIGHT, $S_Onscreen)
;	Note ; Needs a user defined string before the func
;			"Imagefile" = path to Imagefile can be (.bmp, .jpg, .gif, .png, .wmf)
;			POS X and POS Y are the position's where the picture is copy to the window
;			WIDTH/HEIGHT = New width and height for image file
;			Onscreen = 0 / 1
;			0 = in memory
;			1 = onscreen
;			Example;
;			i want to load imagefile , Create SpecialFX for blur effect
;			LoadImage("dino.jpg", 0, 0, 600, 400, 1)
;			Blur("",0,0,30)
;###################################################################################################################################
Func LoadImage($S_FILE, $S_offsetX, $S_offsetY, $N_WIDTH, $N_HEIGHT, $S_Onscreen)
	$WIN_TILLE     = WinGetTitle("","")
	If $hDC <> 0 Then
		;
	Else
		$WIN_GETHANDLE = WinGetHandle($WIN_TILLE,"")
		$RAW_HDC       = DllCall("user32.dll","ptr","GetDC","hwnd",$WIN_GETHANDLE)
		$hDC           = "0x" & Hex($RAW_HDC[0])
	EndIf

	$S_Image  = DllCall($S_DLL, "long", "LoadFileImage", "str", $S_FILE)
	$S_WIDTH  = DllCall($S_DLL, "long", "GetWidthImage", "long", $S_Image[0])
	$S_HEIGHT = DllCall($S_DLL, "long", "GetHeightImage", "long", $S_Image[0])
	If $S_Onscreen = 1 Then
		$C_createBMP = DllCall($S_dll, "long", "CreateImage", _
									   "long", $hDC, _
									   "long", $N_WIDTH, _
									   "long", $N_HEIGHT)
		DllCall($S_dll, "long", "SizeImage", _
						"long", $C_createBMP[0], _
						"long", 0, _
						"long", 0, _
						"long", $N_WIDTH, _
						"long", $N_HEIGHT, _
						"long", $S_Image[0], _
						"long", 0, _
						"long", 0, _
						"long", $S_WIDTH[0], _
						"long", $S_HEIGHT[0], _
						"long", 0)
		$S_ImageFX = DllCall($S_DLL, "long", "InitFX", "long", $C_createBMP[0])
		DllCall($S_DLL, "long", "CopyFX", _
						"long", $hDC, _
						"long", $S_offsetX, _
						"long", $S_offsetY, _
						"long", $S_ImageFX[0])
		$S_fensterkopie1 = DllCall($S_DLL, "long", "CreateImage", _
										   "long", $hDC, _
										   "long", $S_WIDTH[0], _
										   "long", $S_HEIGHT[0])
		DllCall($S_DLL, "long", "PaintImage", "long", $S_fensterkopie1[0], _
									          "long", 0, _
									          "long", 0, _
											  "long", $S_WIDTH[0], _
										      "long", $S_HEIGHT[0], _
										      "long", $hDC, _
										      "long", 0, _
										      "long", 0, _
										      "long", 0)
		Return $S_ImageFX[0]
	ElseIf $S_Onscreen = 0 Then
		$C_createBMP = DllCall($S_dll, "long", "CreateImage", _
									   "long", $hDC, _
									   "long", $N_WIDTH, _
									   "long", $N_HEIGHT)
		DllCall($S_dll, "long", "SizeImage", _
						"long", $C_createBMP[0], _
						"long", $S_offsetX, _
						"long", $S_offsetY, _
						"long", $N_WIDTH, _
						"long", $N_HEIGHT, _
						"long", $S_Image[0], _
						"long", $S_offsetX, _
						"long", $S_offsetY, _
						"long", $S_WIDTH[0], _
						"long", $S_HEIGHT[0], _
						"long", 0)
		$S_ImageFX = DllCall($S_DLL, "long", "InitFX", "long", $C_createBMP[0])
		Return $S_ImageFX[0]
	ElseIf $S_Onscreen = 3 Then
		$C_createBMP = DllCall($S_dll, "long", "CreateImage", _
									   "long", $hDC, _
									   "long", $N_WIDTH, _
									   "long", $N_HEIGHT)
		DllCall($S_dll, "long", "SizeImage", _
						"long", $C_createBMP[0], _
						"long", 0, _
						"long", 0, _
						"long", $N_WIDTH, _
						"long", $N_HEIGHT, _
						"long", $S_Image[0], _
						"long", 0, _
						"long", 0, _
						"long", $S_WIDTH[0], _
						"long", $S_HEIGHT[0], _
						"long", 0)
		Return $C_createBMP[0]
	ElseIf $S_Onscreen = 4 Then
		$C_createBMP = DllCall($S_dll, "long", "CreateImage", _
									   "long", $hDC, _
									   "long", $N_WIDTH, _
									   "long", $N_HEIGHT)
		DllCall($S_dll, "long", "SizeImage", _
						"long", $C_createBMP[0], _
						"long", $S_offsetX, _
						"long", $S_offsetY, _
						"long", $N_WIDTH, _
						"long", $N_HEIGHT, _
						"long", $S_Image[0], _
						"long", $S_offsetX, _
						"long", $S_offsetY, _
						"long", $S_WIDTH[0], _
						"long", $S_HEIGHT[0], _
						"long", 0)
		Return $C_createBMP[0]
	EndIf
EndFunc
;###################################################################################################################################
;	LoadFileImage
;	syntax : $pic = LoadFileImage("c:\photo.jpg")
;	Note   ; load picture to memmory
;	returns Handle for imagedata
;###################################################################################################################################
Func LoadFileImage($S_File)
	$S_Image  = DllCall($S_DLL, "long", "LoadFileImage", _
								"str", $S_File)
	Return 	$S_Image[0]
EndFunc
;###################################################################################################################################
;	LoadMemoryImage
;	syntax : $pic = LoadMemoryImage(dllstructgetprt($struct,1), filegetsize("c:\sprite.gif"))
;	Note   ; load picture from memmory
;	returns Handle for imagedata
;###################################################################################################################################
Func LoadMemoryImage($S_pointer, $S_size)
	$S_LoadExt = DllCall($S_DLL, "long", "LoadMemoryImage", _
								 "long", $S_pointer, _
								 "long", $S_size)
	Return $S_LoadExt[0]
EndFunc
;###################################################################################################################################
;	ImportPng
;	syntax : $PNGpic = ImportPng(ID, Image.png)
;	Note   ; load PNH picture to memmory with alpha channel
;	         $PNG_ID    = image ID used to create dllstructs (can be any number from 0 to 10)
;			 $PNG_Image = path to png picture
;	returns Handle for PNG imagedata
;###################################################################################################################################
Func ImportPng($PNG_ID, $PNG_Image)
	$PNG_struct[$PNG_ID] = DllStructCreate("long;long;long")
	$PNG_Handle = DllCall($S_dll, "long", "ImportPng", _
								  "str" , $PNG_Image, _
								  "long", DllStructGetPtr($PNG_struct[$PNG_ID],1), _
								  "long", DllStructGetPtr($PNG_struct[$PNG_ID],2), _
								  "long", DllStructGetPtr($PNG_struct[$PNG_ID],3))
	Return $PNG_Handle[0]
EndFunc
;###################################################################################################################################
;	GetPngWitdh
;	syntax : $PNGWidth = GetPngWitdh(ID)
;	returns Width for PNG imagedata
;###################################################################################################################################
Func GetPngWitdh($PNG_ID)
	Return DllStructGetPtr($PNG_struct[$PNG_ID],1)
EndFunc
;###################################################################################################################################
;	GetPngHeight
;	syntax : $PNGHeight = GetPngHeight(ID)
;	returns Height for PNG imagedata
;###################################################################################################################################
Func GetPngHeight($PNG_ID)
	Return DllStructGetPtr($PNG_struct[$PNG_ID],2)
EndFunc
;###################################################################################################################################
;	PaintPng
;	syntax : PaintPng(ID, Destination, Offset X, Offset Y, PNG Handle, Hdc2)
;	Note   ; Paints PNH picture from Handle create with ImportPng
;			 $PNG_ID      = Id from ImportPng()
;			 $Destination = Hdc (window)
;			 $PNG_OffsetX = X offset in Hdc
;			 $PNG_OffsetY = Y offset in Hdc
;			 $PNG_Handle  = Handle created with ImportPng
;			 $S_Hdc2      = 0 or BitmapData created with loadimage() or CreateImage()
;###################################################################################################################################
Func PaintPng($PNG_ID, $S_Destination, $PNG_OffsetX, $PNG_OffsetY, $PNG_Handle, $S_Hdc2)
	$PNG_Size   = DllStructGetData($PNG_struct[$PNG_ID],3)
	$PNG_Width  = DllStructGetData($PNG_struct[$PNG_ID],1)
	$PNG_Height = DllStructGetData($PNG_struct[$PNG_ID],2)
	DllCall($S_dll, "long", "PaintPng", _
					"long", $PNG_Handle, _
					"long", $PNG_Size, _
					"long", $S_Destination, _
					"long", $PNG_OffsetX, _
					"long", $PNG_OffsetY, _
					"long", $PNG_Width, _
					"long", $PNG_Height, _
					"long", $S_Hdc2)
EndFunc
;###################################################################################################################################
;	InvertPngMask
;	syntax : InvertPngMask(ID, Handle)
;	Note   ; Invert the alpha channel in PNG picture
;			 $PNG_ID     = Id from ImportPng()
;			 $PNG_Handle = Handle created with ImportPng
;###################################################################################################################################
Func InvertChannelPng($PNG_ID, $PNG_Handle)
	$PNG_Size = DllStructGetData($PNG_struct[$PNG_ID],3)
	DllCall($S_dll, "long", "InvertChannelPng", _
					"long", $PNG_Handle, _
					"long", $PNG_Size)
EndFunc
;###################################################################################################################################
;	MergeChannelPng
;	syntax : MergeChannelPng(ID, PngHandle1, PngHandle1, Value)
;	Note   ; Morph the alpfa channel from PngHandle2 to PngHandle1
;			 $PNG_ID      = Id from ImportPng()
;			 PngHandle1   = Handle from ImportPng()
;			 PngHandle2   = Handle from ImportPng()
;			 $PNG_Value   = Speed of morphing
;###################################################################################################################################
Func MergeChannelPng($PNG_ID, $PNG_Source1, $PNG_Source2, $PNG_Value)
	DllCall($S_DLL, "long", "MergeChannelPng", _
					"long", $PNG_Source1, _
					"long", $PNG_Source2, _
					"long", DllStructGetData($PNG_struct[$PNG_ID],3), _
					"long", $PNG_Value)
EndFunc
;###################################################################################################################################
;	MergeImagePng
;	syntax : MergeImagePng(ID, PngHandle1, PngHandle2, Value)
;	Note   ; Morph the Image Data from PngHandle2 to PngHandle1
;			 ID         = Id from ImportPng()
;			 PngHandle1 = Handle from ImportPng()
;			 PngHandle2 = Handle from ImportPng()
;			 Value      = Speed of morphing
;###################################################################################################################################
Func MergeImagePng($PNG_ID, $PNG_Source1, $PNG_Source2, $PNG_Value)
	DllCall($S_DLL, "long", "MergeImagePng", _
					"long", $PNG_Source1, _
					"long", $PNG_Source2, _
					"long", DllStructGetData($PNG_struct[$PNG_ID],3), _
					"long", $PNG_Value)
EndFunc
;###################################################################################################################################
;	PngToFX
;	syntax : $array = PngToFX(ID, PngHandle, Value)
;	Note   ; Seperate png Image data from alpha channel
;			 ID         = Id from ImportPng()
;			 PngHandle1 = Handle from ImportPng()
;			 Value      = 0 or 1
;			 0 returns image data
;			 1 returns alpha channel mask data
;###################################################################################################################################
Func PngToFX($PNG_ID, $PNG_Source, $PNG_Value)
	Local $PNG_StructMask = DllStructCreate("long")
	$PNG_array = DllCall($S_DLL, "long", "PngToFX", _
							     "long", $PNG_Source, _
							     "long", DllStructGetData($PNG_struct[$PNG_ID], 1), _
							     "long", DllStructGetData($PNG_struct[$PNG_ID], 2), _
							     "long", DllStructGetData($PNG_struct[$PNG_ID], 3), _
							     "long", DllStructGetPtr($PNG_StructMask, 1))
	If $PNG_Value = 0 Then Return $PNG_array[0]
	If $PNG_Value = 1 Then Return DllStructGetData($PNG_StructMask,1)
EndFunc
;###################################################################################################################################
;	FXToPng
;	syntax : $array = FXToPng(ID, Array1, Array2)
;	Note   ; combine 2 Arrays into 1 Png image
;			 ID     = Id from ImportPng()
;			 Array1 = Handle with InitFX() or CreateExtFX() produced byte arrays
;			 Array2 = Handle with InitFX() or CreateExtFX() produced byte arrays
;	return ; Pointer to new Png image data
;###################################################################################################################################
Func FXToPng($PNG_ID, $S_Source1, $S_Source2, $PNGWidth=0, $PNGHeight=0, $PngSize=0)
	If $PNGWidth<>0 Then
		$PNG_struct[$PNG_ID] = DllStructCreate("long;long;long")
		DllStructSetData($PNG_struct[0],1,$PNGWidth)
		DllStructSetData($PNG_struct[0],2,$PNGHeight)
		DllStructSetData($PNG_struct[0],3,$PngSize)
	EndIf
	$PNG_Tmp = DllCall($S_DLL, "long", "FXToPng", _
							   "long", $S_Source1, _
							   "long", DllStructGetPtr($PNG_struct[$PNG_ID],1), _
							   "long", DllStructGetPtr($PNG_struct[$PNG_ID],2), _
							   "long", DllStructGetPtr($PNG_struct[$PNG_ID],3), _
							   "long", $S_Source2)
	Return $PNG_Tmp[0]
EndFunc
;###################################################################################################################################
;	ExportPng
;	syntax : ExportPng(0, $png, "New.png")
;	Note   ; Export png picture to harddisk
;			 $PNG_ID     = Id from ImportPng()
;			 $PNG_Handle = Handle created with ImportPng
;			 $PNG_Name   = "New name.png"
;###################################################################################################################################
Func ExportPng($PNG_ID, $PNG_Handle, $PNG_Name)
	DllCall($S_Dll, "long", "ExportPng", _
					"long", $PNG_Handle, _
					"str" , $PNG_Name, _
					"long", DllStructGetData($PNG_struct[$PNG_ID], 1), _
					"long", DllStructGetData($PNG_struct[$PNG_ID], 2))
EndFunc
;###################################################################################################################################
;	FreePng
;	syntax : FreePng(ID, Handle)
;	Note   ; Free up picture data from memory
;			 $PNG_Handle = Handle created with ImportPng
;###################################################################################################################################
Func FreePng($PNG_ID, $PNG_Handle)
	DllCall($S_dll, "long", "FreePng", _
					"long", $PNG_Handle)
	$PNG_struct[$PNG_ID] = ""
EndFunc
;###################################################################################################################################
;	CreateImage
;	syntax : $bitmap1 = CreateImage(400, 300)
;	Note   ; creates a empty bitmap in memory
;		     $C_Width  = width of the bitmap
;		     $C_Height = height of the bitmap
;	returns pointer for imagedata
;###################################################################################################################################
Func CreateImage($C_Width, $C_Height)
	$C_createBMP = DllCall($S_dll, "long", "CreateImage", _
								   "long", $hDC, _
								   "long", $C_Width, _
								   "long", $C_Height)
	Return $C_createBMP[0]
EndFunc
;###################################################################################################################################
;	CreateExtFX
;	syntax : $FX = CreateExtFX($C_Width, $C_Height)
;	Note   ; creates a empty bitmap array in memory
;		     $C_Width  = width of the bitmap array
;		     $C_Height = height of the bitmap array
;	returns pointer for imagedata
;###################################################################################################################################
Func CreateExtFX($C_Width, $C_Height)
	$C_CreateExtFX = DllCall($S_dll, "long", "CreateExtFX", _
									 "long", $C_Width, _
									 "long", $C_Height)
	Return $C_CreateExtFX[0]
EndFunc
;###################################################################################################################################
;	PaintImage
;	syntax : PaintImage($bitmap1, 0, 0, 400, 300, $hDC, 200, 150)
;	Note   ; copie a bitmap to HDC (window) or another bitmap created with CreateImage
;		     $C_Destination = Destination to copie the bitmap to
;		     $C_OffsetX     = offset on x axis to begin the copie on the destination bitmap
;		     $Cs_Width      = width of the bitmap to be copied
;		     $Cs_Height     = height of the bitmap to be copied
;		     $C_Source      = source bitmap
;		     $C_PosX        = x offset of the source bitmap to begin to copie
;		     $C_PosY        = y offset of the source bitmap to begin to copie
;###################################################################################################################################
Func PaintImage($C_Destination, $C_OffsetX, $C_OffsetY, $Cs_Width, $Cs_Height, $C_Source, $C_PosX, $C_PosY, $S_CopieMode)
	DllCall($S_DLL, "long", "PaintImage", _
					"long", $C_Destination, _
					"long", $C_OffsetX, _
					"long", $C_OffsetY, _
					"long", $Cs_Width, _
					"long", $Cs_Height, _
					"long", $C_Source, _
					"long", $C_PosX, _
					"long", $C_PosY, _
					"long", $S_CopieMode)
EndFunc
;###################################################################################################################################
;	CopyFX
;	syntax : CopyFX($C_Destination, $S_offsetX, $S_offsetY, $C_Source)
;	Note   ; copie a bitmap array to HDC (window) or another bitmap created with CreateImage
;		     $C_Destination = Destination hdc to copy
;		     $C_OffsetX     = x axis in Destination
;		     $C_OffsetY     = y axis in Destination
;		     $C_Source      = Handle with InitFX() or CreateExtFX() produced byte arrays
;###################################################################################################################################
Func CopyFX($C_Destination, $S_offsetX, $S_offsetY, $C_Source)
	DllCall($S_DLL, "long", "CopyFX", _
					"long", $C_Destination, _
					"long", $S_offsetX, _
					"long", $S_offsetY, _
					"long", $C_Source)
EndFunc
;###################################################################################################################################
;	CloneFX
;	Syntax ; $new_array = CloneFX($S_array)
;	Copy existing Array to new array , including imagedata
;	returns ; Pointer for new array
;###################################################################################################################################
Func CloneFX($S_Source)
	$S_CloneFX = DllCall($S_DLL, "long", "CloneFX", _
								 "long", $S_Source)
	Return $S_CloneFX[0]
EndFunc
;###################################################################################################################################
;	SaveImage
;	syntax : SaveImage($bitmap1, c:\temp\image.jpg, 1, 10)
;	Note   ; write image data to harddisk
;	       $C_Source   = imagedata create by loadimage or CreateImage
;		   $S_FilePath = path to write imagedata
;		   $S_Type     = bitmap/jpg 0/1
;		   $S_Quality  = range 1 to 10 only valid for jpg
;###################################################################################################################################
Func SaveImage($C_Source, $S_FilePath, $S_Type, $S_Quality)
	DllCall($S_DLL, "long", "SaveImage", _
					"long", $C_Source, _
					"str" , $S_FilePath, _
					"long", $S_Type, _
					"long", $S_Quality)
EndFunc
;###################################################################################################################################
;	InitFX
;	syntax : $FX = InitFX($bitmap1)
;	Note ; creates a byte array from a bitmap for Special fx functions
;	returns pointer for fx effect
;###################################################################################################################################
Func InitFX($C_Source)
	$S_ImageFX = DllCall($S_DLL, "long", "InitFX", _
								 "long", $C_Source)
	Return $S_ImageFX[0]
EndFunc
;###################################################################################################################################
;	FreeImage
;	syntax : FreeImage(Alias)
;	Note ; clears the bitmap from memory
;###################################################################################################################################
Func FreeImage($S_Alias)
	DllCall($S_DLL, "long", "FreeImage", "long", $S_Alias)
EndFunc
;###################################################################################################################################
;	FreeAllImages
;	syntax : FreeAllImages()
;	Note ; clears all bitmaps from memory
;###################################################################################################################################
Func FreeAllImages()
	DllCall($S_DLL, "long", "FreeAllImages")
EndFunc
;###################################################################################################################################
;	FreeFX
;	syntax : FreeFX($S_Alias)
;	Note ; clears all arrays from memory
;###################################################################################################################################
Func FreeFX($S_Alias)
	DllCall($S_DLL, "long", "FreeFX", "long", $S_Alias)
EndFunc
;###################################################################################################################################
;	Function GetWidthImage
;	syntax : GetWidthImage($Alias)
;	Note ; Alias = String created by Function LoadImage()
;		   Get the width of the loaded image
;###################################################################################################################################
Func GetWidthImage($S_FILE)
	$S_WIDTH = DllCall($S_DLL, "long", "GetWidthImage", "long", $S_FILE)
	Return $S_WIDTH[0]
EndFunc
;###################################################################################################################################
;	Function GetHeightImage
;	syntax : GetHeightImage($Alias)
;	Note ; Alias = String created by Function LoadImage()
;		   Get the Height of the loaded image
;###################################################################################################################################
Func GetHeightImage($S_FILE)
	$S_Height = DllCall($S_DLL, "long", "GetHeightImage", "long", $S_FILE)
	Return $S_Height[0]
EndFunc
;###################################################################################################################################
;
;
;###################################################################################################################################
Func GetInfosImage($Sc_Source, $Sc_GetValue)
	$GetInfosImage = DllStructCreate("long;long;long;short;short;long;long;long;long;long;long")
	DllCall($S_DLL, "long", "GetInfosImage", _
					"long", $Sc_Source, _
					"long", DllStructGetPtr($GetInfosImage))
	$S_BitmapInfo = DllStructGetData($GetInfosImage, $Sc_GetValue)
	Return $S_BitmapInfo
EndFunc
;###################################################################################################################################
;	BitBltArray
;	syntax : BitBltArray($S_Destination, $S_DesX, $S_DesY, $S_Des_width, $S_Des_Height, $S_Source, $S_SourceX, $S_SourceY, $S_Flag, $S_Color_or_Mask)
;	Note ; Copies a rectangular cutout of a byte array into another. If necessary also with transparent color or mask
;	$S_Destination   = Handle with InitFX() or CreateExtFX() produced byte arrays
;	$S_DesX          = X coordinate in the destination byte array
;	$S_DesY 	     = Y coordinate in the destination byte array
;	$S_Des_width     = Width of the rectangle, which is to be copied
;	$S_Des_Height    = Height of the rectangle, which is to be copied
;	$S_Source        = Source with InitFX() or CreateExtFX() produced byte
;	$S_SourceY       = Y coordinate in the source array
;	$S_Flag          = 0/1/2
;	$S_Color_or_Mask = RGB color or Mask image
;	Note about $S_Flag ;
;	If $S_Flag = 0 , normal copy
;	If $S_Flag = 1 , then a transparent color must be indicated, e.g. RGB(255,255,255) in $S_Color_or_Mask.
;	If a pixel in the source diagram possesses this color, it is not copied in the destination byte array.
;	If $S_Flag = 2 , then $S_Color_or_Mask needs a byte array Mask image.
;###################################################################################################################################
Func BitBltArray($S_Destination, $S_DesX, $S_DesY, $S_Des_width, $S_Des_Height, $S_Source, $S_SourceX, $S_SourceY, $S_Flag, $S_Color_or_Mask=0)
	DllCall($S_DLL, "long", "BitBltArray", _
					"long", $S_Destination, _
					"long", $S_DesX, _
					"long", $S_DesY, _
					"long", $S_Des_width, _
					"long", $S_Des_Height, _
					"long", $S_Source , _
					"long", $S_SourceX, _
					"long", $S_SourceY, _
					"long", $S_Flag, _
					"long", $S_Color_or_Mask)
EndFunc
;###################################################################################################################################
;	Size
;	syntax : Size($S_Destination, $N_WIDTH, $N_HEIGHT, $S_Source, $O_WIDTH, $O_HEIGHT, $S_Mode)
;	Note ;  $S_Destination = $hdc (window) or bitmap in memory created with function CreateImage()
;			if $S_Destination = 0 then the resized image data stays in memory
;			$S_X1 = X offset in destination
;			$S_Y1 = Y offset in destination
;			$N_WIDTH  = new width for picture
;           $N_HEIGHT = new height for picture
;           $S_Source = Source picture
;           $S_X2 = X offset in source picture
;           $S_Y2 = Y offset in source picture
;			$O_WIDTH  = old width of picture
;           $O_HEIGHT = old height of picture
;           $S_Mode =
;			0 = normal copy
;			1 = source and destination linked with AND
;			2 = source and target linked with OR
;			3 = source and destination linked with XOR
;			4 = Target invert (source is not taken into account)
;			5 - 12 = further linking techniques
;			13 = black (default) Delete
;			14 = white (default) Delete
;	example; size($hdc, 600, 400, $bitmap1, 800, 600, 0)
;            resize a picture with 800x600 to 600x400 and copy to hDC window with copy mode 0
;###################################################################################################################################
Func Size($S_Destination, $S_X1=0, $S_Y1=0, $N_WIDTH=0, $N_HEIGHT=0, $S_Source=0, $S_X2=0, $S_Y2=0, $O_WIDTH=0, $O_HEIGHT=0, $S_Mode=0)
		DllCall($S_DLL, "long", "SizeImage", _
						"long", $S_Destination, _
						"long", $S_X1, _
						"long", $S_Y1, _
						"long", $N_WIDTH, _
						"long", $N_HEIGHT, _
						"long", $S_Source, _
						"long", $S_X2, _
						"long", $S_Y2, _
						"long", $O_WIDTH, _
						"long", $O_HEIGHT, _
						"long", $S_Mode)
EndFunc
;###################################################################################################################################
;	Effect ColorFillImage
;	syntax : ColorFillImage($S_Destination, $S_Pleft, $S_Pright, $S_Ptop, $S_Pbottom, $S_Pcolor)
;	Note ;  $S_Destination = $hdc (window) or bitmap in memmory created with function CreateImage()
;			if $S_Destination = 0 then the Effect on the image stays in memmory
;			$S_Pleft = how many pixels from the right of the screen to begin paint
;			$S_Pright = how many pixels from $S_Pleft to paint
;			$S_Ptop = how many pixels from the top of the screen to paint
;			$S_Pbottom = how many pixels from $S_Ptop to paint
;			$S_Pcolor = pixel color (normal autoit color = RGB ,but dll call = BGR)
;	example; ColorFillImage(10, 11, 10, 11, 0x0000ff) paint 1 RED pixel at screen coordinate X 10, Y 10
;			 ColorFillImage(10, 110, 10, 110, 0xff0000) paints a BLUE box at screen coordinate X 10, Y 10 , 100 pixels width and 100 pixels height
;###################################################################################################################################
Func ColorFillImage($S_Destination, $S_Pleft, $S_Ptop, $S_Pright, $S_Pbottom, $S_Pcolor)
	DllCall($S_DLL, "long", "ColorFillImage", _
					"long", $S_Destination, _
					"long", $S_Pcolor, _
					"long", $S_Pleft, _
					"long", $S_Ptop, _
					"long", $S_Pright, _
					"long", $S_Pbottom)
EndFunc
;###################################################################################################################################
;	ColorFill
;	Syntax; ColorFill(Destination, color)
;	Fill Array With Color
;###################################################################################################################################
Func ColorFill($S_Destination, $S_Pcolor)
	DllCall($S_DLL, "long", "ColorFill", _
					"long", $S_Destination, _
					"long", $S_Pcolor)
EndFunc
;###################################################################################################################################
;	Frame
;	syntax : Frame($S_Destination, $High_Color, $Low_Color, $S_Left, $S_Top, $S_Right, $S_Bottom, $S_Pixelwidth)
;	Note ;  $C_Destination = $hdc (window) or image data in memory
;			if $S_Destination = 0 then the Effect on the image stays in memmory
;			$High_Color = color of the left and top of the frame
;			$Low_Color = color of the right and bottom of the frame
;			$S_Left = how many pixels from the left of the screen to begin drawing
;			$S_Top = how many pixels from the top of the screen to begin drawing
;			$S_Right = how many pixels from $S_Left to draw
;			$S_Bottom = how many pixels from $S_Top to draw
;			$S_Pixelwidth = how pixel thick to draw
;	example ; Frame(0x0000ff,0x0000aa,30,50,130,100,4)
;###################################################################################################################################
Func Frame($S_Destination, $High_Color, $Low_Color, $S_Left, $S_Top, $S_Right, $S_Bottom, $S_Pixelwidth)
	DllCall($S_DLL, "long", "Frame", _
					"long", $S_Destination, _
					"long", $High_Color, _
					"long", $Low_Color, _
					"long", $S_Left, _
					"long", $S_Top, _
					"long", $S_Right, _
					"long", $S_Bottom, _
					"long", $S_Pixelwidth)
	DllCall($S_DLL, "long", "PaintImage", _
					"long", $S_fensterkopie1[0], _
					"long", 0, _
					"long", 0, _
					"long", $S_WIDTH[0], _
					"long", $S_HEIGHT[0], _
					"long", $hDC, _
					"long", 0, _
					"long", 0, _
					"long", 0)
EndFunc
;###################################################################################################################################
;	Curve
;	syntax : Curve($S_Destination, $Start_X, $Start_Y, $mid_X, $mid_Y, $end_X, $end_Y)
;	Note ;  $C_Destination = $hdc (window) or image data in memory
;			if $S_Destination = 0 then the Effect on the image stays in memmory
;			$Start_X = startpoint on X axis to draw
;			$Start_Y = startpoint on Y axis to draw
;			$mid_X = midpoint on X axis to draw to
;			$mid_Y = midpoint on Y axis to draw to
;			$end_X = endpoint on X axis to draw to
;			$end_Y = endpoint on Y axis to draw to
;	example ; Curve(400, 200, 420, 300, 450, 200)
;###################################################################################################################################
Func Curve($S_Destination, $Start_X, $Start_Y, $mid_X, $mid_Y, $end_X, $end_Y)
	DllCall($S_DLL, "long", "Curve", _
					"long", $S_Destination, _
					"long", $Start_X, _
					"long", $Start_Y, _
					"long", $mid_X, _
					"long", $mid_Y, _
					"long", $end_X, _
					"long", $end_Y)
	DllCall($S_DLL, "long", "PaintImage", _
					"long", $S_fensterkopie1[0], _
					"long", 0, _
					"long", 0, _
					"long", $S_WIDTH[0], _
					"long", $S_HEIGHT[0], _
					"long", $hDC, _
					"long", 0, _
					"long", 0, _
					"long", 0)
EndFunc
;###################################################################################################################################
;	ExchangeColor
;	syntax : ExchangeColor($C_Destination, $C_Xoffset, $C_Yoffset, $C_Source, $C_Source_Color, $C_Destination_Color)
;	Note ;  $C_Destination       = your desktop window or image data in memory
;			if $S_Destination = 0 then the Effect on the image stays in memmory
;			$C_Xoffset           = x axis to begin copy to the screen
;			$C_Yoffset           = y axis to begin copy to the screen
;			$C_Source            = source image data to create the effect on
;			$C_Source_Color      = source image color to change
;			$C_Destination_Color = New color
;	example ;  ExchangeColor($hDC, 0, 0, $fx, 0x0000FF, 0xFFFFFF) ; change red to white
;###################################################################################################################################
Func ExchangeColor($C_Destination, $C_Xoffset, $C_Yoffset, $C_Source, $C_Source_Color, $C_Destination_Color)
	DllCall($S_DLL, "long", "ExchangeColor", _
					"long", $C_Destination, _
					"long", $C_Xoffset, _
					"long", $C_Yoffset, _
					"long", $C_Source, _
					"long", $C_Source_Color, _
					"long", $C_Destination_Color)
	DllCall($S_DLL, "long", "PaintImage", _
					"long", $S_fensterkopie1[0], _
					"long", 0, _
					"long", 0, _
					"long", $S_WIDTH[0], _
					"long", $S_HEIGHT[0], _
					"long", $hDC, _
					"long", 0, _
					"long", 0, _
					"long", 0)
EndFunc
;###################################################################################################################################
;	ExchangeRgb
;	syntax : ExchangeRgb($C_Destination, $C_Xoffset, $C_Yoffset, $C_Source, $C_Color_Red, $C_Color_Green, $C_Color_Blue)
;	Note ;  $C_Destination       = your desktop window or image data in memory
;			if $S_Destination = 0 then the Effect on the image stays in memmory
;			$C_Xoffset           = x axis to begin copy to the screen
;			$C_Yoffset           = y axis to begin copy to the screen
;			$C_Source            = Handle with InitFX() or CreateExtFX() produced byte arrays
;			$C_Color_Red         = Value for Red Color
;			$C_Color_Green       = Value for Green Color
;			$C_Color_Blue        = Value for Blue Color
;	example ;  ExchangeRgb($hdc, 0, 0, $FX1, 45, 0, 120)
;###################################################################################################################################
Func ExchangeRgb($C_Destination, $C_Xoffset, $C_Yoffset, $C_Source, $C_Color_Red, $C_Color_Green, $C_Color_Blue)
	DllCall($S_DLL, "long", "ExchangeRgb", _
					"long", $C_Destination, _
					"long", $C_Xoffset, _
					"long", $C_Yoffset, _
					"long", $C_Source, _
					"long", $C_Color_Red, _
					"long", $C_Color_Green, _
					"long", $C_Color_Blue)
	DllCall($S_DLL, "long", "PaintImage", _
					"long", $S_fensterkopie1[0], _
					"long", 0, _
					"long", 0, _
					"long", $S_WIDTH[0], _
					"long", $S_HEIGHT[0], _
					"long", $hDC, _
					"long", 0, _
					"long", 0, _
					"long", 0)
EndFunc
;###################################################################################################################################
;	ColorMove
;	syntax : ColorMove($C_Xoffset, $C_Yoffset, $C_Source1, $C_Source2)
;	Note   ; $S_Destination = $hdc (window) or bitmap in memmory created by CreateImage()
;			 $C_Xoffset     = x axis to begin copy to the screen
;			 $C_Yoffset     = y axis to begin copy to the screen
;			 $C_Source1     = Handle with InitFX() or CreateExtFX() produced byte arrays
;			 $C_Source2     = Handle with InitFX() or CreateExtFX() produced byte arrays
;			 $C_Value       = how much effect ; could be used in (for next) loop
;	example ; $bitmap       = LoadFileImage("c:\image")
;###################################################################################################################################
Func ColorMove($S_Destination, $C_Xoffset, $C_Yoffset, $C_Source1, $C_Source2, $C_Value)
	DllCall($S_DLL, "long", "ColorMove", _
					"long", $S_Destination, _
					"long", $C_Xoffset, _
					"long", $C_Yoffset, _
					"long", $C_Source1, _
					"long", $C_Source2, _
					"long", $C_Value)
EndFunc
;###################################################################################################################################
;	Effect Blur
;	syntax : blur($S_Destination, $S_POSX, $S_POSY, $S_Source, $S_VALUE)
;	Note   ; $S_Destination    = $hdc (window) or bitmap in memmory created by CreateImage()
;			 if $S_Destination = 0 then the Effect on the image stays in memmory
;			 $S_POSX           = x axis to begin copy to the screen
;			 $S_POSY           = y axis to begin copy to the screen
;			 $S_Source         = Handle with InitFX() or CreateExtFX() produced byte arrays
;			 ValueEffect       = 1 to 256  ; higher is more effect
;###################################################################################################################################
Func blur($S_Destination, $S_POSX, $S_POSY, $S_Source)
	DllCall($S_DLL, "long", "Blur", _
					"long", $S_Destination, _
					"long", $S_POSX, _
					"long", $S_POSY, _
					"long", $S_Source)
EndFunc
;###################################################################################################################################
;	Effect Antialiasing
;	syntax : Antialiasing($S_Destination, $S_POSX, $S_POSY, $S_Source, $S_Color, $S_Flag, $S_value)
;	Note ;
;		    $S_Destination = $hdc (window) or bitmap in memmory created by CreateImage()
;			$S_POSX        = x axis to begin copy to the screen
;			$S_POSY        = y axis to begin copy to the screen
;			$S_Source      = Handle with InitFX() or CreateExtFX() produced byte arrays
;			$S_Color       = RGB Color of the transparent color or -1
;			$S_Flag        = 0 , 1 or 2
;			$S_value       = Number of runs of the effect
;	Example ; Antialiasing($hdc, 0, 0, $fx1, -1, 0, 2)
;###################################################################################################################################
Func Antialiasing($S_Destination, $S_POSX, $S_POSY, $S_Source, $S_Color, $S_Flag, $S_value)
	DllCall($S_DLL, "long", "Antialiasing", _
					"long", $S_Destination, _
					"long", $S_POSX, _
					"long", $S_POSY, _
					"long", $S_Source, _
					"long", $S_Color, _
					"long", $S_Flag, _
					"long", $S_value)
EndFunc
;###################################################################################################################################
;	Effect Smooth
;	syntax : Smooth($S_Destination, $S_POSX, $S_POSY, $S_Source1, $S_Source2)
;	Note ;  kind of like Blur, but with mask picture *.png
;		    $S_Destination = $hdc (window) or bitmap in memmory created by CreateImage()
;			if $S_Destination = 0 then the Effect on the image stays in memmory
;			$S_Source1     = Handle with InitFX() or CreateExtFX() produced byte arrays
;			$S_Source2     = Handle with InitFX() or CreateExtFX() produced byte arrays
;			$S_POSX        = x axis to begin copy to the screen
;			$S_POSY        = y axis to begin copy to the screen
;	Example ; Smooth($hdc, 0, 0, $fx1, $fx2)
;###################################################################################################################################
Func Smooth($S_Destination, $S_POSX, $S_POSY, $S_Source1, $S_Source2)
	DllCall($S_DLL, "long", "Smooth", _
					"long", $S_Destination, _
					"long", $S_POSX, _
					"long", $S_POSY, _
					"long", $S_Source1, _
					"long", $S_Source2)
EndFunc
;###################################################################################################################################
;	Effect Merge
;	syntax : Merge(Alias1, Alias2, offsetX, offsetY, $Flag)
;	Note ;  melt 2 picture's to 1 picture
;			$flag 0-3
;			0= normal copie
;			1= Antialiasing
;			2= ?
;			3= ?
;###################################################################################################################################
Func Merge($S_Source1, $S_Source2, $S_offsetX, $S_offsetY, $S_Flag)
	$S_Merge = DllCall($S_DLL, "long", "Merge", _
							   "long", $S_Source1, _
							   "long", $S_Source2, _
							   "long", $S_Flag)
	Return $S_Merge[0]
EndFunc
;###################################################################################################################################
;	Effect Sharpen
;	syntax : Sharpen($S_Destination, $S_POSX, $S_POSY, $S_Source, $S_VALUE)
;	Note   ; $S_Destination = $hdc (window) or bitmap in memmory created by CreateImage()
;			 if $S_Destination = 0 then the Effect on the image stays in memmory
;			 $S_POSX, $S_POSY = offset to copie
;			 $S_Source = bitmap source data
;			 ValueEffect = 1 to 256  ; higher is more effect
;###################################################################################################################################
Func Sharpen($S_Destination, $S_POSX, $S_POSY, $S_Source)
	DllCall($S_DLL, "long", "Sharpen", _
					"long", $S_Destination, _
					"long", $S_POSX, _
					"long", $S_POSY, _
					"long", $S_Source)
EndFunc
;###################################################################################################################################
;	Effect Darken
;	syntax : Darken($S_Destination, $S_POSX, $S_POSY, $S_Source, $S_VALUE)
;	Note   ; $S_Destination = $hdc (window) or bitmap in memmory created by CreateImage()
;			 if $S_Destination = 0 then the Effect on the image stays in memmory
;			 $S_POSX, $S_POSY = offset to copie
;			 $S_Source = bitmap source data
;			 ValueEffect = 1 to 256  ; higher is more effect
;###################################################################################################################################
Func Darken($S_Destination, $S_POSX, $S_POSY, $S_Source, $S_VALUE)
		DllCall($S_DLL, "long", "Darken", _
						"long", $S_Destination, _
						"long", $S_POSX, _
						"long", $S_POSY, _
						"long", $S_Source, _
						"long", $S_VALUE)
EndFunc
;###################################################################################################################################
;	Effect Lighten
;	syntax : Lighten($S_Destination, $S_POSX, $S_POSY, $S_Source, $S_VALUE)
;	Note   ; $S_Destination = $hdc (window) or bitmap in memmory created by CreateImage()
;			 if $S_Destination = 0 then the Effect on the image stays in memmory
;			 $S_POSX, $S_POSY = offset to copie
;			 $S_Source = bitmap source data
;			 ValueEffect = 1 to 256  ; higher is more effect
;###################################################################################################################################
Func Lighten($S_Destination, $S_POSX, $S_POSY, $S_Source, $S_VALUE)
		DllCall($S_DLL, "long", "Lighten", _
						"long", $S_Destination, _
						"long", $S_POSX, _
						"long", $S_POSY, _
						"long", $S_Source, _
						"long", $S_VALUE)
EndFunc
;###################################################################################################################################
;	Effect Black_White
;	syntax : Black_White($S_Destination, $S_POSX, $S_POSY, $S_Source, $S_VALUE)
;	Note   ; $S_Destination = $hdc (window) or bitmap in memmory created by CreateImage()
;			 if $S_Destination = 0 then the Effect on the image stays in memmory
;			 $S_POSX, $S_POSY = offset to copie
;			 $S_Source = bitmap source data
;			 ValueEffect = -127 to +127
;###################################################################################################################################
Func Black_White($S_Destination, $S_POSX, $S_POSY, $S_Source, $S_VALUE)
		DllCall($S_DLL, "long", "BlackWhite", _
						"long", $S_Destination, _
						"long", $S_POSX, _
						"long", $S_POSY, _
						"long", $S_Source, _
						"long", $S_VALUE)
EndFunc
;###################################################################################################################################
;	Effect Semi_trans Needs 2 pictures loaded with Function Loadimage()
;	syntax : Semi_trans($S_Destination, $S_Source1, $S_Source2, $S_POSX, $S_POSY, $S_VALUE)
;	Note ;  $S_Source1 = String created by Function LoadImage()
;			$S_Source2 = String created by Function LoadImage()
;			$S_Source1 & $S_Source2 pictures loaded with Function LoadImage() must have same dimensions widht and height
;			$S_POSX and $S_POSY are the position's where the picture is copy to the window
;			$S_VALUE = 1 to 100
;###################################################################################################################################
Func Semi_trans($S_Destination, $S_Source1, $S_Source2, $S_POSX, $S_POSY, $S_VALUE)
		DllCall($S_DLL, "long", "SemiTrans", _
						"long", $S_Destination, _
						"long", $S_POSX, _
						"long", $S_POSY, _
						"long", $S_Source1, _
						"long", $S_Source2, _
						"long", $S_VALUE)
EndFunc
;###################################################################################################################################
;	IniFog()
;	syntax : IniFog()
;	Note ;  Need to be loaded before Function Fog($S_Alias, $S_POSX, $S_POSY)
;			No parameters required
;###################################################################################################################################
Func IniFog()
	$S_BMP1 = DllCall($S_DLL, "long", "CreateImage", _
							  "long", $hDC, _
							  "long", $S_WIDTH[0], _
							  "long", $S_HEIGHT[0])
	$S_BMP2 = DllCall($S_DLL, "long", "CreateImage", _
							  "long", $hDC, _
							  "long", $S_WIDTH[0], _
							  "long", $S_HEIGHT[0])
	$S_FXHANDLE1 = DllCall($S_DLL, "long", "InitFX", "long", $S_BMP1[0])
	$S_FXHANDLE2 = DllCall($S_DLL, "long", "InitFX", "long", $S_BMP2[0])
	$S_FXHANDLE1 = $S_FXHANDLE1[0]
	$S_FXHANDLE2 = $S_FXHANDLE2[0]
EndFunc
;###################################################################################################################################
;	Effect Fog Needs Function IniFog() first
;	syntax : Fog($S_Destination, $S_POSX, $S_POSY, $S_Source)
;	Note ;  $S_Destination = $hdc (window) or bitmap in memmory created by CreateImage()
;			$S_Source = String created by Function LoadImage() must be Picture type *.png
;			The White regions let the Effect thrue , de black regions blocks the effect
;			$S_POSX and $S_POSY are the position's where the picture is copy to the window
;			The Effect becomes only visible true a loop
;			Example;
;			$Mask = LoadImage("C:\Mask.png", 0, 0)
;			IniFog()
;			While 1
;				Fog($hdc, 0, 0, $Mask)
;			Wend
;###################################################################################################################################
Func Fog($S_Destination, $S_POSX, $S_POSY, $S_Source1, $S_Source2, $S_Mask)
	DllCall($S_DLL, "long", "Fog", _
					"long", $S_Destination, _
					"long", $S_POSX, _
					"long", $S_POSY, _
					"long", $S_Source1, _
					"long", $S_Source2, _
					"long", $S_Mask)
EndFunc
;###################################################################################################################################
;	Effect Grey
;	syntax : Grey($S_Destination, $S_POSX, $S_POSY, $S_Source)
;	Note   ; $S_Destination = $hdc (window) or bitmap in memmory created by CreateImage()
;			 if $S_Destination = 0 then the Effect on the image stays in memmory
;			 $S_POSX, $S_POSY = offset to copie
;			 $S_Source = bitmap source data
;###################################################################################################################################
Func Grey($S_Destination, $S_POSX, $S_POSY, $S_Source)
		DllCall($S_DLL, "long", "Grey", _
						"long", $S_Destination, _
						"long", $S_POSX, _
						"long", $S_POSY, _
						"long", $S_Source)
EndFunc
;###################################################################################################################################
;	Function IniRotate()
;	syntax : IniRotate()
;	Note ;  Need to be loaded before Function Rotate($S_Alias, $S_POSX, $S_POSY, $S_DEGREE)
;			No parameters required
;###################################################################################################################################
Func IniRotate()
	$BACK = DllCall($S_DLL, "long", "CreateImage", _
							"long", $hDC, _
							"long", $S_WIDTH[0], _
							"long", $S_HEIGHT[0])
	$S_InitFX1 = DllCall($S_DLL, "long", "InitFX", "long", $BACK[0])
	Dim $S_InitFX1 = $S_InitFX1[0]
EndFunc
;###################################################################################################################################
;	Effect Rotate
;	syntax : Rotate(Alias, POS X, POS Y, DEGREE)
;	Note ;  Alias = String created by Function LoadImage()
;			POS X and POS Y are the position's where the picture is copy to the window
;			DEGREE 0 to 360
;###################################################################################################################################
Func Rotate($S_Destination, $S_POSX, $S_POSY, $S_Source1, $S_Source2, $S_DEGREE, $S_Mode)
		DllCall($S_DLL, "long", "Rotate", _
						"long", $S_Destination, _
						"long", $S_POSX, _
						"long", $S_POSY, _
						"long", $S_Source1, _
						"long", $S_Source2, _
						"long", $S_DEGREE, _
						"long", $S_Mode)
EndFunc
;###################################################################################################################################
;
;
;###################################################################################################################################
Func Rotate180($S_Destination, $S_POSX, $S_POSY, $S_Source)
	DllCall($S_DLL, "long", "Rotate180", _
					"long", $S_Destination, _
					"long", $S_POSX, _
					"long", $S_POSY, _
					"long", $S_Source)
EndFunc
;###################################################################################################################################
;
;
;###################################################################################################################################
Func RotateImage($S_Destination, $S_POSX, $S_POSY, $S_Width, $S_Height, $S_Source, $S_POSX2, $S_POSY2, $S_Degree, $S_Mode)
	DllCall($S_DLL, "long", "RotateImage", _
					"long", $S_Destination, _
					"long", $S_POSX, _
					"long", $S_POSY, _
					"long", $S_Width, _
					"long", $S_Height, _
					"long", $S_Source, _
					"long", $S_POSX2, _
					"long", $S_POSY2, _
					"long", $S_Degree, _
					"long", $S_Mode)
EndFunc
;###################################################################################################################################
;
;
;###################################################################################################################################
Func FlipX($S_Destination, $S_POSX, $S_POSY, $S_Source)
	DllCall($S_DLL, "long", "FlipX", _
					"long", $S_Destination, _
					"long", $S_POSX, _
					"long", $S_POSY, _
					"long", $S_Source)
EndFunc
;###################################################################################################################################
;
;
;###################################################################################################################################
Func FlipY($S_Destination, $S_POSX, $S_POSY, $S_Source)
	DllCall($S_DLL, "long", "FlipY", _
					"long", $S_Destination, _
					"long", $S_POSX, _
					"long", $S_POSY, _
					"long", $S_Source)
EndFunc
;###################################################################################################################################
;	Effect AlphaTrans
;	syntax : AlphaTrans(Alias1, Alias2, Alias_MASK, POS X, POS Y)
;	Note ;  Alias1 = String created by Function LoadImage()
;		    Alias2 = String created by Function LoadImage()
;		    Alias_MASK = String created by Function LoadImage()  must be type (.png) and Black & White
;			All PICTURES must have the same dimensions Width & Height
;			You can Alias2 leave empty like "Mask(Alias1, "", Alias_MASK, POS X, POS Y)"
;			Then the effect will be copied to a black bitmap on screen
;			POS X and POS Y are the position's where the picture is copy to the window
;###################################################################################################################################
Func AlphaTrans($S_Destination, $S_POSX, $S_POSY, $S_Source1, $S_Source2, $S_SourceMASK)
		DllCall($S_DLL, "long", "AlphaTrans", _
						"long", $S_Destination, _
						"long", $S_POSX, _
						"long", $S_POSY, _
						"long", $S_Source1, _
						"long", $S_Source2, _
						"long", $S_SourceMASK)
		DllCall($S_DLL, "long", "PaintImage", _
						"long", $S_fensterkopie1[0], _
						"long", 0, _
						"long", 0, _
						"long", $S_WIDTH[0], _
						"long", $S_HEIGHT[0], _
						"long", $hDC, _
						"long", 0, _
						"long", 0, _
						"long", 0)
EndFunc
;###################################################################################################################################
;	Function IniRustle
;	syntax : $RUSTLE1 = IniRustle(WIDTH, HEIGHT)
;	Note ;  creates Empty bitmap for Rustle Effect
;			WIDTH, HEIGHT = how big the Rustle Effect will be
;	RETURN handle for Rustle effect
;###################################################################################################################################
Func IniRustle($P_WIDTH, $P_HEIGHT)
	$S_hdc1 = DllCall($S_DLL, "long", "CreateImage", _
							  "long", $hDC, _
							  "long", $P_WIDTH, _
							  "long", $P_HEIGHT)
	$S_InitFX = DllCall($S_DLL, "long", "InitFX", "long", $S_hdc1[0])
	Return $S_InitFX[0]
EndFunc
;###################################################################################################################################
;	Effect Rustle
;	syntax : Rustle($S_Rustle, PosX, PosY)
;	Note ;  creates Rustle Effect
;			$S_Rustle = return string from IniRustle
;			PosX and PosY are the position's where the effect is copy to the window
;###################################################################################################################################
Func Rustle($S_Rustle, $S_POSX, $S_POSY)
	DllCall($S_DLL, "long", "Rustle", _
					"long", $hDC, _
					"long", $S_POSX, _
					"long", $S_POSY, _
					"long", $S_Rustle)
EndFunc

;###################################################################################################################################
;SPITES
;###################################################################################################################################

;###################################################################################################################################
;	Background
;	syntax : Background("PICTURE", POS X, POS Y, new WIDTH, new HEIGHT)
;	Note ; "PICTURE" = path to picturefile can be (.bmp, .jpg, .gif, .png, .wmf)
;			POS X and POS Y are the position's where the picture is copy to the window
;			new WIDTH / new HEIGHT = new width and height for background image
;###################################################################################################################################
Func Background($S_FILE, $S_POSX, $S_POSY, $N_WIDTH, $N_HEIGHT)
	$WIN_TILLE     = WinGetTitle("","")
	If $hDC <> 0 Then
		;
	Else
		$WIN_GETHANDLE = WinGetHandle($WIN_TILLE,"")
		$RAW_HDC       = DllCall("user32.dll","ptr","GetDC","hwnd",$WIN_GETHANDLE)
		$hDC           = "0x" & Hex($RAW_HDC[0])
	EndIf

	$S_background = DllCall($S_DLL, "long", "LoadFileImage", "str" ,$S_FILE)
	$S_WIDTH      = DllCall($S_DLL, "long", "GetWidthImage" , "long",$S_background[0])
	$S_HEIGHT     = DllCall($S_DLL, "long", "GetHeightImage", "long",$S_background[0])

	$C_createBMP = DllCall($S_dll, "long", "CreateImage", "long", $hDC, "long", $N_WIDTH, "long", $N_HEIGHT)
	DllCall($S_dll,"long","SizeImage", "long",$C_createBMP[0], _
									   "long",0, _
									   "long",0, _
									   "long",$N_WIDTH, _
									   "long",$N_HEIGHT, _
									   "long",$S_background[0], _
									   "long",0, _
									   "long",0, _
									   "long",$S_WIDTH[0], _
									   "long",$S_HEIGHT[0], _
									   "long",0)
	DllCall($S_DLL, "long", "PaintImage", "long",$hdc, _
										  "long",0, _
										  "long",0, _
										  "long",$N_WIDTH, _
										  "long",$N_HEIGHT, _
										  "long",$C_createBMP[0], _
										  "long",0, _
										  "long",0, _
										  "long",0)
	$S_fensterkopie1 = DllCall($S_DLL, "long", "CreateImage", "long", $hDC, "long", $N_WIDTH, "long", $N_HEIGHT)
	$S_fensterkopie2 = DllCall($S_DLL, "long", "CreateImage", "long", $hDC, "long", $N_WIDTH, "long", $N_HEIGHT)
	DllCall($S_DLL, "long", "PaintImage", "long", $S_fensterkopie1[0], _
										  "long",0, _
										  "long",0, _
										  "long",$N_WIDTH, _
										  "long",$N_HEIGHT, _
										  "long",$hDC, _
										  "long",0, _
										  "long",0, _
										  "long",0)
	DllCall($S_DLL, "long", "PaintImage", "long", $S_fensterkopie2[0], _
										  "long",0, _
										  "long",0, _
										  "long",$N_WIDTH, _
										  "long",$N_HEIGHT, _
										  "long",$hDC, _
										  "long",0, _
										  "long",0, _
										  "long",0)
	$S_WIDTH[0]  = $N_WIDTH
	$S_HEIGHT[0] = $N_HEIGHT
	Return $C_createBMP[0]
EndFunc
;###################################################################################################################################
;	GetDesktopHDC
;	syntax : GetDesktopHDC()
;	get's the
;	for sprites ,for displaying sprites on the desktop without a gui
;###################################################################################################################################
Func GetDesktopHDC()
	$S_ProgMan  = DllCall("user32.dll","hwnd","FindWindow","str","Progman","str","Program Manager")
	$S_Shell    = DllCall("user32.dll","hwnd","FindWindowEx","hwnd",$S_ProgMan[0],"int",0,"hwnd","SHELLDLL_DefView","int",0)
	$S_listView = DllCall("user32.dll","hwnd","FindWindowEx","hwnd",$S_Shell[0],"int",0,"hwnd","SysListView32","str","FolderView")
	$HDC        = DllCall("user32.dll","ptr","GetDC","hwnd",$S_listView[0])
	$hDC = $hDC[0]
	Return $hDC
EndFunc
;###################################################################################################################################
;	GetHDC
;	syntax : GetHDC()
;	get's the HDC for the active window
;###################################################################################################################################
Func GetHDC()
	Local $S_WIN_TILLE     = WinGetTitle("", "")
	Local $S_ClientSize    = WinGetClientSize($S_WIN_TILLE, "")
	Local $S_WIN_GETHANDLE = WinGetHandle($S_WIN_TILLE, "")
	Local $S_RAW_HDC = DllCall("user32.dll", "ptr", "GetDC", "hwnd", $S_WIN_GETHANDLE)
	$hDC = "0x" & Hex($S_RAW_HDC[0])
	Return $hDC
EndFunc
;###################################################################################################################################
;	BackgroundScroll
;	syntax : BackgroundScroll("PICTURE", Xoffset, Yoffset, XDirection, YDirection)
;	Note ; "PICTURE" = path to picturefile can be (.bmp, .jpg, .gif, .png, .wmf)
;			Xoffset and Yoffset are the position's where the picture is copy to the window
;			XDirection = Direction to scroll to left or right
;			1 = scroll to right
;			-1 = scroll to left
;			0 = no scrolling
;			YDirection = Direction to scroll to up or down
;			1 = scroll to up
;			-1 = scroll to down
;			0 = no scrolling
;###################################################################################################################################
Func BackgroundScroll($S_FILE, $S_Xoffset, $S_Yoffset, $S_XDirection, $S_YDirection)
	$WIN_TILLE     = WinGetTitle("", "")
	$ClientSize    = WinGetClientSize($WIN_TILLE, "")
	$WIN_GETHANDLE = WinGetHandle($WIN_TILLE, "")
	$RAW_HDC = DllCall("user32.dll", "ptr", "GetDC", "hwnd", $WIN_GETHANDLE)
	$hDC     = "0x" & Hex($RAW_HDC[0])

	$S_background = DllCall($S_DLL, "long", "LoadFileImage", "str" , $S_FILE)
	$S_WIDTH      = DllCall($S_DLL, "long", "GetWidthImage" , "long", $S_background[0])
	$S_HEIGHT     = DllCall($S_DLL, "long", "GetHeightImage", "long", $S_background[0])

	DllCall($S_DLL, "long", "PaintImage", _
					"long", $hDC, _
					"long", 0, _
					"long", 0, _
					"long", $S_WIDTH[0], _
					"long", $S_HEIGHT[0], _
					"long", $S_background[0], _
					"long", 0, _
					"long", 0, _
					"long", 0)
	$S_fensterkopie1 = DllCall($S_DLL, "long", "CreateImage", "long", $hDC, "long", $S_WIDTH[0], "long", $S_HEIGHT[0])
	$S_fensterkopie2 = DllCall($S_DLL, "long", "CreateImage", "long", $hDC, "long", $S_WIDTH[0], "long", $S_HEIGHT[0])
	DllCall($S_DLL, "long", "PaintImage", _
					"long", $S_fensterkopie1[0], _
					"long",0, _
					"long",0, _
					"long",$S_WIDTH[0], _
					"long",$S_HEIGHT[0], _
					"long",$S_background[0], _
					"long",0, _
					"long",0, _
					"long",0)
	DllCall($S_DLL, "long", "PaintImage", _
					"long", $S_fensterkopie2[0], _
					"long",0, _
					"long",0, _
					"long",$S_WIDTH[0], _
					"long",$S_HEIGHT[0], _
					"long",$S_background[0], _
					"long",0, _
					"long",0, _
					"long",0)
	DllCall($S_DLL, "long", "InitSpriteBackground", _
					"long",1, _
					"long",$ClientSize[0], _
					"long",$ClientSize[1], _
					"long",$S_Xoffset, _
					"long",$S_Yoffset, _
					"long",$S_XDirection, _
					"long",$S_YDirection)
	DllCall($S_DLL, "long", "InitSpriteBackground", _
					"long",888888, _
					"long",888888, _
					"long",888888, _
					"long",888888, _
					"long",888888, _
					"long",0, _
					"long",0)
	Return $S_background[0]
EndFunc
;###################################################################################################################################
;	updatescroll
;	syntax : updatescroll()
;	Note ;  No parameters required
;			For using BackgroundScroll()
;			updatescroll() must be in a mainloop, it update's the screen for WM_PAINT
;###################################################################################################################################
Func updatescroll()
	$S_fensterkopie1 = DllCall($S_DLL, "long", "CreateImage", _
									   "long", $hDC, _
									   "long", $S_WIDTH[0], _
									   "long", $S_HEIGHT[0])
EndFunc
;###################################################################################################################################
;	Scroll_Left
;	syntax : Scroll_Left(2)
;	Note ; $S_Speed = how fast to scroll Positive number
;		Scrolls the background to left
;###################################################################################################################################
Func Scroll_Left($S_Speed)
	DllCall($S_DLL, "long", "InitSpriteBackground", _
					"long", 888888, _
					"long", 888888, _
					"long", 888888, _
					"long", 888888, _
					"long", 888888, _
					"long", $S_Speed, _
					"long", 0)
EndFunc
;###################################################################################################################################
;	Scroll_Right
;	syntax : Scroll_Right(-4)
;	Note ; $S_Speed = how fast to scroll must be a Negative number
;		Scrolls the background to Right
;###################################################################################################################################
Func Scroll_Right($S_Speed)
	DllCall($S_DLL, "long", "InitSpriteBackground", _
					"long", 888888, _
					"long", 888888, _
					"long", 888888, _
					"long", 888888, _
					"long", 888888, _
					"long", $S_Speed, _
					"long", 0)
EndFunc
;###################################################################################################################################
;	Scroll_Stop
;	syntax : Scroll_Stop()
;	Note ; No parameters required
;		Stops scrolling
;###################################################################################################################################
Func Scroll_Stop()
	DllCall($S_DLL, "long", "InitSpriteBackground", _
					"long", 888888, _
					"long", 888888, _
					"long", 888888, _
					"long", 888888, _
					"long", 888888, _
					"long", 0, _
					"long", 0)
EndFunc
;###################################################################################################################################
;	Scroll_Up
;	syntax : Scroll_Up(-3)
;	Note ; $S_Speed = how fast to scroll must be a Negative number
;		Scrolls the background Up
;###################################################################################################################################
Func Scroll_Up($S_Speed)
	DllCall($S_DLL, "long", "InitSpriteBackground", _
					"long", 888888, _
					"long", 888888, _
					"long", 888888, _
					"long", 888888, _
					"long", 888888, _
					"long", 0, _
					"long", $S_Speed)
EndFunc
;###################################################################################################################################
;	Scroll_Down
;	syntax : Scroll_Down(3)
;	Note ; $S_Speed = how fast to scroll must be a Positive number
;		Scrolls the background Down
;###################################################################################################################################
Func Scroll_Down($S_Speed)
	DllCall($S_DLL, "long", "InitSpriteBackground", _
					"long", 888888, _
					"long", 888888, _
					"long", 888888, _
					"long", 888888, _
					"long", 888888, _
					"long", 0, _
					"long", $S_Speed)
EndFunc
;###################################################################################################################################
;	GetBackgroundInfos
;	syntax : $GetInfo = GetBackgroundInfos($S_value)
;	Note ; No parameters required
;		   Strings return;
;		   1) return if Background is scrolling return type (0 or 1)
;		   2) returns window width
;		   3) returns window height
;		   4) returns X offset of background scroll
;		   5) returns Y offset of background scroll
;		   6) returns Speed of background scroll on X axis
;		   7) returns Speed of background scroll on Y axis
;	return = value of BackgroundInfos
;###################################################################################################################################
Func GetBackgroundInfos($S_value)
	$B_BackgroundInfos = DllStructCreate("long;long;long;long;long;long;long")
	DllCall($S_DLL, "long", "GetBackgroundInfos", "long", DllStructGetPtr($B_BackgroundInfos))
	$S_Info = DllStructGetData($B_BackgroundInfos, $S_value)
	Return $S_Info
EndFunc
;###################################################################################################################################
;	Water
;	syntax : Water(Destination, $Offset_X, $Offset_Y, $S_Source, $S_DATA, $S_VertJump)
;	Note ; Destination = where to copy effect to , mostly hdc autoit window
;		   $Offset_X = How many pixels from left of the window to start the water effect
;		   $Offset_Y = How many pixels from top of the window to start the water effect
;		   $S_Source = the picture array
;		   $S_DATA   = Datastring (String to create horizotal waves) or -1
;					   Datastring = $data(0,0,0,0,0,0,0,0,1,1,1,1,1,1,2,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,4,4,4,3,3,2,1,255)
;					   End of string must be 255
;					   -1 = waterEffect use hardcoded string
;			$S_VertJump = Offset pixel for vertical water effect
;
;		   This function must be in a loop and must be called every time
;	example ; $pic = LoadFileImage("your picture")
;			  $fx = InitFX($pic)
;			  For $i = 1 To 100
;				Water($hDC, 0, 0, $fx, -1, 50)
;				Sleep(50)
;			  Next
;###################################################################################################################################
Func Water($S_Destination, $Offset_X, $Offset_Y, $S_Source, $S_DATA, $S_VertJump)
	If $S_DATA = -1 Then
		$S_Pointer = 0
	Else
		Local $S_STRUCTs = ""
		$_tmpDATA = StringSplit($S_DATA, ",")
		For $i = 1 To $_tmpDATA[0]
			$S_STRUCTs &= "long;"
		Next
		$S_STRUCT = DllStructCreate($S_STRUCTs)
		For $i = 1 To $_tmpDATA[0]
			DllStructSetData($S_STRUCT, $i, $_tmpDATA[$i])
		Next
		$S_Pointer = DllStructGetPtr($S_STRUCT)
	EndIf
	DllCall($S_DLL, "long", "Water", _
					"long", $S_Destination, _
					"long", $Offset_X, _
					"long", $Offset_Y, _
					"long", $S_Source, _
					"long", $S_Pointer, _
					"long", $S_VertJump)
EndFunc
;###################################################################################################################################
;	Tiles
;	syntax; SetTiles($W_WIDTH, $W_HEIGHT, $S_mapfile, $S_tiles_bmp, $S_posx, $S_posy, $YT_offset, $S_AX, $S_AY, $S_tileWidth, $S_tileheight, $S_tilemap_width, $S_tileX_Offset, $S_tileY_Offset, $S_DATA)
;	$W_WIDTH   = Window Width
;	$W_HEIGHT  = Window height
;	$S_mapfile = Path to mapdata file with .map extention (mappy tiles editor can save .map files) http://www.tilemap.co.uk/)
;	$S_tiles_bmp = path to tiles picture
;	$S_posx and $S_posy = start position in the window
;	$YT_offset = is the y offset in the tile picture
;	$S_AX = how many tiles should be copied to the screen on the X axis
;	$S_AY = how many tiles should be copied to the screen on the Y axis
;	$S_tileWidth = how Width the tile is
;	$S_tileheight = how height tje tile is
;	$S_tilemap_width = how width the tilemap is
;	$S_tileX_Offset = the offset in the tile.bmp on the X axis
;	$S_tileY_Offset = the offset in the tile.bmp on the Y axis
;	Example; $S_DATA = "2,3,4,9,11,16,17,18,45,1111" <1111 = end of data>
;	tiles with trees or houses are much higher than grass or water tiles,
;	so the udf copies a secound number of tiles over the existing tiles specified by $S_DATA
;###################################################################################################################################
Func SetTiles($W_WIDTH, $W_HEIGHT, $S_mapfile, $S_tiles_bmp, $S_posx, $S_posy, $YT_offset, $S_AX, $S_AY, $S_tileWidth, $S_tileheight, $S_tilemap_width, $S_tileX_Offset, $S_tileY_Offset, $S_DATA="")
	$WIN_TILLE = WinGetTitle("","")
	If $hDC <> 0 Then
		;
	Else
		$WIN_GETHANDLE = WinGetHandle($WIN_TILLE,"")
		$RAW_HDC       = DllCall("user32.dll","ptr","GetDC","hwnd",$WIN_GETHANDLE)
		$hDC           = "0x" & Hex($RAW_HDC[0])
	EndIf

	If $S_DATA <> "" Then
		$_tmpDATA = StringSplit($S_DATA, ",")
		Local $S_STRUCTs = ""
		For $i = 1 To $_tmpDATA[0]
			$S_STRUCTs &= "short;"
		Next
			$S_STRUCT = DllStructCreate($S_STRUCTs)
		For $i = 1 To $_tmpDATA[0]
			DllStructSetData($S_STRUCT, $i, $_tmpDATA[$i])
		Next
	EndIf

	$S_size   = FileGetSize($S_mapfile)
	$S_char   = "char["&$S_size&"]"
	$S_map    = DllStructCreate($S_char)
	DllCall($S_DLL, "long", "ReadFileFast", _
					"str",$S_mapfile, _
					"long",DllStructGetPtr($S_map), _
					"long",0, _
					"long",$S_size)

	$S_fensterkopie1 = DllCall($S_DLL, "long","CreateImage", _
									   "long",$hDC, _
									   "long",$W_WIDTH, _
									   "long",$W_HEIGHT)

	$S_WIDTH  = DllCall($S_DLL, "long", "GetWidthImage", _
								"long", $S_fensterkopie1[0])
	$S_HEIGHT = DllCall($S_DLL, "long", "GetHeightImage", _
								"long", $S_fensterkopie1[0])

	$S_Image   = DllCall($S_DLL, "long", "LoadFileImage", _
								 "str", $S_tiles_bmp)

	DllCall($S_dll,"long", "SetTiles", _
				   "long", $S_Image[0], _
				   "long", $YT_offset, _
				   "long", $S_AX, _
				   "long", $S_AY, _
				   "long", $S_tileWidth, _
				   "long", $S_tileheight, _
				   "long", DllStructGetPtr($S_map), _
				   "long", $S_tilemap_width, _
				   "long", $S_posx, _
				   "long", $S_posy, _
				   "long", $S_fensterkopie1[0], _
				   "long", $S_tileX_Offset, _
				   "long", $S_tileY_Offset, _
				   "long", 0, _
				   "long", 0)
	If $S_DATA <> "" Then
		DllCall($S_dll,"long","SetTiles", _
					   "long",$S_Image[0], _
					   "long",0, _
					   "long",$S_AX, _
					   "long",$S_AY, _
					   "long",$S_tileWidth, _
					   "long",$S_tileheight, _
					   "long",DllStructGetPtr($S_map), _
					   "long",$S_tilemap_width, _
					   "long",$S_posx, _
					   "long",$S_posy, _
					   "long",$S_fensterkopie1[0], _
					   "long",$S_tileX_Offset, _
					   "long",$S_tileY_Offset-$S_tileheight, _
					   "long",-1, _
					   "long",DllStructGetPtr($S_STRUCT))
	EndIf
	DllCall($S_DLL, "long","PaintImage", _
					"long",$hDC, _
					"long",0, _
					"long",0, _
					"long",$S_WIDTH[0], _
					"long",$S_HEIGHT[0], _
					"long",$S_fensterkopie1[0], _
					"long",0, _
					"long",0, _
					"long",0)
	$S_STRUCT = ""
	$S_char   = ""
	DllCall($S_DLL, "long", "FreeImage", "long", $S_Image[0])
	DllCall($S_DLL, "long", "FreeImage", "long", $S_fensterkopie1[0])
EndFunc
;###################################################################################################################################
;	loadsprite
;	syntax : $spaceship1 = loadsprite("Picture.gif")
;	Note ;  Needs a user defined string before the func
;			Picture = path to picturefile can be (.bmp, .jpg, .gif, .png, .wmf)
;###################################################################################################################################
Func loadsprite($S_SPRITE_PIC)
	$S_Spriteplane = DllCall($S_DLL, "long", "LoadFileImage", "str", $S_SPRITE_PIC)
	Return $S_Spriteplane[0]
EndFunc
;###################################################################################################################################
;	loadspriteResize
;	syntax : $spaceship1 = loadspriteResize("Picture.gif", new width, new height)
;	Note ;  Needs a user defined string before the func
;			Picture = path to picturefile can be (.bmp, .jpg, .gif, .png, .wmf)
;###################################################################################################################################
Func loadspriteResize($S_SPRITE_PIC, $Np_WIDTH, $Np_HEIGHT)
	$S_Spriteplane = DllCall($S_DLL, "long", "LoadFileImage", "str", $S_SPRITE_PIC)
	$Sp_WIDTH  = DllCall($S_DLL, "long", "GetWidthImage", "long", $S_Spriteplane[0])
	$Sp_HEIGHT = DllCall($S_DLL, "long", "GetHeightImage", "long", $S_Spriteplane[0])

	$C_createBMP2 = DllCall($S_dll, "long", "CreateImage", _
								   "long", $hdc, _
								   "long", $Np_WIDTH, _
							       "long", $Np_HEIGHT)
	DllCall($S_dll, "long", "SizeImage", _
					"long", $C_createBMP2[0], _
					"long", 0, _
					"long", 0, _
					"long", $Np_WIDTH, _
					"long", $Np_HEIGHT, _
					"long", $S_Spriteplane[0], _
					"long", 0, _
					"long", 0, _
					"long", $Sp_WIDTH[0], _
					"long", $Sp_HEIGHT[0], _
					"long", 0)
	DllCall($S_DLL, "long", "FreeImage", "long", $S_Spriteplane[0])
	Return $C_createBMP2[0]
EndFunc
;###################################################################################################################################
;	Sprite
;	syntax : $spaceship = Sprite($spaceship1, $S_offsetX, $S_offsetY, WIDTH, HEIGHT, FRAMES, START_FRAME, FRAME_SPEED, posX, posY)
;	Note ;  Needs a user defined string before the func
;			$spaceship1 = string created with funcion loadsprite()
;			$S_offsetX, $S_offsetY = X and Y Position (Offset) of the Spritebitmap, where the Sprite is found
;			WIDTH, HEIGHT = sprite itself in the picture
;			FRAMES = how many sprites are there in the picture
;			FRAME_SPEED = how fast must the animation run
;			POS X and POS Y are the position where the sprite is copyied to the window
;###################################################################################################################################
Func Sprite($S_Spriteplane, $S_offsetX, $S_offsetY, $S_WIDTH, $S_HEIGHT, $S_FRAMES, $S_START_FRAME, $S_FRAME_SPEED, $S_posX, $S_posY)
	$Sprite_ID = DllCall($S_DLL, "long","InitSprite", _
								 "long",$S_Spriteplane, _
								 "long",$hDC, _
								 "long",$S_fensterkopie1[0], _
								 "long",$S_fensterkopie2[0], _
								 "long",$S_offsetX, _
								 "long",$S_offsetY, _
								 "long",$S_WIDTH, _
								 "long",$S_HEIGHT, _
								 "long",$S_FRAMES, _
								 "long",$S_START_FRAME, _
								 "long",$S_FRAME_SPEED, _
								 "long",$S_posX, _
								 "long",$S_posY, _
								 "long",1, _
								 "long",1)
	Return $Sprite_ID[0]
EndFunc
;###################################################################################################################################
;	CopySprite
;	syntax : $new_bee = CopySprite($S_Alias)
;	Note ;  copies a sprite with indentical parameters
;			$S_Alias = user defined string of the sprite created by function Sprite()
;			If you want to make a lot of incentical sprites you better use CopieSprite
;			Create first sprite with Sprite func and then copie that sprite multiple times
;###################################################################################################################################
Func CopySprite($S_Alias)
	$Sprite_ID = DllCall($S_DLL, "long", "CopySprite", "long", $S_Alias)
	Return $Sprite_ID[0]
EndFunc
;###################################################################################################################################
;	Movesprite
;	syntax : Movesprite($S_Alias, $posx, $posy, $S_Speedx, $S_Speedy)
;	Note ;  $S_Alias = user defined string of the sprite created by function Sprite()
;			$posx, $posy = Postion where the sprite has to moved to
;###################################################################################################################################
Func Movesprite($S_Alias, $S_posx, $S_posy)
	DllCall($S_DLL, "long", "MoveSprite", _
					"long", $S_Alias, _
					"long", $S_posx, _
					"long", $S_posy)
EndFunc
;###################################################################################################################################
;    MoveSpriteWithTable
;    syntax : MoveSpriteWithTable($S_Alias, TABLE)
;    Note :  $S_Alias = user defined string of the sprite created by function Sprite()
;           TABLE = String with X- and Y-Positions in the format "X1 Y1 X2 Y2 etc.."
;    Example: MoveSpriteWithTable($Sprite, "0 0 100 0 100 100 0 100") Would move $Sprite in a square
;###################################################################################################################################
Func MoveSpriteWithTable($S_Alias, $S_DATA)
    $S_DATA = StringSplit($S_DATA, " ")
    Local $S_STRUCTs = ""
    For $i = 1 To $S_DATA[0]
        $S_STRUCTs &= "short;"
    Next
    $S_STRUCT = DllStructCreate($S_STRUCTs)
    For $i = 1 To $S_DATA[0]
        DllStructSetData($S_STRUCT, $i, $S_DATA[$i])
    Next
    DllCall($S_DLL, "long", "MoveSpriteWithTable", "long", $S_Alias, "long", DllStructGetPtr($S_STRUCT), "long", $S_DATA[0] /2, "long", 0, "long", 0, "long", 1)
    $S_STRUCT = ""
EndFunc
;###################################################################################################################################
;    SpriteTableMode
;    syntax : SpriteTableMode($S_Alias, MODE)
;    Note :  $S_Alias = user defined string of the sprite created by function Sprite()
;            Mode = 0 / 1
;                0 = Loops a table
;                1 = Loop off
;###################################################################################################################################
Func SpriteTableMode($S_Alias, $S_Mode)
    DllCall($S_DLL, "long", "SpriteTableMode", "long", $S_Alias, "long", $S_Mode)
EndFunc
;###################################################################################################################################
;    Findpath
;    syntax : Findpath($Pic_array, $P_PixelWidth, $S_StartX, $S_StartY, $S_EndpointX, $S_EndpointY)
;    Note :  $Pic_array = mask picture loaded with function LoadImage() last parameter must be 0
;			example ; $Pic = LoadImage("mask5.bmp", 0, 0, 600, 400, 0)
;            $P_PixelWidth = how width is the path (pixel)
;			$S_StartX and $S_StartY = startpoint x and y axis
;			$S_EndpointX and $S_EndpointY = endpoint x and y axis
;	example ; Findpath("mask_pic", 6, 10, 10, 585, 10)
;###################################################################################################################################
Func Findpath($Pic_array, $P_PixelWidth, $S_StartX, $S_StartY, $S_EndpointX, $S_EndpointY)
	$S_Struct_data = DllStructCreate("short[200000]")
	$S_Rz = DllCall($S_DLL, "long", "FindPath", _
							"long", DllStructGetPtr($S_Struct_data), _
							"long", $Pic_array, _
							"long", $P_pixelWidth, _
							"long", $S_StartX, _
							"long", $S_StartY, _
							"long", $S_EndpointX, _
							"long", $S_EndpointY, _
							"long", 0)
	DllCall($S_DLL, "long", "SmoothPath", _
					"long", DllStructGetPtr($S_Struct_data), _
					"long", $S_Rz[0], _
					"long", 2)
	Dim $S_Rz = $S_Rz[0]/4
EndFunc
;###################################################################################################################################
;    MoveSpritePath
;    syntax : MoveSpritePath($S_Alias)
;    Note :  $S_Alias = user defined string of the sprite created by function Sprite()
;	Findpath must be called before MoveSpritePath
;	example ; MoveSpritePath($sprite)
;###################################################################################################################################
Func MoveSpritePath($S_Alias)
	DllCall($S_DLL, "long", "SpriteTableMode", _
					"long", $S_Alias, _
					"long", 1)
	DllCall($S_DLL, "long", "MoveSpriteWithTable", _
					"long", $S_Alias, _
					"long", DllStructGetPtr($S_Struct_data), _
					"long", $S_Rz, _
					"long", 0, _
					"long", 0, _
					"long", 1)
EndFunc
;###################################################################################################################################
;	SetSpriteMovingMode
;	syntax : SetSpriteMovingMode($S_Alias, $S_Mode)
;	Note ;  $S_Alias = user defined string of the sprite created by function Sprite()
;			$S_Mode = 0 / 1
;			0 = Sprite moves first on the y axis then on the x Axis to reach the destination point created by Movesprite()
;			1 = sprite moves direct equal on the Y and X axis to the destination point created by Movesprite()
;###################################################################################################################################
Func SetSpriteMovingMode($S_Alias, $S_Mode)
	DllCall($S_DLL, "long", "SetSpriteMovingMode", _
					"long", $S_Alias, _
					"long", $S_Mode)
EndFunc
;###################################################################################################################################
;	SetSpritePos
;	syntax : SetSpritePos($S_Alias, $posX, $posY, NextposX, NextposY)
;	Note ;  $S_Alias = user defined string of the sprite created by function Sprite()
;			$posX, $posY = position to put sprite onscreen
;			NextposX, NextposY = next X and Y position where sprite has to move to
;###################################################################################################################################
Func SetSpritePos($S_Alias, $S_posx, $S_posy, $S_Nextposx, $S_Nextposy)
	DllCall($S_DLL, "long", "SetSpritePos", _
					"long", $S_Alias, _
					"long", $S_posX, _
					"long", $S_posY, _
					"long", $S_NextposX, _
					"long", $S_NextposY)
EndFunc
;###################################################################################################################################
;	SetSpriteSpeed
;	syntax : SetSpriteSpeed($S_Alias, Speed X, Speed Y)
;	Note ;  $S_Alias = user defined string of the sprite created by function Sprite()
;			Speed X, Speed Y = how fast moving on screen
;###################################################################################################################################
Func SetSpriteSpeed($S_Alias, $S_SpeedX, $S_SpeedY)
	DllCall($S_DLL, "long", "SetSpriteSpeed", _
					"long",$S_Alias, _
					"long",$S_SpeedX, _
					"long",$S_SpeedY)
EndFunc
;###################################################################################################################################
;	SlowDownSprite
;	syntax : SlowDownSprite($S_Alias, Speed X, Speed Y)
;	Note ;  $S_Alias = user defined string of the sprite created by function Sprite()
;			Speed X, Speed Y = slow down sprite on x an y axis
;			use SlowDownSprite($S_Alias, 0, 0) to return to normal speed set by SetSpriteSpeed func
;###################################################################################################################################
Func SlowDownSprite($S_Alias, $S_SpeedX, $S_SpeedY)
	DllCall($S_DLL, "long", "SlowDownSprite", _
					"long",$S_Alias, _
					"long",$S_SpeedX, _
					"long",$S_SpeedY)
EndFunc
;###################################################################################################################################
;	SetSpriteAnimMove
;	syntax : SetSpriteAnimMove($S_Alias, Direction, offsetX, offsetY)
;	Note ;  $S_Alias = user defined string of the sprite created by function Sprite()
;			Direction = The direction to face the sprite to
;			For every direction the sprite moves you can change the animation sequence
;			0 = Standing still
;			1 = right up
;			2 = right
;			3 = right down
;			4 = down
;			5 = left down
;			6 = left
;			7 = left up
;			8 = up
;			offsetX = Where to find the sprite in the bitmap on x position ;Mostly starts with zero
;			offsetY = Where to find the sprite in the bitmap on y position
;###################################################################################################################################
Func SetSpriteAnimMove($S_Alias, $S_direction, $S_offsetX, $S_offsetY)
	DllCall($S_DLL, "long", "SetSpriteAnimMove", _
					"long",$S_Alias, _
					"long",$S_direction, _
					"long",$S_offsetX, _
					"long",$S_offsetY)
EndFunc
;###################################################################################################################################
;	SetSpriteAnimMode
;	syntax : SetSpriteAnimMode(Alias, Mode)
;	Note ; Alias = user defined string of the sprite created by function Sprite()
;		   Mode = 0 / 1
;		   0 = Set anim loop on
;		   1 = Set anim loop off
;###################################################################################################################################
Func SetSpriteAnimMode($S_Alias, $S_Mode)
	DllCall($S_DLL, "long", "SetSpriteAnimMode", _
					"long",$S_Alias, _
					"long",$S_Mode)
EndFunc
;###################################################################################################################################
;	SetSpriteAnim
;	syntax : SetSpriteAnim($S_Alias, offsetX, offsetY, WIDTH, HEIGHT, FRAMES, START_FRAME, FRAME_SPEED)
;	Note ;  This function is pixel accurate
;			$S_Alias = user defined string of the sprite created by function Sprite()
;			$S_offsetX, $S_offsetY = X and Y Position (Offset) of the Spritebitmap, where the Sprite is found
;			WIDTH, HEIGHT = sprite itself in the bitmap
;			FRAMES        = how many frames are there in the bitmap
;			START_FRAME   = which frame to start the animation
;			FRAME_SPEED   = how fast must the animation run ; lower is faster
;###################################################################################################################################
Func SetSpriteAnim($S_Alias, $S_offsetX, $S_offsetY, $S_WIDTH, $S_HEIGHT, $S_FRAMES, $S_START_FRAME, $S_FRAME_SPEED)
	DllCall($S_DLL, "long", "SetSpriteAnim", _
					"long",$S_Alias, _
					"long",$S_offsetX, _
					"long",$S_offsetY, _
					"long",$S_WIDTH, _
					"long",$S_HEIGHT, _
					"long",$S_FRAMES, _
					"long",$S_START_FRAME, _
					"long",$S_FRAME_SPEED)
EndFunc
;###################################################################################################################################
;	GetSpriteAnimModeStatus
;	syntax : $check = GetSpriteAnimModeStatus($S_Alias)
;	Note ;  checks to see if animatie of sprite has ended or not
;	0 = sprite is still Animating
;	1 = Animation has stopped
;###################################################################################################################################
Func GetSpriteAnimModeStatus($S_Alias)
	$GetSpriteAnimModeStatus = DllCall($S_DLL, "long", "GetSpriteAnimModeStatus", "long", $S_Alias)
	Return $GetSpriteAnimModeStatus[0]
EndFunc
;###################################################################################################################################
;	SetSpriteFixMode
;	syntax : SetSpriteFixMode(Alias, Mode)
;	Note ;  Set Sprite animation stop , Collision detection is still present
;			Alias = user defined string of the sprite created by function Sprite()
;			Mode = 0 / 1
;			0 = Sprite moves and Animate
;			1 = Sprite Do not move and animate
;###################################################################################################################################
Func SetSpriteFixMode($S_Alias, $S_Mode)
	DllCall($S_DLL, "long", "SetSpriteFixMode", "long", $S_Alias, "long", $S_Mode)
EndFunc
;###################################################################################################################################
;	GetSpriteFixMode
;	syntax : $getfixmode = SetSpriteFixMode(Alias)
;	Note ;  0 = normal
;			1 = not animated sprite
;###################################################################################################################################
Func GetSpriteFixMode($S_Alias)
	$S_GetSpriteFixMode = DllCall($S_DLL, "long", "GetSpriteFixMode", "long", $S_Alias)
	If @error Then
		Return @error
	Else
		Return $S_GetSpriteFixMode[0]
	EndIf
EndFunc
;###################################################################################################################################
;	CountSprites
;	syntax : $count = CountSprites()
;	counts all sprites
;###################################################################################################################################
Func CountSprites()
	$countSprites = DllCall($S_DLL, "long", "CountSprites")
	Return $countSprites[0]
EndFunc
;###################################################################################################################################
;	SetSpriteLayer
;	syntax : SetSpriteLayer(Alias, layer)
;	Sets new layer for sprite, means that you can set the sprite to the foreground or background of another sprite
;###################################################################################################################################
Func SetSpriteLayer($S_Alias,$S_layerNum)
	DllCall($S_DLL, "long", "SetSpriteLayer", "long", $S_Alias, "long", $S_layerNum)
	Return @error
EndFunc
;###################################################################################################################################
;	GetSpriteLayer
;	syntax : $getlayer = GetSpriteLayer(Alias)
;	returns the sprite layer
;###################################################################################################################################
Func GetSpriteLayer($S_Alias)
	$S_GetSpriteLayer = DllCall($S_DLL, "long", "GetSpriteLayer", "long", $S_Alias)
	Return $S_GetSpriteLayer[0]
EndFunc
;###################################################################################################################################
;	BringSpriteToTop
;	syntax : BringSpriteToTop(Alias)
;	brings sprite on top of all other sprites
;###################################################################################################################################
Func BringSpriteToTop($S_Alias)
	DllCall($S_DLL, "long", "BringSpriteToTop", "long", $S_Alias)
EndFunc
;###################################################################################################################################
;	BringSpriteToBottom
;	syntax : BringSpriteToBottom(Alias)
;	gives sprite the lowest layer
;###################################################################################################################################
Func BringSpriteToBottom($S_Alias)
	DllCall($S_DLL, "long", "BringSpriteToBottom", "long", $S_Alias)
EndFunc
;###################################################################################################################################
;	SpriteToHDC
;	syntax : SpriteToHDC(Alias)
;	copie sprite to screen, and become part of the window, sprite will not animate anymore
;###################################################################################################################################
Func SpriteToHDC($S_Alias)
	$S_SpriteToHDC = DllCall($S_DLL, "long", "SpriteToHDC", "long", $S_Alias)
	Return $S_SpriteToHDC[0]
EndFunc
;###################################################################################################################################
;
;
;###################################################################################################################################
Func SpriteThreadBrake($M_Seconds)
	DllCall($S_DLL, "long", "SpriteThreadBrake", "long", $M_Seconds)
EndFunc
;###################################################################################################################################
;	$Spritebitmap       	   = 0    sets new sprite bitmap
;	$Offset_X          		   = 4    change X offset in sprite bitmap
;	$Offset_Y          		   = 8    change Y offset in sprite bitmap
;	$HDC_window        		   = 56   change Hdc
;	$Buffer_copie1     		   = 68   change screen buffer for sprite
;	$Buffer_copie2      	   = 84   change screen buffer for sprite
;	$Background_mode     	   = 92   0= background not scrolling / 1= background is scrolling
;	$Background_scroll_X 	   = 96   sets how many pixels the background must scroll on X axis
;	$Background_scroll_Y 	   = 100  sets how many pixels the background must scroll on Y axis
;	$sprite_markNR             = 156  change sprite mark
;	$Start_MoveSpriteWithTable = 312  startpoint for spritemove with table mode
;###################################################################################################################################
Func ChangeSpritePara($S_Alias, $Parameter, $new_value)
	DllCall($S_DLL, "long", "ChangeSpritePara", _
					"long",$S_Alias, _
					"long",$Parameter, _
					"long",$new_value)
EndFunc
;###################################################################################################################################
;	SetmovingRectangle
;	syntax : SetmovingRectangle($S_Alias, LEFT, TOP, RIGHT, BOTTOM)
;	Note ;  $S_Alias = user defined string of the sprite created by function Sprite()
;			LEFT = Left screen position
;			TOP = Top screen position
;			RIGHT = Right screen position
;			BOTTOM = Bottom screen position
;			This creates a cage for the sprites
;			The sprite cannot come outside the cage and is bouncing back when it hits the cage
;			For every sprite you have to create this function
;###################################################################################################################################
Func SetmovingRectangle($S_Alias,$S_LEFT, $S_TOP, $S_RIGHT, $S_BOTTOM)
	DllCall($S_DLL, "long", "SpriteMovingRect", _
					"long",$S_Alias, _
					"long",$S_LEFT, _
					"long",$S_TOP, _
					"long",$S_RIGHT, _
					"long",$S_BOTTOM)
EndFunc
;###################################################################################################################################
;	AtackSprite
;	syntax : AtackSprite($S_Alias1, $S_Alias1, pixel x, pixel y)
;	Note ;  Set sprite nr 1 to attack sprite nr 2
;			$S_Alias1 = user defined string of the sprite created by function Sprite()
;			$S_Alias2 = user defined string of the sprite created by function Sprite()
;			pixel x = amount of pixels to sprite nr 2
;			pixel y = amount of pixels to sprite nr 2
;			If pixel x and y = set to 10 ,sprite nr 1 stays 10 pixels on x and y postion away from sprite nr 2
;			To stop the attack, use; AtackSprite($S_Alias1, 0, 0, 0)
;###################################################################################################################################
Func AtackSprite($S_Alias1, $S_Alias2, $S_DX, $S_DY)
	DllCall($S_DLL, "long", "AttachSprite", _
					"long",$S_Alias1, _
					"long",$S_Alias2, _
					"long",$S_DX, _
					"long",$S_DY)
EndFunc
;###################################################################################################################################
;	Collide
;	syntax : $space1_space2 = Collide($S_Alias1, $S_Alias2)
;	Note ;  let 2 sprites collide
;			$S_Alias1 = user defined string of the sprite created by function Sprite()
;			$S_Alias2 = user defined string of the sprite created by function Sprite()
;	example ;
;			If $space1_space2 <> 0 then func()
;###################################################################################################################################
Func Collide($S_Alias1, $S_Alias2)
	$Collide = DllCall($S_DLL, "long", "Collide", _
							   "long",$S_Alias1, _
							   "long",$S_Alias2)
	Return $Collide[0]
EndFunc
;###################################################################################################################################
;	CollideMore
;	Syntax ; $col = CollideMore()
;	note ; need user defined string for return string
;	$col ;gives sprite collision pointers back or 0
;	0 = no collission detected
;###################################################################################################################################
Func CollideMore($S_Alias)
	$S_STR = "long;long"
	$CollideMoreInfos = DllStructCreate($S_STR)
	$MoreInfos = DllCall($S_DLL, "long", "CollideMore", _
								 "long", DllStructGetPtr($CollideMoreInfos))
	If $MoreInfos[0] <> 0 Then
		$S_HIT   = DllStructGetData($CollideMoreInfos, 2)
		$S_Alias = DllStructGetData($CollideMoreInfos, 1)
		Return $S_HIT
	EndIf
	Return $MoreInfos[0]
EndFunc
;###################################################################################################################################
;	Collision
;	syntax : $bee1_bee2 = Collision($S_Alias1, $S_Alias2, pixel x, pixel y)
;	Note ;  let 2 sprites collide
;			This function is pixel accurate
;			$S_Alias1 = user defined string of the sprite created by function Sprite()
;			$S_Alias2 = user defined string of the sprite created by function Sprite()
;			pixel x = amount of pixels to sprite nr 2 ,must be greater then 0
;			pixel y = amount of pixels to sprite nr 2 ,must be greater then 0
;	example ;
;			If $bee1_bee2 <> 0 then func()
;###################################################################################################################################
Func Collision($S_Alias1, $S_Alias2, $S_pixelX, $S_pixelY)
	$Collision = DllCall($S_DLL, "long", "Collision", _
								 "long",$S_Alias1, _
								 "long",$S_Alias2, _
								 "long",$S_pixelX, _
								 "long",$S_pixelY)
	Return $Collision[0]
EndFunc
;###################################################################################################################################
;	CollideUnknown
;	syntax : $Col = CollideUnknown()
;	Note ;  let multiple sprites collide
;			This function is not pixel accurate
;			No parameters required
;			$col must be user defined string
;			return strings ; $col gives SpritePointer or 0
;				0 = no collission detected
;###################################################################################################################################
Func CollideUnknown()
	$CollideUnknownInfos = DllStructCreate("long;long")
	$UnknownInfos = DllCall($S_DLL, "long", "CollideUnknown", _
									"long", DllStructGetPtr($CollideUnknownInfos))
	If $UnknownInfos <> 0 Then
		$S_HIT = DllStructGetData($CollideUnknownInfos, 2)
		Return $S_HIT
	EndIf
	Return $UnknownInfos[0]
EndFunc
;###################################################################################################################################
;	CollideAll
;	syntax : $col_bee1 = CollideAll($S_Alias)
;	Note ;  This function is not pixel accurate
;			CollideAll let a sprite collide with all other sprites
;			$col_bee1 gives number above 0 if collide with other sprites
;			$col_bee1 must be user defined string
;	example ;
;			if $col_bee1 <> 0 then func()
;###################################################################################################################################
Func CollideAll($S_Alias)
	$CollideAll = DllCall($S_DLL, "long", "CollideAll", "long", $S_Alias)
	Return $CollideAll[0]
EndFunc
;###################################################################################################################################
;	SetBackAutoCollision
;	syntax : SetBackAutoCollision(Alias, Mask, Mode, Width, Height, Sound)
;	Note ;  Automatic Sprite-background collisions function
;			Alias = user defined sprite name made by function sprite()
;			Mask = mask image loaded with funcion LoadImage()
;			Mode =  0 = No Auto-Collision with background
;					1 = Sprite react like a wall
;					2 = Sprite react like a gummiball and bounce away from background
;					3 = Sprite react like mode 2, but Sprite bounce up
;					4 = Sprite react like mode 2, but Sprite bounce right
;					5 = Sprite react like mode 2, but Sprite bounce down
;					6 = Sprite react like mode 2, but Sprite bounce left
;					7 = Sprite get's new animation and will be deleted after animation is ended
;			Width ,Height = image width,Height loaded with funcion LoadImage()
;			Sound = every time a sprite hit's the background a sound can be played
;			parameter for sound = 0 no sound or user defined string contains a loaded sound
;			To load a sound first you need the function; DSoundInit()
;			Then load the sound with function; $explo = DSoundLoad(c:\data\explosion.wav)
;###################################################################################################################################
Func SetBackAutoCollision($S_Alias, $S_Mask, $S_Mode, $SW_Width, $SW_Height, $S_Sound)
	DllCall($S_DLL, "long", "SetBackAutoCollision", _
					"long",$S_Alias, _
					"long",$S_Mask, _
					"long",$S_Mode, _
					"long",0, _
					"long",0, _
					"long",$SW_Width, _
					"long",$SW_Height, _
					"long",0, _
					"long",0, _
					"long",0, _
					"long",$S_Sound)
EndFunc
;###################################################################################################################################
;	MarkSprite
;	syntax : MarkSprite($S_Alias, Number)
;	Note ;  This function marks a sprite
;			$S_Alias = use defined Spritename
;			Number = user defined number
;			example ; MarkSprite($spaceship,125)	,gives $spaceship the number 125
;###################################################################################################################################
Func MarkSprite($S_Alias,$S_number)
	DllCall($S_DLL, "long", "MarkSprite", _
					"long",$S_Alias, _
					"long",$S_number)
EndFunc
;###################################################################################################################################
;	GetSpriteMark
;	syntax : $check = GetSpriteMark($S_Alias)
;	Note ;  This function get's the user defined number of the marked sprite
;			$S_Alias = use defined Spritename
;			$check holds the user defined number
;			$check must be a userdefined string
;###################################################################################################################################
Func GetSpriteMark($S_Alias)
	$S_GetSpriteMark = DllCall($S_DLL, "long", "GetSpriteMark", "long", $S_Alias)
	Return $S_GetSpriteMark[0]
EndFunc
;###################################################################################################################################
;	DeleteSprite
;	syntax : DeleteSprite($S_Alias)
;	Note ;  Delete sprite from window
;###################################################################################################################################
Func DeleteSprite($S_Alias)
	DllCall($S_DLL, "long", "DeleteSprite", "long", $S_Alias)
EndFunc
;###################################################################################################################################
;	DeleteAllSprites
;	syntax : DeleteAllSprites()
;	Note ;  Delete all sprites from window
;###################################################################################################################################
Func DeleteAllSprites()
	DllCall($S_DLL, "long", "DeleteAllSprites")
EndFunc
;###################################################################################################################################
;	DeleteAllSpritesMark
;	syntax : DeleteAllSpritesMark(111)
;	Note ;  Delete all sprites with mark 111
;###################################################################################################################################
Func DeleteSpriteMark($S_Mark)
	DllCall($S_DLL, "long", "DeleteSpritesMark", "long", $S_Mark)
EndFunc
;###################################################################################################################################
;	DeleteSpritesIfAnimReady
;	syntax : DeleteSpritesIfAnimReady()
;	delete sprite when animation seqence has ended
;###################################################################################################################################
Func DeleteSpritesIfAnimReady()
	DllCall($S_DLL, "long", "DeleteSpritesIfAnimReady")
EndFunc
;###################################################################################################################################
;	CleanUp
;	syntax : CleanUp(111)
;	Cleans Sprite tabel in memory for marked sprite
;###################################################################################################################################
Func CleanUp($S_Mark)
	DllCall($S_DLL, "long", "CleanUp", "long", $S_Mark)
EndFunc
;###################################################################################################################################
;	GetSpriteInfos
;	syntax : GetSpriteInfos($S_Alias)
;	Note ;  Returm strings
;			$current_X 		= The current Position X of the sprite on screen
;			$current_Y 		= The current Position Y of the sprite on screen
;			$goal_PosX 		= The Postion X where the sprite go's to called by func movesprite()
;			$goal_PosY 		= The Postion Y where the sprite go's to called by func movesprite()
;			$sprite_arrived = Is sprite arrived on position called by func movesprite() 0 / 1
;			$speedX 		= Current X speed of sprite
;			$speedY 		= Current Y speed of sprite
;			$current_Frame  = Current frame of sprite in bitmap
;			Example;
;					GetSpriteInfos(1)
;					If $sprite_arrived = 1 Then Movesprite(1, 600, 250, 4, 2)
;###################################################################################################################################
Func GetSpriteInfos($S_Alias)
	$GetSpriteInfos = DllStructCreate("long;long;long;long;long;long;long;long")
	DllCall($S_DLL, "long", "GetSpriteInfos", _
					"long",$S_Alias, _
					"long",DllStructGetPtr($GetSpriteInfos))
	$current_X      = DllStructGetData($GetSpriteInfos, 1)
	$current_Y      = DllStructGetData($GetSpriteInfos, 2)
	$goal_PosX      = DllStructGetData($GetSpriteInfos, 3)
	$goal_PosY      = DllStructGetData($GetSpriteInfos, 4)
	$sprite_arrived = DllStructGetData($GetSpriteInfos, 5)
	$speedX         = DllStructGetData($GetSpriteInfos, 6)
	$speedY         = DllStructGetData($GetSpriteInfos, 7)
	$current_Frame  = DllStructGetData($GetSpriteInfos, 8)
EndFunc
;###################################################################################################################################
;	GetSpriteX
;	syntax : GetSpriteX(Alias)
;	Note ;  Get sprite position on the X axis
;###################################################################################################################################
Func GetSpriteX($S_Alias)
	$S_GetX = DllCall($S_DLL, "long", "GetSpriteX", _
							  "long",$S_Alias)
	Return $S_GetX[0]
EndFunc
;###################################################################################################################################
;	GetSpriteY
;	syntax : GetSpriteY(Alias)
;	Note ;  Get sprite position on the Y axis
;###################################################################################################################################
Func GetSpriteY($S_Alias)
	$S_GetY = DllCall($S_DLL, "long", "GetSpriteY", _
							  "long",$S_Alias)
	Return $S_GetY[0]
EndFunc
;###################################################################################################################################
;	GetSpriteMoveX
;	syntax : $getx = GetSpriteMoveX($S_Alias)
;	Note ;  Sprite movement on the X axis
;			Return = $SpriteMoveX
;			Values =
;			-1 = Sprite Moves left
;			0 = No movement
;			1 = Sprite Moves right
;###################################################################################################################################
Func GetSpriteMoveX($S_Alias)
	$SpriteMoveX = DllCall($S_DLL, "long", "GetSpriteMoveX", _
								   "long",$S_Alias)
	Return $SpriteMoveX[0]
EndFunc
;###################################################################################################################################
;	GetSpriteMoveY
;	syntax : $gety = GetSpriteMoveY($S_Alias)
;	Note ;  Sprite movement on the Y axis
;			Return = $SpriteMoveY
;			Values =
;			-1 = Sprite Moves Up
;			0 = No movement
;			1 = Sprite Moves Down
;###################################################################################################################################
Func GetSpriteMoveY($S_Alias)
	$SpriteMoveY = DllCall($S_DLL, "long", "GetSpriteMoveY", _
								   "long",$S_Alias)
	Return $SpriteMoveY[0]
EndFunc
;###################################################################################################################################
;	HasSpriteArrived
;	syntax : $Arrive = HasSpriteArrived($spaceship)
;	Note ;  Test, if the sprite with user defined handle has arrived to coodinates defined with movesprite func
;			Return Value = 0 not arrived
;						   1 arrived
;###################################################################################################################################
Func HasSpriteArrived($S_Alias)
	$S_rtn = DllCall($S_DLL, "long", "HasSpriteArrived", _
							 "long",$S_Alias)
	Return $S_rtn[0]
EndFunc
;###################################################################################################################################
;====================================================================================================================================
;PixelEffects
;====================================================================================================================================
;###################################################################################################################################
;	InitPixelEffects
;	syntax : InitPixelEffects()
;	Note ;  No parameters required
;			initialiseert pixel effect
;###################################################################################################################################
Func InitPixelEffects()
	DllCall($S_DLL, "long", "InitPixelEffects")
EndFunc
;###################################################################################################################################
;	SetPixelEffect
;	syntax : SetPixelEffect(offsetX, offsetY, Color, Disperse, PixelStrenght, Pixeldirection, PixelAmount, Colormode, LifeTime)
;	Note ;  You have to Set InitPixelEffects() First
;			offsetX, $S_offsetY = Postion on screen
;			Color = Set color for the pixels
;			disperse = How width the pixels must disperse (1 - 160)
;			PixelStrenght = Strenght of the pixels to come out (3 - 31)
;			Pixeldirection = which direction the pixels must fall
;			0 = ?
;			1 = Pixel fall to right
;			2 = Pixel fall down
;			3 = Pixel fall to left
;			4 = Pixel fall to top
;			PixelAmount = How many pixels must be in the effect (3 - 1000)
;			Colormode = There are 3 types
;						0 = The startcolor specified by Color ,the pixel change darker and darker til they are black
;						1 = The pixelcolor stay's the color specified by Color
;						2 = Random Color ,Color is bypassed
;			LifeTime = how long the pixels stay onscreen (10 - 300)
;	Example ;
;	SetPixelEffect(Random(50,750,1), Random(50,350,1), 0x00ffff, 24, 13, 2, 200, 1, 100)
;###################################################################################################################################
Func SetPixelEffect($S_offsetX, $S_offsetY, $S_Color, $S_Disperse, $S_PixelStrenght, $S_Pixeldirection, $S_PixelAmount, $S_Colormode, $S_LifeTime)
	DllCall($S_DLL, "long", "SetPixelEffect", _
					"long",$hDC, _
					"long",$S_fensterkopie1[0], _
					"long",$S_offsetX, _
					"long",$S_offsetY, _
					"long",$S_Color, _
					"long",$S_Disperse, _
					"long",$S_PixelStrenght, _
					"long",$S_Pixeldirection, _
					"long",$S_Pixelamount, _
					"long",$S_Colormode, _
					"long",$S_LifeTime)
EndFunc
;###################################################################################################################################
;	DeInitPixelEffects
;	syntax : DeInitPixelEffects()
;	Note ;  No parameters required
;			Stops the pixeleffect
;###################################################################################################################################
Func DeInitPixelEffects()
	DllCall($S_DLL, "long", "DeInitPixelEffects")
EndFunc
;###################################################################################################################################
;	Stars
;	syntax : Stars(LEFT, TOP, RIGHT, BOTTOM, STARS, SPEED)
;	Note ;  left = left side of screen for the pixel effect
;			TOP = top of screen for the pixel effect
;			Right = right side of screen for the pixel effect
;			Bottom = bottom of the screen for the pixel effect
;			Stars = how many stars on screen
;			speed = how fast the stars move
;			example; Stars(0, 0, 800, 600, 300, 4)
;			makes a starfield 800x600 with 300 stars
;###################################################################################################################################
Func Stars($S_LEFT, $S_TOP, $S_RIGHT, $S_BOTTOM, $S_STARS, $S_SPEED, $S_Mode)
	DllCall($S_DLL, "long", "Stars", _
					"long",$hDC, _
					"long",0, _
					"long",$S_LEFT, _
					"long",$S_TOP, _
					"long",$S_RIGHT, _
					"long",$S_BOTTOM, _
					"long",$S_STARS, _
					"long",$S_SPEED, _
					"long",$S_Mode)
EndFunc
;###################################################################################################################################
;	OptionStars
;	syntax : OptionStars(Offset, Offset, X movement, Y movement, speed)
;	Note ;  Change paramaters set by function Stars()
;			Offset,Offset = coordinates on screen from where the stars must come from
;			X movement,Y movement = Witch direction the stars move to (-10 / +10 ) ,if set to high pixels are offscreen
;			speed = how fast the stars move
;###################################################################################################################################
Func OptionStars($X_Offset, $Y_Offset, $X_movement, $Y_movement, $S_speed)
	DllCall($S_DLL, "long", "OptionStars", _
					"long", $X_Offset, _
					"long", $Y_Offset, _
					"long", $X_movement, _
					"long", $Y_movement, _
					"long", $S_speed)
EndFunc
;###################################################################################################################################
;	StatusStars
;	syntax : $checkstars = StatusStars()
;	Note ;  return string = 0 or 1
;			0 = stars effect has stopped
;			1 = stars effect is still running
;###################################################################################################################################
Func StatusStars()
	$StatusStars = DllCall($S_DLL, "long", "StatusStars")
	Return $StatusStars[0]
EndFunc
;###################################################################################################################################
;	NoStars
;	syntax : NoStars(Mode)
;	Note ;  Mode can be ; 0/1/2/3
;			0 = Continue the stars effect
;			1 = Stop the stars effect and leave the remaing stars on screen
;			2 = Stop the stars effect and delete all stars from screen
;			3 = stop the stars effect and let the remaing stars fly out of the screen
;
;###################################################################################################################################
Func NoStars($S_Mode)
	DllCall($S_DLL, "long", "NoStars", "long", $S_Mode)
EndFunc
;###################################################################################################################################
;===================================================================================================================================
;Joystick and Mouse
;===================================================================================================================================
;###################################################################################################################################
;	FindJoystick
;	Syntax; $find_joy = FindJoystick(1)
;	returns 0 or 1
;	0 = no joystick found
;	1 = joystick 1 found
;###################################################################################################################################
Func FindJoystick($J_STICK)
	Select
		Case $J_STICK = 1
			$S_joy1 = DllCall($S_DLL, "long", "FindJoystick", "long",1)
			Return $S_joy1[0]
		Case $J_STICK = 2
			$S_joy2 = DllCall($S_DLL, "long", "FindJoystick", "long",2)
			Return $S_joy2[0]
	EndSelect
EndFunc
;###################################################################################################################################
;	CountJoystickButtons
;	Syntax; $countButt = CountJoystickButtons(1)
;	returns ;Number of buttons
;###################################################################################################################################
Func CountJoystickButtons($J_STICK)
	$S_Count_buttons = DllCall($S_DLL, "long", "CountJoystickButtons", "long", $J_STICK)
	Return $S_Count_buttons[0]
EndFunc
;###################################################################################################################################
;	JoystickX , x axis
;	Syntax; $joyX = JoystickX(1)
;	returns -127 / 127
;	-127 = most left
;	127 = most right
;	all values under 24 or -24 should be ignored
;###################################################################################################################################
Func JoystickX($J_STICK)
	$S_JoystickX = DllCall($S_DLL, "long", "JoystickX", "long", $J_STICK)
	Return $S_JoystickX[0]
EndFunc
;###################################################################################################################################
;	JoystickY ;  y axis
;	Syntax; $joyY = JoystickY(1)
;	returns -127 / 127
;	-127 = Down
;	127 = Up
;	all values under 24 or -24 should be ignored
;###################################################################################################################################
Func JoystickY($J_STICK)
	$S_JoystickY = DllCall($S_DLL, "long", "JoystickY", "long", $J_STICK)
	Return $S_JoystickY[0]
EndFunc
;###################################################################################################################################
;	JoystickButton
;	Syntax; $joyBut = JoystickButton(1)
;	Support for 32 buttons
;	returns 0 / 32
;	0 = no button pressed
;	1 / 32 button pressed
;###################################################################################################################################
Func JoystickButton($J_STICK)
	$S_Buttons = DllCall($S_DLL, "long", "JoystickButton", "long", $J_STICK)
	Return $S_Buttons[0]
EndFunc
;###################################################################################################################################
;	JoystickZ ,z axis
;	Syntax; $joyZ = JoystickZ(1)
;	returns -127 / 127
;	or 256 when joystick has no Z axis
;	all values under 24 or -24 should be ignored
;###################################################################################################################################
Func JoystickZ($J_STICK)
	$S_JoystickZ = DllCall($S_DLL, "long", "JoystickZ", "long", $J_STICK)
	Return $S_JoystickZ[0]
EndFunc
;###################################################################################################################################
;	JoystickR ; Roar or pedals
;	Syntax; $joyR = JoystickR(1)
;	returns -127 / 127
;	or 256 when joystick has no R axis
;	all values under 24 or -24 should be ignored
;###################################################################################################################################
Func JoystickR($J_STICK)
	$S_JoystickR = DllCall($S_DLL, "long", "JoystickR", "long", $J_STICK)
	Return $S_JoystickR[0]
EndFunc
;###################################################################################################################################
;	JoystickU ; u axis or 5th axis
;	Syntax; $joyU = JoystickU(1)
;	returns -127 / 127
;	or 256 when joystick has no U axis
;	all values under 24 or -24 should be ignored
;###################################################################################################################################
Func JoystickU($J_STICK)
	$S_JoystickU = DllCall($S_DLL, "long", "JoystickU", "long", $J_STICK)
	Return $S_JoystickU[0]
EndFunc
;###################################################################################################################################
;	JoystickV ; V axis or 6th axis
;	Syntax; $joyV = JoystickV(1)
;	returns -127 / 127
;	or 256 when joystick has no V axis
;	all values under 24 or -24 should be ignored
;###################################################################################################################################
Func JoystickV($J_STICK)
	$S_JoystickV = DllCall($S_DLL, "long", "JoystickV", "long", $J_STICK)
	Return $S_JoystickV[0]
EndFunc
;###################################################################################################################################
;	Function MouseOverSprite
;	Syntax = $check = MouseOverSprite($bee1)
;	note;  Alias = use defined Spritename
;	example; $check = MouseOverSprite($bee1)
;		 	If $check <> 0 the function()
;	Return string = sprite ID
;###################################################################################################################################
Func MouseOverSprite($S_Alias)
	$S_long  = "long"
	$S_Check = DllStructCreate($S_long)
	DllStructSetData($S_Check, 1, $S_Alias)
	$S_pos = MouseGetPos()
	$S_rtn = DllCall($S_DLL, "long", "MouseOverSprite", _
							 "long", DllStructGetPtr($S_Check, 1), _
							 "long", 1, _
							 "long", $S_pos[0], _
							 "long", $S_pos[1])
	Return $S_rtn[0]
EndFunc
;###################################################################################################################################
;	Function MouseButton()
;	Syntax = $MouseClick = MouseButton()
;	note;  Return strings
;			0 = No mouseclick
;			1 = Left button
;			2 = Right button
;			4 = mid button
;	return string 0 to 4
;###################################################################################################################################
Func MouseButton()
	$M_Mouse = DllCall($S_DLL, "long", "MouseButton")
	Return $M_Mouse[0]
EndFunc
;###################################################################################################################################
;	Function SetMouseXY()
;	Syntax = SetMouseXY(posX, posY)
;	note;  Set mousepointer at Coordinates posX, posY
;###################################################################################################################################
Func SetMouseXY($M_posX, $M_posY)
	DllCall($S_DLL, "long", "SetMouseXY", _
					"long", $M_posX, _
					"long", $M_posY)
EndFunc
;###################################################################################################################################
;	Function SetMouseRect()
;	Syntax = SetMouseRect(Left, Top, MaxX, MaxY)
;	note;  Set a cage for mousepointer, mousepointer can not move outside coodinates
;	example; SetMouseRect(100, 100, 200, 200)
;			 To undo mouse coodinates, set ;
;			 SetMouseRect(0, 0, @DesktopWidth, @DesktopHeight)
;###################################################################################################################################
Func SetMouseRect($M_Left, $M_Top, $M_MaxX, $M_MaxY)
	DllCall($S_DLL, "long", "SetMouseRect", _
					"long",$M_Left, _
					"long",$M_Top, _
					"long",$M_MaxX, _
					"long",$M_MaxY)
EndFunc
;###################################################################################################################################
;===================================================================================================================================
;ScreenShot
;===================================================================================================================================
;###################################################################################################################################
;	Screenshot
;	syntax : Screenshot(path, Width, Height, ShotPosX, ShotPosY, Type)
;	Note ;  path = Filepath + Filename (C:\Temp\Screen.jpg)
;			Width, Height = How big sceenshot must be (640,480)
;			ShotPosX, ShotPosY = Witch part off the screen to take a screenshot
;			Type ; 0 = bmp
;				   1 = jpg
;###################################################################################################################################
Func Screenshot($S_path, $S_Width, $S_Height, $S_ShotPosX, $S_ShotPosY, $S_Type)
	$RAW_HDC = DllCall("user32.dll", "ptr", "GetWindowDC", "hwnd", "")
	$hDC     = "0x" & Hex($RAW_HDC[0])
	$S_Screen = DllCall($S_dll, "long", "CreateImage", _
								"long", $hDC, _
								"long", $S_Width, _
								"long", $S_Height)
	DllCall($S_dll, "long", "PaintImage", _
					"long", $S_Screen[0], _
					"long", -3, _
					"long", -3, _
					"long", $S_Width, _
					"long", $S_Height, _
					"long", $hDC, _
					"long", $S_ShotPosX, _
					"long", $S_ShotPosY, _
					"long", 0)
	$S_FilePath = $S_path
	DllCall($S_DLL, "long", "SaveImage", _
					"long", $S_Screen[0], _
					"str" , $S_FilePath, _
					"long", $S_Type, _
					"long", 10)
EndFunc
;###################################################################################################################################
;===================================================================================================================================
;DirectXSound
;===================================================================================================================================
;###################################################################################################################################
;	Function DSoundInit
;	syntax : DSoundInit()
;	Note ;  No parameters required
;###################################################################################################################################
Func DSoundInit()
	$WIN_TITLE     = WinGetTitle("", "")
	$WIN_GETHANDLE = WinGetHandle($WIN_TITLE, "")
	DllCall($S_DLL, "long", "DSoundInit", "long", $WIN_GETHANDLE)
EndFunc
;###################################################################################################################################
;	Function DSoundLoad
;	syntax : $Media1 = DSoundLoad(File)
;	Note ;  Needs a user defined string before the func
;			File = Filepath + Filename
;###################################################################################################################################
Func DSoundLoad($DL_File)
	$D_Buffer = DllCall($S_DLL, "long", "DSoundLoad", "str", $DL_File)
	Return $D_Buffer[0]
EndFunc
;###################################################################################################################################
;	Function DSoundPlay
;	syntax : $Explosion = DSoundPlay(Alias, Volume, loop)
;	Note ;  Needs a user defined string before the func
;			Alias = user defined string created with Function DSoundLoad()
;			Volume = Set Sound Volume of played sound Values between -10000 and 0
;			loop ; 0 = noloop ,1 = loop
;###################################################################################################################################
Func DSoundPlay($DP_Alias, $D_Volume, $S_loop)
	$DB_Buffer = DllCall($S_DLL, "long", "DSoundGetNextBuffer", "long", $DP_Alias)
	DllCall($S_DLL, "long", "DSoundSetVolume", _
					"long", $DB_Buffer[0], _
					"long", $D_Volume)
	$D_Play = DllCall($S_DLL, "long", "DSoundPlay", _
							  "long", $DP_Alias, _
							  "long", $S_loop)
	Return $D_Play[0]
EndFunc
;###################################################################################################################################
;	Function DSoundStop
;	syntax : DSoundStop(Alias)
;	Note ;  Alias = user defined string created with Function DSoundPlay()
;###################################################################################################################################
Func DSoundStop($DP_Alias)
	DllCall($S_DLL, "long", "DSoundStop", "long", $DP_Alias)
EndFunc
;###################################################################################################################################
;	Function DSoundSetPan
;	syntax : DSoundSetPan(Alias, Value)
;	Note ;  Alias = user defined string created with Function DSoundPlay()
;			Value = Between -10000 and 10000 Left/Right
;###################################################################################################################################
Func DSoundSetPan($DP_Alias, $D_Value)
	DllCall($S_DLL, "long", "DSoundSetPan", _
					"long", $DP_Alias, _
					"long", $D_Value)
EndFunc
;###################################################################################################################################
;	ChangeDisplay
;	syntax : ChangeDisplay(640, 480)
;	change screenresolution
;###################################################################################################################################
Func ChangeDisplay($SW_Width, $SW_Height)
	DllCall($S_DLL, "long", "ChangeDisplay", _
					"long", $SW_Width, _
					"long", $SW_Height)
EndFunc
;###################################################################################################################################
;	CreateBuffer
;	syntax : CreateBuffer(800, 600)
;	Creates screen buffer for WM_Paint to redraw the screen
;###################################################################################################################################
Func CreateBuffer($S_WIDTH, $S_HEIGHT)
	$S_fensterkopie1 = DllCall($S_DLL, "long", "CreateImage", "long", $hDC, "long", $S_WIDTH, "long", $S_HEIGHT)
	$S_fensterkopie2 = DllCall($S_DLL, "long", "CreateImage", "long", $hDC, "long", $S_WIDTH, "long", $S_HEIGHT)
EndFunc
;###################################################################################################################################
;	SetBuffer
;	syntax : SetBuffer($bitmap1, 800, $600)
;	Set bitmap for screen buffer
;	CreateBuffer() has to be called first
;###################################################################################################################################
Func SetBuffer($S_Source)
	$S_WIDTH  = DllCall($S_DLL, "long", "GetWidthImage" , "long", $S_fensterkopie1[0])
	$S_HEIGHT = DllCall($S_DLL, "long", "GetHeightImage", "long", $S_fensterkopie2[0])
	DllCall($S_DLL, "long", "PaintImage", "long", $S_fensterkopie1[0], _
										  "long", 0, _
										  "long", 0, _
										  "long", $S_WIDTH[0], _
										  "long", $S_HEIGHT[0], _
										  "long", $S_Source, _
										  "long", 0, _
										  "long", 0, _
										  "long", 0)
	DllCall($S_DLL, "long", "PaintImage", "long", $S_fensterkopie2[0], _
										  "long", 0, _
										  "long", 0, _
										  "long", $S_WIDTH[0], _
										  "long", $S_HEIGHT[0], _
										  "long", $S_Source, _
										  "long", 0, _
										  "long", 0, _
										  "long", 0)
EndFunc
;###################################################################################################################################
;	DestroyBuffer
;	syntax : DestroyBuffer()
;	Destroys the screenbuffer created by function CreateBuffer()
;###################################################################################################################################
Func DestroyBuffer()
	FreeImage($S_fensterkopie1[0])
	FreeImage($S_fensterkopie2[0])
EndFunc
;###################################################################################################################################
;	PaintNew
;	syntax : PaintNew()
;	redraws the screen
;###################################################################################################################################
Func PaintNew()
	DllCall($S_DLL, "long", "PaintImage", _
					"long", $hDC, _
					"long", 0, _
					"long", 0, _
					"long", $S_WIDTH[0], _
					"long", $S_HEIGHT[0], _
					"long", $S_fensterkopie1[0], _
					"long", 0, _
					"long", 0, _
					"long", 0)
	DllCall($S_DLL, "long", "PaintImage", _
					"long", $hDC, _
					"long", 0, _
					"long", 0, _
					"long", $S_WIDTH[0], _
					"long", $S_HEIGHT[0], _
					"long", $S_fensterkopie2[0], _
					"long", 0, _
					"long", 0, _
					"long", 0)
EndFunc
;###################################################################################################################################
;	Version()
;	Returns The dll version
;###################################################################################################################################
Func Version()
	$Version = DllCall($S_DLL, "long", "Version")
	Return $Version[0]
EndFunc
;###################################################################################################################################
;	GetVersion()
;	Returns The dll version
;###################################################################################################################################
Func GetVersion()
	$Version = DllCall($S_DLL, "long", "GetVersion")
	Return $Version[0]
EndFunc
;###################################################################################################################################
;	SetAByte
;	syntax ; SetAByte(OffSet, Value)
;	$S_OffSet = Offset in memory
;	$S_Value  = Value to write in memory
;###################################################################################################################################
Func SetAByte($S_OffSet, $S_Value)
	DllCall($S_DLL, "long", "SetAByte", _
					"long", $S_OffSet, _
					"long", $S_Value)
EndFunc
;###################################################################################################################################
;	GetAByte
;	syntax ; GetAByte(MemoryPointer)
;	$S_Pointer = MemoryPointer to start reading
;	Example ; $get = GetAByte($array)
;	Returns = 3 bytes colorData From Image array
;###################################################################################################################################
Func GetAByte($S_Pointer)
	$S_Byte = DllCall($S_DLL, "long", "GetAByte", _
							  "long", $S_Pointer)
	Return $S_Byte[0]
EndFunc
;###################################################################################################################################
;	ReadFileFast
;	Reads a file to memory
;	$read  = ReadFileFast(ID, "file", Offset, size)
;	ID     = user defined id started at 0 en increasing
;	Offset = offset in bytes from where to begin the read
;	Size   = Bytesize of the file to read
;	Return value = pointer to memory location
;###################################################################################################################################
Func ReadFileFast($S_ID, $S_file, $S_Offset, $S_size)
	$S_ReadStruct[$S_ID] = DllStructCreate("byte["&$S_size&"]")
	DllCall($S_DLL, "long", "ReadFileFast", _
					"str" , $S_file, _
					"long", DllStructGetPtr($S_ReadStruct[$S_ID]), _
					"long", $S_Offset, _
					"long", $S_size)
	Return DllStructGetPtr($S_ReadStruct[$S_ID])
EndFunc
;###################################################################################################################################
;	ReadFilePieceFast
;	Read of piece of a larger file to memory
;	$Read        = ReadFilePieceFast(ID, Type, "file", MemOffset, ByteSize, ByteOffset)
;	ID           = user defined id started at 0 en increasing
;	Type         = Type of bytes to read (char,byte,str)
;   MemOffset    = offset in memory to write to
;	ByteSize     = Bytesize of the file to read
;	ByteOffset   = offset in bytes from where to begin to read
;	Return value = Pointer to Memory location
;###################################################################################################################################
Func ReadFilePieceFast($S_ID, $S_Type, $S_file, $S_MEMOffset, $S_ByteSize, $S_ByteOffset)
	$S_ReadStruct[$S_ID] = DllStructCreate($S_Type&"["&$S_ByteSize&"]")
	DllCall($S_DLL, "long", "ReadFilePieceFast", _
					"str" , $S_file, _
					"long", DllStructGetPtr($S_ReadStruct[$S_ID]), _
					"long", $S_MEMOffset, _
					"long", $S_ByteSize, _
					"long", $S_ByteOffset)
	Return DllStructGetPtr($S_ReadStruct[$S_ID])
EndFunc
;###################################################################################################################################
;	WriteFileFast()
;	Writes data in bytes to disk
;	WriteFileFast("FileName", pointer, Offset, filesize)
;	FileName = Name of the file
;	pointer  = Pointer where data is stored in memory
;	Offset   = offset in memory to begin for writing to disk
;	filesize = The size in bytes to write to disk
;###################################################################################################################################
Func WriteFileFast($S_FileName, $S_pointer, $S_Offset, $S_size)
	DllCall($S_DLL, "long", "WriteFileFast", _
					"str" , $S_FileName, _
					"long", $S_pointer, _
					"long", $S_Offset, _
					"long", $S_size)
EndFunc
;###################################################################################################################################
;	ImageFromResource
;	Loads bmp,jpg,png,gif from resource file to memory
;	$loadjpg = ImageFromResource("name", "Resource_File", Password)
;	name          = name of file in the resource file
;	Resource_File = name of the resource file
;	Password      = Password of the resource file , created by the "Resource file maker"
;	Return value  = Handle to Image Data
;###################################################################################################################################
Func ImageFromResource($L_name, $L_Resource, $L_Pass)
	$L_Read = ReadFilePieceFast(0, "char", $L_Resource, 0, 4, 0)
	Crypt($L_Read, 4, $L_Pass, StringLen($L_Pass))
	$L_offset = DllStructGetData($S_ReadStruct[0],1)

	$L_Split = StringSplit($L_offset,"|")

	$L_Read = ReadFilePieceFast(0, "char", $L_Resource, 0, $L_Split[1], 0)
	Crypt($L_Read, $L_offset, $L_Pass, StringLen($L_Pass))
	$L_data = DllStructGetData($S_ReadStruct[0],1)

	$L_str = StringSplit($L_data,"|")
	For $i = 2 To ($L_str[0]-1)
		$L_fileinfo = StringSplit($L_str[$i],",")
		If $L_fileinfo[1] = $L_name Then ExitLoop
	Next
	If $L_fileinfo[1] <> $L_name Then
		MsgBox(0,"Error","File not found")
		Return 0
	Else
		$L_readResource = ReadFilePieceFast(0, "byte", $L_Resource, 0, $L_fileinfo[2], $L_offset+$L_fileinfo[3])
		Crypt($L_readResource, $L_fileinfo[2], $L_Pass, StringLen($L_Pass))
		$L_tmp    = LoadMemoryImage($L_readResource, $L_fileinfo[2])
		Return $L_tmp
	EndIf
EndFunc
;###################################################################################################################################
;	PngFromResource
;	Loads png with alphachannel from resource file to memory
;	$loadPng = PngFromResource("name", "Resource_File", Password)
;	name          = name of file in the resource file
;	Resource_File = name of the resource file
;	Password      = Password of the resource file , created by the "Resource file maker"
;	Return value  = Handle to Image Data
;###################################################################################################################################
Func PngFromResource($L_name, $L_Resource, $L_Pass)
	$L_Read = ReadFilePieceFast(0, "char", $L_Resource, 0, 4, 0)
	Crypt($L_Read, 4, $L_Pass, StringLen($L_Pass))
	$L_offset = DllStructGetData($S_ReadStruct[0],1)

	$L_Split = StringSplit($L_offset,"|")

	$L_Read = ReadFilePieceFast(0, "char", $L_Resource, 0, $L_Split[1], 0)
	Crypt($L_Read, $L_offset, $L_Pass, StringLen($L_Pass))
	$L_data = DllStructGetData($S_ReadStruct[0],1)

	$L_str = StringSplit($L_data,"|")
	For $i = 2 To ($L_str[0]-1)
		$L_fileinfo = StringSplit($L_str[$i],",")
		If $L_fileinfo[1] = $L_name Then ExitLoop
	Next
	If $L_fileinfo[1] <> $L_name Then
		MsgBox(0,"Error","File not found")
		Return 0
	Else
		$L_readResource = ReadFilePieceFast(0, "byte", $L_Resource, 0, $L_fileinfo[2], $L_offset+$L_fileinfo[3])
		Crypt($L_readResource, $L_fileinfo[2], $L_Pass, StringLen($L_Pass))
		Return DllStructGetPtr($S_ReadStruct[0],1)
	EndIf
EndFunc
;###################################################################################################################################
;	TextFromResource
;	Loads txt,ini and log files from resource file to memory
;	$loadtxt = TextFromResource("name", "Resource_File", Password)
;	name          = name of file in the resource file
;	Resource_File = name of the resource file
;	Password      = Password of the resource file , created by the "Resource file maker"
;   Return value  = Text Data
;###################################################################################################################################
Func TextFromResource($L_name, $L_Resource, $L_Pass)
	$L_Read = ReadFilePieceFast(0, "char", $L_Resource, 0, 4, 0)
	Crypt($L_Read, 4, $L_Pass, StringLen($L_Pass))
	$L_offset = DllStructGetData($S_ReadStruct[0],1)

	$L_Split = StringSplit($L_offset,"|")

	$L_Read = ReadFilePieceFast(0, "char", $L_Resource, 0, $L_Split[1], 0)
	Crypt($L_Read, $L_offset, $L_Pass, StringLen($L_Pass))
	$L_data = DllStructGetData($S_ReadStruct[0],1)

	$L_str = StringSplit($L_data,"|")
	For $i = 2 To ($L_str[0]-1)
		$L_fileinfo = StringSplit($L_str[$i],",")
		If $L_fileinfo[1] = $L_name Then ExitLoop
	Next
	If $L_fileinfo[1] <> $L_name Then
		MsgBox(0,"Error","File not found")
		Return 0
	Else
		$L_readResource = ReadFilePieceFast(0, "char", $L_Resource, 0, $L_fileinfo[2], $L_offset+$L_fileinfo[3])
		Crypt($L_readResource, $L_fileinfo[2], $L_Pass, StringLen($L_Pass))
		Return DllStructGetData($S_ReadStruct[0],1)
	EndIf
EndFunc
;###################################################################################################################################
;	FontFromResource
;	loads a font from an resource file to memory and add the font to the fonttable
;	$loadfont = FontFromResource("name", "Resource_File", Password)
;	name          = name of file in the resource file
;	Resource_File = name of the resource file
;	Password      = Password of the resource file , created by the "Resource file maker"
;	return value  = Handle to font, needed to call function RemoveFontResource()
;   The font has to be called by name in your program, GUICtrlSetFont(-1, 9, 400, 2, "Arial")
;###################################################################################################################################
Func FontFromResource($L_name, $L_Resource, $L_Pass)
	$L_Read = ReadFilePieceFast(0, "char", $L_Resource, 0, 4, 0)
	Crypt($L_Read, 4, $L_Pass, StringLen($L_Pass))
	$L_offset = DllStructGetData($S_ReadStruct[0],1)

	$L_Split = StringSplit($L_offset,"|")

	$L_Read = ReadFilePieceFast(0, "char", $L_Resource, 0, $L_Split[1], 0)
	Crypt($L_Read, $L_offset, $L_Pass, StringLen($L_Pass))
	$L_data = DllStructGetData($S_ReadStruct[0],1)

	$L_str = StringSplit($L_data,"|")
	For $i = 2 To ($L_str[0]-1)
		$L_fileinfo = StringSplit($L_str[$i],",")
		If $L_fileinfo[1] = $L_name Then ExitLoop
	Next
	If $L_fileinfo[1] <> $L_name Then
		MsgBox(0,"Error","File not found")
		Return 0
	Else
		$L_readResource = ReadFilePieceFast(0, "char", $L_Resource, 0, $L_fileinfo[2], $L_offset+$L_fileinfo[3])
		Crypt($L_readResource, $L_fileinfo[2], $L_Pass, StringLen($L_Pass))
		$L_value = DllCall("gdi32.dll","int","AddFontMemResourceEx","int",$L_readResource,"int",$L_fileinfo[2],"int",0,"int*",0)
		$S_ReadStruct[0] = ""
		Return $L_value[0]
	EndIf
EndFunc
;###################################################################################################################################
;	HtmlFromResource
;	loads html file from resource file to memory
;	$loadHtml = HtmlFromResource("name", "Resource_File", Password)
;	name          = name of file in the resource file
;	Resource_File = name of the resource file
;	Password      = Password of the resource file , created by the "Resource file maker"
;	return value  = html data
;###################################################################################################################################
Func HtmlFromResource($L_name, $L_Resource, $L_Pass)
	$L_Read = ReadFilePieceFast(0, "char", $L_Resource, 0, 4, 0)
	Crypt($L_Read, 4, $L_Pass, StringLen($L_Pass))
	$L_offset = DllStructGetData($S_ReadStruct[0],1)

	$L_Split = StringSplit($L_offset,"|")

	$L_Read = ReadFilePieceFast(0, "char", $L_Resource, 0, $L_Split[1], 0)
	Crypt($L_Read, $L_offset, $L_Pass, StringLen($L_Pass))
	$L_data = DllStructGetData($S_ReadStruct[0],1)

	$L_str = StringSplit($L_data,"|")
	For $i = 2 To ($L_str[0]-1)
		$L_fileinfo = StringSplit($L_str[$i],",")
		If $L_fileinfo[1] = $L_name Then ExitLoop
	Next
	If $L_fileinfo[1] <> $L_name Then
		MsgBox(0,"Error","File not found")
		Return 0
	Else
		$L_readResource = ReadFilePieceFast(0, "char", $L_Resource, 0, $L_fileinfo[2], $L_offset+$L_fileinfo[3])
		Crypt($L_readResource, $L_fileinfo[2], $L_Pass, StringLen($L_Pass))
		Return DllStructGetData($S_ReadStruct[0],1)
	EndIf
EndFunc
;###################################################################################################################################
;	RemoveFontResource
;	Removes Font from fonttable
;	RemoveFontResource(Handle)
;	Handle = handle returned by FontFromResource()
;###################################################################################################################################
Func RemoveFontResource($L_Handle)
	DllCall("gdi32.dll", "int", "RemoveFontMemResourceEx", _
						 "int", $L_Handle)
EndFunc
;###################################################################################################################################
;	SetText
;	Print Text on hDC or Bitmap
;	SetText(Destination, Text, x, y, TextColor, TextBKColor, Font_Height, Font_Width, "Font_Name")
;	Destination = Destination to print the text (bitmap or hDc)
;	Text        = The actual text to be printed "Hallo world"
;	x           = The offset on the x axis in the destination location
;	y           = The offset on the y axis in the destination location
;	TextColor   = The text color
;	TextBKColor = The background text color ,if 0 then it become tranperance
;	Font_Height = The height of the font
;	Font_Width  = The width of the font
;	Font_Name   = The font name to use
;###################################################################################################################################
Func SetText($S_Destination, $S_Text, $S_x, $S_y, $S_TextColor, $S_BKColor, $Font_H, $Font_W, $Font_Name)
	$font = DllCall("gdi32.dll", "int", "CreateFontA", _
								 "int", $Font_H, _
								 "int", 0, _
								 "int", 0, _
								 "int", 0, _
								 "int", $Font_W, _
								 "Int", 0, _
								 "int", 0, _
								 "int", 0, _
								 "int", 0, _
								 "int", 0, _
								 "int", 0, _
								 "int", 0, _
								 "int", 0, _
								 "str", $Font_Name)
	$oldfont = DllCall("gdi32.dll", "int", "SelectObject", _
									"hwnd", $S_Destination, _
									"int",  $font[0])
	If $S_BKColor = 0 Then
		DllCall("gdi32.dll", "int", "SetBkMode", _
							"hwnd", $S_Destination, _
							"int",  "TRANSPARENT")
	EndIf
	DllCall("gdi32.dll", "int",  "SetTextColor", _
						 "hwnd", $S_Destination, _
						 "int",  $S_TextColor)
	DllCall("gdi32.dll", "int",  "SetBkColor", _
						 "hwnd", $S_Destination, _
						 "int",  $S_BKColor)
	DllCall("gdi32.dll", "int",  "TextOutA", _
						 "hwnd", $S_Destination, _
						 "int",  $S_x, _
						 "int",  $S_y, _
						 "str",  $S_Text, _
						 "int",  StringLen($S_Text))
	DllCall("gdi32.dll", "int",  "selectObject", _
						 "hwnd", $S_Destination, _
						 "int",  $oldfont[0])
	DllCall("gdi32.dll", "int",  "DeleteObject", _
						 "hwnd", $font[0])
EndFunc
;###################################################################################################################################
;	Crypt
;	Encrypt data in memory
;	Use twice to Decrypt the data again
;	Crypt(Pointer, ByteSize, passWord, passLen)
;	Pointer  = Pointer to memory location where data stays
;	ByteSize = Byte Size of the data in memory
;	passWord = user defined password ,can be any lenght
;	passLen  = lenght in bytes of the password
;###################################################################################################################################
Func Crypt($C_Pointer, $C_ByteSize, $C_passWord, $C_passLen)
	$C_crypt = DllCall($S_DLL, "long", "Crypt", _
							   "long", $C_Pointer, _
							   "long", $C_ByteSize, _
							   "str" , $C_passWord, _
							   "long", $C_passLen)
	Return $C_crypt[0]
EndFunc
;###################################################################################################################################
;###################################################################################################################################
Func Close_DLL()
	DllClose($S_DLL)
EndFunc