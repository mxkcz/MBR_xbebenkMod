; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GkevinOD (2014)
; Modified ......: Hervidero (2015), CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func chkStopAtkDBNoLoot1()
	If GUICtrlRead($g_hChkStopAtkDBNoLoot1) = $GUI_CHECKED Then
		$g_abStopAtkNoLoot1Enable[$Battle] = True
		GUICtrlSetState($g_hTxtStopAtkDBNoLoot1, $GUI_ENABLE)
		GUICtrlSetState($g_hLblStopAtkDBNoLoot1b, $GUI_ENABLE)
	Else
		$g_abStopAtkNoLoot1Enable[$Battle] = False
		GUICtrlSetState($g_hTxtStopAtkDBNoLoot1, $GUI_DISABLE)
		GUICtrlSetState($g_hLblStopAtkDBNoLoot1b, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkStopAtkDBNoLoot1

Func chkStopAtkDBNoLoot2()
	If GUICtrlRead($g_hChkStopAtkDBNoLoot2) = $GUI_CHECKED Then
		$g_abStopAtkNoLoot2Enable[$Battle] = True
		GUICtrlSetState($g_hTxtStopAtkDBNoLoot2, $GUI_ENABLE)
		GUICtrlSetState($g_hLblStopAtkDBNoLoot2b, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtDBMinGoldStopAtk2, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtDBMinElixirStopAtk2, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtDBMinDarkElixirStopAtk2, $GUI_ENABLE)
		GUICtrlSetState($g_hLblDBMinRerourcesAtk2, $GUI_ENABLE)
	Else
		$g_abStopAtkNoLoot2Enable[$Battle] = False
		GUICtrlSetState($g_hTxtStopAtkDBNoLoot2, $GUI_DISABLE)
		GUICtrlSetState($g_hLblStopAtkDBNoLoot2b, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtDBMinGoldStopAtk2, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtDBMinElixirStopAtk2, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtDBMinDarkElixirStopAtk2, $GUI_DISABLE)
		GUICtrlSetState($g_hLblDBMinRerourcesAtk2, $GUI_DISABLE)

	EndIf
EndFunc   ;==>chkStopAtkDBNoLoot2

Func chkStopAtkABNoLoot1()
	If GUICtrlRead($g_hChkStopAtkABNoLoot1) = $GUI_CHECKED Then
		$g_abStopAtkNoLoot1Enable[$RankedBattle] = True
		GUICtrlSetState($g_hTxtStopAtkABNoLoot1, $GUI_ENABLE)
		GUICtrlSetState($g_hLblABTimeStopAtk, $GUI_ENABLE)
	Else
		$g_abStopAtkNoLoot1Enable[$RankedBattle] = False
		GUICtrlSetState($g_hTxtStopAtkABNoLoot1, $GUI_DISABLE)
		GUICtrlSetState($g_hLblABTimeStopAtk, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkStopAtkABNoLoot1

Func chkStopAtkABNoLoot2()
	If GUICtrlRead($g_hChkStopAtkABNoLoot2) = $GUI_CHECKED Then
		$g_abStopAtkNoLoot2Enable[$RankedBattle] = True
		GUICtrlSetState($g_hTxtStopAtkABNoLoot2, $GUI_ENABLE)
		GUICtrlSetState($g_hLblABTimeStopAtk2, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtABMinGoldStopAtk2, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtABMinElixirStopAtk2, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtABMinDarkElixirStopAtk2, $GUI_ENABLE)
		GUICtrlSetState($g_hLblABMinRerourcesAtk2, $GUI_ENABLE)
	Else
		$g_abStopAtkNoLoot2Enable[$RankedBattle] = False
		GUICtrlSetState($g_hTxtStopAtkABNoLoot2, $GUI_DISABLE)
		GUICtrlSetState($g_hLblABTimeStopAtk2, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtABMinGoldStopAtk2, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtABMinElixirStopAtk2, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtABMinDarkElixirStopAtk2, $GUI_DISABLE)
		GUICtrlSetState($g_hLblABMinRerourcesAtk2, $GUI_DISABLE)

	EndIf
EndFunc   ;==>chkStopAtkABNoLoot2

Func chkBattleEndPercentHigher()
	If GUICtrlRead($g_hchkBattleEndPercentHigher) = $GUI_CHECKED Then
		$g_abStopAtkPctHigherEnable[$Battle] = True
		GUICtrlSetState($g_hTxtDBPercentHigher, $GUI_ENABLE)
		GUICtrlSetState($g_hLblDBPercentHigherSec, $GUI_ENABLE)
	Else
		$g_abStopAtkPctHigherEnable[$Battle] = False
		GUICtrlSetState($g_hTxtDBPercentHigher, $GUI_DISABLE)
		GUICtrlSetState($g_hLblDBPercentHigherSec, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkBattleEndPercentHigher

Func chkBattleEndPercentChange()
	If GUICtrlRead($g_hchkBattleEndPercentChange) = $GUI_CHECKED Then
		$g_abStopAtkPctNoChangeEnable[$Battle] = True
		GUICtrlSetState($g_hTxtDBPercentChange, $GUI_ENABLE)
		GUICtrlSetState($g_hLblDBPercentChangeSec, $GUI_ENABLE)
	Else
		$g_abStopAtkPctNoChangeEnable[$Battle] = False
		GUICtrlSetState($g_hTxtDBPercentChange, $GUI_DISABLE)
		GUICtrlSetState($g_hLblDBPercentChangeSec, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkBattleEndPercentChange

Func chkRankedBattleEndPercentHigher()
	If GUICtrlRead($g_hchkRankedBattleEndPercentHigher) = $GUI_CHECKED Then
		$g_abStopAtkPctHigherEnable[$RankedBattle] = True
		GUICtrlSetState($g_hTxtABPercentHigher, $GUI_ENABLE)
		GUICtrlSetState($g_hLblABPercentHigherSec, $GUI_ENABLE)
	Else
		$g_abStopAtkPctHigherEnable[$RankedBattle] = False
		GUICtrlSetState($g_hTxtABPercentHigher, $GUI_DISABLE)
		GUICtrlSetState($g_hLblABPercentHigherSec, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkRankedBattleEndPercentHigher

Func chkRankedBattleEndPercentChange()
	If GUICtrlRead($g_hchkRankedBattleEndPercentChange) = $GUI_CHECKED Then
		$g_abStopAtkPctNoChangeEnable[$RankedBattle] = True
		GUICtrlSetState($g_hTxtABPercentChange, $GUI_ENABLE)
		GUICtrlSetState($g_hLblABPercentChangeSec, $GUI_ENABLE)
	Else
		$g_abStopAtkPctNoChangeEnable[$RankedBattle] = False
		GUICtrlSetState($g_hTxtABPercentChange, $GUI_DISABLE)
		GUICtrlSetState($g_hLblABPercentChangeSec, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkRankedBattleEndPercentChange

Func chkDESideEB()
	If GUICtrlRead($g_hChkDESideEB) = $GUI_CHECKED Then
		For $i = $g_hTxtDELowEndMin To $g_hLblDEEndAq
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	Else
		For $i = $g_hTxtDELowEndMin To $g_hLblDEEndAq
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
EndFunc   ;==>chkDESideEB

Func chkTakeLootSS()
	GUICtrlSetState($g_hChkScreenshotLootInfo, GUICtrlRead($g_hChkTakeLootSS) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
EndFunc   ;==>chkTakeLootSS
