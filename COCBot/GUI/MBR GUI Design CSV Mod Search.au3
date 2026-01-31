#include-once

; Start search if
Global $g_hchkBattleActivateSearches = 0, $g_hTxtDBSearchesMin = 0, $g_hTxtDBSearchesMax = 0  ; Search count limit
Global $g_hchkBattleActivateCamps = 0, $g_hTxtDBArmyCamps = 0 ; Camp limit
Global $g_hchkBattleWaitForCastle = 0

Global $g_hLblDBSearches = 0, $g_hLblDBArmyCamps = 0

; Filters
Global $g_hTxtDBMinGold = 0, $g_hTxtDBMinElixir = 0, $g_hTxtDBMinDarkElixir = 0


Global $g_hPicDBMinGold = 0, $g_hPicDBMinElixir = 0, $g_hPicDBMinDarkElixir = 0
Global $g_ahPicDBMaxTH[$g_iMaxTHLevel]

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
	Local $x = 5, $y = 5
	Local $w = $g_iSizeWGrpTab1 - 10
	Local $h = $g_iSizeHGrpTab1 - 15
	Local $hTab = GUICtrlCreateTab($x, $y, $w, $h, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))
	CreateAttackSearch()

	GUICtrlCreateTabItem("")

	CSVMod_PruneSearchControls()
EndFunc   ;==>CreateCSVModSearchTab



Func CreateAttackSearch()
	Local $sTxtTip = ""
	Local $x = 25, $y = 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "Group_01", "Start Search IF"), $x - 20, $y - 20, 190, $g_iSizeHGrpTab4)
	$x -= 15
		$g_hchkBattleWaitForCastle = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "ChkWaitForCastle", "Wait for Clan Castle"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "ChkWaitForCastle_Info_01", "Wait until your Clan Castle is filled, as requested."))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 220, $y = 45
	$g_hGrpDBFilter = GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "Group_02", "Filters"), $x - 20, $y - 20, 225, $g_iSizeHGrpTab4)
	$x -= 15
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
		$g_hchkBattleMeetDE = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "ChkMeetDE", "Dark Elixir"), $x, $y, -1, -1)
			GUICtrlSetOnEvent(-1, "chkBattleMeetDE")
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "ChkMeetDE_Info_01", "Search for a base that meets the value set for Min. Dark Elixir."))
		$g_hTxtDBMinDarkElixir = GUICtrlCreateInput("0", $x + 85, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "TxtMinDarkElixir_Info_01", "Set the Min. amount of Dark Elixir to search for on a village to attack.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 5)
			_GUICtrlEdit_SetReadOnly(-1, True)
		$g_hPicDBMinDarkElixir = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 140, $y, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)

	$y += 44
	$y += 24
	$x = $xStartColumn
		$g_ahChkMeetOne[$Battle] = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "ChkMeetOne", "Meet One Then Attack"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "ChkMeetOne_Info_01", "Just meet only ONE of the above conditions, then Attack."))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateAttackSearch