#include-once


; #INDEX# =======================================================================================================================
; Title .........: Constants
; AutoIt Version : v3.3.6.1
; Language ......: English
; Description ...: Global enumerations and constants for the au3Irr2 UDF.
; Author(s) .....: jRowe, linus.
;                  DLL functionality by Frank Dodd and IrrlichtWrapper for FreeBasic team (IrrlichtWrapper.dll),
;                  and Nikolaus Gebhardt and Irrlicht team (Irrlicht.dll).
; Dll(s) ........: IrrlichtWrapper.dll, Irrlicht.dll, msvcp71.dll, msvcr71.dll
; ===============================================================================================================================

; #NO_DOC_FUNCTION# =============================================================================================================
; Not working/documented/implemented at this time
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; ===============================================================================================================================

Global $result
Global $_irrDll



Global Enum $IRR_EDT_NULL, $IRR_EDT_SOFTWARE, $IRR_EDT_SOFTWARE2, $IRR_EDT_OPENGL, $IRR_EDT_DIRECT3D8, $IRR_EDT_DIRECT3D9
Global Enum Step *16 $IRR_BITS_PER_PIXEL_16, $IRR_BITS_PER_PIXEL_32
Global Enum $IRR_WINDOWED, $IRR_FULLSCREEN
Global Enum $IRR_NO_SHADOWS, $IRR_SHADOWS
Global Enum $IRR_IGNORE_EVENTS, $IRR_CAPTURE_EVENTS
Global Enum $IRR_VERTICAL_SYNC_OFF, $IRR_VERTICAL_SYNC_ON
Global Enum $IRR_IGNORE_ALPHA, $IRR_USE_ALPHA
Global Enum $IRR_OFF, $IRR_ON
Global Enum $IRR_EMF_WIREFRAME, $IRR_EMF_POINTCLOUD, $IRR_EMF_GOURAUD_SHADING, $IRR_EMF_LIGHTING, $IRR_EMF_ZBUFFER, $IRR_EMF_ZWRITE_ENABLE, $IRR_EMF_BACK_FACE_CULLING, $IRR_EMF_FRONT_FACE_CULLING, $IRR_EMF_BILINEAR_FILTER, $IRR_EMF_TRILINEAR_FILTER, $IRR_EMF_ANISOTROPIC_FILTER, $IRR_EMF_FOG_ENABLE, $IRR_EMF_NORMALIZE_NORMALS, $IRR_EMF_TEXTURE_WRAP, $IRR_EMF_ANTI_ALIASING, $IRR_EMF_COLOR_MASK, $IRR_EMF_COLOR_MATERIAL
Global Enum $IRR_EMAT_STAND, $IRR_EMAT_RUN, $IRR_EMAT_ATTACK, $IRR_EMAT_PAIN_A, $IRR_EMAT_PAIN_B, $IRR_EMAT_PAIN_C, $IRR_EMAT_JUMP, $IRR_EMAT_FLIP, $IRR_EMAT_SALUTE, $IRR_EMAT_FALLBACK, $IRR_EMAT_WAVE, $IRR_EMAT_POINT, $IRR_EMAT_CROUCH_STAND, $IRR_EMAT_CROUCH_WALK, $IRR_EMAT_CROUCH_ATTACK, $IRR_EMAT_CROUCH_PAIN, $IRR_EMAT_CROUCH_DEATH, $IRR_EMAT_DEATH_FALLBACK, $IRR_EMAT_DEATH_FALLFORWARD, $IRR_EMAT_DEATH_FALLBACKSLOW, $IRR_EMAT_BOOM
Global Enum $IRR_USE_CASE, $IRR_IGNORE_CASE
Global Enum $IRR_USE_PATHS, $IRR_IGNORE_PATHS
Global Enum $IRR_NO_EMITTER, $IRR_DEFAULT_EMITTER
Global Enum $IRR_REPEL, $IRR_ATTRACT



