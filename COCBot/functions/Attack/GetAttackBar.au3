; #FUNCTION# ====================================================================================================================
; Name ..........: _GetAttackBarHash
; Description ...: Builds a lightweight hash for attackbar pixels for CSV cache reuse.
; Syntax ........: _GetAttackBarHash($bDoubleRow, $bCheckSlot12)
; Parameters ....: $bDoubleRow   - True when double-row attackbar is active.
;                  $bCheckSlot12 - True when 12th slot check is enabled.
; Return values .: String hash of sampled pixels and layout flags.
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; =====================================================================================================================
Func _GetAttackBarHash($bDoubleRow, $bCheckSlot12)
	If Not $g_bRunState Then Return ""
	_CaptureRegion(0, 580, $g_iGAME_WIDTH, 660)
	Local $sHash = ""
	Local $sColor1 = _GetPixelColor(120, 632, False)
	Local $sColor2 = _GetPixelColor(300, 632, False)
	Local $sColor3 = _GetPixelColor(480, 632, False)
	Local $sColor4 = _GetPixelColor(660, 632, False)
	Local $sColor5 = _GetPixelColor(840, 632, False)
	$sHash = $sColor1 & ":" & $sColor2 & ":" & $sColor3 & ":" & $sColor4 & ":" & $sColor5 & ":" & _
			($bDoubleRow ? "1" : "0") & ":" & ($bCheckSlot12 ? "1" : "0")
	Return $sHash
EndFunc   ;==>_GetAttackBarHash

