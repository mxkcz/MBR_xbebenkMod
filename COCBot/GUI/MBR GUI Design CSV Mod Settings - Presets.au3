; #FUNCTION# ====================================================================================================================
; Name ..........: CreateCSVModSettingsPresetsTab
; Description ...: Creates preset controls inside Settings -> Presets.
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
; Name ..........: CreateCSVModSettingsPresetsTab
; Description ...: Builds redline, dropline, and CC request preset controls.
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
Func CreateCSVModSettingsPresetsTab()
	Local $x = 0, $y = 0, $w = 0, $h = 0
	CSVMod_GetSettingsSubTabBounds($x, $y, $w, $h)

	GUICtrlCreateGroup("Presets", $x, $y, $w, $h)
		Local Const $iPresetPadX = 10
		Local Const $iPresetPadY = 22
		Local Const $iPresetGapX = 8
		Local Const $iPresetGapY = 10
		Local Const $iPresetLabelW = 100
		Local $iInnerW = $w - ($iPresetPadX * 2)
		Local $bPresetTwoColumn = ((($iPresetLabelW + 120) * 2) + ($iPresetGapX * 3) <= $iInnerW)
		Local $iPresetY = $y + $iPresetPadY

		If $bPresetTwoColumn Then
			Local $iPairW = Int(($iInnerW - $iPresetGapX) / 2)
			Local $iComboW = $iPairW - $iPresetLabelW - $iPresetGapX
			If $iComboW < 110 Then $iComboW = 110
			Local $iPair1X = $x + $iPresetPadX
			Local $iPair2X = $iPair1X + $iPairW + $iPresetGapX

			GUICtrlCreateLabel("Redline preset", $iPair1X, $iPresetY + 2, $iPresetLabelW, 18)
			$g_hCmbCSVRedlinePreset = GUICtrlCreateCombo("", $iPair1X + $iPresetLabelW + $iPresetGapX, $iPresetY, $iComboW, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
			GUICtrlCreateLabel("Dropline preset", $iPair2X, $iPresetY + 2, $iPresetLabelW, 18)
			$g_hCmbCSVDroplinePreset = GUICtrlCreateCombo("", $iPair2X + $iPresetLabelW + $iPresetGapX, $iPresetY, $iComboW, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
			$iPresetY += 18 + $iPresetGapY
		Else
			GUICtrlCreateLabel("Redline preset", $x + $iPresetPadX, $iPresetY + 2, $iPresetLabelW, 18)
			$g_hCmbCSVRedlinePreset = GUICtrlCreateCombo("", $x + $iPresetPadX + $iPresetLabelW + $iPresetGapX, $iPresetY, $iInnerW - $iPresetLabelW - $iPresetGapX, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
			$iPresetY += 18 + $iPresetGapY
			GUICtrlCreateLabel("Dropline preset", $x + $iPresetPadX, $iPresetY + 2, $iPresetLabelW, 18)
			$g_hCmbCSVDroplinePreset = GUICtrlCreateCombo("", $x + $iPresetPadX + $iPresetLabelW + $iPresetGapX, $iPresetY, $iInnerW - $iPresetLabelW - $iPresetGapX, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
				GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
			$iPresetY += 18 + $iPresetGapY
		EndIf

		GUICtrlCreateLabel("CC request", $x + $iPresetPadX, $iPresetY + 2, $iPresetLabelW, 18)
		$g_hTxtCSVCCRequest = GUICtrlCreateInput("", $x + $iPresetPadX + $iPresetLabelW + $iPresetGapX, $iPresetY, $iInnerW - $iPresetLabelW - $iPresetGapX, 18)
			GUICtrlSetOnEvent(-1, "CSVSettings_MarkDirty")
		$iPresetY += 18 + $iPresetGapY + 2

		GUICtrlCreateLabel("Save preset values with Script -> Save CSV.", $x + $iPresetPadX, $iPresetY, $iInnerW, 18)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc   ;==>CreateCSVModSettingsPresetsTab
