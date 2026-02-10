; #FUNCTION# ====================================================================================================================
; Name ..........: CreateCSVModPrecalcTab
; Description ...: Creates precalc status and rebuild controls.
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
Func CreateCSVModPrecalcTab()
	Local $x = 0, $y = 0, $w = 0, $h = 0
	CSVMod_GetContentBounds($x, $y, $w, $h)

	GUICtrlCreateGroup("Precache mode", $x, $y, $w, 110)
		$g_hRadCSVPrecacheConservative = GUICtrlCreateRadio("Conservative", $x + 10, $y + 22, 100, 18)
			GUICtrlSetOnEvent(-1, "CSVSettings_SetPrecacheMode")
		$g_hRadCSVPrecacheAggressive = GUICtrlCreateRadio("Aggressive", $x + 120, $y + 22, 90, 18)
			GUICtrlSetOnEvent(-1, "CSVSettings_SetPrecacheMode")
		$g_hLblCSVPrecacheBudget = GUICtrlCreateLabel("Precalc budget: -", $x + 10, $y + 42, $w - 20, 18)
		$g_hLblCSVPrecacheLast = GUICtrlCreateLabel("Last precalc: -", $x + 10, $y + 58, $w - 20, 18)
		GUICtrlCreateLabel("Recalc side", $x + 10, $y + 80, 70, 18)
		$g_hCmbCSVRecalcSideOverride = GUICtrlCreateCombo("", $x + 85, $y + 78, 130, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "NONE|TOP-LEFT|TOP-RIGHT|BOTTOM-LEFT|BOTTOM-RIGHT|TOP-RAND", "NONE")
			GUICtrlSetOnEvent(-1, "CSVSettings_RecalcOverridesChanged")
		GUICtrlCreateLabel("Vectors", $x + 225, $y + 80, 45, 18)
		$g_hInpCSVRecalcVectors = GUICtrlCreateInput("", $x + 275, $y + 78, $w - 285, 18)
			GUICtrlSetOnEvent(-1, "CSVSettings_RecalcOverridesChanged")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 120
	GUICtrlCreateGroup("Precalc status", $x, $y, $w, $g_iSizeHGrpTab1 - $y - 10)
		$g_hTxtCSVPrecalcStatus = GUICtrlCreateEdit("", $x + 10, $y + 20, $w - 20, $g_iSizeHGrpTab1 - $y - 35, BitOR($ES_READONLY, $WS_VSCROLL))
	GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc   ;==>CreateCSVModPrecalcTab
