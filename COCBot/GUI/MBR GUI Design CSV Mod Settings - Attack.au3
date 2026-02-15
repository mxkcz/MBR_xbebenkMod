; #FUNCTION# ====================================================================================================================
; Name ..........: CreateCSVModSettingsAttackTab
; Description ...: Creates attack-specific CSV controls inside Settings -> Attack.
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

; #FUNCTION# ====================================================================================================================
; Name ..........: CreateCSVModSettingsAttackTab
; Description ...: Creates attack-with and hero ability controls.
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
Func CreateCSVModSettingsAttackTab()
	Local $x = 0, $y = 0, $w = 0, $h = 0
	CSVMod_GetSettingsSubTabBounds($x, $y, $w, $h)

	Local $iCursorY = $y
	Local Const $iSectionGap = 8

	; CSV automation
	Local Const $iAutomationH = 42
	GUICtrlCreateGroup("CSV automation", $x, $iCursorY, $w, $iAutomationH)
		GUICtrlCreateLabel("Flex troop", $x + 10, $iCursorY + 22, 70, 18)
		$g_hCmbCSVFlexTroop = GUICtrlCreateCombo("", $x + 90, $iCursorY + 20, 140, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$iCursorY += $iAutomationH + $iSectionGap

	; Hero abilities
	Local Const $iHeroGroupH = 145
	CreateAttackHeroAbilityGroup($x, $iCursorY, $w)
	$iCursorY += $iHeroGroupH + $iSectionGap

	; Attack-with group (dynamic width-based row layout)
	Local Const $iAttackPadY = 20
	Local Const $iAttackPadBottom = 8
	Local Const $iAttackModeGap = 8
	Local Const $iRowCtlH = 18
	Local $bWrapSwap = _CSVMod_AttackRowNeedsWrap($w)
	Local $iModeRowH = $iRowCtlH + ($bWrapSwap ? ($iRowCtlH + 4) : 0)
	Local $iAttackGroupH = $iAttackPadY + ($iModeRowH * 2) + $iAttackModeGap + $iAttackPadBottom
	GUICtrlCreateGroup("Attack with / Warden && Siege", $x, $iCursorY, $w, $iAttackGroupH)
		Local $iBattleRowY = $iCursorY + $iAttackPadY
		_CSVMod_CreateAttackWithRow($x, $iBattleRowY, $w, "Battle", "CSVSettings_OnBattleDropCCChanged", _
				$g_hchkBattleDropCC, $g_hCmbBattleWardenMode, $g_hCmbBattleSiege, $g_hchkBattleDropEmptySiege, $g_hchkBattleSwapEmptyBlimp, $bWrapSwap)
		Local $iRankedRowY = $iBattleRowY + $iModeRowH + $iAttackModeGap
		_CSVMod_CreateAttackWithRow($x, $iRankedRowY, $w, "Ranked", "CSVSettings_OnRankedBattleDropCCChanged", _
				$g_hchkRankedBattleDropCC, $g_hCmbRankedBattleWardenMode, $g_hCmbRankedBattleSiege, $g_hchkRankedBattleDropEmptySiege, $g_hchkRankedBattleSwapEmptyBlimp, $bWrapSwap)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$iCursorY += $iAttackGroupH + $iSectionGap

	GUICtrlCreateGroup("Notes", $x, $iCursorY, $w, 40)
		GUICtrlCreateLabel("Presets were moved to Settings -> Presets.", $x + 10, $iCursorY + 18, $w - 20, 18)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc   ;==>CreateCSVModSettingsAttackTab


; #FUNCTION# ====================================================================================================================
; Name ..........: _CSVMod_AttackRowNeedsWrap
; Description ...: Returns True if attack row controls must wrap to a second line to stay inside group bounds.
; Syntax ........: _CSVMod_AttackRowNeedsWrap($iGroupW)
; Parameters ....: $iGroupW            - Width of attack group.
; Return values .: Bool
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; =====================================================================================================================
Func _CSVMod_AttackRowNeedsWrap($iGroupW)
	Local Const $iPadX = 10
	Local Const $iModeLabelW = 58
	Local Const $iGap = 8
	Local Const $iDropCCW = 36
	Local Const $iDropEmptyW = 90
	Local Const $iSwapW = 120
	Local Const $iWardenMinW = 95
	Local Const $iSiegeMinW = 120
	Local $iInnerW = $iGroupW - ($iPadX * 2) - $iModeLabelW
	Local $iNeeded = $iDropCCW + $iWardenMinW + $iSiegeMinW + $iDropEmptyW + $iSwapW + ($iGap * 4)
	Return ($iNeeded > $iInnerW)
EndFunc   ;==>_CSVMod_AttackRowNeedsWrap


; #FUNCTION# ====================================================================================================================
; Name ..........: _CSVMod_CreateAttackWithRow
; Description ...: Create one Attack-with row with dynamic control widths that stay within group bounds.
; Syntax ........: _CSVMod_CreateAttackWithRow($iGroupX, $iRowY, $iGroupW, $sModeLabel, $sDropCCEvent, ByRef $hDropCC, ByRef $hCmbWarden, ByRef $hCmbSiege, ByRef $hDropEmptySiege, ByRef $hSwapEmptyBlimp, $bWrapSwap)
; Parameters ....:
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; =====================================================================================================================
Func _CSVMod_CreateAttackWithRow($iGroupX, $iRowY, $iGroupW, $sModeLabel, $sDropCCEvent, ByRef $hDropCC, ByRef $hCmbWarden, ByRef $hCmbSiege, _
		ByRef $hDropEmptySiege, ByRef $hSwapEmptyBlimp, $bWrapSwap)
	Local Const $iPadX = 10
	Local Const $iModeLabelW = 58
	Local Const $iGap = 8
	Local Const $iCtlH = 18
	Local Const $iDropCCW = 36
	Local Const $iDropEmptyW = 90
	Local Const $iSwapW = 120
	Local Const $iWardenMinW = 95
	Local Const $iSiegeMinW = 120
	Local Const $iSwapRowOffset = 4

	GUICtrlCreateLabel($sModeLabel, $iGroupX + $iPadX, $iRowY + 2, $iModeLabelW, 18)

	Local $iCursorX = $iGroupX + $iPadX + $iModeLabelW
	Local $iRowRight = $iGroupX + $iGroupW - $iPadX
	$hDropCC = GUICtrlCreateCheckbox("CC", $iCursorX, $iRowY, $iDropCCW, $iCtlH)
		GUICtrlSetOnEvent(-1, $sDropCCEvent)
	$iCursorX += $iDropCCW + $iGap

	Local $iReservedAfterCombo = $iDropEmptyW + ($bWrapSwap ? 0 : ($iSwapW + $iGap)) + ($iGap * 2)
	Local $iComboAvail = $iRowRight - $iCursorX - $iReservedAfterCombo
	If $iComboAvail < ($iWardenMinW + $iSiegeMinW + $iGap) Then $iComboAvail = $iWardenMinW + $iSiegeMinW + $iGap

	Local $iWardenW = Int(($iComboAvail - $iGap) * 0.34)
	If $iWardenW < $iWardenMinW Then $iWardenW = $iWardenMinW
	Local $iSiegeW = $iComboAvail - $iGap - $iWardenW
	If $iSiegeW < $iSiegeMinW Then
		$iSiegeW = $iSiegeMinW
		$iWardenW = $iComboAvail - $iGap - $iSiegeW
		If $iWardenW < $iWardenMinW Then $iWardenW = $iWardenMinW
	EndIf

	$hCmbWarden = GUICtrlCreateCombo("", $iCursorX, $iRowY, $iWardenW, $iCtlH, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, "Ground mode|Air mode|Default mode", "Default mode")
		GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
	$iCursorX += $iWardenW + $iGap

	$hCmbSiege = GUICtrlCreateCombo("", $iCursorX, $iRowY, $iSiegeW, $iCtlH, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, "Castle only|Wall Wrecker|Battle Blimp|Stone Slammer|Siege Barracks|Log Launcher|Flame Flinger|Battle Drill|Troop Launcher|Any Siege|Default", "Default")
		GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
	$iCursorX += $iSiegeW + $iGap

	$hDropEmptySiege = GUICtrlCreateCheckbox("Empty siege", $iCursorX, $iRowY, $iDropEmptyW, $iCtlH)
		GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
	$iCursorX += $iDropEmptyW + $iGap

	If $bWrapSwap Then
		Local $iSwapX = $iGroupX + $iPadX + $iModeLabelW + $iDropCCW + $iGap
		Local $iSwapY = $iRowY + $iCtlH + $iSwapRowOffset
		Local $iSwapWidth = $iRowRight - $iSwapX
		If $iSwapWidth < $iSwapW Then $iSwapWidth = $iSwapW
		$hSwapEmptyBlimp = GUICtrlCreateCheckbox("Swap empty blimp", $iSwapX, $iSwapY, $iSwapWidth, $iCtlH)
	Else
		Local $iSwapWidthInline = $iRowRight - $iCursorX
		If $iSwapWidthInline < $iSwapW Then $iSwapWidthInline = $iSwapW
		$hSwapEmptyBlimp = GUICtrlCreateCheckbox("Swap empty blimp", $iCursorX, $iRowY, $iSwapWidthInline, $iCtlH)
	EndIf
	GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
EndFunc   ;==>_CSVMod_CreateAttackWithRow


; #FUNCTION# ====================================================================================================================
; Name ..........: CreateAttackHeroAbilityGroup
; Description ...: Creates hero ability activation controls (including Prince).
; Syntax ........:
; Parameters ....: $iGroupX - left position
;                  $iGroupY - top position
;                  $iGroupW - width of group box
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; =====================================================================================================================
Func CreateAttackHeroAbilityGroup($iGroupX, $iGroupY, $iGroupW)
	Local $sTxtTip = ""
	Local $iGroupH = 145
	Local $x = $iGroupX + 20
	Local $y = $iGroupY + 20

	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Attack", "Group_01", "Hero Abilities"), $iGroupX, $iGroupY, $iGroupW, $iGroupH)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnQueen, $x, $y, 22, 22)
	GUIStartGroup()
	$x += 30
		$g_hRadAutoQueenAbility = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Attack", "RadAutoAbilities", "Auto activate (red zone)"), $x, $y, -1, -1)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Attack", "RadAutoAbilities_Info_01", "Activate the Ability when the Hero becomes weak.") & @CRLF & _
					   GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Attack", "RadAutoAbilities_Info_02", "Heroes are checked and activated individually.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_CHECKED)
	$x += 145
		$g_hRadManQueenAbility = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Attack", "RadManAbilities", "Timed after") & ":", $x, $y, -1, -1)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Attack", "RadManAbilities_Info_01", "Activate the Ability on a timer.") & @CRLF & _
					   GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Attack", "RadManAbilities_Info_02", "All Heroes are activated at the same time.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
		$g_hTxtManQueenAbility = GUICtrlCreateInput("9", $x + 80, $y + 3, 30, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Attack", "TxtManAbilities_Info_01", "Set the time in seconds for Timed Activation of Hero Abilities.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 3)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "sec.", -1), $x + 115, $y + 4, -1, -1)
	$x += 145
		$g_hRadBothQueenAbility = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Attack", "RadBothAbilities_Info_01", "Check Both"), $x, $y, -1, -1)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Attack", "RadBothAbilities_Info_02", "Activate the Ability when Hero becomes weak or when timer runs out")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_UNCHECKED)

	$x = $iGroupX + 20
	$y += 25
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnKing, $x, $y, 22, 22)
	GUIStartGroup()
	$x += 30
		$g_hRadAutoKingAbility = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Attack", "RadAutoAbilities", "Auto activate (red zone)"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_CHECKED)
	$x += 145
		$g_hRadManKingAbility = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Attack", "RadManAbilities", "Timed after") & ":", $x, $y, -1, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
		$g_hTxtManKingAbility = GUICtrlCreateInput("9", $x + 80, $y + 3, 30, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 3)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "sec.", -1), $x + 115, $y + 4, -1, -1)
	$x += 145
		$g_hRadBothKingAbility = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Attack", "RadBothAbilities_Info_01", "Check Both"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_UNCHECKED)

	$x = $iGroupX + 20
	$y += 25
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnWarden, $x, $y, 22, 22)
	GUIStartGroup()
	$x += 30
		$g_hRadAutoWardenAbility = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Attack", "RadAutoAbilities", "Auto activate (red zone)"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_CHECKED)
	$x += 145
		$g_hRadManWardenAbility = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Attack", "RadManAbilities", "Timed after") & ":", $x, $y, -1, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
		$g_hTxtManWardenAbility = GUICtrlCreateInput("9", $x + 80, $y + 3, 30, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 3)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "sec.", -1), $x + 115, $y + 4, -1, -1)
	$x += 145
		$g_hRadBothWardenAbility = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Attack", "RadBothAbilities_Info_01", "Check Both"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_UNCHECKED)

	$x = $iGroupX + 20
	$y += 25
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnChampion, $x, $y, 22, 22)
	GUIStartGroup()
	$x += 30
		$g_hRadAutoChampionAbility = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Attack", "RadAutoAbilities", "Auto activate (red zone)"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_CHECKED)
	$x += 145
		$g_hRadManChampionAbility = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Attack", "RadManAbilities", "Timed after") & ":", $x, $y, -1, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
		$g_hTxtManChampionAbility = GUICtrlCreateInput("9", $x + 80, $y + 3, 30, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 3)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "sec.", -1), $x + 115, $y + 4, -1, -1)
	$x += 145
		$g_hRadBothChampionAbility = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Attack", "RadBothAbilities_Info_01", "Check Both"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_UNCHECKED)

	$x = $iGroupX + 20
	$y += 25
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnPrince, $x, $y, 22, 22)
	GUIStartGroup()
	$x += 30
		$g_hRadAutoPrinceAbility = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Attack", "RadAutoAbilities", "Auto activate (red zone)"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_CHECKED)
	$x += 145
		$g_hRadManPrinceAbility = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Attack", "RadManAbilities", "Timed after") & ":", $x, $y, -1, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
		$g_hTxtManPrinceAbility = GUICtrlCreateInput("9", $x + 80, $y + 3, 30, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 3)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "sec.", -1), $x + 115, $y + 4, -1, -1)
	$x += 145
		$g_hRadBothPrinceAbility = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Attack", "RadBothAbilities_Info_01", "Check Both"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_UNCHECKED)

	Local $ahDirtyControls[20] = [ _
			$g_hRadAutoQueenAbility, $g_hRadManQueenAbility, $g_hRadBothQueenAbility, $g_hTxtManQueenAbility, _
			$g_hRadAutoKingAbility, $g_hRadManKingAbility, $g_hRadBothKingAbility, $g_hTxtManKingAbility, _
			$g_hRadAutoWardenAbility, $g_hRadManWardenAbility, $g_hRadBothWardenAbility, $g_hTxtManWardenAbility, _
			$g_hRadAutoChampionAbility, $g_hRadManChampionAbility, $g_hRadBothChampionAbility, $g_hTxtManChampionAbility, _
			$g_hRadAutoPrinceAbility, $g_hRadManPrinceAbility, $g_hRadBothPrinceAbility, $g_hTxtManPrinceAbility]
	For $i = 0 To UBound($ahDirtyControls) - 1
		If $ahDirtyControls[$i] <> 0 Then GUICtrlSetOnEvent($ahDirtyControls[$i], "CSVSettings_MarkDirty")
	Next

	GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc   ;==>CreateAttackHeroAbilityGroup
