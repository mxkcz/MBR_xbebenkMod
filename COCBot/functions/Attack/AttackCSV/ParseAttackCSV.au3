; #FUNCTION# ====================================================================================================================
; Name ..........: ParseAttackCSV
; Description ...:
; Syntax ........: ParseAttackCSV([$debug = False])
; Parameters ....: $debug               - [optional]
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......: MMHK (07/2017)(01/2018), TripleM (03/2019)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func ParseAttackCSV($debug = False)

	Local $bForceSideExist = False
	Local $sErrorText, $sTargetVectors = ""
	Local $iTroopIndex, $bWardenDrop = False
	; TL , TR , BL , BR
	Local $sides2drop[4] = [False, False, False, False]
	Local $aVectorTargetBuilding[26]

	_CSVPrioResetCache()

	For $v = 0 To 25 ; Zero all 26 vectors from last atttack in case here is error MAKE'ing new vectors
		Assign("ATTACKVECTOR_" & Chr(65 + $v), "", $ASSIGN_EXISTFAIL) ; start with character "A" = ASCII 65
		If @error Then SetLog("Failed to erase old vector: " & Chr(65 + $v) & ", ask code monkey to fix!", $COLOR_ERROR)
	Next

	;Local $filename = "attack1"
	If $g_iMatchMode = $DB Then
		Local $filename = $g_sAttackScrScriptName[$DB]
	Else
		Local $filename = $g_sAttackScrScriptName[$LB]
	EndIf
	SetLog("execute " & $filename)

	AttackCSV_PreparePrioPlan($filename)

	Local $f, $line, $acommand, $command
	Local $value1 = "", $value2 = "", $value3 = "", $value4 = "", $value5 = "", $value6 = "", $value7 = "", $value8 = "", $value9 = ""
	Local $aLines, $aTokens
	If _CSVGetCachedLinesAndTokens($filename, $aLines, $aTokens) Then

		; Read in lines of text until the EOF is reached
		For $iLine = 0 To UBound($aLines) - 1
			For $k = 1 To 15 ; reset values each row to avoid leftovers
				Assign("value" & $k, "")
			Next
			$line = $aLines[$iLine]
			$sErrorText = "" ; empty error text each row
			If @error = -1 Then ExitLoop
			If $debug = True Then SetLog("parse line:<<" & $line & ">>")
			debugAttackCSV("[" & $iLine + 1 & "] line content: " & $line)
			$acommand = $aTokens[$iLine]
			If Not IsArray($acommand) Then $acommand = StringSplit($line, "|")
			If $acommand[0] >= 8 Then
				$command = StringStripWS(StringUpper($acommand[1]), $STR_STRIPTRAILING)
				If $command = "" Then
					debugAttackCSV("comment line")
					ContinueLoop
				EndIf
				If $command = "NOTE" Then ContinueLoop ; informational line
				If $command = "TRAIN" Or $command = "REDLN" Or $command = "DRPLN" Or $command = "CCREQ" Then ContinueLoop ; discard setting commands
				If $command = "SIDE" Or $command = "SIDEB" Then ContinueLoop ; discard attack side commands
				; Set values
				For $i = 2 To (UBound($acommand) - 1)
					Assign("value" & Number($i - 1), StringStripWS(StringUpper($acommand[$i]), $STR_STRIPTRAILING))
					If $g_bDebugSetlog Then SetLog("value" & Number($i - 1) & " = " & StringStripWS(StringUpper($acommand[$i]), $STR_STRIPTRAILING), $COLOR_DEBUG1)
				Next

				Switch $command
					Case "MAKE"
						ReleaseClicks()
						If CheckCsvValues("MAKE", 2, $value2) Then
							Local $sidex = StringReplace($value2, "-", "_")
							If $sidex = "RANDOM" Then
								Switch Random(1, 4, 1)
									Case 1
										$sidex = "FRONT_"
										If Random(0, 1, 1) = 0 Then
											$sidex &= "LEFT"
										Else
											$sidex &= "RIGHT"
										EndIf
										$sides2drop[0] = True
									Case 2
										$sidex = "BACK_"
										If Random(0, 1, 1) = 0 Then
											$sidex &= "LEFT"
										Else
											$sidex &= "RIGHT"
										EndIf
										$sides2drop[1] = True
									Case 3
										$sidex = "LEFT_"
										If Random(0, 1, 1) = 0 Then
											$sidex &= "FRONT"
										Else
											$sidex &= "BACK"
										EndIf
										$sides2drop[2] = True
									Case 4
										$sidex = "RIGHT_"
										If Random(0, 1, 1) = 0 Then
											$sidex &= "FRONT"
										Else
											$sidex &= "BACK"
										EndIf
										$sides2drop[3] = True
								EndSwitch
							EndIf
							Switch Eval($sidex)
								Case StringInStr(Eval($sidex), "TOP-LEFT") > 0
									$sides2drop[0] = True
								Case StringInStr(Eval($sidex), "TOP-RIGHT") > 0
									$sides2drop[1] = True
								Case StringInStr(Eval($sidex), "BOTTOM-LEFT") > 0
									$sides2drop[2] = True
								Case StringInStr(Eval($sidex), "BOTTOM-RIGHT") > 0
									$sides2drop[3] = True
							EndSwitch
							If CheckCsvValues("MAKE", 1, $value1) And CheckCsvValues("MAKE", 5, $value5) Then
								$sTargetVectors = StringReplace($sTargetVectors, $value3, "", Default, $STR_NOCASESENSEBASIC) ; if re-making a vector, must remove from target vector string
								If CheckCsvValues("MAKE", 8, $value8) Then ; Vector is targeted towards building
									Local $bPrio = (StringUpper($value8) = "PRIO")
									Local $sAddTiles = $value4
									If $bPrio And (StringStripWS($sAddTiles, $STR_STRIPALL) = "" Or Not StringIsInt($sAddTiles)) Then $sAddTiles = "1"
									Local $sVersus = $value5
									If $bPrio And Not CheckCsvValues("MAKE", 5, $sVersus) Then $sVersus = "EXT-INT"
									Local $sVecKey = StringUpper($value1)
									If StringLen($sVecKey) = 1 Then
										Local $iVecIndex = Asc($sVecKey) - 65
										If $iVecIndex >= 0 And $iVecIndex < UBound($aVectorTargetBuilding) Then
											$aVectorTargetBuilding[$iVecIndex] = StringUpper($value8)
										EndIf
									EndIf
									; new field definitions:
									; value2 = $side = target side string
									; value3 = Drop point count can be 1 or 5 value only
									; value4 = addtiles Ignore if value3 = 5, only used when dropping in sigle point
									; value5 = versus ignore direction
									; value6 = RandomX ignored as image find location will be "random" without need to add more variability
									; value7 = randomY ignored as image find location will be "random" without need to add more variability
									; value8 = Building target for drop points
									If $value3 = 1 Or $value3 = 5 Then ; check for valid number of drop points
										SetLog(Eval($sidex) & ", " & $value3 & ", " & $value4 & ", " & $value8)
										Local $tmpArray = 0
										Local $bFallback = False
										If $bPrio Then
											$tmpArray = MakeTargetDropPoints(Eval($sidex), $value3, $sAddTiles, $value8)
											If @error Then
												$bFallback = True
												SetDebugLog("CSV PRIO: target unavailable, falling back to ADDTILES " & $sAddTiles, $COLOR_DEBUG)
												$tmpArray = MakeDropPoints(Eval($sidex), $value3, $sAddTiles, $sVersus, $value6, $value7)
											EndIf
										Else
											$tmpArray = MakeTargetDropPoints(Eval($sidex), $value3, $value4, $value8)
											Local $iTargetErr = @error
											If $iTargetErr Then
												$bFallback = True
												SetDebugLog("CSV target: " & $value8 & " unavailable on " & Eval($sidex) & " (err " & $iTargetErr & "), falling back to ADDTILES " & $value4, $COLOR_DEBUG)
												$tmpArray = MakeDropPoints(Eval($sidex), $value3, $value4, $sVersus, $value6, $value7)
											EndIf
										EndIf
										If @error Or Not IsArray($tmpArray) Or UBound($tmpArray) = 0 Then
											$sErrorText = ($bFallback ? "MakeDropPoints, err:" : "MakeTargetDropPoints, err:") & (@error ? @error : "empty vector")
										Else
											Assign("ATTACKVECTOR_" & $value1, $tmpArray) ; assing vector
											$sTargetVectors &= $value1 ; add letter of every vector using building target to string to error check DROP command
										EndIf
									Else
										$sErrorText = "value 3"
									EndIf
								Else ; normal redline based drop vectors
									Local $tmpArray = MakeDropPoints(Eval($sidex), $value3, $value4, $value5, $value6, $value7)
									If @error Or Not IsArray($tmpArray) Or UBound($tmpArray) = 0 Then
										$sErrorText = "MakeDropPoints, err:" & (@error ? @error : "empty vector")
									Else
										Assign("ATTACKVECTOR_" & $value1, $tmpArray)
									EndIf
								EndIf
							Else
								$sErrorText = "value1 or value 5"
							EndIf
						Else
							$sErrorText = "value2"
						EndIf
						If $sErrorText <> "" Then ; log error message
							SetLog("Discard row " & $iLine + 1 & ", bad parameter: " & $sErrorText)
							debugAttackCSV("Discard row " & $iLine + 1 & ", bad parameter: " & $sErrorText)
						Else ; debuglog vectors
							Local $dbgVec = Execute("$ATTACKVECTOR_" & $value1)
							If IsArray($dbgVec) Then
								For $i = 0 To UBound($dbgVec) - 1
									Local $pixel = $dbgVec[$i]
									debugAttackCSV($i & " - " & $pixel[0] & "," & $pixel[1])
								Next
							Else
								debugAttackCSV("Vector " & $value1 & " not assigned")
							EndIf
						EndIf
					Case "DROP"
						KeepClicks()
						;index...
						Local $index1, $index2, $indexArray, $indexvect
						$indexvect = StringSplit($value2, "-", 2)
						If UBound($indexvect) > 1 Then
							$indexArray = 0
							If Int($indexvect[0]) > 0 And Int($indexvect[1]) > 0 Then
								$index1 = Int($indexvect[0])
								$index2 = Int($indexvect[1])
							Else
								$index1 = 1
								$index2 = 1
							EndIf
						Else
							$indexArray = StringSplit($value2, ",", 2)
							If UBound($indexArray) > 1 Then
								$index1 = 0
								$index2 = UBound($indexArray) - 1
							Else
								$indexArray = 0
								If Int($value2) > 0 Then
									$index1 = Int($value2)
									$index2 = Int($value2)
								Else
									$index1 = 1
									$index2 = 1
								EndIf
							EndIf
						EndIf
						;qty...
						Local $qty1, $qty2, $qtyvect
						$qtyvect = StringSplit($value3, "-", 2)
						If UBound($qtyvect) > 1 Then
							If Int($qtyvect[0]) > 0 And Int($qtyvect[1]) > 0 Then
								$qty1 = Int($qtyvect[0])
								$qty2 = Int($qtyvect[1])
							Else
								$index1 = 1
								$qty2 = 1
							EndIf
						Else
							If Int($value3) > 0 Then
								$qty1 = Int($value3)
								$qty2 = Int($value3)
							Else
								$qty1 = 1
								$qty2 = 1
							EndIf
						EndIf
						;delay between points
						Local $delaypoints1, $delaypoints2, $delaypointsvect
						$delaypointsvect = StringSplit($value5, "-", 2)
						If UBound($delaypointsvect) > 1 Then
							If Int($delaypointsvect[0]) >= 0 And Int($delaypointsvect[1]) >= 0 Then
								$delaypoints1 = Int($delaypointsvect[0])
								$delaypoints2 = Int($delaypointsvect[1])
							Else
								$delaypoints1 = 1
								$delaypoints2 = 1
							EndIf
						Else
							If Int($value5) >= 0 Then
								$delaypoints1 = Int($value5)
								$delaypoints2 = Int($value5)
							Else
								$delaypoints1 = 1
								$delaypoints2 = 1
							EndIf
						EndIf
						;delay between  drops in same point
						Local $delaydrop1, $delaydrop2, $delaydropvect
						$delaydropvect = StringSplit($value6, "-", 2)
						If UBound($delaydropvect) > 1 Then
							If Int($delaydropvect[0]) >= 0 And Int($delaydropvect[1]) >= 0 Then
								$delaydrop1 = Int($delaydropvect[0])
								$delaydrop2 = Int($delaydropvect[1])
							Else
								$delaydrop1 = 1
								$delaydrop2 = 1
							EndIf
						Else
							If Int($value6) >= 0 Then
								$delaydrop1 = Int($value6)
								$delaydrop2 = Int($value6)
							Else
								$delaydrop1 = 1
								$delaydrop2 = 1
							EndIf
						EndIf
						;sleep time after drop
						Local $sleepdrop1, $sleepdrop2, $sleepdroppvect
						$sleepdroppvect = StringSplit($value7, "-", 2)
						If UBound($sleepdroppvect) > 1 Then
							If Int($sleepdroppvect[0]) >= 0 And Int($sleepdroppvect[1]) >= 0 Then
								$sleepdrop1 = Int($sleepdroppvect[0])
								$sleepdrop2 = Int($sleepdroppvect[1])
							Else
								$index1 = 1
								$sleepdrop2 = 1
							EndIf
						Else
							If Int($value7) >= 0 Then
								$sleepdrop1 = Int($value7)
								$sleepdrop2 = Int($value7)
							Else
								$sleepdrop1 = 1
								$sleepdrop2 = 1
							EndIf
						EndIf
						
						; check for targeted vectors and validate index numbers, need too many values for check logic to use CheckCSVValues()
						Local $tmpVectorList = StringSplit($value1, "-", $STR_NOCOUNT) ; get array with all vector(s) used
						For $v = 0 To UBound($tmpVectorList) - 1 ; loop thru each vector in target list
							If StringInStr($sTargetVectors, $tmpVectorList[$v], $STR_NOCASESENSEBASIC) = True Then
								If IsArray($indexArray) Then ; is index comma separated list?
									For $i = $index1 To $index2 ; check that all values are less 5?
										If $indexArray[$i] < 1 Or $indexArray[$i] > 5 Then
											$sErrorText &= "Invalid INDEX for near building DROP"
											SetDebugLog("$index1: " & $index1 & ", $index2: " & $index2 & ", $indexArray[" & $i & "]: " & $indexArray[$i], $COLOR_ERROR)
											ExitLoop
										EndIf
									Next
								ElseIf $indexArray = 0 Then ; index is either 2 values comma separated, range "-" separated between 1 & 5, or single index
									Select
										Case $index1 = 1 And $index1 = $index2
											; do nothing, is valid
										Case $index1 >= 1 And $index1 <= 5 And $index2 > 1 And $index2 <= 5
											; do nothing valid index values for near location targets
										Case Else
											$sErrorText &= "Invalid INDEX for building target"
											SetDebugLog("$index1: " & $index1 & ", $index2: " & $index2, $COLOR_ERROR)
									EndSelect
								Else
									SetDebugLog("Monkey found a bad banana checking Bdlg target INDEX!", $COLOR_ERROR)
								EndIf
							EndIf
						Next
						Local $iAttackTH = 0
						If IsNumber($g_iSearchTH) Then $iAttackTH = Int($g_iSearchTH)
						If $iAttackTH >= 18 And StringUpper($value4) = "FSPELL" Then
							Local $bSkipFreeze = False
							For $v = 0 To UBound($tmpVectorList) - 1
								Local $sVecKey = StringUpper($tmpVectorList[$v])
								If StringLen($sVecKey) = 1 Then
									Local $iVecIndex = Asc($sVecKey) - 65
									If $iVecIndex >= 0 And $iVecIndex < UBound($aVectorTargetBuilding) Then
										If $aVectorTargetBuilding[$iVecIndex] = "TOWNHALL" Then
											$bSkipFreeze = True
											ExitLoop
										EndIf
									EndIf
								EndIf
							Next
							If $bSkipFreeze Then
								SetLog("CSV: skip Freeze on TownHall at TH18 (vector " & $value1 & ")", $COLOR_INFO)
								ContinueLoop
							EndIf
						EndIf
						; ensure base vector exists before attempting drop
						Local $vectCheck = Execute("$ATTACKVECTOR_" & $value1)
						If Not IsArray($vectCheck) Or UBound($vectCheck) = 0 Then
							SetLog("Discard row, vector " & $value1 & " is empty/missing: row " & $iLine + 1, $COLOR_WARNING)
							ContinueLoop
						EndIf

						; validate index values against actual vector length
						Local $iVectorMax = UBound($vectCheck)
						If IsArray($indexArray) Then
							For $i = $index1 To $index2
								If $indexArray[$i] < 1 Or $indexArray[$i] > $iVectorMax Then
									$sErrorText &= "Invalid INDEX for vector length"
									SetDebugLog("$indexArray[" & $i & "]=" & $indexArray[$i] & ", max=" & $iVectorMax, $COLOR_ERROR)
									ExitLoop
								EndIf
							Next
						ElseIf $index1 < 1 Or $index2 < 1 Or $index1 > $iVectorMax Or $index2 > $iVectorMax Then
							$sErrorText &= "Invalid INDEX for vector length"
							SetDebugLog("$index1: " & $index1 & ", $index2: " & $index2 & ", max=" & $iVectorMax, $COLOR_ERROR)
						EndIf
						
						Local $bRemain = False
						Local $bIncludeHeroes = False
						Local $bIncludeSpells = False
						Local $sUnknownRemainFlags = ""
						If $sErrorText <> "" Then
							SetLog("Discard row, " & $sErrorText & ": row " & $iLine + 1)
							debugAttackCSV("Discard row, " & $sErrorText & ": row " & $iLine + 1)
						Else
							$bRemain = AttackCSV_ParseRemainFlags($value4, $bIncludeHeroes, $bIncludeSpells, $sUnknownRemainFlags)
							; REMAIN CMD from @chalicucu
							If $bRemain Then
								ReleaseClicks()
								Local $sRemainNote = ""
								If $bIncludeHeroes Or $bIncludeSpells Then
									$sRemainNote = " ("
									If $bIncludeHeroes Then $sRemainNote &= "heroes"
									If $bIncludeSpells Then $sRemainNote &= ($bIncludeHeroes ? "+spells" : "spells")
									$sRemainNote &= ")"
								EndIf
								SetLog("Drop|Remain: Dropping left over troops" & $sRemainNote, $COLOR_BLUE)
								If $sUnknownRemainFlags <> "" Then SetLog("Drop|Remain: Unknown flags [" & $sUnknownRemainFlags & "]", $COLOR_WARNING)
								Local $aRemainBackup = $g_avAttackTroops
								Local $iRemainTroops = PrepareAttack($g_iMatchMode, True)
								If $iRemainTroops <= 0 Then
									SetLog("Drop|Remain: attack bar refresh failed, using cached troop data", $COLOR_WARNING)
									$g_avAttackTroops = $aRemainBackup
								Else
									Local $iRestored = AttackCSV_MergeRemainTroops($g_avAttackTroops, $aRemainBackup)
									If $iRestored > 0 Then SetLog("Drop|Remain: restored " & $iRestored & " cached troop slots", $COLOR_WARNING)
								EndIf

								; Drop any remaining troop-type entries found on the attack bar (incl. event troops/CC/siege).
								For $x = 0 To UBound($g_avAttackTroops) - 1
									Local $iTroopIndex = $g_avAttackTroops[$x][0]
									Local $iTroopCount = $g_avAttackTroops[$x][1]
									If $iTroopCount <= 0 Then ContinueLoop
									Local $sShortName = AttackCSV_GetRemainTroopShortName($iTroopIndex, $bIncludeHeroes, $bIncludeSpells)
									If $sShortName = "" Then ContinueLoop
									Local $name = GetTroopName($iTroopIndex, $iTroopCount)
									Setlog("Drop Remaining " & $name & " x" & $iTroopCount, $COLOR_DEBUG)
									DropTroopFromINI($value1, $index1, $index2, $indexArray, $iTroopCount, $iTroopCount, $sShortName, $delaypoints1, $delaypoints2, $delaydrop1, $delaydrop2, $sleepdrop1, $sleepdrop2, $debug)
									If _Sleep($DELAYALGORITHM_ALLTROOPS5) Then Return
								Next
							Else
								DropTroopFromINI($value1, $index1, $index2, $indexArray, $qty1, $qty2, $value4, $delaypoints1, $delaypoints2, $delaydrop1, $delaydrop2, $sleepdrop1, $sleepdrop2, $debug)
							EndIf
						EndIf
						ReleaseClicks($g_iAndroidAdbClicksTroopDeploySize)
						If _Sleep($DELAYRESPOND) Then Return ; check for pause/stop
						;set flag if warden was dropped and sleep after delay was to short for icon to update properly
						If Not $bRemain Then
							$iTroopIndex = TroopIndexLookup($value4, "ParseAttackCSV") ; obtain enum
							$bWardenDrop = ($iTroopIndex = $eWarden) And ($sleepdrop1 < 1000)
						EndIf
					Case "WAIT"
						Local $hSleepTimer = __TimerInit() ; Initialize the timer at first
						ReleaseClicks()
						;sleep time
						Local $sleep1, $sleep2, $sleepvect
						$sleepvect = StringSplit($value1, "-", 2)
						If UBound($sleepvect) > 1 Then
							If Int($sleepvect[0]) > 0 And Int($sleepvect[1]) > 0 Then
								$sleep1 = Int($sleepvect[0])
								$sleep2 = Int($sleepvect[1])
							Else
								$sleep1 = 1
								$sleep2 = 1
							EndIf
						Else
							If Int($value1) > 0 Then
								$sleep1 = Int($value1)
								$sleep2 = Int($value1)
							Else
								$sleep1 = 1
								$sleep2 = 1
							EndIf
						EndIf
						If $sleep1 <> $sleep2 Then
							Local $sleep = Random(Int($sleep1), Int($sleep2), 1)
						Else
							Local $sleep = Int($sleep1)
						EndIf
						debugAttackCSV("wait " & $sleep)
						Local $Gold = 0
						Local $Elixir = 0
						Local $DarkElixir = 0
						Local $Trophies = 0
						Local $Damage = 0
						Local $exitOneStar = 0
						Local $exitTwoStars = 0
						Local $exitNoResources = 0
						Local $exitAttackEnded = 0
						Local $bBreakImmediately = False
						Local $bBreakOnTH = False
						Local $bBreakOnSiege = False
						Local $bBreakOnTHAndSiege = False
						Local $bBreakOn50Percent = False
						Local $bBreakOnAQAct = False
						Local $bBreakOnBKAct = False
						Local $bBreakOnAQandBKAct = False
						Local $bBreakOnGWAct = False
						Local $bBreakOnRCAct = False
						Local $aSiegeSlotPos = [0,0]
						Local $tempvalue2 = StringStripWS($value2, $STR_STRIPALL) ; remove all whitespaces from parameter
						If StringLen($tempvalue2) > 0 Then ; If parameter is not empty
							$bBreakImmediately = True ; when non of the set parameters fits, break the wait immediately
							Local $aParam = StringSplit($tempvalue2, ",", $STR_NOCOUNT) ; split parameter into subparameters
							For $iParam = 0 To UBound($aParam) - 1
								Switch $aParam[$iParam]
									Case "TH"
										$bBreakImmediately = False
										$bBreakOnTH = True
									Case "SIEGE"
										$bBreakOnSiege = True
									Case "TH+SIEGE"
										$bBreakImmediately = False
										$bBreakOnTHAndSiege = True
									Case "50%"
										$bBreakImmediately = False
										$bBreakOn50Percent = True
									Case "AQ"
										If $g_bCheckQueenPower Then ; Queen is dropped, automatic activation on and not activated yet
											$bBreakImmediately = False
											$bBreakOnAQAct = True
										EndIf
									Case "BK"
										If $g_bCheckKingPower Then ; King is dropped, automatic activation on and not activated yet
											$bBreakImmediately = False
											$bBreakOnBKAct = True
										EndIf
									Case "GW"
										If $g_bCheckWardenPower Then ; Warden is dropped, automatic activation on and not activated yet
											$bBreakImmediately = False
											$bBreakOnGWAct = True
										EndIf
									Case "RC"
										If $g_bCheckChampionPower Then ; Champion is dropped, automatic activation on and not activated yet
											$bBreakImmediately = False
											$bBreakOnRCAct = True
										EndIf
									Case "AQ+BK", "BK+AQ"
										If $g_bCheckQueenPower AND $g_bCheckKingPower Then ; Queen and King are dropped, automatic activation on and not activated yet
											$bBreakImmediately = False
											$bBreakOnAQandBKAct = True
										ElseIf $g_bCheckQueenPower Then ; Only Queen is dropped, automatic activation on and not activated yet
											$bBreakImmediately = False
											$bBreakOnAQAct = True
										ElseIf $g_bCheckKingPower Then ; Only King is dropped, automatic activation on and not activated yet
											$bBreakImmediately = False
											$bBreakOnBKAct = True
										EndIf
								EndSwitch
							Next
							SetDebugLog("$bBreakImmediately = " & $bBreakImmediately & ", $bBreakOnTH = " & $bBreakOnTH & ", $bBreakOnSiege = " & $bBreakOnSiege & ", $bBreakOnTHAndSiege = " & $bBreakOnTHAndSiege, $COLOR_INFO)
							SetDebugLog("$bBreakOn50Percent = " & $bBreakOn50Percent & ", $bBreakOnAQAct = " & $bBreakOnAQAct & ", $bBreakOnBKAct = " & $bBreakOnBKAct & ", $bBreakOnGWAct = " & $bBreakOnGWAct & ", $bBreakOnRCAct = " & $bBreakOnRCAct, $COLOR_INFO)
							If $bBreakOnSiege Or $bBreakOnTHAndSiege Then
								debugAttackCSV("WAIT Condition Break on Siege Troop Drop set")
								;Check if Siege is Available In Attackbar
								For $i = 0 To UBound($g_avAttackTroops) - 1
									If $g_avAttackTroops[$i][0] = $eCastle Then
										SetDebugLog("WAIT Break on Siege Machine is set but Clan Castle Troop selected.", $COLOR_INFO)
										ExitLoop
									ElseIf $g_avAttackTroops[$i][0] = $eWallW Or $g_avAttackTroops[$i][0] = $eBattleB Or $g_avAttackTroops[$i][0] = $eStoneS Or $g_avAttackTroops[$i][0] = $eSiegeB Or $g_avAttackTroops[$i][0] = $eLogL Or $g_avAttackTroops[$i][0] = $eFlameF Then
										Local $sSiegeName = GetTroopName($g_avAttackTroops[$i][0])
										SetDebugLog("	" & $sSiegeName & " found. Let's Check If is Dropped Or Not?", $COLOR_SUCCESS)
										;Check Siege Slot Quantity If It's 0 Means Siege Is Dropped
										If ReadTroopQuantity($i) = 0 Then
											SetDebugLog("	" & $sSiegeName & " is dropped.", $COLOR_SUCCESS)
											;Get Siege Machine Slot For Checking Slot Grayed Out or Not
											$aSiegeSlotPos = GetSlotPosition($i, True)
										Else
											SetDebugLog("	" & $sSiegeName & " is not dropped yet.", $COLOR_SUCCESS)
										EndIf
										ExitLoop
									EndIf
								Next
								If $aSiegeSlotPos[0] = 0 And $aSiegeSlotPos[1] = 0 Then ; no dropped Siege found
									SetDebugLog("WAIT no dropped Siege found, so unset Break on Siege.", $COLOR_INFO)
									If $bBreakOnTHAndSiege Then $bBreakOnTH = True ; When "TH+Siege" is set, set it to only "TH"
									$bBreakOnSiege = False
									$bBreakOnTHAndSiege = False
								Else
									$bBreakImmediately = False
								EndIf
							EndIf
						EndIf
						If $bBreakImmediately Then ContinueLoop ; Don't wait, when no condition fits
						While __TimerDiff($hSleepTimer) < $sleep
							CheckHeroesHealth()
							; Break on Queen AND King Activation
							If $bBreakOnAQandBKAct And Not $g_bCheckQueenPower And Not $g_bCheckKingPower Then ContinueLoop 2
							; Break on Queen Activation
							If $bBreakOnAQAct And Not $g_bCheckQueenPower Then ContinueLoop 2
							; Break on King Activation
							If $bBreakOnBKAct And Not $g_bCheckKingPower Then ContinueLoop 2
							; Break on Warden Activation
							If $bBreakOnGWAct And Not $g_bCheckWardenPower Then ContinueLoop 2
							; Break on Champion Activation
							If $bBreakOnRCAct And Not $g_bCheckChampionPower Then ContinueLoop 2
							; When Break on Siege is active and troops dropped, return ASAP
							If $bBreakOnSiege And CheckIfSiegeDroppedTheTroops($hSleepTimer, $aSiegeSlotPos) Then ContinueLoop 2
							; When Break on TH Kill is active in case townhall destroyed, return ASAP
							If $bBreakOnTH And CheckIfTownHallGotDestroyed($hSleepTimer) Then ContinueLoop 2
							; When Break on TH Kill And Siege is active, if both TH is destroyed and Siege troops are dropped, return ASAP
							If $bBreakOnTHAndSiege And CheckIfSiegeDroppedTheTroops($hSleepTimer, $aSiegeSlotPos) And CheckIfTownHallGotDestroyed($hSleepTimer) Then ContinueLoop 2
							; Read Resources and Damage
							$Damage = getOcrOverAllDamage(780, 529)
							$Gold = getGoldVillageSearch(48, 69)
							$Elixir = getElixirVillageSearch(48, 69 + 29)
							If _Sleep($DELAYRESPOND) Then Return ; check for pause/stop
							$Trophies = getTrophyVillageSearch(48, 69 + 99)
							If $Trophies <> "" Then ; If trophy value found, then base has Dark Elixir
								$DarkElixir = getDarkElixirVillageSearch(48, 69 + 57)
							Else
								$DarkElixir = ""
								$Trophies = getTrophyVillageSearch(48, 69 + 69)
							EndIf
							If $bBreakOn50Percent And Number($Damage) > 49 Then ContinueLoop 2
							CheckHeroesHealth()
							; Break on Queen AND King Activation
							If $bBreakOnAQandBKAct And Not $g_bCheckQueenPower And Not $g_bCheckKingPower Then ContinueLoop 2
							; Break on Queen Activation
							If $bBreakOnAQAct And Not $g_bCheckQueenPower Then ContinueLoop 2
							; Break on King Activation
							If $bBreakOnBKAct And Not $g_bCheckKingPower Then ContinueLoop 2
							; Break on Warden Activation
							If $bBreakOnGWAct And Not $g_bCheckWardenPower Then ContinueLoop 2
							; Break on Champion Activation
							If $bBreakOnRCAct And Not $g_bCheckChampionPower Then ContinueLoop 2
							; When Break on Siege is active and troops dropped, return ASAP
							If $bBreakOnSiege And CheckIfSiegeDroppedTheTroops($hSleepTimer, $aSiegeSlotPos) Then ContinueLoop 2
							; When Break on TH Kill is active in case townhall destroyed, return ASAP
							If $bBreakOnTH And CheckIfTownHallGotDestroyed($hSleepTimer) Then ContinueLoop 2
							; When Break on TH Kill And Siege is active, if both TH is destroyed and Siege troops are dropped, return ASAP
							If $bBreakOnTHAndSiege And CheckIfSiegeDroppedTheTroops($hSleepTimer, $aSiegeSlotPos) And CheckIfTownHallGotDestroyed($hSleepTimer) Then ContinueLoop 2

							SetDebugLog("detected [G]: " & $Gold & " [E]: " & $Elixir & " [DE]: " & $DarkElixir, $COLOR_INFO)
							;EXIT IF RESOURCES = 0
							If $g_abStopAtkNoResources[$g_iMatchMode] And Number($Gold) = 0 And Number($Elixir) = 0 And Number($DarkElixir) = 0 Then
								If Not $g_bDebugSetlog Then SetDebugLog("detected [G]: " & $Gold & " [E]: " & $Elixir & " [DE]: " & $DarkElixir, $COLOR_INFO) ; log if not down above
								SetDebugLog("From Attackcsv: Gold & Elixir & DE = 0, end battle ", $COLOR_DEBUG)
								$exitNoResources = 1
								ExitLoop
							EndIf
							;CALCULATE TWO STARS REACH
							If $g_abStopAtkTwoStars[$g_iMatchMode] And _CheckPixel($aWonTwoStar, True) Then
								SetDebugLog("From Attackcsv: Two Star Reach, exit", $COLOR_SUCCESS)
								$exitTwoStars = 1
								ExitLoop
							EndIf
							;CALCULATE ONE STARS REACH
							If $g_abStopAtkOneStar[$g_iMatchMode] And _CheckPixel($aWonOneStar, True) Then
								SetDebugLog("From Attackcsv: One Star Reach, exit", $COLOR_SUCCESS)
								$exitOneStar = 1
								ExitLoop
							EndIf
							If $g_abStopAtkPctHigherEnable[$g_iMatchMode] And Number($Damage) > Int($g_aiStopAtkPctHigherAmt[$g_iMatchMode]) Then
								ExitLoop
							EndIf
							If _CheckPixel($aEndFightSceneBtn, True) And _CheckPixel($aEndFightSceneAvl, True) And _CheckPixel($aEndFightSceneReportGold, True) Then
								SetDebugLog("From Attackcsv: Found End Fight Scene to close, exit", $COLOR_SUCCESS)
								$exitAttackEnded = 1
								ExitLoop
							EndIf
							If _Sleep($DELAYRESPOND) Then Return ; check for pause/stop
						WEnd
						If $exitOneStar = 1 Or $exitTwoStars = 1 Or $exitNoResources = 1 Or $exitAttackEnded = 1 Then ExitLoop ;stop parse CSV file, start exit battle procedure

					Case "RECALC"
						ReleaseClicks()
						PrepareAttack($g_iMatchMode, True)

					Case Else
						Switch StringLeft($command, 1)
							Case ";", "#", "'"
								; also comment
								debugAttackCSV("comment line")
							Case Else
								SetLog("attack row bad, discard: row " & $iLine + 1, $COLOR_ERROR)
						EndSwitch
				EndSwitch
			Else
				If StringLeft($line, 7) <> "NOTE  |" And StringLeft($line, 7) <> "      |" And StringStripWS(StringUpper($line), 2) <> "" Then SetLog("attack row error, discard: row " & $iLine + 1, $COLOR_ERROR)
			EndIf
			If $bWardenDrop = True Then ;Check hero, but skip Warden if was dropped with sleepafter to short to allow icon update
				Local $bHold = $g_bCheckWardenPower ; store existing flag state, should be true?
				$g_bCheckWardenPower = False ;temp disable warden health check
				CheckHeroesHealth()
				$g_bCheckWardenPower = $bHold ; restore flag state
			Else
				CheckHeroesHealth()
			EndIf
			If _Sleep($DELAYRESPOND) Then Return ; check for pause/stop after each line of CSV
		Next
		For $i = 0 To 3
			If $sides2drop[$i] Then $g_iSidesAttack += 1
		Next
		ReleaseClicks()
	Else
		SetLog("Cannot find attack file " & $g_sCSVAttacksPath & "\" & $filename & ".csv", $COLOR_ERROR)
	EndIf
EndFunc   ;==>ParseAttackCSV

; Side-effect: pure (index -> short name mapping)
Func AttackCSV_GetRemainTroopShortName($iTroopIndex, $bIncludeHeroes = False, $bIncludeSpells = False)
	If $iTroopIndex >= $eBarb And $iTroopIndex <= $eIWiza Then
		Return $g_asTroopShortNames[$iTroopIndex]
	EndIf
	If $iTroopIndex >= $eWallW And $iTroopIndex <= $eTroopL Then
		Return $g_asSiegeMachineShortNames[$iTroopIndex - $eWallW]
	EndIf
	If $iTroopIndex = $eCastle Then Return "Castle"
	If $bIncludeHeroes And $iTroopIndex >= $eKing And $iTroopIndex <= $ePrince Then
		Return $g_asHeroShortNames[$iTroopIndex - $eKing]
	EndIf
	If $bIncludeSpells And $iTroopIndex >= $eLSpell And $iTroopIndex <= $eOgSpell Then
		Return $g_asSpellShortNames[$iTroopIndex - $eLSpell]
	EndIf
	Return ""
EndFunc   ;==>AttackCSV_GetRemainTroopShortName

; Side-effect: pure (array merge)
Func AttackCSV_MergeRemainTroops(ByRef $aCurrent, ByRef $aBackup)
	If UBound($aCurrent, 0) <> 2 Or UBound($aBackup, 0) <> 2 Then Return 0
	Local $iRows = UBound($aCurrent, 1)
	Local $iBackupRows = UBound($aBackup, 1)
	If $iBackupRows < $iRows Then $iRows = $iBackupRows
	Local $iCols = UBound($aCurrent, 2)
	Local $iBackupCols = UBound($aBackup, 2)
	If $iBackupCols < $iCols Then $iCols = $iBackupCols
	Local $iRestored = 0

	For $i = 0 To $iRows - 1
		If $aCurrent[$i][0] = -1 And $aBackup[$i][0] >= 0 And $aBackup[$i][1] > 0 Then
			For $j = 0 To $iCols - 1
				$aCurrent[$i][$j] = $aBackup[$i][$j]
			Next
			$iRestored += 1
		EndIf
	Next

	Return $iRestored
EndFunc   ;==>AttackCSV_MergeRemainTroops

; Side-effect: pure (flag parsing)
Func AttackCSV_ParseRemainFlags($sValue, ByRef $bIncludeHeroes, ByRef $bIncludeSpells, ByRef $sUnknownFlags)
	$bIncludeHeroes = False
	$bIncludeSpells = False
	$sUnknownFlags = ""
	Local $sClean = StringUpper(StringStripWS($sValue, $STR_STRIPALL))
	If StringLeft($sClean, 6) <> "REMAIN" Then Return False

	Local $sSuffix = StringTrimLeft($sClean, 6)
	If $sSuffix = "" Then Return True
	If StringLeft($sSuffix, 1) = "+" Or StringLeft($sSuffix, 1) = "-" Or StringLeft($sSuffix, 1) = ":" Then
		$sSuffix = StringTrimLeft($sSuffix, 1)
	EndIf
	$sSuffix = StringReplace($sSuffix, "-", "+")
	$sSuffix = StringReplace($sSuffix, ":", "+")
	$sSuffix = StringReplace($sSuffix, "/", "+")
	Local $aFlags = StringSplit($sSuffix, "+", $STR_NOCOUNT)
	For $i = 0 To UBound($aFlags) - 1
		Local $sFlag = StringStripWS($aFlags[$i], $STR_STRIPALL)
		If $sFlag = "" Then ContinueLoop
		Switch $sFlag
			Case "ALL", "EVERY", "ANY"
				$bIncludeHeroes = True
				$bIncludeSpells = True
			Case "HERO", "HEROES"
				$bIncludeHeroes = True
			Case "SPELL", "SPELLS"
				$bIncludeSpells = True
			Case Else
				If $sUnknownFlags <> "" Then $sUnknownFlags &= ","
				$sUnknownFlags &= $sFlag
		EndSwitch
	Next
	Return True
EndFunc   ;==>AttackCSV_ParseRemainFlags

;This Function is used to check if siege dropped the troops
Func CheckIfSiegeDroppedTheTroops($hSleepTimer, $aSiegeSlotPos)
	;Check Gray Pixel When Siege IS Dead.
	If _ColorCheck(_GetPixelColor($aSiegeSlotPos[0] + 20, $aSiegeSlotPos[1] + 20, True, "WAIT--> IsSiegeDestroyed"), Hex(0x474747, 6), 10) Then
		SetDebugLog("WAIT--> Siege Got Destroyed After " & Round(__TimerDiff($hSleepTimer)) & "ms.", $COLOR_SUCCESS)
		Return True
	EndIf
	Return False
EndFunc   ;==>CheckIfSiegeDroppedTheTroops

;This Function is used to check if Townhall is destroyed
Func CheckIfTownHallGotDestroyed($hSleepTimer)
	Static $hPopupTimer = 0
	Local $bIsTHDestroyed = False
	; Check if got any star
	Local $bWonOneStar = _CheckPixel($aWonOneStar, True)
	Local $bWonTwoStar = _CheckPixel($aWonTwoStar, True)
	; Check for the centrally popped up star
	Local $bCentralStarPopup = _ColorCheck(_GetPixelColor(Int($g_iGAME_WIDTH / 2) - 2, Int($g_iGAME_HEIGHT / 2) - 2, True), Hex(0xC0C4C0, 6), 20) And _
							   _ColorCheck(_GetPixelColor(Int($g_iGAME_WIDTH / 2) - 2, Int($g_iGAME_HEIGHT / 2) + 2, True), Hex(0xC0C4C0, 6), 20) And _
							   _ColorCheck(_GetPixelColor(Int($g_iGAME_WIDTH / 2) + 2, Int($g_iGAME_HEIGHT / 2) + 2, True), Hex(0xC0C4C0, 6), 20) And _
							   _ColorCheck(_GetPixelColor(Int($g_iGAME_WIDTH / 2) + 2, Int($g_iGAME_HEIGHT / 2) - 2, True), Hex(0xC0C4C0, 6), 20)
	;Get Current Damge %
	Local $iDamage = Number(getOcrOverAllDamage(780, 529))

	; Optimistic Trigger on Star Popup
	If $bCentralStarPopup Then
	; When damage < 50% TH is destroyed
		If $iDamage < 50 Then
			$bIsTHDestroyed = True
	; When already one star, popup star is the second one for TH
		ElseIf $bWonOneStar Then
			$bIsTHDestroyed = True
	; trying to catch the cornercase of two distinguishable popups within 1500 msec (time from popup to settle of a star)
	; Initialize the Timer, when not initialized, or last initialization is more than 1500 msec old
		ElseIf $hPopupTimer = 0 Or __TimerDiff($hPopupTimer) > 1500 Then
			$hPopupTimer = __TimerInit()
	; trigger, when 500ms after a star popup there is still a popped up star (the star usually stays less than half a sec)
		ElseIf __TimerDiff($hPopupTimer) > 500 Then
			$bIsTHDestroyed = True
		EndIf
	; Failsafe Trigger: If Got 1 Star and Damage % < 50% then TH was taken before 50%
	ElseIf $bWonOneStar And $iDamage < 50 Then
		$bIsTHDestroyed = True
	; Failsafe Trigger: If Got 2 Star and Damage % >= 50% then TH was taken after 50%
	ElseIf $bWonTwoStar Then
		$bIsTHDestroyed = True
	EndIf
	SetDebugLog("WAIT--> $iDamage: " & $iDamage & ", $bCentralStarPopup: " & $bCentralStarPopup & ", $bWonOneStar: " & $bWonOneStar & ", $bWonTwoStar: " & $bWonTwoStar & ", $bIsTHDestroyed: " & $bIsTHDestroyed, $COLOR_INFO)
	If $bIsTHDestroyed Then SetDebugLog("WAIT--> Town Hall Got Destroyed After " & Round(__TimerDiff($hSleepTimer)) & "ms.", $COLOR_SUCCESS)
	Return $bIsTHDestroyed
EndFunc   ;==>CheckIfTownHallGotDestroyed


; #FUNCTION# ====================================================================================================================
; Name ..........: ParseAttackCSV_MainSide
; Description ...:
; Syntax ........: ParseAttackCSV_MainSide([$debug = False])
; Parameters ....: $debug               - [optional]
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......: MMHK (07-2017)(01-2018), Demen (2019)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func ParseAttackCSV_MainSide($debug = False)

	Local $bForceSideExist = False
	;Local $filename = "attack1"
	If $g_iMatchMode = $DB Then
		Local $filename = $g_sAttackScrScriptName[$DB]
	Else
		Local $filename = $g_sAttackScrScriptName[$LB]
	EndIf

	Local $line, $acommand, $command
	Local $value1 = "", $value2 = "", $value3 = "", $value4 = "", $value5 = "", $value6 = "", $value7 = "", $value8 = "", $value9 = "", $value10 = "", $value11 = "", $value12 = "", $value13 = "", $value14 = ""
	Local $aLines, $aTokens
	If _CSVGetCachedLinesAndTokens($filename, $aLines, $aTokens) Then

		; Read in lines of text until the EOF is reached
		For $iLine = 0 To UBound($aLines) - 1
			$line = $aLines[$iLine]
			debugAttackCSV("line: " & $iLine + 1)
			If @error = -1 Then ExitLoop
			If $debug = True Then SetLog("parse line:<<" & $line & ">>")
			debugAttackCSV("line content: " & $line)
			$acommand = $aTokens[$iLine]
			If Not IsArray($acommand) Then $acommand = StringSplit($line, "|")
			If $acommand[0] >= 8 Then
				$command = StringStripWS(StringUpper($acommand[1]), $STR_STRIPTRAILING)
				If $command <> "SIDE" And $command <> "SIDEB" Then ContinueLoop ; Only deal with SIDE and SIDEB commands
				; Set values
				For $i = 2 To (UBound($acommand) - 1)
					Assign("value" & Number($i - 1), StringStripWS(StringUpper($acommand[$i]), $STR_STRIPTRAILING))
				Next

				Switch $command
					Case "SIDE"
						ReleaseClicks()
						SetLog("Calculate main side... ")
						Local $heightTopLeft = 0, $heightTopRight = 0, $heightBottomLeft = 0, $heightBottomRight = 0
						If StringUpper($value8) = "TOP-LEFT" Or StringUpper($value8) = "TOP-RIGHT" Or StringUpper($value8) = "BOTTOM-LEFT" Or StringUpper($value8) = "BOTTOM-RIGHT" Then
							$MAINSIDE = StringUpper($value8)
							SetLog("Forced side: " & $MAINSIDE, $COLOR_INFO)
							$bForceSideExist = True
						ElseIf StringUpper($value8) = "TOP-RAND" Then
							Local $iRand = Random(0, 1, 1), $aSide[2] = ["LEFT", "RIGHT"]
							Local $side = StringUpper($value8)
							$MAINSIDE = StringReplace($side, "RAND", $aSide[$iRand])
							SetLog("Random Forced side: " & $MAINSIDE, $COLOR_INFO)
							$bForceSideExist = True
						Else
							For $i = 0 To UBound($g_aiPixelMine) - 1
								Local $str = ""
								Local $pixel = $g_aiPixelMine[$i]
								If UBound($pixel) = 2 Then
									Switch StringLeft(Slice8($pixel), 1)
										Case 1, 2
											$heightBottomRight += Int($value1)
										Case 3, 4
											$heightTopRight += Int($value1)
										Case 5, 6
											$heightTopLeft += Int($value1)
										Case 7, 8
											$heightBottomLeft += Int($value1)
									EndSwitch
								EndIf
							Next

							For $i = 0 To UBound($g_aiPixelElixir) - 1
								Local $str = ""
								Local $pixel = $g_aiPixelElixir[$i]
								If UBound($pixel) = 2 Then
									Switch StringLeft(Slice8($pixel), 1)
										Case 1, 2
											$heightBottomRight += Int($value2)
										Case 3, 4
											$heightTopRight += Int($value2)
										Case 5, 6
											$heightTopLeft += Int($value2)
										Case 7, 8
											$heightBottomLeft += Int($value2)
									EndSwitch
								EndIf
							Next

							For $i = 0 To UBound($g_aiPixelDarkElixir) - 1
								Local $str = ""
								Local $pixel = $g_aiPixelDarkElixir[$i]
								If UBound($pixel) = 2 Then
									Switch StringLeft(Slice8($pixel), 1)
										Case 1, 2
											$heightBottomRight += Int($value3)
										Case 3, 4
											$heightTopRight += Int($value3)
										Case 5, 6
											$heightTopLeft += Int($value3)
										Case 7, 8
											$heightBottomLeft += Int($value3)
									EndSwitch
								EndIf
							Next

							If IsArray($g_aiCSVGoldStoragePos) Then
								For $i = 0 To UBound($g_aiCSVGoldStoragePos) - 1
									Local $pixel = $g_aiCSVGoldStoragePos[$i]
									If UBound($pixel) = 2 Then
										Switch StringLeft(Slice8($pixel), 1)
											Case 1, 2
												$heightBottomRight += Int($value4)
											Case 3, 4
												$heightTopRight += Int($value4)
											Case 5, 6
												$heightTopLeft += Int($value4)
											Case 7, 8
												$heightBottomLeft += Int($value4)
										EndSwitch
									EndIf
								Next
							EndIf

							If IsArray($g_aiCSVElixirStoragePos) Then
								For $i = 0 To UBound($g_aiCSVElixirStoragePos) - 1
									Local $pixel = $g_aiCSVElixirStoragePos[$i]
									If UBound($pixel) = 2 Then
										Switch StringLeft(Slice8($pixel), 1)
											Case 1, 2
												$heightBottomRight += Int($value5)
											Case 3, 4
												$heightTopRight += Int($value5)
											Case 5, 6
												$heightTopLeft += Int($value5)
											Case 7, 8
												$heightBottomLeft += Int($value5)
										EndSwitch
									EndIf
								Next
							EndIf

							Switch StringLeft(Slice8($g_aiCSVDarkElixirStoragePos), 1)
								Case 1, 2
									$heightBottomRight += Int($value6)
								Case 3, 4
									$heightTopRight += Int($value6)
								Case 5, 6
									$heightTopLeft += Int($value6)
								Case 7, 8
									$heightBottomLeft += Int($value6)
							EndSwitch

							Local $pixel = StringSplit($g_iTHx & "-" & $g_iTHy, "-", 2)
							Switch StringLeft(Slice8($pixel), 1)
								Case 1, 2
									$heightBottomRight += Int($value7)
								Case 3, 4
									$heightTopRight += Int($value7)
								Case 5, 6
									$heightTopLeft += Int($value7)
								Case 7, 8
									$heightBottomLeft += Int($value7)
							EndSwitch
						EndIf

						If $bForceSideExist = False Then
							Local $maxValue = $heightBottomRight
							Local $sidename = "BOTTOM-RIGHT"

							If $heightTopLeft > $maxValue Then
								$maxValue = $heightTopLeft
								$sidename = "TOP-LEFT"
							EndIf

							If $heightTopRight > $maxValue Then
								$maxValue = $heightTopRight
								$sidename = "TOP-RIGHT"
							EndIf

							If $heightBottomLeft > $maxValue Then
								$maxValue = $heightBottomLeft
								$sidename = "BOTTOM-LEFT"
							EndIf

							SetLog("Mainside: " & $sidename & " (top-left:" & $heightTopLeft & " top-right:" & $heightTopRight & " bottom-left:" & $heightBottomLeft & " bottom-right:" & $heightBottomRight)
							$MAINSIDE = $sidename
						EndIf

						Switch $MAINSIDE
							Case "BOTTOM-RIGHT"
								$FRONT_LEFT = "BOTTOM-RIGHT-DOWN"
								$FRONT_RIGHT = "BOTTOM-RIGHT-UP"
								$RIGHT_FRONT = "TOP-RIGHT-DOWN"
								$RIGHT_BACK = "TOP-RIGHT-UP"
								$LEFT_FRONT = "BOTTOM-LEFT-DOWN"
								$LEFT_BACK = "BOTTOM-LEFT-UP"
								$BACK_LEFT = "TOP-LEFT-DOWN"
								$BACK_RIGHT = "TOP-LEFT-UP"
							Case "BOTTOM-LEFT"
								$FRONT_LEFT = "BOTTOM-LEFT-UP"
								$FRONT_RIGHT = "BOTTOM-LEFT-DOWN"
								$RIGHT_FRONT = "BOTTOM-RIGHT-DOWN"
								$RIGHT_BACK = "BOTTOM-RIGHT-UP"
								$LEFT_FRONT = "TOP-LEFT-DOWN"
								$LEFT_BACK = "TOP-LEFT-UP"
								$BACK_LEFT = "TOP-RIGHT-UP"
								$BACK_RIGHT = "TOP-RIGHT-DOWN"
							Case "TOP-LEFT"
								$FRONT_LEFT = "TOP-LEFT-UP"
								$FRONT_RIGHT = "TOP-LEFT-DOWN"
								$RIGHT_FRONT = "BOTTOM-LEFT-UP"
								$RIGHT_BACK = "BOTTOM-LEFT-DOWN"
								$LEFT_FRONT = "TOP-RIGHT-UP"
								$LEFT_BACK = "TOP-RIGHT-DOWN"
								$BACK_LEFT = "BOTTOM-RIGHT-UP"
								$BACK_RIGHT = "BOTTOM-RIGHT-DOWN"
							Case "TOP-RIGHT"
								$FRONT_LEFT = "TOP-RIGHT-DOWN"
								$FRONT_RIGHT = "TOP-RIGHT-UP"
								$RIGHT_FRONT = "TOP-LEFT-UP"
								$RIGHT_BACK = "TOP-LEFT-DOWN"
								$LEFT_FRONT = "BOTTOM-RIGHT-UP"
								$LEFT_BACK = "BOTTOM-RIGHT-DOWN"
								$BACK_LEFT = "BOTTOM-LEFT-DOWN"
								$BACK_RIGHT = "BOTTOM-LEFT-UP"
						EndSwitch

					Case "SIDEB"
						ReleaseClicks()
						If $bForceSideExist = False Then
							SetLog("Recalculate main side for additional defense buildings... ", $COLOR_INFO)

							Switch StringLeft(Slice8($g_aiCSVEagleArtilleryPos), 1)
								Case 1, 2
									$heightBottomRight += Int($value1) ; Eagle weight
								Case 3, 4
									$heightTopRight += Int($value1)
								Case 5, 6
									$heightTopLeft += Int($value1)
								Case 7, 8
									$heightBottomLeft += Int($value1)
							EndSwitch

							If IsArray($g_aiCSVInfernoPos) Then
								For $i = 0 To UBound($g_aiCSVInfernoPos) - 1
									Local $pixel = $g_aiCSVInfernoPos[$i]
									If UBound($pixel) = 2 Then
										Switch StringLeft(Slice8($pixel), 1)
											Case 1, 2
												$heightBottomRight += Int($value2)
											Case 3, 4
												$heightTopRight += Int($value2)
											Case 5, 6
												$heightTopLeft += Int($value2)
											Case 7, 8
												$heightBottomLeft += Int($value2)
										EndSwitch
									EndIf
								Next
							EndIf

							If IsArray($g_aiCSVXBowPos) Then
								For $i = 0 To UBound($g_aiCSVXBowPos) - 1
									Local $pixel = $g_aiCSVXBowPos[$i]
									If UBound($pixel) = 2 Then
										Switch StringLeft(Slice8($pixel), 1)
											Case 1, 2
												$heightBottomRight += Int($value3)
											Case 3, 4
												$heightTopRight += Int($value3)
											Case 5, 6
												$heightTopLeft += Int($value3)
											Case 7, 8
												$heightBottomLeft += Int($value3)
										EndSwitch
									EndIf
								Next
							EndIf

							If IsArray($g_aiCSVSuperWizTowerPos) Then
								For $i = 0 To UBound($g_aiCSVSuperWizTowerPos) - 1
									Local $pixel = $g_aiCSVSuperWizTowerPos[$i]
									If UBound($pixel) = 2 Then
										Switch StringLeft(Slice8($pixel), 1)
											Case 1, 2
												$heightBottomRight += Int($value4)
											Case 3, 4
												$heightTopRight += Int($value4)
											Case 5, 6
												$heightTopLeft += Int($value4)
											Case 7, 8
												$heightBottomLeft += Int($value4)
										EndSwitch
									EndIf
								Next
							EndIf

							If IsArray($g_aiCSVWizTowerPos) Then
								For $i = 0 To UBound($g_aiCSVWizTowerPos) - 1
									Local $pixel = $g_aiCSVWizTowerPos[$i]
									If UBound($pixel) = 2 Then
										Switch StringLeft(Slice8($pixel), 1)
											Case 1, 2
												$heightBottomRight += Int($value4)
											Case 3, 4
												$heightTopRight += Int($value4)
											Case 5, 6
												$heightTopLeft += Int($value4)
											Case 7, 8
												$heightBottomLeft += Int($value4)
										EndSwitch
									EndIf
								Next
							EndIf

							If IsArray($g_aiCSVMortarPos) Then
								For $i = 0 To UBound($g_aiCSVMortarPos) - 1
									Local $pixel = $g_aiCSVMortarPos[$i]
									If UBound($pixel) = 2 Then
										Switch StringLeft(Slice8($pixel), 1)
											Case 1, 2
												$heightBottomRight += Int($value5)
											Case 3, 4
												$heightTopRight += Int($value5)
											Case 5, 6
												$heightTopLeft += Int($value5)
											Case 7, 8
												$heightBottomLeft += Int($value5)
										EndSwitch
									EndIf
								Next
							EndIf

							If IsArray($g_aiCSVAirDefensePos) Then
								For $i = 0 To UBound($g_aiCSVAirDefensePos) - 1
									Local $pixel = $g_aiCSVAirDefensePos[$i]
									If UBound($pixel) = 2 Then
										Switch StringLeft(Slice8($pixel), 1)
											Case 1, 2
												$heightBottomRight += Int($value6)
											Case 3, 4
												$heightTopRight += Int($value6)
											Case 5, 6
												$heightTopLeft += Int($value6)
											Case 7, 8
												$heightBottomLeft += Int($value6)
										EndSwitch
									EndIf
								Next
							EndIf

							; CSV SIDEB column mapping (by position):
							; 1: Eagle, 2: Inferno, 3: XBow, 4: WizTower, 5: Mortar, 6: AirDefense, 7: Scatter,
							; 8: Sweeper, 9: Monolith, 10: FireSpitter, 11: MultiArcher, 12: MultiGear, 13: Ricochet, 14: Revenge

							If IsArray($g_aiCSVScatterPos) Then
								For $i = 0 To UBound($g_aiCSVScatterPos) - 1
									Local $pixel = $g_aiCSVScatterPos[$i]
									If UBound($pixel) = 2 Then
										Switch StringLeft(Slice8($pixel), 1)
											Case 1, 2
												$heightBottomRight += Int($value7)
											Case 3, 4
												$heightTopRight += Int($value7)
											Case 5, 6
												$heightTopLeft += Int($value7)
											Case 7, 8
												$heightBottomLeft += Int($value7)
										EndSwitch
									EndIf
								Next
							EndIf

							If IsArray($g_aiCSVSweeperPos) Then
								For $i = 0 To UBound($g_aiCSVSweeperPos) - 1
									Local $pixel = $g_aiCSVSweeperPos[$i]
									If UBound($pixel) = 2 Then
										Switch StringLeft(Slice8($pixel), 1)
											Case 1, 2
												$heightBottomRight += Int($value8)
											Case 3, 4
												$heightTopRight += Int($value8)
											Case 5, 6
												$heightTopLeft += Int($value8)
											Case 7, 8
												$heightBottomLeft += Int($value8)
										EndSwitch
									EndIf
								Next
							EndIf

							If IsArray($g_aiCSVMonolithPos) Then
								For $i = 0 To UBound($g_aiCSVMonolithPos) - 1
									Local $pixel = $g_aiCSVMonolithPos[$i]
									If UBound($pixel) = 2 Then
										Switch StringLeft(Slice8($pixel), 1)
											Case 1, 2
												$heightBottomRight += Int($value9)
											Case 3, 4
												$heightTopRight += Int($value9)
											Case 5, 6
												$heightTopLeft += Int($value9)
											Case 7, 8
												$heightBottomLeft += Int($value9)
										EndSwitch
									EndIf
								Next
							EndIf

							If IsArray($g_aiCSVFireSpitterPos) Then
								For $i = 0 To UBound($g_aiCSVFireSpitterPos) - 1
									Local $pixel = $g_aiCSVFireSpitterPos[$i]
									If UBound($pixel) = 2 Then
										Switch StringLeft(Slice8($pixel), 1)
											Case 1, 2
												$heightBottomRight += Int($value10)
											Case 3, 4
												$heightTopRight += Int($value10)
											Case 5, 6
												$heightTopLeft += Int($value10)
											Case 7, 8
												$heightBottomLeft += Int($value10)
										EndSwitch
									EndIf
								Next
							EndIf

							If IsArray($g_aiCSVMultiArcherTowerPos) Then
								For $i = 0 To UBound($g_aiCSVMultiArcherTowerPos) - 1
									Local $pixel = $g_aiCSVMultiArcherTowerPos[$i]
									If UBound($pixel) = 2 Then
										Switch StringLeft(Slice8($pixel), 1)
											Case 1, 2
												$heightBottomRight += Int($value11)
											Case 3, 4
												$heightTopRight += Int($value11)
											Case 5, 6
												$heightTopLeft += Int($value11)
											Case 7, 8
												$heightBottomLeft += Int($value11)
										EndSwitch
									EndIf
								Next
							EndIf

							If IsArray($g_aiCSVMultiGearTowerPos) Then
								For $i = 0 To UBound($g_aiCSVMultiGearTowerPos) - 1
									Local $pixel = $g_aiCSVMultiGearTowerPos[$i]
									If UBound($pixel) = 2 Then
										Switch StringLeft(Slice8($pixel), 1)
											Case 1, 2
												$heightBottomRight += Int($value12)
											Case 3, 4
												$heightTopRight += Int($value12)
											Case 5, 6
												$heightTopLeft += Int($value12)
											Case 7, 8
												$heightBottomLeft += Int($value12)
										EndSwitch
									EndIf
								Next
							EndIf

							If IsArray($g_aiCSVRicochetCannonPos) Then
								For $i = 0 To UBound($g_aiCSVRicochetCannonPos) - 1
									Local $pixel = $g_aiCSVRicochetCannonPos[$i]
									If UBound($pixel) = 2 Then
										Switch StringLeft(Slice8($pixel), 1)
											Case 1, 2
												$heightBottomRight += Int($value13)
											Case 3, 4
												$heightTopRight += Int($value13)
											Case 5, 6
												$heightTopLeft += Int($value13)
											Case 7, 8
												$heightBottomLeft += Int($value13)
										EndSwitch
									EndIf
								Next
							EndIf

							If IsArray($g_aiCSVRevengeTowerPos) Then
								For $i = 0 To UBound($g_aiCSVRevengeTowerPos) - 1
									Local $pixel = $g_aiCSVRevengeTowerPos[$i]
									If UBound($pixel) = 2 Then
										Switch StringLeft(Slice8($pixel), 1)
											Case 1, 2
												$heightBottomRight += Int($value14)
											Case 3, 4
												$heightTopRight += Int($value14)
											Case 5, 6
												$heightTopLeft += Int($value14)
											Case 7, 8
												$heightBottomLeft += Int($value14)
										EndSwitch
									EndIf
								Next
							EndIf

							Local $maxValue = $heightBottomRight
							Local $sidename = "BOTTOM-RIGHT"

							If $heightTopLeft > $maxValue Then
								$maxValue = $heightTopLeft
								$sidename = "TOP-LEFT"
							EndIf

							If $heightTopRight > $maxValue Then
								$maxValue = $heightTopRight
								$sidename = "TOP-RIGHT"
							EndIf

							If $heightBottomLeft > $maxValue Then
								$maxValue = $heightBottomLeft
								$sidename = "BOTTOM-LEFT"
							EndIf

							SetLog("New Mainside: " & $sidename & " (top-left:" & $heightTopLeft & " top-right:" & $heightTopRight & " bottom-left:" & $heightBottomLeft & " bottom-right:" & $heightBottomRight, $COLOR_INFO)
							$MAINSIDE = $sidename
						EndIf
						Switch $MAINSIDE
							Case "BOTTOM-RIGHT"
								$FRONT_LEFT = "BOTTOM-RIGHT-DOWN"
								$FRONT_RIGHT = "BOTTOM-RIGHT-UP"
								$RIGHT_FRONT = "TOP-RIGHT-DOWN"
								$RIGHT_BACK = "TOP-RIGHT-UP"
								$LEFT_FRONT = "BOTTOM-LEFT-DOWN"
								$LEFT_BACK = "BOTTOM-LEFT-UP"
								$BACK_LEFT = "TOP-LEFT-DOWN"
								$BACK_RIGHT = "TOP-LEFT-UP"
							Case "BOTTOM-LEFT"
								$FRONT_LEFT = "BOTTOM-LEFT-UP"
								$FRONT_RIGHT = "BOTTOM-LEFT-DOWN"
								$RIGHT_FRONT = "BOTTOM-RIGHT-DOWN"
								$RIGHT_BACK = "BOTTOM-RIGHT-UP"
								$LEFT_FRONT = "TOP-LEFT-DOWN"
								$LEFT_BACK = "TOP-LEFT-UP"
								$BACK_LEFT = "TOP-RIGHT-UP"
								$BACK_RIGHT = "TOP-RIGHT-DOWN"
							Case "TOP-LEFT"
								$FRONT_LEFT = "TOP-LEFT-UP"
								$FRONT_RIGHT = "TOP-LEFT-DOWN"
								$RIGHT_FRONT = "BOTTOM-LEFT-UP"
								$RIGHT_BACK = "BOTTOM-LEFT-DOWN"
								$LEFT_FRONT = "TOP-RIGHT-UP"
								$LEFT_BACK = "TOP-RIGHT-DOWN"
								$BACK_LEFT = "BOTTOM-RIGHT-UP"
								$BACK_RIGHT = "BOTTOM-RIGHT-DOWN"
							Case "TOP-RIGHT"
								$FRONT_LEFT = "TOP-RIGHT-DOWN"
								$FRONT_RIGHT = "TOP-RIGHT-UP"
								$RIGHT_FRONT = "TOP-LEFT-UP"
								$RIGHT_BACK = "TOP-LEFT-DOWN"
								$LEFT_FRONT = "BOTTOM-RIGHT-UP"
								$LEFT_BACK = "BOTTOM-RIGHT-DOWN"
								$BACK_LEFT = "BOTTOM-LEFT-DOWN"
								$BACK_RIGHT = "BOTTOM-LEFT-UP"
						EndSwitch

					Case Else
						SetLog("No 'SIDE' or 'SIDEB' csv line found, using default attack side: " & $MAINSIDE)
				EndSwitch
			EndIf
		If _Sleep($DELAYRESPOND) Then Return ; check for pause/stop after each line of CSV
		Next
		ReleaseClicks()
	Else
		SetLog("Cannot find attack file " & $g_sCSVAttacksPath & "\" & $filename & ".csv", $COLOR_ERROR)
	EndIf
	Return $MAINSIDE
EndFunc   ;==>ParseAttackCSV_MainSide

