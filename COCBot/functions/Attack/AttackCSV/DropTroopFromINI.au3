; #FUNCTION# ====================================================================================================================
; Name ..........: DropTroopFromINI
; Description ...:
; Syntax ........: DropTroopFromINI($vectors, $iStartIndex, $iEndIndex, $iMinQuantity, $iMaxQuantity, $sTroopName, $delayPointmin,
;                  $delayPointmax, $delayDropMin, $delayDropMax, $sleepafterMin, $sleepAfterMax[, $debug = False[, $bAllowPreDropVerify = True[, $iOverDrop = 0[, $bPostDropVerify = False]]]])
; Parameters ....: $vectors             -
;                  $iStartIndex         -
;                  $iEndIndex           -
;                  $iMinQuantity        -
;                  $iMaxQuantity        -
;                  $sTroopName          -
;                  $delayPointmin       -
;                  $delayPointmax       -
;                  $delayDropMin        -
;                  $delayDropMax        -
;                  $sleepafterMin       -
;                  $sleepAfterMax       -
;                  $bDebug               - [optional] Default is False.
;                  $bAllowPreDropVerify  - [optional] Default is True.
;                  $iOverDrop            - [optional] Default is 0.
;                  $bPostDropVerify      - [optional] Default is False.
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......: MonkeyHunter (03-2017), mxkcz (2026)
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; =====================================================================================================================

#include-once
#include <Array.au3>
#include <MsgBoxConstants.au3>

