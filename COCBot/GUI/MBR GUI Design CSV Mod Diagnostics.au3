; #FUNCTION# ====================================================================================================================
; Name ..........: CreateCSVModDiagnosticsTab
; Description ...: Creates diagnostics text and debug flag controls.
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
Func CreateCSVModDiagnosticsTab()
	Local $iChildX = 0
	Local $iChildY = 25
	$g_hGUI_CSVMOD_DIAGNOSTICS = _GUICreate("", $g_iSizeWGrpTab1, $g_iSizeHGrpTab1, $iChildX, $iChildY, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_CSVMOD)
	GUISwitch($g_hGUI_CSVMOD_DIAGNOSTICS)

	Local $x = 0, $y = 0, $w = 0, $h = 0
	CSVMod_GetContentBounds($x, $y, $w, $h)

	GUICtrlCreateGroup("CSV diagnostics", $x, $y, $w, 160)
		$g_hBtnCSVRefreshDiagnostics = GUICtrlCreateButton("Refresh", $x + $w - 90, $y + 18, 80, 22)
			GUICtrlSetOnEvent(-1, "AttackCSVSettings_UpdateDiagnostics")
		$g_hTxtCSVDiagnostics = GUICtrlCreateEdit("", $x + 10, $y + 45, $w - 20, 100, BitOR($ES_READONLY, $WS_VSCROLL))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 170
	GUICtrlCreateGroup("Debug flags", $x, $y, $w, 95)
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
		$g_hChkCSVDbgAttackTiming = GUICtrlCreateCheckbox("Timing", $x + 250, $y + 40, 80, 18)
			GUICtrlSetOnEvent(-1, "CSVSettings_ToggleDebugFlag")
		$g_hChkCSVDbgRescan = GUICtrlCreateCheckbox("Rescan", $x + 330, $y + 40, 80, 18)
			GUICtrlSetOnEvent(-1, "CSVSettings_ToggleDebugFlag")
		$g_hLblCSVDbgSummary = GUICtrlCreateLabel("Debug summary: -", $x + 10, $y + 63, $w - 20, 18)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 105
	GUICtrlCreateGroup("Diagnostics tail", $x, $y, $w, ($g_iSizeHGrpTab1 - $iChildY) - $y - 10)
		$g_hTxtCSVDebugLines = GUICtrlCreateEdit("", $x + 10, $y + 20, $w - 20, ($g_iSizeHGrpTab1 - $iChildY) - $y - 35, BitOR($ES_READONLY, $WS_VSCROLL))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUISwitch($g_hGUI_CSVMOD)
EndFunc   ;==>CreateCSVModDiagnosticsTab
