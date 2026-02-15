; #FUNCTION# ====================================================================================================================
; Name ..........: saveConfig.au3
; Description ...: Saves all of the GUI values to the config.ini and building.ini files
; Syntax ........: saveConfig()
; Parameters ....: NA
; Return values .: NA
; Author ........:
; Modified ......: CodeSlinger69 (01-2018), mxkcz
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func saveConfig()

	If $g_iGuiMode = 0 Then Return

	If $g_bSaveConfigIsActive Then
		SetDebugLog("saveConfig(), already running, exit")
		Return
	EndIf
	$g_bSaveConfigIsActive = True

	Local $t = __TimerInit()

	Static $iSaveConfigCount = 0
	$iSaveConfigCount += 1
	SetDebugLog("saveConfig(), call number " & $iSaveConfigCount)

	SaveProfileConfig()

	SaveWeakBaseStats()
	;SetDebugLog("saveWeakBaseStats(), time = " & Round(__TimerDiff($t)/1000, 2) & " sec")

	SaveBuildingConfig()
	;SetDebugLog("SaveBuildingConfig(), time = " & Round(__TimerDiff($t)/1000, 2) & " sec")

	SaveRegularConfig()
	;SetDebugLog("SaveRegularConfig(), time = " & Round(__TimerDiff($t)/1000, 2) & " sec")

	SetDebugLog("SaveConfig(), time = " & Round(__TimerDiff($t) / 1000, 2) & " sec")

	$g_bSaveConfigIsActive = False
EndFunc   ;==>saveConfig

Func SaveProfileConfig($sIniFile = Default, $bForceWrite = False)
	If $sIniFile = Default Then $sIniFile = $g_sProfilePath & "\profile.ini"
	IniWrite($sIniFile, "general", "defaultprofile", $g_sProfileCurrentName)
	If $bForceWrite Or Int(IniRead($sIniFile, "general", "globalactivebotsallowed", 0)) = 0 Then
		IniWrite($sIniFile, "general", "globalactivebotsallowed", $g_iGlobalActiveBotsAllowed)
	EndIf
	If $bForceWrite Or IniRead($sIniFile, "general", "globalthreads", "-") = "-" Then
		IniWrite($sIniFile, "general", "globalthreads", $g_iGlobalThreads)
	EndIf
	; Not used anymore since MBR v7.6.7
	;_SaveProfileConfigAdbPath($sIniFile)
EndFunc   ;==>SaveProfileConfig

Func _SaveProfileConfigAdbPath($sIniFile = Default, $sAdbPath = $g_sAndroidAdbPath)
	If $sIniFile = Default Then $sIniFile = $g_sProfilePath & "\profile.ini"
	IniWrite($sIniFile, "general", "adb.path", $sAdbPath)
EndFunc   ;==>SaveProfileConfigAdbPath

Func SaveWeakBaseStats()
	_Ini_Clear()

	; Loop through the current stats
	For $j = 0 To UBound($g_aiWeakBaseStats) - 1
		; Write the new value to the stats file
		_Ini_Add("WeakBase", $g_aiWeakBaseStats[$j][0], $g_aiWeakBaseStats[$j][1])
	Next

	_Ini_Save($g_sProfileBuildingStatsPath)
EndFunc   ;==>SaveWeakBaseStats

Func SaveBuildingConfig()
	SetDebugLog("Save Building Config " & $g_sProfileBuildingPath)
	_Ini_Clear()

	_Ini_Add("general", "version", GetVersionNormalized($g_sBotVersion))

	;Upgrades
	_Ini_Add("upgrade", "LabPosX", $g_aiLaboratoryPos[0])
	_Ini_Add("upgrade", "LabPosY", $g_aiLaboratoryPos[1])

	_Ini_Add("upgrade", "PetHousePosX", $g_aiPetHousePos[0])
	_Ini_Add("upgrade", "PetHousePosY", $g_aiPetHousePos[1])

	_Ini_Add("upgrade", "BlacksmithPosX", $g_aiBlacksmithPos[0])
	_Ini_Add("upgrade", "BlacksmithPosY", $g_aiBlacksmithPos[1])

	_Ini_Add("upgrade", "StarLabPosX", $g_aiStarLaboratoryPos[0])
	_Ini_Add("upgrade", "StarLabPosY", $g_aiStarLaboratoryPos[1])

	_Ini_Add("other", "xTownHall", $g_aiTownHallPos[0])
	_Ini_Add("other", "yTownHall", $g_aiTownHallPos[1])
	_Ini_Add("other", "LevelTownHall", $g_iTownHallLevel)

	_Ini_Add("other", "xCCPos", $g_aiClanCastlePos[0])
	_Ini_Add("other", "yCCPos", $g_aiClanCastlePos[1])

	_Ini_Add("other", "totalcamp", $g_iTotalCampSpace)

	;_Ini_Add("other", "xspellfactory", $SFPos[0])
	;_Ini_Add("other", "yspellfactory", $SFPos[1])

	;_Ini_Add("other", "xDspellfactory", $DSFPos[0])
	;_Ini_Add("other", "yDspellfactory", $DSFPos[1])

	_Ini_Add("other", "xKingAltarPos", $g_aiKingAltarPos[0])
	_Ini_Add("other", "yKingAltarPos", $g_aiKingAltarPos[1])

	_Ini_Add("other", "xQueenAltarPos", $g_aiQueenAltarPos[0])
	_Ini_Add("other", "yQueenAltarPos", $g_aiQueenAltarPos[1])

	_Ini_Add("other", "xWardenAltarPos", $g_aiWardenAltarPos[0])
	_Ini_Add("other", "yWardenAltarPos", $g_aiWardenAltarPos[1])

	_Ini_Add("other", "xChampionAltarPos", $g_aiChampionAltarPos[0])
	_Ini_Add("other", "yChampionAltarPos", $g_aiChampionAltarPos[1])
	
	; <><><><> Village / Upgrade - Lab <><><><>
	ApplyConfig_600_14(GetApplyConfigSaveAction())
	_Ini_Add("upgrade", "upgradetroops", $g_bAutoLabUpgradeEnable ? 1 : 0)
	_Ini_Add("upgrade", "upgradetroopname", $g_iCmbLaboratory)
	_Ini_Add("upgrade", "upgradelabelexircost", $g_iLaboratoryElixirCost)
	_Ini_Add("upgrade", "upgradelabdelexircost", $g_iLaboratoryDElixirCost)
	_Ini_Add("upgrade", "upgradestartroops", $g_bAutoStarLabUpgradeEnable ? 1 : 0)
	_Ini_Add("upgrade", "upgradestartroopname", $g_iCmbStarLaboratory)
	_Ini_Add("upgrade", "uselabpotion", $g_bUseLabPotion)

	;xbenk
	_Ini_Add("upgrade", "upgradeorder", $g_bLabUpgradeOrderEnable ? 1 : 0)
	_Ini_Add("upgrade", "upgradeanytroops", $g_bUpgradeAnyTroops ? 1 : 0)
	_Ini_Add("upgrade", "usebookfighting", $g_bUseBOF ? 1 : 0)
	_Ini_Add("upgrade", "usebookfightingMinTime", $g_iUseBOFTime)
	_Ini_Add("upgrade", "usebookspell", $g_bUseBOS ? 1 : 0)
	_Ini_Add("upgrade", "usebookspellMinTime", $g_iUseBOSTime)
	_Ini_Add("upgrade", "usebookeverything", $g_bUseBOE ? 1 : 0)
	_Ini_Add("upgrade", "usebookeverythingMinTime", $g_iUseBOETime)

	Local $string = ""
	For $i = 0 To UBound($g_aCmbLabUpgradeOrder) - 1
		$string &= $g_aCmbLabUpgradeOrder[$i] & "|"
	Next
	_Ini_Add("upgrade", "upgradeorderlist", $string)

	_Ini_Add("upgrade", "Supgradeorder", $g_bSLabUpgradeOrderEnable ? 1 : 0)
	Local $string = ""
	For $i = 0 To UBound($g_aCmbSLabUpgradeOrder) - 1
		$string &= $g_aCmbSLabUpgradeOrder[$i] & "|"
	Next
	_Ini_Add("upgrade", "Supgradeorderlist", $string)
	_Ini_Add("upgrade", "SUpgradeAnyIfAllOrderMaxed", $g_bChkUpgradeAnyIfAllOrderMaxed ? 1 : 0)

	; <><><><> Village / Upgrade - Buildings <><><><>
	ApplyConfig_600_16(GetApplyConfigSaveAction())
	For $iz = 0 To UBound($g_avBuildingUpgrades, 1) - 1
		_Ini_Add("upgrade", "xupgrade" & $iz, $g_avBuildingUpgrades[$iz][0])
		_Ini_Add("upgrade", "yupgrade" & $iz, $g_avBuildingUpgrades[$iz][1])
		_Ini_Add("upgrade", "upgradevalue" & $iz, $g_avBuildingUpgrades[$iz][2])
		_Ini_Add("upgrade", "upgradetype" & $iz, $g_avBuildingUpgrades[$iz][3])
		_Ini_Add("upgrade", "upgradename" & $iz, $g_avBuildingUpgrades[$iz][4])
		_Ini_Add("upgrade", "upgradelevel" & $iz, $g_avBuildingUpgrades[$iz][5])
		_Ini_Add("upgrade", "upgradetime" & $iz, $g_avBuildingUpgrades[$iz][6])
		_Ini_Add("upgrade", "upgradeend" & $iz, $g_avBuildingUpgrades[$iz][7])
		_Ini_Add("upgrade", "zoomfactor" & $iz, $g_avBuildingUpgrades[$iz][8])
		_Ini_Add("upgrade", "upgradechk" & $iz, $g_abBuildingUpgradeEnable[$iz] ? 1 : 0)
		_Ini_Add("upgrade", "upgraderepeat" & $iz, $g_abUpgradeRepeatEnable[$iz] ? 1 : 0)
		_Ini_Add("upgrade", "upgradestatusicon" & $iz, $g_aiPicUpgradeStatus[$iz])
	Next

	_Ini_Save($g_sProfileBuildingPath)
EndFunc   ;==>SaveBuildingConfig

