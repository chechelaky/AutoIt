; -----------------------------------------------------------------------------
; JSMN UDF (2013/05/19)
; Purpose: A Non-Strict JavaScript Object Notation (JSON) Parser UDF
; Author: Ward
;         http://www.autoitscript.com/forum/user/10768-ward/
; Required: AutoIt v3.3.8.0
;
; JSON website: http://www.json.org/index.html
; jsmn website: http://zserge.com/jsmn.html
; https://github.com/ez2sugul/stopwatch_client/blob/master/JSMN.au3
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Internal Functions:
; _Jsmn_Shutdown()
; _Jsmn_Startup()
; _Jsmn_Token(ByRef $Json, $Ptr, ByRef $Next)
;
; Public Functions:
; Jsmn_StringEncode($String, $Option = 0)
; Jsmn_StringDecode($String)
; Jsmn_IsObject(ByRef $Object)
; Jsmn_IsNull(ByRef $Null)
; Jsmn_Encode_Compact($Data, $Option = 0)
; Jsmn_Encode_Pretty($Data, $Option, $Indent, $ArraySep, $ObjectSep, $ColonSep, $ArrayCRLF = Default, $ObjectCRLF = Default, $NextIdent = "")
; Jsmn_Encode($Data, $Option = 0, $Indent = Default, $ArraySep = Default, $ObjectSep = Default, $ColonSep = Default)
; Jsmn_Decode($Json, $InitTokenCount = 1000)
; Jsmn_ObjTo2DArray(ByRef $Object)
; Jsmn_ObjFrom2DArray(ByRef $Array)
; Jsmn_ObjCreate()
; Jsmn_ObjPut(ByRef $Object, $Key, $Value)
; Jsmn_ObjGet(ByRef $Object, $Key)
; Jsmn_ObjDelete(ByRef $Object, $Key)
; Jsmn_ObjExists(ByRef $Object, $Key)
; Jsmn_ObjGetCount(ByRef $Object)
; Jsmn_ObjGetKeys(ByRef $Object)
; Jsmn_ObjClear(ByRef $Object)
; -----------------------------------------------------------------------------

#include-once
#include <Memory.au3>
#include <Array.au3>
;~ Opt("MustDeclareVars", 1)

; The following constants can be combined to form options for Jsmn_Encode()
Global Const $JSMN_UNESCAPED_UNICODE = 1 ; Encode multibyte Unicode characters literally
Global Const $JSMN_UNESCAPED_SLASHES = 2 ; Don't escape /
Global Const $JSMN_HEX_TAG = 4 ; All < and > are converted to \u003C and \u003E
Global Const $JSMN_HEX_AMP = 8 ; All &s are converted to \u0026
Global Const $JSMN_HEX_APOS = 16 ; All ' are converted to \u0027
Global Const $JSMN_HEX_QUOT = 32 ; All " are converted to \u0022
Global Const $JSMN_UNESCAPED_ASCII = 64 ; Don't escape ascii charcters between chr(1) ~ chr(0x1f)
Global Const $JSMN_PRETTY_PRINT = 128 ; Use whitespace in returned data to format it
Global Const $JSMN_STRICT_PRINT = 256 ; Make sure returned JSON string is RFC4627 compliant
Global Const $JSMN_UNQUOTED_STRING = 512 ; Output unquoted string if possible (conflicting with $JSMN_STRICT_PRINT)
Global Const $SD = "Scripting.Dictionary"

; Error value returnd by Jsmn_Decode()
Global $JSMN_ERROR_NOMEM = -1 ; Not enough tokens were provided
Global $JSMN_ERROR_INVAL = -2 ; Invalid character inside JSON string
Global $JSMN_ERROR_PART = -3 ; The string is not a full JSON packet, more bytes expected

Global $_Jsmn_CodeBuffer, $_Jsmn_CodeBufferPtr
Global $_Jsmn_InitPtr, $_Jsmn_ParsePtr, $_Jsmn_StringEncodePtr, $_Jsmn_StringDecodePtr
Global $_Jsmn_EmptyArray, $_Jsmn_TokenSize = DllStructGetSize(DllStructCreate("int type;int start;int end;int size;int parent"))

Global Const $_JSONNull = Default

Func _JSONIsNull($vv)
	; uniquely identify $_JSONNull
	Return $vv == Default
EndFunc   ;==>_JSONIsNull

Func _Jsmn_Shutdown()
	$_Jsmn_CodeBuffer = 0
	_MemVirtualFree($_Jsmn_CodeBufferPtr, 0, $MEM_RELEASE)
EndFunc   ;==>_Jsmn_Shutdown

