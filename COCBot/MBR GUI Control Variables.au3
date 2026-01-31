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

Global $g_aGroupSearchBattle= "", $groupSearchRB = "", $groupSpellsDB = "", $groupSpellsAB = "", $groupSearchTS = ""

;Attack
Global $g_aGroupAttackB = "", $g_aGroupAttackBSpell = "", $groupIMGAttackDB = "", $groupIMGAttackDBSpell = "", $groupAttackAB = "", $groupAttackABSpell = "", _
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
Global $aTabControlsAttack, $aTabControlsArmy, $aTabControlsSearch, $aTabControlsDeadbase, $aTabControlsActivebase, $aTabControlsAttackOptions
Global $aTabControlsStrategies, $aTabControlsBot, $aTabControlsStats
Global $oAlwaysEnabledControls = ObjCreate("Scripting.Dictionary")

Func InitializeControlVariables()
   $g_aGroupSearchBattlattle = $g_hGrpDBFilter&"#"&$g_hCmbDBMeetGE&"#"&$g_hTxtDBMinGold&"#"&$g_hPicDBMinGold&"#"&$g_hTxtDBMinElixir&"#"&$g_hPicDBMinElixir&"#"& _
				    $g_hTxtDBMinGoldPlusElixir&"#"&$g_hPicDBMinGPEGold&"#"&$g_hchkBattleMeetDE&"#"&$g_hTxtDBMinDarkElixir&"#"&$g_hPicDBMinDarkElixir&"#"& _
				    $g_hchkBattleMeetTH&"#"&$g_hCmbDBTH&"#"&$g_hchkBattleMeetTHO&"#"& _
				    $g_ahChkMeetOne[$Battle]&"#"& _
				    $g_ahChkMaxMortar[$Battle]&"#"&$g_ahCmbWeakMortar[$Battle]&"#"&$g_ahPicWeakMortar[$Battle]&"#"&$g_ahChkMaxWizTower[$Battle]&"#"&$g_ahCmbWeakWizTower[$Battle]&"#"& _
				    $g_ahPicWeakWizTower[$Battle]&"#"& _
				    $g_ahChkMaxXBow[$Battle]&"#"&$g_ahCmbWeakXBow[$Battle]&"#"&$g_ahPicWeakXBow[$Battle]&"#"&$g_ahChkMaxInferno[$Battle]&"#"&$g_ahCmbWeakInferno[$Battle]&"#"& _
				    $g_ahPicWeakInferno[$Battle]&"#"&$g_ahChkMaxEagle[$Battle]&"#"&$g_ahCmbWeakEagle[$Battle]&"#"&$g_ahPicWeakEagle[$Battle]&"#"&$g_ahChkMaxScatter[$Battle]&"#"&$g_ahCmbWeakScatter[$Battle]&"#"&$g_ahPicWeakScatter[$Battle]
   $groupSearchRB = $g_hGrpABFilter&"#"&$g_hCmbABMeetGE&"#"&$g_hTxtABMinGold&"#"&$g_hPicABMinGold&"#"&$g_hTxtABMinElixir&"#"&$g_hPicABMinElixir&"#"& _
				    $g_hTxtABMinGoldPlusElixir&"#"&$g_hPicABMinGPEGold&"#"&$g_hchkRankedBattleMeetDE&"#"&$g_hTxtABMinDarkElixir&"#"&	$g_hPicABMinDarkElixir&"#"& _
				    $g_hchkRankedBattleMeetTH&"#"&$g_hCmbABTH&"#"&$g_hchkRankedBattleMeetTHO&"#"& _
				    $g_ahChkMeetOne[$RankedBattle]&"#"& _
				    $g_ahChkMaxMortar[$RankedBattle]&"#"&$g_ahCmbWeakMortar[$RankedBattle]&"#"&$g_ahPicWeakMortar[$RankedBattle]&"#"&$g_ahChkMaxWizTower[$RankedBattle]&"#"&$g_ahCmbWeakWizTower[$RankedBattle]&"#"& _
					$g_ahPicWeakWizTower[$RankedBattle]&"#"&$g_ahChkMaxXBow[$RankedBattle]&"#"&$g_ahCmbWeakXBow[$RankedBattle]&"#"&$g_ahPicWeakXBow[$RankedBattle]&"#"&$g_ahChkMaxInferno[$RankedBattle]&"#"& _
					$g_ahCmbWeakInferno[$RankedBattle]&"#"&$g_ahPicWeakInferno[$RankedBattle]&"#"&$g_ahChkMaxEagle[$RankedBattle]&"#"&$g_ahCmbWeakEagle[$RankedBattle]&"#"&$g_ahPicWeakEagle[$RankedBattle]&"#"&$g_ahChkMaxScatter[$RankedBattle]&"#"&$g_ahCmbWeakScatter[$RankedBattle]&"#"&$g_ahPicWeakScatter[$RankedBattle]





   ;PicDBMaxTH
   $g_aGroupListPicBMaxTH = $g_ahPicDBMaxTH[6]&"#"&$g_ahPicDBMaxTH[7]&"#"&$g_ahPicDBMaxTH[8]&"#"& _
						$g_ahPicDBMaxTH[9]&"#"&$g_ahPicDBMaxTH[10]&"#"&$g_ahPicDBMaxTH[11]&"#"&$g_ahPicDBMaxTH[12]&"#"&$g_ahPicDBMaxTH[13]&"#"&$g_ahPicDBMaxTH[14]

   ;PicABMaxTH
   $g_aGroupListPicRBMaxTH = $g_ahPicABMaxTH[6]&"#"&$g_ahPicABMaxTH[7]&"#"&$g_ahPicABMaxTH[8]&"#"& _
						$g_ahPicABMaxTH[9]&"#"&$g_ahPicABMaxTH[10]&"#"&$g_ahPicABMaxTH[11]&"#"&$g_ahPicABMaxTH[12]&"#"&$g_ahPicABMaxTH[13]&"#"&$g_ahPicABMaxTH[14]

   ;PicBullyMaxTH
   $g_aGroupListPicBullyMaxTH = $g_ahPicBullyMaxTH[6]&"#"&$g_ahPicBullyMaxTH[7]&"#"&$g_ahPicBullyMaxTH[8]&"#"& _
						$g_ahPicBullyMaxTH[9]&"#"&$g_ahPicBullyMaxTH[10]&"#"&$g_ahPicBullyMaxTH[11]&"#"&$g_ahPicBullyMaxTH[12]&"#"&$g_ahPicBullyMaxTH[13]&"#"&$g_ahPicBullyMaxTH[14]

   ; Groups of controls
   Dim $aTabControlsVillage = [$g_hGUI_VILLAGE_TAB, $g_hGUI_VILLAGE_TAB_ITEM1, $g_hGUI_VILLAGE_TAB_ITEM2, $g_hGUI_VILLAGE_TAB_ITEM3, $g_hGUI_VILLAGE_TAB_ITEM4, $g_hGUI_VILLAGE_TAB_ITEM5]
   Dim $aTabControlsMisc = [$g_hGUI_MISC_TAB, $g_hGUI_MISC_TAB_ITEM1, $g_hGUI_MISC_TAB_ITEM2, $g_hGUI_MISC_TAB_ITEM3, $g_hGUI_MISC_TAB_ITEM4]
   Dim $aTabControlsDonate = [$g_hGUI_DONATE_TAB, $g_hGUI_DONATE_TAB_ITEM1, $g_hGUI_DONATE_TAB_ITEM2]
   Dim $aTabControlsUpgrade = [$g_hGUI_UPGRADE_TAB, $g_hGUI_UPGRADE_TAB_ITEM1, $g_hGUI_UPGRADE_TAB_ITEM2, $g_hGUI_UPGRADE_TAB_ITEM3, $g_hGUI_UPGRADE_TAB_ITEM4, $g_hGUI_UPGRADE_TAB_ITEM5]
   Dim $aTabControlsNotify = [$g_hGUI_NOTIFY_TAB, $g_hGUI_NOTIFY_TAB_ITEM2]
   Dim $aTabControlsAttack = [$g_hGUI_ATTACK_TAB, $g_hGUI_ATTACK_TAB_ITEM1, $g_hGUI_ATTACK_TAB_ITEM2, $g_hGUI_ATTACK_TAB_ITEM3]
   Dim $aTabControlsBuilderBase = [$g_hGUI_BB_TAB, $g_hGUI_BB_TAB_ITEM1, $g_hGUI_BB_TAB_ITEM2]

   Dim $aTabControlsArmy = [$g_hGUI_TRAINARMY_TAB, $g_hGUI_TRAINARMY_TAB_ITEM1, $g_hGUI_TRAINARMY_TAB_ITEM2, $g_hGUI_TRAINARMY_TAB_ITEM3, $g_hGUI_TRAINARMY_ARMY_TAB, $g_hGUI_TRAINARMY_ARMY_TAB_ITEM1, $g_hGUI_TRAINARMY_ARMY_TAB_ITEM2, $g_hGUI_TRAINARMY_ORDER_TAB, $g_hGUI_TRAINARMY_ORDER_TAB_ITEM1, $g_hGUI_TRAINARMY_ORDER_TAB_ITEM2]
   Dim $aTabControlsSearch = [$g_hGUI_SEARCH_TAB, $g_hGUI_SEARCH_TAB_ITEM1, $g_hGUI_SEARCH_TAB_ITEM2, $g_hGUI_SEARCH_TAB_ITEM3, $g_hGUI_SEARCH_TAB_ITEM4]
   Dim $aTabControlsDeadbase = [$g_hGUI_DEADBASE_TAB, $g_hGUI_DEADBASE_TAB_ITEM1, $g_hGUI_DEADBASE_TAB_ITEM2, $g_hGUI_DEADBASE_TAB_ITEM3, $g_hGUI_DEADBASE_TAB_ITEM4]
   Dim $aTabControlsActivebase = [$g_hGUI_ACTIVEBASE_TAB, $g_hGUI_ACTIVEBASE_TAB_ITEM1, $g_hGUI_ACTIVEBASE_TAB_ITEM2, $g_hGUI_ACTIVEBASE_TAB_ITEM3]
   Dim $aTabControlsAttackOptions = [$g_hGUI_ATTACKOPTION_TAB, $g_hGUI_ATTACKOPTION_TAB_ITEM1, $g_hGUI_ATTACKOPTION_TAB_ITEM2, $g_hGUI_ATTACKOPTION_TAB_ITEM3, $g_hGUI_ATTACKOPTION_TAB_ITEM4]
   Dim $aTabControlsStrategies = [$g_hGUI_STRATEGIES_TAB, $g_hGUI_STRATEGIES_TAB_ITEM1, $g_hGUI_STRATEGIES_TAB_ITEM2]

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
	$oAlwaysEnabledControls($g_hChkDebugSmartZap) = 1
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
	For $i in $aTabControlsAttack
		$oAlwaysEnabledControls($i) = 1
	Next
	For $i in $aTabControlsArmy
		$oAlwaysEnabledControls($i) = 1
	Next
	For $i in $aTabControlsSearch
		$oAlwaysEnabledControls($i) = 1
	Next
	For $i in $aTabControlsDeadbase
		$oAlwaysEnabledControls($i) = 1
	Next
	For $i in $aTabControlsActivebase
		$oAlwaysEnabledControls($i) = 1
	Next
	For $i in $aTabControlsAttackOptions
		$oAlwaysEnabledControls($i) = 1
	Next
	For $i in $aTabControlsStrategies
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
