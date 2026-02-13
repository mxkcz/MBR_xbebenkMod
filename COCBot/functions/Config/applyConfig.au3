; #FUNCTION# ====================================================================================================================
; Name ..........: applyConfig.au3
; Description ...: Applies all of the  variable to the GUI
; Syntax ........: applyConfig()
; Parameters ....: $bRedrawAtExit = True: redraws bot window after config was applied, $TypeReadSave = "Read" : Read GUI Values and set Variables. $TypeReadSave = "Save" : Set the GUI Settings with the Variables
; Return values .: NA
; Author ........:
; Modified ......: CodeSlinger69 (01-2017), mxkcz
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2021
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func applyConfig($bRedrawAtExit = True, $TypeReadSave = "Read") ;Applies the data from config to the controls in GUI

	Static $iApplyConfigCount = 0
	$iApplyConfigCount += 1
	If $g_bApplyConfigIsActive Then
		SetDebugLog("applyConfig(), already running, exit")
		Return
	EndIf
	$g_bApplyConfigIsActive = True
	SetDebugLog("applyConfig(), " & $TypeReadSave & ", call number " & $iApplyConfigCount)

	setMaxDegreeOfParallelism($g_iThreads)
	setProcessingPoolSize($g_iGlobalThreads)

	; Saved window positions
	If $g_bAndroidEmbedded = False Then
		If $g_iFrmBotPosX > -30000 And $g_iFrmBotPosY > -30000 And $g_bFrmBotMinimized = False _
			And $g_iFrmBotPosX <> $g_WIN_POS_DEFAULT And $g_iFrmBotPosY <> $g_WIN_POS_DEFAULT Then WinMove($g_hFrmBot, "", $g_iFrmBotPosX, $g_iFrmBotPosY)
	Else
		If $g_iFrmBotDockedPosX > -30000 And $g_iFrmBotDockedPosY > -30000 And $g_bFrmBotMinimized = False _
			And $g_iFrmBotDockedPosX <> $g_WIN_POS_DEFAULT And $g_iFrmBotDockedPosY <> $g_WIN_POS_DEFAULT Then WinMove($g_hFrmBot, "", $g_iFrmBotDockedPosX, $g_iFrmBotDockedPosY)
	EndIf

	If $g_iGuiMode <> 1 Then
		If $g_iGuiMode = 2 Then ; mini mode controls
			Switch $TypeReadSave
                Case "Read"
                    GUICtrlSetState($g_hChkBackgroundMode, $g_bChkBackgroundMode = True ? $GUI_CHECKED : $GUI_UNCHECKED)
				Case "Save"
					$g_bChkBackgroundMode = (GUICtrlRead($g_hChkBackgroundMode) = $GUI_CHECKED)
			EndSwitch
		EndIf
		UpdateBotTitle()
		$g_bApplyConfigIsActive = False
		Return
	EndIf

	; Move with redraw disabled causes ghost window in VMWare, so move first then disable redraw
	Local $bWasRdraw = SetRedrawBotWindow(False, Default, Default, Default, "applyConfig")
	; <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

	; <><><><> Bot / Profile (global settings) <><><><>
	ApplyConfig_Profile($TypeReadSave)
	; <><><><> Bot / Android <><><><>
	ApplyConfig_Android($TypeReadSave)
	; <><><><> Log window <><><><>
	ApplyConfig_600_1($TypeReadSave)
	; <><><><> Village / Misc <><><><>
	ApplyConfig_600_6($TypeReadSave)
	; <><><><> Village / Achievements <><><><>
	ApplyConfig_600_9($TypeReadSave)
	; <><><><> Village / Donate - Request <><><><>
	ApplyConfig_600_11($TypeReadSave)
	; <><><><> Village / Donate - Donate <><><><>
	ApplyConfig_600_12($TypeReadSave)
	; <><><><> Village / Upgrade - Lab <><><><>
	ApplyConfig_600_14($TypeReadSave)
	; <><><><> Village / Upgrade - Heroes <><><><>
	ApplyConfig_600_15($TypeReadSave)
	; <><><><> Village / Upgrade - Buildings <><><><>
	ApplyConfig_600_16($TypeReadSave)
	; <><><><> Village / Upgrade - Auto Upgrade <><><><>
	ApplyConfig_auto($TypeReadSave)
	; <><><><> Village / Upgrade - Walls <><><><>
	ApplyConfig_600_17($TypeReadSave)
	; <><><><> Village / Notify <><><><>
	ApplyConfig_600_18($TypeReadSave)

	; moved here due to check functions
	; troop/spell levels and counts
	;~ ApplyConfig_600_52_2($TypeReadSave)

	; <><><><> Village / Notify <><><><>
	ApplyConfig_600_19($TypeReadSave)
	; <><><><> CSV Mod / Search settings <><><><>
	ApplyConfig_CSVMod_Search_Battle($TypeReadSave)
	ApplyConfig_CSVMod_Search_Ranked($TypeReadSave)
	;~ ; <><><><> Attack Plan / Search & Attack / Bully <><><><>
	;~ ApplyConfig_600_26($TypeReadSave)
	;~ ; <><><><> Attack Plan / Search & Attack / Options / Search <><><><>
	;~ ApplyConfig_600_28($TypeReadSave)
	;~ ; <><><><> Attack Plan / Search & Attack / Options / Attack <><><><>
	;~ ApplyConfig_600_29($TypeReadSave)
	;~ ; <><><><> Attack Plan / Search & Attack / Deadbase / Attack <><><><>
	;~ ApplyConfig_600_29_DB($TypeReadSave)
	;~ ; <><><><> Attack Plan / Search & Attack / Activebase / Attack <><><><>
	;~ ApplyConfig_600_29_LB($TypeReadSave)
	;~ ; <><><><> Attack Plan / Search & Attack / Options / End Battle <><><><>
	;~ ApplyConfig_600_30($TypeReadSave)
	;~ ; <><><><> Attack Plan / Search & Attack / Deadbase / End Battle <><><><>
	;~ ApplyConfig_600_30_DB($TypeReadSave)
	;~ ; <><><><> Attack Plan / Search & Attack / Activebase / End Battle <><><><>
	;~ ApplyConfig_600_30_LB($TypeReadSave)
	;~ ; <><><><> Attack Plan / Search & Attack / Deadbase / Collectors <><><><>
	;~ ApplyConfig_600_31($TypeReadSave)
	;~ ; <><><><> Attack Plan / Search & Attack / Drop Order Troops <><><><>
	;~ ApplyConfig_600_33($TypeReadSave)
	; <><><><> Bot / Options <><><><>
	ApplyConfig_600_35_1($TypeReadSave)
	; <><><><> Bot / Profile / Switch Account <><><><>
	ApplyConfig_600_35_2($TypeReadSave)
	;~ ; <><><> Attack Plan / Train Army / Train Order <><><>
	;~ ApplyConfig_600_54($TypeReadSave)
	;~ ; <><><><> Attack Plan / Search & Attack / Options / SmartZap <><><><>
	;~ ApplyConfig_600_56($TypeReadSave)
	;~ ; <><><> Attack Plan / Train Army / Options <><><>
	;~ ApplyConfig_641_1($TypeReadSave)

	; <><><><> BuilderBase <><><><>
	ApplyBuilderBaseMod($TypeReadSave)

	; <><><><> Bot / Profiles <><><><>
	;~ PopulatePresetComboBox()
	;~ MakeSavePresetMessage()
	;~ GUICtrlSetState($g_hLblLoadPresetMessage, $GUI_SHOW)
	;~ GUICtrlSetState($g_hTxtPresetMessage, $GUI_HIDE)
	;~ GUICtrlSetState($g_hBtnGUIPresetLoadConf, $GUI_HIDE)
	;~ GUICtrlSetState($g_hBtnGUIPresetDeleteConf, $GUI_HIDE + $GUI_DISABLE)
	;~ GUICtrlSetState($g_hChkDeleteConf, $GUI_HIDE + $GUI_UNCHECKED)
	;~ GUICtrlSetState($g_hChkDeleteConf, $GUI_HIDE)

	; <><><><> Bot / Stats <><><><>
	; <<< nothing here >>>

	; <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


	ApplyConfig_Debug($TypeReadSave)

	; Reenabling window redraw - Keep this last....
	If $bRedrawAtExit Then SetRedrawBotWindow($bWasRdraw, Default, Default, Default, "applyConfig")

	$g_bApplyConfigIsActive = False
EndFunc   ;==>applyConfig

Func ApplyConfig_Profile($TypeReadSave)
	; <><><><> Bot / Processor/Threads Advanced <><><><>
	Switch $TypeReadSave
		Case "Read"
			GUICtrlSetData($g_hTxtGlobalActiveBotsAllowed, $g_iGlobalActiveBotsAllowed)
			GUICtrlSetData($g_hTxtGlobalThreads, $g_iGlobalThreads)
		Case "Save"
			$g_iGlobalActiveBotsAllowed = Int(GUICtrlRead($g_hTxtGlobalActiveBotsAllowed))
			If $g_iGlobalActiveBotsAllowed < 1 Then
				$g_iGlobalActiveBotsAllowed = 1 ; ensure that at least one bot can run
			EndIf
			$g_iGlobalThreads = Int(GUICtrlRead($g_hTxtGlobalThreads))
	EndSwitch
EndFunc   ;==>ApplyConfig_Profile

