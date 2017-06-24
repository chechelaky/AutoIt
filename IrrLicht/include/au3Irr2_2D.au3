#include-once

#include "au3Irr2_constants.au3"

; #INDEX# =======================================================================================================================
; Title .........: 2D
; AutoIt Version : v3.3.6.1
; Language ......: English
; Description ...: Support for 2D operations including the loading of bitmaps that can be used for texturing
;                  3D objects or for display on the screen as 2D sprites.
; Author(s) .....: jRowe, linus.
;                  DLL functionality by Frank Dodd and IrrlichtWrapper for FreeBasic team (IrrlichtWrapper.dll),
;                  and Nikolaus Gebhardt and Irrlicht team (Irrlicht.dll).
; Dll(s) ........: IrrlichtWrapper.dll, Irrlicht.dll, msvcp71.dll, msvcr71.dll
; ===============================================================================================================================

; #NO_DOC_FUNCTION# =============================================================================================================
; Not working/documented/implemented at this time
;_IrrLockOpenGLTexture
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;_IrrSetTextureCreationFlag
;_IrrGetTexture
;_IrrGetImage
;_IrrCreateTexture
;_IrrCreateImage
;_IrrRemoveTexture
;_IrrRemoveImage
;_IrrLockTexture
;_IrrUnlockTexture
;_IrrLockImage
;_IrrUnlockImage
;_IrrCreateRenderTargetTexture
;_IrrMakeNormalMapTexture
;_IrrBlendTextures
;_IrrColorKeyTexture
;_IrrDraw2DImage
;_IrrDraw2DImageElement
;_IrrDraw2DImageElementStretch
;_IrrGetFont
;_Irr2DFontDraw
;_IrrSaveScreenShot
;_IrrGetScreenShot
;_IrrGetTextureInformation
;_IrrGetImageInformation
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; ===============================================================================================================================

; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetTextureCreationFlag
; Description ...: Sets texture creation flags controlling how textures are handled when they are created.
; Syntax.........: _IrrSetTextureCreationFlag($i_Flag, $i_Value)
; Parameters ....: $i_Value -  The following flags can be set;
;                  |$ETCF_ALWAYS_16_BIT - Forces the driver to always create 16 bit textures, independently of which format the file on disk has.
;                   When choosing this you may loose some color detail, but gain speed and save memory.
;                   16 bit textures can be transferred twice as quickly as 32 bit textures and only use half of the memory space.
;                   When using this flag, it does not make sense to use the flags ETCF_ALWAYS_32_BIT, ETCF_OPTIMIZED_FOR_QUALITY, or ETCF_OPTIMIZED_FOR_SPEED at the same time.
;                  |$ETCF_ALWAYS_32_BIT - Forces the driver to always create 32 bit textures, independently of which format the file on disk has.
;                   Note that some drivers (like the software device) will ignore this, because they are only able to create and use 16 bit textures.
;                   When using this flag, it does not make sense to use the flags ETCF_ALWAYS_16_BIT, ETCF_OPTIMIZED_FOR_QUALITY, or ETCF_OPTIMIZED_FOR_SPEED at the same time.
;                  |$ETCF_OPTIMIZED_FOR_QUALITY - Lets the driver decide in which format the textures are created and tries to make the textures look as good as possible.
;                   Usually it simply chooses the format in which the texture was stored on disk.
;                   When using this flag, it does not make sense to use the flags ETCF_ALWAYS_16_BIT, ETCF_ALWAYS_32_BIT, or ETCF_OPTIMIZED_FOR_SPEED at the same time.
;                  |$ETCF_OPTIMIZED_FOR_SPEED - Lets the driver decide in which format the textures are created and tries to create them maximizing render speed.
;                   When using this flag, it does not make sense to use the flags ETCF_ALWAYS_16_BIT, ETCF_ALWAYS_32_BIT, or ETCF_OPTIMIZED_FOR_QUALITY, at the same time.
;                  |$ETCF_CREATE_MIP_MAPS - Automatically creates mip map levels for the textures.
;                  |$ETCF_NO_ALPHA_CHANNEL - Discard any alpha layer and use non-alpha color format.
;                  $i_Flag - Turn Creation Flag Off or On ($IRR_OFF or $IRR_ON)
; Return values .: Success - True
;                  Failure - False
; Author ........: smashly
; Modified.......:
; Remarks .......:
; Related .......: None
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrSetTextureCreationFlag($i_Value, $i_Flag)
	DllCall($_irrDll, "none:cdecl", "IrrSetTextureCreationFlag", "int", $i_Value, "int", $i_Flag)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrSetTextureCreationFlag




; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetTexture
; Description ...: Loads 2D texture from bitmap file into video memory that can then be used to texture a model or to draw onto the screen.
; Syntax.........: _IrrGetTexture($s_ImageFile)
; Parameters ....: $s_ImageFile - Full path to the bitmap file.
; Return values .: Success - Handle of the device dependend irrlicht texture object
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: Irrlicht engine supports currently this image file formats:
;                  @@StandardTable@@
;                  JPEG File Interchange Format (.jpg, r/w)	Portable Network Graphics (.png, r/w)
;                  Truevision Targa (.tga, r/w)	Windows Bitmap (.bmp, r/w)
;                  Zsoft Paintbrush (.pcx, r/w)	Portable Pixmaps (.ppm, r/w)
;                  Adobe Photoshop (.psd, r)	Quake 2 textures (.wal, r)
;                  SGI truecolor textures (.rgb, r)
;                  @@End@@
; Related .......: _IrrRemoveTexture, _IrrGetImage
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrGetTexture($s_TextureFile)
	Local $aResult
	$aResult = DllCall($_irrDll, "UINT_PTR:cdecl", "IrrGetTexture", "str", $s_TextureFile)
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrGetTexture


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetImage
; Description ...: Loads 2D texture from bitmap file into main memory for CPU based operations.
; Syntax.........: _IrrGetImage($s_ImageFile)
; Parameters ....: $s_ImageFile - Full path to the bitmap file.
; Return values .: Success - Handle of the irrlicht memory texture object
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: <b>This images can not be used to texture 3D objects!</b> Instead, they can be used to supply a heightmap to a terrain or other similar CPU based operations.
;+
;                  Irrlicht engine supports currently this image file formats:
;                  @@StandardTable@@
;                  JPEG File Interchange Format (.jpg, r/w)	Portable Network Graphics (.png, r/w)
;                  Truevision Targa (.tga, r/w)	Windows Bitmap (.bmp, r/w)
;                  Zsoft Paintbrush (.pcx, r/w)	Portable Pixmaps (.ppm, r/w)
;                  Adobe Photoshop (.psd, r)	Quake 2 textures (.wal, r)
;                  SGI truecolor textures (.rgb, r)
;                  @@End@@
; Related .......: _IrrRemoveImage, _IrrGetTexture
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _IrrGetImage($s_ImageFile)
	Local $aResult
	$aResult = DllCall($_irrDll, "UINT_PTR:cdecl", "IrrGetImage", "str", $s_ImageFile)
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrGetImage


; #FUNCTION# =============================================================================================================
; Name...........: _IrrCreateTexture
; Description ...: Creates a blank texture.
; Syntax.........: _IrrCreateTexture($s_TextureName, $i_XSize, $i_YSize, $i_ColorFormat)
; Parameters ....: $s_TextureName -  Texture_name as string.
;                  $i_XSize - Width of the texture.
;                  $i_YSize - Height of the texture.
;                  $i_ColorFormat - The format of the texture can be one of the following:
;                  |$ECF_A1R5G5B5 - 16 bit color format used by the software driver, and thus preferred by all other irrlicht engine video drivers.
;                   There are 5 bits for every color component, and a single bit is left for alpha information.
;                  |$ECF_R5G6B5 - Standard 16 bit color format.
;                  |$ECF_R8G8B8 - 24 bit color, no alpha channel, but 8 bit for red, green and blue.
;                  |$ECF_A8R8G8B8 - Default 32 bit color format. 8 bits are used for every component: red, green, blue and alpha.
; Return values .: Success - Handle of the newly created irrlicht texture object
;                  Failure - False and @error 1
; Author ........: smashly
; Modified.......:
; Remarks .......:
; Related .......: _IrrDraw2DImage, _IrrGetTextureInformation, _IrrLockTexture, _IrrUnlockTexture
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrCreateTexture($s_TextureName, $i_XSize, $i_YSize, $i_ColorFormat)
	Local $aResult
	$aResult = DllCall($_irrDll, "ptr:cdecl", "IrrCreateTexture", "str", $s_TextureName, "int", $i_XSize, "int", $i_YSize, "int", $i_ColorFormat)
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrCreateTexture


; #FUNCTION# =============================================================================================================
; Name...........: _IrrCreateImage
; Description ...: Creates a blank image that does not use video memory.
; Syntax.........: _IrrCreateImage($i_XSize, $i_YSize, $i_ColorFormat)
; Parameters ....: $i_XSize - Width of the texture.
;                  $i_XSize - Width of the texture.
;                  $i_ColorFormat - The format of the texture can be one of the following:
;                  |$ECF_A1R5G5B5 - 16 bit color format used by the software driver, and thus preferred by all other irrlicht engine video drivers.
;                   There are 5 bits for every color component, and a single bit is left for alpha information.
;                  |$ECF_R5G6B5 - Standard 16 bit color format.
;                  |$ECF_R8G8B8 - 24 bit color, no alpha channel, but 8 bit for red, green and blue.
;                  |$ECF_A8R8G8B8 - Default 32 bit color format. 8 bits are used for every component: red, green, blue and alpha.
; Return values .: Success - Handle of the newly created device dependend irrlicht image object
;                  Failure - False and @error 1
; Author ........: smashly
; Modified.......:
; Remarks .......: This images can not be used to texture 3D objects!
;                  Instead, they can be used to supply a heightmap to a terrain or other similar CPU based operations.
; Related .......: _IrrLockImage, _IrrUnlockImage
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _IrrCreateImage($i_XSize, $i_YSize, $i_ColorFormat)
	Local $aResult
	$aResult = DllCall($_irrDll, "ptr:cdecl", "IrrCreateImage", "int", $i_XSize, "int", $i_YSize, "int", $i_ColorFormat)
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrCreateImage


; #FUNCTION# =============================================================================================================
; Name...........: _IrrRemoveTexture
; Description ...: Removes the texture from memory freeing up the space it occupied.
; Syntax.........: _IrrRemoveTexture($h_Texture)
; Parameters ....: $h_Texture - Handle of an device dependend irrlicht texture object
; Return values .: Success - True
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: You should ensure that the texture is not in use by materials assigned to nodes.
; Related .......: _IrrGetTexture, _IrrGetImage
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrRemoveTexture($h_Texture)
	DllCall($_irrDll, "none:cdecl", "IrrRemoveTexture", "ptr", $h_Texture)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrRemoveTexture


; #FUNCTION# =============================================================================================================
; Name...........: _IrrRemoveImage
; Description ...: Removes the image from memory freeing up the space it occupied.
; Syntax.........: _IrrRemoveImage($h_Image)
; Parameters ....: $h_Image - Handle of the irrlicht memory image object.
; Return values .: Success - True
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: You should ensure that the image is not in use by other functions.
; Related .......: _IrrGetImage, _IrrGetTexture
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _IrrRemoveImage($h_Image)
	DllCall($_irrDll, "none:cdecl", "IrrRemoveImage", "ptr", $h_Image)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrRemoveImage


; #FUNCTION# =============================================================================================================
; Name...........: _IrrLockTexture
; Description ...: Locks the texture and returns a pointer to the pixels.
; Syntax.........: _IrrLockTexture($h_Texture)
; Parameters ....: $h_Texture - Handle to an irrlicht texture object
; Return values .: Success - Pointer to the pixels.
;                  Failure - False and @error 1
; Author ........: smashly
; Modified.......:
; Remarks .......: None.
; Related .......: _IrrUnlockTexture
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrLockTexture($h_Texture)
	Local $aResult
	$aResult = DllCall($_irrDll, "ptr:cdecl", "IrrLockTexture", "ptr", $h_Texture)
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrLockTexture


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrLockOpenGLTexture
; Description ...: Locks an OpenGL texture and returns a pointer to the pixels.
; Syntax.........: _IrrLockOpenGLTexture($h_Texture)
; Parameters ....: $h_Texture - Handle to an irrlicht OpenGL texture object
; Return values .: Success - Pointer to the pixels.
;                  Failure - False and @error 1
; Author ........:
; Modified.......:
; Remarks .......: None.
; Related .......: _IrrUnlockTexture
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _IrrLockOpenGLTexture($h_Texture)
	Local $aResult
	$aResult = DllCall($_irrDll, "ptr:cdecl", "IrrLockOpenGLTexture", "ptr", $h_Texture)
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrLockOpenGLTexture


; #FUNCTION# =============================================================================================================
; Name...........: _IrrUnlockTexture
; Description ...: Unlock the texture, presumably after it has been modified and recreate the mipmap levels.
; Syntax.........: _IrrUnlockTexture($h_Texture)
; Parameters ....: $h_Texture - Handle to an irrlicht texture object that has been Locked by prior call to _IrrLockOpenGLTexture or _IrrLockTexture.
; Return values .: Success - True
;                  Failure - False
; Author ........: smashly
; Modified.......:
; Remarks .......: None
; Related .......: _IrrLockOpenGLTexture, _IrrLockTexture
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrUnlockTexture($h_Texture)
	DllCall($_irrDll, "none:cdecl", "IrrUnlockTexture", "ptr", $h_Texture)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrUnlockTexture


; #FUNCTION# =============================================================================================================
; Name...........: _IrrLockImage
; Description ...: Locks an image object and returns a pointer to the pixels.
; Syntax.........: _IrrLockImage($h_Image)
; Parameters ....: $h_Image - Handle to an irrlicht image object
; Return values .: Success - Pointer to the image pixels
;                  Failure - False and @error 1
; Author ........: smashly
; Modified.......:
; Remarks .......: None.
; Related .......: _IrrCreateImage, _IrrGetImage, _IrrUnlockImage
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrLockImage($h_Image)
	Local $aResult
	$aResult = DllCall($_irrDll, "ptr:cdecl", "IrrLockImage", "ptr", $h_Image)
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Return $aResult[0]
EndFunc   ;==>_IrrLockImage


; #FUNCTION# =============================================================================================================
; Name...........: _IrrUnlockImage
; Description ...: [todo]
; Syntax.........: _IrrUnlockImage($h_Image)
; Parameters ....: $h_Image - Handle to an irrlicht image object that has been Locked by prior call to _IrrLockImage
; Return values .: Success - True
;                  Failure - False and @error > 0
; Author ........: smashly
; Modified.......:
; Remarks .......: None.
; Related .......: _IrrLockImage
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrUnlockImage($h_Image)
	DllCall($_irrDll, "none:cdecl", "IrrUnlockImage", "ptr", $h_Image)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrUnlockImage


; #FUNCTION# =============================================================================================================
; Name...........: _IrrCreateRenderTargetTexture
; Description ...: Create a texture that is suitable for the scene manager to use as a surface to which it can render its 3d object.
; Syntax.........: _IrrCreateRenderTargetTexture($i_XSize, $i_YSize)
; Parameters ....: $i_XSize - Width of the texture
;                  $i_YSize - Height of the texture
; Return values .: Success - Handle to an irrlicht texture object
;                  Failure - False and @error 1
; Author ........:
; Modified.......:
; Remarks .......: Each of the dimentions must be of a power of two for example 128x128 or 256x256.
;                  This function is very important when producing texture maps for special effects for example a rendering of a model for a 2D image displayed in the HUD,
;                  the rendering of a model for display on a 3D surface for example a video display of virtual camera, the rendering of the texture for the reflection of a mirror,
;                  the rendering of the environment for use in a water or chrome shader.
;                  Most cards, even old cards, will support this very important function.
; Related .......: [todo: functionName, functionName]
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _IrrCreateRenderTargetTexture($i_XSize, $i_YSize)
	Local $aResult
	$aResult = DllCall($_irrDll, "ptr:cdecl", "IrrCreateRenderTargetTexture", "uint", $i_XSize, "uint", $i_YSize)
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrCreateRenderTargetTexture


; #FUNCTION# =============================================================================================================
; Name...........: _IrrMakeNormalMapTexture
; Description ...: Create a normal map from a gray-scale height map texture.
; Syntax.........: _IrrMakeNormalMapTexture($h_Texture, $f_Amplitude)
; Parameters ....: $h_Texture - Handle of an device dependend irrlicht texture object
;                  $f_Amplitude -
; Return values .: Success - True
;                  Failure - False and @error 1
; Author ........:
; Modified.......:
; Remarks .......: Normal maps are used to add a high level of surface lighting detail to what are normally low resolution models.
;                  They can have a massive effect on the realism of an object, the model you create will have to be created in "tangent" space to support this.
; Related .......: [todo: functionName, functionName]
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _IrrMakeNormalMapTexture($h_Texture, $f_Amplitude)
	DllCall($_irrDll, "none:cdecl", "IrrMakeNormalMapTexture", "ptr", $h_Texture, "float", $f_Amplitude)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrMakeNormalMapTexture


; #FUNCTION# =============================================================================================================
; Name...........: _IrrBlendTextures
; Description ...: Blend the source texture into the destination texture to create a single texture.
; Syntax.........: _IrrBlendTextures($h_TextureDest, $h_TextureSrc, $i_Xoffset, $i_Yoffset, $i_Operation)
; Parameters ....: $h_TextureDest - Handle to the Destination irrlicht texture object.
;                  $h_TextureSrc - Handle to the Source irrlicht texture object.
;                  $i_Xoffset - X position where the Source texture will be drawn into the Desination texture.
;                  $i_Yoffset - Y position where the Source texture will be drawn into the Desination texture.
;                  $i_Operation - Can be one of the following:
;                  |$BLEND_SCREEN       ; 0
;                  |$BLEND_ADD          ; 1
;                  |$BLEND_SUBTRACT     ; 2
;                  |$BLEND_MULTIPLY     ; 3
;                  |$BLEND_DIVIDE       ; 4
; Return values .: Success - True
;                  Failure - False and set @error, check @extended to see what the error is.
;                  |@extended 0 then the @error is autoit failed the DllCall
;                  |@extended 1 Incompatible texture types
;                  |@extended 2 Unsupported texture format, must be 32bit
; Author ........:
; Modified.......:
; Remarks .......: Textures must be 32 bit format.
; Related .......: _IrrGetTexture, _IrrCreateTexture, _IrrDraw2DImage
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrBlendTextures($h_texturedest, $h_TextureSrc, $i_Xoffset, $i_Yoffset, $i_Operation)
	Local $aResult
	$aResult = DllCall($_irrDll, "int:cdecl", "IrrBlendTextures", "ptr", $h_texturedest, "ptr", $h_TextureSrc, "int", $i_Xoffset, "int", $i_Yoffset, "int", $i_Operation)
	If @error Then Return SetError(@error, 0, @error = 0)
	Return SetError($aResult[0], $aResult[0], $aResult[0] = 0)
EndFunc   ;==>_IrrBlendTextures


; #FUNCTION# =============================================================================================================
; Name...........: _IrrColorKeyTexture
; Description ...: Copies any parts of the texture that are the same as the specified color into the textures alpha channel.
; Syntax.........: _IrrColorKeyTexture($h_Texture, $i_Red, $i_Green, $i_Blue)
; Parameters ....: $h_Texture - Handle of the texture object
;                  $i_Red -  Red value from 0 to 255
;                  $i_Green - Green value from 0 to 255
;                  $i_Blue - Blue value from 0 to 255
; Return values .: Success - True
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: This can be used for special effects or to make these regions transparent.
; Related .......: None
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrColorKeyTexture($h_Texture, $i_Red, $i_Green, $i_Blue)
	DllCall($_irrDll, "none:cdecl", "IrrColorKeyTexture", "ptr", $h_Texture, "int", $i_Red, "int", $i_Green, "int", $i_Blue)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrColorKeyTexture


; #FUNCTION# =============================================================================================================
; Name...........: _IrrDraw2DImage
; Description ...: Draws the texture to the display at the supplied coordinates.
; Syntax.........: _IrrDraw2DImage($h_Image, $i_XPos, $i_YPos)
; Parameters ....: $h_Image - Handle to an irrlicht image object
;                  $i_XPos - X position on display from where drawing starts
;                  $i_YPos - Y position on display from where drawing starts
; Return values .: Success - True
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......:
; Related .......: _IrrGetTexture, _IrrDraw2DImageElement
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrDraw2DImage($h_Image, $i_XPos, $i_YPos)
	DllCall($_irrDll, "none:cdecl", "IrrDraw2DImage", "ptr", $h_Image, "int", $i_XPos, "int", $i_YPos)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrDraw2DImage


; #FUNCTION# =============================================================================================================
; Name...........: _IrrDraw2DImageElement
; Description ...: Draws given rectangular section from a texture to the display at the supplied coordinates
; Syntax.........: _IrrDraw2DImageElement($h_Texture, $i_XPos, $i_YPos, $i_SourceTopX, $i_SourceTopY, $i_SourceBottomX, $i_SourceBottomY, $i_UseAlpha)
; Parameters ....: $h_Image - Handle to an irrlicht image object
;                  $i_XPos - X position on display from where drawing starts
;                  $i_YPos - Y position on display from where drawing starts
;                  $i_SourceTopX - X top position of rectangle in the source texture
;                  $i_SourceTopY - Y top position of rectangle in the source texture
;                  $i_SourceBottomX - X bottom position of rectangle in the source texture
;                  $i_SourceBottomY - Y bottom position of rectangle in the source texture
;                  $i_UseAlpha - Whether or not to use the alpha channel should be one of the following values:
;                  |$IRR_IGNORE_ALPHA
;                  |$IRR_USE_ALPHA
; Return values .: Success - True
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: Draws the texture to the display at the supplied co-ordinates, the image is copied from the specified rectangle in the source texture, this enables you to put many images onto a single texture.
;                  This function also supports the alpha channel when drawing the image to the display and can draw the image transparently.
; Related .......: _IrrGetTexture, _IrrColorKeyTexture, _IrrDraw2DImage, _IrrDraw2DImageElementStretch
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrDraw2DImageElement($h_Texture, $i_XPos, $i_YPos, $i_SourceTopX, $i_SourceTopY, $i_SourceBottomX, $i_SourceBottomY, $i_UseAlpha)
	DllCall($_irrDll, "none:cdecl", "IrrDraw2DImageElement", "ptr", $h_Texture, "int", $i_XPos, "int", $i_YPos, "int", $i_SourceTopX, "int", $i_SourceTopY, "int", $i_SourceBottomX, "int", $i_SourceBottomY, "int", $i_UseAlpha)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrDraw2DImageElement