; #FUNCTION# ====================================================================================================================
; Name ..........: GetAttackBar
; Description ...: Detects army in the attack bar and returns slot data (index, slot, amount, coords).
; Syntax ........: GetAttackBar($bRemaining = False, $pMatchMode = $DB, $bDebug = False)
; Parameters ....: $bRemaining (First Check or for Remaining Troops), $pMatchMode (Attackmode that needs the Attackbar: $DB, $AB), $bDebug (Debug GetAttackbar)
; Return values .:
; Author ........: Trlopes (06-2016)
; Modified ......: ProMac (12-2016), Fliegerfaust(12-2018), mxkcz (2026)
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; =====================================================================================================================
Func GetAttackBar($bRemaining = False, $pMatchMode = $DB, $bDebug = False)
	Local Static $aAttackBar[0][8]
	Local Static $aSlotMap[0][3]
	Local Static $bDoubleRow = False, $bCheckSlot12 = False
	Local $sSearchDiamond = GetDiamondFromRect("0, 580, " & $g_iGAME_WIDTH & ", 660")
	Local $iYBelowRowOne = 630, $aiOCRLocation[2] = [-1, -1], $aSlotAmountX[0][3]
	Local $sHash = ""
	Local $aEmptyUnknown[0][6]
	$g_avAttackUnknownSlots = $aEmptyUnknown

	If $g_bDraggedAttackBar Then DragAttackBar($g_iTotalAttackSlot, True)

	;Reset All Static Variables if GetAttackBar is not for Remaining
	If Not $bRemaining Then
		$bCheckSlot12 = False
		$bDoubleRow = False
		Local $aDummyArray[0][8]
		$aAttackBar = $aDummyArray
		$g_iLSpellLevel = 1
		$g_iESpellLevel = 1
		$g_iSiegeLevel = 0

		;Check if Double Row is enabled aswell as has 12+ Slots
		If _CheckPixel($aDoubRowAttackBar, True) Then
			$bDoubleRow = True
			$sSearchDiamond = GetDiamondFromRect("0, 495, " & $g_iGAME_WIDTH & ", 660")
		ElseIf _CheckPixel($a12OrMoreSlots, True) Then
			$bCheckSlot12 = True
			SetDeBugLog("Found 12th slot for Normal Troops")
		EndIf
		SetDebugLog("GetBarCheck: DoubleRow= " & $bDoubleRow)
	EndIf

	If Not $g_bRunState Then Return

	If Not $bRemaining And $g_bCSVAttackActive And $g_bBattleBarCached And $g_iBattleSearchCount = $g_iSearchCount And $g_sBattleBarHash <> "" Then
		If IsArray($g_aBattleAttackBarCache) And UBound($g_aBattleAttackBarCache, 1) > 0 Then
			$sHash = _GetAttackBarHash($bDoubleRow, $bCheckSlot12)
			If $sHash <> "" And $sHash = $g_sBattleBarHash Then
				If $g_bDebugSetlog Then SetDebugLog("GetAttackBar(): cache hit (CSV)", $COLOR_DEBUG)
				Return $g_aBattleAttackBarCache
			EndIf
		EndIf
	EndIf

	If UBound($aAttackBar) = 0 Or Not $bRemaining Then
		Local $iAttackbarStart = __TimerInit()
		Local $aTempArray, $aTempCoords, $aTempMultiCoords, $iRow = 1
		Local $aAttackBarResult = findMultiple($g_sImgAttackBarDir, $sSearchDiamond, $sSearchDiamond, 0, 1000, 0, "objectname,objectpoints", True)

		If UBound($aAttackBarResult) = 0 Then
			SetLog("Error in GetAttackBar(): Search did not return any results!", $COLOR_ERROR)
			SaveDebugImage("ErrorGetAttackBar", False, Default, "#1")
			Return ""
		EndIf

		;Add found Stuff into our Arrays
		For $i = 0 To UBound($aAttackBarResult, 1) - 1
			$aTempArray = $aAttackBarResult[$i]
			$aTempMultiCoords = decodeMultipleCoords($aTempArray[1], 40, 40, -1)
			For $j = 0 To UBound($aTempMultiCoords, 1) - 1
				$aTempCoords = $aTempMultiCoords[$j]
				If UBound($aTempCoords) < 2 Then ContinueLoop
				If $bDoubleRow And $aTempCoords[1] >= $iYBelowRowOne Then $iRow = 2
				If StringRegExp($aTempArray[0], "(AmountX)", 0) Then
					_ArrayAdd($aSlotAmountX, $aTempCoords[0] & "|" & $aTempCoords[1] & "|" & $iRow, 0, "|", @CRLF, $ARRAYFILL_FORCE_NUMBER)
					$aiOCRLocation[$iRow - 1] = $aTempCoords[1] ; Store any OCR Location for later use on Heroes
				Else
					If StringRegExp($aTempArray[0], "(King)|(Queen)|(Warden)|(Champion)|(Prince)", 0) Then _ArrayAdd($aSlotAmountX, $aTempCoords[0] & "|" & $aTempCoords[1] & "|" & $iRow, 0, "|", @CRLF, $ARRAYFILL_FORCE_NUMBER)
					Local $aTempElement[1][8] = [[$aTempArray[0], $aTempCoords[0], $aTempCoords[1], -1, -1, -1, -1, $iRow]] ; trick to get the right variable types into our array. Delimiter Adding only gets us string which can't be sorted....
					_ArrayAdd($aAttackBar, $aTempElement)
				EndIf
				$iRow = 1
			Next
		Next

		RemoveDuplicateHeroDetections($aAttackBar, $aSlotAmountX, "GetAttackBar():")

		If UBound($aAttackBar, 1) = 0 Then
			SetLog("Error in GetAttackBar(): $aAttackBar has no results in it", $COLOR_ERROR)
			Return ""
		EndIf

		;Sort the Arrays by X Position of the Results
		_ArraySort($aAttackBar, 0, 0, 0, 1)
		_ArraySort($aSlotAmountX)
		If $bDoubleRow Then $aSlotAmountX = SortDoubleRowXElements($aSlotAmountX)

		Local Const $iSlotSpacing = 73
		Local $iInsertedSlots = 0
		Local $iAmountXSlots = UBound($aSlotAmountX, 1)
		Local $aNormalizedSlots = BuildAttackBarSlotMap($aSlotAmountX, $bDoubleRow, $iSlotSpacing, $iInsertedSlots)
		If IsArray($aNormalizedSlots) And UBound($aNormalizedSlots, 1) > 0 Then $aSlotAmountX = $aNormalizedSlots
		$aSlotMap = $aSlotAmountX
		If $g_bDebugSetlog Then SetDebugLog("GetAttackBar(): Slots=" & UBound($aSlotAmountX, 1) & ", AmountX=" & $iAmountXSlots & ", Inserted=" & $iInsertedSlots, $COLOR_DEBUG)

		SetDebugLog("GetAttackBar(): Finished Image Search in: " & StringFormat("%.2f", __TimerDiff($iAttackbarStart)) & " ms")
		$iAttackbarStart = __TimerInit()

	EndIf

	If $bRemaining And UBound($aSlotAmountX, 1) = 0 And UBound($aSlotMap, 1) > 0 Then
		$aSlotAmountX = $aSlotMap
	EndIf

	If $bRemaining And UBound($aSlotAmountX, 1) = 0 And UBound($aSlotMap, 1) > 0 Then
		$aSlotAmountX = $aSlotMap
	EndIf

	#comments-start
		$aAttackBar[n][8]
		[n][0] = Name of the found Troop/Spell/Hero/Siege
		[n][1] = The X Coordinate of the Troop/Spell/Hero/Siege
		[n][2] = The Y Coordinate of the Troop/Spell/Hero/Siege
		[n][3] = The Slot Number (Starts with 0)
		[n][4] = The Amount
		[n][5] = The X Coordinate of the x beside the Amount
		[n][6] = The Y Coordinate of the x beside the Amount
		[n][7] = The Row where it is in
	#comments-end

	Local $aFinalAttackBar[0][7]
	Local $aiOCRY = [-1, -1]
	If Not $bRemaining Then $aiOCRY = GetOCRYLocation($aSlotAmountX)
	Local $iSlotCount = UBound($aSlotAmountX, 1)
	Local $aSlotFinalIndex[0], $aSlotBestScore[0]
	If $iSlotCount > 0 Then
		ReDim $aSlotFinalIndex[$iSlotCount]
		ReDim $aSlotBestScore[$iSlotCount]
		For $i = 0 To $iSlotCount - 1
			$aSlotFinalIndex[$i] = -1
			$aSlotBestScore[$i] = 2147483647
		Next
	EndIf
	Local $sKeepRemainTroops = "(King)|(Queen)|(Warden)|(Champion)|(Prince)|(Castle)|(WallW)|(BattleB)|(StoneS)|(SiegeB)|(LogL)|(FlameF)|(BattleD)"
	Local $sKeepSieges = "(WallW)|(BattleB)|(StoneS)|(SiegeB)|(LogL)|(FlameF)|(BattleD)"

	For $i = 0 To UBound($aAttackBar, 1) - 1
		If $aAttackBar[$i][1] > 0 Then
			Local $bRemoved = False
			If Not $g_bRunState Then Return
			If _Sleep(20) Then Return

			If $bRemaining Then
				$aTroopIsDeployed[0] = $aAttackBar[$i][5] - 15
				$aTroopIsDeployed[1] = $aAttackBar[$i][6]
				Local $bDeployed = _CheckPixel($aTroopIsDeployed, True)
				If Not $bDeployed And StringRegExp($aAttackBar[$i][0], "(Castle)|(WallW)|(BattleB)|(StoneS)|(SiegeB)|(LogL)|(FlameF)|(BattleD)", 0) Then
					$aTroopIsDeployed[0] = $aAttackBar[$i][1]
					$aTroopIsDeployed[1] = $aAttackBar[$i][2]
					$bDeployed = _CheckPixel($aTroopIsDeployed, True)
				EndIf
				If $bDeployed Then
					; Troop got deployed already
					$bRemoved = True
					$aAttackBar[$i][4] = 0 ; set available troops to 0
					If StringRegExp($aAttackBar[$i][0], $sKeepRemainTroops, 0) = 0 Then
						SetDebugLog("GetAttackBar(): Troop " & $aAttackBar[$i][0] & " already deployed, now removed")
						ContinueLoop
					Else
						SetDebugLog("GetAttackBar(): Troop " & $aAttackBar[$i][0] & " already deployed, but stays")
					EndIf
				EndIf
			Else
				Local $aTempSlot = AttackSlot(Number($aAttackBar[$i][1]), Number($aAttackBar[$i][7]), $aSlotAmountX)
				$aAttackBar[$i][5] = Number($aTempSlot[0])
				$aAttackBar[$i][6] = Number($aTempSlot[1])
				$aAttackBar[$i][3] = Number($aTempSlot[2])
				;If StringRegExp($aAttackBar[$i][0], "(King)|(Queen)|(Warden)|(Champion)|(Prince)", 0) And $aiOCRY[$aAttackBar[$i][7] - 1] <> -1 Then $aAttackBar[$i][6] = ($aiOCRY[$aAttackBar[$i][7] - 1] - 7)
			EndIf

				If StringRegExp($aAttackBar[$i][0], $sKeepRemainTroops, 0) Then
					If Not $bRemoved Then $aAttackBar[$i][4] = 1
					If StringRegExp($aAttackBar[$i][0], $sKeepSieges, 0) Then
						$g_iSiegeLevel = Number(getTroopsSpellsLevel(Number($aAttackBar[$i][5]) - 30, 645))
					If $g_iSiegeLevel = "" Then $g_iSiegeLevel = 1
					SetDebugLog($aAttackBar[$i][0] & " Level: " & $g_iSiegeLevel)
				EndIf
			Else
				If Not $bRemoved Then
					$aAttackBar[$i][4] = Number(getTroopCount(Number($aAttackBar[$i][5]), 580))
				EndIf
				If StringRegExp($aAttackBar[$i][0], "(LSpell)", 0) And $g_bSmartZapEnable Then
					Local $iLSpellLevel = Number(getTroopsSpellsLevel(Number($aAttackBar[$i][5]) - 30, 645))
					SetDebugLog("LSpell Level:" & $iLSpellLevel)
					If $iLSpellLevel > 0 And $iLSpellLevel <= 9 Then $g_iLSpellLevel = $iLSpellLevel
				ElseIf StringRegExp($aAttackBar[$i][0], "(ESpell)", 0) And $g_bEarthQuakeZap Then
					Local $iESpellLevel = Number(getTroopsSpellsLevel(Number($aAttackBar[$i][5]) - 30, 645))
					SetDebugLog("ESpell Level:" & $iESpellLevel)
						If $iESpellLevel > 0 And $iESpellLevel <= 5 Then $g_iESpellLevel = $iESpellLevel
					EndIf
				EndIf
				Local $iScoreAmount = Number($aAttackBar[$i][4])
				If $aAttackBar[$i][0] = "Castle" And Not $bRemoved Then
					$iScoreAmount = Number(getTroopCount(Number($aAttackBar[$i][5]), 580))
					If $g_bDebugSetlog Then SetDebugLog("GetAttackBar(): Castle score count at slot " & $aAttackBar[$i][3] & " = " & $iScoreAmount, $COLOR_DEBUG)
				EndIf
				Local $iSlotIndex = $aAttackBar[$i][3]
				Local $iTroopIndex = TroopIndexLookup($aAttackBar[$i][0])
				Local $iCandidateScore = ComputeAttackBarSlotCandidateScore($aAttackBar[$i][0], $iScoreAmount, $aAttackBar[$i][1], $aAttackBar[$i][2], $aAttackBar[$i][5], $aAttackBar[$i][6])
				If $iSlotCount > 0 And $iSlotIndex >= 0 And $iSlotIndex < $iSlotCount Then
						If $aSlotFinalIndex[$iSlotIndex] <> -1 Then
							Local $iExistingRow = $aSlotFinalIndex[$iSlotIndex]
							Local $iExistingTroopIndex = $aFinalAttackBar[$iExistingRow][0]
							Local $bPreferCurrent = False
						If $iExistingTroopIndex = $eCastle And $aAttackBar[$i][0] <> "Castle" Then
							If Number($iScoreAmount) > 1 Then
								$bPreferCurrent = True
								If $g_bDebugSetlog Then SetDebugLog("GetAttackBar(): Duplicate slot " & $iSlotIndex & " preferring " & $aAttackBar[$i][0] & " over Castle", $COLOR_WARNING)
							EndIf
						EndIf
						If $g_bDebugSetlog Then
							SetDebugLog("GetAttackBar(): Duplicate slot " & $iSlotIndex & " compare current=" & $aAttackBar[$i][0] & _
									" score=" & $iCandidateScore & " vs existing=" & GetTroopName($aFinalAttackBar[$aSlotFinalIndex[$iSlotIndex]][0]) & _
									" score=" & $aSlotBestScore[$iSlotIndex], $COLOR_DEBUG)
						EndIf
						If $bPreferCurrent Or $iCandidateScore < $aSlotBestScore[$iSlotIndex] Then
							Local $iReplace = $aSlotFinalIndex[$iSlotIndex]
							SetDebugLog("GetAttackBar(): Duplicate slot " & $iSlotIndex & " for " & $aAttackBar[$i][0] & ", replacing " & GetTroopName($aFinalAttackBar[$iReplace][0]), $COLOR_WARNING)
							$aFinalAttackBar[$iReplace][0] = $iTroopIndex
						$aFinalAttackBar[$iReplace][1] = $aAttackBar[$i][3]
						$aFinalAttackBar[$iReplace][2] = $aAttackBar[$i][4]
						$aFinalAttackBar[$iReplace][3] = $aAttackBar[$i][1]
						$aFinalAttackBar[$iReplace][4] = $aAttackBar[$i][2]
						$aFinalAttackBar[$iReplace][5] = $aAttackBar[$i][5]
						$aFinalAttackBar[$iReplace][6] = $aAttackBar[$i][6]
						$aSlotBestScore[$iSlotIndex] = $iCandidateScore
					Else
						SetDebugLog("GetAttackBar(): Duplicate slot " & $iSlotIndex & " for " & $aAttackBar[$i][0], $COLOR_WARNING)
					EndIf
					ContinueLoop
				EndIf
			EndIf
			; 0: Index, 1: Slot, 2: Amount, 3: X-Coord, 4: Y-Coord, 5: OCR X-Coord, 6: OCR Y-Coord
			Local $aTempFinalArray[1][7] = [[$iTroopIndex, $aAttackBar[$i][3], $aAttackBar[$i][4], $aAttackBar[$i][1], $aAttackBar[$i][2], $aAttackBar[$i][5], $aAttackBar[$i][6]]]
			_ArrayAdd($aFinalAttackBar, $aTempFinalArray)
			If $iSlotCount > 0 And $iSlotIndex >= 0 And $iSlotIndex < $iSlotCount Then
				$aSlotFinalIndex[$iSlotIndex] = UBound($aFinalAttackBar, 1) - 1
				$aSlotBestScore[$iSlotIndex] = $iCandidateScore
			EndIf
		EndIf
	Next

	RecordUnknownSlots($aFinalAttackBar, $aSlotAmountX, $bRemaining, 0, "page1")

	Local $iTotalSlots = $iSlotCount
	; Drag left & checking extended troops from Slot11+ ONLY if not a smart attack
	If ($pMatchMode <= $LB And $bCheckSlot12 And Not $bDoubleRow And UBound($aAttackBar) > 1 And $g_aiAttackAlgorithm[$pMatchMode] <> 2) Or ($bDebug And $bCheckSlot12) Then
		DragAttackBar()
		Local $iExtendedSlotCount = 0
		Local $aExtendedArray = ExtendedAttackBarCheck($aAttackBar, $bRemaining, $sSearchDiamond, $iExtendedSlotCount)
		_ArrayAdd($aFinalAttackBar, $aExtendedArray)
		If $iExtendedSlotCount > $iTotalSlots Then $iTotalSlots = $iExtendedSlotCount
	EndIf

	If Not $bRemaining And $iTotalSlots > 0 Then
		$g_iTotalAttackSlot = $iTotalSlots - 1
		If $g_bDraggedAttackBar Then DragAttackBar($g_iTotalAttackSlot, True) ; return drag
	EndIf

	_ArraySort($aFinalAttackBar, 0, 0, 0, 1) ; Sort Final Array by Slot Number
	If Not $bRemaining And $g_bCSVAttackActive And $g_iBattleSearchCount = $g_iSearchCount Then
		If $sHash = "" Then $sHash = _GetAttackBarHash($bDoubleRow, $bCheckSlot12)
		If $sHash <> "" Then
			$g_sBattleBarHash = $sHash
			$g_bBattleBarCached = True
			$g_aBattleAttackBarCache = $aFinalAttackBar
		EndIf
	EndIf
	Return $aFinalAttackBar

