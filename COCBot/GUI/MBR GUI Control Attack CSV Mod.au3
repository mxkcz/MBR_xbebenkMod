; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Attack CSV Mod
; Description ...: GUI handlers for the CSV Mod tab.
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

; #FUNCTION# ====================================================================================================================
; Name ..........: CSVMod_ToggleDisableFullResources
; Description ...: Updates auto-disable search criteria flag when storage is full.
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
Func CSVMod_ToggleDisableFullResources()
	$g_bSearchDisableFullResources = (GUICtrlRead($g_hChkSearchDisableFullResources) = $GUI_CHECKED)
EndFunc   ;==>CSVMod_ToggleDisableFullResources

; #FUNCTION# ====================================================================================================================
; Name ..........: AttackCSVSettings_GetVersionFromFile
; Description ...: Retrieves Version from AttackCSV file
; Syntax ........:
; Parameters ....: Path
; Return values .: Str
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; =====================================================================================================================
; Side-effect: io (file read)
Func AttackCSVSettings_GetVersionFromFile($sPath)
	Local $aLines = AttackCSVSettings_ReadLines($sPath)
	If @error Then Return "unknown"
	Return AttackCSVSettings_DetectVersion($aLines)
EndFunc   ;==>AttackCSVSettings_GetVersionFromFile

; Side-effect: io (file read)
Func AttackCSVSettings_ReadLines($sPath)
	Local $aLines = FileReadToArray($sPath)
	If @error Then
		SetLog("Attack CSV settings: failed reading " & $sPath, $COLOR_ERROR)
		SetError(1, 0, 0)
		Return
	EndIf
	Return $aLines
EndFunc   ;==>AttackCSVSettings_ReadLines


; Migrated CSV helper functions
Func AttackCSVSettings_ApplyToGUI()
	If $g_hGUI_AttackCSVSettings = 0 Then Return
	Local $sScript = AttackCSVSettings_GetScriptName($g_iAttackCSVSettingsMode)
	If $sScript = "" Then
		SetLog("Attack CSV settings: no script selected.", $COLOR_ERROR)
		Return
	EndIf
	CSVSettings_RecalcOverridesChanged()
	SetDebugLog("CSV RECALC side override = " & $g_sCSVRecalcSideOverride, $COLOR_INFO)
	SetDebugLog("CSV RECALC vector override = " & ($g_sCSVRecalcVectorTargets = "" ? "AUTO" : $g_sCSVRecalcVectorTargets), $COLOR_INFO)
	AttackCSVSettings_SaveToCSV($g_iAttackCSVSettingsMode)
	If $g_iAttackCSVSettingsMode = $RankedBattle Then
		ApplyScriptAB()
	Else
		ApplyScriptDB()
	EndIf
EndFunc   ;==>AttackCSVSettings_ApplyToGUI

; Side-effect: io (GUI state updates)
Func CSVSettings_SetDirty($bDirty)
	$g_bCSVSettingsDirty = $bDirty
	If $g_hLblCSVSettingsDirty <> 0 Then
		GUICtrlSetData($g_hLblCSVSettingsDirty, $bDirty ? "Status: Unsaved" : "Status: Saved")
		GUICtrlSetColor($g_hLblCSVSettingsDirty, $bDirty ? $COLOR_ERROR : $COLOR_BLACK)
	EndIf
EndFunc   ;==>CSVSettings_SetDirty

; Side-effect: io (GUI state updates)
Func CSVSettings_MarkDirty()
	If Not $g_bCSVSettingsDirty Then CSVSettings_SetDirty(True)
EndFunc   ;==>CSVSettings_MarkDirty

; Side-effect: io (GUI state updates)
Func AttackCSVSettings_UpdateHeader($sScript, $sPath, $sLoaded, $sVersion = "")
	Local $sLabelScript = ($sScript <> "") ? $sScript : "-"
	Local $sLabelPath = ($sPath <> "") ? $sPath : "-"
	Local $sLabelLoaded = ($sLoaded <> "") ? $sLoaded : "-"
	Local $sLabelVersion = ($sVersion <> "") ? $sVersion : "-"
	; TODO: add a tooltip or truncation when the path exceeds the label width.
	If $g_hLblCSVSettingsScript <> 0 Then GUICtrlSetData($g_hLblCSVSettingsScript, "Script: " & $sLabelScript)
	If $g_hLblCSVSettingsPath <> 0 Then GUICtrlSetData($g_hLblCSVSettingsPath, "Path: " & $sLabelPath)
	If $g_hLblCSVSettingsLoaded <> 0 Then GUICtrlSetData($g_hLblCSVSettingsLoaded, "Loaded: " & $sLabelLoaded)
	If $g_hLblCSVSettingsVersion <> 0 Then GUICtrlSetData($g_hLblCSVSettingsVersion, "CSV: " & $sLabelVersion)
EndFunc   ;==>AttackCSVSettings_UpdateHeader

; Side-effect: io (file read + GUI state updates)
Func AttackCSVSettings_ReloadFromCSV()
	If $g_hGUI_AttackCSVSettings = 0 Then Return
	; TODO: prompt before discarding unsaved edits instead of only logging.
	If $g_bCSVSettingsDirty Then SetLog("Attack CSV settings: reload requested, discarding unsaved edits.", $COLOR_WARNING)
	AttackCSVSettings_LoadFromCSV($g_iAttackCSVSettingsMode)
EndFunc   ;==>AttackCSVSettings_ReloadFromCSV

; #FUNCTION# ====================================================================================================================
; Name ..........: AttackCSVSettings_AttackNowBattle
; Description ...: Run a manual battle test attack using the selected CSV script with updated CSV precalc.
; Syntax ........: AttackCSVSettings_AttackNowBattle()
; Parameters ....: None
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
; Side-effect: automation (triggers attack flow usingBattlescripted settings)
Func AttackCSVSettings_AttackNowBattle()
	If $g_hGUI_AttackCSVSettings = 0 Then Return
	Local $sScript = AttackCSVSettings_GetScriptName($Battle)
	If $sScript = "" Then
		SetLog("CSV settings battle test: no battle script selected.", $COLOR_ERROR)
		Return
	EndIf
	SetLog("CSV settings battle test: " & $sScript & " (manual target required)", $COLOR_INFO)

	Local $tempbRunState = $g_bRunState
	Local $tempSieges = $g_aiCurrentSiegeMachines
	$g_aiCurrentSiegeMachines[$eSiegeWallWrecker] = 1
	$g_aiCurrentSiegeMachines[$eSiegeBattleBlimp] = 1
	$g_aiCurrentSiegeMachines[$eSiegeStoneSlammer] = 1
	$g_aiCurrentSiegeMachines[$eSiegeBarracks] = 1
	$g_aiCurrentSiegeMachines[$eSiegeLogLauncher] = 1
	$g_aiAttackAlgorithm[$Battle] = 1
	$g_sAttackScrScriptName[$Battle] = $sScript
	$g_iMatchMode = $Battle
	$g_bRunState = True
	If Not PrepareAttackCSV($g_iMatchMode, True) Then
		SetDebugLog("CSV settings battle test: precalc failed, continuing with live scan", $COLOR_WARNING)
	EndIf
	PrepareAttack($g_iMatchMode)
	Algorithm_AttackCSV()
	$g_aiCurrentSiegeMachines = $tempSieges
	$g_bRunState = $tempbRunState
EndFunc   ;==>AttackCSVSettings_AttackNowBattle

; #FUNCTION# ====================================================================================================================
; Name ..........: AttackCSVSettings_TestAttackLive
; Description ...: Run a live CSV test attack for the selected mode.
; Syntax ........: AttackCSVSettings_TestAttackLive()
; Parameters ....: None
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
; Side-effect: automation (triggers test attack flow)
Func AttackCSVSettings_TestAttackLive()
	_AttackCSVSettings_RunTest(False)
EndFunc   ;==>AttackCSVSettings_TestAttackLive

; #FUNCTION# ====================================================================================================================
; Name ..........: AttackCSVSettings_TestAttackBattle
; Description ...: Backward-compatible alias used by CSV Mod script tab test button.
; Syntax ........: AttackCSVSettings_TestAttackBattle()
; Parameters ....: None
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func AttackCSVSettings_TestAttackBattle()
	AttackCSVSettings_TestAttackLive()
EndFunc   ;==>AttackCSVSettings_TestAttackBattle