Func _Jsmn_Startup()
	If Not IsDllStruct($_Jsmn_CodeBuffer) Then
		Local $Code
		If @AutoItX64 Then
			$Code = "0xFF01E940030000FF02EB0EFF03E9CE050000FF04E9A0030000564589C9534883EC08E9C90200006683F82C0F84BD020000773" & _
					"76683F80D0F84B1020000771283E8096683F8010F873F020000E99D0200006683F8200F84930200006683F8220F8526020000E9" & _
					"030100006683F85D0F849F00000077166683F83A0F846E0200006683F85B0F8501020000EB126683F87B740C6683F87D0F85EF0" & _
					"10000EB7C8B59044C63D34D39CA0F83950200004D6BD214FFC38959044F8D141041C74208FFFFFFFF41C74204FFFFFFFF41C742" & _
					"0C0000000041C74210FFFFFFFF448B59084183FBFF74104963F345895A10486BF61441FF44300C6683F87B0F95C0FFCB0FB6C0F" & _
					"FC04189028B0141894204895908E9DB010000BB02000000EB05BB010000008B410485C00F8E0C020000489848FFC8486BC01449" & _
					"8D0400837804FF7420837808FF751A39180F85EB01000041FFC2448950088B4010894108E9910100008B401083F8FF0F8485010" & _
					"0004898EBC2418D42018901E99E0000006683F82275478B59044863C34C39C80F83B2010000486BC01441FFC2FFC3895904498D" & _
					"04004489500444895808C7400C00000000448B5108C700030000004183FAFF448950107571E9290100006683F85C754941FFC34" & _
					"489194589DB66428B045A6683F86E743577226683F862742D77126683F82F74256683F85C741F6683F822EB046683F866757EEB" & _
					"116683F872740B727483E8746683F801776BFF01448B194489D8668B04426685C00F854FFFFFFF448911E9F00000004D63D24D6" & _
					"BD21443FF44100CE9AC0000006683F820745077126683F80972266683F80A76426683F80DEB186683F83A743677066683F82CEB" & _
					"0A6683F85D74286683F87D742283E8206683F85E7608448911E9AF000000FFC389198B1989D8668B04426685C075AA448B59044" & _
					"963C34C39C80F8397000000486BC01441FFC344895904448B19498D0400448958084489500441FFCBC7400C000000008B5908C7" & _
					"00000000008958108B410844891983F8FF740B4898486BC01441FF44000CFF01448B114489D0668B04426685C00F8524FDFFFF8" & _
					"B5104FFCA4863C2486BC014498D440004EB188338FF740D837804FF7507B8FDFFFFFFEB13FFCA4883E81485D279E431C0EB05B8" & _
					"FEFFFFFF5A5B5EC344891183C8FFEBF44883EC08C70100000000C7410400000000C74108FFFFFFFF59C38D41D04883EC086683F" & _
					"80977080FB7C98D41D0EB238D41BF6683F80577080FB7C98D41C9EB128D519F83C8FF6683FA0577060FB7C98D41A94158C34883" & _
					"EC0883F9098D4130760E8D5157B83000000083F9100F42C24159C341544531D24531C955575653E9E90100004489D34C39C30F8" & _
					"300020000488D3C5A41FFC141FFC26683F85C6689070F85C60100004489CB668B04596685C00F84C60100006683F86E0F84A101" & _
					"000077376683F862745877236683F82F0F84920100006683F85C0F84880100006683F8220F8584010000E9790100006683F8660" & _
					"F8575010000EB316683F87474176683F875742F6683F8720F855D010000B00DE950010000B809000000E946010000B808000000" & _
					"E93C010000B80C000000E932010000488D6C5902668B45006685C00F84260100008D58D00FB7F06683FB09770583EE30EB1E8D5" & _
					"8BF6683FB05770583EE37EB1083E8616683F8050F87FA00000083EE5785F60F88EF000000668B45026685C00F84E2000000448D" & _
					"58D00FB7D8664183FB09770583EB30EB20448D58BF664183FB05770583EB37EB1083E8616683F8050F87B200000083EB5785DB0" & _
					"F88A7000000668B45046685C00F849A000000448D60D0440FB7D8664183FC0977064183EB30EB1E448D60BF664183FC05770641" & _
					"83EB37EB0D83E8616683F805776B4183EB574585DB7862668B45066685C07459448D60D00FB7E8664183FC0977058D45D0EB1C4" & _
					"48D60BF664183FC0577058D45C9EB0C83E8616683F805772D8D45A985C07826C1E6044183C10501F3C1E304418D1C1BC1E3048D" & _
					"0403668907EB0BB80A00000066890741FFC14489C8668B04416685C00F8507FEFFFF4589D24D39C2730B6642C70452000031C0E" & _
					"B0383C8FF5B5E5F5D415CC341574489C84531D283E0104531DB415641554589CD4183E50141544589CC4183E402554489CD83E5" & _
					"0857564489CE83E604534883EC18894424044489C84183E14083E02044894C240C89442408E9AB0100004C39C30F83C70100004" & _
					"88D3C5A41FFC26683F81F66890777466683F80E0F83BD0000006683F809747877166683F8010F82B20000006683F8070F86A100" & _
					"0000EB696683F80B0F849500000072426683F80C74606683F80D0F858A000000EB396683F82F745777146683F82674666683F82" & _
					"774596683F822756EEB4B6683F83E74566683F85C74746683F83C755AEB4831DBB86E000000EB6C31DBB872000000EB6331DBB8" & _
					"74000000EB5A31DBB862000000EB5131DBB866000000EB484585E4743AE9E50000008B5C2408EB38837C240400EB0685EDEB028" & _
					"5F67524E9CB000000837C240C00EB0D663DFF000F86BA0000004585ED7409E9B000000031DBEB05BB0100000085DB66C7075C00" & _
					"0F848B000000458D4A044D39C10F83B200000089C74489D3458D720166C1EF0C66C7045A7500448D7F578D5F306683FF09410F4" & _
					"7DF6642891C720FB6DC458D720283E30F448D7B578D7B3083FB09410F47FF6642893C7289C7458D720366C1EF0483E70F8D5F30" & _
					"448D7F5783FF09410F47DF83E00F6642891C728D78578D583083F8090F47DF4183C2056642891C4AEB0F4489D34C39C3732C668" & _
					"9045A41FFC24489D841FFC34489D3668B04416685C00F853FFEFFFF4C39C3730A66C7045A000031C0EB0383C8FF4883C4185B5E" & _
					"5F5D415C415D415E415FC3"
		Else
			$Code = "0xFF01E913030000FF02EB46FF03E924050000FF04E9770300005589E556538B3031DB39CE73256BDE144689308D1C1AC74308F" & _
					"FFFFFFFC74304FFFFFFFFC7430C00000000C74310FFFFFFFF89D85B5E5DC35589E557565383EC088B5D088B7D108D43048945EC" & _
					"E95D02000066837DF22C0F8450020000773E66837DF20D0F84430200007716668B45F283E8096683F8010F87E3010000E92B020" & _
					"00066837DF2200F842002000066837DF2220F85C8010000E9C200000066837DF25D746D771866837DF23A0F84FC01000066837D" & _
					"F25B0F85A4010000EB1466837DF27B740D66837DF27D0F8590010000EB468B4D1489FA8B45ECE821FFFFFF85C00F84020200008" & _
					"B530883FAFF740A6BCA14895010FF440F0C31D266837DF27B0F95C24289108B138950048B430448EB39BA02000000EB05BA0100" & _
					"00008B430485C00F8EC6010000486BC0148D0407837804FF741D837808FF751739100F85AB010000468970088B4010894308E95" & _
					"B0100008B401083F8FF75CFE94E0100008D46018B4D0C8903E98B0000006683F822753B8B4D1489FA8B45ECE881FEFFFF85C00F" & _
					"84F80000008B1346C70003000000897004C7400C000000008950088B530883FAFF8950107565E9000100006683F85C754242668" & _
					"B045189136683F86E743577226683F862742D77126683F82F74256683F85C741F6683F822EB046683F8667574EB116683F87274" & _
					"0B726A83E8746683F8017761FF038B13668B04516685C00F8566FFFFFF8933E9E80000006BD214FF44170CE9940000006683F82" & _
					"0744F77126683F80972266683F80A76416683F80DEB186683F83A743577066683F82CEB0A6683F85D74276683F87D742183E820" & _
					"6683F85E76078933E9910000004289138B138B4D0C668B04516685C075AB8B4D1489FA8B45ECE885FDFFFF85C075048933EB668" & _
					"B138B4B08C700000000008970048950084A83F9FFC7400C00000000894810891374076BC914FF440F0CFF038B338B450C668B04" & _
					"706685C0668945F20F858DFDFFFF8B53044A6BC2148D440704EB0F8338FF7406837804FF74184A83E81485D279ED31C0EB1183C" & _
					"8FFEB0CB8FEFFFFFFEB05B8FDFFFFFF5A595B5E5F5DC35589E58B4508C70000000000C7400400000000C74008FFFFFFFF5DC355" & _
					"89E58B55088D42D06683F80977080FB7D28D42D0EB238D42BF6683F80577080FB7D28D42C9EB128D4A9F83C8FF6683F90577060" & _
					"FB7D28D42A95DC35589E58B550883FA098D4230760E8D4A57B83000000083FA0F0F46C15DC35589E5575631F65331DB83EC148B" & _
					"7D0C897DF0E95E0100003B75100F837A0100008B55F04366890472466683F85C0F85420100008B5508668B045A6685C00F84420" & _
					"100006683F86E0F841301000077376683F862745677236683F82F0F840B0100006683F85C0F84010100006683F8220F85000100" & _
					"00E9F20000006683F8660F85F1000000EB2F6683F87474156683F875742D6683F8720F85D9000000E9C6000000B809000000E9C" & _
					"1000000B808000000E9B7000000B80C000000E9AD0000008B45088D7C5802668B076685C00F84A30000000FB7C0890424E8C8FE" & _
					"FFFF85C08945EC0F888D000000668B47026685C00F84800000000FB7C0890424E8A5FEFFFF85C08945E8786E668B47046685C07" & _
					"4650FB7C0890424E88AFEFFFF85C089C27854668B47066685C0744B0FB7C08904248955E4E86DFEFFFF8B55E485C078368B4DEC" & _
					"83C305C1E104034DE8C1E1048D0C0A8B55F0C1E10401C166894C72FEEB15B80A000000EB05B80D0000008B55F04366894472FE8" & _
					"B5508668B045A6685C00F8592FEFFFF83C8FF8B7DF03B7510730D66C70477000031C0EB0383C8FF83C4145B5E5F5DC35589E557" & _
					"5631F65383EC248B55148B45088B7D0C8945F089D083E0018945E889D083E0028945E489D083E0048945EC89D083E0088945E08" & _
					"9D083E0108945DCE9B40100003B75100F83CC0100008D0C77466683FB1F668919774E6683FB0E0F83DB0000006683FB090F8481" & _
					"00000077166683FB010F82D40000006683FB070F86BB000000EB726683FB0B0F84AF0000000F82D30000006683FB0C74656683F" & _
					"B0D0F85A8000000EB3B6683FB2F745C77186683FB26746E6683FB27745D6683FB220F8588000000EB4A6683FB3E74616683FB5C" & _
					"74086683FB3C7574EB5331C0E98D00000031C0BB72000000E98100000031C0BB74000000EB7831C0BB62000000EB6F31C0BB660" & _
					"00000EB6631C0837DE400EB3589D083E020EB57B801000000837DDC00EB14B801000000837DE000EB09837DEC00B80100000075" & _
					"36E9B5000000B801000000F6C2407427E9A6000000837DE8000F859C0000006681FBFF00B801000000770CE98B00000031C0BB6" & _
					"E00000085C066C7015C0074718D4E043B4D100F839400000089D866C1E80C83E00F66C7047775008904248955D4894DD8E89AFC" & _
					"FFFF66894477020FB6C783E00F890424E887FCFFFF668944770489D883E30F66C1E80483E00F890424E86EFCFFFF66894477068" & _
					"3C605891C24E85EFCFFFF8B4DD88B55D46689044FEB0A3B7510732A66891C77468345F0028B45F0668B186685DB0F853DFEFFFF" & _
					"83C8FF3B7510730D66C70477000031C0EB0383C8FF83C4245B5E5F5DC3"
		EndIf

		Local $Offset_Init = (StringInStr($Code, "FF01") + 1) / 2
		Local $Offset_Parse = (StringInStr($Code, "FF02") + 1) / 2
		Local $Offset_Encode = (StringInStr($Code, "FF03") + 1) / 2
		Local $Offset_Decode = (StringInStr($Code, "FF04") + 1) / 2

		Local $Opcode = Binary($Code)
		$_Jsmn_CodeBufferPtr = _MemVirtualAlloc(0, BinaryLen($Opcode), $MEM_COMMIT, $PAGE_EXECUTE_READWRITE)
		$_Jsmn_CodeBuffer = DllStructCreate("byte[" & BinaryLen($Opcode) & "]", $_Jsmn_CodeBufferPtr)
		DllStructSetData($_Jsmn_CodeBuffer, 1, $Opcode)

		$_Jsmn_InitPtr = $_Jsmn_CodeBufferPtr + $Offset_Init
		$_Jsmn_ParsePtr = $_Jsmn_CodeBufferPtr + $Offset_Parse
		$_Jsmn_StringEncodePtr = $_Jsmn_CodeBufferPtr + $Offset_Encode
		$_Jsmn_StringDecodePtr = $_Jsmn_CodeBufferPtr + $Offset_Decode

		Local $Object = Jsmn_ObjCreate()
		$_Jsmn_EmptyArray = $Object.Keys()

		OnAutoItExitRegister("_Jsmn_Shutdown")
	EndIf