Func SaveRegularConfig()
	SetDebugLog("Save Config " & $g_sProfileConfigPath)
	_Ini_Clear()

	; General information
	_Ini_Add("general", "version", GetVersionNormalized($g_sBotVersion))

	_Ini_Add("general", "threads", $g_iThreads)
	_Ini_add("general", "botDesignFlags", $g_iBotDesignFlags)

	; Window positions
	_Ini_Add("general", "frmBotPosX", $g_iFrmBotPosX)
	_Ini_Add("general", "frmBotPosY", $g_iFrmBotPosY)
	; read now android position again, as it might have changed
	If $g_hAndroidWindow <> 0 Then WinGetAndroidHandle()
	_Ini_Add("general", "AndroidPosX", $g_iAndroidPosX)
	_Ini_Add("general", "AndroidPosY", $g_iAndroidPosY)
	_Ini_Add("general", "frmBotDockedPosX", $g_iFrmBotDockedPosX)
	_Ini_Add("general", "frmBotDockedPosY", $g_iFrmBotDockedPosY)

	; Redraw mode
	_Ini_Add("general", "RedrawBotWindowMode", $g_iRedrawBotWindowMode)

	; <><><> Attack Plan / Train Army / Options <><><>
	SaveConfig_Android()
	; <><><><> Log window <><><><>
	SaveConfig_600_1()
	; <><><><> Village / Misc <><><><>
	SaveConfig_600_6()
	; <><><><> Village / Achievements <><><><>
	SaveConfig_600_9()
	; <><><><> Village / Donate - Request <><><><>
	SaveConfig_600_11()
	; <><><><> Village / Donate - Donate <><><><>
	SaveConfig_600_12()
	; <><><><> Village / Upgrade - Heroes <><><><>
	SaveConfig_600_15()
	; <><><><> Village / Upgrade - Buildings <><><><>
	SaveConfig_600_16()
	; <><><><> Village / Upgrade - Auto Upgrade <><><><>
	SaveConfig_auto()
	; <><><><> Village / Upgrade - Walls <><><><>
	SaveConfig_600_17()
	; <><><><> Village / Notify <><><><>
	SaveConfig_600_18()
	; <><><><> Village / Notify <><><><>
	SaveConfig_600_19()
	; <><><><> CSV Mod <><><><>
	SaveConfig_CSVMod()
	;~ ; <><><><> Attack Plan / Search & Attack / Bully <><><><>
	;~ SaveConfig_600_26()
	;~ ; <><><><> Attack Plan / Search & Attack / Options / Search <><><><>
	;~ SaveConfig_600_28()
	;~ ; <><><><> Attack Plan / Search & Attack / Deadbase / Search <><><><>
	;~ SaveConfig_600_28_DB()
	;~ ; <><><><> Attack Plan / Search & Attack / Activebase / Search <><><><>
	;~ SaveConfig_600_28_LB()
	;~ ; <><><><> Attack Plan / Search & Attack / Options / Attack <><><><>
	;~ SaveConfig_600_29()
	;~ ; <><><><> Attack Plan / Search & Attack / Deadbase / Attack <><><><>
	;~ SaveConfig_600_29_DB()
	;~ ; <><><><> Attack Plan / Search & Attack / Activebase / Attack <><><><>
	;~ SaveConfig_600_29_LB()
	;~ ; <><><><> Attack Plan / Search & Attack / Options / End Battle <><><><>
	;~ SaveConfig_600_30()
	;~ ; <><><><> Attack Plan / Search & Attack / Deadbase / End Battle <><><><>
	;~ SaveConfig_600_30_DB()
	;~ ; <><><><> Attack Plan / Search & Attack / Activebase / End Battle <><><><>
	;~ SaveConfig_600_30_LB()
	;~ ; <><><><> Attack Plan / Search & Attack / CSV Recalc Overrides <><><><>
	;~ SaveConfig_AttackCSV()
	;~ ; <><><><> Attack Plan / Search & Attack / Deadbase / Collectors <><><><>
	;~ SaveConfig_600_31()
	;~ ; <><><><> Attack Plan / Search & Attack / Drop Order Troops <><><><>
	;~ SaveConfig_600_33()
	; <><><><> Bot / Options <><><><>
	SaveConfig_600_35_1()
	; <><><><> Bot / Profile / Switch Account <><><><>
	SaveConfig_600_35_2()
	;~ ; <><><> Attack Plan / Train Army / Troops/Spells <><><>
	;~ ; troop/spell levels and counts
	;~ SaveConfig_600_52_2()
	; <><><> Attack Plan / Train Army / Train Order <><><>
	;~ SaveConfig_600_54()
	;~ ; <><><><> Attack Plan / Search & Attack / Options / SmartZap <><><><>
	;~ SaveConfig_600_56()
	;~ ; <><><> Attack Plan / Train Army / Options <><><>
	;~ SaveConfig_641_1()
	; <><><><> Bot / Debug <><><><>
	SaveConfig_Debug()
	; <><><><> Attack Plan / Strategies <><><><>
	; <<< nothing here >>>

	; <><><><> Bot / Profiles <><><><>
	; <<< nothing here >>>

	; <><><><> Bot / Stats <><><><>
	; <<< nothing here >>>

	;SetDebugLog("saveConfig: Wrote " & $g_iIniLineCount & " ini lines.")
	_Ini_Save($g_sProfileConfigPath)
EndFunc   ;==>SaveRegularConfig

Func SaveConfig_Android()
	; <><><><> Bot / Android <><><><>
	ApplyConfig_Android(GetApplyConfigSaveAction())
	_Ini_Add("android", "game.distributor", $g_sAndroidGameDistributor)
	_Ini_Add("android", "game.package", $g_sAndroidGamePackage)
	_Ini_Add("android", "appActitivityName", $g_sAndroidGameClass)
	_Ini_Add("android", "user.distributor", $g_sUserGameDistributor)
	_Ini_Add("android", "user.package", $g_sUserGamePackage)
	_Ini_Add("android", "UserAppActitivityName", $g_sUserGameClass)
	_Ini_Add("android", "backgroundmode", $g_iAndroidBackgroundMode)
	_Ini_Add("android", "zoomoutmode", $g_iAndroidZoomoutMode)
	_Ini_Add("android", "adb.replace", $g_iAndroidAdbReplace)
	_Ini_Add("android", "check.time.lag.enabled", ($g_bAndroidCheckTimeLagEnabled ? "1" : "0"))
	_Ini_Add("android", "adb.dedicated.instance", ($g_bAndroidAdbPortPerInstance ? "1" : "0"))
	_Ini_Add("android", "adb.screencap.timeout.min", $g_iAndroidAdbScreencapTimeoutMin)
	_Ini_Add("android", "adb.screencap.timeout.max", $g_iAndroidAdbScreencapTimeoutMax)
	_Ini_Add("android", "adb.screencap.timeout.dynamic", $g_iAndroidAdbScreencapTimeoutDynamic)
	_Ini_Add("android", "adb.input.enabled", ($g_bAndroidAdbInputEnabled ? "1" : "0"))
	_Ini_Add("android", "adb.click.enabled", ($g_bAndroidAdbClickEnabled ? "1" : "0"))
	_Ini_Add("android", "adb.click.drag.script", ($g_bAndroidAdbClickDragScript ? "1" : "0"))
	_Ini_Add("android", "adb.click.group", $g_iAndroidAdbClickGroup)
	_Ini_Add("android", "adb.clicks.enabled", ($g_bAndroidAdbClicksEnabled ? "1" : "0"))
	_Ini_Add("android", "adb.clicks.troop.deploy.size", $g_iAndroidAdbClicksTroopDeploySize)
	_Ini_Add("android", "no.focus.tampering", ($g_bNoFocusTampering ? "1" : "0"))
	_Ini_Add("android", "shield.color", Hex($g_iAndroidShieldColor, 6))
	_Ini_Add("android", "shield.transparency", $g_iAndroidShieldTransparency)
	_Ini_Add("android", "active.color", Hex($g_iAndroidActiveColor, 6))
	_Ini_Add("android", "active.transparency", $g_iAndroidActiveTransparency)
	_Ini_Add("android", "inactive.color", Hex($g_iAndroidInactiveColor, 6))
	_Ini_Add("android", "inactive.transparency", $g_iAndroidInactiveTransparency)
	_Ini_Add("android", "suspend.mode", $g_iAndroidSuspendModeFlags)
	_Ini_Add("android", "emulator", $g_sAndroidEmulator)
	_Ini_Add("android", "instance", $g_sAndroidInstance)
	_Ini_Add("android", "reboot.hours", $g_iAndroidRebootHours)
	_Ini_Add("android", "close", ($g_bAndroidCloseWithBot ? "1" : "0"))
	_Ini_Add("android", "shared_prefs.update", ($g_bUpdateSharedPrefs ? "1" : "0"))
	_Ini_Add("android", "process.affinity.mask", $g_iAndroidProcessAffinityMask)
	_Ini_Add("android", "click.additional.delay", $g_iAndroidControlClickAdditionalDelay)

EndFunc   ;==>SaveConfig_Android

Func SaveConfig_Debug()
	; Debug
	ApplyConfig_Debug(GetApplyConfigSaveAction())
	; <><><><> Bot / Debug <><><><>
	_Ini_Add("debug", "debugsetlog", $g_bDebugSetlog ? 1 : 0)
	_Ini_Add("debug", "debugAndroid", $g_bDebugAndroid ? 1 : 0)
	_Ini_Add("debug", "debugsetclick", $g_bDebugClick ? 1 : 0)
	_Ini_Add("debug", "debugFunc", ($g_bDebugFuncTime And $g_bDebugFuncCall)? 1 : 0)
	_Ini_Add("debug", "disablezoomout", $g_bDebugDisableZoomout ? 1 : 0)
	_Ini_Add("debug", "debugdeadbaseimage", $g_bDebugDeadBaseImage ? 1 : 0)
	_Ini_Add("debug", "debugocr", $g_bDebugOcr ? 1 : 0)
	_Ini_Add("debug", "debugimagesave", $g_bDebugImageSave ? 1 : 0)
	_Ini_Add("debug", "debugbuildingpos", $g_bDebugBuildingPos ? 1 : 0)
	_Ini_Add("debug", "debugtrain", $g_bDebugSetlogTrain ? 1 : 0)
	_Ini_Add("debug", "debugOCRDonate", $g_bDebugOCRdonate ? 1 : 0)
	_Ini_Add("debug", "debugAttackCSV", $g_bDebugAttackCSV ? 1 : 0)
	_Ini_Add("debug", "debugmakeimgcsv", $g_bDebugMakeIMGCSV ? 1 : 0)
	_Ini_Add("debug", "debugAttackTiming", $g_bDebugAttackTiming ? 1 : 0)
	_Ini_Add("debug", "debugAttackRescan", $g_bDebugAttackRescan ? 1 : 0)
	_Ini_Add("debug", "DebugSmartZap", $g_bDebugSmartZap)
