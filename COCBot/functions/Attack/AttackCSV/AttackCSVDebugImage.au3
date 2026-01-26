; #FUNCTION# ====================================================================================================================
; Name ..........: AttackCSVDEBUGIMAGE
; Description ...:
; Syntax ........: AttackCSVDEBUGIMAGE()
; Parameters ....:
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func AttackCSVDEBUGIMAGE($bOpenImage = False)

	Local $iTimer = __TimerInit()

	_CaptureRegion2()

	Local $EditedImage = _GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap2)
	Local $testx
	Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($EditedImage)
	Local $hBrush = _GDIPlus_BrushCreateSolid(0xFFFFFFFF)
	Local $pixel
	Local $aEmpty[0]
	If Not IsArray($g_aiPixelTopLeft) Then $g_aiPixelTopLeft = $aEmpty
	If Not IsArray($g_aiPixelTopRight) Then $g_aiPixelTopRight = $aEmpty
	If Not IsArray($g_aiPixelBottomLeft) Then $g_aiPixelBottomLeft = $aEmpty
	If Not IsArray($g_aiPixelBottomRight) Then $g_aiPixelBottomRight = $aEmpty

	; Open box of crayons :-)
	Local $hPenLtGreen = _GDIPlus_PenCreate(0xFF00DC00, 2)
	Local $hPenDkGreen = _GDIPlus_PenCreate(0xFF006E00, 2)
	Local $hPenMdGreen = _GDIPlus_PenCreate(0xFF4CFF00, 2)
	Local $hPenRed = _GDIPlus_PenCreate(0xFFFF0000, 2)
	Local $hPenDkRed = _GDIPlus_PenCreate(0xFF6A0000, 2)
	Local $hPenNavyBlue = _GDIPlus_PenCreate(0xFF000066, 2)
	Local $hPenBlue = _GDIPlus_PenCreate(0xFF0000CC, 2)
	Local $hPenSteelBlue = _GDIPlus_PenCreate(0xFF0066CC, 2)
	Local $hPenLtBlue = _GDIPlus_PenCreate(0xFF0080FF, 2)
	Local $hPenPaleBlue = _GDIPlus_PenCreate(0xFF66B2FF, 2)
	Local $hPenCyan = _GDIPlus_PenCreate(0xFF00FFFF, 2)
	Local $hPenYellow = _GDIPlus_PenCreate(0xFFFFD800, 2)
	Local $hPenLtGrey = _GDIPlus_PenCreate(0xFFCCCCCC, 2)
	Local $hPenWhite = _GDIPlus_PenCreate(0xFFFFFFFF, 2)
	Local $hPenMagenta = _GDIPlus_PenCreate(0xFFFF00F6, 2)


	;-- DRAW EXTERNAL PERIMETER LINES
	_GDIPlus_GraphicsDrawLine($hGraphic, $ExternalArea[0][0], $ExternalArea[0][1], $ExternalArea[2][0], $ExternalArea[2][1], $hPenYellow)
	_GDIPlus_GraphicsDrawLine($hGraphic, $ExternalArea[0][0], $ExternalArea[0][1], $ExternalArea[3][0], $ExternalArea[3][1], $hPenYellow)
	_GDIPlus_GraphicsDrawLine($hGraphic, $ExternalArea[1][0], $ExternalArea[1][1], $ExternalArea[2][0], $ExternalArea[2][1], $hPenYellow)
	_GDIPlus_GraphicsDrawLine($hGraphic, $ExternalArea[1][0], $ExternalArea[1][1], $ExternalArea[3][0], $ExternalArea[3][1], $hPenYellow)

	;-- DRAW INTERNAL PERIMETER LINES
	_GDIPlus_GraphicsDrawLine($hGraphic, $InternalArea[0][0], $InternalArea[0][1], $InternalArea[2][0], $InternalArea[2][1], $hPenMagenta)
	_GDIPlus_GraphicsDrawLine($hGraphic, $InternalArea[0][0], $InternalArea[0][1], $InternalArea[3][0], $InternalArea[3][1], $hPenMagenta)
	_GDIPlus_GraphicsDrawLine($hGraphic, $InternalArea[1][0], $InternalArea[1][1], $InternalArea[2][0], $InternalArea[2][1], $hPenMagenta)
	_GDIPlus_GraphicsDrawLine($hGraphic, $InternalArea[1][0], $InternalArea[1][1], $InternalArea[3][0], $InternalArea[3][1], $hPenMagenta)

	;-- DRAW VERTICAL AND ORIZONTAL LINES
	_GDIPlus_GraphicsDrawLine($hGraphic, $InternalArea[2][0], 0, $InternalArea[2][0], $g_iDEFAULT_HEIGHT, $hPenDkGreen)
	_GDIPlus_GraphicsDrawLine($hGraphic, 0, $InternalArea[0][1], $g_iDEFAULT_WIDTH, $InternalArea[0][1], $hPenDkGreen)

	;-- DRAW DIAGONALS LINES
	_GDIPlus_GraphicsDrawLine($hGraphic, $ExternalArea[4][0], $ExternalArea[4][1], $ExternalArea[7][0], $ExternalArea[7][1], $hPenLtGreen)
	_GDIPlus_GraphicsDrawLine($hGraphic, $ExternalArea[5][0], $ExternalArea[5][1], $ExternalArea[6][0], $ExternalArea[6][1], $hPenLtGreen)

	;-- DRAW INNER/OUTER DIAMOND OVERLAY (scenery validation)
	If IsArray($g_aiInnerDiamond) And UBound($g_aiInnerDiamond) >= 4 Then
		_DrawDiamondOverlay($hGraphic, $g_aiInnerDiamond[0], $g_aiInnerDiamond[1], $g_aiInnerDiamond[2], $g_aiInnerDiamond[3], $hPenBlue)
	EndIf
	If IsArray($g_aiOuterDiamond) And UBound($g_aiOuterDiamond) >= 4 Then
		_DrawDiamondOverlay($hGraphic, $g_aiOuterDiamond[0], $g_aiOuterDiamond[1], $g_aiOuterDiamond[2], $g_aiOuterDiamond[3], $hPenCyan)
	EndIf

	;-- DRAW REDAREA PATH
	For $i = 0 To UBound($g_aiPixelTopLeft) - 1
		$pixel = $g_aiPixelTopLeft[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenRed)
	Next
	For $i = 0 To UBound($g_aiPixelTopRight) - 1
		$pixel = $g_aiPixelTopRight[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenRed)
	Next
	For $i = 0 To UBound($g_aiPixelBottomLeft) - 1
		$pixel = $g_aiPixelBottomLeft[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenRed)
	Next
	For $i = 0 To UBound($g_aiPixelBottomRight) - 1
		$pixel = $g_aiPixelBottomRight[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenRed)
	Next

	;-- DRAW LOCATED BUILDINGS (CSV/IMGLOC)
	If $g_bDebugBuildingPos Or $g_bDebugAttackCSV Then
		_CSVDrawCollectorPoints($hGraphic, $hPenYellow, $hPenMagenta, $hPenCyan)
		_CSVDrawBldgLocations($hGraphic, $hPenWhite, $hPenRed, $hPenDkRed, $hPenBlue, $hPenLtBlue, $hPenPaleBlue, _
				$hPenDkGreen, $hPenSteelBlue, $hPenNavyBlue, $hPenYellow, $hPenMagenta, $hPenCyan, $hPenLtGrey)
	EndIf

	;;DRAW FULL DROP LINES PATH
	;
	;For $i = 0 To UBound($g_aiPixelTopLeftDropLine) - 1
	;	$pixel = $g_aiPixelTopLeftDropLine[$i]
	;	_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenBlue)
	;Next
	;For $i = 0 To UBound($g_aiPixelTopRightDropLine) - 1
	;	$pixel = $g_aiPixelTopRightDropLine[$i]
	;	_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenCyan)
	;Next
	;For $i = 0 To UBound($g_aiPixelBottomLeftDropLine) - 1
	;	$pixel = $g_aiPixelBottomLeftDropLine[$i]
	;	_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenYellow)
	;Next
	;For $i = 0 To UBound($g_aiPixelBottomRightDropLine) - 1
	;	$pixel = $g_aiPixelBottomRightDropLine[$i]
	;	_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenLtGrey)
	;Next
	;
	;;DRAW SLICES DROP PATH LINES
	;For $i = 0 To UBound($g_aiPixelTopLeftDOWNDropLine) - 1
	;	$pixel = $g_aiPixelTopLeftDOWNDropLine[$i]
	;	_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenBlue)
	;Next
	;For $i = 0 To UBound($g_aiPixelTopLeftUPDropLine) - 1
	;	$pixel = $g_aiPixelTopLeftUPDropLine[$i]
	;	_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenCyan)
	;Next
	;For $i = 0 To UBound($g_aiPixelBottomLeftDOWNDropLine) - 1
	;	$pixel = $g_aiPixelBottomLeftDOWNDropLine[$i]
	;	_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenYellow)
	;Next
	;For $i = 0 To UBound($g_aiPixelBottomLeftUPDropLine) - 1
	;	$pixel = $g_aiPixelBottomLeftUPDropLine[$i]
	;	_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenLtGrey)
	;Next
	;For $i = 0 To UBound($g_aiPixelTopRightDOWNDropLine) - 1
	;	$pixel = $g_aiPixelTopRightDOWNDropLine[$i]
	;	_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenBlue)
	;Next
	;For $i = 0 To UBound($g_aiPixelTopRightUPDropLine) - 1
	;	$pixel = $g_aiPixelTopRightUPDropLine[$i]
	;	_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenCyan)
	;Next
	;For $i = 0 To UBound($g_aiPixelBottomRightDOWNDropLine) - 1
	;	$pixel = $g_aiPixelBottomRightDOWNDropLine[$i]
	;	_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenYellow)
	;Next
	;For $i = 0 To UBound($g_aiPixelBottomRightUPDropLine) - 1
	;	$pixel = $g_aiPixelBottomRightUPDropLine[$i]
	;	_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenLtGrey)
	;Next

	;DRAW DROP POINTS EXAMPLES
	;$testx = MakeDropPoints("TOP-LEFT-DOWN", 10, 2, "EXT-INT")
	;For $i = 0 To UBound($testx) - 1
	;	$pixel = $testx[$i]
	;	_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0], $pixel[1], "Arial", 12)
	;	_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenRed)
	;Next

	$testx = MakeDropPoints("TOP-LEFT-DOWN", 10, 4, "EXT-INT") ;
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0] - 10, $pixel[1] - 10, "Arial", 12)
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenMdGreen)
	Next

	;$testx = MakeDropPoints("BOTTOM-LEFT-UP", 10, 2, "EXT-INT")
	;For $i = 0 To UBound($testx) - 1
	;	$pixel = $testx[$i]
	;	_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0], $pixel[1], "Arial", 12)
	;	_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenRed)
	;Next

	$testx = MakeDropPoints("BOTTOM-LEFT-UP", 10, 4, "EXT-INT") ;
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0] - 10, $pixel[1] - 10, "Arial", 12)
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenMdGreen)
	Next

	;$testx = MakeDropPoints("TOP-RIGHT-DOWN", 10, 2, "EXT-INT")
	;For $i = 0 To UBound($testx) - 1
	;	$pixel = $testx[$i]
	;	_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0], $pixel[1], "Arial", 12)
	;	_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenRed)
	;Next

	$testx = MakeDropPoints("TOP-RIGHT-DOWN", 10, 4, "EXT-INT") ;
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0] - 10, $pixel[1] - 10, "Arial", 12)
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenMdGreen)
	Next

	;$testx = MakeDropPoints("BOTTOM-RIGHT-UP", 10, 2, "EXT-INT")
	;For $i = 0 To UBound($testx) - 1
	;	$pixel = $testx[$i]
	;	_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0], $pixel[1], "Arial", 12)
	;	_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenRed)
	;Next

	$testx = MakeDropPoints("BOTTOM-RIGHT-UP", 10, 4, "EXT-INT") ;
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0] - 10, $pixel[1] - 10, "Arial", 12)
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenMdGreen)
	Next

	;$testx = MakeDropPoints("TOP-LEFT-UP", 10, 2, "INT-EXT")
	;For $i = 0 To UBound($testx) - 1
	;	$pixel = $testx[$i]
	;	_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0], $pixel[1], "Arial", 12)
	;	_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenRed)
	;Next

	$testx = MakeDropPoints("TOP-LEFT-UP", 10, 4, "INT-EXT") ;
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0] - 10, $pixel[1] - 10, "Arial", 12)
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenMdGreen)
	Next

	;$testx = MakeDropPoints("BOTTOM-LEFT-DOWN", 10, 2, "INT-EXT")
	;For $i = 0 To UBound($testx) - 1
	;	$pixel = $testx[$i]
	;	_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0], $pixel[1], "Arial", 12)
	;	_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenRed)
	;Next

	$testx = MakeDropPoints("BOTTOM-LEFT-DOWN", 10, 4, "INT-EXT") ;
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0] - 10, $pixel[1] - 10, "Arial", 12)
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenMdGreen)
	Next

	;$testx = MakeDropPoints("TOP-RIGHT-UP", 10, 2, "INT-EXT")
	;For $i = 0 To UBound($testx) - 1
	;	$pixel = $testx[$i]
	;	_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0], $pixel[1], "Arial", 12)
	;	_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenRed)
	;Next

	$testx = MakeDropPoints("TOP-RIGHT-UP", 10, 4, "INT-EXT") ;
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0] - 10, $pixel[1] - 10, "Arial", 12)
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenMdGreen)
	Next

	;$testx = MakeDropPoints("BOTTOM-RIGHT-DOWN", 10, 2, "INT-EXT")
	;For $i = 0 To UBound($testx) - 1
	;	$pixel = $testx[$i]
	;	_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0], $pixel[1], "Arial", 12)
	;	_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenRed)
	;Next

	$testx = MakeDropPoints("BOTTOM-RIGHT-DOWN", 10, 4, "INT-EXT") ;
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0] - 10, $pixel[1] - 10, "Arial", 12)
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenMdGreen)
	Next

	; 06 - DRAW MINES, ELIXIR, DRILLS ------------------------------------------------------------------------
	For $i = 0 To UBound($g_aiPixelMine) - 1
		$pixel = $g_aiPixelMine[$i]
		_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 10, $pixel[1] - 10, 20, 20, $hPenLtGreen)
	Next
	For $i = 0 To UBound($g_aiPixelElixir) - 1
		$pixel = $g_aiPixelElixir[$i]
		_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 10, $pixel[1] - 5, 20, 20, $hPenDkGreen)
	Next
	For $i = 0 To UBound($g_aiPixelDarkElixir) - 1
		$pixel = $g_aiPixelDarkElixir[$i]
		_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 10, $pixel[1] - 5, 20, 20, $hPenDkRed)
	Next

	; - DRAW GOLD STORAGE -------------------------------------------------------
	If $g_bCSVLocateStorageGold = True And IsArray($g_aiCSVGoldStoragePos) Then
			For $i = 0 To UBound($g_aiCSVGoldStoragePos) - 1
				$pixel = $g_aiCSVGoldStoragePos[$i]
				_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 10, $pixel[1] - 15, 20, 20, $hPenWhite)
			Next
	EndIf

	; - DRAW ELIXIR STORAGE ---------------------------------------------------------
	If $g_bCSVLocateStorageElixir = True And IsArray($g_aiCSVElixirStoragePos) Then
			For $i = 0 To UBound($g_aiCSVElixirStoragePos) - 1
				$pixel = $g_aiCSVElixirStoragePos[$i]
				_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 10, $pixel[1] - 15, 20, 20, $hPenMagenta)
			Next
	EndIf


	; - DRAW TOWNHALL -------------------------------------------------------------------
	_GDIPlus_GraphicsDrawRect($hGraphic, $g_iTHx - 5, $g_iTHy - 10, 30, 30, $hPenRed)

	; - DRAW Eagle -------------------------------------------------------------------
	If $g_bCSVLocateEagle = True And IsArray($g_aiCSVEagleArtilleryPos) Then
		_GDIPlus_GraphicsDrawRect($hGraphic, $g_aiCSVEagleArtilleryPos[0] - 15, $g_aiCSVEagleArtilleryPos[1] - 15, 30, 30, $hPenBlue)
	EndIf

	; - DRAW Eagle -------------------------------------------------------------------
	If $g_bCSVLocateScatter = True And IsArray($g_aiCSVScatterPos) Then
		_GDIPlus_GraphicsDrawRect($hGraphic, $g_aiCSVScatterPos[0] - 15, $g_aiCSVScatterPos[1] - 15, 30, 30, $hPenBlue)
	EndIf

	; - DRAW Inferno -------------------------------------------------------------------
	If $g_bCSVLocateInferno = True And IsArray($g_aiCSVInfernoPos) Then
		For $i = 0 To UBound($g_aiCSVInfernoPos) - 1
			$pixel = $g_aiCSVInfernoPos[$i]
			_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 10, $pixel[1] - 10, 20, 20, $hPenNavyBlue)
		Next
	EndIf

	; - DRAW X-Bow -------------------------------------------------------------------
	If $g_bCSVLocateXBow = True And IsArray($g_aiCSVXBowPos) Then
		For $i = 0 To UBound($g_aiCSVXBowPos) - 1
			$pixel = $g_aiCSVXBowPos[$i]
			_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 10, $pixel[1] - 25, 25, 25, $hPenBlue)
		Next
	EndIf

	; - DRAW Wizard Towers -------------------------------------------------------------------
	If $g_bCSVLocateWizTower = True And IsArray($g_aiCSVWizTowerPos) Then
		For $i = 0 To UBound($g_aiCSVWizTowerPos) - 1
			$pixel = $g_aiCSVWizTowerPos[$i]
			_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 5, $pixel[1] - 15, 25, 25, $hPenSteelBlue)
		Next
	EndIf

	; - DRAW Mortars -------------------------------------------------------------------
	If $g_bCSVLocateMortar = True And IsArray($g_aiCSVMortarPos) Then
		For $i = 0 To UBound($g_aiCSVMortarPos) - 1
			$pixel = $g_aiCSVMortarPos[$i]
			_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 10, $pixel[1] - 15, 25, 25, $hPenLtBlue)
		Next
	EndIf

	; - DRAW Air Defense -------------------------------------------------------------------
	If $g_bCSVLocateAirDefense = True And IsArray($g_aiCSVAirDefensePos) Then
		For $i = 0 To UBound($g_aiCSVAirDefensePos) - 1
			$pixel = $g_aiCSVAirDefensePos[$i]
			_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 12, $pixel[1] - 10, 25, 25, $hPenPaleBlue)
		Next
	EndIf

	; - DRAW Air Sweeper -------------------------------------------------------------------
	If $g_bCSVLocateSweeper = True And IsArray($g_aiCSVSweeperPos) Then
		For $i = 0 To UBound($g_aiCSVSweeperPos) - 1
			$pixel = $g_aiCSVSweeperPos[$i]
			_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 10, $pixel[1] - 10, 24, 24, $hPenCyan)
		Next
	EndIf

	; - DRAW Monolith -------------------------------------------------------------------
	If $g_bCSVLocateMonolith = True And IsArray($g_aiCSVMonolithPos) Then
		For $i = 0 To UBound($g_aiCSVMonolithPos) - 1
			$pixel = $g_aiCSVMonolithPos[$i]
			_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 12, $pixel[1] - 12, 26, 26, $hPenYellow)
		Next
	EndIf

	; - DRAW Firespitter -------------------------------------------------------------------
	If $g_bCSVLocateFireSpitter = True And IsArray($g_aiCSVFireSpitterPos) Then
		For $i = 0 To UBound($g_aiCSVFireSpitterPos) - 1
			$pixel = $g_aiCSVFireSpitterPos[$i]
			_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 12, $pixel[1] - 12, 24, 24, $hPenDkRed)
		Next
	EndIf

	; - DRAW Multi Archer Tower -------------------------------------------------------------------
	If $g_bCSVLocateMultiArcherTower = True And IsArray($g_aiCSVMultiArcherTowerPos) Then
		For $i = 0 To UBound($g_aiCSVMultiArcherTowerPos) - 1
			$pixel = $g_aiCSVMultiArcherTowerPos[$i]
			_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 10, $pixel[1] - 20, 24, 24, $hPenLtGrey)
		Next
	EndIf

	; - DRAW Multi Gear Tower -------------------------------------------------------------------

	If $g_bCSVLocateMultiGearTower = True And IsArray($g_aiCSVMultiGearTowerPos) Then
		For $i = 0 To UBound($g_aiCSVMultiGearTowerPos) - 1
			$pixel = $g_aiCSVMultiGearTowerPos[$i]
			_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 10, $pixel[1] - 10, 24, 24, $hPenLtGrey)
		Next
	EndIf

	; - DRAW Ricochet Cannon -------------------------------------------------------------------
	If $g_bCSVLocateRicochetCannon = True And IsArray($g_aiCSVRicochetCannonPos) Then
		For $i = 0 To UBound($g_aiCSVRicochetCannonPos) - 1
			$pixel = $g_aiCSVRicochetCannonPos[$i]
			_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 12, $pixel[1] - 12, 24, 24, $hPenSteelBlue)
		Next
	EndIf

	; - DRAW Super Wizard Tower -------------------------------------------------------------------

	If $g_bCSVLocateSuperWizTower = True And IsArray($g_aiCSVSuperWizTowerPos) Then
		For $i = 0 To UBound($g_aiCSVSuperWizTowerPos) - 1
			$pixel = $g_aiCSVSuperWizTowerPos[$i]
			_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 10, $pixel[1] - 10, 24, 24, $hPenLtBlue)
		Next
	EndIf

	; - DRAW Revenge Tower -------------------------------------------------------------------
	If $g_bCSVLocateRevengeTower = True And IsArray($g_aiCSVRevengeTowerPos) Then
		For $i = 0 To UBound($g_aiCSVRevengeTowerPos) - 1
			$pixel = $g_aiCSVRevengeTowerPos[$i]
			_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 10, $pixel[1] - 10, 24, 24, $hPenDkGreen)
		Next
	EndIf

	; 99 -  DRAW SLICE NUMBERS
	;_GDIPlus_GraphicsDrawString($hGraphic, "1", 580, 580, "Arial", 20)
	;_GDIPlus_GraphicsDrawString($hGraphic, "2", 750, 450, "Arial", 20)
	;_GDIPlus_GraphicsDrawString($hGraphic, "3", 750, 200, "Arial", 20)
	;_GDIPlus_GraphicsDrawString($hGraphic, "4", 580, 110, "Arial", 20)
	;_GDIPlus_GraphicsDrawString($hGraphic, "5", 260, 110, "Arial", 20)
	;_GDIPlus_GraphicsDrawString($hGraphic, "6", 110, 200, "Arial", 20)
	;_GDIPlus_GraphicsDrawString($hGraphic, "7", 110, 450, "Arial", 20)
	;_GDIPlus_GraphicsDrawString($hGraphic, "8", 310, 580, "Arial", 20)
	
	
	; - DRAW GetVillageSize
	DrawStringA($hGraphic, $g_aVillageSize[4] & "," & $g_aVillageSize[5], $g_aVillageSize[4] - 20, $g_aVillageSize[5] + 5, "Arial", 9, 0, 0xFF0080FF)
	DrawStringA($hGraphic, $g_aVillageSize[7] & "," & $g_aVillageSize[8], $g_aVillageSize[7], $g_aVillageSize[8] + 10, "Arial", 9, 0, 0xFF0080FF)
	DrawStringA($hGraphic, "S: " & DetectScenery($g_aVillageSize[6]), 610, 490, "Arial", 12)
	DrawStringA($hGraphic, "Size: " & $g_aVillageSize[0], 610, 510, "Arial", 12)
	DrawStringA($hGraphic, "ZF: " & $g_aVillageSize[1], 610, 530, "Arial", 12)
	DrawStringA($hGraphic, "Offset: " & $g_aVillageSize[2] & ", " & $g_aVillageSize[3], 610, 550, "Arial", 12)
	
	_GDIPlus_GraphicsDrawLine($hGraphic, int($g_aVillageSize[4]), int($g_aVillageSize[5]), int($g_aVillageSize[7]), int($g_aVillageSize[8]), $hPenMagenta)
	;_GDIPlus_GraphicsDrawLine($hGraphic, int($g_aVillageSize[4]), int($g_aVillageSize[8]), int($g_aVillageSize[7]), int($g_aVillageSize[8]), $hPenMagenta)
	;_GDIPlus_GraphicsDrawLine($hGraphic, int($g_aVillageSize[4]), int($g_aVillageSize[8]), int($g_aVillageSize[4]), int($g_aVillageSize[5]), $hPenMagenta)

	Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
	Local $Time = @HOUR & "." & @MIN & "." & @SEC
	Local $filename = $g_sProfileTempDebugPath & String("AttackDebug_" & DetectScenery($g_aVillageSize[6]) & "_" & $Date & "_" & $Time) & ".png"
	_GDIPlus_ImageSaveToFile($EditedImage, $filename)
	If @error Then SetLog("Debug Image save error: " & @extended, $COLOR_ERROR)
	SetDebugLog("Attack CSV image saved: " & $filename)

	; Clean up resources
	_GDIPlus_PenDispose($hPenLtGreen)
	_GDIPlus_PenDispose($hPenDkGreen)
	_GDIPlus_PenDispose($hPenMdGreen)
	_GDIPlus_PenDispose($hPenRed)
	_GDIPlus_PenDispose($hPenDkRed)
	_GDIPlus_PenDispose($hPenBlue)
	_GDIPlus_PenDispose($hPenNavyBlue)
	_GDIPlus_PenDispose($hPenSteelBlue)
	_GDIPlus_PenDispose($hPenLtBlue)
	_GDIPlus_PenDispose($hPenPaleBlue)
	_GDIPlus_PenDispose($hPenCyan)
	_GDIPlus_PenDispose($hPenYellow)
	_GDIPlus_PenDispose($hPenLtGrey)
	_GDIPlus_PenDispose($hPenWhite)
	_GDIPlus_PenDispose($hPenMagenta)
	_GDIPlus_BrushDispose($hBrush)
	_GDIPlus_GraphicsDispose($hGraphic)
	_GDIPlus_BitmapDispose($EditedImage)

	; open image
	If TestCapture() = True Or $bOpenImage Then
		ShellExecute($filename)
	EndIf

	SetDebugLog("AttackCSV DEBUG IMAGE Create Required: " & Round((__TimerDiff($iTimer) * 0.001), 1) & "Seconds", $COLOR_DEBUG)