Global Enum _ ; IRR_MATERIAL_TYPES: Material Types
		$IRR_EMT_SOLID, _ ; Standard solid rendering uses one texture
		$IRR_EMT_SOLID_2_LAYER, _ ; 2 blended textures using vertex alpha value
		$IRR_EMT_LIGHTMAP, _ ; 2 textures: 0=color 1=lighting level and ignores vertex lighting
		$IRR_EMT_LIGHTMAP_ADD, _ ; ... as above but adds levels instead of modulating between them
		$IRR_EMT_LIGHTMAP_M2, _ ; ... as above but color levels are multiplied by 2 for brightening
		$IRR_EMT_LIGHTMAP_M4, _ ; ... as above but color leels are multiplied by 4 for brightening
		$IRR_EMT_LIGHTMAP_LIGHTING, _ ; 2 textures: 0=color 1=lighting level but supports dynamic lighting
		$IRR_EMT_LIGHTMAP_LIGHTING_M2, _ ; ... as above but color levels are multiplied by 2 for brightening
		$IRR_EMT_LIGHTMAP_LIGHTING_M4, _ ; ... as above but color leels are multiplied by 4 for brightening
		$IRR_EMT_DETAIL_MAP, _ ; 2 blended textures: the first is a color map the second at a different scale adds and subtracts from the color to add detail
		$IRR_EMT_SPHERE_MAP, _ ; makes the material appear reflective
		$IRR_EMT_REFLECTION_2_LAYER, _ ; a reflective material blended with a color texture
		$IRR_EMT_TRANSPARENT_ADD_COLOR, _ ; a transparency effect that simply adds a color texture to the background. the darker the color the more transparent it is.
		$IRR_EMT_TRANSPARENT_ALPHA_CHANNEL, _ ; a transparency effect that uses the color textures alpha as a transparency level
		$IRR_EMT_TRANSPARENT_ALPHA_CHANNEL_REF, _ ; a transparency effect that uses the color textures alpha, the pixel is only drawn if the alpha is > 127. this is a fast effect that does not blur edges and is ideal for leaves & grass etc.
		$IRR_EMT_TRANSPARENT_VERTEX_ALPHA, _ ; a transparency effect that uses the vertex alpha value
		$IRR_EMT_TRANSPARENT_REFLECTION_2_LAYER, _ ; a transparent & reflecting effect. the first texture is a reflection map, the second a color map. transparency is from vertex alpha
		$IRR_EMT_NORMAL_MAP_SOLID, _ ; A solid normal map renderer. First texture is color, second is normal map. Only use nodes added with IrrAddStaticMeshForNormalMappingToScene. Only supports nearest two lights. Requires vertex and pixel shaders 1.1
		$IRR_EMT_NORMAL_MAP_TRANSPARENT_ADD_COLOR, _ ; ... as above only with a transparency effect that simply adds the color to the background. the darker the color the more transparent it is.
		$IRR_EMT_NORMAL_MAP_TRANSPARENT_VERTEX_ALPHA, _ ; ... as above only with a transparency effect that uses the vertex alpha value
		$IRR_EMT_PARALLAX_MAP_SOLID, _ ; similar to the solid normal map but more realistic providing virtual displacement of the surface. Uses the alpha channel of the normal map for height field displacement. Requires vertex shader 1.1 and pixel shader 1.4.
		$IRR_EMT_PARALLAX_MAP_TRANSPARENT_ADD_COLOR, _ ; ... as above only with a transparency effect that simply adds the color to the background. the darker the color the more transparent it is.
		$IRR_EMT_PARALLAX_MAP_TRANSPARENT_VERTEX_ALPHA, _ ; ... as above only wiht a transparency effect that uses the vertex alpha value
		$IRR_EMT_ONE_TEXTURE_BLEND, _
		$IRR_EMT_FOUR_DETAIL_MAP, _ ; 4 grayscale images in the channels of the first texture mixed with the vertex channels as alpha images
		$IRR_EMT_TRANSPARENT_ADD_ALPHA_CHANNEL_REF, _ ; as above only it adds the texture color rather than replacing it
		$IRR_EMT_TRANSPARENT_ADD_ALPHA_CHANNEL
; $IRR_EMT_FORCE_32BIT = &h7fffffff
; END ENUM IRR_MATERIAL_TYPES