EndFunc   ;==>SaveConfig_Debug

Func SaveConfig_600_1()
	; <><><><> Village / Misc <><><><>
	ApplyConfig_600_1(GetApplyConfigSaveAction())
	; <><><><> Log window <><><><>
	_Ini_Add("general", "logstyle", $g_iCmbLogDividerOption)
	_Ini_Add("general", "LogDividerY", $g_iLogDividerY)
	; <><><><> Bottom panel <><><><>
	_Ini_Add("general", "Background", $g_bChkBackgroundMode ? 1 : 0)
EndFunc   ;==>SaveConfig_600_1

Func SaveConfig_600_6()
	; <><><><> Village / Misc <><><><>
	ApplyConfig_600_6(GetApplyConfigSaveAction())
	_Ini_Add("general", "BotStop", $g_bChkBotStop ? 1 : 0)
	_Ini_Add("general", "Command", $g_iCmbBotCommand)
	_Ini_Add("general", "Cond", $g_iCmbBotCond)
	_Ini_Add("general", "Hour", $g_iCmbHoursStop)
	For $i = 0 To $eLootCount - 1
		_Ini_Add("other", "MinResumeAttackLoot_" & $i, $g_aiResumeAttackLoot[$i])
	Next
	_Ini_Add("general", "CollectStarBonus", $g_bCollectStarBonus ? 1 : 0)
	_Ini_Add("general", "CmbTimeStop", $g_iCmbTimeStop)
	_Ini_Add("other", "ResumeAttackTime", $g_iResumeAttackTime)
	_Ini_Add("other", "minrestartgold", $g_iTxtRestartGold)
	_Ini_Add("other", "minrestartelixir", $g_iTxtRestartElixir)
	_Ini_Add("other", "minrestartdark", $g_iTxtRestartDark)
	_Ini_Add("other", "chkCollect", $g_bChkCollect ? 1 : 0)
	_Ini_Add("other", "ChkCollectLootCart", $g_bChkCollectLootCart ? 1 : 0)
	_Ini_Add("other", "ChkCollectTreasury", $g_bChkTreasuryCollect ? 1 : 0)
	_Ini_Add("other", "ChkCollectCookie", $g_bChkCollectCookie ? 1 : 0)
	_Ini_Add("other", "chkTombstones", $g_bChkTombstones ? 1 : 0)
	_Ini_Add("other", "chkCleanYard", $g_bChkCleanYard ? 1 : 0)
	_Ini_Add("other", "ChkCollectAchievements", $g_bChkCollectAchievements ? 1 : 0)
	_Ini_Add("other", "ChkSellRewards", $g_bChkSellRewards ? 1 : 0)
	_Ini_Add("other", "ChkCollectFreeMagicItems", $g_bChkCollectFreeMagicItems ? 1 : 0)
	_Ini_Add("other", "ChkCollectRewards", $g_bChkCollectRewards ? 1 : 0)
	_Ini_Add("other", "chkGemsBox", $g_bChkGemsBox ? 1 : 0)
	_Ini_Add("MagicItems", "ChkSellMagicItems", $g_bChkEnableSellMagicItem ? 1 : 0)
	_Ini_Add("MagicItems", "ChkSellBOF", $g_bChkSellBOF ? 1 : 0)
	_Ini_Add("MagicItems", "ChkSellBOB", $g_bChkSellBOB ? 1 : 0)
	_Ini_Add("MagicItems", "ChkSellBOS", $g_bChkSellBOS ? 1 : 0)
	_Ini_Add("MagicItems", "ChkSellBOH", $g_bChkSellBOH ? 1 : 0)
	_Ini_Add("MagicItems", "ChkSellBOE", $g_bChkSellBOE ? 1 : 0)
	_Ini_Add("MagicItems", "ChkSellShovel", $g_bChkSellShovel ? 1 : 0)
	_Ini_Add("MagicItems", "ChkSellWallRing", $g_bChkSellWallRing ? 1 : 0)
	_Ini_Add("MagicItems", "ChkSellPowerPot", $g_bChkSellPowerPot ? 1 : 0)
	_Ini_Add("MagicItems", "ChkSellResourcePot", $g_bChkSellResourcePot ? 1 : 0)
	_Ini_Add("MagicItems", "ChkSellTrainingPot", $g_bChkSellTrainingPot ? 1 : 0)
	_Ini_Add("MagicItems", "ChkSellBuilderPot", $g_bChkSellBuilderPot ? 1 : 0)
	_Ini_Add("MagicItems", "ChkSellCTPot", $g_bChkSellCTPot ? 1 : 0)
	_Ini_Add("MagicItems", "ChkSellHeroPot", $g_bChkSellHeroPot ? 1 : 0)
	_Ini_Add("MagicItems", "ChkSellResearchPot", $g_bChkSellResearchPot ? 1 : 0)
	_Ini_Add("MagicItems", "ChkSellSuperPot", $g_bChkSellSuperPot ? 1 : 0)
	_Ini_Add("MagicItems", "ChkSellROG", $g_bChkSellROG ? 1 : 0)
	_Ini_Add("MagicItems", "ChkSellROE", $g_bChkSellROE ? 1 : 0)
	_Ini_Add("MagicItems", "ChkSellRODE", $g_bChkSellRODE ? 1 : 0)
	_Ini_Add("MagicItems", "ChkSellROBG", $g_bChkSellROBG ? 1 : 0)
	_Ini_Add("MagicItems", "ChkSellROBE", $g_bChkSellROBE ? 1 : 0)

	_Ini_Add("other", "ChkCollectBuildersBase", $g_bChkCollectBuilderBase ? 1 : 0)
	_Ini_Add("other", "ChkCleanBBYard", $g_bChkCleanBBYard ? 1 : 0)
	_Ini_Add("other", "ChkStartClockTowerBoost", $g_bChkStartClockTowerBoost ? 1 : 0)
	_Ini_Add("other", "ChkBBSuggestedUpgrades", $g_bAutoUpgradeBBEnabled)
	_Ini_Add("other", "ChkBBSuggestedUpgradesIgnoreHall", $g_bChkAutoUpgradeBBIgnoreHall)
	_Ini_Add("other", "ChkBBSuggestedUpgradesIgnoreWall", $g_bChkAutoUpgradeBBIgnoreWall)
	_Ini_Add("other", "ChkBOBControl", $g_bChkBOBControl)

	# NEW CLANGAMES GUI
	_Ini_Add("other", "ChkClanGamesEnabled", $g_bChkClanGamesEnabled ? 1 : 0)
	_Ini_Add("other", "ChkClanGames60", $g_bChkClanGames3H ? 1 : 0)
	_Ini_Add("other", "ChkClanGamesDebug", $g_bChkClanGamesDebug ? 1 : 0)
	_Ini_Add("other", "CollectCGReward", $g_bCollectCGReward ? 1 : 0)

	_Ini_Add("other", "ChkClanGamesLoot", $g_bChkClanGamesLoot ? 1 : 0)
	_Ini_Add("other", "ChkClanGamesBattle", $g_bChkClanGamesBattle ? 1 : 0)
	_Ini_Add("other", "ChkClanGamesDestruction", $g_bChkClanGamesDes ? 1 : 0)
	_Ini_Add("other", "ChkClanGamesAirTroop", $g_bChkClanGamesAirTroop ? 1 : 0)
	_Ini_Add("other", "ChkClanGamesGroundTroop", $g_bChkClanGamesGroundTroop ? 1 : 0)
	_Ini_Add("other", "ChkClanGamesMiscellaneous", $g_bChkClanGamesMiscellaneous ? 1 : 0)
	_Ini_Add("other", "ChkClanGamesSpell", $g_bChkClanGamesSpell ? 1 : 0)
	_Ini_Add("other", "ChkClanGamesBBBattle", $g_bChkClanGamesBBBattle ? 1 : 0)
    _Ini_Add("other", "ChkClanGamesBBDestruction", $g_bChkClanGamesBBDes ? 1 : 0)
	_Ini_Add("other", "ChkClanGamesBBTroops", $g_bChkClanGamesBBTroops ? 1 : 0)

	_Ini_Add("other", "ChkForceBBAttackOnClanGames", $g_bChkForceBBAttackOnClanGames ? 1 : 0)
	_Ini_Add("other", "ChkClanGamesPurgeAny", $g_bChkClanGamesPurgeAny ? 1 : 0)
	_Ini_Add("other", "ChkClanGamesStopBeforeReachAndPurge", $g_bChkClanGamesStopBeforeReachAndPurge ? 1 : 0)
	_Ini_Add("other", "ClanGamesPurgeDay", $g_iCmbClanGamesPurgeDay)
	_Ini_Add("other", "ChkClanGamesSort", $g_bSortClanGames ? 1 : 0)
	_Ini_Add("other", "ClanGamesSortBy", $g_iSortClanGames)
	_Ini_Add("other", "ChkCGBBAttackOnly", $g_bChkCGBBAttackOnly ? 1 : 0)

	Local $str = ""
	For $i = 0 To UBound($g_abCGMainLootItem) - 1
		$str &= $g_abCGMainLootItem[$i] & "|"
	Next
	_Ini_Add("other", "EnabledCGLoot", $str)

	$str = ""
	For $i = 0 To UBound($g_abCGMainBattleItem) - 1
		$str &= $g_abCGMainBattleItem[$i] & "|"
	Next
	_Ini_Add("other", "EnabledCGBattle", $str)

	$str = ""
	For $i = 0 To UBound($g_abCGMainDestructionItem) - 1
		$str &= $g_abCGMainDestructionItem[$i] & "|"
	Next
	_Ini_Add("other", "EnabledCGDes", $str)

	$str = ""
	For $i = 0 To UBound($g_abCGMainAirItem) - 1
		$str &= $g_abCGMainAirItem[$i] & "|"
	Next
	_Ini_Add("other", "EnabledCGAirTroop", $str)

	$str = ""
	For $i = 0 To UBound($g_abCGMainGroundItem) - 1
		$str &= $g_abCGMainGroundItem[$i] & "|"
	Next
	_Ini_Add("other", "EnabledCGGroundTroop", $str)

	$str = ""
	For $i = 0 To UBound($g_abCGMainMiscItem) - 1
		$str &= $g_abCGMainMiscItem[$i] & "|"
	Next
	_Ini_Add("other", "EnabledCGMisc", $str)

	$str = ""
	For $i = 0 To UBound($g_abCGMainSpellItem) - 1
		$str &= $g_abCGMainSpellItem[$i] & "|"
	Next
	_Ini_Add("other", "EnabledCGSpell", $str)

	$str = ""
	For $i = 0 To UBound($g_abCGBBBattleItem) - 1
		$str &= $g_abCGBBBattleItem[$i] & "|"
	Next
	_Ini_Add("other", "EnabledBBBattle", $str)

	$str = ""
	For $i = 0 To UBound($g_abCGBBDestructionItem) - 1
		$str &= $g_abCGBBDestructionItem[$i] & "|"
	Next
	_Ini_Add("other", "EnabledBBDestruction", $str)

	$str = ""
	For $i = 0 To UBound($g_abCGBBTroopsItem) - 1
		$str &= $g_abCGBBTroopsItem[$i] & "|"
	Next
	_Ini_Add("other", "EnabledBBTroops", $str)

	; Builder Base Attack
	_Ini_Add("other", "ChkEnableBBAttack", $g_bChkEnableBBAttack)
	_Ini_Add("other", "ChkBBDropTrophy", $g_bChkBBDropTrophy)
	_Ini_Add("other", "ChkStopAttackBB6thBuilder", $g_bChkStopAttackBB6thBuilder)
	_Ini_Add("other", "ChkBBEndBattleOn2Stars", $g_bChkBBEndBattleOn2Stars)
	_Ini_Add("other", "ChkSkipBBRoutineOn6thBuilder", $g_bChkSkipBBRoutineOn6thBuilder)
	_Ini_Add("other", "BBTrophyLowerLimit", $g_iTxtBBTrophyLowerLimit)
	_Ini_Add("other", "ChkBBAttIfLootAvail", $g_bChkBBAttIfStarsAvail)
	_Ini_Add("other", "ChkSkipBBAttIfStorageFull", $g_bChkSkipBBAttIfStorageFull)
	_Ini_Add("other", "ChkBBWaitForMachine", $g_bChkBBWaitForMachine)
	_Ini_Add("other", "ChkBBDropBMFirst", $g_bChkBBDropBMFirst)
	_Ini_Add("other", "ChkDebugAttackBB", $g_bChkDebugAttackBB)
	_Ini_Add("other", "iBBSameTroopDelay", $g_iBBSameTroopDelay)
	_Ini_Add("other", "iBBNextTroopDelay", $g_iBBNextTroopDelay)
	_Ini_Add("other", "iBBAttackCount", $g_iBBAttackCount)

	; Builder Base Drop Order
	_Ini_Add("other", "bBBDropOrderSet", $g_bBBDropOrderSet)
	_Ini_Add("other", "sBBDropOrder", $g_sBBDropOrder)

	;Clan Capital
	_Ini_Add("ClanCapital", "ChkCollectCCGold", $g_bChkEnableCollectCCGold)
	_Ini_Add("ClanCapital", "ChkStartWeekendRaid", $g_bChkStartWeekendRaid)
	_Ini_Add("ClanCapital", "ChkEnableForgeGold", $g_bChkEnableForgeGold)
	_Ini_Add("ClanCapital", "ChkEnableForgeElix", $g_bChkEnableForgeElix)
	_Ini_Add("ClanCapital", "ChkEnableForgeDE", $g_bChkEnableForgeDE)
	_Ini_Add("ClanCapital", "ChkEnableForgeBBGold", $g_bChkEnableForgeBBGold)
	_Ini_Add("ClanCapital", "ChkEnableForgeBBElix", $g_bChkEnableForgeBBElix)
	_Ini_Add("ClanCapital", "ForgeUseBuilder", $g_iCmbForgeBuilder)
	_Ini_Add("ClanCapital", "AutoUpgradeCC", $g_bChkEnableAutoUpgradeCC)
	_Ini_Add("ClanCapital", "MinGoldAUCC", $g_bChkEnableMinGoldAUCC)
	_Ini_Add("ClanCapital", "MinCCGoldToUpgrade", $g_iMinCCGoldToUpgrade)
	_Ini_Add("ClanCapital", "ChkAutoUpgradeCCIgnore", $g_bChkAutoUpgradeCCIgnore)
	_Ini_Add("ClanCapital", "ChkAutoUpgradeCCWallIgnore", $g_bChkAutoUpgradeCCWallIgnore)

	;Misc Mod
	_Ini_Add("other", "SkipFirstCheckRoutine", $g_bSkipFirstCheckRoutine)
	_Ini_Add("other", "SkipBB", $g_bSkipBB)
	_Ini_Add("other", "IgnoreIncorrectTroopCombo", $g_bIgnoreIncorrectTroopCombo)
	_Ini_Add("other", "FillIncorrectTroopCombo", $g_iCmbFillIncorrectTroopCombo)
	_Ini_Add("other", "IgnoreIncorrectSpellCombo", $g_bIgnoreIncorrectSpellCombo)
	_Ini_Add("other", "FillIncorrectSpellCombo", $g_iCmbFillIncorrectSpellCombo)
	_Ini_Add("other", "SkipWallPlacingOnBB", $g_bSkipWallPlacingOnBB)
	_Ini_Add("other", "CheckDonateEarly", $g_bDonateEarly)
	_Ini_Add("other", "CheckAutoUpgradeEarly", $g_bAutoUpgradeEarly)
	_Ini_Add("other", "ForceSwitchifNoCGEvent", $g_bChkForceSwitchifNoCGEvent)
	_Ini_Add("other", "EnableCCSleep", $g_bEnableCCSleep)

	SaveBuilderBaseMod()
