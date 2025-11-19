#include-once

Global $g_aCapitalDeployArea

Func ToRaidMap()
	Local $bRet = False
	If QuickMIS("BC1", $g_sImgAttackCapitalButton, 760, 590, 835, 630) Then
		Click($g_iQuickMISX, $g_iQuickMISY, 1, 0, "AttackMap Button")
		If _Sleep(1000) Then Return
		If QuickMIS("BC1", $g_sImgAttackCapitalButton, 460, 25, 510, 50) Then
			SetLog("We are on Attacking Raid Map", $COLOR_SUCCESS)
			$bRet = True
		EndIf
	EndIf
	Return $bRet
EndFunc

Func FindCapitalAttackTarget()
	Local $aMap
	$aMap = QuickMIS("CNX", $g_sImgAttackMapName)
	If IsArray($aMap) And UBound($aMap) > 0 Then
		_ArraySort($aMap, 0, 0, 0, 2)
		For $i = 0 To UBound($aMap) - 1
			SetLog("Detected AttackMap " & $aMap[$i][0], $COLOR_INFO)
		Next
	EndIf
EndFunc

Func CapitalPrepareAttack()
	AndroidZoomout()
	
EndFunc

Func SearchDeployArea()
	Local $aArea
	$aArea = QuickMIS("CNX", $g_sImgAttackDeployArea)
	If IsArray($aArea) And UBound($aArea) > 0 Then
		RemoveDupCNX($aArea)
		_ArraySort($aArea, 0, 0, 0, 1)
	EndIf
	Return $aArea
EndFunc

Func DeployCapitalTroop()
	Local $aArea, $x, $y, $sTroopName = ""
	Local $iTroopCount = 20
	CapitalPrepareAttack()
	$g_aCapitalDeployArea = SearchDeployArea()
	If IsArray($g_aCapitalDeployArea) And UBound($g_aCapitalDeployArea) > 0 Then
		
		Click(63, 630, 1, 0, "Click Army")
		For $i = 0 To UBound($g_aCapitalDeployArea) - 1
			$x = $g_aCapitalDeployArea[$i][1]
			$y = $g_aCapitalDeployArea[$i][2]
			$sTroopName =  $g_aCapitalDeployArea[$i][2] 
			Click($x, $y, 2, 0, "DeployTroop on " & $sTroopName & ", (" & $x & "," & $y & ")")
			If _Sleep(200) Then Return
			If $i = $iTroopCount Then ExitLoop
		Next
	EndIf
EndFunc