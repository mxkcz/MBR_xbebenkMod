; #FUNCTION# ====================================================================================================================
; Name ..........: CreateCSVModAttackTab
; Description ...: Creates hero ability activation and deployment mode settings.
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
; Related .......:
; Link ..........:
; Example .......:
; =====================================================================================================================
Func CreateCSVModAttackTab()
	Local $x = 0, $y = 0, $w = 0, $h = 0
	CSVMod_GetContentBounds($x, $y, $w, $h)

	; Hero ability activation (shared with Attack Options)
	CreateAttackHeroAbilityGroup($x, $y, $w)
	$y += 150

	GUICtrlCreateGroup("Warden mode && Siege", $x, $y, $w, 90)
		GUICtrlCreateLabel("Battle", $x + 10, $y + 22, 60, 18)
		$g_hchkBattleWardenAttack = GUICtrlCreateCheckbox("", $x + 75, $y + 20, 18, 18)
			GUICtrlSetOnEvent(-1, "chkBattleWardenAttack")
		$g_hCmbDBWardenMode = GUICtrlCreateCombo("", $x + 100, $y + 20, 90, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "Ground mode|Air mode|Default mode", "Default mode")
		$g_hchkBattleDropEmptySiege = GUICtrlCreateCheckbox("Drop empty siege", $x + 200, $y + 20, 140, 18)
		GUICtrlCreateLabel("Ranked Battle", $x + 10, $y + 45, 90, 18)
		$g_hchkRankedBattleWardenAttack = GUICtrlCreateCheckbox("", $x + 105, $y + 43, 18, 18)
			GUICtrlSetOnEvent(-1, "chkRankedBattleWardenAttack")
		$g_hCmbABWardenMode = GUICtrlCreateCombo("", $x + 130, $y + 43, 90, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "Ground mode|Air mode|Default mode", "Default mode")
		$g_hchkRankedBattleDropEmptySiege = GUICtrlCreateCheckbox("Drop empty siege", $x + 230, $y + 43, 140, 18)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 100
	GUICtrlCreateGroup("Redline && Dropline", $x, $y, $w, $g_iSizeHGrpTab1 - $y - 10)
		Local $iRowY = $y + 20
		GUICtrlCreateLabel("Battle Redline", $x + 10, $iRowY, 110, 18)
		$g_hCmbScriptRedlineImplBattle = GUICtrlCreateCombo("", $x + 130, $iRowY - 2, 210, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "ImgLoc Raw Redline (default)|ImgLoc Redline Drop Points|Original Redline|External Edges")
			GUICtrlSetOnEvent(-1, "cmbScriptRedlineImplDB")
		$iRowY += 24
		GUICtrlCreateLabel("Battle Dropline", $x + 10, $iRowY, 110, 18)
		$g_hCmbScriptDroplineDB = GUICtrlCreateCombo("", $x + 130, $iRowY - 2, 210, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "Drop line fix outer corner|Drop line fist Redline point|Full Drop line fix outer corner|Full Drop line fist Redline point|No Drop line")
			GUICtrlSetOnEvent(-1, "cmbScriptDroplineDB")
		$iRowY += 28
		GUICtrlCreateLabel("Ranked Battle Redline", $x + 10, $iRowY, 140, 18)
		$g_hCmbScriptRedlineImplRankedBattle = GUICtrlCreateCombo("", $x + 150, $iRowY - 2, 210, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "ImgLoc Raw Redline (default)|ImgLoc Redline Drop Points|Original Redline|External Edges")
			GUICtrlSetOnEvent(-1, "cmbScriptRedlineImplAB")
		$iRowY += 24
		GUICtrlCreateLabel("Ranked Battle Dropline", $x + 10, $iRowY, 140, 18)
		$g_hCmbScriptDroplineAB = GUICtrlCreateCombo("", $x + 150, $iRowY - 2, 210, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "Drop line fix outer corner|Drop line fist Redline point|Full Drop line fix outer corner|Full Drop line fist Redline point|No Drop line")
			GUICtrlSetOnEvent(-1, "cmbScriptDroplineAB")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc   ;==>CreateCSVModAttackTab

