; #FUNCTION# ====================================================================================================================
; Name ..........: CreateCSVModPrecalcTab
; Description ...: Creates precalc status and rebuild controls.
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
Func CreateCSVModPrecalcTab()
	Local $x = 10, $y = 10
	Local $w = $g_iSizeWGrpTab1 - 20

	GUICtrlCreateGroup("Precache mode", $x, $y, $w, 70)
		$g_hRadCSVPrecacheConservative = GUICtrlCreateRadio("Conservative", $x + 10, $y + 22, 100, 18)
			GUICtrlSetOnEvent(-1, "CSVSettings_SetPrecacheMode")
		$g_hRadCSVPrecacheAggressive = GUICtrlCreateRadio("Aggressive", $x + 120, $y + 22, 90, 18)
			GUICtrlSetOnEvent(-1, "CSVSettings_SetPrecacheMode")
		$g_hLblCSVPrecacheBudget = GUICtrlCreateLabel("Precalc budget: -", $x + 10, $y + 42, $w - 20, 18)
		$g_hLblCSVPrecacheLast = GUICtrlCreateLabel("Last precalc: -", $x + 10, $y + 58, $w - 20, 18)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 80
	GUICtrlCreateGroup("Precalc status", $x, $y, $w, $g_iSizeHGrpTab1 - $y - 10)
		$g_hTxtCSVPrecalcStatus = GUICtrlCreateEdit("", $x + 10, $y + 20, $w - 20, $g_iSizeHGrpTab1 - $y - 35, BitOR($ES_READONLY, $WS_VSCROLL))
	GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc   ;==>CreateCSVModPrecalcTab
