; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GkevinOD (2014)
; Modified ......: Hervidero (2015), CodeSlinger69 [2017], MonkeyHunter (03-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func cmbDBGoldElixir()
	If _GUICtrlComboBox_GetCurSel($g_hCmbDBMeetGE) < 2 Then
		GUICtrlSetState($g_hTxtDBMinGold, $GUI_SHOW)
		GUICtrlSetState($g_hPicDBMinGold, $GUI_SHOW)
		GUICtrlSetState($g_hTxtDBMinElixir, $GUI_SHOW)
		GUICtrlSetState($g_hPicDBMinElixir, $GUI_SHOW)
		GUICtrlSetState($g_hTxtDBMinGoldPlusElixir, $GUI_HIDE)
		GUICtrlSetState($g_hPicDBMinGPEGold, $GUI_HIDE)
	Else
		GUICtrlSetState($g_hTxtDBMinGold, $GUI_HIDE)
		GUICtrlSetState($g_hPicDBMinGold, $GUI_HIDE)
		GUICtrlSetState($g_hTxtDBMinElixir, $GUI_HIDE)
		GUICtrlSetState($g_hPicDBMinElixir, $GUI_HIDE)
		GUICtrlSetState($g_hTxtDBMinGoldPlusElixir, $GUI_SHOW)
		GUICtrlSetState($g_hPicDBMinGPEGold, $GUI_SHOW)
	EndIf
EndFunc   ;==>cmbDBGoldElixir

Func chkBattleMeetDE()
	_GUICtrlEdit_SetReadOnly($g_hTxtDBMinDarkElixir, GUICtrlRead($g_hchkBattleMeetDE) = $GUI_CHECKED ? False : True)
EndFunc   ;==>chkBattleMeetDE

Func chkBattleMeetTH()
	GUICtrlSetState($g_hCmbDBTH, GUICtrlRead($g_hchkBattleMeetTH) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
EndFunc   ;==>chkBattleMeetTH

Func chkBattleMeetDeadEagle()
	If GUICtrlRead($g_hchkBattleMeetDeadEagle) = $GUI_CHECKED Then
		$g_bChkDeadEagle = True
		$g_iDeadEagleSearch = GUICtrlRead($g_hTxtDeadEagleSearch)
	Else
		$g_bChkDeadEagle = False
	EndIf

	SetLog("$g_bChkDeadEagle :" & $g_bChkDeadEagle)
EndFunc

Func chkBattleWeakBase()
	GUICtrlSetState($g_ahCmbWeakMortar[$Battle], GUICtrlRead($g_ahChkMaxMortar[$Battle]) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
	GUICtrlSetState($g_ahCmbWeakWizTower[$Battle], GUICtrlRead($g_ahChkMaxWizTower[$Battle]) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
	GUICtrlSetState($g_ahCmbWeakAirDefense[$Battle], GUICtrlRead($g_ahChkMaxAirDefense[$Battle]) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
	GUICtrlSetState($g_ahCmbWeakXBow[$Battle], GUICtrlRead($g_ahChkMaxXBow[$Battle]) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
	GUICtrlSetState($g_ahCmbWeakInferno[$Battle], GUICtrlRead($g_ahChkMaxInferno[$Battle]) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
	GUICtrlSetState($g_ahCmbWeakEagle[$Battle], GUICtrlRead($g_ahChkMaxEagle[$Battle]) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
	GUICtrlSetState($g_ahCmbWeakScatter[$Battle], GUICtrlRead($g_ahChkMaxScatter[$Battle]) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
EndFunc   ;==>chkBattleWeakBase

Func cmbABGoldElixir()
	If _GUICtrlComboBox_GetCurSel($g_hCmbABMeetGE) < 2 Then
		GUICtrlSetState($g_hTxtABMinGold, $GUI_SHOW)
		GUICtrlSetState($g_hPicABMinGold, $GUI_SHOW)
		GUICtrlSetState($g_hTxtABMinElixir, $GUI_SHOW)
		GUICtrlSetState($g_hPicABMinElixir, $GUI_SHOW)
		GUICtrlSetState($g_hTxtABMinGoldPlusElixir, $GUI_HIDE)
		GUICtrlSetState($g_hPicABMinGPEGold, $GUI_HIDE)
	Else
		GUICtrlSetState($g_hTxtABMinGold, $GUI_HIDE)
		GUICtrlSetState($g_hPicABMinGold, $GUI_HIDE)
		GUICtrlSetState($g_hTxtABMinElixir, $GUI_HIDE)
		GUICtrlSetState($g_hPicABMinElixir, $GUI_HIDE)
		GUICtrlSetState($g_hTxtABMinGoldPlusElixir, $GUI_SHOW)
		GUICtrlSetState($g_hPicABMinGPEGold, $GUI_SHOW)
	EndIf
EndFunc   ;==>cmbABGoldElixir

Func chkRankedBattleMeetDE()
	_GUICtrlEdit_SetReadOnly($g_hTxtABMinDarkElixir, GUICtrlRead($g_hchkRankedBattleMeetDE) = $GUI_CHECKED ? False : True)
EndFunc   ;==>chkRankedBattleMeetDE

Func chkRankedBattleMeetTH()
	GUICtrlSetState($g_hCmbABTH, GUICtrlRead($g_hchkRankedBattleMeetTH) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
EndFunc   ;==>chkRankedBattleMeetTH

Func chkRankedBattleWeakBase()
	GUICtrlSetState($g_ahCmbWeakMortar[$RankedBattle], GUICtrlRead($g_ahChkMaxMortar[$RankedBattle]) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
	GUICtrlSetState($g_ahCmbWeakWizTower[$RankedBattle], GUICtrlRead($g_ahChkMaxWizTower[$RankedBattle]) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
	GUICtrlSetState($g_ahCmbWeakAirDefense[$RankedBattle], GUICtrlRead($g_ahChkMaxAirDefense[$RankedBattle]) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
	GUICtrlSetState($g_ahCmbWeakXBow[$RankedBattle], GUICtrlRead($g_ahChkMaxXBow[$RankedBattle]) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
	GUICtrlSetState($g_ahCmbWeakInferno[$RankedBattle], GUICtrlRead($g_ahChkMaxInferno[$RankedBattle]) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
	GUICtrlSetState($g_ahCmbWeakEagle[$RankedBattle], GUICtrlRead($g_ahChkMaxEagle[$RankedBattle]) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
	GUICtrlSetState($g_ahCmbWeakScatter[$RankedBattle], GUICtrlRead($g_ahChkMaxScatter[$RankedBattle]) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
EndFunc   ;==>chkRankedBattleWeakBase

Func chkRestartSearchLimit()
	GUICtrlSetState($g_hTxtRestartSearchlimit, GUICtrlRead($g_hChkRestartSearchLimit) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
EndFunc   ;==>chkRestartSearchLimit

Func chkBattleActivateSearches()
	If GUICtrlRead($g_hchkBattleActivateSearches) = $GUI_CHECKED Then
		GUICtrlSetState($g_hTxtDBSearchesMin, $GUI_ENABLE)
		GUICtrlSetState($g_hLblDBSearches, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtDBSearchesMax, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hTxtDBSearchesMin, $GUI_DISABLE)
		GUICtrlSetState($g_hLblDBSearches, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtDBSearchesMax, $GUI_DISABLE)
	EndIf

	dbCheckall()
EndFunc   ;==>chkBattleActivateSearches

Func chkBattleActivateCamps()
	If GUICtrlRead($g_hchkBattleActivateCamps) = $GUI_CHECKED Then
		GUICtrlSetState($g_hLblDBArmyCamps, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtDBArmyCamps, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hLblDBArmyCamps, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtDBArmyCamps, $GUI_DISABLE)
	EndIf

	dbCheckall()
EndFunc   ;==>chkBattleActivateCamps

Func EnableSearchPanels($iMatchMode)
	Switch $iMatchMode
		Case $Battle
			If GUICtrlRead($g_hchkBattleActivateSearches) = $GUI_CHECKED Or _
			   GUICtrlRead($g_hchkBattleActivateCamps) = $GUI_CHECKED Then
				_GUI_Value_STATE("SHOW", $g_aGroupSearchBattlattle)

				cmbDBGoldElixir()
			Else
				_GUI_Value_STATE("HIDE", $g_aGroupSearchBattlattle)
			EndIf
		Case $RankedBattle
			If GUICtrlRead($g_hchkRankedBattleActivateSearches) = $GUI_CHECKED Or _
			   GUICtrlRead($g_hchkRankedBattleActivateCamps) = $GUI_CHECKED Then
				_GUI_Value_STATE("SHOW", $groupSearchRB)

				cmbABGoldElixir()
			Else
				_GUI_Value_STATE("HIDE", $groupSearchRB)
			EndIf
	EndSwitch

EndFunc   ;==>EnableSearchPanels




Func chkRankedBattleActivateSearches()
	If GUICtrlRead($g_hchkRankedBattleActivateSearches) = $GUI_CHECKED Then
		GUICtrlSetState($g_hTxtABSearchesMin, $GUI_ENABLE)
		GUICtrlSetState($g_hLblABSearches, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtABSearchesMax, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hTxtABSearchesMin, $GUI_DISABLE)
		GUICtrlSetState($g_hLblABSearches, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtABSearchesMax, $GUI_DISABLE)
	EndIf
	;EnableSearchPanels($RankedBattle)
	abCheckall()
EndFunc   ;==>chkRankedBattleActivateSearches
Func CmbDBTH()
	_GUI_Value_STATE("HIDE", $g_aGroupListPicBMaxTH)
	Local $iCmbValue = _GUICtrlComboBox_GetCurSel($g_hCmbDBTH) + 6
	GUICtrlSetState($g_ahPicDBMaxTH[$iCmbValue], $GUI_SHOW)
EndFunc   ;==>CmbDBTH

Func CmbABTH()
	_GUI_Value_STATE("HIDE", $g_aGroupListPicRBMaxTH)
	Local $iCmbValue = _GUICtrlComboBox_GetCurSel($g_hCmbABTH) + 6
	GUICtrlSetState($g_ahPicABMaxTH[$iCmbValue], $GUI_SHOW)
EndFunc   ;==>CmbABTH

Func CmbBullyMaxTH()
	_GUI_Value_STATE("HIDE", $g_aGroupListPicBullyMaxTH)
	Local $iCmbValue = _GUICtrlComboBox_GetCurSel($g_hCmbBullyMaxTH) + 6
	GUICtrlSetState($g_ahPicBullyMaxTH[$iCmbValue], $GUI_SHOW)
EndFunc   ;==>CmbBullyMaxTH

Func dbCheckAll()
	If BitAND(GUICtrlRead($g_hchkBattleActivateSearches), GUICtrlRead($g_hchkBattleActivateCamps)) = $GUI_UNCHECKED Then
		GUICtrlSetState($g_hChkDeadbase, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($g_hChkDeadbase, $GUI_CHECKED)
	EndIf
	tabSEARCH()
EndFunc   ;==>dbCheckAll

Func abCheckAll()
	If BitAND(GUICtrlRead($g_hchkRankedBattleActivateSearches), GUICtrlRead($g_hchkRankedBattleActivateCamps)) = $GUI_UNCHECKED Then
		GUICtrlSetState($g_hChkActivebase, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($g_hChkActivebase, $GUI_CHECKED)
	EndIf
	tabSEARCH()
EndFunc   ;==>abCheckAll