Func DropTroopFromINI($sDropVectors, $iStartIndex, $iEndIndex, $aiIndexArray, $iMinQuantity, $iMaxQuantity, $sTroopName, $delayPointmin, $delayPointmax, $delayDropMin, $delayDropMax, $sleepafterMin, $sleepAfterMax, $bDebug = False, $bAllowPreDropVerify = True, $iOverDrop = 0, $bPostDropVerify = False)
	If IsArray($aiIndexArray) = 0 Then
		debugAttackCSV("drop using vectors " & $sDropVectors & " index " & $iStartIndex & "-" & $iEndIndex & " and using " & $iMinQuantity & "-" & $iMaxQuantity & " of " & $sTroopName)
	Else
		debugAttackCSV("drop using vectors " & $sDropVectors & " index " & _ArrayToString($aiIndexArray, ",") & " and using " & $iMinQuantity & "-" & $iMaxQuantity & " of " & $sTroopName)
	EndIf
	debugAttackCSV(" - delay for multiple troops in same point: " & $delayPointmin & "-" & $delayPointmax)
	debugAttackCSV(" - delay when  change deploy point : " & $delayDropMin & "-" & $delayDropMax)
	debugAttackCSV(" - delay after drop all troops : " & $sleepafterMin & "-" & $sleepAfterMax)

	;how many vectors need to manage...
	Local $temp = StringSplit($sDropVectors, "-")
	Local $numbersOfVectors
	If UBound($temp) > 0 Then
		$numbersOfVectors = $temp[0]
	Else
		$numbersOfVectors = 0
	EndIf

	;name of vectors...
	Local $vector1, $vector2, $vector3, $vector4
	If UBound($temp) > 0 Then
		If $temp[0] >= 1 Then $vector1 = "ATTACKVECTOR_" & $temp[1]
		If $temp[0] >= 2 Then $vector2 = "ATTACKVECTOR_" & $temp[2]
		If $temp[0] >= 3 Then $vector3 = "ATTACKVECTOR_" & $temp[3]
		If $temp[0] >= 4 Then $vector4 = "ATTACKVECTOR_" & $temp[4]
	Else
		$vector1 = $sDropVectors
	EndIf

	;Qty to drop
	If $iMinQuantity <> $iMaxQuantity Then
		Local $qty = Random($iMinQuantity, $iMaxQuantity, 1)
	Else
		Local $qty = $iMinQuantity
	EndIf
	If $iOverDrop > 0 Then $qty += $iOverDrop
	debugAttackCSV(">> qty to deploy: " & $qty)

	;number of troop to drop in one point...
	Local $qtyxpoint = Int($qty / ($iEndIndex - $iStartIndex + 1))
	Local $extraunit = Mod($qty, ($iEndIndex - $iStartIndex + 1))
	debugAttackCSV(">> qty x point: " & $qtyxpoint)
	debugAttackCSV(">> qty extra: " & $extraunit)

	; Get the integer index of the troop name specified
	Local $iTroopIndex = TroopIndexLookup($sTroopName, "DropTroopFromINI")
	If $iTroopIndex = -1 Then
		SetLog("CSV troop name '" & $sTroopName & "' is unrecognized.")
		Return
	EndIf
	Local $bHeroDrop = ($iTroopIndex = $eWarden ? True : False) ;set flag TRUE if Warden was dropped
	Local $bCountedTroop = ($iTroopIndex >= $eBarb And $iTroopIndex <= $eFurn) Or ($iTroopIndex >= $eLSpell And $iTroopIndex <= $eOgSpell)
	Local $bCountedNormalTroop = ($iTroopIndex >= $eBarb And $iTroopIndex <= $eFurn)
	Local $iRemainingCount = -1

	;_ArrayDisplay($g_avAttackTroops, "Index: " & $iTroopIndex)

	;search slot where is the troop...
	Local $troopPosition = -1
	Local $troopSlotConst = -1 ; $troopSlotConst = xx/22 (the unique slot number of troop) - Slot11+
	Local $fallbackSlotConst = -1
	For $i = 0 To UBound($g_avAttackTroops) - 1
		If $g_avAttackTroops[$i][0] = $iTroopIndex Then
			If $fallbackSlotConst = -1 Then $fallbackSlotConst = $i
			If $g_avAttackTroops[$i][1] > 0 Then
				debugAttackCSV("Found troop position " & $i & ". " & $sTroopName & " x" & $g_avAttackTroops[$i][1])
				$troopSlotConst = $i
				$troopPosition = $troopSlotConst
				ExitLoop
			EndIf
		EndIf
	Next
	If $troopSlotConst = -1 And $fallbackSlotConst <> -1 Then
		$troopSlotConst = $fallbackSlotConst
		$troopPosition = $troopSlotConst
		debugAttackCSV("Fallback troop position " & $troopSlotConst & ". " & $sTroopName & " x" & $g_avAttackTroops[$troopSlotConst][1])
	EndIf

	; Slot11+
	debugAttackCSV("Troop position / Total slots: " & $troopSlotConst & " / " & $g_iTotalAttackSlot)
	If $troopSlotConst >= 0 And $troopSlotConst < $g_iTotalAttackSlot - 10 Then ; can only be selected when in 1st page of troopbar
		If $g_bDraggedAttackBar Then DragAttackBar($g_iTotalAttackSlot, True) ; return drag
	ElseIf $troopSlotConst > 10 Then ; can only be selected when in 2nd page of troopbar
		If $g_bDraggedAttackBar = False Then DragAttackBar($g_iTotalAttackSlot, False) ; drag forward
		EndIf

	If $g_bDraggedAttackBar And $troopPosition > -1 Then
		$troopPosition = $troopSlotConst - ($g_iTotalAttackSlot - 10)
		debugAttackCSV("New troop position: " & $troopPosition)
	EndIf

	Local $bSelectTroop = True
	Local $bUseSpell = True
	Switch $iTroopIndex
		;Case $eLSpell
		;	If Not $g_abAttackUseLightSpell[$g_iMatchMode] Then $bUseSpell = False
		;Case $eHSpell
		;	If Not $g_abAttackUseHealSpell[$g_iMatchMode] Then $bUseSpell = False
		;Case $eRSpell
		;	If Not $g_abAttackUseRageSpell[$g_iMatchMode] Then $bUseSpell = False
		;Case $eJSpell
		;	If Not $g_abAttackUseJumpSpell[$g_iMatchMode] Then $bUseSpell = False
		;Case $eFSpell
		;	If Not $g_abAttackUseFreezeSpell[$g_iMatchMode] Then $bUseSpell = False
		;Case $eCSpell
		;	If Not $g_abAttackUseCloneSpell[$g_iMatchMode] Then $bUseSpell = False
		;Case $eISpell
		;	If Not $g_abAttackUseInvisibilitySpell[$g_iMatchMode] Then $bUseSpell = False
		;Case $ePSpell
		;	If Not $g_abAttackUsePoisonSpell[$g_iMatchMode] Then $bUseSpell = False
		;Case $eESpell
		;	If Not $g_abAttackUseEarthquakeSpell[$g_iMatchMode] Then $bUseSpell = False
		;Case $eHaSpell
		;	If Not $g_abAttackUseHasteSpell[$g_iMatchMode] Then $bUseSpell = False
		;Case $eSkSpell
		;	If Not $g_abAttackUseSkeletonSpell[$g_iMatchMode] Then $bUseSpell = False
		;Case $eBtSpell
		;	If Not $g_abAttackUseBatSpell[$g_iMatchMode] Then $bUseSpell = False
		Case $eKing, $eQueen, $eWarden, $eChampion, $eCastle, $eWallW, $eBattleB, $eStoneS, $eSiegeB, $eLogL, $eFlameF, $eBattleD, $eTroopL
			$bSelectTroop = False ; avoid double select
	EndSwitch

	If $troopPosition = -1 Or Not $bUseSpell Then

		If $bUseSpell Then
			SetLog("No " & GetTroopName($iTroopIndex) & " found in your attack troops list")
			debugAttackCSV("No " & GetTroopName($iTroopIndex) & " found in your attack troops list")
		Else
			SetDebugLog("Discard use " & GetTroopName($iTroopIndex), $COLOR_DEBUG)
		EndIf

	Else

		;Local $SuspendMode = SuspendAndroid()

		If $bCountedTroop Then
			$iRemainingCount = $g_avAttackTroops[$troopSlotConst][1]
			Local $bSlotSelected = ($g_iCSVLastTroopPositionDropTroopFromINI = $troopSlotConst)
			If $bAllowPreDropVerify And $g_bCSVPreDropVerify And $iRemainingCount <= $g_iCSVPreDropThreshold Then
				If Not $bSlotSelected Or $iRemainingCount <= 0 Then
					Local $iActualCount = ReadTroopQuantity($troopSlotConst, False, True)
					If $iActualCount <= 0 And $iRemainingCount > 0 Then
						debugAttackCSV("Troop count OCR returned 0, keeping cached: " & $iRemainingCount)
					ElseIf $iActualCount <> $iRemainingCount Then
						debugAttackCSV("Troop count mismatch - cached: " & $iRemainingCount & ", actual: " & $iActualCount)
						$g_avAttackTroops[$troopSlotConst][1] = $iActualCount
					EndIf
					$iRemainingCount = $g_avAttackTroops[$troopSlotConst][1]
				Else
					debugAttackCSV("Skip OCR verify: slot already selected")
				EndIf
			EndIf

			If $iRemainingCount <= 0 Then
				SetLog("No " & GetTroopName($iTroopIndex) & " remaining, skip drop")
				Return
			EndIf

			If $iOverDrop <= 0 And $iRemainingCount < $qty Then
				debugAttackCSV("Adjust qty to deploy: " & $qty & " -> " & $iRemainingCount)
				$qty = $iRemainingCount
			EndIf
		EndIf

		If $g_iCSVLastTroopPositionDropTroopFromINI <> $troopSlotConst Then
			ReleaseClicks()
			If $bSelectTroop Then
				SelectDropTroop($troopPosition) ; select the troop...
				If _Sleep(80) Then Return
				If Not IsSlotSelected($troopPosition, True) Then
					SelectDropTroop($troopPosition)
					If _Sleep(80) Then Return
				EndIf
				ReleaseClicks()
				KeepClicks()
			EndIf
			$g_iCSVLastTroopPositionDropTroopFromINI = $troopSlotConst
		EndIf
		DropTroopFromINI_ExecuteDrop($iTroopIndex, $sTroopName, $numbersOfVectors, $iStartIndex, $iEndIndex, $aiIndexArray, $qty, _
				$delayPointmin, $delayPointmax, $delayDropMin, $delayDropMax, $bDebug, $troopPosition, $troopSlotConst, _
				$vector1, $vector2, $vector3, $vector4)

		If $bPostDropVerify And $bCountedNormalTroop Then
			If _Sleep(150) Then Return
			If Not IsSlotSelected($troopPosition, True) Then
				SelectDropTroop($troopPosition)
				If _Sleep(80) Then Return
			EndIf
			Local $iAfterCount = ReadTroopQuantity($troopSlotConst, True, True)
			If $iAfterCount > 0 Then
				debugAttackCSV("Post-drop verify remaining: " & $iAfterCount & " " & $sTroopName)
				DropTroopFromINI_ExecuteDrop($iTroopIndex, $sTroopName, $numbersOfVectors, $iStartIndex, $iEndIndex, $aiIndexArray, $iAfterCount, _
						$delayPointmin, $delayPointmax, $delayDropMin, $delayDropMax, $bDebug, $troopPosition, $troopSlotConst, _
						$vector1, $vector2, $vector3, $vector4)
			EndIf
		EndIf

		ReleaseClicks()

		;sleep time after deploy all troops
		Local $iPostDeploySleep = 0
		If $sleepafterMin <> $sleepAfterMax Then
			$iPostDeploySleep = Random($sleepafterMin, $sleepAfterMax, 1)
		Else
			$iPostDeploySleep = Int($sleepafterMin)
		EndIf
		If $iPostDeploySleep > 0 And Not IsKeepClicksActive() Then
			debugAttackCSV("- delay after drop all troops: " & $iPostDeploySleep)
			If $iPostDeploySleep <= 1000 Then ; check SLEEPAFTER value is less than 1 second?
				If _Sleep($iPostDeploySleep) Then Return
				If $bHeroDrop = True Then ;Check hero but skip Warden if was dropped with sleepafter to short to allow icon update
					Local $bHold = $g_bCheckWardenPower ; store existing flag state, should be true?
					$g_bCheckWardenPower = False ;temp disable warden health check
					CheckHeroesHealth()
					$g_bCheckWardenPower = $bHold ; restore flag state
				Else
					CheckHeroesHealth()
				EndIf
			Else ; $sleepafter is More than 1 second, then improve pause/stop button response with max 1 second delays
				For $z = 1 To Int($iPostDeploySleep / 1000) ; Check hero health every second while while sleeping
					If _Sleep(980) Then Return ; sleep 1 second minus estimated herohealthcheck time when heroes not activiated
					CheckHeroesHealth() ; check hero health == does nothing if hero not dropped
				Next
				If _Sleep(Mod($iPostDeploySleep, 1000)) Then Return ; $sleepafter must be integer for MOD function return correct value!
				CheckHeroesHealth() ; check hero health == does nothing if hero not dropped
			EndIf
		EndIf
	EndIf

