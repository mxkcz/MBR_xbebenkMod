; #FUNCTION# ====================================================================================================================
; Name ..........: MakeDropPoints
; Description ...:
; Syntax ........: MakeDropPoints($side, $pointsQty, $addtiles, $versus[, $randomx = 2[, $randomy = 2]])
; Parameters ....: $side                -
;                  $pointsQty           -
;                  $addtiles            -
;                  $versus              -
;                  $randomx             - [optional] an unknown value. Default is 2.
;                  $randomy             - [optional] an unknown value. Default is 2.
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func MakeDropPoints($side, $pointsQty, $addtiles, $versus, $randomx = 2, $randomy = 2)
	debugAttackCSV("make for side " & $side)
	Local $Vector, $Output = ""
	Local $rndx = Random(0, Abs(Int($randomx)), 1)
	Local $rndy = Random(0, Abs(Int($randomy)), 1)
	If $side = "RANDOM" Then
	EndIf
	Switch $side
		Case "TOP-LEFT-DOWN"
			Local $Vector = $g_aiPixelTopLeftDOWNDropLine
		Case "TOP-LEFT-UP"
			Local $Vector = $g_aiPixelTopLeftUPDropLine
		Case "TOP-RIGHT-DOWN"
			Local $Vector = $g_aiPixelTopRightDOWNDropLine
		Case "TOP-RIGHT-UP"
			Local $Vector = $g_aiPixelTopRightUPDropLine
		Case "BOTTOM-LEFT-UP"
			Local $Vector = $g_aiPixelBottomLeftUPDropLine
		Case "BOTTOM-LEFT-DOWN"
			Local $Vector = $g_aiPixelBottomLeftDOWNDropLine
		Case "BOTTOM-RIGHT-UP"
			Local $Vector = $g_aiPixelBottomRightUPDropLine
		Case "BOTTOM-RIGHT-DOWN"
			Local $Vector = $g_aiPixelBottomRightDOWNDropLine
		Case Else
	EndSwitch
	If $versus = "IGNORE" Then $versus = "EXT-INT" ; error proof use input if misuse targeted MAKE command
	If Not IsArray($Vector) Or UBound($Vector) = 0 Then
		SetLog("MakeDropPoints: empty vector for side " & $side, $COLOR_WARNING)
		SetError(1, 0, 0)
		Return 0
	EndIf
	If Int($pointsQty) > 0 Then
		Local $pointsQtyCleaned = Abs(Int($pointsQty))
	Else
		Local $pointsQtyCleaned = 1
	EndIf
	Local $p = Int(UBound($Vector) / $pointsQtyCleaned)
	If $p = 0 Then $p = 1
	Local $x = 0
	Local $y = 0

	Local $str = ""
	For $i = 0 To UBound($Vector) - 1
		Local $pixel = $Vector[$i]
		$str &= $pixel[0] & "-" & $pixel[1] & "|"
	Next

	Switch $side & "|" & $versus
		Case "TOP-LEFT-DOWN|INT-EXT", "TOP-LEFT-UP|EXT-INT", "TOP-RIGHT-DOWN|EXT-INT", "TOP-RIGHT-UP|INT-EXT", "BOTTOM-LEFT-DOWN|EXT-INT", "BOTTOM-LEFT-UP|INT-EXT", "BOTTOM-RIGHT-DOWN|INT-EXT", "BOTTOM-RIGHT-UP|EXT-INT"
			;From right to left
			For $i = UBound($Vector) To 1 Step -1
				$pixel = $Vector[$i - 1]
				$x += $pixel[0]
				$y += $pixel[1]
				If Mod(UBound($Vector) - $i + 1, $p) = 0 Then
					For $u = 8 * Abs(Int($addtiles)) To 0 Step -1
						If Int($addtiles) > 0 Then
							Local $l = $u
						Else
							Local $l = -$u
						EndIf
						Switch $side
							Case "TOP-LEFT-UP", "TOP-LEFT-DOWN"
								Local $x1 = Round($x / $p) - $l
								Local $y1 = Round($y / $p) - $l
								Local $x2 = Round($x / $p) - $l - $rndx
								Local $y2 = Round($y / $p) - $l - $rndy
							Case "TOP-RIGHT-UP", "TOP-RIGHT-DOWN"
								Local $x1 = Round($x / $p) + $l
								Local $y1 = Round($y / $p) - $l
								Local $x2 = Round($x / $p) + $l + $rndx
								Local $y2 = Round($y / $p) - $l - $rndy
							Case "BOTTOM-LEFT-UP", "BOTTOM-LEFT-DOWN"
								Local $x1 = Round($x / $p) - $l
								Local $y1 = Round($y / $p) + $l
								Local $x2 = Round($x / $p) - $l - $rndx
								Local $y2 = Round($y / $p) + $l + $rndy
							Case "BOTTOM-RIGHT-UP", "BOTTOM-RIGHT-DOWN"
								Local $x1 = Round($x / $p) + $l
								Local $y1 = Round($y / $p) + $l
								Local $x2 = Round($x / $p) + $l + $rndx
								Local $y2 = Round($y / $p) + $l + $rndy
							Case Else
						EndSwitch
						$pixel = StringSplit($x2 & "-" & $y2, "-", 2)
						If isInsideDiamondRedArea($pixel) Then ExitLoop
					Next
					$pixel = StringSplit($x2 & "-" & $y2, "-", 2)
					$Output &= $pixel[0] & "-" & $pixel[1] & "|"
					$x = 0
					$y = 0
				EndIf
			Next
		Case "TOP-LEFT-DOWN|EXT-INT", "TOP-LEFT-UP|INT-EXT", "TOP-RIGHT-DOWN|INT-EXT", "TOP-RIGHT-UP|EXT-INT", "BOTTOM-LEFT-DOWN|INT-EXT", "BOTTOM-LEFT-UP|EXT-INT", "BOTTOM-RIGHT-DOWN|EXT-INT", "BOTTOM-RIGHT-UP|INT-EXT"
			;From left to right
			For $i = 1 To UBound($Vector)
				$pixel = $Vector[$i - 1]
				$x += $pixel[0]
				$y += $pixel[1]
				If Mod($i, $p) = 0 Then
					For $u = 8 * Abs(Int($addtiles)) To 0 Step -1
						If Int($addtiles) > 0 Then
							Local $l = $u
						Else
							Local $l = -$u
						EndIf
						Switch $side
							Case "TOP-LEFT-UP", "TOP-LEFT-DOWN"
								Local $x1 = Round($x / $p) - $l
								Local $y1 = Round($y / $p) - $l
								Local $x2 = Round($x / $p) - $l - $rndx
								Local $y2 = Round($y / $p) - $l - $rndy
							Case "TOP-RIGHT-UP", "TOP-RIGHT-DOWN"
								Local $x1 = Round($x / $p) + $l
								Local $y1 = Round($y / $p) - $l
								Local $x2 = Round($x / $p) + $l + $rndx
								Local $y2 = Round($y / $p) - $l - $rndy
							Case "BOTTOM-LEFT-UP", "BOTTOM-LEFT-DOWN"
								Local $x1 = Round($x / $p) - $l
								Local $y1 = Round($y / $p) + $l
								Local $x2 = Round($x / $p) - $l - $rndx
								Local $y2 = Round($y / $p) + $l + $rndy
							Case "BOTTOM-RIGHT-UP", "BOTTOM-RIGHT-DOWN"
								Local $x1 = Round($x / $p) + $l
								Local $y1 = Round($y / $p) + $l
								Local $x2 = Round($x / $p) + $l + $rndx
								Local $y2 = Round($y / $p) + $l + $rndy
							Case Else
						EndSwitch
						$pixel = StringSplit($x2 & "-" & $y2, "-", 2)
						If isInsideDiamondRedArea($pixel) Then ExitLoop
					Next
					$pixel = StringSplit($x2 & "-" & $y2, "-", 2)
					$Output &= $pixel[0] & "-" & $pixel[1] & "|"
					$x = 0
					$y = 0
				EndIf
			Next

		Case Else
	EndSwitch

	If StringLen($Output) > 0 Then $Output = StringLeft($Output, StringLen($Output) - 1)
	If StringLen($Output) = 0 Then
		SetLog("MakeDropPoints: no output generated for side " & $side & " (" & $versus & ")", $COLOR_WARNING)
		SetError(2, 0, 0)
		Return 0
	EndIf
	Return GetListPixel($Output)
