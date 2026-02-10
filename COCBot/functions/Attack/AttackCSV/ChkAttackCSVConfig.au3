; #FUNCTION# ====================================================================================================================
; Name ..........: ChkAttackCSVConfig
; Description ...:
; Syntax ........: ChkAttackCSVConfig()
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
Func ChkAttackCSVConfig()
	;check if exists attackscript Files
	If Not (FileExists($g_sCSVAttacksPath & "\" & $g_sAttackScrScriptName[$Battle] & ".csv")) Then
		SetLog("Battle scripted attack file do not exists (renamed, deleted?)", $COLOR_ERROR)
		SetLog("Please select a new scripted algorithm from 'CSV Mod' tab", $COLOR_ERROR)
		PopulateComboScriptsFilesBattle()
		btnStop()
	EndIf
	If Not (FileExists($g_sCSVAttacksPath & "\" & $g_sAttackScrScriptName[$RankedBattle] & ".csv")) Then
		SetLog("Battle scripted attack file do not exists (renamed, deleted?)", $COLOR_ERROR)
		SetLog("Please select a new scripted algorithm from 'CSV Mod' tab", $COLOR_ERROR)
		PopulateComboScriptsFilesRankedBattle()
		btnStop()
	EndIf
	If $g_sAttackScrScriptNameRankedBattle <> "" And Not (FileExists($g_sCSVAttacksPath & "\" & $g_sAttackScrScriptNameRankedBattle & ".csv")) Then
		SetLog("Ranked scripted attack file does not exist (renamed, deleted?)", $COLOR_ERROR)
		SetLog("Please select a new ranked script from 'CSV Mod' tab", $COLOR_ERROR)
		PopulateComboScriptsFilesRanked()
		btnStop()
	EndIf

EndFunc   ;==>ChkAttackCSVConfig