EndFunc   ;==>AttackCSVDEBUGIMAGE

Func DrawStringA($hGraphics, $sString, $nX, $nY, $sFont = "Arial", $fSize = 10, $iFormat = 0, $color = 0xFFFFD800)
	Local $hBrush = _GDIPlus_BrushCreateSolid($color)
	Local $hFormat = _GDIPlus_StringFormatCreate($iFormat)
	Local $hFamily = _GDIPlus_FontFamilyCreate($sFont)
	Local $hFont = _GDIPlus_FontCreate($hFamily, $fSize)
	Local $tLayout = _GDIPlus_RectFCreate($nX, $nY, 0.0, 0.0)
	Local $aInfo = _GDIPlus_GraphicsMeasureString($hGraphics, $sString, $hFont, $tLayout, $hFormat)
	If @error Then Return SetError(@error, @extended, 0)
	Local $aResult = _GDIPlus_GraphicsDrawStringEx($hGraphics, $sString, $hFont, $aInfo[0], $hFormat, $hBrush)
	Local $iError = @error, $iExtended = @extended
	_GDIPlus_FontDispose($hFont)
	_GDIPlus_FontFamilyDispose($hFamily)
	_GDIPlus_StringFormatDispose($hFormat)
	_GDIPlus_BrushDispose($hBrush)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _DrawDiamondOverlay
