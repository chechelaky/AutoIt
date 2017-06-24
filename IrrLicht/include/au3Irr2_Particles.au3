#include-once

#include "au3Irr2_constants.au3"
#include "au3Irr2_system.au3"

; #INDEX# =======================================================================================================================
; Title .........: System
; AutoIt Version : v3.3.6.1
; Language ......: English
; Description ...: Calls to control the appearance and follow of particles in particle systems.
; Author(s) .....: jRowe, linus.
;                  DLL functionality by Frank Dodd and IrrlichtWrapper for FreeBasic team (IrrlichtWrapper.dll),
;                  and Nikolaus Gebhardt and Irrlicht team (Irrlicht.dll).
; Dll(s) ........: IrrlichtWrapper.dll, Irrlicht.dll, msvcp71.dll, msvcr71.dll
; ===============================================================================================================================

; #NO_DOC_FUNCTION# =============================================================================================================
; Not working/documented/implemented at this time
;_IrrSetParticleMinSize
;_IrrSetParticleMaxSize
;_IrrCreateRotationAffector
;_IrrSetParticleEmitterDirection
;_IrrSetFadeOutParticleAffectorTargetColor
;_IrrSetGravityParticleAffectorTimeForceLost
;_IrrSetParticleAttractionAffectorAffectX
;_IrrSetParticleAttractionAffectorAffectY
;_IrrSetParticleAttractionAffectorAffectZ
;_IrrSetParticleAttractionAffectorAttract
;_IrrSetParticleAttractionAffectorPoint
;_IrrSetRotationAffectorPivotPoint
;_IrrSetFurthestDistanceOfEffect
;_IrrSetNearestDistanceOfEffect
;_IrrSetColumnDistanceOfEffect
;_IrrSetStrengthOfEffect
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;__CreateParticleSettings
;_IrrAddParticleEmitter
;_IrrAddAnimatedMeshSceneNodeEmitter
;_IrrAddRotationAffector
;_IrrAddFadeOutParticleAffector
;_IrrAddGravityParticleAffector
;_IrrAddParticleAttractionAffector
;_IrrAddStopParticleAffector
;_IrrAddParticlePushAffector
;_IrrAddColorMorphAffector
;_IrrAddSplineAffector
;_IrrRemoveAffectors
;_IrrSetParticleEmitterMinParticlesPerSecond
;_IrrSetParticleEmitterMaxParticlesPerSecond
;_IrrSetParticleEmitterMinStartColor
;_IrrSetParticleEmitterMaxStartColor
;_IrrSetParticleAffectorEnable
;_IrrSetFadeOutParticleAffectorTime
;_IrrSetGravityParticleAffectorDirection
;_IrrSetCenterOfEffect
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; ===============================================================================================================================

; #FUNCTION# =============================================================================================================
; Name...........: __CreateParticleSettings
; Description ...: Helper function: Creates particle settings as required from _IrrAddParticleEmitter.
; Syntax.........: __CreateParticleSettings($minBoxX, $minBoxY, $minBoxZ, $maxBoxX, $maxBoxY, $maxBoxZ, $directionX, $directionY, $directionZ, $minParticlesSecond, $maxParticlesSecond, $minStartColorR, $minStartColorG, $minStartColorB, $maxStartColorR, $maxStartColorG, $maxStartColorB, $minLifetime, $maxLifetime, $minStartSizeX, $minStartSizeY, $maxStartSizeX, $maxStartSizeY, $maxAngleDegrees)
; Parameters ....: $minBoxX, $minBoxY, $minBoxZ - Minimal positions of a a box in space inside which the position of a particle is randomly created.
;                  $maxBoxX, $maxBoxY, $maxBoxZ - Maximal positions of a a box in space inside which the position of a particle is randomly created.
;                  $directionX, $directionY, $directionZ - Define a direction into which the particles will be ejected as the animation plays.
;                  $minParticlesSecond, $maxParticlesSecond - A range defining the minimum and maximum number of particles that will be created each second.
;                  $minStartColorR, $minStartColorG, $minStartColorB, $maxStartColorR, $maxStartColorG, $maxStartColorB - Although particles can be textured by texturing the particle system node, these can be used to apply a range that tints the color of the particles.
;                  $minLifetime, $maxLifetime - How long the partilce will live, long lifespans can create very large numbers of particles.
;                  $minStartSizeX, $minStartSizeY, $maxStartSizeX, $maxStartSizeY - The minimum and maximum start sizes for the particles.
;                  $maxAngleDegrees - The maximum number of degrees that the ejected particles will deviate from the defined direction.
; Return values .: Array that can be passed to _IrrAddParticleEmitter
; Author ........:
; Modified.......:
; Remarks .......: None
; Related .......: _IrrAddParticleSystemToScene, _IrrAddParticleEmitter
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func __CreateParticleSettings($minBoxX, $minBoxY, $minBoxZ, $maxBoxX, $maxBoxY, $maxBoxZ, $directionX, $directionY, $directionZ, $minParticlesSecond, $maxParticlesSecond, $minStartColorR, $minStartColorG, $minStartColorB, $maxStartColorR, $maxStartColorG, $maxStartColorB, $minLifetime, $maxLifetime, $minStartSizeX, $minStartSizeY, $maxStartSizeX, $maxStartSizeY, $maxAngleDegrees)
	local $arr[24] =  [ $minBoxX, $minBoxY, $minBoxZ, $maxBoxX, $maxBoxY, $maxBoxZ, _
						$directionX, $directionY, $directionZ, $minParticlesSecond, $maxParticlesSecond, _
						$minStartColorR, $minStartColorG, $minStartColorB, $maxStartColorR, $maxStartColorG, $maxStartColorB, _
						$minLifetime, $maxLifetime, $minStartSizeX, $minStartSizeY, $maxStartSizeX, $maxStartSizeY, $maxAngleDegrees ]
	return $arr