EndFunc   ;==>SaveConfig_600_6

Func SaveBuilderBaseMod()
	; Custom Army
	_Ini_Add("BBCustomArmy", "ChkBBCustomArmyEnable", $g_bChkBBCustomArmyEnable)
	For $i = 0 To UBound($g_hCmbTroopBB) - 1
		_Ini_Add("BBCustomArmy", "ComboTroopBB" & $i, $g_iCmbTroopBB[$i])
	Next
	_Ini_Add("BBCustomArmy", "Chk1SideBBAttack", $g_b1SideBBAttack)
	_Ini_Add("BBCustomArmy", "1SideBBAttack", $g_i1SideBBAttack)
	_Ini_Add("BBCustomArmy", "Chk2SideBBAttack", $g_b2SideBBAttack)
	_Ini_Add("BBCustomArmy", "ChkAllSideBBAttack", $g_bAllSideBBAttack)
EndFunc   ;==>SaveBuilderBaseMod

Func SaveConfig_600_9()
	; <><><><> Village / Achievements <><><><>
	ApplyConfig_600_9(GetApplyConfigSaveAction())
	_Ini_Add("Unbreakable", "chkUnbreakable", $g_iUnbrkMode)
	_Ini_Add("Unbreakable", "UnbreakableWait", $g_iUnbrkWait)
	_Ini_Add("Unbreakable", "minUnBrkgold", $g_iUnbrkMinGold)
	_Ini_Add("Unbreakable", "minUnBrkelixir", $g_iUnbrkMinElixir)
	_Ini_Add("Unbreakable", "minUnBrkdark", $g_iUnbrkMinDark)
	_Ini_Add("Unbreakable", "maxUnBrkgold", $g_iUnbrkMaxGold)
	_Ini_Add("Unbreakable", "maxUnBrkelixir", $g_iUnbrkMaxElixir)
	_Ini_Add("Unbreakable", "maxUnBrkdark", $g_iUnbrkMaxDark)
EndFunc   ;==>SaveConfig_600_9

Func SaveConfig_600_11()
	ApplyConfig_600_11(GetApplyConfigSaveAction())
	; <><><><> Village / Donate - Request <><><><>
	_Ini_Add("donate", "txtRequest", $g_sRequestTroopsText)
	_Ini_Add("donate", "chkRequest", $g_bRequestTroopsEnable ? 1 : 0)
EndFunc   ;==>SaveConfig_600_11

Func SaveConfig_600_12()
	Local $t = __TimerInit()

	; <><><><> Village / Donate - Donate <><><><>
	ApplyConfig_600_12(GetApplyConfigSaveAction())

	_Ini_Add("donate", "Doncheck", $g_bChkDonate ? 1 : 0)
	
	For $i = 0 To $eTroopCount - 1
		Local $sIniName = ""
		If $i >= $eTroopBarbarian And $i <= $eTroopIceWizard Then
			$sIniName = StringReplace($g_asTroopNamesPlural[$i], " ", "")
		EndIf

		_Ini_Add("donate", "chkDonate" & $sIniName, $g_abChkDonateTroop[$i] ? 1 : 0)
		_Ini_Add("donate", "txtDonate" & $sIniName, StringReplace($g_asTxtDonateTroop[$i], @CRLF, "|"))
	Next

	For $i = 0 To $eSpellCount - 1
		Local $sIniName = $g_asSpellNames[$i] & "Spells"
		_Ini_Add("donate", "chkDonate" & $sIniName, $g_abChkDonateSpell[$i] ? 1 : 0)
		_Ini_Add("donate", "txtDonate" & $sIniName, StringReplace($g_asTxtDonateSpell[$i], @CRLF, "|"))
	Next

	For $i = $eSiegeWallWrecker to $eSiegeMachineCount - 1
		Local $index = $eTroopCount
		Local $sIniName = $g_asSiegeMachineShortNames[$i]
		_Ini_Add("donate", "chkDonate" & $sIniName, $g_abChkDonateTroop[$index + $i] ? 1 : 0)
		_Ini_Add("donate", "txtDonate" & $sIniName, StringReplace($g_asTxtDonateTroop[$index + $i], @CRLF, "|"))
	Next

	_Ini_Add("donate", "chkExtraAlphabets", $g_bChkExtraAlphabets ? 1 : 0)
	_Ini_Add("donate", "chkExtraChinese", $g_bChkExtraChinese ? 1 : 0)
	_Ini_Add("donate", "chkExtraKorean", $g_bChkExtraKorean ? 1 : 0)
	_Ini_Add("donate", "chkExtraPersian", $g_bChkExtraPersian ? 1 : 0)
