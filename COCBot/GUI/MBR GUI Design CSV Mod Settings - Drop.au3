; #FUNCTION# ====================================================================================================================
; Name ..........: CreateCSVModDropsTab
; Description ...: Creates drop/remain range and WAIT controls.
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
Func CreateCSVModDropsTab()
	Local $x = 0, $y = 0, $w = 0, $h = 0
	CSVMod_GetSettingsSubTabBounds($x, $y, $w, $h)
	Local $iBottom = $y + $h

	GUICtrlCreateGroup("DROP ranges && REMAIN", $x, $y, $w, 180)
		GUICtrlCreateLabel("Index", $x + 10, $y + 22, 40, 18)
		$g_hInpCSVIndexMin = GUICtrlCreateInput("1", $x + 60, $y + 20, 35, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
			GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
		$g_hInpCSVIndexMax = GUICtrlCreateInput("5", $x + 100, $y + 20, 35, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
			GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
		GUICtrlCreateLabel("Qty", $x + 150, $y + 22, 30, 18)
		$g_hInpCSVQtyMin = GUICtrlCreateInput("1", $x + 190, $y + 20, 35, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
			GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
		$g_hInpCSVQtyMax = GUICtrlCreateInput("5", $x + 230, $y + 20, 35, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
			GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
		GUICtrlCreateLabel("Point delay", $x + 10, $y + 50, 70, 18)
		$g_hInpCSVDelayPointMin = GUICtrlCreateInput("0", $x + 90, $y + 48, 35, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
			GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
		$g_hInpCSVDelayPointMax = GUICtrlCreateInput("0", $x + 130, $y + 48, 35, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
			GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
		GUICtrlCreateLabel("Drop delay", $x + 180, $y + 50, 70, 18)
		$g_hInpCSVDelayDropMin = GUICtrlCreateInput("0", $x + 260, $y + 48, 35, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
			GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
		$g_hInpCSVDelayDropMax = GUICtrlCreateInput("0", $x + 300, $y + 48, 35, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
			GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
		GUICtrlCreateLabel("Sleep", $x + 10, $y + 78, 40, 18)
		$g_hInpCSVDelaySleepMin = GUICtrlCreateInput("0", $x + 60, $y + 76, 35, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
			GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
		$g_hInpCSVDelaySleepMax = GUICtrlCreateInput("0", $x + 100, $y + 76, 35, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
			GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")

		$g_hChkCSVDropRemaining = GUICtrlCreateCheckbox("Drop remaining troops (REMAIN)", $x + 10, $y + 110, 220, 18)
			GUICtrlSetOnEvent(-1, "CSVRemainToggle")
		$g_hChkCSVDropIncludeHeroes = GUICtrlCreateCheckbox("Include heroes", $x + 30, $y + 130, 120, 18)
			GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
		$g_hChkCSVDropIncludeSpells = GUICtrlCreateCheckbox("Include spells", $x + 30, $y + 150, 120, 18)
			GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 180
	Local $iWaitGroupH = $iBottom - $y
	If $iWaitGroupH < 120 Then $iWaitGroupH = 120
	GUICtrlCreateGroup("WAIT && break conditions", $x, $y, $w, $iWaitGroupH)
		GUICtrlCreateLabel("Wait (sec)", $x + 10, $y + 22, 65, 18)
		$g_hInpCSVWaitMin = GUICtrlCreateInput("0", $x + 80, $y + 20, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
			GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
		$g_hInpCSVWaitMax = GUICtrlCreateInput("0", $x + 125, $y + 20, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
			GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
		$g_hChkCSVBreakTH = GUICtrlCreateCheckbox("Break on Town Hall destroy", $x + 10, $y + 50, 210, 18)
			GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
		$g_hChkCSVBreakSiege = GUICtrlCreateCheckbox("Break when Siege drops", $x + 10, $y + 70, 210, 18)
			GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
		$g_hChkCSVBreak50 = GUICtrlCreateCheckbox("Break at 50% damage", $x + 10, $y + 90, 210, 18)
			GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
		$g_hChkCSVBreakAQ = GUICtrlCreateCheckbox("Trigger AQ ability", $x + 180, $y + 50, 160, 18)
			GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
		$g_hChkCSVBreakBK = GUICtrlCreateCheckbox("Trigger BK ability", $x + 180, $y + 70, 160, 18)
			GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
		$g_hChkCSVBreakGW = GUICtrlCreateCheckbox("Trigger GW ability", $x + 320, $y + 50, 160, 18)
			GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
		$g_hChkCSVBreakRC = GUICtrlCreateCheckbox("Trigger RC ability", $x + 320, $y + 70, 160, 18)
			GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
		$g_hChkCSVBreakAnyHero = GUICtrlCreateCheckbox("Any hero ability combo", $x + 180, $y + 90, 200, 18)
			GUICtrlSetOnEvent(-1, "CSVWaitComboToggle")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc   ;==>CreateCSVModDropsTab
