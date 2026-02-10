; #FUNCTION# ====================================================================================================================
; Name ..........: CreateCSVModSideTab
; Description ...: Creates SIDE and SIDEB weight controls.
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
Func CreateCSVModSideTab()
	Local $x = 0, $y = 0, $w = 0, $h = 0
	CSVMod_GetContentBounds($x, $y, $w, $h)
	Local $aSideWeightNames[7] = ["Gold Mines", "Elixir Collectors", "Dark Drills", "Gold Storage", "Elixir Storage", "Dark Storage", "Town Hall"]
	Local $aSideBWeightNames[14] = ["Eagle", "Inferno", "X-Bow", "Wizard Tower/Super Wiz", "Mortar", "Air Defense", "Scattershot", "Sweeper", "Monolith", "Fire Spitter", "Multi Archer", "Multi Gear", "Ricochet Cannon", "Revenge Tower"]

	GUICtrlCreateGroup("Forced side", $x, $y, $w, 55)
		$g_hCmbCSVForceSide = GUICtrlCreateCombo("", $x + 10, $y + 20, $w - 20, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "Auto (weight-based)|TOP-LEFT|TOP-RIGHT|BOTTOM-LEFT|BOTTOM-RIGHT|TOP-RAND", "Auto (weight-based)")
			GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 65
	GUICtrlCreateGroup("SIDE weights (resource)", $x, $y, $w, 160)
		Local $iColW = Int(($w - 20) / 2)
		Local $iLabelW = $iColW - 45
		If $iLabelW < 70 Then $iLabelW = 70
		Local $iInputW = $iColW - $iLabelW - 10
		If $iInputW < 35 Then $iInputW = 35
		If $iInputW > 50 Then $iInputW = 50
		For $i = 0 To UBound($aSideWeightNames) - 1
			Local $iRow = Mod($i, 4), $iCol = Int($i / 4)
			Local $iOffsetX = $x + 10 + ($iCol * $iColW), $iOffsetY = $y + 20 + ($iRow * 30)
			GUICtrlCreateLabel($aSideWeightNames[$i] & ":", $iOffsetX, $iOffsetY + 3, $iLabelW, 18)
			$g_ahCSVSideWeightInputs[$i] = GUICtrlCreateInput("0", $iOffsetX + $iLabelW + 5, $iOffsetY, $iInputW, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
			$g_ahCSVSideWeightSpin[$i] = GUICtrlCreateUpdown($g_ahCSVSideWeightInputs[$i])
				GUICtrlSetLimit(-1, 99, 0)
			GUICtrlSetOnEvent($g_ahCSVSideWeightInputs[$i], "CSVSettings_MarkDirty")
		Next
		$g_hBtnCSVSideZero = GUICtrlCreateButton("Zero", $x + 10, $y + 125, 70, 20)
			GUICtrlSetOnEvent(-1, "CSVSideWeightsPresetZero")
		$g_hBtnCSVSideEqual = GUICtrlCreateButton("Equal", $x + 90, $y + 125, 70, 20)
			GUICtrlSetOnEvent(-1, "CSVSideWeightsPresetEqual")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 170
	GUICtrlCreateGroup("SIDEB weights (defenses)", $x, $y, $w, 185)
		Local $iColBW = Int(($w - 20) / 2)
		Local $iLabelBW = $iColBW - 50
		If $iLabelBW < 90 Then $iLabelBW = 90
		Local $iInputBW = $iColBW - $iLabelBW - 10
		If $iInputBW < 35 Then $iInputBW = 35
		If $iInputBW > 50 Then $iInputBW = 50
		For $j = 0 To UBound($aSideBWeightNames) - 1
			Local $iRowB = Mod($j, 7), $iColB = Int($j / 7)
			Local $iOffsetXB = $x + 10 + ($iColB * $iColBW), $iOffsetYB = $y + 20 + ($iRowB * 23)
			GUICtrlCreateLabel($aSideBWeightNames[$j] & ":", $iOffsetXB, $iOffsetYB + 3, $iLabelBW, 18)
			$g_ahCSVSideBWeightInputs[$j] = GUICtrlCreateInput("0", $iOffsetXB + $iLabelBW + 5, $iOffsetYB, $iInputBW, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
			$g_ahCSVSideBWeightSpin[$j] = GUICtrlCreateUpdown($g_ahCSVSideBWeightInputs[$j])
				GUICtrlSetLimit(-1, 99, 0)
			GUICtrlSetOnEvent($g_ahCSVSideBWeightInputs[$j], "CSVSettings_MarkDirty")
		Next
		$g_hBtnCSVSideBZero = GUICtrlCreateButton("Zero", $x + 10, $y + 155, 70, 20)
			GUICtrlSetOnEvent(-1, "CSVSideBWeightsPresetZero")
		$g_hBtnCSVSideBEqual = GUICtrlCreateButton("Equal", $x + 90, $y + 155, 70, 20)
			GUICtrlSetOnEvent(-1, "CSVSideBWeightsPresetEqual")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc   ;==>CreateCSVModSideTab