; #FUNCTION# =============================================================================================================
; Name...........: _IrrDraw2DImageElementStretch
; Description ...: Draws specified rectangle from Source texture sizing it to fit the specified Desination rectangle.
; Syntax.........: _IrrDraw2DImageElementStretch($h_Texture, $i_DestTopX, $i_DestTopY, $i_DestBottomX, $i_DestBottomY, $i_SourceTopX, $i_SourceTopY, $i_SourceBottomX, $i_SourceBottomY, $i_UseAlpha)
; Parameters ....: $h_Texture - Handle to an irrlicht image object
;                  $i_DestTopX - Top X Destination where the drawing will start.
;                  $i_DestTopY - Top Y Destination where the drawing will start.
;                  $i_DestBottomX - Bottom X Destination where the drawing will end.
;                  $i_DestBottomY - Bottom Y Destination where the drawing will end.
;                  $i_SourceTopX - X top position of rectangle in the source texture
;                  $i_SourceTopY - Y top position of rectangle in the source texture
;                  $i_SourceBottomX - X bottom position of rectangle in the source texture
;                  $i_SourceBottomY - Y bottom position of rectangle in the source texture
;                  $i_UseAlpha - Whether or not to use the alpha channel should be one of the following values:
;                  |$IRR_IGNORE_ALPHA
;                  |$IRR_USE_ALPHA
; Return values .: Success - True
;                  Failure - False
; Author ........: smashly
; Modified.......:
; Remarks .......: The image is copied from the specified rectangle in the source texture, this enables you to put many images onto a single texture.
;                  If the rectangles are different sizes this function will scale the images appropriately.
;                  This function also supports the alpha channel when drawing the image to the display and can draw the image transparently.
; Related .......: _IrrGetTexture, _IrrColorKeyTexture, _IrrDraw2DImageElement
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrDraw2DImageElementStretch($h_Texture, $i_DestTopX, $i_DestTopY, $i_DestBottomX, $i_DestBottomY, $i_SourceTopX, $i_SourceTopY, $i_SourceBottomX, $i_SourceBottomY, $i_UseAlpha)
	DllCall($_irrDll, "none:cdecl", "IrrDraw2DImageElementStretch", "ptr", $h_Texture, "int", $i_DestTopX, "int", $i_DestTopY, "int", $i_DestBottomX, "int", $i_DestBottomY, "int", $i_SourceTopX, "int", $i_SourceTopY, "int", $i_SourceBottomX, "int", $i_SourceBottomY, "int", $i_UseAlpha)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrDraw2DImageElementStretch

; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetFont
; Description ...: Loads a bitmap containing a bitmap font.
; Syntax.........: _IrrGetFont($s_Font)
; Parameters ....: $s_Font - Filename of the bitmap font file
; Return values .: Success - Handle of the irrlicht font texture object
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: None
; Related .......: _Irr2DFontDraw
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrGetFont($s_Font)
	Local $aResult
	$aResult = DllCall($_irrDll, "ptr:cdecl", "IrrGetFont", "str", $s_Font)
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrGetFont


; #FUNCTION# =============================================================================================================
; Name...........: _Irr2DFontDraw
; Description ...: Draws the text into the supplied rectangular area using the supplied font object.
; Syntax.........: _Irr2DFontDraw($h_Font, $s_Text, $i_XPos, $i_YPos, $i_BottomX, $i_BottomY)
; Parameters ....: $h_Font - Handle of an irrlicht font texture object
;                  $s_Text - Text string to display
;                  $i_XPos - X top position of rectangle for the text
;                  $i_YPos - Y top position of rectangle for the text
;                  $i_BottomX - X bottom position of rectangle for the text
;                  $i_BottomY - Y bottom position of rectangle for the text
; Return values .: Success - True
;                  Failure - False
; Author ........:
; Modified.......:
; Remarks .......: None
; Related .......: _IrrGetFont
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _Irr2DFontDraw($h_Font, $s_Text, $i_XPos, $i_YPos, $i_BottomX, $i_BottomY)
	DllCall($_irrDll, "none:cdecl", "Irr2DFontDraw", "ptr", $h_Font, "wstr", $s_Text, "int", $i_XPos, "int", $i_YPos, "int", $i_BottomX, "int", $i_BottomY)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_Irr2DFontDraw


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSaveScreenShot
; Description ...: Save a screenshot out to a file.
; Syntax.........: _IrrSaveScreenShot($s_Filename)
; Parameters ....: $s_Filename - file name to save the screenshot as.
; Return values .: Success - True
;                  Failure - False
; Author ........: smashly
; Modified.......:
; Remarks .......: The image format is defined by the extension applied to the filename.
;+
;                  Irrlicht currently supports: bmp, png, tga, ppm and jpg
; Related .......: _IrrGetScreenShot
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrSaveScreenShot($s_Filename)
	DllCall($_irrDll, "none:cdecl", "IrrSaveScreenShot", "str", $s_Filename)
	Return SetError(@error, 0, @error = 0)