EndFunc   ;==>_Jsmn_Startup

Func _Jsmn_Token(ByRef $Json, $Ptr, ByRef $Next)
	If $Next = -1 Then Return Default

	Local $Token = DllStructCreate("int;int;int;int", $Ptr + ($Next * $_Jsmn_TokenSize))
	Local $Type = DllStructGetData($Token, 1)
	Local $Start = DllStructGetData($Token, 2)
	Local $End = DllStructGetData($Token, 3)
	Local $Size = DllStructGetData($Token, 4)
	$Next += 1

	If $Type = 0 And $Start = 0 And $End = 0 And $Size = 0 Then ; Null Item
		$Next = -1
		Return Default
	EndIf

	Switch $Type
		Case 0 ; JSMN_PRIMITIVE
			Local $Primitive = StringMid($Json, $Start + 1, $End - $Start)
			Switch $Primitive
				Case "true"
					Return True
				Case "false"
					Return False
				Case "null"
					Return Default
				Case Else
					If StringRegExp($Primitive, "^[+\-0-9]") Then
						Return Number($Primitive)
					Else
						Return Jsmn_StringDecode($Primitive)
					EndIf
			EndSwitch

		Case 1 ; JSMN_OBJECT
			Local $Object = Jsmn_ObjCreate()
			For $i = 0 To $Size - 1 Step 2
				Local $Key = _Jsmn_Token($Json, $Ptr, $Next)
				Local $Value = _Jsmn_Token($Json, $Ptr, $Next)
				If Not IsString($Key) Then $Key = Jsmn_Encode($Key)

				If $Object.Exists($Key) Then $Object.Remove($Key)
				$Object.Add($Key, $Value)
			Next
			Return $Object

		Case 2 ; JSMN_ARRAY
			If $Size = 0 Then Return $_Jsmn_EmptyArray
			Local $Array[$Size]
			For $i = 0 To $Size - 1
				$Array[$i] = _Jsmn_Token($Json, $Ptr, $Next)
			Next
			Return $Array

		Case 3 ; JSMN_STRING
			Return Jsmn_StringDecode(StringMid($Json, $Start + 1, $End - $Start))
	EndSwitch
EndFunc   ;==>_Jsmn_Token

Func Jsmn_Encode_String($str = '')
	$str = StringToASCIIArray($str, 0, Default, 0)
	Local $ret = ""
	For $ii = 0 To UBound($str, 1) - 1
		Switch $str[$ii]
			Case 65 To 90, 97 To 122, 48 To 57
				$ret &= ChrW($str[$ii])
			Case Else
				$ret &= "\u" & Hex($str[$ii], 4)
		EndSwitch
	Next
	Return $ret
EndFunc   ;==>Jsmn_Encode_String

Func Jsmn_StringEncode($String, $Option = 0)
	If Not IsDllStruct($_Jsmn_CodeBuffer) Then _Jsmn_Startup()

	Local $Length = StringLen($String) * 6 + 1
	Local $Buffer = DllStructCreate("wchar[" & $Length & "]")
	Local $ret = DllCallAddress("int:cdecl", $_Jsmn_StringEncodePtr, "wstr", $String, "ptr", DllStructGetPtr($Buffer), "uint", $Length, "int", $Option)
;~ 	Return SetError($ret[0], 0, Jsmn_Encode_String(DllStructGetData($Buffer, 1)))
	Return SetError($ret[0], 0, DllStructGetData($Buffer, 1))
EndFunc   ;==>Jsmn_StringEncode

Func Jsmn_StringDecode($String)
	If Not IsDllStruct($_Jsmn_CodeBuffer) Then _Jsmn_Startup()

	Local $Length = StringLen($String) + 1
	Local $Buffer = DllStructCreate("wchar[" & $Length & "]")
	Local $ret = DllCallAddress("int:cdecl", $_Jsmn_StringDecodePtr, "wstr", $String, "ptr", DllStructGetPtr($Buffer), "uint", $Length)
	Return SetError($ret[0], 0, DllStructGetData($Buffer, 1))
