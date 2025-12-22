; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Attack Plan" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GKevinOD (2014)
; Modified ......: DkEd, Hervidero (2015), CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hGUI_ATTACK = 0
Global $g_hGUI_ATTACK_TAB = 0, $g_hGUI_ATTACK_TAB_ITEM1 = 0, $g_hGUI_ATTACK_TAB_ITEM2 = 0, $g_hGUI_ATTACK_TAB_ITEM3 = 0
Global $g_hGUI_DropOrder = 0
Global $g_hGUI_AttackCSVSettings = 0, $g_hAttackCSVSettingsTab = 0, $g_hBtnAttackCSVSettingsClose = 0

#include "MBR GUI Design Child Attack - Troops.au3"
#include "MBR GUI Design Child Attack - Search.au3"
#include "MBR GUI Design Child Attack - Strategies.au3"

;Func LoadTranslatedDropOrderList()
;	Global $g_asDropOrderList = ["", _
;		"Barbarians", "Super Barbarians", "Archers", "Super Archers", "Giants", "Super Giants", "Goblins", "Sneaky Goblins", "Wall Breakers", _
;		"Super Wall Breakers", "Balloons", "Rocket Balloons", "Wizards", "Super Wizards", "Healers", "Dragons", "Super Dragon", _
;		"Pekkas", "Baby Dragons", "Inferno Dragons", "Miners", "Super Miners", "Electro Dragons", "Yetis", "Dragon Riders", "Electro Titans", _
;		"Minions", "Super Minions", "Hog Riders", "Valkyries", "Super Valkyries", "Golems", "Witches", "Super Witches", "Lava Hounds", _
;		"Ice Hounds", "Bowlers", "Super Bowlers", "Ice Golems", "Headhunters", _
;		"Giant Skeleton", "Royal Ghost", "Party Wizard", "Ice Wizard", "Clan Castle", "Heroes"]
;EndFunc   ;==>LoadTranslatedDropOrderList

Global $g_hChkCustomDropOrderEnable = 0
Global $g_ahCmbDropOrder[10] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_ahImgDropOrder[10] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hBtnDropOrderSet = 0, $g_ahImgDropOrderSet = 0
Global $g_hBtnRemoveDropOrder = 0
Global $g_hCmbCSVForceSide = 0, $g_ahCSVSideWeightInputs[7] = [0, 0, 0, 0, 0, 0, 0], $g_ahCSVSideWeightSpin[7] = [0, 0, 0, 0, 0, 0, 0]
Global $g_ahCSVSideBWeightInputs[14] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], $g_ahCSVSideBWeightSpin[14] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hCmbCSVVectorId = 0, $g_hChkCSVVectorTargeted = 0, $g_hCmbCSVTargetBuilding = 0, $g_hCmbCSVPointCount = 0, $g_hInpCSVOffsetTiles = 0, $g_hChkCSVRandomDropSide = 0
Global $g_hInpCSVIndexMin = 0, $g_hInpCSVIndexMax = 0, $g_hInpCSVQtyMin = 0, $g_hInpCSVQtyMax = 0, $g_hInpCSVDelayPointMin = 0, $g_hInpCSVDelayPointMax = 0, $g_hInpCSVDelayDropMin = 0, $g_hInpCSVDelayDropMax = 0, $g_hInpCSVDelaySleepMin = 0, $g_hInpCSVDelaySleepMax = 0, $g_hChkCSVDropRemaining = 0
Global $g_hInpCSVWaitMin = 0, $g_hInpCSVWaitMax = 0, $g_hChkCSVBreakTH = 0, $g_hChkCSVBreakSiege = 0, $g_hChkCSVBreak50 = 0, $g_hChkCSVBreakAQ = 0, $g_hChkCSVBreakBK = 0, $g_hChkCSVBreakGW = 0, $g_hChkCSVBreakRC = 0, $g_hChkCSVBreakAnyHero = 0
Global $g_asCSVSearchNames[23] = ["Mines", "Elixir Collectors", "Dark Drills", "Gold Storage", "Elixir Storage", "Dark Storage", "Town Hall", "Eagle", "Inferno", "X-Bow", "Wizard Tower", "Super Wizard Tower", "Mortar", "Air Defense", "Scattershot", "Sweeper", "Monolith", "Fire Spitter", "Multi Archer Tower", "Multi Gear Tower", "Ricochet Cannon", "Revenge Tower", "Walls"]
Global $g_ahCSVSearchToggles[23] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hBtnCSVSearchAll = 0, $g_hBtnCSVSearchNone = 0, $g_hBtnCSVSearchResources = 0, $g_hBtnCSVSearchDefenses = 0
Global $g_hCmbCSVFlexTroop = 0, $g_ahCSVHeroAbilityMode[4] = [0, 0, 0, 0], $g_ahCSVHeroAbilityDelay[4] = [0, 0, 0, 0]
Global $g_hCmbCSVRedlinePreset = 0, $g_hCmbCSVDroplinePreset = 0, $g_hTxtCSVCCRequest = 0
Global $g_hLblCSVSidePreview = 0
Global $g_hBtnAttackCSVSettingsCloseTop = 0