EndFunc   ;==>_IrrSaveScreenShot


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetScreenShot
; Description ...: Return a pointer to a texture containing a rectangular portion of a screenshot.
; Syntax.........: _IrrGetScreenShot($i_XPos, $i_YPos, $i_Width, $i_Height)
; Parameters ....: $i_XPos - X position for the screenshot
;                  $i_YPos - Y position for the screenshot
;                  $i_Width - Width of the screebshot
;                  $i_Height - Height of the screebshot
; Return values .: Success - Pointer to a texture containing a rectangular portion of a screenshot.
;                  Failure - False and @error 1
; Author ........: smashly
; Modified.......:
; Remarks .......: None
; Related .......: _IrrSaveScreenShot, _IrrDraw2DImage, _IrrDraw2DImageElement, _IrrDraw2DImageElementStretch
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrGetScreenShot($i_XPos, $i_YPos, $i_Width, $i_Height)
	Local $aResult
	$aResult = DllCall($_irrDll, "ptr:cdecl", "IrrGetScreenShot", "int", $i_XPos, "int", $i_YPos, "int", $i_Width, "int", $i_Height)
	If @error Or Not $aResult[0] Then Return SetError(1, 0, False)
	Return SetError(0, 0, $aResult[0])
EndFunc   ;==>_IrrGetScreenShot

; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetTextureInformation
; Description ...: Get information of a texture. The width, height, pitch and color format is returned in an array.
; Syntax.........: _IrrGetTextureInformation($h_Texture)
; Parameters ....: $h_Texture - Handle to an irrlicht texture object
; Return values .: Success - 1D Array with the information
;                  |$Array[0] = Width of the texture
;                  |$Array[1] = Height of the texture
;                  |$Array[2] = Pitch of the texture
;                  |$Array[3] = Color Reference of the texture (e.g.: $ECF_A1R5G5B5, $ECF_R5G6B5, $ECF_R8G8B8, $ECF_A8R8G8B8)
;                  Failure - Empty Array and Sets @error to 1
; Author ........: smashly
; Modified.......:
; Remarks .......: This function cannot be used for image objects. For this, use _IrrGetImageInformation instead.
; Related .......: _IrrGetTexture, _IrrGetImageInformation
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrGetTextureInformation($h_Texture)
	Local $aResult, $aReturn[4]
	$aResult = DllCall($_irrDll, "none:cdecl", "IrrGetTextureInformation", "ptr", $h_Texture, "uint*", 0, "uint*", 0, "uint*", 0, "int*", 0)
	If @error Or UBound($aResult) <> 6 Then Return SetError(1, 0, $aReturn)
	For $i = 2 To 5
		$aReturn[$i - 2] = $aResult[$i]
	Next
	Return SetError(0, 0, $aReturn)
EndFunc   ;==>_IrrGetTextureInformation


; #FUNCTION# =============================================================================================================
; Name...........: _IrrGetImageInformation
; Description ...: Get information of an image. The width, height, pitch and color format is returned in an array.
; Syntax.........: _IrrGetImageInformation($h_Image)
; Parameters ....: $h_Texture - Handle to an irrlicht image object
; Return values .: Success - 1D Array with the information
;                  |$Array[0] = Width of the image
;                  |$Array[1] = Height of the image
;                  |$Array[2] = Pitch of the image
;                  |$Array[3] = Color Reference of the image (e.g.: $ECF_A1R5G5B5, $ECF_R5G6B5, $ECF_R8G8B8, $ECF_A8R8G8B8)
;                  Failure - Empty Array and Sets @error to 1
; Author ........: smashly
; Modified.......:
; Remarks .......: This function cannot be used for texture objects. For this, use _IrrGetTextureInformation instead.
; Related .......: _IrrGetImage, _IrrGetTextureInformation
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrGetImageInformation($h_Image)
	Local $aResult, $aReturn[4]
	$aResult = DllCall($_irrDll, "none:cdecl", "IrrGetImageInformation", "ptr", $h_Image, "uint*", 0, "uint*", 0, "uint*", 0, "int*", 0)
	If @error Or UBound($aResult) <> 6 Then Return SetError(1, 0, $aReturn)
	For $i = 2 To 5
		$aReturn[$i - 2] = $aResult[$i]
	Next
	Return SetError(0, 0, $aReturn)
EndFunc   ;==>_IrrGetImageInformation
