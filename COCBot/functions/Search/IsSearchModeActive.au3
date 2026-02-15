; #FUNCTION# ====================================================================================================================
; Name ..........: IsSearchModeActive
; Description ...:
; Syntax ........: IsSearchModeActive($g_iMatchMode)
; Parameters ....:
; Return values .: None
; Author ........: Sardo (2016-01)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func IsSearchModeActive($g_iMatchMode, $bDontCheckHeroes = False, $bNoLog = False)
	Local $currentSearch = $g_iSearchCount + 1
	Local $currentArmyCamps = 0
	If $g_iTotalCampSpace > 0 Then $currentArmyCamps = Int($g_CurrentCampUtilization / $g_iTotalCampSpace * 100)
	Local $bMatchModeEnabled = False
	Local $bForceBattleActivation = False

	Local $checkSearches = Int($currentSearch) >= Int($g_aiSearchSearchesMin[$g_iMatchMode]) And Int($currentSearch) <= Int($g_aiSearchSearchesMax[$g_iMatchMode]) And $g_abSearchSearchesEnable[$g_iMatchMode]
	Local $checkArmyCamps = Int($currentArmyCamps) >= Int($g_aiSearchCampsPct[$g_iMatchMode]) And $g_abSearchCampsEnable[$g_iMatchMode]
	; true if we have correct needed heroes or we do not need to check our heroes... this variable decides if your heroes are ready for this particular search mode
	Local $bCheckHeroes = True

	Local $g_bCheckSpells = True
	Local $bCheckClanCastle = True

	If $g_abSearchCastleWaitEnable[$g_iMatchMode] Then
		$bCheckClanCastle = $g_bFullArmyCC
	EndIf

	Switch $g_iMatchMode
		Case $Battle
			$bMatchModeEnabled = $g_abAttackTypeEnable[$Battle]
			$bForceBattleActivation = True
		Case $RankedBattle
			$bMatchModeEnabled = $g_abAttackTypeEnable[$RankedBattle]
		Case Else
			$bMatchModeEnabled = False
	EndSwitch


	Local $bcheckSiege = False
	If $g_abSearchSiegeWaitEnable[$g_iMatchMode] Then
		If (($g_aiAttackUseSiege[$g_iMatchMode] = 1 And ($g_aiCurrentSiegeMachines[$eSiegeWallWrecker] > 0 Or $g_aiCurrentCCSiegeMachines[$eSiegeWallWrecker] > 0)) Or _
			($g_aiAttackUseSiege[$g_iMatchMode] = 2 And ($g_aiCurrentSiegeMachines[$eSiegeBattleBlimp] > 0 Or $g_aiCurrentCCSiegeMachines[$eSiegeBattleBlimp] > 0)) Or _
			($g_aiAttackUseSiege[$g_iMatchMode] = 3 And ($g_aiCurrentSiegeMachines[$eSiegeStoneSlammer] > 0 Or $g_aiCurrentCCSiegeMachines[$eSiegeStoneSlammer] > 0)) Or _
			($g_aiAttackUseSiege[$g_iMatchMode] = 4 And ($g_aiCurrentSiegeMachines[$eSiegeBarracks] > 0 Or $g_aiCurrentCCSiegeMachines[$eSiegeBarracks] > 0)) Or _
			($g_aiAttackUseSiege[$g_iMatchMode] = 5 And ($g_aiCurrentSiegeMachines[$eSiegeLogLauncher] > 0 Or $g_aiCurrentCCSiegeMachines[$eSiegeLogLauncher] > 0)) Or _
			$g_aiAttackUseSiege[$g_iMatchMode] = 0) Then
			$bcheckSiege = True
		EndIf
	Else
		$bcheckSiege = True
	EndIf

	If Not $bMatchModeEnabled Then Return False ; exit if no DB, LB, TS mode enabled
	If $bForceBattleActivation Then
		$checkSearches = True
		$checkArmyCamps = True
	EndIf

	If $bCheckHeroes And $g_bCheckSpells And $bcheckSiege And $bCheckClanCastle Then ;If $bCheckHeroes Then
		If ($checkSearches Or $g_abSearchSearchesEnable[$g_iMatchMode] = False) And ($checkArmyCamps Or $g_abSearchCampsEnable[$g_iMatchMode] = False) Then
			If $g_bDebugSetlog And Not $bNoLog Then SetLog($g_asModeText[$g_iMatchMode] & " active! ($checkSearches=" & $checkSearches & _
																						  ",$checkArmyCamps=" & $checkArmyCamps & _
																						  ",$bCheckHeroes=" & $bCheckHeroes & _
																						  ",$g_bCheckSpells=" & $g_bCheckSpells & _
																						  ",$bcheckSiege=" & $bcheckSiege & _
																						  ",$bCheckClanCastle=" & $bCheckClanCastle & ")", $COLOR_INFO)
			Return True
		Else
			If $g_bDebugSetlog And Not $bNoLog Then
				SetLog($g_asModeText[$g_iMatchMode] & " not active!", $COLOR_INFO)
				Local $txtsearches = "Fail"
				If $checkSearches Then $txtsearches = "Success"
				Local $txtArmyCamp = "Fail"
				If $checkArmyCamps Then $txtArmyCamp = "Success"
				Local $txtHeroes = "Fail"
				If $bCheckHeroes Then $txtHeroes = "Success"
				If $g_abSearchSearchesEnable[$g_iMatchMode] Then SetLog("searches range: " & $g_aiSearchSearchesMin[$g_iMatchMode] & "-" & $g_aiSearchSearchesMax[$g_iMatchMode] & "  actual value: " & $currentSearch & " - " & $txtsearches, $COLOR_INFO)
				If $g_abSearchCampsEnable[$g_iMatchMode] Then SetLog("Army camps % range >=: " & $g_aiSearchCampsPct[$g_iMatchMode] & " actual value: " & $currentArmyCamps & " | " & $txtArmyCamp, $COLOR_INFO)
				Local $txtSpells = "Fail"
				If $g_bCheckSpells Then $txtSpells = "Success"
				Local $txtSieges = $bcheckSiege = True ? "Success" : "Fail"
				If $g_abSearchSiegeWaitEnable[$g_iMatchMode] Then SetLog("Siege status: " & $bcheckSiege, $COLOR_INFO)
				Local $txtClanCastle = $bCheckClanCastle = True ? "Success" : "Fail"
				If $g_abSearchCastleWaitEnable[$g_iMatchMode] Then SetLog("Clan Castle status: " & $g_bFullArmyCC & " | " & $txtClanCastle, $COLOR_INFO)
			EndIf
			Return False
		EndIf
	ElseIf Not $bCheckHeroes Then
		If $g_bDebugSetlog And Not $bNoLog Then SetLog("Heroes not ready", $COLOR_DEBUG)
		Return False
	ElseIf Not $bcheckSiege Then
		If $g_bDebugSetlog And Not $bNoLog Then SetLog("Siege not ready", $COLOR_DEBUG)
		Return False
	ElseIf Not $bCheckClanCastle Then
		If $g_bDebugSetlog And Not $bNoLog Then SetLog("Clan Castle not ready", $COLOR_DEBUG)
		Return False
	Else
		If $g_bDebugSetlog And Not $bNoLog Then SetLog("Spells not ready", $COLOR_DEBUG)
		Return False
	EndIf