Func CreateAttackTab()
	$g_hGUI_ATTACK = _GUICreate("", $g_iSizeWGrpTab1, $g_iSizeHGrpTab1, $_GUI_CHILD_LEFT, $_GUI_CHILD_TOP, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hFrmBotEx)
	;GUISetBkColor($COLOR_WHITE, $g_hGUI_ATTACK)

	CreateAttackTroops()
	CreateAttackSearch()
	CreateAttackStrategies()
	CreateAttackCSVSettingsGUI()

	GUISwitch($g_hGUI_ATTACK)
	$g_hGUI_ATTACK_TAB = GUICtrlCreateTab(0, 0, $g_iSizeWGrpTab1, $g_iSizeHGrpTab1, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))
	$g_hGUI_ATTACK_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_01", "Train Army"))
	$g_hGUI_ATTACK_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_02", "Search && Attack"))
	$g_hGUI_ATTACK_TAB_ITEM3 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_03", "Strategies"))

	; needed to init the window now, like if it's a tab
	CreateDropOrderGUI()

	GUICtrlCreateTabItem("")

EndFunc   ;==>CreateAttackTab

Func CreateDropOrderGUI()

	$g_hGUI_DropOrder = _GUICreate(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "GUI_DropOrder", "Attack Custom Dropping Order"), $_GUI_MAIN_WIDTH - 100, $_GUI_MAIN_HEIGHT - 340, $g_iFrmBotPosX, $g_iFrmBotPosY + 80, $WS_DLGFRAME, -1, $g_hFrmBot)
	SetDefaultDropOrderGroup(False)
	;LoadTranslatedDropOrderList()

	Local $x = 25, $y = 25
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Group_03", "Custom Dropping Order"), $x - 20, $y - 20, 360, 300)
	$x += 10
	$y += 20

		$g_hChkCustomDropOrderEnable = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "ChkCustomDropOrderEnable", "Enable Custom Dropping Order"), $x - 13, $y - 22, -1, -1)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "ChkCustomDropOrderEnable_Info_01", "Enable to select a custom troops dropping order") & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "ChkCustomDropOrderEnable_Info_02", "Will not have effect on CSV Scripted Attack! It's only for Standard Attack.") & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "ChkCustomDropOrderEnable_Info_03", "For Live and Dead Bases"))
			GUICtrlSetOnEvent(-1, "chkDropOrder")

		; Create translated list of Troops for combo box
		Local $sComboData = ""
		For $j = 0 To UBound($g_asDropOrderNames) - 1
			$sComboData &= $g_asDropOrderNames[$j] & "|"
		Next

		Local $g_hTxtDropOrder = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "TxtDropOrder", "Enter sequence order for drop of troop #")

	$y += 5
		For $p = 0 To UBound($g_ahCmbDropOrder) - 1
			;If $p < 9 Then
				GUICtrlCreateLabel($p + 1 & ":", $x - 19, $y + 3, -1, 18)
				$g_ahCmbDropOrder[$p] = GUICtrlCreateCombo("", $x, $y, 120, 18, BitOR($CBS_DROPDOWNLIST + $WS_VSCROLL, $CBS_AUTOHSCROLL))
					GUICtrlSetOnEvent(-1, "GUIDropOrder")
					GUICtrlSetData(-1, $sComboData, "")
					_GUICtrlSetTip(-1, $g_hTxtDropOrder & $p + 1)
					GUICtrlSetState(-1, $GUI_DISABLE)
				$g_ahImgDropOrder[$p] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnOptions, $x + 122, $y + 1, 18, 18)
				$y += 25 ; move down to next combobox location
		Next

	$x = 210
	$y = 150
		; Create push button to set training order once completed
		$g_hBtnDropOrderSet = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "BtnDropOrderSet", "Apply New Order"), $x, $y, 100, 25)
			GUICtrlSetState(-1, BitOR($GUI_UNCHECKED, $GUI_ENABLE))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "BtnDropOrderSet_Info_01", "Push button when finished selecting custom troops dropping order") & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "BtnDropOrderSet_Info_02", "When not all troop slots are filled, will use random troop order in empty slots!"))
			GUICtrlSetOnEvent(-1, "BtnDropOrderSet")
		$g_ahImgDropOrderSet = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSilverStar, $x + 104, $y + 4, 18, 18)

	$y += 30
		$g_hBtnRemoveDropOrder = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "BtnRemoveDropOrder", "Empty Drop List"), $x, $y, 100, 25)
			GUICtrlSetState(-1, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "BtnRemoveDropOrder_Info_01", "Push button to remove all troops from list and start over"))
			GUICtrlSetOnEvent(-1, "BtnRemoveDropOrder")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 80
	; Create a button control.
	Local $g_hBtnClose = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "BtnClose", "Close"), $x + 33, $y, 85, 25)
		GUICtrlSetOnEvent(-1, "CloseCustomDropOrder")