Global Enum _ ; IRR_EGUI_EVENT_TYPE
		$EGET_ELEMENT_FOCUS_LOST = 0, _ 	; ' A gui element has lost its focus.
		$EGET_ELEMENT_FOCUSED, _ 		; ' A gui element has got the focus.
		$EGET_ELEMENT_HOVERED, _ 		; ' The mouse cursor hovered over a gui element.
		$EGET_ELEMENT_LEFT, _ 			; ' The mouse cursor left the hovered element.
		$EGET_ELEMENT_CLOSED, _ 			; ' An element would like to close.
		$EGET_BUTTON_CLICKED, _ 			; ' A button was clicked.
		$EGET_SCROLL_BAR_CHANGED, _ 		; ' A scrollbar has changed its position.
		$EGET_CHECKBOX_CHANGED, _ 		; ' A checkbox has changed its check state.
		$EGET_LISTBOX_CHANGED, _ 		; ' A new item in a listbox was seleted.
		$EGET_LISTBOX_SELECTED_AGAIN, _ 	; ' An item in the listbox was selected, which was already selected.
		$EGET_FILE_SELECTED, _ 			; ' A file has been selected in the file dialog
		$EGET_DIRECTORY_SELECTED, _ 		; ' A directory has been selected in the file dialog
		$EGET_FILE_CHOOSE_DIALOG_CANCELLED, _ 	; ' A file open dialog has been closed without choosing a file
		$EGET_MESSAGEBOX_YES, _ 				; ' 'Yes' was clicked on a messagebox
		$EGET_MESSAGEBOX_NO, _ 				; ' 'No' was clicked on a messagebox
		$EGET_MESSAGEBOX_OK, _ 				; ' 'OK' was clicked on a messagebox
		$EGET_MESSAGEBOX_CANCEL, _ 			; ' 'Cancel' was clicked on a messagebox
		$EGET_EDITBOX_ENTER, _ 				; ' In an editbox 'ENTER' was pressed
		$EGET_EDITBOX_CHANGED, _ 			; ' The text in an editbox was changed. This does not include automatic changes in text-breaking.
		$EGET_EDITBOX_MARKING_CHANGED, _ 	; ' The marked area in an editbox was changed.
		$EGET_TAB_CHANGED, _ 				; ' The tab was changed in an tab control
		$EGET_MENU_ITEM_SELECTED, _ 			; ' A menu item was selected in a (context) menu
		$EGET_COMBO_BOX_CHANGED, _ 			; ' The selection in a combo box has been changed
		$EGET_SPINBOX_CHANGED, _ 			; ' The value of a spin box has changed
		$EGET_TABLE_CHANGED, _ 				; ' A table has changed
		$EGET_TABLE_HEADER_CHANGED, _ 		;
		$EGET_TABLE_SELECTED_AGAIN, _ 		;
		$EGET_TREEVIEW_NODE_DESELECT, _ 		; ' A tree view node lost selection. See IGUITreeView::getLastEventNode().
		$EGET_TREEVIEW_NODE_SELECT, _ 		; ' A tree view node was selected. See IGUITreeView::getLastEventNode().
		$EGET_TREEVIEW_NODE_EXPAND, _ 		; ' A tree view node was expanded. See IGUITreeView::getLastEventNode().
		$EGET_TREEVIEW_NODE_COLLAPS, _ 		; ' A tree view node was collapsed. See IGUITreeView::getLastEventNode().
		$EGET_COUNT ; ' No real event. Just for convenience to get number of events
; End Enum IRR_EGUI_EVENT_TYPE


Global Enum _ 	;IRR_GUI_COLOR_ELEMENT
		$EGDC_3D_DARK_SHADOW = 0, _ ; ' Dark shadow for three-dimensional display elements.
		$EGDC_3D_SHADOW, _ 			; Shadow color for three-dimensional display elements (for edges facing away from the light source).
		$EGDC_3D_FACE, _ 			; Face color for three-dimensional display elements and for dialog box backgrounds.
		$EGDC_3D_HIGH_LIGHT, _ 		; Highlight color for three-dimensional display elements (for edges facing the light source.).
		$EGDC_3D_LIGHT, _ 			; Light color for three-dimensional display elements (for edges facing the light source.).
		$EGDC_ACTIVE_BORDER, _ 		; Active window border.
		$EGDC_ACTIVE_CAPTION, _ 	; Active window title bar text.
		$EGDC_APP_WORKSPACE, _ 		; Background color of multiple document interface (MDI) applications.
		$EGDC_BUTTON_TEXT, _ 		; Text on a button.
		$EGDC_GRAY_TEXT, _ 			; Grayed (disabled) text.
		$EGDC_HIGH_LIGHT, _ 		; Item(s) selected in a control.
		$EGDC_HIGH_LIGHT_TEXT, _ 	; Text of item(s) selected in a control.
		$EGDC_INACTIVE_BORDER, _ 	; Inactive window border.
		$EGDC_INACTIVE_CAPTION, _ 	; Inactive window caption.
		$EGDC_TOOLTIP, _ 			; Tool tip text color.
		$EGDC_TOOLTIP_BACKGROUND, _ ; Tool tip background color.
		$EGDC_SCROLLBAR, _ 			; Scrollbar gray area.
		$EGDC_WINDOW, _ 			; Window background.
		$EGDC_WINDOW_SYMBOL, _ 		; Window symbols like on close buttons, scroll bars and check boxes.
		$EGDC_ICON, _ 				; Icons in a list or tree.
		$EGDC_ICON_HIGH_LIGHT, _ 	; Selected icons in a list or tree.
		$EGDC_COUNT ; this value is not used, it only specifies the amount of default colors available.