; Description ...: Draw a diamond overlay from bounding LRTB coordinates.
; Syntax ........: _DrawDiamondOverlay($hGraphic, $iLeft, $iRight, $iTop, $iBottom, $hPen)
; Parameters ....: $hGraphic - GDI+ graphics handle
;                  $iLeft    - left bound
;                  $iRight   - right bound
;                  $iTop     - top bound
;                  $iBottom  - bottom bound
;                  $hPen     - GDI+ pen handle
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; =====================================================================================================================
Func _DrawDiamondOverlay($hGraphic, $iLeft, $iRight, $iTop, $iBottom, ByRef $hPen)
	Local $iMidX = Int(($iLeft + $iRight) / 2)
	Local $iMidY = Int(($iTop + $iBottom) / 2)
	_GDIPlus_GraphicsDrawLine($hGraphic, $iLeft, $iMidY, $iMidX, $iTop, $hPen)
	_GDIPlus_GraphicsDrawLine($hGraphic, $iMidX, $iTop, $iRight, $iMidY, $hPen)
	_GDIPlus_GraphicsDrawLine($hGraphic, $iRight, $iMidY, $iMidX, $iBottom, $hPen)
	_GDIPlus_GraphicsDrawLine($hGraphic, $iMidX, $iBottom, $iLeft, $iMidY, $hPen)
