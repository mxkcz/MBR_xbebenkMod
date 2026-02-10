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
	$g_hGUI_CSVMOD_TAB = GUICtrlCreateTab(0, 0, $g_iSizeWGrpTab1, $g_iSizeHGrpTab1, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))

	$g_hGUI_CSVMOD_TAB_ITEM1 = GUICtrlCreateTabItem("Script")
		CreateCSVModScriptTab()
	$g_hGUI_CSVMOD_TAB_ITEM2 = GUICtrlCreateTabItem("Search")
		CreateCSVModSearchTab()
	$g_hGUI_CSVMOD_TAB_ITEM3 = GUICtrlCreateTabItem("Side")
		CreateCSVModSideTab()
	$g_hGUI_CSVMOD_TAB_ITEM4 = GUICtrlCreateTabItem("Vector")
		CreateCSVModVectorTab()
	$g_hGUI_CSVMOD_TAB_ITEM5 = GUICtrlCreateTabItem("Drops")
		CreateCSVModDropsTab()
	$g_hGUI_CSVMOD_TAB_ITEM6 = GUICtrlCreateTabItem("Settings")
		CreateCSVModSettingsTab()
	$g_hGUI_CSVMOD_TAB_ITEM7 = GUICtrlCreateTabItem("Precalc")
		CreateCSVModPrecalcTab()
	$g_hGUI_CSVMOD_TAB_ITEM8 = GUICtrlCreateTabItem("Diagnostics")
		CreateCSVModDiagnosticsTab()
	$g_hGUI_CSVMOD_TAB_ITEM9 = GUICtrlCreateTabItem("Attack")
		CreateCSVModAttackTab()
	GUICtrlCreateTabItem("")

	; Reuse CSV settings logic guards by pointing to the Mod tab container.
	$g_hGUI_AttackCSVSettings = $g_hGUI_CSVMOD
	$g_iAttackCSVSettingsMode = $Battle
	AttackCSVSettings_LoadFromCSV($g_iAttackCSVSettingsMode)
	$g_bCSVModReady = True
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
