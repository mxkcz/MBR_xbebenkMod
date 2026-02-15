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

; #FUNCTION# ====================================================================================================================
; Name ..........: _CSVParseLineTokens
; Description ...: Parse CSV line tokens into an uppercase command and trimmed values array.
; Syntax ........: _CSVParseLineTokens(ByRef $aLines, ByRef $aTokens, $iLine, ByRef $sCommand, ByRef $aValues[, $iMinCols = 8[, $bUpperValues = True]])
; Parameters ....: $aLines           - CSV lines array.
;                  $aTokens          - Tokenized CSV lines (StringSplit arrays).
;                  $iLine            - Zero-based line index.
;                  $sCommand         - [out] Parsed command (uppercase).
;                  $aValues          - [out] Values array, 1-based with [0] = count.
;                  $iMinCols         - [optional] Minimum token count to accept.
;                  $bUpperValues     - [optional] Uppercase values when True.
; Return values .: Success: 1
;                  Failure: 0
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
; Side-effect: pure (reads arrays, returns parsed values)
Func _CSVParseLineTokens(ByRef $aLines, ByRef $aTokens, $iLine, ByRef $sCommand, ByRef $aValues, $iMinCols = 8, $bUpperValues = True)
	$sCommand = ""
	Local $aInit[1]
	$aInit[0] = 0
	$aValues = $aInit

	If Not IsArray($aLines) Or Not IsArray($aTokens) Then Return 0
	If $iLine < 0 Or $iLine >= UBound($aLines) Then Return 0

	Local $aCmdTokens = $aTokens[$iLine]
	If Not IsArray($aCmdTokens) Then $aCmdTokens = StringSplit($aLines[$iLine], "|")
	If Not IsArray($aCmdTokens) Or $aCmdTokens[0] < $iMinCols Then Return 0

	$sCommand = StringStripWS(StringUpper($aCmdTokens[1]), $STR_STRIPTRAILING)
	If $sCommand = "" Then Return 0

	Local $iCount = $aCmdTokens[0] - 1
	If $iCount < 1 Then Return 1

	ReDim $aValues[$iCount + 1]
	$aValues[0] = $iCount
	For $i = 1 To $iCount
		Local $sValue = StringStripWS($aCmdTokens[$i + 1], $STR_STRIPTRAILING)
		If $bUpperValues Then $sValue = StringUpper($sValue)
		$aValues[$i] = $sValue
	Next
	Return 1
EndFunc   ;==>_CSVParseLineTokens

; #FUNCTION# ====================================================================================================================
; Name ..........: _CSVParseIntRange
; Description ...: Parse an integer or integer range (min-max) into outputs with defaults.
; Syntax ........: _CSVParseIntRange($sValue, ByRef $iOutMin, ByRef $iOutMax, $iDefaultMin, $iDefaultMax[, $bAllowZero = True])
; Parameters ....: $sValue           - Raw value string.
;                  $iOutMin          - [out] Parsed minimum.
;                  $iOutMax          - [out] Parsed maximum.
;                  $iDefaultMin      - Default minimum when invalid.
;                  $iDefaultMax      - Default maximum when invalid.
;                  $bAllowZero       - [optional] Allow zero and above when True.
; Return values .: Success: 1 when parsed, 0 when defaults applied.
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
; Side-effect: pure
Func _CSVParseIntRange($sValue, ByRef $iOutMin, ByRef $iOutMax, $iDefaultMin, $iDefaultMax, $bAllowZero = True)
	Local $aParts = StringSplit($sValue, "-", $STR_NOCOUNT)
	If UBound($aParts) > 1 Then
		Local $sMin = StringStripWS($aParts[0], $STR_STRIPALL)
		Local $sMax = StringStripWS($aParts[1], $STR_STRIPALL)
		If StringIsInt($sMin) And StringIsInt($sMax) Then
			Local $iMin = Int($sMin)
			Local $iMax = Int($sMax)
			If ($bAllowZero And $iMin >= 0 And $iMax >= 0) Or (Not $bAllowZero And $iMin > 0 And $iMax > 0) Then
				$iOutMin = $iMin
				$iOutMax = $iMax
				Return 1
			EndIf
		EndIf
	Else
		Local $sSingle = StringStripWS($sValue, $STR_STRIPALL)
		If StringIsInt($sSingle) Then
			Local $iVal = Int($sSingle)
			If ($bAllowZero And $iVal >= 0) Or (Not $bAllowZero And $iVal > 0) Then
				$iOutMin = $iVal
				$iOutMax = $iVal
				Return 1
			EndIf
		EndIf
	EndIf

	$iOutMin = $iDefaultMin
	$iOutMax = $iDefaultMax
	Return 0
EndFunc   ;==>_CSVParseIntRange

; #FUNCTION# ====================================================================================================================
; Name ..........: _CSVParseIndexList
; Description ...: Parse index spec into range or list.
; Syntax ........: _CSVParseIndexList($sValue, ByRef $iStart, ByRef $iEnd, ByRef $aIndexArray[, $iDefault = 1])
; Parameters ....: $sValue           - Raw index string.
;                  $iStart           - [out] Range start or list start index.
;                  $iEnd             - [out] Range end or list end index.
;                  $aIndexArray      - [out] Array of explicit indices, or 0 when not used.
;                  $iDefault         - [optional] Default index when invalid.
; Return values .: Success: 1 when parsed, 0 when defaults applied.
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
; Side-effect: pure
Func _CSVParseIndexList($sValue, ByRef $iStart, ByRef $iEnd, ByRef $aIndexArray, $iDefault = 1)
	$aIndexArray = 0
	Local $aRange = StringSplit($sValue, "-", $STR_NOCOUNT)
	If UBound($aRange) > 1 Then
		Local $sMin = StringStripWS($aRange[0], $STR_STRIPALL)
		Local $sMax = StringStripWS($aRange[1], $STR_STRIPALL)
		If StringIsInt($sMin) And StringIsInt($sMax) Then
			Local $iMin = Int($sMin)
			Local $iMax = Int($sMax)
			If $iMin > 0 And $iMax > 0 Then
				$iStart = $iMin
				$iEnd = $iMax
				Return 1
			EndIf
		EndIf
		$iStart = $iDefault
		$iEnd = $iDefault
		Return 0
	EndIf

	Local $aList = StringSplit($sValue, ",", $STR_NOCOUNT)
	If UBound($aList) > 1 Then
		$aIndexArray = $aList
		$iStart = 0
		$iEnd = UBound($aList) - 1
		Return 1
	EndIf

	Local $sSingle = StringStripWS($sValue, $STR_STRIPALL)
	If StringIsInt($sSingle) And Int($sSingle) > 0 Then
		$iStart = Int($sSingle)
		$iEnd = Int($sSingle)
		Return 1
	EndIf

	$iStart = $iDefault
	$iEnd = $iDefault
	Return 0
EndFunc   ;==>_CSVParseIndexList

