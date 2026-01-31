; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Search" tab under the "ActiveBase" tab under the "Search & Attack" tab under the "Attack Plan" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

; Start search if
Global $g_hchkRankedBattleActivateSearches = 0, $g_hTxtABSearchesMin = 0, $g_hTxtABSearchesMax = 0  ; Search count limit
Global $g_hchkRankedBattleActivateCamps = 0, $g_hTxtABArmyCamps = 0 ; Camp limit
Global $g_hchkRankedBattleWaitForCastle = 0

Global $g_hLblABSearches = 0, $g_hLblABArmyCamps = 0

; Filters
Global $g_hCmbABMeetGE = 0, $g_hTxtABMinGold = 0, $g_hTxtABMinElixir = 0, $g_hTxtABMinGoldPlusElixir = 0
Global $g_hchkRankedBattleMeetDE = 0, $g_hTxtABMinDarkElixir = 0
Global $g_hchkRankedBattleMeetTH = 0, $g_hCmbABTH = 0, $g_hchkRankedBattleMeetTHO = 0

Global $g_hGrpABFilter = 0, $g_hPicABMinGold = 0, $g_hPicABMinElixir = 0, $g_hPicABMinGPEGold = 0, $g_hPicABMinDarkElixir = 0
Global $g_ahPicABMaxTH[15]

