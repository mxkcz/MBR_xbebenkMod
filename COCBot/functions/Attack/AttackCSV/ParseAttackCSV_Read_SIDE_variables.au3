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
