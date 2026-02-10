; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Variables
; Description ...: This file Includes several files in the current script and all Declared variables, constant, or create an array.
; Syntax ........: #include , Global
; Parameters ....: $action_groupe, $group_de_controle
; Return values .: None
; Author ........: Boju(2016)
; Modified ......: MR.ViPER (11-2016), CodeSlinger69 (2017), MMHK (01-2018)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_aGroupSearchBattle= "", $groupSpellsDB = "", $groupSpellsAB = "", $groupSearchTS = ""

;Attack
Global $g_aGroupAttackBattle = "", $g_aGroupAttackBattleSpell = "", $groupIMGAttackDB = "", $groupIMGAttackDBSpell = "", $groupAttackAB = "", $groupAttackABSpell = "", _
	   $groupIMGAttackAB = "", $groupIMGAttackABSpell = "", $groupAttackTS = "", $groupAttackTSSpell = "", $groupIMGAttackTS = "", $groupIMGAttackTSSpell = ""

;Spell
Global $groupLightning = "", $groupHeal = "", $groupRage = "", $groupJump = "", $groupFreeze = "", $groupClone = "", $groupInvisibility = ""

;Dark Spell
Global $groupPoison = "", $groupEarthquake = "", $groupHaste = "", $groupSkeleton = "", $groupBat = ""

;All Spells
Global $groupListSpells = ""

;TH Level
Global $g_aGroupListTHLevels = ""

;PicDBMaxTH
Global $g_aGroupListPicBMaxTH = ""

;PicABMaxTH
Global $g_aGroupListPicRBMaxTH = ""

;PicBullyMaxTH
Global $g_aGroupListPicBullyMaxTH = ""

; Groups of controls
Global $aTabControlsVillage, $aTabControlsMisc, $aTabControlsDonate, $aTabControlsUpgrade, $aTabControlsNotify

Global $aTabControlsStrategies, $aTabControlsBot, $aTabControlsStats
Global $oAlwaysEnabledControls = ObjCreate("Scripting.Dictionary")

