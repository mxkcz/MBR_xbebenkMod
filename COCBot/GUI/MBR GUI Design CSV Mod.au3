; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design CSV Mod
; Description ...: This file creates the "CSV Mod" top-level tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: mxkcz
; Modified ......: mxkcz
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; =====================================================================================================================
#include-once
#include "MBR GUI Design CSV Mod Search.au3"
#include "MBR GUI Design CSV Mod Search Opt.au3"
#include "MBR GUI Design CSV Mod Side.au3"
#include "MBR GUI Design CSV Mod Script.au3"
#include "MBR GUI Design CSV Mod Vector.au3"
#include "MBR GUI Design CSV Mod Drops.au3"
#include "MBR GUI Design CSV Mod Settings.au3"
#include "MBR GUI Design CSV Mod Precalc.au3"
#include "MBR GUI Design CSV Mod Diagnostics.au3"
#include "MBR GUI Design CSV Mod Attack.au3"

; #FUNCTION# ====================================================================================================================
; Name ..........: CreateCSVModTab
; Description ...: Builds the CSV Mod top-level tab and its sub-tabs.
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; =====================================================================================================================
Func CreateCSVModTab()
	$g_hGUI_CSVMOD = _GUICreate("", $g_iSizeWGrpTab1, $g_iSizeHGrpTab1, $_GUI_CHILD_LEFT, $_GUI_CHILD_TOP, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hFrmBotEx)

	GUISwitch($g_hGUI_CSVMOD)
	$g_hGUI_CSVMOD_TAB = GUICtrlCreateTab(0, 0, $g_iSizeWGrpTab1, $g_iSizeHGrpTab1, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))

	$g_hGUI_CSVMOD_TAB_ITEM1 = GUICtrlCreateTabItem("Script")
		CreateCSVModScriptTab()
	$g_hGUI_CSVMOD_TAB_ITEM2 = GUICtrlCreateTabItem("Search")
		CreateCSVModSearchTab()
	$g_hGUI_CSVMOD_TAB_ITEM3 = GUICtrlCreateTabItem("Search Opt")
		CreateCSVModSearchOptionsTab()
	$g_hGUI_CSVMOD_TAB_ITEM4 = GUICtrlCreateTabItem("Side")
		CreateCSVModSideTab()
	$g_hGUI_CSVMOD_TAB_ITEM5 = GUICtrlCreateTabItem("Vector")
		CreateCSVModVectorTab()
	$g_hGUI_CSVMOD_TAB_ITEM6 = GUICtrlCreateTabItem("Drops")
		CreateCSVModDropsTab()
	$g_hGUI_CSVMOD_TAB_ITEM7 = GUICtrlCreateTabItem("Settings")
		CreateCSVModSettingsTab()
	$g_hGUI_CSVMOD_TAB_ITEM8 = GUICtrlCreateTabItem("Precalc")
		CreateCSVModPrecalcTab()
	$g_hGUI_CSVMOD_TAB_ITEM9 = GUICtrlCreateTabItem("Diagnostics")
		CreateCSVModDiagnosticsTab()
	$g_hGUI_CSVMOD_TAB_ITEM10 = GUICtrlCreateTabItem("Attack")
		CreateCSVModAttackTab()
	GUICtrlCreateTabItem("")

	; Reuse CSV settings logic guards by pointing to the Mod tab container.
	$g_hGUI_AttackCSVSettings = $g_hGUI_CSVMOD
	$g_iAttackCSVSettingsMode = $Battle
	AttackCSVSettings_LoadFromCSV($g_iAttackCSVSettingsMode)
	$g_bCSVModReady = True
EndFunc   ;==>CreateCSVModTab

; #FUNCTION# ====================================================================================================================
; Name ..........: CreateCSVModScriptTab
; Description ...: Creates the script selection, tools, and status panel.
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; =====================================================================================================================


; #FUNCTION# ====================================================================================================================
; Name ..........: CreateCSVModSearchTab
; Description ...: Creates search criteria UI for Battle and Ranked Battle.
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; =====================================================================================================================


; #FUNCTION# ====================================================================================================================
; Name ..........: CreateCSVModSearchOptionsTab
; Description ...: Creates search options (reduction, delays, attack now, etc).
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; =====================================================================================================================


; #FUNCTION# ====================================================================================================================
; Name ..........: CreateCSVModSideTab
; Description ...: Creates SIDE/SIDEB weighting controls.
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; =====================================================================================================================


; #FUNCTION# ====================================================================================================================
; Name ..........: CreateCSVModVectorTab
; Description ...: Creates vector editor and PRIO preview.
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; =====================================================================================================================


; #FUNCTION# ====================================================================================================================
; Name ..........: CreateCSVModDropsTab
; Description ...: Creates DROP/REMAIN ranges and WAIT break conditions.
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; =====================================================================================================================


