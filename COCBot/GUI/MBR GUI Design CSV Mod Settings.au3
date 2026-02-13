; #FUNCTION# ====================================================================================================================
; Name ..........: CreateCSVModSettingsTab
; Description ...: Creates nested CSV Mod Settings sub-sub-tabs.
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
#include-once
#include "MBR GUI Design CSV Mod Settings - Attack.au3"
#include "MBR GUI Design CSV Mod Settings - Presets.au3"
#include "MBR GUI Design CSV Mod Settings - Drop.au3"
#include "MBR GUI Design CSV Mod Settings - Vector.au3"
#include "MBR GUI Design CSV Mod Settings - Side.au3"
#include "MBR GUI Design CSV Mod Settings - Precalc.au3"

; #FUNCTION# ====================================================================================================================
; Name ..........: CreateCSVModSettingsTab
; Description ...: Creates Settings tab content and nested sub-subtab host.
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
Func CreateCSVModSettingsTab()
	Local $x = 0, $y = 0, $w = 0, $h = 0
	CSVMod_GetContentBounds($x, $y, $w, $h)

	Local $iTabX = 0
	Local $iTabY = 0
	Local $iTabW = $w
	Local $iTabH = $h
	If $iTabW < 220 Then $iTabW = 220
	If $iTabH < 180 Then $iTabH = 180

	$g_hGUI_CSVMOD_SETTINGS = _GUICreate("", $w, $h, $x, $y, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_CSVMOD)
	GUISwitch($g_hGUI_CSVMOD_SETTINGS)

	$g_iCSVModSettingsTabX = $iTabX
	$g_iCSVModSettingsTabY = $iTabY
	$g_iCSVModSettingsTabW = $iTabW
	$g_iCSVModSettingsTabH = $iTabH

	$g_hGUI_CSVMOD_SETTINGS_TAB = GUICtrlCreateTab($iTabX, $iTabY, $iTabW, $iTabH, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))
	$g_hGUI_CSVMOD_SETTINGS_TAB_ATTACK = GUICtrlCreateTabItem("Attack")
		CreateCSVModSettingsAttackTab()
	$g_hGUI_CSVMOD_SETTINGS_TAB_PRESETS = GUICtrlCreateTabItem("Presets")
		CreateCSVModSettingsPresetsTab()
	$g_hGUI_CSVMOD_SETTINGS_TAB_DROP = GUICtrlCreateTabItem("Drop")
		CreateCSVModDropsTab()
	$g_hGUI_CSVMOD_SETTINGS_TAB_VECTOR = GUICtrlCreateTabItem("Vector")
		CreateCSVModVectorTab()
	$g_hGUI_CSVMOD_SETTINGS_TAB_SIDE = GUICtrlCreateTabItem("Side")
		CreateCSVModSideTab()
	$g_hGUI_CSVMOD_SETTINGS_TAB_PRECALC = GUICtrlCreateTabItem("Precalc")
		CreateCSVModPrecalcTab()
	GUICtrlCreateTabItem("")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUISwitch($g_hGUI_CSVMOD)
EndFunc   ;==>CreateCSVModSettingsTab