EndFunc   ;==>DropTroopFromINI

; #FUNCTION# ====================================================================================================================
; Name ..........: DropTroopFromSlot
; Description ...: Drops troops using a direct slot index (for unknown/misread slots).
; Syntax ........: DropTroopFromSlot($vectors, $iStartIndex, $iEndIndex, $aiIndexArray, $iMinQuantity, $iMaxQuantity, $iSlotIndex, $iClickX, $iClickY, $delayPointmin,
;                  $delayPointmax, $delayDropMin, $delayDropMax, $sleepafterMin, $sleepAfterMax[, $debug = False])
; Parameters ....: $vectors             -
;                  $iStartIndex         -
;                  $iEndIndex           -
;                  $aiIndexArray        -
;                  $iMinQuantity        -
;                  $iMaxQuantity        -
;                  $iSlotIndex          -
;                  $iClickX             -
;                  $iClickY             -
;                  $delayPointmin       -
;                  $delayPointmax       -
;                  $delayDropMin        -
;                  $delayDropMax        -
;                  $sleepafterMin       -
;                  $sleepAfterMax       -
;                  $bDebug              - [optional] Default is False.
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; =====================================================================================================================
Func DropTroopFromSlot($sDropVectors, $iStartIndex, $iEndIndex, $aiIndexArray, $iMinQuantity, $iMaxQuantity, $iSlotIndex, $iClickX, $iClickY, $delayPointmin, $delayPointmax, $delayDropMin, $delayDropMax, $sleepafterMin, $sleepAfterMax, $bDebug = False)
	;how many vectors need to manage...
	Local $temp = StringSplit($sDropVectors, "-")
	Local $numbersOfVectors
	If UBound($temp) > 0 Then
		$numbersOfVectors = $temp[0]
	Else
		$numbersOfVectors = 0
	EndIf

	;name of vectors...
	Local $vector1, $vector2, $vector3, $vector4
	If UBound($temp) > 0 Then
		If $temp[0] >= 1 Then $vector1 = "ATTACKVECTOR_" & $temp[1]
		If $temp[0] >= 2 Then $vector2 = "ATTACKVECTOR_" & $temp[2]
		If $temp[0] >= 3 Then $vector3 = "ATTACKVECTOR_" & $temp[3]
		If $temp[0] >= 4 Then $vector4 = "ATTACKVECTOR_" & $temp[4]
	Else
		$vector1 = $sDropVectors
	EndIf

	;Qty to drop
	If $iMinQuantity <> $iMaxQuantity Then
		Local $qty = Random($iMinQuantity, $iMaxQuantity, 1)
	Else
		Local $qty = $iMinQuantity
	EndIf
	debugAttackCSV(">> qty to deploy (unknown slot): " & $qty)

	;number of troop to drop in one point...
	Local $qtyxpoint = Int($qty / ($iEndIndex - $iStartIndex + 1))
	Local $extraunit = Mod($qty, ($iEndIndex - $iStartIndex + 1))

	; Slot11+
	debugAttackCSV("Unknown slot position / Total slots: " & $iSlotIndex & " / " & $g_iTotalAttackSlot)
	If $iSlotIndex >= 0 And $iSlotIndex < $g_iTotalAttackSlot - 10 Then
		If $g_bDraggedAttackBar Then DragAttackBar($g_iTotalAttackSlot, True)
	ElseIf $iSlotIndex > 10 Then
		If $g_bDraggedAttackBar = False Then DragAttackBar($g_iTotalAttackSlot, False)
	EndIf

	If $g_iCSVLastTroopPositionDropTroopFromINI <> $iSlotIndex Then
		ReleaseClicks()
		Local $aClickPos = GetSlotPosition($iSlotIndex)
		If $aClickPos[0] <= 0 Or $aClickPos[1] <= 0 Then
			Local $aFallbackPos[2] = [$iClickX, $iClickY]
			$aClickPos = $aFallbackPos
		EndIf
		ClickP($aClickPos, 1, 0, "#0111")
		ReleaseClicks()
		KeepClicks()
		$g_iCSVLastTroopPositionDropTroopFromINI = $iSlotIndex
	EndIf

	;drop
	For $i = $iStartIndex To $iEndIndex
		Local $delayDrop = 0
		Local $index = $i
		Local $indexMax = $iEndIndex
		If IsArray($aiIndexArray) = 1 Then
			$index = $aiIndexArray[$i]
			$indexMax = $aiIndexArray[$iEndIndex]
		EndIf
		If $index <> $indexMax Then
			If $delayDropMin <> $delayDropMax Then
				$delayDrop = Random($delayDropMin, $delayDropMax, 1)
			Else
				$delayDrop = $delayDropMin
			EndIf
		EndIf

		For $j = 1 To $numbersOfVectors
			Local $delayDropLast = 0
			If $j = $numbersOfVectors Then $delayDropLast = $delayDrop
			If $index <= UBound(Execute("$" & Eval("vector" & $j))) Then
				Local $pixel = Execute("$" & Eval("vector" & $j) & "[" & $index - 1 & "]")
				Local $qty2 = $qtyxpoint
				If $index < $iStartIndex + $extraunit Then $qty2 += 1

				If $delayPointmin <> $delayPointmax Then
					Local $delayPoint = Random($delayPointmin, $delayPointmax, 1)
				Else
					Local $delayPoint = $delayPointmin
				EndIf

				If $bDebug Then
					SetLog("AttackClick( " & $pixel[0] & ", " & $pixel[1] & " , " & $qty2 & ", " & $delayPoint & ",#0668)")
				Else
					AttackClick($pixel[0], $pixel[1], $qty2, $delayPoint, $delayDropLast, "#0668")
				EndIf
			EndIf
		Next
	Next

	ReleaseClicks()
	If $sleepafterMin <> $sleepAfterMax Then
		Local $iPostDeploySleep = Random($sleepafterMin, $sleepAfterMax, 1)
	Else
		Local $iPostDeploySleep = $sleepafterMin
	EndIf
	If $iPostDeploySleep > 0 Then
		If _Sleep($iPostDeploySleep) Then Return
	EndIf
