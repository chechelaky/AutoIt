#AutoIt3Wrapper_UseX64=n
#include "Bass.au3"
#include "BassFX.au3"

$sFile = FileOpenDialog("Open...", "..\audiofiles", "playable formats (*.MP3;*.MP2;*.MP1;*.OGG;*.WAV;*.AIFF;*.AIF)")
If @error Or Not FileExists($sFile) Then Exit

_BASS_STARTUP()
_BASS_FX_Startup()

_BASS_Init(0, -1, 44100, 0, "")
$hStream = _BASS_StreamCreateFile(False, $sFile, 0, 0, 0)
_BASS_ChannelPlay($hStream, 1)

Sleep(2000)

$hFX_HiPass = _BASS_ChannelSetFX($hStream, $BASS_FX_BFX_BQF, 1)
_BASS_FXSetParameters($hFX_HiPass, $BASS_BFX_BQF_HIGHPASS & "|" & 1000 & "|0|1|0|0|" & $BASS_BFX_CHANALL)

Sleep(2000)

$hFX_LoPass = _BASS_ChannelSetFX($hStream, $BASS_FX_BFX_BQF, 1)
_BASS_FXSetParameters($hFX_LoPass, $BASS_BFX_BQF_LOWPASS & "|" & 5000 & "|0|1|0|0|" & $BASS_BFX_CHANALL)

Sleep(5000)

_BASS_ChannelRemoveFX($hStream, $hFX_HiPass)
_BASS_ChannelRemoveFX($hStream, $hFX_LoPass)
_BASS_StreamFree($hStream)
_BASS_Free()