; #FUNCTION# ====================================================================================================================
; Name ..........: PrepareSearch
; Description ...: Goes into searching for a match, breaks shield if it has to
; Syntax ........: PrepareSearch()
; Parameters ....:
; Return values .: None
; Author ........: Code Monkey #4
; Modified ......: KnowJack (Aug 2015), MonkeyHunter(2015-12), xbebenk(03-2024), mxkcz(02-2026)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
; #FUNCTION# ====================================================================================================================
; Name ..........: PrepareSearch
; Description ...: Opens multiplayer search, attempts ranked battle join flow, and starts match search.
; Syntax ........: PrepareSearch([$bTest = False])
; Parameters ....: $bTest - Optional test mode flag.
; Return values .: None
; Author ........: mxkcz
; Modified ......: mxkcz (2026-02)
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......: RankedBattle_TryJoin(), PrepareSearchCheckArmy()
; Link ..........:
; Example .......:
; =====================================================================================================================
Func PrepareSearch($bTest = False) ;Click attack button and find match button, will break shield

	SetLog("Going to Attack", $COLOR_INFO)
	$g_bRestart = False ;reset
	If Not $g_bRunState Then Return

	ChkAttackCSVConfig()
	
	checkChatTabPixel()
	If ClickB("AttackButton") Then
		If $g_bDebugSetLog Then SetLog("Opening Multiplayer Tab!", $COLOR_ACTION)
		If _Sleep(1000) Then Return
	Else
		SetLog("AttackButton Not Found!", $COLOR_DEBUG2)
		$g_bRestart = True
		Return
	EndIf	
	
	For $i = 1 To 5
		If IsMultiplayerTabOpen() Then 
			SetLog("Multiplayer Tab is Opened", $COLOR_DEBUG)
			If QuickMIS("BC1", $g_sImgRevengeTutor, 370, 85, 460, 160) Then ;check for arrow on ranked battle layout and Reinforcement
				If Not CheckRevengeTutor() Then ContinueLoop
			EndIf
			ExitLoop
		Else
			SetLog("Couldn't Multiplayer Window after click attack button!", $COLOR_DEBUG2)
			If _Sleep(5000) Then Return
			If CheckRevengeTutor() Then ExitLoop
			$g_bRestart = True
			Return
		EndIf
		If _Sleep(1000) Then Return
	Next

	Local $bRankedBattle = False
	$g_bLeagueAttack = False
	If IsSearchModeActive($RankedBattle) Then
		$bRankedBattle = RankedBattle_TryJoin($bTest)
	EndIf

	Local $bAttackButtonFound = False
	If Not $bRankedBattle Then
		$bAttackButtonFound = _ColorCheck(_GetPixelColor(255, 488, True), Hex(0xF1A522, 6), 10, Default, "FindMatch")
		If $bAttackButtonFound Then
			Click(160, 460, 1, 0, "FindMatch")
			$g_bLeagueAttack = False
			If _Sleep(1000) Then Return
			If Not PrepareSearchCheckArmy() Then Return
		Else
			SetLog("FindMatch Not Found!", $COLOR_DEBUG2)
			$g_bRestart = True
			Return
		EndIf
	EndIf
	
	$g_bCloudsActive = True ; early set of clouds to ensure no android suspend occurs that might cause infinite waits
	
	If $g_iTownHallLevel <> "" And $g_iTownHallLevel > 0 Then
		$g_iSearchCost += $g_aiSearchCost[$g_iTownHallLevel - 1]
		$g_iStatsTotalGain[$eLootGold] -= $g_aiSearchCost[$g_iTownHallLevel - 1]
	EndIf
	UpdateStats()

	If $g_bRestart Then ; If we have one or both errors, Then Return
		$g_bIsClientSyncError = False ; reset fast restart flag to stop OOS mode, collecting resources etc.
		Return
	EndIf
	
EndFunc   ;==>PrepareSearch

