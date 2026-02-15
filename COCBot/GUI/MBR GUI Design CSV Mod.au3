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
#include "MBR GUI Design CSV Mod Script.au3"
#include "MBR GUI Design CSV Mod Settings.au3"
#include "MBR GUI Design CSV Mod Diagnostics.au3"

; #FUNCTION# ====================================================================================================================
; Name ..........: CreateCSVModTab
; Description ...: Builds the CSV Mod top-level tab and its sub-tabs.
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
Func CreateCSVModTab()
	$g_hGUI_CSVMOD = _GUICreate("", $g_iSizeWGrpTab1, $g_iSizeHGrpTab1, $_GUI_CHILD_LEFT, $_GUI_CHILD_TOP, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hFrmBotEx)

	GUISwitch($g_hGUI_CSVMOD)
	$g_hGUI_CSVMOD_TAB = GUICtrlCreateTab(0, 0, $g_iSizeWGrpTab1, $g_iSizeHGrpTab1)

	$g_hGUI_CSVMOD_TAB_ITEM1 = GUICtrlCreateTabItem("Script")
		CreateCSVModScriptTab()
	$g_hGUI_CSVMOD_TAB_ITEM2 = GUICtrlCreateTabItem("Search")
		CreateCSVModSearchTab()
	$g_hGUI_CSVMOD_TAB_ITEM3 = GUICtrlCreateTabItem("Settings")
		CreateCSVModSettingsTab()
	$g_hGUI_CSVMOD_TAB_ITEM4 = GUICtrlCreateTabItem("Diagnostics")
		CreateCSVModDiagnosticsTab()
	GUICtrlCreateTabItem("")

	; CSV settings logic expects a valid GUI container handle.
	$g_hGUI_AttackCSVSettings = ($g_hGUI_CSVMOD_SETTINGS <> 0) ? $g_hGUI_CSVMOD_SETTINGS : $g_hGUI_CSVMOD
	$g_iAttackCSVSettingsMode = $Battle
	$g_bCSVModReady = True
	ApplyConfig_CSVMod_Search_Battle("Read")
	ApplyConfig_CSVMod_Search_Ranked("Read")
	CSVMod_ApplyScriptSelectionFromGlobals()
EndFunc   ;==>CreateCSVModTab

; #FUNCTION# ====================================================================================================================
; Name ..........: CSVMod_GetContentBounds
; Description ...: Returns a shared content area for CSV Mod sub-tabs to keep controls below tab headers.
; Syntax ........: CSVMod_GetContentBounds(ByRef $iX, ByRef $iY, ByRef $iW, ByRef $iH)
; Parameters ....: $iX - Left offset for sub-tab content.
;                  $iY - Top offset for sub-tab content.
;                  $iW - Width available for sub-tab content.
;                  $iH - Height available for sub-tab content.
; Return values .: None
; Author ........: mxkcz
; Modified ......: mxkcz
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; =====================================================================================================================
Func CSVMod_GetContentBounds(ByRef $iX, ByRef $iY, ByRef $iW, ByRef $iH)
	$iX = 10
	$iY = 45
	$iW = $g_iSizeWGrpTab1 - 20
	$iH = $g_iSizeHGrpTab1 - $iY - 10
EndFunc   ;==>CSVMod_GetContentBounds

; #FUNCTION# ====================================================================================================================
; Name ..........: CSVMod_GetSettingsSubTabBounds
; Description ...: Returns a shared content area for nested CSV Mod Settings subtabs.
; Syntax ........: CSVMod_GetSettingsSubTabBounds(ByRef $iX, ByRef $iY, ByRef $iW, ByRef $iH)
; Parameters ....: $iX - Left offset for nested Settings sub-tab content.
;                  $iY - Top offset for nested Settings sub-tab content.
;                  $iW - Width available for nested Settings sub-tab content.
;                  $iH - Height available for nested Settings sub-tab content.
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; =====================================================================================================================
Func CSVMod_GetSettingsSubTabBounds(ByRef $iX, ByRef $iY, ByRef $iW, ByRef $iH)
	If $g_iCSVModSettingsTabW <= 0 Or $g_iCSVModSettingsTabH <= 0 Then
		CSVMod_GetContentBounds($iX, $iY, $iW, $iH)
		Return
	EndIf

	; Settings subtabs render in the dedicated Settings child GUI, so bounds are local.
	$iX = 8
	$iY = 30
	$iW = $g_iCSVModSettingsTabW - 16
	$iH = $g_iCSVModSettingsTabH - 38
	If $iW < 180 Then $iW = 180
	If $iH < 120 Then $iH = 120
EndFunc   ;==>CSVMod_GetSettingsSubTabBounds