; End Enum IRR_GUI_COLOR_ELEMENT

; GUI Interface definitions
Global Const $IRR_GUI_NO_BORDER = 0
Global Const $IRR_GUI_BORDER = 1
Global Const $IRR_GUI_NO_WRAP = 0
Global Const $IRR_GUI_WRAP = 1
Global Const $IRR_GUI_HORIZONTAL = 1
Global Const $IRR_GUI_VERTICAL = 0
Global Const $IRR_GUI_MODAL = 1
Global Const $IRR_GUI_NOT_MODAL = 0
Global Const $IRR_GUI_DRAW_BACKGROUND = 1
Global Const $IRR_GUI_EMPTY_BACKGROUND = 0
Global Const $IRR_GUI_PASSWORD = 1
Global Const $IRR_GUI_NOT_PASSWORD = 0

Global Const $IRR_NO_PARENT = 0
Global Const $IRR_NO_OBJECT = 0
Global Enum $IRR_ONE_SHOT, $IRR_LOOP
Global Enum $IRR_EXPONENTIAL_FOG, $IRR_LINEAR_FOG
Global Enum $ELT_POINT, $ELT_SPOT, $ELT_DIRECTIONAL ; enum E_LIGHT_TYPE: Light types

Global Enum _ ; IRR_COLOR_MATERIAL
		$ECM_NONE, _            ; Dont use vertex color for lighting
		$ECM_DIFFUSE, _         ; Use vertex color for diffuse light, (default)
		$ECM_AMBIENT, _         ; Use vertex color for ambient light
		$ECM_EMISSIVE, _        ; Use vertex color for emissive light
		$ECM_SPECULAR, _        ; Use vertex color for specular light
		$ECM_DIFFUSE_AND_AMBIENT ;Use vertex color for both diffuse and ambient light

Global Enum _ ; IRR_BLEND_FACTOR: blend factors for the ONE_TEXTURE_BLEND material
		$EBF_ZERO, $EBF_ONE, $EBF_DST_COLOR, $EBF_ONE_MINUS_DST_COLOR, $EBF_SRC_COLOR, $EBF_ONE_MINUS_SRC_COLOR, _
		$EBF_SRC_ALPHA, $EBF_ONE_MINUS_SRC_ALPHA, $EBF_DST_ALPHA, $EBF_ONE_MINUS_DST_ALPHA, $EBF_SRC_ALPHA_SATURATE

Global Enum _ ; IRR_COLOR_FORMAT: ' A color format specifies how color information is stored
		$ECF_A1R5G5B5 = 0, _ ; 16 bit color format used by the software driver, and thus preferred by all other irrlicht engine video drivers. There are 5 bits for every color component, and a single bit is left for alpha information.
		$ECF_R5G6B5, _		 ; Standard 16 bit color format.
		$ECF_R8G8B8, _		 ; 24 bit color, no alpha channel, but 8 bit for red, green and blue.
		$ECF_A8R8G8B8 ; Default 32 bit color format. 8 bits are used for every component: red, green, blue and alpha.

Global Enum _ ; IRR_MESH_FILE_FORMAT: Enumeration flags defining the file format supported loading and saving
		$EMWT_IRR_MESH = 0, _ 	; Irrlicht Native mesh writer, for static .irrmesh files.
		$EMWT_COLLADA, _		; COLLADA mesh writer for .dae and .xml files.
		$EMWT_STL ; STL mesh writer for .stl files.

Global Enum _ ; IRR_TERRAIN_PATCH_SIZE
		$ETPS_9 = 9, _	; patch size of 9, at most, use 4 levels of detail with this patch size.
		$ETPS_17 = 17, _; patch size of 17, at most, use 5 levels of detail with this patch size.
		$ETPS_33 = 33, _; patch size of 33, at most, use 6 levels of detail with this patch size.
		$ETPS_65 = 65, _; patch size of 65, at most, use 7 levels of detail with this patch size.
		$ETPS_129 = 129 ; patch size of 129, at most, use 8 levels of detail with this patch size.