EndFunc   ;==>GetBarCheck

; #FUNCTION# ====================================================================================================================
; Name ..........: ExtendedAttackBarCheck
; Description ...: Detects extended attack bar slots after drag and returns slot data.
; Syntax ........: ExtendedAttackBarCheck($aAttackBarFirstSearch, $bRemaining, $sSearchDiamond, ByRef $iTotalSlots)
; Parameters ....: $aAttackBarFirstSearch, $bRemaining, $sSearchDiamond, $iTotalSlots (out)
; Return values .: Array of slot data
; Author ........:
; Modified ......: mxkcz
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; =====================================================================================================================
Func ExtendedAttackBarCheck($aAttackBarFirstSearch, $bRemaining, $sSearchDiamond, ByRef $iTotalSlots)

	Local Static $aAttackBar[0][8]
	Local Static $aSlotMap[0][3]
	Local $iLastSlotNumber = _ArrayMax($aAttackBarFirstSearch, 0, -1, -1, 3)
	Local $sLastTroopName = $aAttackBarFirstSearch[_ArrayMaxIndex($aAttackBarFirstSearch, 0, -1, -1, 1)][0], $aiOCRLocation[2] = [-1, -1]
	Local $aSlotAmountX[0][3]

	;Reset All Static Variables if the AttackBarCheck is not for Remaining
	If Not $bRemaining Then
		Local $aDummyArray[0][8]
		$aAttackBar = $aDummyArray
		$g_iTotalAttackSlot = 11
	EndIf

	If Not $g_bRunState Then Return

	If UBound($aAttackBar) = 0 Or Not $bRemaining Then
		Local $iAttackbarStart = __TimerInit()
		Local $aTempArray, $aTempCoords, $aTempMultiCoords, $iRow = 1

		Local $aAttackBarResult = findMultiple($g_sImgAttackBarDir, $sSearchDiamond, $sSearchDiamond, 0, 1000, 0, "objectname,objectpoints", True)

		If UBound($aAttackBarResult) = 0 Then
			SetLog("Error in AttackBarCheck(): Search did not return any results!", $COLOR_ERROR)
			SaveDebugImage("ErrorAttackBarCheck", False, Default, "#2")
			Return ""
		EndIf

		;Add found Stuff into our Arrays
		For $i = 0 To UBound($aAttackBarResult, 1) - 1
			$aTempArray = $aAttackBarResult[$i]
			$aTempMultiCoords = decodeMultipleCoords($aTempArray[1], 40, 40, -1)
			For $j = 0 To UBound($aTempMultiCoords, 1) - 1
				$aTempCoords = $aTempMultiCoords[$j]
				If UBound($aTempCoords) < 2 Then ContinueLoop
				If StringRegExp($aTempArray[0], "(AmountX)", 0) Then
					_ArrayAdd($aSlotAmountX, $aTempCoords[0] & "|" & $aTempCoords[1] & "|" & $iRow, 0, "|", @CRLF, $ARRAYFILL_FORCE_NUMBER)
					$aiOCRLocation[$iRow - 1] = $aTempCoords[1]
				Else
					If StringRegExp($aTempArray[0], "(King)|(Queen)|(Warden)|(Champion)|(Prince)", 0) Then _ArrayAdd($aSlotAmountX, $aTempCoords[0] & "|" & $aTempCoords[1] & "|" & $iRow, 0, "|", @CRLF, $ARRAYFILL_FORCE_NUMBER)
					Local $aTempElement[1][8] = [[$aTempArray[0], $aTempCoords[0], $aTempCoords[1], -1, -1, -1, -1, $iRow]]
					_ArrayAdd($aAttackBar, $aTempElement)
				EndIf
			Next
		Next

		RemoveDuplicateHeroDetections($aAttackBar, $aSlotAmountX, "AttackBarCheck():")

		If UBound($aAttackBar, 1) = 0 Then
			SetLog("Error in AttackBarCheck(): $aAttackBar has no results in it", $COLOR_ERROR)
			Return ""
		EndIf

		;Sort the Arrays by X Position of the Results
		_ArraySort($aAttackBar, 0, 0, 0, 1)
		_ArraySort($aSlotAmountX)

		Local Const $iSlotSpacing = 73
		Local $iInsertedSlots = 0
		Local $iAmountXSlots = UBound($aSlotAmountX, 1)
		Local $aNormalizedSlots = BuildAttackBarSlotMap($aSlotAmountX, False, $iSlotSpacing, $iInsertedSlots)
		If IsArray($aNormalizedSlots) And UBound($aNormalizedSlots, 1) > 0 Then $aSlotAmountX = $aNormalizedSlots
		$aSlotMap = $aSlotAmountX
		If $g_bDebugSetlog Then SetDebugLog("AttackBarCheck(): Slots=" & UBound($aSlotAmountX, 1) & ", AmountX=" & $iAmountXSlots & ", Inserted=" & $iInsertedSlots, $COLOR_DEBUG)

		SetDebugLog("AttackBarCheck(): Finished Image Search in: " & StringFormat("%.2f", __TimerDiff($iAttackbarStart)) & " ms")
		$iAttackbarStart = __TimerInit()
	EndIf

	#comments-start
		$aAttackBar[n][8]
		[n][0] = Name of the found Troop/Spell/Hero/Siege
		[n][1] = The X Coordinate of the Troop/Spell/Hero/Siege
		[n][2] = The Y Coordinate of the Troop/Spell/Hero/Siege
		[n][3] = The Slot Number (Starts with 0)
		[n][4] = The Amount
		[n][5] = The X Coordinate of the x beside the Amount
		[n][6] = The Y Coordinate of the x beside the Amount
		[n][7] = The Row where it is in
	#comments-end

	Local $aFinalAttackBar[0][7]
	Local $aiOCRY = [-1, -1]
	Local $sKeepRemainTroops = "(King)|(Queen)|(Warden)|(Champion)|(WallW)|(BattleB)|(StoneS)|(SiegeB)|(LogL)|(FlameF)|(BattleD)"
	
	If Not $bRemaining Then
		$aiOCRY = GetOCRYLocation($aSlotAmountX)
		Local $iLastTroopIndex = _ArraySearch($aAttackBar, $sLastTroopName, 0, 0, 0, 0, 1, 0) + 1
		$aAttackBar = _ArrayExtract($aAttackBar, $iLastTroopIndex)
		$aSlotAmountX = _ArrayExtract($aSlotAmountX, $iLastTroopIndex)
		If UBound($aSlotAmountX, 1) > 0 Then $aSlotMap = $aSlotAmountX
	EndIf

	Local $iSlotCount = UBound($aSlotAmountX, 1)
	Local $aSlotFinalIndex[0], $aSlotBestScore[0]
	Local $iSlotMapSize = $iSlotCount + $iLastSlotNumber + 1
	If $iSlotMapSize > 0 Then
		ReDim $aSlotFinalIndex[$iSlotMapSize]
		ReDim $aSlotBestScore[$iSlotMapSize]
		For $i = 0 To $iSlotMapSize - 1
			$aSlotFinalIndex[$i] = -1
			$aSlotBestScore[$i] = 2147483647
		Next
	EndIf

	For $i = 0 To UBound($aAttackBar, 1) - 1
		If $aAttackBar[$i][1] > 0 Then
			Local $bRemoved = False
			If Not $g_bRunState Then Return
			If _Sleep(20) Then Return

			If $bRemaining Then
				$aTroopIsDeployed[0] = $aAttackBar[$i][5] - 15
				$aTroopIsDeployed[1] = $aAttackBar[$i][6]
				Local $bDeployed = _CheckPixel($aTroopIsDeployed, True)
				If Not $bDeployed And StringRegExp($aAttackBar[$i][0], "(Castle)|(WallW)|(BattleB)|(StoneS)|(SiegeB)|(LogL)|(FlameF)|(BattleD)", 0) Then
					$aTroopIsDeployed[0] = $aAttackBar[$i][1]
					$aTroopIsDeployed[1] = $aAttackBar[$i][2]
					$bDeployed = _CheckPixel($aTroopIsDeployed, True)
				EndIf
				If $bDeployed Then
					; Troop got deployed already
					$bRemoved = True
					$aAttackBar[$i][4] = 0 ; set available troops to 0
					If StringRegExp($aAttackBar[$i][0], $sKeepRemainTroops, 0) = 0 Then
						SetDebugLog("AttackBarCheck(): Troop " & $aAttackBar[$i][0] & " already deployed, now removed")
						ContinueLoop
					Else
						SetDebugLog("AttackBarCheck(): Troop " & $aAttackBar[$i][0] & " already deployed, but stays")
					EndIf
				EndIf
			Else
				Local $aTempSlot = AttackSlot(Number($aAttackBar[$i][1]), Number($aAttackBar[$i][7]), $aSlotAmountX)
				$aAttackBar[$i][5] = Number($aTempSlot[0])
				$aAttackBar[$i][6] = Number($aTempSlot[1])
				$aAttackBar[$i][3] = Number($aTempSlot[2] + $iLastSlotNumber + 1)
				If StringRegExp($aAttackBar[$i][0], "(King)|(Queen)|(Warden)|(Champion)|(Prince)", 0) And $aiOCRY[$aAttackBar[$i][7] - 1] <> -1 Then $aAttackBar[$i][6] = ($aiOCRY[$aAttackBar[$i][7] - 1] - 7)
			EndIf

				If StringRegExp($aAttackBar[$i][0], "(King)|(Queen)|(Warden)|(Champion)|(Castle)|(WallW)|(BattleB)|(StoneS)|(SiegeB)|(LogL)|(FlameF)", 0) Then
					If Not $bRemoved Then $aAttackBar[$i][4] = 1
				Else
					If Not $bRemoved Then
						$aAttackBar[$i][4] = Number(getTroopCount(Number($aAttackBar[$i][5]), 580))
				EndIf
				If StringRegExp($aAttackBar[$i][0], "(LSpell)", 0) And $g_bSmartZapEnable Then
					Local $iLSpellLevel = Number(getTroopsSpellsLevel(Number($aAttackBar[$i][5]) - 30, 645))
					SetDebugLog("$LSpell Level:" & $iLSpellLevel)
					If $iLSpellLevel > 0 And $iLSpellLevel <= 9 Then $g_iLSpellLevel = $iLSpellLevel
				ElseIf StringRegExp($aAttackBar[$i][0], "(ESpell)", 0) And $g_bEarthQuakeZap Then
					Local $iESpellLevel = Number(getTroopsSpellsLevel(Number($aAttackBar[$i][5]) - 30, 645))
					SetDebugLog("ESpell Level:" & $iESpellLevel)
						If $iESpellLevel > 0 And $iESpellLevel <= 5 Then $g_iESpellLevel = $iESpellLevel
					EndIf
				EndIf
				Local $iScoreAmount = Number($aAttackBar[$i][4])
				If $aAttackBar[$i][0] = "Castle" And Not $bRemoved Then
					$iScoreAmount = Number(getTroopCount(Number($aAttackBar[$i][5]), 580))
					If $g_bDebugSetlog Then SetDebugLog("AttackBarCheck(): Castle score count at slot " & $aAttackBar[$i][3] & " = " & $iScoreAmount, $COLOR_DEBUG)
				EndIf
				Local $iSlotIndex = $aAttackBar[$i][3]
				Local $iTroopIndex = TroopIndexLookup($aAttackBar[$i][0])
				Local $iCandidateScore = ComputeAttackBarSlotCandidateScore($aAttackBar[$i][0], $iScoreAmount, $aAttackBar[$i][1], $aAttackBar[$i][2], $aAttackBar[$i][5], $aAttackBar[$i][6])
				If $iSlotMapSize > 0 And $iSlotIndex >= 0 And $iSlotIndex < $iSlotMapSize Then
						If $aSlotFinalIndex[$iSlotIndex] <> -1 Then
							Local $iExistingRow = $aSlotFinalIndex[$iSlotIndex]
							Local $iExistingTroopIndex = $aFinalAttackBar[$iExistingRow][0]
							Local $bPreferCurrent = False
						If $iExistingTroopIndex = $eCastle And $aAttackBar[$i][0] <> "Castle" Then
							If Number($iScoreAmount) > 1 Then
								$bPreferCurrent = True
								If $g_bDebugSetlog Then SetDebugLog("AttackBarCheck(): Duplicate slot " & $iSlotIndex & " preferring " & $aAttackBar[$i][0] & " over Castle", $COLOR_WARNING)
							EndIf
						EndIf
						If $g_bDebugSetlog Then
							SetDebugLog("AttackBarCheck(): Duplicate slot " & $iSlotIndex & " compare current=" & $aAttackBar[$i][0] & _
									" score=" & $iCandidateScore & " vs existing=" & GetTroopName($aFinalAttackBar[$aSlotFinalIndex[$iSlotIndex]][0]) & _
									" score=" & $aSlotBestScore[$iSlotIndex], $COLOR_DEBUG)
						EndIf
						If $bPreferCurrent Or $iCandidateScore < $aSlotBestScore[$iSlotIndex] Then
							Local $iReplace = $aSlotFinalIndex[$iSlotIndex]
							SetDebugLog("AttackBarCheck(): Duplicate slot " & $iSlotIndex & " for " & $aAttackBar[$i][0] & ", replacing " & GetTroopName($aFinalAttackBar[$iReplace][0]), $COLOR_WARNING)
							$aFinalAttackBar[$iReplace][0] = $iTroopIndex
						$aFinalAttackBar[$iReplace][1] = $aAttackBar[$i][3]
						$aFinalAttackBar[$iReplace][2] = $aAttackBar[$i][4]
						$aFinalAttackBar[$iReplace][3] = $aAttackBar[$i][1]
						$aFinalAttackBar[$iReplace][4] = $aAttackBar[$i][2]
						$aFinalAttackBar[$iReplace][5] = $aAttackBar[$i][5]
						$aFinalAttackBar[$iReplace][6] = $aAttackBar[$i][6]
						$aSlotBestScore[$iSlotIndex] = $iCandidateScore
					Else
						SetDebugLog("AttackBarCheck(): Duplicate slot " & $iSlotIndex & " for " & $aAttackBar[$i][0], $COLOR_WARNING)
					EndIf
					ContinueLoop
				EndIf
			EndIf
			; 0: Index, 1: Slot, 2: Amount, 3: X-Coord, 4: Y-Coord, 5: OCR X-Coord, 6: OCR Y-Coord
			Local $aTempFinalArray[1][7] = [[$iTroopIndex, $aAttackBar[$i][3], $aAttackBar[$i][4], $aAttackBar[$i][1], $aAttackBar[$i][2], $aAttackBar[$i][5], $aAttackBar[$i][6]]]
			_ArrayAdd($aFinalAttackBar, $aTempFinalArray)
			If $iSlotMapSize > 0 And $iSlotIndex >= 0 And $iSlotIndex < $iSlotMapSize Then
				$aSlotFinalIndex[$iSlotIndex] = UBound($aFinalAttackBar, 1) - 1
				$aSlotBestScore[$iSlotIndex] = $iCandidateScore
			EndIf
		EndIf
	Next

	RecordUnknownSlots($aFinalAttackBar, $aSlotAmountX, $bRemaining, $iLastSlotNumber + 1, "page2")

	If $iSlotCount > 0 Then $iTotalSlots = $iLastSlotNumber + 1 + $iSlotCount

	_ArraySort($aFinalAttackBar, 0, 0, 0, 1) ; Sort Final Array by Slot Number

	Return $aFinalAttackBar
EndFunc   ;==>ExtendedAttackBarCheck

Func GetOCRYLocation($aArray)
	Local $aiReturn[2] = [-1, -1], $aTempArray[0], $aTempArray2[0]
	For $i = 0 To UBound($aArray, 1) - 1
		If $aArray[$i][2] = 1 Then
			_ArrayAdd($aTempArray, $aArray[$i][1])
		Else
			_ArrayAdd($aTempArray2, $aArray[$i][1])
		EndIf
	Next
	$aiReturn[0] = _ArrayMin($aTempArray)
	$aiReturn[1] = _ArrayMin($aTempArray2)

	Return $aiReturn
EndFunc   ;==>GetOCRYLocation

Func SearchNearest($aArray, $iNumber, $iRow)
	Local $iVal, $iValOld = _ArrayMax($aArray), $iReturn
	For $i = 0 To UBound($aArray) - 1
		$iVal = Abs($aArray[$i][0] - $iNumber)
		If $iValOld >= $iVal And $iRow = Number($aArray[$i][2]) Then
			$iValOld = $iVal
			$iReturn = $i
		EndIf
	Next
	Return $iReturn
EndFunc   ;==>SearchNearest

Func SortDoubleRowXElements($aArray)
	Local $aSecondRow[0][3]
	Local $aNewSlotAmountX[0][3]
	For $i = 0 To UBound($aArray) - 1
		If $aArray[$i][2] = 2 Then
			_ArrayAdd($aSecondRow, _ArrayExtract($aArray, $i, $i))
		Else
			_ArrayAdd($aNewSlotAmountX, _ArrayExtract($aArray, $i, $i))
		EndIf
	Next
	_ArraySort($aNewSlotAmountX)
	_ArraySort($aSecondRow)
	_ArrayAdd($aNewSlotAmountX, $aSecondRow)

	Return $aNewSlotAmountX
