; #FUNCTION# ====================================================================================================================
; Name ..........: CreateCSVModScriptTab
; Description ...: Creates the script selection, tools, and status panel for ranked and standard CSV scripts.
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
; Related .......:
; Link ..........:
; Example .......:
; =====================================================================================================================
Func CreateCSVModScriptTab()
	Local $x = 0, $y = 0, $w = 0, $h = 0
	CSVMod_GetContentBounds($x, $y, $w, $h)

	; Battle + Ranked Battle script selectors (side-by-side)
	Local $iGroupW = Int(($w - 10) / 2)
	Local $iGroupH = 135
	GUICtrlCreateGroup("Battle Script", $x, $y, $iGroupW, $iGroupH)
		$g_hCmbScriptNameBattle = GUICtrlCreateCombo("", $x + 10, $y + 20, $iGroupW - 55, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL, $WS_VSCROLL))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design CSV Mod Script", "CmbScriptName", "Choose the script; You can edit/add new scripts located in folder: 'CSV/Attack'"))
			GUICtrlSetOnEvent(-1, "cmbScriptNameBattle")
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnReload, $x + $iGroupW - 35, $y + 22, 16, 16)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design CSV Mod Script", "IconReload_Info_01", "Reload Script Files"))
			GUICtrlSetOnEvent(-1, "UpdateComboScriptNameBattle")
		$g_hLblCSVScriptVersionBattle = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design CSV Mod Script", "Lbl_ScriptCSVVersion", "CSV: -"), $x + 10, $y + 44, $iGroupW - 20, 16)
		$g_hLblNotesScriptBattle = GUICtrlCreateLabel("", $x + 10, $y + 62, $iGroupW - 20, $iGroupH - 72)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup("Ranked Battle Script", $x + $iGroupW + 10, $y, $iGroupW, $iGroupH)
		$g_hCmbScriptNameRankedBattle = GUICtrlCreateCombo("", $x + $iGroupW + 20, $y + 20, $iGroupW - 55, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL, $WS_VSCROLL))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design CSV Mod Script", "CmbScriptName", -1))
			GUICtrlSetOnEvent(-1, "cmbScriptNameRankedBattle")
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnReload, $x + ($iGroupW * 2) - 25, $y + 22, 16, 16)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design CSV Mod Script", "IconReload_Info_01", -1))
			GUICtrlSetOnEvent(-1, "UpdateComboScriptNameRankedBattle")
		$g_hLblCSVScriptVersionRankedBattle = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design CSV Mod Script", "Lbl_ScriptCSVVersion", -1), $x + $iGroupW + 20, $y + 44, $iGroupW - 20, 16)
		$g_hLblNotesScriptRankedBattle = GUICtrlCreateLabel("", $x + $iGroupW + 20, $y + 62, $iGroupW - 20, $iGroupH - 72)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 150
	GUICtrlCreateGroup("Tools", $x, $y, $w, 70)
		Local $iBtnW = 90, $iBtnH = 22, $iBtnGap = 8
		Local $iBtnX = $x + 10, $iBtnY = $y + 20
		$g_hBtnCSVSettingsReload = GUICtrlCreateButton("Reload CSV", $iBtnX, $iBtnY, $iBtnW, $iBtnH)
			GUICtrlSetOnEvent(-1, "AttackCSVSettings_ReloadFromCSV")
		$g_hBtnCSVSettingsValidate = GUICtrlCreateButton("Validate CSV", $iBtnX + $iBtnW + $iBtnGap, $iBtnY, $iBtnW, $iBtnH)
			GUICtrlSetOnEvent(-1, "AttackCSVSettings_ValidateCSV")
		$g_hBtnCSVSettingsDebugLocate = GUICtrlCreateButton("Debug Locate", $iBtnX + (($iBtnW + $iBtnGap) * 2), $iBtnY, $iBtnW, $iBtnH)
			GUICtrlSetOnEvent(-1, "debugCSVLocateBuildings")
		$iBtnY += 24
		$g_hBtnCSVSettingsTestBattle = GUICtrlCreateButton("Test Attack", $iBtnX, $iBtnY, $iBtnW, $iBtnH)
			GUICtrlSetOnEvent(-1, "AttackCSVSettings_TestAttackBattle")
		$g_hBtnCSVSettingsTestDry = GUICtrlCreateButton("Test Dry", $iBtnX + $iBtnW + $iBtnGap, $iBtnY, $iBtnW, $iBtnH)
			GUICtrlSetOnEvent(-1, "AttackCSVSettings_TestAttackDry")
		$g_hBtnCSVSettingsRebuildPrecalc = GUICtrlCreateButton("Rebuild Precalc", $iBtnX + (($iBtnW + $iBtnGap) * 2), $iBtnY, $iBtnW + 15, $iBtnH)
			GUICtrlSetOnEvent(-1, "AttackCSVSettings_RebuildPrecalc")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 80
	GUICtrlCreateGroup("Status", $x, $y, $w, $g_iSizeHGrpTab1 - $y - 10)
		$g_hLblCSVSettingsScript = GUICtrlCreateLabel("Script: -", $x + 10, $y + 20, $w - 20, 16)
		$g_hLblCSVSettingsPath = GUICtrlCreateLabel("Path: -", $x + 10, $y + 36, $w - 20, 16)
		$g_hLblCSVSettingsLoaded = GUICtrlCreateLabel("Loaded: -", $x + 10, $y + 52, 180, 16)
		$g_hLblCSVSettingsVersion = GUICtrlCreateLabel("CSV: -", $x + 10, $y + 68, 180, 16)
		$g_hLblCSVSettingsDirty = GUICtrlCreateLabel("Status: Saved", $x + 200, $y + 52, 180, 16)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Populate script lists on load
	UpdateComboScriptNameBattle()
	UpdateComboScriptNameRankedBattle()
EndFunc   ;==>CreateCSVModScriptTab
