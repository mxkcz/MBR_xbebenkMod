; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "ActiveBase" tab under the "Search & Attack" tab under the "Attack Plan" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (01-2017), mxkcz
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hGUI_ACTIVEBASE = 0

#include "MBR GUI Design Child Attack - Activebase Attack Standard.au3"
#include "MBR GUI Design Child Attack - Activebase-Search.au3"
#include "MBR GUI Design Child Attack - Activebase-Attack.au3"
#include "MBR GUI Design Child Attack - Activebase-EndBattle.au3"

Global $g_hGUI_ACTIVEBASE_TAB = 0, $g_hGUI_ACTIVEBASE_TAB_ITEM1 = 0, $g_hGUI_ACTIVEBASE_TAB_ITEM2 = 0, $g_hGUI_ACTIVEBASE_TAB_ITEM3 = 0

Func CreateAttackSearchActiveBase()

	$g_hGUI_ACTIVEBASE = _GUICreate("", $g_iSizeWGrpTab3, $g_iSizeHGrpTab3, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_SEARCH)
	;GUISetBkColor($COLOR_WHITE, $g_hGUI_ACTIVEBASE)

	;creating subchilds first!
	CreateAttackSearchActiveBaseStandard()

	GUISwitch($g_hGUI_ACTIVEBASE)
	$g_hGUI_ACTIVEBASE_TAB = GUICtrlCreateTab(0, 0, $g_iSizeWGrpTab3, $g_iSizeHGrpTab3, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))
	$g_hGUI_ACTIVEBASE_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_02_STab_0X_STab_01", -1))
		GUICtrlCreateLabel("Search criteria moved to CSV Mod tab.", 15, 20, $g_iSizeWGrpTab3 - 30, 40)
	$g_hGUI_ACTIVEBASE_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_02_STab_0X_STab_02", -1))
		GUICtrlCreateLabel("Attack options moved to CSV Mod tab.", 15, 20, $g_iSizeWGrpTab3 - 30, 40)
	$g_hGUI_ACTIVEBASE_TAB_ITEM3 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_02_STab_0X_STab_03", -1))
		CreateAttackSearchActiveBaseEndBattle()
	GUICtrlCreateTabItem("")

EndFunc   ;==>CreateAttackSearchActiveBase