EndFunc   ;==>SaveConfig_600_12

Func SaveConfig_600_15()
	; <><><><> Village / Upgrade - Heroes <><><><>
	ApplyConfig_600_15(GetApplyConfigSaveAction())
	_Ini_Add("upgrade", "UpgradeKing", $g_bUpgradeKingEnable ? 1 : 0)
	_Ini_Add("upgrade", "UpgradeQueen", $g_bUpgradeQueenEnable ? 1 : 0)
	_Ini_Add("upgrade", "UpgradeWarden", $g_bUpgradeWardenEnable ? 1 : 0)
	_Ini_Add("upgrade", "UpgradeChampion", $g_bUpgradeChampionEnable ? 1 : 0)
	_Ini_Add("upgrade", "HeroReservedBuilder", $g_iHeroReservedBuilder)

	; Equipment Order
	_Ini_Add("upgrade", "ChkUpgradeEquipment", $g_bChkCustomEquipmentOrderEnable ? 1 : 0)
	For $z = 0 To UBound($g_aiCmbCustomEquipmentOrder) - 1
		_Ini_Add("upgrade", "ChkEquipment" & $z, $g_bChkCustomEquipmentOrder[$z] ? 1 : 0)
		_Ini_Add("upgrade", "cmbEquipmentOrder" & $z, $g_aiCmbCustomEquipmentOrder[$z])
	Next
	_Ini_Add("upgrade", "ChkMinOreUpgrade", $g_bChkMinOreUpgrade ? 1 : 0)
	_Ini_Add("upgrade", "MinOreUpgrade", $g_sTxtMinOreUpgrade)

	_Ini_Add("upgrade", "ChkSortPetUpgrade", $g_bChkSortPetUpgrade ? 1 : 0)
	_Ini_Add("upgrade", "CmbSortPetUpgrade", $g_iCmbSortPetUpgrade)
	_Ini_Add("upgrade", "ChkSyncSaveDE", $g_bChkSyncSaveDE ? 1 : 0)

	_Ini_Add("upgrade", "UpgradePetLassi", $g_bUpgradePetsEnable[$ePetLassi] ? 1 : 0)
	_Ini_Add("upgrade", "UpgradePetElectroOwl", $g_bUpgradePetsEnable[$ePetElectroOwl] ? 1 : 0)
	_Ini_Add("upgrade", "UpgradePetMightyYak", $g_bUpgradePetsEnable[$ePetMightyYak] ? 1 : 0)
	_Ini_Add("upgrade", "UpgradePetUnicorn", $g_bUpgradePetsEnable[$ePetUnicorn] ? 1 : 0)

	_Ini_Add("upgrade", "UpgradePetFrosty", $g_bUpgradePetsEnable[$ePetFrosty] ? 1 : 0)
	_Ini_Add("upgrade", "UpgradePetDiggy", $g_bUpgradePetsEnable[$ePetDiggy] ? 1 : 0)
	_Ini_Add("upgrade", "UpgradePetPoisonLizard", $g_bUpgradePetsEnable[$ePetPoisonLizard] ? 1 : 0)
	_Ini_Add("upgrade", "UpgradePetPhoenix", $g_bUpgradePetsEnable[$ePetPhoenix] ? 1 : 0)
EndFunc   ;==>SaveConfig_600_15

Func SaveConfig_600_16()
	; <><><><> Village / Upgrade - Buildings <><><><>
	_Ini_Add("upgrade", "minupgrgold", $g_iUpgradeMinGold)
	_Ini_Add("upgrade", "minupgrelixir", $g_iUpgradeMinElixir)
	_Ini_Add("upgrade", "minupgrdark", $g_iUpgradeMinDark)
EndFunc   ;==>SaveConfig_600_16

Func SaveConfig_auto()
	ApplyConfig_auto(GetApplyConfigSaveAction())
	; Auto Upgrade
	_Ini_Add("Auto Upgrade", "AutoUpgradeEnabled", $g_bAutoUpgradeEnabled)
	_Ini_Add("Auto Upgrade", "ChkRushTH", $g_bChkRushTH)
	_Ini_Add("Auto Upgrade", "UseWallReserveBuilder", $g_bUseWallReserveBuilder)
	_Ini_Add("Auto Upgrade", "UseBuilderPotion", $g_bUseBuilderPotion)

	Local $string = ""
	For $i = 0 To UBound($g_aiCmbRushTHOption) - 1
		$string &= $g_aiCmbRushTHOption[$i] & "|"
	Next
	_Ini_Add("Auto Upgrade", "RushTHOption", $string)
	$string = ""
	For $i = 0 To UBound($g_aichkEssentialUpgrade) - 1
		$string &= $g_aichkEssentialUpgrade[$i] & "|"
	Next
	_Ini_Add("Auto Upgrade", "EssentialBuildings", $string)
	_Ini_Add("Auto Upgrade", "UpgradeOnlyTHLevelAchieve", $g_bUpgradeOnlyTHLevelAchieve)
	_Ini_Add("Auto Upgrade", "HeroPriority", $g_bHeroPriority)
	_Ini_Add("Auto Upgrade", "UseHeroBooks", $g_bUseHeroBooks)
	_Ini_Add("Auto Upgrade", "HeroMinUpgradeTime", $g_iHeroMinUpgradeTime)
	_Ini_Add("Auto Upgrade", "UpgradeOtherDefenses", $g_bUpgradeOtherDefenses)
	For $i = 0 To UBound($g_iChkUpgradesToIgnore) - 1
		_Ini_Add("Auto Upgrade", "ChkUpgradesToIgnore[" & $i & "]", $g_iChkUpgradesToIgnore[$i])
	Next
	For $i = 0 To 2
		_Ini_Add("Auto Upgrade", "ChkResourcesToIgnore[" & $i & "]", $g_iChkResourcesToIgnore[$i])
	Next
	_Ini_Add("Auto Upgrade", "SmartMinGold", $g_iTxtSmartMinGold)
	_Ini_Add("Auto Upgrade", "SmartMinElixir", $g_iTxtSmartMinElixir)
	_Ini_Add("Auto Upgrade", "SmartMinDark", $g_iTxtSmartMinDark)
EndFunc   ;==>SaveConfig_auto

Func SaveConfig_600_17()
	; <><><><> Village / Upgrade - Walls <><><><>
	ApplyConfig_600_17(GetApplyConfigSaveAction())
	_Ini_Add("upgrade", "auto-wall", $g_bAutoUpgradeWallsEnable ? 1 : 0)
	_Ini_Add("upgrade", "minwallgold", $g_iUpgradeWallMinGold)
	_Ini_Add("upgrade", "minwallelixir", $g_iUpgradeWallMinElixir)
	_Ini_Add("upgrade", "use-storage", $g_iUpgradeWallLootType)
	_Ini_Add("upgrade", "AutoAdjustSaveMinWall", $g_bAutoAdjustSaveWall ? 1 : 0)
	_Ini_Add("upgrade", "savebldr", $g_bUpgradeWallSaveBuilder ? 1 : 0)
	_Ini_Add("upgrade", "Only1Builder", $g_bChkOnly1Builder ? 1 : 0)
	_Ini_Add("upgrade", "SpesificWall", $g_bUpgradeSpesificWall ? 1 : 0)
	_Ini_Add("upgrade", "WallLevel", $g_iTargetWallLevel)
EndFunc   ;==>SaveConfig_600_17

Func SaveConfig_600_18()
	; <><><><> Village / Notify <><><><>
	ApplyConfig_600_18(GetApplyConfigSaveAction())
	_Ini_Add("notify", "TGEnabled", $g_bNotifyTGEnable ? 1 : 0)
	_Ini_Add("notify", "TGToken", $g_sNotifyTGToken)
	_Ini_Add("notify", "TGUserID", $g_sTGChatID)
	;Remote Control
	_Ini_Add("notify", "PBRemote", $g_bNotifyRemoteEnable ? 1 : 0)
	_Ini_Add("notify", "HoursPushBullet", $g_iNotifyDeletePushesOlderThanHours)
	_Ini_Add("notify", "Origin", $g_sNotifyOrigin)
	;Alerts
	_Ini_Add("notify", "AlertPBVMFound", $g_bNotifyAlertMatchFound ? 1 : 0)
	_Ini_Add("notify", "AlertPBLastRaid", $g_bNotifyAlerLastRaidIMG ? 1 : 0)
	_Ini_Add("notify", "AlertPBWallUpgrade", $g_bNotifyAlertUpgradeWalls ? 1 : 0)
	_Ini_Add("notify", "AlertPBOOS", $g_bNotifyAlertOutOfSync ? 1 : 0)
	_Ini_Add("notify", "AlertPBVBreak", $g_bNotifyAlertTakeBreak ? 1 : 0)
	_Ini_Add("notify", "AlertPBOtherDevice", $g_bNotifyAlertAnotherDevice ? 1 : 0)
	_Ini_Add("notify", "AlertPBLastRaidTxt", $g_bNotifyAlerLastRaidTXT ? 1 : 0)
	_Ini_Add("notify", "AlertPBCampFull", $g_bNotifyAlertCampFull ? 1 : 0)
	_Ini_Add("notify", "AlertPBVillage", $g_bNotifyAlertVillageReport ? 1 : 0)
	_Ini_Add("notify", "AlertPBLastAttack", $g_bNotifyAlertLastAttack ? 1 : 0)
	_Ini_Add("notify", "AlertBuilderIdle", $g_bNotifyAlertBulderIdle ? 1 : 0)
	_Ini_Add("notify", "AlertPBMaintenance", $g_bNotifyAlertMaintenance ? 1 : 0)
	_Ini_Add("notify", "AlertPBBAN", $g_bNotifyAlertBAN ? 1 : 0)
	_Ini_Add("notify", "AlertPBUpdate", $g_bNotifyAlertBOTUpdate ? 1 : 0)
	_Ini_Add("notify", "AlertLaboratoryIdle", $g_bNotifyAlertLaboratoryIdle ? 1 : 0)
EndFunc   ;==>SaveConfig_600_18

Func SaveConfig_600_19()
	; <><><><> Village / Notify <><><><>
	ApplyConfig_600_19(GetApplyConfigSaveAction())
	_Ini_Add("notify", "NotifyHoursEnable", $g_bNotifyScheduleHoursEnable ? 1 : 0)
	Local $string = ""
	For $i = 0 To 23
		$string &= ($g_abNotifyScheduleHours[$i] ? "1" : "0") & "|"
	Next
	_Ini_Add("notify", "NotifyHours", $string)
	_Ini_Add("notify", "NotifyWeekDaysEnable", $g_bNotifyScheduleWeekDaysEnable ? 1 : 0)
	Local $string = ""
	For $i = 0 To 6
		$string &= ($g_abNotifyScheduleWeekDays[$i] ? "1" : "0") & "|"
	Next
	_Ini_Add("notify", "NotifyWeekDays", $string)
EndFunc   ;==>SaveConfig_600_19

; #FUNCTION# ====================================================================================================================
; Name ..........: SaveConfig_CSVMod
; Description ...: Save CSV Mod search/attack settings and CSV override options.
; Syntax ........: SaveConfig_CSVMod()
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
Func SaveConfig_CSVMod()
	SaveConfig_CSVMod_Search()
	SaveConfig_CSVMod_Attack()
	SaveConfig_AttackCSV()
EndFunc   ;==>SaveConfig_CSVMod

; #FUNCTION# ====================================================================================================================
; Name ..........: SaveConfig_CSVMod_Search
; Description ...: Save CSV Mod search settings and remove legacy search filters.
; Syntax ........: SaveConfig_CSVMod_Search()
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
Func SaveConfig_CSVMod_Search()
	Local $aLegacyDBSearchKeys[24] = [ _
			"chkBattleSearchCamps", "DBEnableAfterArmyCamps", "DBMeetGE", "BattleSearchGoldPlusElixir", "DBMeetDE", "DBMeetTH", "DBTHLevel", "DBMeetTHO", _
			"DBMeetDeadEagle", "DBMeetDeadEagleSearch", _
			"DBCheckMortar", "DBCheckWizTower", "DBCheckAirDefense", "DBCheckXBow", "DBCheckInferno", "DBCheckEagle", "DBCheckScatter", _
			"DBWeakMortar", "DBWeakWizTower", "DBWeakAirDefense", "DBWeakXBow", "DBWeakInferno", "DBWeakEagle", "DBWeakScatter"]
	Local $aLegacyABSearchKeys[29] = [ _
			"chkRankedBattleSearchSearches", "ABEnableAfterCount", "ABEnableBeforeCount", "chkRankedBattleSearchCamps", "ABEnableAfterArmyCamps", _
			"ABMeetGE", "ABsearchGold", "ABsearchElixir", "ABsearchGoldPlusElixir", "ABMeetDE", "ABsearchDark", "ABMeetTH", "ABTHLevel", "ABMeetTHO", _
			"ABCheckMortar", "ABCheckWizTower", "ABCheckAirDefense", "ABCheckXBow", "ABCheckInferno", "ABCheckEagle", "ABCheckScatter", _
			"ABWeakMortar", "ABWeakWizTower", "ABWeakAirDefense", "ABWeakXBow", "ABWeakInferno", "ABWeakEagle", "ABWeakScatter", "ABMeetOne"]
	Local $i = 0

	ApplyConfig_CSVMod_Search_Battle(GetApplyConfigSaveAction())
	ApplyConfig_CSVMod_Search_Ranked(GetApplyConfigSaveAction())

	; Search options shared by CSV Mod flow.
	_Ini_Add("search", "reduction", $g_bSearchReductionEnable ? 1 : 0)
	_Ini_Add("search", "reduceCount", $g_iSearchReductionCount)
	_Ini_Add("search", "reduceGold", $g_iSearchReductionGold)
	_Ini_Add("search", "reduceElixir", $g_iSearchReductionElixir)
	_Ini_Add("search", "reduceGoldPlusElixir", $g_iSearchReductionGoldPlusElixir)
	_Ini_Add("search", "reduceDark", $g_iSearchReductionDark)
	_Ini_Add("other", "VSDelay", $g_iSearchDelayMin)
	_Ini_Add("other", "MaxVSDelay", $g_iSearchDelayMax)
	_Ini_Add("general", "attacknow", $g_bSearchAttackNowEnable ? 1 : 0)
	_Ini_Add("general", "attacknowdelay", $g_iSearchAttackNowDelay)
	_Ini_Add("search", "ChkRestartSearchLimit", $g_bSearchRestartEnable ? 1 : 0)
	_Ini_Add("search", "RestartSearchLimit", $g_iSearchRestartLimit)
	_Ini_Add("general", "AlertSearch", $g_bSearchAlertMe ? 1 : 0)
	_Ini_Add("search", "DisableFullResources", $g_bSearchDisableFullResources ? 1 : 0)

	; Battle (Deadbase) CSV Mod search.
	_Ini_Add("search", "BattleCheck", $g_abAttackTypeEnable[$Battle] ? 1 : 0)
	_Ini_Add("search", "chkBattleSearchSearches", $g_abSearchSearchesEnable[$Battle] ? 1 : 0)
	_Ini_Add("search", "BattleEnableAfterCount", $g_aiSearchSearchesMin[$Battle])
	_Ini_Add("search", "BattleEnableBeforeCount", $g_aiSearchSearchesMax[$Battle])
	_Ini_Add("search", "chkBattleCastleWait", $g_abSearchCastleWaitEnable[$Battle] ? 1 : 0)
	_Ini_Add("search", "BattleSearchGold", $g_aiFilterMinGold[$Battle])
	_Ini_Add("search", "BattleSearchElixir", $g_aiFilterMinElixir[$Battle])
	_Ini_Add("search", "BattleSearchDark", $g_aiFilterMeetDEMin[$Battle])
	_Ini_Add("search", "BattleMeetOne", $g_abFilterMeetOneConditionEnable[$Battle] ? 1 : 0)
	_Ini_Add("search", "BattleUseLegacyDeadbaseGate", $g_bBattleUseLegacyDeadbaseGate ? 1 : 0)

	For $i = 0 To UBound($aLegacyDBSearchKeys) - 1
		_Ini_Delete("search", $aLegacyDBSearchKeys[$i])
	Next

	; Ranked battle keeps mode enable + wait for CC.
	_Ini_Add("search", "RankedBattleCheck", $g_abAttackTypeEnable[$RankedBattle] ? 1 : 0)
	_Ini_Add("search", "chkRankedBattleCastleWait", $g_abSearchCastleWaitEnable[$RankedBattle] ? 1 : 0)
	For $i = 0 To UBound($aLegacyABSearchKeys) - 1
		_Ini_Delete("search", $aLegacyABSearchKeys[$i])
	Next
EndFunc   ;==>SaveConfig_CSVMod_Search

; #FUNCTION# ====================================================================================================================
; Name ..........: SaveConfig_CSVMod_Attack
; Description ...: Save CSV Mod attack-mode settings and script selections.
; Syntax ........: SaveConfig_CSVMod_Attack()
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
Func SaveConfig_CSVMod_Attack()
	Local $sBattleScript = AttackCSVSettings_GetScriptName($Battle)
	Local $sRankedScript = AttackCSVSettings_GetScriptName($RankedBattle)

	_SaveConfig_CSVMod_SyncHeroAbilityFromGui()
	_SaveConfig_CSVMod_SyncAttackModeFromGui($Battle)
	_SaveConfig_CSVMod_SyncAttackModeFromGui($RankedBattle)

	If $sBattleScript <> "" Then $g_sAttackScrScriptName[$Battle] = $sBattleScript
	If $sRankedScript <> "" Then $g_sAttackScrScriptName[$RankedBattle] = $sRankedScript
	$g_sAttackScrScriptNameRankedBattle = $g_sAttackScrScriptName[$RankedBattle]

	_Ini_Add("attack", "ActivateQueen", $g_iActivateQueen)
	_Ini_Add("attack", "ActivateKing", $g_iActivateKing)
	_Ini_Add("attack", "ActivateWarden", $g_iActivateWarden)
	_Ini_Add("attack", "ActivateChampion", $g_iActivateChampion)
	_Ini_Add("attack", "ActivatePrince", $g_iActivatePrince)
	_Ini_Add("attack", "delayActivateQueen", $g_iDelayActivateQueen)
	_Ini_Add("attack", "delayActivateKing", $g_iDelayActivateKing)
	_Ini_Add("attack", "delayActivateWarden", $g_iDelayActivateWarden)
	_Ini_Add("attack", "delayActivateChampion", $g_iDelayActivateChampion)
	_Ini_Add("attack", "delayActivatePrince", $g_iDelayActivatePrince)

	_Ini_Add("attack", "DBAtkAlgorithm", $g_aiAttackAlgorithm[$Battle])
	_Ini_Add("attack", "DBSelectTroop", $g_aiAttackTroopSelection[$Battle])
	_Ini_Add("attack", "DBKingAtk", BitAND($g_aiAttackUseHeroes[$Battle], $eHeroKing))
	_Ini_Add("attack", "DBQueenAtk", BitAND($g_aiAttackUseHeroes[$Battle], $eHeroQueen))
	_Ini_Add("attack", "DBWardenAtk", BitAND($g_aiAttackUseHeroes[$Battle], $eHeroWarden))
	_Ini_Add("attack", "DBChampionAtk", BitAND($g_aiAttackUseHeroes[$Battle], $eHeroChampion))
	_Ini_Add("attack", "DBDropCC", $g_abAttackDropCC[$Battle] ? 1 : 0)
	_Ini_Add("attack", "DBAtkUseWardenMode", $g_aiAttackUseWardenMode[$Battle])
	_Ini_Add("attack", "DBAtkUseSiege", $g_aiAttackUseSiege[$Battle])
	_Ini_Add("attack", "DBDropEmptySiege", $g_bDropEmptySiege[$Battle] ? 1 : 0)
	_Ini_Add("attack", "DBSwapEmptyBlimp", $g_bSwapEmptyBlimp[$Battle] ? 1 : 0)
	_Ini_Add("attack", "RedlineRoutineBattle", $g_aiAttackScrRedlineRoutine[$Battle])
	_Ini_Add("attack", "DroplineEdgeBattle", $g_aiAttackScrDroplineEdge[$Battle])
	_Ini_Add("attack", "ScriptBattle", $g_sAttackScrScriptName[$Battle])

	_Ini_Add("attack", "ABAtkAlgorithm", $g_aiAttackAlgorithm[$RankedBattle])
	_Ini_Add("attack", "ABSelectTroop", $g_aiAttackTroopSelection[$RankedBattle])
	_Ini_Add("attack", "ABKingAtk", BitAND($g_aiAttackUseHeroes[$RankedBattle], $eHeroKing))
	_Ini_Add("attack", "ABQueenAtk", BitAND($g_aiAttackUseHeroes[$RankedBattle], $eHeroQueen))
	_Ini_Add("attack", "ABWardenAtk", BitAND($g_aiAttackUseHeroes[$RankedBattle], $eHeroWarden))
	_Ini_Add("attack", "ABChampionAtk", BitAND($g_aiAttackUseHeroes[$RankedBattle], $eHeroChampion))
	_Ini_Add("attack", "ABDropCC", $g_abAttackDropCC[$RankedBattle] ? 1 : 0)
	_Ini_Add("attack", "ABAtkUseWardenMode", $g_aiAttackUseWardenMode[$RankedBattle])
	_Ini_Add("attack", "ABAtkUseSiege", $g_aiAttackUseSiege[$RankedBattle])
	_Ini_Add("attack", "ABDropEmptySiege", $g_bDropEmptySiege[$RankedBattle] ? 1 : 0)
	_Ini_Add("attack", "ABSwapEmptyBlimp", $g_bSwapEmptyBlimp[$RankedBattle] ? 1 : 0)
	_Ini_Add("attack", "RedlineRoutineRankedBattle", $g_aiAttackScrRedlineRoutine[$RankedBattle])
	_Ini_Add("attack", "DroplineEdgeRankedBattle", $g_aiAttackScrDroplineEdge[$RankedBattle])
	_Ini_Add("attack", "ScriptRanked", $g_sAttackScrScriptName[$RankedBattle])
