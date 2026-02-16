#include-once

; CSV Mod search globals are declared in COCBot/MBR Global Variables.au3.

; #FUNCTION# ====================================================================================================================
; Name ..........: CreateCSVModSearchTab
; Description ...: Creates search criteria UI for Battle within CSV Mod.
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
Func CreateCSVModSearchTab()
	Local $iChildX = 0
	Local $iChildY = 25
	$g_hGUI_CSVMOD_SEARCH = _GUICreate("", $g_iSizeWGrpTab1, $g_iSizeHGrpTab1, $iChildX, $iChildY, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_CSVMOD)
	GUISwitch($g_hGUI_CSVMOD_SEARCH)

	CreateAttackSearch()

	GUISwitch($g_hGUI_CSVMOD)
EndFunc   ;==>CreateCSVModSearchTab

Func CreateAttackSearch()
	Local $sTxtTip = ""
	Local $x = 25, $y = 45
	GUICtrlCreateGroup("Normal Battle", $x - 20, $y - 20, 190, 78)
	$x -= 15
		$g_hChkBattle = GUICtrlCreateCheckbox("Enable Battle Search", $x, $y, 150, 18)
		$g_hchkBattleWaitForCastle = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "ChkWaitForCastle", "Wait for Clan Castle"), $x, $y + 22, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "ChkWaitForCastle_Info_01", "Wait until your Clan Castle is filled, as requested."))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = 25
	$y = 130
	GUICtrlCreateGroup("Ranked Battle", $x - 20, $y - 20, 190, 78)
	$x -= 15
		$g_hChkRankedBattle = GUICtrlCreateCheckbox("Enable Ranked Search", $x, $y, 160, 18)
		$g_hchkRankedBattleWaitForCastle = GUICtrlCreateCheckbox("Wait for Clan Castle", $x, $y + 22, -1, -1)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = 220
	$y = 45
	$g_hGrpBattleFilter = GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "Group_02", "Filters"), $x - 20, $y - 20, 225, $g_iSizeHGrpTab4)
	$x -= 15
	Local $xStartColumn = $x
		$g_hTxtDBMinGold = GUICtrlCreateInput("80000", $x + 85, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "TxtMinGold_Info_01", "Set the Min. amount of Gold to search for on a village to attack.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 7)
		$g_hPicDBMinGold = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 140, $y, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)

	$y += 21
		$g_hTxtDBMinElixir = GUICtrlCreateInput("80000", $x + 85, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "TxtMinElixir_Info_01", "Set the Min. amount of Elixir to search for on a village to attack.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 7)
		$g_hPicDBMinElixir = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 140, $y, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)

	$y += 34
		$g_hTxtDBMinDarkElixir = GUICtrlCreateInput("0", $x + 85, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "TxtMinDarkElixir_Info_01", "Set the Min. amount of Dark Elixir to search for on a village to attack.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 5)
		$g_hPicDBMinDarkElixir = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 140, $y, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)

	$y += 34
	$x = $xStartColumn
		$g_hChkSearchDisableFullResources = GUICtrlCreateCheckbox("Disable filters when storage is full", $x - 5, $y, 210, 18)
		GUICtrlSetOnEvent(-1, "CSVMod_ToggleDisableFullResources")
	$y += 34
	$x = $xStartColumn
		$g_ahChkMeetOne[$Battle] = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "ChkMeetOne", "Meet One Then Attack"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "ChkMeetOne_Info_01", "Just meet only ONE of the above conditions, then Attack."))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateAttackSearch
