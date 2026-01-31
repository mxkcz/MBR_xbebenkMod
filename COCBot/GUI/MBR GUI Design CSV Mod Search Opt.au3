; #FUNCTION# ====================================================================================================================
; Name ..........: CreateCSVModSearchOptionsTab
; Description ...: Creates search options such as reductions, delays, and attack-now toggles.
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
Func CreateCSVModSearchOptionsTab()
	CreateAttackSearchOptionsSearch()

	Local $x = 25, $y = 300
	GUICtrlCreateGroup("Auto-disable criteria", $x - 20, $y - 20, 223, 50)
		$g_hChkSearchDisableFullResources = GUICtrlCreateCheckbox("Disable filters when storage is full", $x - 5, $y, 210, 18)
			GUICtrlSetOnEvent(-1, "CSVMod_ToggleDisableFullResources")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc   ;==>CreateCSVModSearchOptionsTab