EndFunc   ;==>__CreateParticleEmitter


; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddParticleEmitter
; Description ...: Adds a particle emitter to a particle system.
; Syntax.........: _IrrAddParticleEmitter($h_ParticleSystem, $a_Settings)
; Parameters ....: $h_ParticleSystem - Handle of particle system the emitter shall be attached to.
;                  $a_Settings - Array with particle emitter settings created with __CreateParticleSettings.
; Return values .: success - Handle of the created particle emitter
;                  failure - False
; Author ........:
; Modified.......:
; Remarks .......: The emitter creates particles and controls how they move and when they are to be removed.
; Related .......: _IrrAddParticleSystemToScene, __CreateParticleSettings
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrAddParticleEmitter($h_ParticleSystem, $a_Settings)
	$result = DllCall($_irrDll, "UINT_PTR:cdecl", "IrrAddParticleEmitter", "UINT_PTR", $h_ParticleSystem, _
						"float", $a_Settings[0], "float", $a_Settings[1], "float", $a_Settings[2], _
						"float", $a_Settings[3], "float", $a_Settings[4], "float", $a_Settings[5], _
						"float", $a_Settings[6], "float", $a_Settings[7], "float", $a_Settings[8], _
						"UINT", $a_Settings[9], "UINT", $a_Settings[10], _
						"int", $a_Settings[11], "int", $a_Settings[12], "int", $a_Settings[13], _
						"int", $a_Settings[14], "int", $a_Settings[15], "int", $a_Settings[16], _
						"UINT", $a_Settings[17], "UINT", $a_Settings[18], "float", $a_Settings[19], _
						"float", $a_Settings[20], "float", $a_Settings[21], "float", $a_Settings[22], "int", $a_Settings[23])
	Return $result[0]
EndFunc   ;==>_IrrAddParticleEmitter


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrSetParticleMinSize
; Description ...: NOT WORKING DLL FUNCTION - ALSO CRASHING IN FREEBASIC EXAMPLES
; Syntax.........: _IrrSetParticleMinSize($h_Emitter, $f_X, $f_Y)
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
Func _IrrSetParticleMinSize($h_Emitter, $f_X, $f_Y)
	DllCall($_irrDll, "none:cdecl", "IrrSetParticleMinSize", "UINT_PTR", $h_Emitter, "float", $f_X, "float", $f_Y)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrSetParticleMinSize


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrSetParticleMaxSize
; Description ...: NOT WORKING DLL FUNCTION - ALSO CRASHING IN FREEBASIC EXAMPLES
; Syntax.........: _IrrSetParticleMaxSize($h_Emitter, $f_X, $f_Y)
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
Func _IrrSetParticleMaxSize($h_Emitter, $f_X, $f_Y)
	DllCall($_irrDll, "none:cdecl", "IrrSetParticleMaxSize", "UINT_PTR", $h_Emitter, "float", $f_X, "float", $f_Y)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrSetParticleMaxSize


; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddAnimatedMeshSceneNodeEmitter
; Description ...: [todo]
; Syntax.........: _IrrAddAnimatedMeshSceneNodeEmitter($h_ParticleSystem, $h_Node, $b_UseNormals, $f_NormalModifier, $b_FromAllVertices, $a_Settings)
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
Func _IrrAddAnimatedMeshSceneNodeEmitter($h_ParticleSystem, $h_Node, $b_UseNormals, $f_NormalModifier, $b_FromAllVertices, $a_Settings)
	$result = DllCall($_irrDll, "UINT_PTR:cdecl", "IrrAddAnimatedMeshSceneNodeEmitter", "UINT_PTR", $h_ParticleSystem, _
					"UINT_PTR", $h_Node, "UINT", $b_UseNormals, "float", $f_NormalModifier, "int", $b_FromAllVertices, _
					"float", $a_Settings[0], "float", $a_Settings[1], "float", $a_Settings[2], _
					"float", $a_Settings[3], "float", $a_Settings[4], "float", $a_Settings[5], _
					"float", $a_Settings[6], "float", $a_Settings[7], "float", $a_Settings[8], _
					"UINT", $a_Settings[9], "UINT", $a_Settings[10], _
					"int", $a_Settings[11], "int", $a_Settings[12], "int", $a_Settings[13], _
					"int", $a_Settings[14], "int", $a_Settings[15], "int", $a_Settings[16], _
					"UINT", $a_Settings[17], "UINT", $a_Settings[18], "float", $a_Settings[19], _
					"float", $a_Settings[20], "float", $a_Settings[21], "float", $a_Settings[22], "int", $a_Settings[23])
	if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrAddAnimatedMeshSceneNodeEmitter


; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddRotationAffector
; Description ...: Adds a an affector to a particle system rotating the particles.
; Syntax.........: _IrrAddRotationAffector($h_ParticleSystem, $f_SpeedX, $f_SpeedY, $f_SpeedZ, $f_PivotX, $f_pivotY, $f_pivotZ)
; Parameters ....: $h_ParticleSystem - Handle of the particle system the created affector is attached to.
;                  $f_SpeedX, $f_SpeedY, $f_SpeedZ - Set the speed in degrees per second in all 3 dimensions.
;                  $f_PivotX, $f_pivotY, $f_pivotZ - Set the point that particles will rotate around.
; Return values .: success - Handle of the created affector.
;                  failure - false
; Author ........:
; Modified.......:
; Remarks .......: This affector modifies the positions of the particles and attracts them to a specified point at a specified speed per second.
; Related .......: _IrrAddParticleSystemToScene, _IrrSetParticleAffectorEnable, _IrrRemoveAffectors
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrAddRotationAffector($h_ParticleSystem, $f_SpeedX, $f_SpeedY, $f_SpeedZ, $f_PivotX, $f_pivotY, $f_pivotZ)
; Creates a rotation affector. This affector modifies the positions of the
; particles and attracts them to a specified point at a specified speed per second.
	$result = DllCall($_irrDll, "UINT_PTR:cdecl", "IrrAddRotationAffector", "UINT_PTR", $h_ParticleSystem, _
			"float", $f_SpeedX, "float", $f_SpeedY, "float", $f_SpeedZ, "float", $f_PivotX, "float", $f_PivotY, "float", $f_PivotZ)
	if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrAddRotationAffector



; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddFadeOutParticleAffector
; Description ...: Adds a fade out affector to a particle system gradually fading particles out so they are invisible when they are deleted.
; Syntax.........: _IrrAddFadeOutParticleAffector($h_ParticleSystem, $i_FadeFactor, $i_Red, $i_Green, $i_Blue)
; Parameters ....: $h_ParticleSystem - Handle of the particle system the created affector is attached to.
;                  $i_FadeFactor - Milliseconds the fade out effect will take place.
;                  $i_Red, $i_Green, $i_Blue - Values of the colour the particles are faded to (0-255)
; Return values .: success - Handle of the created affector.
;                  failure - false
; Author ........:
; Modified.......:
; Remarks .......: The fade out affector fades the particles out as they come to the end of their lifespan and stops them 'popping' out of existance. This creates a convincing effect for fire and smoke in particular.
; Related .......: _IrrAddParticleSystemToScene, _IrrSetParticleAffectorEnable, _IrrRemoveAffectors
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrAddFadeOutParticleAffector($h_ParticleSystem, $i_FadeFactor, $i_Red, $i_Green, $i_Blue)
	$result = DllCall($_irrDll, "ptr:cdecl", "IrrAddFadeOutParticleAffector", "ptr", $h_ParticleSystem, "int", $i_FadeFactor, "int", $i_Red, "int", $i_Green, "int", $i_Blue)
	if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrAddFadeOutParticleAffector


; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddGravityParticleAffector
; Description ...: Adds a gravity affector to a particle system gradually pulling the particles in the direction of the effect.
; Syntax.........: _IrrAddGravityParticleAffector($h_ParticleSystem, $f_X, $f_Y, $f_Z, $i_TimeForceLost = 1000)
; Parameters ....: $h_ParticleSystem - Handle of the particle system the created affector is attached to.
;                  $f_X, $f_Y, $f_Z - Set the direction and force of gravity in all 3 dimensions.
;                  $i_TimeForceLost - [optional] Set the time in milliseconds when the gravity force is totally lost. At that point the particle does not move any more.
; Return values .: success - Handle of the created affector.
;                  failure - false
; Author ........:
; Modified.......:
; Remarks .......: The gravity affector is adding a small amount of velocity to the particles each frame. Although its called a gravity affector it can be used to push the particles in any direction so you can have drifting smoke bubbling fountains, to make a wind effect and have the particles drift off to the side, etc.
; Related .......: _IrrAddParticleSystemToScene, _IrrSetParticleAffectorEnable, _IrrRemoveAffectors
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrAddGravityParticleAffector($h_ParticleSystem, $f_X, $f_Y, $f_Z, $i_TimeForceLost = 1000)
	$result = DllCall($_irrDll, "UINT_PTR:cdecl", "IrrAddGravityParticleAffector", "UINT_PTR", $h_ParticleSystem, _
						"float", $f_X, "float", $f_Y, "float", $f_Z, "UINT", $i_TimeForceLost)
	if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrAddGravityParticleAffector


; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddParticleAttractionAffector
; Description ...: Adds an affector to a particle system attracting particles to a specified point at a specified speed.
; Syntax.........: _IrrAddParticleAttractionAffector($h_ParticleSystem, $f_X, $f_Y, $f_Z, $f_Speed = 1, $i_Attract = $IRR_ATTRACT, $b_AffectX = true, $b_AffectY = true, $b_AffectZ = true)
; Parameters ....: $h_ParticleSystem - Handle of the particle system the created affector is attached to.
;                  $f_X, $f_Y, $f_Z - Set the point that particles will attract to.
;                  $f_Speed - [optional] Speed in units per second, to attract to the specified point.
;                  $i_Attract - [optional] Set whether or not the particles are attracting or detracting. Values are:
;                  |$IRR_ATTRACT - particles are attracting.
;                  |IRR_REPEL - particles are detracting.
;                  $b_AffectX, $b_AffectY, $b_AffectZ - [optional] Set whether or not this will affect particles in the X, Y, Z direction.
; Return values .: success - Handle of the created affector.
;                  failure - false
; Author ........:
; Modified.......:
; Remarks .......: None.
; Related .......: _IrrAddParticleSystemToScene, _IrrSetParticleAffectorEnable, _IrrRemoveAffectors
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrAddParticleAttractionAffector($h_ParticleSystem, $f_X, $f_Y, $f_Z, $f_Speed = 1, $i_Attract = $IRR_ATTRACT, $b_AffectX = true, $b_AffectY = true, $b_AffectZ = true)
	$result = DllCall($_irrDll, "UINT_PTR:cdecl", "IrrAddParticleAttractionAffector", "UINT_PTR", $h_ParticleSystem, "float", $f_X, "float", $f_Y, "float", $f_Z, "float", $f_Speed, "UINT", $i_Attract, "UINT", $b_AffectX, "UINT", $b_AffectY, "UINT", $b_AffectZ)
	if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrAddParticleAttractionAffector


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrCreateRotationAffector
; Description ...: [todo]
; Syntax.........: _IrrCreateRotationAffector($h_ParticleSystem, $f_SpeedX, $f_SpeedY, $f_SpeedZ, $f_RotX, $f_RotY, $f_RotZ)
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
Func _IrrCreateRotationAffector($h_ParticleSystem, $f_SpeedX, $f_SpeedY, $f_SpeedZ, $f_RotX, $f_RotY, $f_RotZ)
	$result = DllCall($_irrDll, "ptr:cdecl", "IrrCreateRotationAffector", "ptr", $h_ParticleSystem, "float", $f_SpeedX, "float", $f_SpeedY, "float", $f_SpeedZ, "float", $f_RotX, "float", $f_RotY, "float", $f_RotZ)
	if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrCreateRotationAffector


; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddStopParticleAffector
; Description ...: [todo]
; Syntax.........: _IrrAddStopParticleAffector($h_ParticleSystem, $i_Time, $h_Emitter)
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
Func _IrrAddStopParticleAffector($h_ParticleSystem, $i_Time, $h_Emitter)
	$result = DllCall($_irrDll, "ptr:cdecl", "IrrAddStopParticleAffector", "ptr", $h_ParticleSystem, "int", $i_Time, "ptr", $h_Emitter)
	if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrAddStopParticleAffector


; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddParticlePushAffector
; Description ...: [todo]
; Syntax.........: _IrrAddParticlePushAffector($h_ParticleSystem, $f_X, $f_Y, $f_Z, $f_SpeedX, $f_SpeedY, $f_SpeedZ, $f_Far, $f_Near, $f_Column, $i_Distant)
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
Func _IrrAddParticlePushAffector($h_ParticleSystem, $f_X, $f_Y, $f_Z, $f_SpeedX, $f_SpeedY, $f_SpeedZ, $f_Far, $f_Near, $f_Column, $i_Distant)
	$result = DllCall($_irrDll, "ptr:cdecl", "IrrAddParticlePushAffector", "ptr", $h_ParticleSystem, "float", $f_X, "float", $f_Y, "float", $f_Z, "float", $f_SpeedX, "float", $f_SpeedY, "float", $f_SpeedZ, "float", $f_Far, "float", $f_Near, "float", $f_Column, "int", $i_Distant)
	if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrAddParticlePushAffector


; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddColorMorphAffector
; Description ...: [todo]
; Syntax.........: _IrrAddColorMorphAffector($h_ParticleSystem, $a_ParticleColors, $a_ParticleTimes, $b_Smooth)
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
Func _IrrAddColorMorphAffector($h_ParticleSystem, $a_ParticleColors, $a_ParticleTimes, $b_Smooth)
	local $iColors = UBound($a_ParticleColors)
	local $bTimes = IsArray($a_ParticleTimes)
	local $ColorsStruct = DllStructCreate("UINT[" & $iColors & "]")
	local $TimesStruct = 0

	local $i
	For $i = 1 To $iColors
		DllStructSetData($ColorsStruct, 1, $a_ParticleColors[$i - 1], $i)
	Next

	if $bTimes then
		$TimesStruct = DllStructCreate("UINT[" & $iColors & "]")
		For $i = 1 To $iColors
			DllStructSetData($TimesStruct, 1, $a_ParticleTimes[$i - 1], $i)
		Next
	EndIf

	$result = DllCall($_irrDll, "UINT_PTR:cdecl", "IrrAddColorMorphAffector", "UINT_PTR", $h_ParticleSystem, _
	"UINT", $iColors, "UINT_PTR", DllStructGetPtr($ColorsStruct), "UINT_PTR", DllStructGetPtr($TimesStruct), "UINT", $b_Smooth)
	if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrAddColorMorphAffector


; #FUNCTION# =============================================================================================================
; Name...........: _IrrAddSplineAffector
; Description ...: [todo]
; Syntax.........: _IrrAddSplineAffector($h_ParticleSystem, $tVectors, $f_Speed, $f_Tightness, $f_Attraction, $b_DeleteAtEnd)
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
Func _IrrAddSplineAffector($h_ParticleSystem, $tVectors, $f_Speed, $f_Tightness, $f_Attraction, $b_DeleteAtEnd)
	if not IsDllStruct($tVectors) then Return SetError(2, 0, False)

	local $iSplineVerts = DllStructGetSize($tVectors) / DllStructGetSize(DllStructCreate($tagIRR_VECTOR))

	; whyever - dll function expects vectors inside vertices array. So prepare needed structure:
	local $tVertexArray = __CreateVertStruct($iSplineVerts)
	local $i
	for $i = 0 to $iSplineVerts - 1
		__SetVertStruct($tVertexArray, $i, $VERT_X, __GetVectStruct($tVectors, $i, $VECT_X) )
		__SetVertStruct($tVertexArray, $i, $VERT_Y, __GetVectStruct($tVectors, $i, $VECT_Y) )
		__SetVertStruct($tVertexArray, $i, $VERT_Z, __GetVectStruct($tVectors, $i, $VECT_Z) )
	Next

	$result = DllCall($_irrDll, "UINT_PTR:cdecl", "IrrAddSplineAffector", "UINT_PTR", $h_ParticleSystem, _
				"UINT", $iSplineVerts, "ptr", DllStructGetPtr($tVertexArray), "float", $f_Speed, _
				"float", $f_Tightness, "float", $f_Attraction, "UINT", $b_DeleteAtEnd)
	if @error Then
		Return Seterror(1,0,False)
	Else
		Return $result[0]
	EndIf
