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
Global $g_hCmbCSVVectorId = 0, $g_hCmbCSVVectorSide = 0, $g_hChkCSVVectorTargeted = 0, $g_hCmbCSVTargetBuilding = 0, $g_hInpCSVPointCount = 0, $g_hInpCSVOffsetTiles = 0
Global $g_hCmbCSVVectorVersus = 0, $g_hInpCSVRandomX = 0, $g_hInpCSVRandomY = 0
Global $g_hInpCSVIndexMin = 0, $g_hInpCSVIndexMax = 0, $g_hInpCSVQtyMin = 0, $g_hInpCSVQtyMax = 0, $g_hInpCSVDelayPointMin = 0, $g_hInpCSVDelayPointMax = 0, $g_hInpCSVDelayDropMin = 0, $g_hInpCSVDelayDropMax = 0, $g_hInpCSVDelaySleepMin = 0, $g_hInpCSVDelaySleepMax = 0, $g_hChkCSVDropRemaining = 0, $g_hChkCSVDropIncludeHeroes = 0, $g_hChkCSVDropIncludeSpells = 0
Global $g_hInpCSVWaitMin = 0, $g_hInpCSVWaitMax = 0, $g_hChkCSVBreakTH = 0, $g_hChkCSVBreakSiege = 0, $g_hChkCSVBreak50 = 0, $g_hChkCSVBreakAQ = 0, $g_hChkCSVBreakBK = 0, $g_hChkCSVBreakGW = 0, $g_hChkCSVBreakRC = 0, $g_hChkCSVBreakAnyHero = 0
Global $g_asCSVSearchNames[23] = ["Mines", "Elixir Collectors", "Dark Drills", "Gold Storage", "Elixir Storage", "Dark Storage", "Town Hall", "Eagle", "Inferno", "X-Bow", "Wizard Tower", "Super Wizard Tower", "Mortar", "Air Defense", "Scattershot", "Sweeper", "Monolith", "Fire Spitter", "Multi Archer Tower", "Multi Gear Tower", "Ricochet Cannon", "Revenge Tower", "Walls"]
Global $g_ahCSVSearchToggles[23] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hBtnCSVSearchAll = 0, $g_hBtnCSVSearchNone = 0, $g_hBtnCSVSearchResources = 0, $g_hBtnCSVSearchDefenses = 0
Global $g_hBtnCSVSearchStorages = 0, $g_hBtnCSVSearchCoreDef = 0
Global $g_hBtnCSVSideZero = 0, $g_hBtnCSVSideEqual = 0, $g_hBtnCSVSideBZero = 0, $g_hBtnCSVSideBEqual = 0
Global $g_hCmbCSVFlexTroop = 0, $g_ahCSVHeroAbilityMode[4] = [0, 0, 0, 0], $g_ahCSVHeroAbilityDelay[4] = [0, 0, 0, 0]
Global $g_hCmbCSVRedlinePreset = 0, $g_hCmbCSVDroplinePreset = 0, $g_hTxtCSVCCRequest = 0, $g_hBtnCSVSettingsApply = 0
Global $g_hLblCSVSettingsScript = 0, $g_hLblCSVSettingsPath = 0, $g_hLblCSVSettingsLoaded = 0, $g_hLblCSVSettingsVersion = 0, $g_hLblCSVSettingsDirty = 0
Global $g_hBtnCSVSettingsReload = 0, $g_hBtnCSVSettingsValidate = 0, $g_hBtnCSVSettingsUpgrade = 0, $g_hBtnCSVSettingsTestDB = 0
Global $g_hLblCSVVectorEditInfo = 0, $g_hTxtCSVVectorRow = 0
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
	Local $iGuiHeight = $_GUI_MAIN_HEIGHT - 150
	$g_hGUI_AttackCSVSettings = _GUICreate(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "GUI_AttackCSVSettings", "Attack CSV Settings"), $iGuiWidth, $iGuiHeight, $g_iFrmBotPosX + 10, $g_iFrmBotPosY + 70, $WS_DLGFRAME, -1, $g_hFrmBot)
	GUISetOnEvent($GUI_EVENT_CLOSE, "CloseAttackCSVSettings", $g_hGUI_AttackCSVSettings)
	Local $iTabX = 10
	Local $iHeaderX = $iTabX + 8
	Local $iHeaderY = 10
	Local $iCloseBtnW = 85, $iCloseBtnH = 25
	Local $iApplyBtnW = 120, $iApplyBtnH = 25
	Local $iBtnGap = 10
	Local $iHeaderRowH = $iApplyBtnH
	Local $iHeaderLineGap = 16
	Local $iHeaderGap = 6
	Local $iHeaderLabelY = $iHeaderY + $iHeaderRowH + 2
	Local $iHeaderLineCount = 4
	Local $iHeaderH = $iHeaderRowH + ($iHeaderLineGap * $iHeaderLineCount) + $iHeaderGap
	Local $iTabWidth = $iGuiWidth - 30
	Local $iTabRight = $iTabX + $iTabWidth
	Local $iTabY = $iHeaderY + $iHeaderH + 6
	Local $iTabHeight = $iGuiHeight - $iTabY - 10
	Local $iTabLeft = $iTabX + 15
	Local $iTabTop = $iTabY + 45
	Local $x = $iTabLeft, $y = $iTabTop
	Local $iGroupLeft = $iTabLeft - 10
	Local $iTabInnerW = $iTabWidth - 30
	Local $iGroupGap = 15
	Local $iTopBtnY = $iHeaderY
	Local $iCloseBtnX = $iTabRight - $iCloseBtnW - 10
	Local $iApplyBtnX = $iCloseBtnX - $iApplyBtnW - $iBtnGap
	Local $iHeaderBtnW = 95, $iHeaderBtnH = $iApplyBtnH, $iHeaderBtnGap = 8
	Local $iHeaderBtnUpgradeW = $iHeaderBtnW + 10
	Local $iHeaderBtnX = $iHeaderX
	Local $iHeaderBtnY = $iHeaderY
	Local $iHeaderLabelW = $iTabRight - $iHeaderX - 20
	If $iHeaderLabelW < 220 Then $iHeaderLabelW = 220
	Local $iHeaderStatusX = $iHeaderX + 210
	If $iHeaderStatusX + 140 > $iTabRight - 10 Then $iHeaderStatusX = $iTabRight - 150
	$g_hBtnCSVSettingsReload = GUICtrlCreateButton("Reload CSV", $iHeaderBtnX, $iHeaderBtnY, $iHeaderBtnW, $iHeaderBtnH)
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Btn_AttackCSVSettings_Reload_Info", "Reloads settings from the CSV file, discarding unsaved edits."))
		GUICtrlSetOnEvent(-1, "AttackCSVSettings_ReloadFromCSV")
	$g_hBtnCSVSettingsValidate = GUICtrlCreateButton("Validate CSV", $iHeaderBtnX + $iHeaderBtnW + $iHeaderBtnGap, $iHeaderBtnY, $iHeaderBtnW, $iHeaderBtnH)
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Btn_AttackCSVSettings_Validate_Info", "Runs quick validation for MAKE/SIDE/WAIT values in the CSV."))
		GUICtrlSetOnEvent(-1, "AttackCSVSettings_ValidateCSV")
	$g_hBtnCSVSettingsTestDB = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Btn_AttackCSVSettings_TestDB", "Test DB"), $iHeaderBtnX + (($iHeaderBtnW + $iHeaderBtnGap) * 2) + $iHeaderBtnUpgradeW + $iHeaderBtnGap, $iHeaderBtnY, $iHeaderBtnW, $iHeaderBtnH)
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Btn_AttackCSVSettings_TestDB_Info", "Run a manual DB test attack using the selected Dead Base script (target must be selected)."))
		GUICtrlSetOnEvent(-1, "AttackCSVSettings_AttackNowDB")
	$g_hLblCSVSettingsScript = GUICtrlCreateLabel("Script: -", $iHeaderX, $iHeaderLabelY, $iHeaderLabelW, 16)
	$g_hLblCSVSettingsPath = GUICtrlCreateLabel("Path: -", $iHeaderX, $iHeaderLabelY + $iHeaderLineGap, $iHeaderLabelW, 16)
	$g_hLblCSVSettingsLoaded = GUICtrlCreateLabel("Loaded: -", $iHeaderX, $iHeaderLabelY + ($iHeaderLineGap * 2), 200, 16)
	$g_hLblCSVSettingsVersion = GUICtrlCreateLabel("CSV: -", $iHeaderX, $iHeaderLabelY + ($iHeaderLineGap * 3), 200, 16)
	$g_hLblCSVSettingsDirty = GUICtrlCreateLabel("Status: Saved", $iHeaderStatusX, $iHeaderLabelY + ($iHeaderLineGap * 2), 140, 16)
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Lbl_AttackCSVSettings_Dirty_Info", "Shows whether current edits are saved to the CSV file."))
	$g_hAttackCSVSettingsTab = GUICtrlCreateTab($iTabX, $iTabY, $iTabWidth, $iTabHeight, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))

	; ---- Tab 1: Side weighting & forcing ----
	GUICtrlCreateTabItem(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Tab_AttackCSVSettings_Side", "Side Weights"))
		$x = $iTabLeft
		$y = $iTabTop
		Local $iSideGapX = 20
		Local $iForceGroupH = 70
		Local $iSideGroupH = 200
		Local $iSideBGroupH = 270
		Local $iLeftGroupW = 320
		Local $iRightGroupW = 400
		Local $bSideWide = ($iTabInnerW >= ($iLeftGroupW + $iRightGroupW + $iSideGapX))
		Local $iLeftGroupX = $iGroupLeft
		Local $iRightGroupX = $iLeftGroupX + $iLeftGroupW + $iSideGapX
		Local $iForceGroupY = $y - 15
		Local $iSideGroupY = $iForceGroupY + $iForceGroupH + 10
		Local $iSideBGroupY = $iForceGroupY
		If Not $bSideWide Then
			$iLeftGroupW = $iTabInnerW
			$iRightGroupW = $iTabInnerW
			$iRightGroupX = $iLeftGroupX
			$iSideBGroupY = $iSideGroupY + $iSideGroupH + $iGroupGap
		EndIf

		GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Group_AttackCSVSettings_ForceSide", "Forced side"), $iLeftGroupX, $iForceGroupY, $iLeftGroupW, $iForceGroupH)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Group_AttackCSVSettings_ForceSide_Info", "Overrides SIDE/SIDEB weight selection when set."))
			Local $iForceComboW = $iLeftGroupW - 90
			If $iForceComboW < 140 Then $iForceComboW = 140
			$g_hCmbCSVForceSide = GUICtrlCreateCombo("", $x, $y, $iForceComboW, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, "Auto (weight-based)|TOP-LEFT|TOP-RIGHT|BOTTOM-LEFT|BOTTOM-RIGHT|TOP-RAND", "Auto (weight-based)")
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb_AttackCSVSettings_ForceSide_Info", "Matches SIDE/SIDEB value8. TOP-RAND randomizes left/right on top."))
				GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
		GUICtrlCreateGroup("", -99, -99, 1, 1)

		; SIDE weights (resource focus)
		GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Group_AttackCSVSettings_SideWeights", "SIDE weights (resource)"), $iLeftGroupX, $iSideGroupY, $iLeftGroupW, $iSideGroupH)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Group_AttackCSVSettings_SideWeights_Info", "Higher values push SIDE selection toward resource-heavy edges."))
			Local $aSideWeightNames[7] = ["Gold Mines", "Elixir Collectors", "Dark Drills", "Gold Storage", "Elixir Storage", "Dark Storage", "Town Hall"]
			Local $iSideColW = Int(($iLeftGroupW - 20) / 2)
			Local $iSideLabelW = $iSideColW - 45
			If $iSideLabelW < 70 Then $iSideLabelW = 70
			Local $iSideInputW = $iSideColW - $iSideLabelW - 10
			If $iSideInputW < 35 Then $iSideInputW = 35
			If $iSideInputW > 50 Then $iSideInputW = 50
			For $i = 0 To UBound($aSideWeightNames) - 1
				Local $iRow = Mod($i, 4), $iCol = Int($i / 4)
				Local $iOffsetX = $iLeftGroupX + 10 + ($iCol * $iSideColW), $iOffsetY = $iSideGroupY + 25 + ($iRow * 30)
				GUICtrlCreateLabel($aSideWeightNames[$i] & ":", $iOffsetX, $iOffsetY + 4, $iSideLabelW, 18)
				$g_ahCSVSideWeightInputs[$i] = GUICtrlCreateInput("0", $iOffsetX + $iSideLabelW + 5, $iOffsetY, $iSideInputW, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
				$g_ahCSVSideWeightSpin[$i] = GUICtrlCreateUpdown($g_ahCSVSideWeightInputs[$i])
					GUICtrlSetLimit(-1, 99, 0)
				GUICtrlSetOnEvent($g_ahCSVSideWeightInputs[$i], "CSVSettings_MarkDirty")
			Next
			Local $iSidePresetY = $iSideGroupY + $iSideGroupH - 28
			Local $iSidePresetW = 80
			$g_hBtnCSVSideZero = GUICtrlCreateButton("Zero", $iLeftGroupX + 10, $iSidePresetY, $iSidePresetW, 20)
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Btn_AttackCSVSettings_SideZero_Info", "Set all SIDE weights to 0."))
				GUICtrlSetOnEvent(-1, "CSVSideWeightsPresetZero")
			$g_hBtnCSVSideEqual = GUICtrlCreateButton("Equal", $iLeftGroupX + 10 + $iSidePresetW + 8, $iSidePresetY, $iSidePresetW, 20)
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Btn_AttackCSVSettings_SideEqual_Info", "Set all SIDE weights to 5."))
				GUICtrlSetOnEvent(-1, "CSVSideWeightsPresetEqual")
		GUICtrlCreateGroup("", -99, -99, 1, 1)

		; SIDEB weights (defense focus, incl. new defenses)
		GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Group_AttackCSVSettings_SideBWeights", "SIDEB weights (defenses)"), $iRightGroupX, $iSideBGroupY, $iRightGroupW, $iSideBGroupH)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Group_AttackCSVSettings_SideBWeights_Info", "Higher values prioritize defense-heavy edges in SIDEB."))
			Local $aSideBWeightNames[14] = ["Eagle", "Inferno", "X-Bow", "Wizard Tower/Super Wiz", "Mortar", "Air Defense", "Scattershot", "Sweeper", "Monolith", "Fire Spitter", "Multi Archer", "Multi Gear", "Ricochet Cannon", "Revenge Tower"]
			Local $iSideBColW = Int(($iRightGroupW - 20) / 2)
			Local $iSideBLabelW = $iSideBColW - 50
			If $iSideBLabelW < 90 Then $iSideBLabelW = 90
			Local $iSideBInputW = $iSideBColW - $iSideBLabelW - 10
			If $iSideBInputW < 35 Then $iSideBInputW = 35
			If $iSideBInputW > 50 Then $iSideBInputW = 50
			For $j = 0 To UBound($aSideBWeightNames) - 1
				Local $iRowB = Mod($j, 7), $iColB = Int($j / 7)
				Local $iOffsetXB = $iRightGroupX + 10 + ($iColB * $iSideBColW), $iOffsetYB = $iSideBGroupY + 25 + ($iRowB * 30)
				GUICtrlCreateLabel($aSideBWeightNames[$j] & ":", $iOffsetXB, $iOffsetYB + 4, $iSideBLabelW, 18)
				$g_ahCSVSideBWeightInputs[$j] = GUICtrlCreateInput("0", $iOffsetXB + $iSideBLabelW + 5, $iOffsetYB, $iSideBInputW, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
				$g_ahCSVSideBWeightSpin[$j] = GUICtrlCreateUpdown($g_ahCSVSideBWeightInputs[$j])
					GUICtrlSetLimit(-1, 99, 0)
				GUICtrlSetOnEvent($g_ahCSVSideBWeightInputs[$j], "CSVSettings_MarkDirty")
			Next
			Local $iSideBPresetY = $iSideBGroupY + $iSideBGroupH - 28
			Local $iSideBPresetW = 90
			$g_hBtnCSVSideBZero = GUICtrlCreateButton("Zero", $iRightGroupX + 10, $iSideBPresetY, $iSideBPresetW, 20)
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Btn_AttackCSVSettings_SideBZero_Info", "Set all SIDEB weights to 0."))
				GUICtrlSetOnEvent(-1, "CSVSideBWeightsPresetZero")
			$g_hBtnCSVSideBEqual = GUICtrlCreateButton("Equal", $iRightGroupX + 10 + $iSideBPresetW + 8, $iSideBPresetY, $iSideBPresetW, 20)
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Btn_AttackCSVSettings_SideBEqual_Info", "Set all SIDEB weights to 5."))
				GUICtrlSetOnEvent(-1, "CSVSideBWeightsPresetEqual")
		GUICtrlCreateGroup("", -99, -99, 1, 1)

	; ---- Tab 2: Vectors ----
	GUICtrlCreateTabItem(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Tab_AttackCSVSettings_Vector", "Vectors"))
		$x = $iTabLeft
		$y = $iTabTop
		GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Group_AttackCSVSettings_Targeted", "Targeted vectors"), $iGroupLeft, $y - 20, $iTabInnerW, 160)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Group_AttackCSVSettings_Targeted_Info", "Edits the selected MAKE line (value2..value8) for this vector."))
		$g_hCmbCSVVectorId = GUICtrlCreateCombo("", $x, $y, 60, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "A|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z", "A")
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb_AttackCSVSettings_VectorId_Info", "MAKE/DROP vector letter"))
			GUICtrlSetOnEvent(-1, "CSVVectorSelect")
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Lbl_AttackCSVSettings_VectorSide", "Side"), $x + 70, $y, 40, 18)
		$g_hCmbCSVVectorSide = GUICtrlCreateCombo("", $x + 110, $y - 2, 120, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "FRONT-LEFT|FRONT-RIGHT|RIGHT-FRONT|RIGHT-BACK|LEFT-FRONT|LEFT-BACK|BACK-LEFT|BACK-RIGHT|RANDOM", "FRONT-LEFT")
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb_AttackCSVSettings_VectorSide_Info", "MAKE value2 (side). Use RANDOM for random side selection."))
			GUICtrlSetOnEvent(-1, "CSVVectorUpdate")
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Lbl_AttackCSVSettings_PointCount", "Points"), $x + 240, $y, 50, 18)
		$g_hInpCSVPointCount = GUICtrlCreateInput("1", $x + 295, $y - 2, 45, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Inp_AttackCSVSettings_PointCount_Info", "MAKE value3. Targeted vectors support 1 or 5."))
			GUICtrlSetOnEvent(-1, "CSVVectorUpdate")
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Lbl_AttackCSVSettings_Offset", "Offset tiles"), $x + 350, $y, 65, 18)
		$g_hInpCSVOffsetTiles = GUICtrlCreateInput("0", $x + 420, $y - 2, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Inp_AttackCSVSettings_Offset_Info", "MAKE value4 (tile offset)."))
			GUICtrlSetOnEvent(-1, "CSVVectorUpdate")
		$g_hChkCSVVectorTargeted = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk_AttackCSVSettings_Targeted", "Building targeted (MAKE value8)"), $x, $y + 28, 180, 20)
			GUICtrlSetState(-1, $GUI_CHECKED)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk_AttackCSVSettings_Targeted_Info", "When enabled, uses value8 target building for MakeTargetDropPoints."))
			GUICtrlSetOnEvent(-1, "CSVVectorUpdate")
		$g_hCmbCSVTargetBuilding = GUICtrlCreateCombo("", $x + 190, $y + 28, 140, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "TOWNHALL|EAGLE|INFERNO|XBOW|WIZTOWER|SUPERWIZTW|MORTAR|AIRDEFENSE|SWEEPER|MONOLITH|FIRESPITTER|MULTIARCHER|MULTIGEAR|RICOCHETCA|SCATTER|REVENGETW|EX-WALL|IN-WALL", "TOWNHALL")
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb_AttackCSVSettings_TargetBuilding_Info", "Matches MakeTargetDropPoints value8 list"))
			GUICtrlSetOnEvent(-1, "CSVVectorUpdate")
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Lbl_AttackCSVSettings_DropPoints", "Drop points"), $x + 340, $y + 30, 80, 18)
		$g_hCmbCSVVectorVersus = GUICtrlCreateCombo("", $x + 425, $y + 28, 90, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "EXT-INT|INT-EXT|IGNORE", "EXT-INT")
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb_AttackCSVSettings_Versus_Info", "MAKE value5 (drop points order)."))
			GUICtrlSetOnEvent(-1, "CSVVectorUpdate")
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Lbl_AttackCSVSettings_RandomX", "Rand X"), $x + 520, $y + 30, 45, 18)
		$g_hInpCSVRandomX = GUICtrlCreateInput("0", $x + 565, $y + 28, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Inp_AttackCSVSettings_RandomX_Info", "MAKE value6 (random X, px). Ignored for targeted vectors."))
			GUICtrlSetOnEvent(-1, "CSVVectorUpdate")
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Lbl_AttackCSVSettings_RandomY", "Rand Y"), $x + 610, $y + 30, 45, 18)
		$g_hInpCSVRandomY = GUICtrlCreateInput("0", $x + 655, $y + 28, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Inp_AttackCSVSettings_RandomY_Info", "MAKE value7 (random Y, px). Ignored for targeted vectors."))
			GUICtrlSetOnEvent(-1, "CSVVectorUpdate")
		$g_hLblCSVVectorEditInfo = GUICtrlCreateLabel("Editing MAKE line: A", $x, $y + 60, 300, 18)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Lbl_AttackCSVSettings_VectorEdit_Info", "Shows which MAKE line will be updated."))
		GUICtrlCreateLabel("MAKE row", $x, $y + 80, 70, 18)
		$g_hTxtCSVVectorRow = GUICtrlCreateInput("", $x + 70, $y + 78, $iTabInnerW - 90, 20, BitOR($ES_READONLY, $ES_AUTOHSCROLL))
			GUICtrlSetState(-1, $GUI_ENABLE)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Txt_AttackCSVSettings_VectorRow_Info", "Raw MAKE line from CSV (read-only)."))
		GUICtrlCreateGroup("", -99, -99, 1, 1)

	; ---- Tab 3: Drops & Wait ----
	GUICtrlCreateTabItem(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Tab_AttackCSVSettings_Drops", "Drops && Wait"))
		$x = $iTabLeft
		$y = $iTabTop
		Local $iDropGroupW = 360
		Local $iWaitGroupW = 360
		Local $iDropGroupH = 215
		Local $iWaitGroupH = 215
		Local $iDropGroupGapX = 20
		Local $bDropWide = ($iTabInnerW >= ($iDropGroupW + $iWaitGroupW + $iDropGroupGapX))
		Local $iDropGroupX = $iGroupLeft
		Local $iDropGroupY = $y - 20
		Local $iWaitGroupX = $iDropGroupX + $iDropGroupW + $iDropGroupGapX
		Local $iWaitGroupY = $y - 20
		If Not $bDropWide Then
			$iDropGroupW = $iTabInnerW
			$iWaitGroupW = $iTabInnerW
			$iWaitGroupX = $iDropGroupX
			$iWaitGroupY = $iDropGroupY + $iDropGroupH + $iGroupGap
		EndIf
		Local $iDropX = $iDropGroupX + 10
		Local $iDropY = $iDropGroupY + 20
		Local $iWaitX = $iWaitGroupX + 10
		Local $iWaitY = $iWaitGroupY + 20

		GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Group_AttackCSVSettings_DropRange", "DROP ranges && leftovers"), $iDropGroupX, $iDropGroupY, $iDropGroupW, $iDropGroupH)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Group_AttackCSVSettings_DropRange_Info", "Edits DROP ranges used by REMAIN helper lines."))
			GUICtrlCreateLabel("Index min/max", $iDropX, $iDropY, 90, 18)
			$g_hInpCSVIndexMin = GUICtrlCreateInput("1", $iDropX + 95, $iDropY - 2, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
				GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
			$g_hInpCSVIndexMax = GUICtrlCreateInput("5", $iDropX + 140, $iDropY - 2, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
				GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
			GUICtrlCreateLabel("Qty min/max", $iDropX, $iDropY + 25, 90, 18)
			$g_hInpCSVQtyMin = GUICtrlCreateInput("1", $iDropX + 95, $iDropY + 23, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
				GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
			$g_hInpCSVQtyMax = GUICtrlCreateInput("5", $iDropX + 140, $iDropY + 23, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
				GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
			GUICtrlCreateLabel("Delay point ms", $iDropX, $iDropY + 50, 90, 18)
			$g_hInpCSVDelayPointMin = GUICtrlCreateInput("0", $iDropX + 95, $iDropY + 48, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
				GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
			$g_hInpCSVDelayPointMax = GUICtrlCreateInput("0", $iDropX + 140, $iDropY + 48, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
				GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
			GUICtrlCreateLabel("Delay drop ms", $iDropX, $iDropY + 75, 90, 18)
			$g_hInpCSVDelayDropMin = GUICtrlCreateInput("0", $iDropX + 95, $iDropY + 73, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
				GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
			$g_hInpCSVDelayDropMax = GUICtrlCreateInput("0", $iDropX + 140, $iDropY + 73, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
				GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
			GUICtrlCreateLabel("Sleep after drop ms", $iDropX, $iDropY + 100, 110, 18)
			$g_hInpCSVDelaySleepMin = GUICtrlCreateInput("0", $iDropX + 125, $iDropY + 98, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
				GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
			$g_hInpCSVDelaySleepMax = GUICtrlCreateInput("0", $iDropX + 170, $iDropY + 98, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
				GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
		$g_hChkCSVDropRemaining = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk_AttackCSVSettings_DropRemain", "Drop remaining troops (REMAIN)"), $iDropX, $iDropY + 130, 240, 20)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk_AttackCSVSettings_DropRemain_Info", "Adds or updates a REMAIN DROP line for the selected vector."))
			GUICtrlSetOnEvent(-1, "CSVRemainToggle")
		$g_hChkCSVDropIncludeHeroes = GUICtrlCreateCheckbox("Include heroes in REMAIN", $iDropX + 10, $iDropY + 150, 190, 18)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk_AttackCSVSettings_DropRemain_Hero_Info", "Include heroes when using REMAIN."))
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
		$g_hChkCSVDropIncludeSpells = GUICtrlCreateCheckbox("Include spells in REMAIN", $iDropX + 10, $iDropY + 170, 190, 18)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk_AttackCSVSettings_DropRemain_Spell_Info", "Include spells when using REMAIN."))
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
		GUICtrlCreateGroup("", -99, -99, 1, 1)

		GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Group_AttackCSVSettings_Wait", "WAIT && break conditions"), $iWaitGroupX, $iWaitGroupY, $iWaitGroupW, $iWaitGroupH)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Group_AttackCSVSettings_Wait_Info", "Edits the WAIT line time range and break conditions."))
			GUICtrlCreateLabel("Wait ms min/max", $iWaitX, $iWaitY, 100, 18)
			$g_hInpCSVWaitMin = GUICtrlCreateInput("0", $iWaitX + 105, $iWaitY - 2, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
				GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
			$g_hInpCSVWaitMax = GUICtrlCreateInput("0", $iWaitX + 160, $iWaitY - 2, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
				GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
			$g_hChkCSVBreakTH = GUICtrlCreateCheckbox("Break on Town Hall destroy", $iWaitX, $iWaitY + 25, 200, 20)
				GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
			$g_hChkCSVBreakSiege = GUICtrlCreateCheckbox("Break when Siege drops", $iWaitX, $iWaitY + 50, 200, 20)
				GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
			$g_hChkCSVBreak50 = GUICtrlCreateCheckbox("Break at 50% damage", $iWaitX, $iWaitY + 75, 200, 20)
				GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
			$g_hChkCSVBreakAQ = GUICtrlCreateCheckbox("Trigger AQ ability", $iWaitX, $iWaitY + 100, 140, 20)
				GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
			$g_hChkCSVBreakBK = GUICtrlCreateCheckbox("Trigger BK ability", $iWaitX, $iWaitY + 125, 140, 20)
				GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
			$g_hChkCSVBreakGW = GUICtrlCreateCheckbox("Trigger GW ability", $iWaitX + 170, $iWaitY + 100, 140, 20)
				GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
			$g_hChkCSVBreakRC = GUICtrlCreateCheckbox("Trigger RC ability", $iWaitX + 170, $iWaitY + 125, 140, 20)
				GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
			$g_hChkCSVBreakAnyHero = GUICtrlCreateCheckbox("Any hero ability combo", $iWaitX, $iWaitY + 150, 200, 20)
				GUICtrlSetOnEvent(-1, "CSVWaitComboToggle")
			Local $iWaitExampleW = $iWaitGroupW - 20
			If $iWaitExampleW < 220 Then $iWaitExampleW = 220
			GUICtrlCreateLabel("WAIT condition examples: TH,SIEGE,50%,AQ,BK,GW,RC or AQ+BK.", $iWaitX, $iWaitY + 175, $iWaitExampleW, 18)
		GUICtrlCreateGroup("", -99, -99, 1, 1)

	; ---- Tab 4: Search toggles & settings ----
	GUICtrlCreateTabItem(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Tab_AttackCSVSettings_Search", "Search && Settings"))
		$x = $iTabLeft
		$y = $iTabTop
		Local $iSearchGroupW = 420
		Local $iAutoGroupW = 320
		Local $iSearchGroupH = 260
		Local $iAutoGroupH = 250
		Local $iSearchGapX = 20
		Local $bSearchWide = ($iTabInnerW >= ($iSearchGroupW + $iAutoGroupW + $iSearchGapX))
		Local $iSearchGroupX = $iGroupLeft
		Local $iSearchGroupY = $y - 20
		Local $iAutoGroupX = $iSearchGroupX + $iSearchGroupW + $iSearchGapX
		Local $iAutoGroupY = $y - 20
		If Not $bSearchWide Then
			$iSearchGroupW = $iTabInnerW
			$iAutoGroupW = $iTabInnerW
			$iAutoGroupX = $iSearchGroupX
			$iAutoGroupY = $iSearchGroupY + $iSearchGroupH + $iGroupGap
		EndIf
		Local $iSearchX = $iSearchGroupX + 10
		Local $iSearchY = $iSearchGroupY + 20
		Local $iAutoX = $iAutoGroupX + 10
		Local $iAutoY = $iAutoGroupY + 20

		GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Group_AttackCSVSettings_Search", "CSV building detection limits"), $iSearchGroupX, $iSearchGroupY, $iSearchGroupW, $iSearchGroupH)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Group_AttackCSVSettings_Search_Info", "Unchecked buildings are skipped for SIDE/SIDEB priority detection. MAKE targets remain enabled."))
			$g_hBtnCSVSearchAll = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Btn_AttackCSVSettings_SearchAll", "All"), $iSearchX, $iSearchY - 2, 60, 20)
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Btn_AttackCSVSettings_SearchAll_Info", "Enable all building searches."))
				GUICtrlSetOnEvent(-1, "CSVSearchSelectAll")
			$g_hBtnCSVSearchNone = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Btn_AttackCSVSettings_SearchNone", "None"), $iSearchX + 70, $iSearchY - 2, 60, 20)
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Btn_AttackCSVSettings_SearchNone_Info", "Disable all building searches."))
				GUICtrlSetOnEvent(-1, "CSVSearchSelectNone")
			$g_hBtnCSVSearchResources = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Btn_AttackCSVSettings_SearchResources", "Resources"), $iSearchX + 140, $iSearchY - 2, 90, 20)
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Btn_AttackCSVSettings_SearchResources_Info", "Enable resource buildings only."))
				GUICtrlSetOnEvent(-1, "CSVSearchSelectResources")
			$g_hBtnCSVSearchDefenses = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Btn_AttackCSVSettings_SearchDefenses", "Defenses"), $iSearchX + 240, $iSearchY - 2, 90, 20)
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Btn_AttackCSVSettings_SearchDefenses_Info", "Enable defense buildings only."))
				GUICtrlSetOnEvent(-1, "CSVSearchSelectDefenses")
			$g_hBtnCSVSearchStorages = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Btn_AttackCSVSettings_SearchStorages", "Storages"), $iSearchX, $iSearchY + 20, 90, 20)
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Btn_AttackCSVSettings_SearchStorages_Info", "Enable storage buildings only."))
				GUICtrlSetOnEvent(-1, "CSVSearchSelectStorages")
			$g_hBtnCSVSearchCoreDef = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Btn_AttackCSVSettings_SearchCoreDef", "Core Def"), $iSearchX + 100, $iSearchY + 20, 90, 20)
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Btn_AttackCSVSettings_SearchCoreDef_Info", "Enable key core defenses only."))
				GUICtrlSetOnEvent(-1, "CSVSearchSelectCoreDef")
			Local $iSearchRowH = 21
			Local $iSearchStartY = $iSearchY + 45
			Local $iSearchRowCount = 8
			For $k = 0 To UBound($g_asCSVSearchNames) - 1
				Local $iRowSearch = Mod($k, 8), $iColSearch = Int($k / 8)
				Local $iOffsetXSearch = $iSearchX + ($iColSearch * 140), $iOffsetYSearch = $iSearchStartY + ($iRowSearch * $iSearchRowH)
				$g_ahCSVSearchToggles[$k] = GUICtrlCreateCheckbox($g_asCSVSearchNames[$k], $iOffsetXSearch, $iOffsetYSearch, 130, 18)
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk_AttackCSVSettings_Search_Info", "Enable/disable search for this building in SIDE/SIDEB."))
				GUICtrlSetOnEvent(-1, "CSVSearchToggle")
			Next
			Local $iSearchNoteY = $iSearchStartY + ($iSearchRowCount * $iSearchRowH) + 5
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Lbl_AttackCSVSettings_Search_Note", "Tip: keep only the buildings you want to prioritize."), $iSearchX, $iSearchNoteY, $iSearchGroupW - 40, 18)
			GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Lbl_AttackCSVSettings_Search_TH", "TH-aware: locked buildings are auto-skipped."), $iSearchX, $iSearchNoteY + 18, $iSearchGroupW - 40, 18)
		GUICtrlCreateGroup("", -99, -99, 1, 1)

		GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Group_AttackCSVSettings_Automation", "CSV settings automation"), $iAutoGroupX, $iAutoGroupY, $iAutoGroupW, $iAutoGroupH)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Group_AttackCSVSettings_Automation_Info", "Apply script settings back into GUI elements."))
			GUICtrlCreateLabel("Flex troop (col 3)", $iAutoX, $iAutoY, 110, 18)
			Local $iFlexComboW = $iAutoGroupW - 140
			If $iFlexComboW < 150 Then $iFlexComboW = 150
			$g_hCmbCSVFlexTroop = GUICtrlCreateCombo("", $iAutoX + 120, $iAutoY - 2, $iFlexComboW, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb_AttackCSVSettings_Flex_Info", "Mark one TRAIN troop as flexible (col 3 = 1)."))
				GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
				If IsArray($g_asTroopNames) Then
					Local $sFlexTroopList = ""
					For $iFlex = 0 To UBound($g_asTroopNames) - 1
						$sFlexTroopList &= $g_asTroopNames[$iFlex] & "|"
					Next
					$sFlexTroopList = StringTrimRight($sFlexTroopList, 1)
					GUICtrlSetData(-1, $sFlexTroopList)
				EndIf
			GUICtrlCreateLabel("Hero ability mode/delay (s)", $iAutoX, $iAutoY + 30, 170, 18)
			Local $aHeroNames[4] = ["BK", "AQ", "GW", "RC"]
			For $h = 0 To 3
				Local $iOffsetYHero = $iAutoY + 55 + ($h * 25)
				GUICtrlCreateLabel($aHeroNames[$h], $iAutoX, $iOffsetYHero + 2, 20, 18)
				$g_ahCSVHeroAbilityMode[$h] = GUICtrlCreateCombo("", $iAutoX + 30, $iOffsetYHero, 90, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
					GUICtrlSetData(-1, "Auto|Manual|Both|Off", "Auto")
					_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb_AttackCSVSettings_HeroMode_Info", "Hero ability mode stored in TRAIN column."))
					GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
				$g_ahCSVHeroAbilityDelay[$h] = GUICtrlCreateInput("0", $iAutoX + 125, $iOffsetYHero, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
					_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Inp_AttackCSVSettings_HeroDelay_Info", "Delay in seconds for hero ability (TRAIN value)."))
					GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
			Next
			GUICtrlCreateLabel("Redline preset", $iAutoX, $iAutoY + 160, 90, 18)
			Local $iPresetW = $iAutoGroupW - 120
			If $iPresetW < 160 Then $iPresetW = 160
			$g_hCmbCSVRedlinePreset = GUICtrlCreateCombo("", $iAutoX + 100, $iAutoY + 158, $iPresetW, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, "ImgLoc Raw Redline|ImgLoc Redline Drop Points|Original Redline|External Edges", "ImgLoc Raw Redline")
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb_AttackCSVSettings_Redline_Info", "Updates REDLN preset in CSV settings."))
				GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
			GUICtrlCreateLabel("Dropline preset", $iAutoX, $iAutoY + 185, 90, 18)
			$g_hCmbCSVDroplinePreset = GUICtrlCreateCombo("", $iAutoX + 100, $iAutoY + 183, $iPresetW, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, "Drop line fix outer corner|Drop line fist Redline point|Full Drop line fix outer corner|Full Drop line fist Redline point|No Drop line", "Drop line fix outer corner")
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb_AttackCSVSettings_Dropline_Info", "Updates DRPLN preset in CSV settings."))
				GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
			GUICtrlCreateLabel("CC request text", $iAutoX, $iAutoY + 210, 100, 18)
			$g_hTxtCSVCCRequest = GUICtrlCreateInput("", $iAutoX + 100, $iAutoY + 208, $iPresetW, 18)
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Txt_AttackCSVSettings_CCReq_Info", "Updates CCREQ in CSV settings."))
				GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
		GUICtrlCreateGroup("", -99, -99, 1, 1)

	; ---- Tab 5: Preview ----
	GUICtrlCreateTabItem(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Tab_AttackCSVSettings_Preview", "Vector preview"))
		$x = $iTabLeft
		$y = $iTabTop
		GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Group_AttackCSVSettings_Preview", "MAINSIDE vector mapping"), $iGroupLeft, $y - 20, $iTabInnerW, 260)
			Local $sPreview = "BOTTOM-RIGHT:" & @CRLF & " FRONT_LEFT=BOTTOM-RIGHT-DOWN, FRONT_RIGHT=BOTTOM-RIGHT-UP" & @CRLF & " RIGHT_FRONT=TOP-RIGHT-DOWN, RIGHT_BACK=TOP-RIGHT-UP" & @CRLF & " LEFT_FRONT=BOTTOM-LEFT-DOWN, LEFT_BACK=BOTTOM-LEFT-UP" & @CRLF & " BACK_LEFT=TOP-LEFT-DOWN, BACK_RIGHT=TOP-LEFT-UP" & @CRLF & @CRLF & _
							  "BOTTOM-LEFT:" & @CRLF & " FRONT_LEFT=BOTTOM-LEFT-UP, FRONT_RIGHT=BOTTOM-LEFT-DOWN" & @CRLF & " RIGHT_FRONT=BOTTOM-RIGHT-DOWN, RIGHT_BACK=BOTTOM-RIGHT-UP" & @CRLF & " LEFT_FRONT=TOP-LEFT-DOWN, LEFT_BACK=TOP-LEFT-UP" & @CRLF & " BACK_LEFT=TOP-RIGHT-UP, BACK_RIGHT=TOP-RIGHT-DOWN" & @CRLF & @CRLF & _
							  "TOP-LEFT:" & @CRLF & " FRONT_LEFT=TOP-LEFT-UP, FRONT_RIGHT=TOP-LEFT-DOWN" & @CRLF & " RIGHT_FRONT=BOTTOM-LEFT-UP, RIGHT_BACK=BOTTOM-LEFT-DOWN" & @CRLF & " LEFT_FRONT=TOP-RIGHT-UP, LEFT_BACK=TOP-RIGHT-DOWN" & @CRLF & " BACK_LEFT=BOTTOM-RIGHT-UP, BACK_RIGHT=BOTTOM-RIGHT-DOWN" & @CRLF & @CRLF & _
							  "TOP-RIGHT:" & @CRLF & " FRONT_LEFT=TOP-RIGHT-DOWN, FRONT_RIGHT=TOP-RIGHT-UP" & @CRLF & " RIGHT_FRONT=TOP-LEFT-UP, RIGHT_BACK=TOP-LEFT-DOWN" & @CRLF & " LEFT_FRONT=BOTTOM-RIGHT-UP, LEFT_BACK=BOTTOM-RIGHT-DOWN" & @CRLF & " BACK_LEFT=BOTTOM-LEFT-DOWN, BACK_RIGHT=BOTTOM-LEFT-UP"
			$g_hLblCSVSidePreview = GUICtrlCreateEdit($sPreview, $x + 5, $y, $iTabInnerW - 25, 210, BitOR($ES_MULTILINE, $WS_VSCROLL))
				GUICtrlSetState(-1, $GUI_DISABLE)
				GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Lbl_AttackCSVSettings_Preview", "Reference for MAKE/DROP vector names derived from MAINSIDE/forced side."), $x + 5, $y + 215, $iTabInnerW - 30, 18)
		GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateTabItem("")

	$g_hBtnCSVSettingsApply = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Btn_AttackCSVSettings_Apply", "Save and apply to GUI"), $iApplyBtnX, $iTopBtnY, $iApplyBtnW, $iApplyBtnH)
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Btn_AttackCSVSettings_Apply_Info", "Save CSV settings and apply them to the current script."))
		GUICtrlSetOnEvent(-1, "AttackCSVSettings_ApplyToGUI")
	$g_hBtnAttackCSVSettingsClose = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Btn_AttackCSVSettings_Close", "Close"), $iCloseBtnX, $iTopBtnY, $iCloseBtnW, $iCloseBtnH)
		GUICtrlSetOnEvent(-1, "CloseAttackCSVSettings")
	$g_hBtnAttackCSVSettingsCloseTop = $g_hBtnAttackCSVSettingsClose
EndFunc   ;==>CreateAttackCSVSettingsGUI