Global Enum _ ; IRR_VIDEO_FEATURE_QUERY: enumeration for querying features of the video driver.
		$EVDF_RENDER_TO_TARGET, _ ; Is driver able to render to a surface?
		$EVDF_HARDWARE_TL, _ ; Is hardeware transform and lighting supported?
		$EVDF_MULTITEXTURE, _ ; Are multiple textures per material possible?
		$EVDF_BILINEAR_FILTER, _ ; Is driver able to render with a bilinear filter applied?
		$EVDF_MIP_MAP, _ ; Can the driver handle mip maps?
		$EVDF_MIP_MAP_AUTO_UPDATE, _ ; Can the driver update mip maps automatically?
		$EVDF_STENCIL_BUFFER, _ ; Are stencilbuffers switched on and does the device support stencil buffers?
		$EVDF_VERTEX_SHADER_1_1, _ ; Is Vertex Shader 1.1 supported?
		$EVDF_VERTEX_SHADER_2_0, _ ; Is Vertex Shader 2.0 supported?
		$EVDF_VERTEX_SHADER_3_0, _ ; Is Vertex Shader 3.0 supported?
		$EVDF_PIXEL_SHADER_1_1, _ ; Is Pixel Shader 1.1 supported?
		$EVDF_PIXEL_SHADER_1_2, _ ; Is Pixel Shader 1.2 supported?
		$EVDF_PIXEL_SHADER_1_3, _ ; Is Pixel Shader 1.3 supported?
		$EVDF_PIXEL_SHADER_1_4, _ ; Is Pixel Shader 1.4 supported?
		$EVDF_PIXEL_SHADER_2_0, _ ; Is Pixel Shader 2.0 supported?
		$EVDF_PIXEL_SHADER_3_0, _ ; Is Pixel Shader 3.0 supported?
		$EVDF_ARB_VERTEX_PROGRAM_1, _ ; Are ARB vertex programs v1.0 supported?
		$EVDF_ARB_FRAGMENT_PROGRAM_1, _ ; Are ARB fragment programs v1.0 supported?
		$EVDF_ARB_GLSL, _ ; Is GLSL supported?
		$EVDF_HLSL, _ ; Is HLSL supported?
		$EVDF_TEXTURE_NSQUARE, _ ; Are non-square textures supported?
		$EVDF_TEXTURE_NPOT, _ ; Are non-power-of-two textures supported?
		$EVDF_FRAMEBUFFER_OBJECT, _ ; Are framebuffer objects supported?
		$EVDF_VERTEX_BUFFER_OBJECT, _ ; Are vertex buffer objects supported?
		$EVDF_ALPHA_TO_COVERAGE, _ ; Supports Alpha To Coverage
		$EVDF_COLOR_MASK, _ ; Supports Color masks (disabling color planes in output)
		$EVDF_MULTIPLE_RENDER_TARGETS, _ ; Supports multiple render targets at once
		$EVDF_MRT_BLEND, _ ; Supports separate blend settings for multiple render targets
		$EVDF_MRT_COLOR_MASK, _ ; Supports separate color masks for multiple render targets
		$EVDF_MRT_BLEND_FUNC, _ ; Supports separate blend functions for multiple render targets
		$EVDF_GEOMETRY_SHADER ; Supports geometry shaders
; End Enum ; IRR_VIDEO_FEATURE_QUERY

Global Enum _ ; IRR_JOINT_MODE: Joint animation modes
		$IRR_JOINT_MODE_NONE, $IRR_JOINT_MODE_READ, $IRR_JOINT_MODE_CONTROL

Global Enum _ ; attach a tile onto this tile: used for _IrrAttachTile
		$TOP_EDGE, $BOTTOM_EDGE, $LEFT_EDGE, $RIGHT_EDGE

Global Enum $IRR_KEY_UP, $IRR_KEY_DOWN ; Input definitions

Global Enum _ ; IRR_MOUSE_EVENTS
		$IRR_EMIE_LMOUSE_PRESSED_DOWN, $IRR_EMIE_RMOUSE_PRESSED_DOWN, $IRR_EMIE_MMOUSE_PRESSED_DOWN, $IRR_EMIE_LMOUSE_LEFT_UP, _
		$IRR_EMIE_RMOUSE_LEFT_UP, $IRR_EMIE_MMOUSE_LEFT_UP, $IRR_EMIE_MOUSE_MOVED, $IRR_EMIE_MOUSE_WHEEL