EndFunc   ;==>DropTroopFromSlot

; #FUNCTION# ====================================================================================================================
; Name ..........: DropTroopFromINI_ExecuteDrop
; Description ...: Executes the attack bar drop loop for a specific quantity.
; Syntax ........: DropTroopFromINI_ExecuteDrop($iTroopIndex, $sTroopName, $iVectorCount, $iStartIndex, $iEndIndex, $aiIndexArray, $iDropQty, $delayPointmin,
;                  $delayPointmax, $delayDropMin, $delayDropMax, $bDebug, $troopPosition, $troopSlotConst, $vector1, $vector2, $vector3, $vector4)
; Parameters ....: $iTroopIndex, $sTroopName, $iVectorCount, $iStartIndex, $iEndIndex, $aiIndexArray, $iDropQty, $delayPointmin, $delayPointmax,
;                  $delayDropMin, $delayDropMax, $bDebug, $troopPosition, $troopSlotConst, $vector1, $vector2, $vector3, $vector4
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; =====================================================================================================================
Func DropTroopFromINI_ExecuteDrop($iTroopIndex, $sTroopName, $iVectorCount, $iStartIndex, $iEndIndex, $aiIndexArray, $iDropQty, $delayPointmin, $delayPointmax, $delayDropMin, $delayDropMax, $bDebug, $troopPosition, $troopSlotConst, $vector1, $vector2, $vector3, $vector4)
	If $iDropQty <= 0 Then Return

	Local $qtyxpoint = Int($iDropQty / ($iEndIndex - $iStartIndex + 1))
	Local $extraunit = Mod($iDropQty, ($iEndIndex - $iStartIndex + 1))

	For $i = $iStartIndex To $iEndIndex
		Local $delayDrop = 0
		Local $index = $i
		Local $indexMax = $iEndIndex
		If IsArray($aiIndexArray) = 1 Then
			; adjust $index and $indexMax based on array
			$index = $aiIndexArray[$i]
			$indexMax = $aiIndexArray[$iEndIndex]
		EndIf
		If $index <> $indexMax Then
			;delay time between 2 drops in different point
			If $delayDropMin <> $delayDropMax Then
				$delayDrop = Random($delayDropMin, $delayDropMax, 1)
			Else
				$delayDrop = $delayDropMin
			EndIf
			debugAttackCSV("- delay change drop point: " & $delayDrop)
		EndIf

		For $j = 1 To $iVectorCount
			;delay time between 2 drops in different point
			Local $delayDropLast = 0
			If $j = $iVectorCount Then $delayDropLast = $delayDrop
			Local $sVectorName = Eval("vector" & $j)
			Local $aVector = Execute("$" & $sVectorName)
			If Not IsArray($aVector) Then
				SetDebugLog("DropTroopFromINI: Vector " & $sVectorName & " is not initialized", $COLOR_ERROR)
				ContinueLoop
			EndIf

			Local $iVectorUBound = UBound($aVector)
			If $index >= 1 And $index <= $iVectorUBound Then
				Local $pixel = $aVector[$index - 1]
				Local $qty2 = $qtyxpoint
				If $index < $iStartIndex + $extraunit Then $qty2 += 1

				;delay time between 2 drops in same point
				If $delayPointmin <> $delayPointmax Then
					Local $delayPoint = Random($delayPointmin, $delayPointmax, 1)
				Else
					Local $delayPoint = $delayPointmin
				EndIf

				Switch $iTroopIndex
					Case $eBarb To $eFurn ; drop normal/super troops
						If $bDebug Then
							SetLog("AttackClick( " & $pixel[0] & ", " & $pixel[1] & " , " & $qty2 & ", " & $delayPoint & ",#0668)")
						Else
							AttackClick($pixel[0], $pixel[1], $qty2, $delayPoint, $delayDropLast, "#0668")
							If $g_bCSVTrackDropCounts Then
								If UBound($g_avAttackTroops) > $troopSlotConst And $g_avAttackTroops[$troopSlotConst][1] > 0 And $qty2 > 0 Then
									$g_avAttackTroops[$troopSlotConst][1] -= $qty2
									If $g_avAttackTroops[$troopSlotConst][1] < 0 Then $g_avAttackTroops[$troopSlotConst][1] = 0
									debugAttackCSV("Adjust quantity of troop use: " & $g_avAttackTroops[$troopSlotConst][0] & " x" & $g_avAttackTroops[$troopSlotConst][1])
								EndIf
							EndIf
						EndIf
					Case $eKing
						If $bDebug Then
							SetLog("dropHeroes(" & $pixel[0] & ", " & $pixel[1] & ", " & $troopPosition & ", -1, -1, -1) ")
						Else
							dropHeroes($pixel[0], $pixel[1], $troopPosition, -1, -1, -1) ; was $g_iKingSlot, Slot11+
						EndIf
					Case $eQueen
						If $bDebug Then
							SetLog("dropHeroes(" & $pixel[0] & ", " & $pixel[1] & ",-1," & $troopPosition & ", -1, -1) ")
						Else
							dropHeroes($pixel[0], $pixel[1], -1, $troopPosition, -1, -1) ; was $g_iQueenSlot, Slot11+
						EndIf
					Case $eWarden
						If $bDebug Then
							SetLog("dropHeroes(" & $pixel[0] & ", " & $pixel[1] & ", -1, -1," & $troopPosition & ", -1) ")
						Else
							dropHeroes($pixel[0], $pixel[1], -1, -1, $troopPosition, -1) ; was $g_iWardenSlot, Slot11+
						EndIf
					Case $eChampion
						If $bDebug Then
							SetLog("dropHeroes(" & $pixel[0] & ", " & $pixel[1] & ",-1, -1, -1," & $troopPosition & ") ")
						Else
							dropHeroes($pixel[0], $pixel[1], -1, -1, -1, $troopPosition) ; was $g_iChampionSlot, Slot11+
						EndIf
					Case $ePrince
						If $bDebug Then
							SetLog("dropHeroes(" & $pixel[0] & ", " & $pixel[1] & ", -1, -1, -1, -1, " & $troopPosition & ") ")
						Else
							dropHeroes($pixel[0], $pixel[1], -1, -1, -1, -1, $troopPosition) ; was $g_iPrinceSlot, Slot11+
						EndIf
					Case $eCastle, $eWallW, $eBattleB, $eStoneS, $eSiegeB, $eLogL, $eFlameF
						If $bDebug Then
							SetLog("dropCC(" & $pixel[0] & ", " & $pixel[1] & ", " & $troopPosition & ")")
						Else
							dropCC($pixel[0], $pixel[1], $troopPosition)
						EndIf
					Case $eLSpell To $eOgSpell
						If $bDebug Then
							SetLog("Drop Spell AttackClick( " & $pixel[0] & ", " & $pixel[1] & " , " & $qty2 & ", " & $delayPoint & ",#0668)")
						Else
							AttackClick($pixel[0], $pixel[1], $qty2, $delayPoint, $delayDropLast, "#0668")
						EndIf
						; assume spells get always dropped: adjust count so CC spells can be used without recalc
						If UBound($g_avAttackTroops) > $troopSlotConst And $g_avAttackTroops[$troopSlotConst][1] > 0 And $qty2 > 0 Then ; Slot11 - Demen_S11_#9003
							$g_avAttackTroops[$troopSlotConst][1] -= $qty2
							debugAttackCSV("Adjust quantity of spell use: " & $g_avAttackTroops[$troopSlotConst][0] & " x" & $g_avAttackTroops[$troopSlotConst][1])
						EndIf
					Case Else
						SetLog("Error parsing line")
				EndSwitch
				debugAttackCSV($sTroopName & " qty " & $qty2 & " in (" & $pixel[0] & "," & $pixel[1] & ") delay " & $delayPoint)
			Else
				SetDebugLog("DropTroopFromINI: Index " & $index & " out of bounds for vector " & $sVectorName & " (max=" & $iVectorUBound & ")", $COLOR_ERROR)
				ContinueLoop
			EndIf
			;;;;if $j <> $iVectorCount Then _sleep(5) ;little delay by passing from a vector to another vector
		Next
	Next
EndFunc   ;==>DropTroopFromINI_ExecuteDrop
