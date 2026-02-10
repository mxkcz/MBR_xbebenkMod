; #FUNCTION# ====================================================================================================================
; Name ..........: CreateCSVModVectorTab
; Description ...: Creates vector and MAKE line editor controls.
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: mxkcz
; Modified ......: mxkcz
; Remarks .......: This file is part of MyBotRun. Copyright 2016
; Related .......:
; Link ..........:
; Example .......:
; =====================================================================================================================
Func CreateCSVModVectorTab()
	Local $x = 0, $y = 0, $w = 0, $h = 0
	CSVMod_GetContentBounds($x, $y, $w, $h)
	Local $sCSVVectorList = "A|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z"
	Local $sCSVTargetBuildings = "PRIO|TOWNHALL|EAGLE|INFERNO|XBOW|WIZTOWER|SUPERWIZTW|MORTAR|AIRDEFENSE|SWEEPER|MONOLITH|FIRESPITTER|MULTIARCHER|MULTIGEAR|RICOCHETCA|SCATTER|REVENGETW|EX-WALL|IN-WALL"

	GUICtrlCreateGroup("Targeted vectors", $x, $y, $w, 170)
		$g_hCmbCSVVectorId = GUICtrlCreateCombo("", $x + 10, $y + 20, 60, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, $sCSVVectorList, "A")
			GUICtrlSetOnEvent(-1, "CSVVectorSelect")
		GUICtrlCreateLabel("Side", $x + 80, $y + 22, 40, 18)
		$g_hCmbCSVVectorSide = GUICtrlCreateCombo("", $x + 120, $y + 20, 120, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "FRONT-LEFT|FRONT-RIGHT|RIGHT-FRONT|RIGHT-BACK|LEFT-FRONT|LEFT-BACK|BACK-LEFT|BACK-RIGHT|RANDOM", "FRONT-LEFT")
			GUICtrlSetOnEvent(-1, "CSVVectorUpdate")
		GUICtrlCreateLabel("Points", $x + 250, $y + 22, 45, 18)
		$g_hInpCSVPointCount = GUICtrlCreateInput("1", $x + 295, $y + 20, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
			GUICtrlSetOnEvent(-1, "CSVVectorUpdate")
		GUICtrlCreateLabel("Offset", $x + 345, $y + 22, 45, 18)
		$g_hInpCSVOffsetTiles = GUICtrlCreateInput("0", $x + 390, $y + 20, 35, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
			GUICtrlSetOnEvent(-1, "CSVVectorUpdate")

		$g_hChkCSVVectorTargeted = GUICtrlCreateCheckbox("Building targeted", $x + 10, $y + 50, 130, 18)
			GUICtrlSetOnEvent(-1, "CSVVectorUpdate")
		$g_hCmbCSVTargetBuilding = GUICtrlCreateCombo("", $x + 150, $y + 48, 120, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, $sCSVTargetBuildings, "TOWNHALL")
			GUICtrlSetOnEvent(-1, "CSVVectorUpdate")
		GUICtrlCreateLabel("Drop order", $x + 280, $y + 50, 70, 18)
		$g_hCmbCSVVectorVersus = GUICtrlCreateCombo("", $x + 350, $y + 48, 80, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "IN|OUT|BOTH|RANDOM", "IN")
			GUICtrlSetOnEvent(-1, "CSVVectorUpdate")

		GUICtrlCreateLabel("Rand X", $x + 10, $y + 78, 45, 18)
		$g_hInpCSVRandomX = GUICtrlCreateInput("0", $x + 60, $y + 76, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
			GUICtrlSetOnEvent(-1, "CSVVectorUpdate")
		GUICtrlCreateLabel("Rand Y", $x + 110, $y + 78, 45, 18)
		$g_hInpCSVRandomY = GUICtrlCreateInput("0", $x + 160, $y + 76, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
			GUICtrlSetOnEvent(-1, "CSVVectorUpdate")

		$g_hLblCSVVectorEditInfo = GUICtrlCreateLabel("Editing MAKE line: A", $x + 210, $y + 76, 180, 18)
		$g_hTxtCSVVectorRow = GUICtrlCreateInput("", $x + 10, $y + 100, $w - 20, 20, BitOR($ES_READONLY, $ES_AUTOHSCROLL))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 180
	GUICtrlCreateGroup("PRIO preview (top 3 per side)", $x, $y, $w, $g_iSizeHGrpTab1 - $y - 10)
		$g_hTxtCSVPrioPreview = GUICtrlCreateEdit("", $x + 10, $y + 20, $w - 20, $g_iSizeHGrpTab1 - $y - 35, BitOR($ES_READONLY, $WS_VSCROLL))
	GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc   ;==>CreateCSVModVectorTab