; #FUNCTION# ====================================================================================================================
; Name ..........: _CSVVectorMaskFromList
; Description ...: Convert a vector list string (e.g., A-B-C) into a bitmask.
; Syntax ........: _CSVVectorMaskFromList($sVectors)
; Parameters ....: $sVectors          - vector list string.
; Return values .: Success: bitmask integer (0 when empty).
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
; Side-effect: pure
Func _CSVVectorMaskFromList($sVectors)
	Local $iMask = 0
	If StringStripWS($sVectors, $STR_STRIPALL) = "" Then Return 0
	Local $aList = StringSplit($sVectors, "-", $STR_NOCOUNT)
	For $i = 0 To UBound($aList) - 1
		Local $sKey = StringStripWS(StringUpper($aList[$i]), $STR_STRIPALL)
		If StringLen($sKey) <> 1 Then ContinueLoop
		Local $iIndex = Asc($sKey) - 65
		If $iIndex < 0 Or $iIndex >= $g_iCSVVectorCount Then ContinueLoop
		$iMask = BitOR($iMask, BitShift(1, -$iIndex))
	Next
	Return $iMask
EndFunc   ;==>_CSVVectorMaskFromList

; #FUNCTION# ====================================================================================================================
; Name ..........: _CSVParsePrioCapLine
; Description ...: Parse PRIOCAP values into a per-side cap array.
; Syntax ........: _CSVParsePrioCapLine(ByRef $aCaps, $sTL, $sTR, $sBL, $sBR[, $bLogInvalid = False])
; Parameters ....: $aCaps            - [in/out] cap array [TL, TR, BL, BR].
;                  $sTL              - top-left cap value.
;                  $sTR              - top-right cap value.
;                  $sBL              - bottom-left cap value.
;                  $sBR              - bottom-right cap value.
;                  $bLogInvalid      - [optional] log invalid values when True.
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _CSVParsePrioCapLine(ByRef $aCaps, $sTL, $sTR, $sBL, $sBR, $bLogInvalid = False)
	Local $aVals[4] = [$sTL, $sTR, $sBL, $sBR]
	Local $aLabels[4] = ["TOP-LEFT", "TOP-RIGHT", "BOTTOM-LEFT", "BOTTOM-RIGHT"]
	For $i = 0 To 3
		Local $sVal = StringStripWS($aVals[$i], $STR_STRIPALL)
		If $sVal = "" Then ContinueLoop
		If Not StringIsInt($sVal) Then
			If $bLogInvalid Then SetDebugLog("PRIOCAP invalid value for " & $aLabels[$i] & ": " & $sVal, $COLOR_WARNING)
			ContinueLoop
		EndIf
		Local $iCap = Int($sVal)
		If $iCap < 0 Then $iCap = 0
		$aCaps[$i] = $iCap
	Next
EndFunc   ;==>_CSVParsePrioCapLine

; #FUNCTION# ====================================================================================================================
; Name ..........: AttackCSV_GetVecUseMaskForLine
; Description ...: Return the precomputed vector usage mask after the given CSV line.
; Syntax ........: AttackCSV_GetVecUseMaskForLine($iMode, $iLine)
; Parameters ....: $iMode             - Match mode index ($Battle/$RankedBattle).
;                  $iLine             - Zero-based CSV line index.
; Return values .: Success: bitmask integer (0 when unavailable).
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
; Side-effect: impure-deterministic (reads prep cache)
Func AttackCSV_GetVecUseMaskForLine($iMode, $iLine)
	If $iMode < 0 Or $iMode >= $g_iModeCount Then Return 0
	If Not PrepareAttackCSV($iMode) Then Return 0
	If Not IsArray($g_aCSVPrepVecUseMask[$iMode]) Then Return 0
	Local $aMask = $g_aCSVPrepVecUseMask[$iMode]
	If Not IsArray($aMask) Then Return 0
	If $iLine < 0 Or $iLine >= UBound($aMask) Then Return 0
	Return $aMask[$iLine]
EndFunc   ;==>AttackCSV_GetVecUseMaskForLine

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
	For $i = 0 To 3
		$g_aiCSVPrioCap[$i] = 0
	Next

	Local $filename = ""
	If $g_bLeagueAttack And $g_sAttackScrScriptNameRankedBattle <> "" Then
		$filename = $g_sAttackScrScriptNameRankedBattle
	ElseIf $g_iMatchMode = $Battle Then
		$filename = $g_sAttackScrScriptName[$Battle]
	Else
		$filename = $g_sAttackScrScriptName[$RankedBattle]
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
			Local $aValues
			If _CSVParseLineTokens($aLines, $aTokens, $iLine, $command, $aValues, 8, True) Then
				If $command <> "SIDE" And $command <> "SIDEB" And $command <> "MAKE" And $command <> "PRIOCAP" Then ContinueLoop

				$value1 = ($aValues[0] >= 1 ? $aValues[1] : "")
				$value2 = ($aValues[0] >= 2 ? $aValues[2] : "")
				$value3 = ($aValues[0] >= 3 ? $aValues[3] : "")
				$value4 = ($aValues[0] >= 4 ? $aValues[4] : "")
				$value5 = ($aValues[0] >= 5 ? $aValues[5] : "")
				$value6 = ($aValues[0] >= 6 ? $aValues[6] : "")
				$value7 = ($aValues[0] >= 7 ? $aValues[7] : "")
				$value8 = ($aValues[0] >= 8 ? $aValues[8] : "")
				$value9 = ($aValues[0] >= 9 ? $aValues[9] : "")
				$value10 = ($aValues[0] >= 10 ? $aValues[10] : "")
				$value11 = ($aValues[0] >= 11 ? $aValues[11] : "")
				$value12 = ($aValues[0] >= 12 ? $aValues[12] : "")
				$value13 = ($aValues[0] >= 13 ? $aValues[13] : "")
				$value14 = ($aValues[0] >= 14 ? $aValues[14] : "")

				If $command = "SIDE" And ($value8 = "TOP-LEFT" Or $value8 = "TOP-RIGHT" Or $value8 = "BOTTOM-LEFT" Or $value8 = "BOTTOM-RIGHT") Then
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
					Case "PRIOCAP"
						_CSVParsePrioCapLine($g_aiCSVPrioCap, $value1, $value2, $value3, $value4, True)
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
; Parameters ....: $iMode             - Match mode index ($Battle/$RankedBattle).
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

	_CSVInitPrioCandidates()
	_CSVInitTargetEnumToLocateMap()
	_CSVInitTHWindow()

	Local $sFilename = $g_sAttackScrScriptName[$iMode]
	If $g_bLeagueAttack And $g_sAttackScrScriptNameRankedBattle <> "" Then $sFilename = $g_sAttackScrScriptNameRankedBattle
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
		If IsArray($g_aCSVPrepVecUseMask[$iMode]) And $g_aiCSVPrepVecUseLineCount[$iMode] > 0 Then
			_CSVPrebuildTHLocateTableWindow($iMode)
			Return 1
		EndIf
	EndIf

	Local $aLocate[$eCSVLocateCount]
	Local $aWeights[14]
	Local $aSidesUsed[4] = [False, False, False, False]
	Local $aPrioCap[4]
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
		Local $command = ""
		Local $aValues
		If Not _CSVParseLineTokens($aLines, $aTokens, $iLine, $command, $aValues, 8, True) Then ContinueLoop
		If $command <> "SIDE" And $command <> "SIDEB" And $command <> "MAKE" And $command <> "PRIOCAP" Then ContinueLoop

		Local $value1 = ($aValues[0] >= 1 ? $aValues[1] : "")
		Local $value2 = ($aValues[0] >= 2 ? $aValues[2] : "")
		Local $value3 = ($aValues[0] >= 3 ? $aValues[3] : "")
		Local $value4 = ($aValues[0] >= 4 ? $aValues[4] : "")
		Local $value5 = ($aValues[0] >= 5 ? $aValues[5] : "")
		Local $value6 = ($aValues[0] >= 6 ? $aValues[6] : "")
		Local $value7 = ($aValues[0] >= 7 ? $aValues[7] : "")
		Local $value8 = ($aValues[0] >= 8 ? $aValues[8] : "")
		Local $value9 = ($aValues[0] >= 9 ? $aValues[9] : "")
		Local $value10 = ($aValues[0] >= 10 ? $aValues[10] : "")
		Local $value11 = ($aValues[0] >= 11 ? $aValues[11] : "")
		Local $value12 = ($aValues[0] >= 12 ? $aValues[12] : "")
		Local $value13 = ($aValues[0] >= 13 ? $aValues[13] : "")
		Local $value14 = ($aValues[0] >= 14 ? $aValues[14] : "")

		If $command = "SIDE" And ($value8 = "TOP-LEFT" Or $value8 = "TOP-RIGHT" Or $value8 = "BOTTOM-LEFT" Or $value8 = "BOTTOM-RIGHT") Then
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
			Case "PRIOCAP"
				_CSVParsePrioCapLine($aPrioCap, $value1, $value2, $value3, $value4, True)
			Case "MAKE"
				If StringLen(StringStripWS($value8, $STR_STRIPALL)) > 0 Then
					If Not _CSVScanMakeTargets($aLocate, $value8, $bPrioMakeFound, $sTargetEnums) Then
						SetDebugLog("Invalid MAKE building target name: " & $value8, $COLOR_WARNING)
					EndIf
				EndIf
		EndSwitch
	Next

	If Not AttackCSV_ScanMakeUsage($sFilename, $aSidesUsed, $bAllMakeTargeted) Then
		$aSidesUsed[0] = False
		$aSidesUsed[1] = False
		$aSidesUsed[2] = False
		$aSidesUsed[3] = False
		$bAllMakeTargeted = False
	EndIf

	Local $aUseMask[UBound($aLines)]
	Local $iMask = 0
	For $iLine = UBound($aLines) - 1 To 0 Step -1
		$aUseMask[$iLine] = $iMask
		Local $aCmdTokens = $aTokens[$iLine]
		If Not IsArray($aCmdTokens) Then $aCmdTokens = StringSplit($aLines[$iLine], "|")
		If $aCmdTokens[0] < 2 Then ContinueLoop
		Local $sCmd = StringStripWS(StringUpper($aCmdTokens[1]), $STR_STRIPTRAILING)
		If $sCmd <> "DROP" Then ContinueLoop
		Local $sVecList = ($aCmdTokens[0] >= 2 ? StringStripWS(StringUpper($aCmdTokens[2]), $STR_STRIPTRAILING) : "")
		If $sVecList = "" Then ContinueLoop
		$iMask = BitOR($iMask, _CSVVectorMaskFromList($sVecList))
	Next

	For $i = 0 To $eCSVLocateCount - 1
		$g_abCSVPrepLocate[$iMode][$i] = $aLocate[$i]
	Next
	For $i = 0 To 13
		$g_aiCSVPrepSideBWeights[$iMode][$i] = $aWeights[$i]
	Next
	For $i = 0 To 3
		$g_aiCSVPrepPrioCap[$iMode][$i] = $aPrioCap[$i]
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
	$g_aCSVPrepVecUseMask[$iMode] = $aUseMask
	$g_aiCSVPrepVecUseLineCount[$iMode] = UBound($aUseMask)

	_CSVPrebuildTHLocateTableWindow($iMode)
	SetDebugLog("CSV prep cached for " & $sFilename & " (mode " & $iMode & ")", $COLOR_DEBUG)
	Return 1
EndFunc   ;==>PrepareAttackCSV

; #FUNCTION# ====================================================================================================================
; Name ..........: AttackCSV_ApplyPrepared
; Description ...: Apply prepared CSV locate flags and weights for the current match.
; Syntax ........: AttackCSV_ApplyPrepared($iMode, $iTH)
; Parameters ....: $iMode             - Match mode index ($Battle/$RankedBattle).
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

	_CSVResolveLocateFlags($iMode)
	Local $aLocateResolved[$eCSVLocateCount]
	If $g_abCSVPrepTHWindowValid[$iMode] Then
		Local $iWindow = _CSVTHToWindowIndex($iTH)
		For $i = 0 To $eCSVLocateCount - 1
			$aLocateResolved[$i] = $g_aCSVPrepLocateByTHWindow[$iMode][$iWindow][$i]
		Next
	Else
		If $g_abCSVPrepHasPrioMake[$iMode] And _CSVIsWeaponizedTownHall($iTH) Then
			$g_abCSVPrepLocate[$iMode][$eCSVLocateStorageTownHall] = True
		EndIf
		For $i = 0 To $eCSVLocateCount - 1
			$aLocateResolved[$i] = $g_abCSVPrepLocate[$iMode][$i]
		Next
		_CSVPrecalcLocateForTH($iMode, $iTH, 1, $aLocateResolved)
	EndIf

	$g_bCSVLocateMine = $aLocateResolved[$eCSVLocateMine]
	$g_bCSVLocateElixir = $aLocateResolved[$eCSVLocateElixir]
	$g_bCSVLocateDrill = $aLocateResolved[$eCSVLocateDrill]
	$g_bCSVLocateStorageGold = $aLocateResolved[$eCSVLocateStorageGold]
	$g_bCSVLocateStorageElixir = $aLocateResolved[$eCSVLocateStorageElixir]
	$g_bCSVLocateStorageDarkElixir = $aLocateResolved[$eCSVLocateStorageDarkElixir]
	$g_bCSVLocateStorageTownHall = $aLocateResolved[$eCSVLocateStorageTownHall]
	$g_bCSVLocateEagle = $aLocateResolved[$eCSVLocateEagle]
	$g_bCSVLocateScatter = $aLocateResolved[$eCSVLocateScatter]
	$g_bCSVLocateInferno = $aLocateResolved[$eCSVLocateInferno]
	$g_bCSVLocateXBow = $aLocateResolved[$eCSVLocateXBow]
	$g_bCSVLocateWizTower = $aLocateResolved[$eCSVLocateWizTower]
	$g_bCSVLocateMortar = $aLocateResolved[$eCSVLocateMortar]
	$g_bCSVLocateAirDefense = $aLocateResolved[$eCSVLocateAirDefense]
	$g_bCSVLocateSweeper = $aLocateResolved[$eCSVLocateSweeper]
	$g_bCSVLocateMonolith = $aLocateResolved[$eCSVLocateMonolith]
	$g_bCSVLocateFireSpitter = $aLocateResolved[$eCSVLocateFireSpitter]
	$g_bCSVLocateMultiArcherTower = $aLocateResolved[$eCSVLocateMultiArcherTower]
	$g_bCSVLocateMultiGearTower = $aLocateResolved[$eCSVLocateMultiGearTower]
	$g_bCSVLocateRicochetCannon = $aLocateResolved[$eCSVLocateRicochetCannon]
	$g_bCSVLocateSuperWizTower = $aLocateResolved[$eCSVLocateSuperWizTower]
	$g_bCSVLocateRevengeTower = $aLocateResolved[$eCSVLocateRevengeTower]
	$g_bCSVLocateWall = $aLocateResolved[$eCSVLocateWall]

	For $i = 0 To UBound($g_aiCSVSideBWeights) - 1
		$g_aiCSVSideBWeights[$i] = $g_aiCSVPrepSideBWeights[$iMode][$i]
	Next
	For $i = 0 To 3
		$g_aiCSVPrioCap[$i] = $g_aiCSVPrepPrioCap[$iMode][$i]
	Next

	PrepareCSVBuildingsTH($iTH, True)
	Return 1
EndFunc   ;==>AttackCSV_ApplyPrepared

; #FUNCTION# ====================================================================================================================
; Name ..........: AttackCSV_GetPreparedMakeUsage
; Description ...: Retrieve cached MAKE side usage and targeted-only state for a mode.
; Syntax ........: AttackCSV_GetPreparedMakeUsage($iMode, ByRef $aSidesUsed, ByRef $bAllMakeTargeted)
; Parameters ....: $iMode             - Match mode index ($Battle/$RankedBattle).
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
; Name ..........: AttackCSV_GetTargetedOnlyCap
; Description ...: Resolve the targeted-only cap using per-side overrides.
; Syntax ........: AttackCSV_GetTargetedOnlyCap($iMode, $iDefaultCap)
; Parameters ....: $iMode             - Match mode index ($Battle/$RankedBattle).
;                  $iDefaultCap       - default cap when no per-side override is set.
; Return values .: Success: effective cap (>=0).
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func AttackCSV_GetTargetedOnlyCap($iMode, $iDefaultCap)
	Local $iDefault = Int($iDefaultCap)
	If $iDefault <= 0 Then Return 0
	If $iMode < 0 Or $iMode >= $g_iModeCount Then Return $iDefault
	If Not PrepareAttackCSV($iMode) Then Return $iDefault

	Local $iCap = 0
	For $i = 0 To 3
		If Not $g_abCSVPrepMakeSidesUsed[$iMode][$i] Then ContinueLoop
		Local $iSideCap = $g_aiCSVPrepPrioCap[$iMode][$i]
		If $iSideCap <= 0 Then $iSideCap = $iDefault
		If $iSideCap > $iCap Then $iCap = $iSideCap
	Next
	If $iCap <= 0 Then $iCap = $iDefault
	Return $iCap
EndFunc   ;==>AttackCSV_GetTargetedOnlyCap

; #FUNCTION# ====================================================================================================================
; Name ..........: AttackCSV_GetTargetMaxReturnPoints
; Description ...: Compute max return points for targeted-only MAKE using defense counts and PRIO weights.
; Syntax ........: AttackCSV_GetTargetMaxReturnPoints($iMode, $iTH, $iCap)
; Parameters ....: $iMode             - Match mode index ($Battle/$RankedBattle).
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

; #FUNCTION# ====================================================================================================================
; Name ..........: _CSVInitTargetEnumToLocateMap
; Description ...: Build lookup map from building enum to CSV locate index.
; Syntax ........: _CSVInitTargetEnumToLocateMap()
; Parameters ....: None
; Return values .: Success: 1
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
; Side-effect: impure-deterministic (mutates lookup array)
Func _CSVInitTargetEnumToLocateMap()
	Local $iSize = $eBldgRevengeTower + 1
	If Not IsArray($g_aiCSVPrepTargetEnumToLocate) Or UBound($g_aiCSVPrepTargetEnumToLocate) <> $iSize Then
		ReDim $g_aiCSVPrepTargetEnumToLocate[$iSize]
	EndIf
	For $i = 0 To $iSize - 1
		$g_aiCSVPrepTargetEnumToLocate[$i] = -1
	Next

	$g_aiCSVPrepTargetEnumToLocate[$eBldgGoldM] = $eCSVLocateMine
	$g_aiCSVPrepTargetEnumToLocate[$eBldgElixirC] = $eCSVLocateElixir
	$g_aiCSVPrepTargetEnumToLocate[$eBldgDrill] = $eCSVLocateDrill
	$g_aiCSVPrepTargetEnumToLocate[$eBldgGoldS] = $eCSVLocateStorageGold
	$g_aiCSVPrepTargetEnumToLocate[$eBldgElixirS] = $eCSVLocateStorageElixir
	$g_aiCSVPrepTargetEnumToLocate[$eBldgDarkS] = $eCSVLocateStorageDarkElixir
	$g_aiCSVPrepTargetEnumToLocate[$eBldgTownHall] = $eCSVLocateStorageTownHall
	$g_aiCSVPrepTargetEnumToLocate[$eBldgEagle] = $eCSVLocateEagle
	$g_aiCSVPrepTargetEnumToLocate[$eBldgScatter] = $eCSVLocateScatter
	$g_aiCSVPrepTargetEnumToLocate[$eBldgInferno] = $eCSVLocateInferno
	$g_aiCSVPrepTargetEnumToLocate[$eBldgXBow] = $eCSVLocateXBow
	$g_aiCSVPrepTargetEnumToLocate[$eBldgWizTower] = $eCSVLocateWizTower
	$g_aiCSVPrepTargetEnumToLocate[$eBldgMortar] = $eCSVLocateMortar
	$g_aiCSVPrepTargetEnumToLocate[$eBldgAirDefense] = $eCSVLocateAirDefense
	$g_aiCSVPrepTargetEnumToLocate[$eBldgSweeper] = $eCSVLocateSweeper
	$g_aiCSVPrepTargetEnumToLocate[$eBldgMonolith] = $eCSVLocateMonolith
	$g_aiCSVPrepTargetEnumToLocate[$eBldgFireSpitter] = $eCSVLocateFireSpitter
	$g_aiCSVPrepTargetEnumToLocate[$eBldgMultiArcherTower] = $eCSVLocateMultiArcherTower
	$g_aiCSVPrepTargetEnumToLocate[$eBldgMultiGearTower] = $eCSVLocateMultiGearTower
	$g_aiCSVPrepTargetEnumToLocate[$eBldgRicochetCannon] = $eCSVLocateRicochetCannon
	$g_aiCSVPrepTargetEnumToLocate[$eBldgSuperWizTower] = $eCSVLocateSuperWizTower
	$g_aiCSVPrepTargetEnumToLocate[$eBldgRevengeTower] = $eCSVLocateRevengeTower
	$g_aiCSVPrepTargetEnumToLocate[$eExternalWall] = $eCSVLocateWall
	$g_aiCSVPrepTargetEnumToLocate[$eInternalWall] = $eCSVLocateWall
	Return 1
