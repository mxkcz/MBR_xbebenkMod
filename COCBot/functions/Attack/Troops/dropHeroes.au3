; #FUNCTION# ====================================================================================================================
; Name ..........: dropHeroes
; Description ...: Will drop heroes in a specific coordinates, only if slot is not -1,Only drops when option is clicked.
; Syntax ........: dropHeroes($x, $y, $iKingSlot = -1, $iQueenSlot = -1, $iWardenSlot = -1, $iChampionSlot = -1)
; Parameters ....: $x                   - an unknown value.
;                  $y                   - an unknown value.
;                  $KingSlot            - [optional] an unknown value. Default is -1.
;                  $QueenSlot           - [optional] an unknown value. Default is -1.
;                  $WardenSlot          - [optional] an unknown value. Default is -1.
; Return values .: None
; Author ........:
; Modified ......: mxkcz (2026)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func dropHeroes($iX, $iY, $iKingSlotNumber = -1, $iQueenSlotNumber = -1, $iWardenSlotNumber = -1, $iChampionSlotNumber = -1, $iPrinceSlotNumber = -1) ;Drops for All Heroes
	SetDebugLog("dropHeroes $iKingSlotNumber " & $iKingSlotNumber & " $iQueenSlotNumber " & $iQueenSlotNumber & " $iWardenSlotNumber " & $iWardenSlotNumber & " $iChampionSlotNumber " & $iChampionSlotNumber & " $iPrinceSlotNumber " & $iPrinceSlotNumber & " matchmode " & $g_iMatchMode, $COLOR_DEBUG)
	If _Sleep($DELAYDROPHEROES1) Then Return
	$iKingSlotNumber = ResolveHeroDropSlot($iKingSlotNumber, $eKing, "King")
	$iQueenSlotNumber = ResolveHeroDropSlot($iQueenSlotNumber, $eQueen, "Queen")
	$iWardenSlotNumber = ResolveHeroDropSlot($iWardenSlotNumber, $eWarden, "Warden")
	$iChampionSlotNumber = ResolveHeroDropSlot($iChampionSlotNumber, $eChampion, "Champion")
	$iPrinceSlotNumber = ResolveHeroDropSlot($iPrinceSlotNumber, $ePrince, "Minion Prince")
	Local $bDropKing = False
	Local $bDropQueen = False
	Local $bDropWarden = False
	Local $bDropChampion = False
	Local $bDropPrince = False
	Local $bCSVManualKing = ($g_bCSVHeroAbilityOverrideActive And $g_abCSVHeroManualControl[$eHeroBarbarianKing])
	Local $bCSVManualQueen = ($g_bCSVHeroAbilityOverrideActive And $g_abCSVHeroManualControl[$eHeroArcherQueen])
	Local $bCSVManualWarden = ($g_bCSVHeroAbilityOverrideActive And $g_abCSVHeroManualControl[$eHeroGrandWarden])
	Local $bCSVManualChampion = ($g_bCSVHeroAbilityOverrideActive And $g_abCSVHeroManualControl[$eHeroRoyalChampion])
	Local $bCSVManualPrince = ($g_bCSVHeroAbilityOverrideActive And $g_abCSVHeroManualControl[$eHeroMinionPrince])

	;use hero if  slot (detected ) and ( ($g_iMatchMode <>DB and <>LB  ) or (check user GUI settings) )
	If $iKingSlotNumber <> -1 Then $bDropKing = True ;And (($g_iMatchMode <> $DB And $g_iMatchMode <> $LB) Or BitAND($g_aiAttackUseHeroes[$g_iMatchMode], $eHeroKing) = $eHeroKing) Then $bDropKing = True
	If $iQueenSlotNumber <> -1 Then $bDropQueen = True ;And (($g_iMatchMode <> $DB And $g_iMatchMode <> $LB) Or BitAND($g_aiAttackUseHeroes[$g_iMatchMode], $eHeroQueen) = $eHeroQueen) Then $bDropQueen = True
	If $iWardenSlotNumber <> -1 Then $bDropWarden = True ;And (($g_iMatchMode <> $DB And $g_iMatchMode <> $LB) Or BitAND($g_aiAttackUseHeroes[$g_iMatchMode], $eHeroWarden) = $eHeroWarden) Then $bDropWarden = True
	If $iChampionSlotNumber <> -1 Then $bDropChampion = True ;And (($g_iMatchMode <> $DB And $g_iMatchMode <> $LB) Or BitAND($g_aiAttackUseHeroes[$g_iMatchMode], $eHeroChampion) = $eHeroChampion) Then $bDropChampion = True
	If $iPrinceSlotNumber <> -1 Then $bDropPrince = True ;And (($g_iMatchMode <> $DB And $g_iMatchMode <> $LB) Or BitAND($g_aiAttackUseHeroes[$g_iMatchMode], $eHeroPrince = $eHeroPrince Then $bDropPrince = True
	

	SetDebugLog("drop KING = " & $bDropKing, $COLOR_DEBUG)
	SetDebugLog("drop QUEEN = " & $bDropQueen, $COLOR_DEBUG)
	SetDebugLog("drop WARDEN = " & $bDropWarden, $COLOR_DEBUG)
	SetDebugLog("drop CHAMPION = " & $bDropChampion, $COLOR_DEBUG)
	SetDebugLog("drop MINION PRINCE = " & $bDropPrince, $COLOR_DEBUG)

		If $bDropKing Then
			SetLog("Dropping King at " & $iX & ", " & $iY, $COLOR_INFO)
			SelectDropTroop($iKingSlotNumber, 1, Default, False)
			If _Sleep($DELAYDROPHEROES2) Then Return
			AttackClick($iX, $iY, 1, 0, 0, "#0093")
			If Not $g_bDropKing Then ; check global flag, only begin hero health check on 1st hero drop as flag is reset to false after activation
				$g_bCheckKingPower = True
			Else
				SetDebugLog("King dropped 2nd time, Check Power flag not changed") ; do nothing as hero already dropped
				If $bCSVManualKing Then
					$g_bCheckKingPower = False
					$g_abCSVHeroAbilityTriggered[$eHeroBarbarianKing] = True
					$g_aHeroesTimerActivation[$eHeroBarbarianKing] = 0
					SetDebugLog("CSV manual hero trigger: King ability marked as activated", $COLOR_INFO)
				EndIf
			EndIf
			$g_bDropKing = True ; Set global flag hero dropped
			If Not $g_abCSVHeroAbilityTriggered[$eHeroBarbarianKing] Then $g_aHeroesTimerActivation[$eHeroBarbarianKing] = __TimerInit() ; initialize fixed activation timer
			If _Sleep($DELAYDROPHEROES1) Then Return
		EndIf

	If _Sleep($DELAYDROPHEROES1) Then Return

		If $bDropQueen Then
			SetLog("Dropping Queen at " & $iX & ", " & $iY, $COLOR_INFO)
			SelectDropTroop($iQueenSlotNumber, 1, Default, False)
			If _Sleep($DELAYDROPHEROES2) Then Return
			AttackClick($iX, $iY, 1, 0, 0, "#0095")
			If Not $g_bDropQueen Then ; check global flag, only begin hero health check on 1st hero drop as flag is reset to false after activation
				$g_bCheckQueenPower = True
			Else
				SetDebugLog("Queen dropped 2nd time, Check Power flag not changed") ; do nothing as hero already dropped
				If $bCSVManualQueen Then
					$g_bCheckQueenPower = False
					$g_abCSVHeroAbilityTriggered[$eHeroArcherQueen] = True
					$g_aHeroesTimerActivation[$eHeroArcherQueen] = 0
					SetDebugLog("CSV manual hero trigger: Queen ability marked as activated", $COLOR_INFO)
				EndIf
			EndIf
			$g_bDropQueen = True ; Set global flag hero dropped
			If Not $g_abCSVHeroAbilityTriggered[$eHeroArcherQueen] Then $g_aHeroesTimerActivation[$eHeroArcherQueen] = __TimerInit() ; initialize fixed activation timer
			If _Sleep($DELAYDROPHEROES1) Then Return
		EndIf

	If _Sleep($DELAYDROPHEROES1) Then Return

		If $bDropWarden Then
			SetLog("Dropping Grand Warden at " & $iX & ", " & $iY, $COLOR_INFO)
			SelectDropTroop($iWardenSlotNumber, 1, Default, False)
			If _Sleep($DELAYDROPHEROES2) Then Return
			AttackClick($iX, $iY, 1, 0, 0, "#x999")
			If Not $g_bDropWarden Then ; check global flag, only begin hero health check on 1st hero drop as flag is reset to false after activation
				$g_bCheckWardenPower = True
			Else
				SetDebugLog("Warden dropped 2nd time, Check Power flag not changed") ; do nothing as hero already dropped
				If $bCSVManualWarden Then
					$g_bCheckWardenPower = False
					$g_abCSVHeroAbilityTriggered[$eHeroGrandWarden] = True
					$g_aHeroesTimerActivation[$eHeroGrandWarden] = 0
					SetDebugLog("CSV manual hero trigger: Warden ability marked as activated", $COLOR_INFO)
				EndIf
			EndIf
			$g_bDropWarden = True ; Set global flag hero dropped
			If Not $g_abCSVHeroAbilityTriggered[$eHeroGrandWarden] Then $g_aHeroesTimerActivation[$eHeroGrandWarden] = __TimerInit() ; initialize fixed activation timer
			If _Sleep($DELAYDROPHEROES1) Then Return
		EndIf

	If _Sleep($DELAYDROPHEROES1) Then Return

		If $bDropChampion Then
			SetLog("Dropping Royal Champion at " & $iX & ", " & $iY, $COLOR_INFO)
			SelectDropTroop($iChampionSlotNumber, 1, Default, False)
			If _Sleep($DELAYDROPHEROES2) Then Return
			AttackClick($iX, $iY, 1, 0, 0, "#x999")
			If Not $g_bDropChampion Then ; check global flag, only begin hero health check on 1st hero drop as flag is reset to false after activation
				$g_bCheckChampionPower = True
			Else
				SetDebugLog("Royal Champion dropped 2nd time, Check Power flag not changed") ; do nothing as hero already dropped
				If $bCSVManualChampion Then
					$g_bCheckChampionPower = False
					$g_abCSVHeroAbilityTriggered[$eHeroRoyalChampion] = True
					$g_aHeroesTimerActivation[$eHeroRoyalChampion] = 0
					SetDebugLog("CSV manual hero trigger: Champion ability marked as activated", $COLOR_INFO)
				EndIf
			EndIf
			$g_bDropChampion = True ; Set global flag hero dropped
			If Not $g_abCSVHeroAbilityTriggered[$eHeroRoyalChampion] Then $g_aHeroesTimerActivation[$eHeroRoyalChampion] = __TimerInit() ; initialize fixed activation timer
			If _Sleep($DELAYDROPHEROES1) Then Return
		EndIf
	
		If $bDropPrince Then
			SetLog("Dropping Minion Prince at " & $iX & ", " & $iY, $COLOR_INFO)
			SelectDropTroop($iPrinceSlotNumber, 1, Default, False)
			If _Sleep($DELAYDROPHEROES2) Then Return
			AttackClick($iX, $iY, 1, 0, 0, "#x999")
			If Not $g_bDropPrince Then ; check global flag, only begin hero health check on 1st hero drop as flag is reset to false after activation
				$g_bCheckPrincePower = True
			Else
				SetDebugLog("Minion Prince dropped 2nd time, Check Power flag not changed") ; do nothing as hero already dropped
				If $bCSVManualPrince Then
					$g_bCheckPrincePower = False
					$g_abCSVHeroAbilityTriggered[$eHeroMinionPrince] = True
					$g_aHeroesTimerActivation[$eHeroMinionPrince] = 0
					SetDebugLog("CSV manual hero trigger: Prince ability marked as activated", $COLOR_INFO)
				EndIf
			EndIf
			$g_bDropPrince = True ; Set global flag hero dropped
			If Not $g_abCSVHeroAbilityTriggered[$eHeroMinionPrince] Then $g_aHeroesTimerActivation[$eHeroMinionPrince] = __TimerInit() ; initialize fixed activation timer
			If _Sleep($DELAYDROPHEROES1) Then Return
		EndIf

EndFunc   ;==>dropHeroes

; #FUNCTION# ====================================================================================================================
; Name ..........: ResolveHeroDropSlot
; Description ...: Validates hero slot and falls back to scanned attack bar slot when needed.
; Syntax ........: ResolveHeroDropSlot($iRequestedSlot, $iHeroIndex, $sHeroName)
; Parameters ....: $iRequestedSlot, $iHeroIndex, $sHeroName
; Return values .: Slot index or -1 when no slot is available.
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; =====================================================================================================================
Func ResolveHeroDropSlot($iRequestedSlot, $iHeroIndex, $sHeroName)
	If $iRequestedSlot < 0 Then Return -1
	If UBound($g_avAttackTroops, 0) <> 2 Or UBound($g_avAttackTroops, 1) = 0 Then Return $iRequestedSlot
	Local $bRequestedInRange = ($iRequestedSlot >= 0 And $iRequestedSlot < UBound($g_avAttackTroops, 1))

	If $bRequestedInRange Then
		If Number($g_avAttackTroops[$iRequestedSlot][0]) = $iHeroIndex Then Return $iRequestedSlot
	EndIf

	For $i = 0 To UBound($g_avAttackTroops, 1) - 1
		If Number($g_avAttackTroops[$i][0]) = $iHeroIndex Then
			SetDebugLog("dropHeroes(): " & $sHeroName & " slot remapped " & $iRequestedSlot & " -> " & $i, $COLOR_WARNING)
			Return $i
		EndIf
	Next

	If Not $bRequestedInRange Then
		SetDebugLog("dropHeroes(): " & $sHeroName & " requested slot " & $iRequestedSlot & " is out of range", $COLOR_WARNING)
		Return -1
	EndIf
	SetDebugLog("dropHeroes(): " & $sHeroName & " slot " & $iRequestedSlot & " not found in current attack bar, using requested slot", $COLOR_WARNING)
	Return $iRequestedSlot
EndFunc   ;==>ResolveHeroDropSlot



