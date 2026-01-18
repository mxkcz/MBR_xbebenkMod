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

Func chkDBMeetDE()
	_GUICtrlEdit_SetReadOnly($g_hTxtDBMinDarkElixir, GUICtrlRead($g_hChkDBMeetDE) = $GUI_CHECKED ? False : True)
EndFunc   ;==>chkDBMeetDE

Func chkDBMeetTH()
	GUICtrlSetState($g_hCmbDBTH, GUICtrlRead($g_hChkDBMeetTH) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
EndFunc   ;==>chkDBMeetTH

Func chkDBMeetDeadEagle()
	If GUICtrlRead($g_hChkDBMeetDeadEagle) = $GUI_CHECKED Then
		$g_bChkDeadEagle = True
		$g_iDeadEagleSearch = GUICtrlRead($g_hTxtDeadEagleSearch)
	Else
		$g_bChkDeadEagle = False
	EndIf

	SetLog("$g_bChkDeadEagle :" & $g_bChkDeadEagle)
EndFunc

Func chkDBWeakBase()
	GUICtrlSetState($g_ahCmbWeakMortar[$DB], GUICtrlRead($g_ahChkMaxMortar[$DB]) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
	GUICtrlSetState($g_ahCmbWeakWizTower[$DB], GUICtrlRead($g_ahChkMaxWizTower[$DB]) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
	GUICtrlSetState($g_ahCmbWeakAirDefense[$DB], GUICtrlRead($g_ahChkMaxAirDefense[$DB]) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
	GUICtrlSetState($g_ahCmbWeakXBow[$DB], GUICtrlRead($g_ahChkMaxXBow[$DB]) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
	GUICtrlSetState($g_ahCmbWeakInferno[$DB], GUICtrlRead($g_ahChkMaxInferno[$DB]) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
	GUICtrlSetState($g_ahCmbWeakEagle[$DB], GUICtrlRead($g_ahChkMaxEagle[$DB]) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
	GUICtrlSetState($g_ahCmbWeakScatter[$DB], GUICtrlRead($g_ahChkMaxScatter[$DB]) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
EndFunc   ;==>chkDBWeakBase

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

Func chkABMeetDE()
	_GUICtrlEdit_SetReadOnly($g_hTxtABMinDarkElixir, GUICtrlRead($g_hChkABMeetDE) = $GUI_CHECKED ? False : True)
EndFunc   ;==>chkABMeetDE

Func chkABMeetTH()
	GUICtrlSetState($g_hCmbABTH, GUICtrlRead($g_hChkABMeetTH) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
EndFunc   ;==>chkABMeetTH

Func chkABWeakBase()
	GUICtrlSetState($g_ahCmbWeakMortar[$LB], GUICtrlRead($g_ahChkMaxMortar[$LB]) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
	GUICtrlSetState($g_ahCmbWeakWizTower[$LB], GUICtrlRead($g_ahChkMaxWizTower[$LB]) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
	GUICtrlSetState($g_ahCmbWeakAirDefense[$LB], GUICtrlRead($g_ahChkMaxAirDefense[$LB]) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
	GUICtrlSetState($g_ahCmbWeakXBow[$LB], GUICtrlRead($g_ahChkMaxXBow[$LB]) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
	GUICtrlSetState($g_ahCmbWeakInferno[$LB], GUICtrlRead($g_ahChkMaxInferno[$LB]) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
	GUICtrlSetState($g_ahCmbWeakEagle[$LB], GUICtrlRead($g_ahChkMaxEagle[$LB]) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
	GUICtrlSetState($g_ahCmbWeakScatter[$LB], GUICtrlRead($g_ahChkMaxScatter[$LB]) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
EndFunc   ;==>chkABWeakBase

Func chkRestartSearchLimit()
	GUICtrlSetState($g_hTxtRestartSearchlimit, GUICtrlRead($g_hChkRestartSearchLimit) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
EndFunc   ;==>chkRestartSearchLimit

Func chkDBActivateSearches()
	If GUICtrlRead($g_hChkDBActivateSearches) = $GUI_CHECKED Then
		GUICtrlSetState($g_hTxtDBSearchesMin, $GUI_ENABLE)
		GUICtrlSetState($g_hLblDBSearches, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtDBSearchesMax, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hTxtDBSearchesMin, $GUI_DISABLE)
		GUICtrlSetState($g_hLblDBSearches, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtDBSearchesMax, $GUI_DISABLE)
	EndIf

	dbCheckall()
EndFunc   ;==>chkDBActivateSearches

Func chkDBActivateCamps()
	If GUICtrlRead($g_hChkDBActivateCamps) = $GUI_CHECKED Then
		GUICtrlSetState($g_hLblDBArmyCamps, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtDBArmyCamps, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hLblDBArmyCamps, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtDBArmyCamps, $GUI_DISABLE)
	EndIf

	dbCheckall()
EndFunc   ;==>chkDBActivateCamps

Func EnableSearchPanels($iMatchMode)
	Switch $iMatchMode
		Case $DB
			If GUICtrlRead($g_hChkDBActivateSearches) = $GUI_CHECKED Or _
			   GUICtrlRead($g_hChkDBActivateCamps) = $GUI_CHECKED Then
				_GUI_Value_STATE("SHOW", $g_aGroupSearchDB)

				cmbDBGoldElixir()
			Else
				_GUI_Value_STATE("HIDE", $g_aGroupSearchDB)
			EndIf
		Case $LB
			If GUICtrlRead($g_hChkABActivateSearches) = $GUI_CHECKED Or _
			   GUICtrlRead($g_hChkABActivateCamps) = $GUI_CHECKED Then
				_GUI_Value_STATE("SHOW", $groupSearchAB)

				cmbABGoldElixir()
			Else
				_GUI_Value_STATE("HIDE", $groupSearchAB)
			EndIf
	EndSwitch

EndFunc   ;==>EnableSearchPanels




Func chkABActivateSearches()
	If GUICtrlRead($g_hChkABActivateSearches) = $GUI_CHECKED Then
		GUICtrlSetState($g_hTxtABSearchesMin, $GUI_ENABLE)
		GUICtrlSetState($g_hLblABSearches, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtABSearchesMax, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hTxtABSearchesMin, $GUI_DISABLE)
		GUICtrlSetState($g_hLblABSearches, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtABSearchesMax, $GUI_DISABLE)
	EndIf
	;EnableSearchPanels($LB)
	abCheckall()
EndFunc   ;==>chkABActivateSearches
Func CmbDBTH()
	_GUI_Value_STATE("HIDE", $g_aGroupListPicDBMaxTH)
	Local $iCmbValue = _GUICtrlComboBox_GetCurSel($g_hCmbDBTH) + 6
	GUICtrlSetState($g_ahPicDBMaxTH[$iCmbValue], $GUI_SHOW)
EndFunc   ;==>CmbDBTH

Func CmbABTH()
	_GUI_Value_STATE("HIDE", $g_aGroupListPicABMaxTH)
	Local $iCmbValue = _GUICtrlComboBox_GetCurSel($g_hCmbABTH) + 6
	GUICtrlSetState($g_ahPicABMaxTH[$iCmbValue], $GUI_SHOW)
EndFunc   ;==>CmbABTH

Func CmbBullyMaxTH()
	_GUI_Value_STATE("HIDE", $g_aGroupListPicBullyMaxTH)
	Local $iCmbValue = _GUICtrlComboBox_GetCurSel($g_hCmbBullyMaxTH) + 6
	GUICtrlSetState($g_ahPicBullyMaxTH[$iCmbValue], $GUI_SHOW)
EndFunc   ;==>CmbBullyMaxTH

Func dbCheckAll()
	If BitAND(GUICtrlRead($g_hChkDBActivateSearches), GUICtrlRead($g_hChkDBActivateCamps)) = $GUI_UNCHECKED Then
		GUICtrlSetState($g_hChkDeadbase, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($g_hChkDeadbase, $GUI_CHECKED)
	EndIf
	tabSEARCH()
EndFunc   ;==>dbCheckAll

Func abCheckAll()
	If BitAND(GUICtrlRead($g_hChkABActivateSearches), GUICtrlRead($g_hChkABActivateCamps)) = $GUI_UNCHECKED Then
		GUICtrlSetState($g_hChkActivebase, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($g_hChkActivebase, $GUI_CHECKED)
	EndIf
	tabSEARCH()
EndFunc   ;==>abCheckAll

