; #FUNCTION# ====================================================================================================================
; Name ..........: SmartWait4Train
; Description ...: Training time waits are disabled; function returns immediately.
; Syntax ........: SmartWait4Train()
; Parameters ....:
; Return values .: None
; Author ........: MonkeyHunter (05-2016)
; Modified ......: mxkcz
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func SmartWait4Train($iTestSeconds = Default)
	If Not $g_bRunState Then Return
	If $g_bDebugSetlogTrain Or $g_bDebugSetlog Then SetLog("SmartWait4Train skipped: train-time waits disabled.", $COLOR_DEBUG1)
	Return
EndFunc   ;==>SmartWait4Train