EndFunc   ;==>SortDoubleRowXElements

; #FUNCTION# ====================================================================================================================
; Name ..........: RemoveDuplicateHeroDetections
; Description ...: Removes duplicate hero detections across templates and matching slot markers.
; Syntax ........: RemoveDuplicateHeroDetections(ByRef $aAttackBar, ByRef $aSlotAmountX, $sContext = "")
; Parameters ....: $aAttackBar, $aSlotAmountX, $sContext
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; =====================================================================================================================
Func RemoveDuplicateHeroDetections(ByRef $aAttackBar, ByRef $aSlotAmountX, $sContext = "")
	If UBound($aAttackBar, 0) <> 2 Or UBound($aAttackBar, 1) <= 1 Then Return

	Local Const $iHeroProximityThreshold = 50
	Local Const $sHeroPattern = "(King)|(Queen)|(Warden)|(Champion)|(Prince)"

	For $i = UBound($aAttackBar, 1) - 1 To 1 Step -1
		If StringRegExp($aAttackBar[$i][0], $sHeroPattern, 0) = 0 Then ContinueLoop
		For $j = 0 To $i - 1
			If $aAttackBar[$j][0] <> $aAttackBar[$i][0] Then ContinueLoop

			Local $iDeltaX = Abs($aAttackBar[$i][1] - $aAttackBar[$j][1])
			Local $iDeltaY = Abs($aAttackBar[$i][2] - $aAttackBar[$j][2])
			If $iDeltaX <= $iHeroProximityThreshold And $iDeltaY <= $iHeroProximityThreshold Then
				RemoveNearestAttackBarSlot($aSlotAmountX, $aAttackBar[$i][1], $aAttackBar[$i][2], $iHeroProximityThreshold, Number($aAttackBar[$i][7]))
				SetDebugLog($sContext & " Removing duplicate " & $aAttackBar[$i][0] & " detection at (" & $aAttackBar[$i][1] & "," & $aAttackBar[$i][2] & ")", $COLOR_WARNING)
				_ArrayDelete($aAttackBar, $i)
				ExitLoop
			EndIf
		Next
	Next
EndFunc   ;==>RemoveDuplicateHeroDetections

; #FUNCTION# ====================================================================================================================
; Name ..........: RemoveNearestAttackBarSlot
; Description ...: Removes a duplicate slot marker nearest to a duplicate hero detection.
; Syntax ........: RemoveNearestAttackBarSlot(ByRef $aSlotAmountX, $iPosX, $iPosY, $iThreshold, $iRow = -1)
; Parameters ....: $aSlotAmountX, $iPosX, $iPosY, $iThreshold, $iRow
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; =====================================================================================================================
Func RemoveNearestAttackBarSlot(ByRef $aSlotAmountX, $iPosX, $iPosY, $iThreshold, $iRow = -1)
	If UBound($aSlotAmountX, 0) <> 2 Or UBound($aSlotAmountX, 1) <= 1 Then Return

	Local $aCandidates[0], $iDelete = -1, $iBestDistance = 0
	For $i = 0 To UBound($aSlotAmountX, 1) - 1
		If $iRow <> -1 And Number($aSlotAmountX[$i][2]) <> $iRow Then ContinueLoop

		Local $iDeltaX = Abs($aSlotAmountX[$i][0] - $iPosX)
		Local $iDeltaY = Abs($aSlotAmountX[$i][1] - $iPosY)
		If $iDeltaX > $iThreshold Or $iDeltaY > $iThreshold Then ContinueLoop

		_ArrayAdd($aCandidates, $i)
		Local $iDistance = $iDeltaX + $iDeltaY
		If $iDelete = -1 Or $iDistance < $iBestDistance Then
			$iDelete = $i
			$iBestDistance = $iDistance
		EndIf
	Next

	; Only remove when we can prove duplicate slot markers exist nearby.
	If UBound($aCandidates) >= 2 And $iDelete <> -1 Then _ArrayDelete($aSlotAmountX, $iDelete)
