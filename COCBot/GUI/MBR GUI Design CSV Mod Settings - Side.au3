; #FUNCTION# ====================================================================================================================
; Name ..........: CreateCSVModSideTab
; Description ...: Creates SIDE and SIDEB tabbed weight controls.
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: mxkcz
; Modified ......: mxkcz
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; =====================================================================================================================
Func CreateCSVModSideTab()
	Local $x = 0, $y = 0, $w = 0, $h = 0
	CSVMod_GetSettingsSubTabBounds($x, $y, $w, $h)
	If $w <= 0 Or $h <= 0 Then Return

	$g_hGUI_CSVSIDE = _GUICreate("", $w, $h, $x, $y, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_CSVMOD_SETTINGS)
	GUISwitch($g_hGUI_CSVSIDE)

	Local Const $iForcedGroupH = 55
	Local Const $iGap = 6
	Local $iTabY = $iForcedGroupH + $iGap
	Local $iTabH = $h - ($iForcedGroupH + $iGap)
	If $iTabH < 80 Then $iTabH = 80

	$g_hGrpCSVSideResourceForced = GUICtrlCreateGroup("Forced side", 0, 0, $w, $iForcedGroupH)
		$g_hCmbCSVForceSide = GUICtrlCreateCombo("", 10, 20, $w - 20, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "Auto (weight-based)|TOP-LEFT|TOP-RIGHT|BOTTOM-LEFT|BOTTOM-RIGHT|TOP-RAND", "Auto (weight-based)")
			GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$g_hGUI_CSVSIDE_TAB = GUICtrlCreateTab(0, $iTabY, $w, $iTabH, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))
	$g_hGUI_CSVSIDE_TAB_SIDE = GUICtrlCreateTabItem("SIDE")
		CSVSide_CreateWeightsPage(False, 0, $iTabY + 26, $w, $iTabH - 32)
	$g_hGUI_CSVSIDE_TAB_SIDEB = GUICtrlCreateTabItem("SIDEB")
		CSVSide_CreateWeightsPage(True, 0, $iTabY + 26, $w, $iTabH - 32)
	GUICtrlCreateTabItem("")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	If $g_hGUI_CSVSIDE_TAB <> 0 Then
		Local $hSideTab = GUICtrlGetHandle($g_hGUI_CSVSIDE_TAB)
		If $hSideTab <> 0 Then
			If $g_iCSVSideTabSelected <> $g_iCSVSideTabSIDE And $g_iCSVSideTabSelected <> $g_iCSVSideTabSIDEB Then $g_iCSVSideTabSelected = $g_iCSVSideTabSIDE
			_GUICtrlTab_SetCurSel($hSideTab, $g_iCSVSideTabSelected)
		EndIf
	EndIf

	GUISetState(@SW_HIDE, $g_hGUI_CSVSIDE)
	GUISwitch($g_hGUI_CSVMOD_SETTINGS)
EndFunc   ;==>CreateCSVModSideTab

; #FUNCTION# ====================================================================================================================
; Name ..........: CSVSide_CreateWeightsPage
; Description ...: Creates one inner SIDE/SIDEB tab page and wires dynamic weight rows.
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; =====================================================================================================================
Func CSVSide_CreateWeightsPage($bSideB, $x, $y, $w, $h)
	If $h < 60 Then $h = 60

	Local $iCount = ($bSideB ? UBound($g_asCSVSideBWeightNames) : UBound($g_asCSVSideWeightNames))
	Local $iColumns = 2
	Local $iRowsPerColumn = Int(($iCount + $iColumns - 1) / $iColumns)

	Local $iTopPad = 20
	Local $iBottomPad = 32
	Local $iRowStep = Int(($h - $iTopPad - $iBottomPad) / $iRowsPerColumn)
	If $iRowStep < 16 Then $iRowStep = 16

	Local $iColW = Int(($w - 20) / $iColumns)
	Local $iLabelW = $iColW - 50
	If $iLabelW < 90 Then $iLabelW = 90
	Local $iInputW = $iColW - $iLabelW - 10
	If $iInputW < 35 Then $iInputW = 35
	If $iInputW > 50 Then $iInputW = 50

	If $bSideB Then
		$g_hGrpCSVSideDefenseWeights = GUICtrlCreateGroup("SIDEB weights (defenses)", $x, $y, $w, $h)
	Else
		$g_hGrpCSVSideResourceWeights = GUICtrlCreateGroup("SIDE weights (resources)", $x, $y, $w, $h)
	EndIf

	For $i = 0 To $iCount - 1
		Local $iRow = Mod($i, $iRowsPerColumn)
		Local $iCol = Int($i / $iRowsPerColumn)
		Local $iOffsetX = $x + 10 + ($iCol * $iColW)
		Local $iOffsetY = $y + $iTopPad + ($iRow * $iRowStep)
		Local $sName = ($bSideB ? $g_asCSVSideBWeightNames[$i] : $g_asCSVSideWeightNames[$i])
		Local $hLabel = GUICtrlCreateLabel($sName & ":", $iOffsetX, $iOffsetY + 3, $iLabelW, 18)
		Local $hInput = GUICtrlCreateInput("0", $iOffsetX + $iLabelW + 5, $iOffsetY, $iInputW, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
		Local $hSpin = GUICtrlCreateUpdown($hInput)
		GUICtrlSetLimit(-1, 99, 0)
		GUICtrlSetOnEvent($hInput, "CSVSettings_MarkDirty")

		If $bSideB Then
			$g_ahCSVSideBWeightLabels[$i] = $hLabel
			$g_ahCSVSideBWeightInputs[$i] = $hInput
			$g_ahCSVSideBWeightSpin[$i] = $hSpin
		Else
			$g_ahCSVSideWeightLabels[$i] = $hLabel
			$g_ahCSVSideWeightInputs[$i] = $hInput
			$g_ahCSVSideWeightSpin[$i] = $hSpin
		EndIf
	Next

	Local $iButtonsY = $y + $h - 26
	If $bSideB Then
		$g_hBtnCSVSideBZero = GUICtrlCreateButton("Zero", $x + 10, $iButtonsY, 70, 20)
			GUICtrlSetOnEvent(-1, "CSVSideBWeightsPresetZero")
		$g_hBtnCSVSideBEqual = GUICtrlCreateButton("Equal", $x + 90, $iButtonsY, 70, 20)
			GUICtrlSetOnEvent(-1, "CSVSideBWeightsPresetEqual")
	Else
		$g_hBtnCSVSideZero = GUICtrlCreateButton("Zero", $x + 10, $iButtonsY, 70, 20)
			GUICtrlSetOnEvent(-1, "CSVSideWeightsPresetZero")
		$g_hBtnCSVSideEqual = GUICtrlCreateButton("Equal", $x + 90, $iButtonsY, 70, 20)
			GUICtrlSetOnEvent(-1, "CSVSideWeightsPresetEqual")
	EndIf

	GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc   ;==>CSVSide_CreateWeightsPage
