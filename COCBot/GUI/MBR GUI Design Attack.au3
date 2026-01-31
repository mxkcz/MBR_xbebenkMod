; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Attack Plan" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GKevinOD (2014)
; Modified ......: DkEd, Hervidero (2015), CodeSlinger69 (2017), mxkcz
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
Global $g_hGUI_AttackCSVSettings = 0

#include "MBR GUI Design Child Attack - Troops.au3"
#include "MBR GUI Design CSV Mod Search.au3"
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
Global $g_hBtnCSVSideZero = 0, $g_hBtnCSVSideEqual = 0, $g_hBtnCSVSideBZero = 0, $g_hBtnCSVSideBEqual = 0
Global $g_hCmbCSVFlexTroop = 0, $g_ahCSVHeroAbilityMode[4] = [0, 0, 0, 0], $g_ahCSVHeroAbilityDelay[4] = [0, 0, 0, 0]
Global $g_hCmbCSVRedlinePreset = 0, $g_hCmbCSVDroplinePreset = 0, $g_hTxtCSVCCRequest = 0, $g_hBtnCSVSettingsApply = 0
Global $g_hLblCSVSettingsScript = 0, $g_hLblCSVSettingsPath = 0, $g_hLblCSVSettingsLoaded = 0, $g_hLblCSVSettingsVersion = 0, $g_hLblCSVSettingsDirty = 0
Global $g_hBtnCSVSettingsReload = 0, $g_hBtnCSVSettingsTestBattle = 0, $g_hBtnCSVSettingsTestDry = 0, $g_hBtnCSVSettingsValidate = 0, $g_hBtnCSVSettingsDebugLocate = 0
Global $g_hLblCSVVectorEditInfo = 0, $g_hTxtCSVVectorRow = 0
Global $g_hLblCSVSidePreview = 0
Global $g_hRadCSVPrecacheConservative = 0, $g_hRadCSVPrecacheAggressive = 0
Global $g_hLblCSVPrecacheBudget = 0, $g_hLblCSVPrecacheLast = 0
Global $g_hBtnCSVRebuildPrecalc = 0
Global $g_hTxtCSVPrecalcStatus = 0
Global $g_hTxtCSVPrioPreview = 0
Global $g_hTxtCSVDiagnostics = 0, $g_hBtnCSVRefreshDiagnostics = 0
Global $g_hChkCSVDbgSetlog = 0, $g_hChkCSVDbgClick = 0, $g_hChkCSVDbgRedArea = 0, $g_hChkCSVDbgOcr = 0, $g_hChkCSVDbgAttackCSV = 0, $g_hChkCSVDbgMakeImg = 0
Global $g_hLblCSVDbgSummary = 0, $g_hTxtCSVDebugLines = 0

Func CreateAttackTab()
	$g_hGUI_ATTACK = _GUICreate("", $g_iSizeWGrpTab1, $g_iSizeHGrpTab1, $_GUI_CHILD_LEFT, $_GUI_CHILD_TOP, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hFrmBotEx)
	;GUISetBkColor($COLOR_WHITE, $g_hGUI_ATTACK)

	CreateAttackTroops()
	CreateAttackSearch()
	CreateAttackStrategies()

	GUISwitch($g_hGUI_ATTACK)
	$g_hGUI_ATTACK_TAB = GUICtrlCreateTab(0, 0, $g_iSizeWGrpTab1, $g_iSizeHGrpTab1, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))
	$g_hGUI_ATTACK_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_01", "Train Army"))
	$g_hGUI_ATTACK_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_03_STab_03", "Strategies"))

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