EndFunc   ;==>IsSearchModeActive

Func IsSearchModeActiveMini(Const $iMatchMode)
	Return $g_abAttackTypeEnable[$iMatchMode]
EndFunc   ;==>IsSearchModeActiveMini

; #FUNCTION# ====================================================================================================================
; Name ..........: IsWaitforSpellsActive
; Description ...: Checks if Wait for Spells is enabled for all enabled attack modes
; Syntax ........: IsWaitforSpellsActive()
; Parameters ....: none
; Return values .: Returns True if Wait for spells is enabled for any enabled attack mode, false if not
; Author ........: MonkeyHunter (06-2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func IsWaitforSpellsActive()
	If $g_bDebugSetlogTrain Or $g_bDebugSetlog Then SetLog("IsWaitforSpellsActive = False", $COLOR_DEBUG)
	Return False
EndFunc   ;==>IsWaitforSpellsActive

; #FUNCTION# ====================================================================================================================
; Name ..........: IsWaitforHeroesActive
; Description ...: Checks if Wait for Heroes is enabled for all enabled attack modes
; Syntax ........: IsWaitforHeroesActive()
; Parameters ....: none
; Return values .: Returns True if Wait for any Hero is enabled for any enabled attack mode, false if not
; Author ........: MonkeyHunter (06-2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func IsWaitforHeroesActive()
	If $g_bDebugSetlogTrain Or $g_bDebugSetlog Then SetLog("IsWaitforHeroesActive = False", $COLOR_DEBUG)
	Return False
EndFunc   ;==>IsWaitforHeroesActive

; #FUNCTION# ====================================================================================================================
; Name ..........: IsWaitforSiegeMachine
; Description ...: Checks if Wait for Siege Machine is enabled for all enabled attack modes
; Syntax ........: IsWaitforSiegeMachine()
; Parameters ....: none
; Return values .: Returns True if Wait for any Siege is enabled for any enabled attack mode, false if not
; Author ........: ProMac (07-2018)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func IsWaitforSiegeMachine()
	For $i = $Battle To $g_iModeCount - 1
		If $g_abAttackTypeEnable[$i] And $g_abSearchSiegeWaitEnable[$i] Then
			If $g_bDebugSetlogTrain Or $g_bDebugSetlog Then SetLog("IsWaitforSiegeMachine = True", $COLOR_DEBUG)
			Return True
		EndIf
	Next
	If $g_bDebugSetlogTrain Or $g_bDebugSetlog Then SetLog("IsWaitforSiegeMachine = False", $COLOR_DEBUG)
	Return False
EndFunc   ;==>IsWaitforSiegeMachine