EndFunc   ;==>Jsmn_StringDecode

Func Jsmn_IsObject(ByRef $Object)
	Return (IsObj($Object) And ObjName($Object) = "Dictionary")
EndFunc   ;==>Jsmn_IsObject

Func Jsmn_IsNull(ByRef $Null)
	Return IsKeyword($Null) Or (Not IsObj($Null) And VarGetType($Null) = "Object")
EndFunc   ;==>Jsmn_IsNull

Func Jsmn_Encode_Compact($Data, $Option = 0)
	Local $Json
	Select
		Case IsString($Data)
			Return '"' & Jsmn_StringEncode($Data, $Option) & '"'

		Case IsNumber($Data)
			Return $Data

		Case IsArray($Data) And UBound($Data, 0) = 1
			$Json = "["
			For $i = 0 To UBound($Data) - 1
				$Json &= Jsmn_Encode_Compact($Data[$i], $Option) & ","
			Next
			If StringRight($Json, 1) = "," Then $Json = StringTrimRight($Json, 1)
			Return $Json & "]"

		Case Jsmn_IsObject($Data)
			$Json = "{"
			Local $Keys = $Data.Keys()
			For $i = 0 To UBound($Keys) - 1
				$Json &= '"' & Jsmn_StringEncode($Keys[$i], $Option) & '":' & Jsmn_Encode_Compact($Data.Item($Keys[$i]), $Option) & ","
			Next
			If StringRight($Json, 1) = "," Then $Json = StringTrimRight($Json, 1)
			Return $Json & "}"

		Case IsBool($Data)
			Return StringLower($Data)

		Case IsPtr($Data)
			Return Number($Data)

		Case IsBinary($Data)
			Return '"' & Jsmn_StringEncode(BinaryToString($Data, 4), $Option) & '"'

		Case Else ; Keyword, DllStruct, Object
			Return "null"
	EndSelect
EndFunc   ;==>Jsmn_Encode_Compact

Func Jsmn_Encode_Pretty($Data, $Option, $Indent, $ArraySep, $ObjectSep, $ColonSep, $ArrayCRLF = Default, $ObjectCRLF = Default, $NextIdent = "")
	Local $ThisIdent = $NextIdent, $Json = "", $Match, $Length
	Select
		Case IsString($Data)
			Local $String = Jsmn_StringEncode($Data, $Option)
			If BitAND($Option, $JSMN_UNQUOTED_STRING) And Not BitAND($Option, $JSMN_STRICT_PRINT) And Not StringRegExp($String, "[\s,:]") And Not StringRegExp($String, "^[+\-0-9]") Then
				Return $String
			Else
				Return '"' & $String & '"'
			EndIf

		Case IsArray($Data) And UBound($Data, 0) = 1
			If UBound($Data) = 0 Then Return "[]"
			If IsKeyword($ArrayCRLF) Then
				$ArrayCRLF = ""
				$Match = StringRegExp($ArraySep, "[\r\n]+$", 3)
				If IsArray($Match) Then $ArrayCRLF = $Match[0]
			EndIf

			If $ArrayCRLF Then $NextIdent &= $Indent
			$Length = UBound($Data) - 1
			For $i = 0 To $Length
				If $ArrayCRLF Then $Json &= $NextIdent
				$Json &= Jsmn_Encode_Pretty($Data[$i], $Option, $Indent, $ArraySep, $ObjectSep, $ColonSep, $ArrayCRLF, $ObjectCRLF, $NextIdent)
				If $i < $Length Then $Json &= $ArraySep
			Next

			If $ArrayCRLF Then Return "[" & $ArrayCRLF & $Json & $ArrayCRLF & $ThisIdent & "]"
			Return "[" & $Json & "]"

		Case Jsmn_IsObject($Data)
			If $Data.Count = 0 Then Return "{}"
			If IsKeyword($ObjectCRLF) Then
				$ObjectCRLF = ""
				$Match = StringRegExp($ObjectSep, "[\r\n]+$", 3)
				If IsArray($Match) Then $ObjectCRLF = $Match[0]
			EndIf

			If $ObjectCRLF Then $NextIdent &= $Indent
			Local $Keys = $Data.Keys()
			$Length = UBound($Keys) - 1
			For $i = 0 To $Length
				If $ObjectCRLF Then $Json &= $NextIdent
				$Json &= Jsmn_Encode_Pretty(String($Keys[$i]), $Option, $Indent, $ArraySep, $ObjectSep, $ColonSep) & $ColonSep _
						 & Jsmn_Encode_Pretty($Data.Item($Keys[$i]), $Option, $Indent, $ArraySep, $ObjectSep, $ColonSep, $ArrayCRLF, $ObjectCRLF, $NextIdent)
				If $i < $Length Then $Json &= $ObjectSep
			Next

			If $ObjectCRLF Then Return "{" & $ObjectCRLF & $Json & $ObjectCRLF & $ThisIdent & "}"
			Return "{" & $Json & "}"

		Case Else
			Return Jsmn_Encode_Compact($Data, $Option)

	EndSelect
EndFunc   ;==>Jsmn_Encode_Pretty

