; #FUNCTION# ====================================================================================================================
; Name ..........:
; Description ...: This file contens the attack algorithm SCRIPTED
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......: CodeSlinger69 (01-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $MAINSIDE = "BOTTOM-RIGHT"
Global $FRONT_LEFT = "BOTTOM-RIGHT-DOWN"
Global $FRONT_RIGHT = "BOTTOM-RIGHT-UP"
Global $RIGHT_FRONT = "TOP-RIGHT-DOWN"
Global $RIGHT_BACK = "TOP-RIGHT-UP"
Global $LEFT_FRONT = "BOTTOM-LEFT-DOWN"
Global $LEFT_BACK = "BOTTOM-LEFT-UP"
Global $BACK_LEFT = "TOP-LEFT-DOWN"
Global $BACK_RIGHT = "TOP-LEFT-UP"


Global $g_aiPixelTopLeftDropLine
Global $g_aiPixelTopRightDropLine
Global $g_aiPixelBottomLeftDropLine
Global $g_aiPixelBottomRightDropLine
Global $g_aiPixelTopLeftUPDropLine
Global $g_aiPixelTopLeftDOWNDropLine
Global $g_aiPixelTopRightUPDropLine
Global $g_aiPixelTopRightDOWNDropLine
Global $g_aiPixelBottomLeftUPDropLine
Global $g_aiPixelBottomLeftDOWNDropLine
Global $g_aiPixelBottomRightUPDropLine
Global $g_aiPixelBottomRightDOWNDropLine

Global $DeployableLRTB = [0, $g_iGAME_WIDTH - 1, 0, 556]
Global $InnerDiamondLeft = $g_iDefaultInnerDiamondLeft
Global $InnerDiamondRight = $g_iDefaultInnerDiamondRight
Global $InnerDiamondTop = $g_iDefaultInnerDiamondTop
Global $InnerDiamondBottom = $g_iDefaultInnerDiamondBottom

Global $OuterDiamondLeft = 0
Global $OuterDiamondRight = 0
Global $OuterDiamondTop = 0
Global $OuterDiamondBottom = 0

ConvertInternalExternArea() ; initial layout so variables are not empty

; #FUNCTION# ====================================================================================================================
; Name ..........: ConvertInternalExternArea
; Description ...:
; Syntax ........: ConvertInternalExternArea()
; Parameters ....:
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; =====================================================================================================================
Func ConvertInternalExternArea()
	Local $DiamondMiddleX = ($InnerDiamondLeft + $InnerDiamondRight) / 2
	Local $DiamondMiddleY = ($InnerDiamondTop + $InnerDiamondBottom) / 2
	Local $iRefLeft = $g_afRefVillage[$g_iTree][1]
	Local $iRefRight = $g_afRefVillage[$g_iTree][2]
	Local $iRefTop = $g_afRefVillage[$g_iTree][3]
	Local $iRefBottom = $g_afRefVillage[$g_iTree][4]
	If $g_bIsCustomMainVillage Then
		For $i = 0 To UBound($g_afRefCustomMainVillage) - 1
			If $g_iTree = $g_afRefCustomMainVillage[$i][5] Then
				$iRefLeft = $g_afRefCustomMainVillage[$i][0]
				$iRefRight = $g_afRefCustomMainVillage[$i][1]
				$iRefTop = $g_afRefCustomMainVillage[$i][2]
				$iRefBottom = $g_afRefCustomMainVillage[$i][3]
				ExitLoop
			EndIf
		Next
	EndIf

	Local $iRefWidth = $iRefRight - $iRefLeft
	Local $iRefHeight = $iRefBottom - $iRefTop
	Local $iCurWidth = $InnerDiamondRight - $InnerDiamondLeft
	Local $iCurHeight = $InnerDiamondBottom - $InnerDiamondTop
	Local $fScaleX = 1
	Local $fScaleY = 1
	If $iRefWidth > 0 Then $fScaleX = $iCurWidth / $iRefWidth
	If $iRefHeight > 0 Then $fScaleY = $iCurHeight / $iRefHeight
	$g_fEdgeScaleX = $fScaleX
	$g_fEdgeScaleY = $fScaleY
	$g_aiRefDiamond[0] = $iRefLeft
	$g_aiRefDiamond[1] = $iRefRight
	$g_aiRefDiamond[2] = $iRefTop
	$g_aiRefDiamond[3] = $iRefBottom
	Local $iAdjLeft = Round($g_afRefVillage[$g_iTree][6] * $fScaleX)
	Local $iAdjRight = Round($g_afRefVillage[$g_iTree][7] * $fScaleX)
	Local $iAdjTop = Round($g_afRefVillage[$g_iTree][8] * $fScaleY)
	Local $iAdjBottom = Round($g_afRefVillage[$g_iTree][9] * $fScaleY)
	Local $bScaleWarn = (Abs($fScaleX - 1) > 0.2 Or Abs($fScaleY - 1) > 0.2)
	If $bScaleWarn Then
		SetLog("Warning: edge scale mismatch X/Y=" & Round($fScaleX, 3) & "/" & Round($fScaleY, 3) & " using default edge diff", $COLOR_WARNING)
		$iAdjLeft = $g_iDefaultEdgeDiffX
		$iAdjRight = $g_iDefaultEdgeDiffX
		$iAdjTop = $g_iDefaultEdgeDiffY
		$iAdjBottom = $g_iDefaultEdgeDiffY
	EndIf
	If $iAdjLeft <= 0 Then $iAdjLeft = $g_iDefaultEdgeDiffX
	If $iAdjRight <= 0 Then $iAdjRight = $g_iDefaultEdgeDiffX
	If $iAdjTop <= 0 Then $iAdjTop = $g_iDefaultEdgeDiffY
	If $iAdjBottom <= 0 Then $iAdjBottom = $g_iDefaultEdgeDiffY
	$g_iSceneryEdgeDiffX = Int(($iAdjLeft + $iAdjRight) / 2)
	$g_iSceneryEdgeDiffY = Int(($iAdjTop + $iAdjBottom) / 2)

	Local $iInnerPad = $g_iInnerEdgePadding
	If $iInnerPad > 0 Then
		$InnerDiamondLeft -= $iInnerPad
		$InnerDiamondRight += $iInnerPad
		$InnerDiamondTop -= $iInnerPad
		$InnerDiamondBottom += $iInnerPad
	EndIf

	Local $iExpandLeft = $iAdjLeft
	Local $iExpandRight = $iAdjRight
	Local $iExpandTop = $iAdjTop
	Local $iExpandBottom = $iAdjBottom
	Local $bMinExpandForced = False
	If $iExpandLeft < $g_iMinOuterExpansion Then
		$iExpandLeft = $g_iMinOuterExpansion
		$bMinExpandForced = True
	EndIf
	If $iExpandRight < $g_iMinOuterExpansion Then
		$iExpandRight = $g_iMinOuterExpansion
		$bMinExpandForced = True
	EndIf
	If $iExpandTop < $g_iMinOuterExpansion Then
		$iExpandTop = $g_iMinOuterExpansion
		$bMinExpandForced = True
	EndIf
	If $iExpandBottom < $g_iMinOuterExpansion Then
		$iExpandBottom = $g_iMinOuterExpansion
		$bMinExpandForced = True
	EndIf
	If $g_iOuterEdgePadding > 0 Then
		$iExpandLeft += $g_iOuterEdgePadding
		$iExpandRight += $g_iOuterEdgePadding
		$iExpandTop += $g_iOuterEdgePadding
		$iExpandBottom += $g_iOuterEdgePadding
	EndIf

	Local $bClamped = False
	Local $bReduced = False
	Local $iMaxX = $g_iGAME_WIDTH - 1
	Local $iMaxY = $g_iGAME_HEIGHT - 1
	Local $iMaxLeft = $InnerDiamondLeft
	Local $iMaxRight = $iMaxX - $InnerDiamondRight
	Local $iMaxTop = $InnerDiamondTop
	Local $iMaxBottom = $iMaxY - $InnerDiamondBottom
	If $iExpandLeft > $iMaxLeft Then
		$iExpandLeft = $iMaxLeft
		$bClamped = True
		$bReduced = True
	EndIf
	If $iExpandRight > $iMaxRight Then
		$iExpandRight = $iMaxRight
		$bClamped = True
		$bReduced = True
	EndIf
	If $iExpandTop > $iMaxTop Then
		$iExpandTop = $iMaxTop
		$bClamped = True
		$bReduced = True
	EndIf
	If $iExpandBottom > $iMaxBottom Then
		$iExpandBottom = $iMaxBottom
		$bClamped = True
		$bReduced = True
	EndIf
	If $iExpandLeft < 0 Then $iExpandLeft = 0
	If $iExpandRight < 0 Then $iExpandRight = 0
	If $iExpandTop < 0 Then $iExpandTop = 0
	If $iExpandBottom < 0 Then $iExpandBottom = 0

	$OuterDiamondLeft = $InnerDiamondLeft - $iExpandLeft
	$OuterDiamondRight = $InnerDiamondRight + $iExpandRight
	$OuterDiamondTop = $InnerDiamondTop - $iExpandTop
	$OuterDiamondBottom = $InnerDiamondBottom + $iExpandBottom
	If $OuterDiamondRight <= $OuterDiamondLeft Or $OuterDiamondBottom <= $OuterDiamondTop Then
		SetLog("Warning: outer diamond invalid after expansion, using default edge diff", $COLOR_WARNING)
		Local $iFallbackLeft = _Min($InnerDiamondLeft, $g_iDefaultEdgeDiffX + $g_iOuterEdgePadding)
		Local $iFallbackRight = _Min($iMaxRight, $g_iDefaultEdgeDiffX + $g_iOuterEdgePadding)
		Local $iFallbackTop = _Min($InnerDiamondTop, $g_iDefaultEdgeDiffY + $g_iOuterEdgePadding)
		Local $iFallbackBottom = _Min($iMaxBottom, $g_iDefaultEdgeDiffY + $g_iOuterEdgePadding)
		$OuterDiamondLeft = $InnerDiamondLeft - $iFallbackLeft
		$OuterDiamondRight = $InnerDiamondRight + $iFallbackRight
		$OuterDiamondTop = $InnerDiamondTop - $iFallbackTop
		$OuterDiamondBottom = $InnerDiamondBottom + $iFallbackBottom
		$bClamped = True
	EndIf

	$g_aiInnerDiamond[0] = $InnerDiamondLeft
	$g_aiInnerDiamond[1] = $InnerDiamondRight
	$g_aiInnerDiamond[2] = $InnerDiamondTop
	$g_aiInnerDiamond[3] = $InnerDiamondBottom
	$g_aiOuterDiamond[0] = $OuterDiamondLeft
	$g_aiOuterDiamond[1] = $OuterDiamondRight
	$g_aiOuterDiamond[2] = $OuterDiamondTop
	$g_aiOuterDiamond[3] = $OuterDiamondBottom
	If $g_bDebugSetlog Then
		SetDebugLog("EdgeScale X/Y: " & Round($fScaleX, 3) & "/" & Round($fScaleY, 3), $COLOR_DEBUG1)
		SetDebugLog("Ref LRTB: " & $iRefLeft & "," & $iRefRight & "," & $iRefTop & "," & $iRefBottom, $COLOR_DEBUG1)
		SetDebugLog("Inner LRTB: " & $InnerDiamondLeft & "," & $InnerDiamondRight & "," & $InnerDiamondTop & "," & $InnerDiamondBottom, $COLOR_DEBUG1)
		SetDebugLog("Adj LRTB: " & $iAdjLeft & "," & $iAdjRight & "," & $iAdjTop & "," & $iAdjBottom, $COLOR_DEBUG1)
		SetDebugLog("Outer LRTB: " & $OuterDiamondLeft & "," & $OuterDiamondRight & "," & $OuterDiamondTop & "," & $OuterDiamondBottom, $COLOR_DEBUG1)
		If $iInnerPad > 0 Then SetDebugLog("Inner edge padding: " & $iInnerPad, $COLOR_DEBUG1)
		If $g_iOuterEdgePadding > 0 Then SetDebugLog("Outer edge padding: " & $g_iOuterEdgePadding, $COLOR_DEBUG1)
		If $g_iMinOuterExpansion > 0 Then SetDebugLog("Min outer expansion: " & $g_iMinOuterExpansion, $COLOR_DEBUG1)
		Local $iExpectedX = Round($g_iDefaultEdgeDiffX * $fScaleX) + $g_iOuterEdgePadding
		Local $iExpectedY = Round($g_iDefaultEdgeDiffY * $fScaleY) + $g_iOuterEdgePadding
		If Abs($iExpandLeft - $iExpectedX) > $g_iOuterConsistencyTolerance Or Abs($iExpandRight - $iExpectedX) > $g_iOuterConsistencyTolerance Then
			SetDebugLog("Outer edge X deviates from baseline: " & $iExpandLeft & "/" & $iExpandRight & " (exp " & $iExpectedX & ")", $COLOR_WARNING)
		EndIf
		If Abs($iExpandTop - $iExpectedY) > $g_iOuterConsistencyTolerance Or Abs($iExpandBottom - $iExpectedY) > $g_iOuterConsistencyTolerance Then
			SetDebugLog("Outer edge Y deviates from baseline: " & $iExpandTop & "/" & $iExpandBottom & " (exp " & $iExpectedY & ")", $COLOR_WARNING)
		EndIf
	EndIf
	If $bScaleWarn Then SetDebugLog("Edge scale fallback applied", $COLOR_WARNING)
	If $bMinExpandForced Then SetDebugLog("Min outer expansion forced", $COLOR_WARNING)
	If $bClamped Then SetDebugLog("Outer diamond clamped/fallback applied", $COLOR_WARNING)
	If $bReduced Then SetDebugLog("Outer expansion reduced due to screen bounds", $COLOR_WARNING)

	Local $ExternalAreaRef[8][3] = [ _
			[$OuterDiamondLeft, $DiamondMiddleY, "LEFT"], _
			[$OuterDiamondRight, $DiamondMiddleY, "RIGHT"], _
			[$DiamondMiddleX, $OuterDiamondTop, "TOP"], _
			[$DiamondMiddleX, $OuterDiamondBottom, "BOTTOM"], _
			[$OuterDiamondLeft + ($DiamondMiddleX - $OuterDiamondLeft) / 2, $OuterDiamondTop + ($DiamondMiddleY - $OuterDiamondTop) / 2, "TOP-LEFT"], _
			[$DiamondMiddleX + ($OuterDiamondRight - $DiamondMiddleX) / 2, $OuterDiamondTop + ($DiamondMiddleY - $OuterDiamondTop) / 2, "TOP-RIGHT"], _
			[$OuterDiamondLeft + ($DiamondMiddleX - $OuterDiamondLeft) / 2, $DiamondMiddleY + ($OuterDiamondBottom - $DiamondMiddleY) / 2, "BOTTOM-LEFT"], _
			[$DiamondMiddleX + ($OuterDiamondRight - $DiamondMiddleX) / 2, $DiamondMiddleY + ($OuterDiamondBottom - $DiamondMiddleY) / 2, "BOTTOM-RIGHT"] _
			]

	Local $InternalAreaRef[8][3] = [ _
			[$InnerDiamondLeft, $DiamondMiddleY, "LEFT"], _
			[$InnerDiamondRight, $DiamondMiddleY, "RIGHT"], _
			[$DiamondMiddleX, $InnerDiamondTop, "TOP"], _
			[$DiamondMiddleX, $InnerDiamondBottom, "BOTTOM"], _
			[$InnerDiamondLeft + ($DiamondMiddleX - $InnerDiamondLeft) / 2, $InnerDiamondTop + ($DiamondMiddleY - $InnerDiamondTop) / 2, "TOP-LEFT"], _
			[$DiamondMiddleX + ($InnerDiamondRight - $DiamondMiddleX) / 2, $InnerDiamondTop + ($DiamondMiddleY - $InnerDiamondTop) / 2, "TOP-RIGHT"], _
			[$InnerDiamondLeft + ($DiamondMiddleX - $InnerDiamondLeft) / 2, $DiamondMiddleY + ($InnerDiamondBottom - $DiamondMiddleY) / 2, "BOTTOM-LEFT"], _
			[$DiamondMiddleX + ($InnerDiamondRight - $DiamondMiddleX) / 2, $DiamondMiddleY + ($InnerDiamondBottom - $DiamondMiddleY) / 2, "BOTTOM-RIGHT"] _
			]
	
	Local $x, $y
	; Update External coord.
	For $i = 0 To 7
		$x = $ExternalAreaRef[$i][0]
		$y = $ExternalAreaRef[$i][1]
		ConvertToVillagePos($x, $y)
		$ExternalArea[$i][0] = $x
		$ExternalArea[$i][1] = $y
		$ExternalArea[$i][2] = $ExternalAreaRef[$i][2]
		;debugAttackCSV("External Area Point " & $ExternalArea[$i][2] & ": " & $x & ", " & $y)
	Next
	; Full ECD Diamond $CocDiamondECD
	; Top
	$x = $ExternalAreaRef[2][0]
	$y = $ExternalAreaRef[2][1]
	ConvertToVillagePos($x, $y)
	$CocDiamondECD = $x & "," & $y
	; Right
	$x = $ExternalAreaRef[1][0]
	$y = $ExternalAreaRef[1][1]
	ConvertToVillagePos($x, $y)
	$CocDiamondECD &= "|" & $x & "," & $y
	; Bottom
	$x = $ExternalAreaRef[3][0]
	$y = $ExternalAreaRef[3][1]
	ConvertToVillagePos($x, $y)
	$CocDiamondECD &= "|" & $x & "," & $y
	; Left
	$x = $ExternalAreaRef[0][0]
	$y = $ExternalAreaRef[0][1]
	ConvertToVillagePos($x, $y)
	$CocDiamondECD &= "|" & $x & "," & $y

	; Update Internal coord.
	For $i = 0 To 7
		$x = $InternalAreaRef[$i][0]
		$y = $InternalAreaRef[$i][1]
		ConvertToVillagePos($x, $y)
		$InternalArea[$i][0] = $x
		$InternalArea[$i][1] = $y
		$InternalArea[$i][2] = $InternalAreaRef[$i][2]
		;debugAttackCSV("Internal Area Point " & $InternalArea[$i][2] & ": " & $x & ", " & $y)
	Next
	$CocDiamondDCD = $InternalArea[2][0] & "," & $InternalArea[2][1] & "|" & _
			$InternalArea[1][0] & "," & $InternalArea[1][1] & "|" & _
			$InternalArea[3][0] & "," & $InternalArea[3][1] & "|" & _
			$InternalArea[0][0] & "," & $InternalArea[0][1]
			
	$CocDiamondECD = $ExternalArea[2][0] & "," & $ExternalArea[2][1] & "|" & _
			$ExternalArea[1][0] & "," & $ExternalArea[1][1] & "|" & _
			$ExternalArea[3][0] & "," & $ExternalArea[3][1] & "|" & _
			$ExternalArea[0][0] & "," & $ExternalArea[0][1]
EndFunc   ;==>ConvertInternalExternArea

Func CheckAttackLocation(ByRef $iX, ByRef $iY)
	If $iY > $DeployableLRTB[3] Then
		$iY = $DeployableLRTB[3]
		Return False
	EndIf
	Return True
EndFunc   ;==>CheckAttackLocation

Func GetMinPoint($PointList, $Dim)
	Local $Result = [9999, 9999]
	For $i = 0 To UBound($PointList) - 1
		Local $Point = $PointList[$i]
		If $Point[$Dim] < $Result[$Dim] Then $Result = $Point
	Next
	Return $Result
EndFunc   ;==>GetMinPoint

Func GetMaxPoint($PointList, $Dim)
	Local $Result = [-9999, -9999]
	For $i = 0 To UBound($PointList) - 1
		Local $Point = $PointList[$i]
		If $Point[$Dim] > $Result[$Dim] Then $Result = $Point
	Next
	Return $Result
EndFunc   ;==>GetMaxPoint

Func _EnsureDropLineArray(ByRef $aLine, ByRef $aStartEnd, $sLabel = "")
	If IsArray($aLine) And UBound($aLine) > 0 Then Return
	Local $sStartEnd = $aStartEnd[0][0] & "," & $aStartEnd[0][1] & "|" & $aStartEnd[1][0] & "," & $aStartEnd[1][1]
	$aLine = GetListPixel($sStartEnd, ",", $sLabel & "-fallback")
	SetDebugLog("DropLine fallback " & $sLabel & " using start/end: " & $sStartEnd, $COLOR_WARNING)
EndFunc   ;==>_EnsureDropLineArray

; #FUNCTION# ====================================================================================================================
; Name ..........: _CSVBuildDropLines
; Description ...: Build dropline and slice arrays for CSV drop vectors based on used sides.
; Syntax ........: _CSVBuildDropLines(ByRef $aSidesUsed, $bAllMakeTargeted)
; Parameters ....: $aSidesUsed      - [in] Array [TL, TR, BL, BR] of used sides (Boolean).
;                  $bAllMakeTargeted - [in] True when all MAKE commands are targeted and droplines can be skipped.
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
; Side-effect: impure-deterministic (builds dropline/slice arrays from redline data)
Func _CSVBuildDropLines(ByRef $aSidesUsed, $bAllMakeTargeted)
	Local $aEmpty[0]
	$g_aiPixelTopLeftDropLine = $aEmpty
	$g_aiPixelTopRightDropLine = $aEmpty
	$g_aiPixelBottomLeftDropLine = $aEmpty
	$g_aiPixelBottomRightDropLine = $aEmpty
	$g_aiPixelTopLeftUPDropLine = $aEmpty
	$g_aiPixelTopLeftDOWNDropLine = $aEmpty
	$g_aiPixelTopRightUPDropLine = $aEmpty
	$g_aiPixelTopRightDOWNDropLine = $aEmpty
	$g_aiPixelBottomLeftUPDropLine = $aEmpty
	$g_aiPixelBottomLeftDOWNDropLine = $aEmpty
	$g_aiPixelBottomRightUPDropLine = $aEmpty
	$g_aiPixelBottomRightDOWNDropLine = $aEmpty

	Local $bUseTL = $aSidesUsed[0]
	Local $bUseTR = $aSidesUsed[1]
	Local $bUseBL = $aSidesUsed[2]
	Local $bUseBR = $aSidesUsed[3]
	Local $bAnySide = ($bUseTL Or $bUseTR Or $bUseBL Or $bUseBR)

	If $bAllMakeTargeted Then
		SetDebugLog("CSV dropline build skipped: all MAKE commands are targeted", $COLOR_DEBUG)
		Return
	EndIf
	If Not $bAnySide Then
		SetDebugLog("CSV dropline build skipped: no MAKE sides require droplines", $COLOR_DEBUG)
		Return
	EndIf

	Local $hTimer = __timerinit()
	If $g_aiAttackScrDroplineEdge[$g_iMatchMode] = $DROPLINE_DROPPOINTS_ONLY Then
		If $bUseTL Then $g_aiPixelTopLeftDropLine = $g_aiPixelTopLeft
		If $bUseTR Then $g_aiPixelTopRightDropLine = $g_aiPixelTopRight
		If $bUseBL Then $g_aiPixelBottomLeftDropLine = $g_aiPixelBottomLeft
		If $bUseBR Then $g_aiPixelBottomRightDropLine = $g_aiPixelBottomRight
	Else
		If Not IsArray($g_aiPixelTopLeft) Then $g_aiPixelTopLeft = $aEmpty
		If Not IsArray($g_aiPixelTopRight) Then $g_aiPixelTopRight = $aEmpty
		If Not IsArray($g_aiPixelBottomLeft) Then $g_aiPixelBottomLeft = $aEmpty
		If Not IsArray($g_aiPixelBottomRight) Then $g_aiPixelBottomRight = $aEmpty

		Local $coordLeft = [$ExternalArea[0][0], $ExternalArea[0][1]]
		Local $coordTop = [$ExternalArea[2][0], $ExternalArea[2][1]]
		Local $coordRight = [$ExternalArea[1][0], $ExternalArea[1][1]]
		Local $coordBottom = [$ExternalArea[3][0], $ExternalArea[3][1]]

		Local $StartEndTopLeft = [$coordLeft, $coordTop]
		If UBound($g_aiPixelTopLeft) > 2 Then Local $StartEndTopLeft = [$g_aiPixelTopLeft[0], $g_aiPixelTopLeft[UBound($g_aiPixelTopLeft) - 1]]
		Local $StartEndTopRight = [$coordTop, $coordRight]
		If UBound($g_aiPixelTopRight) > 2 Then Local $StartEndTopRight = [$g_aiPixelTopRight[0], $g_aiPixelTopRight[UBound($g_aiPixelTopRight) - 1]]
		Local $StartEndBottomLeft = [$coordLeft, $coordBottom]
		If UBound($g_aiPixelBottomLeft) > 2 Then Local $StartEndBottomLeft = [$g_aiPixelBottomLeft[0], $g_aiPixelBottomLeft[UBound($g_aiPixelBottomLeft) - 1]]
		Local $StartEndBottomRight = [$coordBottom, $coordRight]
		If UBound($g_aiPixelBottomRight) > 2 Then Local $StartEndBottomRight = [$g_aiPixelBottomRight[0], $g_aiPixelBottomRight[UBound($g_aiPixelBottomRight) - 1]]

		Switch $g_aiAttackScrDroplineEdge[$g_iMatchMode]
			Case $DROPLINE_EDGE_FIXED, $DROPLINE_FULL_EDGE_FIXED ; default inner area edges
				; reset fix corners
				Local $StartEndTopLeft = [$coordLeft, $coordTop]
				Local $StartEndTopRight = [$coordTop, $coordRight]
				Local $StartEndBottomLeft = [$coordLeft, $coordBottom]
				Local $StartEndBottomRight = [$coordBottom, $coordRight]
		EndSwitch

		SetDebugLog("MakeDropLines, StartEndTopLeft     = " & PixelArrayToString($StartEndTopLeft, ","))
		SetDebugLog("MakeDropLines, StartEndTopRight    = " & PixelArrayToString($StartEndTopRight, ","))
		SetDebugLog("MakeDropLines, StartEndBottomLeft  = " & PixelArrayToString($StartEndBottomLeft, ","))
		SetDebugLog("MakeDropLines, StartEndBottomRight = " & PixelArrayToString($StartEndBottomRight, ","))

		Switch $g_aiAttackScrDroplineEdge[$g_iMatchMode]
			Case $DROPLINE_EDGE_FIXED, $DROPLINE_EDGE_FIRST ; default drop line
				If $bUseTL Then $g_aiPixelTopLeftDropLine = MakeDropLineOriginal($g_aiPixelTopLeft, $StartEndTopLeft[0], $StartEndTopLeft[1])
				If $bUseTR Then $g_aiPixelTopRightDropLine = MakeDropLineOriginal($g_aiPixelTopRight, $StartEndTopRight[0], $StartEndTopRight[1])
				If $bUseBL Then $g_aiPixelBottomLeftDropLine = MakeDropLineOriginal($g_aiPixelBottomLeft, $StartEndBottomLeft[0], $StartEndBottomLeft[1])
				If $bUseBR Then $g_aiPixelBottomRightDropLine = MakeDropLineOriginal($g_aiPixelBottomRight, $StartEndBottomRight[0], $StartEndBottomRight[1])
			Case $DROPLINE_FULL_EDGE_FIXED, $DROPLINE_FULL_EDGE_FIRST ; full drop line
				Local $iLineDistanceThreshold = 75
				If $g_aiAttackScrRedlineRoutine[$g_iMatchMode] = $REDLINE_IMGLOC Then $iLineDistanceThreshold = 25
				If $bUseTL Then $g_aiPixelTopLeftDropLine = MakeDropLine($g_aiPixelTopLeft, $StartEndTopLeft[0], $StartEndTopLeft[1], $iLineDistanceThreshold, $g_aiAttackScrDroplineEdge[$g_iMatchMode] = $DROPLINE_FULL_EDGE_FIXED)
				If $bUseTR Then $g_aiPixelTopRightDropLine = MakeDropLine($g_aiPixelTopRight, $StartEndTopRight[0], $StartEndTopRight[1], $iLineDistanceThreshold, $g_aiAttackScrDroplineEdge[$g_iMatchMode] = $DROPLINE_FULL_EDGE_FIXED)
				If $bUseBL Then $g_aiPixelBottomLeftDropLine = MakeDropLine($g_aiPixelBottomLeft, $StartEndBottomLeft[0], $StartEndBottomLeft[1], $iLineDistanceThreshold, $g_aiAttackScrDroplineEdge[$g_iMatchMode] = $DROPLINE_FULL_EDGE_FIXED)
				If $bUseBR Then $g_aiPixelBottomRightDropLine = MakeDropLine($g_aiPixelBottomRight, $StartEndBottomRight[0], $StartEndBottomRight[1], $iLineDistanceThreshold, $g_aiAttackScrDroplineEdge[$g_iMatchMode] = $DROPLINE_FULL_EDGE_FIXED)
		EndSwitch

		If $bUseTL Then _EnsureDropLineArray($g_aiPixelTopLeftDropLine, $StartEndTopLeft, "TL")
		If $bUseTR Then _EnsureDropLineArray($g_aiPixelTopRightDropLine, $StartEndTopRight, "TR")
		If $bUseBL Then _EnsureDropLineArray($g_aiPixelBottomLeftDropLine, $StartEndBottomLeft, "BL")
		If $bUseBR Then _EnsureDropLineArray($g_aiPixelBottomRightDropLine, $StartEndBottomRight, "BR")
	EndIf

	If $bUseTL Then
		Local $tempvectstr1 = ""
		Local $tempvectstr2 = ""
		For $i = 0 To UBound($g_aiPixelTopLeftDropLine) - 1
			Local $pixel = $g_aiPixelTopLeftDropLine[$i]
			Local $slice = Slice8($pixel)
			Switch StringLeft($slice, 1)
				Case "6"
					$tempvectstr1 &= $pixel[0] & "," & $pixel[1] & "|"
				Case "5"
					$tempvectstr2 &= $pixel[0] & "," & $pixel[1] & "|"
				Case Else
					SetDebugLog("TOP LEFT: Skip slice " & $slice & " at " & $pixel[0] & ", " & $pixel[1])
			EndSwitch
		Next
		If StringLen($tempvectstr1) > 0 Then $tempvectstr1 = StringLeft($tempvectstr1, StringLen($tempvectstr1) - 1)
		If StringLen($tempvectstr2) > 0 Then $tempvectstr2 = StringLeft($tempvectstr2, StringLen($tempvectstr2) - 1)
		$g_aiPixelTopLeftDOWNDropLine = GetListPixel($tempvectstr1, ",", "TL-DOWN")
		$g_aiPixelTopLeftUPDropLine = GetListPixel($tempvectstr2, ",", "TL-UP")
	EndIf

	If $bUseTR Then
		Local $tempvectstr1 = ""
		Local $tempvectstr2 = ""
		For $i = 0 To UBound($g_aiPixelTopRightDropLine) - 1
			Local $pixel = $g_aiPixelTopRightDropLine[$i]
			Local $slice = Slice8($pixel)
			Switch StringLeft($slice, 1)
				Case "3"
					$tempvectstr1 &= $pixel[0] & "," & $pixel[1] & "|"
				Case "4"
					$tempvectstr2 &= $pixel[0] & "," & $pixel[1] & "|"
				Case Else
					SetDebugLog("TOP RIGHT: Skip slice " & $slice & " at " & $pixel[0] & ", " & $pixel[1])
			EndSwitch
		Next
		If StringLen($tempvectstr1) > 0 Then $tempvectstr1 = StringLeft($tempvectstr1, StringLen($tempvectstr1) - 1)
		If StringLen($tempvectstr2) > 0 Then $tempvectstr2 = StringLeft($tempvectstr2, StringLen($tempvectstr2) - 1)
		$g_aiPixelTopRightDOWNDropLine = GetListPixel($tempvectstr1, ",", "TR-DOWN")
		$g_aiPixelTopRightUPDropLine = GetListPixel($tempvectstr2, ",", "TR-UP")
	EndIf

	If $bUseBL Then
		Local $tempvectstr1 = ""
		Local $tempvectstr2 = ""
		For $i = 0 To UBound($g_aiPixelBottomLeftDropLine) - 1
			Local $pixel = $g_aiPixelBottomLeftDropLine[$i]
			Local $slice = Slice8($pixel)
			Switch StringLeft($slice, 1)
				Case "8"
					$tempvectstr1 &= $pixel[0] & "," & $pixel[1] & "|"
				Case "7"
					$tempvectstr2 &= $pixel[0] & "," & $pixel[1] & "|"
				Case Else
					SetDebugLog("BOTTOM LEFT: Skip slice " & $slice & " at " & $pixel[0] & ", " & $pixel[1])
			EndSwitch
		Next
		If StringLen($tempvectstr1) > 0 Then $tempvectstr1 = StringLeft($tempvectstr1, StringLen($tempvectstr1) - 1)
		If StringLen($tempvectstr2) > 0 Then $tempvectstr2 = StringLeft($tempvectstr2, StringLen($tempvectstr2) - 1)
		$g_aiPixelBottomLeftDOWNDropLine = GetListPixel($tempvectstr1, ",", "BL-DOWN")
		$g_aiPixelBottomLeftUPDropLine = GetListPixel($tempvectstr2, ",", "BL-UP")
	EndIf

	If $bUseBR Then
		Local $tempvectstr1 = ""
		Local $tempvectstr2 = ""
		For $i = 0 To UBound($g_aiPixelBottomRightDropLine) - 1
			Local $pixel = $g_aiPixelBottomRightDropLine[$i]
			Local $slice = Slice8($pixel)
			Switch StringLeft($slice, 1)
				Case "1"
					$tempvectstr1 &= $pixel[0] & "," & $pixel[1] & "|"
				Case "2"
					$tempvectstr2 &= $pixel[0] & "," & $pixel[1] & "|"
				Case Else
					SetDebugLog("BOTTOM RIGHT: Skip slice " & $slice & " at " & $pixel[0] & ", " & $pixel[1])
			EndSwitch
		Next
		If StringLen($tempvectstr1) > 0 Then $tempvectstr1 = StringLeft($tempvectstr1, StringLen($tempvectstr1) - 1)
		If StringLen($tempvectstr2) > 0 Then $tempvectstr2 = StringLeft($tempvectstr2, StringLen($tempvectstr2) - 1)
		$g_aiPixelBottomRightDOWNDropLine = GetListPixel($tempvectstr1, ",", "BR-DOWN")
		$g_aiPixelBottomRightUPDropLine = GetListPixel($tempvectstr2, ",", "BR-UP")
	EndIf

	debugAttackCSV("DropLine sizes: TL=" & (IsArray($g_aiPixelTopLeftDropLine) ? UBound($g_aiPixelTopLeftDropLine) : 0) & ", TR=" & (IsArray($g_aiPixelTopRightDropLine) ? UBound($g_aiPixelTopRightDropLine) : 0) & ", BL=" & (IsArray($g_aiPixelBottomLeftDropLine) ? UBound($g_aiPixelBottomLeftDropLine) : 0) & ", BR=" & (IsArray($g_aiPixelBottomRightDropLine) ? UBound($g_aiPixelBottomRightDropLine) : 0))
	debugAttackCSV("Slice sizes: TLup=" & (IsArray($g_aiPixelTopLeftUPDropLine) ? UBound($g_aiPixelTopLeftUPDropLine) : 0) & ", TLdown=" & (IsArray($g_aiPixelTopLeftDOWNDropLine) ? UBound($g_aiPixelTopLeftDOWNDropLine) : 0) & ", TRup=" & (IsArray($g_aiPixelTopRightUPDropLine) ? UBound($g_aiPixelTopRightUPDropLine) : 0) & ", TRdown=" & (IsArray($g_aiPixelTopRightDOWNDropLine) ? UBound($g_aiPixelTopRightDOWNDropLine) : 0) & ", BLup=" & (IsArray($g_aiPixelBottomLeftUPDropLine) ? UBound($g_aiPixelBottomLeftUPDropLine) : 0) & ", BLdown=" & (IsArray($g_aiPixelBottomLeftDOWNDropLine) ? UBound($g_aiPixelBottomLeftDOWNDropLine) : 0) & ", BRup=" & (IsArray($g_aiPixelBottomRightUPDropLine) ? UBound($g_aiPixelBottomRightUPDropLine) : 0) & ", BRdown=" & (IsArray($g_aiPixelBottomRightDOWNDropLine) ? UBound($g_aiPixelBottomRightDOWNDropLine) : 0))
	SetLog("> Drop Lines located in  " & Round(__timerdiff($hTimer) / 1000, 2) & " seconds", $COLOR_INFO)
	If _Sleep($DELAYRESPOND) Then Return
EndFunc   ;==>_CSVBuildDropLines

; #FUNCTION# ====================================================================================================================
; Name ..........: _CSVEstimateMainSide
; Description ...: Estimate main attack side from Town Hall position.
; Syntax ........: _CSVEstimateMainSide($iTHx, $iTHy)
; Parameters ....: $iTHx              - Town Hall X coordinate.
;                  $iTHy              - Town Hall Y coordinate.
; Return values .: Success: main side string (TOP-LEFT/TOP-RIGHT/BOTTOM-LEFT/BOTTOM-RIGHT)
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
; Side-effect: pure
Func _CSVEstimateMainSide($iTHx, $iTHy)
	If $iTHx < $InternalArea[2][0] Then
		If $iTHy < $InternalArea[0][1] Then
			Return "BOTTOM-RIGHT"
		Else
			Return "TOP-RIGHT"
		EndIf
	Else
		If $iTHy < $InternalArea[0][1] Then
			Return "BOTTOM-LEFT"
		Else
			Return "TOP-LEFT"
		EndIf
	EndIf
EndFunc   ;==>_CSVEstimateMainSide

; #FUNCTION# ====================================================================================================================
; Name ..........: Algorithm_AttackCSV
; Description ...:
; Syntax ........: Algorithm_AttackCSV([$testattack = False])
; Parameters ....: $testattack          - [optional]
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......: CodeSlinger69 (2017), mxkcz (2026)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func Algorithm_AttackCSV($testattack = False, $captureredarea = True)

	Local $g_aiPixelNearCollectorTopLeft[0]
	Local $g_aiPixelNearCollectorBottomLeft[0]
	Local $g_aiPixelNearCollectorTopRight[0]
	Local $g_aiPixelNearCollectorBottomRight[0]
	Local $aResult
	Local $bGoldCached = False
	Local $bElixirCached = False
	Local $iPreDropMs = 0
	Local $fPreDropSeconds = 0

	$g_bCSVAttackActive = True
	$g_bCSVFirstDropLogged = False

	;00 read attack file SIDE row and valorize variables
	Local $bPrepOk = AttackCSV_ApplyPrepared($g_iMatchMode, $g_iSearchTH)
_CSVResetCSVDiagnostics()
_CSVInitTHContext($g_iSearchTH, "attack", True)
	$g_iCSVLastTroopPositionDropTroopFromINI = -1
	If _Sleep($DELAYRESPOND) Then Return CSV_AttackCleanup()
	AttackTiming_Reset()
	CSV_LogTiming("attack start", "mode=" & $g_asModeText[$g_iMatchMode])
	CSV_LogTiming("pre-drop start", "mode=" & $g_asModeText[$g_iMatchMode])

	; Pre-scan MAKE usage for targeted-only optimizations
	Local $sMakeScript = ($g_iMatchMode = $DB ? $g_sAttackScrScriptName[$DB] : $g_sAttackScrScriptName[$LB])
	Local $aMakeSidesUsed[4] = [False, False, False, False] ; TL, TR, BL, BR
	Local $bAllMakeTargeted = False
	Local $iCSVMaxReturnPointsOverride = Default
	If AttackCSV_GetPreparedMakeUsage($g_iMatchMode, $aMakeSidesUsed, $bAllMakeTargeted) Then
		SetDebugLog("CSV MAKE pre-scan: targetedOnly=" & ($bAllMakeTargeted ? "yes" : "no"), $COLOR_DEBUG)
	Else
		SetDebugLog("CSV MAKE pre-scan failed", $COLOR_WARNING)
	EndIf
	$g_bCSVTargetedOnlyActive = $bAllMakeTargeted
	If $bAllMakeTargeted Then
		Local $bHasWeights = False
		For $w = 0 To UBound($g_aiCSVSideBWeights) - 1
			If $g_aiCSVSideBWeights[$w] > 0 Then
				$bHasWeights = True
				ExitLoop
			EndIf
		Next
		Local $bHasTargets = ($g_asCSVPrepTargetEnums[$g_iMatchMode] <> "") Or ($g_abCSVPrepHasPrioMake[$g_iMatchMode] And $bHasWeights)
		If Not $bHasTargets Then
			Local $sDiag = "CSV targeted-only guard: no target enums/weights; forcing redline"
			SetLog($sDiag, $COLOR_WARNING)
			_CSVAddDiagnosticLine($sDiag)
			$bAllMakeTargeted = False
			$g_bCSVTargetedOnlyActive = False
		EndIf
	EndIf
	Local $iTargetedCap = AttackCSV_GetTargetedOnlyCap($g_iMatchMode, $g_iCSVTargetedMaxReturnPoints)
	If $bAllMakeTargeted And $iTargetedCap > 0 Then
		$iCSVMaxReturnPointsOverride = AttackCSV_GetTargetMaxReturnPoints($g_iMatchMode, $g_iSearchTH, $iTargetedCap)
		If $iCSVMaxReturnPointsOverride <> Default Then
			SetDebugLog("CSV targeted MAKE: capping building locate maxReturnPoints to " & $iCSVMaxReturnPointsOverride, $COLOR_DEBUG)
		EndIf
	EndIf

Local $bAnyLocate = _CSVHasAnyLocateFlag($g_iMatchMode, $g_iSearchTH)

	;01 - TROOPS ------------------------------------------------------------------------------------------------------------------------------------------
	debugAttackCSV("Troops to be used (purged from troops) ")
	For $i = 0 To UBound($g_avAttackTroops) - 1 ; identify the position of this kind of troop
		debugAttackCSV("SLOT n.: " & $i & " - Troop: " & GetTroopName($g_avAttackTroops[$i][0]) & " (" & $g_avAttackTroops[$i][0] & ") - Quantity: " & $g_avAttackTroops[$i][1])
	Next

	Local $hTimerTOTAL = __timerinit()
	;02.01 - REDAREA -----------------------------------------------------------------------------------------------------------------------------------------
	Local $hTimer = __timerinit()

	SetDebugLog("Redline mode: " & $g_aiAttackScrRedlineRoutine[$g_iMatchMode])
	SetDebugLog("Dropline mode: " & $g_aiAttackScrDroplineEdge[$g_iMatchMode])

	Local $bSkipRedArea = (Not $bAnyLocate) And $bAllMakeTargeted
	If $bSkipRedArea Then
		SetDebugLog("CSV redline skipped: no locate flags and targeted-only MAKE", $COLOR_DEBUG)
	Else
		CSV_LogTiming("capture", "Algorithm_AttackCSV redline")
		_CaptureRegion2() ; ensure full screen is captured (not ideal for debugging as clean image was already saved, but...)
		If $captureredarea Then _GetRedArea($g_aiAttackScrRedlineRoutine[$g_iMatchMode])
		If _Sleep($DELAYRESPOND) Then Return CSV_AttackCleanup()

		Local $htimerREDAREA = Round(__timerdiff($hTimer) / 1000, 2)
		CSV_LogTiming("redline done", "Algorithm_AttackCSV")
		debugAttackCSV("Calculated  (in " & $htimerREDAREA & " seconds) :")
		debugAttackCSV("	[" & (IsArray($g_aiPixelTopLeft) ? UBound($g_aiPixelTopLeft) : 0) & "] pixels TopLeft")
		debugAttackCSV("	[" & (IsArray($g_aiPixelTopRight) ? UBound($g_aiPixelTopRight) : 0) & "] pixels TopRight")
		debugAttackCSV("	[" & (IsArray($g_aiPixelBottomLeft) ? UBound($g_aiPixelBottomLeft) : 0) & "] pixels BottomLeft")
		debugAttackCSV("	[" & (IsArray($g_aiPixelBottomRight) ? UBound($g_aiPixelBottomRight) : 0) & "] pixels BottomRight")
	EndIf

	; Drop line build moved to post-MAIN side so we can skip unused sides.

	; 03 - TOWNHALL ------------------------------------------------------------------------

If $g_bCSVLocateStorageTownHall = True Then
	CSV_LogTiming("locate start", "townhall")
	If $g_iSearchTH = "-" Or $g_oBldgAttackInfo.Exists($eBldgTownHall & "_LOCATION") = False Then ; If TH is unknown, try again to find as it is needed by script
		imglocTHSearch(True, False, False)
	Else
		SetLog("> Townhall has already been located in while searching for an image", $COLOR_INFO)
	EndIf
	CSV_LogTiming("locate done", "townhall")
Else
	SetLog("> Townhall search not needed, skip")
	EndIf
	If _Sleep($DELAYRESPOND) Then Return CSV_AttackCleanup()

	;04 - MINES, COLLECTORS, DRILLS -----------------------------------------------------------------------------------------------------------------------

	;reset variables
	Global $g_aiPixelMine[0]
	Global $g_aiPixelElixir[0]
	Global $g_aiPixelDarkElixir[0]
	Local $g_aiPixelNearCollectorTopLeftSTR = ""
	Local $g_aiPixelNearCollectorBottomLeftSTR = ""
	Local $g_aiPixelNearCollectorTopRightSTR = ""
	Local $g_aiPixelNearCollectorBottomRightSTR = ""
	Local $bCollectorsSuspended = False

If $g_bCSVLocateMine Or $g_bCSVLocateElixir Or $g_bCSVLocateDrill Then
	CSV_LogTiming("locate start", "collectors")
	SuspendAndroid()
	$bCollectorsSuspended = True
Else
	CSV_LogTiming("locate skipped", "collectors")
EndIf


	;04.01 If drop troop near gold mine
	If $g_bCSVLocateMine Then
		$hTimer = __timerinit()
		$g_aiPixelMine = GetLocationMine()
		If _Sleep($DELAYRESPOND) Then
			If $bCollectorsSuspended Then ResumeAndroid()
			Return CSV_AttackCleanup()
		EndIf
		CleanRedArea($g_aiPixelMine)
		Local $htimerMine = Round(__timerdiff($hTimer) / 1000, 2)
		If (IsArray($g_aiPixelMine)) Then
			For $i = 0 To UBound($g_aiPixelMine) - 1
				Local $pixel = $g_aiPixelMine[$i]
				Local $str = $pixel[0] & "-" & $pixel[1] & "-" & "MINE"
				If isInsideDiamond($pixel) Then
					If $pixel[0] <= $InternalArea[2][0] Then
						If $pixel[1] <= $InternalArea[0][1] Then
							;SetLog($str & " :  TOP LEFT SIDE")
							$g_aiPixelNearCollectorTopLeftSTR &= $str & "|"
						Else
							;SetLog($str & " :  BOTTOM LEFT SIDE")
							$g_aiPixelNearCollectorBottomLeftSTR &= $str & "|"
						EndIf
					Else
						If $pixel[1] <= $InternalArea[0][1] Then
							;SetLog($str & " :  TOP RIGHT SIDE")
							$g_aiPixelNearCollectorTopRightSTR &= $str & "|"
						Else
							;SetLog($str & " :  BOTTOM RIGHT SIDE")
							$g_aiPixelNearCollectorBottomRightSTR &= $str & "|"
						EndIf
					EndIf
				EndIf
			Next
		EndIf
		SetLog("> Mines located in " & Round(__timerdiff($hTimer) / 1000, 2) & " seconds", $COLOR_INFO)
	Else
		SetLog("> Mines detection not needed, skip", $COLOR_INFO)
	EndIf
	If _Sleep($DELAYRESPOND) Then
		If $bCollectorsSuspended Then ResumeAndroid()
		Return CSV_AttackCleanup()
	EndIf

	;04.02  If drop troop near elisir
	If $g_bCSVLocateElixir Then
		$hTimer = __timerinit()
		$g_aiPixelElixir = GetLocationElixir()
		If _Sleep($DELAYRESPOND) Then
			If $bCollectorsSuspended Then ResumeAndroid()
			Return CSV_AttackCleanup()
		EndIf
		CleanRedArea($g_aiPixelElixir)
		Local $htimerMine = Round(__timerdiff($hTimer) / 1000, 2)
		If (IsArray($g_aiPixelElixir)) Then
			For $i = 0 To UBound($g_aiPixelElixir) - 1
				Local $pixel = $g_aiPixelElixir[$i]
				Local $str = $pixel[0] & "-" & $pixel[1] & "-" & "ELIXIR"
				If isInsideDiamond($pixel) Then
					If $pixel[0] <= $InternalArea[2][0] Then
						If $pixel[1] <= $InternalArea[0][1] Then
							;SetLog($str & " :  TOP LEFT SIDE")
							$g_aiPixelNearCollectorTopLeftSTR &= $str & "|"
						Else
							;SetLog($str & " :  BOTTOM LEFT SIDE")
							$g_aiPixelNearCollectorBottomLeftSTR &= $str & "|"
						EndIf
					Else
						If $pixel[1] <= $InternalArea[0][1] Then
							;SetLog($str & " :  TOP RIGHT SIDE")
							$g_aiPixelNearCollectorTopRightSTR &= $str & "|"
						Else
							;SetLog($str & " :  BOTTOM RIGHT SIDE")
							$g_aiPixelNearCollectorBottomRightSTR &= $str & "|"
						EndIf
					EndIf
				EndIf
			Next
		EndIf
		SetLog("> Elixir collectors located in " & Round(__timerdiff($hTimer) / 1000, 2) & " seconds", $COLOR_INFO)
	Else
		SetLog("> Elixir collectors detection not needed, skip", $COLOR_INFO)
	EndIf
	If _Sleep($DELAYRESPOND) Then
		If $bCollectorsSuspended Then ResumeAndroid()
		Return CSV_AttackCleanup()
	EndIf

	;04.03 If drop troop near drill
	If $g_bCSVLocateDrill Then
		;SetLog("Locating drills")
		$hTimer = __timerinit()
		$g_aiPixelDarkElixir = GetLocationDarkElixir()
		If _Sleep($DELAYRESPOND) Then
			If $bCollectorsSuspended Then ResumeAndroid()
			Return CSV_AttackCleanup()
		EndIf
		CleanRedArea($g_aiPixelDarkElixir)
		Local $htimerMine = Round(__timerdiff($hTimer) / 1000, 2)
		If (IsArray($g_aiPixelDarkElixir)) Then
			For $i = 0 To UBound($g_aiPixelDarkElixir) - 1
				Local $pixel = $g_aiPixelDarkElixir[$i]
				Local $str = $pixel[0] & "-" & $pixel[1] & "-" & "DRILL"
				If isInsideDiamond($pixel) Then
					If $pixel[0] <= $InternalArea[2][0] Then
						If $pixel[1] <= $InternalArea[0][1] Then
							;SetLog($str & " :  TOP LEFT SIDE")
							$g_aiPixelNearCollectorTopLeftSTR &= $str & "|"
						Else
							;SetLog($str & " :  BOTTOM LEFT SIDE")
							$g_aiPixelNearCollectorBottomLeftSTR &= $str & "|"
						EndIf
					Else
						If $pixel[1] <= $InternalArea[0][1] Then
							;SetLog($str & " :  TOP RIGHT SIDE")
							$g_aiPixelNearCollectorTopRightSTR &= $str & "|"
						Else
							;SetLog($str & " :  BOTTOM RIGHT SIDE")
							$g_aiPixelNearCollectorBottomRightSTR &= $str & "|"
						EndIf
					EndIf
				EndIf
			Next
		EndIf
		SetLog("> Drills located in " & Round(__timerdiff($hTimer) / 1000, 2) & " seconds", $COLOR_INFO)
	Else
		SetLog("> Drills detection not needed, skip", $COLOR_INFO)
	EndIf
	If $bCollectorsSuspended Then
		ResumeAndroid()
		CSV_LogTiming("locate done", "collectors")
	EndIf
	If _Sleep($DELAYRESPOND) Then Return CSV_AttackCleanup()

	If StringLen($g_aiPixelNearCollectorTopLeftSTR) > 0 Then $g_aiPixelNearCollectorTopLeftSTR = StringLeft($g_aiPixelNearCollectorTopLeftSTR, StringLen($g_aiPixelNearCollectorTopLeftSTR) - 1)
	If StringLen($g_aiPixelNearCollectorTopRightSTR) > 0 Then $g_aiPixelNearCollectorTopRightSTR = StringLeft($g_aiPixelNearCollectorTopRightSTR, StringLen($g_aiPixelNearCollectorTopRightSTR) - 1)
	If StringLen($g_aiPixelNearCollectorBottomLeftSTR) > 0 Then $g_aiPixelNearCollectorBottomLeftSTR = StringLeft($g_aiPixelNearCollectorBottomLeftSTR, StringLen($g_aiPixelNearCollectorBottomLeftSTR) - 1)
	If StringLen($g_aiPixelNearCollectorBottomRightSTR) > 0 Then $g_aiPixelNearCollectorBottomRightSTR = StringLeft($g_aiPixelNearCollectorBottomRightSTR, StringLen($g_aiPixelNearCollectorBottomRightSTR) - 1)
	$g_aiPixelNearCollectorTopLeft = GetListPixel3($g_aiPixelNearCollectorTopLeftSTR)
	$g_aiPixelNearCollectorTopRight = GetListPixel3($g_aiPixelNearCollectorTopRightSTR)
	$g_aiPixelNearCollectorBottomLeft = GetListPixel3($g_aiPixelNearCollectorBottomLeftSTR)
	$g_aiPixelNearCollectorBottomRight = GetListPixel3($g_aiPixelNearCollectorBottomRightSTR)


	; 05 - Gold, Elixir and Dark Elixir STORAGES ------------------------------------------------------------------------

	If $g_bCSVLocateStorageGold Or $g_bCSVLocateStorageElixir Or $g_bCSVLocateStorageDarkElixir Then
		CSV_LogTiming("locate start", "storages")
	Else
		CSV_LogTiming("locate skipped", "storages")
	EndIf
	If $g_bCSVLocateStorageGold Then
		$bGoldCached = False
		If _ObjSearch($g_oBldgAttackInfo, $eBldgGoldS & "_LOCATION") Then
			$aResult = _ObjGetValue($g_oBldgAttackInfo, $eBldgGoldS & "_LOCATION")
			If Not @error And IsArray($aResult) Then
				$g_aiCSVGoldStoragePos = $aResult
				$bGoldCached = True
				SetDebugLog("CSV storage cache hit: " & $g_sBldgNames[$eBldgGoldS], $COLOR_DEBUG)
			EndIf
		EndIf
		If Not $bGoldCached Then
			$aResult = GetLocationBuilding($eBldgGoldS, $g_iSearchTH, False, $iCSVMaxReturnPointsOverride)
			If $aResult <> -1 Then ; check if Monkey ate bad banana
				If $aResult = 1 Then
					SetLog("> " & $g_sBldgNames[$eBldgGoldS] & " Not found", $COLOR_WARNING)
				Else
					$aResult = _ObjGetValue($g_oBldgAttackInfo, $eBldgGoldS & "_LOCATION")
					If @error Then
						_ObjErrMsg("_ObjGetValue " & $g_sBldgNames[$eBldgGoldS] & " _LOCATION", @error) ; Log errors
						SetLog("> " & $g_sBldgNames[$eBldgGoldS] & " location not in dictionary", $COLOR_WARNING)
					Else
						If IsArray($aResult) Then $g_aiCSVGoldStoragePos = $aResult
					EndIf
				EndIf
			Else
				SetLog("Monkey ate bad banana: " & "GetLocationBuilding " & $g_sBldgNames[$eBldgGoldS], $COLOR_ERROR)
			EndIf
		EndIf
	EndIf

	If $g_bCSVLocateStorageElixir Then
		$bElixirCached = False
		If _ObjSearch($g_oBldgAttackInfo, $eBldgElixirS & "_LOCATION") Then
			$aResult = _ObjGetValue($g_oBldgAttackInfo, $eBldgElixirS & "_LOCATION")
			If Not @error And IsArray($aResult) Then
				$g_aiCSVElixirStoragePos = $aResult
				$bElixirCached = True
				SetDebugLog("CSV storage cache hit: " & $g_sBldgNames[$eBldgElixirS], $COLOR_DEBUG)
			EndIf
		EndIf
		If Not $bElixirCached Then
			$aResult = GetLocationBuilding($eBldgElixirS, $g_iSearchTH, False, $iCSVMaxReturnPointsOverride)
			If @error And $g_bDebugSetlog Then _logErrorGetBuilding(@error)
			If $aResult <> -1 Then ; check if Monkey ate bad banana
				If $aResult = 1 Then
					SetLog("> " & $g_sBldgNames[$eBldgElixirS] & " Not found", $COLOR_WARNING)
				Else
					$aResult = _ObjGetValue($g_oBldgAttackInfo, $eBldgElixirS & "_LOCATION")
					If @error Then
						_ObjErrMsg("_ObjGetValue " & $g_sBldgNames[$eBldgElixirS] & " _LOCATION", @error) ; Log errors
						SetLog("> " & $g_sBldgNames[$eBldgElixirS] & " location not in dictionary", $COLOR_WARNING)
					Else
						If IsArray($aResult) Then $g_aiCSVElixirStoragePos = $aResult
					EndIf
				EndIf
			Else
				SetLog("Monkey ate bad banana: " & "GetLocationBuilding " & $g_sBldgNames[$eBldgElixirS], $COLOR_ERROR)
			EndIf
		EndIf
	EndIf

	If $g_bCSVLocateStorageDarkElixir = True Then
		$hTimer = __timerinit()
		SuspendAndroid()
		; USES OLD OPENCV DETECTION
		Local $g_aiPixelDarkElixirStorage = GetLocationDarkElixirStorageWithLevel()
		ResumeAndroid()
		If _Sleep($DELAYRESPOND) Then Return CSV_AttackCleanup()
		CleanRedArea($g_aiPixelDarkElixirStorage)
		Local $pixel = StringSplit($g_aiPixelDarkElixirStorage, "#", 2)
		If UBound($pixel) >= 2 Then
			Local $pixellevel = $pixel[0]
			Local $pixelpos = StringSplit($pixel[1], "-", 2)
			If UBound($pixelpos) >= 2 Then
				Local $temp = [Int($pixelpos[0]), Int($pixelpos[1])]
				$g_aiCSVDarkElixirStoragePos = $temp
			EndIf
		EndIf
		SetLog("> Dark Elixir Storage located in " & Round(__timerdiff($hTimer) / 1000, 2) & " seconds", $COLOR_INFO)
	Else
		SetLog("> Dark Elixir Storage detection not needed, skip", $COLOR_INFO)
	EndIf
	If $g_bCSVLocateStorageGold Or $g_bCSVLocateStorageElixir Or $g_bCSVLocateStorageDarkElixir Then
		CSV_LogTiming("locate done", "storages")
	EndIf

	; Pre-fetch defense building locations in a single batch pass
	Local $bSkipDefenseLocate = $g_bCSVPrecacheDone[$g_iMatchMode]
	If $bSkipDefenseLocate Then SetDebugLog("CSV precache: skipping defense locate calls", $COLOR_DEBUG)
	If Not $bSkipDefenseLocate Then
		CSV_LogTiming("locate start", "defenses")
		AttackCSV_BatchLocateBuildings($iCSVMaxReturnPointsOverride)
		CSV_LogTiming("locate done", "defenses")
	Else
		CSV_LogTiming("locate skipped", "defenses precache")
	EndIf

	; 06 - EAGLE ARTILLERY ------------------------------------------------------------------------

	$g_aiCSVEagleArtilleryPos = "" ; reset pixel position to null

	If $g_bCSVLocateEagle = True Then ; eagle find required?
		If $g_iSearchTH = "-" Or $g_iSearchTH > 10 Then ; TH level where eagle exists?
			If _ObjSearch($g_oBldgAttackInfo, $eBldgEagle & "_LOCATION") = False And Not $bSkipDefenseLocate Then ; get data if not already exist?
				$aResult = GetLocationBuilding($eBldgEagle, $g_iSearchTH, False, $iCSVMaxReturnPointsOverride)
				If $aResult = -1 Then SetLog("Monkey ate bad banana: " & "GetLocationBuilding " & $g_sBldgNames[$eBldgEagle], $COLOR_ERROR)
			EndIf
			$aResult = _ObjGetValue($g_oBldgAttackInfo, $eBldgEagle & "_LOCATION")
			If @error Then
				_ObjErrMsg("_ObjGetValue " & $g_sBldgNames[$eBldgEagle] & " _LOCATION", @error) ; Log errors
				SetLog("> " & $g_sBldgNames[$eBldgEagle] & " location not in dictionary", $COLOR_WARNING)
			Else
				If IsArray($aResult[0]) Then $g_aiCSVEagleArtilleryPos = $aResult[0]
			EndIf
		Else
			SetLog("> TH Level to low for Eagle, skip detection", $COLOR_INFO)
		EndIf
	Else
		SetDebugLog("> Eagle Artillery detection not needed, skipping", $COLOR_DEBUG)
	EndIf

	; 07 - Scatter Shot ------------------------------------------------------------------------

	$g_aiCSVScatterPos = "" ; reset pixel position to null

	If $g_bCSVLocateScatter Then
		If $g_iSearchTH = "-" Or $g_iSearchTH > 10 Then
			If Not _ObjSearch($g_oBldgAttackInfo, $eBldgScatter & "_LOCATION") And Not $bSkipDefenseLocate Then ; get data if not already exist?
				$aResult = GetLocationBuilding($eBldgScatter, $g_iSearchTH, False, $iCSVMaxReturnPointsOverride)
				If $aResult = -1 Then SetLog("Monkey ate bad banana: " & "GetLocationBuilding " & $g_sBldgNames[$eBldgScatter], $COLOR_ERROR)
			EndIf
			$aResult = _ObjGetValue($g_oBldgAttackInfo, $eBldgScatter & "_LOCATION")
			If @error Then
				_ObjErrMsg("_ObjGetValue " & $g_sBldgNames[$eBldgScatter] & " _LOCATION", @error) ; Log errors
				SetLog("> " & $g_sBldgNames[$eBldgScatter] & " location not in dictionary", $COLOR_WARNING)
			Else
				If IsArray($aResult[0]) Then $g_aiCSVEagleArtilleryPos = $aResult[0]
			EndIf
		Else
			SetLog("> TH Level to low for Scatter Shot, skip detection", $COLOR_INFO)
		EndIf
	Else
		SetDebugLog("> Scatter Shot detection not needed, skipping", $COLOR_DEBUG)
	EndIf

	; 08 - Inferno ------------------------------------------------------------------------

	$g_aiCSVInfernoPos = "" ; reset location array?

	If $g_bCSVLocateInferno Then
		If $g_iSearchTH = "-" Or $g_iSearchTH > 9 Then
			If Not _ObjSearch($g_oBldgAttackInfo, $eBldgInferno & "_LOCATION") And Not $bSkipDefenseLocate Then
				$aResult = GetLocationBuilding($eBldgInferno, $g_iSearchTH, False, $iCSVMaxReturnPointsOverride)
				If $aResult = -1 Then SetLog("Monkey ate bad banana: " & "GetLocationBuilding " & $g_sBldgNames[$eBldgInferno], $COLOR_ERROR)
			EndIf
			$aResult = _ObjGetValue($g_oBldgAttackInfo, $eBldgInferno & "_LOCATION")
			If @error Then
				_ObjErrMsg("_ObjGetValue " & $g_sBldgNames[$eBldgInferno] & " _LOCATION", @error) ; Log errors
				SetLog("> " & $g_sBldgNames[$eBldgInferno] & " location not in dictionary", $COLOR_WARNING)
			Else
				If IsArray($aResult) Then $g_aiCSVInfernoPos = $aResult
			EndIf
		Else
			SetLog("> TH Level to low for Inferno, ignore location", $COLOR_INFO)
		EndIf
	Else
		SetDebugLog("> Inferno detection not needed, skipping", $COLOR_DEBUG)
	EndIf

	; 09 - X-Bow ------------------------------------------------------------------------

	$g_aiCSVXBowPos = "" ; reset location array?

	If $g_bCSVLocateXBow Then
		If $g_iSearchTH = "-" Or $g_iSearchTH > 8 Then
			If Not _ObjSearch($g_oBldgAttackInfo, $eBldgXBow & "_LOCATION") And Not $bSkipDefenseLocate Then
				$aResult = GetLocationBuilding($eBldgXBow, $g_iSearchTH, False, $iCSVMaxReturnPointsOverride)
				If $aResult = -1 Then SetLog("Monkey ate bad banana: " & "GetLocationBuilding " & $g_sBldgNames[$eBldgXBow], $COLOR_ERROR)
			EndIf
			$aResult = _ObjGetValue($g_oBldgAttackInfo, $eBldgXBow & "_LOCATION")
			If @error Then
				_ObjErrMsg("_ObjGetValue " & $g_sBldgNames[$eBldgXBow] & " _LOCATION", @error) ; Log errors
				SetLog("> " & $g_sBldgNames[$eBldgXBow] & " location not in dictionary", $COLOR_WARNING)
			Else
				If IsArray($aResult) Then $g_aiCSVXBowPos = $aResult
			EndIf
		Else
			SetLog("> TH Level to low for " & $g_sBldgNames[$eBldgXBow] & " , ignore location", $COLOR_INFO)
		EndIf
	Else
		SetDebugLog("> " & $g_sBldgNames[$eBldgXBow] & " detection not needed, skipping", $COLOR_DEBUG)
	EndIf


	; 10 - Wizard Tower -----------------------------------------------------------------

	$g_aiCSVWizTowerPos = "" ; reset location array?

	If $g_bCSVLocateWizTower Then
		If Not _ObjSearch($g_oBldgAttackInfo, $eBldgWizTower & "_LOCATION") And Not $bSkipDefenseLocate Then
			$aResult = GetLocationBuilding($eBldgWizTower, $g_iSearchTH, False, $iCSVMaxReturnPointsOverride)
			If $aResult = -1 Then SetLog("Monkey ate bad banana: " & "GetLocationBuilding " & $g_sBldgNames[$eBldgWizTower], $COLOR_ERROR)
		EndIf
		$aResult = _ObjGetValue($g_oBldgAttackInfo, $eBldgWizTower & "_LOCATION")
		If @error Then
			_ObjErrMsg("_ObjGetValue " & $g_sBldgNames[$eBldgWizTower] & " _LOCATION", @error) ; Log errors
			SetLog("> " & $g_sBldgNames[$eBldgWizTower] & " location not in dictionary", $COLOR_WARNING)
		Else
			If IsArray($aResult) Then $g_aiCSVWizTowerPos = $aResult
		EndIf
	Else
		SetDebugLog("> " & $g_sBldgNames[$eBldgWizTower] & " detection not needed, skipping", $COLOR_DEBUG)
	EndIf

	; 11 - Mortar ------------------------------------------------------------------------

	$g_aiCSVMortarPos = "" ; reset location array?

	If $g_bCSVLocateMortar Then
		If Not _ObjSearch($g_oBldgAttackInfo, $eBldgMortar & "_LOCATION") And Not $bSkipDefenseLocate Then
			$aResult = GetLocationBuilding($eBldgMortar, $g_iSearchTH, False, $iCSVMaxReturnPointsOverride)
			If $aResult = -1 Then SetLog("Monkey ate bad banana: " & "GetLocationBuilding " & $g_sBldgNames[$eBldgMortar], $COLOR_ERROR)
		EndIf
		$aResult = _ObjGetValue($g_oBldgAttackInfo, $eBldgMortar & "_LOCATION")
		If @error Then
			_ObjErrMsg("_ObjGetValue " & $g_sBldgNames[$eBldgMortar] & " _LOCATION", @error) ; Log errors
			SetLog("> " & $g_sBldgNames[$eBldgMortar] & " location not in dictionary", $COLOR_WARNING)
		Else
			If IsArray($aResult) Then $g_aiCSVMortarPos = $aResult
		EndIf
	Else
		SetDebugLog("> " & $g_sBldgNames[$eBldgMortar] & " detection not needed, skipping", $COLOR_DEBUG)
	EndIf

	; 12 - Air Defense ------------------------------------------------------------------------

	$g_aiCSVAirDefensePos = "" ; reset location array?

	If $g_bCSVLocateAirDefense Then
		If Not _ObjSearch($g_oBldgAttackInfo, $eBldgAirDefense & "_LOCATION") And Not $bSkipDefenseLocate Then
			$aResult = GetLocationBuilding($eBldgAirDefense, $g_iSearchTH, False, $iCSVMaxReturnPointsOverride)
			If $aResult = -1 Then SetLog("Monkey ate bad banana: " & "GetLocationBuilding " & $g_sBldgNames[$eBldgAirDefense], $COLOR_ERROR)
		EndIf
		$aResult = _ObjGetValue($g_oBldgAttackInfo, $eBldgAirDefense & "_LOCATION")
		If @error Then
			_ObjErrMsg("_ObjGetValue " & $g_sBldgNames[$eBldgAirDefense] & " _LOCATION", @error) ; Log errors
			SetLog("> " & $g_sBldgNames[$eBldgAirDefense] & " location not in dictionary", $COLOR_WARNING)
		Else
			If IsArray($aResult) Then $g_aiCSVAirDefensePos = $aResult
		EndIf
	Else
		SetDebugLog("> " & $g_sBldgNames[$eBldgAirDefense] & " detection not needed, skipping", $COLOR_DEBUG)
	EndIf

	; 12.1 - Air Sweeper ------------------------------------------------------------------------

	$g_aiCSVSweeperPos = "" ; reset location array?

	If $g_bCSVLocateSweeper Then
		If Not _ObjSearch($g_oBldgAttackInfo, $eBldgSweeper & "_LOCATION") And Not $bSkipDefenseLocate Then
			$aResult = GetLocationBuilding($eBldgSweeper, $g_iSearchTH, False, $iCSVMaxReturnPointsOverride)
			If $aResult = -1 Then SetLog("Monkey ate bad banana: " & "GetLocationBuilding " & $g_sBldgNames[$eBldgSweeper], $COLOR_ERROR)
		EndIf
		$aResult = _ObjGetValue($g_oBldgAttackInfo, $eBldgSweeper & "_LOCATION")
		If @error Then
			_ObjErrMsg("_ObjGetValue " & $g_sBldgNames[$eBldgSweeper] & " _LOCATION", @error) ; Log errors
			SetLog("> " & $g_sBldgNames[$eBldgSweeper] & " location not in dictionary", $COLOR_WARNING)
		Else
			If IsArray($aResult) Then $g_aiCSVSweeperPos = $aResult
		EndIf
	Else
		SetDebugLog("> " & $g_sBldgNames[$eBldgSweeper] & " detection not needed, skipping", $COLOR_DEBUG)
	EndIf

	; 12.2 - Monolith ------------------------------------------------------------------------

	$g_aiCSVMonolithPos = "" ; reset location array?

	If $g_bCSVLocateMonolith Then
		If Not _ObjSearch($g_oBldgAttackInfo, $eBldgMonolith & "_LOCATION") And Not $bSkipDefenseLocate Then
			$aResult = GetLocationBuilding($eBldgMonolith, $g_iSearchTH, False, $iCSVMaxReturnPointsOverride)
			If $aResult = -1 Then SetLog("Monkey ate bad banana: " & "GetLocationBuilding " & $g_sBldgNames[$eBldgMonolith], $COLOR_ERROR)
		EndIf
		$aResult = _ObjGetValue($g_oBldgAttackInfo, $eBldgMonolith & "_LOCATION")
		If @error Then
			_ObjErrMsg("_ObjGetValue " & $g_sBldgNames[$eBldgMonolith] & " _LOCATION", @error) ; Log errors
			SetLog("> " & $g_sBldgNames[$eBldgMonolith] & " location not in dictionary", $COLOR_WARNING)
		Else
			If IsArray($aResult) Then $g_aiCSVMonolithPos = $aResult
		EndIf
	Else
		SetDebugLog("> " & $g_sBldgNames[$eBldgMonolith] & " detection not needed, skipping", $COLOR_DEBUG)
	EndIf

	; 12.3 - Firespitter ------------------------------------------------------------------------

	$g_aiCSVFireSpitterPos = "" ; reset location array?

	If $g_bCSVLocateFireSpitter Then
		If Not _ObjSearch($g_oBldgAttackInfo, $eBldgFireSpitter & "_LOCATION") And Not $bSkipDefenseLocate Then
			$aResult = GetLocationBuilding($eBldgFireSpitter, $g_iSearchTH, False, $iCSVMaxReturnPointsOverride)
			If $aResult = -1 Then SetLog("Monkey ate bad banana: " & "GetLocationBuilding " & $g_sBldgNames[$eBldgFireSpitter], $COLOR_ERROR)
		EndIf
		$aResult = _ObjGetValue($g_oBldgAttackInfo, $eBldgFireSpitter & "_LOCATION")
		If @error Then
			_ObjErrMsg("_ObjGetValue " & $g_sBldgNames[$eBldgFireSpitter] & " _LOCATION", @error) ; Log errors
			SetLog("> " & $g_sBldgNames[$eBldgFireSpitter] & " location not in dictionary", $COLOR_WARNING)
		Else
			If IsArray($aResult) Then $g_aiCSVFireSpitterPos = $aResult
		EndIf
	Else
		SetDebugLog("> " & $g_sBldgNames[$eBldgFireSpitter] & " detection not needed, skipping", $COLOR_DEBUG)
	EndIf

	; 12.4 - Multi Archer Tower ------------------------------------------------------------------------

	$g_aiCSVMultiArcherTowerPos = "" ; reset location array?

	If $g_bCSVLocateMultiArcherTower Then
		If Not _ObjSearch($g_oBldgAttackInfo, $eBldgMultiArcherTower & "_LOCATION") And Not $bSkipDefenseLocate Then
			$aResult = GetLocationBuilding($eBldgMultiArcherTower, $g_iSearchTH, False, $iCSVMaxReturnPointsOverride)
			If $aResult = -1 Then SetLog("Monkey ate bad banana: " & "GetLocationBuilding " & $g_sBldgNames[$eBldgMultiArcherTower], $COLOR_ERROR)
		EndIf
		$aResult = _ObjGetValue($g_oBldgAttackInfo, $eBldgMultiArcherTower & "_LOCATION")
		If @error Then
			_ObjErrMsg("_ObjGetValue " & $g_sBldgNames[$eBldgMultiArcherTower] & " _LOCATION", @error) ; Log errors
			SetLog("> " & $g_sBldgNames[$eBldgMultiArcherTower] & " location not in dictionary", $COLOR_WARNING)
		Else
			If IsArray($aResult) Then $g_aiCSVMultiArcherTowerPos = $aResult
		EndIf
	Else
		SetDebugLog("> " & $g_sBldgNames[$eBldgMultiArcherTower] & " detection not needed, skipping", $COLOR_DEBUG)
	EndIf

	; 12.5 - Multi Gear Tower ------------------------------------------------------------------------
	$g_aiCSVMultiGearTowerPos = "" ; reset location array?

	If $g_bCSVLocateMultiGearTower Then
		If Not _ObjSearch($g_oBldgAttackInfo, $eBldgMultiGearTower & "_LOCATION") And Not $bSkipDefenseLocate Then
			$aResult = GetLocationBuilding($eBldgMultiGearTower, $g_iSearchTH, False, $iCSVMaxReturnPointsOverride)
			If $aResult = -1 Then SetLog("Monkey ate bad banana: " & "GetLocationBuilding " & $g_sBldgNames[$eBldgMultiGearTower], $COLOR_ERROR)
		EndIf
		$aResult = _ObjGetValue($g_oBldgAttackInfo, $eBldgMultiGearTower & "_LOCATION")
		If @error Then
			_ObjErrMsg("_ObjGetValue " & $g_sBldgNames[$eBldgMultiGearTower] & " _LOCATION", @error) ; Log errors
			SetLog("> " & $g_sBldgNames[$eBldgMultiGearTower] & " location not in dictionary", $COLOR_WARNING)
		Else
			If IsArray($aResult) Then $g_aiCSVMultiGearTowerPos = $aResult
		EndIf
	Else
		SetDebugLog("> " & $g_sBldgNames[$eBldgMultiGearTower] & " detection not needed, skipping", $COLOR_DEBUG)
	EndIf
	
	; 12.6 - Ricochet Cannon ------------------------------------------------------------------------

	$g_aiCSVRicochetCannonPos = "" ; reset location array?

	If $g_bCSVLocateRicochetCannon Then
		If Not _ObjSearch($g_oBldgAttackInfo, $eBldgRicochetCannon & "_LOCATION") And Not $bSkipDefenseLocate Then
			$aResult = GetLocationBuilding($eBldgRicochetCannon, $g_iSearchTH, False, $iCSVMaxReturnPointsOverride)
			If $aResult = -1 Then SetLog("Monkey ate bad banana: " & "GetLocationBuilding " & $g_sBldgNames[$eBldgRicochetCannon], $COLOR_ERROR)
		EndIf
		$aResult = _ObjGetValue($g_oBldgAttackInfo, $eBldgRicochetCannon & "_LOCATION")
		If @error Then
			_ObjErrMsg("_ObjGetValue " & $g_sBldgNames[$eBldgRicochetCannon] & " _LOCATION", @error) ; Log errors
			SetLog("> " & $g_sBldgNames[$eBldgRicochetCannon] & " location not in dictionary", $COLOR_WARNING)
		Else
			If IsArray($aResult) Then $g_aiCSVRicochetCannonPos = $aResult
		EndIf
	Else
		SetDebugLog("> " & $g_sBldgNames[$eBldgRicochetCannon] & " detection not needed, skipping", $COLOR_DEBUG)
	EndIf

	; 12.7 - Super Wizard Tower ------------------------------------------------------------------------
	$g_aiCSVSuperWizTowerPos = "" ; reset location array?

	If $g_bCSVLocateSuperWizTower Then
		If $g_bCSVUseWizTowerForSuperWiz Then
			; Super Wizard Tower not unlocked/unknown TH: reuse Wizard Tower detection
			If Not _ObjSearch($g_oBldgAttackInfo, $eBldgWizTower & "_LOCATION") And Not $bSkipDefenseLocate Then
				$aResult = GetLocationBuilding($eBldgWizTower, $g_iSearchTH, False, $iCSVMaxReturnPointsOverride)
				If $aResult = -1 Then SetLog("Monkey ate bad banana: " & "GetLocationBuilding " & $g_sBldgNames[$eBldgWizTower], $COLOR_ERROR)
			EndIf
			$aResult = _ObjGetValue($g_oBldgAttackInfo, $eBldgWizTower & "_LOCATION")
			If @error Then
				_ObjErrMsg("_ObjGetValue " & $g_sBldgNames[$eBldgWizTower] & " _LOCATION", @error) ; Log errors
				SetLog("> " & $g_sBldgNames[$eBldgWizTower] & " location not in dictionary", $COLOR_WARNING)
			Else
				If IsArray($aResult) Then
					$g_aiCSVSuperWizTowerPos = $aResult
					If _ObjSearch($g_oBldgAttackInfo, $eBldgSuperWizTower & "_LOCATION") Then
						_ObjPutValue($g_oBldgAttackInfo, $eBldgSuperWizTower & "_LOCATION", $aResult)
					Else
						_ObjAdd($g_oBldgAttackInfo, $eBldgSuperWizTower & "_LOCATION", $aResult)
					EndIf
					If _ObjSearch($g_oBldgAttackInfo, $eBldgWizTower & "_OBJECTPOINTS") Then
						Local $sWizPoints = _ObjGetValue($g_oBldgAttackInfo, $eBldgWizTower & "_OBJECTPOINTS")
						If Not @error And $sWizPoints <> "" Then
							_ObjPutValue($g_oBldgAttackInfo, $eBldgSuperWizTower & "_OBJECTPOINTS", $sWizPoints)
						EndIf
					EndIf
				EndIf
			EndIf
		Else
			If Not _ObjSearch($g_oBldgAttackInfo, $eBldgSuperWizTower & "_LOCATION") And Not $bSkipDefenseLocate Then
				$aResult = GetLocationBuilding($eBldgSuperWizTower, $g_iSearchTH, False, $iCSVMaxReturnPointsOverride)
				If $aResult = -1 Then SetLog("Monkey ate bad banana: " & "GetLocationBuilding " & $g_sBldgNames[$eBldgSuperWizTower], $COLOR_ERROR)
			EndIf
			$aResult = _ObjGetValue($g_oBldgAttackInfo, $eBldgSuperWizTower & "_LOCATION")
			If @error Then
				_ObjErrMsg("_ObjGetValue " & $g_sBldgNames[$eBldgSuperWizTower] & " _LOCATION", @error) ; Log errors
				SetLog("> " & $g_sBldgNames[$eBldgSuperWizTower] & " location not in dictionary", $COLOR_WARNING)
			Else
				If IsArray($aResult) Then $g_aiCSVSuperWizTowerPos = $aResult
			EndIf
		EndIf
	Else
		SetDebugLog("> " & $g_sBldgNames[$eBldgSuperWizTower] & " detection not needed, skipping", $COLOR_DEBUG)
	EndIf

	; 12.8 - Revenge Tower ------------------------------------------------------------------------

	$g_aiCSVRevengeTowerPos = "" ; reset location array?

	If $g_bCSVLocateRevengeTower Then
		If Not _ObjSearch($g_oBldgAttackInfo, $eBldgRevengeTower & "_LOCATION") And Not $bSkipDefenseLocate Then
			$aResult = GetLocationBuilding($eBldgRevengeTower, $g_iSearchTH, False, $iCSVMaxReturnPointsOverride)
			If $aResult = -1 Then SetLog("Monkey ate bad banana: " & "GetLocationBuilding " & $g_sBldgNames[$eBldgRevengeTower], $COLOR_ERROR)
		EndIf
		$aResult = _ObjGetValue($g_oBldgAttackInfo, $eBldgRevengeTower & "_LOCATION")
		If @error Then
			_ObjErrMsg("_ObjGetValue " & $g_sBldgNames[$eBldgRevengeTower] & " _LOCATION", @error) ; Log errors
			SetLog("> " & $g_sBldgNames[$eBldgRevengeTower] & " location not in dictionary", $COLOR_WARNING)
		Else
			If IsArray($aResult) Then $g_aiCSVRevengeTowerPos = $aResult
		EndIf
	Else
		SetDebugLog("> " & $g_sBldgNames[$eBldgRevengeTower] & " detection not needed, skipping", $COLOR_DEBUG)
	EndIf

	; Targeted-only guard: ensure targets exist before skipping to redline fallback
	If $bAllMakeTargeted Then
		Local $iTargetEnumsFound = 0
		Local $sTargetEnums = $g_asCSVPrepTargetEnums[$g_iMatchMode]
		If $sTargetEnums <> "" Then
			Local $aTargetEnums = StringSplit($sTargetEnums, "|", $STR_NOCOUNT)
			For $t = 0 To UBound($aTargetEnums) - 1
				Local $iEnum = Int($aTargetEnums[$t])
				If $iEnum <= 0 Then ContinueLoop
				If _ObjSearch($g_oBldgAttackInfo, $iEnum & "_LOCATION") Then
					Local $aLoc = _ObjGetValue($g_oBldgAttackInfo, $iEnum & "_LOCATION")
					If Not @error And IsArray($aLoc) Then $iTargetEnumsFound += 1
				EndIf
			Next
		EndIf

		Local $iPrioTargets = 0
		If $g_abCSVPrepHasPrioMake[$g_iMatchMode] Then
			Local $aSideKeys[4] = ["TOP-LEFT", "TOP-RIGHT", "BOTTOM-LEFT", "BOTTOM-RIGHT"]
			For $s = 0 To 3
				Local $aTargets = _CSVPrioGetTargetsForSide($aSideKeys[$s])
				If Not @error And IsArray($aTargets) Then $iPrioTargets += UBound($aTargets)
			Next
		EndIf

		If ($iTargetEnumsFound + $iPrioTargets) <= 0 Then
			Local $sDiag = "CSV targeted-only guard: zero targets located (explicit=" & $iTargetEnumsFound & ", prio=" & $iPrioTargets & "), falling back to redline"
			SetLog($sDiag, $COLOR_WARNING)
			_CSVAddDiagnosticLine($sDiag)
			If $g_bCSVPrioStrict Then
				SetLog("CSV PRIOSTRICT: aborting attack due to missing targets", $COLOR_ERROR)
				$g_bCSVAbortAttack = True
				Return CSV_AttackCleanup()
			EndIf
			$bAllMakeTargeted = False
			$g_bCSVTargetedOnlyActive = False
		EndIf
	EndIf

	; Calculate main attack side
	If $g_sCSVMainSideEstimate <> "" Then SetDebugLog("CSV main side estimate (precache): " & $g_sCSVMainSideEstimate, $COLOR_DEBUG)
	CSV_LogTiming("phase start", "main side")
	Local $sMainSide = ParseAttackCSV_MainSide()
	CSV_LogTiming("phase done", "main side")
	; Re-scan MAKE usage after MAIN side mapping so droplines match the resolved sides
	If AttackCSV_ScanMakeUsage($sMakeScript, $aMakeSidesUsed, $bAllMakeTargeted) Then
		SetDebugLog("CSV MAKE sides: TL=" & $aMakeSidesUsed[0] & ", TR=" & $aMakeSidesUsed[1] & ", BL=" & $aMakeSidesUsed[2] & ", BR=" & $aMakeSidesUsed[3] & _
				", targetedOnly=" & ($bAllMakeTargeted ? "yes" : "no"), $COLOR_DEBUG)
	Else
		SetDebugLog("CSV MAKE scan failed, building full droplines", $COLOR_WARNING)
		$aMakeSidesUsed[0] = True
		$aMakeSidesUsed[1] = True
		$aMakeSidesUsed[2] = True
		$aMakeSidesUsed[3] = True
		$bAllMakeTargeted = False
	EndIf
	$g_bCSVTargetedOnlyActive = $bAllMakeTargeted
	CSV_LogTiming("phase start", "droplines")
	_CSVBuildDropLines($aMakeSidesUsed, $bAllMakeTargeted)
	CSV_LogTiming("phase done", "droplines")

	; 13 - Wall
	If $g_bCSVLocateWall Then
		Local $aCSVExternalWall[1], $aCSVInternalWall[1]
		If FindWallCSV($aCSVExternalWall, $aCSVInternalWall) Then
			_ObjAdd($g_oBldgAttackInfo, $eExternalWall & "_LOCATION", $aCSVExternalWall) ; save array of locations
			If @error Then _ObjErrMsg("_ObjAdd " & $g_sBldgNames[$eExternalWall] & " _LOCATION", @error) ; Log errors
			_ObjAdd($g_oBldgAttackInfo, $eInternalWall & "_LOCATION", $aCSVInternalWall) ; save array of locations
			If @error Then _ObjErrMsg("_ObjAdd " & $g_sBldgNames[$eInternalWall] & " _LOCATION", @error) ; Log errors
		EndIf
	EndIf

	; Log total CSV prep time
	$iPreDropMs = Round(__timerdiff($hTimerTOTAL))
	$fPreDropSeconds = Round($iPreDropMs / 1000, 2)
	CSV_LogTiming("pre-drop done", "total=" & $iPreDropMs & "ms")
	If $g_iCSVPrecalcBudgetMs > 0 And $iPreDropMs > $g_iCSVPrecalcBudgetMs Then
		SetLog("CSV pre-drop exceeded budget: " & $iPreDropMs & " ms (budget " & $g_iCSVPrecalcBudgetMs & " ms)", $COLOR_WARNING)
	EndIf
	SetLog(">> Total time: " & $fPreDropSeconds & " seconds", $COLOR_INFO)
	CSV_LogPrepSummary(3)

	; 14 - DEBUGIMAGE ------------------------------------------------------------------------
	If $g_bDebugMakeIMGCSV Then AttackCSVDEBUGIMAGE() ;make IMG debug
	If $g_bDebugAttackCSV Then _LogObjList($g_oBldgAttackInfo) ; display dictionary for raw find image debug

	; 15 - LAUNCH PARSE FUNCTION -------------------------------------------------------------
	SetSlotSpecialTroops()
	If _Sleep($DELAYRESPOND) Then Return CSV_AttackCleanup()
	;If $sMainSide = "BOTTOM-RIGHT" Or $sMainSide = "BOTTOM-LEFT" Then
	;	SetDebugLog("BOTTOM LEFT/RIGHT as MainSide, checking boost button")
	;	For $i = 1 To 15
	;		If QuickMIS("BFI", $g_sImgImgLocButtons & "\BoostButton*.xml", 300,520,390,550) Then
	;			If _Sleep(2000) Then Return
	;			SetLog("Wait Battle Start #" & $i, $COLOR_ACTION)
	;		Else
	;			If _Sleep(3000) Then Return
	;			ExitLoop
	;		EndIf
	;	Next
	;EndIf
	
	AttackTiming_Summary("pre-drop")
	ParseAttackCSV($testattack)

	CheckHeroesHealth()
	CSV_LogTiming("attack end", "mode=" & $g_asModeText[$g_iMatchMode])
	CSV_AttackCleanup()
EndFunc   ;==>Algorithm_AttackCSV

; #FUNCTION# ====================================================================================================================
; Name ..........: CSV_AttackCleanup
; Description ...: Reset CSV attack timing flags.
; Syntax ........: CSV_AttackCleanup()
; Parameters ....: None
; Return values .: Success: 0
; Author ........: mxkcz
; Modified ......: 
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func CSV_AttackCleanup()
	$g_bCSVAttackActive = False
	$g_bCSVFirstDropLogged = False
	Return 0
EndFunc   ;==>CSV_AttackCleanup

; #FUNCTION# ====================================================================================================================
; Name ..........: AttackCSV_LightweightRescan
; Description ...: Perform a bounded mid-attack rescan for missing/PRIO building enums only.
; Syntax ........: AttackCSV_LightweightRescan(ByRef $aForcedEnums, ByRef $aRescannedEnums, [$iBudgetMs = Default, $sReason = "", $bForceRescan = False])
; Parameters ....: $aForcedEnums     - Array of building enums to rescan (empty array = auto).
;                  $aRescannedEnums  - [out] Array of enums actually rescanned.
;				   $iBudgetMs        - [optional] Time budget in ms. Default uses $g_iCSVRecalcBudgetMs.
;                  $bForceRescan     - [optional] Force cache clearing (reserved).
;                  $sReason          - [optional] Rescan trigger reason for diagnostics.
; Return values .: Success: number of building enums rescanned.
;                  Failure: 0 when rescan skipped or blocked.
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
; Side-effect: io (updates building caches, PRIO plan caches, and diagnostics)
Func AttackCSV_LightweightRescan(ByRef $aForcedEnums, ByRef $aRescannedEnums, $iBudgetMs = Default, $sReason = "", $bForceRescan = False)
	Local $iBudgetLocal = Int($iBudgetMs)
	If $iBudgetMs = Default Or $iBudgetLocal <= 0 Then $iBudgetLocal = $g_iCSVRecalcBudgetMs
	If $sReason = "" Then $sReason = "RESCAN"
	$g_sCSVRescanLastReason = $sReason
	$g_iCSVRescanLastDurationMs = 0
	$g_iCSVRescanLastCount = 0
	$g_iCSVRescanLastBudgetMs = $iBudgetLocal
	$g_bCSVRescanLastBudgetExceeded = False
	$g_sCSVRescanLastFallback = ""
	Local $aRescannedLocal[0]
	Local $iForcedCount = (IsArray($aForcedEnums) ? UBound($aForcedEnums) : 0)
	If $bForceRescan Then CSV_LogRescan("force", "cache clear enabled", $COLOR_DEBUG)
	CSV_LogRescan("start", "reason=" & $sReason & " budget=" & $iBudgetLocal & "ms forced=" & $iForcedCount & _
			" vecOverride=" & ($g_sCSVRecalcVectorTargets = "" ? "AUTO" : $g_sCSVRecalcVectorTargets) & _
			" sideOverride=" & $g_sCSVRecalcSideOverride, $COLOR_INFO)
	$aRescannedEnums = $aRescannedLocal

	If Not IsObj($g_oBldgAttackInfo) Then
		$g_sCSVRescanLastFallback = "building cache missing"
		CSV_LogRescan("fallback", "keeping previous vectors (building cache missing)", $COLOR_WARNING)
		Return 0
	EndIf

	Local $sRedline = ""
	If _ObjSearch($g_oBldgAttackInfo, $eBldgRedLine & "_OBJECTPOINTS") Then
		$sRedline = _ObjGetValue($g_oBldgAttackInfo, $eBldgRedLine & "_OBJECTPOINTS")
	ElseIf $g_sImglocRedline <> "" Then
		$sRedline = $g_sImglocRedline
		_ObjAdd($g_oBldgAttackInfo, $eBldgRedLine & "_OBJECTPOINTS", $sRedline)
		If @error Then _ObjErrMsg("_ObjAdd $g_oBldgAttackInfo redline", @error)
		Local $aSplit = StringSplit($sRedline, "|", $STR_NOCOUNT)
		If IsArray($aSplit) And UBound($aSplit) > 0 Then
			_ObjAdd($g_oBldgAttackInfo, $eBldgRedLine & "_COUNT", UBound($aSplit))
			If @error Then _ObjErrMsg("_ObjAdd $g_oBldgAttackInfo redline count", @error)
		EndIf
	EndIf

	If Not IsString($sRedline) Or $sRedline = "" Or $sRedline = "ECD" Then
		$g_sCSVRescanLastFallback = "redline missing"
		CSV_LogRescan("fallback", "keeping previous vectors (redline missing)", $COLOR_WARNING)
		Return 0
	EndIf

	Local $aEnumsToRescan
	If IsArray($aForcedEnums) And UBound($aForcedEnums) > 0 Then
		$aEnumsToRescan = $aForcedEnums
	Else
		$aEnumsToRescan = _CSVRescanGetMissingEnums()
	EndIf
	If Not IsArray($aEnumsToRescan) Or UBound($aEnumsToRescan) = 0 Then
		$g_sCSVRescanLastFallback = "no missing/PRIO enums"
		CSV_LogRescan("skip", "no missing/PRIO enums", $COLOR_DEBUG)
		If $g_abCSVPrepHasPrioMake[$g_iMatchMode] Then _CSVPrioRebuildPlanFromLocations()
		Return 0
	EndIf

	Local $iCSVMaxReturnPointsOverride = Default
	Local $iTargetedCap = AttackCSV_GetTargetedOnlyCap($g_iMatchMode, $g_iCSVTargetedMaxReturnPoints)
	If $g_bCSVTargetedOnlyActive And $iTargetedCap > 0 Then
		$iCSVMaxReturnPointsOverride = AttackCSV_GetTargetMaxReturnPoints($g_iMatchMode, $g_iSearchTH, $iTargetedCap)
	EndIf

	_CaptureRegion2()
	Local $hTimer = __TimerInit()
	Local $iRescanned = 0
	Local $bBudgetExceeded = False

	For $i = 0 To UBound($aEnumsToRescan) - 1
		If __TimerDiff($hTimer) > $iBudgetLocal Then
			CSV_LogRescan("budget", "exceeded at " & $iRescanned & "/" & UBound($aEnumsToRescan), $COLOR_WARNING)
			$bBudgetExceeded = True
			ExitLoop
		EndIf
		Local $iEnum = $aEnumsToRescan[$i]
		_CSVBatchClearBuildingCache($iEnum)
		GetLocationBuilding($iEnum, $g_iSearchTH, False, $iCSVMaxReturnPointsOverride)
		$iRescanned += 1
		Local $iSize = UBound($aRescannedLocal)
		ReDim $aRescannedLocal[$iSize + 1]
		$aRescannedLocal[$iSize] = $iEnum
	Next

	If $g_abCSVPrepHasPrioMake[$g_iMatchMode] Then _CSVPrioRebuildPlanFromLocations()

	$g_iCSVRescanLastDurationMs = Round(__TimerDiff($hTimer))
	$g_iCSVRescanLastCount = $iRescanned
	$g_bCSVRescanLastBudgetExceeded = $bBudgetExceeded
	If $bBudgetExceeded Then
		$g_sCSVRescanLastFallback = "budget exceeded"
		CSV_LogRescan("fallback", "keeping previous vectors for remaining enums", $COLOR_WARNING)
	EndIf
	Local $sDoneDetail = "rescanned=" & $iRescanned & " duration=" & $g_iCSVRescanLastDurationMs & "ms budgetExceeded=" & ($bBudgetExceeded ? "yes" : "no")
	If $g_sCSVRescanLastFallback <> "" Then $sDoneDetail &= " fallback=" & $g_sCSVRescanLastFallback
	CSV_LogRescan("done", $sDoneDetail, $COLOR_INFO)
	If $aRescannedEnums <> Default Then $aRescannedEnums = $aRescannedLocal
	Return SetExtended(($bBudgetExceeded ? 1 : 0), $iRescanned)
EndFunc   ;==>AttackCSV_LightweightRescan

; #FUNCTION# ====================================================================================================================
; Name ..........: _CSVEnumInList
; Description ...: Check if an enum exists in a list.
; Syntax ........: _CSVEnumInList($aList, $iEnum)
; Parameters ....: $aList             - enum list array.
;                  $iEnum             - enum value to search.
; Return values .: Success: True/False
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
; Side-effect: pure
Func _CSVEnumInList($aList, $iEnum)
	If Not IsArray($aList) Then Return False
	For $i = 0 To UBound($aList) - 1
		If $aList[$i] = $iEnum Then Return True
	Next
	Return False
EndFunc   ;==>_CSVEnumInList

; #FUNCTION# ====================================================================================================================
; Name ..........: _CSVIsTargetLocationStillDetected
; Description ...: Check if a target location is still detected after rescan.
; Syntax ........: _CSVIsTargetLocationStillDetected($iEnum, ByRef $aTargetLoc)
; Parameters ....: $iEnum             - building enum.
;                  $aTargetLoc        - [in] location array [x,y].
; Return values .: Success: True/False
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
; Side-effect: pure
Func _CSVIsTargetLocationStillDetected($iEnum, ByRef $aTargetLoc)
	If $iEnum <= 0 Then Return False
	If Not IsObj($g_oBldgAttackInfo) Then Return False
	If Not IsArray($aTargetLoc) Then Return False
	Local $aLoc = _ObjGetValue($g_oBldgAttackInfo, $iEnum & "_LOCATION")
	If @error Or Not IsArray($aLoc) Then Return False
	If UBound($aLoc, 1) > 1 And IsArray($aLoc[1]) Then
		For $i = 0 To UBound($aLoc) - 1
			Local $aPoint = $aLoc[$i]
			If Not IsArray($aPoint) Then ContinueLoop
			If GetPixelDistance($aPoint, $aTargetLoc) <= $g_iCSVTargetRecalcTolerance Then Return True
		Next
	Else
		Local $aPoint = $aLoc[0]
		If IsArray($aPoint) And GetPixelDistance($aPoint, $aTargetLoc) <= $g_iCSVTargetRecalcTolerance Then Return True
	EndIf
	Return False
EndFunc   ;==>_CSVIsTargetLocationStillDetected

; #FUNCTION# ====================================================================================================================
; Name ..........: _CSVNormalizeRecalcSideOverride
; Description ...: Normalize the RECALC side override string.
; Syntax ........: _CSVNormalizeRecalcSideOverride($sValue[, $bLogInvalid = False])
; Parameters ....: $sValue            - input string.
;                  $bLogInvalid       - [optional] Log invalid values when True.
; Return values .: Success: normalized value ("NONE", "MAIN", or side token).
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _CSVNormalizeRecalcSideOverride($sValue, $bLogInvalid = False)
	Local $sUpper = StringUpper(StringStripWS($sValue, $STR_STRIPALL))
	If $sUpper = "" Or $sUpper = "NONE" Then Return "NONE"
	If $sUpper = "MAIN" Then Return "MAIN"
	Switch $sUpper
		Case "TOP-LEFT", "TOP-RIGHT", "BOTTOM-LEFT", "BOTTOM-RIGHT", _
				"FRONT-LEFT", "FRONT-RIGHT", "RIGHT-FRONT", "RIGHT-BACK", _
				"LEFT-FRONT", "LEFT-BACK", "BACK-LEFT", "BACK-RIGHT"
			Return $sUpper
	EndSwitch
	If $bLogInvalid Then SetDebugLog("CSV RECALC: invalid side override '" & $sValue & "', using NONE", $COLOR_WARNING)
	Return "NONE"
EndFunc   ;==>_CSVNormalizeRecalcSideOverride

; #FUNCTION# ====================================================================================================================
; Name ..........: _CSVVectorOverrideTokenToIndex
; Description ...: Convert a vector token (A or 1) to zero-based index.
; Syntax ........: _CSVVectorOverrideTokenToIndex($sToken)
; Parameters ....: $sToken            - token string.
; Return values .: Success: index (0..$g_iCSVVectorCount-1).
;                  Failure: -1.
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _CSVVectorOverrideTokenToIndex($sToken)
	Local $sTrim = StringStripWS($sToken, $STR_STRIPALL)
	If $sTrim = "" Then Return -1
	If StringIsInt($sTrim) Then
		Local $iVal = Int($sTrim)
		If $iVal < 1 Or $iVal > $g_iCSVVectorCount Then Return -1
		Return $iVal - 1
	EndIf
	If StringLen($sTrim) = 1 Then
		Local $iIndex = Asc(StringUpper($sTrim)) - 65
		If $iIndex < 0 Or $iIndex >= $g_iCSVVectorCount Then Return -1
		Return $iIndex
	EndIf
	Return -1
EndFunc   ;==>_CSVVectorOverrideTokenToIndex

; #FUNCTION# ====================================================================================================================
; Name ..........: _CSVVectorMaskToList
; Description ...: Convert a vector mask into a comma-separated letter list.
; Syntax ........: _CSVVectorMaskToList($iMask)
; Parameters ....: $iMask             - bitmask.
; Return values .: Success: list string.
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _CSVVectorMaskToList($iMask)
	Local $sList = ""
	For $i = 0 To $g_iCSVVectorCount - 1
		If BitAND($iMask, BitShift(1, -$i)) <> 0 Then
			If $sList <> "" Then $sList &= ","
			$sList &= Chr(65 + $i)
		EndIf
	Next
	Return $sList
EndFunc   ;==>_CSVVectorMaskToList

; #FUNCTION# ====================================================================================================================
; Name ..........: _CSVParseRecalcVectorOverrideMask
; Description ...: Parse RECALC vector override string into a bitmask.
; Syntax ........: _CSVParseRecalcVectorOverrideMask($sOverride, ByRef $sResolved, ByRef $sInvalid)
; Parameters ....: $sOverride         - override string.
;                  $sResolved         - [out] comma-separated resolved list.
;                  $sInvalid          - [out] comma-separated invalid tokens.
; Return values .: Success: bitmask (0 when none/invalid).
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _CSVParseRecalcVectorOverrideMask($sOverride, ByRef $sResolved, ByRef $sInvalid)
	$sResolved = ""
	$sInvalid = ""
	Local $sTrim = StringStripWS($sOverride, $STR_STRIPALL)
	If $sTrim = "" Or StringUpper($sTrim) = "AUTO" Then Return 0
	Local $aTokens = StringSplit($sOverride, ",", $STR_NOCOUNT)
	Local $iMask = 0
	For $i = 0 To UBound($aTokens) - 1
		Local $sToken = StringStripWS($aTokens[$i], $STR_STRIPALL)
		If $sToken = "" Then ContinueLoop
		Local $aRange = StringSplit($sToken, "-", $STR_NOCOUNT)
		If UBound($aRange) = 2 Then
			Local $iStart = _CSVVectorOverrideTokenToIndex($aRange[0])
			Local $iEnd = _CSVVectorOverrideTokenToIndex($aRange[1])
			If $iStart < 0 Or $iEnd < 0 Then
				If $sInvalid <> "" Then $sInvalid &= ","
				$sInvalid &= $sToken
				ContinueLoop
			EndIf
			If $iStart > $iEnd Then
				Local $iTmp = $iStart
				$iStart = $iEnd
				$iEnd = $iTmp
			EndIf
			For $j = $iStart To $iEnd
				$iMask = BitOR($iMask, BitShift(1, -$j))
			Next
		ElseIf UBound($aRange) = 1 Then
			Local $iIndex = _CSVVectorOverrideTokenToIndex($sToken)
			If $iIndex < 0 Then
				If $sInvalid <> "" Then $sInvalid &= ","
				$sInvalid &= $sToken
				ContinueLoop
			EndIf
			$iMask = BitOR($iMask, BitShift(1, -$iIndex))
		Else
			If $sInvalid <> "" Then $sInvalid &= ","
			$sInvalid &= $sToken
		EndIf
	Next
	$sResolved = _CSVVectorMaskToList($iMask)
	Return $iMask
EndFunc   ;==>_CSVParseRecalcVectorOverrideMask

; #FUNCTION# ====================================================================================================================
; Name ..........: AttackCSV_RecalcMakeVectors
; Description ...: Rebuild PRIO/targeted MAKE vectors used after the current line.
; Syntax ........: AttackCSV_RecalcMakeVectors([$iBudgetMs = Default[, $sReason = ""[, $bForceRebuild = False[, $iLine = -1]]]])
; Parameters ....: $iBudgetMs         - [optional] rescan budget in ms.
;                  $sReason           - [optional] rescan reason for diagnostics.
;                  $bForceRebuild     - [optional] force rebuild even if targets still detected.
;                  $iLine             - [optional] zero-based CSV line index.
; Return values .: Success: number of rebuilt vectors.
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
; Side-effect: io (rescans buildings, updates vectors, logs)
Func AttackCSV_RecalcMakeVectors($iBudgetMs = Default, $sReason = "", $bForceRebuild = False, $iLine = -1)
	Local $iBudgetLocal = Int($iBudgetMs)
	If $iBudgetMs = Default Or $iBudgetLocal <= 0 Then $iBudgetLocal = $g_iCSVRecalcBudgetMs
	If $sReason = "" Then $sReason = "RECALC"
	If $iLine < 0 Then Return 0

	Local $iMask = AttackCSV_GetVecUseMaskForLine($g_iMatchMode, $iLine)
	If $iMask = 0 Then
		CSV_LogRescan("recalc skip", "no vectors used after line " & ($iLine + 1), $COLOR_DEBUG)
		Return 0
	EndIf
	Local $sOverrideTrim = StringStripWS($g_sCSVRecalcVectorTargets, $STR_STRIPALL)
	If $sOverrideTrim <> "" And StringUpper($sOverrideTrim) <> "AUTO" Then
		Local $sVecResolved = ""
		Local $sVecInvalid = ""
		Local $iOverrideMask = _CSVParseRecalcVectorOverrideMask($g_sCSVRecalcVectorTargets, $sVecResolved, $sVecInvalid)
		If $sVecInvalid <> "" Then CSV_LogRescan("recalc override", "invalid tokens=" & $sVecInvalid, $COLOR_WARNING)
		If $iOverrideMask = 0 Then
			CSV_LogRescan("recalc override", "invalid, using usage mask", $COLOR_WARNING)
		Else
			CSV_LogRescan("recalc override", "vectors=" & $sVecResolved, $COLOR_INFO)
			$iMask = BitAND($iMask, $iOverrideMask)
			If $iMask = 0 Then
				CSV_LogRescan("recalc skip", "override yielded no eligible vectors after line " & ($iLine + 1), $COLOR_WARNING)
				Return 0
			EndIf
		EndIf
	EndIf

	Local $sSideOverride = ""
	Local $sSideOverrideNorm = _CSVNormalizeRecalcSideOverride($g_sCSVRecalcSideOverride, True)
	Switch $sSideOverrideNorm
		Case "MAIN"
			Local $sMainSide = StringUpper($MAINSIDE)
			If $sMainSide <> "" Then
				$sSideOverride = $sMainSide
			Else
				CSV_LogRescan("recalc side", "MAIN missing, using vector side", $COLOR_WARNING)
			EndIf
		Case "NONE"
			$sSideOverride = ""
		Case Else
			$sSideOverride = $sSideOverrideNorm
	EndSwitch
	If $sSideOverride <> "" Then CSV_LogRescan("recalc side", "override=" & $sSideOverride, $COLOR_INFO)

	Local $aVecIndex[0]
	Local $aForcedEnums[0]
	Local $bHasPrioVec = False
	Local $iListSize = 0
	For $i = 0 To $g_iCSVVectorCount - 1
		If BitAND($iMask, BitShift(1, -$i)) = 0 Then ContinueLoop
		Switch $g_aCSVMakeVecType[$i]
			Case $eCSVVecTypeTarget
				$iListSize = UBound($aVecIndex)
				ReDim $aVecIndex[$iListSize + 1]
				$aVecIndex[$iListSize] = $i
				Local $iTargetEnum = $g_aiCSVMakeVecTargetEnum[$i]
				If $iTargetEnum <= 0 Then $iTargetEnum = $g_aiCSVMakeVecResolvedEnum[$i]
				If $iTargetEnum > 0 Then _CSVBatchAddUnique($aForcedEnums, $iTargetEnum)
			Case $eCSVVecTypePrio
				$iListSize = UBound($aVecIndex)
				ReDim $aVecIndex[$iListSize + 1]
				$aVecIndex[$iListSize] = $i
				$bHasPrioVec = True
		EndSwitch
	Next

	If UBound($aVecIndex) = 0 Then
		CSV_LogRescan("recalc skip", "no targeted vectors after line " & ($iLine + 1), $COLOR_DEBUG)
		Return 0
	EndIf

	If $bHasPrioVec Then
		Local $aEnums, $aNames, $aWeightIndex
		_CSVGetPrioCandidateMap($aEnums, $aNames, $aWeightIndex)
		For $i = 0 To UBound($aEnums) - 1
			Local $iWeightIdx = $aWeightIndex[$i]
			If $iWeightIdx < 0 Or $iWeightIdx >= UBound($g_aiCSVSideBWeights) Then ContinueLoop
			If $g_aiCSVSideBWeights[$iWeightIdx] <= 0 Then ContinueLoop
			_CSVBatchAddUnique($aForcedEnums, $aEnums[$i])
		Next
		Local $iTHWeight = _CSVPrioGetTownHallWeight()
		If $iTHWeight > 0 And _CSVPrioIsWeaponizedTownHall() Then _CSVBatchAddUnique($aForcedEnums, $eBldgTownHall)
	EndIf

	If UBound($aForcedEnums) = 0 Then
		CSV_LogRescan("recalc skip", "no enums to rescan", $COLOR_DEBUG)
		Return 0
	EndIf

	Local $sEligibleVectors = ""
	For $i = 0 To UBound($aVecIndex) - 1
		If $sEligibleVectors <> "" Then $sEligibleVectors &= ","
		$sEligibleVectors &= Chr(65 + $aVecIndex[$i])
	Next
	CSV_LogRescan("recalc start", "reason=" & $sReason & _
			" budget=" & $iBudgetLocal & "ms forcedEnums=" & UBound($aForcedEnums) & _
			" vecOverride=" & ($g_sCSVRecalcVectorTargets = "" ? "AUTO" : $g_sCSVRecalcVectorTargets) & _
			" vectors=" & ($sEligibleVectors = "" ? "-" : $sEligibleVectors) & _
			" sideOverride=" & ($sSideOverride = "" ? "NONE" : $sSideOverride), $COLOR_INFO)
	Local $aRescanned[0]
	Local $iRescanned = AttackCSV_LightweightRescan($aForcedEnums, $aRescanned, $iBudgetLocal, $sReason, True)
	Local $bBudgetExceeded = (@extended = 1)

	Local $iRebuilt = 0
	Local $iKept = 0
	Local $iCleared = 0

	For $i = 0 To UBound($aVecIndex) - 1
		Local $iVecIndex = $aVecIndex[$i]
		Local $sVecKey = Chr(65 + $iVecIndex)
		Local $bTargetDetected = False
		Local $bCanEvaluate = False
		Local $iResolvedEnum = $g_aiCSVMakeVecResolvedEnum[$iVecIndex]
		Local $aTargetLoc[2] = [$g_aCSVMakeVecTargetLoc[$iVecIndex][0], $g_aCSVMakeVecTargetLoc[$iVecIndex][1]]

		If $g_abCSVMakeVecTargetLocValid[$iVecIndex] And $iResolvedEnum > 0 Then
			If _CSVEnumInList($aRescanned, $iResolvedEnum) Then
				$bCanEvaluate = True
				$bTargetDetected = _CSVIsTargetLocationStillDetected($iResolvedEnum, $aTargetLoc)
			EndIf
		EndIf

			If $bForceRebuild Then
				If Not $bCanEvaluate Then
					CSV_LogRescan("vec keep", $sVecKey & " enum not rescanned", $COLOR_WARNING)
					$iKept += 1
					ContinueLoop
				EndIf
			Else
				If $bCanEvaluate And $bTargetDetected Then
					CSV_LogRescan("vec keep", $sVecKey & " target still detected", $COLOR_DEBUG)
					$iKept += 1
					ContinueLoop
				EndIf
				If Not $bCanEvaluate Then
					CSV_LogRescan("vec keep", $sVecKey & " enum not rescanned", $COLOR_WARNING)
					$iKept += 1
					ContinueLoop
				EndIf
			EndIf

			Local $sTarget = $g_asCSVMakeVecTargetName[$iVecIndex]
			If $sTarget = "" Then
				CSV_LogRescan("vec keep", $sVecKey & " target name missing", $COLOR_WARNING)
				$iKept += 1
				ContinueLoop
			EndIf
		Local $sVecSide = $g_aCSVMakeVecSide[$iVecIndex]
		If $sSideOverride <> "" Then $sVecSide = $sSideOverride
		Local $aNewVector = MakeTargetDropPoints($sVecSide, $g_aCSVMakeVecPoints[$iVecIndex], $g_aCSVMakeVecAddTiles[$iVecIndex], $sTarget)
			If @error Or Not IsArray($aNewVector) Or UBound($aNewVector) = 0 Then
				Assign("ATTACKVECTOR_" & $sVecKey, "")
				$g_abCSVMakeVecTargetLocValid[$iVecIndex] = False
				CSV_LogRescan("vec cleared", $sVecKey & " target missing", $COLOR_WARNING)
				$iCleared += 1
			Else
			Assign("ATTACKVECTOR_" & $sVecKey, $aNewVector)
			$g_aiCSVMakeVecResolvedEnum[$iVecIndex] = $g_iCSVLastMakeResolvedEnum
			If $g_aCSVMakeVecType[$iVecIndex] = $eCSVVecTypeTarget Then $g_aiCSVMakeVecTargetEnum[$iVecIndex] = $g_iCSVLastMakeResolvedEnum
			If $g_bCSVLastMakeTargetLocValid Then
				$g_abCSVMakeVecTargetLocValid[$iVecIndex] = True
				$g_aCSVMakeVecTargetLoc[$iVecIndex][0] = $g_aCSVLastMakeTargetLoc[0]
				$g_aCSVMakeVecTargetLoc[$iVecIndex][1] = $g_aCSVLastMakeTargetLoc[1]
			Else
				$g_abCSVMakeVecTargetLocValid[$iVecIndex] = False
			EndIf
				CSV_LogRescan("vec rebuilt", $sVecKey & " target=" & $sTarget, $COLOR_INFO)
				$iRebuilt += 1
			EndIf
	Next

	If $bBudgetExceeded Then CSV_LogRescan("recalc", "budget exceeded, some vectors kept", $COLOR_WARNING)
	CSV_LogRescan("recalc done", "vectors=" & ($sEligibleVectors = "" ? "-" : $sEligibleVectors) & _
			" rebuilt=" & $iRebuilt & " kept=" & $iKept & " cleared=" & $iCleared & _
			" rescanned=" & $iRescanned, $COLOR_INFO)
	Return $iRebuilt
EndFunc   ;==>AttackCSV_RecalcMakeVectors

; #FUNCTION# ====================================================================================================================
; Name ..........: _CSVRescanGetMissingEnums
; Description ...: Build a list of enums that need a lightweight rescan.
; Syntax ........: _CSVRescanGetMissingEnums()
; Parameters ....: None
; Return values .: Success: array of building enums to rescan (possibly empty).
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
; Side-effect: pure
Func _CSVRescanGetMissingEnums()
	Local $aMissing[0]
	If Not IsObj($g_oBldgAttackInfo) Then Return $aMissing

	Local $bHasSideBWeights = False
	If IsArray($g_aiCSVSideBWeights) Then
		For $w = 0 To UBound($g_aiCSVSideBWeights) - 1
			If $g_aiCSVSideBWeights[$w] > 0 Then
				$bHasSideBWeights = True
				ExitLoop
			EndIf
		Next
	EndIf

	If $g_abCSVPrepHasPrioMake[$g_iMatchMode] Or $bHasSideBWeights Then
		Local $aEnums, $aNames, $aWeightIndex
		_CSVGetPrioCandidateMap($aEnums, $aNames, $aWeightIndex)
		For $i = 0 To UBound($aEnums) - 1
			Local $iWeightIdx = $aWeightIndex[$i]
			If $iWeightIdx < 0 Or $iWeightIdx >= UBound($g_aiCSVSideBWeights) Then ContinueLoop
			If $g_aiCSVSideBWeights[$iWeightIdx] <= 0 Then ContinueLoop
			_CSVBatchAddUnique($aMissing, $aEnums[$i])
		Next

		Local $iTHWeight = _CSVPrioGetTownHallWeight()
		If $iTHWeight > 0 And _CSVPrioIsWeaponizedTownHall() Then _CSVBatchAddUnique($aMissing, $eBldgTownHall)
	EndIf

	Local $sTargetEnums = $g_asCSVPrepTargetEnums[$g_iMatchMode]
	If $sTargetEnums <> "" Then
		Local $aTargetEnums = StringSplit($sTargetEnums, "|", $STR_NOCOUNT)
		For $i = 0 To UBound($aTargetEnums) - 1
			Local $iEnum = Int($aTargetEnums[$i])
			If $iEnum <= 0 Then ContinueLoop
			If $iEnum = $eExternalWall Or $iEnum = $eInternalWall Then ContinueLoop

			If Not _ObjSearch($g_oBldgAttackInfo, $iEnum & "_LOCATION") Then
				_CSVBatchAddUnique($aMissing, $iEnum)
				ContinueLoop
			EndIf
			Local $aLoc = _ObjGetValue($g_oBldgAttackInfo, $iEnum & "_LOCATION")
			If @error Or Not IsArray($aLoc) Or UBound($aLoc) = 0 Then
				_CSVBatchAddUnique($aMissing, $iEnum)
				ContinueLoop
			EndIf
			If IsArray($aLoc[0]) Then ContinueLoop
			If UBound($aLoc) >= 2 Then ContinueLoop
			_CSVBatchAddUnique($aMissing, $iEnum)
		Next
	EndIf

	Return $aMissing
EndFunc   ;==>_CSVRescanGetMissingEnums

; #FUNCTION# ====================================================================================================================
; Name ..........: AttackCSV_PrecacheBuildingsFromSearch
; Description ...: Pre-cache CSV building locations once redline is available during search.
; Syntax ........: AttackCSV_PrecacheBuildingsFromSearch($iMode[, $bForceRescan = False])
; Parameters ....: $iMode             - Match mode index ($DB/$LB).
;                  $bForceRescan      - [optional] Force rescan of cached locations. Default is False.
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
Func AttackCSV_PrecacheBuildingsFromSearch($iMode, $bForceRescan = False)
	If $iMode < 0 Or $iMode >= $g_iModeCount Then Return SetError(1, 0, 0)
	If $g_aiAttackAlgorithm[$iMode] <> 1 Then Return SetError(2, 0, 0)
	If Not PrepareAttackCSV($iMode) Then Return SetError(3, 0, 0)

	Local $hPrecacheTimer = __timerinit()
	Local $bForceRescanLocal = ($bForceRescan Or ($g_iCSVPrecacheMode = $g_iCSVPrecacheAggressive))
	$g_bCSVPrecacheDone[$iMode] = False
	$g_sCSVMainSideEstimate = ""

	Local $sRedline = ""
	If $g_sImglocRedline <> "" Then
		$sRedline = $g_sImglocRedline
	ElseIf _ObjSearch($g_oBldgAttackInfo, $eBldgRedLine & "_OBJECTPOINTS") Then
		$sRedline = _ObjGetValue($g_oBldgAttackInfo, $eBldgRedLine & "_OBJECTPOINTS")
	EndIf
	If $sRedline = "" Then
		CSV_LogTiming("precache skipped", "redline missing")
		$g_bCSVPrecacheDone[$iMode] = False
		$g_iCSVLastPrecalcMs = Round(__timerdiff($hPrecacheTimer))
		$g_sCSVLastPrecalcTime = @YEAR & "-" & StringFormat("%02d", @MON) & "-" & StringFormat("%02d", @MDAY) & " " & _
				StringFormat("%02d", @HOUR) & ":" & StringFormat("%02d", @MIN) & ":" & StringFormat("%02d", @SEC)
		Return SetError(4, 0, 0)
	EndIf

	If Not _ObjSearch($g_oBldgAttackInfo, $eBldgRedLine & "_OBJECTPOINTS") Then
		_ObjAdd($g_oBldgAttackInfo, $eBldgRedLine & "_OBJECTPOINTS", $sRedline)
		Local $aSplit = StringSplit($sRedline, "|", $STR_NOCOUNT)
		If UBound($aSplit) > 0 Then _ObjAdd($g_oBldgAttackInfo, $eBldgRedLine & "_COUNT", UBound($aSplit))
	EndIf

	AttackCSV_ApplyPrepared($iMode, $g_iSearchTH)

	Local $aMakeSidesUsed[4] = [False, False, False, False]
	Local $bAllMakeTargeted = False
	Local $iCSVMaxReturnPointsOverride = Default
	If AttackCSV_GetPreparedMakeUsage($iMode, $aMakeSidesUsed, $bAllMakeTargeted) Then
		Local $iTargetedCap = AttackCSV_GetTargetedOnlyCap($iMode, $g_iCSVTargetedMaxReturnPoints)
		If $bAllMakeTargeted And $iTargetedCap > 0 Then
			$iCSVMaxReturnPointsOverride = AttackCSV_GetTargetMaxReturnPoints($iMode, $g_iSearchTH, $iTargetedCap)
		EndIf
	EndIf

	Local $bAnyLocate = _CSVHasAnyLocateFlag($iMode, $g_iSearchTH)
	If Not $bAnyLocate Then
		CSV_LogTiming("precache skipped", "no locate flags")
		$g_iCSVLastPrecalcMs = Round(__timerdiff($hPrecacheTimer))
		$g_sCSVLastPrecalcTime = @YEAR & "-" & StringFormat("%02d", @MON) & "-" & StringFormat("%02d", @MDAY) & " " & _
				StringFormat("%02d", @HOUR) & ":" & StringFormat("%02d", @MIN) & ":" & StringFormat("%02d", @SEC)
		Return 1
	EndIf

	CSV_LogTiming("capture", "precache search")
	_CaptureRegion2()
	AttackCSV_BatchLocateBuildings($iCSVMaxReturnPointsOverride, $bForceRescanLocal)
	CSV_LogPrepSummary(3)
	$g_bCSVPrecacheDone[$iMode] = True

	If _ObjSearch($g_oBldgAttackInfo, $eBldgTownHall & "_LOCATION") Then
		Local $aTHLoc = _ObjGetValue($g_oBldgAttackInfo, $eBldgTownHall & "_LOCATION")
		If Not @error And IsArray($aTHLoc) Then
			$g_sCSVMainSideEstimate = _CSVEstimateMainSide($aTHLoc[0], $aTHLoc[1])
			SetDebugLog("CSV main side estimate: " & $g_sCSVMainSideEstimate, $COLOR_DEBUG)
		EndIf
	EndIf

	If $g_abCSVPrepHasPrioMake[$iMode] Then
		Local $aSideKeys[4] = ["TOP-LEFT", "TOP-RIGHT", "BOTTOM-LEFT", "BOTTOM-RIGHT"]
		For $s = 0 To 3
			_CSVPrioGetTargetsForSide($aSideKeys[$s])
		Next
		CSV_LogTiming("prio pools cached", "mode=" & $g_asModeText[$iMode])
	EndIf

	CSV_LogTiming("precache done", "mode=" & $g_asModeText[$iMode])
	$g_iCSVLastPrecalcMs = Round(__timerdiff($hPrecacheTimer))
	$g_sCSVLastPrecalcTime = @YEAR & "-" & StringFormat("%02d", @MON) & "-" & StringFormat("%02d", @MDAY) & " " & _
			StringFormat("%02d", @HOUR) & ":" & StringFormat("%02d", @MIN) & ":" & StringFormat("%02d", @SEC)
	If $g_iCSVPrecalcBudgetMs > 0 And $g_iCSVLastPrecalcMs > $g_iCSVPrecalcBudgetMs Then
		SetLog("CSV precalc exceeded budget: " & $g_iCSVLastPrecalcMs & " ms (budget " & $g_iCSVPrecalcBudgetMs & " ms)", $COLOR_WARNING)
	EndIf
	Return 1
EndFunc   ;==>AttackCSV_PrecacheBuildingsFromSearch

; #FUNCTION# ====================================================================================================================
; Name ..........: AttackCSV_BatchLocateBuildings
; Description ...: Pre-fetch building locations for CSV logic in a single batch pass.
; Syntax ........: AttackCSV_BatchLocateBuildings($iMaxReturnPointsOverride[, $bForceRescan = False])
; Parameters ....: $iMaxReturnPointsOverride - Max return points override passed to GetLocationBuilding.
;                  $bForceRescan             - [optional] Force rescan even if cached. Default is False.
; Return values .: Success: 1
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func AttackCSV_BatchLocateBuildings($iMaxReturnPointsOverride, $bForceRescan = False)
	Local $aBatch[0]
	Local $bUseWizForSuper = ($g_bCSVLocateSuperWizTower And $g_bCSVUseWizTowerForSuperWiz)

	If $g_bCSVLocateEagle And ($g_iSearchTH = "-" Or $g_iSearchTH > 10) Then _CSVBatchAddUnique($aBatch, $eBldgEagle)
	If $g_bCSVLocateScatter And ($g_iSearchTH = "-" Or $g_iSearchTH > 10) Then _CSVBatchAddUnique($aBatch, $eBldgScatter)
	If $g_bCSVLocateInferno And ($g_iSearchTH = "-" Or $g_iSearchTH > 9) Then _CSVBatchAddUnique($aBatch, $eBldgInferno)
	If $g_bCSVLocateXBow And ($g_iSearchTH = "-" Or $g_iSearchTH > 8) Then _CSVBatchAddUnique($aBatch, $eBldgXBow)
	If $g_bCSVLocateWizTower Or $bUseWizForSuper Then _CSVBatchAddUnique($aBatch, $eBldgWizTower)
	If $g_bCSVLocateSuperWizTower And Not $bUseWizForSuper Then _CSVBatchAddUnique($aBatch, $eBldgSuperWizTower)
	If $g_bCSVLocateMortar Then _CSVBatchAddUnique($aBatch, $eBldgMortar)
	If $g_bCSVLocateAirDefense Then _CSVBatchAddUnique($aBatch, $eBldgAirDefense)
	If $g_bCSVLocateSweeper Then _CSVBatchAddUnique($aBatch, $eBldgSweeper)
	If $g_bCSVLocateMonolith Then _CSVBatchAddUnique($aBatch, $eBldgMonolith)
	If $g_bCSVLocateFireSpitter Then _CSVBatchAddUnique($aBatch, $eBldgFireSpitter)
	If $g_bCSVLocateMultiArcherTower Then _CSVBatchAddUnique($aBatch, $eBldgMultiArcherTower)
	If $g_bCSVLocateMultiGearTower Then _CSVBatchAddUnique($aBatch, $eBldgMultiGearTower)
	If $g_bCSVLocateRicochetCannon Then _CSVBatchAddUnique($aBatch, $eBldgRicochetCannon)
	If $g_bCSVLocateRevengeTower Then _CSVBatchAddUnique($aBatch, $eBldgRevengeTower)

	If UBound($aBatch) = 0 Then Return 1

	If $bForceRescan Then
		If IsObj($g_oCSVPrioTargets) Then $g_oCSVPrioTargets.RemoveAll()
		If IsObj($g_oCSVPrioPlan) Then $g_oCSVPrioPlan.RemoveAll()
		If IsObj($g_oCSVPrioIndexes) Then $g_oCSVPrioIndexes.RemoveAll()
	EndIf

	CSV_LogTiming("locate batch start", "count=" & UBound($aBatch))
	For $i = 0 To UBound($aBatch) - 1
		Local $iEnum = $aBatch[$i]
		If $bForceRescan Then _CSVBatchClearBuildingCache($iEnum)
		If $bForceRescan Or Not _ObjSearch($g_oBldgAttackInfo, $iEnum & "_LOCATION") Then
			Local $aResult = GetLocationBuilding($iEnum, $g_iSearchTH, False, $iMaxReturnPointsOverride)
			If $aResult = -1 Then SetLog("Monkey ate bad banana: " & "GetLocationBuilding " & $g_sBldgNames[$iEnum], $COLOR_ERROR)
		EndIf
	Next
	CSV_LogTiming("locate batch done", "count=" & UBound($aBatch))
	Return 1
EndFunc   ;==>AttackCSV_BatchLocateBuildings

; #FUNCTION# ====================================================================================================================
; Name ..........: _CSVBatchClearBuildingCache
; Description ...: Remove cached building keys so the next locate call can repopulate them.
; Syntax ........: _CSVBatchClearBuildingCache($iEnum)
; Parameters ....: $iEnum              - building enum to clear.
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _CSVBatchClearBuildingCache($iEnum)
	If Not IsObj($g_oBldgAttackInfo) Then Return
	Local $sPrefix = $iEnum & "_"
	Local $aKeys = $g_oBldgAttackInfo.Keys
	For $sKey In $aKeys
		If StringLeft($sKey, StringLen($sPrefix)) = $sPrefix Then
			$g_oBldgAttackInfo.Remove($sKey)
		EndIf
	Next
EndFunc   ;==>_CSVBatchClearBuildingCache

; #FUNCTION# ====================================================================================================================
; Name ..........: _CSVBatchAddUnique
; Description ...: Add an enum value to a batch list if it is not already present.
; Syntax ........: _CSVBatchAddUnique(ByRef $aBatch, $iEnum)
; Parameters ....: $aBatch            - [in/out] array of enums
;                  $iEnum             - enum to add
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _CSVBatchAddUnique(ByRef $aBatch, $iEnum)
	For $i = 0 To UBound($aBatch) - 1
		If $aBatch[$i] = $iEnum Then Return
	Next
	Local $iSize = UBound($aBatch)
	ReDim $aBatch[$iSize + 1]
	$aBatch[$iSize] = $iEnum
EndFunc   ;==>_CSVBatchAddUnique

Func FindWallCSV(ByRef $aCSVExternalWall, ByRef $aCSVInternalWall)
	SetLog("Searching for wall location")

	Local $aOuterWall[2], $aInnerWall[2], $bResult = False
	Local $aiWallPos[1][3] ; x, y, distance to edge
	Local $aEdgeCoord[2], $aCenterCoord[2] = [$ExternalArea[2][0], $ExternalArea[0][1]]

	For $i = 0 To UBound($ExternalArea) - 1
		If $MAINSIDE = $ExternalArea[$i][2] Then
			$aEdgeCoord[0] = Number($ExternalArea[$i][0])
			$aEdgeCoord[1] = Number($ExternalArea[$i][1])
			ExitLoop
		EndIf
	Next

	If $g_bDebugImageSave Then
		_CaptureRegion2()
		; Create the necessery GDI stuff
		Local $subDirectory = $g_sProfileTempDebugPath & "CSVWall"
		DirCreate($subDirectory)
		Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
		Local $Time = @HOUR & "." & @MIN & "." & @SEC
		Local $filename = String($Date & "_" & $Time & "_.png")
		Local $editedImage = _GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap2)
		Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($editedImage)
		Local $hPenRED = _GDIPlus_PenCreate(0xFFFF0000, 3) ; Create a pencil Color FF0000/RED
		Local $hPenBLUE = _GDIPlus_PenCreate(0xFF0000FF, 2)
	EndIf

	For $i = 0 To 2 ; 3 rectangulars from edge to center
		Local $X1 = Int($aEdgeCoord[0] + $i * ($aEdgeCoord[0] < $aCenterCoord[0] ? 63 : -63))
		Local $Y1 = Int($aEdgeCoord[1] + $i * ($aEdgeCoord[1] < $aCenterCoord[1] ? 47 : -47))
		Local $X2 = Int($X1 + ($aEdgeCoord[0] < $aCenterCoord[0] ? 80 : -80))
		Local $Y2 = Int($Y1 + ($aEdgeCoord[1] < $aCenterCoord[1] ? 60 : -60))

		_CaptureRegion2(_Min($X1, $X2), _Min($Y1, $Y2), _Max($X1, $X2), _Max($Y1, $Y2))
		Local $FoundWalls = imglocFindWalls("AnyWallLevel", "FV", "FV", 10)

		If $g_bDebugImageSave Then _GDIPlus_GraphicsDrawRect($hGraphic, _Min($X1, $X2), _Min($Y1, $Y2), Abs($X1 - $X2), Abs ($Y1 - $Y2), $hPenBLUE)

		If $FoundWalls[0] = "" Then ; nothing found
			SetDebugLog("No wall(s) found in section " & $i + 1)
		Else
			Local $sWallString = _ArrayToString($FoundWalls)
			Local $aWallCoordsArray = decodeMultipleCoords($sWallString, 7, 7)
			SetDebugLog("Found " & UBound($aWallCoordsArray) & " walls in section " & $i + 1 & ": " & $sWallString)

			For $j = 0 To UBound($aWallCoordsArray) - 1
				Local $aTempPos = $aWallCoordsArray[$j]
				Local $index = UBound($aiWallPos) - 1
				$aiWallPos[$index][0] = $aTempPos[0] + _Min($X1, $X2)
				$aiWallPos[$index][1] = $aTempPos[1] + _Min($Y1, $Y2)
				$aiWallPos[$index][2] = Int(Sqrt(($aiWallPos[$index][0] - $aEdgeCoord[0]) ^ 2 + ($aiWallPos[$index][1] - $aEdgeCoord[1]) ^ 2))
				ReDim $aiWallPos[UBound($aiWallPos) + 1][3]
				If $g_bDebugImageSave Then _GDIPlus_GraphicsDrawEllipse($hGraphic, $aiWallPos[$index][0], $aiWallPos[$index][1], 3, 3, $hPenBLUE)
			Next
		EndIf
	Next

	If UBound($aiWallPos) > 1 And $aiWallPos[0][0] <> "" Then
		_ArraySort($aiWallPos, 0, 0, 0, 2)
		_ArrayDelete($aiWallPos, 0) ; remove 1st "" element
		SetDebugLog(@CRLF & _ArrayToString($aiWallPos))

		$aOuterWall[0] = $aiWallPos[0][0]
		$aOuterWall[1] = $aiWallPos[0][1]

		For $i = 0 To UBound($aiWallPos) - 1
			If $i = 0 Then ContinueLoop
			If $aiWallPos[$i][2] - $aiWallPos[0][2] >= 40 Then
				$aInnerWall[0] = $aiWallPos[$i][0]
				$aInnerWall[1] = $aiWallPos[$i][1]
				ExitLoop
			EndIf
		Next

		Setlog("External Wall: " & _ArrayToString($aOuterWall) & " , Internal Wall: " & _ArrayToString($aInnerWall))
		If $aOuterWall[0] <> "" Then
			$aCSVExternalWall[0] = $aOuterWall
			$aCSVInternalWall[0] = $aInnerWall
			If $g_bDebugImageSave Then
				_GDIPlus_GraphicsDrawEllipse($hGraphic, $aOuterWall[0], $aOuterWall[1], 3, 3, $hPenRED)
				_GDIPlus_GraphicsDrawEllipse($hGraphic, $aInnerWall[0], $aInnerWall[1], 3, 3, $hPenRED)
			EndIf
			$bResult = True
		EndIf
	Else
		SetLog("No wall found")
	EndIf
	If $g_bDebugImageSave Then
		; Destroy the used GDI stuff
		_GDIPlus_ImageSaveToFile($editedImage, $subDirectory & "\" & $filename)
		_GDIPlus_PenDispose($hPenRED)
		_GDIPlus_GraphicsDispose($hGraphic)
		_GDIPlus_BitmapDispose($editedImage)
	EndIf

	Return $bResult
EndFunc

Func TestDropLine($SearchRedLine = True)
	SetLog("TestDropLine()", $COLOR_INFO)
	
	SearchZoomOut(False, True, "TestDropLine", False, False)
	ConvertInternalExternArea()
	
	If $SearchRedLine And IsAttackPage() Then 
		Local $hTimer = __timerinit()

		SetDebugLog("Redline mode: " & $g_aiAttackScrRedlineRoutine[$g_iMatchMode])
		SetDebugLog("Dropline mode: " & $g_aiAttackScrDroplineEdge[$g_iMatchMode])

		_CaptureRegion2()
		_GetRedArea($g_aiAttackScrRedlineRoutine[$g_iMatchMode])
		SetDebugLog("Calculated  (in " & Round(__timerdiff($hTimer) / 1000, 2) & " seconds) :")
		debugAttackCSV("	[" & UBound($g_aiPixelTopLeft) & "] pixels TopLeft")
		debugAttackCSV("	[" & UBound($g_aiPixelTopRight) & "] pixels TopRight")
		debugAttackCSV("	[" & UBound($g_aiPixelBottomLeft) & "] pixels BottomLeft")
		debugAttackCSV("	[" & UBound($g_aiPixelBottomRight) & "] pixels BottomRight")
	Else
		$g_aiPixelTopLeft = 0
		$g_aiPixelTopRight = 0
		$g_aiPixelBottomLeft = 0
		$g_aiPixelBottomRight = 0
	EndIf
	
	AttackCSVDEBUGIMAGE(True) ;make IMG debug

EndFunc   ;==>TestDropLine

Func TestDropLine1($bRedArea = True, $bCheckZoom = True)
	SetLog("TestDropLine()", $COLOR_INFO)
	;reset
	resetEdge()
	
	If $bCheckZoom Then
		If Not CheckZoomOut("TestDropLine1") Then 
			Setlog("TestDropLine1 : CheckZoomOut Fail!", $COLOR_ERROR)
			Return
		EndIf
	EndIf
	If $bRedArea Then _GetRedArea()
	AttackCSVDEBUGIMAGE(True) ;make IMG debug
EndFunc   ;==>TestDropLine1

Func TestDropLine2($bImage = False)
	SetLog("TestDropLine2()", $COLOR_INFO)
	setVillageOffset(0, 0, 1)
	If Not CheckZoomOut("TestDropLine2") Then 
		Setlog("TestDropLine2 : CheckZoomOut Fail!", $COLOR_ERROR)
		Return
	EndIf
	
	_GetRedArea()
	AttackCSVDEBUGIMAGE($bImage) ;make IMG debug
EndFunc   ;==>TestDropLine2

Func resetEdge()
	$g_aiPixelTopLeft = 0
	$g_aiPixelTopRight = 0
	$g_aiPixelBottomLeft = 0
	$g_aiPixelBottomRight = 0
EndFunc

Func TestCSV($iMatchMode = $LB)
	Local $filename = $g_sAttackScrScriptName[$iMatchMode]
	$g_iMatchMode = $iMatchMode
	SetLog("will use script : " & $filename, $COLOR_INFO)
	CheckZoomOut("TestCSV")
	PrepareAttack($iMatchMode)
	Algorithm_AttackCSV()
	ReturnHome()
EndFunc

Func CSVLoop($iCountLoop = 1, $bStopWhenResourceFull = False)
	Local $filename = $g_sAttackScrScriptName[$LB]
	ZoomOut()
	For $i = 1 To $iCountLoop
		SetLog("TestCSVLoop #" & $i, $COLOR_ACTION)
		PrepareSearch()
		If Not $g_bRunState Then Return
		VillageSearch()
		If Not $g_bRunState Then Return
		SetLog("will use script : " & $filename, $COLOR_INFO)
		CheckZoomOut("TestCSV")
		PrepareAttack($LB)
		Algorithm_AttackCSV()
		ReturnHome()
		If Not $g_bRunState Then Return
		VillageReport()
		If Not $g_bRunState Then Return
		RequestCC()
		Setlog("TestCSV Loop [" & $i & "/" & $iCountLoop & "]", $COLOR_ACTION) 
		If isGoldFull() And isElixirFull() And $bStopWhenResourceFull Then Return
	Next
EndFunc