EndFunc   ;==>RemoveNearestAttackBarSlot

; #FUNCTION# ====================================================================================================================
; Name ..........: BuildAttackBarSlotMap
; Description ...: Normalizes attack bar slot map by filling gaps based on expected spacing.
; Syntax ........: BuildAttackBarSlotMap($aSlotAmountX, $bDoubleRow, $iSlotSpacing, ByRef $iInserted)
; Parameters ....: $aSlotAmountX, $bDoubleRow, $iSlotSpacing, $iInserted (out)
; Return values .: Normalized slot map array
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; =====================================================================================================================
Func BuildAttackBarSlotMap(ByRef $aSlotAmountX, $bDoubleRow, $iSlotSpacing, ByRef $iInserted)
	$iInserted = 0
	If UBound($aSlotAmountX, 0) <> 2 Or UBound($aSlotAmountX, 1) = 0 Then Return $aSlotAmountX

	Local $aRow1[0][3], $aRow2[0][3]
	For $i = 0 To UBound($aSlotAmountX, 1) - 1
		If $aSlotAmountX[$i][2] = 2 Then
			Local $aTempRow[1][3] = [[$aSlotAmountX[$i][0], $aSlotAmountX[$i][1], $aSlotAmountX[$i][2]]]
			_ArrayAdd($aRow2, $aTempRow)
		Else
			Local $aTempRow[1][3] = [[$aSlotAmountX[$i][0], $aSlotAmountX[$i][1], $aSlotAmountX[$i][2]]]
			_ArrayAdd($aRow1, $aTempRow)
		EndIf
	Next

	If UBound($aRow1, 1) > 0 Then _ArraySort($aRow1, 0, 0, 0, 0)
	If UBound($aRow2, 1) > 0 Then _ArraySort($aRow2, 0, 0, 0, 0)

	Local $aFilled[0][3]
	Local $aFilledRow1 = _FillAttackBarSlotRow($aRow1, $iSlotSpacing, $iInserted)
	If IsArray($aFilledRow1) And UBound($aFilledRow1, 1) > 0 Then _ArrayAdd($aFilled, $aFilledRow1)
	If $bDoubleRow Then
		Local $aFilledRow2 = _FillAttackBarSlotRow($aRow2, $iSlotSpacing, $iInserted)
		If IsArray($aFilledRow2) And UBound($aFilledRow2, 1) > 0 Then _ArrayAdd($aFilled, $aFilledRow2)
	EndIf

	Return $aFilled
EndFunc   ;==>BuildAttackBarSlotMap

; #FUNCTION# ====================================================================================================================
; Name ..........: _FillAttackBarSlotRow
; Description ...: Inserts missing slots in a single row based on spacing.
; Syntax ........: _FillAttackBarSlotRow($aRow, $iSlotSpacing, ByRef $iInserted)
; Parameters ....: $aRow, $iSlotSpacing, $iInserted (in/out)
; Return values .: Row with inserted slots
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; =====================================================================================================================
Func _FillAttackBarSlotRow(ByRef $aRow, $iSlotSpacing, ByRef $iInserted)
	Local $aFilled[0][3]
	If UBound($aRow, 0) <> 2 Or UBound($aRow, 1) = 0 Then Return $aFilled

	For $i = 0 To UBound($aRow, 1) - 1
		Local $aTempRow[1][3] = [[$aRow[$i][0], $aRow[$i][1], $aRow[$i][2]]]
		_ArrayAdd($aFilled, $aTempRow)
		If $i >= UBound($aRow, 1) - 1 Then ContinueLoop

		Local $iDeltaX = $aRow[$i + 1][0] - $aRow[$i][0]
		Local $iSteps = Int((($iDeltaX + ($iSlotSpacing / 2)) / $iSlotSpacing))
		If $iSteps > 1 Then
			For $k = 1 To $iSteps - 1
				Local $iInsertX = $aRow[$i][0] + ($iSlotSpacing * $k)
				Local $aMissing[1][3] = [[$iInsertX, $aRow[$i][1], $aRow[$i][2]]]
				_ArrayAdd($aFilled, $aMissing)
				$iInserted += 1
			Next
		EndIf
	Next

	Return $aFilled
EndFunc   ;==>_FillAttackBarSlotRow

; #FUNCTION# ====================================================================================================================
; Name ..........: RecordUnknownSlots
; Description ...: Tracks slots without detected troop icons and records counts for REMAIN drops.
; Syntax ........: RecordUnknownSlots($aFinalAttackBar, $aSlotAmountX, $bRemaining, $iSlotOffset = 0, $sContext = "")
; Parameters ....: $aFinalAttackBar, $aSlotAmountX, $bRemaining, $iSlotOffset, $sContext
; Return values .: Number of unknown slots detected
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; =====================================================================================================================
Func RecordUnknownSlots(ByRef $aFinalAttackBar, ByRef $aSlotAmountX, $bRemaining, $iSlotOffset = 0, $sContext = "")
	If UBound($aSlotAmountX, 0) <> 2 Or UBound($aSlotAmountX, 1) = 0 Then Return 0

	Local Const $iOcrEdgeGuard = 60
	Local Const $iOcrEdgeX = 53
	Local Const $iOcrXOffset = 15
	Local Const $iOcrYOffset = 7
	Local Const $iClickXOffset = 10
	Local Const $iClickYOffset = 22

	Local $iSlotCount = UBound($aSlotAmountX, 1)
	Local $aUsed[$iSlotCount]
	For $i = 0 To UBound($aFinalAttackBar, 1) - 1
		If $aFinalAttackBar[$i][0] >= 0 Then
			Local $iSlot = $aFinalAttackBar[$i][1] - $iSlotOffset
			If $iSlot >= 0 And $iSlot < $iSlotCount Then $aUsed[$iSlot] = 1
		EndIf
	Next

	Local $iUnknown = 0
	For $i = 0 To $iSlotCount - 1
		If $aUsed[$i] Then ContinueLoop
		$iUnknown += 1
		If $bRemaining Then
			Local $iSlotIndex = $i + $iSlotOffset
			Local $iX = $aSlotAmountX[$i][0]
			Local $iY = $aSlotAmountX[$i][1]
			Local $iOcrX = ($i = $iSlotCount - 1 And $iX >= ($g_iGAME_WIDTH - $iOcrEdgeGuard)) ? $g_iGAME_WIDTH - $iOcrEdgeX : $iX - $iOcrXOffset
			Local $iOcrY = $iY - $iOcrYOffset
			Local $iCount = Number(getTroopCount($iOcrX, $iOcrY))
			If $iCount > 0 Then
				Local $iClickX = $iX - $iClickXOffset
				Local $iClickY = $iY + $iClickYOffset
				Local $aUnknown[1][6] = [[$iSlotIndex, $iClickX, $iClickY, $iOcrX, $iOcrY, $iCount]]
				_ArrayAdd($g_avAttackUnknownSlots, $aUnknown)
				If $g_bDebugSetlog Then SetDebugLog("Unknown slot " & $iSlotIndex & " x" & $iCount & " (" & $sContext & ")", $COLOR_DEBUG)
			EndIf
		EndIf
	Next
	If $g_bDebugSetlog Then SetDebugLog("GetAttackBar(): Unknown slots(" & $sContext & ")=" & $iUnknown, $COLOR_DEBUG)

	Return $iUnknown
EndFunc   ;==>RecordUnknownSlots

Func DragAttackBar($iTotalSlot = 20, $bBack = False)
	If $g_iTotalAttackSlot > 10 Then $iTotalSlot = $g_iTotalAttackSlot
	Local $bAlreadyDrag = False

	If Not $bBack Then
		SetDebugLog("Dragging attack troop bar to 2nd page. Distance = " & $iTotalSlot - 9 & " slots")
		ClickDrag(25 + 73 * ($iTotalSlot - 9), 620, 25, 620, 1000)
		If _Sleep(1000 + $iTotalSlot * 25) Then Return
		$bAlreadyDrag = True
	Else
		SetDebugLog("Dragging attack troop bar back to 1st page. Distance = " & $iTotalSlot - 9 & " slots")
		ClickDrag(25, 620, 25 + 73 * ($iTotalSlot - 9), 620, 1000)
		If _Sleep(800 + $iTotalSlot * 25) Then Return
		$bAlreadyDrag = False
	EndIf

	$g_bDraggedAttackBar = $bAlreadyDrag
	$g_iCSVLastTroopPositionDropTroopFromINI = -1 ; after drag attack bar, need to clear last troop selected
	Return $bAlreadyDrag
EndFunc   ;==>DragAttackBar

Func AttackSlot($iPosX, $iRow, $aSlots)
	Local $aTempSlot[3] = [0, 0, 0]
	Local $iClosest = SearchNearest($aSlots, $iPosX, $iRow)
	Local $bLast = False
	If $iClosest = _ArrayMaxIndex($aSlots, 0) And $aSlots[$iClosest][0] >= ($g_iGAME_WIDTH - 60) Then $bLast = True

	If $iClosest >= 0 And $iClosest < UBound($aSlots) Then
		$aTempSlot[0] = $bLast ? $g_iGAME_WIDTH - 53 : $aSlots[$iClosest][0] - 15 ; X Coord | Last Item to get OCRd needs to be compensated because it could happen that the Capture Rectangle gets out of boundary and image gets not usable
		$aTempSlot[1] = $aSlots[$iClosest][1] - 7 ; Y Coord
		$aTempSlot[2] = $iClosest
	EndIf

	Return $aTempSlot
EndFunc   ;==>AttackSlot

; #FUNCTION# ====================================================================================================================
; Name ..........: ComputeAttackBarSlotCandidateScore
; Description ...: Scores competing troop detections for the same slot; lower score is preferred.
; Syntax ........: ComputeAttackBarSlotCandidateScore($sName, $iAmount, $iIconX, $iIconY, $iOcrX, $iOcrY)
; Parameters ....: $sName, $iAmount, $iIconX, $iIconY, $iOcrX, $iOcrY
; Return values .: Integer score
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; =====================================================================================================================
Func ComputeAttackBarSlotCandidateScore($sName, $iAmount, $iIconX, $iIconY, $iOcrX, $iOcrY)
	Local $iScore = Abs(Number($iIconX) - (Number($iOcrX) + 15)) + Abs(Number($iIconY) - (Number($iOcrY) + 7))
	If $sName = "Castle" And Number($iAmount) > 1 Then $iScore += 800 ; CC icon cannot be x2+, strongly penalize false-positive reads
	If $sName <> "Castle" And Number($iAmount) > 1 Then $iScore -= 40 ; Prefer non-CC candidates with valid troop counts
	Return $iScore
EndFunc   ;==>ComputeAttackBarSlotCandidateScore

Func DebugAttackBarImage($aAttackBarResult)
	#comments-start
		SetDebugLog("Attackbar OCR completed in " & StringFormat("%.2f", __TimerDiff($iAttackbarStart)) & " ms")

		If $bDebug Then
		Local $iX1 = 0, $iY1 = 635, $iX2 = 853, $iY2 = 698
		_CaptureRegion2($iX1, $iY1, $iX2, $iY2)

		Local $sSubDir = $g_sProfileTempDebugPath & "AttackBarDetection"

		DirCreate($sSubDir)

		Local $sDate = @YEAR & "-" & @MON & "-" & @MDAY, $sTime = @HOUR & "." & @MIN & "." & @SEC
		Local $sDebugImageName = String($sDate & "_" & $sTime & "_.png")
		Local $hEditedImage = _GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap2)
		Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($hEditedImage)
		Local $hPenRED = _GDIPlus_PenCreate(0xFFFF0000, 3)

		For $i = 0 To UBound($aResult) - 1
		addInfoToDebugImage($hGraphic, $hPenRED, $aResult[$i][0], $aResult[$i][1], $aResult[$i][2])
		Next

		_GDIPlus_ImageSaveToFile($hEditedImage, $sSubDir & "\" & $sDebugImageName)
		_GDIPlus_PenDispose($hPenRED)
		_GDIPlus_GraphicsDispose($hGraphic)
		_GDIPlus_BitmapDispose($hEditedImage)
		EndIf

	#comments-end
EndFunc   ;==>DebugAttackBarImage