EndFunc   ;==>MakeDropPoints


; #FUNCTION# ====================================================================================================================
; Name ..........: MakeTargetDropPoints
; Description ...:
; Syntax ........: MakeTargetDropPoints($side, $pointsQty, $addtiles, $building)
; Parameters ....: $side                - a string, target side string ($sidex)
;                  $pointsQty           - a integer Drop point count can be 1 or 5 value only ($value3)
;                  $addtiles            - a integer, Ignore if $pointsqty = 5, only used when dropping in sigle point ($value4)
;                  $building            - a enum value, building target for drop points ($value8)
; Return values .: PointQty =1: single x,y array
;					  : 			 =5: Array with 5 x,y points
; @error values  : 1 = Bad defense name
;					  : 2 = dictionary value for defense missing
;					  : 3 = dictionary value of defense was not array
; 					  : 4 = strange programming error?
; Author ........: MonkeyHunter (05-2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func MakeTargetDropPoints($side, $pointsQty, $addtiles, $building)
	;MakeTargetDropPoints(Eval($sidex), $value3,   $value4,   $value8))

	debugAttackCSV("make for side " & $side & ", target: " & $building)

	Local $Vector, $Output = ""
	Local $x, $y
	Local $sLoc, $aLocation[2], $pixel[2], $BuildingEnum, $result, $array
	Local $bPrioLocation = False

	Switch $building ; translate CSV building name into building enum
		Case "PRIO"
			Local $sResolved = ""
			$BuildingEnum = _CSVPrioResolveBuilding($side, $sResolved, $aLocation)
			If @error Then
				SetLog("PRIO target: no weighted defense found on " & $side, $COLOR_WARNING)
				SetError(@error, 0, "")
				Return
			EndIf
			$building = $sResolved
			$bPrioLocation = True
		Case "TOWNHALL"
			$BuildingEnum = $eBldgTownHall
		Case "EAGLE"
			$BuildingEnum = $eBldgEagle
		Case "INFERNO"
			$BuildingEnum = $eBldgInferno
		Case "XBOW"
			$BuildingEnum = $eBldgXBow
		Case "WIZTOWER"
			$BuildingEnum = $eBldgWizTower
		Case "MORTAR"
			$BuildingEnum = $eBldgMortar
		Case "AIRDEFENSE"
			$BuildingEnum = $eBldgAirDefense
		Case "SWEEPER"
			$BuildingEnum = $eBldgSweeper
		Case "MONOLITH"
			$BuildingEnum = $eBldgMonolith
		Case "FIRESPITTER"
			$BuildingEnum = $eBldgFireSpitter
		Case "MULTIARCHER"
			$BuildingEnum = $eBldgMultiArcherTower
		Case "MULTIGEAR"
			$BuildingEnum = $eBldgMultiGearTower
		Case "RICOCHETCA"
			$BuildingEnum = $eBldgRicochetCannon
		Case "SUPERWIZTW"
			$BuildingEnum = $eBldgSuperWizTower
		Case "REVENGETW"
			$BuildingEnum = $eBldgRevengeTower
		Case "EX-WALL"
			$BuildingEnum = $eExternalWall
		Case "IN-WALL"
			$BuildingEnum = $eInternalWall
		Case "SCATTER"
			$BuildingEnum = $eBldgScatter
		Case Else
			SetLog("Defense name not understood", $COLOR_ERROR) ; impossible error as value is checked earlier
			SetError(1, 0, "")
			Return
	EndSwitch

	If Not $bPrioLocation Then
		Local $aBuildingLoc = _ObjGetValue($g_oBldgAttackInfo, $BuildingEnum & "_LOCATION")

		If @error Then
			_ObjErrMsg("_ObjGetValue " & $g_sBldgNames[$BuildingEnum] & " _LOCATION", @error) ; Log errors
			SetError(2, 0, "")
			Return
		EndIf

		If IsArray($aBuildingLoc) Then
			If UBound($aBuildingLoc, 1) > 1 And IsArray($aBuildingLoc[1]) Then ; cycle thru all building locations
				Local $bFoundLocation = False
				For $p = 0 To UBound($aBuildingLoc) - 1
					$array = $aBuildingLoc[$p] ; pull sub-array from inside location array
					$result = IsPointOnSide($array, $side) ; Determine if target building on side specified
					If @error Then ; not normal
						Return SetError(4, 0, "")
					EndIf
					If $result = True Then
						_CSVPrioCopyPoint($aLocation, $aBuildingLoc[$p]) ; 1st building location found is used
						$bFoundLocation = True
						ExitLoop
					EndIf
				Next
				If Not $bFoundLocation Then
					SetLog($g_sBldgNames[$BuildingEnum] & " not in side:" & $side, $COLOR_ERROR)
					Return SetError(3, 0, "")
				EndIf
			Else ; use only building found even if not on user chosen side?
				_CSVPrioCopyPoint($aLocation, $aBuildingLoc[0])
			EndIf
		Else
			SetLog($g_sBldgNames[$BuildingEnum] & " _LOCATION not an array", $COLOR_ERROR)
			Return SetError(3, 0, "")
		EndIf
	ElseIf Not IsArray($aLocation) Then
		SetLog("PRIO target location not found for " & $g_sBldgNames[$BuildingEnum], $COLOR_ERROR)
		Return SetError(3, 0, "")
	EndIf

	Switch Int($pointsQty) ; Create vector
		Case 1 ; drop point here is single point on side specified
			$x += $aLocation[0]
			$y += $aLocation[1]
			; use ADDTILES * 8 pixels per tile to add offset to vector location
			For $u = 8 * Abs(Int($addtiles)) To 0 Step -1 ; count down to zero pixels till find valid drop point
				If Int($addtiles) > 0 Then ; adjust for positive or negative ADDTILES value
					Local $l = $u
				Else
					Local $l = -$u
				EndIf
				Switch $side
					Case "TOP-LEFT-UP", "TOP-LEFT-DOWN"
						$pixel[0] = $x - $l
						$pixel[1] = $y - $l
					Case "TOP-RIGHT-UP", "TOP-RIGHT-DOWN"
						$pixel[0] = $x + $l
						$pixel[1] = $y - $l
					Case "BOTTOM-LEFT-UP", "BOTTOM-LEFT-DOWN"
						$pixel[0] = $x - $l
						$pixel[1] = $y + $l
					Case "BOTTOM-RIGHT-UP", "BOTTOM-RIGHT-DOWN"
						$pixel[0] = $x + $l
						$pixel[1] = $y + $l
					Case Else
						SetLog("Silly code monkey 'MAKE' TargetDropPoints mistake", $COLOR_ERROR)
						SetError(5, 0, "")
						Return
				EndSwitch
				If isInsideDiamondRedArea($pixel) Then ExitLoop
			Next
			If Not isInsideDiamondRedArea($pixel) Then SetDebugLog("MakeTargetDropPoints() ADDTILES error!")
			$sLoc = $pixel[0] & "-" & $pixel[1] ; make string for modified building location
			SetLog("Target drop point for " &  $g_sBldgNames[$BuildingEnum] & " (adding " & $addtiles & " tiles): " & $sLoc)
			Return GetListPixel($sLoc, "-", "MakeTargetDropPoints TARGET") ; return ADDTILES modified location array
		Case 5
			$sLoc = $aLocation[0] & "," & $aLocation[1] ; make string for bldg location
			$Output = GetDeployableNextTo($sLoc, 10, $g_oBldgAttackInfo.item($eBldgRedLine & "_OBJECTPOINTS")) ; Get 5 near points, 10 pixels outisde red line for drop
			If StringLen($Output) = 0 Then
				SetLog("MakeTargetDropPoints: no near points found for " & $g_sBldgNames[$BuildingEnum], $COLOR_WARNING)
				SetError(5, 0, "")
				Return
			EndIf
			Return GetListPixel($Output, ",", "MakeTargetDropPoints NEARPOINTS") ;imgloc DLL calls return comma separated values
		Case Else
			; impossible?
			SetLog("Strange MakeTargetDropPoint Error", $COLOR_ERROR)
			Return SetError(6, 0, "")
	EndSwitch

EndFunc   ;==>MakeTargetDropPoints

; Side-effect: io (clears PRIO caches)
Func _CSVPrioResetCache()
	If IsObj($g_oCSVPrioTargets) Then $g_oCSVPrioTargets.RemoveAll()
	If IsObj($g_oCSVPrioIndexes) Then $g_oCSVPrioIndexes.RemoveAll()
EndFunc   ;==>_CSVPrioResetCache

; Side-effect: impure-deterministic (reads weight and building location data)
Func _CSVPrioResolveBuilding($side, ByRef $sResolved, ByRef $aLocation)
	Local $sSideKey = _CSVPrioGetSideKey($side)
	If @error Then
		SetError(7, 0, "")
		Return -1
	EndIf

	Local $aTargets = _CSVPrioGetTargetsForSide($sSideKey)
	If @error Or Not IsArray($aTargets) Or UBound($aTargets) = 0 Then
		SetError(7, 0, "")
		Return -1
	EndIf

	Local $iIndex = _CSVPrioNextIndex($sSideKey)
	If $iIndex < 0 Or $iIndex >= UBound($aTargets) Then
		SetError(7, 0, "")
		Return -1
	EndIf

	$sResolved = $aTargets[$iIndex][1]
	_CSVPrioAssignPoint($aLocation, $aTargets[$iIndex][2], $aTargets[$iIndex][3])
	SetDebugLog("CSV PRIO[" & ($iIndex + 1) & "]: " & $sResolved & " @" & $aLocation[0] & "," & $aLocation[1] & " side=" & $sSideKey)
	Return $aTargets[$iIndex][0]
EndFunc   ;==>_CSVPrioResolveBuilding

; Side-effect: impure-deterministic (reads building location data)
Func _CSVPrioGetTargetsForSide($sSideKey)
	If IsObj($g_oCSVPrioTargets) And $g_oCSVPrioTargets.Exists($sSideKey) Then
		Return $g_oCSVPrioTargets.Item($sSideKey)
	EndIf

	Local $sSideCheck = _CSVPrioGetSideCheck($sSideKey)
	If @error Then Return SetError(1, 0, 0)
	Local $aTargets = _CSVPrioBuildTargetsForSide($sSideKey, $sSideCheck)
	If Not IsArray($aTargets) Or UBound($aTargets) = 0 Then Return SetError(2, 0, 0)

	_CSVPrioSortTargets($aTargets)
	If IsObj($g_oCSVPrioTargets) Then $g_oCSVPrioTargets.Item($sSideKey) = $aTargets
	Return $aTargets
EndFunc   ;==>_CSVPrioGetTargetsForSide

; Side-effect: impure-deterministic (reads building location data)
Func _CSVPrioBuildTargetsForSide($sSideKey, $sSideCheck)
	Local $aTargets[0][6]
	Local $aSideMid[2]
	If _CSVPrioGetSideMid($sSideKey, $aSideMid) = 0 Then Return $aTargets

	Local $aCandidateEnum[15] = [$eBldgEagle, $eBldgInferno, $eBldgXBow, $eBldgSuperWizTower, $eBldgWizTower, $eBldgMortar, $eBldgAirDefense, _
			$eBldgScatter, $eBldgSweeper, $eBldgMonolith, $eBldgFireSpitter, $eBldgMultiArcherTower, $eBldgMultiGearTower, $eBldgRicochetCannon, $eBldgRevengeTower]
	Local $aCandidateName[15] = ["EAGLE", "INFERNO", "XBOW", "SUPERWIZTW", "WIZTOWER", "MORTAR", "AIRDEFENSE", _
			"SCATTER", "SWEEPER", "MONOLITH", "FIRESPITTER", "MULTIARCHER", "MULTIGEAR", "RICOCHETCA", "REVENGETW"]
	Local $aWeightIndex[15] = [0, 1, 2, 3, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]

	For $i = 0 To UBound($aCandidateEnum) - 1
		Local $iWeightIndex = $aWeightIndex[$i]
		If $iWeightIndex < 0 Or $iWeightIndex >= UBound($g_aiCSVSideBWeights) Then ContinueLoop
		Local $iWeight = $g_aiCSVSideBWeights[$iWeightIndex]
		If $iWeight <= 0 Then ContinueLoop

		Local $aLoc = _ObjGetValue($g_oBldgAttackInfo, $aCandidateEnum[$i] & "_LOCATION")
		If @error Or Not IsArray($aLoc) Then ContinueLoop
		If UBound($aLoc, 1) > 1 And IsArray($aLoc[1]) Then
			For $j = 0 To UBound($aLoc) - 1
				Local $aPoint = $aLoc[$j]
				If Not IsArray($aPoint) Then ContinueLoop
				If Not IsPointOnSide($aPoint, $sSideCheck) Then ContinueLoop
				_CSVPrioAddTarget($aTargets, $aCandidateEnum[$i], $aCandidateName[$i], $aPoint, $iWeight, GetPixelDistance($aPoint, $aSideMid))
			Next
		Else
			Local $aPoint = $aLoc[0]
			If IsArray($aPoint) And IsPointOnSide($aPoint, $sSideCheck) Then
				_CSVPrioAddTarget($aTargets, $aCandidateEnum[$i], $aCandidateName[$i], $aPoint, $iWeight, GetPixelDistance($aPoint, $aSideMid))
			EndIf
		EndIf
	Next

	Return $aTargets
EndFunc   ;==>_CSVPrioBuildTargetsForSide

; Side-effect: pure
Func _CSVPrioGetSideKey($side)
	Local $sSide = StringUpper($side)
	If StringInStr($sSide, "TOP-LEFT") > 0 Then Return "TOP-LEFT"
	If StringInStr($sSide, "TOP-RIGHT") > 0 Then Return "TOP-RIGHT"
	If StringInStr($sSide, "BOTTOM-LEFT") > 0 Then Return "BOTTOM-LEFT"
	If StringInStr($sSide, "BOTTOM-RIGHT") > 0 Then Return "BOTTOM-RIGHT"
	Return SetError(1, 0, "")
EndFunc   ;==>_CSVPrioGetSideKey

; Side-effect: pure
Func _CSVPrioGetSideCheck($sSideKey)
	Switch $sSideKey
		Case "TOP-LEFT"
			Return "TOP-LEFT-UP"
		Case "TOP-RIGHT"
			Return "TOP-RIGHT-UP"
		Case "BOTTOM-LEFT"
			Return "BOTTOM-LEFT-UP"
		Case "BOTTOM-RIGHT"
			Return "BOTTOM-RIGHT-UP"
		Case Else
			Return SetError(1, 0, "")
	EndSwitch
EndFunc   ;==>_CSVPrioGetSideCheck