EndFunc   ;==>_IrrAddSplineAffector


; #FUNCTION# =============================================================================================================
; Name...........: _IrrRemoveAffectors
; Description ...: Removes all affectors from a particle system.
; Syntax.........: _IrrRemoveAffectors($h_ParticleSystem)
; Parameters ....: $h_ParticleSystem - Handle of an Irrlicht particle system.
; Return values .: success - true
;                  failure - false
; Author ........:
; Modified.......:
; Remarks .......: You might use this if you want to change the direction or strength of the wind for example.
; Related .......: _IrrAddParticleSystemToScene, _IrrSetParticleAffectorEnable
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrRemoveAffectors($h_ParticleSystem)
	DllCall($_irrDll, "none:cdecl", "IrrRemoveAffectors", "UINT_PTR", $h_ParticleSystem)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrRemoveAffectors


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrSetParticleEmitterDirection
; Description ...: [todo]
; Syntax.........: _IrrSetParticleEmitterDirection($h_ParticleEmitter, $f_X, $f_Y, $f_Z)
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
Func _IrrSetParticleEmitterDirection($h_ParticleEmitter, $f_X, $f_Y, $f_Z)
	DllCall($_irrDll, "none:cdecl", "IrrSetParticleEmitterDirection", "ptr", $h_ParticleEmitter, "float", $f_X, "float", $f_Y, "float", $f_Z)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrSetParticleEmitterDirection


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetParticleEmitterMinParticlesPerSecond
; Description ...: [todo]
; Syntax.........: _IrrSetParticleEmitterMinParticlesPerSecond($h_ParticleEmitter, $i_Min)
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
Func _IrrSetParticleEmitterMinParticlesPerSecond($h_ParticleEmitter, $i_Min)
	DllCall($_irrDll, "none:cdecl", "IrrSetParticleEmitterMinParticlesPerSecond", "ptr", $h_ParticleEmitter, "int", $i_Min)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrSetParticleEmitterMinParticlesPerSecond


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetParticleEmitterMaxParticlesPerSecond
; Description ...: [todo]
; Syntax.........: _IrrSetParticleEmitterMaxParticlesPerSecond($h_ParticleEmitter, $i_Max)
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
Func _IrrSetParticleEmitterMaxParticlesPerSecond($h_ParticleEmitter, $i_Max)
	DllCall($_irrDll, "none:cdecl", "IrrSetParticleEmitterMaxParticlesPerSecond", "ptr", $h_ParticleEmitter, "int", $i_Max)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrSetParticleEmitterMaxParticlesPerSecond


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetParticleEmitterMinStartColor
; Description ...: [todo]
; Syntax.........: _IrrSetParticleEmitterMinStartColor($h_ParticleEmitter, $i_Red, $i_Green, $i_Blue)
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
Func _IrrSetParticleEmitterMinStartColor($h_ParticleEmitter, $i_Red, $i_Green, $i_Blue)
	DllCall($_irrDll, "none:cdecl", "IrrSetParticleEmitterMinStartColor", "ptr", $h_ParticleEmitter, "int", $i_Red, "int", $i_Green, "int", $i_Blue)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrSetParticleEmitterMinStartColor


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetParticleEmitterMaxStartColor
; Description ...: [todo]
; Syntax.........: _IrrSetParticleEmitterMaxStartColor($h_ParticleEmitter, $i_Red, $i_Green, $i_Blue)
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
Func _IrrSetParticleEmitterMaxStartColor($h_ParticleEmitter, $i_Red, $i_Green, $i_Blue)
	DllCall($_irrDll, "none:cdecl", "IrrSetParticleEmitterMaxStartColor", "ptr", $h_ParticleEmitter, "int", $i_Red, "int", $i_Green, "int", $i_Blue)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrSetParticleEmitterMaxStartColor


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetParticleAffectorEnable
; Description ...: Enables or disables an Irrlicht affector.
; Syntax.........: _IrrSetParticleAffectorEnable($h_ParticleAffector, $b_Enabled)
; Parameters ....: $h_ParticleAffector - Handle of an Irrlicht particle affector
;                  $i_Enabled - $IRR_ON (or true) enables the affector, $IRR_OFF (or false) disables it.
; Return values .: success - true
;                  failure - false
; Author ........:
; Modified.......:
; Remarks .......: None
; Related .......: _IrrAddParticleSystemToScene, _IrrRemoveAffectors
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _IrrSetParticleAffectorEnable($h_ParticleAffector, $b_Enabled)
	DllCall($_irrDll, "none:cdecl", "IrrSetParticleAffectorEnable", "ptr", $h_ParticleAffector, "int", $b_Enabled)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrSetParticleAffectorEnable


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetFadeOutParticleAffectorTime
; Description ...: [todo]
; Syntax.........: _IrrSetFadeOutParticleAffectorTime($h_ParticleAffector, $f_Time)
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
Func _IrrSetFadeOutParticleAffectorTime($h_ParticleAffector, $f_Time)
	DllCall($_irrDll, "none:cdecl", "IrrSetFadeOutParticleAffectorTime", "ptr", $h_ParticleAffector, "float", $f_Time)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrSetFadeOutParticleAffectorTime


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrSetFadeOutParticleAffectorTargetColor
; Description ...: [todo]
; Syntax.........: _IrrSetFadeOutParticleAffectorTargetColor($h_ParticleAffector, $i_Red, $i_Green, $i_Blue)
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
Func _IrrSetFadeOutParticleAffectorTargetColor($h_ParticleAffector, $i_Red, $i_Green, $i_Blue)
	DllCall($_irrDll, "none:cdecl", "IrrSetFadeOutParticleAffectorTargetColor", "ptr", $h_ParticleAffector, "int", $i_Red, "int", $i_Green, "int", $i_Blue)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrSetFadeOutParticleAffectorTargetColor


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetGravityParticleAffectorDirection
; Description ...: [todo]
; Syntax.........: _IrrSetGravityParticleAffectorDirection($h_ParticleAffector, $f_X, $f_Y, $f_Z)
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
Func _IrrSetGravityParticleAffectorDirection($h_ParticleAffector, $f_X, $f_Y, $f_Z)
	DllCall($_irrDll, "none:cdecl", "IrrSetGravityParticleAffectorDirection", "ptr", $h_ParticleAffector, "float", $f_X, "float", $f_Y, "float", $f_Z)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrSetGravityParticleAffectorDirection


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrSetGravityParticleAffectorTimeForceLost
; Description ...: [todo]
; Syntax.........: _IrrSetGravityParticleAffectorTimeForceLost($h_ParticleAffector, $f_TimeForceLost)
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
Func _IrrSetGravityParticleAffectorTimeForceLost($h_ParticleAffector, $f_TimeForceLost)
	DllCall($_irrDll, "none:cdecl", "IrrSetGravityParticleAffectorTimeForceLost", "ptr", $h_ParticleAffector, "float", $f_TimeForceLost)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrSetGravityParticleAffectorTimeForceLost


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrSetParticleAttractionAffectorAffectX
; Description ...: [todo]
; Syntax.........: _IrrSetParticleAttractionAffectorAffectX($h_ParticleAffector, $i_Affect)
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
Func _IrrSetParticleAttractionAffectorAffectX($h_ParticleAffector, $i_Affect)
	DllCall($_irrDll, "none:cdecl", "IrrSetParticleAttractionAffectorAffectX", "ptr", $h_ParticleAffector, "int", $i_Affect)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrSetParticleAttractionAffectorAffectX


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrSetParticleAttractionAffectorAffectY
; Description ...: [todo]
; Syntax.........: _IrrSetParticleAttractionAffectorAffectY($h_ParticleAffector, $i_Affect)
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
Func _IrrSetParticleAttractionAffectorAffectY($h_ParticleAffector, $i_Affect)
	DllCall($_irrDll, "none:cdecl", "IrrSetParticleAttractionAffectorAffectY", "ptr", $h_ParticleAffector, "int", $i_Affect)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrSetParticleAttractionAffectorAffectY


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrSetParticleAttractionAffectorAffectZ
; Description ...: [todo]
; Syntax.........: _IrrSetParticleAttractionAffectorAffectZ($h_ParticleAffector, $i_Affect)
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
Func _IrrSetParticleAttractionAffectorAffectZ($h_ParticleAffector, $i_Affect)
	DllCall($_irrDll, "none:cdecl", "IrrSetParticleAttractionAffectorAffectZ", "ptr", $h_ParticleAffector, "int", $i_Affect)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrSetParticleAttractionAffectorAffectZ


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrSetParticleAttractionAffectorAttract
; Description ...: [todo]
; Syntax.........: _IrrSetParticleAttractionAffectorAttract($h_ParticleAffector, $i_Attract)
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
Func _IrrSetParticleAttractionAffectorAttract($h_ParticleAffector, $i_Attract)
	DllCall($_irrDll, "none:cdecl", "IrrSetParticleAttractionAffectorAttract", "ptr", $h_ParticleAffector, "int", $i_Attract)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrSetParticleAttractionAffectorAttract


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrSetParticleAttractionAffectorPoint
; Description ...: [todo]
; Syntax.........: _IrrSetParticleAttractionAffectorPoint($h_ParticleAffector, $f_X, $f_Y, $f_Z)
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
Func _IrrSetParticleAttractionAffectorPoint($h_ParticleAffector, $f_X, $f_Y, $f_Z)
	DllCall($_irrDll, "none:cdecl", "IrrSetParticleAttractionAffectorPoint", "ptr", $h_ParticleAffector, "float", $f_X, "float", $f_Y, "float", $f_Z)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrSetParticleAttractionAffectorPoint


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrSetRotationAffectorPivotPoint
; Description ...: [todo]
; Syntax.........: _IrrSetRotationAffectorPivotPoint($h_ParticleAffector, $f_X, $f_Y, $f_Z)
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
Func _IrrSetRotationAffectorPivotPoint($h_ParticleAffector, $f_X, $f_Y, $f_Z)
	DllCall($_irrDll, "none:cdecl", "IrrSetRotationAffectorPivotPoint", "ptr", $h_ParticleAffector, "float", $f_X, "float", $f_Y, "float", $f_Z)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrSetRotationAffectorPivotPoint


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrSetFurthestDistanceOfEffect
; Description ...: [todo]
; Syntax.........: _IrrSetFurthestDistanceOfEffect($h_ParticleAffector, $f_Distance)
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
Func _IrrSetFurthestDistanceOfEffect($h_ParticleAffector, $f_Distance)
	DllCall($_irrDll, "none:cdecl", "IrrSetFurthestDistanceOfEffect", "ptr", $h_ParticleAffector, "float", $f_Distance)
