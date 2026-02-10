; #FUNCTION# ====================================================================================================================
; Name ..........: CreateCSVModSettingsTab
; Description ...: Creates CSV automation, hero, and redline preset controls.
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
	Local $aHeroNames[4] = ["King", "Queen", "Warden", "Champion"]

	GUICtrlCreateGroup("CSV automation", $x, $y, $w, 175)
		GUICtrlCreateLabel("Flex troop", $x + 10, $y + 22, 70, 18)
		$g_hCmbCSVFlexTroop = GUICtrlCreateCombo("", $x + 90, $y + 20, 140, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
		Local $iOffsetYHero = $y + 50
		For $h = 0 To UBound($aHeroNames) - 1
			GUICtrlCreateLabel($aHeroNames[$h], $x + 10, $iOffsetYHero + 2, 60, 18)
			$g_ahCSVHeroAbilityMode[$h] = GUICtrlCreateCombo("", $x + 80, $iOffsetYHero, 90, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetData(-1, "Auto|Timer|Both|None", "Auto")
				GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
			$g_ahCSVHeroAbilityDelay[$h] = GUICtrlCreateInput("0", $x + 180, $iOffsetYHero, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
				GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
			$iOffsetYHero += 23
		Next
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 185
	GUICtrlCreateGroup("Presets", $x, $y, $w, $g_iSizeHGrpTab1 - $y - 10)
		GUICtrlCreateLabel("Redline preset", $x + 10, $y + 22, 90, 18)
		$g_hCmbCSVRedlinePreset = GUICtrlCreateCombo("", $x + 110, $y + 20, 120, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
		GUICtrlCreateLabel("Dropline preset", $x + 10, $y + 48, 90, 18)
		$g_hCmbCSVDroplinePreset = GUICtrlCreateCombo("", $x + 110, $y + 46, 120, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
		GUICtrlCreateLabel("CC request", $x + 10, $y + 74, 90, 18)
		$g_hTxtCSVCCRequest = GUICtrlCreateInput("", $x + 110, $y + 72, 120, 18)
			GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
		$g_hBtnCSVSettingsApply = GUICtrlCreateButton("Save && apply to GUI", $x + 10, $y + 105, 140, 22)
			GUICtrlSetOnEvent(-1, "AttackCSVSettings_ApplyToGUI")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc   ;==>CreateCSVModSettingsTab