EndFunc   ;==>_DrawDiamondOverlay

; #FUNCTION# ====================================================================================================================
; Name ..........: _CSVDrawCollectorPoints
; Description ...: Draw mine/collector/drill points on the CSV debug image.
; Syntax ........: _CSVDrawCollectorPoints($hGraphic, $hPenGold, $hPenElixir, $hPenDark)
; Parameters ....: $hGraphic          - GDI+ graphics handle.
;                  $hPenGold          - Pen for mines.
;                  $hPenElixir        - Pen for collectors.
;                  $hPenDark          - Pen for drills.
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _CSVDrawCollectorPoints($hGraphic, ByRef $hPenGold, ByRef $hPenElixir, ByRef $hPenDark)
	_CSVDrawPointArray($hGraphic, $g_aiPixelMine, $hPenGold, 6, "M", 0xFFFFFFFF)
	_CSVDrawPointArray($hGraphic, $g_aiPixelElixir, $hPenElixir, 6, "E", 0xFFFFFFFF)
	_CSVDrawPointArray($hGraphic, $g_aiPixelDarkElixir, $hPenDark, 6, "D", 0xFFFFFFFF)
EndFunc   ;==>_CSVDrawCollectorPoints

; #FUNCTION# ====================================================================================================================
; Name ..........: _CSVDrawBldgLocations
; Description ...: Draw building locations from attack dictionary.
; Syntax ........: _CSVDrawBldgLocations($hGraphic, $hPenDefault, $hPenEagle, $hPenInferno, $hPenXBow, $hPenWiz, $hPenSuperWiz, _
;                                       $hPenAirDef, $hPenFireSpitter, $hPenMonolith, $hPenGold, $hPenElixir, $hPenDark, $hPenOther)
; Parameters ....: $hGraphic          - GDI+ graphics handle.
;                  $hPenDefault       - Default pen.
;                  $hPenEagle         - Eagle Artillery pen.
;                  $hPenInferno       - Inferno Tower pen.
;                  $hPenXBow          - XBow pen.
;                  $hPenWiz           - Wizard Tower pen.
;                  $hPenSuperWiz      - Super Wizard Tower pen.
;                  $hPenAirDef        - Air Defense pen.
;                  $hPenFireSpitter   - Fire Spitter pen.
;                  $hPenMonolith      - Monolith pen.
;                  $hPenGold          - Gold Storage pen.
;                  $hPenElixir        - Elixir Storage pen.
;                  $hPenDark          - Dark Storage/TH pen.
;                  $hPenOther         - Other defenses pen.
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _CSVDrawBldgLocations($hGraphic, ByRef $hPenDefault, ByRef $hPenEagle, ByRef $hPenInferno, ByRef $hPenXBow, ByRef $hPenWiz, _
		ByRef $hPenSuperWiz, ByRef $hPenAirDef, ByRef $hPenFireSpitter, ByRef $hPenMonolith, ByRef $hPenGold, ByRef $hPenElixir, _
		ByRef $hPenDark, ByRef $hPenOther)
	If Not IsObj($g_oBldgAttackInfo) Then Return
	Local $aKeys = $g_oBldgAttackInfo.Keys
	For $sKey In $aKeys
		If StringRight($sKey, 9) <> "_LOCATION" Then ContinueLoop
		Local $aParts = StringSplit($sKey, "_", $STR_NOCOUNT)
		If UBound($aParts) < 1 Then ContinueLoop
		Local $iEnum = Int($aParts[0])
		If $iEnum < 0 Or $iEnum >= UBound($g_sBldgNames) Then ContinueLoop
		Local $aLoc = $g_oBldgAttackInfo.Item($sKey)
		If Not IsArray($aLoc) Then ContinueLoop
		Local $hPen = $hPenDefault
		Local $sLabel = _CSVGetBldgLabel($iEnum)
		Local $iLabelColor = 0xFFFFFFFF
		Switch $iEnum
			Case $eBldgTownHall
				$hPen = $hPenDark
				$iLabelColor = 0xFFFFFFFF
			Case $eBldgEagle
				$hPen = $hPenEagle
			Case $eBldgInferno
				$hPen = $hPenInferno
			Case $eBldgXBow
				$hPen = $hPenXBow
			Case $eBldgWizTower
				$hPen = $hPenWiz
			Case $eBldgSuperWizTower
				$hPen = $hPenSuperWiz
			Case $eBldgAirDefense
				$hPen = $hPenAirDef
			Case $eBldgFireSpitter
				$hPen = $hPenFireSpitter
			Case $eBldgMonolith
				$hPen = $hPenMonolith
			Case $eBldgGoldS
				$hPen = $hPenGold
			Case $eBldgElixirS
				$hPen = $hPenElixir
			Case $eBldgDarkS
				$hPen = $hPenDark
			Case Else
				$hPen = $hPenOther
		EndSwitch
		_CSVDrawPointArray($hGraphic, $aLoc, $hPen, 6, $sLabel, $iLabelColor)
	Next