Global Enum _ ; Enum EKEY_CODE
		$KEY_LBUTTON = 0x0001, _ ;Left mouse button
		$KEY_RBUTTON = 0x0002, _ ;Right mouse button
		$KEY_CANCEL = 0x0003, _ ;Control-break processing
		$KEY_MBUTTON = 0x0004, _ ;Middle mouse button (three-button mouse)
		$KEY_XBUTTON1 = 0x0005, _ ;Windows 2000/XP: X1 mouse button
		$KEY_XBUTTON2 = 0x0006, _ ;Windows 2000/XP: X2 mouse button
		$KEY_BACK = 0x0008, _ ;BACKSPACE key
		$KEY_TAB = 0x0009, _ ;Tab key
		$KEY_CLEAR = 0x000C, _ ;Clear key
		$KEY_RETURN = 0x000D, _ ;ENTER key
		$KEY_SHIFT = 0x0010, _ ;SHIFT key
		$KEY_CONTROL = 0x0011, _ ;CTRL key
		$KEY_MENU = 0x0012, _ ;ALT key
		$KEY_PAUSE = 0x0013, _ ;PAUSE key
		$KEY_CAPITAL = 0x0014, _ ;CAPS Lock key
		$KEY_KANA = 0x0015, _ ;IME Kana mode
		$KEY_HANGUEL = 0x0015, _ ;IME Hanguel mode (maintained For compatibility use KEY_HANGUL)
		$KEY_HANGUL = 0x0015, _ ;IME Hangul mode
		$KEY_JUNJA = 0x0017, _ ;IME Junja mode
		$KEY_FINAL = 0x0018, _ ;IME final mode
		$KEY_HANJA = 0x0019, _ ;IME Hanja mode
		$KEY_KANJI = 0x0019, _ ;IME Kanji mode
		$KEY_ESCAPE = 0x001B, _ ;ESC key
		$KEY_CONVERT = 0x001C, _ ;IME convert
		$KEY_NONCONVERT = 0x001D, _ ;IME nonconvert
		$KEY_ACCEPT = 0x001E, _ ;IME accept
		$KEY_MODECHANGE = 0x001F, _ ;IME mode change request
		$KEY_SPACE = 0x0020, _ ;SPACEBAR
		$KEY_PRIOR = 0x0021, _ ;PAGE UP key
		$KEY_NEXT = 0x0022, _ ;PAGE DOWN key
		$KEY_END = 0x0023, _ ;End key
		$KEY_HOME = 0x0024, _ ;HOME key
		$KEY_LEFT = 0x0025, _ ;Left ARROW key
		$KEY_UP = 0x0026, _ ;UP ARROW key
		$KEY_RIGHT = 0x0027, _ ;Right ARROW key
		$KEY_DOWN = 0x0028, _ ;DOWN ARROW key
		$KEY_SELECT = 0x0029, _ ;Select key
		$KEY_PRINT = 0x002A, _ ;Print key
		$KEY_EXECUT = 0x002B, _ ;EXECUTE key
		$KEY_SNAPSHOT = 0x002C, _ ;Print Screen key
		$KEY_INSERT = 0x002D, _ ;INS key
		$KEY_DELETE = 0x002E, _ ;DEL key
		$KEY_HELP = 0x002F, _ ;HELP key
		$KEY_KEY_0 = 0x0030, _ ;0 key
		$KEY_KEY_1 = 0x0031, _ ;1 key
		$KEY_KEY_2 = 0x0032, _ ;2 key
		$KEY_KEY_3 = 0x0033, _ ;3 key
		$KEY_KEY_4 = 0x0034, _ ;4 key
		$KEY_KEY_5 = 0x0035, _ ;5 key
		$KEY_KEY_6 = 0x0036, _ ;6 key
		$KEY_KEY_7 = 0x0037, _ ;7 key
		$KEY_KEY_8 = 0x0038, _ ;8 key
		$KEY_KEY_9 = 0x0039, _ ;9 key
		$KEY_KEY_A = 0x0041, _ ;A key
		$KEY_KEY_B = 0x0042, _ ;B key
		$KEY_KEY_C = 0x0043, _ ;C key
		$KEY_KEY_D = 0x0044, _ ;D key
		$KEY_KEY_E = 0x0045, _ ;E key
		$KEY_KEY_F = 0x0046, _ ;F key
		$KEY_KEY_G = 0x0047, _ ;G key
		$KEY_KEY_H = 0x0048, _ ;H key
		$KEY_KEY_I = 0x0049, _ ;I key
		$KEY_KEY_J = 0x004A, _ ;J key
		$KEY_KEY_K = 0x004B, _ ;K key
		$KEY_KEY_L = 0x004C, _ ;L key
		$KEY_KEY_M = 0x004D, _ ;M key
		$KEY_KEY_N = 0x004E, _ ;N key
		$KEY_KEY_O = 0x004F, _ ;O key
		$KEY_KEY_P = 0x0050, _ ;P key
		$KEY_KEY_Q = 0x0051, _ ;Q key
		$KEY_KEY_R = 0x0052, _ ;R key
		$KEY_KEY_S = 0x0053, _ ;S key
		$KEY_KEY_T = 0x0054, _ ;T key
		$KEY_KEY_U = 0x0055, _ ;U key
		$KEY_KEY_V = 0x0056, _ ;V key
		$KEY_KEY_W = 0x0057, _ ;W key
		$KEY_KEY_X = 0x0058, _ ;X key
		$KEY_KEY_Y = 0x0059, _ ;Y key
		$KEY_KEY_Z = 0x005A, _ ;Z key
		$KEY_LWIN = 0x005B, _ ;Left Windows key (Microsoft® Natural® keyboard)
		$KEY_RWIN = 0x005C, _ ;Right Windows key (Natural keyboard)
		$KEY_APPS = 0x005D, _ ;Applications key (Natural keyboard)
		$KEY_SLEEP = 0x005F, _ ;Computer Sleep key
		$KEY_NUMPAD0 = 0x0060, _ ;Numeric keypad 0 key
		$KEY_NUMPAD1 = 0x0061, _ ;Numeric keypad 1 key
		$KEY_NUMPAD2 = 0x0062, _ ;Numeric keypad 2 key
		$KEY_NUMPAD3 = 0x0063, _ ;Numeric keypad 3 key
		$KEY_NUMPAD4 = 0x0064, _ ;Numeric keypad 4 key
		$KEY_NUMPAD5 = 0x0065, _ ;Numeric keypad 5 key
		$KEY_NUMPAD6 = 0x0066, _ ;Numeric keypad 6 key
		$KEY_NUMPAD7 = 0x0067, _ ;Numeric keypad 7 key
		$KEY_NUMPAD8 = 0x0068, _ ;Numeric keypad 8 key
		$KEY_NUMPAD9 = 0x0069, _ ;Numeric keypad 9 key
		$KEY_MULTIPLY = 0x006A, _ ;Multiply key
		$KEY_ADD = 0x006B, _ ;Add key
		$KEY_SEPARATOR = 0x006C, _ ;Separator key
		$KEY_SUBTRACT = 0x006D, _ ;Subtract key
		$KEY_DECIMAL = 0x006E, _ ;Decimal key
		$KEY_DIVIDE = 0x006F, _ ;Divide key
		$KEY_F1 = 0x0070, _ ;F1 key
		$KEY_F2 = 0x0071, _ ;F2 key
		$KEY_F3 = 0x0072, _ ;F3 key
		$KEY_F4 = 0x0073, _ ;F4 key
		$KEY_F5 = 0x0074, _ ;F5 key
		$KEY_F6 = 0x0075, _ ;F6 key
		$KEY_F7 = 0x0076, _ ;F7 key
		$KEY_F8 = 0x0077, _ ;F8 key
		$KEY_F9 = 0x0078, _ ;F9 key
		$KEY_F10 = 0x0079, _ ;F10 key
		$KEY_F11 = 0x007A, _ ;F11 key
		$KEY_F12 = 0x007B, _ ;F12 key
		$KEY_F13 = 0x007C, _ ;F13 key
		$KEY_F14 = 0x007D, _ ;F14 key
		$KEY_F15 = 0x007E, _ ;F15 key
		$KEY_F16 = 0x007F, _ ;F16 key
		$KEY_F17 = 0x0080, _ ;F17 key
		$KEY_F18 = 0x0081, _ ;F18 key
		$KEY_F19 = 0x0082, _ ;F19 key
		$KEY_F20 = 0x0083, _ ;F20 key
		$KEY_F21 = 0x0084, _ ;F21 key
		$KEY_F22 = 0x0085, _ ;F22 key
		$KEY_F23 = 0x0086, _ ;F23 key
		$KEY_F24 = 0x0087, _ ;F24 key
		$KEY_NUMLOCK = 0x0090, _ ;NUM Lock key
		$KEY_SCROLL = 0x0091, _ ;SCROLL Lock key
		$KEY_LSHIFT = 0x00A0, _ ;Left SHIFT key
		$KEY_RSHIFT = 0x00A1, _ ;Right SHIFT key
		$KEY_LCONTROL = 0x00A2, _ ;Left CONTROL key
		$KEY_RCONTROL = 0x00A3, _ ;Right CONTROL key
		$KEY_LMENU = 0x00A4, _ ;Left MENU key
		$KEY_RMENU = 0x00A5, _ ;Right MENU key
		$KEY_PLUS = 0x00BB, _ ;Plus Key   (+)
		$KEY_COMMA = 0x00BC, _ ;Comma Key  (,)
		$KEY_MINUS = 0x00BD, _ ;Minus Key  (-)
		$KEY_PERIOD = 0x00BE, _ ;Period Key (.)
		$KEY_ATTN = 0x00F6, _ ;Attn key
		$KEY_CRSEL = 0x00F7, _ ;CrSel key
		$KEY_EXSEL = 0x00F8, _ ;ExSel key
		$KEY_EREOF = 0x00F9, _ ;Erase Eof key
		$KEY_PLAY = 0x00FA, _ ;Play key
		$KEY_ZOOM = 0x00FB, _ ;Zoom key
		$KEY_PA1 = 0x00FD, _ ;PA1 key
		$KEY_OEM_CLEAR = 0x00FE, _ ;Clear key
		$KEY_KEY_CODES_COUNT = 0x00FF ;this Is Not a key but the amount of keycodes there are.