; #FUNCTION# ====================================================================================================================
; Name ..........: CreateCSVModSettingsTab
; Description ...: Creates CSV automation settings (flex troop, hero ability modes, presets).
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; =====================================================================================================================


; #FUNCTION# ====================================================================================================================
; Name ..........: CreateCSVModPrecalcTab
; Description ...: Creates precache aggressiveness and precalc status panel.
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; =====================================================================================================================


; #FUNCTION# ====================================================================================================================
; Name ..........: CreateCSVModDiagnosticsTab
; Description ...: Creates diagnostics and debug panels.
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; =====================================================================================================================


; #FUNCTION# ====================================================================================================================
; Name ..........: CreateCSVModAttackTab
; Description ...: Creates hero ability activation and attack options.
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; =====================================================================================================================


; #FUNCTION# ====================================================================================================================
; Name ..........: CSVMod_PruneSearchControls
; Description ...: Hides unsupported search filters to keep only gold/elixir/dark criteria.
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; =====================================================================================================================
Func CSVMod_PruneSearchControls()
	; Force G/E mode and hide extra filters.
	If $g_hCmbDBMeetGE <> 0 Then
		GUICtrlSetData($g_hCmbDBMeetGE, GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "CmbMeetGE_Item_01", "G And E"))
		GUICtrlSetState($g_hCmbDBMeetGE, $GUI_DISABLE)
	EndIf
	If $g_hCmbABMeetGE <> 0 Then
		GUICtrlSetData($g_hCmbABMeetGE, GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "CmbMeetGE_Item_01", "G And E"))
		GUICtrlSetState($g_hCmbABMeetGE, $GUI_DISABLE)
	EndIf
	If $g_hTxtDBMinGoldPlusElixir <> 0 Then GUICtrlSetState($g_hTxtDBMinGoldPlusElixir, $GUI_HIDE)
	If $g_hPicDBMinGPEGold <> 0 Then GUICtrlSetState($g_hPicDBMinGPEGold, $GUI_HIDE)
	If $g_hTxtABMinGoldPlusElixir <> 0 Then GUICtrlSetState($g_hTxtABMinGoldPlusElixir, $GUI_HIDE)
	If $g_hPicABMinGPEGold <> 0 Then GUICtrlSetState($g_hPicABMinGPEGold, $GUI_HIDE)

	; Hide TownHall and defense filters.
	If $g_hchkBattleMeetTH <> 0 Then GUICtrlSetState($g_hchkBattleMeetTH, $GUI_HIDE)
	If $g_hCmbDBTH <> 0 Then GUICtrlSetState($g_hCmbDBTH, $GUI_HIDE)

	If $g_hCmbABTH <> 0 Then GUICtrlSetState($g_hCmbABTH, $GUI_HIDE)
	If $g_hchkRankedBattleMeetTHO <> 0 Then GUICtrlSetState($g_hchkRankedBattleMeetTHO, $GUI_HIDE)
	If $g_hchkRankedBattleMeetDeadEagle <> 0 Then GUICtrlSetState($g_hchkRankedBattleMeetDeadEagle, $GUI_HIDE)
	If $g_hTxtActiveEagleSearch <> 0 Then GUICtrlSetState($g_hTxtActiveEagleSearch, $GUI_HIDE)

	; Disable Army Camps search requirement.
	If $g_hchkBattleActivateCamps <> 0 Then GUICtrlSetState($g_hchkBattleActivateCamps, $GUI_HIDE)
	If $g_hLblDBArmyCamps <> 0 Then GUICtrlSetState($g_hLblDBArmyCamps, $GUI_HIDE)
	If $g_hTxtDBArmyCamps <> 0 Then GUICtrlSetState($g_hTxtDBArmyCamps, $GUI_HIDE)
	If $g_hchkRankedBattleActivateCamps <> 0 Then GUICtrlSetState($g_hchkRankedBattleActivateCamps, $GUI_HIDE)
	If $g_hLblABArmyCamps <> 0 Then GUICtrlSetState($g_hLblABArmyCamps, $GUI_HIDE)
	If $g_hTxtABArmyCamps <> 0 Then GUICtrlSetState($g_hTxtABArmyCamps, $GUI_HIDE)

	; Hide weak base / max defense filters.
	For $i = 0 To UBound($g_ahChkMaxMortar) - 1
		If $g_ahChkMaxMortar[$i] <> 0 Then GUICtrlSetState($g_ahChkMaxMortar[$i], $GUI_HIDE)
		If $g_ahCmbWeakMortar[$i] <> 0 Then GUICtrlSetState($g_ahCmbWeakMortar[$i], $GUI_HIDE)
		If $g_ahPicWeakMortar[$i] <> 0 Then GUICtrlSetState($g_ahPicWeakMortar[$i], $GUI_HIDE)
		If $g_ahChkMaxWizTower[$i] <> 0 Then GUICtrlSetState($g_ahChkMaxWizTower[$i], $GUI_HIDE)
		If $g_ahCmbWeakWizTower[$i] <> 0 Then GUICtrlSetState($g_ahCmbWeakWizTower[$i], $GUI_HIDE)
		If $g_ahPicWeakWizTower[$i] <> 0 Then GUICtrlSetState($g_ahPicWeakWizTower[$i], $GUI_HIDE)
		If $g_ahChkMaxAirDefense[$i] <> 0 Then GUICtrlSetState($g_ahChkMaxAirDefense[$i], $GUI_HIDE)
		If $g_ahCmbWeakAirDefense[$i] <> 0 Then GUICtrlSetState($g_ahCmbWeakAirDefense[$i], $GUI_HIDE)
		If $g_ahPicWeakAirDefense[$i] <> 0 Then GUICtrlSetState($g_ahPicWeakAirDefense[$i], $GUI_HIDE)
		If $g_ahChkMaxXBow[$i] <> 0 Then GUICtrlSetState($g_ahChkMaxXBow[$i], $GUI_HIDE)
		If $g_ahCmbWeakXBow[$i] <> 0 Then GUICtrlSetState($g_ahCmbWeakXBow[$i], $GUI_HIDE)
		If $g_ahPicWeakXBow[$i] <> 0 Then GUICtrlSetState($g_ahPicWeakXBow[$i], $GUI_HIDE)
		If $g_ahChkMaxInferno[$i] <> 0 Then GUICtrlSetState($g_ahChkMaxInferno[$i], $GUI_HIDE)
		If $g_ahCmbWeakInferno[$i] <> 0 Then GUICtrlSetState($g_ahCmbWeakInferno[$i], $GUI_HIDE)
		If $g_ahPicWeakInferno[$i] <> 0 Then GUICtrlSetState($g_ahPicWeakInferno[$i], $GUI_HIDE)
		If $g_ahChkMaxEagle[$i] <> 0 Then GUICtrlSetState($g_ahChkMaxEagle[$i], $GUI_HIDE)
		If $g_ahCmbWeakEagle[$i] <> 0 Then GUICtrlSetState($g_ahCmbWeakEagle[$i], $GUI_HIDE)
		If $g_ahPicWeakEagle[$i] <> 0 Then GUICtrlSetState($g_ahPicWeakEagle[$i], $GUI_HIDE)
		If $g_ahChkMaxScatter[$i] <> 0 Then GUICtrlSetState($g_ahChkMaxScatter[$i], $GUI_HIDE)
		If $g_ahCmbWeakScatter[$i] <> 0 Then GUICtrlSetState($g_ahCmbWeakScatter[$i], $GUI_HIDE)
		If $g_ahPicWeakScatter[$i] <> 0 Then GUICtrlSetState($g_ahPicWeakScatter[$i], $GUI_HIDE)
	Next

	; Enforce simplified search filters at runtime.
	$g_abSearchCampsEnable[$Battle] = False
	$g_abSearchCampsEnable[$RankedBattle] = False
	$g_aiSearchCampsPct[$Battle] = 0
	$g_aiSearchCampsPct[$RankedBattle] = 0
	$g_aiFilterMeetGE[$Battle] = 0
	$g_aiFilterMeetGE[$RankedBattle] = 0
	$g_aiFilterMinGoldPlusElixir[$Battle] = 0
	$g_aiFilterMinGoldPlusElixir[$RankedBattle] = 0
	$g_abFilterMeetTH[$Battle] = False
	$g_abFilterMeetTH[$RankedBattle] = False
	$g_abFilterMeetTHOutsideEnable[$Battle] = False
	$g_abFilterMeetTHOutsideEnable[$RankedBattle] = False
	$g_abFilterMaxMortarEnable[$Battle] = False
	$g_abFilterMaxMortarEnable[$RankedBattle] = False
	$g_abFilterMaxWizTowerEnable[$Battle] = False
	$g_abFilterMaxWizTowerEnable[$RankedBattle] = False
	$g_abFilterMaxAirDefenseEnable[$Battle] = False
	$g_abFilterMaxAirDefenseEnable[$RankedBattle] = False
	$g_abFilterMaxXBowEnable[$Battle] = False
	$g_abFilterMaxXBowEnable[$RankedBattle] = False
	$g_abFilterMaxInfernoEnable[$Battle] = False
	$g_abFilterMaxInfernoEnable[$RankedBattle] = False
	$g_abFilterMaxEagleEnable[$Battle] = False
	$g_abFilterMaxEagleEnable[$RankedBattle] = False
	$g_abFilterMaxScatterEnable[$Battle] = False
	$g_abFilterMaxScatterEnable[$RankedBattle] = False
EndFunc   ;==>CSVMod_PruneSearchControls