Func Jsmn_Encode($Data, $Option = 0, $Indent = Default, $ArraySep = Default, $ObjectSep = Default, $ColonSep = Default)
	If BitAND($Option, $JSMN_PRETTY_PRINT) Then
		Local $Strict = BitAND($Option, $JSMN_STRICT_PRINT)

		If IsKeyword($Indent) Then
			$Indent = @TAB
		Else
			$Indent = Jsmn_StringDecode($Indent)
			If StringRegExp($Indent, "[^\t ]") Then $Indent = @TAB
		EndIf

		If IsKeyword($ArraySep) Then
			$ArraySep = "," & @CRLF
		Else
			$ArraySep = Jsmn_StringDecode($ArraySep)
			If $ArraySep = "" Or StringRegExp($ArraySep, "[^\s,]|,.*,") Or ($Strict And Not StringRegExp($ArraySep, ",")) Then $ArraySep = "," & @CRLF
		EndIf

		If IsKeyword($ObjectSep) Then
			$ObjectSep = "," & @CRLF
		Else
			$ObjectSep = Jsmn_StringDecode($ObjectSep)
			If $ObjectSep = "" Or StringRegExp($ObjectSep, "[^\s,]|,.*,") Or ($Strict And Not StringRegExp($ObjectSep, ",")) Then $ObjectSep = "," & @CRLF
		EndIf

		If IsKeyword($ColonSep) Then
			$ColonSep = ": "
		Else
			$ColonSep = Jsmn_StringDecode($ColonSep)
			If $ColonSep = "" Or StringRegExp($ColonSep, "[^\s,:]|[,:].*[,:]") Or ($Strict And (StringRegExp($ColonSep, ",") Or Not StringRegExp($ColonSep, ":"))) Then $ColonSep = ": "
		EndIf

		Return Jsmn_Encode_Pretty($Data, $Option, $Indent, $ArraySep, $ObjectSep, $ColonSep)

	ElseIf BitAND($Option, $JSMN_UNQUOTED_STRING) Then
		Return Jsmn_Encode_Pretty($Data, $Option, "", ",", ",", ":")
	Else
		Return Jsmn_Encode_Compact($Data, $Option)
	EndIf
EndFunc   ;==>Jsmn_Encode

Func Jsmn_Decode($Json, $InitTokenCount = 1000)
	If Not IsDllStruct($_Jsmn_CodeBuffer) Then _Jsmn_Startup()

	If $Json = "" Then $Json = '""'
	Local $TokenList, $ret
	Local $Parser = DllStructCreate("uint pos;int toknext;int toksuper")
	Do
		DllCallAddress("none:cdecl", $_Jsmn_InitPtr, "ptr", DllStructGetPtr($Parser))
		$TokenList = DllStructCreate("byte[" & $_Jsmn_TokenSize * $InitTokenCount & "]")
		$ret = DllCallAddress("int:cdecl", $_Jsmn_ParsePtr, "ptr", DllStructGetPtr($Parser), "wstr", $Json, "ptr", DllStructGetPtr($TokenList), "uint", $InitTokenCount)
		$InitTokenCount *= 2
	Until $ret[0] <> $JSMN_ERROR_NOMEM

	Local $Next = 0
	Return SetError($ret[0], 0, _Jsmn_Token($Json, DllStructGetPtr($TokenList), $Next))
EndFunc   ;==>Jsmn_Decode

Func Jsmn_ObjTo2DArray(ByRef $Object)
	Local $Length
	If Jsmn_IsObject($Object) Then
		Local $Keys = $Object.Keys()
		$Length = UBound($Keys)

		Local $Array[$Length + 1][2]
		$Array[0][0] = Default
		$Array[0][1] = 'JSONObject'

		For $i = 1 To $Length
			Local $Key = $Keys[$i - 1]
			Local $Value = $Object.Item($Key)

			$Array[$i][0] = $Key
			$Array[$i][1] = Jsmn_ObjTo2DArray($Value)
		Next
		Return $Array

	ElseIf IsArray($Object) Then
		$Length = UBound($Object)
		If $Length = 0 Then Return $Object

		Local $Array[$Length]
		For $i = 0 To $Length - 1
			$Array[$i] = Jsmn_ObjTo2DArray($Object[$i])
		Next
		Return $Array

	Else
		Return $Object
	EndIf
EndFunc   ;==>Jsmn_ObjTo2DArray

Func Jsmn_ObjFrom2DArray(ByRef $Array)
	If UBound($Array, 0) = 2 And $Array[0][0] = Default And $Array[0][1] = 'JSONObject' Then
		Local $Object = Jsmn_ObjCreate()
		For $i = 1 To UBound($Array) - 1
			Jsmn_ObjPut($Object, $Array[$i][0], Jsmn_ObjFrom2DArray($Array[$i][1]))
		Next
		Return $Object

	ElseIf IsArray($Array) Then
		For $i = 0 To UBound($Array) - 1
			$Array[$i] = Jsmn_ObjFrom2DArray($Array[$i])
		Next
		Return $Array

	Else
		Return $Array
	EndIf
EndFunc   ;==>Jsmn_ObjFrom2DArray

Func Jsmn_ObjCreate()
	Local $Object = ObjCreate("Scripting.Dictionary")
	$Object.CompareMode = 0
	Return $Object
EndFunc   ;==>Jsmn_ObjCreate

Func Jsmn_ObjPut(ByRef $Object, $Key, $Value)
	$Key = String($Key)
	If $Object.Exists($Key) Then $Object.Remove($Key)
	$Object.Add($Key, $Value)
EndFunc   ;==>Jsmn_ObjPut

Func Jsmn_ObjGet(ByRef $Object, $Key)
	Return $Object.Item(String($Key))
EndFunc   ;==>Jsmn_ObjGet

Func Jsmn_ObjDelete(ByRef $Object, $Key)
	$Key = String($Key)
	If $Object.Exists($Key) Then $Object.Remove($Key)
EndFunc   ;==>Jsmn_ObjDelete

