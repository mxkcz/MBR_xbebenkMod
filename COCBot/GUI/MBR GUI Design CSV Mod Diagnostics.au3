; #FUNCTION# ====================================================================================================================
; Name ..........: CreateCSVModDiagnosticsTab
; Description ...: Creates diagnostics text and debug flag controls.
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
Func CreateCSVModDiagnosticsTab()
	Local $x = 10, $y = 10
	Local $w = $g_iSizeWGrpTab1 - 20

	GUICtrlCreateGroup("CSV diagnostics", $x, $y, $w, 160)
		$g_hBtnCSVRefreshDiagnostics = GUICtrlCreateButton("Refresh", $x + $w - 90, $y + 18, 80, 22)
			GUICtrlSetOnEvent(-1, "AttackCSVSettings_UpdateDiagnostics")
		$g_hTxtCSVDiagnostics = GUICtrlCreateEdit("", $x + 10, $y + 45, $w - 20, 100, BitOR($ES_READONLY, $WS_VSCROLL))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 170
	GUICtrlCreateGroup("Debug flags", $x, $y, $w, 70)
		$g_hChkCSVDbgSetlog = GUICtrlCreateCheckbox("Log", $x + 10, $y + 20, 80, 18)
			GUICtrlSetOnEvent(-1, "CSVSettings_ToggleDebugFlag")
		$g_hChkCSVDbgClick = GUICtrlCreateCheckbox("Click", $x + 90, $y + 20, 80, 18)
			GUICtrlSetOnEvent(-1, "CSVSettings_ToggleDebugFlag")
		$g_hChkCSVDbgRedArea = GUICtrlCreateCheckbox("RedArea", $x + 170, $y + 20, 90, 18)
			GUICtrlSetOnEvent(-1, "CSVSettings_ToggleDebugFlag")
		$g_hChkCSVDbgOcr = GUICtrlCreateCheckbox("OCR", $x + 260, $y + 20, 80, 18)
			GUICtrlSetOnEvent(-1, "CSVSettings_ToggleDebugFlag")
		$g_hChkCSVDbgAttackCSV = GUICtrlCreateCheckbox("AttackCSV", $x + 10, $y + 40, 100, 18)
			GUICtrlSetOnEvent(-1, "CSVSettings_ToggleDebugFlag")
		$g_hChkCSVDbgMakeImg = GUICtrlCreateCheckbox("Make IMG CSV", $x + 120, $y + 40, 120, 18)
			GUICtrlSetOnEvent(-1, "CSVSettings_ToggleDebugFlag")
		$g_hLblCSVDbgSummary = GUICtrlCreateLabel("Debug summary: -", $x + 260, $y + 40, $w - 270, 18)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 80
	GUICtrlCreateGroup("Diagnostics tail", $x, $y, $w, $g_iSizeHGrpTab1 - $y - 10)
		$g_hTxtCSVDebugLines = GUICtrlCreateEdit("", $x + 10, $y + 20, $w - 20, $g_iSizeHGrpTab1 - $y - 35, BitOR($ES_READONLY, $WS_VSCROLL))
	GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc   ;==>CreateCSVModDiagnosticsTab