EndFunc   ;==>_CSVDrawBldgLocations

; #FUNCTION# ====================================================================================================================
; Name ..........: _CSVDrawPointArray
; Description ...: Draw a point array (single or multi) onto the CSV debug image.
; Syntax ........: _CSVDrawPointArray($hGraphic, $aLoc, $hPen[, $iSize = 6])
; Parameters ....: $hGraphic          - GDI+ graphics handle.
;                  $aLoc              - Location array (single [x,y] or list of [x,y]).
;                  $hPen              - Pen to draw with.
;                  $iSize             - [optional] marker size. Default is 6.
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _CSVDrawPointArray($hGraphic, $aLoc, ByRef $hPen, $iSize = 6, $sLabel = "", $iLabelColor = 0xFFFFFFFF)
	If Not IsArray($aLoc) Then Return
	Local $iDims = UBound($aLoc, 0)
	If @error Then Return
	Switch $iDims
		Case 2
			Local $iRows = UBound($aLoc, 1)
			Local $iCols = UBound($aLoc, 2)
			If $iCols < 2 Then Return
			For $i = 0 To $iRows - 1
				Local $iX = $aLoc[$i][0]
				Local $iY = $aLoc[$i][1]
				_GDIPlus_GraphicsDrawEllipse($hGraphic, $iX - 1, $iY - 1, $iSize, $iSize, $hPen)
				If $sLabel <> "" Then DrawStringA($hGraphic, $sLabel & ($i + 1), $iX + 4, $iY - 10, "Arial", 8, 0, $iLabelColor)
			Next
		Case Else
			If UBound($aLoc) = 0 Then Return
			If IsArray($aLoc[0]) Then
				For $i = 0 To UBound($aLoc) - 1
					Local $aPoint = $aLoc[$i]
					If IsArray($aPoint) And UBound($aPoint) >= 2 Then
						_GDIPlus_GraphicsDrawEllipse($hGraphic, $aPoint[0] - 1, $aPoint[1] - 1, $iSize, $iSize, $hPen)
						If $sLabel <> "" Then DrawStringA($hGraphic, $sLabel & ($i + 1), $aPoint[0] + 4, $aPoint[1] - 10, "Arial", 8, 0, $iLabelColor)
					EndIf
				Next
			ElseIf UBound($aLoc) >= 2 Then
				_GDIPlus_GraphicsDrawEllipse($hGraphic, $aLoc[0] - 1, $aLoc[1] - 1, $iSize, $iSize, $hPen)
				If $sLabel <> "" Then DrawStringA($hGraphic, $sLabel, $aLoc[0] + 4, $aLoc[1] - 10, "Arial", 8, 0, $iLabelColor)
			EndIf
	EndSwitch