EndFunc   ;==>_CSVInitTargetEnumToLocateMap

; #FUNCTION# ====================================================================================================================
; Name ..........: _CSVLocateEnumToIndex
; Description ...: Convert building enum to CSV locate index.
; Syntax ........: _CSVLocateEnumToIndex($iEnum)
; Parameters ....: $iEnum             - Building enum.
; Return values .: Success: locate index
;                  Failure: -1
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
; Side-effect: pure
Func _CSVLocateEnumToIndex($iEnum)
	If $iEnum <= 0 Then Return -1
	If Not IsArray($g_aiCSVPrepTargetEnumToLocate) Then Return -1
	If UBound($g_aiCSVPrepTargetEnumToLocate) = 0 Then Return -1
	If $iEnum < 0 Or $iEnum >= UBound($g_aiCSVPrepTargetEnumToLocate) Then Return -1
	Return $g_aiCSVPrepTargetEnumToLocate[$iEnum]
EndFunc   ;==>_CSVLocateEnumToIndex

; #FUNCTION# ====================================================================================================================
; Name ..........: _CSVLocateIndexToEnum
; Description ...: Convert CSV locate index to building enum.
; Syntax ........: _CSVLocateIndexToEnum($iIndex)
; Parameters ....: $iIndex            - Locate index.
; Return values .: Success: building enum
;                  Failure: -1
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
; Side-effect: pure
Func _CSVLocateIndexToEnum($iIndex)
	Switch $iIndex
		Case $eCSVLocateMine
			Return $eBldgGoldM
		Case $eCSVLocateElixir
			Return $eBldgElixirC
		Case $eCSVLocateDrill
			Return $eBldgDrill
		Case $eCSVLocateStorageGold
			Return $eBldgGoldS
		Case $eCSVLocateStorageElixir
			Return $eBldgElixirS
		Case $eCSVLocateStorageDarkElixir
			Return $eBldgDarkS
		Case $eCSVLocateStorageTownHall
			Return $eBldgTownHall
		Case $eCSVLocateEagle
			Return $eBldgEagle
		Case $eCSVLocateScatter
			Return $eBldgScatter
		Case $eCSVLocateInferno
			Return $eBldgInferno
		Case $eCSVLocateXBow
			Return $eBldgXBow
		Case $eCSVLocateWizTower
			Return $eBldgWizTower
		Case $eCSVLocateMortar
			Return $eBldgMortar
		Case $eCSVLocateAirDefense
			Return $eBldgAirDefense
		Case $eCSVLocateSweeper
			Return $eBldgSweeper
		Case $eCSVLocateMonolith
			Return $eBldgMonolith
		Case $eCSVLocateFireSpitter
			Return $eBldgFireSpitter
		Case $eCSVLocateMultiArcherTower
			Return $eBldgMultiArcherTower
		Case $eCSVLocateMultiGearTower
			Return $eBldgMultiGearTower
		Case $eCSVLocateRicochetCannon
			Return $eBldgRicochetCannon
		Case $eCSVLocateSuperWizTower
			Return $eBldgSuperWizTower
		Case $eCSVLocateRevengeTower
			Return $eBldgRevengeTower
	EndSwitch
	Return -1
EndFunc   ;==>_CSVLocateIndexToEnum

; #FUNCTION# ====================================================================================================================
; Name ..........: _CSVInitTHWindow
; Description ...: Initialize TH window (TH-1/TH/TH+1) for precalc tables.
; Syntax ........: _CSVInitTHWindow()
; Parameters ....: None
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
; Side-effect: impure-deterministic (mutates global window)
Func _CSVInitTHWindow()
	Local $iTH = $g_iTownHallLevel
	If $iTH < 1 Then $iTH = 1
	If $iTH > $g_iMaxTHLevel Then $iTH = $g_iMaxTHLevel

	Local $iMin = 1
	Local $iMax = $g_iMaxTHLevel

	Local $iPrev = $iTH - 1
	If $iPrev < $iMin Then $iPrev = $iMin
	Local $iNext = $iTH + 1
	If $iNext > $iMax Then $iNext = $iMax

	$g_aCSVPrepTHWindow[0] = $iPrev
	$g_aCSVPrepTHWindow[1] = $iTH
	$g_aCSVPrepTHWindow[2] = $iNext
EndFunc   ;==>_CSVInitTHWindow

; #FUNCTION# ====================================================================================================================
; Name ..........: _CSVTHToWindowIndex
; Description ...: Resolve a TH value to the closest precalc window index.
; Syntax ........: _CSVTHToWindowIndex($iTH)
; Parameters ....: $iTH               - Townhall level (may be "-").
; Return values .: Success: window index (0..2)
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
; Side-effect: pure
Func _CSVTHToWindowIndex($iTH)
	If $iTH = "-" Or $iTH = "" Or Not IsNumber($iTH) Then Return 1
	Local $iVal = Int($iTH)
	If $iVal = $g_aCSVPrepTHWindow[0] Then Return 0
	If $iVal = $g_aCSVPrepTHWindow[1] Then Return 1
	If $iVal = $g_aCSVPrepTHWindow[2] Then Return 2

	Local $iBest = 1
	Local $iBestD = Abs($iVal - $g_aCSVPrepTHWindow[1])
	For $w = 0 To 2
		Local $iD = Abs($iVal - $g_aCSVPrepTHWindow[$w])
		If $iD < $iBestD Then
			$iBestD = $iD
			$iBest = $w
		EndIf
	Next
	Return $iBest
EndFunc   ;==>_CSVTHToWindowIndex