;End Enum EKEY_CODE

Global Enum _ ; E_FILTER_TYPE: filter types, up to 16 samples PCF.
		$EFT_NONE, $EFT_4PCF, $EFT_8PCF, $EFT_12PCF, $EFT_16PCF, $EFT_COUNT

Global Enum _ ; E_SHADOW_MODE shadow modes for lighting
		$ESM_RECEIVE, $ESM_CAST, $ESM_BOTH, $ESM_EXCLUDE, $ESM_COUNT

Global Enum _ ; IRR_SHADER_CONSTANTS ' Pre-programmed shader constants
		$IRR_NO_PRESET, $IRR_INVERSE_WORLD, $IRR_WORLD_VIEW_PROJECTION, $IRR_CAMERA_POSITION, $IRR_TRANSPOSED_WORLD

Global Enum _ ; IRR_DEBUG
		$EDS_OFF = 0, $EDS_BBOX = 1, $EDS_NORMALS = 2, $EDS_SKELETON = 4, $EDS_MESH_WIRE_OVERLAY = 8, _
		$EDS_HALF_TRANSPARENCY = 16, $EDS_BBOX_BUFFERS = 32, $EDS_FULL = 0xffffffff

Global Enum _ ; Constants for 2D Management TEXTURE_CREATION_FLAG
		$ETCF_ALWAYS_16_BIT = 0x00000001, _
		$ETCF_ALWAYS_32_BIT = 0x00000002, _
		$ETCF_OPTIMIZED_FOR_QUALITY = 0x00000004, _
		$ETCF_OPTIMIZED_FOR_SPEED = 0x00000008, _
		$ETCF_CREATE_MIP_MAPS = 0x00000010, _
		$ETCF_NO_ALPHA_CHANNEL = 0x00000020