Func ApplyConfig_Android($TypeReadSave)
	; <><><><> Bot / Android <><><><>
	Switch $TypeReadSave
		Case "Read"
			SetCurSelCmbCOCDistributors()
			sldAdditionalClickDelay(True)
			UpdateBotTitle()
			_GUICtrlComboBox_SetCurSel($g_hCmbAndroidBackgroundMode, $g_iAndroidBackgroundMode)
			_GUICtrlComboBox_SetCurSel($g_hCmbAndroidZoomoutMode, $g_iAndroidZoomoutMode)
			_GUICtrlComboBox_SetCurSel($g_hCmbAndroidReplaceAdb, $g_iAndroidAdbReplace)
			GUICtrlSetState($g_hChkAndroidAdbClickDragScript, $g_bAndroidAdbClickDragScript ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkAndroidCloseWithBot, $g_bAndroidCloseWithBot ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkUseDedicatedAdbPort, $g_bAndroidAdbPortPerInstance ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkUpdateSharedPrefs, $g_bUpdateSharedPrefs ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($g_hTxtAndroidRebootHours, $g_iAndroidRebootHours)
			_GUICtrlComboBox_SetCurSel($g_hCmbSuspendAndroid, AndroidSuspendFlagsToIndex($g_iAndroidSuspendModeFlags))
		Case "Save"
			cmbCOCDistributors()
			sldAdditionalClickDelay()
			cmbAndroidBackgroundMode()
			$g_iAndroidZoomoutMode = _GUICtrlComboBox_GetCurSel($g_hCmbAndroidZoomoutMode)
			$g_iAndroidAdbReplace = _GUICtrlComboBox_GetCurSel($g_hCmbAndroidReplaceAdb)
			$g_bAndroidAdbClickEnabled = (GUICtrlRead($g_hChkAndroidAdbClick) = $GUI_CHECKED ? True : False)
			$g_bAndroidAdbClick = $g_bAndroidAdbClickEnabled ; also update $g_bAndroidAdbClick as that one is actually used
			$g_bAndroidAdbClickDragScript = (GUICtrlRead($g_hChkAndroidAdbClickDragScript) = $GUI_CHECKED ? True : False)
			$g_bAndroidCloseWithBot = (GUICtrlRead($g_hChkAndroidCloseWithBot) = $GUI_CHECKED ? True : False)
			$g_bAndroidAdbPortPerInstance = (GUICtrlRead($g_hChkUseDedicatedAdbPort) = $GUI_CHECKED ? True : False)
			$g_bUpdateSharedPrefs = (GUICtrlRead($g_hChkUpdateSharedPrefs) = $GUI_CHECKED ? True : False)
			$g_iAndroidRebootHours = Int(GUICtrlRead($g_hTxtAndroidRebootHours)) ; Hours are entered
			cmbSuspendAndroid()
	EndSwitch
EndFunc   ;==>ApplyConfig_Android

Func ApplyConfig_Debug($TypeReadSave)
	; <><><><> Bot / Debug <><><><>
	Switch $TypeReadSave
		Case "Read"
			GUICtrlSetState($g_hChkDebugSetlog, $g_bDebugSetlog ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkDebugAndroid, $g_bDebugAndroid ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkDebugClick, $g_bDebugClick ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkDebugFunc, ($g_bDebugFuncTime And $g_bDebugFuncCall) ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkDebugDisableZoomout, $g_bDebugDisableZoomout ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkDebugDeadbaseImage, $g_bDebugDeadBaseImage ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkDebugOCR, $g_bDebugOcr ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkDebugImageSave, $g_bDebugImageSave ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkdebugBuildingPos, $g_bDebugBuildingPos ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkdebugTrain, $g_bDebugSetlogTrain ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkDebugOCRDonate, $g_bDebugOCRdonate ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkdebugAttackCSV, $g_bDebugAttackCSV ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkMakeIMGCSV, $g_bDebugMakeIMGCSV ? $GUI_CHECKED : $GUI_UNCHECKED)
			If $g_bDevMode Then
				GUICtrlSetState($g_hChkDebugFunc, $GUI_ENABLE)
				GUICtrlSetState($g_hChkDebugDisableZoomout, $GUI_ENABLE)
				GUICtrlSetState($g_hChkDebugDeadbaseImage, $GUI_ENABLE)
				GUICtrlSetState($g_hChkDebugOCR, $GUI_ENABLE)
				GUICtrlSetState($g_hChkDebugImageSave, $GUI_ENABLE)
				GUICtrlSetState($g_hChkdebugBuildingPos, $GUI_ENABLE)
				GUICtrlSetState($g_hChkdebugTrain, $GUI_ENABLE)
				GUICtrlSetState($g_hChkDebugOCRDonate, $GUI_ENABLE)
				GUICtrlSetState($g_hChkdebugAttackCSV, $GUI_ENABLE)
				GUICtrlSetState($g_hChkMakeIMGCSV, $GUI_ENABLE)
			EndIf
		Case "Save"
			$g_bDebugSetlog = (GUICtrlRead($g_hChkDebugSetlog) = $GUI_CHECKED)
			$g_bDebugAndroid = (GUICtrlRead($g_hChkDebugAndroid) = $GUI_CHECKED)
			$g_bDebugClick = (GUICtrlRead($g_hChkDebugClick) = $GUI_CHECKED)
			If $g_bDevMode Then
				Local $bDebugFunc = (GUICtrlRead($g_hChkDebugFunc) = $GUI_CHECKED)
				$g_bDebugFuncTime = $bDebugFunc
				$g_bDebugFuncCall = $bDebugFunc
				$g_bDebugDisableZoomout = (GUICtrlRead($g_hChkDebugDisableZoomout) = $GUI_CHECKED)
				$g_bDebugDeadBaseImage = (GUICtrlRead($g_hChkDebugDeadbaseImage) = $GUI_CHECKED)
				$g_bDebugOcr = (GUICtrlRead($g_hChkDebugOCR) = $GUI_CHECKED)
				$g_bDebugImageSave = (GUICtrlRead($g_hChkDebugImageSave) = $GUI_CHECKED)
				$g_bDebugBuildingPos = (GUICtrlRead($g_hChkdebugBuildingPos) = $GUI_CHECKED)
				$g_bDebugSetlogTrain = (GUICtrlRead($g_hChkdebugTrain) = $GUI_CHECKED)
				$g_bDebugOCRdonate = (GUICtrlRead($g_hChkDebugOCRDonate) = $GUI_CHECKED)
				$g_bDebugAttackCSV = (GUICtrlRead($g_hChkdebugAttackCSV) = $GUI_CHECKED)
				$g_bDebugMakeIMGCSV = (GUICtrlRead($g_hChkMakeIMGCSV) = $GUI_CHECKED)
				;~ $g_bDebugSmartZap = (GUICtrlRead($g_hChkDebugSmartZap) = $GUI_CHECKED)
			EndIf
	EndSwitch
EndFunc   ;==>ApplyConfig_Debug

Func ApplyConfig_600_1($TypeReadSave)
	; <><><><> Log window <><><><>
	Switch $TypeReadSave
		Case "Read"
			_GUICtrlComboBox_SetCurSel($g_hCmbLogDividerOption, $g_iCmbLogDividerOption)
			cmbLog()
			; <><><><> Bottom panel <><><><>
			GUICtrlSetState($g_hChkBackgroundMode, $g_bChkBackgroundMode = True ? $GUI_CHECKED : $GUI_UNCHECKED)
			UpdateChkBackground() ;Applies it to hidden button
		Case "Save"
			$g_iCmbLogDividerOption = _GUICtrlComboBox_GetCurSel($g_hCmbLogDividerOption)
			; <><><><> Bottom panel <><><><>
			$g_bChkBackgroundMode = (GUICtrlRead($g_hChkBackgroundMode) = $GUI_CHECKED)
	EndSwitch
EndFunc   ;==>ApplyConfig_600_1

Func ApplyConfig_600_6($TypeReadSave)
	; <><><><> Village / Misc <><><><>
	Switch $TypeReadSave
		Case "Read"
			GUICtrlSetState($g_hChkBotStop, $g_bChkBotStop ? $GUI_CHECKED : $GUI_UNCHECKED)
			_GUICtrlComboBox_SetCurSel($g_hCmbBotCommand, $g_iCmbBotCommand)
			_GUICtrlComboBox_SetCurSel($g_hCmbBotCond, $g_iCmbBotCond)
			_GUICtrlComboBox_SetCurSel($g_hCmbHoursStop, $g_iCmbHoursStop)
			For $i = 0 To $eLootCount - 1
				If $g_ahTxtResumeAttackLoot[$i] <> 0 Then GUICtrlSetData($g_ahTxtResumeAttackLoot[$i], $g_aiResumeAttackLoot[$i])
			Next
			GUICtrlSetState($g_hChkCollectStarBonus, $g_bCollectStarBonus ? $GUI_CHECKED : $GUI_UNCHECKED)
			_GUICtrlComboBox_SetCurSel($g_hCmbTimeStop, $g_iCmbTimeStop)
			_GUICtrlComboBox_SetCurSel($g_hCmbResumeTime, $g_iResumeAttackTime)
			chkBotStop()

			GUICtrlSetState($g_hChkCollect, $g_bChkCollect ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkCollectLootCart, $g_bChkCollectLootCart ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkTreasuryCollect, $g_bChkTreasuryCollect ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkCollectCookie, $g_bChkCollectCookie ? $GUI_CHECKED : $GUI_UNCHECKED)
			
			GUICtrlSetState($g_hChkTombstones, $g_bChkTombstones ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkCleanYard, $g_bChkCleanYard ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkGemsBox, $g_bChkGemsBox ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkCollectAchievements, $g_bChkCollectAchievements ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkCollectFreeMagicItems, $g_bChkCollectFreeMagicItems ? $GUI_CHECKED : $GUI_UNCHECKED)
			ChkFreeMagicItems()
			GUICtrlSetState($g_hChkCollectRewards, $g_bChkCollectRewards ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkSellRewards, $g_bChkSellRewards ? $GUI_CHECKED : $GUI_UNCHECKED)

			;Sell Magic Items
			GUICtrlSetState($g_hChkEnableSellMagicItem, $g_bChkEnableSellMagicItem ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkSellBOF, $g_bChkSellBOF ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkSellBOB, $g_bChkSellBOB ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkSellBOS, $g_bChkSellBOS ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkSellBOH, $g_bChkSellBOH ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkSellBOE, $g_bChkSellBOE ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkSellShovel, $g_bChkSellShovel ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkSellWallRing, $g_bChkSellWallRing ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkSellPowerPot, $g_bChkSellPowerPot ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkSellResourcePot, $g_bChkSellResourcePot ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkSellTrainingPot, $g_bChkSellTrainingPot ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkSellBuilderPot, $g_bChkSellBuilderPot ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkSellCTPot, $g_bChkSellCTPot ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkSellHeroPot, $g_bChkSellHeroPot ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkSellResearchPot, $g_bChkSellResearchPot ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkSellSuperPot, $g_bChkSellSuperPot ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkSellBuilderJar, $g_bChkSellBuilderJar ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkSellROG, $g_bChkSellROG ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkSellROE, $g_bChkSellROE ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkSellRODE, $g_bChkSellRODE ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkSellROBG, $g_bChkSellROBG ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkSellROBE, $g_bChkSellROBE ? $GUI_CHECKED : $GUI_UNCHECKED)
			chkEnableSellMagicItem()

			;BBPlay > Collect
			GUICtrlSetState($g_hChkCollectBuilderBase, $g_bChkCollectBuilderBase ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkCleanBBYard, $g_bChkCleanBBYard ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkStartClockTowerBoost, $g_bChkStartClockTowerBoost ? $GUI_CHECKED : $GUI_UNCHECKED)
			;BBPlay > AutoUpgrade
			GUICtrlSetState($g_hChkAutoUpgradeBB, $g_bAutoUpgradeBBEnabled? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkAutoUpgradeBBIgnoreHall, $g_bChkAutoUpgradeBBIgnoreHall ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkAutoUpgradeBBIgnoreWall, $g_bChkAutoUpgradeBBIgnoreWall ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkBOBControl, $g_bChkBOBControl ? $GUI_CHECKED : $GUI_UNCHECKED)
			chkActivateBBSuggestedUpgrades()

			#NEW CLANGAMES GUI
			GUICtrlSetState($g_hChkClanGamesEnabled, $g_bChkClanGamesEnabled ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkClanGames3H, $g_bChkClanGames3H ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkClanGamesDebug, $g_bChkClanGamesDebug ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkCollectCGReward, $g_bCollectCGReward ? $GUI_CHECKED : $GUI_UNCHECKED)

			GUICtrlSetState($g_hChkCGMainLoot, $g_bChkClanGamesLoot ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkCGMainBattle, $g_bChkClanGamesBattle ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkCGMainDestruction, $g_bChkClanGamesDes ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkCGMainAir, $g_bChkClanGamesAirTroop ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkCGMainGround, $g_bChkClanGamesGroundTroop ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkCGMainMisc, $g_bChkClanGamesMiscellaneous ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkCGMainSpell, $g_bChkClanGamesSpell ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkCGBBBattle, $g_bChkClanGamesBBBattle ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkCGBBDestruction, $g_bChkClanGamesBBDes ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkCGBBTroops, $g_bChkClanGamesBBTroops ? $GUI_CHECKED : $GUI_UNCHECKED)

			GUICtrlSetState($g_hChkForceBBAttackOnClanGames, $g_bChkForceBBAttackOnClanGames ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkClanGamesPurgeAny, $g_bChkClanGamesPurgeAny ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkClanGamesStopBeforeReachAndPurge, $g_bChkClanGamesStopBeforeReachAndPurge ? $GUI_CHECKED : $GUI_UNCHECKED)
			_GUICtrlComboBox_SetCurSel($g_hCmbClanGamesPurgeDay, $g_iCmbClanGamesPurgeDay)
			GUICtrlSetState($g_hChkClanGamesSort, $g_bSortClanGames ? $GUI_CHECKED : $GUI_UNCHECKED)
			_GUICtrlComboBox_SetCurSel($g_hCmbClanGamesSort, $g_iSortClanGames)
			GUICtrlSetState($g_hChkCGBBAttackOnly, $g_bChkCGBBAttackOnly ? $GUI_CHECKED : $GUI_UNCHECKED)

			For $i = 0 To UBound($g_ahCGMainLootItem) - 1
				GUICtrlSetState($g_ahCGMainLootItem[$i], $g_abCGMainLootItem[$i] = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			Next
			For $i = 0 To UBound($g_ahCGMainBattleItem) - 1
				GUICtrlSetState($g_ahCGMainBattleItem[$i], $g_abCGMainBattleItem[$i] = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			Next
			For $i = 0 To UBound($g_ahCGMainDestructionItem) - 1
				GUICtrlSetState($g_ahCGMainDestructionItem[$i], $g_abCGMainDestructionItem[$i] = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			Next
			For $i = 0 To UBound($g_ahCGMainAirItem) - 1
				GUICtrlSetState($g_ahCGMainAirItem[$i], $g_abCGMainAirItem[$i] = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			Next
			For $i = 0 To UBound($g_ahCGMainGroundItem) - 1
				GUICtrlSetState($g_ahCGMainGroundItem[$i], $g_abCGMainGroundItem[$i] = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			Next
			For $i = 0 To UBound($g_ahCGMainMiscItem) - 1
				GUICtrlSetState($g_ahCGMainMiscItem[$i], $g_abCGMainMiscItem[$i] = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			Next
			For $i = 0 To UBound($g_ahCGMainSpellItem) - 1
				GUICtrlSetState($g_ahCGMainSpellItem[$i], $g_abCGMainSpellItem[$i] = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			Next
			For $i = 0 To UBound($g_ahCGBBBattleItem) - 1
				GUICtrlSetState($g_ahCGBBBattleItem[$i], $g_abCGBBBattleItem[$i] = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			Next
			For $i = 0 To UBound($g_ahCGBBDestructionItem) - 1
				GUICtrlSetState($g_ahCGBBDestructionItem[$i], $g_abCGBBDestructionItem[$i] = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			Next
			For $i = 0 To UBound($g_ahCGBBTroopsItem) - 1
				GUICtrlSetState($g_ahCGBBTroopsItem[$i], $g_abCGBBTroopsItem[$i] = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			Next

			chkActivateClangames()

			; Builder Base Attack
			GUICtrlSetState($g_hChkEnableBBAttack, $g_bChkEnableBBAttack ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkBBDropTrophy, $g_bChkBBDropTrophy ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkStopAttackBB6thBuilder, $g_bChkStopAttackBB6thBuilder ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkBBEndBattleOn2Stars, $g_bChkBBEndBattleOn2Stars ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkSkipBBRoutineOn6thBuilder, $g_bChkSkipBBRoutineOn6thBuilder ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($g_hTxtBBTrophyLowerLimit, $g_iTxtBBTrophyLowerLimit)
			GUICtrlSetState($g_hChkBBAttIfStarsAvail, $g_bChkBBAttIfStarsAvail ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkSkipBBAttIfStorageFull, $g_bChkSkipBBAttIfStorageFull ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkBBWaitForMachine, $g_bChkBBWaitForMachine ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkBBDropBMFirst, $g_bChkBBDropBMFirst ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkDebugAttackBB, $g_bChkDebugAttackBB ? $GUI_CHECKED : $GUI_UNCHECKED)
			_GUICtrlComboBox_SetCurSel($g_hCmbBBSameTroopDelay, $g_iBBSameTroopDelay + 1)
			_GUICtrlComboBox_SetCurSel($g_hCmbBBNextTroopDelay, $g_iBBNextTroopDelay + 1)
			_GUICtrlComboBox_SetCurSel($g_hCmbBBAttackCount, $g_iBBAttackCount)
			chkEnableBBAttack()
			chkBBDropTrophy()

			; Builder Base Drop Order
			If $g_bBBDropOrderSet Then
				GUICtrlSetState($g_hChkBBCustomDropOrderEnable, $GUI_CHECKED)
				GUICtrlSetState($g_hBtnBBDropOrderSet, $GUI_ENABLE)
				GUICtrlSetState($g_hBtnBBRemoveDropOrder, $GUI_ENABLE)
				Local $asBBDropOrder = StringSplit($g_sBBDropOrder, "|")
				If UBound($asBBDropOrder) <> $g_iBBTroopCount + 1 Then
					$g_sBBDropOrder = $g_sBBDropOrderDefault
					$asBBDropOrder = StringSplit($g_sBBDropOrderDefault, "|")
					Setlog("Update BBDropOrder List", $COLOR_DEBUG)
					Setlog(_ArrayToString($asBBDropOrder), $COLOR_DEBUG)
				EndIf
				For $i=0 To $g_iBBTroopCount - 1
					_GUICtrlComboBox_SetCurSel($g_ahCmbBBDropOrder[$i], _GUICtrlComboBox_SelectString($g_ahCmbBBDropOrder[$i], $asBBDropOrder[$i+1]))
				Next
				GUICtrlSetBkColor($g_hBtnBBDropOrder, $COLOR_GREEN)
			EndIf

			;ClanCapital
			GUICtrlSetState($g_hChkEnableCollectCCGold, $g_bChkEnableCollectCCGold ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkStartWeekendRaid, $g_bChkStartWeekendRaid ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkEnableForgeGold, $g_bChkEnableForgeGold ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkEnableForgeElix, $g_bChkEnableForgeElix ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkEnableForgeDE, $g_bChkEnableForgeDE ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkEnableForgeBBGold, $g_bChkEnableForgeBBGold ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkEnableForgeBBElix, $g_bChkEnableForgeBBElix ? $GUI_CHECKED : $GUI_UNCHECKED)
			_GUICtrlComboBox_SetCurSel($g_hCmbForgeBuilder, $g_iCmbForgeBuilder)
			GUICtrlSetState($g_hChkEnableAutoUpgradeCC, $g_bChkEnableAutoUpgradeCC ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkEnableMinGoldAUCC, $g_bChkEnableMinGoldAUCC ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($g_hTxtMinCCGoldToUpgrade, $g_iMinCCGoldToUpgrade)
			GUICtrlSetState($g_hChkAutoUpgradeCCIgnore, $g_bChkAutoUpgradeCCIgnore ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkAutoUpgradeCCWallIgnore, $g_bChkAutoUpgradeCCWallIgnore ? $GUI_CHECKED : $GUI_UNCHECKED)

			;Misc Mod
			GUICtrlSetState($g_hChkMMSkipFirstCheckRoutine, $g_bSkipFirstCheckRoutine ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkMMSkipBB, $g_bSkipBB ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkMMIgnoreIncorrectTroopCombo, $g_bIgnoreIncorrectTroopCombo ? $GUI_CHECKED : $GUI_UNCHECKED)
			_GUICtrlComboBox_SetCurSel($g_hCmbFillIncorrectTroopCombo, $g_iCmbFillIncorrectTroopCombo)
			GUICtrlSetState($g_hChkMMIgnoreIncorrectSpellCombo, $g_bIgnoreIncorrectSpellCombo ? $GUI_CHECKED : $GUI_UNCHECKED)
			_GUICtrlComboBox_SetCurSel($g_hCmbFillIncorrectSpellCombo, $g_iCmbFillIncorrectSpellCombo)
			GUICtrlSetState($g_hChkMMSkipWallPlacingOnBB, $g_bSkipWallPlacingOnBB ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hDonateEarly, $g_bDonateEarly ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hAutoUpgradeEarly, $g_bAutoUpgradeEarly ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkForceSwitchifNoCGEvent, $g_bChkForceSwitchifNoCGEvent ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkEnableCCSleep, $g_bEnableCCSleep ? $GUI_CHECKED : $GUI_UNCHECKED)

		Case "Save"
			$g_bChkBotStop = (GUICtrlRead($g_hChkBotStop) = $GUI_CHECKED)
			$g_iCmbBotCommand = _GUICtrlComboBox_GetCurSel($g_hCmbBotCommand)
			$g_iCmbBotCond = _GUICtrlComboBox_GetCurSel($g_hCmbBotCond)
			$g_iCmbHoursStop = _GUICtrlComboBox_GetCurSel($g_hCmbHoursStop)
			For $i = 0 To $eLootCount - 1
				If $g_ahTxtResumeAttackLoot[$i] <> 0 Then $g_aiResumeAttackLoot[$i] = GUICtrlRead($g_ahTxtResumeAttackLoot[$i])
			Next
			$g_bCollectStarBonus = (GUICtrlRead($g_hChkCollectStarBonus) = $GUI_CHECKED)
			$g_iCmbTimeStop = _GUICtrlComboBox_GetCurSel($g_hCmbTimeStop)
			$g_iResumeAttackTime = _GUICtrlComboBox_GetCurSel($g_hCmbResumeTime)
			$g_bChkCollect = (GUICtrlRead($g_hChkCollect) = $GUI_CHECKED)
			$g_bChkCollectLootCart = (GUICtrlRead($g_hChkCollectLootCart) = $GUI_CHECKED)
			$g_bChkTreasuryCollect = (GUICtrlRead($g_hChkTreasuryCollect) = $GUI_CHECKED)
			$g_bChkCollectCookie = (GUICtrlRead($g_hChkCollectCookie) = $GUI_CHECKED)
			$g_bChkTombstones = (GUICtrlRead($g_hChkTombstones) = $GUI_CHECKED)
			$g_bChkCleanYard = (GUICtrlRead($g_hChkCleanYard) = $GUI_CHECKED)
			$g_bChkEnableSellMagicItem = (GUICtrlRead($g_hChkEnableSellMagicItem) = $GUI_CHECKED)
			$g_bChkCollectAchievements = (GUICtrlRead($g_hChkCollectAchievements) = $GUI_CHECKED)
			$g_bChkCollectFreeMagicItems = (GUICtrlRead($g_hChkCollectFreeMagicItems) = $GUI_CHECKED)
			$g_bChkGemsBox = (GUICtrlRead($g_hChkGemsBox) = $GUI_CHECKED)
			$g_bChkCollectRewards = (GUICtrlRead($g_hChkCollectRewards) = $GUI_CHECKED)
			$g_bChkSellRewards = (GUICtrlRead($g_hChkSellRewards) = $GUI_CHECKED)

			;Sell Magic Items
			$g_bChkSellBOF = ((GUICtrlRead($g_hChkSellBOF) = $GUI_CHECKED))
			$g_bChkSellBOB = (GUICtrlRead($g_hChkSellBOB) = $GUI_CHECKED)
			$g_bChkSellBOS = (GUICtrlRead($g_hChkSellBOS) = $GUI_CHECKED)
			$g_bChkSellBOH = (GUICtrlRead($g_hChkSellBOH) = $GUI_CHECKED)
			$g_bChkSellBOE = (GUICtrlRead($g_hChkSellBOE) = $GUI_CHECKED)
			$g_bChkSellShovel = (GUICtrlRead($g_hChkSellShovel) = $GUI_CHECKED)
			$g_bChkSellWallRing = (GUICtrlRead($g_hChkSellWallRing) = $GUI_CHECKED)
			$g_bChkSellPowerPot = (GUICtrlRead($g_hChkSellPowerPot) = $GUI_CHECKED)
			$g_bChkSellResourcePot = (GUICtrlRead($g_hChkSellResourcePot) = $GUI_CHECKED)
			$g_bChkSellTrainingPot = (GUICtrlRead($g_hChkSellTrainingPot) = $GUI_CHECKED)
			$g_bChkSellBuilderPot = (GUICtrlRead($g_hChkSellBuilderPot) = $GUI_CHECKED)
			$g_bChkSellCTPot = (GUICtrlRead($g_hChkSellCTPot) = $GUI_CHECKED)
			$g_bChkSellHeroPot = (GUICtrlRead($g_hChkSellHeroPot) = $GUI_CHECKED)
			$g_bChkSellResearchPot = (GUICtrlRead($g_hChkSellResearchPot) = $GUI_CHECKED)
			$g_bChkSellSuperPot = (GUICtrlRead($g_hChkSellSuperPot) = $GUI_CHECKED)
			$g_hChkSellBuilderJar = (GUICtrlRead($g_bChkSellBuilderJar) = $GUI_CHECKED)
			$g_bChkSellROG = (GUICtrlRead($g_hChkSellROG) = $GUI_CHECKED)
			$g_bChkSellROE = (GUICtrlRead($g_hChkSellROE) = $GUI_CHECKED)
			$g_bChkSellRODE = (GUICtrlRead($g_hChkSellRODE) = $GUI_CHECKED)
			$g_bChkSellROBG = (GUICtrlRead($g_hChkSellROBG) = $GUI_CHECKED)
			$g_bChkSellROBE = (GUICtrlRead($g_hChkSellROBE) = $GUI_CHECKED)
			chkEnableSellMagicItem()

			$g_bChkCollectBuilderBase = (GUICtrlRead($g_hChkCollectBuilderBase) = $GUI_CHECKED)
			$g_bChkCleanBBYard = (GUICtrlRead($g_hChkCleanBBYard) = $GUI_CHECKED)
			$g_bChkStartClockTowerBoost = (GUICtrlRead($g_hChkStartClockTowerBoost) = $GUI_CHECKED)
			$g_bAutoUpgradeBBEnabled= (GUICtrlRead($g_hChkAutoUpgradeBB) = $GUI_CHECKED)
			$g_bChkAutoUpgradeBBIgnoreHall = (GUICtrlRead($g_hChkAutoUpgradeBBIgnoreHall) = $GUI_CHECKED)
			$g_bChkAutoUpgradeBBIgnoreWall = (GUICtrlRead($g_hChkAutoUpgradeBBIgnoreWall) = $GUI_CHECKED)
			$g_bChkBOBControl = (GUICtrlRead($g_hChkBOBControl) = $GUI_CHECKED)

			#NEW CLANGAMES GUI
			$g_bChkClanGamesEnabled = (GUICtrlRead($g_hChkClanGamesEnabled) = $GUI_CHECKED) ? 1 : 0
			$g_bChkClanGames3H = (GUICtrlRead($g_hChkClanGames3H) = $GUI_CHECKED) ? 1 : 0
			$g_bChkClanGamesDebug = (GUICtrlRead($g_hChkClanGamesDebug) = $GUI_CHECKED) ? 1 : 0
			$g_bCollectCGReward = (GUICtrlRead($g_hChkCollectCGReward) = $GUI_CHECKED) ? 1 : 0

			$g_bChkClanGamesLoot = BitAND(GUICtrlRead($g_hChkCGMainLoot), $GUI_CHECKED) ? 1 : 0
			$g_bChkClanGamesBattle = BitAND(GUICtrlRead($g_hChkCGMainBattle), $GUI_CHECKED) ? 1 : 0
			$g_bChkClanGamesDes = BitAND(GUICtrlRead($g_hChkCGMainDestruction), $GUI_CHECKED) ? 1 : 0
			$g_bChkClanGamesAirTroop = BitAND(GUICtrlRead($g_hChkCGMainAir), $GUI_CHECKED) ? 1 : 0
			$g_bChkClanGamesGroundTroop = BitAND(GUICtrlRead($g_hChkCGMainGround), $GUI_CHECKED) ? 1 : 0
			$g_bChkClanGamesMiscellaneous = BitAND(GUICtrlRead($g_hChkCGMainMisc), $GUI_CHECKED) ? 1 : 0
			$g_bChkClanGamesSpell = BitAND(GUICtrlRead($g_hChkCGMainSpell), $GUI_CHECKED) ? 1 : 0
			$g_bChkClanGamesBBBattle = BitAND(GUICtrlRead($g_hChkCGBBBattle), $GUI_CHECKED) ? 1 : 0
			$g_bChkClanGamesBBDes = BitAND(GUICtrlRead($g_hChkCGBBDestruction), $GUI_CHECKED) ? 1 : 0
			$g_bChkClanGamesBBTroops = BitAND(GUICtrlRead($g_hChkCGBBTroops), $GUI_CHECKED) ? 1 : 0

			$g_bChkForceBBAttackOnClanGames = (GUICtrlRead($g_hChkForceBBAttackOnClanGames) = $GUI_CHECKED) ? 1 : 0
			$g_bChkClanGamesPurgeAny = (GUICtrlRead($g_hChkClanGamesPurgeAny) = $GUI_CHECKED) ? 1 : 0
			$g_bChkClanGamesStopBeforeReachAndPurge = (GUICtrlRead($g_hChkClanGamesStopBeforeReachAndPurge) = $GUI_CHECKED) ? 1 : 0
			$g_iCmbClanGamesPurgeDay = _GUICtrlComboBox_GetCurSel($g_hCmbClanGamesPurgeDay)
			$g_bSortClanGames = (GUICtrlRead($g_hChkClanGamesSort) = $GUI_CHECKED) ? 1 : 0
			$g_iSortClanGames = _GUICtrlComboBox_GetCurSel($g_hCmbClanGamesSort)
			$g_bChkCGBBAttackOnly = (GUICtrlRead($g_hChkCGBBAttackOnly) = $GUI_CHECKED) ? 1 : 0

			For $i = 0 To UBound($g_ahCGMainLootItem) - 1
				$g_abCGMainLootItem[$i] = BitAND(GUICtrlRead($g_ahCGMainLootItem[$i]), $GUI_CHECKED) ? 1 : 0
			Next
			For $i = 0 To UBound($g_ahCGMainBattleItem) - 1
				$g_abCGMainBattleItem[$i] = BitAND(GUICtrlRead($g_ahCGMainBattleItem[$i]), $GUI_CHECKED) ? 1 : 0
			Next
			For $i = 0 To UBound($g_ahCGMainDestructionItem) - 1
				$g_abCGMainDestructionItem[$i] = BitAND(GUICtrlRead($g_ahCGMainDestructionItem[$i]), $GUI_CHECKED) ? 1 : 0
			Next
			For $i = 0 To UBound($g_ahCGMainAirItem) - 1
				$g_abCGMainAirItem[$i] = BitAND(GUICtrlRead($g_ahCGMainAirItem[$i]), $GUI_CHECKED) ? 1 : 0
			Next
			For $i = 0 To UBound($g_ahCGMainGroundItem) - 1
				$g_abCGMainGroundItem[$i] = BitAND(GUICtrlRead($g_ahCGMainGroundItem[$i]), $GUI_CHECKED) ? 1 : 0
			Next
			For $i = 0 To UBound($g_ahCGMainMiscItem) - 1
				$g_abCGMainMiscItem[$i] = BitAND(GUICtrlRead($g_ahCGMainMiscItem[$i]), $GUI_CHECKED) ? 1 : 0
			Next
			For $i = 0 To UBound($g_ahCGMainSpellItem) - 1
				$g_abCGMainSpellItem[$i] = BitAND(GUICtrlRead($g_ahCGMainSpellItem[$i]), $GUI_CHECKED) ? 1 : 0
			Next
			For $i = 0 To UBound($g_ahCGBBBattleItem) - 1
				$g_abCGBBBattleItem[$i] = BitAND(GUICtrlRead($g_ahCGBBBattleItem[$i]), $GUI_CHECKED) ? 1 : 0
			Next
			For $i = 0 To UBound($g_ahCGBBDestructionItem) - 1
				$g_abCGBBDestructionItem[$i] = BitAND(GUICtrlRead($g_ahCGBBDestructionItem[$i]), $GUI_CHECKED) ? 1 : 0
			Next
			For $i = 0 To UBound($g_ahCGBBTroopsItem) - 1
				$g_abCGBBTroopsItem[$i] = BitAND(GUICtrlRead($g_ahCGBBTroopsItem[$i]), $GUI_CHECKED) ? 1 : 0
			Next

			; Builder Base Attack
			$g_bChkEnableBBAttack = (GUICtrlRead($g_hChkEnableBBAttack) = $GUI_CHECKED)
			$g_bChkBBDropTrophy = (GUICtrlRead($g_hChkBBDropTrophy) = $GUI_CHECKED)
			$g_bChkStopAttackBB6thBuilder = (GUICtrlRead($g_hChkStopAttackBB6thBuilder) = $GUI_CHECKED)
			$g_bChkBBEndBattleOn2Stars = (GUICtrlRead($g_hChkBBEndBattleOn2Stars) = $GUI_CHECKED)
			$g_bChkSkipBBRoutineOn6thBuilder = (GUICtrlRead($g_hChkSkipBBRoutineOn6thBuilder) = $GUI_CHECKED)
			$g_iTxtBBTrophyLowerLimit = Number(GUICtrlRead($g_hTxtBBTrophyLowerLimit))
			$g_bChkBBAttIfStarsAvail = (GUICtrlRead($g_hChkBBAttIfStarsAvail) = $GUI_CHECKED)
			$g_bChkSkipBBAttIfStorageFull = (GUICtrlRead($g_hChkSkipBBAttIfStorageFull) = $GUI_CHECKED)
			$g_bChkBBWaitForMachine = (GUICtrlRead($g_hChkBBWaitForMachine) = $GUI_CHECKED)
			$g_bChkBBDropBMFirst = (GUICtrlRead($g_hChkBBDropBMFirst) = $GUI_CHECKED)
			$g_bChkDebugAttackBB = (GUICtrlRead($g_hChkDebugAttackBB) = $GUI_CHECKED)
			$g_iBBSameTroopDelay = _GUICtrlComboBox_GetCurSel($g_hCmbBBSameTroopDelay) - 1
			$g_iBBNextTroopDelay = _GUICtrlComboBox_GetCurSel($g_hCmbBBNextTroopDelay) - 1
			$g_iBBAttackCount = _GUICtrlComboBox_GetCurSel($g_hCmbBBAttackCount)

			;ClanCapital
			$g_bChkEnableCollectCCGold = (GUICtrlRead($g_hChkEnableCollectCCGold) = $GUI_CHECKED)
			$g_bChkStartWeekendRaid = (GUICtrlRead($g_hChkStartWeekendRaid) = $GUI_CHECKED)
			$g_bChkEnableForgeGold = (GUICtrlRead($g_hChkEnableForgeGold) = $GUI_CHECKED)
			$g_bChkEnableForgeElix = (GUICtrlRead($g_hChkEnableForgeElix) = $GUI_CHECKED)
			$g_bChkEnableForgeDE = (GUICtrlRead($g_hChkEnableForgeDE) = $GUI_CHECKED)
			$g_bChkEnableForgeBBGold = (GUICtrlRead($g_hChkEnableForgeBBGold) = $GUI_CHECKED)
			$g_bChkEnableForgeBBElix = (GUICtrlRead($g_hChkEnableForgeBBElix) = $GUI_CHECKED)
			$g_iCmbForgeBuilder = _GUICtrlComboBox_GetCurSel($g_hCmbForgeBuilder)
			$g_bChkEnableAutoUpgradeCC = (GUICtrlRead($g_hChkEnableAutoUpgradeCC) = $GUI_CHECKED)
			$g_bChkEnableMinGoldAUCC = (GUICtrlRead($g_hChkEnableMinGoldAUCC) = $GUI_CHECKED)
			$g_iMinCCGoldToUpgrade = Number(GUICtrlRead($g_hTxtMinCCGoldToUpgrade))
			$g_bChkAutoUpgradeCCIgnore = (GUICtrlRead($g_hChkAutoUpgradeCCIgnore) = $GUI_CHECKED)
			$g_bChkAutoUpgradeCCWallIgnore = (GUICtrlRead($g_hChkAutoUpgradeCCWallIgnore) = $GUI_CHECKED)

			;Misc Mod
			$g_bSkipFirstCheckRoutine = (GUICtrlRead($g_hChkMMSkipFirstCheckRoutine) = $GUI_CHECKED)
			$g_bSkipBB = (GUICtrlRead($g_hChkMMSkipBB) = $GUI_CHECKED)
			$g_bIgnoreIncorrectTroopCombo = (GUICtrlRead($g_hChkMMIgnoreIncorrectTroopCombo) = $GUI_CHECKED)
			$g_iCmbFillIncorrectTroopCombo = _GUICtrlComboBox_GetCurSel($g_hCmbFillIncorrectTroopCombo)
			$g_bIgnoreIncorrectSpellCombo = (GUICtrlRead($g_hChkMMIgnoreIncorrectSpellCombo) = $GUI_CHECKED)
			$g_iCmbFillIncorrectSpellCombo = _GUICtrlComboBox_GetCurSel($g_hCmbFillIncorrectSpellCombo)
			$g_bSkipWallPlacingOnBB = (GUICtrlRead($g_hChkMMSkipWallPlacingOnBB) = $GUI_CHECKED)
			$g_bDonateEarly = (GUICtrlRead($g_hDonateEarly) = $GUI_CHECKED)
			$g_bAutoUpgradeEarly = (GUICtrlRead($g_hAutoUpgradeEarly) = $GUI_CHECKED)
			$g_bChkForceSwitchifNoCGEvent = (GUICtrlRead($g_hChkForceSwitchifNoCGEvent) = $GUI_CHECKED)
			$g_bEnableCCSleep = (GUICtrlRead($g_hChkEnableCCSleep) = $GUI_CHECKED)

	EndSwitch
EndFunc   ;==>ApplyConfig_600_6

Func ApplyBuilderBaseMod($TypeReadSave)
	If $TypeReadSave = "Read" Then
		; Custom Army
		GUICtrlSetState($g_hChkBBCustomArmyEnable, $g_bChkBBCustomArmyEnable ? $GUI_CHECKED : $GUI_UNCHECKED)
		For $i = 0 To UBound($g_hCmbTroopBB) - 1
			_GUICtrlComboBox_SetCurSel($g_hCmbTroopBB[$i], $g_iCmbTroopBB[$i])
			_GUICtrlSetImage($g_hIcnTroopBB[$i], $g_sLibIconPath, $g_avStarLabTroops[$g_iCmbTroopBB[$i] + 1][4])
		Next
		GUICtrlSetState($g_hChk1SideAttack, $g_b1SideBBAttack ? $GUI_CHECKED : $GUI_UNCHECKED)
		_GUICtrlComboBox_SetCurSel($g_hCmbSideAttack, $g_i1SideBBAttack)
		GUICtrlSetState($g_hChk2SideAttack, $g_b2SideBBAttack ? $GUI_CHECKED : $GUI_UNCHECKED)
		GUICtrlSetState($g_hChkAllSideBBAttack, $g_bAllSideBBAttack ? $GUI_CHECKED : $GUI_UNCHECKED)
	Else
		; Custom Army
		$g_bChkBBCustomArmyEnable = (GUICtrlRead($g_hChkBBCustomArmyEnable) = $GUI_CHECKED)
		For $i = 0 To UBound($g_hCmbTroopBB) - 1
			$g_iCmbTroopBB[$i] = _GUICtrlComboBox_GetCurSel($g_hCmbTroopBB[$i])
		Next
		$g_b1SideBBAttack = (GUICtrlRead($g_hChk1SideAttack) = $GUI_CHECKED)
		$g_i1SideBBAttack = _GUICtrlComboBox_GetCurSel($g_hCmbSideAttack)
		$g_b2SideBBAttack = (GUICtrlRead($g_hChk2SideAttack) = $GUI_CHECKED)
		$g_bAllSideBBAttack = (GUICtrlRead($g_hChkAllSideBBAttack) = $GUI_CHECKED)
	EndIf
	ChkBBCustomArmyEnable()
EndFunc   ;==>ApplyBuilderBaseMod

Func ApplyConfig_600_9($TypeReadSave)
	; <><><><> Village / Achievements <><><><>
	Switch $TypeReadSave
		Case "Read"
			GUICtrlSetState($g_hChkUnbreakable, $g_iUnbrkMode = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($g_hTxtUnbreakable, $g_iUnbrkWait)
			GUICtrlSetData($g_hTxtUnBrkMinGold, $g_iUnbrkMinGold)
			GUICtrlSetData($g_hTxtUnBrkMinElixir, $g_iUnbrkMinElixir)
			GUICtrlSetData($g_hTxtUnBrkMinDark, $g_iUnbrkMinDark)
			GUICtrlSetData($g_hTxtUnBrkMaxGold, $g_iUnbrkMaxGold)
			GUICtrlSetData($g_hTxtUnBrkMaxElixir, $g_iUnbrkMaxElixir)
			GUICtrlSetData($g_hTxtUnBrkMaxDark, $g_iUnbrkMaxDark)
			chkUnbreakable()
		Case "Save"
			$g_iUnbrkMode = GUICtrlRead($g_hChkUnbreakable) = $GUI_CHECKED ? 1 : 0
			$g_iUnbrkWait = GUICtrlRead($g_hTxtUnbreakable)
			$g_iUnbrkMinGold = GUICtrlRead($g_hTxtUnBrkMinGold)
			$g_iUnbrkMinElixir = GUICtrlRead($g_hTxtUnBrkMinElixir)
			$g_iUnbrkMinDark = GUICtrlRead($g_hTxtUnBrkMinDark)
			$g_iUnbrkMaxGold = GUICtrlRead($g_hTxtUnBrkMaxGold)
			$g_iUnbrkMaxElixir = GUICtrlRead($g_hTxtUnBrkMaxElixir)
			$g_iUnbrkMaxDark = GUICtrlRead($g_hTxtUnBrkMaxDark)
	EndSwitch
EndFunc   ;==>ApplyConfig_600_9

Func ApplyConfig_600_11($TypeReadSave)
	; <><><><> Village / Donate - Request <><><><>
	Switch $TypeReadSave
		Case "Read"
			GUICtrlSetState($g_hChkRequestTroopsEnable, $g_bRequestTroopsEnable ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($g_hTxtRequestCC, $g_sRequestTroopsText)
			chkRequestCC()
		Case "Save"
			$g_bRequestTroopsEnable = (GUICtrlRead($g_hChkRequestTroopsEnable) = $GUI_CHECKED)
			$g_sRequestTroopsText = GUICtrlRead($g_hTxtRequestCC)
	EndSwitch
EndFunc   ;==>ApplyConfig_600_11

Func ApplyConfig_600_12($TypeReadSave)
	; <><><><> Village / Donate - Donate <><><><>
	Switch $TypeReadSave
		Case "Read"
			GUICtrlSetState($g_hChkDonate, $g_bChkDonate ? $GUI_CHECKED : $GUI_UNCHECKED)
			Doncheck()
			For $i = 0 To $eTroopCount - 1
				GUICtrlSetState($g_ahChkDonateTroop[$i], $g_abChkDonateTroop[$i] ? $GUI_CHECKED : $GUI_UNCHECKED)
				If $g_abChkDonateTroop[$i] Then
					_DonateControls($i)
				Else
					GUICtrlSetBkColor($g_ahLblDonateTroop[$i], $GUI_BKCOLOR_TRANSPARENT)
				EndIf

				GUICtrlSetData($g_ahTxtDonateTroop[$i], $g_asTxtDonateTroop[$i])
			Next

			For $i = 0 To $eSpellCount - 1
				GUICtrlSetState($g_ahChkDonateSpell[$i], $g_abChkDonateSpell[$i] ? $GUI_CHECKED : $GUI_UNCHECKED)
				If $g_abChkDonateSpell[$i] Then
					_DonateControlsSpell($i)
				Else
					GUICtrlSetBkColor($g_ahLblDonateSpell[$i], $GUI_BKCOLOR_TRANSPARENT)
				EndIf

				GUICtrlSetData($g_ahTxtDonateSpell[$i], $g_asTxtDonateSpell[$i])
			Next

			For $i = $eSiegeWallWrecker to $eSiegeMachineCount - 1
				Local $index = $eTroopCount
				GUICtrlSetState($g_ahChkDonateTroop[$index + $i], $g_abChkDonateTroop[$index + $i] ? $GUI_CHECKED : $GUI_UNCHECKED)
				If $g_abChkDonateTroop[$index + $i] Then
					_DonateControls($index + $i)
				Else
					GUICtrlSetBkColor($g_ahLblDonateTroop[$index + $i], $GUI_BKCOLOR_TRANSPARENT)
				EndIf

				GUICtrlSetData($g_ahTxtDonateTroop[$index + $i], $g_asTxtDonateTroop[$index + $i])
			Next

			GUICtrlSetState($g_hChkExtraAlphabets, $g_bChkExtraAlphabets ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkExtraChinese, $g_bChkExtraChinese ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkExtraKorean, $g_bChkExtraKorean ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkExtraPersian, $g_bChkExtraPersian ? $GUI_CHECKED : $GUI_UNCHECKED)

		Case "Save"
			$g_bChkDonate = (GUICtrlRead($g_hChkDonate) = $GUI_CHECKED)
			For $i = 0 To $eTroopCount - 1
				$g_abChkDonateTroop[$i] = (GUICtrlRead($g_ahChkDonateTroop[$i]) = $GUI_CHECKED)
				$g_asTxtDonateTroop[$i] = GUICtrlRead($g_ahTxtDonateTroop[$i])
			Next

			For $i = 0 To $eSpellCount - 1
				$g_abChkDonateSpell[$i] = (GUICtrlRead($g_ahChkDonateSpell[$i]) = $GUI_CHECKED)
				$g_asTxtDonateSpell[$i] = GUICtrlRead($g_ahTxtDonateSpell[$i])
			Next

			For $i = $eSiegeWallWrecker to $eSiegeMachineCount - 1
				Local $index = $eTroopCount
				$g_abChkDonateTroop[$index + $i] = (GUICtrlRead($g_ahChkDonateTroop[$index + $i]) = $GUI_CHECKED)
				$g_asTxtDonateTroop[$index + $i] = GUICtrlRead($g_ahTxtDonateTroop[$index + $i])
			Next

			$g_bChkExtraAlphabets = (GUICtrlRead($g_hChkExtraAlphabets) = $GUI_CHECKED)
			$g_bChkExtraChinese = (GUICtrlRead($g_hChkExtraChinese) = $GUI_CHECKED)
			$g_bChkExtraKorean = (GUICtrlRead($g_hChkExtraKorean) = $GUI_CHECKED)
			$g_bChkExtraPersian = (GUICtrlRead($g_hChkExtraPersian) = $GUI_CHECKED)

	EndSwitch
EndFunc   ;==>ApplyConfig_600_12

Func ApplyConfig_600_14($TypeReadSave)
	; <><><><> Village / Upgrade - Lab <><><><>
	Switch $TypeReadSave
		Case "Read"
			GUICtrlSetState($g_hChkAutoLabUpgrades, $g_bAutoLabUpgradeEnable ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hUseLabPotion, $g_bUseLabPotion ? $GUI_CHECKED : $GUI_UNCHECKED)
			_GUICtrlComboBox_SetCurSel($g_hCmbLaboratory, $g_iCmbLaboratory)
			_GUICtrlSetImage($g_hPicLabUpgrade, $g_sLibIconPath, $g_avLabTroops[$g_iCmbLaboratory][1])
			chkLab()

			GUICtrlSetState($g_hChkLabUpgradeOrder, $g_bLabUpgradeOrderEnable ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hUpgradeAnyTroops, $g_bUpgradeAnyTroops ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hUseBOF, $g_bUseBOF ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($g_hUseBOFTime, $g_iUseBOFTime)
			GUICtrlSetState($g_hUseBOS, $g_bUseBOS ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($g_hUseBOSTime, $g_iUseBOSTime)
			GUICtrlSetState($g_hUseBOE, $g_bUseBOE ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($g_hUseBOETime, $g_iUseBOETime)

			For $i = 0 To UBound($g_aCmbLabUpgradeOrder) - 1
				_GUICtrlComboBox_SetCurSel($g_ahCmbLabUpgradeOrder[$i], $g_aCmbLabUpgradeOrder[$i])
			Next
			chkLabUpgradeOrder()
			GUICtrlSetState($g_hChkAutoStarLabUpgrades, $g_bAutoStarLabUpgradeEnable ? $GUI_CHECKED : $GUI_UNCHECKED)
			_GUICtrlComboBox_SetCurSel($g_hCmbStarLaboratory, $g_iCmbStarLaboratory)
			chkStarLab()

			GUICtrlSetState($g_hChkSLabUpgradeOrder, $g_bSLabUpgradeOrderEnable ? $GUI_CHECKED : $GUI_UNCHECKED)
			For $i = 0 To UBound($g_aCmbSLabUpgradeOrder) - 1
				_GUICtrlComboBox_SetCurSel($g_ahCmbSLabUpgradeOrder[$i], $g_aCmbSLabUpgradeOrder[$i])
			Next
			GUICtrlSetState($g_hChkUpgradeAnyIfAllOrderMaxed, $g_bChkUpgradeAnyIfAllOrderMaxed ? $GUI_CHECKED : $GUI_UNCHECKED)
			chkSLabUpgradeOrder()
		Case "Save"
			$g_bAutoLabUpgradeEnable = (GUICtrlRead($g_hChkAutoLabUpgrades) = $GUI_CHECKED)
			$g_bUseLabPotion = (GUICtrlRead($g_hUseLabPotion) = $GUI_CHECKED)
			$g_iCmbLaboratory = _GUICtrlComboBox_GetCurSel($g_hCmbLaboratory)
			$g_bAutoStarLabUpgradeEnable = (GUICtrlRead($g_hChkAutoStarLabUpgrades) = $GUI_CHECKED)
			$g_iCmbStarLaboratory = _GUICtrlComboBox_GetCurSel($g_hCmbStarLaboratory)

			$g_bLabUpgradeOrderEnable = (GUICtrlRead($g_hChkLabUpgradeOrder) = $GUI_CHECKED)
			$g_bUpgradeAnyTroops = (GUICtrlRead($g_hUpgradeAnyTroops) = $GUI_CHECKED)
			$g_bUseBOF = (GUICtrlRead($g_hUseBOF) = $GUI_CHECKED)
			$g_iUseBOFTime =  GUICtrlRead($g_hUseBOFTime)
			$g_bUseBOS = (GUICtrlRead($g_hUseBOS) = $GUI_CHECKED)
			$g_iUseBOSTime =  GUICtrlRead($g_hUseBOSTime)
			$g_bUseBOE = (GUICtrlRead($g_hUseBOE) = $GUI_CHECKED)
			$g_iUseBOETime =  GUICtrlRead($g_hUseBOETime)

			For $i = 0 To UBound($g_ahCmbLabUpgradeOrder) - 1
				$g_aCmbLabUpgradeOrder[$i] = _GUICtrlComboBox_GetCurSel($g_ahCmbLabUpgradeOrder[$i])
			Next
			$g_bSLabUpgradeOrderEnable = (GUICtrlRead($g_hChkSLabUpgradeOrder) = $GUI_CHECKED)
			For $i = 0 To UBound($g_ahCmbSLabUpgradeOrder) - 1
				$g_aCmbSLabUpgradeOrder[$i] = _GUICtrlComboBox_GetCurSel($g_ahCmbSLabUpgradeOrder[$i])
			Next
			$g_bChkUpgradeAnyIfAllOrderMaxed = (GUICtrlRead($g_hChkUpgradeAnyIfAllOrderMaxed) = $GUI_CHECKED)
	EndSwitch
EndFunc   ;==>ApplyConfig_600_14

Func ApplyConfig_600_15($TypeReadSave)
	; <><><><> Village / Upgrade - Heroes <><><><>
	Switch $TypeReadSave
		Case "Read"
			GUICtrlSetState($g_hChkUpgradeKing, $g_bUpgradeKingEnable ? $GUI_CHECKED : $GUI_UNCHECKED)
			chkUpgradeKing()
			GUICtrlSetState($g_hChkUpgradeQueen, $g_bUpgradeQueenEnable ? $GUI_CHECKED : $GUI_UNCHECKED)
			chkUpgradeQueen()
			GUICtrlSetState($g_hChkUpgradeWarden, $g_bUpgradeWardenEnable ? $GUI_CHECKED : $GUI_UNCHECKED)
			chkUpgradeWarden()
			GUICtrlSetState($g_hChkUpgradeChampion, $g_bUpgradeChampionEnable ? $GUI_CHECKED : $GUI_UNCHECKED)
			chkUpgradeChampion()
			_GUICtrlComboBox_SetCurSel($g_hCmbHeroReservedBuilder, $g_iHeroReservedBuilder)
			cmbHeroReservedBuilder()

			GUICtrlSetState($g_hChkCustomEquipmentOrderEnable, $g_bChkCustomEquipmentOrderEnable ? $GUI_CHECKED : $GUI_UNCHECKED)
			For $z = 0 To UBound($g_ahCmbEquipmentOrder) - 1
				GUICtrlSetState($g_hChkCustomEquipmentOrder[$z], $g_bChkCustomEquipmentOrder[$z] ? $GUI_CHECKED : $GUI_UNCHECKED)
				_GUICtrlComboBox_SetCurSel($g_ahCmbEquipmentOrder[$z], $g_aiCmbCustomEquipmentOrder[$z])
				_GUICtrlSetImage($g_ahImgEquipmentOrder[$z], $g_sLibIconPath, $g_aiEquipmentOrderIcon[$g_aiCmbCustomEquipmentOrder[$z] + 1])
				_GUICtrlSetImage($g_ahImgEquipmentOrder2[$z], $g_sLibIconPath, $g_aiEquipmentOrderIcon2[$g_aiCmbCustomEquipmentOrder[$z] + 1])
			Next
			GUICtrlSetState($g_hChkMinOreUpgrade, $g_bChkMinOreUpgrade ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($g_hTxtMinOreUpgrade, $g_sTxtMinOreUpgrade)

			Local $iValueSet = 0
			For $i = 0 To UBound($g_ahCmbEquipmentOrder) - 1
				Local $iValue = _GUICtrlComboBox_GetCurSel($g_ahCmbEquipmentOrder[$i])
				If $iValue <> -1 Then
					$iValueSet += 1
				EndIf
			Next
			If $iValueSet > 0 And $iValueSet < $eEquipmentCount Then
				SetLog("Set your Equipment Upgrade Order!")
				btnRegularOrder()
			EndIf
			If Not ChangeEquipmentOrder() Then SetDefaultEquipmentGroup()
			If $iValueSet = 0 And $g_bChkCustomEquipmentOrderEnable Then
				SetLog("Set your Equipment Upgrade Order!")
				btnRegularOrder()
			EndIf
			EnableUpgradeEquipment()
			chkEquipmentOrder()

			For $i = 0 to $ePetCount - 1
				GUICtrlSetState($g_hChkUpgradePets[$i], $g_bUpgradePetsEnable[$i] ? $GUI_CHECKED : $GUI_UNCHECKED)
			Next
			GUICtrlSetState($g_hChkSortPetUpgrade, $g_bChkSortPetUpgrade ? $GUI_CHECKED : $GUI_UNCHECKED)
			_GUICtrlComboBox_SetCurSel($g_hCmbSortPetUpgrade, $g_iCmbSortPetUpgrade)
			GUICtrlSetState($g_hChkSyncSaveDE, $g_bChkSyncSaveDE ? $GUI_CHECKED : $GUI_UNCHECKED)
		Case "Save"
			$g_bUpgradeKingEnable = (GUICtrlRead($g_hChkUpgradeKing) = $GUI_CHECKED)
			$g_bUpgradeQueenEnable = (GUICtrlRead($g_hChkUpgradeQueen) = $GUI_CHECKED)
			$g_bUpgradeWardenEnable = (GUICtrlRead($g_hChkUpgradeWarden) = $GUI_CHECKED)
			$g_bUpgradeChampionEnable = (GUICtrlRead($g_hChkUpgradeChampion) = $GUI_CHECKED)
			$g_iHeroReservedBuilder = _GUICtrlComboBox_GetCurSel($g_hCmbHeroReservedBuilder)

			$g_bChkCustomEquipmentOrderEnable = (GUICtrlRead($g_hChkCustomEquipmentOrderEnable) = $GUI_CHECKED)
			For $z = 0 To UBound($g_ahCmbEquipmentOrder) - 1
				$g_bChkCustomEquipmentOrder[$z] = (GUICtrlRead($g_hChkCustomEquipmentOrder[$z]) = $GUI_CHECKED)
				$g_aiCmbCustomEquipmentOrder[$z] = _GUICtrlComboBox_GetCurSel($g_ahCmbEquipmentOrder[$z])
			Next
			$g_bChkMinOreUpgrade = (GUICtrlRead($g_hChkMinOreUpgrade) = $GUI_CHECKED)
			$g_sTxtMinOreUpgrade = GuiCtrlRead($g_hTxtMinOreUpgrade)

			For $i = 0 to $ePetCount - 1
				$g_bUpgradePetsEnable[$i] = (GUICtrlRead($g_hChkUpgradePets[$i]) = $GUI_CHECKED)
			Next
			$g_bChkSortPetUpgrade = (GUICtrlRead($g_hChkSortPetUpgrade) = $GUI_CHECKED)
			$g_iCmbSortPetUpgrade = _GUICtrlComboBox_GetCurSel($g_hCmbSortPetUpgrade)
			$g_bChkSyncSaveDE = (GUICtrlRead($g_hChkSyncSaveDE) = $GUI_CHECKED)

	EndSwitch
EndFunc   ;==>ApplyConfig_600_15

Func ApplyConfig_600_16($TypeReadSave)
	; <><><><> Village / Upgrade - Buildings <><><><>
	Local $j=0
	Switch $TypeReadSave
		Case "Read"
			For $iz = 0 To UBound($g_avBuildingUpgrades, 1) - 1 ; Apply the buildings upgrade variable to GUI
				;SetDebugLog("Setting image to " & $g_aiPicUpgradeStatus[$iz])
				;$eIcnTroops=43, $eIcnGreenLight=69, $eIcnRedLight=71 or $eIcnYellowLight=73
				;I have no idea why this crap is necessary...
				$j=$eIcnRedLight
				if $g_aiPicUpgradeStatus[$iz]=$eIcnYellowLight Then $j=$eIcnYellowLight
				If $g_aiPicUpgradeStatus[$iz]=$eIcnGreenLight Then $j=$eIcnGreenLight
				;Should be no other value...otherwise will default to Red.
				_GUICtrlSetImage($g_hPicUpgradeStatus[$iz], $g_sLibIconPath, $j) ; Set GUI status pic
				If $g_avBuildingUpgrades[$iz][2] > 0 Then
					GUICtrlSetData($g_hTxtUpgradeValue[$iz], _NumberFormat($g_avBuildingUpgrades[$iz][2])) ; Set GUI loot value to match $g_avBuildingUpgrades variable
				Else
					GUICtrlSetData($g_hTxtUpgradeValue[$iz], "") ; Set GUI loot value to blank
				EndIf
				GUICtrlSetData($g_hTxtUpgradeName[$iz], $g_avBuildingUpgrades[$iz][4]) ; Set GUI unit name $g_avBuildingUpgrades variable
				GUICtrlSetData($g_hTxtUpgradeLevel[$iz], $g_avBuildingUpgrades[$iz][5]) ; Set GUI unit level to match $g_avBuildingUpgrades variable
				GUICtrlSetData($g_hTxtUpgradeTime[$iz], StringStripWS($g_avBuildingUpgrades[$iz][6], $STR_STRIPALL)) ; Set GUI upgrade time to match $g_avBuildingUpgrades variable

				Switch $g_avBuildingUpgrades[$iz][3] ;Set GUI Upgrade Type to match $g_avBuildingUpgrades variable
					Case "Gold"
						_GUICtrlSetImage($g_hPicUpgradeType[$iz], $g_sLibIconPath, $eIcnGold)
					Case "Elixir"
						_GUICtrlSetImage($g_hPicUpgradeType[$iz], $g_sLibIconPath, $eIcnElixir)
					Case "Dark"
						_GUICtrlSetImage($g_hPicUpgradeType[$iz], $g_sLibIconPath, $eIcnDark)
					Case Else
						_GUICtrlSetImage($g_hPicUpgradeType[$iz], $g_sLibIconPath, $eIcnBlank)
				EndSwitch

				GUICtrlSetState($g_hChkUpgrade[$iz], $g_abBuildingUpgradeEnable[$iz] ? $GUI_CHECKED : $GUI_UNCHECKED)
				GUICtrlSetState($g_hChkUpgradeRepeat[$iz], $g_abUpgradeRepeatEnable[$iz] ? $GUI_CHECKED : $GUI_UNCHECKED)
				GUICtrlSetData($g_hTxtUpgradeEndTime[$iz], $g_avBuildingUpgrades[$iz][7]) ; Set GUI upgrade End time to match $g_avBuildingUpgrades variable
			Next
			GUICtrlSetData($g_hTxtUpgrMinGold, $g_iUpgradeMinGold)
			GUICtrlSetData($g_hTxtUpgrMinElixir, $g_iUpgradeMinElixir)
			GUICtrlSetData($g_hTxtUpgrMinDark, $g_iUpgradeMinDark)
		Case "Save"
			For $iz = 0 To UBound($g_avBuildingUpgrades, 1) - 1 ; Apply the buildings upgrade variable to GUI
				$g_abBuildingUpgradeEnable[$iz] = (GUICtrlRead($g_hChkUpgrade[$iz]) = $GUI_CHECKED)
				$g_abUpgradeRepeatEnable[$iz] = (GUICtrlRead($g_hChkUpgradeRepeat[$iz]) = $GUI_CHECKED)
			Next
			$g_iUpgradeMinGold = Number(GUICtrlRead($g_hTxtUpgrMinGold))
			$g_iUpgradeMinElixir = Number(GUICtrlRead($g_hTxtUpgrMinElixir))
			$g_iUpgradeMinDark = Number(GUICtrlRead($g_hTxtUpgrMinDark))
	EndSwitch
EndFunc   ;==>ApplyConfig_600_16

Func ApplyConfig_auto($TypeReadSave)
	; Auto Upgrade
	Switch $TypeReadSave
		Case "Read"
			GUICtrlSetState($g_hChkAutoUpgrade, $g_bAutoUpgradeEnabled ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkRushTH, $g_bChkRushTH ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hUseWallReserveBuilder, $g_bUseWallReserveBuilder ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hUseBuilderPotion, $g_bUseBuilderPotion ? $GUI_CHECKED : $GUI_UNCHECKED)
			For $y = 0 To UBound($g_aiCmbRushTHOption) - 1
				_GUICtrlComboBox_SetCurSel($g_ahCmbRushTHOption[$y], $g_aiCmbRushTHOption[$y])
			Next
			For $y = 0 To UBound($g_aichkEssentialUpgrade) - 1
				GUICtrlSetState($g_hchkEssentialUpgrade[$y], $g_aichkEssentialUpgrade[$y] = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			Next
			GUICtrlSetState($g_hUpgradeOnlyTHLevelAchieve, $g_bUpgradeOnlyTHLevelAchieve ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hHeroPriority, $g_bHeroPriority ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hUseHeroBooks, $g_bUseHeroBooks ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($g_hHeroMinUpgradeTime, $g_iHeroMinUpgradeTime)
			GUICtrlSetState($g_hUpgradeOtherDefenses, $g_bUpgradeOtherDefenses ? $GUI_CHECKED : $GUI_UNCHECKED)
			For $i = 0 To UBound($g_iChkUpgradesToIgnore) - 1
				GUICtrlSetState($g_hChkUpgradesToIgnore[$i], $g_iChkUpgradesToIgnore[$i] = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			Next
			For $i = 0 To UBound($g_hChkResourcesToIgnore) - 1
				GUICtrlSetState($g_hChkResourcesToIgnore[$i], $g_iChkResourcesToIgnore[$i] = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
			Next
			GUICtrlSetData($g_hTxtSmartMinGold, $g_iTxtSmartMinGold)
			GUICtrlSetData($g_hTxtSmartMinElixir, $g_iTxtSmartMinElixir)
			GUICtrlSetData($g_hTxtSmartMinDark, $g_iTxtSmartMinDark)
			chkAutoUpgrade()
		Case "Save"
			$g_bAutoUpgradeEnabled = (GUICtrlRead($g_hChkAutoUpgrade) = $GUI_CHECKED)
			$g_bChkRushTH = (GUICtrlRead($g_hChkRushTH) = $GUI_CHECKED)
			$g_bUseWallReserveBuilder = (GUICtrlRead($g_hUseWallReserveBuilder) = $GUI_CHECKED)
			$g_bUseBuilderPotion = (GUICtrlRead($g_hUseBuilderPotion) = $GUI_CHECKED)
			For $y = 0 To UBound($g_aiCmbRushTHOption) - 1
				$g_aiCmbRushTHOption[$y] = _GUICtrlComboBox_GetCurSel($g_ahCmbRushTHOption[$y])
			Next
			For $y = 0 To UBound($g_aichkEssentialUpgrade) - 1
				$g_aichkEssentialUpgrade[$y] = GUICtrlRead($g_hchkEssentialUpgrade[$y]) = $GUI_CHECKED ? 1 : 0
			Next
			$g_bUpgradeOnlyTHLevelAchieve = (GUICtrlRead($g_hUpgradeOnlyTHLevelAchieve) = $GUI_CHECKED)
			$g_bHeroPriority = (GUICtrlRead($g_hHeroPriority) = $GUI_CHECKED)
			$g_bUseHeroBooks = (GUICtrlRead($g_hUseHeroBooks) = $GUI_CHECKED)
			$g_iHeroMinUpgradeTime =  GUICtrlRead($g_hHeroMinUpgradeTime)
			$g_bUpgradeOtherDefenses = (GUICtrlRead($g_hUpgradeOtherDefenses) = $GUI_CHECKED)
			For $i = 0 To UBound($g_iChkUpgradesToIgnore) - 1
				$g_iChkUpgradesToIgnore[$i] = GUICtrlRead($g_hChkUpgradesToIgnore[$i]) = $GUI_CHECKED ? 1 : 0
			Next
			For $i = 0 To UBound($g_hChkResourcesToIgnore) - 1
				$g_iChkResourcesToIgnore[$i] = GUICtrlRead($g_hChkResourcesToIgnore[$i]) = $GUI_CHECKED ? 1 : 0
			Next
			$g_iTxtSmartMinGold = GUICtrlRead($g_hTxtSmartMinGold)
			$g_iTxtSmartMinElixir = GUICtrlRead($g_hTxtSmartMinElixir)
			$g_iTxtSmartMinDark = GUICtrlRead($g_hTxtSmartMinDark)
    EndSwitch
EndFunc   ;==>ApplyConfig_auto

Func ApplyConfig_600_17($TypeReadSave)
	; <><><><> Village / Upgrade - Walls <><><><>
	Switch $TypeReadSave
		Case "Read"
			GUICtrlSetState($g_hChkWalls, $g_bAutoUpgradeWallsEnable ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($g_hTxtWallMinGold, $g_iUpgradeWallMinGold)
			GUICtrlSetData($g_hTxtWallMinElixir, $g_iUpgradeWallMinElixir)
			Switch $g_iUpgradeWallLootType
				Case 0
					GUICtrlSetState($g_hChkUseGold, $GUI_CHECKED)
				Case 1
					GUICtrlSetState($g_hChkUseElixir, $GUI_CHECKED)
				Case 2
					GUICtrlSetState($g_hChkUseElixirGold, $GUI_CHECKED)
			EndSwitch
			
			GUICtrlSetState($g_hAutoAdjustSaveWall, $g_bAutoAdjustSaveWall ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkSaveWallBldr, $g_bUpgradeWallSaveBuilder ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkOnly1Builder, $g_bChkOnly1Builder ? $GUI_CHECKED : $GUI_UNCHECKED)
			_GUICtrlComboBox_SetCurSel($g_hCmbTargetWallLevel, $g_iTargetWallLevel)
			chkWalls()
			cmbWallLevel()
		Case "Save"
			$g_bAutoUpgradeWallsEnable = (GUICtrlRead($g_hChkWalls) = $GUI_CHECKED)
			$g_iUpgradeWallMinGold = Number(GUICtrlRead($g_hTxtWallMinGold))
			$g_iUpgradeWallMinElixir = Number(GUICtrlRead($g_hTxtWallMinElixir))

			If GUICtrlRead($g_hChkUseGold) = $GUI_CHECKED Then
				$g_iUpgradeWallLootType = 0
			ElseIf GUICtrlRead($g_hChkUseElixir) = $GUI_CHECKED Then
				$g_iUpgradeWallLootType = 1
			ElseIf GUICtrlRead($g_hChkUseElixirGold) = $GUI_CHECKED Then
				$g_iUpgradeWallLootType = 2
			EndIf
			$g_bAutoAdjustSaveWall = (GUICtrlRead($g_hAutoAdjustSaveWall) = $GUI_CHECKED)
			$g_bUpgradeWallSaveBuilder = (GUICtrlRead($g_hChkSaveWallBldr) = $GUI_CHECKED)
			$g_bChkOnly1Builder = (GUICtrlRead($g_hChkOnly1Builder) = $GUI_CHECKED)
			$g_iTargetWallLevel = _GUICtrlComboBox_GetCurSel($g_hCmbTargetWallLevel)
			$g_bUpgradeSpesificWall = (_GUICtrlComboBox_GetCurSel($g_hCmbTargetWallLevel) = 0 ? False : True)
	EndSwitch
EndFunc   ;==>ApplyConfig_600_17

Func ApplyConfig_600_18($TypeReadSave)
	; <><><><> Village / Notify <><><><>
	Switch $TypeReadSave
		Case "Read"

			GUICtrlSetState($g_hChkNotifyTGEnable, $g_bNotifyTGEnable ? $GUI_CHECKED : $GUI_UNCHECKED)
			chkPBTGenabled()
			GUICtrlSetData($g_hTxtNotifyTGToken, $g_sNotifyTGToken)
			;Remote Control
			GUICtrlSetState($g_hChkNotifyRemote, $g_bNotifyRemoteEnable ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($g_hTxtNotifyOrigin, $g_sNotifyOrigin)
			;Alerts
			GUICtrlSetState($g_hChkNotifyAlertMatchFound, $g_bNotifyAlertMatchFound ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkNotifyAlertLastRaidIMG, $g_bNotifyAlerLastRaidIMG ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkNotifyAlertUpgradeWall, $g_bNotifyAlertUpgradeWalls ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkNotifyAlertOutOfSync, $g_bNotifyAlertOutOfSync ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkNotifyAlertTakeBreak, $g_bNotifyAlertTakeBreak ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkNotifyAlertAnotherDevice, $g_bNotifyAlertAnotherDevice ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkNotifyAlertLastRaidTXT, $g_bNotifyAlerLastRaidTXT ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkNotifyAlertCampFull, $g_bNotifyAlertCampFull ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkNotifyAlertVillageStats, $g_bNotifyAlertVillageReport ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkNotifyAlertLastAttack, $g_bNotifyAlertLastAttack ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkNotifyAlertBuilderIdle, $g_bNotifyAlertBulderIdle ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkNotifyAlertMaintenance, $g_bNotifyAlertMaintenance ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkNotifyAlertBAN, $g_bNotifyAlertBAN ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkNotifyBOTUpdate, $g_bNotifyAlertBOTUpdate ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkNotifyAlertLaboratoryIdle, $g_bNotifyAlertLaboratoryIdle ? $GUI_CHECKED : $GUI_UNCHECKED)
		Case "Save"
			; Telegram
			$g_bNotifyTGEnable = (GUICtrlRead($g_hChkNotifyTGEnable) = $GUI_CHECKED)
			$g_sNotifyTGToken = GUICtrlRead($g_hTxtNotifyTGToken)
			;Remote Control
			$g_bNotifyRemoteEnable = (GUICtrlRead($g_hChkNotifyRemote) = $GUI_CHECKED)
			$g_sNotifyOrigin = GUICtrlRead($g_hTxtNotifyOrigin)
			;Alerts
			$g_bNotifyAlertMatchFound = (GUICtrlRead($g_hChkNotifyAlertMatchFound) = $GUI_CHECKED)
			$g_bNotifyAlerLastRaidIMG = (GUICtrlRead($g_hChkNotifyAlertLastRaidIMG) = $GUI_CHECKED)
			$g_bNotifyAlertUpgradeWalls = (GUICtrlRead($g_hChkNotifyAlertUpgradeWall) = $GUI_CHECKED)
			$g_bNotifyAlertOutOfSync = (GUICtrlRead($g_hChkNotifyAlertOutOfSync) = $GUI_CHECKED)
			$g_bNotifyAlertTakeBreak = (GUICtrlRead($g_hChkNotifyAlertTakeBreak) = $GUI_CHECKED)
			$g_bNotifyAlertAnotherDevice = (GUICtrlRead($g_hChkNotifyAlertAnotherDevice) = $GUI_CHECKED)
			$g_bNotifyAlerLastRaidTXT = (GUICtrlRead($g_hChkNotifyAlertLastRaidTXT) = $GUI_CHECKED)
			$g_bNotifyAlertCampFull = (GUICtrlRead($g_hChkNotifyAlertCampFull) = $GUI_CHECKED)
			$g_bNotifyAlertVillageReport = (GUICtrlRead($g_hChkNotifyAlertVillageStats) = $GUI_CHECKED)
			$g_bNotifyAlertLastAttack = (GUICtrlRead($g_hChkNotifyAlertLastAttack) = $GUI_CHECKED)
			$g_bNotifyAlertBulderIdle = (GUICtrlRead($g_hChkNotifyAlertBuilderIdle) = $GUI_CHECKED)
			$g_bNotifyAlertMaintenance = (GUICtrlRead($g_hChkNotifyAlertMaintenance) = $GUI_CHECKED)
			$g_bNotifyAlertBAN = (GUICtrlRead($g_hChkNotifyAlertBAN) = $GUI_CHECKED)
			$g_bNotifyAlertBOTUpdate = (GUICtrlRead($g_hChkNotifyBOTUpdate) = $GUI_CHECKED)
			$g_bNotifyAlertLaboratoryIdle = (GUICtrlRead($g_hChkNotifyAlertLaboratoryIdle) = $GUI_CHECKED)
	EndSwitch
EndFunc   ;==>ApplyConfig_600_18

Func ApplyConfig_600_19($TypeReadSave)
	; <><><><> Village / Notify <><><><>
	Switch $TypeReadSave
		Case "Read"
			;Schedule
			GUICtrlSetState($g_hChkNotifyOnlyHours, $g_bNotifyScheduleHoursEnable ? $GUI_CHECKED : $GUI_UNCHECKED)
			chkNotifyHours()
			For $i = 0 To 23
				GUICtrlSetState($g_hChkNotifyhours[$i], $g_abNotifyScheduleHours[$i] ? $GUI_CHECKED : $GUI_UNCHECKED)
			Next

			GUICtrlSetState($g_hChkNotifyOnlyWeekDays, $g_bNotifyScheduleWeekDaysEnable ? $GUI_CHECKED : $GUI_UNCHECKED)
			chkNotifyWeekDays()
			For $i = 0 To 6
				GUICtrlSetState($g_hChkNotifyWeekdays[$i], $g_abNotifyScheduleWeekDays[$i] ? $GUI_CHECKED : $GUI_UNCHECKED)
			Next
		Case "Save"
			$g_bNotifyScheduleHoursEnable = (GUICtrlRead($g_hChkNotifyOnlyHours) = $GUI_CHECKED)
			For $i = 0 To 23
				$g_abNotifyScheduleHours[$i] = (GUICtrlRead($g_hChkNotifyhours[$i]) = $GUI_CHECKED)
			Next
			$g_bNotifyScheduleWeekDaysEnable = (GUICtrlRead($g_hChkNotifyOnlyWeekDays) = $GUI_CHECKED)
			For $i = 0 To 6
				$g_abNotifyScheduleWeekDays[$i] = (GUICtrlRead($g_hChkNotifyWeekdays[$i]) = $GUI_CHECKED)
			Next
	EndSwitch
EndFunc   ;==>ApplyConfig_600_19

;~ Func ApplyConfig_600_26($TypeReadSave)
;~ 	; <><><><> Attack Plan / Search & Attack / Bully <><><><>
;~ 	Switch $TypeReadSave
;~ 		Case "Read"
;~ 			GUICtrlSetState($g_hChkBully, $g_abAttackTypeEnable[$TB] ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			GUICtrlSetData($g_hTxtATBullyMode, $g_iAtkTBEnableCount)
;~ 			_GUICtrlComboBox_SetCurSel($g_hCmbBullyMaxTH, $g_iAtkTBMaxTHLevel)
;~ 			CmbBullyMaxTH()
;~ 			GUICtrlSetState($g_hRadBullyUseDBAttack, $g_iAtkTBMode = 0 ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			GUICtrlSetState($g_hRadBullyUseLBAttack, $g_iAtkTBMode = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 		Case "Save"
;~ 			$g_abAttackTypeEnable[$TB] = (GUICtrlRead($g_hChkBully) = $GUI_CHECKED)
;~ 			$g_iAtkTBEnableCount = GUICtrlRead($g_hTxtATBullyMode)
;~ 			$g_iAtkTBMaxTHLevel = _GUICtrlComboBox_GetCurSel($g_hCmbBullyMaxTH)
;~ 			$g_iAtkTBMode = (GUICtrlRead($g_hRadBullyUseDBAttack) = $GUI_CHECKED ? 0 : 1)
;~ 	EndSwitch
;~ EndFunc   ;==>ApplyConfig_600_26

;~ Func ApplyConfig_600_28($TypeReadSave)
;~ 	; <><><><> Attack Plan / Search & Attack / Options / Search <><><><>
;~ 	Switch $TypeReadSave
;~ 		Case "Read"
;~ 			GUICtrlSetState($g_hChkSearchReduction, $g_bSearchReductionEnable ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			chkSearchReduction()
;~ 			GUICtrlSetData($g_hTxtSearchReduceCount, $g_iSearchReductionCount)
;~ 			GUICtrlSetData($g_hTxtSearchReduceGold, $g_iSearchReductionGold)
;~ 			GUICtrlSetData($g_hTxtSearchReduceElixir, $g_iSearchReductionElixir)
;~ 			GUICtrlSetData($g_hTxtSearchReduceGoldPlusElixir, $g_iSearchReductionGoldPlusElixir)
;~ 			GUICtrlSetData($g_hTxtSearchReduceDark, $g_iSearchReductionDark)
;~ 			If $g_iSearchDelayMin > $g_iSearchDelayMax Then $g_iSearchDelayMax = $g_iSearchDelayMin ; check for illegal condition
;~ 			GUICtrlSetData($g_hSldVSDelay, $g_iSearchDelayMin)
;~ 			GUICtrlSetData($g_hLblVSDelay, $g_iSearchDelayMin)
;~ 			GUICtrlSetData($g_hSldMaxVSDelay, $g_iSearchDelayMax)
;~ 			GUICtrlSetData($g_hLblMaxVSDelay, $g_iSearchDelayMax)
;~ 			GUICtrlSetState($g_hChkAttackNow, $g_bSearchAttackNowEnable ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			chkAttackNow()
;~ 			_GUICtrlComboBox_SetCurSel($g_hCmbAttackNowDelay, $g_iSearchAttackNowDelay)
;~ 			GUICtrlSetState($g_hChkRestartSearchLimit, $g_bSearchRestartEnable ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			GUICtrlSetData($g_hTxtRestartSearchlimit, $g_iSearchRestartLimit)
;~ 			ChkRestartSearchLimit()
;~ 			GUICtrlSetState($g_hChkAlertSearch, $g_bSearchAlertMe ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			GUICtrlSetState($g_hChkSearchDisableFullResources, $g_bSearchDisableFullResources ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 		Case "Save"
;~ 			$g_bSearchReductionEnable = (GUICtrlRead($g_hChkSearchReduction) = $GUI_CHECKED)
;~ 			$g_iSearchReductionCount = GUICtrlRead($g_hTxtSearchReduceCount)
;~ 			$g_iSearchReductionGold = GUICtrlRead($g_hTxtSearchReduceGold)
;~ 			$g_iSearchReductionElixir = GUICtrlRead($g_hTxtSearchReduceElixir)
;~ 			$g_iSearchReductionGoldPlusElixir = GUICtrlRead($g_hTxtSearchReduceGoldPlusElixir)
;~ 			$g_iSearchReductionDark = GUICtrlRead($g_hTxtSearchReduceDark)
;~ 			$g_iSearchDelayMin = GUICtrlRead($g_hSldVSDelay)
;~ 			$g_iSearchDelayMax = GUICtrlRead($g_hSldMaxVSDelay)
;~ 			$g_bSearchAttackNowEnable = (GUICtrlRead($g_hChkAttackNow) = $GUI_CHECKED)
;~ 			$g_iSearchAttackNowDelay = _GUICtrlComboBox_GetCurSel($g_hCmbAttackNowDelay)
;~ 			$g_bSearchRestartEnable = (GUICtrlRead($g_hChkRestartSearchLimit) = $GUI_CHECKED)
;~ 			$g_iSearchRestartLimit = GUICtrlRead($g_hTxtRestartSearchlimit)
;~ 			$g_bSearchAlertMe = (GUICtrlRead($g_hChkAlertSearch) = $GUI_CHECKED)
;~ 			$g_bSearchDisableFullResources = (GUICtrlRead($g_hChkSearchDisableFullResources) = $GUI_CHECKED)
;~ 	EndSwitch
;~ EndFunc   ;==>ApplyConfig_600_28

; #FUNCTION# ====================================================================================================================
; Name ..........: ApplyConfig_CSVMod_Search_Battle
; Description ...: Apply CSV Mod battle search settings from/to GUI and normalize unsupported filters.
; Syntax ........: ApplyConfig_CSVMod_Search_Battle($TypeReadSave)
; Parameters ....: $TypeReadSave      - "Read" to push globals to GUI, "Save" to read GUI into globals.
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; =====================================================================================================================
Func ApplyConfig_CSVMod_Search_Battle($TypeReadSave)
	Switch $TypeReadSave
		Case "Read"
			If $g_hChkBattle <> 0 Then GUICtrlSetState($g_hChkBattle, $g_abAttackTypeEnable[$Battle] ? $GUI_CHECKED : $GUI_UNCHECKED)
			If $g_hchkBattleActivateSearches <> 0 Then GUICtrlSetState($g_hchkBattleActivateSearches, $g_abSearchSearchesEnable[$Battle] ? $GUI_CHECKED : $GUI_UNCHECKED)
			If $g_hTxtBattleSearchesMin <> 0 Then GUICtrlSetData($g_hTxtBattleSearchesMin, $g_aiSearchSearchesMin[$Battle])
			If $g_hTxtBattleSearchesMax <> 0 Then GUICtrlSetData($g_hTxtBattleSearchesMax, $g_aiSearchSearchesMax[$Battle])
			If $g_hchkBattleWaitForCastle <> 0 Then GUICtrlSetState($g_hchkBattleWaitForCastle, $g_abSearchCastleWaitEnable[$Battle] ? $GUI_CHECKED : $GUI_UNCHECKED)
			If $g_hTxtDBMinGold <> 0 Then GUICtrlSetData($g_hTxtDBMinGold, $g_aiFilterMinGold[$Battle])
			If $g_hTxtDBMinElixir <> 0 Then GUICtrlSetData($g_hTxtDBMinElixir, $g_aiFilterMinElixir[$Battle])
			If $g_hTxtDBMinDarkElixir <> 0 Then GUICtrlSetData($g_hTxtDBMinDarkElixir, $g_aiFilterMeetDEMin[$Battle])
			If $g_ahChkMeetOne[$Battle] <> 0 Then GUICtrlSetState($g_ahChkMeetOne[$Battle], $g_abFilterMeetOneConditionEnable[$Battle] ? $GUI_CHECKED : $GUI_UNCHECKED)
			If $g_hChkSearchDisableFullResources <> 0 Then GUICtrlSetState($g_hChkSearchDisableFullResources, $g_bSearchDisableFullResources ? $GUI_CHECKED : $GUI_UNCHECKED)
		Case "Save"
			If $g_hChkBattle <> 0 Then $g_abAttackTypeEnable[$Battle] = (GUICtrlRead($g_hChkBattle) = $GUI_CHECKED)
			If $g_hchkBattleActivateSearches <> 0 Then $g_abSearchSearchesEnable[$Battle] = (GUICtrlRead($g_hchkBattleActivateSearches) = $GUI_CHECKED)
			If $g_hTxtBattleSearchesMin <> 0 Then $g_aiSearchSearchesMin[$Battle] = Int(GUICtrlRead($g_hTxtBattleSearchesMin))
			If $g_hTxtBattleSearchesMax <> 0 Then $g_aiSearchSearchesMax[$Battle] = Int(GUICtrlRead($g_hTxtBattleSearchesMax))
			If $g_hchkBattleWaitForCastle <> 0 Then $g_abSearchCastleWaitEnable[$Battle] = (GUICtrlRead($g_hchkBattleWaitForCastle) = $GUI_CHECKED)
			If $g_hTxtDBMinGold <> 0 Then $g_aiFilterMinGold[$Battle] = Int(GUICtrlRead($g_hTxtDBMinGold))
			If $g_hTxtDBMinElixir <> 0 Then $g_aiFilterMinElixir[$Battle] = Int(GUICtrlRead($g_hTxtDBMinElixir))
			If $g_hTxtDBMinDarkElixir <> 0 Then $g_aiFilterMeetDEMin[$Battle] = Int(GUICtrlRead($g_hTxtDBMinDarkElixir))
			If $g_ahChkMeetOne[$Battle] <> 0 Then $g_abFilterMeetOneConditionEnable[$Battle] = (GUICtrlRead($g_ahChkMeetOne[$Battle]) = $GUI_CHECKED)
			If $g_hChkSearchDisableFullResources <> 0 Then $g_bSearchDisableFullResources = (GUICtrlRead($g_hChkSearchDisableFullResources) = $GUI_CHECKED)
	EndSwitch
	_ApplyConfig_CSVMod_SearchPolicy($Battle, False)
EndFunc   ;==>ApplyConfig_CSVMod_Search_Battle

; #FUNCTION# ====================================================================================================================
; Name ..........: ApplyConfig_CSVMod_Search_Ranked
; Description ...: Keep ranked battle search filter state deterministic without relying on removed GUI controls.
; Syntax ........: ApplyConfig_CSVMod_Search_Ranked($TypeReadSave)
; Parameters ....: $TypeReadSave      - "Read" to push globals to GUI, "Save" to read GUI into globals.
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; =====================================================================================================================
Func ApplyConfig_CSVMod_Search_Ranked($TypeReadSave)
	Switch $TypeReadSave
		Case "Read"
			If $g_hChkRankedBattle <> 0 Then GUICtrlSetState($g_hChkRankedBattle, $g_abAttackTypeEnable[$RankedBattle] ? $GUI_CHECKED : $GUI_UNCHECKED)
			If $g_hchkRankedBattleWaitForCastle <> 0 Then GUICtrlSetState($g_hchkRankedBattleWaitForCastle, $g_abSearchCastleWaitEnable[$RankedBattle] ? $GUI_CHECKED : $GUI_UNCHECKED)
		Case "Save"
			If $g_hChkRankedBattle <> 0 Then $g_abAttackTypeEnable[$RankedBattle] = (GUICtrlRead($g_hChkRankedBattle) = $GUI_CHECKED)
			If $g_hchkRankedBattleWaitForCastle <> 0 Then $g_abSearchCastleWaitEnable[$RankedBattle] = (GUICtrlRead($g_hchkRankedBattleWaitForCastle) = $GUI_CHECKED)
	EndSwitch
	_ApplyConfig_CSVMod_SearchPolicy($RankedBattle, True)
EndFunc   ;==>ApplyConfig_CSVMod_Search_Ranked

; #FUNCTION# ====================================================================================================================
; Name ..........: _ApplyConfig_CSVMod_SearchPolicy
; Description ...: Apply CSV Mod search policy defaults for unsupported filters.
; Syntax ........: _ApplyConfig_CSVMod_SearchPolicy($iMode, $bRankedDefaults)
; Parameters ....: $iMode             - Mode index ($Battle/$RankedBattle).
;                  $bRankedDefaults   - True to force ranked search to no-filter defaults.
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; =====================================================================================================================
Func _ApplyConfig_CSVMod_SearchPolicy($iMode, $bRankedDefaults)
	$g_abSearchSpellsWaitEnable[$iMode] = False
	$g_abSearchCampsEnable[$iMode] = False
	$g_aiSearchCampsPct[$iMode] = 0
	$g_aiFilterMeetGE[$iMode] = 0
	$g_aiFilterMinGoldPlusElixir[$iMode] = 0
	$g_abFilterMeetDEEnable[$iMode] = ($bRankedDefaults ? False : ($g_aiFilterMeetDEMin[$iMode] > 0))
	$g_abFilterMeetTH[$iMode] = False
	$g_abFilterMeetTHOutsideEnable[$iMode] = False
	$g_abFilterMaxMortarEnable[$iMode] = False
	$g_abFilterMaxWizTowerEnable[$iMode] = False
	$g_abFilterMaxAirDefenseEnable[$iMode] = False
	$g_abFilterMaxXBowEnable[$iMode] = False
	$g_abFilterMaxInfernoEnable[$iMode] = False
	$g_abFilterMaxEagleEnable[$iMode] = False
	$g_abFilterMaxScatterEnable[$iMode] = False
	$g_aiFilterMaxMortarLevel[$iMode] = 0
	$g_aiFilterMaxWizTowerLevel[$iMode] = 0
	$g_aiFilterMaxAirDefenseLevel[$iMode] = 0
	$g_aiFilterMaxXBowLevel[$iMode] = 0
	$g_aiFilterMaxInfernoLevel[$iMode] = 0
	$g_aiFilterMaxEagleLevel[$iMode] = 0
	$g_aiFilterMaxScatterLevel[$iMode] = 0
	If $iMode = $Battle Then
		$g_bChkDeadEagle = 0
		$g_iDeadEagleSearch = 0
	EndIf
	If $bRankedDefaults Then
		$g_abSearchSearchesEnable[$iMode] = False
		$g_aiSearchSearchesMin[$iMode] = 0
		$g_aiSearchSearchesMax[$iMode] = 0
		$g_aiFilterMinGold[$iMode] = 0
		$g_aiFilterMinElixir[$iMode] = 0
		$g_aiFilterMeetDEMin[$iMode] = 0
		$g_abFilterMeetOneConditionEnable[$iMode] = False
		$g_abFilterMeetDEEnable[$iMode] = False
	EndIf
EndFunc   ;==>_ApplyConfig_CSVMod_SearchPolicy

;~ Func ApplyConfig_600_29($TypeReadSave)
;~ 	; <><><><> Attack Plan / Search & Attack / Options / Attack <><><><>
;~ 	Switch $TypeReadSave
;~ 		Case "Read"
;~ 			radHerosApply()
;~ 			GUICtrlSetState($g_hChkAttackPlannerEnable, $g_bAttackPlannerEnable = True ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			GUICtrlSetState($g_hChkAttackPlannerCloseCoC, $g_bAttackPlannerCloseCoC = True ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			GUICtrlSetState($g_hChkAttackPlannerCloseAll, $g_bAttackPlannerCloseAll = True ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			GUICtrlSetState($g_hChkAttackPlannerSuspendComputer, $g_bAttackPlannerSuspendComputer = True ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			GUICtrlSetState($g_hChkAttackPlannerRandom, $g_bAttackPlannerRandomEnable ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			_GUICtrlComboBox_SetCurSel($g_hCmbAttackPlannerRandom, ($g_iAttackPlannerRandomTime - 1))
;~ 			GUICtrlSetState($g_hChkAttackPlannerDayLimit, $g_bAttackPlannerDayLimit = True ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			chkAttackPlannerEnable()
;~ 			GUICtrlSetData($g_hCmbAttackPlannerDayMin, $g_iAttackPlannerDayMin)
;~ 			GUICtrlSetData($g_hCmbAttackPlannerDayMax, $g_iAttackPlannerDayMax)
;~ 			_cmbAttackPlannerDayLimit()
;~ 			For $i = 0 To 6
;~ 				GUICtrlSetState($g_ahChkAttackWeekdays[$i], $g_abPlannedAttackWeekDays[$i] ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			Next
;~ 			For $i = 0 To 23
;~ 				GUICtrlSetState($g_ahChkAttackHours[$i], $g_abPlannedattackHours[$i] ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			Next
;~ 		Case "Save"
;~ 			If GUICtrlRead($g_hRadAutoQueenAbility) = $GUI_CHECKED Then
;~ 				$g_iActivateQueen = 0
;~ 			ElseIf GUICtrlRead($g_hRadManQueenAbility) = $GUI_CHECKED Then
;~ 				$g_iActivateQueen = 1
;~ 			ElseIf GUICtrlRead($g_hRadBothQueenAbility) = $GUI_CHECKED Then
;~ 				$g_iActivateQueen = 2
;~ 			EndIf
;~ 			$g_iDelayActivateQueen = Int(GUICtrlRead($g_hTxtManQueenAbility) * 1000)

;~ 			If GUICtrlRead($g_hRadAutoKingAbility) = $GUI_CHECKED Then
;~ 				$g_iActivateKing = 0
;~ 			ElseIf GUICtrlRead($g_hRadManKingAbility) = $GUI_CHECKED Then
;~ 				$g_iActivateKing = 1
;~ 			ElseIf GUICtrlRead($g_hRadBothKingAbility) = $GUI_CHECKED Then
;~ 				$g_iActivateKing = 2
;~ 			EndIf
;~ 			$g_iDelayActivateKing = Int(GUICtrlRead($g_hTxtManKingAbility) * 1000)

;~ 			If GUICtrlRead($g_hRadAutoWardenAbility) = $GUI_CHECKED Then
;~ 				$g_iActivateWarden = 0
;~ 			ElseIf GUICtrlRead($g_hRadManWardenAbility) = $GUI_CHECKED Then
;~ 				$g_iActivateWarden = 1
;~ 			ElseIf GUICtrlRead($g_hRadBothWardenAbility) = $GUI_CHECKED Then
;~ 				$g_iActivateWarden = 2
;~ 			EndIf
;~ 			$g_iDelayActivateWarden = Int(GUICtrlRead($g_hTxtManWardenAbility) * 1000)

;~ 			If GUICtrlRead($g_hRadAutoChampionAbility) = $GUI_CHECKED Then
;~ 				$g_iActivateChampion = 0
;~ 			ElseIf GUICtrlRead($g_hRadManChampionAbility) = $GUI_CHECKED Then
;~ 				$g_iActivateChampion = 1
;~ 			ElseIf GUICtrlRead($g_hRadBothChampionAbility) = $GUI_CHECKED Then
;~ 				$g_iActivateChampion = 2
;~ 			EndIf
;~ 			$g_iDelayActivateChampion = Int(GUICtrlRead($g_hTxtManChampionAbility) * 1000)

;~ 			If GUICtrlRead($g_hRadAutoPrinceAbility) = $GUI_CHECKED Then
;~ 				$g_iActivatePrince = 0
;~ 			ElseIf GUICtrlRead($g_hRadManPrinceAbility) = $GUI_CHECKED Then
;~ 				$g_iActivatePrince = 1
;~ 			ElseIf GUICtrlRead($g_hRadBothPrinceAbility) = $GUI_CHECKED Then
;~ 				$g_iActivatePrince = 2
;~ 			EndIf
;~ 			$g_iDelayActivatePrince = Int(GUICtrlRead($g_hTxtManPrinceAbility) * 1000)

;~ 			$g_bAttackPlannerEnable = (GUICtrlRead($g_hChkAttackPlannerEnable) = $GUI_CHECKED)
;~ 			$g_bAttackPlannerCloseCoC = (GUICtrlRead($g_hChkAttackPlannerCloseCoC) = $GUI_CHECKED)
;~ 			$g_bAttackPlannerCloseAll = (GUICtrlRead($g_hChkAttackPlannerCloseAll) = $GUI_CHECKED)
;~ 			$g_bAttackPlannerSuspendComputer = (GUICtrlRead($g_hChkAttackPlannerSuspendComputer) = $GUI_CHECKED)
;~ 			$g_bAttackPlannerRandomEnable = (GUICtrlRead($g_hChkAttackPlannerRandom) = $GUI_CHECKED)
;~ 			$g_iAttackPlannerRandomTime = (_GUICtrlComboBox_GetCurSel($g_hCmbAttackPlannerRandom) + 1)
;~ 			$g_bAttackPlannerDayLimit = (GUICtrlRead($g_hChkAttackPlannerDayLimit) = $GUI_CHECKED)
;~ 			$g_iAttackPlannerDayMin = GUICtrlRead($g_hCmbAttackPlannerDayMin)
;~ 			$g_iAttackPlannerDayMax = GUICtrlRead($g_hCmbAttackPlannerDayMax)
;~ 			Local $string = ""
;~ 			For $i = 0 To 6
;~ 				$g_abPlannedAttackWeekDays[$i] = (GUICtrlRead($g_ahChkAttackWeekdays[$i]) = $GUI_CHECKED)
;~ 			Next
;~ 			Local $string = ""
;~ 			For $i = 0 To 23
;~ 				$g_abPlannedattackHours[$i] = (GUICtrlRead($g_ahChkAttackHours[$i]) = $GUI_CHECKED)
;~ 			Next
;~ 	EndSwitch
;~ EndFunc   ;==>ApplyConfig_600_29

;~ Func ApplyConfig_600_29_DB($TypeReadSave)
;~ 	; <><><><> Attack Plan / Search & Attack / Deadbase / Attack <><><><>
;~ 	Switch $TypeReadSave
;~ 		Case "Read"
;~ 			; Attack
;~ 			If $g_hCmbDBAlgorithm <> 0 Then
;~ 				_GUICtrlComboBox_SetCurSel($g_hCmbDBAlgorithm, $g_aiAttackAlgorithm[$Battle])
;~ 				cmbDBAlgorithm()
;~ 			EndIf
;~ 			If $g_hCmbDBSelectTroop <> 0 Then _GUICtrlComboBox_SetCurSel($g_hCmbDBSelectTroop, $g_aiAttackTroopSelection[$Battle])
;~ 			If $g_hchkBattleKingAttack <> 0 Then GUICtrlSetState($g_hchkBattleKingAttack, BitAND($g_aiAttackUseHeroes[$Battle], $eHeroKing) = $eHeroKing ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			If $g_hchkBattleQueenAttack <> 0 Then GUICtrlSetState($g_hchkBattleQueenAttack, BitAND($g_aiAttackUseHeroes[$Battle], $eHeroQueen) = $eHeroQueen ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			If $g_hchkBattleWardenAttack <> 0 Then
;~ 				GUICtrlSetState($g_hchkBattleWardenAttack, BitAND($g_aiAttackUseHeroes[$Battle], $eHeroWarden) = $eHeroWarden ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 				chkBattleWardenAttack()
;~ 			EndIf
;~ 			If $g_hchkBattleChampionAttack <> 0 Then GUICtrlSetState($g_hchkBattleChampionAttack, BitAND($g_aiAttackUseHeroes[$Battle], $eHeroChampion) = $eHeroChampion ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			Local $temp1 = (BitAND($g_aiAttackUseHeroes[$Battle], $eHeroKing) = $eHeroKing ? $eHeroKing : $eHeroNone)
;~ 			Local $temp2 = (BitAND($g_aiAttackUseHeroes[$Battle], $eHeroQueen) = $eHeroQueen ? $eHeroQueen : $eHeroNone)
;~ 			Local $temp3 = (BitAND($g_aiAttackUseHeroes[$Battle], $eHeroWarden) = $eHeroWarden ? $eHeroWarden : $eHeroNone)
;~ 			Local $temp4 = (BitAND($g_aiAttackUseHeroes[$Battle], $eHeroChampion) = $eHeroChampion ? $eHeroChampion : $eHeroNone)
;~ 			If $g_hchkBattleKingAttack <> 0 Then $temp1 = (GUICtrlRead($g_hchkBattleKingAttack) = $GUI_CHECKED ? $eHeroKing : $eHeroNone)
;~ 			If $g_hchkBattleQueenAttack <> 0 Then $temp2 = (GUICtrlRead($g_hchkBattleQueenAttack) = $GUI_CHECKED ? $eHeroQueen : $eHeroNone)
;~ 			If $g_hchkBattleWardenAttack <> 0 Then $temp3 = (GUICtrlRead($g_hchkBattleWardenAttack) = $GUI_CHECKED ? $eHeroWarden : $eHeroNone)
;~ 			If $g_hchkBattleChampionAttack <> 0 Then $temp4 = (GUICtrlRead($g_hchkBattleChampionAttack) = $GUI_CHECKED ? $eHeroChampion : $eHeroNone)
;~ 			$g_aiAttackUseHeroes[$Battle] = BitOR(Int($temp1), Int($temp2), Int($temp3), Int($temp4))
;~ 			If $g_hchkBattleDropCC <> 0 Then
;~ 				GUICtrlSetState($g_hchkBattleDropCC, $g_abAttackDropCC[$Battle] ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 				chkBattleDropCC()
;~ 			EndIf
;~ 			If $g_hCmbDBWardenMode <> 0 Then _GUICtrlComboBox_SetCurSel($g_hCmbDBWardenMode, $g_aiAttackUseWardenMode[$Battle])
;~ 			If $g_hCmbDBSiege <> 0 Then _GUICtrlComboBox_SetCurSel($g_hCmbDBSiege, $g_aiAttackUseSiege[$Battle])
;~ 			If $g_hchkBattleDropEmptySiege <> 0 Then GUICtrlSetState($g_hchkBattleDropEmptySiege, $g_bDropEmptySiege[$Battle] ? $GUI_CHECKED : $GUI_UNCHECKED)

;~ 		Case "Save"
;~ 			If $g_hCmbDBAlgorithm <> 0 Then $g_aiAttackAlgorithm[$Battle] = _GUICtrlComboBox_GetCurSel($g_hCmbDBAlgorithm)
;~ 			If $g_hCmbDBSelectTroop <> 0 Then $g_aiAttackTroopSelection[$Battle] = _GUICtrlComboBox_GetCurSel($g_hCmbDBSelectTroop)
;~ 			Local $temp1 = (BitAND($g_aiAttackUseHeroes[$Battle], $eHeroKing) = $eHeroKing ? $eHeroKing : $eHeroNone)
;~ 			Local $temp2 = (BitAND($g_aiAttackUseHeroes[$Battle], $eHeroQueen) = $eHeroQueen ? $eHeroQueen : $eHeroNone)
;~ 			Local $temp3 = (BitAND($g_aiAttackUseHeroes[$Battle], $eHeroWarden) = $eHeroWarden ? $eHeroWarden : $eHeroNone)
;~ 			Local $temp4 = (BitAND($g_aiAttackUseHeroes[$Battle], $eHeroChampion) = $eHeroChampion ? $eHeroChampion : $eHeroNone)
;~ 			If $g_hchkBattleKingAttack <> 0 Then $temp1 = (GUICtrlRead($g_hchkBattleKingAttack) = $GUI_CHECKED ? $eHeroKing : $eHeroNone)
;~ 			If $g_hchkBattleQueenAttack <> 0 Then $temp2 = (GUICtrlRead($g_hchkBattleQueenAttack) = $GUI_CHECKED ? $eHeroQueen : $eHeroNone)
;~ 			If $g_hchkBattleWardenAttack <> 0 Then $temp3 = (GUICtrlRead($g_hchkBattleWardenAttack) = $GUI_CHECKED ? $eHeroWarden : $eHeroNone)
;~ 			If $g_hchkBattleChampionAttack <> 0 Then $temp4 = (GUICtrlRead($g_hchkBattleChampionAttack) = $GUI_CHECKED ? $eHeroChampion : $eHeroNone)
;~ 			$g_aiAttackUseHeroes[$Battle] = BitOR(Int($temp1), Int($temp2), Int($temp3), Int($temp4))
;~ 			If $g_hchkBattleDropCC <> 0 Then $g_abAttackDropCC[$Battle] = (GUICtrlRead($g_hchkBattleDropCC) = $GUI_CHECKED)

;~ 			If $g_hCmbDBWardenMode <> 0 Then
;~ 				Local $iDBWardenMode = _GUICtrlComboBox_GetCurSel($g_hCmbDBWardenMode)
;~ 				If $iDBWardenMode >= 0 Then $g_aiAttackUseWardenMode[$Battle] = $iDBWardenMode
;~ 			EndIf
;~ 			If $g_hCmbDBSiege <> 0 Then
;~ 				Local $iDBSiege = _GUICtrlComboBox_GetCurSel($g_hCmbDBSiege)
;~ 				If $iDBSiege >= 0 Then $g_aiAttackUseSiege[$Battle] = $iDBSiege
;~ 			EndIf
;~ 			If $g_hchkBattleDropEmptySiege <> 0 Then $g_bDropEmptySiege[$Battle] = (GUICtrlRead($g_hchkBattleDropEmptySiege) = $GUI_CHECKED)
;~ 	EndSwitch

;~ 	ApplyConfig_600_29_DB_Standard($TypeReadSave)
;~ 	ApplyConfig_600_29_DB_Scripted($TypeReadSave)
;~ 	ApplyConfig_600_29_DB_SmartFarm($TypeReadSave)
;~ EndFunc   ;==>ApplyConfig_600_29_DB

;~ Func ApplyConfig_600_29_DB_Standard($TypeReadSave)
;~ 	; <><><><> Attack Plan / Search & Attack / Deadbase / Attack / Standard <><><><>
;~ 	Switch $TypeReadSave
;~ 		Case "Read"
;~ 			_GUICtrlComboBox_SetCurSel($g_hCmbStandardDropOrderDB, $g_aiAttackStdDropOrder[$Battle])
;~ 			_GUICtrlComboBox_SetCurSel($g_hCmbStandardDropSidesDB, $g_aiAttackStdDropSides[$Battle])
;~ 			GUICtrlSetState($g_hChkSmartAttackRedAreaDB, $g_abAttackStdSmartAttack[$Battle] ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			chkSmartAttackRedAreaDB()
;~ 			_GUICtrlComboBox_SetCurSel($g_hCmbSmartDeployDB, $g_aiAttackStdSmartDeploy[$Battle])
;~ 			GUICtrlSetState($g_hChkAttackNearGoldMineDB, $g_abAttackStdSmartNearCollectors[$Battle][0] ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			GUICtrlSetState($g_hChkAttackNearElixirCollectorDB, $g_abAttackStdSmartNearCollectors[$Battle][1] ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			GUICtrlSetState($g_hChkAttackNearDarkElixirDrillDB, $g_abAttackStdSmartNearCollectors[$Battle][2] ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 		Case "Save"
;~ 			$g_aiAttackStdDropOrder[$Battle] = _GUICtrlComboBox_GetCurSel($g_hCmbStandardDropOrderDB)
;~ 			$g_aiAttackStdDropSides[$Battle] = _GUICtrlComboBox_GetCurSel($g_hCmbStandardDropSidesDB)
;~ 			$g_abAttackStdSmartAttack[$Battle] = (GUICtrlRead($g_hChkSmartAttackRedAreaDB) = $GUI_CHECKED)
;~ 			$g_aiAttackStdSmartDeploy[$Battle] = _GUICtrlComboBox_GetCurSel($g_hCmbSmartDeployDB)
;~ 			$g_abAttackStdSmartNearCollectors[$Battle][0] = (GUICtrlRead($g_hChkAttackNearGoldMineDB) = $GUI_CHECKED)
;~ 			$g_abAttackStdSmartNearCollectors[$Battle][1] = (GUICtrlRead($g_hChkAttackNearElixirCollectorDB) = $GUI_CHECKED)
;~ 			$g_abAttackStdSmartNearCollectors[$Battle][2] = (GUICtrlRead($g_hChkAttackNearDarkElixirDrillDB) = $GUI_CHECKED)

;~ 	EndSwitch
;~ EndFunc   ;==>ApplyConfig_600_29_DB_Standard

;~ Func ApplyConfig_600_29_DB_Scripted($TypeReadSave)
;~ 	; <><><><> Attack Plan / Search & Attack / Deadbase / Attack / Scripted <><><><>
;~ 	Switch $TypeReadSave
;~ 		Case "Read"
;~ 			_GUICtrlComboBox_SetCurSel($g_hCmbScriptRedlineImplBattle, $g_aiAttackScrRedlineRoutine[$Battle])
;~ 			_GUICtrlComboBox_SetCurSel($g_hCmbScriptDroplineDB, $g_aiAttackScrDroplineEdge[$Battle])
;~ 			PopulateComboScriptsFilesBattle()
;~ 			UpdateComboScriptNameRankedBattle()
;~ 			Local $tempindex = _GUICtrlComboBox_FindStringExact($g_hCmbScriptNameBattle, $g_sAttackScrScriptName[$Battle])
;~ 			If $tempindex = -1 Then
;~ 				$tempindex = 0
;~ 				SetLog("Previous saved Scripted Attack not found (deleted, renamed?)", $COLOR_ERROR)
;~ 				SetLog("Automatically setted a default script, please check your config", $COLOR_ERROR)
;~ 			EndIf
;~ 			_GUICtrlComboBox_SetCurSel($g_hCmbScriptNameBattle, $tempindex)
;~ 			cmbScriptNameBattle()
;~ 			cmbScriptRedlineImplDB()
;~ 		Case "Save"
;~ 			$g_aiAttackScrRedlineRoutine[$Battle] = _GUICtrlComboBox_GetCurSel($g_hCmbScriptRedlineImplBattle)
;~ 			$g_aiAttackScrDroplineEdge[$Battle] = _GUICtrlComboBox_GetCurSel($g_hCmbScriptDroplineDB)
;~ 			Local $indexofscript = _GUICtrlComboBox_GetCurSel($g_hCmbScriptNameBattle)
;~ 			Local $scriptname
;~ 			_GUICtrlComboBox_GetLBText($g_hCmbScriptNameBattle, $indexofscript, $scriptname)
;~ 			$g_sAttackScrScriptName[$Battle] = $scriptname
;~ 			IniWriteS($g_sProfileConfigPath, "attack", "ScriptBattle", $g_sAttackScrScriptName[$Battle])
;~ 			Local $indexRanked = _GUICtrlComboBox_GetCurSel($g_hCmbScriptNameRankedBattle)
;~ 			Local $rankedName
;~ 			_GUICtrlComboBox_GetLBText($g_hCmbScriptNameRankedBattle, $indexRanked, $rankedName)
;~ 			$g_sAttackScrScriptNameRankedBattle = $rankedName
;~ 			IniWriteS($g_sProfileConfigPath, "attack", "ScriptRanked", $g_sAttackScrScriptNameRankedBattle)
;~ 	EndSwitch
;~ EndFunc   ;==>ApplyConfig_600_29_DB_Scripted

;~ Func ApplyConfig_600_29_DB_SmartFarm($TypeReadSave)
;~ 	; <><><><> Attack Plan / Search & Attack / Deadbase / Attack / SmartFarm <><><><>
;~ 	Switch $TypeReadSave
;~ 		Case "Read"
;~ 			GUICtrlSetData($g_hTxtInsidePercentage, $g_iTxtInsidePercentage)
;~ 			GUICtrlSetData($g_hTxtOutsidePercentage, $g_iTxtOutsidePercentage)
;~ 			GUICtrlSetState($g_hChkDebugSmartFarm, $g_bDebugSmartFarm ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			GUICtrlSetData($g_hCmbMaxAttackSide, $g_iCmbMaxAttackSide)
;~ 		Case "Save"
;~ 			$g_iTxtInsidePercentage = GUICtrlRead($g_hTxtInsidePercentage)
;~ 			$g_iTxtOutsidePercentage = GUICtrlRead($g_hTxtOutsidePercentage)
;~ 			$g_bDebugSmartFarm = (GUICtrlRead($g_hChkDebugSmartFarm) = $GUI_CHECKED)
;~ 			$g_iCmbMaxAttackSide = GUICtrlRead($g_hCmbMaxAttackSide)
;~ 	EndSwitch
;~ EndFunc

;~ Func ApplyConfig_600_29_LB($TypeReadSave)
;~ 	; <><><><> Attack Plan / Search & Attack / Activebase / Attack <><><><>
;~ 	Switch $TypeReadSave
;~ 		Case "Read"
;~ 			If $g_hCmbABAlgorithm <> 0 Then
;~ 				_GUICtrlComboBox_SetCurSel($g_hCmbABAlgorithm, $g_aiAttackAlgorithm[$RankedBattle])
;~ 				cmbABAlgorithm()
;~ 			EndIf
;~ 			If $g_hCmbABSelectTroop <> 0 Then _GUICtrlComboBox_SetCurSel($g_hCmbABSelectTroop, $g_aiAttackTroopSelection[$RankedBattle])
;~ 			If $g_hchkRankedBattleKingAttack <> 0 Then GUICtrlSetState($g_hchkRankedBattleKingAttack, BitAND($g_aiAttackUseHeroes[$RankedBattle], $eHeroKing) = $eHeroKing ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			If $g_hchkRankedBattleQueenAttack <> 0 Then GUICtrlSetState($g_hchkRankedBattleQueenAttack, BitAND($g_aiAttackUseHeroes[$RankedBattle], $eHeroQueen) = $eHeroQueen ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			If $g_hchkRankedBattleWardenAttack <> 0 Then
;~ 				GUICtrlSetState($g_hchkRankedBattleWardenAttack, BitAND($g_aiAttackUseHeroes[$RankedBattle], $eHeroWarden) = $eHeroWarden ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 				chkRankedBattleWardenAttack()
;~ 			EndIf
;~ 			If $g_hchkRankedBattleChampionAttack <> 0 Then GUICtrlSetState($g_hchkRankedBattleChampionAttack, BitAND($g_aiAttackUseHeroes[$RankedBattle], $eHeroChampion) = $eHeroChampion ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			Local $temp1 = (BitAND($g_aiAttackUseHeroes[$RankedBattle], $eHeroKing) = $eHeroKing ? $eHeroKing : $eHeroNone)
;~ 			Local $temp2 = (BitAND($g_aiAttackUseHeroes[$RankedBattle], $eHeroQueen) = $eHeroQueen ? $eHeroQueen : $eHeroNone)
;~ 			Local $temp3 = (BitAND($g_aiAttackUseHeroes[$RankedBattle], $eHeroWarden) = $eHeroWarden ? $eHeroWarden : $eHeroNone)
;~ 			Local $temp4 = (BitAND($g_aiAttackUseHeroes[$RankedBattle], $eHeroChampion) = $eHeroChampion ? $eHeroChampion : $eHeroNone)
;~ 			If $g_hchkRankedBattleKingAttack <> 0 Then $temp1 = (GUICtrlRead($g_hchkRankedBattleKingAttack) = $GUI_CHECKED ? $eHeroKing : $eHeroNone)
;~ 			If $g_hchkRankedBattleQueenAttack <> 0 Then $temp2 = (GUICtrlRead($g_hchkRankedBattleQueenAttack) = $GUI_CHECKED ? $eHeroQueen : $eHeroNone)
;~ 			If $g_hchkRankedBattleWardenAttack <> 0 Then $temp3 = (GUICtrlRead($g_hchkRankedBattleWardenAttack) = $GUI_CHECKED ? $eHeroWarden : $eHeroNone)
;~ 			If $g_hchkRankedBattleChampionAttack <> 0 Then $temp4 = (GUICtrlRead($g_hchkRankedBattleChampionAttack) = $GUI_CHECKED ? $eHeroChampion : $eHeroNone)
;~ 			$g_aiAttackUseHeroes[$RankedBattle] = BitOR(Int($temp1), Int($temp2), Int($temp3), Int($temp4))
;~ 			If $g_hchkRankedBattleDropCC <> 0 Then
;~ 				GUICtrlSetState($g_hchkRankedBattleDropCC, $g_abAttackDropCC[$RankedBattle] ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 				chkRankedBattleDropCC()
;~ 			EndIf
;~ 			If $g_hCmbABWardenMode <> 0 Then _GUICtrlComboBox_SetCurSel($g_hCmbABWardenMode, $g_aiAttackUseWardenMode[$RankedBattle])
;~ 			If $g_hCmbABSiege <> 0 Then _GUICtrlComboBox_SetCurSel($g_hCmbABSiege, $g_aiAttackUseSiege[$RankedBattle])
;~ 			If $g_hchkRankedBattleDropEmptySiege <> 0 Then GUICtrlSetState($g_hchkRankedBattleDropEmptySiege, $g_bDropEmptySiege[$RankedBattle] ? $GUI_CHECKED : $GUI_UNCHECKED)

;~ 		Case "Save"
;~ 			If $g_hCmbABAlgorithm <> 0 Then $g_aiAttackAlgorithm[$RankedBattle] = _GUICtrlComboBox_GetCurSel($g_hCmbABAlgorithm)
;~ 			If $g_hCmbABSelectTroop <> 0 Then $g_aiAttackTroopSelection[$RankedBattle] = _GUICtrlComboBox_GetCurSel($g_hCmbABSelectTroop)
;~ 			Local $temp1 = (BitAND($g_aiAttackUseHeroes[$RankedBattle], $eHeroKing) = $eHeroKing ? $eHeroKing : $eHeroNone)
;~ 			Local $temp2 = (BitAND($g_aiAttackUseHeroes[$RankedBattle], $eHeroQueen) = $eHeroQueen ? $eHeroQueen : $eHeroNone)
;~ 			Local $temp3 = (BitAND($g_aiAttackUseHeroes[$RankedBattle], $eHeroWarden) = $eHeroWarden ? $eHeroWarden : $eHeroNone)
;~ 			Local $temp4 = (BitAND($g_aiAttackUseHeroes[$RankedBattle], $eHeroChampion) = $eHeroChampion ? $eHeroChampion : $eHeroNone)
;~ 			If $g_hchkRankedBattleKingAttack <> 0 Then $temp1 = (GUICtrlRead($g_hchkRankedBattleKingAttack) = $GUI_CHECKED ? $eHeroKing : $eHeroNone)
;~ 			If $g_hchkRankedBattleQueenAttack <> 0 Then $temp2 = (GUICtrlRead($g_hchkRankedBattleQueenAttack) = $GUI_CHECKED ? $eHeroQueen : $eHeroNone)
;~ 			If $g_hchkRankedBattleWardenAttack <> 0 Then $temp3 = (GUICtrlRead($g_hchkRankedBattleWardenAttack) = $GUI_CHECKED ? $eHeroWarden : $eHeroNone)
;~ 			If $g_hchkRankedBattleChampionAttack <> 0 Then $temp4 = (GUICtrlRead($g_hchkRankedBattleChampionAttack) = $GUI_CHECKED ? $eHeroChampion : $eHeroNone)
;~ 			$g_aiAttackUseHeroes[$RankedBattle] = BitOR(Int($temp1), Int($temp2), Int($temp3), Int($temp4))
;~ 			If $g_hchkRankedBattleDropCC <> 0 Then $g_abAttackDropCC[$RankedBattle] = (GUICtrlRead($g_hchkRankedBattleDropCC) = $GUI_CHECKED)

;~ 			If $g_hCmbABWardenMode <> 0 Then
;~ 				Local $iABWardenMode = _GUICtrlComboBox_GetCurSel($g_hCmbABWardenMode)
;~ 				If $iABWardenMode >= 0 Then $g_aiAttackUseWardenMode[$RankedBattle] = $iABWardenMode
;~ 			EndIf
;~ 			If $g_hCmbABSiege <> 0 Then
;~ 				Local $iABSiege = _GUICtrlComboBox_GetCurSel($g_hCmbABSiege)
;~ 				If $iABSiege >= 0 Then $g_aiAttackUseSiege[$RankedBattle] = $iABSiege
;~ 			EndIf
;~ 			If $g_hchkRankedBattleDropEmptySiege <> 0 Then $g_bDropEmptySiege[$RankedBattle] = (GUICtrlRead($g_hchkRankedBattleDropEmptySiege) = $GUI_CHECKED)
;~ 	EndSwitch

;~ 	ApplyConfig_600_29_LB_Standard($TypeReadSave)
;~ 	ApplyConfig_600_29_LB_Scripted($TypeReadSave)
;~ EndFunc   ;==>ApplyConfig_600_29_LB

;~ Func ApplyConfig_600_29_LB_Standard($TypeReadSave)
;~ 	; <><><><> Attack Plan / Search & Attack / Activebase / Attack / Standard <><><><>
;~ 	Switch $TypeReadSave
;~ 		Case "Read"
;~ 			_GUICtrlComboBox_SetCurSel($g_hCmbStandardDropOrderAB, $g_aiAttackStdDropOrder[$RankedBattle])
;~ 			_GUICtrlComboBox_SetCurSel($g_hCmbStandardDropSidesAB, $g_aiAttackStdDropSides[$RankedBattle])
;~ 			GUICtrlSetState($g_hChkSmartAttackRedAreaAB, $g_abAttackStdSmartAttack[$RankedBattle] ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			chkSmartAttackRedAreaAB()
;~ 			_GUICtrlComboBox_SetCurSel($g_hCmbSmartDeployAB, $g_aiAttackStdSmartDeploy[$RankedBattle])
;~ 			GUICtrlSetState($g_hChkAttackNearGoldMineAB, $g_abAttackStdSmartNearCollectors[$RankedBattle][0] ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			GUICtrlSetState($g_hChkAttackNearElixirCollectorAB, $g_abAttackStdSmartNearCollectors[$RankedBattle][1] ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			GUICtrlSetState($g_hChkAttackNearDarkElixirDrillAB, $g_abAttackStdSmartNearCollectors[$RankedBattle][2] ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 		Case "Save"
;~ 			$g_aiAttackStdDropOrder[$RankedBattle] = _GUICtrlComboBox_GetCurSel($g_hCmbStandardDropOrderAB)
;~ 			$g_aiAttackStdDropSides[$RankedBattle] = _GUICtrlComboBox_GetCurSel($g_hCmbStandardDropSidesAB)
;~ 			$g_abAttackStdSmartAttack[$RankedBattle] = (GUICtrlRead($g_hChkSmartAttackRedAreaAB) = $GUI_CHECKED)
;~ 			$g_aiAttackStdSmartDeploy[$RankedBattle] = _GUICtrlComboBox_GetCurSel($g_hCmbSmartDeployAB)
;~ 			$g_abAttackStdSmartNearCollectors[$RankedBattle][0] = (GUICtrlRead($g_hChkAttackNearGoldMineAB) = $GUI_CHECKED)
;~ 			$g_abAttackStdSmartNearCollectors[$RankedBattle][1] = (GUICtrlRead($g_hChkAttackNearElixirCollectorAB) = $GUI_CHECKED)
;~ 			$g_abAttackStdSmartNearCollectors[$RankedBattle][2] = (GUICtrlRead($g_hChkAttackNearDarkElixirDrillAB) = $GUI_CHECKED)
;~ 	EndSwitch
;~ EndFunc   ;==>ApplyConfig_600_29_LB_Standard

;~ Func ApplyConfig_600_29_LB_Scripted($TypeReadSave)
;~ 	; <><><><> Attack Plan / Search & Attack / Activebase / Attack / Scripted <><><><>
;~ 	Switch $TypeReadSave
;~ 		Case "Read"
;~ 			_GUICtrlComboBox_SetCurSel($g_hCmbScriptRedlineImplRankedBattle, $g_aiAttackScrRedlineRoutine[$RankedBattle])
;~ 			_GUICtrlComboBox_SetCurSel($g_hCmbScriptDroplineAB, $g_aiAttackScrDroplineEdge[$RankedBattle])
;~ 			PopulateComboScriptsFilesRankedBattle()
;~ 			UpdateComboScriptNameRankedBattle()
;~ 			Local $tempindex = _GUICtrlComboBox_FindStringExact($g_hCmbScriptNameRankedBattle, $g_sAttackScrScriptName[$RankedBattle])
;~ 			If $tempindex = -1 Then
;~ 				$tempindex = 0
;~ 				SetLog("Previous saved Scripted Attack not found (deleted, renamed?)", $COLOR_ERROR)
;~ 				SetLog("Automatically setted a default script, please check your config", $COLOR_ERROR)
;~ 			EndIf
;~ 			_GUICtrlComboBox_SetCurSel($g_hCmbScriptNameRankedBattle, $tempindex)
;~ 			cmbScriptNameRankedBattle()
;~ 			cmbScriptRedlineImplAB()
;~ 		Case "Save"
;~ 			$g_aiAttackScrRedlineRoutine[$RankedBattle] = _GUICtrlComboBox_GetCurSel($g_hCmbScriptRedlineImplRankedBattle)
;~ 			$g_aiAttackScrDroplineEdge[$RankedBattle] = _GUICtrlComboBox_GetCurSel($g_hCmbScriptDroplineAB)
;~ 			Local $indexofscript = _GUICtrlComboBox_GetCurSel($g_hCmbScriptNameRankedBattle)
;~ 			Local $scriptname
;~ 			_GUICtrlComboBox_GetLBText($g_hCmbScriptNameRankedBattle, $indexofscript, $scriptname)
;~ 			$g_sAttackScrScriptName[$RankedBattle] = $scriptname
;~ 			IniWriteS($g_sProfileConfigPath, "attack", "ScriptAB", $g_sAttackScrScriptName[$RankedBattle])
;~ 			Local $indexRanked = _GUICtrlComboBox_GetCurSel($g_hCmbScriptNameRankedBattle)
;~ 			Local $rankedName
;~ 			_GUICtrlComboBox_GetLBText($g_hCmbScriptNameRankedBattle, $indexRanked, $rankedName)
;~ 			$g_sAttackScrScriptNameRankedBattle = $rankedName
;~ 			IniWriteS($g_sProfileConfigPath, "attack", "ScriptRanked", $g_sAttackScrScriptNameRankedBattle)
;~ 	EndSwitch
;~ EndFunc   ;==>ApplyConfig_600_29_LB_Scripted

;~ Func ApplyConfig_600_30($TypeReadSave)
;~ 	; <><><><> Attack Plan / Search & Attack / Options / End Battle <><><><>
;~ 	Switch $TypeReadSave
;~ 		Case "Read"
;~ 			GUICtrlSetState($g_hChkShareAttack, $g_bShareAttackEnable ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			GUICtrlSetData($g_hTxtShareMinGold, $g_iShareMinGold)
;~ 			GUICtrlSetData($g_hTxtShareMinElixir, $g_iShareMinElixir)
;~ 			GUICtrlSetData($g_hTxtShareMinDark, $g_iShareMinDark)
;~ 			GUICtrlSetData($g_hTxtShareMessage, StringReplace($g_sShareMessage, "|", @CRLF))
;~ 			chkShareAttack()
;~ 			GUICtrlSetState($g_hChkTakeLootSS, $g_bTakeLootSnapShot ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			GUICtrlSetState($g_hChkScreenshotLootInfo, $g_bScreenshotLootInfo ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			chkTakeLootSS()
;~ 		Case "Save"
;~ 			$g_bShareAttackEnable = (GUICtrlRead($g_hChkShareAttack) = $GUI_CHECKED)
;~ 			$g_iShareMinGold = GUICtrlRead($g_hTxtShareMinGold)
;~ 			$g_iShareMinElixir = GUICtrlRead($g_hTxtShareMinElixir)
;~ 			$g_iShareMinDark = GUICtrlRead($g_hTxtShareMinDark)
;~ 			$g_sShareMessage = StringReplace(GUICtrlRead($g_hTxtShareMessage), @CRLF, "|")
;~ 			$g_bTakeLootSnapShot = (GUICtrlRead($g_hChkTakeLootSS) = $GUI_CHECKED)
;~ 			$g_bScreenshotLootInfo = (GUICtrlRead($g_hChkScreenshotLootInfo) = $GUI_CHECKED)
;~ 	EndSwitch
;~ EndFunc   ;==>ApplyConfig_600_30

;~ Func ApplyConfig_600_30_DB($TypeReadSave)
;~ 	; <><><><> Attack Plan / Search & Attack / Deadbase / End Battle <><><><>
;~ 	Switch $TypeReadSave
;~ 		Case "Read"
;~ 			GUICtrlSetState($g_hChkStopAtkDBNoLoot1, $g_abStopAtkNoLoot1Enable[$Battle] ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			GUICtrlSetData($g_hTxtStopAtkDBNoLoot1, $g_aiStopAtkNoLoot1Time[$Battle])
;~ 			chkStopAtkDBNoLoot1()
;~ 			GUICtrlSetState($g_hChkStopAtkDBNoLoot2, $g_abStopAtkNoLoot2Enable[$Battle] ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			GUICtrlSetData($g_hTxtStopAtkDBNoLoot2, $g_aiStopAtkNoLoot2Time[$Battle])
;~ 			chkStopAtkDBNoLoot2()
;~ 			GUICtrlSetData($g_hTxtDBMinGoldStopAtk2, $g_aiStopAtkNoLoot2MinGold[$Battle])
;~ 			GUICtrlSetData($g_hTxtDBMinElixirStopAtk2, $g_aiStopAtkNoLoot2MinElixir[$Battle])
;~ 			GUICtrlSetData($g_hTxtDBMinDarkElixirStopAtk2, $g_aiStopAtkNoLoot2MinDark[$Battle])
;~ 			GUICtrlSetState($g_hchkBattleEndNoResources, $g_abStopAtkNoResources[$Battle] ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			GUICtrlSetState($g_hchkBattleEndOneStar, $g_abStopAtkOneStar[$Battle] ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			GUICtrlSetState($g_hchkBattleEndTwoStars, $g_abStopAtkTwoStars[$Battle] ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			GUICtrlSetState($g_hchkBattleEndPercentHigher, $g_abStopAtkPctHigherEnable[$Battle] ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			GUICtrlSetData($g_hTxtDBPercentHigher, $g_aiStopAtkPctHigherAmt[$Battle])
;~ 			chkBattleEndPercentHigher()
;~ 			GUICtrlSetState($g_hchkBattleEndPercentChange, $g_abStopAtkPctNoChangeEnable[$Battle] ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			GUICtrlSetData($g_hTxtDBPercentChange, $g_aiStopAtkPctNoChangeTime[$Battle])
;~ 			chkBattleEndPercentChange()
;~ 		Case "Save"
;~ 			$g_abStopAtkNoLoot1Enable[$Battle] = (GUICtrlRead($g_hChkStopAtkDBNoLoot1) = $GUI_CHECKED)
;~ 			$g_aiStopAtkNoLoot1Time[$Battle] = Int(GUICtrlRead($g_hTxtStopAtkDBNoLoot1))
;~ 			$g_abStopAtkNoLoot2Enable[$Battle] = (GUICtrlRead($g_hChkStopAtkDBNoLoot2) = $GUI_CHECKED)
;~ 			$g_aiStopAtkNoLoot2Time[$Battle] = Int(GUICtrlRead($g_hTxtStopAtkDBNoLoot2))
;~ 			$g_aiStopAtkNoLoot2MinGold[$Battle] = Int(GUICtrlRead($g_hTxtDBMinGoldStopAtk2))
;~ 			$g_aiStopAtkNoLoot2MinElixir[$Battle] = Int(GUICtrlRead($g_hTxtDBMinElixirStopAtk2))
;~ 			$g_aiStopAtkNoLoot2MinDark[$Battle] = Int(GUICtrlRead($g_hTxtDBMinDarkElixirStopAtk2))
;~ 			$g_abStopAtkNoResources[$Battle] = (GUICtrlRead($g_hchkBattleEndNoResources) = $GUI_CHECKED)
;~ 			$g_abStopAtkOneStar[$Battle] = (GUICtrlRead($g_hchkBattleEndOneStar) = $GUI_CHECKED)
;~ 			$g_abStopAtkTwoStars[$Battle] = (GUICtrlRead($g_hchkBattleEndTwoStars) = $GUI_CHECKED)
;~ 			$g_abStopAtkPctHigherEnable[$Battle] = (GUICtrlRead($g_hchkBattleEndPercentHigher) = $GUI_CHECKED)
;~ 			$g_aiStopAtkPctHigherAmt[$Battle] = GUICtrlRead($g_hTxtDBPercentHigher)
;~ 			$g_abStopAtkPctNoChangeEnable[$Battle] = (GUICtrlRead($g_hchkBattleEndPercentChange) = $GUI_CHECKED)
;~ 			$g_aiStopAtkPctNoChangeTime[$Battle] = GUICtrlRead($g_hTxtDBPercentChange)
;~ 	EndSwitch
;~ EndFunc   ;==>ApplyConfig_600_30_DB

;~ Func ApplyConfig_600_30_LB($TypeReadSave)
;~ 	; <><><><> Attack Plan / Search & Attack / Activebase / End Battle <><><><>
;~ 	Switch $TypeReadSave
;~ 		Case "Read"
;~ 			GUICtrlSetState($g_hChkStopAtkABNoLoot1, $g_abStopAtkNoLoot1Enable[$RankedBattle] ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			GUICtrlSetData($g_hTxtStopAtkABNoLoot1, $g_aiStopAtkNoLoot1Time[$RankedBattle])
;~ 			chkStopAtkABNoLoot1()
;~ 			GUICtrlSetState($g_hChkStopAtkABNoLoot2, $g_abStopAtkNoLoot2Enable[$RankedBattle] ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			GUICtrlSetData($g_hTxtStopAtkABNoLoot2, $g_aiStopAtkNoLoot2Time[$RankedBattle])
;~ 			chkStopAtkABNoLoot2()
;~ 			GUICtrlSetData($g_hTxtABMinGoldStopAtk2, $g_aiStopAtkNoLoot2MinGold[$RankedBattle])
;~ 			GUICtrlSetData($g_hTxtABMinElixirStopAtk2, $g_aiStopAtkNoLoot2MinElixir[$RankedBattle])
;~ 			GUICtrlSetData($g_hTxtABMinDarkElixirStopAtk2, $g_aiStopAtkNoLoot2MinDark[$RankedBattle])
;~ 			GUICtrlSetState($g_hchkRankedBattleEndNoResources, $g_abStopAtkNoResources[$RankedBattle] ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			GUICtrlSetState($g_hchkRankedBattleEndOneStar, $g_abStopAtkOneStar[$RankedBattle] ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			GUICtrlSetState($g_hchkRankedBattleEndTwoStars, $g_abStopAtkTwoStars[$RankedBattle] ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			GUICtrlSetState($g_hChkDESideEB, $g_bDESideEndEnable ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			chkDESideEB()
;~ 			GUICtrlSetData($g_hTxtDELowEndMin, $g_iDESideEndMin)
;~ 			GUICtrlSetState($g_hChkDisableOtherEBO, $g_bDESideDisableOther ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			GUICtrlSetState($g_hChkDEEndBk, $g_bDESideEndBKWeak ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			GUICtrlSetState($g_hChkDEEndAq, $g_bDESideEndAQWeak ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			GUICtrlSetState($g_hChkDEEndOneStar, $g_bDESideEndOneStar ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			GUICtrlSetState($g_hchkRankedBattleEndPercentHigher, $g_abStopAtkPctHigherEnable[$RankedBattle] ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			GUICtrlSetData($g_hTxtABPercentHigher, $g_aiStopAtkPctHigherAmt[$RankedBattle])
;~ 			chkRankedBattleEndPercentHigher()
;~ 			GUICtrlSetState($g_hchkRankedBattleEndPercentChange, $g_abStopAtkPctNoChangeEnable[$RankedBattle] ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			GUICtrlSetData($g_hTxtABPercentChange, $g_aiStopAtkPctNoChangeTime[$RankedBattle])
;~ 			chkRankedBattleEndPercentChange()
;~ 		Case "Save"
;~ 			$g_abStopAtkNoLoot1Enable[$RankedBattle] = (GUICtrlRead($g_hChkStopAtkABNoLoot1) = $GUI_CHECKED)
;~ 			$g_aiStopAtkNoLoot1Time[$RankedBattle] = Int(GUICtrlRead($g_hTxtStopAtkABNoLoot1))
;~ 			$g_abStopAtkNoLoot2Enable[$RankedBattle] = (GUICtrlRead($g_hChkStopAtkABNoLoot2) = $GUI_CHECKED)
;~ 			$g_aiStopAtkNoLoot2Time[$RankedBattle] = (GUICtrlRead($g_hTxtStopAtkABNoLoot2))
;~ 			$g_aiStopAtkNoLoot2MinGold[$RankedBattle] = Int(GUICtrlRead($g_hTxtABMinGoldStopAtk2))
;~ 			$g_aiStopAtkNoLoot2MinElixir[$RankedBattle] = Int(GUICtrlRead($g_hTxtABMinElixirStopAtk2))
;~ 			$g_aiStopAtkNoLoot2MinDark[$RankedBattle] = Int(GUICtrlRead($g_hTxtABMinDarkElixirStopAtk2))
;~ 			$g_abStopAtkNoResources[$RankedBattle] = (GUICtrlRead($g_hchkRankedBattleEndNoResources) = $GUI_CHECKED)
;~ 			$g_abStopAtkOneStar[$RankedBattle] = (GUICtrlRead($g_hchkRankedBattleEndOneStar) = $GUI_CHECKED)
;~ 			$g_abStopAtkTwoStars[$RankedBattle] = (GUICtrlRead($g_hchkRankedBattleEndTwoStars) = $GUI_CHECKED)
;~ 			$g_bDESideEndEnable = (GUICtrlRead($g_hChkDESideEB) = $GUI_CHECKED)
;~ 			$g_iDESideEndMin = GUICtrlRead($g_hTxtDELowEndMin)
;~ 			$g_bDESideDisableOther = (GUICtrlRead($g_hChkDisableOtherEBO) = $GUI_CHECKED)
;~ 			$g_bDESideEndAQWeak = (GUICtrlRead($g_hChkDEEndAq) = $GUI_CHECKED)
;~ 			$g_bDESideEndBKWeak = (GUICtrlRead($g_hChkDEEndBk) = $GUI_CHECKED)
;~ 			$g_bDESideEndOneStar = (GUICtrlRead($g_hChkDEEndOneStar) = $GUI_CHECKED)
;~ 			$g_abStopAtkPctHigherEnable[$RankedBattle] = (GUICtrlRead($g_hchkRankedBattleEndPercentHigher) = $GUI_CHECKED)
;~ 			$g_aiStopAtkPctHigherAmt[$RankedBattle] = GUICtrlRead($g_hTxtABPercentHigher)
;~ 			$g_abStopAtkPctNoChangeEnable[$RankedBattle] = (GUICtrlRead($g_hchkRankedBattleEndPercentChange) = $GUI_CHECKED)
;~ 			$g_aiStopAtkPctNoChangeTime[$RankedBattle] = GUICtrlRead($g_hTxtABPercentChange)
;~ 	EndSwitch
;~ EndFunc   ;==>ApplyConfig_600_30_LB

;~ Func ApplyConfig_600_31($TypeReadSave)
;~ 	; <><><><> Attack Plan / Search & Attack / Deadbase / Collectors <><><><>
;~ 	Switch $TypeReadSave
;~ 		Case "Read"
;~ 			For $i = 6 To 14
;~ 				GUICtrlSetState($g_ahchkBattleCollectorLevel[$i], $g_abCollectorLevelEnabled[$i] ? $GUI_CHECKED : $GUI_UNCHECKED)
;~                 GUICtrlSetState($g_ahCmbDBCollectorLevel[$i], $g_abCollectorLevelEnabled[$i] ? $GUI_ENABLE : $GUI_DISABLE)
;~ 				_GUICtrlComboBox_SetCurSel($g_ahCmbDBCollectorLevel[$i], $g_aiCollectorLevelFill[$i])
;~ 			Next
;~ 			GUICtrlSetState($g_hchkBattleDisableCollectorsFilter, $g_bCollectorFilterDisable ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			_GUICtrlComboBox_SetCurSel($g_hCmbMinCollectorMatches, $g_iCollectorMatchesMin - 1)
;~ 			GUICtrlSetData($g_hSldCollectorTolerance, $g_iCollectorToleranceOffset)
;~ 			checkCollectors()
;~ 		Case "Save"
;~ 			For $i = 6 To 14
;~ 				$g_abCollectorLevelEnabled[$i] = (GUICtrlRead($g_ahchkBattleCollectorLevel[$i]) = $GUI_CHECKED)
;~ 				$g_aiCollectorLevelFill[$i] = _GUICtrlComboBox_GetCurSel($g_ahCmbDBCollectorLevel[$i])
;~ 			Next
;~ 			$g_bCollectorFilterDisable = (GUICtrlRead($g_hchkBattleDisableCollectorsFilter) = $GUI_CHECKED)
;~ 			$g_iCollectorMatchesMin = _GUICtrlComboBox_GetCurSel($g_hCmbMinCollectorMatches) + 1
;~ 			$g_iCollectorToleranceOffset = GUICtrlRead($g_hSldCollectorTolerance)
;~ 	EndSwitch
;~ EndFunc   ;==>ApplyConfig_600_31

;~ Func ApplyConfig_600_33($TypeReadSave)
;~ 	; <><><><> Attack Plan / Search & Attack / Drop Order Troops <><><><>
;~ 	Switch $TypeReadSave
;~ 		Case "Read"
;~ 			GUICtrlSetState($g_hChkCustomDropOrderEnable, $g_bCustomDropOrderEnable ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			chkDropOrder()
;~ 			For $p = 0 To UBound($g_ahCmbDropOrder) - 1
;~ 				_GUICtrlComboBox_SetCurSel($g_ahCmbDropOrder[$p], $g_aiCmbCustomDropOrder[$p])
;~ 				_GUICtrlSetImage($g_ahImgDropOrder[$p], $g_sLibIconPath, $g_aiDropOrderIcon[$g_aiCmbCustomDropOrder[$p] + 1])
;~ 			Next
;~ 			If $g_bCustomDropOrderEnable Then ; only update troop train order if enabled
;~ 				If Not ChangeDropOrder() Then ; process error
;~ 					SetDefaultDropOrderGroup()
;~ 					GUICtrlSetState($g_hChkCustomDropOrderEnable, $GUI_UNCHECKED)
;~ 					$g_bCustomDropOrderEnable = False
;~ 					GUICtrlSetState($g_hBtnDropOrderSet, $GUI_DISABLE) ; disable button
;~ 					GUICtrlSetState($g_hBtnRemoveDropOrder, $GUI_DISABLE)
;~ 					For $i = 0 To UBound($g_ahCmbDropOrder) - 1
;~ 						GUICtrlSetState($g_ahCmbDropOrder[$i], $GUI_DISABLE) ; disable combo boxes
;~ 					Next
;~ 				EndIf
;~ 			EndIf
;~ 			GUICtrlSetState($g_hChkForceEdgeSmartfarm, $g_bChkForceEdgeSmartfarm ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 		Case "Save"
;~ 			$g_bCustomDropOrderEnable = (GUICtrlRead($g_hChkCustomDropOrderEnable) = $GUI_CHECKED)
;~ 			$g_bChkForceEdgeSmartfarm = (GUICtrlRead($g_hChkForceEdgeSmartfarm) = $GUI_CHECKED)
;~ 			For $p = 0 To UBound($g_ahCmbDropOrder) - 1
;~ 				$g_aiCmbCustomDropOrder[$p] = _GUICtrlComboBox_GetCurSel($g_ahCmbDropOrder[$p])
;~ 			Next
;~ 	EndSwitch
;~ EndFunc   ;==>ApplyConfig_600_33

Func ApplyConfig_600_35_1($TypeReadSave)
	; <><><><> Bot / Options <><><><>
	Switch $TypeReadSave
		Case "Read"
			LoadLanguagesComboBox() ; recreate combo box values
			GUICtrlSetState($g_hChkDisableSplash, $g_bDisableSplash ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkForMBRUpdates, $g_bCheckVersion ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkDeleteLogs, $g_bDeleteLogs ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($g_hTxtDeleteLogsDays, $g_iDeleteLogsDays)
			chkDeleteLogs()
			GUICtrlSetState($g_hChkDeleteTemp, $g_bDeleteTemp ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($g_hTxtDeleteTempDays, $g_iDeleteTempDays)
			chkDeleteTemp()
			GUICtrlSetState($g_hChkDeleteLoots, $g_bDeleteLoots ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($g_hTxtDeleteLootsDays, $g_iDeleteLootsDays)
			chkDeleteLoots()
			GUICtrlSetState($g_hChkAutostart, $g_bAutoStart ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($g_hTxtAutostartDelay, $g_iAutoStartDelay)
			chkAutoStart()
			GUICtrlSetState($g_hChkAutoAlign, $g_bAutoAlignEnable ? $GUI_CHECKED : $GUI_UNCHECKED)
			chkDisposeWindows()
			_GUICtrlComboBox_SetCurSel($g_hCmbAlignmentOptions, $g_iAutoAlignPosition)
			GUICtrlSetData($g_hTxtAlignOffsetX, $g_iAutoAlignOffsetX)
			GUICtrlSetData($g_hTxtAlignOffsetY, $g_iAutoAlignOffsetY)
			;GUICtrlSetState($g_hChkUpdatingWhenMinimized, $g_bUpdatingWhenMinimized ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkBotCustomTitleBarClick, ((BitAND($g_iBotDesignFlags, 1)) ? ($GUI_CHECKED) : ($GUI_UNCHECKED)))
			GUICtrlSetState($g_hChkBotAutoSlideClick, ((BitAND($g_iBotDesignFlags, 2)) ? ($GUI_CHECKED) : ($GUI_UNCHECKED)))
			GUICtrlSetState($g_hChkHideWhenMinimized, $g_bHideWhenMinimized ? $GUI_CHECKED : $GUI_UNCHECKED)
			TrayItemSetState($g_hTiHide, $g_bHideWhenMinimized ? $TRAY_CHECKED : $TRAY_UNCHECKED)
			GUICtrlSetState($g_hChkUseRandomClick, $g_bUseRandomClick ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkScreenshotType, $g_bScreenshotPNGFormat ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkScreenshotHideName, $g_bScreenshotHideName ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($g_hTxtTimeAnotherDevice, Int(Int($g_iAnotherDeviceWaitTime) / 60))
			GUICtrlSetState($g_hChkSwitchOnAnotherDevice, $g_bChkSwitchOnAnotherDevice ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkSinglePBTForced, $g_bForceSinglePBLogoff ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($g_hTxtSinglePBTimeForced, $g_iSinglePBForcedLogoffTime)
			GUICtrlSetData($g_hTxtPBTimeForcedExit, $g_iSinglePBForcedEarlyExitTime)
			chkSinglePBTForced()
			GUICtrlSetState($g_hChkAutoResume, $g_bAutoResumeEnable ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetData($g_hTxtAutoResumeTime, $g_iAutoResumeTime)
			chkAutoResume()
			GUICtrlSetState($g_hChkDisableNotifications, $g_bDisableNotifications ? $GUI_CHECKED : $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkSqlite, $g_bUseStatistics ? $GUI_CHECKED : $GUI_UNCHECKED)

		Case "Save"
			$g_bDisableSplash = (GUICtrlRead($g_hChkDisableSplash) = $GUI_CHECKED)
			$g_bCheckVersion = (GUICtrlRead($g_hChkForMBRUpdates) = $GUI_CHECKED)
			$g_bDeleteLogs = (GUICtrlRead($g_hChkDeleteLogs) = $GUI_CHECKED)
			$g_iDeleteLogsDays = GUICtrlRead($g_hTxtDeleteLogsDays)
			$g_bDeleteTemp = (GUICtrlRead($g_hChkDeleteTemp) = $GUI_CHECKED)
			$g_iDeleteTempDays = GUICtrlRead($g_hTxtDeleteTempDays)
			$g_bDeleteLoots = (GUICtrlRead($g_hChkDeleteLoots) = $GUI_CHECKED)
			$g_iDeleteLootsDays = GUICtrlRead($g_hTxtDeleteLootsDays)
			$g_bAutoStart = (GUICtrlRead($g_hChkAutostart) = $GUI_CHECKED)
			$g_iAutoStartDelay = GUICtrlRead($g_hTxtAutostartDelay)
			$g_bAutoAlignEnable = (GUICtrlRead($g_hChkAutoAlign) = $GUI_CHECKED)
			$g_iAutoAlignPosition = _GUICtrlComboBox_GetCurSel($g_hCmbAlignmentOptions)
			$g_iAutoAlignOffsetX = GUICtrlRead($g_hTxtAlignOffsetX)
			$g_iAutoAlignOffsetY = GUICtrlRead($g_hTxtAlignOffsetY)
			;$g_bUpdatingWhenMinimized = GUICtrlRead($g_hChkUpdatingWhenMinimized) = $GUI_CHECKED ? 1 : 0 ; disabled as is must be always on
			$g_iBotDesignFlags = BitOR(BitAND($g_iBotDesignFlags, BitNOT(1)), ((GUICtrlRead($g_hChkBotCustomTitleBarClick) = $GUI_CHECKED) ? (1) : (0)))
			$g_iBotDesignFlags = BitOR(BitAND($g_iBotDesignFlags, BitNOT(2)), ((GUICtrlRead($g_hChkBotAutoSlideClick) = $GUI_CHECKED) ? (2) : (0)))
			$g_bHideWhenMinimized = (GUICtrlRead($g_hChkHideWhenMinimized) = $GUI_CHECKED)

			$g_bUseRandomClick = (GUICtrlRead($g_hChkUseRandomClick) = $GUI_CHECKED)
			$g_bScreenshotPNGFormat = (GUICtrlRead($g_hChkScreenshotType) = $GUI_CHECKED)
			$g_bScreenshotHideName = (GUICtrlRead($g_hChkScreenshotHideName) = $GUI_CHECKED)
			$g_iAnotherDeviceWaitTime = Int(GUICtrlRead($g_hTxtTimeAnotherDevice)) * 60 ; Minutes are entered
			$g_bChkSwitchOnAnotherDevice = (GUICtrlRead($g_hChkSwitchOnAnotherDevice) = $GUI_CHECKED)
			$g_bForceSinglePBLogoff = (GUICtrlRead($g_hChkSinglePBTForced) = $GUI_CHECKED)
			$g_iSinglePBForcedLogoffTime = GUICtrlRead($g_hTxtSinglePBTimeForced)
			$g_iSinglePBForcedEarlyExitTime = GUICtrlRead($g_hTxtPBTimeForcedExit)
			$g_bAutoResumeEnable = (GUICtrlRead($g_hChkAutoResume) = $GUI_CHECKED)
			$g_iAutoResumeTime = GUICtrlRead($g_hTxtAutoResumeTime)
			$g_bDisableNotifications = (GUICtrlRead($g_hChkDisableNotifications) = $GUI_CHECKED)
			$g_bUseStatistics = (GUICtrlRead($g_hChkSqlite) = $GUI_CHECKED)

	EndSwitch
EndFunc   ;==>ApplyConfig_600_35_1

Func ApplyConfig_600_35_2($TypeReadSave)
	; <><><><> Bot / Profile / Switch Account <><><><>
	Switch $TypeReadSave
		Case "Read"
			_GUICtrlComboBox_SetCurSel($g_hCmbSwitchAcc, $g_iCmbSwitchAcc)
			GUICtrlSetState($g_hChkSwitchAcc, $g_bChkSwitchAcc ? $GUI_CHECKED : $GUI_UNCHECKED)
			If $g_bChkSuperCellID Then GUICtrlSetState($g_hRadSwitchSuperCellID, $GUI_CHECKED)
			If $g_bChkSharedPrefs Then GUICtrlSetState($g_hRadSwitchSharedPrefs, $GUI_CHECKED)
			_GUICtrlComboBox_SetCurSel($g_hCmbTotalAccount, $g_iTotalAcc - 1)
			For $i = 0 To UBound($g_abAccountNo) - 1
				GUICtrlSetState($g_ahChkAccount[$i], $g_abAccountNo[$i] ? $GUI_CHECKED : $GUI_UNCHECKED)
				_GUICtrlComboBox_SetCurSel($g_ahCmbProfile[$i], _GUICtrlComboBox_FindStringExact($g_ahCmbProfile[$i], $g_asProfileName[$i]))
				GUICtrlSetState($g_ahChkDonate[$i], $g_abDonateOnly[$i] ? $GUI_CHECKED : $GUI_UNCHECKED)
			Next
			_cmbSwitchAcc(False)

		Case "Save"
			$g_iCmbSwitchAcc = _GUICtrlComboBox_GetCurSel($g_hCmbSwitchAcc)
			$g_bChkSwitchAcc = (GUICtrlRead($g_hChkSwitchAcc) = $GUI_CHECKED)
			$g_bChkSuperCellID = (GUICtrlRead($g_hRadSwitchSuperCellID) = $GUI_CHECKED)
			$g_bChkSharedPrefs = (GUICtrlRead($g_hRadSwitchSharedPrefs) = $GUI_CHECKED)
			$g_iTotalAcc = _GUICtrlComboBox_GetCurSel($g_hCmbTotalAccount) + 1 ; at least 2 accounts needed
			For $i = 0 To UBound($g_abAccountNo) - 1
				$g_abAccountNo[$i] = (GUICtrlRead($g_ahChkAccount[$i]) = $GUI_CHECKED)
				$g_asProfileName[$i] = GUICtrlRead($g_ahCmbProfile[$i])
				$g_abDonateOnly[$i] = (GUICtrlRead($g_ahChkDonate[$i]) = $GUI_CHECKED)
			Next
	EndSwitch
EndFunc   ;==>ApplyConfig_600_35_2

;~ Func ApplyConfig_600_52_2($TypeReadSave)
;~ 	; troop/spell levels and counts
;~ 	Switch $TypeReadSave
;~ 		Case "Read"
;~ 			For $T = 0 To $eTroopCount - 1
;~ 				GUICtrlSetData($g_ahTxtTrainArmyTroopCount[$T], $g_aiArmyCustomTroops[$T])
;~ 			Next
;~ 			For $S = 0 To $eSpellCount - 1
;~ 				GUICtrlSetData($g_ahTxtTrainArmySpellCount[$S], $g_aiArmyCustomSpells[$S])
;~ 			Next
;~ 			For $S = 0 To $eSiegeMachineCount - 1
;~ 				GUICtrlSetData($g_ahTxtTrainArmySiegeCount[$S], $g_aiArmyCustomSiegeMachines[$S])
;~ 			Next
;~ 			; full & forced Total Camp values
;~ 			GUICtrlSetData($g_hTxtFullTroop, $g_iTrainArmyFullTroopPct)
;~ 			GUICtrlSetData($g_hTxtTotalCampForced, $g_iTotalCampForcedValue)
;~ 			; spell capacity and forced flag
;~ 			GUICtrlSetData($g_hTxtTotalCountSpell, $g_iTotalSpellValue)
;~ 			; DoubleTrain - Demen
;~ 			GUICtrlSetState($g_hChkDoubleTrain, $g_bDoubleTrain ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			GUICtrlSetState($g_hChkPreciseArmy, $g_bPreciseArmy ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 		Case "Save"
;~ 			; troop/spell levels and counts
;~ 			For $T = 0 To $eTroopCount - 1
;~ 				$g_aiArmyCustomTroops[$T] = GUICtrlRead($g_ahTxtTrainArmyTroopCount[$T])
;~ 			Next
;~ 			For $S = 0 To $eSpellCount - 1
;~ 				$g_aiArmyCustomSpells[$S] = GUICtrlRead($g_ahTxtTrainArmySpellCount[$S])
;~ 			Next
;~ 			For $S = 0 To $eSiegeMachineCount - 1
;~ 				$g_aiArmyCustomSiegeMachines[$S] = GUICtrlRead($g_ahTxtTrainArmySiegeCount[$S])
;~ 			Next
;~ 			; full & forced Total Camp values
;~ 			$g_iTrainArmyFullTroopPct = Int(GUICtrlRead($g_hTxtFullTroop))
;~ 			$g_iTotalCampForcedValue = Int(GUICtrlRead($g_hTxtTotalCampForced))
;~ 			; spell capacity and forced flag
;~ 			$g_iTotalSpellValue = GUICtrlRead($g_hTxtTotalCountSpell)
;~ 			; DoubleTrain - Demen
;~ 			$g_bDoubleTrain = (GUICtrlRead($g_hChkDoubleTrain) = $GUI_CHECKED)
;~ 			$g_bPreciseArmy = (GUICtrlRead($g_hChkPreciseArmy) = $GUI_CHECKED)
;~ 			chkOnDoubleTrain()
;~ 	EndSwitch
;~ EndFunc   ;==>ApplyConfig_600_52_2

;~ Func ApplyConfig_600_54($TypeReadSave)
;~ 	; <><><> Attack Plan / Train Army / Train Order <><><>
;~ 	Switch $TypeReadSave
;~ 		Case "Read"
;~ 			; Troops Order
;~ 			GUICtrlSetState($g_hChkCustomTrainOrderEnable, $g_bCustomTrainOrderEnable ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			chkTroopOrder()
;~ 			For $z = 0 To UBound($g_ahCmbTroopOrder) - 1
;~ 				_GUICtrlComboBox_SetCurSel($g_ahCmbTroopOrder[$z], $g_aiCmbCustomTrainOrder[$z])
;~ 				_GUICtrlSetImage($g_ahImgTroopOrder[$z], $g_sLibIconPath, $g_aiTroopOrderIcon[$g_aiCmbCustomTrainOrder[$z] + 1])
;~ 			Next
;~ 			If $g_bCustomTrainOrderEnable Then ; only update troop train order if enabled
;~ 				If Not ChangeTroopTrainOrder() Then ; process error
;~ 					SetDefaultTroopGroup()
;~ 					GUICtrlSetState($g_hChkCustomTrainOrderEnable, $GUI_UNCHECKED)
;~ 					$g_bCustomTrainOrderEnable = False
;~ 					GUICtrlSetState($g_hBtnTroopOrderSet, $GUI_DISABLE) ; disable button
;~ 					GUICtrlSetState($g_hBtnRemoveTroops, $GUI_DISABLE)
;~ 					For $i = 0 To UBound($g_ahCmbTroopOrder) - 1
;~ 						GUICtrlSetState($g_ahCmbTroopOrder[$i], $GUI_DISABLE) ; disable combo boxes
;~ 					Next
;~ 				EndIf
;~ 			EndIf
;~ 			; Spells Order
;~ 			GUICtrlSetState($g_hChkCustomBrewOrderEnable, $g_bCustomBrewOrderEnable ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			chkSpellsOrder()
;~ 			For $z = 0 To UBound($g_ahCmbSpellsOrder) - 1
;~ 				_GUICtrlComboBox_SetCurSel($g_ahCmbSpellsOrder[$z], $g_aiCmbCustomBrewOrder[$z])
;~ 				_GUICtrlSetImage($g_ahImgSpellsOrder[$z], $g_sLibIconPath, $g_aiSpellsOrderIcon[$g_aiCmbCustomBrewOrder[$z] + 1])
;~ 			Next
;~ 			If $g_bCustomBrewOrderEnable Then ; only update troop train order if enabled
;~ 				If Not ChangeSpellsBrewOrder() Then ; process error
;~ 					SetDefaultSpellsGroup()
;~ 					GUICtrlSetState($g_hChkCustomBrewOrderEnable, $GUI_UNCHECKED)
;~ 					$g_bCustomBrewOrderEnable = False
;~ 					GUICtrlSetState($g_hBtnRemoveSpells, $GUI_DISABLE) ; disable button
;~ 					GUICtrlSetState($g_hBtnSpellsOrderSet, $GUI_DISABLE)
;~ 					For $i = 0 To UBound($g_ahCmbSpellsOrder) - 1
;~ 						GUICtrlSetState($g_ahCmbSpellsOrder[$i], $GUI_DISABLE) ; disable combo boxes
;~ 					Next
;~ 				EndIf
;~ 			EndIf

;~ 			;chkTotalCampForced()
;~ 			SetComboTroopComp() ; this function also calls lblTotalCount
;~ 		Case "Save"
;~ 			; Troops Order
;~ 			$g_bCustomTrainOrderEnable = (GUICtrlRead($g_hChkCustomTrainOrderEnable) = $GUI_CHECKED)
;~ 			For $z = 0 To UBound($g_ahCmbTroopOrder) - 1
;~ 				$g_aiCmbCustomTrainOrder[$z] = _GUICtrlComboBox_GetCurSel($g_ahCmbTroopOrder[$z])
;~ 			Next
;~ 			; Spells Order
;~ 			$g_bCustomBrewOrderEnable = (GUICtrlRead($g_hChkCustomBrewOrderEnable) = $GUI_CHECKED)
;~ 			For $z = 0 To UBound($g_ahCmbSpellsOrder) - 1
;~ 				$g_aiCmbCustomBrewOrder[$z] = _GUICtrlComboBox_GetCurSel($g_ahCmbSpellsOrder[$z])
;~ 			Next
;~ 	EndSwitch
;~ EndFunc   ;==>ApplyConfig_600_54

;~ Func ApplyConfig_600_56($TypeReadSave)
;~ 	; <><><><> Attack Plan / Search & Attack / Options / SmartZap <><><><>
;~ 	Switch $TypeReadSave
;~ 		Case "Read"
;~ 			GUICtrlSetState($g_hChkSmartLightSpell, $g_bSmartZapEnable ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			GUICtrlSetState($g_hChkSmartEQSpell, $g_bEarthQuakeZap = True ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			GUICtrlSetState($g_hChkNoobZap, $g_bNoobZap = True ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			GUICtrlSetState($g_hChkSmartZapDB, $g_bSmartZapDB = True ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			GUICtrlSetState($g_hChkSmartZapSaveHeroes, $g_bSmartZapSaveHeroes = True ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			GUICtrlSetState($g_hChkSmartZapFTW, $g_bSmartZapFTW = True ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			GUICtrlSetData($g_hTxtSmartZapMinDE, $g_iSmartZapMinDE)
;~ 			GUICtrlSetData($g_hTxtSmartExpectedDE, $g_iSmartZapExpectedDE)
;~ 			GUICtrlSetState($g_hEarlyZap, $g_bEarlyZap = True ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			chkSmartLightSpell()
;~ 			#CS
;~ 				GUICtrlSetState($g_hChkSmartZapDB, $g_bSmartZapEnable = True ? $GUI_ENABLE : $GUI_DISABLE)
;~ 				GUICtrlSetState($g_hTxtSmartZapMinDE, $g_bSmartZapEnable = True ? $GUI_ENABLE : $GUI_DISABLE)
;~ 				GUICtrlSetState($g_hChkNoobZap, $g_bSmartZapEnable = True ? $GUI_ENABLE : $GUI_DISABLE)
;~ 				GUICtrlSetState($g_hChkSmartZapSaveHeroes, $g_bSmartZapEnable = True ? $GUI_ENABLE : $GUI_DISABLE)
;~ 				GUICtrlSetState($g_hTxtSmartExpectedDE, $g_bNoobZap = True ? $GUI_ENABLE : $GUI_DISABLE)
;~ 			#CE
;~ 		Case "Save"
;~ 			$g_bSmartZapEnable = (GUICtrlRead($g_hChkSmartLightSpell) = $GUI_CHECKED)
;~ 			$g_bEarthQuakeZap = (GUICtrlRead($g_hChkSmartEQSpell) = $GUI_CHECKED)
;~ 			$g_bNoobZap = (GUICtrlRead($g_hChkNoobZap) = $GUI_CHECKED)
;~ 			$g_bSmartZapDB = (GUICtrlRead($g_hChkSmartZapDB) = $GUI_CHECKED)
;~ 			$g_bSmartZapSaveHeroes = (GUICtrlRead($g_hChkSmartZapSaveHeroes) = $GUI_CHECKED)
;~ 			$g_bSmartZapFTW = (GUICtrlRead($g_hChkSmartZapFTW) = $GUI_CHECKED)
;~ 			$g_iSmartZapMinDE = Int(GUICtrlRead($g_hTxtSmartZapMinDE))
;~ 			$g_iSmartZapExpectedDE = Int(GUICtrlRead($g_hTxtSmartExpectedDE))
;~ 			$g_bEarlyZap = (GUICtrlRead($g_hEarlyZap) = $GUI_CHECKED)
;~ 	EndSwitch
;~ EndFunc   ;==>ApplyConfig_600_56

;~ Func ApplyConfig_641_1($TypeReadSave)
;~ 	; <><><> Attack Plan / Train Army / Options <><><>
;~ 	Switch $TypeReadSave
;~ 		Case "Read"
;~ 			; Train click timing
;~ 			GUICtrlSetData($g_hSldTrainITDelay, $g_iTrainClickDelay)
;~ 			sldTrainITDelay()
;~ 			GUICtrlSetData($g_hLblTrainITDelayTime, $g_iTrainClickDelay & " ms")
;~ 			; Training add random delay
;~ 			GUICtrlSetState($g_hChkTrainAddRandomDelayEnable, $g_bTrainAddRandomDelayEnable ? $GUI_CHECKED : $GUI_UNCHECKED)
;~ 			GUICtrlSetData($g_hTxtAddRandomDelayMin, $g_iTrainAddRandomDelayMin)
;~ 			GUICtrlSetData($g_hTxtAddRandomDelayMax, $g_iTrainAddRandomDelayMax)
;~ 			chkAddDelayIdlePhaseEnable()
;~ 		Case "Save"
;~ 			; Train click timing
;~ 			$g_iTrainClickDelay = GUICtrlRead($g_hSldTrainITDelay)
;~ 			; Training add random delay
;~ 			$g_bTrainAddRandomDelayEnable = (GUICtrlRead($g_hChkTrainAddRandomDelayEnable) = $GUI_CHECKED)
;~ 			$g_iTrainAddRandomDelayMin = Int(GUICtrlRead($g_hTxtAddRandomDelayMin))
;~ 			$g_iTrainAddRandomDelayMax = Int(GUICtrlRead($g_hTxtAddRandomDelayMax))
;~ 	EndSwitch
;~ EndFunc   ;==>ApplyConfig_641_1