Func Jsmn_ObjExists(ByRef $Object, $Key)
	Return $Object.Exists(String($Key))
EndFunc   ;==>Jsmn_ObjExists

Func Jsmn_ObjGetCount(ByRef $Object)
	Return $Object.Count
EndFunc   ;==>Jsmn_ObjGetCount

Func Jsmn_ObjGetKeys(ByRef $Object)
	Return $Object.Keys()
EndFunc   ;==>Jsmn_ObjGetKeys

Func Jsmn_ObjClear(ByRef $Object)
	Return $Object.RemoveAll()
EndFunc   ;==>Jsmn_ObjClear

Func _JSONGet($Json, $sPath, $sSeparator = '.')
;~ 	ConsoleWrite('_JSONGet[' & $JSON & '] $sPath[' & $sPath & '] $separator[' & $sSeparator & ']' & @LF)
	Local $iSeparatorPos, $sCurrent, $sNext, $ll
	$iSeparatorPos = StringInStr($sPath, $sSeparator)
	If $iSeparatorPos > 0 Then
		$sCurrent = StringLeft($sPath, $iSeparatorPos - 1)
		$sNext = StringTrimLeft($sPath, $iSeparatorPos + StringLen($sSeparator) - 1)
	Else
		$sCurrent = $sPath
		$sNext = ''
	EndIf

	If _JSONIsObject($Json) Then
		$ll = UBound($Json, 1)
		For $ii = 0 To $ll - 1
			If $Json[$ii][0] == $sCurrent Then
				If $sNext == '' Then
					Return $Json[$ii][1]
				Else
					Return _JSONGet($Json[$ii][1], $sNext, $sSeparator)
				EndIf
			EndIf
		Next
	ElseIf IsArray($Json) And UBound($Json, 0) == 1 And UBound($Json, 1) > $sCurrent Then
		If $sNext == '' Then
			Return $Json[$sCurrent]
		Else
			Return _JSONGet($Json[$sCurrent], $sNext, $sSeparator)
		EndIf
	EndIf
	Return $_JSONNull
EndFunc   ;==>_JSONGet

Func _JSONIsObject($vv)
	If IsArray($vv) And UBound($vv, 0) == 2 And UBound($vv, 2) == 2 Then
		Return _JSONIsNull($vv[0][0]) And $vv[0][1] == 'JSONObject'
	EndIf
	Return False
EndFunc   ;==>_JSONIsObject

Func json_load($sPath = "", $sFileOptions = 0)
	If Not $sPath Then Return SetError(1, 0, 0)
	If Not FileExists($sPath) Then Return SetError(2, 0, 0)
	Local $hFile = FileOpen($sPath, $sFileOptions)
	If @error Or $hFile = -1 Then Return SetError(3, 0, 0)
	Local $Json = FileRead($hFile)
	If @error Then Return SetError(4, 0, 0)
	$Json = Jsmn_Decode($Json)
	If @error Or $Json = Default Then Return SetError(5, 0, 0)
	Return $Json
EndFunc   ;==>json_load

;~ #cs
; #FUNCTION# ====================================================================================================================
; Name...........: JSON_Eval
; Description ...:
; Syntax.........:
; Parameters ....:
; Return values .:
; Author ........: Luismar Chechelaky
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func JSON_Eval($oo, $mPath, $mDefault, $mType = 0, $iMin = 0, $iMax = 0)
;~ 	ConsoleWrite("JSON_Eval($oo, $mPath[ " & $mPath & " ], $mDefault[ " & $mDefault & " ], $mType[ " & $mType & " ], $iMin[ " & $iMin & " ], $iMax[ " & $iMax & " ])" & @LF)
	$mType = Number($mType)
	Local $TRY = False, $arr
	If (ObjName($oo, 2) = $SD) Then
		$arr = StringSplit($mPath, ".")
		Switch $mType
			Case 0
				; STRING
;~ 				ConsoleWrite("String" & @LF)
				Switch $arr[0]
					Case 0
					Case 1
						If $oo.Exists($arr[1]) Then Return $oo.Item($arr[1])
					Case Else
						$TRY = '$oo.Item("' & _ArrayToString($arr, '").Item("', 1, ($arr[0] - 1)) & '").Exists("' & $arr[UBound($arr, 1) - 1] & '")'
						If Execute($TRY) Then Return Execute('$oo.Item("' & _ArrayToString($arr, '").Item("', 1) & '")')
				EndSwitch
				Return $mDefault
			Case 1
				; NUMBER
;~ 				ConsoleWrite("Number" & @LF)
				Switch $arr[0]
					Case 0
					Case 1
						If $oo.Exists($arr[1]) Then
							$TRY = $oo.Item($arr[1])
							Return _JSON_Limit($TRY, $iMin, $iMax)
						EndIf
					Case Else
						$TRY = '$oo.Item("' & _ArrayToString($arr, '").Item("', 1, ($arr[0] - 1)) & '").Exists("' & $arr[UBound($arr, 1) - 1] & '")'
						If Execute($TRY) Then
							$TRY = Execute('$oo.Item("' & _ArrayToString($arr, '").Item("', 1) & '")')
							Return _JSON_Limit($TRY, $iMin, $iMax)
						EndIf
				EndSwitch
				Return Number($mDefault)
			Case 2
				; ARRAY_OPTION
