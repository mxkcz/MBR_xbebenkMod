; #FUNCTION# ====================================================================================================================
; Name ..........: ParseAttackCSV_Read_SIDE_variables
; Description ...:
; Syntax ........: ParseAttackCSV_Read_SIDE_variables()
; Parameters ....:
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
; CSV parse cache for attack scripts (shared across ParseAttackCSV*).
Global $g_sCSVCacheName = ""
Global $g_sCSVCachePath = ""
Global $g_sCSVCacheMTime = ""
Global $g_aCSVCacheLines[0]
Global $g_aCSVCacheTokens[0]

; Side-effect: io (reads CSV file), impure-deterministic (updates in-memory cache)
Func _CSVGetCachedLinesAndTokens($sFilename, ByRef $aLines, ByRef $aTokens)
	Local $sPath = $g_sCSVAttacksPath & "\" & $sFilename & ".csv"
	If Not FileExists($sPath) Then Return SetError(1, 0, 0)

	Local Const $kFileTimeModified = 1
	Local Const $kFileTimeString = 1
	Local $sMTime = FileGetTime($sPath, $kFileTimeModified, $kFileTimeString)
	If @error Then $sMTime = ""

	If $g_sCSVCachePath = $sPath And $g_sCSVCacheName = $sFilename And $g_sCSVCacheMTime = $sMTime Then
		If IsArray($g_aCSVCacheLines) And IsArray($g_aCSVCacheTokens) Then
			$aLines = $g_aCSVCacheLines
			$aTokens = $g_aCSVCacheTokens
			Return 1
		EndIf
	EndIf

	Local $aReadLines = FileReadToArray($sPath)
	If @error Then Return SetError(2, 0, 0)

	Local $aReadTokens[UBound($aReadLines)]
	For $i = 0 To UBound($aReadLines) - 1
		$aReadTokens[$i] = StringSplit($aReadLines[$i], "|")
	Next

	$g_sCSVCacheName = $sFilename
	$g_sCSVCachePath = $sPath
	$g_sCSVCacheMTime = $sMTime
	$g_aCSVCacheLines = $aReadLines
	$g_aCSVCacheTokens = $aReadTokens

	$aLines = $g_aCSVCacheLines
	$aTokens = $g_aCSVCacheTokens
	Return 1
EndFunc   ;==>_CSVGetCachedLinesAndTokens

Func ParseAttackCSV_Read_SIDE_variables()

	$g_bCSVLocateMine = False
	$g_bCSVLocateElixir = False
	$g_bCSVLocateDrill = False
	$g_bCSVLocateStorageGold = False
	$g_bCSVLocateStorageElixir = False
	$g_bCSVLocateStorageDarkElixir = False
	$g_bCSVLocateStorageTownHall = False
	$g_bCSVLocateEagle = False
	$g_bCSVLocateScatter = False
	$g_bCSVLocateInferno = False
	$g_bCSVLocateXBow = False
	$g_bCSVLocateWizTower = False
	$g_bCSVLocateMortar = False
	$g_bCSVLocateAirDefense = False
	$g_bCSVLocateSweeper = False
	$g_bCSVLocateMonolith = False
	$g_bCSVLocateFireSpitter = False
	$g_bCSVLocateMultiArcherTower = False
	$g_bCSVLocateMultiGearTower = False
	$g_bCSVLocateRicochetCannon = False
	$g_bCSVLocateSuperWizTower = False
	$g_bCSVLocateRevengeTower = False
	$g_bCSVLocateWall = False
	; $g_bCSVLocateGemBox = False
	Local $bPrioMakeFound = False
	For $i = 0 To UBound($g_aiCSVSideBWeights) - 1
		$g_aiCSVSideBWeights[$i] = 0
	Next

	If $g_iMatchMode = $DB Then
		Local $filename = $g_sAttackScrScriptName[$DB]
	Else
		Local $filename = $g_sAttackScrScriptName[$LB]
	EndIf

	Local $f, $line, $acommand, $command
	Local $value1, $value2, $value3, $value4, $value5, $value6, $value7, $value8, $value9, $value10, $value11, $value12, $value13, $value14
	Local $bForceSideExist = False

	Local $aLines, $aTokens
	If _CSVGetCachedLinesAndTokens($filename, $aLines, $aTokens) Then
		For $iLine = 0 To UBound($aLines) - 1
			$line = $aLines[$iLine]
			$acommand = $aTokens[$iLine]
			If Not IsArray($acommand) Then $acommand = StringSplit($line, "|")
			If $acommand[0] >= 8 Then
				$command = StringStripWS(StringUpper($acommand[1]), $STR_STRIPTRAILING)

				If $command <> "SIDE" And $command <> "SIDEB" And $command <> "MAKE" Then ContinueLoop

				$value1 = ($acommand[0] >= 2 ? StringStripWS(StringUpper($acommand[2]), $STR_STRIPTRAILING) : "")
				$value2 = ($acommand[0] >= 3 ? StringStripWS(StringUpper($acommand[3]), $STR_STRIPTRAILING) : "")
				$value3 = ($acommand[0] >= 4 ? StringStripWS(StringUpper($acommand[4]), $STR_STRIPTRAILING) : "")
				$value4 = ($acommand[0] >= 5 ? StringStripWS(StringUpper($acommand[5]), $STR_STRIPTRAILING) : "")
				$value5 = ($acommand[0] >= 6 ? StringStripWS(StringUpper($acommand[6]), $STR_STRIPTRAILING) : "")
				$value6 = ($acommand[0] >= 7 ? StringStripWS(StringUpper($acommand[7]), $STR_STRIPTRAILING) : "")
				$value7 = ($acommand[0] >= 8 ? StringStripWS(StringUpper($acommand[8]), $STR_STRIPTRAILING) : "")
				$value8 = ($acommand[0] >= 9 ? StringStripWS(StringUpper($acommand[9]), $STR_STRIPTRAILING) : "")
				$value9 = ($acommand[0] >= 10 ? StringStripWS(StringUpper($acommand[10]), $STR_STRIPTRAILING) : "")
				$value10 = ($acommand[0] >= 11 ? StringStripWS(StringUpper($acommand[11]), $STR_STRIPTRAILING) : "")
				$value11 = ($acommand[0] >= 12 ? StringStripWS(StringUpper($acommand[12]), $STR_STRIPTRAILING) : "")
				$value12 = ($acommand[0] >= 13 ? StringStripWS(StringUpper($acommand[13]), $STR_STRIPTRAILING) : "")
				$value13 = ($acommand[0] >= 14 ? StringStripWS(StringUpper($acommand[14]), $STR_STRIPTRAILING) : "")
				$value14 = ($acommand[0] >= 15 ? StringStripWS(StringUpper($acommand[15]), $STR_STRIPTRAILING) : "")

				If $command = "SIDE" And StringUpper($value8) = "TOP-LEFT" Or StringUpper($value8) = "TOP-RIGHT" Or StringUpper($value8) = "BOTTOM-LEFT" Or StringUpper($value8) = "BOTTOM-RIGHT" Then
					$bForceSideExist = True ;keep original values
				EndIf

				Switch $command
					Case "SIDE" ;if this line uses a building, then it must be detected
						If $bForceSideExist = False Then
							If Int($value1) > 0 Then $g_bCSVLocateMine = True
							If Int($value2) > 0 Then $g_bCSVLocateElixir = True
							If Int($value3) > 0 Then $g_bCSVLocateDrill = True
							If Int($value4) > 0 Then $g_bCSVLocateStorageGold = True
							If Int($value5) > 0 Then $g_bCSVLocateStorageElixir = True
							If Int($value6) > 0 Then $g_bCSVLocateStorageDarkElixir = True
							If Int($value7) > 0 Then $g_bCSVLocateStorageTownHall = True
							; $value8 = Forced Side value
						EndIf
					Case "SIDEB"
						If $bForceSideExist = False Then
							If Int($value1) > 0 Then $g_bCSVLocateEagle = True
							If Int($value2) > 0 Then $g_bCSVLocateInferno = True
							If Int($value3) > 0 Then $g_bCSVLocateXBow = True
							If Int($value4) > 0 Then
								$g_bCSVLocateWizTower = True
								$g_bCSVLocateSuperWizTower = True
							EndIf
							If Int($value5) > 0 Then $g_bCSVLocateMortar = True
							If Int($value6) > 0 Then $g_bCSVLocateAirDefense = True
								If Int($value7) > 0 Then $g_bCSVLocateScatter = True
								If Int($value8) > 0 Then $g_bCSVLocateSweeper = True
								If Int($value9) > 0 Then $g_bCSVLocateMonolith = True
								If Int($value10) > 0 Then $g_bCSVLocateFireSpitter = True
								If Int($value11) > 0 Then $g_bCSVLocateMultiArcherTower = True
								If Int($value12) > 0 Then $g_bCSVLocateRicochetCannon = True
								If Int($value13) > 0 Then $g_bCSVLocateRevengeTower = True
								; $value14 = Gem Box placeholder
						EndIf
						$g_aiCSVSideBWeights[0] = Int($value1)
						$g_aiCSVSideBWeights[1] = Int($value2)
						$g_aiCSVSideBWeights[2] = Int($value3)
						$g_aiCSVSideBWeights[3] = Int($value4)
						$g_aiCSVSideBWeights[4] = Int($value5)
						$g_aiCSVSideBWeights[5] = Int($value6)
						$g_aiCSVSideBWeights[6] = Int($value7)
						$g_aiCSVSideBWeights[7] = Int($value8)
						$g_aiCSVSideBWeights[8] = Int($value9)
						$g_aiCSVSideBWeights[9] = Int($value10)
						$g_aiCSVSideBWeights[10] = Int($value11)
						$g_aiCSVSideBWeights[11] = Int($value12)
						$g_aiCSVSideBWeights[12] = Int($value13)
						$g_aiCSVSideBWeights[13] = Int($value14)
					Case "MAKE" ; check if targeted building vectors are used im MAKE commands >> starting in V7.2+
						If StringLen(StringStripWS($value8, $STR_STRIPALL)) > 0 Then ; check for empty string?
							Switch $value8
								Case "PRIO"
									$bPrioMakeFound = True
								Case "TOWNHALL"
									$g_bCSVLocateStorageTownHall = True
								Case "EAGLE"
									$g_bCSVLocateEagle = True
								Case "INFERNO"
									$g_bCSVLocateInferno = True
								Case "XBOW"
									$g_bCSVLocateXBow = True
								Case "SCATTER"
									$g_bCSVLocateScatter = True
								Case "WIZTOWER"
									$g_bCSVLocateWizTower = True
								Case "MORTAR"
									$g_bCSVLocateMortar = True
								Case "AIRDEFENSE"
									$g_bCSVLocateAirDefense = True
								Case "SWEEPER"
									$g_bCSVLocateSweeper = True
								Case "MONOLITH"
									$g_bCSVLocateMonolith = True
								Case "MULTIARCHER"
									$g_bCSVLocateMultiArcherTower = True
									$g_bCSVLocateMultiGearTower = True
								Case "MULTIGEAR"
									$g_bCSVLocateMultiGearTower = True
								Case "RICOCHETCA"
									$g_bCSVLocateRicochetCannon = True
								Case "FIRESPITTER"
									$g_bCSVLocateFireSpitter = True
								Case "SUPERWIZTW"
									$g_bCSVLocateSuperWizTower = True
								Case "REVENGETW"
									$g_bCSVLocateRevengeTower = True
								Case "EX-WALL"
									$g_bCSVLocateWall = True
								Case "IN-WALL"
									$g_bCSVLocateWall = True
								Case Else
									SetDebugLog("Invalid MAKE building target name: " & $value8, $COLOR_WARNING)
									debugAttackCSV("Invalid MAKE building target name: " & $value8)
							EndSwitch
							debugAttackCSV("SIDE Parse MAKE target building= " & $value8)
						EndIf
				EndSwitch
			EndIf
		Next
		If $bPrioMakeFound Then _CSVEnablePrioLocateFromWeights()
	Else
		Switch @error
			Case 2
				SetLog("Attack CSV script not found: " & $g_sCSVAttacksPath & "\" & $filename & ".csv", $COLOR_ERROR)
			Case Else
				SetLog("Cannot find attack file " & $g_sCSVAttacksPath & "\" & $filename & ".csv", $COLOR_ERROR)
		EndSwitch
		Return
	EndIf
EndFunc   ;==>ParseAttackCSV_Read_SIDE_variables

; #FUNCTION# ====================================================================================================================
; Name ..........: PrepareAttackCSV
; Description ...: Pre-scan CSV script to cache locate flags, weights, and MAKE usage before search.
; Syntax ........: PrepareAttackCSV($iMode[, $bForce = False])
; Parameters ....: $iMode             - Match mode index ($DB/$LB).
;                  $bForce            - [optional] Force refresh even if cache is valid. Default is False.
; Return values .: Success: 1
;                  Failure: 0 and @error set.
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
; Side-effect: io (reads CSV file), impure-deterministic (updates CSV prep caches)
Func PrepareAttackCSV($iMode, $bForce = False)
	If $iMode < 0 Or $iMode >= $g_iModeCount Then Return SetError(1, 0, 0)
	If $g_aiAttackAlgorithm[$iMode] <> 1 Then Return SetError(2, 0, 0)

	Local $sFilename = $g_sAttackScrScriptName[$iMode]
	If $sFilename = "" Then
		_CSVPrepResetMode($iMode)
		Return SetError(3, 0, 0)
	EndIf

	Local $sPath = $g_sCSVAttacksPath & "\" & $sFilename & ".csv"
	If Not FileExists($sPath) Then
		_CSVPrepResetMode($iMode)
		SetLog("Attack CSV script not found: " & $sPath, $COLOR_ERROR)
		Return SetError(4, 0, 0)
	EndIf

	Local Const $kFileTimeModified = 1
	Local Const $kFileTimeString = 1
	Local $sMTime = FileGetTime($sPath, $kFileTimeModified, $kFileTimeString)
	If @error Then $sMTime = ""

	If Not $bForce And $g_abCSVPrepValid[$iMode] And $g_asCSVPrepName[$iMode] = $sFilename And $g_asCSVPrepMTime[$iMode] = $sMTime Then
		Return 1
	EndIf

	Local $aLocate[$eCSVLocateCount]
	Local $aWeights[14]
	Local $aSidesUsed[4] = [False, False, False, False]
	Local $bAllMakeTargeted = False
	Local $bPrioMakeFound = False
	Local $sTargetEnums = ""
	Local $bForceSideExist = False

	Local $aLines, $aTokens
	If Not _CSVGetCachedLinesAndTokens($sFilename, $aLines, $aTokens) Then
		_CSVPrepResetMode($iMode)
		SetLog("Cannot read attack file " & $sPath, $COLOR_ERROR)
		Return SetError(5, 0, 0)
	EndIf

	For $iLine = 0 To UBound($aLines) - 1
		Local $line = $aLines[$iLine]
		Local $acommand = $aTokens[$iLine]
		If Not IsArray($acommand) Then $acommand = StringSplit($line, "|")
		If $acommand[0] < 8 Then ContinueLoop

		Local $command = StringStripWS(StringUpper($acommand[1]), $STR_STRIPTRAILING)
		If $command <> "SIDE" And $command <> "SIDEB" And $command <> "MAKE" Then ContinueLoop

		Local $value1 = ($acommand[0] >= 2 ? StringStripWS(StringUpper($acommand[2]), $STR_STRIPTRAILING) : "")
		Local $value2 = ($acommand[0] >= 3 ? StringStripWS(StringUpper($acommand[3]), $STR_STRIPTRAILING) : "")
		Local $value3 = ($acommand[0] >= 4 ? StringStripWS(StringUpper($acommand[4]), $STR_STRIPTRAILING) : "")
		Local $value4 = ($acommand[0] >= 5 ? StringStripWS(StringUpper($acommand[5]), $STR_STRIPTRAILING) : "")
		Local $value5 = ($acommand[0] >= 6 ? StringStripWS(StringUpper($acommand[6]), $STR_STRIPTRAILING) : "")
		Local $value6 = ($acommand[0] >= 7 ? StringStripWS(StringUpper($acommand[7]), $STR_STRIPTRAILING) : "")
		Local $value7 = ($acommand[0] >= 8 ? StringStripWS(StringUpper($acommand[8]), $STR_STRIPTRAILING) : "")
		Local $value8 = ($acommand[0] >= 9 ? StringStripWS(StringUpper($acommand[9]), $STR_STRIPTRAILING) : "")
		Local $value9 = ($acommand[0] >= 10 ? StringStripWS(StringUpper($acommand[10]), $STR_STRIPTRAILING) : "")
		Local $value10 = ($acommand[0] >= 11 ? StringStripWS(StringUpper($acommand[11]), $STR_STRIPTRAILING) : "")
		Local $value11 = ($acommand[0] >= 12 ? StringStripWS(StringUpper($acommand[12]), $STR_STRIPTRAILING) : "")
		Local $value12 = ($acommand[0] >= 13 ? StringStripWS(StringUpper($acommand[13]), $STR_STRIPTRAILING) : "")
		Local $value13 = ($acommand[0] >= 14 ? StringStripWS(StringUpper($acommand[14]), $STR_STRIPTRAILING) : "")
		Local $value14 = ($acommand[0] >= 15 ? StringStripWS(StringUpper($acommand[15]), $STR_STRIPTRAILING) : "")

		If $command = "SIDE" And (StringUpper($value8) = "TOP-LEFT" Or StringUpper($value8) = "TOP-RIGHT" Or StringUpper($value8) = "BOTTOM-LEFT" Or StringUpper($value8) = "BOTTOM-RIGHT") Then
			$bForceSideExist = True ; keep original values
		EndIf

		Switch $command
			Case "SIDE"
				If $bForceSideExist = False Then
					If Int($value1) > 0 Then $aLocate[$eCSVLocateMine] = True
					If Int($value2) > 0 Then $aLocate[$eCSVLocateElixir] = True
					If Int($value3) > 0 Then $aLocate[$eCSVLocateDrill] = True
					If Int($value4) > 0 Then $aLocate[$eCSVLocateStorageGold] = True
					If Int($value5) > 0 Then $aLocate[$eCSVLocateStorageElixir] = True
					If Int($value6) > 0 Then $aLocate[$eCSVLocateStorageDarkElixir] = True
					If Int($value7) > 0 Then $aLocate[$eCSVLocateStorageTownHall] = True
				EndIf
			Case "SIDEB"
				If $bForceSideExist = False Then
					If Int($value1) > 0 Then $aLocate[$eCSVLocateEagle] = True
					If Int($value2) > 0 Then $aLocate[$eCSVLocateInferno] = True
					If Int($value3) > 0 Then $aLocate[$eCSVLocateXBow] = True
					If Int($value4) > 0 Then
						$aLocate[$eCSVLocateWizTower] = True
						$aLocate[$eCSVLocateSuperWizTower] = True
					EndIf
					If Int($value5) > 0 Then $aLocate[$eCSVLocateMortar] = True
					If Int($value6) > 0 Then $aLocate[$eCSVLocateAirDefense] = True
						If Int($value7) > 0 Then $aLocate[$eCSVLocateScatter] = True
						If Int($value8) > 0 Then $aLocate[$eCSVLocateSweeper] = True
						If Int($value9) > 0 Then $aLocate[$eCSVLocateMonolith] = True
						If Int($value10) > 0 Then $aLocate[$eCSVLocateFireSpitter] = True
						If Int($value11) > 0 Then $aLocate[$eCSVLocateMultiArcherTower] = True
						If Int($value12) > 0 Then $aLocate[$eCSVLocateRicochetCannon] = True
						If Int($value13) > 0 Then $aLocate[$eCSVLocateRevengeTower] = True
				EndIf
				$aWeights[0] = Int($value1)
				$aWeights[1] = Int($value2)
				$aWeights[2] = Int($value3)
				$aWeights[3] = Int($value4)
				$aWeights[4] = Int($value5)
				$aWeights[5] = Int($value6)
				$aWeights[6] = Int($value7)
				$aWeights[7] = Int($value8)
				$aWeights[8] = Int($value9)
				$aWeights[9] = Int($value10)
				$aWeights[10] = Int($value11)
				$aWeights[11] = Int($value12)
				$aWeights[12] = Int($value13)
				$aWeights[13] = Int($value14)
			Case "MAKE"
				If StringLen(StringStripWS($value8, $STR_STRIPALL)) > 0 Then
					If Not _CSVPrepApplyMakeTarget($aLocate, $value8, $bPrioMakeFound, $sTargetEnums) Then
						SetDebugLog("Invalid MAKE building target name: " & $value8, $COLOR_WARNING)
					EndIf
				EndIf
		EndSwitch
	Next

	If $bPrioMakeFound Then _CSVPrepEnablePrioLocateFromWeights($aLocate, $aWeights)

	If Not AttackCSV_ScanMakeUsage($sFilename, $aSidesUsed, $bAllMakeTargeted) Then
		$aSidesUsed[0] = False
		$aSidesUsed[1] = False
		$aSidesUsed[2] = False
		$aSidesUsed[3] = False
		$bAllMakeTargeted = False
	EndIf

	For $i = 0 To $eCSVLocateCount - 1
		$g_abCSVPrepLocate[$iMode][$i] = $aLocate[$i]
	Next
	For $i = 0 To 13
		$g_aiCSVPrepSideBWeights[$iMode][$i] = $aWeights[$i]
	Next
	For $i = 0 To 3
		$g_abCSVPrepMakeSidesUsed[$iMode][$i] = $aSidesUsed[$i]
	Next
	$g_abCSVPrepAllMakeTargeted[$iMode] = $bAllMakeTargeted
	$g_abCSVPrepHasPrioMake[$iMode] = $bPrioMakeFound
	$g_abCSVPrepValid[$iMode] = True
	$g_asCSVPrepTargetEnums[$iMode] = $sTargetEnums
	$g_asCSVPrepName[$iMode] = $sFilename
	$g_asCSVPrepMTime[$iMode] = $sMTime

	SetDebugLog("CSV prep cached for " & $sFilename & " (mode " & $iMode & ")", $COLOR_DEBUG)
	Return 1
EndFunc   ;==>PrepareAttackCSV

; #FUNCTION# ====================================================================================================================
; Name ..........: AttackCSV_ApplyPrepared
; Description ...: Apply prepared CSV locate flags and weights for the current match.
; Syntax ........: AttackCSV_ApplyPrepared($iMode, $iTH)
; Parameters ....: $iMode             - Match mode index ($DB/$LB).
;                  $iTH               - Townhall level (may be "-").
; Return values .: Success: 1
;                  Failure: 0 and @error set.
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
; Side-effect: impure-deterministic (mutates locate flags and weights)
Func AttackCSV_ApplyPrepared($iMode, $iTH)
	If $iMode < 0 Or $iMode >= $g_iModeCount Then Return SetError(1, 0, 0)
	If Not PrepareAttackCSV($iMode) Then
		ParseAttackCSV_Read_SIDE_variables()
		PrepareCSVBuildingsTH($iTH)
		Return SetError(2, 0, 0)
	EndIf

	$g_bCSVLocateMine = $g_abCSVPrepLocate[$iMode][$eCSVLocateMine]
	$g_bCSVLocateElixir = $g_abCSVPrepLocate[$iMode][$eCSVLocateElixir]
	$g_bCSVLocateDrill = $g_abCSVPrepLocate[$iMode][$eCSVLocateDrill]
	$g_bCSVLocateStorageGold = $g_abCSVPrepLocate[$iMode][$eCSVLocateStorageGold]
	$g_bCSVLocateStorageElixir = $g_abCSVPrepLocate[$iMode][$eCSVLocateStorageElixir]
	$g_bCSVLocateStorageDarkElixir = $g_abCSVPrepLocate[$iMode][$eCSVLocateStorageDarkElixir]
	$g_bCSVLocateStorageTownHall = $g_abCSVPrepLocate[$iMode][$eCSVLocateStorageTownHall]
	$g_bCSVLocateEagle = $g_abCSVPrepLocate[$iMode][$eCSVLocateEagle]
	$g_bCSVLocateScatter = $g_abCSVPrepLocate[$iMode][$eCSVLocateScatter]
	$g_bCSVLocateInferno = $g_abCSVPrepLocate[$iMode][$eCSVLocateInferno]
	$g_bCSVLocateXBow = $g_abCSVPrepLocate[$iMode][$eCSVLocateXBow]
	$g_bCSVLocateWizTower = $g_abCSVPrepLocate[$iMode][$eCSVLocateWizTower]
	$g_bCSVLocateMortar = $g_abCSVPrepLocate[$iMode][$eCSVLocateMortar]
	$g_bCSVLocateAirDefense = $g_abCSVPrepLocate[$iMode][$eCSVLocateAirDefense]
	$g_bCSVLocateSweeper = $g_abCSVPrepLocate[$iMode][$eCSVLocateSweeper]
	$g_bCSVLocateMonolith = $g_abCSVPrepLocate[$iMode][$eCSVLocateMonolith]
	$g_bCSVLocateFireSpitter = $g_abCSVPrepLocate[$iMode][$eCSVLocateFireSpitter]
	$g_bCSVLocateMultiArcherTower = $g_abCSVPrepLocate[$iMode][$eCSVLocateMultiArcherTower]
	$g_bCSVLocateMultiGearTower = $g_abCSVPrepLocate[$iMode][$eCSVLocateMultiGearTower]
	$g_bCSVLocateRicochetCannon = $g_abCSVPrepLocate[$iMode][$eCSVLocateRicochetCannon]
	$g_bCSVLocateSuperWizTower = $g_abCSVPrepLocate[$iMode][$eCSVLocateSuperWizTower]
	$g_bCSVLocateRevengeTower = $g_abCSVPrepLocate[$iMode][$eCSVLocateRevengeTower]
	$g_bCSVLocateWall = $g_abCSVPrepLocate[$iMode][$eCSVLocateWall]

	For $i = 0 To UBound($g_aiCSVSideBWeights) - 1
		$g_aiCSVSideBWeights[$i] = $g_aiCSVPrepSideBWeights[$iMode][$i]
	Next

	If $g_abCSVPrepHasPrioMake[$iMode] Then _CSVEnablePrioLocateFromWeights()
	PrepareCSVBuildingsTH($iTH)
	Return 1
EndFunc   ;==>AttackCSV_ApplyPrepared

; #FUNCTION# ====================================================================================================================
; Name ..........: AttackCSV_GetPreparedMakeUsage
; Description ...: Retrieve cached MAKE side usage and targeted-only state for a mode.
; Syntax ........: AttackCSV_GetPreparedMakeUsage($iMode, ByRef $aSidesUsed, ByRef $bAllMakeTargeted)
; Parameters ....: $iMode             - Match mode index ($DB/$LB).
;                  $aSidesUsed        - [out] Array [TL, TR, BL, BR] of used sides (Boolean).
;                  $bAllMakeTargeted  - [out] True if all MAKE commands are targeted.
; Return values .: Success: 1
;                  Failure: 0 and @error set.
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
; Side-effect: impure-deterministic (reads prep cache)
Func AttackCSV_GetPreparedMakeUsage($iMode, ByRef $aSidesUsed, ByRef $bAllMakeTargeted)
	If $iMode < 0 Or $iMode >= $g_iModeCount Then Return SetError(1, 0, 0)
	If Not PrepareAttackCSV($iMode) Then Return SetError(2, 0, 0)

	Local $aLocal[4] = [False, False, False, False]
	For $i = 0 To 3
		$aLocal[$i] = $g_abCSVPrepMakeSidesUsed[$iMode][$i]
	Next
	$aSidesUsed = $aLocal
	$bAllMakeTargeted = $g_abCSVPrepAllMakeTargeted[$iMode]
	Return 1
EndFunc   ;==>AttackCSV_GetPreparedMakeUsage

; #FUNCTION# ====================================================================================================================
; Name ..........: AttackCSV_GetTargetMaxReturnPoints
; Description ...: Compute max return points for targeted-only MAKE using defense counts and PRIO weights.
; Syntax ........: AttackCSV_GetTargetMaxReturnPoints($iMode, $iTH, $iCap)
; Parameters ....: $iMode             - Match mode index ($DB/$LB).
;                  $iTH               - Townhall level (may be "-").
;                  $iCap              - Max cap (0 disables).
; Return values .: Success: integer max return points
;                  Failure: Default on no override or @error set.
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
; Side-effect: impure-deterministic (reads prep cache and building counts)
Func AttackCSV_GetTargetMaxReturnPoints($iMode, $iTH, $iCap)
	If $iCap <= 0 Then Return Default
	If $iMode < 0 Or $iMode >= $g_iModeCount Then Return SetError(1, 0, Default)
	If Not PrepareAttackCSV($iMode) Then Return SetError(2, 0, Default)

	Local $bUnknownTH = False
	Local $iTHLocal = _CSVNormalizeTH($iTH, $bUnknownTH)
	Local $iMax = 0

	If $g_abCSVPrepHasPrioMake[$iMode] Then
		Local $aCandidateEnum[15] = [$eBldgEagle, $eBldgInferno, $eBldgXBow, $eBldgSuperWizTower, $eBldgWizTower, $eBldgMortar, $eBldgAirDefense, _
				$eBldgScatter, $eBldgSweeper, $eBldgMonolith, $eBldgFireSpitter, $eBldgMultiArcherTower, $eBldgMultiGearTower, $eBldgRicochetCannon, $eBldgRevengeTower]
		Local $aWeightIndex[15] = [0, 1, 2, 3, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]

		For $i = 0 To UBound($aCandidateEnum) - 1
			Local $iWeightIndex = $aWeightIndex[$i]
			If $iWeightIndex < 0 Or $iWeightIndex >= 14 Then ContinueLoop
			If $g_aiCSVPrepSideBWeights[$iMode][$iWeightIndex] <= 0 Then ContinueLoop
			Local $iQty = _CSVGetBldgMaxQty($aCandidateEnum[$i], $iTHLocal)
			If $iQty > $iMax Then $iMax = $iQty
		Next

		If _CSVIsWeaponizedTownHall($iTHLocal) Then
			Local $iTHWeight = 0
			For $w = 0 To 13
				If $g_aiCSVPrepSideBWeights[$iMode][$w] > $iTHWeight Then $iTHWeight = $g_aiCSVPrepSideBWeights[$iMode][$w]
			Next
			If $iTHWeight > 0 And $iMax < 1 Then $iMax = 1
		EndIf
	EndIf

	If $g_asCSVPrepTargetEnums[$iMode] <> "" Then
		Local $aEnums = StringSplit($g_asCSVPrepTargetEnums[$iMode], "|", $STR_NOCOUNT)
		For $i = 0 To UBound($aEnums) - 1
			Local $iEnum = Int($aEnums[$i])
			If $iEnum <= 0 Then ContinueLoop
			Local $iQty = _CSVGetBldgMaxQty($iEnum, $iTHLocal)
			If $iQty > $iMax Then $iMax = $iQty
		Next
	EndIf

	If $iMax <= 0 Then Return Default
	If $iMax > Int($iCap) Then $iMax = Int($iCap)
	Return $iMax
EndFunc   ;==>AttackCSV_GetTargetMaxReturnPoints

; Side-effect: impure-deterministic (mutates prep locate flags)
Func _CSVPrepEnablePrioLocateFromWeights(ByRef $aLocate, ByRef $aWeights)
	If $aWeights[0] > 0 Then $aLocate[$eCSVLocateEagle] = True
	If $aWeights[1] > 0 Then $aLocate[$eCSVLocateInferno] = True
	If $aWeights[2] > 0 Then $aLocate[$eCSVLocateXBow] = True
	If $aWeights[3] > 0 Then
		$aLocate[$eCSVLocateWizTower] = True
		$aLocate[$eCSVLocateSuperWizTower] = True
	EndIf
	If $aWeights[4] > 0 Then $aLocate[$eCSVLocateMortar] = True
	If $aWeights[5] > 0 Then $aLocate[$eCSVLocateAirDefense] = True
	If $aWeights[6] > 0 Then $aLocate[$eCSVLocateScatter] = True
	If $aWeights[7] > 0 Then $aLocate[$eCSVLocateSweeper] = True
	If $aWeights[8] > 0 Then $aLocate[$eCSVLocateMonolith] = True
	If $aWeights[9] > 0 Then $aLocate[$eCSVLocateFireSpitter] = True
	If $aWeights[10] > 0 Then $aLocate[$eCSVLocateMultiArcherTower] = True
	If $aWeights[11] > 0 Then $aLocate[$eCSVLocateMultiGearTower] = True
	If $aWeights[12] > 0 Then $aLocate[$eCSVLocateRicochetCannon] = True
	If $aWeights[13] > 0 Then $aLocate[$eCSVLocateRevengeTower] = True
EndFunc   ;==>_CSVPrepEnablePrioLocateFromWeights

; Side-effect: pure
Func _CSVGetPrioCandidateMap(ByRef $aEnums, ByRef $aNames, ByRef $aWeightIndex)
	Local $aEnumLocal[15] = [$eBldgEagle, $eBldgInferno, $eBldgXBow, $eBldgSuperWizTower, $eBldgWizTower, $eBldgMortar, $eBldgAirDefense, _
			$eBldgScatter, $eBldgSweeper, $eBldgMonolith, $eBldgFireSpitter, $eBldgMultiArcherTower, $eBldgMultiGearTower, $eBldgRicochetCannon, $eBldgRevengeTower]
	Local $aNameLocal[15] = ["EAGLE", "INFERNO", "XBOW", "SUPERWIZTW", "WIZTOWER", "MORTAR", "AIRDEFENSE", _
			"SCATTER", "SWEEPER", "MONOLITH", "FIRESPITTER", "MULTIARCHER", "MULTIGEAR", "RICOCHETCA", "REVENGETW"]
	Local $aWeightLocal[15] = [0, 1, 2, 3, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]
	$aEnums = $aEnumLocal
	$aNames = $aNameLocal
	$aWeightIndex = $aWeightLocal
	Return 1
EndFunc   ;==>_CSVGetPrioCandidateMap

; Side-effect: pure
Func _CSVLookupTargetEnum($sTarget, ByRef $iEnum, ByRef $iWeightIndex)
	$iEnum = 0
	$iWeightIndex = -1
	If $sTarget = "TOWNHALL" Then
		$iEnum = $eBldgTownHall
		Return True
	EndIf

	Local $aEnums, $aNames, $aWeightIndex
	_CSVGetPrioCandidateMap($aEnums, $aNames, $aWeightIndex)
	For $i = 0 To UBound($aNames) - 1
		If $aNames[$i] = $sTarget Then
			$iEnum = $aEnums[$i]
			$iWeightIndex = $aWeightIndex[$i]
			Return True
		EndIf
	Next
	Return False
EndFunc   ;==>_CSVLookupTargetEnum

; Side-effect: impure-deterministic (mutates prep locate flags)
Func _CSVPrepApplyMakeTarget(ByRef $aLocate, $sTarget, ByRef $bPrioMakeFound, ByRef $sTargetEnums)
	Switch $sTarget
		Case "PRIO"
			$bPrioMakeFound = True
			Return True
		Case "EX-WALL", "IN-WALL"
			$aLocate[$eCSVLocateWall] = True
			Return True
	EndSwitch

	Local $iEnum = 0
	Local $iWeightIndex = -1
	If Not _CSVLookupTargetEnum($sTarget, $iEnum, $iWeightIndex) Then Return False

	Switch $iEnum
		Case $eBldgTownHall
			$aLocate[$eCSVLocateStorageTownHall] = True
		Case $eBldgEagle
			$aLocate[$eCSVLocateEagle] = True
		Case $eBldgInferno
			$aLocate[$eCSVLocateInferno] = True
		Case $eBldgXBow
			$aLocate[$eCSVLocateXBow] = True
		Case $eBldgScatter
			$aLocate[$eCSVLocateScatter] = True
		Case $eBldgWizTower
			$aLocate[$eCSVLocateWizTower] = True
		Case $eBldgMortar
			$aLocate[$eCSVLocateMortar] = True
		Case $eBldgAirDefense
			$aLocate[$eCSVLocateAirDefense] = True
		Case $eBldgSweeper
			$aLocate[$eCSVLocateSweeper] = True
		Case $eBldgMonolith
			$aLocate[$eCSVLocateMonolith] = True
		Case $eBldgFireSpitter
			$aLocate[$eCSVLocateFireSpitter] = True
		Case $eBldgMultiArcherTower
			$aLocate[$eCSVLocateMultiArcherTower] = True
			$aLocate[$eCSVLocateMultiGearTower] = True
		Case $eBldgMultiGearTower
			$aLocate[$eCSVLocateMultiGearTower] = True
		Case $eBldgRicochetCannon
			$aLocate[$eCSVLocateRicochetCannon] = True
		Case $eBldgSuperWizTower
			$aLocate[$eCSVLocateSuperWizTower] = True
		Case $eBldgRevengeTower
			$aLocate[$eCSVLocateRevengeTower] = True
		Case Else
			Return False
	EndSwitch

	_CSVPrepAddTargetEnum($sTargetEnums, $iEnum)
	If $sTarget = "MULTIARCHER" Then _CSVPrepAddTargetEnum($sTargetEnums, $eBldgMultiGearTower)
	Return True
EndFunc   ;==>_CSVPrepApplyMakeTarget

; Side-effect: impure-deterministic (updates enum list)
Func _CSVPrepAddTargetEnum(ByRef $sTargetEnums, $iEnum)
	If $iEnum <= 0 Then Return
	Local $sNeedle = "|" & $iEnum & "|"
	Local $sHay = "|" & $sTargetEnums & "|"
	If StringInStr($sHay, $sNeedle) > 0 Then Return
	If $sTargetEnums = "" Then
		$sTargetEnums = $iEnum
	Else
		$sTargetEnums &= "|" & $iEnum
	EndIf
EndFunc   ;==>_CSVPrepAddTargetEnum

; Side-effect: impure-deterministic (clears prep cache for mode)
Func _CSVPrepResetMode($iMode)
	For $i = 0 To $eCSVLocateCount - 1
		$g_abCSVPrepLocate[$iMode][$i] = False
	Next
	For $i = 0 To 13
		$g_aiCSVPrepSideBWeights[$iMode][$i] = 0
	Next
	For $i = 0 To 3
		$g_abCSVPrepMakeSidesUsed[$iMode][$i] = False
	Next
	$g_abCSVPrepAllMakeTargeted[$iMode] = False
	$g_abCSVPrepHasPrioMake[$iMode] = False
	$g_abCSVPrepValid[$iMode] = False
	$g_asCSVPrepTargetEnums[$iMode] = ""
	$g_asCSVPrepName[$iMode] = ""
	$g_asCSVPrepMTime[$iMode] = ""
EndFunc   ;==>_CSVPrepResetMode

; Side-effect: pure (reads max building counts)
Func _CSVGetBldgMaxQty($iBuildingType, $iTH)
	If $iTH < 1 Then Return 0
	Local $aMaxQty = _ObjGetValue($g_oBldgMaxQty, $iBuildingType)
	If @error Then Return 0
	If Not IsArray($aMaxQty) Or UBound($aMaxQty) < $iTH Then Return 0
	Return $aMaxQty[$iTH - 1]
EndFunc   ;==>_CSVGetBldgMaxQty

; Side-effect: impure-deterministic (mutates locate flags using PRIO weights)
Func _CSVEnablePrioLocateFromWeights()
	If $g_aiCSVSideBWeights[0] > 0 Then
		$g_bCSVLocateEagle = True
	EndIf
	If $g_aiCSVSideBWeights[1] > 0 Then
		$g_bCSVLocateInferno = True
	EndIf
	If $g_aiCSVSideBWeights[2] > 0 Then
		$g_bCSVLocateXBow = True
	EndIf
	If $g_aiCSVSideBWeights[3] > 0 Then
		$g_bCSVLocateWizTower = True
		$g_bCSVLocateSuperWizTower = True
	EndIf
	If $g_aiCSVSideBWeights[4] > 0 Then
		$g_bCSVLocateMortar = True
	EndIf
	If $g_aiCSVSideBWeights[5] > 0 Then
		$g_bCSVLocateAirDefense = True
	EndIf
	If $g_aiCSVSideBWeights[6] > 0 Then
		$g_bCSVLocateScatter = True
	EndIf
	If $g_aiCSVSideBWeights[7] > 0 Then
		$g_bCSVLocateSweeper = True
	EndIf
	If $g_aiCSVSideBWeights[8] > 0 Then
		$g_bCSVLocateMonolith = True
	EndIf
	If $g_aiCSVSideBWeights[9] > 0 Then
		$g_bCSVLocateFireSpitter = True
	EndIf
	If $g_aiCSVSideBWeights[10] > 0 Then
		$g_bCSVLocateMultiArcherTower = True
	EndIf
	If $g_aiCSVSideBWeights[11] > 0 Then
		$g_bCSVLocateMultiGearTower = True
	EndIf
	If $g_aiCSVSideBWeights[12] > 0 Then
		$g_bCSVLocateRicochetCannon = True
	EndIf
	If $g_aiCSVSideBWeights[13] > 0 Then
		$g_bCSVLocateRevengeTower = True
	EndIf
	If _CSVIsWeaponizedTownHall($g_iSearchTH) Then
		$g_bCSVLocateStorageTownHall = True
	EndIf
EndFunc   ;==>_CSVEnablePrioLocateFromWeights

; Side-effect: pure (weaponized TH check; TH11-TH17 only)
Func _CSVIsWeaponizedTownHall($iTH)
	If $iTH = "-" Or $iTH = "" Then Return False
	If Not IsNumber($iTH) Then Return False
	Local $iLevel = Int($iTH)
	If $iLevel >= 12 And $iLevel <= 17 Then Return True
	Return False
EndFunc   ;==>_CSVIsWeaponizedTownHall