; #FUNCTION# ====================================================================================================================
; Name ..........: CreateAttackHeroAbilityGroup
; Description ...: Creates hero ability activation controls (including Prince).
; Syntax ........:
; Parameters ....: $iGroupX - left position
;                  $iGroupY - top position
;                  $iGroupW - width of group box
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; =====================================================================================================================
Func CreateAttackHeroAbilityGroup($iGroupX, $iGroupY, $iGroupW)
	Local $sTxtTip = ""
	Local $iGroupH = 145
	Local $x = $iGroupX + 20
	Local $y = $iGroupY + 20

	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Attack", "Group_01", "Hero Abilities"), $iGroupX, $iGroupY, $iGroupW, $iGroupH)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnQueen, $x, $y, 22, 22)
	GUIStartGroup()
	$x += 30
		$g_hRadAutoQueenAbility = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Attack", "RadAutoAbilities", "Auto activate (red zone)"), $x, $y, -1, -1)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Attack", "RadAutoAbilities_Info_01", "Activate the Ability when the Hero becomes weak.") & @CRLF & _
					   GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Attack", "RadAutoAbilities_Info_02", "Heroes are checked and activated individually.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_CHECKED)
	$x += 145
		$g_hRadManQueenAbility = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Attack", "RadManAbilities", "Timed after") & ":", $x , $y , -1, -1)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Attack", "RadManAbilities_Info_01", "Activate the Ability on a timer.") & @CRLF & _
					   GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Attack", "RadManAbilities_Info_02", "All Heroes are activated at the same time.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
		$g_hTxtManQueenAbility = GUICtrlCreateInput("9", $x + 80, $y + 3, 30, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Attack", "TxtManAbilities_Info_01", "Set the time in seconds for Timed Activation of Hero Abilities.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 3)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "sec.", -1), $x + 115, $y + 4, -1, -1)
	$x += 145
		$g_hRadBothQueenAbility = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Attack", "RadBothAbilities_Info_01", "Check Both"), $x, $y, -1, -1)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Attack", "RadBothAbilities_Info_02", "Activate the Ability when Hero becomes weak or when timer runs out")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_UNCHECKED)

	$x = $iGroupX + 20
	$y += 25
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnKing, $x, $y, 22, 22)
	GUIStartGroup()
	$x += 30
		$g_hRadAutoKingAbility = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Attack", "RadAutoAbilities", "Auto activate (red zone)"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_CHECKED)
	$x += 145
		$g_hRadManKingAbility = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Attack", "RadManAbilities", "Timed after") & ":", $x , $y , -1, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
		$g_hTxtManKingAbility = GUICtrlCreateInput("9", $x + 80, $y + 3, 30, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 3)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "sec.", -1), $x + 115, $y + 4, -1, -1)
	$x += 145
		$g_hRadBothKingAbility = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Attack", "RadBothAbilities_Info_01", "Check Both"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_UNCHECKED)

	$x = $iGroupX + 20
	$y += 25
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnWarden, $x, $y , 22, 22)
	GUIStartGroup()
	$x += 30
		$g_hRadAutoWardenAbility = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Attack", "RadAutoAbilities", "Auto activate (red zone)"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_CHECKED)
	$x += 145
		$g_hRadManWardenAbility = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Attack", "RadManAbilities", "Timed after") & ":", $x , $y , -1, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
		$g_hTxtManWardenAbility = GUICtrlCreateInput("9", $x + 80, $y + 3, 30, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 3)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "sec.", -1), $x + 115, $y + 4, -1, -1)
	$x += 145
		$g_hRadBothWardenAbility = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Attack", "RadBothAbilities_Info_01", "Check Both"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_UNCHECKED)

	$x = $iGroupX + 20
	$y += 25
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnChampion, $x, $y , 22, 22)
	GUIStartGroup()
	$x += 30
		$g_hRadAutoChampionAbility = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Attack", "RadAutoAbilities", "Auto activate (red zone)"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_CHECKED)
	$x += 145
		$g_hRadManChampionAbility = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Attack", "RadManAbilities", "Timed after") & ":", $x , $y , -1, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
		$g_hTxtManChampionAbility = GUICtrlCreateInput("9", $x + 80, $y + 3, 30, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 3)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "sec.", -1), $x + 115, $y + 4, -1, -1)
	$x += 145
		$g_hRadBothChampionAbility = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Attack", "RadBothAbilities_Info_01", "Check Both"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_UNCHECKED)

	$x = $iGroupX + 20
	$y += 25
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnPrince, $x, $y , 22, 22)
	GUIStartGroup()
	$x += 30
		$g_hRadAutoPrinceAbility = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Attack", "RadAutoAbilities", "Auto activate (red zone)"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_CHECKED)
	$x += 145
		$g_hRadManPrinceAbility = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Attack", "RadManAbilities", "Timed after") & ":", $x , $y , -1, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
		$g_hTxtManPrinceAbility = GUICtrlCreateInput("9", $x + 80, $y + 3, 30, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 3)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "sec.", -1), $x + 115, $y + 4, -1, -1)
	$x += 145
		$g_hRadBothPrinceAbility = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Attack", "RadBothAbilities_Info_01", "Check Both"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_UNCHECKED)

	GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc   ;==>CreateAttackHeroAbilityGroup