Func CreateAttackSearchActiveBaseSearch()
	Local $sTxtTip = ""
	Local $x = 25, $y = 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "Group_01", -1), $x - 20, $y - 20, 190, $g_iSizeHGrpTab4)
	$x -= 15
		$g_hchkRankedBattleActivateSearches = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "ChkActivateSearches", -1), $x, $y, 68, 18)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "ChkActivateSearches_Info_01", -1) & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "ChkActivateSearches_Info_02", -1))
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetOnEvent(-1, "chkRankedBattleActivateSearches")
		$g_hTxtABSearchesMin = GUICtrlCreateInput("1", $x + 70, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "LblActivateMinSearches_Info_01", -1) & @CRLF & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "ChkActivateSearches_Info_01", -1) & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "ChkActivateSearches_Info_02", -1))
			GUICtrlSetLimit(-1, 6)
		$g_hLblABSearches = GUICtrlCreateLabel("-", $x + 113, $y + 2, -1, -1)
		$g_hTxtABSearchesMax = GUICtrlCreateInput("9999", $x + 120, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER)) ;ChrW(8734)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "LblActivateMaxSearches_Info_01", -1) & @CRLF & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "ChkActivateSearches_Info_01", -1))
			GUICtrlSetLimit(-1, 6)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnMagnifier, $x + 163, $y + 1, 16, 16)

	$y += 21
		$g_hchkRankedBattleActivateCamps = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "ChkActivateCamps", -1), $x, $y, 110, 18)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "ChkActivateCamps_Info_01", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLblABArmyCamps = GUICtrlCreateLabel(ChrW(8805), $x + 113 - 1, $y + 2, -1, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hTxtABArmyCamps = GUICtrlCreateInput("100", $x + 120, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetLimit(-1, 6)
		GUICtrlCreateLabel("%", $x + 163 + 3, $y + 4, -1, -1)
			GUICtrlSetState(-1, $GUI_DISABLE)

	$y += 23
	$x = 10
		$g_hchkRankedBattleWaitForCastle = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "ChkWaitForCastle", -1), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "ChkWaitForCastle_Info_01", -1))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 220, $y = 45
	$g_hGrpABFilter = GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "Group_02", -1), $x - 20, $y - 20, 225, $g_iSizeHGrpTab4)
	$x -= 15
		$g_hCmbABMeetGE = GUICtrlCreateCombo("", $x, $y + 10, 65, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "CmbMeetGE_Item_01", -1) & "|" & _
							   GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "CmbMeetGE_Item_02", -1) & "|" & _
							   GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "CmbMeetGE_Item_03", -1), GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "CmbMeetGE_Item_01", -1))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "CmbMeetGE_Info_01", -1) & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "CmbMeetGE_Info_02", -1) & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "CmbMeetGE_Info_03", -1) & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "CmbMeetGE_Info_04", -1))
			GUICtrlSetOnEvent(-1, "cmbABGoldElixir")
		$g_hTxtABMinGold = GUICtrlCreateInput("80000", $x + 85, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "TxtMinGold_Info_01", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 7)
		$g_hPicABMinGold = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 137, $y, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)

	$y += 21
		$g_hTxtABMinElixir = GUICtrlCreateInput("80000", $x + 85, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "TxtMinElixir_Info_01", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 7)
		$g_hPicABMinElixir = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 137, $y, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)

	$y -= 11
		$g_hTxtABMinGoldPlusElixir = GUICtrlCreateInput("160000", $x + 85, $y, 50, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "TxtMinGoldPlusElixir_Info_01", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 7)
			GUICtrlSetState (-1, $GUI_HIDE)
		$g_hPicABMinGPEGold = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGoldElixir, $x + 137, $y + 1, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState (-1, $GUI_HIDE)

	$y += 34
		$g_hchkRankedBattleMeetDE = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "ChkMeetDE", -1), $x, $y, -1, -1)
			GUICtrlSetOnEvent(-1, "chkRankedBattleMeetDE")
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "ChkMeetDE_Info_01", -1))
		$g_hTxtABMinDarkElixir = GUICtrlCreateInput("0", $x + 85, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "TxtMinDarkElixir_Info_01", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 5)
			_GUICtrlEdit_SetReadOnly(-1, True)
		$g_hPicABMinDarkElixir = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 137, $y, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)

	$y += 24
		$g_hchkRankedBattleMeetTH = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR Global GUI Design", "LblTownhall", -1), $x, $y, -1, -1)
			GUICtrlSetOnEvent(-1, "chkRankedBattleMeetTH")
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "ChkMeetTH_Info_01", -1))
		$g_hCmbABTH = GUICtrlCreateCombo("", $x + 85, $y - 1, 50, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "CmbDBTH", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetData(-1, "4-6|7|8|9|10|11|12|13|14", "4-6")
			GUICtrlSetOnEvent(-1, "CmbABTH")
		$g_ahPicABMaxTH[6] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV06, $x + 137, $y - 3, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState (-1, $GUI_SHOW)
		$g_ahPicABMaxTH[7] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV07, $x + 137, $y - 3, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState (-1, $GUI_HIDE)
		$g_ahPicABMaxTH[8] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV08, $x + 137, $y - 3, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState (-1, $GUI_HIDE)
		$g_ahPicABMaxTH[9] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV09, $x + 137, $y - 3, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState (-1, $GUI_HIDE)
		$g_ahPicABMaxTH[10] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV10, $x + 137, $y - 3, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState (-1, $GUI_HIDE)
		$g_ahPicABMaxTH[11] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV11, $x + 137, $y - 3, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState (-1, $GUI_HIDE)
		$g_ahPicABMaxTH[12] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV12, $x + 137, $y - 3, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState (-1, $GUI_HIDE)
		$g_ahPicABMaxTH[13] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV13, $x + 137, $y - 3, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState (-1, $GUI_HIDE)
		$g_ahPicABMaxTH[14] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV14, $x + 137, $y - 3, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState (-1, $GUI_HIDE)

	$y += 24
		$g_hchkRankedBattleMeetTHO = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "ChkMeetTHO", "Townhall Outside"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "ChkMeetTHO_Info_01", "Search for a base that has an exposed Townhall. (Outside of Walls)"))
	$y += 24

	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "Group_03", -1), $x, $y, 215, 120)
	$x += 5
	$y += 20
	Local $xStartColumn = $x, $yStartColumn = $y
		$g_ahChkMaxMortar[$RankedBattle] = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "ChkMaxMortar", -1))
			GUICtrlSetOnEvent(-1, "chkRankedBattleWeakBase")
		$g_ahCmbWeakMortar[$RankedBattle] = GUICtrlCreateCombo("", $x + 19, $y, 52, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "CmbMaxMortar_Info_01", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetData(-1, "-|Lvl 1|Lvl 2|Lvl 3|Lvl 4|Lvl 5|Lvl 6|Lvl 7|Lvl 8|Lvl 9|Lvl 10|Lvl 11|Lvl 12|Lvl 13", "Lvl 5")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahPicWeakMortar[$RankedBattle] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnMortar, $x + 75, $y - 2, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)

	$y += 24
		$g_ahChkMaxWizTower[$RankedBattle] = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "ChkMaxWizTower", -1))
			GUICtrlSetOnEvent(-1, "chkRankedBattleWeakBase")
		$g_ahCmbWeakWizTower[$RankedBattle] = GUICtrlCreateCombo("", $x + 19, $y, 52, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "CmbMaxWizTower_Info_01", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetData(-1, "-|Lvl 1|Lvl 2|Lvl 3|Lvl 4|Lvl 5|Lvl 6|Lvl 7|Lvl 8|Lvl 9|Lvl 10|Lvl 11|Lvl 12|Lvl 13", "Lvl 4")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahPicWeakWizTower[$RankedBattle] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnWizTower, $x + 75, $y - 2, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)

	$y += 24
		$g_ahChkMaxAirDefense[$RankedBattle] = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "ChkMaxAirDefense", -1))
			GUICtrlSetOnEvent(-1, "chkRankedBattleWeakBase")
		$g_ahCmbWeakAirDefense[$RankedBattle] = GUICtrlCreateCombo("", $x + 19, $y, 53, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "CmbMaxAirDefense_Info_01", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetData(-1, "-|Lvl 1|Lvl 2|Lvl 3|Lvl 4|Lvl 5|Lvl 6|Lvl 7|Lvl 8|Lvl 9|Lvl 10|Lvl 11|Lvl 12", "Lvl 7")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahPicWeakAirDefense[$RankedBattle] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnAirdefense, $x + 75, $y - 2, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)

	$y += 24
		$g_ahChkMaxScatter[$RankedBattle] = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "ChkMaxScatter", -1))
			GUICtrlSetOnEvent(-1, "chkRankedBattleWeakBase")
		$g_ahCmbWeakScatter[$RankedBattle] = GUICtrlCreateCombo("", $x + 19, $y, 53, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "CmbMaxScatter_Info_01", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetData(-1, "-|Lvl 1|Lvl 2|Lvl 3", "Lvl 1")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahPicWeakScatter[$RankedBattle] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnScattershot, $x + 75, $y - 2, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)

	$x = $xStartColumn + 104
	$y = $yStartColumn
		$g_ahChkMaxXBow[$RankedBattle] = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "ChkMaxXBow", -1))
			GUICtrlSetOnEvent(-1, "chkRankedBattleWeakBase")
		$g_ahCmbWeakXBow[$RankedBattle] = GUICtrlCreateCombo("", $x + 19, $y, 50, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "CmbMaxXBow_Info_01", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetData(-1, "-|Lvl 1|Lvl 2|Lvl 3|Lvl 4|Lvl 5|Lvl 6|Lvl 7|Lvl 8", "Lvl 2")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahPicWeakXBow[$RankedBattle] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnXBow3, $x + 75, $y - 2, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)

	$y += 24
		$g_ahChkMaxInferno[$RankedBattle] = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "ChkMaxInferno", -1))
			GUICtrlSetOnEvent(-1, "chkRankedBattleWeakBase")
		$g_ahCmbWeakInferno[$RankedBattle] = GUICtrlCreateCombo("", $x + 19, $y, 50, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "CmbMaxInferno_Info_01", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetData(-1, "-|Lvl 1|Lvl 2|Lvl 3|Lvl 4|Lvl 5|Lvl 6|Lvl 7|Lvl 8", "Lvl 2")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahPicWeakInferno[$RankedBattle] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnInferno4, $x + 75, $y - 2, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)

	$y += 24
		$g_ahChkMaxEagle[$RankedBattle] = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "ChkMaxEagle", -1))
			GUICtrlSetOnEvent(-1, "chkRankedBattleWeakBase")
		$g_ahCmbWeakEagle[$RankedBattle] = GUICtrlCreateCombo("", $x + 19, $y, 50, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "CmbMaxEagle_Info_01", -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetData(-1, "-|Lvl 1|Lvl 2|Lvl 3|Lvl 4|Lvl 5", "Lvl 1")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_ahPicWeakEagle[$RankedBattle] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnEagleArt, $x + 75, $y - 2, 24, 24)
			_GUICtrlSetTip(-1, $sTxtTip)

	$y += 44
	$y += 24
	$x = $xStartColumn
		$g_ahChkMeetOne[$RankedBattle] = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "ChkMeetOne", -1), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design CSV Mod Search", "ChkMeetOne_Info_01", -1))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateAttackSearchActiveBaseSearch
