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
		Local $aEmpty[0]
		Return SetError(1, 0, $aEmpty)
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
		Local $aEmpty[0]
		Return SetError(2, 0, $aEmpty)
	EndIf
	Return GetListPixel($Output)
EndFunc   ;==>MakeDropPoints

; #FUNCTION# ====================================================================================================================
; Name ..........: AttackCSV_ScanMakeUsage
; Description ...: Pre-scan CSV MAKE commands to determine which sides require droplines and if all MAKEs are targeted.
; Syntax ........: AttackCSV_ScanMakeUsage($sFilename, ByRef $aSidesUsed, ByRef $bAllMakeTargeted)
; Parameters ....: $sFilename        - CSV script name without extension.
;                  $aSidesUsed       - [in/out] Array [TL, TR, BL, BR] of used sides (Boolean).
;                  $bAllMakeTargeted - [in/out] True if all MAKE commands are targeted (no dropline needed).
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
; Side-effect: io (reads CSV file), impure-deterministic (depends on current script/side mapping)
Func AttackCSV_ScanMakeUsage($sFilename, ByRef $aSidesUsed, ByRef $bAllMakeTargeted)
	Local $aSideFlags[4] = [False, False, False, False] ; TL, TR, BL, BR
	Local $bFoundMake = False
	Local $bAllTargeted = True
	Local $aLines, $aTokens

	If Not _CSVGetCachedLinesAndTokens($sFilename, $aLines, $aTokens) Then
		$aSidesUsed = $aSideFlags
		$bAllMakeTargeted = False
		Return SetError(1, 0, 0)
	EndIf

	For $iLine = 0 To UBound($aLines) - 1
		Local $acommand = $aTokens[$iLine]
		If Not IsArray($acommand) Then $acommand = StringSplit($aLines[$iLine], "|")
		If $acommand[0] < 8 Then ContinueLoop
		Local $command = StringStripWS(StringUpper($acommand[1]), $STR_STRIPTRAILING)
		If $command <> "MAKE" Then ContinueLoop

		$bFoundMake = True
		Local $value2 = ($acommand[0] >= 3 ? StringStripWS(StringUpper($acommand[3]), $STR_STRIPTRAILING) : "")
		Local $value8 = ($acommand[0] >= 9 ? StringStripWS(StringUpper($acommand[9]), $STR_STRIPTRAILING) : "")
		Local $bTargeted = CheckCsvValues("MAKE", 8, $value8)
		If $bTargeted Then ContinueLoop

		$bAllTargeted = False
		If Not CheckCsvValues("MAKE", 2, $value2) Then ContinueLoop

		If $value2 = "RANDOM" Then
			$aSideFlags[0] = True
			$aSideFlags[1] = True
			$aSideFlags[2] = True
			$aSideFlags[3] = True
			ContinueLoop
		EndIf

		Local $sidex = StringReplace($value2, "-", "_")
		Local $sResolved = Eval($sidex)
		If $sResolved = "" Then $sResolved = $value2
		Local $bMatched = False

		If StringInStr($sResolved, "TOP-LEFT") Then
			$aSideFlags[0] = True
			$bMatched = True
		EndIf
		If StringInStr($sResolved, "TOP-RIGHT") Then
			$aSideFlags[1] = True
			$bMatched = True
		EndIf
		If StringInStr($sResolved, "BOTTOM-LEFT") Then
			$aSideFlags[2] = True
			$bMatched = True
		EndIf
		If StringInStr($sResolved, "BOTTOM-RIGHT") Then
			$aSideFlags[3] = True
			$bMatched = True
		EndIf

		If Not $bMatched Then
			$aSideFlags[0] = True
			$aSideFlags[1] = True
			$aSideFlags[2] = True
			$aSideFlags[3] = True
			SetDebugLog("CSV MAKE side '" & $value2 & "' unresolved, enabling all dropline sides", $COLOR_WARNING)
		EndIf
	Next

	If Not $bFoundMake Then $bAllTargeted = True
	$aSidesUsed = $aSideFlags
	$bAllMakeTargeted = $bAllTargeted
	Return 1
EndFunc   ;==>AttackCSV_ScanMakeUsage


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
				SetLog("PRIO target unavailable on " & $side & " (err " & @error & ")", $COLOR_WARNING)
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
			Local $sRedline = _ObjGetValue($g_oBldgAttackInfo, $eBldgRedLine & "_OBJECTPOINTS")
			If @error Or $sRedline = "" Then $sRedline = $g_sImglocRedline
			$Output = GetDeployableNextTo($sLoc, 10, $sRedline) ; Get 5 near points, 10 pixels outisde red line for drop
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

; #FUNCTION# ====================================================================================================================
; Name ..........: _CSVPrioGetRedlineKey
; Description ...: Read current redline string to invalidate PRIO caches between villages.
; Syntax ........: _CSVPrioGetRedlineKey()
; Parameters ....: None
; Return values .: Success: redline string (may be empty)
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _CSVPrioGetRedlineKey()
	Local $sKey = ""
	If IsObj($g_oBldgAttackInfo) And _ObjSearch($g_oBldgAttackInfo, $eBldgRedLine & "_OBJECTPOINTS") Then
		$sKey = _ObjGetValue($g_oBldgAttackInfo, $eBldgRedLine & "_OBJECTPOINTS")
		If @error Then $sKey = ""
	EndIf
	If $sKey = "" And $g_sImglocRedline <> "" Then $sKey = $g_sImglocRedline
	Return $sKey
EndFunc   ;==>_CSVPrioGetRedlineKey

; #FUNCTION# ====================================================================================================================
; Name ..........: _CSVPrioSyncRedlineCache
; Description ...: Invalidate PRIO caches when redline changes.
; Syntax ........: _CSVPrioSyncRedlineCache()
; Parameters ....: None
; Return values .: Success: 1 when redline key available
;                  Failure: 0 when redline key missing
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _CSVPrioSyncRedlineCache()
	Local $sKey = _CSVPrioGetRedlineKey()
	If $sKey = "" Then
		If $g_sCSVPrioRedlineKey <> "" Then SetDebugLog("CSV PRIO cache cleared: redline unavailable", $COLOR_WARNING)
		$g_sCSVPrioRedlineKey = ""
		If IsObj($g_oCSVPrioTargets) Then $g_oCSVPrioTargets.RemoveAll()
		If IsObj($g_oCSVPrioPlan) Then $g_oCSVPrioPlan.RemoveAll()
		If IsObj($g_oCSVPrioIndexes) Then $g_oCSVPrioIndexes.RemoveAll()
		Return 0
	EndIf

	If $g_sCSVPrioRedlineKey <> $sKey Then
		$g_sCSVPrioRedlineKey = $sKey
		If IsObj($g_oCSVPrioTargets) Then $g_oCSVPrioTargets.RemoveAll()
		If IsObj($g_oCSVPrioPlan) Then $g_oCSVPrioPlan.RemoveAll()
		If IsObj($g_oCSVPrioIndexes) Then $g_oCSVPrioIndexes.RemoveAll()
		SetDebugLog("CSV PRIO cache reset: redline changed", $COLOR_DEBUG)
	EndIf
	Return 1
EndFunc   ;==>_CSVPrioSyncRedlineCache

; #FUNCTION# ====================================================================================================================
; Name ..........: _CSVPrioResetCache
; Description ...: Reset PRIO plan/index caches while preserving target lists when redline is unchanged.
; Syntax ........: _CSVPrioResetCache()
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
; Side-effect: io (clears PRIO caches)
Func _CSVPrioResetCache()
	_CSVPrioSyncRedlineCache()
	If IsObj($g_oCSVPrioPlan) Then $g_oCSVPrioPlan.RemoveAll()
	If IsObj($g_oCSVPrioIndexes) Then $g_oCSVPrioIndexes.RemoveAll()
EndFunc   ;==>_CSVPrioResetCache

; #FUNCTION# ====================================================================================================================
; Name ..........: _CSVPrioResolveBuilding
; Description ...: Resolve the next PRIO target for a side using cached targets and plan.
; Syntax ........: _CSVPrioResolveBuilding($side, ByRef $sResolved, ByRef $aLocation)
; Parameters ....: $side       - side string (e.g. TOP-LEFT-UP).
;                  $sResolved  - [out] resolved building name.
;                  $aLocation  - [out] resolved target point array.
; Return values .: Success: enum value of resolved building.
;                  Failure: -1 and @error set.
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
; Side-effect: impure-deterministic (reads weight and building location data)
Func _CSVPrioResolveBuilding($side, ByRef $sResolved, ByRef $aLocation)
	Local $sSideKey = _CSVPrioGetSideKey($side)
	If @error Then
		SetError(7, 0, "")
		Return -1
	EndIf

	If _CSVPrioSyncRedlineCache() = 0 Then
		SetError(7, 0, "")
		Return -1
	EndIf

	Local $aTargets = _CSVPrioGetPlanTargets($sSideKey)
	Local $iTargetsErr = @error
	Local $bPlanExists = (IsObj($g_oCSVPrioPlan) And $g_oCSVPrioPlan.Exists($sSideKey))
	If $bPlanExists Then
		If $iTargetsErr Or Not IsArray($aTargets) Or UBound($aTargets) = 0 Then
			SetError(7, 0, "")
			Return -1
		EndIf
	Else
		If $iTargetsErr Or Not IsArray($aTargets) Or UBound($aTargets) = 0 Then
			$aTargets = _CSVPrioGetTargetsForSide($sSideKey)
			$iTargetsErr = @error
			Local $sSideCheck = _CSVPrioGetSideCheck($sSideKey)
			If @error Then
				SetError(7, 0, "")
				Return -1
			EndIf

			Local $aAllTargets = _CSVPrioBuildTargetsForSide($sSideKey, $sSideCheck, True)
			If @error Then $aAllTargets = 0

			If $iTargetsErr Or Not IsArray($aTargets) Or UBound($aTargets) = 0 Then
				If IsArray($aAllTargets) And UBound($aAllTargets) > 0 Then
					SetDebugLog("CSV PRIO fallback: no weighted defense on side " & $sSideKey & ", using previously detected buildings", $COLOR_WARNING)
					$aTargets = $aAllTargets
				Else
					SetError(7, 0, "")
					Return -1
				EndIf
			Else
				Local $iMaxSideWeight = _CSVPrioGetMaxWeight($aTargets)
				Local $iMaxAllWeight = _CSVPrioGetMaxWeight($aAllTargets)
				If $iMaxAllWeight > $iMaxSideWeight Then
					_CSVPrioMergeHighWeightTargets($aTargets, $aAllTargets, $iMaxSideWeight)
					_CSVPrioSortTargets($aTargets)
				EndIf
				If _CSVPrioIsWeaponizedTownHall() Then
					_CSVPrioMergeEnumTargets($aTargets, $aAllTargets, $eBldgTownHall)
					_CSVPrioSortTargets($aTargets)
				EndIf
			EndIf
		EndIf
	EndIf

	Local $iIndex = _CSVPrioNextIndex($sSideKey)
	If $iIndex < 0 Then $iIndex = 0
	If UBound($aTargets) > 0 Then $iIndex = Mod($iIndex, UBound($aTargets))

	$sResolved = $aTargets[$iIndex][1]
	_CSVPrioAssignPoint($aLocation, $aTargets[$iIndex][2], $aTargets[$iIndex][3])
	SetDebugLog("CSV PRIO[" & ($iIndex + 1) & "]: " & $sResolved & " @" & $aLocation[0] & "," & $aLocation[1] & " side=" & $sSideKey)
	Return $aTargets[$iIndex][0]
EndFunc   ;==>_CSVPrioResolveBuilding

; Side-effect: impure-deterministic (reads planned targets)
Func _CSVPrioGetPlanTargets($sSideKey)
	If IsObj($g_oCSVPrioPlan) And $g_oCSVPrioPlan.Exists($sSideKey) Then
		Return $g_oCSVPrioPlan.Item($sSideKey)
	EndIf
	Return SetError(1, 0, 0)
EndFunc   ;==>_CSVPrioGetPlanTargets

; #FUNCTION# ====================================================================================================================
; Name ..........: AttackCSV_PreparePrioPlan
; Description ...: Build PRIO target plans using CSV MAKE order and max building counts.
; Syntax ........: AttackCSV_PreparePrioPlan($sFilename)
; Parameters ....: $sFilename        - CSV script name without extension.
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
; Side-effect: io (reads CSV file), impure-deterministic (updates PRIO plan cache and counters)
Func AttackCSV_PreparePrioPlan($sFilename)
	If Not IsObj($g_oCSVPrioPlan) Then Return SetError(1, 0, 0)
	$g_oCSVPrioPlan.RemoveAll()

	Local $aLines, $aTokens
	If Not _CSVGetCachedLinesAndTokens($sFilename, $aLines, $aTokens) Then Return SetError(2, 0, 0)

	Local $aCandidateEnum, $aCandidateName, $aWeightIndex
	If _CSVGetPrioCandidateMap($aCandidateEnum, $aCandidateName, $aWeightIndex) = 0 Then Return SetError(3, 0, 0)

	Local $aExplicitCounts[4][UBound($aCandidateEnum)]
	Local $aExplicitTH[4]
	Local $aPrioCount[4]
	Local $bHasPrio = False

	For $iLine = 0 To UBound($aLines) - 1
		Local $acommand = $aTokens[$iLine]
		If Not IsArray($acommand) Then $acommand = StringSplit($aLines[$iLine], "|")
		If $acommand[0] < 8 Then ContinueLoop

		Local $command = StringStripWS(StringUpper($acommand[1]), $STR_STRIPTRAILING)
		If $command <> "MAKE" Then ContinueLoop

		Local $value2 = ($acommand[0] >= 3 ? StringStripWS(StringUpper($acommand[3]), $STR_STRIPTRAILING) : "")
		Local $value8 = ($acommand[0] >= 9 ? StringStripWS(StringUpper($acommand[9]), $STR_STRIPTRAILING) : "")

		If Not CheckCsvValues("MAKE", 8, $value8) Then ContinueLoop
		If Not CheckCsvValues("MAKE", 2, $value2) Then ContinueLoop

		Local $aSideIdx[1]
		If $value2 = "RANDOM" Then
			ReDim $aSideIdx[4]
			$aSideIdx[0] = 0
			$aSideIdx[1] = 1
			$aSideIdx[2] = 2
			$aSideIdx[3] = 3
		Else
			Local $sidex = StringReplace($value2, "-", "_")
			Local $sResolved = Eval($sidex)
			If $sResolved = "" Then $sResolved = $value2
			Local $sSideKey = _CSVPrioGetSideKey($sResolved)
			If @error Then ContinueLoop
			Local $iResolvedIdx = _CSVPrioSideIndex($sSideKey)
			If $iResolvedIdx < 0 Then ContinueLoop
			$aSideIdx[0] = $iResolvedIdx
		EndIf

		For $iSide = 0 To UBound($aSideIdx) - 1
			Local $iSideIdx = $aSideIdx[$iSide]
			If $value8 = "PRIO" Then
				$aPrioCount[$iSideIdx] += 1
				$bHasPrio = True
				ContinueLoop
			EndIf

			Local $iEnum = 0
			Local $iWeightIndex = -1
			If Not _CSVLookupTargetEnum($value8, $iEnum, $iWeightIndex) Then ContinueLoop
			If $iEnum = $eBldgTownHall Then
				$aExplicitTH[$iSideIdx] += 1
				ContinueLoop
			EndIf
			If $iEnum <= 0 Then ContinueLoop

			Local $iEnumIdx = _CSVPrioEnumIndex($aCandidateEnum, $iEnum)
			If $iEnumIdx < 0 Then ContinueLoop
			$aExplicitCounts[$iSideIdx][$iEnumIdx] += 1
		Next
	Next

	If Not $bHasPrio Then Return 1

	Local $bUnknownTH = False
	Local $iTH = _CSVNormalizeTH($g_iSearchTH, $bUnknownTH)
	If $bUnknownTH Then SetDebugLog("CSV PRIO plan using available counts; search TH unknown", $COLOR_WARNING)

	Local $aSideKeys[4] = ["TOP-LEFT", "TOP-RIGHT", "BOTTOM-LEFT", "BOTTOM-RIGHT"]
	For $s = 0 To 3
		If $aPrioCount[$s] <= 0 Then ContinueLoop
		Local $sSideKey = $aSideKeys[$s]
		Local $aTargets = _CSVPrioGetTargetsForSide($sSideKey)
		If @error Or Not IsArray($aTargets) Or UBound($aTargets) = 0 Then ContinueLoop

		Local $aAvailable[UBound($aCandidateEnum)]
		Local $iAvailTH = 0
		For $i = 0 To UBound($aTargets) - 1
			If $aTargets[$i][0] = $eBldgTownHall Then
				$iAvailTH += 1
				ContinueLoop
			EndIf
			Local $iEnumIdx = _CSVPrioEnumIndex($aCandidateEnum, $aTargets[$i][0])
			If $iEnumIdx >= 0 Then $aAvailable[$iEnumIdx] += 1
		Next

		Local $iManualTotal = 0
		Local $aBudget[UBound($aCandidateEnum)]
		For $i = 0 To UBound($aCandidateEnum) - 1
			Local $iMaxQty = $aAvailable[$i]
			If Not $bUnknownTH Then $iMaxQty = _CSVGetBldgMaxQty($aCandidateEnum[$i], $iTH)
			Local $iCapQty = ($iMaxQty < $aAvailable[$i] ? $iMaxQty : $aAvailable[$i])
			Local $iManualCap = $aExplicitCounts[$s][$i]
			If $iManualCap > $iCapQty Then $iManualCap = $iCapQty
			Local $iBudget = $iCapQty - $iManualCap
			If $iBudget < 0 Then $iBudget = 0
			$aBudget[$i] = $iBudget
			$iManualTotal += $iManualCap
		Next

		Local $iBudgetTH = 0
		If Not $bUnknownTH And _CSVIsWeaponizedTownHall($iTH) Then
			Local $iCapTH = ($iAvailTH > 0 ? 1 : 0)
			Local $iManualTHCap = $aExplicitTH[$s]
			If $iManualTHCap > $iCapTH Then $iManualTHCap = $iCapTH
			$iBudgetTH = $iCapTH - $iManualTHCap
			If $iBudgetTH < 0 Then $iBudgetTH = 0
			$iManualTotal += $iManualTHCap
		EndIf

		Local $iPlanCols = UBound($aTargets, 2)
		If $iPlanCols < 1 Then ContinueLoop
		Local $aPlan[0][$iPlanCols]
		For $i = 0 To UBound($aTargets) - 1
			Local $iEnum = $aTargets[$i][0]
			If $iEnum = $eBldgTownHall Then
				If $iBudgetTH <= 0 Then ContinueLoop
				_CSVPrioPlanAdd($aPlan, $aTargets, $i)
				$iBudgetTH -= 1
				ContinueLoop
			EndIf
			Local $iEnumIdx = _CSVPrioEnumIndex($aCandidateEnum, $iEnum)
			If $iEnumIdx < 0 Then ContinueLoop
			If $aBudget[$iEnumIdx] <= 0 Then ContinueLoop
			_CSVPrioPlanAdd($aPlan, $aTargets, $i)
			$aBudget[$iEnumIdx] -= 1
		Next

		If UBound($aPlan) = 0 Then
			If $iManualTotal > 0 Then
				SetDebugLog("CSV PRIO plan empty for " & $sSideKey & " after manual targets, leaving PRIO empty", $COLOR_WARNING)
			Else
				$aPlan = $aTargets
				SetDebugLog("CSV PRIO plan empty for " & $sSideKey & ", using full target list", $COLOR_WARNING)
			EndIf
		EndIf

		$g_oCSVPrioPlan.Item($sSideKey) = $aPlan
		If IsObj($g_oCSVPrioIndexes) Then $g_oCSVPrioIndexes.Item($sSideKey) = 0
		SetDebugLog("CSV PRIO plan built for " & $sSideKey & ": " & UBound($aPlan) & " targets", $COLOR_DEBUG)
	Next
	Return 1
EndFunc   ;==>AttackCSV_PreparePrioPlan

; Side-effect: pure (builds plan list)
Func _CSVPrioPlanAdd(ByRef $aPlan, ByRef $aSource, $iRow)
	If Not IsArray($aSource) Or $iRow < 0 Or $iRow >= UBound($aSource) Then Return
	Local $iSrcCols = UBound($aSource, 2)
	If $iSrcCols < 1 Then Return
	Local $iPlanCols = UBound($aPlan, 2)
	If $iPlanCols <> $iSrcCols Then
		SetDebugLog("CSV PRIO plan column mismatch, adjusting to " & $iSrcCols, $COLOR_WARNING)
		Local $iPlanRows = UBound($aPlan)
		ReDim $aPlan[$iPlanRows][$iSrcCols]
		$iPlanCols = $iSrcCols
	EndIf
	Local $iSize = UBound($aPlan)
	ReDim $aPlan[$iSize + 1][$iPlanCols]
	For $c = 0 To $iPlanCols - 1
		$aPlan[$iSize][$c] = $aSource[$iRow][$c]
	Next
EndFunc   ;==>_CSVPrioPlanAdd

; Side-effect: pure
Func _CSVPrioSideIndex($sSideKey)
	Switch $sSideKey
		Case "TOP-LEFT"
			Return 0
		Case "TOP-RIGHT"
			Return 1
		Case "BOTTOM-LEFT"
			Return 2
		Case "BOTTOM-RIGHT"
			Return 3
	EndSwitch
	Return -1
EndFunc   ;==>_CSVPrioSideIndex

; Side-effect: pure
Func _CSVPrioEnumIndex(ByRef $aCandidateEnum, $iEnum)
	For $i = 0 To UBound($aCandidateEnum) - 1
		If $aCandidateEnum[$i] = $iEnum Then Return $i
	Next
	Return -1
EndFunc   ;==>_CSVPrioEnumIndex

; #FUNCTION# ====================================================================================================================
; Name ..........: _CSVPrioGetTargetsForSide
; Description ...: Build or retrieve cached PRIO targets for a side.
; Syntax ........: _CSVPrioGetTargetsForSide($sSideKey)
; Parameters ....: $sSideKey   - side key (TOP-LEFT, TOP-RIGHT, BOTTOM-LEFT, BOTTOM-RIGHT).
; Return values .: Success: target list array
;                  Failure: 0 and @error set.
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
; Side-effect: impure-deterministic (reads building location data)
Func _CSVPrioGetTargetsForSide($sSideKey)
	If _CSVPrioSyncRedlineCache() = 0 Then Return SetError(3, 0, 0)
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
Func _CSVPrioBuildTargetsForSide($sSideKey, $sSideCheck, $bIgnoreSide = False)
	Local $aTargets[0][6]
	Local $aSideMid[2]
	If _CSVPrioGetSideMid($sSideKey, $aSideMid) = 0 Then Return $aTargets

	Local $aCandidateEnum, $aCandidateName, $aWeightIndex
	If _CSVGetPrioCandidateMap($aCandidateEnum, $aCandidateName, $aWeightIndex) = 0 Then Return $aTargets

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
				If Not $bIgnoreSide And Not IsPointOnSide($aPoint, $sSideCheck) Then ContinueLoop
				_CSVPrioAddTarget($aTargets, $aCandidateEnum[$i], $aCandidateName[$i], $aPoint, $iWeight, GetPixelDistance($aPoint, $aSideMid))
			Next
		Else
			Local $aPoint = $aLoc[0]
			If IsArray($aPoint) And ($bIgnoreSide Or IsPointOnSide($aPoint, $sSideCheck)) Then
				_CSVPrioAddTarget($aTargets, $aCandidateEnum[$i], $aCandidateName[$i], $aPoint, $iWeight, GetPixelDistance($aPoint, $aSideMid))
			EndIf
		EndIf
	Next

	Local $iTHWeight = _CSVPrioGetTownHallWeight()
	If $iTHWeight > 0 And _CSVPrioIsWeaponizedTownHall() Then
		Local $aTHLoc = _ObjGetValue($g_oBldgAttackInfo, $eBldgTownHall & "_LOCATION")
		If Not @error And IsArray($aTHLoc) Then
			If UBound($aTHLoc, 1) > 1 And IsArray($aTHLoc[1]) Then
				For $t = 0 To UBound($aTHLoc) - 1
					Local $aPoint = $aTHLoc[$t]
					If Not IsArray($aPoint) Then ContinueLoop
					If Not $bIgnoreSide And Not IsPointOnSide($aPoint, $sSideCheck) Then ContinueLoop
					_CSVPrioAddTarget($aTargets, $eBldgTownHall, "TOWNHALL", $aPoint, $iTHWeight, GetPixelDistance($aPoint, $aSideMid))
				Next
			Else
				Local $aPoint = $aTHLoc[0]
				If IsArray($aPoint) And ($bIgnoreSide Or IsPointOnSide($aPoint, $sSideCheck)) Then
					_CSVPrioAddTarget($aTargets, $eBldgTownHall, "TOWNHALL", $aPoint, $iTHWeight, GetPixelDistance($aPoint, $aSideMid))
				EndIf
			EndIf
		EndIf
	EndIf

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
			Local $iWeightJ = Int($aTargets[$j][4])
			Local $iWeightI = Int($aTargets[$i][4])
			If $iWeightJ > $iWeightI Or ($iWeightJ = $iWeightI And $aTargets[$j][5] < $aTargets[$i][5]) Then
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

; Side-effect: pure
Func _CSVPrioGetMaxWeight($aTargets)
	If Not IsArray($aTargets) Or UBound($aTargets) = 0 Then Return 0
	Local $iMax = 0
	For $i = 0 To UBound($aTargets) - 1
		Local $iWeight = Int($aTargets[$i][4])
		If $iWeight > $iMax Then $iMax = $iWeight
	Next
	Return $iMax
EndFunc   ;==>_CSVPrioGetMaxWeight

; Side-effect: pure
Func _CSVPrioMergeHighWeightTargets(ByRef $aTargets, $aAllTargets, $iMinWeight)
	If Not IsArray($aAllTargets) Then Return
	For $i = 0 To UBound($aAllTargets) - 1
		If Int($aAllTargets[$i][4]) <= $iMinWeight Then ContinueLoop
		If _CSVPrioTargetExists($aTargets, $aAllTargets[$i][0], $aAllTargets[$i][2], $aAllTargets[$i][3]) Then ContinueLoop
		Local $aPoint[2]
		$aPoint[0] = $aAllTargets[$i][2]
		$aPoint[1] = $aAllTargets[$i][3]
		_CSVPrioAddTarget($aTargets, $aAllTargets[$i][0], $aAllTargets[$i][1], _
				$aPoint, $aAllTargets[$i][4], $aAllTargets[$i][5])
	Next
EndFunc   ;==>_CSVPrioMergeHighWeightTargets

; Side-effect: pure
Func _CSVPrioMergeEnumTargets(ByRef $aTargets, $aAllTargets, $iEnum)
	If Not IsArray($aAllTargets) Then Return
	For $i = 0 To UBound($aAllTargets) - 1
		If $aAllTargets[$i][0] <> $iEnum Then ContinueLoop
		If _CSVPrioTargetExists($aTargets, $aAllTargets[$i][0], $aAllTargets[$i][2], $aAllTargets[$i][3]) Then ContinueLoop
		Local $aPoint[2]
		$aPoint[0] = $aAllTargets[$i][2]
		$aPoint[1] = $aAllTargets[$i][3]
		_CSVPrioAddTarget($aTargets, $aAllTargets[$i][0], $aAllTargets[$i][1], _
				$aPoint, $aAllTargets[$i][4], $aAllTargets[$i][5])
	Next
EndFunc   ;==>_CSVPrioMergeEnumTargets

; Side-effect: pure
Func _CSVPrioTargetExists($aTargets, $iEnum, $iX, $iY)
	If Not IsArray($aTargets) Then Return False
	For $i = 0 To UBound($aTargets) - 1
		If $aTargets[$i][0] = $iEnum And $aTargets[$i][2] = $iX And $aTargets[$i][3] = $iY Then Return True
	Next
	Return False
EndFunc   ;==>_CSVPrioTargetExists

; Side-effect: pure
Func _CSVPrioIsWeaponizedTownHall()
	If $g_iSearchTH = "-" Or $g_iSearchTH = "" Then Return False
	If Not IsNumber($g_iSearchTH) Then Return False
	Local $iLevel = Int($g_iSearchTH)
	If $iLevel >= 12 And $iLevel <= 17 Then Return True
	Return False
EndFunc   ;==>_CSVPrioIsWeaponizedTownHall

; Side-effect: pure
Func _CSVPrioGetTownHallWeight()
	Local $iMax = 0
	For $i = 0 To UBound($g_aiCSVSideBWeights) - 1
		If $g_aiCSVSideBWeights[$i] > $iMax Then $iMax = $g_aiCSVSideBWeights[$i]
	Next
	Return $iMax
EndFunc   ;==>_CSVPrioGetTownHallWeight

; Side-effect: impure-deterministic (updates PRIO counter)
Func _CSVPrioNextIndex($sSideKey)
	Local $iIndex = 0
	If IsObj($g_oCSVPrioIndexes) And $g_oCSVPrioIndexes.Exists($sSideKey) Then
		$iIndex = $g_oCSVPrioIndexes.Item($sSideKey)
	EndIf
	If IsObj($g_oCSVPrioIndexes) Then $g_oCSVPrioIndexes.Item($sSideKey) = $iIndex + 1
	Return $iIndex
EndFunc   ;==>_CSVPrioNextIndex