; Side-effect: pure
Func _CSVPrioGetSideMid($sSideKey, ByRef $aMid)
	Switch $sSideKey
		Case "TOP-LEFT"
			_CSVPrioAssignPoint($aMid, $ExternalArea[4][0], $ExternalArea[4][1])
		Case "TOP-RIGHT"
			_CSVPrioAssignPoint($aMid, $ExternalArea[5][0], $ExternalArea[5][1])
		Case "BOTTOM-LEFT"
			_CSVPrioAssignPoint($aMid, $ExternalArea[6][0], $ExternalArea[6][1])
		Case "BOTTOM-RIGHT"
			_CSVPrioAssignPoint($aMid, $ExternalArea[7][0], $ExternalArea[7][1])
		Case Else
			Return SetError(1, 0, 0)
	EndSwitch
	Return 1
EndFunc   ;==>_CSVPrioGetSideMid

; Side-effect: pure
Func _CSVPrioAddTarget(ByRef $aTargets, $iEnum, $sName, $aPoint, $iWeight, $iDistance)
	Local $iSize = UBound($aTargets)
	ReDim $aTargets[$iSize + 1][6]
	$aTargets[$iSize][0] = $iEnum
	$aTargets[$iSize][1] = $sName
	$aTargets[$iSize][2] = $aPoint[0]
	$aTargets[$iSize][3] = $aPoint[1]
	$aTargets[$iSize][4] = $iWeight
	$aTargets[$iSize][5] = $iDistance