; #FUNCTION# ====================================================================================================================
; Name ..........: _CSVGetResolvedLocateBase
; Description ...: Build resolved locate flags from weights and explicit targets.
; Syntax ........: _CSVGetResolvedLocateBase($iMode, ByRef $aResolved)
; Parameters ....: $iMode             - Match mode index ($Battle/$RankedBattle).
;                  $aResolved         - [out] Locate flags array.
; Return values .: Success: 1
;                  Failure: 0 and @error set.
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
; Side-effect: impure-deterministic (reads prep cache, mutates local output)
Func _CSVGetResolvedLocateBase($iMode, ByRef $aResolved)
	If $iMode < 0 Or $iMode >= $g_iModeCount Then Return SetError(1, 0, 0)

	_CSVInitTargetEnumToLocateMap()
	_CSVInitPrioCandidates()

	Local $aLocal[$eCSVLocateCount]
	For $i = 0 To $eCSVLocateCount - 1
		$aLocal[$i] = $g_abCSVPrepLocate[$iMode][$i]
	Next

	If $g_abCSVPrepHasPrioMake[$iMode] Then
		Local $aWeights[14]
		For $i = 0 To 13
			$aWeights[$i] = $g_aiCSVPrepSideBWeights[$iMode][$i]
		Next
		_CSVPrepEnablePrioLocateFromWeights($aLocal, $aWeights)
	EndIf

	If $g_asCSVPrepTargetEnums[$iMode] <> "" Then
		Local $aEnums = StringSplit($g_asCSVPrepTargetEnums[$iMode], "|", $STR_NOCOUNT)
		For $i = 0 To UBound($aEnums) - 1
			Local $iEnum = Int($aEnums[$i])
			If $iEnum <= 0 Then ContinueLoop
			Local $iLocate = _CSVLocateEnumToIndex($iEnum)
			If $iLocate >= 0 And $iLocate < $eCSVLocateCount Then $aLocal[$iLocate] = True
		Next
	EndIf

	$aResolved = $aLocal
	Return 1
EndFunc   ;==>_CSVGetResolvedLocateBase

; #FUNCTION# ====================================================================================================================
; Name ..........: _CSVPrebuildTHLocateTableWindow
; Description ...: Precompute locate flags for the TH window (TH-1/TH/TH+1).
; Syntax ........: _CSVPrebuildTHLocateTableWindow($iMode)
; Parameters ....: $iMode             - Match mode index ($Battle/$RankedBattle).
; Return values .: Success: 1
;                  Failure: 0 and @error set.
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
; Side-effect: impure-deterministic (mutates precalc tables)
Func _CSVPrebuildTHLocateTableWindow($iMode)
	If $iMode < 0 Or $iMode >= $g_iModeCount Then Return SetError(1, 0, 0)

	Local $aBase[$eCSVLocateCount]
	If Not _CSVGetResolvedLocateBase($iMode, $aBase) Then Return SetError(2, 0, 0)

	For $w = 0 To 2
		Local $iTH = $g_aCSVPrepTHWindow[$w]
		Local $aTemp[$eCSVLocateCount]
		For $i = 0 To $eCSVLocateCount - 1
			$aTemp[$i] = $aBase[$i]
		Next

		If $g_abCSVPrepHasPrioMake[$iMode] And _CSVIsWeaponizedTownHall($iTH) Then
			$aTemp[$eCSVLocateStorageTownHall] = True
		EndIf

		_CSVPrecalcLocateForTH($iMode, $iTH, 0, $aTemp)

		For $i = 0 To $eCSVLocateCount - 1
			$g_aCSVPrepLocateByTHWindow[$iMode][$w][$i] = $aTemp[$i]
		Next
	Next

	$g_abCSVPrepTHWindowValid[$iMode] = True
	Return 1
EndFunc   ;==>_CSVPrebuildTHLocateTableWindow

; #FUNCTION# ====================================================================================================================
; Name ..........: _CSVHasAnyLocateFlag
; Description ...: Determine if any locate flag is enabled for a mode and TH.
; Syntax ........: _CSVHasAnyLocateFlag($iMode, $iTH)
; Parameters ....: $iMode             - Match mode index ($Battle/$RankedBattle).
;                  $iTH               - Townhall level (may be "-").
; Return values .: Success: True/False
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
; Side-effect: pure
Func _CSVHasAnyLocateFlag($iMode, $iTH)
	If $iMode < 0 Or $iMode >= $g_iModeCount Then Return False
	If $g_abCSVPrepTHWindowValid[$iMode] Then
		Local $iWindow = _CSVTHToWindowIndex($iTH)
		For $i = 0 To $eCSVLocateCount - 1
			If $g_aCSVPrepLocateByTHWindow[$iMode][$iWindow][$i] Then Return True
		Next
	Else
		For $i = 0 To $eCSVLocateCount - 1
			If $g_abCSVPrepLocate[$iMode][$i] Then Return True
		Next
	EndIf
	Return False
EndFunc   ;==>_CSVHasAnyLocateFlag

; #FUNCTION# ====================================================================================================================
; Name ..........: _CSVResolveLocateFlags
; Description ...: Resolve CSV locate flags from PRIO weights and explicit MAKE targets.
; Syntax ........: _CSVResolveLocateFlags($iMode)
; Parameters ....: $iMode             - Match mode index ($Battle/$RankedBattle).
; Return values .: Success: 1
;                  Failure: 0 and @error set.
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
; Side-effect: impure-deterministic (mutates prep locate flags)
Func _CSVResolveLocateFlags($iMode)
	If $iMode < 0 Or $iMode >= $g_iModeCount Then Return SetError(1, 0, 0)

	Local $aResolved[$eCSVLocateCount]
	If Not _CSVGetResolvedLocateBase($iMode, $aResolved) Then Return SetError(2, 0, 0)

	Local $iCount = 0
	For $i = 0 To $eCSVLocateCount - 1
		$g_abCSVPrepLocate[$iMode][$i] = $aResolved[$i]
		If $aResolved[$i] Then $iCount += 1
	Next

	SetDebugLog("CSV prep: resolved locate flags (mode " & $iMode & ", count=" & $iCount & ")", $COLOR_DEBUG)
	Return 1
EndFunc   ;==>_CSVResolveLocateFlags

; #FUNCTION# ====================================================================================================================
; Name ..........: _CSVPrecalcLocateForTH
; Description ...: Disable locate flags for buildings locked below the minimum TH (with delta).
; Syntax ........: _CSVPrecalcLocateForTH($iMode, $iTH, $iDelta, $aLocateOverride)
; Parameters ....: $iMode             - Match mode index ($Battle/$RankedBattle).
;                  $iTH               - Townhall level (may be "-").
;                  $iDelta            - [optional] TH delta tolerance. Default is 1.
; Return values .: Success: 1
;                  Failure: 0 and @error set.
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
; Side-effect: impure-deterministic (mutates override array)
Func _CSVPrecalcLocateForTH($iMode, $iTH, $iDelta, ByRef $aLocateOverride)
	If $iMode < 0 Or $iMode >= $g_iModeCount Then Return SetError(1, 0, 0)

	Local $bUnknownTH = False
	Local $iTHLocal = _CSVNormalizeTH($iTH, $bUnknownTH)
	If $bUnknownTH Then $iDelta = 0

	Local $iMinTH = ($iTHLocal - $iDelta)
	If $iMinTH < 1 Then $iMinTH = 1

	For $i = 0 To $eCSVLocateCount - 1
		If Not $aLocateOverride[$i] Then ContinueLoop
		Local $iBldgEnum = _CSVLocateIndexToEnum($i)
		If $iBldgEnum <= 0 Then ContinueLoop
		Local $iMaxLevel = _CSVGetBldgMaxLevel($iBldgEnum, $iMinTH)
		If $iMaxLevel = -1 Then ContinueLoop
		If $iMaxLevel <= 0 Then
			$aLocateOverride[$i] = False
			SetDebugLog("CSV precalc: skip " & $g_sBldgNames[$iBldgEnum] & " (locked at TH" & $iMinTH & ")", $COLOR_DEBUG)
		EndIf
	Next
	Return 1