;~ 				ConsoleWrite("Array" & @LF)
				Local $iDefault = _JSON_Limit($mDefault, 0, $arr[0] - 1)
				Local $aOpt = StringSplit($iMin, ".", 2)

				Local $ITEM, $iSearch
				Switch $arr[0]
					Case 0
					Case 1
						$TRY = '$oo.Exists("' & $arr[1] & '")'
						$ITEM = '$oo.Item("' & $arr[1] & '")'
					Case Else
						$TRY = '$oo.Item("' & _ArrayToString($arr, '").Item("', 1, ($arr[0] - 1)) & '").Exists("' & $arr[UBound($arr, 1) - 1] & '")'
						$ITEM = '$oo.Item("' & _ArrayToString($arr, '").Item("', 1, $arr[0]) & '")'
				EndSwitch

				If Execute($TRY) Then
					$ITEM = Execute($ITEM)
					$iSearch = _ArraySearch($aOpt, $ITEM)
					If $iSearch >= 0 Then Return $aOpt[$iSearch]
				EndIf
				Return $aOpt[$iDefault]
			Case 3
				; BOOL
;~ 				ConsoleWrite("Bool" & @LF)
				$TRY = False
				Switch $arr[0]
					Case 0
					Case 1
						If $oo.Exists($arr[1]) Then $TRY = $oo.Item($arr[1])
					Case Else
						$TRY = '$oo.Item("' & _ArrayToString($arr, '").Item("', 1, ($arr[0] - 1)) & '").Exists("' & $arr[UBound($arr, 1) - 1] & '")'
						If Execute($TRY) Then $TRY = Execute('$oo.Item("' & _ArrayToString($arr, '").Item("', 1) & '")')
				EndSwitch

				Switch StringLeft($TRY, 1)
					Case "T", "1"
						Return True
					Case Else
						Return False
				EndSwitch
			Case 5
				; ARRAY
				ConsoleWrite("ARRAY $arr[ " & _ArrayToString($arr, ",") & " ]" & @LF)
;~ 				JSON_Eval($oo, $mPath, $mDefault, $mType = 0, $iMin = 0, $iMax = 0)
;~ 				JSON_Eval($JSON, "properties.view", "8.6", 5)

				Local $ITEM, $iSearch
				Switch $arr[0]
					Case 0
					Case 1
						$TRY = '$oo.Exists("' & $arr[1] & '")'
						$ITEM = '$oo.Item("' & $arr[1] & '")'
					Case Else
						$TRY = '$oo.Item("' & _ArrayToString($arr, '").Item("', 1, ($arr[0] - 1)) & '").Exists("' & $arr[UBound($arr, 1) - 1] & '")'
						$ITEM = '$oo.Item("' & _ArrayToString($arr, '").Item("', 1, $arr[0]) & '")'
				EndSwitch

				If Execute($TRY) Then Return Jsmn_Decode(Execute($ITEM))
				$mDefault = StringSplit($mDefault, "|", 2)
				Return $mDefault

;~ 				$TRY = '$oo.Exists("' & $arr[1] & '")'

;~ 				$mDefault = StringSplit($mDefault, ".", 2)
;~ 				$mType = StringSplit($mType, ".", 2)
;~ 				If Not IsArray($mType) Then Return $mDefault
;~ 				Return $mType
			Case 4
				Switch $arr[0]
					Case 0
					Case 1
						If $oo.Exists($arr[1]) Then
							$TRY = $oo.Item($arr[1])
							If IsArray($TRY) Then Return $TRY
						EndIf
					Case Else
						$TRY = '$oo.Item("' & _ArrayToString($arr, '").Item("', 1, ($arr[0] - 1)) & '").Exists("' & $arr[UBound($arr, 1) - 1] & '")'
						If Execute($TRY) Then
							$TRY = Execute('$oo.Item("' & _ArrayToString($arr, '").Item("', 1) & '")')
							If IsArray($TRY) Then Return $TRY
						EndIf
				EndSwitch
				Return $mDefault
			Case 6
				; FILE
				Local $sFile = @ScriptDir & "\" & JSON_Eval($oo, $mPath, $mDefault, 0)
				If FileExists($sFile) Then Return $sFile
				Return $mDefault
			Case 7 ; ARRAY INDEXED
				; $mDefault = [2, "a", "b", "c"]
				; $mDefault[0] indice default de retorno do array

				Local $ITEM, $iSearch
				Switch $arr[0]
					Case 0
					Case 1
						$TRY = '$oo.Exists("' & $arr[1] & '")'
						$ITEM = '$oo.Item("' & $arr[1] & '")'
					Case Else
						$TRY = '$oo.Item("' & _ArrayToString($arr, '").Item("', 1, ($arr[0] - 1)) & '").Exists("' & $arr[UBound($arr, 1) - 1] & '")'
						$ITEM = '$oo.Item("' & _ArrayToString($arr, '").Item("', 1, $arr[0]) & '")'
				EndSwitch
				$iSearch = _ArraySearch($mDefault, Execute($ITEM), 1)
				If @error Or $iSearch = -1 Then Return $mDefault[$mDefault[0]]
				Return $mDefault[$iSearch]
		EndSwitch
	Else
		Return $mDefault
	EndIf

EndFunc   ;==>JSON_Eval

; #FUNCTION# ====================================================================================================================
; Name...........: _JSON_Limit
; Description ...:
; Syntax.........:
; Parameters ....: $iValue
;                  $iMin
;                  $iMax
; Return values .:
; Author ........: Luismar Chechelaky
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _JSON_Limit($iValue, $iMin, $iMax)
	If $iMin > $iMax Then
		Local $iTemp = $iMax
		$iMax = $iMin
		$iMin = $iTemp
	EndIf
	If $iValue < $iMin Then Return Number($iMin)
	If $iValue > $iMax Then Return Number($iMax)
	Return Number($iValue)
EndFunc   ;==>_JSON_Limit
;~ #ce
