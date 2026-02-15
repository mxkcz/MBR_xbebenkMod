; #FUNCTION# ====================================================================================================================
; Name ..........: RankedBattle_TryJoin
; Description ...: Attempts ranked-battle tournament join/find-match flow from Multiplayer window.
; Syntax ........: RankedBattle_TryJoin([$bDryRun = False])
; Parameters ....: $bDryRun - Optional; if True, stop before attack-confirm flow.
; Return values .: True when ranked-battle match path is started; False otherwise.
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......: PrepareSearch(), PrepareSearchCheckArmy(), getMatchRemain()
; Link ..........:
; Example .......:
; =====================================================================================================================

Func RankedBattle_TryJoin($bDryRun = False)
	Local $bRankedBattle = False
	Local $aUi = RankedBattle_GetUiProfile()
	Local $aButton, $aMatch
	Local $iUsed = 0, $iTotal = 0, $iRemain = -1

	If Not FileExists($g_sImgRankedBattleSearch) Then
		SetLog("Ranked battle image directory not found: " & $g_sImgRankedBattleSearch, $COLOR_ERROR)
		Return False
	EndIf

	For $i = 1 To 20
		If Not $g_bRunState Then Return False
		If _Sleep(50) Then Return False

		SetDebugLog("Ranked battle scan #" & $i & " in region [" & $aUi[0][0] & "," & $aUi[0][1] & "," & $aUi[0][2] & "," & $aUi[0][3] & "]", $COLOR_DEBUG)
		$aButton = QuickMIS("CNX", $g_sImgRankedBattleSearch, $aUi[0][0], $aUi[0][1], $aUi[0][2], $aUi[0][3])
		If Not (IsArray($aButton) And UBound($aButton) > 0) Then ContinueLoop

		For $z = 0 To UBound($aButton) - 1
			Switch $aButton[$z][0]
				Case "SignUp"
					SetLog("Ranked battle SignUp button detected", $COLOR_DEBUG)
					Click($aButton[$z][1], $aButton[$z][2], 1, 0, "SignUp Ranked Battle")
					If _Sleep(1500) Then Return False
					If QuickMIS("BC1", $g_sImgRankedBattleSearch, $aUi[1][0], $aUi[1][1], $aUi[1][2], $aUi[1][3]) Then
						Click($g_iQuickMISX, $g_iQuickMISY, 1, 0, "SignUp Ranked Battle [2]")
						SetLog("Ranked battle signup confirmed; waiting for match state", $COLOR_ACTION)
						If _Sleep(300) Then Return False
						ContinueLoop 2
					EndIf

				Case "SignedUp"
					SetLog("Ranked battle is signed up; falling back to normal search this cycle", $COLOR_INFO)
					If _Sleep(500) Then Return False
					ExitLoop 2

				Case "Completed"
					SetLog("Ranked battle attacks completed", $COLOR_DEBUG2)
					If _Sleep(500) Then Return False
					ExitLoop 2

				Case "Match"
					SetLog("Ranked battle Match button detected", $COLOR_DEBUG)
					$aMatch = getMatchRemain($aUi[2][0], $aUi[2][1])
					$iRemain = -1
					If IsArray($aMatch) And UBound($aMatch) > 1 Then
						$iUsed = Number(StringRegExpReplace($aMatch[0], "[^0-9]", ""))
						$iTotal = Number(StringRegExpReplace($aMatch[1], "[^0-9]", ""))
						If $iTotal > 0 Then
							$iRemain = $iTotal - $iUsed
							SetLog("Ranked matches: " & $iUsed & "/" & $iTotal & " (remain " & $iRemain & ")", $COLOR_INFO)
						EndIf
					Else
						SetDebugLog("Ranked match OCR parsing returned no array", $COLOR_DEBUG)
					EndIf

					If $iRemain = 0 Then
						SetLog("All ranked battle attacks are already used", $COLOR_DEBUG2)
						ExitLoop 2
					EndIf

					Click($aButton[$z][1], $aButton[$z][2], 1, 0, "Find a Match Ranked Battle")
					If _Sleep(1000) Then Return False

					If $bDryRun Then Return True
					If Not PrepareSearchCheckArmy() Then
						SetLog("Ranked battle attack confirmation failed", $COLOR_DEBUG2)
						ExitLoop 2
					EndIf

					$g_bLeagueAttack = True
					$g_iMatchMode = $RankedBattle
					$bRankedBattle = True
					SetLog("Ranked battle path selected for next village", $COLOR_SUCCESS)
					ExitLoop 2
			EndSwitch
		Next
	Next

	Return $bRankedBattle
EndFunc   ;==>RankedBattle_TryJoin

; #FUNCTION# ====================================================================================================================
; Name ..........: RankedBattle_GetUiProfile
; Description ...: Builds ranked-battle search regions using current emulator height.
; Syntax ........: RankedBattle_GetUiProfile()
; Parameters ....: None
; Return values .: 2D array of bounded UI regions.
; Author ........: mxkcz
; Modified ......:
; Remarks .......: Baseline values target current project resolution. PH mod used a different height;
;                  update this profile only if migrating to PH resolution in the future.
;                  This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......: RankedBattle_TryJoin()
; Link ..........:
; Example .......:
; =====================================================================================================================
Func RankedBattle_GetUiProfile()
	Local $aProfile[3][4]
	Local $iYOffset = _RankedBattle_GetYOffset()
	Local $iCaptureHeight = $g_iGAME_HEIGHT

	If IsInt($g_iAndroidClientHeight) And $g_iAndroidClientHeight > 0 Then
		$iCaptureHeight = $g_iAndroidClientHeight
	EndIf

	; Search button tile region
	$aProfile[0][0] = 325
	$aProfile[0][1] = 435 + $iYOffset
	$aProfile[0][2] = 540
	$aProfile[0][3] = 500 + $iYOffset

	; Signup confirm region
	$aProfile[1][0] = 500
	$aProfile[1][1] = 460 + $iYOffset
	$aProfile[1][2] = 710
	$aProfile[1][3] = 530 + $iYOffset

	; Match remain OCR region (x, y, width, height)
	$aProfile[2][0] = 414
	$aProfile[2][1] = 475 + $iYOffset
	$aProfile[2][2] = 70
	$aProfile[2][3] = 22

	For $i = 0 To 1
		If $aProfile[$i][1] < 0 Then $aProfile[$i][1] = 0
		If $aProfile[$i][3] < 0 Then $aProfile[$i][3] = 0
		If $aProfile[$i][1] > $iCaptureHeight - 1 Then $aProfile[$i][1] = $iCaptureHeight - 1
		If $aProfile[$i][3] > $iCaptureHeight - 1 Then $aProfile[$i][3] = $iCaptureHeight - 1
	Next

	If $aProfile[2][1] < 0 Then $aProfile[2][1] = 0
	If $aProfile[2][1] > $iCaptureHeight - 1 Then $aProfile[2][1] = $iCaptureHeight - 1
	If $aProfile[2][1] + $aProfile[2][3] > $iCaptureHeight Then
		$aProfile[2][3] = $iCaptureHeight - $aProfile[2][1]
		If $aProfile[2][3] < 1 Then $aProfile[2][3] = 1
	EndIf

	Return $aProfile
EndFunc   ;==>RankedBattle_GetUiProfile

; #FUNCTION# ====================================================================================================================
; Name ..........: _RankedBattle_GetYOffset
; Description ...: Returns Y offset against baseline game height for ranked-battle UI profile.
; Syntax ........: _RankedBattle_GetYOffset()
; Parameters ....: None
; Return values .: Integer Y offset.
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......: RankedBattle_GetUiProfile()
; Link ..........:
; Example .......:
; =====================================================================================================================
Func _RankedBattle_GetYOffset()
	Local $iOffset = 0
	If IsInt($g_iAndroidClientHeight) And $g_iAndroidClientHeight > 0 Then
		$iOffset = $g_iAndroidClientHeight - $g_iGAME_HEIGHT
	EndIf
	Return $iOffset
EndFunc   ;==>_RankedBattle_GetYOffset