EndFunc   ;==>_CSVPrioAddTarget

; Side-effect: pure
Func _CSVPrioAssignPoint(ByRef $aTarget, $x, $y)
	Local $aTemp[2]
	$aTemp[0] = $x
	$aTemp[1] = $y
	$aTarget = $aTemp
	Return 1
EndFunc   ;==>_CSVPrioAssignPoint

; Side-effect: pure
Func _CSVPrioCopyPoint(ByRef $aTarget, $aPoint)
	If Not IsArray($aPoint) Then Return SetError(1, 0, 0)
	Return _CSVPrioAssignPoint($aTarget, $aPoint[0], $aPoint[1])
EndFunc   ;==>_CSVPrioCopyPoint

; Side-effect: pure
Func _CSVPrioSortTargets(ByRef $aTargets)
	For $i = 0 To UBound($aTargets) - 2
		For $j = $i + 1 To UBound($aTargets) - 1
			If $aTargets[$j][4] > $aTargets[$i][4] Or ($aTargets[$j][4] = $aTargets[$i][4] And $aTargets[$j][5] < $aTargets[$i][5]) Then
				_CSVPrioSwapTargets($aTargets, $i, $j)
			EndIf
		Next
	Next
EndFunc   ;==>_CSVPrioSortTargets

; Side-effect: pure
Func _CSVPrioSwapTargets(ByRef $aTargets, $i, $j)
	Local $aTemp[6]
	For $c = 0 To 5
		$aTemp[$c] = $aTargets[$i][$c]
	Next
	For $c = 0 To 5
		$aTargets[$i][$c] = $aTargets[$j][$c]
		$aTargets[$j][$c] = $aTemp[$c]
	Next
EndFunc   ;==>_CSVPrioSwapTargets

; Side-effect: impure-deterministic (updates PRIO counter)
Func _CSVPrioNextIndex($sSideKey)
	Local $iIndex = 0
	If IsObj($g_oCSVPrioIndexes) And $g_oCSVPrioIndexes.Exists($sSideKey) Then
		$iIndex = $g_oCSVPrioIndexes.Item($sSideKey)
	EndIf
	If IsObj($g_oCSVPrioIndexes) Then $g_oCSVPrioIndexes.Item($sSideKey) = $iIndex + 1
	Return $iIndex
EndFunc   ;==>_CSVPrioNextIndex