; #FUNCTION# ====================================================================================================================
; Name ..........: chkBattleWardenAttack
; Description ...: Toggle battle warden mode combo based on battle warden checkbox state.
; Syntax ........: chkBattleWardenAttack()
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
Func chkBattleWardenAttack()
	If $g_hCmbDBWardenMode = 0 Or $g_hchkBattleWardenAttack = 0 Then Return
	If GUICtrlRead($g_hchkBattleWardenAttack) = $GUI_CHECKED Then
		GUICtrlSetState($g_hCmbDBWardenMode, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hCmbDBWardenMode, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkBattleWardenAttack

; #FUNCTION# ====================================================================================================================
; Name ..........: chkRankedBattleWardenAttack
; Description ...: Toggle ranked battle warden combo based on ranked battle warden checkbox state.
; Syntax ........: chkRankedBattleWardenAttack()
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
Func chkRankedBattleWardenAttack()
	If $g_hCmbABWardenMode = 0 Or $g_hchkRankedBattleWardenAttack = 0 Then Return
	If GUICtrlRead($g_hchkRankedBattleWardenAttack) = $GUI_CHECKED Then
		GUICtrlSetState($g_hCmbABWardenMode, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hCmbABWardenMode, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkRankedBattleWardenAttack

; #FUNCTION# ====================================================================================================================
; Name ..........: chkBattleDropCC
; Description ...: Toggle battle siege combo based on battle drop-CC checkbox state.
; Syntax ........: chkBattleDropCC()
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
Func chkBattleDropCC()
	If $g_hCmbDBSiege = 0 Or $g_hchkBattleDropCC = 0 Then Return
	GUICtrlSetState($g_hCmbDBSiege, GUICtrlRead($g_hchkBattleDropCC) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
EndFunc   ;==>chkBattleDropCC

; #FUNCTION# ====================================================================================================================
; Name ..........: chkRankedBattleDropCC
; Description ...: Toggle ranked battle siege combo based on ranked battle drop-CC checkbox state.
; Syntax ........: chkRankedBattleDropCC()
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
Func chkRankedBattleDropCC()
	If $g_hCmbABSiege = 0 Or $g_hchkRankedBattleDropCC = 0 Then Return
	GUICtrlSetState($g_hCmbABSiege, GUICtrlRead($g_hchkRankedBattleDropCC) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
EndFunc   ;==>chkRankedBattleDropCC

; Legacy callbacks retained for applyConfig compatibility after removing old Attack tabs.
; #FUNCTION# ====================================================================================================================
; Name ..........: cmbDBAlgorithm
; Description ...: Compatibility callback retained for DB algorithm combo event wiring.
; Syntax ........: cmbDBAlgorithm()
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
Func cmbDBAlgorithm()
EndFunc   ;==>cmbDBAlgorithm

; #FUNCTION# ====================================================================================================================
; Name ..........: cmbABAlgorithm
; Description ...: Compatibility callback retained for AB algorithm combo event wiring.
; Syntax ........: cmbABAlgorithm()
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
Func cmbABAlgorithm()
EndFunc   ;==>cmbABAlgorithm

; #FUNCTION# ====================================================================================================================
; Name ..........: AttackCSVSettings_TestAttackDry
; Description ...: Run a dry CSV test pass (parse + precalc only).
; Syntax ........: AttackCSVSettings_TestAttackDry()
; Parameters ....: None
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
; Side-effect: automation (parses CSV with no live actions)
Func AttackCSVSettings_TestAttackDry()
	_AttackCSVSettings_RunTest(True)
EndFunc   ;==>AttackCSVSettings_TestAttackDry

; #FUNCTION# ====================================================================================================================
; Name ..........: _AttackCSVSettings_RunTest
; Description ...: Shared runner for live/dry CSV tests.
; Syntax ........: _AttackCSVSettings_RunTest($bDryRun)
; Parameters ....: $bDryRun          - True for dry-run (no live actions).
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
; Side-effect: automation (runs CSV pipeline)
Func _AttackCSVSettings_RunTest($bDryRun)
	If $g_hGUI_AttackCSVSettings = 0 Then Return
	Local $iMode = $g_iAttackCSVSettingsMode
	Local $sScript = AttackCSVSettings_GetScriptName($iMode)
	If $sScript = "" Then
		SetLog("CSV settings test: no script selected.", $COLOR_ERROR)
		Return
	EndIf
	CSVSettings_RecalcOverridesChanged()

	Local $sModeLabel = ($iMode >= 0 And $iMode < UBound($g_asModeText) ? $g_asModeText[$iMode] : "mode " & $iMode)
	SetLog("CSV settings test (" & ($bDryRun ? "dry" : "live") & "): " & $sScript & " (" & $sModeLabel & ")", $COLOR_INFO)

	Local $tempbRunState = $g_bRunState
	Local $tempSieges = $g_aiCurrentSiegeMachines
	Local $tempMatchMode = $g_iMatchMode
	Local $tempScript = $g_sAttackScrScriptName[$iMode]
	Local $tempAlgorithm = $g_aiAttackAlgorithm[$iMode]

	$g_aiCurrentSiegeMachines[$eSiegeWallWrecker] = 1
	$g_aiCurrentSiegeMachines[$eSiegeBattleBlimp] = 1
	$g_aiCurrentSiegeMachines[$eSiegeStoneSlammer] = 1
	$g_aiCurrentSiegeMachines[$eSiegeBarracks] = 1
	$g_aiCurrentSiegeMachines[$eSiegeLogLauncher] = 1
	$g_aiAttackAlgorithm[$iMode] = 1
	$g_sAttackScrScriptName[$iMode] = $sScript
	$g_iMatchMode = $iMode
	$g_bRunState = True

	If Not PrepareAttackCSV($g_iMatchMode, True) Then
		SetDebugLog("CSV settings test: precalc failed, continuing", $COLOR_WARNING)
	EndIf
	PrepareAttack($g_iMatchMode)
	If $bDryRun Then
		Algorithm_AttackCSV(True, False)
	Else
		Algorithm_AttackCSV()
	EndIf

	$g_aiCurrentSiegeMachines = $tempSieges
	$g_bRunState = $tempbRunState
	$g_iMatchMode = $tempMatchMode
	$g_sAttackScrScriptName[$iMode] = $tempScript
	$g_aiAttackAlgorithm[$iMode] = $tempAlgorithm

	AttackCSVSettings_UpdateDiagnostics()
	AttackCSVSettings_UpdatePrioPreview()
	AttackCSVSettings_UpdatePrecalcStatus()
EndFunc   ;==>_AttackCSVSettings_RunTest

; #FUNCTION# ====================================================================================================================
; Name ..........: AttackCSVSettings_RebuildPrecalc
; Description ...: Force PrepareAttackCSV refresh and update GUI status panels.
; Syntax ........: AttackCSVSettings_RebuildPrecalc()
; Parameters ....: None
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
; Side-effect: io (reads CSV, updates diagnostics)
Func AttackCSVSettings_RebuildPrecalc()
	If $g_hGUI_AttackCSVSettings = 0 Then Return
	Local $iMode = $g_iAttackCSVSettingsMode
	Local $sScript = AttackCSVSettings_GetScriptName($iMode)
	If $sScript = "" Then
		SetLog("CSV precalc: no script selected.", $COLOR_ERROR)
		Return
	EndIf
	CSVSettings_RecalcOverridesChanged()

	Local $hTimer = __timerinit()
	Local $bOk = PrepareAttackCSV($iMode, True)
	$g_iCSVLastPrecalcMs = Round(__timerdiff($hTimer))
	$g_sCSVLastPrecalcTime = @YEAR & "-" & StringFormat("%02d", @MON) & "-" & StringFormat("%02d", @MDAY) & " " & _
			StringFormat("%02d", @HOUR) & ":" & StringFormat("%02d", @MIN) & ":" & StringFormat("%02d", @SEC)

	If Not $bOk Then SetLog("CSV precalc: PrepareAttackCSV failed", $COLOR_WARNING)
	AttackCSVSettings_ValidateCSV()
	If AttackCSV_PreparePrioPlan($sScript) = 0 Then
		SetLog("CSV precalc: no PRIO candidates built", $COLOR_WARNING)
	ElseIf $g_abCSVPrepHasPrioMake[$iMode] And IsObj($g_oCSVPrioPlan) And $g_oCSVPrioPlan.Count = 0 Then
		SetLog("CSV precalc: PRIO plan empty", $COLOR_WARNING)
	EndIf

	AttackCSVSettings_UpdatePrecalcStatus()
	AttackCSVSettings_UpdateDiagnostics()
	AttackCSVSettings_UpdatePrioPreview()
	AttackCSVSettings_UpdateDebugPanel()
EndFunc   ;==>AttackCSVSettings_RebuildPrecalc

; #FUNCTION# ====================================================================================================================
; Name ..........: CSVSettings_SetPrecacheMode
; Description ...: Set CSV precache aggressiveness mode from GUI.
; Syntax ........: CSVSettings_SetPrecacheMode()
; Parameters ....: None
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
; Side-effect: io (GUI state updates)
Func CSVSettings_SetPrecacheMode()
	Switch @GUI_CtrlId
		Case $g_hRadCSVPrecacheAggressive
			$g_iCSVPrecacheMode = $g_iCSVPrecacheAggressive
		Case $g_hRadCSVPrecacheConservative
			$g_iCSVPrecacheMode = $g_iCSVPrecacheConservative
		Case Else
			Return
	EndSwitch

	If $g_hRadCSVPrecacheConservative <> 0 Then
		GUICtrlSetState($g_hRadCSVPrecacheConservative, ($g_iCSVPrecacheMode = $g_iCSVPrecacheConservative) ? $GUI_CHECKED : $GUI_UNCHECKED)
	EndIf
	If $g_hRadCSVPrecacheAggressive <> 0 Then
		GUICtrlSetState($g_hRadCSVPrecacheAggressive, ($g_iCSVPrecacheMode = $g_iCSVPrecacheAggressive) ? $GUI_CHECKED : $GUI_UNCHECKED)
	EndIf
	AttackCSVSettings_UpdatePrecalcStatus()
EndFunc   ;==>CSVSettings_SetPrecacheMode

; #FUNCTION# ====================================================================================================================
; Name ..........: CSVSettings_RecalcOverridesChanged
; Description ...: Sync RECALC override controls into globals.
; Syntax ........: CSVSettings_RecalcOverridesChanged()
; Parameters ....: None
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
; Side-effect: io (reads GUI state, updates globals)
Func CSVSettings_RecalcOverridesChanged()
	If $g_hGUI_AttackCSVSettings = 0 Then Return

	If $g_hCmbCSVRecalcSideOverride <> 0 Then
		Local $iSel = _GUICtrlComboBox_GetCurSel($g_hCmbCSVRecalcSideOverride)
		Local $sSide = "NONE"
		If $iSel >= 0 Then _GUICtrlComboBox_GetLBText($g_hCmbCSVRecalcSideOverride, $iSel, $sSide)
		$g_sCSVRecalcSideOverride = _CSVNormalizeRecalcSideOverride($sSide, True)
	EndIf

	If $g_hInpCSVRecalcVectors <> 0 Then
		Local $hCtrl = GUICtrlGetHandle($g_hInpCSVRecalcVectors)
		If $hCtrl <> 0 Then
			Local $sRaw = ControlGetText($g_hGUI_AttackCSVSettings, "", $hCtrl)
			$g_sCSVRecalcVectorTargets = StringStripWS($sRaw, $STR_STRIPALL)
		EndIf
	EndIf
EndFunc   ;==>CSVSettings_RecalcOverridesChanged

; #FUNCTION# ====================================================================================================================
; Name ..........: CSVSettings_ToggleDebugFlag
; Description ...: Toggle CSV-related debug flags and sync UI.
; Syntax ........: CSVSettings_ToggleDebugFlag()
; Parameters ....: None
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
; Side-effect: io (mutates debug globals + GUI state)
Func CSVSettings_ToggleDebugFlag()
	Switch @GUI_CtrlId
		Case $g_hChkCSVDbgSetlog
			$g_bDebugSetlog = Not $g_bDebugSetlog
		Case $g_hChkCSVDbgClick
			$g_bDebugClick = Not $g_bDebugClick
		Case $g_hChkCSVDbgRedArea
			$g_bDebugRedArea = Not $g_bDebugRedArea
		Case $g_hChkCSVDbgOcr
			$g_bDebugOcr = Not $g_bDebugOcr
		Case $g_hChkCSVDbgAttackCSV
			$g_bDebugAttackCSV = Not $g_bDebugAttackCSV
		Case $g_hChkCSVDbgMakeImg
			$g_bDebugMakeIMGCSV = Not $g_bDebugMakeIMGCSV
		Case $g_hChkCSVDbgAttackTiming
			$g_bDebugAttackTiming = Not $g_bDebugAttackTiming
		Case $g_hChkCSVDbgRescan
			$g_bDebugAttackRescan = Not $g_bDebugAttackRescan
		Case Else
			Return
	EndSwitch

	AttackCSVSettings_UpdateDebugPanel()
EndFunc   ;==>CSVSettings_ToggleDebugFlag

; #FUNCTION# ====================================================================================================================
; Name ..........: AttackCSVSettings_UpdatePrecalcStatus
; Description ...: Refresh precalc status panel and budget labels.
; Syntax ........: AttackCSVSettings_UpdatePrecalcStatus()
; Parameters ....: None
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
; Side-effect: io (GUI state updates)
Func AttackCSVSettings_UpdatePrecalcStatus()
	If $g_hLblCSVPrecacheBudget <> 0 Then
		GUICtrlSetData($g_hLblCSVPrecacheBudget, "Precalc budget: " & Round($g_iCSVPrecalcBudgetMs / 1000, 1) & "s")
	EndIf
	If $g_hLblCSVPrecacheLast <> 0 Then
		Local $sLast = ($g_sCSVLastPrecalcTime <> "" ? $g_sCSVLastPrecalcTime : "-")
		GUICtrlSetData($g_hLblCSVPrecacheLast, "Last precalc: " & $sLast & " (" & $g_iCSVLastPrecalcMs & " ms)")
	EndIf
	If $g_hRadCSVPrecacheConservative <> 0 Then
		GUICtrlSetState($g_hRadCSVPrecacheConservative, ($g_iCSVPrecacheMode = $g_iCSVPrecacheConservative) ? $GUI_CHECKED : $GUI_UNCHECKED)
	EndIf
	If $g_hRadCSVPrecacheAggressive <> 0 Then
		GUICtrlSetState($g_hRadCSVPrecacheAggressive, ($g_iCSVPrecacheMode = $g_iCSVPrecacheAggressive) ? $GUI_CHECKED : $GUI_UNCHECKED)
	EndIf

	If $g_hTxtCSVPrecalcStatus = 0 Then Return

	Local $iMode = $g_iAttackCSVSettingsMode
	Local $sScript = AttackCSVSettings_GetScriptName($iMode)
	If $sScript = "" Then
		GUICtrlSetData($g_hTxtCSVPrecalcStatus, "No CSV script selected.")
		Return
	EndIf

	Local $sStatus = "Script: " & $sScript & @CRLF
	Local $bPrepValid = ($g_abCSVPrepValid[$iMode] And $g_asCSVPrepName[$iMode] = $sScript)
	$sStatus &= "Precalc cache: " & ($bPrepValid ? "valid" : "stale") & @CRLF

	Local $aMakeSidesUsed[4] = [False, False, False, False]
	Local $bAllMakeTargeted = False
	If $bPrepValid And AttackCSV_GetPreparedMakeUsage($iMode, $aMakeSidesUsed, $bAllMakeTargeted) Then
		$sStatus &= "Targeted-only: " & ($bAllMakeTargeted ? "yes" : "no") & @CRLF
	Else
		$sStatus &= "Targeted-only: unknown" & @CRLF
	EndIf

	Local $bRedline = ($g_sImglocRedline <> "")
	If Not $bRedline And IsObj($g_oBldgAttackInfo) Then
		$bRedline = _ObjSearch($g_oBldgAttackInfo, $eBldgRedLine & "_OBJECTPOINTS")
	EndIf
	$sStatus &= "Redline cache: " & ($bRedline ? "available" : "missing") & @CRLF

	Local $iCap = $g_iCSVTargetedMaxReturnPoints
	Local $iOverride = Default
	If $bAllMakeTargeted And $iCap > 0 Then
		$iOverride = AttackCSV_GetTargetMaxReturnPoints($iMode, $g_iSearchTH, $iCap)
	EndIf
	If $iOverride <> Default Then
		$sStatus &= "MaxReturnPoints cap: " & $iOverride & " (base " & $iCap & ")" & @CRLF
	Else
		$sStatus &= "MaxReturnPoints cap: " & $iCap & @CRLF
	EndIf

	Local $aSideKeys[4] = ["TOP-LEFT", "TOP-RIGHT", "BOTTOM-LEFT", "BOTTOM-RIGHT"]
	Local $aSideShort[4] = ["TL", "TR", "BL", "BR"]
	Local $sPrio = "PRIO plan counts:"
	If IsObj($g_oCSVPrioPlan) Then
		For $i = 0 To 3
			Local $iCount = ($g_oCSVPrioPlan.Exists($aSideKeys[$i]) ? UBound($g_oCSVPrioPlan.Item($aSideKeys[$i])) : 0)
			$sPrio &= " " & $aSideShort[$i] & "=" & $iCount
		Next
	Else
		$sPrio &= " n/a"
	EndIf
	$sStatus &= $sPrio & @CRLF

	GUICtrlSetData($g_hTxtCSVPrecalcStatus, $sStatus)
EndFunc   ;==>AttackCSVSettings_UpdatePrecalcStatus

; #FUNCTION# ====================================================================================================================
; Name ..........: AttackCSVSettings_UpdateDiagnostics
; Description ...: Refresh CSV diagnostics pane with counts and warnings.
; Syntax ........: AttackCSVSettings_UpdateDiagnostics()
; Parameters ....: None
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
; Side-effect: io (reads CSV + GUI state updates)
Func AttackCSVSettings_UpdateDiagnostics()
	If $g_hTxtCSVDiagnostics = 0 Then Return
	Local $iMode = $g_iAttackCSVSettingsMode
	Local $sScript = AttackCSVSettings_GetScriptName($iMode)
	If $sScript = "" Then
		GUICtrlSetData($g_hTxtCSVDiagnostics, "No CSV script selected.")
		Return
	EndIf
	Local $sPath = $g_sCSVAttacksPath & "\" & $sScript & ".csv"
	Local $aLines = AttackCSVSettings_ReadLines($sPath)
	If @error Then
		GUICtrlSetData($g_hTxtCSVDiagnostics, "Failed to read CSV: " & $sPath)
		Return
	EndIf

	Local $iMake = 0, $iSide = 0, $iSideB = 0, $iWait = 0
	For $iLine = 0 To UBound($aLines) - 1
		Local $aCols = StringSplit($aLines[$iLine], "|", 2)
		Local $sCmd = AttackCSVSettings_GetCommand($aCols)
		Switch $sCmd
			Case "MAKE"
				$iMake += 1
			Case "SIDE"
				$iSide += 1
			Case "SIDEB"
				$iSideB += 1
			Case "WAIT"
				$iWait += 1
		EndSwitch
	Next

	Local $sDiag = "Script: " & $sScript & @CRLF & _
			"Counts: MAKE=" & $iMake & " SIDE=" & $iSide & " SIDEB=" & $iSideB & " WAIT=" & $iWait & @CRLF

	Local $aMakeSidesUsed[4] = [False, False, False, False]
	Local $bAllMakeTargeted = False
	If $g_abCSVPrepValid[$iMode] And AttackCSV_GetPreparedMakeUsage($iMode, $aMakeSidesUsed, $bAllMakeTargeted) Then
		$sDiag &= "Targeted-only: " & ($bAllMakeTargeted ? "yes" : "no") & @CRLF
		Local $bAnyLocate = _CSVHasAnyLocateFlag($iMode, $g_iSearchTH)
		If $bAllMakeTargeted And Not $bAnyLocate Then
			$sDiag &= "Warning: targeted-only with zero locate flags (fallback to redline)." & @CRLF
		EndIf
	Else
		$sDiag &= "Targeted-only: unknown (precalc stale)" & @CRLF
	EndIf

	If UBound($g_asCSVDiagnostics) > 0 Then
		$sDiag &= @CRLF & "Diagnostics (last lines):" & @CRLF
		Local $iStart = UBound($g_asCSVDiagnostics) - 5
		If $iStart < 0 Then $iStart = 0
		For $i = $iStart To UBound($g_asCSVDiagnostics) - 1
			$sDiag &= $g_asCSVDiagnostics[$i] & @CRLF
		Next
	EndIf

	GUICtrlSetData($g_hTxtCSVDiagnostics, $sDiag)
EndFunc   ;==>AttackCSVSettings_UpdateDiagnostics

; #FUNCTION# ====================================================================================================================
; Name ..........: AttackCSVSettings_UpdatePrioPreview
; Description ...: Refresh PRIO preview list using cached locate data.
; Syntax ........: AttackCSVSettings_UpdatePrioPreview()
; Parameters ....: None
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
; Side-effect: io (GUI state updates)
Func AttackCSVSettings_UpdatePrioPreview()
	If $g_hTxtCSVPrioPreview = 0 Then Return
	Local $aSideKeys[4] = ["TOP-LEFT", "TOP-RIGHT", "BOTTOM-LEFT", "BOTTOM-RIGHT"]
	Local $aSideShort[4] = ["TL", "TR", "BL", "BR"]
	Local $sPreview = ""

	For $s = 0 To 3
		Local $sSideKey = $aSideKeys[$s]
		$sPreview &= $aSideShort[$s] & ": "
		Local $aTargets = _CSVPrioGetTargetsForSide($sSideKey)
		If @error Or Not IsArray($aTargets) Or UBound($aTargets) = 0 Then
			$sPreview &= "no targets" & @CRLF
			ContinueLoop
		EndIf

		Local $iMax = (UBound($aTargets) > 3 ? 3 : UBound($aTargets))
		For $i = 0 To $iMax - 1
			If $i > 0 Then $sPreview &= "; "
			$sPreview &= $aTargets[$i][1] & " w" & $aTargets[$i][4] & " d" & $aTargets[$i][5]
		Next

		Local $iPlanCount = 0
		If IsObj($g_oCSVPrioPlan) And $g_oCSVPrioPlan.Exists($sSideKey) Then
			$iPlanCount = UBound($g_oCSVPrioPlan.Item($sSideKey))
		EndIf
		$sPreview &= " (plan " & $iPlanCount & "/" & UBound($aTargets) & ")" & @CRLF
	Next

	GUICtrlSetData($g_hTxtCSVPrioPreview, $sPreview)
EndFunc   ;==>AttackCSVSettings_UpdatePrioPreview

; #FUNCTION# ====================================================================================================================
; Name ..........: AttackCSVSettings_UpdateDebugPanel
; Description ...: Sync debug flags and show last diagnostics lines.
; Syntax ........: AttackCSVSettings_UpdateDebugPanel()
; Parameters ....: None
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
; Side-effect: io (GUI state updates)
Func AttackCSVSettings_UpdateDebugPanel()
	If $g_hChkCSVDbgSetlog <> 0 Then GUICtrlSetState($g_hChkCSVDbgSetlog, $g_bDebugSetlog ? $GUI_CHECKED : $GUI_UNCHECKED)
	If $g_hChkCSVDbgClick <> 0 Then GUICtrlSetState($g_hChkCSVDbgClick, $g_bDebugClick ? $GUI_CHECKED : $GUI_UNCHECKED)
	If $g_hChkCSVDbgRedArea <> 0 Then GUICtrlSetState($g_hChkCSVDbgRedArea, $g_bDebugRedArea ? $GUI_CHECKED : $GUI_UNCHECKED)
	If $g_hChkCSVDbgOcr <> 0 Then GUICtrlSetState($g_hChkCSVDbgOcr, $g_bDebugOcr ? $GUI_CHECKED : $GUI_UNCHECKED)
	If $g_hChkCSVDbgAttackCSV <> 0 Then GUICtrlSetState($g_hChkCSVDbgAttackCSV, $g_bDebugAttackCSV ? $GUI_CHECKED : $GUI_UNCHECKED)
	If $g_hChkCSVDbgMakeImg <> 0 Then GUICtrlSetState($g_hChkCSVDbgMakeImg, $g_bDebugMakeIMGCSV ? $GUI_CHECKED : $GUI_UNCHECKED)
	If $g_hChkCSVDbgAttackTiming <> 0 Then GUICtrlSetState($g_hChkCSVDbgAttackTiming, $g_bDebugAttackTiming ? $GUI_CHECKED : $GUI_UNCHECKED)
	If $g_hChkCSVDbgRescan <> 0 Then GUICtrlSetState($g_hChkCSVDbgRescan, $g_bDebugAttackRescan ? $GUI_CHECKED : $GUI_UNCHECKED)

	If $g_hLblCSVDbgSummary <> 0 Then
		Local $sSummary = "Debug summary: setlog=" & ($g_bDebugSetlog ? "on" : "off") & _
				" click=" & ($g_bDebugClick ? "on" : "off") & _
				" red=" & ($g_bDebugRedArea ? "on" : "off") & _
				" ocr=" & ($g_bDebugOcr ? "on" : "off") & _
				" csv=" & ($g_bDebugAttackCSV ? "on" : "off") & _
				" timing=" & ($g_bDebugAttackTiming ? "on" : "off") & _
				" rescan=" & ($g_bDebugAttackRescan ? "on" : "off")
		GUICtrlSetData($g_hLblCSVDbgSummary, $sSummary)
	EndIf

	If $g_hTxtCSVDebugLines <> 0 Then
		Local $sLines = ""
		Local $iStart = UBound($g_asCSVDiagnostics) - 5
		If $iStart < 0 Then $iStart = 0
		For $i = $iStart To UBound($g_asCSVDiagnostics) - 1
			$sLines &= $g_asCSVDiagnostics[$i] & @CRLF
		Next
		GUICtrlSetData($g_hTxtCSVDebugLines, $sLines)
	EndIf
EndFunc   ;==>AttackCSVSettings_UpdateDebugPanel

; Side-effect: automation (debug CSV building locate pass with test image support)
Func debugCSVLocateBuildings()
	If $g_hGUI_AttackCSVSettings = 0 Then Return
	Local $sScript = AttackCSVSettings_GetScriptName($g_iAttackCSVSettingsMode)
	If $sScript = "" Then
		SetLog("CSV locate debug: no script selected.", $COLOR_ERROR)
		Return
	EndIf

	BeginImageTest() ; allow screenshot or file-based test

	Local $currentRunState = $g_bRunState
	Local $currentDebugAttackCSV = $g_bDebugAttackCSV
	Local $currentMakeIMGCSV = $g_bDebugMakeIMGCSV
	Local $currentiMatchMode = $g_iMatchMode
	Local $currentdebugsetlog = $g_bDebugSetlog
	Local $currentDebugBuildingPos = $g_bDebugBuildingPos
	Local $currentScript = $g_sAttackScrScriptName[$g_iAttackCSVSettingsMode]

	$g_bRunState = True
	$g_bDebugAttackCSV = True
	$g_bDebugMakeIMGCSV = True
	$g_bDebugSetlog = True
	$g_bDebugBuildingPos = True

	$g_iMatchMode = $g_iAttackCSVSettingsMode
	$g_sAttackScrScriptName[$g_iMatchMode] = $sScript

	; reset village measures
	setVillageOffset(0, 0, 1)
	ConvertInternalExternArea()

	If Not CheckZoomOut("debugCSVLocateBuildings") Then
		SetLog("CheckZoomOut failed", $COLOR_INFO)
	EndIf
	ResetTHsearch()
	SetLog("CSV locate debug: FindTownhall()", $COLOR_INFO)
	SetLog("FindTownhall() = " & FindTownhall(True), $COLOR_INFO)
	SetLog("$g_sImglocRedline = " & $g_sImglocRedline, $COLOR_INFO)

	If $g_bDebugMakeIMGCSV And TestCapture() = 0 Then
		If $g_iSearchTH = "-" Then ; If TH is unknown, try again to find as it is needed for filename
			imglocTHSearch(True, False, False)
		EndIf
		SaveDebugImage("clean", False, Default, "TH" & $g_iSearchTH & "-") ; make clean snapshot as well
	EndIf
	;~ SetLog("CSV locate debug: PrepareAttack()", $COLOR_INFO)
	;~ PrepareAttack($g_iMatchMode)

	;~ SetLog("CSV locate debug: Algorithm_AttackCSV()", $COLOR_INFO)
	;~ Algorithm_AttackCSV(True, False) ; test mode, skip redline capture
	SetLog("CSV locate debug: DONE", $COLOR_INFO)

	EndImageTest() ; clear test image handle

	$g_bRunState = $currentRunState
	$g_bDebugAttackCSV = $currentDebugAttackCSV
	$g_bDebugMakeIMGCSV = $currentMakeIMGCSV
	$g_iMatchMode = $currentiMatchMode
	$g_bDebugSetlog = $currentdebugsetlog
	$g_bDebugBuildingPos = $currentDebugBuildingPos
	$g_sAttackScrScriptName[$g_iAttackCSVSettingsMode] = $currentScript
EndFunc   ;==>debugCSVLocateBuildings

; Side-effect: io (file read + logging)
Func AttackCSVSettings_ValidateCSV()
	If $g_hGUI_AttackCSVSettings = 0 Then Return
	; TODO: extend validation to DROP/TRAIN/REMAIN consistency and full ParseAttackCSV rules.
	Local $sScript = AttackCSVSettings_GetScriptName($g_iAttackCSVSettingsMode)
	If $sScript = "" Then
		SetLog("Attack CSV validation: no script selected.", $COLOR_ERROR)
		Return
	EndIf
	Local $sPath = $g_sCSVAttacksPath & "\" & $sScript & ".csv"
	Local $aLines = AttackCSVSettings_ReadLines($sPath)
	If @error Then Return

	Local $iErrors = 0
	Local $iWarnings = 0
	For $iLine = 0 To UBound($aLines) - 1
		Local $aCols = StringSplit($aLines[$iLine], "|", 2)
		Local $sCmd = AttackCSVSettings_GetCommand($aCols)
		If $sCmd = "" Or $sCmd = "NOTE" Then ContinueLoop

		Switch $sCmd
			Case "MAKE"
				Local $sVec = StringUpper(AttackCSVSettings_GetValue($aCols, 1))
				If $sVec = "" Or Not CheckCsvValues("MAKE", 1, $sVec) Then
					SetLog("CSV validate: line " & ($iLine + 1) & " MAKE vector invalid (" & $sVec & ")", $COLOR_ERROR)
					$iErrors += 1
				EndIf
				Local $sSide = StringUpper(AttackCSVSettings_GetValue($aCols, 2))
				If $sSide <> "" And Not CheckCsvValues("MAKE", 2, $sSide) Then
					SetLog("CSV validate: line " & ($iLine + 1) & " MAKE side invalid (" & $sSide & ")", $COLOR_ERROR)
					$iErrors += 1
				EndIf
				Local $sPoints = AttackCSVSettings_GetValue($aCols, 3)
				If $sPoints <> "" And Not AttackCSVSettings_IsNumericValue($sPoints) Then
					SetLog("CSV validate: line " & ($iLine + 1) & " MAKE points not numeric (" & $sPoints & ")", $COLOR_WARNING)
					$iWarnings += 1
				ElseIf $sPoints <> "" And $sPoints <> "1" And $sPoints <> "5" Then
					SetLog("CSV validate: line " & ($iLine + 1) & " MAKE points unusual (" & $sPoints & ")", $COLOR_WARNING)
					$iWarnings += 1
				EndIf
				Local $sOffset = AttackCSVSettings_GetValue($aCols, 4)
				If $sOffset <> "" And Not AttackCSVSettings_IsNumericValue($sOffset) Then
					SetLog("CSV validate: line " & ($iLine + 1) & " MAKE offset not numeric (" & $sOffset & ")", $COLOR_WARNING)
					$iWarnings += 1
				EndIf
				Local $sDropPoints = StringUpper(AttackCSVSettings_GetValue($aCols, 5))
				If $sDropPoints <> "" And Not CheckCsvValues("MAKE", 5, $sDropPoints) Then
					SetLog("CSV validate: line " & ($iLine + 1) & " MAKE drop points invalid (" & $sDropPoints & ")", $COLOR_ERROR)
					$iErrors += 1
				EndIf
				Local $sRandX = AttackCSVSettings_GetValue($aCols, 6)
				If $sRandX <> "" And Not AttackCSVSettings_IsNumericValue($sRandX) Then
					SetLog("CSV validate: line " & ($iLine + 1) & " MAKE random X not numeric (" & $sRandX & ")", $COLOR_WARNING)
					$iWarnings += 1
				EndIf
				Local $sRandY = AttackCSVSettings_GetValue($aCols, 7)
				If $sRandY <> "" And Not AttackCSVSettings_IsNumericValue($sRandY) Then
					SetLog("CSV validate: line " & ($iLine + 1) & " MAKE random Y not numeric (" & $sRandY & ")", $COLOR_WARNING)
					$iWarnings += 1
				EndIf
				Local $sBuilding = StringUpper(AttackCSVSettings_GetValue($aCols, 8))
				If $sBuilding <> "" And Not CheckCsvValues("MAKE", 8, $sBuilding) Then
					SetLog("CSV validate: line " & ($iLine + 1) & " MAKE target invalid (" & $sBuilding & ")", $COLOR_ERROR)
					$iErrors += 1
				EndIf
			Case "SIDE"
				For $i = 1 To 7
					Local $sVal = AttackCSVSettings_GetValue($aCols, $i)
					If $sVal <> "" And Not AttackCSVSettings_IsNumericValue($sVal) Then
						SetLog("CSV validate: line " & ($iLine + 1) & " SIDE weight invalid (" & $sVal & ")", $COLOR_WARNING)
						$iWarnings += 1
					EndIf
				Next
				Local $sForce = StringUpper(AttackCSVSettings_GetValue($aCols, 8))
				If $sForce <> "" Then
					Switch $sForce
						Case "TOP-LEFT", "TOP-RIGHT", "BOTTOM-LEFT", "BOTTOM-RIGHT", "TOP-RAND"
						Case Else
							SetLog("CSV validate: line " & ($iLine + 1) & " SIDE forced value invalid (" & $sForce & ")", $COLOR_WARNING)
							$iWarnings += 1
					EndSwitch
				EndIf
			Case "SIDEB"
				For $i = 1 To 14
					Local $sVal = AttackCSVSettings_GetValue($aCols, $i)
					If $sVal <> "" And Not AttackCSVSettings_IsNumericValue($sVal) Then
						SetLog("CSV validate: line " & ($iLine + 1) & " SIDEB weight invalid (" & $sVal & ")", $COLOR_WARNING)
						$iWarnings += 1
					EndIf
				Next
			Case "PRIOCAP"
				For $i = 1 To 4
					Local $sVal = AttackCSVSettings_GetValue($aCols, $i)
					If $sVal <> "" And Not AttackCSVSettings_IsNumericValue($sVal) Then
						SetLog("CSV validate: line " & ($iLine + 1) & " PRIOCAP value invalid (" & $sVal & ")", $COLOR_WARNING)
						$iWarnings += 1
					EndIf
				Next
			Case "WAIT"
				Local $sWait = AttackCSVSettings_GetValue($aCols, 1)
				If $sWait <> "" And Not AttackCSVSettings_IsRangeValue($sWait) Then
					SetLog("CSV validate: line " & ($iLine + 1) & " WAIT time invalid (" & $sWait & ")", $COLOR_WARNING)
					$iWarnings += 1
				EndIf
				Local $sCond = AttackCSVSettings_GetValue($aCols, 2)
				If $sCond <> "" Then
					Local $sUnknown = ""
					If Not AttackCSVSettings_ValidateWaitConditions($sCond, $sUnknown) Then
						SetLog("CSV validate: line " & ($iLine + 1) & " WAIT condition unknown (" & $sUnknown & ")", $COLOR_WARNING)
						$iWarnings += 1
					EndIf
				EndIf
		EndSwitch
	Next

	If $iErrors = 0 And $iWarnings = 0 Then
		SetLog("Attack CSV validation: OK (" & $sScript & ")", $COLOR_SUCCESS)
	Else
		SetLog("Attack CSV validation: " & $iErrors & " error(s), " & $iWarnings & " warning(s).", $COLOR_WARNING)
	EndIf
EndFunc   ;==>AttackCSVSettings_ValidateCSV

; Side-effect: io (GUI state updates)
Func CSVSideWeightsPresetZero()
	For $i = 0 To UBound($g_ahCSVSideWeightInputs) - 1
		If $g_ahCSVSideWeightInputs[$i] <> 0 Then GUICtrlSetData($g_ahCSVSideWeightInputs[$i], "0")
	Next
	CSVSettings_MarkDirty()
EndFunc   ;==>CSVSideWeightsPresetZero

; Side-effect: io (GUI state updates)
Func CSVSideWeightsPresetEqual()
	Local $iEqualWeight = 5
	For $i = 0 To UBound($g_ahCSVSideWeightInputs) - 1
		If $g_ahCSVSideWeightInputs[$i] <> 0 Then GUICtrlSetData($g_ahCSVSideWeightInputs[$i], $iEqualWeight)
	Next
	CSVSettings_MarkDirty()
EndFunc   ;==>CSVSideWeightsPresetEqual

; Side-effect: io (GUI state updates)
Func CSVSideBWeightsPresetZero()
	For $i = 0 To UBound($g_ahCSVSideBWeightInputs) - 1
		If $g_ahCSVSideBWeightInputs[$i] <> 0 Then GUICtrlSetData($g_ahCSVSideBWeightInputs[$i], "0")
	Next
	CSVSettings_MarkDirty()
EndFunc   ;==>CSVSideBWeightsPresetZero

; Side-effect: io (GUI state updates)
Func CSVSideBWeightsPresetEqual()
	Local $iEqualWeight = 5
	For $i = 0 To UBound($g_ahCSVSideBWeightInputs) - 1
		If $g_ahCSVSideBWeightInputs[$i] <> 0 Then GUICtrlSetData($g_ahCSVSideBWeightInputs[$i], $iEqualWeight)
	Next
	CSVSettings_MarkDirty()
EndFunc   ;==>CSVSideBWeightsPresetEqual

; Side-effect: io (GUI state updates)
Func CSVVectorSelect()
	If $g_hGUI_AttackCSVSettings = 0 Then Return
	AttackCSVSettings_LoadVectorFromCSV($g_iAttackCSVSettingsMode)
EndFunc   ;==>CSVVectorSelect

; Side-effect: io (file read/write)
Func CSVVectorUpdate()
	If $g_hGUI_AttackCSVSettings = 0 Then Return
	CSVVectorSyncTargetedState()
	AttackCSVSettings_SaveVectorToCSV($g_iAttackCSVSettingsMode)
EndFunc   ;==>CSVVectorUpdate

; Side-effect: io (GUI state updates)
Func CSVVectorSyncTargetedState()
	Local $bTargeted = (GUICtrlRead($g_hChkCSVVectorTargeted) = $GUI_CHECKED)
	If $g_hInpCSVRandomX <> 0 Then
		GUICtrlSetState($g_hInpCSVRandomX, $bTargeted ? $GUI_DISABLE : $GUI_ENABLE)
		If $bTargeted Then GUICtrlSetData($g_hInpCSVRandomX, "0")
	EndIf
	If $g_hInpCSVRandomY <> 0 Then
		GUICtrlSetState($g_hInpCSVRandomY, $bTargeted ? $GUI_DISABLE : $GUI_ENABLE)
		If $bTargeted Then GUICtrlSetData($g_hInpCSVRandomY, "0")
	EndIf
EndFunc   ;==>CSVVectorSyncTargetedState

; Side-effect: io (GUI state updates)
Func CSVRemainToggle()
	Local $bEnabled = (GUICtrlRead($g_hChkCSVDropRemaining) = $GUI_CHECKED)
	If $g_hChkCSVDropIncludeHeroes <> 0 Then
		GUICtrlSetState($g_hChkCSVDropIncludeHeroes, $bEnabled ? $GUI_ENABLE : $GUI_DISABLE)
		If Not $bEnabled Then GUICtrlSetState($g_hChkCSVDropIncludeHeroes, $GUI_UNCHECKED)
	EndIf
	If $g_hChkCSVDropIncludeSpells <> 0 Then
		GUICtrlSetState($g_hChkCSVDropIncludeSpells, $bEnabled ? $GUI_ENABLE : $GUI_DISABLE)
		If Not $bEnabled Then GUICtrlSetState($g_hChkCSVDropIncludeSpells, $GUI_UNCHECKED)
	EndIf
	CSVSettings_MarkDirty()
EndFunc   ;==>CSVRemainToggle

; Side-effect: io (GUI state updates)
Func CSVWaitComboToggle()
	Local $bAnyHero = (GUICtrlRead($g_hChkCSVBreakAnyHero) = $GUI_CHECKED)
	If $g_hChkCSVBreakAQ <> 0 Then
		GUICtrlSetState($g_hChkCSVBreakAQ, $bAnyHero ? $GUI_DISABLE : $GUI_ENABLE)
		If $bAnyHero Then GUICtrlSetState($g_hChkCSVBreakAQ, $GUI_UNCHECKED)
	EndIf
	If $g_hChkCSVBreakBK <> 0 Then
		GUICtrlSetState($g_hChkCSVBreakBK, $bAnyHero ? $GUI_DISABLE : $GUI_ENABLE)
		If $bAnyHero Then GUICtrlSetState($g_hChkCSVBreakBK, $GUI_UNCHECKED)
	EndIf
	CSVSettings_MarkDirty()
EndFunc   ;==>CSVWaitComboToggle

; Side-effect: io (file read + GUI state updates)
Func AttackCSVSettings_LoadFromCSV($iMode)
	Local $sScript = AttackCSVSettings_GetScriptName($iMode)
	If $sScript = "" Then
		SetLog("Attack CSV settings: no script selected.", $COLOR_ERROR)
		Return
	EndIf
	Local $sPath = $g_sCSVAttacksPath & "\" & $sScript & ".csv"
	Local $aLines = AttackCSVSettings_ReadLines($sPath)
	If @error Then Return

	SetLog("Attack CSV settings load: " & $sScript, $COLOR_INFO)
	$g_sCSVSettingsLastLoad = AttackCSVSettings_FormatTimeStamp()
	$g_sCSVSettingsVersion = AttackCSVSettings_DetectVersion($aLines)
	AttackCSVSettings_UpdateHeader($sScript, $sPath, $g_sCSVSettingsLastLoad, $g_sCSVSettingsVersion)

	Local $iTHCol = AttackCSVSettings_GetTHColumnIndex()
	Local $iTHStart = 3
	Local $iTHEnd = 15

	; defaults to avoid stale values when switching scripts
	For $i = 0 To UBound($g_ahCSVSideWeightInputs) - 1
		If $g_ahCSVSideWeightInputs[$i] <> 0 Then GUICtrlSetData($g_ahCSVSideWeightInputs[$i], "0")
	Next
	For $i = 0 To UBound($g_ahCSVSideBWeightInputs) - 1
		If $g_ahCSVSideBWeightInputs[$i] <> 0 Then GUICtrlSetData($g_ahCSVSideBWeightInputs[$i], "0")
	Next
	If $g_hCmbCSVForceSide <> 0 Then _GUICtrlComboBox_SetCurSel($g_hCmbCSVForceSide, 0)

	GUICtrlSetData($g_hInpCSVIndexMin, "1")
	GUICtrlSetData($g_hInpCSVIndexMax, "10")
	GUICtrlSetData($g_hInpCSVQtyMin, "1")
	GUICtrlSetData($g_hInpCSVQtyMax, "5")
	GUICtrlSetData($g_hInpCSVDelayPointMin, "0")
	GUICtrlSetData($g_hInpCSVDelayPointMax, "0")
	GUICtrlSetData($g_hInpCSVDelayDropMin, "0")
	GUICtrlSetData($g_hInpCSVDelayDropMax, "0")
	GUICtrlSetData($g_hInpCSVDelaySleepMin, "0")
	GUICtrlSetData($g_hInpCSVDelaySleepMax, "0")
	GUICtrlSetState($g_hChkCSVDropRemaining, $GUI_UNCHECKED)
	GUICtrlSetState($g_hChkCSVDropIncludeHeroes, $GUI_UNCHECKED)
	GUICtrlSetState($g_hChkCSVDropIncludeSpells, $GUI_UNCHECKED)
	CSVRemainToggle()

	GUICtrlSetData($g_hInpCSVWaitMin, "0")
	GUICtrlSetData($g_hInpCSVWaitMax, "0")
	GUICtrlSetState($g_hChkCSVBreakTH, $GUI_UNCHECKED)
	GUICtrlSetState($g_hChkCSVBreakSiege, $GUI_UNCHECKED)
	GUICtrlSetState($g_hChkCSVBreak50, $GUI_UNCHECKED)
	GUICtrlSetState($g_hChkCSVBreakAQ, $GUI_UNCHECKED)
	GUICtrlSetState($g_hChkCSVBreakBK, $GUI_UNCHECKED)
	GUICtrlSetState($g_hChkCSVBreakGW, $GUI_UNCHECKED)
	GUICtrlSetState($g_hChkCSVBreakRC, $GUI_UNCHECKED)
	GUICtrlSetState($g_hChkCSVBreakAnyHero, $GUI_UNCHECKED)
	CSVWaitComboToggle()

	If $g_hCmbCSVFlexTroop <> 0 Then _GUICtrlComboBox_SetCurSel($g_hCmbCSVFlexTroop, -1)
	For $i = 0 To UBound($g_ahCSVHeroAbilityMode) - 1
		If $g_ahCSVHeroAbilityMode[$i] <> 0 Then _GUICtrlComboBox_SetCurSel($g_ahCSVHeroAbilityMode[$i], 3)
		If $g_ahCSVHeroAbilityDelay[$i] <> 0 Then GUICtrlSetData($g_ahCSVHeroAbilityDelay[$i], "0")
	Next
	If $g_hCmbCSVRedlinePreset <> 0 Then _GUICtrlComboBox_SetCurSel($g_hCmbCSVRedlinePreset, -1)
	If $g_hCmbCSVDroplinePreset <> 0 Then _GUICtrlComboBox_SetCurSel($g_hCmbCSVDroplinePreset, -1)
	If $g_hTxtCSVCCRequest <> 0 Then GUICtrlSetData($g_hTxtCSVCCRequest, "")

	Local $bFlexFound = False
	Local $bRemainFound = False
	Local $iWaitLineAny = -1
	Local $iWaitLineCond = -1
	Local $sWaitTime = ""
	Local $sWaitCond = ""
	Local $sHeroValues[4] = ["", "", "", ""]
	Local $sRedlineValue = ""
	Local $sDroplineValue = ""
	Local $sCCReqValue = ""

	For $iLine = 0 To UBound($aLines) - 1
		Local $aCols = StringSplit($aLines[$iLine], "|", 2)
		Local $sCmd = AttackCSVSettings_GetCommand($aCols)
		Switch $sCmd
			Case "SIDE"
				For $i = 0 To 6
					Local $sValue = AttackCSVSettings_GetValue($aCols, $i + 1)
					If $g_ahCSVSideWeightInputs[$i] <> 0 Then GUICtrlSetData($g_ahCSVSideWeightInputs[$i], $sValue)
				Next
				Local $sForceSide = AttackCSVSettings_GetValue($aCols, 8)
				If $g_hCmbCSVForceSide <> 0 Then
					Local $iForceIndex = _GUICtrlComboBox_FindStringExact($g_hCmbCSVForceSide, $sForceSide)
					If $iForceIndex = -1 Then
						_GUICtrlComboBox_SetCurSel($g_hCmbCSVForceSide, 0)
					Else
						_GUICtrlComboBox_SetCurSel($g_hCmbCSVForceSide, $iForceIndex)
					EndIf
				EndIf
			Case "SIDEB"
				For $i = 0 To 13
					Local $sValue = AttackCSVSettings_GetValue($aCols, $i + 1)
					If $g_ahCSVSideBWeightInputs[$i] <> 0 Then GUICtrlSetData($g_ahCSVSideBWeightInputs[$i], $sValue)
				Next
			Case "TRAIN"
				Local $sTroop = AttackCSVSettings_GetValue($aCols, 1)
				Local $sFlex = AttackCSVSettings_GetValue($aCols, 2)
				If Not $bFlexFound And $sFlex <> "" And Number($sFlex) > 0 Then
					Local $iIndex = AttackCSVSettings_GetTroopShortIndex($sTroop)
					If $iIndex >= 0 Then
						_GUICtrlComboBox_SetCurSel($g_hCmbCSVFlexTroop, $iIndex)
						$bFlexFound = True
					EndIf
				EndIf
				Local $iHeroIndex = AttackCSVSettings_GetHeroIndex($sTroop)
				If $iHeroIndex >= 0 Then
					Local $sHeroValue = AttackCSVSettings_SelectTHValue($aCols, $iTHCol, $iTHStart, $iTHEnd)
					$sHeroValues[$iHeroIndex] = $sHeroValue
				EndIf
			Case "REDLN"
				$sRedlineValue = AttackCSVSettings_SelectTHValue($aCols, $iTHCol, $iTHStart, $iTHEnd)
			Case "DRPLN"
				$sDroplineValue = AttackCSVSettings_SelectTHValue($aCols, $iTHCol, $iTHStart, $iTHEnd)
			Case "CCREQ"
				$sCCReqValue = AttackCSVSettings_SelectTHValueTrim($aCols, $iTHCol, $iTHStart, $iTHEnd)
			Case "DROP"
				Local $sTroop = AttackCSVSettings_GetValue($aCols, 4)
				Local $bIncludeHeroes = False
				Local $bIncludeSpells = False
				Local $sUnknownFlags = ""
				If AttackCSV_ParseRemainFlags($sTroop, $bIncludeHeroes, $bIncludeSpells, $sUnknownFlags) And Not $bRemainFound Then
					Local $iMin, $iMax
					AttackCSVSettings_ParseRange(AttackCSVSettings_GetValue($aCols, 2), $iMin, $iMax)
					GUICtrlSetData($g_hInpCSVIndexMin, $iMin)
					GUICtrlSetData($g_hInpCSVIndexMax, $iMax)
					AttackCSVSettings_ParseRange(AttackCSVSettings_GetValue($aCols, 3), $iMin, $iMax)
					GUICtrlSetData($g_hInpCSVQtyMin, $iMin)
					GUICtrlSetData($g_hInpCSVQtyMax, $iMax)
					AttackCSVSettings_ParseRange(AttackCSVSettings_GetValue($aCols, 5), $iMin, $iMax)
					GUICtrlSetData($g_hInpCSVDelayPointMin, $iMin)
					GUICtrlSetData($g_hInpCSVDelayPointMax, $iMax)
					AttackCSVSettings_ParseRange(AttackCSVSettings_GetValue($aCols, 6), $iMin, $iMax)
					GUICtrlSetData($g_hInpCSVDelayDropMin, $iMin)
					GUICtrlSetData($g_hInpCSVDelayDropMax, $iMax)
					AttackCSVSettings_ParseRange(AttackCSVSettings_GetValue($aCols, 7), $iMin, $iMax)
					GUICtrlSetData($g_hInpCSVDelaySleepMin, $iMin)
					GUICtrlSetData($g_hInpCSVDelaySleepMax, $iMax)
					GUICtrlSetState($g_hChkCSVDropRemaining, $GUI_CHECKED)
					GUICtrlSetState($g_hChkCSVDropIncludeHeroes, $bIncludeHeroes ? $GUI_CHECKED : $GUI_UNCHECKED)
					GUICtrlSetState($g_hChkCSVDropIncludeSpells, $bIncludeSpells ? $GUI_CHECKED : $GUI_UNCHECKED)
					If $sUnknownFlags <> "" Then SetLog("Attack CSV settings: unknown REMAIN flags [" & $sUnknownFlags & "]", $COLOR_WARNING)
					CSVRemainToggle()
					$bRemainFound = True
				EndIf
			Case "WAIT"
				If $iWaitLineAny = -1 Then $iWaitLineAny = $iLine
				Local $sCond = AttackCSVSettings_GetValue($aCols, 2)
				If $sCond <> "" And $iWaitLineCond = -1 Then
					$iWaitLineCond = $iLine
					$sWaitCond = $sCond
					$sWaitTime = AttackCSVSettings_GetValue($aCols, 1)
				ElseIf $iWaitLineAny = $iLine And $sWaitTime = "" Then
					$sWaitTime = AttackCSVSettings_GetValue($aCols, 1)
					$sWaitCond = $sCond
				EndIf
		EndSwitch
	Next

	If $sWaitTime <> "" Then
		Local $iMin, $iMax
		AttackCSVSettings_ParseRange($sWaitTime, $iMin, $iMax)
		If $iMin > 0 Then GUICtrlSetData($g_hInpCSVWaitMin, $iMin)
		If $iMax > 0 Then GUICtrlSetData($g_hInpCSVWaitMax, $iMax)
	EndIf
	If $sWaitCond <> "" Then AttackCSVSettings_SetWaitCheckboxes($sWaitCond)

	For $i = 0 To UBound($sHeroValues) - 1
		AttackCSVSettings_SetHeroControls($i, $sHeroValues[$i])
	Next

	If $sRedlineValue <> "" Then AttackCSVSettings_SetComboIndex($g_hCmbCSVRedlinePreset, Number($sRedlineValue) - 1)
	If $sDroplineValue <> "" Then AttackCSVSettings_SetComboIndex($g_hCmbCSVDroplinePreset, Number($sDroplineValue) - 1)
	If $sCCReqValue <> "" Then GUICtrlSetData($g_hTxtCSVCCRequest, $sCCReqValue)
	If $g_hCmbCSVRecalcSideOverride <> 0 Then
		Local $sRecalcSide = _CSVNormalizeRecalcSideOverride($g_sCSVRecalcSideOverride, True)
		$g_sCSVRecalcSideOverride = $sRecalcSide
		Local $iRecalcIndex = _GUICtrlComboBox_FindStringExact($g_hCmbCSVRecalcSideOverride, $sRecalcSide)
		If $iRecalcIndex < 0 Then $iRecalcIndex = 0
		_GUICtrlComboBox_SetCurSel($g_hCmbCSVRecalcSideOverride, $iRecalcIndex)
	EndIf
	If $g_hInpCSVRecalcVectors <> 0 Then GUICtrlSetData($g_hInpCSVRecalcVectors, $g_sCSVRecalcVectorTargets)

	AttackCSVSettings_LoadVectorFromLines($aLines)
	CSVSettings_SetDirty(False)
EndFunc   ;==>AttackCSVSettings_LoadFromCSV

; Side-effect: io (file read + GUI state updates)
Func AttackCSVSettings_LoadVectorFromCSV($iMode)
	Local $sScript = AttackCSVSettings_GetScriptName($iMode)
	If $sScript = "" Then Return
	Local $sPath = $g_sCSVAttacksPath & "\" & $sScript & ".csv"
	Local $aLines = AttackCSVSettings_ReadLines($sPath)
	If @error Then Return
	AttackCSVSettings_LoadVectorFromLines($aLines)
EndFunc   ;==>AttackCSVSettings_LoadVectorFromCSV

; Side-effect: io (file read)
Func AttackCSVSettings_SaveVectorToCSV($iMode)
	Local $sScript = AttackCSVSettings_GetScriptName($iMode)
	If $sScript = "" Then Return
	Local $sPath = $g_sCSVAttacksPath & "\" & $sScript & ".csv"
	Local $aLines = AttackCSVSettings_ReadLines($sPath)
	If @error Then Return
	AttackCSVSettings_UpdateMakeLine($aLines)
	CSVSettings_MarkDirty()
EndFunc   ;==>AttackCSVSettings_SaveVectorToCSV

; Side-effect: io (GUI state updates)
Func AttackCSVSettings_LoadVectorFromLines(ByRef $aLines)
	Local $sVector = StringUpper(StringStripWS(GUICtrlRead($g_hCmbCSVVectorId), $STR_STRIPALL))
	If $sVector = "" Then Return

	GUICtrlSetState($g_hChkCSVVectorTargeted, $GUI_UNCHECKED)
	If $g_hCmbCSVVectorSide <> 0 Then _GUICtrlComboBox_SetCurSel($g_hCmbCSVVectorSide, 0)
	If $g_hCmbCSVVectorVersus <> 0 Then _GUICtrlComboBox_SetCurSel($g_hCmbCSVVectorVersus, 0)
	If $g_hCmbCSVTargetBuilding <> 0 Then AttackCSVSettings_SetComboText($g_hCmbCSVTargetBuilding, "TOWNHALL")
	If $g_hInpCSVPointCount <> 0 Then GUICtrlSetData($g_hInpCSVPointCount, "1")
	If $g_hInpCSVOffsetTiles <> 0 Then GUICtrlSetData($g_hInpCSVOffsetTiles, "0")
	If $g_hInpCSVRandomX <> 0 Then GUICtrlSetData($g_hInpCSVRandomX, "0")
	If $g_hInpCSVRandomY <> 0 Then GUICtrlSetData($g_hInpCSVRandomY, "0")

	Local $iFoundLine = -1
	Local $sFoundLine = ""
	For $iLine = 0 To UBound($aLines) - 1
		Local $aCols = StringSplit($aLines[$iLine], "|", 2)
		If AttackCSVSettings_GetCommand($aCols) <> "MAKE" Then ContinueLoop
		Local $sVec = AttackCSVSettings_GetValue($aCols, 1)
		If $sVec <> $sVector Then ContinueLoop

		Local $sSide = AttackCSVSettings_GetValue($aCols, 2)
		Local $sPoints = AttackCSVSettings_GetValue($aCols, 3)
		Local $sOffset = AttackCSVSettings_GetValue($aCols, 4)
		Local $sVersus = AttackCSVSettings_GetValue($aCols, 5)
		Local $sRandX = AttackCSVSettings_GetValue($aCols, 6)
		Local $sRandY = AttackCSVSettings_GetValue($aCols, 7)
		Local $sBuilding = AttackCSVSettings_GetValue($aCols, 8)

		If $sSide <> "" Then AttackCSVSettings_SetComboText($g_hCmbCSVVectorSide, $sSide)
		If $sPoints <> "" Then GUICtrlSetData($g_hInpCSVPointCount, $sPoints)
		If $sOffset <> "" Then GUICtrlSetData($g_hInpCSVOffsetTiles, $sOffset)
		If $sVersus <> "" Then AttackCSVSettings_SetComboText($g_hCmbCSVVectorVersus, $sVersus)
		If $sRandX <> "" Then GUICtrlSetData($g_hInpCSVRandomX, $sRandX)
		If $sRandY <> "" Then GUICtrlSetData($g_hInpCSVRandomY, $sRandY)
		If $sBuilding <> "" Then
			GUICtrlSetState($g_hChkCSVVectorTargeted, $GUI_CHECKED)
			AttackCSVSettings_SetComboText($g_hCmbCSVTargetBuilding, $sBuilding)
		Else
			GUICtrlSetState($g_hChkCSVVectorTargeted, $GUI_UNCHECKED)
		EndIf
		$iFoundLine = $iLine + 1
		$sFoundLine = $aLines[$iLine]
		ExitLoop
	Next
	CSVVectorSyncTargetedState()
	AttackCSVSettings_SetVectorRowInfo($sVector, $iFoundLine, $sFoundLine)
EndFunc   ;==>AttackCSVSettings_LoadVectorFromLines

; Side-effect: io (GUI state updates)
Func AttackCSVSettings_SetVectorRowInfo($sVector, $iLineIndex, $sLine)
	Local $sLabel = "Editing MAKE line: " & $sVector
	If $iLineIndex > 0 Then
		$sLabel &= " (line " & $iLineIndex & ")"
	Else
		$sLabel &= " (not found)"
	EndIf
	If $g_hLblCSVVectorEditInfo <> 0 Then GUICtrlSetData($g_hLblCSVVectorEditInfo, $sLabel)
	If $g_hTxtCSVVectorRow <> 0 Then GUICtrlSetData($g_hTxtCSVVectorRow, $sLine)
EndFunc   ;==>AttackCSVSettings_SetVectorRowInfo

; Side-effect: io (file read/write)
Func AttackCSVSettings_SaveToCSV($iMode)
	Local $sScript = AttackCSVSettings_GetScriptName($iMode)
	If $sScript = "" Then
		SetLog("Attack CSV settings: no script selected.", $COLOR_ERROR)
		Return
	EndIf
	Local $sPath = $g_sCSVAttacksPath & "\" & $sScript & ".csv"
	Local $aLines = AttackCSVSettings_ReadLines($sPath)
	If @error Then Return

	Local $iTHCol = AttackCSVSettings_GetTHColumnIndex()
	Local $iTHStart = 3
	Local $iTHEnd = 15
	Local $bUpdateAllTH = ($iTHCol = 0)

	If $bUpdateAllTH Then
		SetLog("Attack CSV settings: TH column unknown, updating all TH columns.", $COLOR_WARNING)
	EndIf

	Local $iSideLine = -1
	Local $iSideBLine = -1
	Local $iRedlnLine = -1
	Local $iDrplnLine = -1
	Local $iCCReqLine = -1
	Local $iRemainLine = -1
	Local $iWaitLineAny = -1
	Local $iWaitLineCond = -1
	Local $iLastTrainLine = -1
	Local $iLastDropLine = -1
	Local $iFirstMakeLine = -1

	For $iLine = 0 To UBound($aLines) - 1
		Local $aCols = StringSplit($aLines[$iLine], "|", 2)
		Local $sCmd = AttackCSVSettings_GetCommand($aCols)
		Switch $sCmd
			Case "SIDE"
				$iSideLine = $iLine
			Case "SIDEB"
				$iSideBLine = $iLine
			Case "TRAIN"
				$iLastTrainLine = $iLine
			Case "MAKE"
				If $iFirstMakeLine = -1 Then $iFirstMakeLine = $iLine
			Case "DROP"
				$iLastDropLine = $iLine
		EndSwitch
	Next

	; SIDE line
	Local $aSideCols = AttackCSVSettings_GetLineColumns($aLines, $iSideLine)
	If $iSideLine = -1 Then
		Local $sNewSide = AttackCSVSettings_BuildSideLine(False)
		AttackCSVSettings_InsertLine($aLines, ($iFirstMakeLine > -1 ? $iFirstMakeLine : UBound($aLines)), $sNewSide)
		$iSideLine = ($iFirstMakeLine > -1 ? $iFirstMakeLine : UBound($aLines) - 1)
		$aSideCols = StringSplit($sNewSide, "|", 2)
	EndIf
	AttackCSVSettings_UpdateSideLine($aSideCols)
	$aLines[$iSideLine] = AttackCSVSettings_JoinColumns($aSideCols)

	; SIDEB line
	Local $aSideBCols = AttackCSVSettings_GetLineColumns($aLines, $iSideBLine)
	If $iSideBLine = -1 Then
		Local $sNewSideB = AttackCSVSettings_BuildSideLine(True)
		Local $iInsert = ($iSideLine > -1 ? $iSideLine + 1 : ($iFirstMakeLine > -1 ? $iFirstMakeLine : UBound($aLines)))
		AttackCSVSettings_InsertLine($aLines, $iInsert, $sNewSideB)
		$iSideBLine = $iInsert
		$aSideBCols = StringSplit($sNewSideB, "|", 2)
	EndIf
	AttackCSVSettings_UpdateSideBLine($aSideBCols)
	$aLines[$iSideBLine] = AttackCSVSettings_JoinColumns($aSideBCols)

	AttackCSVSettings_ScanAnchors($aLines, $iRedlnLine, $iDrplnLine, $iCCReqLine, $iRemainLine, $iWaitLineAny, $iWaitLineCond, _
		$iLastTrainLine, $iLastDropLine, $iFirstMakeLine)

	; REDLN/DRPLN/CCREQ
	AttackCSVSettings_UpdateSettingsLine($aLines, $iRedlnLine, "REDLN", $iLastTrainLine, $iTHCol, $iTHStart, $iTHEnd, $bUpdateAllTH, _
		AttackCSVSettings_BuildPresetValue($g_hCmbCSVRedlinePreset))
	AttackCSVSettings_UpdateSettingsLine($aLines, $iDrplnLine, "DRPLN", $iLastTrainLine, $iTHCol, $iTHStart, $iTHEnd, $bUpdateAllTH, _
		AttackCSVSettings_BuildPresetValue($g_hCmbCSVDroplinePreset))
	AttackCSVSettings_UpdateSettingsLine($aLines, $iCCReqLine, "CCREQ", $iLastTrainLine, $iTHCol, $iTHStart, $iTHEnd, $bUpdateAllTH, _
		StringStripWS(GUICtrlRead($g_hTxtCSVCCRequest), BitOR($STR_STRIPLEADING, $STR_STRIPTRAILING)), True)

	AttackCSVSettings_ScanAnchors($aLines, $iRedlnLine, $iDrplnLine, $iCCReqLine, $iRemainLine, $iWaitLineAny, $iWaitLineCond, _
		$iLastTrainLine, $iLastDropLine, $iFirstMakeLine)

	; TRAIN lines (flex + hero ability)
	AttackCSVSettings_UpdateTrainLines($aLines, $iTHCol, $iTHStart, $iTHEnd, $bUpdateAllTH)

	; MAKE line for selected vector
	AttackCSVSettings_UpdateMakeLine($aLines)

	AttackCSVSettings_ScanAnchors($aLines, $iRedlnLine, $iDrplnLine, $iCCReqLine, $iRemainLine, $iWaitLineAny, $iWaitLineCond, _
		$iLastTrainLine, $iLastDropLine, $iFirstMakeLine)

	; DROP remain line
	AttackCSVSettings_UpdateDropRemainLine($aLines, $iRemainLine, $iLastDropLine, $iFirstMakeLine)

	; WAIT line
	AttackCSVSettings_UpdateWaitLine($aLines, $iWaitLineAny, $iWaitLineCond, $iLastDropLine, $iFirstMakeLine)

	AttackCSVSettings_WriteLines($sPath, $aLines)
	SetLog("Attack CSV settings saved: " & $sScript, $COLOR_INFO)
	CSVSettings_SetDirty(False)
EndFunc   ;==>AttackCSVSettings_SaveToCSV

; Side-effect: io (GUI state reads)
Func AttackCSVSettings_GetScriptName($iMode)
	Local $hCombo = ($iMode = $RankedBattle ? $g_hCmbScriptNameRankedBattle : $g_hCmbScriptNameBattle)
	If $hCombo = 0 Then Return ""
	Local $aTemp = _GUICtrlComboBox_GetListArray($hCombo)
	Local $iSel = _GUICtrlComboBox_GetCurSel($hCombo)
	If $iSel < 0 Then Return ""
	If UBound($aTemp) <= ($iSel + 1) Then Return ""
	Return $aTemp[$iSel + 1]
EndFunc   ;==>AttackCSVSettings_GetScriptName





; Side-effect: io (file write)
Func AttackCSVSettings_WriteLines($sPath, ByRef $aLines)
	Local $hFile = FileOpen($sPath, $FO_OVERWRITE)
	If $hFile = -1 Then
		SetLog("Attack CSV settings: failed writing " & $sPath, $COLOR_ERROR)
		Return
	EndIf
	For $i = 0 To UBound($aLines) - 1
		FileWrite($hFile, $aLines[$i] & @CRLF)
	Next
	FileClose($hFile)
EndFunc   ;==>AttackCSVSettings_WriteLines

; Side-effect: pure (string parsing)
Func AttackCSVSettings_GetCommand(ByRef $aCols)
	If UBound($aCols) = 0 Then Return ""
	Return StringStripWS(StringUpper($aCols[0]), $STR_STRIPALL)
EndFunc   ;==>AttackCSVSettings_GetCommand

; Side-effect: pure (string parsing)
Func AttackCSVSettings_GetValue(ByRef $aCols, $iIndex)
	If UBound($aCols) <= $iIndex Then Return ""
	Return StringStripWS($aCols[$iIndex], $STR_STRIPALL)
EndFunc   ;==>AttackCSVSettings_GetValue

; Side-effect: pure (string parsing)
Func AttackCSVSettings_GetValueTrim(ByRef $aCols, $iIndex)
	If UBound($aCols) <= $iIndex Then Return ""
	Return StringStripWS($aCols[$iIndex], BitOR($STR_STRIPLEADING, $STR_STRIPTRAILING))
EndFunc   ;==>AttackCSVSettings_GetValueTrim

; Side-effect: pure (string parsing)
Func AttackCSVSettings_SelectTHValue(ByRef $aCols, $iTHCol, $iTHStart, $iTHEnd)
	If $iTHCol > 0 And UBound($aCols) > $iTHCol Then
		Local $sValue = AttackCSVSettings_GetValue($aCols, $iTHCol)
		If $sValue <> "" Then Return $sValue
	EndIf
	For $i = $iTHEnd To $iTHStart Step -1
		Local $sValue = AttackCSVSettings_GetValue($aCols, $i)
		If $sValue <> "" Then Return $sValue
	Next
	Return ""
EndFunc   ;==>AttackCSVSettings_SelectTHValue

; Side-effect: pure (string parsing)
Func AttackCSVSettings_SelectTHValueTrim(ByRef $aCols, $iTHCol, $iTHStart, $iTHEnd)
	If $iTHCol > 0 And UBound($aCols) > $iTHCol Then
		Local $sValue = AttackCSVSettings_GetValueTrim($aCols, $iTHCol)
		If $sValue <> "" Then Return $sValue
	EndIf
	For $i = $iTHEnd To $iTHStart Step -1
		Local $sValue = AttackCSVSettings_GetValueTrim($aCols, $i)
		If $sValue <> "" Then Return $sValue
	Next
	Return ""
EndFunc   ;==>AttackCSVSettings_SelectTHValueTrim

; Side-effect: pure (array formatting)
Func AttackCSVSettings_EnsureColumns(ByRef $aCols, $iCount)
	If UBound($aCols) >= $iCount Then Return
	Local $iOld = UBound($aCols)
	ReDim $aCols[$iCount]
	For $i = $iOld To $iCount - 1
		$aCols[$i] = " "
	Next
EndFunc   ;==>AttackCSVSettings_EnsureColumns

; Side-effect: pure (array formatting)
Func AttackCSVSettings_SetColumn(ByRef $aCols, $iIndex, $sValue)
	AttackCSVSettings_EnsureColumns($aCols, $iIndex + 1)
	Local $sOld = $aCols[$iIndex]
	Local $sTrim = StringStripWS($sOld, $STR_STRIPALL)
	If $sTrim = "" Then
		$aCols[$iIndex] = " " & $sValue & " "
		Return
	EndIf
	Local $iStart = StringInStr($sOld, $sTrim, 0, 1)
	If $iStart <= 0 Then
		$aCols[$iIndex] = " " & $sValue & " "
		Return
	EndIf
	Local $sPrefix = StringLeft($sOld, $iStart - 1)
	Local $sSuffix = StringMid($sOld, $iStart + StringLen($sTrim))
	$aCols[$iIndex] = $sPrefix & $sValue & $sSuffix
EndFunc   ;==>AttackCSVSettings_SetColumn

; Side-effect: pure (array formatting)
Func AttackCSVSettings_JoinColumns(ByRef $aCols)
	Local $sLine = ""
	For $i = 0 To UBound($aCols) - 1
		$sLine &= $aCols[$i]
		If $i < UBound($aCols) - 1 Then $sLine &= "|"
	Next
	Return $sLine
EndFunc   ;==>AttackCSVSettings_JoinColumns

; Side-effect: pure (value parsing)
Func AttackCSVSettings_ParseRange($sValue, ByRef $iMin, ByRef $iMax)
	$iMin = 0
	$iMax = 0
	Local $sClean = StringStripWS($sValue, $STR_STRIPALL)
	If $sClean = "" Then Return
	If StringInStr($sClean, "-") Then
		Local $aParts = StringSplit($sClean, "-", 2)
		If UBound($aParts) >= 2 Then
			$iMin = Number($aParts[0])
			$iMax = Number($aParts[1])
		EndIf
	ElseIf StringInStr($sClean, ",") Then
		Local $aParts = StringSplit($sClean, ",", 2)
		$iMin = 999999
		For $i = 0 To UBound($aParts) - 1
			Local $iVal = Number($aParts[$i])
			If $iVal < $iMin Then $iMin = $iVal
			If $iVal > $iMax Then $iMax = $iVal
		Next
		If $iMin = 999999 Then $iMin = 0
	Else
		$iMin = Number($sClean)
		$iMax = $iMin
	EndIf
	If $iMin < 0 Then $iMin = 0
	If $iMax < 0 Then $iMax = 0
EndFunc   ;==>AttackCSVSettings_ParseRange

; Side-effect: pure (value formatting)
Func AttackCSVSettings_BuildRange($iMin, $iMax)
	If $iMin <= 0 And $iMax <= 0 Then Return ""
	If $iMin <= 0 Then $iMin = $iMax
	If $iMax <= 0 Then $iMax = $iMin
	If $iMin > $iMax Then
		Local $iSwap = $iMin
		$iMin = $iMax
		$iMax = $iSwap
	EndIf
	If $iMin = $iMax Then Return String($iMin)
	Return $iMin & "-" & $iMax
EndFunc   ;==>AttackCSVSettings_BuildRange

; Side-effect: io (GUI state reads)
Func AttackCSVSettings_BuildRemainTroopName($sExisting)
	Local $bIncludeHeroes = False
	Local $bIncludeSpells = False
	If $g_hChkCSVDropIncludeHeroes <> 0 Then $bIncludeHeroes = (GUICtrlRead($g_hChkCSVDropIncludeHeroes) = $GUI_CHECKED)
	If $g_hChkCSVDropIncludeSpells <> 0 Then $bIncludeSpells = (GUICtrlRead($g_hChkCSVDropIncludeSpells) = $GUI_CHECKED)

	Local $sTarget = "REMAIN"
	If $bIncludeHeroes And $bIncludeSpells Then
		$sTarget &= "+HERO+SPELL"
	ElseIf $bIncludeHeroes Then
		$sTarget &= "+HERO"
	ElseIf $bIncludeSpells Then
		$sTarget &= "+SPELL"
	EndIf

	If $sExisting = "" Then Return $sTarget

	Local $bExistingHeroes = False
	Local $bExistingSpells = False
	Local $sUnknownFlags = ""
	If AttackCSV_ParseRemainFlags($sExisting, $bExistingHeroes, $bExistingSpells, $sUnknownFlags) Then
		If $bExistingHeroes = $bIncludeHeroes And $bExistingSpells = $bIncludeSpells Then Return $sExisting
	EndIf
	Return $sTarget
EndFunc   ;==>AttackCSVSettings_BuildRemainTroopName

; Side-effect: io (GUI state updates)
Func AttackCSVSettings_SetWaitCheckboxes($sCond)
	Local $aParams = StringSplit($sCond, ",", $STR_NOCOUNT)
	Local $bAnyHeroCombo = False
	For $i = 0 To UBound($aParams) - 1
		Local $sParam = StringUpper(StringStripWS($aParams[$i], $STR_STRIPALL))
		Switch $sParam
			Case "TH"
				GUICtrlSetState($g_hChkCSVBreakTH, $GUI_CHECKED)
			Case "SIEGE"
				GUICtrlSetState($g_hChkCSVBreakSiege, $GUI_CHECKED)
			Case "TH+SIEGE", "SIEGE+TH"
				GUICtrlSetState($g_hChkCSVBreakTH, $GUI_CHECKED)
				GUICtrlSetState($g_hChkCSVBreakSiege, $GUI_CHECKED)
			Case "50%"
				GUICtrlSetState($g_hChkCSVBreak50, $GUI_CHECKED)
			Case "AQ"
				GUICtrlSetState($g_hChkCSVBreakAQ, $GUI_CHECKED)
			Case "BK"
				GUICtrlSetState($g_hChkCSVBreakBK, $GUI_CHECKED)
			Case "GW"
				GUICtrlSetState($g_hChkCSVBreakGW, $GUI_CHECKED)
			Case "RC"
				GUICtrlSetState($g_hChkCSVBreakRC, $GUI_CHECKED)
			Case "AQ+BK", "BK+AQ"
				$bAnyHeroCombo = True
		EndSwitch
	Next
	If $bAnyHeroCombo Then GUICtrlSetState($g_hChkCSVBreakAnyHero, $GUI_CHECKED)
	CSVWaitComboToggle()
EndFunc   ;==>AttackCSVSettings_SetWaitCheckboxes

; Side-effect: pure (GUI state reads)
Func AttackCSVSettings_BuildWaitConditions()
	Local $sCond = ""
	If GUICtrlRead($g_hChkCSVBreakTH) = $GUI_CHECKED Then $sCond &= "TH,"
	If GUICtrlRead($g_hChkCSVBreakSiege) = $GUI_CHECKED Then $sCond &= "SIEGE,"
	If GUICtrlRead($g_hChkCSVBreak50) = $GUI_CHECKED Then $sCond &= "50%,"
	If GUICtrlRead($g_hChkCSVBreakAnyHero) = $GUI_CHECKED Then
		$sCond &= "AQ+BK,"
	Else
		If GUICtrlRead($g_hChkCSVBreakAQ) = $GUI_CHECKED Then $sCond &= "AQ,"
		If GUICtrlRead($g_hChkCSVBreakBK) = $GUI_CHECKED Then $sCond &= "BK,"
	EndIf
	If GUICtrlRead($g_hChkCSVBreakGW) = $GUI_CHECKED Then $sCond &= "GW,"
	If GUICtrlRead($g_hChkCSVBreakRC) = $GUI_CHECKED Then $sCond &= "RC,"
	If StringRight($sCond, 1) = "," Then $sCond = StringTrimRight($sCond, 1)
	Return $sCond
EndFunc   ;==>AttackCSVSettings_BuildWaitConditions

; Side-effect: pure (formatting)
Func AttackCSVSettings_FormatTimeStamp()
	Return StringFormat("%04d-%02d-%02d %02d:%02d:%02d", @YEAR, @MON, @MDAY, @HOUR, @MIN, @SEC)
EndFunc   ;==>AttackCSVSettings_FormatTimeStamp

; Side-effect: pure (version parsing)
Func AttackCSVSettings_DetectVersion(ByRef $aLines)
	Local $sVersion = ""
	For $i = 0 To UBound($aLines) - 1
		Local $aCols = StringSplit($aLines[$i], "|", 2)
		If AttackCSVSettings_GetCommand($aCols) <> "NOTE" Then ContinueLoop
		Local $sKey = StringUpper(AttackCSVSettings_GetValueTrim($aCols, 1))
		If $sKey = "CSV_VERSION" Then
			Local $sVal = AttackCSVSettings_GetValueTrim($aCols, 2)
			$sVersion = AttackCSVSettings_NormalizeVersion($sVal)
			ExitLoop
		EndIf
		Local $sNote = AttackCSVSettings_GetValueTrim($aCols, 1)
		For $j = 2 To UBound($aCols) - 1
			Local $sPart = AttackCSVSettings_GetValueTrim($aCols, $j)
			If $sPart <> "" Then $sNote &= " " & $sPart
		Next
		Local $aMatch = StringRegExp($sNote, "(?i)v\\d+(?:\\.\\d+)?", 1)
		If IsArray($aMatch) Then
			$sVersion = AttackCSVSettings_NormalizeVersion($aMatch[0])
			ExitLoop
		EndIf
	Next
	If $sVersion = "" Then Return "unknown"
	Return $sVersion
EndFunc   ;==>AttackCSVSettings_DetectVersion

; Side-effect: pure (version formatting)
Func AttackCSVSettings_NormalizeVersion($sVersion)
	Local $sVal = StringStripWS($sVersion, $STR_STRIPALL)
	If $sVal = "" Then Return ""
	If StringLeft($sVal, 1) = "V" Or StringLeft($sVal, 1) = "v" Then
		$sVal = StringTrimLeft($sVal, 1)
	EndIf
	Return "v" & $sVal
EndFunc   ;==>AttackCSVSettings_NormalizeVersion

; Side-effect: pure (validation)
Func AttackCSVSettings_IsNumericValue($sValue)
	Local $sTrim = StringStripWS($sValue, $STR_STRIPALL)
	If $sTrim = "" Then Return False
	If Not StringIsInt($sTrim) Then Return False
	If Number($sTrim) < 0 Then Return False
	Return True
EndFunc   ;==>AttackCSVSettings_IsNumericValue

; Side-effect: pure (validation)
Func AttackCSVSettings_IsRangeValue($sValue)
	Local $sTrim = StringStripWS($sValue, $STR_STRIPALL)
	If $sTrim = "" Then Return False
	If StringRegExp($sTrim, "^\d+$") Then Return True
	If StringRegExp($sTrim, "^\d+\-\d+$") Then Return True
	If StringRegExp($sTrim, "^\d+(,\d+)+$") Then Return True
	Return False
EndFunc   ;==>AttackCSVSettings_IsRangeValue

; Side-effect: pure (validation)
Func AttackCSVSettings_ValidateWaitConditions($sCond, ByRef $sUnknown)
	$sUnknown = ""
	Local $aParts = StringSplit($sCond, ",", $STR_NOCOUNT)
	For $i = 0 To UBound($aParts) - 1
		Local $sPart = StringUpper(StringStripWS($aParts[$i], $STR_STRIPALL))
		If $sPart = "" Then ContinueLoop
		Switch $sPart
			Case "TH", "SIEGE", "TH+SIEGE", "SIEGE+TH", "50%", "AQ", "BK", "GW", "RC", "AQ+BK", "BK+AQ"
			Case Else
				$sUnknown &= ($sUnknown = "" ? "" : ",") & $sPart
		EndSwitch
	Next
	Return ($sUnknown = "")
EndFunc   ;==>AttackCSVSettings_ValidateWaitConditions

; Side-effect: pure (state derivation)
Func AttackCSVSettings_GetTHColumnIndex()
	If $g_iTownHallLevel >= 6 And $g_iTownHallLevel <= 18 Then Return 3 + ($g_iTownHallLevel - 6)
	If $g_iTotalCampSpace = 0 Then Return 0
	If $g_iTotalSpellValue = 0 Then Return 0

	Local $iTH = 0
	Switch $g_iTotalCampSpace
		Case $g_iMaxCapTroopTH[16] + 5 To $g_iMaxCapTroopTH[17]
			$iTH = 17
		Case $g_iMaxCapTroopTH[14] + 5 To $g_iMaxCapTroopTH[15]
			$iTH = 15
		Case $g_iMaxCapTroopTH[12] + 5 To $g_iMaxCapTroopTH[13]
			$iTH = 13
		Case $g_iMaxCapTroopTH[11] + 5 To $g_iMaxCapTroopTH[12]
			$iTH = 12
		Case $g_iMaxCapTroopTH[10] + 5 To $g_iMaxCapTroopTH[11]
			$iTH = 11
		Case $g_iMaxCapTroopTH[9] + 5 To $g_iMaxCapTroopTH[10]
			$iTH = 10
		Case $g_iMaxCapTroopTH[8] + 5 To $g_iMaxCapTroopTH[9]
			$iTH = 9
		Case $g_iMaxCapTroopTH[6] + 5 To $g_iMaxCapTroopTH[8]
			Switch $g_iTotalSpellValue
				Case $g_iMaxCapSpellTH[7] + 1 To $g_iMaxCapSpellTH[8]
					$iTH = 8
				Case $g_iMaxCapSpellTH[6] + 1 To $g_iMaxCapSpellTH[7]
					$iTH = 7
			EndSwitch
		Case $g_iMaxCapTroopTH[5] + 5 To $g_iMaxCapTroopTH[6]
			$iTH = 6
	EndSwitch

	If $iTH = 0 Then Return 0
	Return 3 + ($iTH - 6)
EndFunc   ;==>AttackCSVSettings_GetTHColumnIndex

; Side-effect: pure (array lookup)
Func AttackCSVSettings_GetLineColumns(ByRef $aLines, $iIndex)
	If $iIndex < 0 Or $iIndex >= UBound($aLines) Then
		Local $aEmpty[1] = [""]
		Return $aEmpty
	EndIf
	Return StringSplit($aLines[$iIndex], "|", 2)
EndFunc   ;==>AttackCSVSettings_GetLineColumns

; Side-effect: pure (array edit)
Func AttackCSVSettings_InsertLine(ByRef $aLines, $iIndex, $sLine)
	Local $iLen = UBound($aLines)
	If $iIndex < 0 Then $iIndex = 0
	If $iIndex > $iLen Then $iIndex = $iLen
	ReDim $aLines[$iLen + 1]
	For $i = $iLen To $iIndex + 1 Step -1
		$aLines[$i] = $aLines[$i - 1]
	Next
	$aLines[$iIndex] = $sLine
EndFunc   ;==>AttackCSVSettings_InsertLine

; Side-effect: pure (array scan)
Func AttackCSVSettings_ScanAnchors(ByRef $aLines, ByRef $iRedlnLine, ByRef $iDrplnLine, ByRef $iCCReqLine, ByRef $iRemainLine, _
		ByRef $iWaitLineAny, ByRef $iWaitLineCond, ByRef $iLastTrainLine, ByRef $iLastDropLine, ByRef $iFirstMakeLine)
	$iRedlnLine = -1
	$iDrplnLine = -1
	$iCCReqLine = -1
	$iRemainLine = -1
	$iWaitLineAny = -1
	$iWaitLineCond = -1
	$iLastTrainLine = -1
	$iLastDropLine = -1
	$iFirstMakeLine = -1

	For $iLine = 0 To UBound($aLines) - 1
		Local $aCols = StringSplit($aLines[$iLine], "|", 2)
		Local $sCmd = AttackCSVSettings_GetCommand($aCols)
		Switch $sCmd
			Case "REDLN"
				$iRedlnLine = $iLine
			Case "DRPLN"
				$iDrplnLine = $iLine
			Case "CCREQ"
				$iCCReqLine = $iLine
			Case "TRAIN"
				$iLastTrainLine = $iLine
			Case "MAKE"
				If $iFirstMakeLine = -1 Then $iFirstMakeLine = $iLine
			Case "DROP"
				$iLastDropLine = $iLine
				Local $sTroop = AttackCSVSettings_GetValue($aCols, 4)
				If $iRemainLine = -1 Then
					Local $bIncludeHeroes = False
					Local $bIncludeSpells = False
					Local $sUnknownFlags = ""
					If AttackCSV_ParseRemainFlags($sTroop, $bIncludeHeroes, $bIncludeSpells, $sUnknownFlags) Then $iRemainLine = $iLine
				EndIf
			Case "WAIT"
				If $iWaitLineAny = -1 Then $iWaitLineAny = $iLine
				If $iWaitLineCond = -1 And AttackCSVSettings_GetValue($aCols, 2) <> "" Then $iWaitLineCond = $iLine
		EndSwitch
	Next
EndFunc   ;==>AttackCSVSettings_ScanAnchors

; Side-effect: io (GUI state reads)
Func AttackCSVSettings_BuildSideLine($bSideB)
	Local $sLine = ($bSideB ? "SIDEB" : "SIDE")
	Local $iCount = ($bSideB ? 14 : 7)
	For $i = 0 To $iCount - 1
		$sLine &= " |0"
	Next
	$sLine &= "|"
	Return $sLine
EndFunc   ;==>AttackCSVSettings_BuildSideLine

; Side-effect: io (GUI state reads)
Func AttackCSVSettings_UpdateSideLine(ByRef $aCols)
	AttackCSVSettings_EnsureColumns($aCols, 9)
	For $i = 0 To 6
		Local $sVal = StringStripWS(GUICtrlRead($g_ahCSVSideWeightInputs[$i]), $STR_STRIPALL)
		If $sVal = "" Then $sVal = "0"
		AttackCSVSettings_SetColumn($aCols, $i + 1, $sVal)
	Next
	Local $sForce = ""
	Local $iForceSel = _GUICtrlComboBox_GetCurSel($g_hCmbCSVForceSide)
	If $iForceSel > 0 Then $sForce = StringStripWS(GUICtrlRead($g_hCmbCSVForceSide), $STR_STRIPALL)
	AttackCSVSettings_SetColumn($aCols, 8, $sForce)
EndFunc   ;==>AttackCSVSettings_UpdateSideLine

; Side-effect: io (GUI state reads)
Func AttackCSVSettings_UpdateSideBLine(ByRef $aCols)
	AttackCSVSettings_EnsureColumns($aCols, 15)
	For $i = 0 To 13
		Local $sVal = StringStripWS(GUICtrlRead($g_ahCSVSideBWeightInputs[$i]), $STR_STRIPALL)
		If $sVal = "" Then $sVal = "0"
		AttackCSVSettings_SetColumn($aCols, $i + 1, $sVal)
	Next
EndFunc   ;==>AttackCSVSettings_UpdateSideBLine

; Side-effect: io (GUI state reads)
Func AttackCSVSettings_UpdateSettingsLine(ByRef $aLines, ByRef $iLineIndex, $sCmd, $iLastTrainLine, $iTHCol, $iTHStart, $iTHEnd, $bUpdateAllTH, $sValue, $bAllowBlank = False)
	If $sValue = "" And Not $bAllowBlank Then Return
	If $iLineIndex = -1 Then
		If $sValue = "" And $bAllowBlank Then Return
		Local $sLine = $sCmd
		For $i = 0 To $iTHEnd
			$sLine &= " |"
		Next
		AttackCSVSettings_InsertLine($aLines, $iLastTrainLine + 1, $sLine)
		$iLineIndex = $iLastTrainLine + 1
	EndIf
	Local $aCols = StringSplit($aLines[$iLineIndex], "|", 2)
	If $bUpdateAllTH Then
		For $i = $iTHStart To $iTHEnd
			AttackCSVSettings_SetColumn($aCols, $i, $sValue)
		Next
	Else
		AttackCSVSettings_SetColumn($aCols, $iTHCol, $sValue)
	EndIf
	$aLines[$iLineIndex] = AttackCSVSettings_JoinColumns($aCols)
EndFunc   ;==>AttackCSVSettings_UpdateSettingsLine

; Side-effect: io (GUI state reads)
Func AttackCSVSettings_BuildPresetValue($hCombo)
	Local $iIndex = _GUICtrlComboBox_GetCurSel($hCombo)
	If $iIndex < 0 Then Return ""
	Return String($iIndex + 1)
EndFunc   ;==>AttackCSVSettings_BuildPresetValue

; Side-effect: io (CSV edits)
Func AttackCSVSettings_UpdateTrainLines(ByRef $aLines, $iTHCol, $iTHStart, $iTHEnd, $bUpdateAllTH)
	Local $iFlexIndex = _GUICtrlComboBox_GetCurSel($g_hCmbCSVFlexTroop)
	Local $sFlexShort = ""
	If $iFlexIndex >= 0 And $iFlexIndex < UBound($g_asTroopShortNames) Then $sFlexShort = $g_asTroopShortNames[$iFlexIndex]

	Local $aHeroModes[4]
	Local $aHeroDelays[4]
	For $i = 0 To 3
		$aHeroModes[$i] = _GUICtrlComboBox_GetCurSel($g_ahCSVHeroAbilityMode[$i])
		$aHeroDelays[$i] = Number(GUICtrlRead($g_ahCSVHeroAbilityDelay[$i]))
	Next

	For $iLine = 0 To UBound($aLines) - 1
		Local $aCols = StringSplit($aLines[$iLine], "|", 2)
		If AttackCSVSettings_GetCommand($aCols) <> "TRAIN" Then ContinueLoop
		Local $sTroop = AttackCSVSettings_GetValue($aCols, 1)
		Local $iTroopIndex = AttackCSVSettings_GetTroopShortIndex($sTroop)
		If $iTroopIndex >= 0 And $sFlexShort <> "" Then
			Local $sFlexVal = (StringUpper($sTroop) = StringUpper($sFlexShort)) ? "1" : "0"
			AttackCSVSettings_SetColumn($aCols, 2, $sFlexVal)
		EndIf

		Local $iHeroIndex = AttackCSVSettings_GetHeroIndex($sTroop)
		If $iHeroIndex >= 0 Then
			Local $iMode = $aHeroModes[$iHeroIndex]
			If $iMode >= 0 And $iMode <= 2 Then
				Local $sHeroValue = String($iMode + 1) & ($aHeroDelays[$iHeroIndex] > 0 ? String($aHeroDelays[$iHeroIndex]) : "")
				If $bUpdateAllTH Then
					For $i = $iTHStart To $iTHEnd
						AttackCSVSettings_SetColumn($aCols, $i, $sHeroValue)
					Next
				Else
					AttackCSVSettings_SetColumn($aCols, $iTHCol, $sHeroValue)
				EndIf
			EndIf
		EndIf
		$aLines[$iLine] = AttackCSVSettings_JoinColumns($aCols)
	Next
EndFunc   ;==>AttackCSVSettings_UpdateTrainLines

; Side-effect: io (GUI state reads)
Func AttackCSVSettings_UpdateMakeLine(ByRef $aLines)
	Local $sVector = StringUpper(StringStripWS(GUICtrlRead($g_hCmbCSVVectorId), $STR_STRIPALL))
	If $sVector = "" Then Return

	Local $sSide = StringUpper(StringStripWS(GUICtrlRead($g_hCmbCSVVectorSide), $STR_STRIPALL))
	Local $sPoints = StringStripWS(GUICtrlRead($g_hInpCSVPointCount), $STR_STRIPALL)
	Local $sOffset = StringStripWS(GUICtrlRead($g_hInpCSVOffsetTiles), $STR_STRIPALL)
	Local $sVersus = StringUpper(StringStripWS(GUICtrlRead($g_hCmbCSVVectorVersus), $STR_STRIPALL))
	Local $sRandX = StringStripWS(GUICtrlRead($g_hInpCSVRandomX), $STR_STRIPALL)
	Local $sRandY = StringStripWS(GUICtrlRead($g_hInpCSVRandomY), $STR_STRIPALL)
	Local $bTargeted = (GUICtrlRead($g_hChkCSVVectorTargeted) = $GUI_CHECKED)
	Local $sBuilding = StringUpper(StringStripWS(GUICtrlRead($g_hCmbCSVTargetBuilding), $STR_STRIPALL))

	Local $iFoundLine = -1
	Local $sUpdatedLine = ""
	For $iLine = 0 To UBound($aLines) - 1
		Local $aCols = StringSplit($aLines[$iLine], "|", 2)
		If AttackCSVSettings_GetCommand($aCols) <> "MAKE" Then ContinueLoop
		If AttackCSVSettings_GetValue($aCols, 1) <> $sVector Then ContinueLoop

		If $sSide <> "" Then AttackCSVSettings_SetColumn($aCols, 2, $sSide)
		If $sPoints <> "" Then AttackCSVSettings_SetColumn($aCols, 3, $sPoints)
		If $sOffset <> "" Then AttackCSVSettings_SetColumn($aCols, 4, $sOffset)
		If $sVersus <> "" Then AttackCSVSettings_SetColumn($aCols, 5, $sVersus)
		If $sRandX <> "" Then AttackCSVSettings_SetColumn($aCols, 6, $sRandX)
		If $sRandY <> "" Then AttackCSVSettings_SetColumn($aCols, 7, $sRandY)
		If $bTargeted Then
			AttackCSVSettings_SetColumn($aCols, 8, $sBuilding)
		Else
			AttackCSVSettings_SetColumn($aCols, 8, "")
		EndIf

		$sUpdatedLine = AttackCSVSettings_JoinColumns($aCols)
		$aLines[$iLine] = $sUpdatedLine
		$iFoundLine = $iLine + 1
		ExitLoop
	Next
	AttackCSVSettings_SetVectorRowInfo($sVector, $iFoundLine, $sUpdatedLine)
EndFunc   ;==>AttackCSVSettings_UpdateMakeLine

; Side-effect: io (GUI state reads)
Func AttackCSVSettings_UpdateDropRemainLine(ByRef $aLines, $iRemainLine, $iLastDropLine, $iFirstMakeLine)
	If GUICtrlRead($g_hChkCSVDropRemaining) <> $GUI_CHECKED Then Return
	Local $iIndexMin = Number(GUICtrlRead($g_hInpCSVIndexMin))
	Local $iIndexMax = Number(GUICtrlRead($g_hInpCSVIndexMax))
	Local $iQtyMin = Number(GUICtrlRead($g_hInpCSVQtyMin))
	Local $iQtyMax = Number(GUICtrlRead($g_hInpCSVQtyMax))
	Local $iDelayPointMin = Number(GUICtrlRead($g_hInpCSVDelayPointMin))
	Local $iDelayPointMax = Number(GUICtrlRead($g_hInpCSVDelayPointMax))
	Local $iDelayDropMin = Number(GUICtrlRead($g_hInpCSVDelayDropMin))
	Local $iDelayDropMax = Number(GUICtrlRead($g_hInpCSVDelayDropMax))
	Local $iSleepMin = Number(GUICtrlRead($g_hInpCSVDelaySleepMin))
	Local $iSleepMax = Number(GUICtrlRead($g_hInpCSVDelaySleepMax))

	Local $sIndex = AttackCSVSettings_BuildRange($iIndexMin, $iIndexMax)
	Local $sQty = AttackCSVSettings_BuildRange($iQtyMin, $iQtyMax)
	Local $sDelayPoint = AttackCSVSettings_BuildRange($iDelayPointMin, $iDelayPointMax)
	Local $sDelayDrop = AttackCSVSettings_BuildRange($iDelayDropMin, $iDelayDropMax)
	Local $sSleep = AttackCSVSettings_BuildRange($iSleepMin, $iSleepMax)
	Local $sRemainName = AttackCSVSettings_BuildRemainTroopName("")

	If $iRemainLine = -1 Then
		Local $sVector = StringUpper(StringStripWS(GUICtrlRead($g_hCmbCSVVectorId), $STR_STRIPALL))
		If $sVector = "" Then $sVector = "A"
		Local $sLine = "DROP |" & $sVector & " |" & $sIndex & " |" & $sQty & " |" & $sRemainName & " |" & $sDelayPoint & " |" & $sDelayDrop & " |" & $sSleep & " |"
		Local $iInsert = ($iLastDropLine > -1 ? $iLastDropLine + 1 : ($iFirstMakeLine > -1 ? $iFirstMakeLine + 1 : UBound($aLines)))
		AttackCSVSettings_InsertLine($aLines, $iInsert, $sLine)
		Return
	EndIf

	Local $aCols = StringSplit($aLines[$iRemainLine], "|", 2)
	Local $sExistingRemain = AttackCSVSettings_GetValue($aCols, 4)
	$sRemainName = AttackCSVSettings_BuildRemainTroopName($sExistingRemain)
	Local $iOldMin, $iOldMax
	AttackCSVSettings_ParseRange(AttackCSVSettings_GetValue($aCols, 2), $iOldMin, $iOldMax)
	If $iOldMin = $iIndexMin And $iOldMax = $iIndexMax Then
		AttackCSVSettings_ParseRange(AttackCSVSettings_GetValue($aCols, 3), $iOldMin, $iOldMax)
		If $iOldMin = $iQtyMin And $iOldMax = $iQtyMax Then
			AttackCSVSettings_ParseRange(AttackCSVSettings_GetValue($aCols, 5), $iOldMin, $iOldMax)
			If $iOldMin = $iDelayPointMin And $iOldMax = $iDelayPointMax Then
				AttackCSVSettings_ParseRange(AttackCSVSettings_GetValue($aCols, 6), $iOldMin, $iOldMax)
				If $iOldMin = $iDelayDropMin And $iOldMax = $iDelayDropMax Then
					AttackCSVSettings_ParseRange(AttackCSVSettings_GetValue($aCols, 7), $iOldMin, $iOldMax)
					If $iOldMin = $iSleepMin And $iOldMax = $iSleepMax And $sExistingRemain = $sRemainName Then Return
				EndIf
			EndIf
		EndIf
	EndIf
	AttackCSVSettings_SetColumn($aCols, 2, $sIndex)
	AttackCSVSettings_SetColumn($aCols, 3, $sQty)
	AttackCSVSettings_SetColumn($aCols, 4, $sRemainName)
	AttackCSVSettings_SetColumn($aCols, 5, $sDelayPoint)
	AttackCSVSettings_SetColumn($aCols, 6, $sDelayDrop)
	AttackCSVSettings_SetColumn($aCols, 7, $sSleep)
	$aLines[$iRemainLine] = AttackCSVSettings_JoinColumns($aCols)
EndFunc   ;==>AttackCSVSettings_UpdateDropRemainLine

; Side-effect: io (GUI state reads)
Func AttackCSVSettings_UpdateWaitLine(ByRef $aLines, $iWaitLineAny, $iWaitLineCond, $iLastDropLine, $iFirstMakeLine)
	Local $sWaitRange = AttackCSVSettings_BuildRange(Number(GUICtrlRead($g_hInpCSVWaitMin)), Number(GUICtrlRead($g_hInpCSVWaitMax)))
	Local $sCond = AttackCSVSettings_BuildWaitConditions()
	If $sWaitRange = "" And $sCond = "" Then Return

	Local $iLine = ($sCond <> "" And $iWaitLineCond > -1) ? $iWaitLineCond : $iWaitLineAny
	If $iLine = -1 Then
		If $sWaitRange = "" Then $sWaitRange = "1000"
		Local $sLine = "WAIT |" & $sWaitRange & " |" & $sCond & " |"
		Local $iInsert = ($iLastDropLine > -1 ? $iLastDropLine + 1 : ($iFirstMakeLine > -1 ? $iFirstMakeLine + 1 : UBound($aLines)))
		AttackCSVSettings_InsertLine($aLines, $iInsert, $sLine)
		Return
	EndIf

	Local $aCols = StringSplit($aLines[$iLine], "|", 2)
	If $sWaitRange <> "" Then AttackCSVSettings_SetColumn($aCols, 1, $sWaitRange)
	AttackCSVSettings_SetColumn($aCols, 2, $sCond)
	$aLines[$iLine] = AttackCSVSettings_JoinColumns($aCols)
EndFunc   ;==>AttackCSVSettings_UpdateWaitLine

; Side-effect: pure (name mapping)
Func AttackCSVSettings_GetTroopShortIndex($sTroop)
	For $i = 0 To UBound($g_asTroopShortNames) - 1
		If StringUpper($sTroop) = StringUpper($g_asTroopShortNames[$i]) Then Return $i
	Next
	Return -1
EndFunc   ;==>AttackCSVSettings_GetTroopShortIndex

; Side-effect: pure (name mapping)
Func AttackCSVSettings_GetHeroIndex($sTroop)
	Switch StringUpper($sTroop)
		Case "KING"
			Return 0
		Case "QUEEN"
			Return 1
		Case "WARDEN"
			Return 2
		Case "CHAMPION"
			Return 3
	EndSwitch
	Return -1
EndFunc   ;==>AttackCSVSettings_GetHeroIndex

; Side-effect: io (GUI state updates)
Func AttackCSVSettings_SetHeroControls($iHeroIndex, $sValue)
	If $iHeroIndex < 0 Or $iHeroIndex > 3 Then Return
	If $sValue = "" Then Return
	Local $sMode = StringLeft($sValue, 1)
	Local $sDelay = StringTrimLeft($sValue, 1)
	Local $iMode = Number($sMode) - 1
	If $iMode < 0 Or $iMode > 2 Then
		_GUICtrlComboBox_SetCurSel($g_ahCSVHeroAbilityMode[$iHeroIndex], 3)
		Return
	EndIf
	_GUICtrlComboBox_SetCurSel($g_ahCSVHeroAbilityMode[$iHeroIndex], $iMode)
	If $sDelay <> "" Then GUICtrlSetData($g_ahCSVHeroAbilityDelay[$iHeroIndex], Number($sDelay))
EndFunc   ;==>AttackCSVSettings_SetHeroControls

; Side-effect: io (GUI state updates)
Func AttackCSVSettings_SetComboIndex($hCombo, $iIndex)
	If $hCombo = 0 Then Return
	If $iIndex < 0 Then Return
	_GUICtrlComboBox_SetCurSel($hCombo, $iIndex)
EndFunc   ;==>AttackCSVSettings_SetComboIndex

; Side-effect: io (GUI state updates)
Func AttackCSVSettings_SetComboText($hCombo, $sValue)
	If $hCombo = 0 Then Return
	Local $iIndex = _GUICtrlComboBox_FindStringExact($hCombo, $sValue)
	If $iIndex >= 0 Then _GUICtrlComboBox_SetCurSel($hCombo, $iIndex)
EndFunc   ;==>AttackCSVSettings_SetComboText

Func PopulateComboScriptsFilesBattle()
	Dim $FileSearch, $NewFile
	$FileSearch = FileFindFirstFile($g_sCSVAttacksPath & "\*.csv")
	Dim $output = ""
	While True
		$NewFile = FileFindNextFile($FileSearch)
		If @error Then ExitLoop
		$output = $output & StringLeft($NewFile, StringLen($NewFile) - 4) & "|"
	WEnd
	FileClose($FileSearch)
	;remove last |
	$output = StringLeft($output, StringLen($output) - 1)
	;reset combo box
	_GUICtrlComboBox_ResetContent($g_hCmbScriptNameBattle)
	;set combo box
	GUICtrlSetData($g_hCmbScriptNameBattle, $output)
	_GUICtrlComboBox_SetCurSel($g_hCmbScriptNameBattle, _GUICtrlComboBox_FindStringExact($g_hCmbScriptNameBattle, ""))
	GUICtrlSetData($g_hLblNotesScriptBattle, "")
	If $g_hLblCSVScriptVersionBattle <> 0 Then GUICtrlSetData($g_hLblCSVScriptVersionBattle, "CSV: -")
EndFunc   ;==>PopulateComboScriptsFilesBattle

Func PopulateComboScriptsFilesRankedBattle()
	Dim $FileSearch, $NewFile
	$FileSearch = FileFindFirstFile($g_sCSVAttacksPath & "\*.csv")
	Dim $output = ""
	While True
		$NewFile = FileFindNextFile($FileSearch)
		If @error Then ExitLoop
		$output = $output & StringLeft($NewFile, StringLen($NewFile) - 4) & "|"
	WEnd
	FileClose($FileSearch)
	;remove last |
	$output = StringLeft($output, StringLen($output) - 1)
	;reset combo box
	_GUICtrlComboBox_ResetContent($g_hCmbScriptNameRankedBattle)
	;set combo box
	GUICtrlSetData($g_hCmbScriptNameRankedBattle, $output)
	_GUICtrlComboBox_SetCurSel($g_hCmbScriptNameRankedBattle, _GUICtrlComboBox_FindStringExact($g_hCmbScriptNameRankedBattle, ""))
	GUICtrlSetData($g_hLblNotesScriptRankedBattle, "")
	If $g_hLblCSVScriptVersionRankedBattle <> 0 Then GUICtrlSetData($g_hLblCSVScriptVersionRankedBattle, "CSV: -")
EndFunc   ;==>PopulateComboScriptsFilesRankedBattle


Func cmbScriptNameBattle()

	Local $tempvect1 = _GUICtrlComboBox_GetListArray($g_hCmbScriptNameBattle)
	Local $filename = $tempvect1[_GUICtrlComboBox_GetCurSel($g_hCmbScriptNameBattle) + 1]
	Local $f, $result = ""
	Local $tempvect, $line, $t
	Local $i = 0
	Local $sNoteKey = "", $sNoteKeyFlat = "", $sNoteLine = "", $sPart = ""
	Local $bNoteHasValue = False
	Local $sVersion = "unknown"

	If FileExists($g_sCSVAttacksPath & "\" & $filename & ".csv") Then
		$f = FileOpen($g_sCSVAttacksPath & "\" & $filename & ".csv", 0)
		; Read in lines of text until the EOF is reached
		While 1
			$line = FileReadLine($f)
			If @error = -1 Then ExitLoop
			$tempvect = StringSplit($line, "|", 2)
			If UBound($tempvect) >= 2 Then
				If StringStripWS(StringUpper($tempvect[0]), 2) = "NOTE" Then
					$sNoteKey = StringUpper(StringStripWS($tempvect[1], 3))
					$sNoteKeyFlat = StringRegExpReplace($sNoteKey, "[^A-Z0-9]", "")
					If StringLeft($sNoteKeyFlat, 10) = "CSVVERSION" Then ContinueLoop
					$sNoteLine = ""
					$bNoteHasValue = False
					For $i = 1 To UBound($tempvect) - 1
						$sPart = StringStripWS($tempvect[$i], 3)
						If $sPart <> "" Then
							If $sNoteLine <> "" Then $sNoteLine &= " | "
							$sNoteLine &= $sPart
							$bNoteHasValue = True
						EndIf
					Next
					If $bNoteHasValue Then
						$result &= $sNoteLine & @CRLF
					Else
						$result &= @CRLF
					EndIf
				EndIf
			EndIf
		WEnd
		FileClose($f)
		$sVersion = AttackCSVSettings_GetVersionFromFile($g_sCSVAttacksPath & "\" & $filename & ".csv")

	EndIf
	GUICtrlSetData($g_hLblNotesScriptBattle, $result)
	If $g_hLblCSVScriptVersionBattle <> 0 Then GUICtrlSetData($g_hLblCSVScriptVersionBattle, "CSV version: " & $sVersion)
	If $g_bCSVModReady Then
		$g_iAttackCSVSettingsMode = $Battle
		AttackCSVSettings_LoadFromCSV($g_iAttackCSVSettingsMode)
	EndIf

EndFunc   ;==>cmbScriptNameBattle

Func cmbScriptNameRankedBattle()

	Local $tempvect1 = _GUICtrlComboBox_GetListArray($g_hCmbScriptNameRankedBattle)
	Local $filename = $tempvect1[_GUICtrlComboBox_GetCurSel($g_hCmbScriptNameRankedBattle) + 1]
	Local $f, $result = ""
	Local $tempvect, $line, $t
	Local $i = 0
	Local $sNoteKey = "", $sNoteKeyFlat = "", $sNoteLine = "", $sPart = ""
	Local $bNoteHasValue = False
	Local $sVersion = "unknown"

	If FileExists($g_sCSVAttacksPath & "\" & $filename & ".csv") Then
		$f = FileOpen($g_sCSVAttacksPath & "\" & $filename & ".csv", 0)
		; Read in lines of text until the EOF is reached
		While 1
			$line = FileReadLine($f)
			If @error = -1 Then ExitLoop
			$tempvect = StringSplit($line, "|", 2)
			If UBound($tempvect) >= 2 Then
				If StringStripWS(StringUpper($tempvect[0]), 2) = "NOTE" Then
					$sNoteKey = StringUpper(StringStripWS($tempvect[1], 3))
					$sNoteKeyFlat = StringRegExpReplace($sNoteKey, "[^A-Z0-9]", "")
					If StringLeft($sNoteKeyFlat, 10) = "CSVVERSION" Then ContinueLoop
					$sNoteLine = ""
					$bNoteHasValue = False
					For $i = 1 To UBound($tempvect) - 1
						$sPart = StringStripWS($tempvect[$i], 3)
						If $sPart <> "" Then
							If $sNoteLine <> "" Then $sNoteLine &= " | "
							$sNoteLine &= $sPart
							$bNoteHasValue = True
						EndIf
					Next
					If $bNoteHasValue Then
						$result &= $sNoteLine & @CRLF
					Else
						$result &= @CRLF
					EndIf
				EndIf
			EndIf
		WEnd
		FileClose($f)
		$sVersion = AttackCSVSettings_GetVersionFromFile($g_sCSVAttacksPath & "\" & $filename & ".csv")

	EndIf
	GUICtrlSetData($g_hLblNotesScriptRankedBattle, $result)
	If $g_hLblCSVScriptVersionRankedBattle <> 0 Then GUICtrlSetData($g_hLblCSVScriptVersionRankedBattle, "CSV: " & $sVersion)
	If $g_bCSVModReady Then
		$g_iAttackCSVSettingsMode = $RankedBattle
		AttackCSVSettings_LoadFromCSV($g_iAttackCSVSettingsMode)
	EndIf

EndFunc   ;==>cmbScriptNameRankedBattle


Func UpdateComboScriptNameBattle()
	Local $indexofscript = _GUICtrlComboBox_GetCurSel($g_hCmbScriptNameBattle)
	Local $scriptname
	_GUICtrlComboBox_GetLBText($g_hCmbScriptNameBattle, $indexofscript, $scriptname)
	PopulateComboScriptsFilesBattle()
	_GUICtrlComboBox_SetCurSel($g_hCmbScriptNameBattle, _GUICtrlComboBox_FindStringExact($g_hCmbScriptNameBattle, $scriptname))
	cmbScriptNameBattle()
EndFunc   ;==>UpdateComboScriptNameBattle

Func UpdateComboScriptNameRankedBattle()
	Local $indexofscript = _GUICtrlComboBox_GetCurSel($g_hCmbScriptNameRankedBattle)
	Local $scriptname
	_GUICtrlComboBox_GetLBText($g_hCmbScriptNameRankedBattle, $indexofscript, $scriptname)
	PopulateComboScriptsFilesRankedBattle()
	_GUICtrlComboBox_SetCurSel($g_hCmbScriptNameRankedBattle, _GUICtrlComboBox_FindStringExact($g_hCmbScriptNameRankedBattle, $scriptname))
	cmbScriptNameRankedBattle()
EndFunc   ;==>UpdateComboScriptNameRankedBattle



Func AttackCSVAssignDefaultScriptName()
	Dim $FileSearch, $NewFile
	$FileSearch = FileFindFirstFile($g_sCSVAttacksPath & "\*.csv")
	Dim $output = ""
	$NewFile = FileFindNextFile($FileSearch)
	If @error Then $output = ""
	$output = StringLeft($NewFile, StringLen($NewFile) - 4)
	FileClose($FileSearch)
	;remove last |
	_GUICtrlComboBox_SetCurSel($g_hCmbScriptNameBattle, _GUICtrlComboBox_FindStringExact($g_hCmbScriptNameBattle, $output))
	_GUICtrlComboBox_SetCurSel($g_hCmbScriptNameRankedBattle, _GUICtrlComboBox_FindStringExact($g_hCmbScriptNameRankedBattle, $output))

	cmbScriptNameBattle()
	cmbScriptNameRankedBattle()
EndFunc   ;==>AttackCSVAssignDefaultScriptName

; TODO: update for battle logic
Func ApplyScriptDB()
	Local $iApply = 0
	Local $aiCSVTroops[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	Local $aiCSVSpells[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	Local $aiCSVSieges[$eSiegeMachineCount] = [0, 0, 0, 0, 0, 0, 0, 0]
	Local $aiCSVHeros[$eHeroCount][2] = [[0, 0], [0, 0], [0, 0], [0, 0]]
	Local $iCSVRedlineRoutineItem = 0, $iCSVDroplineEdgeItem = 0
	Local $sCSVCCReq = ""
	Local $aTemp = _GUICtrlComboBox_GetListArray($g_hCmbScriptNameBattle)
	Local $sFilename = $aTemp[_GUICtrlComboBox_GetCurSel($g_hCmbScriptNameBattle) + 1]

	SetLog("CSV settings apply starts: " & $sFilename, $COLOR_INFO)
	$iApply = ParseAttackCSV_Settings_variables($aiCSVTroops, $aiCSVSpells, $aiCSVSieges, $aiCSVHeros, $iCSVRedlineRoutineItem, $iCSVDroplineEdgeItem, $sCSVCCReq, $sFilename)
	If Not $iApply Then
		SetLog("CSV settings apply failed", $COLOR_ERROR)
		Return
	EndIf

	$iApply = 0
	For $i = 0 To UBound($aiCSVTroops) - 1
		If $aiCSVTroops[$i] > 0 Then $iApply += 1
	Next
	For $i = 0 To UBound($aiCSVSpells) - 1
		If $aiCSVSpells[$i] > 0 Then $iApply += 1
	Next
	If $iApply > 0 Then
		$g_aiArmyCustomTroops = $aiCSVTroops
		$g_aiArmyCustomSpells = $aiCSVSpells
		$g_aiArmyCustomSiegeMachines = $aiCSVSieges
		ApplyConfig_600_52_2("Read")
		SetComboTroopComp() ; GUI refresh
		SetLog("CSV Train settings applied", $COLOR_SUCCESS)
	EndIf

	$iApply = 0
	For $i = 0 To UBound($aiCSVHeros) - 1
		If $aiCSVHeros[$i][0] > 0 Then $iApply += 1
	Next
	If $iApply > 0 Then
		For $h = 0 To UBound($aiCSVHeros) - 1
			If $aiCSVHeros[$h][0] > 0 Then
				Switch $h
					Case $eHeroBarbarianKing
						$g_iActivateKing = $aiCSVHeros[$h][0] - 1
						$g_iDelayActivateKing = $aiCSVHeros[$h][1]
					Case $eHeroArcherQueen
						$g_iActivateQueen = $aiCSVHeros[$h][0] - 1
						$g_iDelayActivateQueen = $aiCSVHeros[$h][1]
					Case $eHeroGrandWarden
						$g_iActivateWarden = $aiCSVHeros[$h][0] - 1
						$g_iDelayActivateWarden = $aiCSVHeros[$h][1]
					Case $eHeroRoyalChampion
						$g_iActivateChampion = $aiCSVHeros[$h][0] - 1
						$g_iDelayActivateChampion = $aiCSVHeros[$h][1]
				EndSwitch
			EndIf
		Next
		radHerosApply()
		SetLog("CSV Hero Ability settings applied", $COLOR_SUCCESS)

			If $g_hchkBattleKingAttack <> 0 Then GUICtrlSetState($g_hchkBattleKingAttack, $aiCSVHeros[$eHeroBarbarianKing][0] > 0 ? $GUI_CHECKED : GUICtrlGetState($g_hchkBattleKingAttack))
			If $g_hchkBattleQueenAttack <> 0 Then GUICtrlSetState($g_hchkBattleQueenAttack, $aiCSVHeros[$eHeroArcherQueen][0] > 0 ? $GUI_CHECKED : GUICtrlGetState($g_hchkBattleQueenAttack))
			If $g_hchkBattleWardenAttack <> 0 Then GUICtrlSetState($g_hchkBattleWardenAttack, $aiCSVHeros[$eHeroGrandWarden][0] > 0 ? $GUI_CHECKED : GUICtrlGetState($g_hchkBattleWardenAttack))
			If $g_hchkBattleChampionAttack <> 0 Then GUICtrlSetState($g_hchkBattleChampionAttack, $aiCSVHeros[$eHeroRoyalChampion][0] > 0 ? $GUI_CHECKED : GUICtrlGetState($g_hchkBattleChampionAttack))
			SetLog("CSV 'Attack with' Hero settings applied", $COLOR_SUCCESS)
		EndIf

		If $sCSVCCReq <> "" Then
			If $g_hchkBattleDropCC <> 0 Then GUICtrlSetState($g_hchkBattleDropCC, $GUI_CHECKED)
			SetLog("CSV 'Attack with' CC settings applied", $COLOR_SUCCESS)
		EndIf

	$iApply = 0
	Local $ahchkBattleSpell = StringSplit($g_aGroupAttackBattleSpell, "#", 2)
	If IsArray($ahchkBattleSpell) Then
		For $i = 0 To UBound($ahchkBattleSpell) - 1
			GUICtrlSetState($ahchkBattleSpell[$i], $aiCSVSpells[$i] > 0 ? $GUI_CHECKED : $GUI_UNCHECKED)
			If $aiCSVSpells[$i] > 0 Then $iApply += 1
		Next
		If $iApply > 0 Then SetLog("CSV 'Attack with' Spell settings applied", $COLOR_SUCCESS)
	EndIf

	If $iCSVRedlineRoutineItem > 0 And $iCSVRedlineRoutineItem <= _GUICtrlComboBox_GetCount($g_hCmbScriptRedlineImplBattle) + 1 Then
		_GUICtrlComboBox_SetCurSel($g_hCmbScriptRedlineImplBattle, $iCSVRedlineRoutineItem - 1)
		cmbScriptRedlineImplDB()
		SetLog("CSV Red Line settings applied", $COLOR_SUCCESS)
	Else
		If $iCSVRedlineRoutineItem <> 0 Then SetLog("CSV Red Line settings out of bounds", $COLOR_ERROR)
	EndIf
	If $iCSVDroplineEdgeItem > 0 And $iCSVDroplineEdgeItem <= _GUICtrlComboBox_GetCount($g_hCmbScriptDroplineDB) + 1 Then
		_GUICtrlComboBox_SetCurSel($g_hCmbScriptDroplineDB, $iCSVDroplineEdgeItem - 1)
		cmbScriptDroplineDB()
		SetLog("CSV Drop Line settings applied", $COLOR_SUCCESS)
	Else
		If $iCSVDroplineEdgeItem <> 0 Then SetLog("CSV Drop Line settings out of bounds", $COLOR_ERROR)
	EndIf

	If $sCSVCCReq <> "" Then
		$g_bRequestTroopsEnable = True
		$g_sRequestTroopsText = $sCSVCCReq
		ApplyConfig_600_11("Read")
		SetLog("CSV CC Request settings applied", $COLOR_SUCCESS)
	EndIf
EndFunc   ;==>ApplyScriptDB

; TODO: update for ranked battle logic
Func ApplyScriptAB()
	Local $iApply = 0
	Local $aiCSVTroops[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	Local $aiCSVSpells[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	Local $aiCSVSieges[$eSiegeMachineCount] = [0, 0, 0, 0, 0, 0, 0, 0]
	Local $aiCSVHeros[$eHeroCount][2] = [[0, 0], [0, 0], [0, 0], [0, 0]]
	Local $iCSVRedlineRoutineItem = 0, $iCSVDroplineEdgeItem = 0
	Local $sCSVCCReq = ""
	Local $aTemp = _GUICtrlComboBox_GetListArray($g_hCmbScriptNameRankedBattle)
	Local $sFilename = $aTemp[_GUICtrlComboBox_GetCurSel($g_hCmbScriptNameRankedBattle) + 1]

	SetLog("CSV settings apply starts: " & $sFilename, $COLOR_INFO)
	$iApply = ParseAttackCSV_Settings_variables($aiCSVTroops, $aiCSVSpells, $aiCSVSieges, $aiCSVHeros, $iCSVRedlineRoutineItem, $iCSVDroplineEdgeItem, $sCSVCCReq, $sFilename)
	If Not $iApply Then
		SetLog("CSV settings apply failed", $COLOR_ERROR)
		Return
	EndIf

	$iApply = 0
	For $i = 0 To UBound($aiCSVTroops) - 1
		If $aiCSVTroops[$i] > 0 Then $iApply += 1
	Next
	For $i = 0 To UBound($aiCSVSpells) - 1
		If $aiCSVSpells[$i] > 0 Then $iApply += 1
	Next
	If $iApply > 0 Then
		$g_aiArmyCustomTroops = $aiCSVTroops
		$g_aiArmyCustomSpells = $aiCSVSpells
		$g_aiArmyCustomSiegeMachines = $aiCSVSieges
		ApplyConfig_600_52_2("Read")
		SetComboTroopComp() ; GUI refresh
		SetLog("CSV Train settings applied", $COLOR_SUCCESS)
	EndIf

	$iApply = 0
	For $i = 0 To UBound($aiCSVHeros) - 1
		If $aiCSVHeros[$i][0] > 0 Then $iApply += 1
	Next
	If $iApply > 0 Then
		For $h = 0 To UBound($aiCSVHeros) - 1
			If $aiCSVHeros[$h][0] > 0 Then
				Switch $h
					Case $eHeroBarbarianKing
						$g_iActivateKing = $aiCSVHeros[$h][0] - 1
						$g_iDelayActivateKing = $aiCSVHeros[$h][1]
					Case $eHeroArcherQueen
						$g_iActivateQueen = $aiCSVHeros[$h][0] - 1
						$g_iDelayActivateQueen = $aiCSVHeros[$h][1]
					Case $eHeroGrandWarden
						$g_iActivateWarden = $aiCSVHeros[$h][0] - 1
						$g_iDelayActivateWarden = $aiCSVHeros[$h][1]
					Case $eHeroRoyalChampion
						$g_iActivateChampion = $aiCSVHeros[$h][0] - 1
						$g_iDelayActivateChampion = $aiCSVHeros[$h][1]
				EndSwitch
			EndIf
		Next
		radHerosApply()
		SetLog("CSV Hero Ability settings applied", $COLOR_SUCCESS)

			If $g_hchkRankedBattleKingAttack <> 0 Then GUICtrlSetState($g_hchkRankedBattleKingAttack, $aiCSVHeros[$eHeroBarbarianKing][0] > 0 ? $GUI_CHECKED : GUICtrlGetState($g_hchkRankedBattleKingAttack))
			If $g_hchkRankedBattleQueenAttack <> 0 Then GUICtrlSetState($g_hchkRankedBattleQueenAttack, $aiCSVHeros[$eHeroArcherQueen][0] > 0 ? $GUI_CHECKED : GUICtrlGetState($g_hchkRankedBattleQueenAttack))
			If $g_hchkRankedBattleWardenAttack <> 0 Then GUICtrlSetState($g_hchkRankedBattleWardenAttack, $aiCSVHeros[$eHeroGrandWarden][0] > 0 ? $GUI_CHECKED : GUICtrlGetState($g_hchkRankedBattleWardenAttack))
			If $g_hchkRankedBattleChampionAttack <> 0 Then GUICtrlSetState($g_hchkRankedBattleChampionAttack, $aiCSVHeros[$eHeroRoyalChampion][0] > 0 ? $GUI_CHECKED : GUICtrlGetState($g_hchkRankedBattleChampionAttack))
			SetLog("CSV 'Attack with' Hero settings applied", $COLOR_SUCCESS)
		EndIf

		If $sCSVCCReq <> "" Then
			If $g_hchkRankedBattleDropCC <> 0 Then GUICtrlSetState($g_hchkRankedBattleDropCC, $GUI_CHECKED)
			SetLog("CSV 'Attack with' CC settings applied", $COLOR_SUCCESS)
		EndIf

	$iApply = 0
	Local $ahchkRankedBattleSpell = StringSplit($GroupAttackABSpell, "#", 2)
	If IsArray($ahchkRankedBattleSpell) Then
		For $i = 0 To UBound($ahchkRankedBattleSpell) - 1
			GUICtrlSetState($ahchkRankedBattleSpell[$i], $aiCSVSpells[$i] > 0 ? $GUI_CHECKED : $GUI_UNCHECKED)
			If $aiCSVSpells[$i] > 0 Then $iApply += 1
		Next
		If $iApply > 0 Then SetLog("CSV 'Attack with' Spell settings applied", $COLOR_SUCCESS)
	EndIf

	If $iCSVRedlineRoutineItem > 0 And $iCSVRedlineRoutineItem <= _GUICtrlComboBox_GetCount($g_hCmbScriptRedlineImplRankedBattle) + 1 Then
		_GUICtrlComboBox_SetCurSel($g_hCmbScriptRedlineImplRankedBattle, $iCSVRedlineRoutineItem - 1)
		cmbScriptRedlineImplAB()
		SetLog("CSV Red Line settings applied", $COLOR_SUCCESS)
	Else
		If $iCSVRedlineRoutineItem <> 0 Then SetLog("CSV Red Line settings out of bounds", $COLOR_ERROR)
	EndIf
	If $iCSVDroplineEdgeItem > 0 And $iCSVDroplineEdgeItem <= _GUICtrlComboBox_GetCount($g_hCmbScriptDroplineAB) + 1 Then
		_GUICtrlComboBox_SetCurSel($g_hCmbScriptDroplineAB, $iCSVDroplineEdgeItem - 1)
		cmbScriptDroplineAB()
		SetLog("CSV Drop Line settings applied", $COLOR_SUCCESS)
	Else
		If $iCSVDroplineEdgeItem <> 0 Then SetLog("CSV Drop Line settings out of bounds", $COLOR_ERROR)
	EndIf

	If $sCSVCCReq <> "" Then
		$g_bRequestTroopsEnable = True
		$g_sRequestTroopsText = $sCSVCCReq
		ApplyConfig_600_11("Read")
		SetLog("CSV CC Request settings applied", $COLOR_SUCCESS)
	EndIf
EndFunc   ;==>ApplyScriptAB

Func cmbScriptRedlineImplDB()
	$g_aiAttackScrRedlineRoutine[$Battle] = _GUICtrlComboBox_GetCurSel($g_hCmbScriptRedlineImplBattle)
    If $g_aiAttackScrRedlineRoutine[$Battle] = 3 then
        GUICtrlSetState($g_hCmbScriptDroplineDB, $GUI_HIDE)
        $g_aiAttackScrDroplineEdge[$Battle] = $DROPLINE_FULL_EDGE_FIXED
    Else
        GUICtrlSetState($g_hCmbScriptDroplineDB, $GUI_SHOW)
    Endif
EndFunc   ;==>cmbScriptRedlineImplDB

Func cmbScriptRedlineImplAB()
	$g_aiAttackScrRedlineRoutine[$RankedBattle] = _GUICtrlComboBox_GetCurSel($g_hCmbScriptRedlineImplRankedBattle)
    If $g_aiAttackScrRedlineRoutine[$RankedBattle] = 3 then
        GUICtrlSetState($g_hCmbScriptDroplineAB, $GUI_HIDE)
        $g_aiAttackScrDroplineEdge[$RankedBattle] = $DROPLINE_FULL_EDGE_FIXED
    Else
        GUICtrlSetState($g_hCmbScriptDroplineAB, $GUI_SHOW)
    EndIf
EndFunc   ;==>cmbScriptRedlineImplAB

Func cmbScriptDroplineDB()
	$g_aiAttackScrDroplineEdge[$Battle] = _GUICtrlComboBox_GetCurSel($g_hCmbScriptDroplineDB)
EndFunc   ;==>cmbScriptDroplineDB

Func cmbScriptDroplineAB()
	$g_aiAttackScrDroplineEdge[$RankedBattle] = _GUICtrlComboBox_GetCurSel($g_hCmbScriptDroplineAB)
EndFunc   ;==>cmbScriptDroplineAB