EndFunc   ;==>_CSVDrawPointArray

; #FUNCTION# ====================================================================================================================
; Name ..........: _CSVGetBldgLabel
; Description ...: Short label for building enum used in CSV debug image.
; Syntax ........: _CSVGetBldgLabel($iEnum)
; Parameters ....: $iEnum             - building enum.
; Return values .: Success: label string
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _CSVGetBldgLabel($iEnum)
	Switch $iEnum
		Case $eBldgTownHall
			Return "TH"
		Case $eBldgEagle
			Return "EA"
		Case $eBldgInferno
			Return "IT"
		Case $eBldgXBow
			Return "XB"
		Case $eBldgWizTower
			Return "WT"
		Case $eBldgSuperWizTower
			Return "SW"
		Case $eBldgAirDefense
			Return "AD"
		Case $eBldgSweeper
			Return "SWP"
		Case $eBldgMonolith
			Return "MO"
		Case $eBldgFireSpitter
			Return "FS"
		Case $eBldgScatter
			Return "SC"
		Case $eBldgMortar
			Return "MR"
		Case $eBldgMultiArcherTower
			Return "MA"
		Case $eBldgMultiGearTower
			Return "MG"
		Case $eBldgRicochetCannon
			Return "RC"
		Case $eBldgRevengeTower
			Return "RT"
		Case $eBldgGoldS
			Return "GS"
		Case $eBldgElixirS
			Return "ES"
		Case $eBldgDarkS
			Return "DS"
	EndSwitch
	If $iEnum >= 0 And $iEnum < UBound($g_sBldgNames) Then
		Local $sName = StringUpper($g_sBldgNames[$iEnum])
		If StringLen($sName) > 3 Then $sName = StringLeft($sName, 3)
		Return $sName
	EndIf
	Return "B"
EndFunc   ;==>_CSVGetBldgLabel