Func PrepareSearchCheckArmy()
	Local $bRet = False
	For $i = 1 To 3
		SetLog("Checking ArmyOverview Window", $COLOR_DEBUG)
		If WaitforPixel(695, 500, 696, 501, "C2ED91", 20, 1) Then
			Click(695, 500, 1, 0, "ArmyOverview Attack Button")
			$bRet = True
			If _Sleep(1000) Then Return
			If IsOKCancelPage(True) Then 
				Click(535, 410, 1, 0, "Confirm Attack OK")
				$g_bLeagueAttack = True
			EndIf
			If _Sleep(1000) Then Return
			ExitLoop
		EndIf
		If _Sleep(500) Then Return
	Next
	
	Return $bRet
EndFunc

Func CloseMultiPlayerWindow()
	If IsMultiplayerTabOpen() Then 
		SetLog("Close Multiplayer Window", $COLOR_ACTION)
		ClickAway("Right")
		Return True
	EndIf
EndFunc

Func CheckRevengeTutor()
	Local $bRet = False
	
	If _ColorCheck(_GetPixelColor(299, 410, True), Hex(0xFFFFFF, 6), 20, Default, "CheckRevengeTutor") Or QuickMIS("BC1", $g_sImgRevengeTutor, 370, 85, 460, 160) Then
		SetLog("Found Multiplayer Tutorial", $COLOR_DEBUG)
		Click(300, 420, 1, 0, "Tutor Chat")
		
		For $i = 1 To 6
			SetLog("Waiting for Arrow #" & $i, $COLOR_ACTION)
			If QuickMIS("BC1", $g_sImgRevengeTutor, 370, 85, 460, 160) Then
				SetLog("Found Arrow Set Defense", $COLOR_DEBUG)
				Click(412, 182, 1, 0, "Button Setup Defense")
				If _Sleep(3000) Then Return
			EndIf
			
			If _ColorCheck(_GetPixelColor(299, 410, True), Hex(0xFFFFFF, 6), 20, Default, "WaitArrow") Then 
				Click(300, 420, 1, 0, "Tutor Chat")
				If _Sleep(3000) Then Return
			EndIf
			If _Sleep(1000) Then Return
		Next
		
		If _Sleep(2000) Then Return
		If QuickMIS("BC1", $g_sImgRevengeTutor, 245, 195, 288, 228) Then
			SetLog("Set Default Defense Layout", $COLOR_ACTION)
			Click(400, 300, 1, 0, "Defense Layout")
		EndIf
		
		If _ColorCheck(_GetPixelColor(299, 410, True), Hex(0xFFFFFF, 6), 20, Default, "WaitArrow") Then 
			Click(300, 420, 1, 0, "Tutor Chat")
			If _Sleep(3000) Then Return
		EndIf
		
		If QuickMIS("BC1", $g_sImgRevengeTutor, 765, 425, 800, 460) Then
			SetLog("Set Default Defense Troops", $COLOR_ACTION)
			Click(400, 500, 1, 0, "Defending Reinforcement")
			
			If _Sleep(1000) Then Return
			
			For $iTry = 1 To 2
				Local $aTroops = QuickMIS("CNX", $g_sImgTrainTroops, 22, 485, 460, 655) ;read all troops image 
				If IsArray($aTroops) And UBound($aTroops) > 0 Then
					_ArraySort($aTroops, 0, 0, 0, 1)
					
					For $i = 0 To UBound($aTroops) - 1
						Local $iTroopIndex = TroopIndexLookup($aTroops[$i][0])
						Local $sTroopName = GetTroopName($iTroopIndex)
						
						Switch $aTroops[$i][0]
							Case "Drag"
								TrainIt($iTroopIndex, 2, $g_iTrainClickDelay)
							Case "Ball"
								TrainIt($iTroopIndex, 7, $g_iTrainClickDelay)
						EndSwitch
						
						If Not QuickMIS("BC1", $g_sImgRevengeTutor, 765, 330, 800, 360) Then 
							Click(824, 26, 1, 0, "Close Train Troops")
							If _Sleep(1500) Then Return
							Click(825, 125, 1, 0, "Close Window")
							If _Sleep(1000) Then Return
							$bRet = True
							ExitLoop
						EndIf
					Next
				EndIf
			Next
		EndIf
	EndIf
	
	Return $bRet
EndFunc ;==>CheckRevengeTutor