EndFunc   ;==>_CSVPrecalcLocateForTH

; #FUNCTION# ====================================================================================================================
; Name ..........: AttackTiming_Reset
; Description ...: Reset attack timing markers when debug timing is enabled.
; Syntax ........: AttackTiming_Reset()
; Parameters ....: None
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func AttackTiming_Reset()
	If Not $g_bDebugAttackTiming Then Return
	$g_hAttackTimingTimer = __TimerInit()
	ReDim $g_aAttackTimingLabels[0]
	ReDim $g_aAttackTimingDetails[0]
	ReDim $g_aAttackTimingMs[0]
EndFunc   ;==>AttackTiming_Reset

; #FUNCTION# ====================================================================================================================
; Name ..........: AttackTiming_Mark
; Description ...: Record a timing marker for the current attack.
; Syntax ........: AttackTiming_Mark($sLabel[, $sDetail = ""])
; Parameters ....: $sLabel             - short label for the timing mark.
;                  $sDetail            - [optional] extra detail text.
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func AttackTiming_Mark($sLabel, $sDetail = "")
	If Not $g_bDebugAttackTiming Then Return
	If $g_hAttackTimingTimer = 0 Then $g_hAttackTimingTimer = __TimerInit()
	Local $iMs = Round(__TimerDiff($g_hAttackTimingTimer))
	Local $iSize = UBound($g_aAttackTimingLabels)
	ReDim $g_aAttackTimingLabels[$iSize + 1]
	ReDim $g_aAttackTimingDetails[$iSize + 1]
	ReDim $g_aAttackTimingMs[$iSize + 1]
	$g_aAttackTimingLabels[$iSize] = $sLabel
	$g_aAttackTimingDetails[$iSize] = $sDetail
	$g_aAttackTimingMs[$iSize] = $iMs
EndFunc   ;==>AttackTiming_Mark

; #FUNCTION# ====================================================================================================================
; Name ..........: AttackTiming_Summary
; Description ...: Emit a compact timing summary before drops.
; Syntax ........: AttackTiming_Summary($sContext)
; Parameters ....: $sContext           - context tag for the summary.
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func AttackTiming_Summary($sContext)
	If Not $g_bDebugAttackTiming Then Return
	Local $iPreDropStart = _AttackTiming_GetMarkMs("pre-drop start")
	Local $iPreDropDone = _AttackTiming_GetMarkMs("pre-drop done")
	Local $iPreDropTotal = ($iPreDropStart >= 0 And $iPreDropDone >= 0) ? ($iPreDropDone - $iPreDropStart) : -1
	Local $iRedlineStart = _AttackTiming_GetMarkMs("capture", "Algorithm_AttackCSV redline")
	Local $iRedlineDone = _AttackTiming_GetMarkMs("redline done", "Algorithm_AttackCSV")
	Local $iRedlineTotal = ($iRedlineStart >= 0 And $iRedlineDone >= 0) ? ($iRedlineDone - $iRedlineStart) : -1
	Local $iLocateBatchTotal = _AttackTiming_SumDurations("locate batch start", "locate batch done")
	Local $iDroplineTotal = _AttackTiming_SumDurations("phase start", "phase done", "droplines")
	Local $iMainSideTotal = _AttackTiming_SumDurations("phase start", "phase done", "main side")

	Local $sLine = "CSV timing summary (" & $sContext & "): " & _
			"pre-drop=" & _AttackTiming_FormatSeconds($iPreDropTotal) & _
			" redline=" & _AttackTiming_FormatSeconds($iRedlineTotal) & _
			" locateBatch=" & _AttackTiming_FormatSeconds($iLocateBatchTotal) & _
			" mainSide=" & _AttackTiming_FormatSeconds($iMainSideTotal) & _
			" droplines=" & _AttackTiming_FormatSeconds($iDroplineTotal)
	SetDebugLog($sLine, $COLOR_INFO)

	If $g_sCSVRescanLastReason <> "" Or $g_iCSVRescanLastDurationMs > 0 Then
		Local $sRescan = "CSV rescan summary: reason=" & ($g_sCSVRescanLastReason = "" ? "-" : $g_sCSVRescanLastReason) & _
				" count=" & $g_iCSVRescanLastCount & _
				" duration=" & _AttackTiming_FormatSeconds($g_iCSVRescanLastDurationMs) & _
				" budget=" & _AttackTiming_FormatSeconds($g_iCSVRescanLastBudgetMs) & _
				" exceeded=" & ($g_bCSVRescanLastBudgetExceeded ? "yes" : "no")
		If $g_sCSVRescanLastFallback <> "" Then $sRescan &= " fallback=" & $g_sCSVRescanLastFallback
		SetDebugLog($sRescan, $COLOR_INFO)
	EndIf
EndFunc   ;==>AttackTiming_Summary

; #FUNCTION# ====================================================================================================================
; Name ..........: CSV_LogTiming
; Description ...: Log CSV timing markers relative to the search window timer when debug is enabled.
; Syntax ........: CSV_LogTiming($sLabel[, $sDetail = ""])
; Parameters ....: $sLabel             - short label for the timing mark.
;                  $sDetail            - [optional] extra detail text.
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func CSV_LogTiming($sLabel, $sDetail = "")
	If Not $g_bDebugAttackTiming Then Return
	AttackTiming_Mark($sLabel, $sDetail)
	Local $sElapsed = ""
	If $g_hAttackTimingTimer <> 0 Then
		$sElapsed = " t+" & Round(__TimerDiff($g_hAttackTimingTimer)) & "ms"
	EndIf
	Local $sMsg = "CSV timing: " & $sLabel
	If $sDetail <> "" Then $sMsg &= " [" & $sDetail & "]"
	If $sElapsed <> "" Then $sMsg &= " (" & $sElapsed & ")"
	SetDebugLog($sMsg, $COLOR_DEBUG)
EndFunc   ;==>CSV_LogTiming