EndFunc   ;==>SaveConfig_CSVMod_Attack

; #FUNCTION# ====================================================================================================================
; Name ..........: _SaveConfig_CSVMod_SyncHeroAbilityFromGui
; Description ...: Read hero ability controls from CSV Mod attack tab into globals.
; Syntax ........: _SaveConfig_CSVMod_SyncHeroAbilityFromGui()
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
Func _SaveConfig_CSVMod_SyncHeroAbilityFromGui()
	If $g_hRadAutoQueenAbility <> 0 Then
		If GUICtrlRead($g_hRadAutoQueenAbility) = $GUI_CHECKED Then
			$g_iActivateQueen = 0
		ElseIf GUICtrlRead($g_hRadManQueenAbility) = $GUI_CHECKED Then
			$g_iActivateQueen = 1
		ElseIf GUICtrlRead($g_hRadBothQueenAbility) = $GUI_CHECKED Then
			$g_iActivateQueen = 2
		EndIf
	EndIf
	If $g_hTxtManQueenAbility <> 0 Then $g_iDelayActivateQueen = Int(GUICtrlRead($g_hTxtManQueenAbility) * 1000)

	If $g_hRadAutoKingAbility <> 0 Then
		If GUICtrlRead($g_hRadAutoKingAbility) = $GUI_CHECKED Then
			$g_iActivateKing = 0
		ElseIf GUICtrlRead($g_hRadManKingAbility) = $GUI_CHECKED Then
			$g_iActivateKing = 1
		ElseIf GUICtrlRead($g_hRadBothKingAbility) = $GUI_CHECKED Then
			$g_iActivateKing = 2
		EndIf
	EndIf
	If $g_hTxtManKingAbility <> 0 Then $g_iDelayActivateKing = Int(GUICtrlRead($g_hTxtManKingAbility) * 1000)

	If $g_hRadAutoWardenAbility <> 0 Then
		If GUICtrlRead($g_hRadAutoWardenAbility) = $GUI_CHECKED Then
			$g_iActivateWarden = 0
		ElseIf GUICtrlRead($g_hRadManWardenAbility) = $GUI_CHECKED Then
			$g_iActivateWarden = 1
		ElseIf GUICtrlRead($g_hRadBothWardenAbility) = $GUI_CHECKED Then
			$g_iActivateWarden = 2
		EndIf
	EndIf
	If $g_hTxtManWardenAbility <> 0 Then $g_iDelayActivateWarden = Int(GUICtrlRead($g_hTxtManWardenAbility) * 1000)

	If $g_hRadAutoChampionAbility <> 0 Then
		If GUICtrlRead($g_hRadAutoChampionAbility) = $GUI_CHECKED Then
			$g_iActivateChampion = 0
		ElseIf GUICtrlRead($g_hRadManChampionAbility) = $GUI_CHECKED Then
			$g_iActivateChampion = 1
		ElseIf GUICtrlRead($g_hRadBothChampionAbility) = $GUI_CHECKED Then
			$g_iActivateChampion = 2
		EndIf
	EndIf
	If $g_hTxtManChampionAbility <> 0 Then $g_iDelayActivateChampion = Int(GUICtrlRead($g_hTxtManChampionAbility) * 1000)

	If $g_hRadAutoPrinceAbility <> 0 Then
		If GUICtrlRead($g_hRadAutoPrinceAbility) = $GUI_CHECKED Then
			$g_iActivatePrince = 0
		ElseIf GUICtrlRead($g_hRadManPrinceAbility) = $GUI_CHECKED Then
			$g_iActivatePrince = 1
		ElseIf GUICtrlRead($g_hRadBothPrinceAbility) = $GUI_CHECKED Then
			$g_iActivatePrince = 2
		EndIf
	EndIf
	If $g_hTxtManPrinceAbility <> 0 Then $g_iDelayActivatePrince = Int(GUICtrlRead($g_hTxtManPrinceAbility) * 1000)
EndFunc   ;==>_SaveConfig_CSVMod_SyncHeroAbilityFromGui

; #FUNCTION# ====================================================================================================================
; Name ..........: _SaveConfig_CSVMod_SyncAttackModeFromGui
; Description ...: Read CSV Mod per-mode attack controls into globals.
; Syntax ........: _SaveConfig_CSVMod_SyncAttackModeFromGui($iMode)
; Parameters ....: $iMode             - Mode index ($Battle/$RankedBattle)
; Return values .: None
; Author ........: mxkcz
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _SaveConfig_CSVMod_SyncAttackModeFromGui($iMode)
	Local $hCmbAlgorithm = 0, $hCmbSelectTroop = 0
	Local $hChkDropCC = 0, $hCmbWardenMode = 0, $hCmbSiege = 0, $hChkDropEmptySiege = 0, $hChkSwapEmptyBlimp = 0
	Local $iSel = 0

	Switch $iMode
		Case $Battle
			$hCmbAlgorithm = $g_hCmbBattleAlgorithm
			$hCmbSelectTroop = $g_hCmbBattleSelectTroop
			$hChkDropCC = $g_hchkBattleDropCC
			$hCmbWardenMode = $g_hCmbBattleWardenMode
			$hCmbSiege = $g_hCmbBattleSiege
			$hChkDropEmptySiege = $g_hchkBattleDropEmptySiege
			$hChkSwapEmptyBlimp = $g_hchkBattleSwapEmptyBlimp
		Case $RankedBattle
			$hCmbAlgorithm = $g_hCmbRankedBattleAlgorithm
			$hCmbSelectTroop = $g_hCmbRankedBattleSelectTroop
			$hChkDropCC = $g_hchkRankedBattleDropCC
			$hCmbWardenMode = $g_hCmbRankedBattleWardenMode
			$hCmbSiege = $g_hCmbRankedBattleSiege
			$hChkDropEmptySiege = $g_hchkRankedBattleDropEmptySiege
			$hChkSwapEmptyBlimp = $g_hchkRankedBattleSwapEmptyBlimp
		Case Else
			Return
	EndSwitch

	If $hCmbAlgorithm <> 0 Then
		$iSel = _GUICtrlComboBox_GetCurSel($hCmbAlgorithm)
		If $iSel >= 0 Then $g_aiAttackAlgorithm[$iMode] = $iSel
	EndIf
	If $hCmbSelectTroop <> 0 Then
		$iSel = _GUICtrlComboBox_GetCurSel($hCmbSelectTroop)
		If $iSel >= 0 Then $g_aiAttackTroopSelection[$iMode] = $iSel
	EndIf

	If $hChkDropCC <> 0 Then $g_abAttackDropCC[$iMode] = (GUICtrlRead($hChkDropCC) = $GUI_CHECKED)
	If $hCmbWardenMode <> 0 Then
		$iSel = _GUICtrlComboBox_GetCurSel($hCmbWardenMode)
		If $iSel >= 0 Then $g_aiAttackUseWardenMode[$iMode] = $iSel
	EndIf
	If $hCmbSiege <> 0 Then
		$iSel = _GUICtrlComboBox_GetCurSel($hCmbSiege)
		If $iSel >= 0 Then $g_aiAttackUseSiege[$iMode] = $iSel
	EndIf
	If $hChkDropEmptySiege <> 0 Then $g_bDropEmptySiege[$iMode] = (GUICtrlRead($hChkDropEmptySiege) = $GUI_CHECKED)
	If $hChkSwapEmptyBlimp <> 0 Then $g_bSwapEmptyBlimp[$iMode] = (GUICtrlRead($hChkSwapEmptyBlimp) = $GUI_CHECKED)
EndFunc   ;==>_SaveConfig_CSVMod_SyncAttackModeFromGui

; #FUNCTION# ====================================================================================================================
; Name ..........: SaveConfig_AttackCSV
; Description ...: Persist CSV RECALC override settings to config.
; Syntax ........: SaveConfig_AttackCSV()
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
Func SaveConfig_AttackCSV()
	_Ini_Add("attackcsv", "recalc_side_override", $g_sCSVRecalcSideOverride)
	_Ini_Add("attackcsv", "recalc_vector_targets", $g_sCSVRecalcVectorTargets)
	_Ini_Add("attackcsv", "precache_mode", $g_iCSVPrecacheMode)
EndFunc   ;==>SaveConfig_AttackCSV