EndFunc   ;==>CreateDropOrderGUI

Func CreateAttackCSVSettingsGUI()
	Local $iDesiredWidth = ($_GUI_MAIN_WIDTH < 1150) ? 1150 : $_GUI_MAIN_WIDTH ; widen to fit wide control groups
	Local $iGuiWidth = $iDesiredWidth - 40
	$g_hGUI_AttackCSVSettings = _GUICreate(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "GUI_AttackCSVSettings", "Attack CSV Settings"), $iGuiWidth, $_GUI_MAIN_HEIGHT - 150, $g_iFrmBotPosX + 10, $g_iFrmBotPosY + 70, $WS_DLGFRAME, -1, $g_hFrmBot)
	GUISetOnEvent($GUI_EVENT_CLOSE, "CloseAttackCSVSettings", $g_hGUI_AttackCSVSettings)
	Local $iTabWidth = $iGuiWidth - 30, $iTabHeight = $_GUI_MAIN_HEIGHT - 200
	Local $x = 25, $y = 40
	$g_hAttackCSVSettingsTab = GUICtrlCreateTab(10, 10, $iTabWidth, $iTabHeight, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))

	; ---- Tab 1: Side weighting & forcing ----
	GUICtrlCreateTabItem(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Tab_AttackCSVSettings_Side", "Side Weights"))
		GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Group_AttackCSVSettings_ForceSide", "Forced side"), $x - 10, $y - 15, 320, 70)
			$g_hCmbCSVForceSide = GUICtrlCreateCombo("", $x, $y, 220, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, "Auto (weight-based)|TOP-LEFT|TOP-RIGHT|BOTTOM-LEFT|BOTTOM-RIGHT|TOP-RAND", "Auto (weight-based)")
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb_AttackCSVSettings_ForceSide_Info", "Matches SIDE/SIDEB value8. TOP-RAND randomizes left/right on top."))
		GUICtrlCreateGroup("", -99, -99, 1, 1)

		; SIDE weights (resource focus)
		GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Group_AttackCSVSettings_SideWeights", "SIDE weights (resource)"), $x - 10, $y + 65, 320, 200)
			Local $aSideWeightNames[7] = ["Gold Mines", "Elixir Collectors", "Dark Drills", "Gold Storage", "Elixir Storage", "Dark Storage", "Town Hall"]
			For $i = 0 To UBound($aSideWeightNames) - 1
				Local $iRow = Mod($i, 4), $iCol = Int($i / 4)
				Local $iOffsetX = $x + ($iCol * 150), $iOffsetY = ($y + 90) + ($iRow * 30)
				GUICtrlCreateLabel($aSideWeightNames[$i] & ":", $iOffsetX, $iOffsetY + 4, 95, 18)
				$g_ahCSVSideWeightInputs[$i] = GUICtrlCreateInput("0", $iOffsetX + 100, $iOffsetY, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
				$g_ahCSVSideWeightSpin[$i] = GUICtrlCreateUpdown($g_ahCSVSideWeightInputs[$i])
					GUICtrlSetLimit(-1, 99, 0)
			Next
		GUICtrlCreateGroup("", -99, -99, 1, 1)

		; SIDEB weights (defense focus, incl. new defenses)
		GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Group_AttackCSVSettings_SideBWeights", "SIDEB weights (defenses)"), $x + 330, $y - 15, 400, 270)
			Local $aSideBWeightNames[14] = ["Eagle", "Inferno", "X-Bow", "Wizard Tower/Super Wiz", "Mortar", "Air Defense", "Scattershot", "Sweeper", "Monolith", "Fire Spitter", "Multi Archer", "Multi Gear", "Ricochet Cannon", "Revenge Tower"]
			For $j = 0 To UBound($aSideBWeightNames) - 1
				Local $iRowB = Mod($j, 7), $iColB = Int($j / 7)
				Local $iOffsetXB = $x + 340 + ($iColB * 190), $iOffsetYB = ($y + 10) + ($iRowB * 30)
				GUICtrlCreateLabel($aSideBWeightNames[$j] & ":", $iOffsetXB, $iOffsetYB + 4, 120, 18)
				$g_ahCSVSideBWeightInputs[$j] = GUICtrlCreateInput("0", $iOffsetXB + 125, $iOffsetYB, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
				$g_ahCSVSideBWeightSpin[$j] = GUICtrlCreateUpdown($g_ahCSVSideBWeightInputs[$j])
					GUICtrlSetLimit(-1, 99, 0)
			Next
		GUICtrlCreateGroup("", -99, -99, 1, 1)

	; ---- Tab 2: Vectors ----
	GUICtrlCreateTabItem(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Tab_AttackCSVSettings_Vector", "Vectors"))
		$x = 25
		$y = 60
		GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Group_AttackCSVSettings_Targeted", "Targeted vectors"), $x - 10, $y - 20, 720, 130)
			$g_hCmbCSVVectorId = GUICtrlCreateCombo("", $x, $y, 60, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, "A|B|C|D|E|F|G|H|I|J", "A")
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb_AttackCSVSettings_VectorId_Info", "MAKE/DROP vector letter"))
				GUICtrlSetOnEvent(-1, "CSVVectorSelect")
			$g_hChkCSVVectorTargeted = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk_AttackCSVSettings_Targeted", "Building targeted (MAKE value8)"), $x + 80, $y - 2, 190, 20)
				GUICtrlSetState(-1, $GUI_CHECKED)
			$g_hCmbCSVTargetBuilding = GUICtrlCreateCombo("", $x + 280, $y - 2, 150, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, "TOWNHALL|EAGLE|INFERNO|XBOW|WIZTOWER|SUPERWIZTW|MORTAR|AIRDEFENSE|SWEEPER|MONOLITH|FIRESPITTER|MULTIARCHER|MULTIGEAR|RICOCHETCA|SCATTER|REVENGETW|EX-WALL|IN-WALL", "TOWNHALL")
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb_AttackCSVSettings_TargetBuilding_Info", "Matches MakeTargetDropPoints value8 list"))
			$g_hCmbCSVPointCount = GUICtrlCreateCombo("", $x + 450, $y - 2, 60, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, "1|5", "5")
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb_AttackCSVSettings_PointCount_Info", "DROP point count (MAKE value3)"))
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Lbl_AttackCSVSettings_Offset", "Offset tiles"), $x + 520, $y, 65, 18)
			$g_hInpCSVOffsetTiles = GUICtrlCreateInput("0", $x + 590, $y - 2, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
			$g_hChkCSVRandomDropSide = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk_AttackCSVSettings_RandomSide", "Random drop side (MAKE RANDOM)"), $x, $y + 30, 220, 20)
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk_AttackCSVSettings_RandomSide_Info", "MAKE RANDOM helper for quadrant selection"))
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Lbl_AttackCSVSettings_Targeted_Todo", "TODO: Bind to MAKE/DROP editor to push values into CSV"), $x, $y + 60, 500, 18)
		GUICtrlCreateGroup("", -99, -99, 1, 1)

	; ---- Tab 3: Drops & Wait ----
	GUICtrlCreateTabItem(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Tab_AttackCSVSettings_Drops", "Drops && Wait"))
		$x = 25
		$y = 60
		GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Group_AttackCSVSettings_DropRange", "DROP ranges && leftovers"), $x - 10, $y - 20, 360, 190)
			GUICtrlCreateLabel("Index min/max", $x, $y, 90, 18)
			$g_hInpCSVIndexMin = GUICtrlCreateInput("1", $x + 95, $y - 2, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
			$g_hInpCSVIndexMax = GUICtrlCreateInput("5", $x + 140, $y - 2, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
			GUICtrlCreateLabel("Qty min/max", $x, $y + 25, 90, 18)
			$g_hInpCSVQtyMin = GUICtrlCreateInput("1", $x + 95, $y + 23, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
			$g_hInpCSVQtyMax = GUICtrlCreateInput("5", $x + 140, $y + 23, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
			GUICtrlCreateLabel("Delay point ms", $x, $y + 50, 90, 18)
			$g_hInpCSVDelayPointMin = GUICtrlCreateInput("0", $x + 95, $y + 48, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
			$g_hInpCSVDelayPointMax = GUICtrlCreateInput("0", $x + 140, $y + 48, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
			GUICtrlCreateLabel("Delay drop ms", $x, $y + 75, 90, 18)
			$g_hInpCSVDelayDropMin = GUICtrlCreateInput("0", $x + 95, $y + 73, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
			$g_hInpCSVDelayDropMax = GUICtrlCreateInput("0", $x + 140, $y + 73, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
			GUICtrlCreateLabel("Sleep after drop ms", $x, $y + 100, 110, 18)
			$g_hInpCSVDelaySleepMin = GUICtrlCreateInput("0", $x + 125, $y + 98, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
			$g_hInpCSVDelaySleepMax = GUICtrlCreateInput("0", $x + 170, $y + 98, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
			$g_hChkCSVDropRemaining = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk_AttackCSVSettings_DropRemain", "Drop remaining troops (REMAIN)"), $x, $y + 130, 240, 20)
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Lbl_AttackCSVSettings_DropRange_Todo", "TODO: map to DROP line builder"), $x, $y + 155, 250, 18)
		GUICtrlCreateGroup("", -99, -99, 1, 1)

		GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Group_AttackCSVSettings_Wait", "WAIT && break conditions"), $x + 380, $y - 20, 360, 190)
			GUICtrlCreateLabel("Wait ms min/max", $x + 390, $y, 100, 18)
			$g_hInpCSVWaitMin = GUICtrlCreateInput("0", $x + 495, $y - 2, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
			$g_hInpCSVWaitMax = GUICtrlCreateInput("0", $x + 550, $y - 2, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
			$g_hChkCSVBreakTH = GUICtrlCreateCheckbox("Break on Town Hall destroy", $x + 390, $y + 25, 200, 20)
			$g_hChkCSVBreakSiege = GUICtrlCreateCheckbox("Break when Siege drops", $x + 390, $y + 50, 200, 20)
			$g_hChkCSVBreak50 = GUICtrlCreateCheckbox("Break at 50% damage", $x + 390, $y + 75, 200, 20)
			$g_hChkCSVBreakAQ = GUICtrlCreateCheckbox("Trigger AQ ability", $x + 390, $y + 100, 140, 20)
			$g_hChkCSVBreakBK = GUICtrlCreateCheckbox("Trigger BK ability", $x + 390, $y + 125, 140, 20)
			$g_hChkCSVBreakGW = GUICtrlCreateCheckbox("Trigger GW ability", $x + 560, $y + 100, 140, 20)
			$g_hChkCSVBreakRC = GUICtrlCreateCheckbox("Trigger RC ability", $x + 560, $y + 125, 140, 20)
			$g_hChkCSVBreakAnyHero = GUICtrlCreateCheckbox("Any hero ability combo", $x + 390, $y + 150, 200, 20)
			GUICtrlCreateLabel("TODO: align with WAIT ranges & combo parsing", $x + 390, $y + 175, 250, 18)
		GUICtrlCreateGroup("", -99, -99, 1, 1)

	; ---- Tab 4: Search toggles & settings ----
	GUICtrlCreateTabItem(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Tab_AttackCSVSettings_Search", "Search && Settings"))
		$x = 25
		$y = 60
		GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Group_AttackCSVSettings_Search", "CSV building detection limits"), $x - 10, $y - 20, 420, 220)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Group_AttackCSVSettings_Search_Info", "Unchecked buildings are skipped for SIDE/SIDEB priority detection. MAKE targets remain enabled."))
			$g_hBtnCSVSearchAll = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Btn_AttackCSVSettings_SearchAll", "All"), $x, $y - 2, 60, 20)
				GUICtrlSetOnEvent(-1, "CSVSearchSelectAll")
			$g_hBtnCSVSearchNone = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Btn_AttackCSVSettings_SearchNone", "None"), $x + 70, $y - 2, 60, 20)
				GUICtrlSetOnEvent(-1, "CSVSearchSelectNone")
			$g_hBtnCSVSearchResources = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Btn_AttackCSVSettings_SearchResources", "Resources"), $x + 140, $y - 2, 90, 20)
				GUICtrlSetOnEvent(-1, "CSVSearchSelectResources")
			$g_hBtnCSVSearchDefenses = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Btn_AttackCSVSettings_SearchDefenses", "Defenses"), $x + 240, $y - 2, 90, 20)
				GUICtrlSetOnEvent(-1, "CSVSearchSelectDefenses")
			Local $iSearchStartY = $y + 22
			For $k = 0 To UBound($g_asCSVSearchNames) - 1
				Local $iRowSearch = Mod($k, 8), $iColSearch = Int($k / 8)
				Local $iOffsetXSearch = $x + ($iColSearch * 140), $iOffsetYSearch = $iSearchStartY + ($iRowSearch * 25)
				$g_ahCSVSearchToggles[$k] = GUICtrlCreateCheckbox($g_asCSVSearchNames[$k], $iOffsetXSearch, $iOffsetYSearch, 130, 18)
				GUICtrlSetOnEvent(-1, "CSVSearchToggle")
			Next
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Lbl_AttackCSVSettings_Search_Note", "Tip: keep only the buildings you want to prioritize."), $x, $y + 195, 380, 18)
		GUICtrlCreateGroup("", -99, -99, 1, 1)

		GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Group_AttackCSVSettings_Automation", "CSV settings automation"), $x + 430, $y - 20, 320, 220)
			GUICtrlCreateLabel("Flex troop (col 3)", $x + 440, $y, 110, 18)
			$g_hCmbCSVFlexTroop = GUICtrlCreateCombo("", $x + 560, $y - 2, 170, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				If IsArray($g_asTroopNames) Then
					Local $sFlexTroopList = ""
					For $iFlex = 0 To UBound($g_asTroopNames) - 1
						$sFlexTroopList &= $g_asTroopNames[$iFlex] & "|"
					Next
					$sFlexTroopList = StringTrimRight($sFlexTroopList, 1)
					GUICtrlSetData(-1, $sFlexTroopList)
				EndIf
			GUICtrlCreateLabel("Hero ability mode/delay (s)", $x + 440, $y + 30, 170, 18)
			Local $aHeroNames[4] = ["BK", "AQ", "GW", "RC"]
			For $h = 0 To 3
				Local $iOffsetYHero = $y + 55 + ($h * 25)
				GUICtrlCreateLabel($aHeroNames[$h], $x + 440, $iOffsetYHero + 2, 20, 18)
				$g_ahCSVHeroAbilityMode[$h] = GUICtrlCreateCombo("", $x + 470, $iOffsetYHero, 90, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
					GUICtrlSetData(-1, "Auto|Manual|Both|Off", "Auto")
				$g_ahCSVHeroAbilityDelay[$h] = GUICtrlCreateInput("0", $x + 565, $iOffsetYHero, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
			Next
			GUICtrlCreateLabel("Redline preset", $x + 440, $y + 160, 90, 18)
			$g_hCmbCSVRedlinePreset = GUICtrlCreateCombo("", $x + 540, $y + 158, 190, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, "ImgLoc Raw Redline|ImgLoc Redline Drop Points|Original Redline|External Edges", "ImgLoc Raw Redline")
			GUICtrlCreateLabel("Dropline preset", $x + 440, $y + 185, 90, 18)
			$g_hCmbCSVDroplinePreset = GUICtrlCreateCombo("", $x + 540, $y + 183, 190, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, "Drop line fix outer corner|Drop line fist Redline point|Full Drop line fix outer corner|Full Drop line fist Redline point|No Drop line", "Drop line fix outer corner")
			GUICtrlCreateLabel("CC request text", $x + 440, $y + 210, 100, 18)
			$g_hTxtCSVCCRequest = GUICtrlCreateInput("", $x + 540, $y + 208, 190, 18)
			GUICtrlCreateLabel("TODO: push settings into ParseAttackCSV_Settings_variables", $x + 440, $y + 235, 280, 18)
		GUICtrlCreateGroup("", -99, -99, 1, 1)

	; ---- Tab 5: Preview ----
	GUICtrlCreateTabItem(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Tab_AttackCSVSettings_Preview", "Vector preview"))
		$x = 25
		$y = 60
		GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Group_AttackCSVSettings_Preview", "MAINSIDE vector mapping"), $x - 10, $y - 20, 740, 260)
			Local $sPreview = "BOTTOM-RIGHT:" & @CRLF & " FRONT_LEFT=BOTTOM-RIGHT-DOWN, FRONT_RIGHT=BOTTOM-RIGHT-UP" & @CRLF & " RIGHT_FRONT=TOP-RIGHT-DOWN, RIGHT_BACK=TOP-RIGHT-UP" & @CRLF & " LEFT_FRONT=BOTTOM-LEFT-DOWN, LEFT_BACK=BOTTOM-LEFT-UP" & @CRLF & " BACK_LEFT=TOP-LEFT-DOWN, BACK_RIGHT=TOP-LEFT-UP" & @CRLF & @CRLF & _
							  "BOTTOM-LEFT:" & @CRLF & " FRONT_LEFT=BOTTOM-LEFT-UP, FRONT_RIGHT=BOTTOM-LEFT-DOWN" & @CRLF & " RIGHT_FRONT=BOTTOM-RIGHT-DOWN, RIGHT_BACK=BOTTOM-RIGHT-UP" & @CRLF & " LEFT_FRONT=TOP-LEFT-DOWN, LEFT_BACK=TOP-LEFT-UP" & @CRLF & " BACK_LEFT=TOP-RIGHT-UP, BACK_RIGHT=TOP-RIGHT-DOWN" & @CRLF & @CRLF & _
							  "TOP-LEFT:" & @CRLF & " FRONT_LEFT=TOP-LEFT-UP, FRONT_RIGHT=TOP-LEFT-DOWN" & @CRLF & " RIGHT_FRONT=BOTTOM-LEFT-UP, RIGHT_BACK=BOTTOM-LEFT-DOWN" & @CRLF & " LEFT_FRONT=TOP-RIGHT-UP, LEFT_BACK=TOP-RIGHT-DOWN" & @CRLF & " BACK_LEFT=BOTTOM-RIGHT-UP, BACK_RIGHT=BOTTOM-RIGHT-DOWN" & @CRLF & @CRLF & _
							  "TOP-RIGHT:" & @CRLF & " FRONT_LEFT=TOP-RIGHT-DOWN, FRONT_RIGHT=TOP-RIGHT-UP" & @CRLF & " RIGHT_FRONT=TOP-LEFT-UP, RIGHT_BACK=TOP-LEFT-DOWN" & @CRLF & " LEFT_FRONT=BOTTOM-RIGHT-UP, LEFT_BACK=BOTTOM-RIGHT-DOWN" & @CRLF & " BACK_LEFT=BOTTOM-LEFT-DOWN, BACK_RIGHT=BOTTOM-LEFT-UP"
			$g_hLblCSVSidePreview = GUICtrlCreateEdit($sPreview, $x + 5, $y, 715, 210, BitOR($ES_MULTILINE, $WS_VSCROLL))
				GUICtrlSetState(-1, $GUI_DISABLE)
				GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Lbl_AttackCSVSettings_Preview", "Reference for MAKE/DROP vector names derived from MAINSIDE/forced side."), $x + 5, $y + 215, 620, 18)
		GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateTabItem("")

	$g_hBtnAttackCSVSettingsClose = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Btn_AttackCSVSettings_Close", "Close"), $iTabWidth - 60, $iTabHeight + 25, 85, 25)
		GUICtrlSetOnEvent(-1, "CloseAttackCSVSettings")
	$g_hBtnAttackCSVSettingsCloseTop = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Btn_AttackCSVSettings_Close", "Close"), $iTabWidth - 60, 15, 85, 25)
		GUICtrlSetOnEvent(-1, "CloseAttackCSVSettings")
EndFunc   ;==>CreateAttackCSVSettingsGUI
