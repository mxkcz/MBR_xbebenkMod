; #FUNCTION# ====================================================================================================================
; Name ..........: GetVillageSize
; Description ...: Measures the size of village. After CoC October 2016 update, max'ed zoomed out village is 440 (reference!)
;                  But usually sizes around 470 - 490 pixels are measured due to lock on max zoom out.
; Syntax ........: GetVillageSize()
; Parameters ....:
; Return values .: 0 if not identified or Array with index
;                      0 = Size of village (float)
;                      1 = Zoom factor based on 440 village size (float)
;                      2 = X offset of village center (int)
;                      3 = Y offset of village center (int)
;                      4 = X coordinate of stone
;                      5 = Y coordinate of stone
;                      6 = stone image file name
;                      7 = X coordinate of tree
;                      8 = Y coordinate of tree
;                      9 = tree image file name
; Author ........: Cosote (Oct 17th 2016)
; Modified ......: xbebenk (June 2022)
; Removed Fix village measurement if using shared_prefs as I dont know how it works :(
; Change the logic for measure village size, zoomlevel now measured from tree to stone
; And then compare it with Reference size
; All scenery (as this code modified: 01 June 2022) is supported
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
;GetVillageSize(True, "stone", "tree", False)
Func GetVillageSize($DebugLog = Default, $sStonePrefix = Default, $sTreePrefix = Default, $bOnBuilderBase = Default)
	FuncEnter(GetVillageSize)
	Local $stone = [0, 0, 0, 0, 0, ""], $tree = [0, 0, 0, 0, 0, ""]
	If $DebugLog = Default Then $DebugLog = False
	If $sStonePrefix = Default Then $sStonePrefix = "stone"
	If $sTreePrefix = Default Then $sTreePrefix = "tree"
	
	If $bOnBuilderBase = Default Then
		$bOnBuilderBase = isOnBuilderBase()
	EndIf
	
	Local $sDirectory
	If $bOnBuilderBase Then
		$sDirectory = $g_sImgZoomOutDirBB
	Else
		$sDirectory = $g_sImgZoomOutDir
	EndIf
	
	Local $iAdditionalX = 100
	Local $iAdditionalY = 100
	Local $iFallbackAddX = 160
	Local $iFallbackAddY = 160
	Local $aResult = 0, $stone, $tree, $x, $y
	
	$stone = FindStone($sDirectory, $sStonePrefix, $iAdditionalX, $iAdditionalY)
	If Not $g_bRunState Then Return 0
	SetDebugLog("stone: " & _ArrayToString($stone))
	If $stone[0] = 0 Then
		SetDebugLog("GetVillageSize cannot find stone", $COLOR_WARNING)
		If $g_bDebugImageSave Then SaveDebugImage("GetVillageSize_StoneMissing", True)
		Local $treeFallback = FindTree($sDirectory, $sTreePrefix, $iFallbackAddX, $iFallbackAddY, $g_sSceneryCode)
		If Not $g_bRunState Then Return 0
		SetDebugLog("tree fallback (stone missing): " & _ArrayToString($treeFallback))
		If $treeFallback[0] <> 0 And IsString($treeFallback[4]) And $treeFallback[4] <> "" Then
			SetDebugLog("Stone missing; attempting stone search using tree code " & $treeFallback[4], $COLOR_WARNING)
			$stone = FindStone($sDirectory, $sStonePrefix, $iFallbackAddX, $iFallbackAddY, $treeFallback[4])
			If Not $g_bRunState Then Return 0
			SetDebugLog("stone override (from tree): " & _ArrayToString($stone))
			If $stone[0] <> 0 Then
				$tree = $treeFallback
			EndIf
		EndIf
		If $bOnBuilderBase Then ZoomOutHelperBB("GetVillageSize")
		If $stone[0] = 0 Then
			If IsArray($g_aVillageSize) And UBound($g_aVillageSize) > 0 And $g_aVillageSize[0] > 0 Then
				SetLog("GetVillageSize using last known village size (stone missing)", $COLOR_WARNING)
				Return FuncReturn($g_aVillageSize)
			EndIf
			Return FuncReturn($aResult)
		EndIf
	EndIf
	
	If $tree[0] = 0 Then $tree = FindTree($sDirectory, $sTreePrefix, $iAdditionalX, $iAdditionalY, $stone[4])
	If Not $g_bRunState Then Return 0
	SetDebugLog("tree: " & _ArrayToString($tree))
	If $tree[0] = 0 Then
		SetDebugLog("GetVillageSize cannot find tree", $COLOR_ACTION)
		If $g_bDebugImageSave Then SaveDebugImage("GetVillageSize_TreeMissing", True)
		If $bOnBuilderBase Then ZoomOutHelperBB("GetVillageSize")
		If IsArray($g_aVillageSize) And UBound($g_aVillageSize) > 0 And $g_aVillageSize[0] > 0 Then
			SetLog("GetVillageSize using last known village size (tree missing)", $COLOR_WARNING)
			Return FuncReturn($g_aVillageSize)
		EndIf
		Return FuncReturn($aResult)
	Else
		Local $sTreeCode = ""
		If IsString($tree[4]) Then $sTreeCode = $tree[4]
		If IsString($stone[4]) And $stone[4] = "DS" And $sTreeCode <> "" And $sTreeCode <> "DS" Then
			Local $stoneOverride = FindStone($sDirectory, $sStonePrefix, $iFallbackAddX, $iFallbackAddY, $sTreeCode)
			If Not $g_bRunState Then Return 0
			If $stoneOverride[0] <> 0 Then
				SetLog("Stone override: " & $stone[4] & " -> " & $sTreeCode, $COLOR_WARNING)
				$stone = $stoneOverride
			EndIf
		EndIf
		; calculate village size, see https://en.wikipedia.org/wiki/Pythagorean_theorem
		Local $a = $tree[0] - $stone[0]
		Local $b = $stone[1] - $tree[1]
		Local $c = Sqrt($a * $a + $b * $b) ;measure distance from stone to tree
		Local $ZoomOffset = 100, $checkZoomOffset = 0
			
		Local $iRefSize = $g_aVillageRefSize[0][2]
		Local $iIndex = _ArraySearch($g_aVillageRefSize, $stone[4])
		If $iIndex <> -1 Then 
			$iRefSize = $g_aVillageRefSize[$iIndex][2]
			$g_sSceneryCode = $g_aVillageRefSize[$iIndex][0]
			$g_sCurrentScenery = $g_aVillageRefSize[$iIndex][1]
			$InnerDiamondLeft = $g_aVillageRefSize[$iIndex][3]
			$InnerDiamondRight = $g_aVillageRefSize[$iIndex][4]
			$InnerDiamondTop = $g_aVillageRefSize[$iIndex][5]
			$InnerDiamondBottom = $g_aVillageRefSize[$iIndex][6]
			_ApplySceneryInnerAdjust($g_sSceneryCode, $InnerDiamondLeft, $InnerDiamondRight, $InnerDiamondTop, $InnerDiamondBottom)
			$g_bIsCustomMainVillage = False
			Local $sTreeCode = ""
			If IsString($tree[4]) Then $sTreeCode = $tree[4]
			If $sTreeCode <> "" And $sTreeCode <> $g_sSceneryCode Then
				Local $iTreeIndexAlt = _ArraySearch($g_aVillageRefSize, $sTreeCode)
				If $g_sSceneryCode = "DS" And $iTreeIndexAlt <> -1 Then
					SetLog("Tree code override: " & $g_sSceneryCode & " -> " & $sTreeCode, $COLOR_WARNING)
					$iIndex = $iTreeIndexAlt
					$iRefSize = $g_aVillageRefSize[$iIndex][2]
					$g_sSceneryCode = $g_aVillageRefSize[$iIndex][0]
					$g_sCurrentScenery = $g_aVillageRefSize[$iIndex][1]
					$InnerDiamondLeft = $g_aVillageRefSize[$iIndex][3]
					$InnerDiamondRight = $g_aVillageRefSize[$iIndex][4]
					$InnerDiamondTop = $g_aVillageRefSize[$iIndex][5]
					$InnerDiamondBottom = $g_aVillageRefSize[$iIndex][6]
					_ApplySceneryInnerAdjust($g_sSceneryCode, $InnerDiamondLeft, $InnerDiamondRight, $InnerDiamondTop, $InnerDiamondBottom)
				EndIf
			EndIf
			If $bOnBuilderBase Then
				$g_iTree = $eTreeBB
			Else
				Local $sPhCode = $g_sSceneryCode
				Switch $sPhCode
					Case "PC"
						$sPhCode = "PS"
					Case "PS"
						$sPhCode = "PX"
					Case "10"
						$sPhCode = "XC"
					Case "EP"
						$sPhCode = "EJ"
					Case "RY"
						$sPhCode = "RS"
					Case "CA"
						$sPhCode = "CL"
					Case "BC"
						$sPhCode = "BK"
					Case "JL"
						$sPhCode = "JO"
					Case "PT"
						$sPhCode = "PA"
					Case "HP"
						$sPhCode = "HS"
					Case "TD"
						$sPhCode = "TW"
					Case "W1", "W2", "W3", "W4"
						$sPhCode = "WS"
				EndSwitch
				Local $iTreeIndex = _ArraySearch($g_asSceneryCodes, $sPhCode)
				If $iTreeIndex <> -1 Then
					$g_iTree = $iTreeIndex
				Else
					$g_iTree = $eTreeDS
					SetLog("Scenery code '" & $g_sSceneryCode & "' not mapped (PH '" & $sPhCode & "'); using default offsets", $COLOR_WARNING)
				EndIf
				If $g_bDebugSetLog Then
					Local $iMapIndex = _ArraySearch($g_asSceneryCodes, $g_sSceneryCode)
					If $iMapIndex = -1 And $sPhCode = $g_sSceneryCode Then
						SetDebugLog("Scenery code '" & $g_sSceneryCode & "' not in PH map list", $COLOR_WARNING)
					EndIf
				EndIf
			EndIf
			If $g_bDebugSetLog Then SetDebugLog("Scenery map: " & $g_sSceneryCode & " -> " & $sPhCode & ", tree=" & $g_iTree & ", refsize=" & $iRefSize, $COLOR_DEBUG1)
			If Not $bOnBuilderBase Then
				For $i = 0 To UBound($g_afRefCustomMainVillage) - 1
					If $g_iTree = $g_afRefCustomMainVillage[$i][5] Then
						$g_bIsCustomMainVillage = True
						ExitLoop
					EndIf
				Next
			EndIf
			If $g_bDebugSetLog Then SetDebugLog("Custom main village ref: " & $g_bIsCustomMainVillage, $COLOR_DEBUG1)
			$g_iSceneryEdgeDiffX = $g_iDefaultEdgeDiffX
			$g_iSceneryEdgeDiffY = $g_iDefaultEdgeDiffY
			If $g_bDebugSetLog Then SetDebugLog("LRTB: " & $InnerDiamondLeft & "," & $InnerDiamondRight & "," & $InnerDiamondTop & "," & $InnerDiamondBottom)
		Else
			SetLog("Reference Size no match", $COLOR_ERROR)
			SetLog("Stone2tree = " & $c, $COLOR_INFO)
			SetLog("Scenery detection failed; using default edges. Redline may be inaccurate.", $COLOR_WARNING)
			$g_sSceneryCode = "DS"
			$g_sCurrentScenery = "Default"
			$g_iTree = $eTreeDS
			$g_bIsCustomMainVillage = False
			$InnerDiamondLeft = $g_iDefaultInnerDiamondLeft
			$InnerDiamondRight = $g_iDefaultInnerDiamondRight
			$InnerDiamondTop = $g_iDefaultInnerDiamondTop
			$InnerDiamondBottom = $g_iDefaultInnerDiamondBottom
			$g_iSceneryEdgeDiffX = $g_iDefaultEdgeDiffX
			$g_iSceneryEdgeDiffY = $g_iDefaultEdgeDiffY
			If $g_bDebugSetLog Then SetDebugLog("Scenery unknown, using default diamond and edges", $COLOR_WARNING)
		EndIf
		
		Local $z = $c / $iRefSize
		If $g_bDebugSetLog Then SetDebugLog("GetVillageSize, Scenery : " & $g_sSceneryCode & " : " & $g_sCurrentScenery & ", Zoom:" & $z, $COLOR_DEBUG1)
		If $g_bDebugSetLog Then SetDebugLog("Stone2tree = " & $c)
		If $g_bDebugSetLog Then SetDebugLog("Reference = " & $iRefSize)
		If $g_bDebugSetLog Then SetDebugLog("ZoomLevel = " & $z)
		
		$checkZoomOffset = Round(($c - $iRefSize), 2)
		If $checkZoomOffset > $ZoomOffset Then 
			If $g_bDebugSetLog Then SetDebugLog("Stone2tree:" & Round($c, 2) & " - Reference:" & Round($iRefSize, 2) & " = " & $checkZoomOffset & " > " & $ZoomOffset, $COLOR_DEBUG2)
			Return FuncReturn($aResult)
		Else
			If $g_bDebugSetLog Then SetDebugLog("Stone2tree:" & Round($c, 2) & " Reference:" & Round($iRefSize, 2) & " checkZoomOffset: " & $checkZoomOffset, $COLOR_DEBUG2)
		EndIf
		
		Local $stone_x_exp = $stone[2]
		Local $stone_y_exp = $stone[3]
		ConvertVillagePos($stone_x_exp, $stone_y_exp, $z) ; expected x, y position of stone
		$x = $stone[0] - $stone_x_exp
		$y = $stone[1] - $stone_y_exp
		
		;set global var
		$g_iZoomFactor = $z
		$g_ixOffset = $x
		$g_iyOffset = $y
		
		If $g_bDebugSetLog Then SetDebugLog("GetVillageSize measured: " & $c & ", Zoom factor: " & $z & ", Offset: " & $x & ", " & $y, $COLOR_INFO)

		Dim $aResult[11]
		$aResult[0] = $c
		$aResult[1] = $z
		$aResult[2] = $x
		$aResult[3] = $y
		$aResult[4] = $stone[0]
		$aResult[5] = $stone[1]
		$aResult[6] = $stone[5]
		$aResult[7] = $tree[0]
		$aResult[8] = $tree[1]
		$aResult[9] = $tree[5]

		$g_aVillageSize = $aResult
		ConvertInternalExternArea()
		Return FuncReturn($aResult)
	EndIf
	FuncReturn()
EndFunc   ;==>GetVillageSize

; #FUNCTION# ====================================================================================================================
; Name ..........: _ApplySceneryInnerAdjust
; Description ...: Apply optional per-scenery inner diamond adjustments.
; Syntax ........: _ApplySceneryInnerAdjust($sSceneryCode, ByRef $iLeft, ByRef $iRight, ByRef $iTop, ByRef $iBottom)
; Parameters ....: $sSceneryCode - scenery code
;                  $iLeft        - [in/out] left bound
;                  $iRight       - [in/out] right bound
;                  $iTop         - [in/out] top bound
;                  $iBottom      - [in/out] bottom bound
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; =====================================================================================================================
Func _ApplySceneryInnerAdjust($sSceneryCode, ByRef $iLeft, ByRef $iRight, ByRef $iTop, ByRef $iBottom)
	Local $iIndex = _ArraySearch($g_aSceneryInnerAdjust, $sSceneryCode)
	If $iIndex = -1 Then Return
	Local $dLeft = $g_aSceneryInnerAdjust[$iIndex][1]
	Local $dRight = $g_aSceneryInnerAdjust[$iIndex][2]
	Local $dTop = $g_aSceneryInnerAdjust[$iIndex][3]
	Local $dBottom = $g_aSceneryInnerAdjust[$iIndex][4]
	If $dLeft = 0 And $dRight = 0 And $dTop = 0 And $dBottom = 0 Then Return
	$iLeft += $dLeft
	$iRight += $dRight
	$iTop += $dTop
	$iBottom += $dBottom
	If $g_bDebugSetLog Then SetDebugLog("Inner adjust " & $sSceneryCode & ": " & $dLeft & "," & $dRight & "," & $dTop & "," & $dBottom, $COLOR_DEBUG1)
EndFunc   ;==>_ApplySceneryInnerAdjust

Func FindStone($sDirectory = $g_sImgZoomOutDir, $sStonePrefix = "stone", $iAdditionalX = 100, $iAdditionalY = 100, $sStoneCodeOverride = "")
	Local $stone = [0, 0, 0, 0, 0, ""]
	Local $x0, $y0, $d0, $x, $y, $x1, $y1, $right, $bottom, $a, $b
	Local $aStoneFiles
	Local $iMaxX = $g_iGAME_WIDTH - 1
	Local $iMaxY = $g_iGAME_HEIGHT - 1
	
	For $check = 1 To 2
		;SetLog("[" & $check & "] Checking for same scenery: " & $g_sSceneryCode, $COLOR_DEBUG1)
		If $check = 1 Then 
			Local $sSearchCode = $g_sSceneryCode
			If $sStoneCodeOverride <> "" Then $sSearchCode = $sStoneCodeOverride
			$aStoneFiles = _FileListToArray($sDirectory & "stone\", $sStonePrefix & $sSearchCode & "*.*", $FLTA_FILES)
		Else
			$aStoneFiles = _FileListToArray($sDirectory & "stone\", $sStonePrefix & "*.*", $FLTA_FILES)
		EndIf
		
		If @error Then
			SetDebugLog("Error: Missing stone files (" & @error & ")", $COLOR_ERROR)
			ContinueLoop
		EndIf
		
		Local $i, $findImage, $sArea, $StoneName, $iAddX, $iAddY
		$iAddX = $iAdditionalX
		$iAddY = $iAdditionalY
		If $check = 2 Then
			$iAddX += 80
			$iAddY += 80
			SetDebugLog("FindStone fallback: any stone, expanded search")
		EndIf
		For $i = 1 To $aStoneFiles[0]
			$findImage = $aStoneFiles[$i]
			$a = StringRegExp($findImage, "stone([0-9A-Z]+)-(\d+)-(\d+)_.*[.](xml|png|bmp)$", $STR_REGEXPARRAYMATCH)
			If UBound($a) = 4 Then
				$StoneName = $a[0]
				$d0 = $StoneName
				$x0 = $a[1]
				$y0 = $a[2]
				$x1 = $x0 - $iAddX
				$y1 = $y0 - $iAddY
				$right = $x0 + $iAddX
				$bottom = $y0 + $iAddY
				If $x1 < 0 Then $x1 = 0
				If $y1 < 0 Then $y1 = 0
				If $right > $iMaxX Then $right = $iMaxX
				If $bottom > $iMaxY Then $bottom = $iMaxY
				If $right <= $x1 Or $bottom <= $y1 Then ContinueLoop
				$sArea = Int($x1) & "," & Int($y1) & "|" & Int($right) & "," & Int($y1) & "|" & Int($right) & "," & Int($bottom) & "|" & Int($x1) & "," & Int($bottom)
				SetDebugLog("GetVillageSize check for image " & $findImage)
				$b = decodeSingleCoord(findImage("stone" & $StoneName, $sDirectory & "stone\" & $findImage, $sArea, 1, True))
				If UBound($b) = 2 Then
					$x = Int($b[0])
					$y = Int($b[1])
					SetDebugLog("Found stone image at " & $x & ", " & $y & ": " & $findImage, $COLOR_INFO)
					$stone[0] = $x ; x center of stone found
					$stone[1] = $y ; y center of stone found
					$stone[2] = $x0 ; x center of reference stone
					$stone[3] = $y0 ; y center of reference stone
					$stone[4] = $d0 ; distance from stone to tree in pixel
					$stone[5] = $findImage
					ExitLoop 2
				EndIf
			Else
				SetDebugLog("GetVillageSize ignore image " & $findImage & ", reason: " & UBound($a), $COLOR_WARNING)
			EndIf
			If Not $g_bRunState Then Return
		Next
		If Not $g_bRunState Then Return
	Next
	Return $stone
EndFunc

Func FindTree($sDirectory = $g_sImgZoomOutDir, $sTreePrefix = "tree", $iAdditionalX = 150, $iAdditionalY = 100, $sStoneName = "DS")
	Local $tree = [0, 0, 0, 0, 0, ""]
	Local $x0, $y0, $d0, $x, $y, $x1, $y1, $right, $bottom, $a, $b, $i, $findImage, $sArea, $sTreeCode
	Local $aTreeFiles = _FileListToArray($sDirectory & "tree\", $sTreePrefix & "*.*", $FLTA_FILES)
	Local $iMaxX = $g_iGAME_WIDTH - 1
	Local $iMaxY = $g_iGAME_HEIGHT - 1
	If @error Then
		SetLog("Error: Missing tree (" & @error & ")", $COLOR_ERROR)
		Return $tree
	EndIf
	
	Local $scenerycode = "tree" & $sStoneName
	For $pass = 1 To 2
		Local $iAddX = $iAdditionalX
		Local $iAddY = $iAdditionalY
		If $pass = 2 Then
			$iAddX += 80
			$iAddY += 80
			SetDebugLog("FindTree fallback: any tree, expanded search")
		EndIf
		For $i = 1 To $aTreeFiles[0]
			$findImage = $aTreeFiles[$i]
			If $pass = 1 And StringRegExp($findImage, $scenerycode, $STR_REGEXPMATCH) <> 1 Then
				ContinueLoop
			EndIf
			$a = StringRegExp($findImage, "(tree[0-9A-Z]+)-(\d+)-(\d+)_.*[.](xml|png|bmp)$", $STR_REGEXPARRAYMATCH)
			If UBound($a) = 4 Then
				$x0 = $a[1]
				$y0 = $a[2]
				$d0 = "notused"
				$sTreeCode = StringTrimLeft($a[0], 4)

				$x1 = $x0 - $iAddX
				$y1 = $y0 - $iAddY
				$right = $x0 + $iAddX
				$bottom = $y0 + $iAddY
				If $x1 < 0 Then $x1 = 0
				If $y1 < 0 Then $y1 = 0
				If $right > $iMaxX Then $right = $iMaxX
				If $bottom > $iMaxY Then $bottom = $iMaxY
				If $right <= $x1 Or $bottom <= $y1 Then ContinueLoop
				$sArea = Int($x1) & "," & Int($y1) & "|" & Int($right) & "," & Int($y1) & "|" & Int($right) & "," & Int($bottom) & "|" & Int($x1) & "," & Int($bottom)
				SetDebugLog("GetVillageSize check for image " & $findImage)
				$b = decodeSingleCoord(findImage("tree" & $sTreeCode, $sDirectory & "tree\" & $findImage, $sArea, 1, True))
				; sort by x because there can be a 2nd at the right that should not be used
				If UBound($b) = 2 Then
					$x = Int($b[0])
					$y = Int($b[1])
					SetDebugLog("Found tree image at " & $x & ", " & $y & ": " & $findImage, $COLOR_INFO)
					$tree[0] = $x ; x center of tree found
					$tree[1] = $y ; y center of tree found
					$tree[2] = $x0 ; x ref. center of tree
					$tree[3] = $y0 ; y ref. center of tree
					$tree[4] = $sTreeCode ; tree scenery code
					$tree[5] = $findImage
					ExitLoop 2
				EndIf
			Else
				SetDebugLog("GetVillageSize ignore image " & $findImage & ", reason: " & UBound($a), $COLOR_WARNING)
			EndIf
			If Not $g_bRunState Then Return
		Next
		If Not $g_bRunState Then Return
	Next
	Return $tree
EndFunc

Func UpdateGlobalVillageOffset($x, $y)

	Local $updated = False

	If $g_sImglocRedline <> "" Then

		Local $newReadLine = ""
		Local $aPoints = StringSplit($g_sImglocRedline, "|", $STR_NOCOUNT)

		For $sPoint In $aPoints

			Local $aPoint = GetPixel($sPoint, ",")
			$aPoint[0] += $x
			$aPoint[1] += $y

			If StringLen($newReadLine) > 0 Then $newReadLine &= "|"
			$newReadLine &= ($aPoint[0] & "," & $aPoint[1])

		Next

		; set updated red line
		$g_sImglocRedline = $newReadLine

		$updated = True
	EndIf

	If $g_aiTownHallDetails[0] <> 0 And $g_aiTownHallDetails[1] <> 0 Then
		$g_aiTownHallDetails[0] += $x
		$g_aiTownHallDetails[1] += $y
		$updated = True
	EndIf
	If $g_iTHx <> 0 And $g_iTHy <> 0 Then
		$g_iTHx += $x
		$g_iTHy += $y
		$updated = True
	EndIf

	ConvertInternalExternArea()

	Return $updated

EndFunc   ;==>UpdateGlobalVillageOffset

Func DetectScenery($stone = "None")
	Local $sScenery = ""
	Local $iIndex = 0
	Local $a = StringRegExp($stone, "stone([0-9A-Z]+)", $STR_REGEXPARRAYMATCH)
	If IsArray($a) Then 
		$iIndex = _ArraySearch($g_aVillageRefSize, $a[0])
		$sScenery = $g_aVillageRefSize[$iIndex][1]
	Else
		$sScenery = "Failed scenery detection"
	EndIf

	Return $sScenery
EndFunc

Func getVillageCenteringCoord()
	Local $aValue[2] = [0, 0]
	Local $iRan = Random(0, Ubound($aVillageCenteringCoord) - 1, 1)

	$aValue[0] = $aVillageCenteringCoord[$iRan][0]
	$aValue[1] = $aVillageCenteringCoord[$iRan][1]
	
	If $g_bDebugSetLog Then SetLog("Village Centering Coord : [" & $aValue[0] & "," & $aValue[1] & "]")
	Return $aValue
EndFunc