Func SaveConfig_600_35_1()
	; <><><><> Bot / Options <><><><>
	ApplyConfig_600_35_1(GetApplyConfigSaveAction())
	_Ini_Add("other", "language", $g_sLanguage)
	_Ini_Add("General", "ChkDisableSplash", $g_bDisableSplash ? 1 : 0)
	_Ini_Add("General", "ChkVersion", $g_bCheckVersion ? 1 : 0)
	_Ini_Add("deletefiles", "DeleteLogs", $g_bDeleteLogs ? 1 : 0)
	_Ini_Add("deletefiles", "DeleteLogsDays", $g_iDeleteLogsDays)
	_Ini_Add("deletefiles", "DeleteTemp", $g_bDeleteTemp ? 1 : 0)
	_Ini_Add("deletefiles", "DeleteTempDays", $g_iDeleteTempDays)
	_Ini_Add("deletefiles", "DeleteLoots", $g_bDeleteLoots ? 1 : 0)
	_Ini_Add("deletefiles", "DeleteLootsDays", $g_iDeleteLootsDays)
	_Ini_Add("general", "AutoStart", $g_bAutoStart ? 1 : 0)
	_Ini_Add("general", "AutoStartDelay", $g_iAutoStartDelay)
	_Ini_Add("general", "DisposeWindows", $g_bAutoAlignEnable ? 1 : 0)
	_Ini_Add("general", "DisposeWindowsPos", $g_iAutoAlignPosition)
	_Ini_Add("other", "WAOffsetX", $g_iAutoAlignOffsetX)
	_Ini_Add("other", "WAOffsetY", $g_iAutoAlignOffsetY)
	_Ini_Add("general", "UpdatingWhenMinimized", $g_bUpdatingWhenMinimized ? 1 : 0)
	_Ini_Add("general", "HideWhenMinimized", $g_bHideWhenMinimized ? 1 : 0)

	_Ini_Add("other", "UseRandomClick", $g_bUseRandomClick ? 1 : 0)
	_Ini_Add("other", "ScreenshotType", $g_bScreenshotPNGFormat ? 1 : 0)
	_Ini_Add("other", "ScreenshotHideName", $g_bScreenshotHideName ? 1 : 0)
	_Ini_Add("other", "txtTimeWakeUp", $g_iAnotherDeviceWaitTime)
	_Ini_Add("other", "ChkSwitchOnAnotherDevice", $g_bChkSwitchOnAnotherDevice ? 1 : 0)
	_Ini_Add("other", "chkSinglePBTForced", $g_bForceSinglePBLogoff ? 1 : 0)
	_Ini_Add("other", "ValueSinglePBTimeForced", $g_iSinglePBForcedLogoffTime)
	_Ini_Add("other", "ValuePBTimeForcedExit", $g_iSinglePBForcedEarlyExitTime)
	_Ini_Add("other", "ChkAutoResume", $g_bAutoResumeEnable ? 1 : 0)
	_Ini_Add("other", "AutoResumeTime", $g_iAutoResumeTime)
	_Ini_Add("other", "ChkDisableNotifications", $g_bDisableNotifications)
	_Ini_Add("other", "ChkSqlite", $g_bUseStatistics ? 1 : 0)
EndFunc   ;==>SaveConfig_600_35_1

Func SaveConfig_600_35_2()
	; <><><><> Bot / Profile / Switch Account <><><><>
	ApplyConfig_600_35_2(GetApplyConfigSaveAction())
	Local $sSwitchAccFile
	Local $iCmbSwitchAcc = $g_iCmbSwitchAcc
	If $iCmbSwitchAcc = 0 Then
		; find group this profile belongs to: no switch profile config is saved in config.ini on purpose!
		For $g = 1 To UBound($iCmbSwitchAcc) ;group number
			$sSwitchAccFile = $g_sProfilePath & "\SwitchAccount.0" & $g & ".ini"
			If FileExists($sSwitchAccFile) = 0 Then ContinueLoop
			Local $sProfile
			Local $bEnabled
			For $i = 1 To UBound($g_abAccountNo)
				$bEnabled = IniRead($sSwitchAccFile, "SwitchAccount", "Enable" & $i, "") = "1"
				If $bEnabled Then
					$bEnabled = IniRead($sSwitchAccFile, "SwitchAccount", "AccountNo." & $i, "") = "1"
					If $bEnabled Then
						$sProfile = IniRead($sSwitchAccFile, "SwitchAccount", "ProfileName." & $i, "")
						If $sProfile = $g_sProfileCurrentName Then
							; found current profile
							$iCmbSwitchAcc = $g
							ExitLoop 2
						EndIf
					EndIf
				EndIf
			Next
		Next
	EndIf
	If $iCmbSwitchAcc Then
		$sSwitchAccFile = $g_sProfilePath & "\SwitchAccount.0" & $iCmbSwitchAcc & ".ini"
		IniWrite($sSwitchAccFile, "SwitchAccount", "Enable", $g_bChkSwitchAcc ? 1 : 0)
		IniWrite($sSwitchAccFile, "SwitchAccount", "SuperCellID", $g_bChkSuperCellID ? 1 : 0)
		IniWrite($sSwitchAccFile, "SwitchAccount", "SharedPrefs", $g_bChkSharedPrefs ? 1 : 0)
		IniWrite($sSwitchAccFile, "SwitchAccount", "TotalCocAccount", $g_iTotalAcc)
		For $i = 1 To UBound($g_abAccountNo)
			IniWrite($sSwitchAccFile, "SwitchAccount", "AccountNo." & $i, $g_abAccountNo[$i - 1] ? 1 : 0)
			IniWrite($sSwitchAccFile, "SwitchAccount", "ProfileName." & $i, $g_asProfileName[$i - 1])
			IniWrite($sSwitchAccFile, "SwitchAccount", "DonateOnly." & $i, $g_abDonateOnly[$i - 1] ? 1 : 0)
		Next
	EndIf

EndFunc   ;==>SaveConfig_600_35_2

Func SaveConfig_600_52_2()
	; troop/spell levels and counts
	ApplyConfig_600_52_2(GetApplyConfigSaveAction())
	For $t = 0 To $eTroopCount - 1
		_Ini_Add("troop", $g_asTroopShortNames[$t], $g_aiArmyCustomTroops[$t])
	Next

	For $s = 0 To $eSpellCount - 1
		_Ini_Add("Spells", $g_asSpellShortNames[$s], $g_aiArmyCustomSpells[$s])
	Next
	For $s = 0 To $eSiegeMachineCount - 1
		_Ini_Add("Siege", $g_asSiegeMachineShortNames[$s], $g_aiArmyCustomSiegeMachines[$s])
	Next
	; full & forced Total Camp values
	_Ini_Add("troop", "fulltroop", $g_iTrainArmyFullTroopPct)
	_Ini_Add("other", "ValueTotalCampForced", $g_iTotalCampForcedValue)
	; spell capacity and forced flag
	_Ini_Add("Spells", "SpellFactory", $g_iTotalSpellValue)
	; DoubleTrain - Demen
	_Ini_Add("troop", "DoubleTrain", $g_bDoubleTrain ? 1 : 0)
	_Ini_Add("troop", "PreciseArmy", $g_bPreciseArmy ? 1 : 0)
EndFunc   ;==>SaveConfig_600_52_2

Func SaveConfig_600_54()
	; <><><> Attack Plan / Train Army / Train Order <><><>
	ApplyConfig_600_54(GetApplyConfigSaveAction())

	; Troops Order
	_Ini_Add("troop", "chkTroopOrder", $g_bCustomTrainOrderEnable ? 1 : 0)
	For $z = 0 To UBound($g_aiCmbCustomTrainOrder) - 1
		_Ini_Add("troop", "cmbTroopOrder" & $z, $g_aiCmbCustomTrainOrder[$z])
	Next

	; Spells Order
	_Ini_Add("SpellsOrder", "chkSpellOrder", $g_bCustomBrewOrderEnable ? 1 : 0)
	For $z = 0 To UBound($g_aiCmbCustomBrewOrder) - 1
		_Ini_Add("SpellsOrder", "cmbSpellOrder" & $z, $g_aiCmbCustomBrewOrder[$z])
	Next
EndFunc   ;==>SaveConfig_600_54

Func SaveConfig_600_56()
	; <><><><> Attack Plan / Search & Attack / Options / SmartZap <><><><>
	ApplyConfig_600_56(GetApplyConfigSaveAction())
	_Ini_Add("SmartZap", "UseSmartZap", $g_bSmartZapEnable ? 1 : 0)
	_Ini_Add("SmartZap", "UseEarthQuakeZap", $g_bEarthQuakeZap ? 1 : 0)
	_Ini_Add("SmartZap", "UseNoobZap", $g_bNoobZap ? 1 : 0)
	_Ini_Add("SmartZap", "ZapDBOnly", $g_bSmartZapDB ? 1 : 0)
	_Ini_Add("SmartZap", "THSnipeSaveHeroes", $g_bSmartZapSaveHeroes ? 1 : 0)
	_Ini_Add("SmartZap", "FTW", $g_bSmartZapFTW ? 1 : 0)
	_Ini_Add("SmartZap", "MinDE", $g_iSmartZapMinDE)
	_Ini_Add("SmartZap", "ExpectedDE", $g_iSmartZapExpectedDE)
	_Ini_Add("SmartZap", "EarlyZap", $g_bEarlyZap ? 1 : 0)
EndFunc   ;==>SaveConfig_600_56

Func SaveConfig_641_1()
	; <><><> Attack Plan / Train Army / Options <><><>
	ApplyConfig_641_1(GetApplyConfigSaveAction())
	; Training idle time
	; Train click timing
	_Ini_Add("other", "TrainITDelay", $g_iTrainClickDelay)
	; Training add random delay
	_Ini_Add("other", "chkAddIdleTime", $g_bTrainAddRandomDelayEnable ? 1 : 0)
	_Ini_Add("other", "txtAddDelayIdlePhaseTimeMin", $g_iTrainAddRandomDelayMin)
	_Ini_Add("other", "txtAddDelayIdlePhaseTimeMax", $g_iTrainAddRandomDelayMax)
EndFunc   ;==>SaveConfig_641_1

Func IniWriteS($filename, $section, $key, $value)
	;save in standard config files and also save settings in strategy ini file (save strategy button valorize variable $g_sProfileSecondaryOutputFileName )
	Local $s = $section
	Local $k = $key
	IniWrite($filename, $section, $key, $value)
EndFunc   ;==>IniWriteS

Func GetApplyConfigSaveAction()
	; in Mini GUI Mode the "Save" is replaced with "Save(disabled)" as controlls don't exists
	If $g_iGuiMode <> 1 Then
		Return "Save(disabled)"
	EndIf

	Return "Save"
EndFunc   ;==>GetApplyConfigSaveAction