Func InitializeControlVariables()
   $g_aGroupSearchBattle = $g_hchkBattleWaitForCastle & "#" & $g_hTxtDBMinGold & "#" & $g_hPicDBMinGold & "#" & _
					    $g_hTxtDBMinElixir & "#" & $g_hPicDBMinElixir & "#" & $g_hTxtDBMinDarkElixir & "#" & _
					    $g_hPicDBMinDarkElixir & "#" & $g_hChkSearchDisableFullResources & "#" & $g_ahChkMeetOne[$Battle]

   ; Groups of controls
   Dim $aTabControlsVillage = [$g_hGUI_VILLAGE_TAB, $g_hGUI_VILLAGE_TAB_ITEM1, $g_hGUI_VILLAGE_TAB_ITEM2, $g_hGUI_VILLAGE_TAB_ITEM3, $g_hGUI_VILLAGE_TAB_ITEM4, $g_hGUI_VILLAGE_TAB_ITEM5]
   Dim $aTabControlsMisc = [$g_hGUI_MISC_TAB, $g_hGUI_MISC_TAB_ITEM1, $g_hGUI_MISC_TAB_ITEM2, $g_hGUI_MISC_TAB_ITEM3, $g_hGUI_MISC_TAB_ITEM4]
   Dim $aTabControlsDonate = [$g_hGUI_DONATE_TAB, $g_hGUI_DONATE_TAB_ITEM1, $g_hGUI_DONATE_TAB_ITEM2]
   Dim $aTabControlsUpgrade = [$g_hGUI_UPGRADE_TAB, $g_hGUI_UPGRADE_TAB_ITEM1, $g_hGUI_UPGRADE_TAB_ITEM2, $g_hGUI_UPGRADE_TAB_ITEM3, $g_hGUI_UPGRADE_TAB_ITEM4, $g_hGUI_UPGRADE_TAB_ITEM5]
   Dim $aTabControlsNotify = [$g_hGUI_NOTIFY_TAB, $g_hGUI_NOTIFY_TAB_ITEM2]

   Dim $aTabControlsBuilderBase = [$g_hGUI_BB_TAB, $g_hGUI_BB_TAB_ITEM1, $g_hGUI_BB_TAB_ITEM2]

   Dim $aTabControlsBot = [$g_hGUI_BOT_TAB, $g_hGUI_BOT_TAB_ITEM1, $g_hGUI_BOT_TAB_ITEM2, $g_hGUI_BOT_TAB_ITEM3, $g_hGUI_BOT_TAB_ITEM4, $g_hGUI_BOT_TAB_ITEM5]
   Dim $aTabControlsStats = [$g_hGUI_STATS_TAB, $g_hGUI_STATS_TAB_ITEM1, $g_hGUI_STATS_TAB_ITEM2, $g_hGUI_STATS_TAB_ITEM3, $g_hGUI_STATS_TAB_ITEM4, $g_hGUI_STATS_TAB_ITEM5]

	; always enabled / unchanged controls during enabling/disabling all GUI controls function
	;$oAlwaysEnabledControls($g_hChkUpdatingWhenMinimized) = 1
	$oAlwaysEnabledControls($g_hChkHideWhenMinimized) = 1
	$oAlwaysEnabledControls($g_hChkDebugSetlog) = 1
	$oAlwaysEnabledControls($g_hChkDebugAndroid) = 1
	$oAlwaysEnabledControls($g_hChkDebugClick) = 1
	$oAlwaysEnabledControls($g_hChkDebugFunc) = 1
	$oAlwaysEnabledControls($g_hChkDebugDisableZoomout) = 1
	$oAlwaysEnabledControls($g_hChkDebugDeadbaseImage) = 1
	$oAlwaysEnabledControls($g_hChkDebugOCR) = 1
	$oAlwaysEnabledControls($g_hChkDebugImageSave) = 1
	$oAlwaysEnabledControls($g_hChkdebugBuildingPos) = 1
	$oAlwaysEnabledControls($g_hChkdebugTrain) = 1
	$oAlwaysEnabledControls($g_hChkDebugOCRDonate) = 1
	;~ $oAlwaysEnabledControls($g_hChkDebugSmartZap) = 1
	$oAlwaysEnabledControls($g_hBtnTestTrain) = 1
	$oAlwaysEnabledControls($g_hBtnTestDonateCC) = 1
	$oAlwaysEnabledControls($g_hBtnTestRequestCC) = 1
	$oAlwaysEnabledControls($g_hBtnTestSendText) = 1
	$oAlwaysEnabledControls($g_hBtnTestAttackBar) = 1
	$oAlwaysEnabledControls($g_hBtnTestClickDrag) = 1
	$oAlwaysEnabledControls($g_hBtnTestImage) = 1
	$oAlwaysEnabledControls($g_hBtnTestVillageSize) = 1
	$oAlwaysEnabledControls($g_hBtnTestDeadBase) = 1
	$oAlwaysEnabledControls($g_hBtnTestDeadBaseFolder) = 1
	$oAlwaysEnabledControls($g_hBtnTestTHimgloc) = 1
	$oAlwaysEnabledControls($g_hBtnTestQuickTrainsimgloc) = 1
	$oAlwaysEnabledControls($g_hChkdebugAttackCSV) = 1
	$oAlwaysEnabledControls($g_hChkMakeIMGCSV) = 1
	$oAlwaysEnabledControls($g_hBtnTestAttackCSV) = 1
	$oAlwaysEnabledControls($g_hBtnTestBuildingLocation) = 1
	$oAlwaysEnabledControls($g_hBtnRunFunction) = 1
	$oAlwaysEnabledControls($g_hTxtRunFunction) = 1
	$oAlwaysEnabledControls($g_hBtnTestCleanYard) = 1
	$oAlwaysEnabledControls($g_hLblSmartLightningUsed) = 1
	$oAlwaysEnabledControls($g_hLblSmartZap) = 1
	$oAlwaysEnabledControls($g_hLblSmartEarthQuakeUsed) = 1
	$oAlwaysEnabledControls($g_hBtnTestConfigSave) = 1
	$oAlwaysEnabledControls($g_hBtnTestConfigRead) = 1
	$oAlwaysEnabledControls($g_hBtnTestConfigApply) = 1
	$oAlwaysEnabledControls($g_hBtnTestWeakBase) = 1
	$oAlwaysEnabledControls($g_hBtnConsoleWindow) = 1

	$oAlwaysEnabledControls($g_hBtnAndroidAdbShell) = 1
	$oAlwaysEnabledControls($g_hBtnAndroidHome) = 1
	$oAlwaysEnabledControls($g_hBtnAndroidBack) = 1
	$oAlwaysEnabledControls($g_hBtnPullSharedPrefs) = 1

	$oAlwaysEnabledControls($g_hBtnMakeScreenshot) = 1
	$oAlwaysEnabledControls($g_hDivider) = 1
	$oAlwaysEnabledControls($lbl_LogStyle) = 1
	$oAlwaysEnabledControls($g_hBtnAttackNowDB) = 1
	$oAlwaysEnabledControls($g_hBtnAttackNowLB) = 1

	$oAlwaysEnabledControls($g_hTabMain) = 1
	$oAlwaysEnabledControls($g_hTabLog) = 1
	$oAlwaysEnabledControls($g_hTabVillage) = 1
	$oAlwaysEnabledControls($g_hTabAttack) = 1
	$oAlwaysEnabledControls($g_hTabBuilderBase) = 1
	$oAlwaysEnabledControls($g_hTabBot) = 1
	$oAlwaysEnabledControls($g_hTabAbout) = 1

	$oAlwaysEnabledControls($g_hCmbLogDividerOption) = 1
	$oAlwaysEnabledControls($g_hBtnAtkLogClear) = 1
	$oAlwaysEnabledControls($g_hBtnAtkLogCopyClipboard) = 1
	$oAlwaysEnabledControls($g_hBtnOpenFolder) = 1
	$oAlwaysEnabledControls($g_hTxtAutoUpgradeLog) = 1
	$oAlwaysEnabledControls($g_hTxtClanGamesLog) = 1

	For $i in $aTabControlsVillage
		$oAlwaysEnabledControls($i) = 1
	Next
	For $i in $aTabControlsMisc
		$oAlwaysEnabledControls($i) = 1
	Next
	For $i in $aTabControlsDonate
		$oAlwaysEnabledControls($i) = 1
	Next
	For $i in $aTabControlsUpgrade
		$oAlwaysEnabledControls($i) = 1
	Next
	For $i in $aTabControlsNotify
		$oAlwaysEnabledControls($i) = 1
	Next
	For $i in $aTabControlsBuilderBase
		$oAlwaysEnabledControls($i) = 1
	Next
	For $i in $aTabControlsBot
		$oAlwaysEnabledControls($i) = 1
	Next
	For $i in $aTabControlsStats
		$oAlwaysEnabledControls($i) = 1
	Next

EndFunc