EndFunc   ;==>_IrrSetFurthestDistanceOfEffect


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrSetNearestDistanceOfEffect
; Description ...: [todo]
; Syntax.........: _IrrSetNearestDistanceOfEffect($h_ParticleAffector, $f_Distance)
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
Func _IrrSetNearestDistanceOfEffect($h_ParticleAffector, $f_Distance)
	DllCall($_irrDll, "none:cdecl", "IrrSetNearestDistanceOfEffect", "ptr", $h_ParticleAffector, "float", $f_Distance)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrSetNearestDistanceOfEffect


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrSetColumnDistanceOfEffect
; Description ...: [todo]
; Syntax.........: _IrrSetColumnDistanceOfEffect($h_ParticleAffector, $f_Distance)
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
Func _IrrSetColumnDistanceOfEffect($h_ParticleAffector, $f_Distance)
	DllCall($_irrDll, "none:cdecl", "IrrSetColumnDistanceOfEffect", "ptr", $h_ParticleAffector, "float", $f_Distance)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrSetColumnDistanceOfEffect


; #FUNCTION# =============================================================================================================
; Name...........: _IrrSetCenterOfEffect
; Description ...: [todo]
; Syntax.........: _IrrSetCenterOfEffect($h_ParticleAffector, $f_X, $f_Y, $f_Z)
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
Func _IrrSetCenterOfEffect($h_ParticleAffector, $f_X, $f_Y, $f_Z)
	DllCall($_irrDll, "none:cdecl", "IrrSetCenterOfEffect", "ptr", $h_ParticleAffector, "float", $f_X, "float", $f_Y, "float", $f_Z)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrSetCenterOfEffect


; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _IrrSetStrengthOfEffect
; Description ...: [todo]
; Syntax.........: _IrrSetStrengthOfEffect($h_ParticleAffector, $f_X, $f_Y, $f_Z)
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
Func _IrrSetStrengthOfEffect($h_ParticleAffector, $f_X, $f_Y, $f_Z)
	DllCall($_irrDll, "none:cdecl", "IrrSetStrengthOfEffect", "ptr", $h_ParticleAffector, "float", $f_X, "float", $f_Y, "float", $f_Z)
	if @error Then
		Return Seterror(1,0,False)
	Else
		return True
	EndIf
EndFunc   ;==>_IrrSetStrengthOfEffect