; #FUNCTION# ====================================================================================================================
; Name ..........: CSV_LogRescan
; Description ...: Log CSV rescan decisions when rescan debug is enabled.
; Syntax ........: CSV_LogRescan($sLabel[, $sDetail = ""[, $iColor = $COLOR_DEBUG]])
; Parameters ....: $sLabel             - short label for the rescan event.
;                  $sDetail            - [optional] extra detail text.
;                  $iColor             - [optional] log color.
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func CSV_LogRescan($sLabel, $sDetail = "", $iColor = $COLOR_DEBUG)
	If Not $g_bDebugAttackRescan Then Return
	Local $sMsg = "CSV rescan: " & $sLabel
	If $sDetail <> "" Then $sMsg &= " [" & $sDetail & "]"
	SetDebugLog($sMsg, $iColor)
EndFunc   ;==>CSV_LogRescan

; #FUNCTION# ====================================================================================================================
; Name ..........: _AttackTiming_GetMarkMs
; Description ...: Return the first timing mark match in ms.
; Syntax ........: _AttackTiming_GetMarkMs($sLabel[, $sDetail = ""])
; Parameters ....: $sLabel             - label to match.
;                  $sDetail            - [optional] detail to match.
; Return values .: Success: ms timestamp.
;                  Failure: -1.
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _AttackTiming_GetMarkMs($sLabel, $sDetail = "")
	For $i = 0 To UBound($g_aAttackTimingLabels) - 1
		If $g_aAttackTimingLabels[$i] <> $sLabel Then ContinueLoop
		If $sDetail <> "" And $g_aAttackTimingDetails[$i] <> $sDetail Then ContinueLoop
		Return $g_aAttackTimingMs[$i]
	Next
	Return -1
EndFunc   ;==>_AttackTiming_GetMarkMs

; #FUNCTION# ====================================================================================================================
; Name ..........: _AttackTiming_SumDurations
; Description ...: Sum durations between start/end markers.
; Syntax ........: _AttackTiming_SumDurations($sStartLabel, $sEndLabel[, $sDetail = ""])
; Parameters ....: $sStartLabel        - start marker label.
;                  $sEndLabel          - end marker label.
;                  $sDetail            - [optional] detail filter for matching.
; Return values .: Total duration in ms (0 when no pairs).
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _AttackTiming_SumDurations($sStartLabel, $sEndLabel, $sDetail = "")
	Local $iTotal = 0
	Local $iStartMs = -1
	For $i = 0 To UBound($g_aAttackTimingLabels) - 1
		If $g_aAttackTimingLabels[$i] = $sStartLabel Then
			If $sDetail <> "" And $g_aAttackTimingDetails[$i] <> $sDetail Then ContinueLoop
			$iStartMs = $g_aAttackTimingMs[$i]
			ContinueLoop
		EndIf
		If $g_aAttackTimingLabels[$i] = $sEndLabel And $iStartMs >= 0 Then
			If $sDetail <> "" And $g_aAttackTimingDetails[$i] <> $sDetail Then ContinueLoop
			$iTotal += ($g_aAttackTimingMs[$i] - $iStartMs)
			$iStartMs = -1
		EndIf
	Next
	Return $iTotal
EndFunc   ;==>_AttackTiming_SumDurations

; #FUNCTION# ====================================================================================================================
; Name ..........: _AttackTiming_FormatSeconds
; Description ...: Format ms as seconds string for summaries.
; Syntax ........: _AttackTiming_FormatSeconds($iMs)
; Parameters ....: $iMs                - milliseconds.
; Return values .: String for summary.
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _AttackTiming_FormatSeconds($iMs)
	If $iMs < 0 Then Return "-"
	Return Round($iMs / 1000, 2) & "s"
EndFunc   ;==>_AttackTiming_FormatSeconds

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

; #FUNCTION# ====================================================================================================================
; Name ..........: _CSVInitPrioCandidates
; Description ...: Initialize PRIO candidate arrays once per run.
; Syntax ........: _CSVInitPrioCandidates()
; Parameters ....: None
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
; Side-effect: impure-deterministic (mutates global arrays)
Func _CSVInitPrioCandidates()
	If $g_bPrioCandidatesInit Then Return
	_CSVGetPrioCandidateMap($g_aPrioCandidateEnums, $g_aPrioCandidateNames, $g_aPrioCandidateWeightIdx)
	$g_bPrioCandidatesInit = True
EndFunc   ;==>_CSVInitPrioCandidates

; Side-effect: pure
Func _CSVLookupTargetEnum($sTarget, ByRef $iEnum, ByRef $iWeightIndex)
	$iEnum = 0
	$iWeightIndex = -1
	If $sTarget = "TOWNHALL" Then
		$iEnum = $eBldgTownHall
		Return True
	EndIf

	_CSVInitPrioCandidates()
	For $i = 0 To UBound($g_aPrioCandidateNames) - 1
		If $g_aPrioCandidateNames[$i] = $sTarget Then
			$iEnum = $g_aPrioCandidateEnums[$i]
			$iWeightIndex = $g_aPrioCandidateWeightIdx[$i]
			Return True
		EndIf
	Next
	Return False
EndFunc   ;==>_CSVLookupTargetEnum

; #FUNCTION# ====================================================================================================================
; Name ..........: _CSVScanMakeTargets
; Description ...: Process MAKE target column and capture explicit building enums.
; Syntax ........: _CSVScanMakeTargets(ByRef $aLocate, $sTarget, ByRef $bPrioMakeFound, ByRef $sTargetEnums)
; Parameters ....: $aLocate          - [in/out] Locate flags array.
;                  $sTarget          - Target value from MAKE column.
;                  $bPrioMakeFound   - [in/out] PRIO target flag.
;                  $sTargetEnums     - [in/out] Pipe-delimited building enum list.
; Return values .: Success: True
;                  Failure: False for invalid target.
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
; Side-effect: impure-deterministic (mutates locate flags and target list)
Func _CSVScanMakeTargets(ByRef $aLocate, $sTarget, ByRef $bPrioMakeFound, ByRef $sTargetEnums)
	Return _CSVPrepApplyMakeTarget($aLocate, $sTarget, $bPrioMakeFound, $sTargetEnums)
EndFunc   ;==>_CSVScanMakeTargets

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
		$g_aiCSVPrepPrioCap[$iMode][$i] = 0
	Next
	For $i = 0 To 3
		$g_abCSVPrepMakeSidesUsed[$iMode][$i] = False
	Next
	$g_abCSVPrepAllMakeTargeted[$iMode] = False
	$g_abCSVPrepHasPrioMake[$iMode] = False
	$g_abCSVPrepValid[$iMode] = False
	$g_abCSVPrepTHWindowValid[$iMode] = False
	$g_asCSVPrepTargetEnums[$iMode] = ""
	$g_asCSVPrepName[$iMode] = ""
	$g_asCSVPrepMTime[$iMode] = ""
	$g_aiCSVPrepVecUseLineCount[$iMode] = 0
	Local $aEmpty[0]
	$g_aCSVPrepVecUseMask[$iMode] = $aEmpty
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