Global Enum _ ; Constants for 2D Management IRR_TEXTURE_BLEND
		$BLEND_SCREEN, $BLEND_ADD, $BLEND_SUBTRACT, $BLEND_MULTIPLY, $BLEND_DIVIDE



; vertex struct definition and constants for __CreateVertStruct, __GetVertStruct, __SetVertStruct, _IrrCreateMesh
Global Const $tagIRR_VERTEX = "float x; " & _ ;         The x position of the vertex
		"float y; " & _ ;         The y position of the vertex
		"float z; " & _ ;         The z position of the vertex
		"float normal_x; " & _ ;  The x normal of the vertex
		"float normal_y; " & _ ;  The y normal of the vertex
		"float normal_z; " & _ ;  The z normal of the vertex
		"uint vcolor; " & _ ;     The 32bit ARGB color of the vertex
		"float texture_x; " & _ ; the x co-ordinate of the vertex on the texture (0 to 1)
		"float texture_y; " ;     the y co-ordinate of the vertex on the texture (0 to 1)

Global Enum _ ; elements for vertex struct $tagIRR_VERTEX
		$VERT_X = "x", _
		$VERT_Y = "y", _
		$VERT_Z = "z", _
		$VERT_NORMALX = "normal_x", _
		$VERT_NORMALY = "normal_y", _
		$VERT_NORMALZ = "normal_z", _
		$VERT_VCOLOR = "vcolor", _
		$VERT_TEXTUREX = "texture_x", _
		$VERT_TEXTUREY = "texture_y"

; vector struct definition and constants for __CreateVectStruct, __GetVectStruct, __SetVectStruct
Global Const $tagIRR_VECTOR = "float x; " & _ ;         The x position of the vector
		"float y; " & _ ;         The y position of the vector
		"float z; " ;	          The z position of the vector

Global Enum _ ; elements for vector struct $tagIRR_VECTOR
		$VECT_X = "x", _
		$VECT_Y = "y", _
		$VECT_Z = "z"
