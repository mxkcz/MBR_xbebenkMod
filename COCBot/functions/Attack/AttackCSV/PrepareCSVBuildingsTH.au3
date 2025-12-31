
; Purpose: Adjust CSV building image sources and locate flags based on TH level.
; Assumptions: CSV locate flags already parsed; $g_oBldgLevels/$g_oBldgImages initialized.
; Author: mxkcz
; Side-effect: impure-deterministic (mutates CSV locate flags and building image map)
Func PrepareCSVBuildingsTH($iAttackingTH = $g_iMaxTHLevel)
	Local $bUnknownTH = False
	Local $iTH = _CSVNormalizeTH($iAttackingTH, $bUnknownTH)

	_CSVPrepareSuperWizTowerImages($iTH, $bUnknownTH)

	If $bUnknownTH Then Return

	_CSVDisableLocateIfLocked("g_bCSVLocateMine", $eBldgGoldM, $iTH)
	_CSVDisableLocateIfLocked("g_bCSVLocateElixir", $eBldgElixirC, $iTH)
	_CSVDisableLocateIfLocked("g_bCSVLocateDrill", $eBldgDrill, $iTH)
	_CSVDisableLocateIfLocked("g_bCSVLocateStorageGold", $eBldgGoldS, $iTH)
	_CSVDisableLocateIfLocked("g_bCSVLocateStorageElixir", $eBldgElixirS, $iTH)
	_CSVDisableLocateIfLocked("g_bCSVLocateStorageDarkElixir", $eBldgDarkS, $iTH)
	_CSVDisableLocateIfLocked("g_bCSVLocateEagle", $eBldgEagle, $iTH)
	_CSVDisableLocateIfLocked("g_bCSVLocateInferno", $eBldgInferno, $iTH)
	_CSVDisableLocateIfLocked("g_bCSVLocateXBow", $eBldgXBow, $iTH)
	_CSVDisableLocateIfLocked("g_bCSVLocateWizTower", $eBldgWizTower, $iTH)
	_CSVDisableLocateIfLocked("g_bCSVLocateSuperWizTower", $eBldgSuperWizTower, $iTH)
	_CSVDisableLocateIfLocked("g_bCSVLocateMortar", $eBldgMortar, $iTH)
	_CSVDisableLocateIfLocked("g_bCSVLocateAirDefense", $eBldgAirDefense, $iTH)
	_CSVDisableLocateIfLocked("g_bCSVLocateScatter", $eBldgScatter, $iTH)
	_CSVDisableLocateIfLocked("g_bCSVLocateSweeper", $eBldgSweeper, $iTH)
	_CSVDisableLocateIfLocked("g_bCSVLocateMonolith", $eBldgMonolith, $iTH)
	_CSVDisableLocateIfLocked("g_bCSVLocateFireSpitter", $eBldgFireSpitter, $iTH)
	_CSVDisableLocateIfLocked("g_bCSVLocateMultiArcherTower", $eBldgMultiArcherTower, $iTH)
	_CSVDisableLocateIfLocked("g_bCSVLocateMultiGearTower", $eBldgMultiGearTower, $iTH)
	_CSVDisableLocateIfLocked("g_bCSVLocateRicochetCannon", $eBldgRicochetCannon, $iTH)
	_CSVDisableLocateIfLocked("g_bCSVLocateRevengeTower", $eBldgRevengeTower, $iTH)
EndFunc   ;==>PrepareCSVBuildingsTH

; Side-effect: impure-deterministic (mutates Super Wizard Tower image mapping and reuse flag)
Func _CSVPrepareSuperWizTowerImages($iTH, $bUnknownTH)
	Local $sSuperWizPath = @ScriptDir & "\imgxml\Buildings\SuperwizTower"
	Local $sWizPath = @ScriptDir & "\imgxml\Buildings\WTower"
	Local $sWizSnowPath = @ScriptDir & "\imgxml\Buildings\WTowerSnow"
	Local $iMaxLevel = _CSVGetBldgMaxLevel($eBldgSuperWizTower, $iTH)

	If Not $bUnknownTH And $iMaxLevel > 0 Then
		$g_bCSVUseWizTowerForSuperWiz = False
		_CSVSetBldgImages($eBldgSuperWizTower, $sSuperWizPath)
		SetDebugLog("CSV prep: Super Wizard Tower imgloc -> SuperwizTower (TH" & $iTH & ")", $COLOR_DEBUG)
	Else
		$g_bCSVUseWizTowerForSuperWiz = True
		_CSVSetBldgImages($eBldgSuperWizTower, $sWizPath, $sWizSnowPath)
		SetDebugLog("CSV prep: Super Wizard Tower imgloc -> Wizard Tower (fallback)", $COLOR_DEBUG)
	EndIf
EndFunc   ;==>_CSVPrepareSuperWizTowerImages

; Side-effect: impure-deterministic (mutates CSV locate flags)
Func _CSVDisableLocateIfLocked($sFlagName, $iBuildingType, $iTH)
	If Eval($sFlagName) = False Then Return
	Local $iMaxLevel = _CSVGetBldgMaxLevel($iBuildingType, $iTH)
	If $iMaxLevel = -1 Then Return
	If $iMaxLevel <= 0 Then
		Assign($sFlagName, False)
		SetDebugLog("CSV prep: disable " & $sFlagName & " for TH" & $iTH, $COLOR_DEBUG)
	EndIf
EndFunc   ;==>_CSVDisableLocateIfLocked

; Side-effect: impure-deterministic (mutates building image map)
Func _CSVSetBldgImages($iBuildingType, $sPath, $sSnowPath = Default)
	If $sSnowPath = Default Then $sSnowPath = $sPath
	_CSVUpsertBldgImage($iBuildingType & "_0", $sPath)
	_CSVUpsertBldgImage($iBuildingType & "_1", $sSnowPath)
EndFunc   ;==>_CSVSetBldgImages

; Side-effect: impure-deterministic (mutates building image map)
Func _CSVUpsertBldgImage($sKey, $sPath)
	If _ObjSearch($g_oBldgImages, $sKey) Then
		_ObjPutValue($g_oBldgImages, $sKey, $sPath)
	Else
		_ObjAdd($g_oBldgImages, $sKey, $sPath)
	EndIf
	If @error Then _ObjErrMsg("_ObjPutValue $g_oBldgImages " & $sKey, @error)
EndFunc   ;==>_CSVUpsertBldgImage

; Side-effect: pure (returns normalized TH and unknown flag)
Func _CSVNormalizeTH($iAttackingTH, ByRef $bUnknown)
	$bUnknown = False
	Local $iTH = $iAttackingTH
	If $iTH = "-" Or $iTH = "" Then $bUnknown = True
	If Not $bUnknown And Not IsNumber($iTH) Then $bUnknown = True
	If Not $bUnknown Then $iTH = Int($iTH)
	If $bUnknown Or $iTH < 1 Then
		$bUnknown = True
		$iTH = $g_iMaxTHLevel
	EndIf
	If $iTH > $g_iMaxTHLevel Then $iTH = $g_iMaxTHLevel
	Return $iTH
EndFunc   ;==>_CSVNormalizeTH

; Side-effect: pure (reads level table)
Func _CSVGetBldgMaxLevel($iBuildingType, $iTH)
	If $iTH < 1 Then Return 0
	Local $aLevels = _ObjGetValue($g_oBldgLevels, $iBuildingType)
	If @error Then Return -1
	If Not IsArray($aLevels) Or UBound($aLevels) < $iTH Then Return 0
	Return $aLevels[$iTH - 1]
EndFunc   ;==>_CSVGetBldgMaxLevel
