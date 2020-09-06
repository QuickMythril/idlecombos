#include JSON.ahk
;Fixed in 1.1.2:
;-Repeated results when opening chests now shows only once.

;Known issues in 1.1.2:
;-"CNE Support Ticket" not working properly

;Special thanks to all the idle dragons who inspired and assisted me!
global VersionNumber := "1.1.2"

;Local File globals
global OutputLogFile := "idlecombolog.txt"
global SettingsFile := "idlecombosettings.json"
global UserDetailsFile := "userdetails.json"
global ChestOpenLogFile := "chestopenlog.json"
global RedeemCodeLogFile := "redeemcodelog.json"
global CurrentSettings := []
global GameInstallDir := "C:\Program Files (x86)\Steam\steamapps\common\IdleChampions\"
global WRLFile := GameInstallDir "IdleDragons_Data\StreamingAssets\downloaded_files\webRequestLog.txt"
global GameClient := GameInstallDir "IdleDragons.exe"

;Settings globals
global GetDetailsonStart := 0
global LaunchGameonStart := 0
global FirstRun := 1
global AlwaysSaveChests := 0
global AlwaysSaveCodes := 0

;Server globals
global DummyData := "&language_id=1&timestamp=0&request_id=0&network_id=11&mobile_client_version=999"
global CodestoEnter := ""

;User info globals
global UserID := 0
global UserHash := 0
global InstanceID := 0
global UserDetails := []
global ActiveInstance := 0
global CurrentAdventure := 0
global CurrentPatron := 0
global AchievementInfo := "This page intentionally left blank.`n`n`n`n"
global BlessingInfo := "`n`n`n`n"
;Inventory globals
global CurrentGems := ""
global AvailableGolds := ""
global SpentGems := ""
global CurrentGolds := ""
global CurrentSilvers := ""
global CurrentTGPs := ""
global AvailableTGs := ""
global NextTGPDrop := ""
global CurrentSmBounties := ""
global CurrentMdBounties := ""
global CurrentLgBounties := ""
global AvailableTokens := ""
global AvailableFPs := ""
global CurrentTinyBS := ""
global CurrentSmBS := ""
global CurrentMdBS := ""
global CurrentLgBS := ""
global AvailableBSLvs := ""
;Loot globals
global EpicGearCount := 0
;global BrivRarity := 0
;global BrivGild := 0
;global BrivEnchant := 0
global BrivSlot4 := 0
global BrivZone := 0
;940.2 = 65.01 triple
;749.4 = 53.09 triple
;565.2 = 83.15 double ;mine
;238.8 = 83.7 single
;Patron globals
global MirtVariants := 0
global MirtCompleted := 0
global MirtVariantTotal := 0
global MirtFPCurrency := 0
global MirtChallenges := 0
global VajraVariants := 0
global VajraCompleted := 0
global VajraVariantTotal := 0
global VajraFPCurrency := 0
global VajraChallenges := 0
global StrahdVariants := 0
global StrahdCompleted := 0
global StrahdVariantTotal := 0
global StrahdFPCurrency := 0
global StrahdChallenges := 0

;GUI globals
global oMyGUI := ""
global OutputText := "Test"
global OutputStatus := "Welcome to IdleCombos v" VersionNumber
global CurrentTime := ""
global CrashProtectStatus := "Crash Protect`nDisabled"
global CrashCount := 0
global LastUpdated := "No data loaded."
global TrayIcon := systemroot "\system32\imageres.dll"

;BEGIN:	default run commands
If FileExist(TrayIcon) {
	If (SubStr(A_OSVersion, 1, 2) == 10) {
		Menu, Tray, Icon, %TrayIcon%, 300
	}
}
UpdateLogTime()
FileAppend, (%CurrentTime%) IdleCombos v%VersionNumber% started.`n, %OutputLogFile%
FileRead, OutputText, %OutputLogFile%
if (!oMyGUI) {
	oMyGUI := new MyGui()
}
;First run checks and setup
if !FileExist(SettingsFile) {
	newsettings := JSON.stringify({"firstrun":0,"user_id":0,"hash":0,"getdetailsonstart":0,"launchgameonstart":0,"alwayssavechests":1,"alwayssavecodes":1})
	FileAppend, %newsettings%, %SettingsFile%
	UpdateLogTime()
	FileAppend, (%CurrentTime%) Settings file "idlecombosettings.json" created.`n, %OutputLogFile%
	FileRead, OutputText, %OutputLogFile%
	oMyGUI.Update()
}
FileRead, rawsettings, %SettingsFile%
CurrentSettings := JSON.parse(rawsettings)
if !(CurrentSettings.firstrun) {
	FirstRun()
}
if (CurrentSettings.user_id && CurrentSettings.hash) {
	UserID := CurrentSettings.user_id
	UserHash := CurrentSettings.hash
	SB_SetText("User ID & Hash ready.")
}
else {
	SB_SetText("User ID & Hash not found!")
}
;Loading current settings
GetDetailsonStart := CurrentSettings.getdetailsonstart
LaunchGameonStart := CurrentSettings.launchgameonstart
AlwaysSaveChests := CurrentSettings.alwayssavechests
AlwaysSaveCodes := CurrentSettings.alwayssavecodes
if (GetDetailsonStart == "1") {
	GetUserDetails()
}
if (LaunchGameonStart == "1") {
	LaunchGame()
	FirstRun := 0
}
oMyGUI.Update()
return
;END:	default run commands

;BEGIN: GUI Defs
class MyGui {
	Width := "525"
	Height := "360"
	
	__New()
	{
		Gui, MyWindow:New
		Gui, MyWindow:+Resize -MaximizeBox 
		
		Menu, FileSubmenu, Add, &Launch Game Client, LaunchGame
		Menu, FileSubmenu, Add, &Update UserDetails, GetUserDetails
		Menu, FileSubmenu, Add
		Menu, FileSubmenu, Add, &Reload IdleCombos, Reload_Clicked
		Menu, FileSubmenu, Add, E&xit IdleCombos, Exit_Clicked
		Menu, IdleMenu, Add, &File, :FileSubmenu
		
		Menu, BuyChestsSubmenu, Add, &Gold, Buy_Gold
		Menu, BuyChestsSubmenu, Add, &Silver, Buy_Silver
		Menu, ToolsSubmenu, Add, &Buy Chests, :BuyChestsSubmenu
		Menu, OpenChestsSubmenu, Add, &Gold, Open_Gold
		Menu, OpenChestsSubmenu, Add, &Silver, Open_Silver
		Menu, ToolsSubmenu, Add, &Open Chests, :OpenChestsSubmenu
		Menu, ToolsSubmenu, Add, &Redeem Codes, Open_Codes
		Menu, AdvSubmenu, Add, &Load New Adv, LoadAdventure
		Menu, AdvSubmenu, Add, &End Current Adv, EndAdventure
		Menu, ToolsSubmenu, Add, &Adventure Manager, :AdvSubmenu
		Menu, ToolsSubmenu, Add, BrivStack &Calculator, Briv_Calc
		Menu, IdleMenu, Add, &Tools, :ToolsSubmenu
		
		Menu, HelpSubmenu, Add, &Run Setup, FirstRun
		Menu, HelpSubmenu, Add, Clear &Log, Clear_Log
		Menu, HelpSubmenu, Add, CNE &Support Ticket, Open_Ticket
		Menu, HelpSubmenu, Add
		Menu, HelpSubmenu, Add, &About IdleCombos, About_Clicked
		Menu, HelpSubmenu, Add, &Discord Support Server, Discord_Clicked
		Menu, IdleMenu, Add, &Help, :HelpSubmenu
		Gui, Menu, IdleMenu
		
		col1_x := 5
		col2_x := 400
		col3_x := 460
		row_y := 5
		
		Gui, Add, StatusBar,, %OutputStatus%
		
		Gui, MyWindow:Add, Button, x%col2_x% y%row_y% w60 gReload_Clicked, Reload
		Gui, MyWindow:Add, Button, x%col3_x% y%row_y% w60 gExit_Clicked, Exit
		
		Gui, MyWindow:Add, Tab3, x%col1_x% y%row_y% w380, Summary|Adventures|Inventory||Patrons|Modrons|Settings|Log|
		Gui, Tab
		
		row_y := row_y + 25
		;Gui, MyWindow:Add, Button, x%col3_x% y%row_y% w60 gUpdate_Clicked, Update
		
		row_y := row_y + 25
		Gui, MyWindow:Add, Text, x390 y53 vCrashProtectStatus, % CrashProtectStatus
		Gui, MyWindow:Add, Button, x%col3_x% y%row_y% w60 gCrash_Toggle, Toggle
		
		Gui, MyWindow:Add, Text, x390 y100, Data Timestamp:
		Gui, MyWindow:Add, Text, x390 y120 vLastUpdated w220, % LastUpdated
		Gui, MyWindow:Add, Button, x390 y140 w60 gUpdate_Clicked, Update
		
		Gui, Tab, Summary
		Gui, MyWindow:Add, Text, vAchievementInfo x15 y33 w300, % AchievementInfo
		Gui, MyWindow:Add, Text, vBlessingInfo x15 y+p w300, % BlessingInfo
		
		Gui, Tab, Adventures
		Gui, MyWindow:Add, Text, x15 y33 w90, Current Adventure:
		Gui, MyWindow:Add, Text, vCurrentAdventure x+2 w25 right, % CurrentAdventure
		Gui, MyWindow:Add, Text, x15 y+p w90, Current Patron:
		Gui, MyWindow:Add, Text, vCurrentPatron x+2 w25 right, % CurrentPatron
		
		Gui, Tab, Inventory
		Gui, MyWindow:Add, Text, x15 y33 w70, Current Gems:
		Gui, MyWindow:Add, Text, vCurrentGems x+2 w75 right, % CurrentGems
		Gui, MyWindow:Add, Text, vAvailableGolds x+10 w190, % AvailableGolds
		Gui, MyWindow:Add, Text, x15 y+p w70, (Spent Gems):
		Gui, MyWindow:Add, Text, vSpentGems x+2 w75 right, % SpentGems
		
		Gui, MyWindow:Add, Text, x15 y+5+p w110, Gold Chests:
		Gui, MyWindow:Add, Text, vCurrentGolds x+2 w35 right, % CurrentGolds
		Gui, MyWindow:Add, Text, x15 y+p w110, Silver Chests:
		Gui, MyWindow:Add, Text, vCurrentSilvers x+2 w35 right, % CurrentSilvers
		Gui, MyWindow:Add, Text, x+105 w185, Next TGP:
		Gui, MyWindow:Add, Text, x15 y+p w110, Time Gate Pieces:
		Gui, MyWindow:Add, Text, vCurrentTGPs x+2 w35 right, % CurrentTGPs
		Gui, MyWindow:Add, Text, vAvailableTGs x+10 w85, % AvailableTGs
		Gui, MyWindow:Add, Text, vNextTGPDrop x+10 w220, % NextTGPDrop
		
		Gui, MyWindow:Add, Text, x15 y+5+p w110, Small Bounties:
		Gui, MyWindow:Add, Text, vCurrentSmBounties x+2 w35 right, % CurrentSmBounties
		Gui, MyWindow:Add, Text, vAvailableTokens x+10 w185, % AvailableTokens
		Gui, MyWindow:Add, Text, x15 y+p w110, Medium Bounties:
		Gui, MyWindow:Add, Text, vCurrentMdBounties x+2 w35 right, % CurrentMdBounties
		Gui, MyWindow:Add, Text, vAvailableFPs x+10 w185, % AvailableFPs
		Gui, MyWindow:Add, Text, x15 y+p w110, Large Bounties:
		Gui, MyWindow:Add, Text, vCurrentLgBounties x+2 w35 right, % CurrentLgBounties
		
		Gui, MyWindow:Add, Text, x15 y+5+p w110, Tiny Blacksmiths:
		Gui, MyWindow:Add, Text, vCurrentTinyBS x+2 w35 right, % CurrentTinyBS
		Gui, MyWindow:Add, Text, vAvailableBSLvs x+10 w175, % AvailableBSLvs
		Gui, MyWindow:Add, Text, x15 y+p w110, Small Blacksmiths:
		Gui, MyWindow:Add, Text, vCurrentSmBS x+2 w35 right, % CurrentSmBS
		Gui, MyWindow:Add, Text, x15 y+p w110, Medium Blacksmiths:
		Gui, MyWindow:Add, Text, vCurrentMdBS x+2 w35 right, % CurrentMdBS
		Gui, MyWindow:Add, Text, x15 y+p w110, Large Blacksmiths:
		Gui, MyWindow:Add, Text, vCurrentLgBS x+2 w35 right, % CurrentLgBS
		
		Gui, Tab, Patrons
		Gui, MyWindow:Add, Text, x15 y33 w70, Mirt Variants:
		Gui, MyWindow:Add, Text, vMirtVariants x+2 w75 right cRed, % MirtVariants
		Gui, MyWindow:Add, Text, x15 y+p w110, Mirt FP Currency:
		Gui, MyWindow:Add, Text, vMirtFPCurrency x+2 w35 right cRed, % MirtFPCurrency
		Gui, MyWindow:Add, Text, x15 y+p w110, Mirt Challenges:
		Gui, MyWindow:Add, Text, vMirtChallenges x+2 w35 right cRed, % MirtChallenges
		
		Gui, MyWindow:Add, Text, x15 y+5+p w70, Vajra Variants:
		Gui, MyWindow:Add, Text, vVajraVariants x+2 w75 right cRed, % VajraVariants
		Gui, MyWindow:Add, Text, x15 y+p w110, Vajra FP Currency:
		Gui, MyWindow:Add, Text, vVajraFPCurrency x+2 w35 right cRed, % VajraFPCurrency
		Gui, MyWindow:Add, Text, x15 y+p w110, Vajra Challenges:
		Gui, MyWindow:Add, Text, vVajraChallenges x+2 w35 right cRed, % VajraChallenges
		
		Gui, MyWindow:Add, Text, x15 y+5+p w75, Strahd Variants:
		Gui, MyWindow:Add, Text, vStrahdVariants x+2 w70 right cRed, % StrahdVariants
		Gui, MyWindow:Add, Text, x15 y+p w110, Strahd FP Currency:
		Gui, MyWindow:Add, Text, vStrahdFPCurrency x+2 w35 right cRed, % StrahdFPCurrency
		Gui, MyWindow:Add, Text, x15 y+p w110, Strahd Challenges:
		Gui, MyWindow:Add, Text, vStrahdChallenges x+2 w35 right cRed, % StrahdChallenges
		
		Gui, Tab, Modrons
		Gui, Font, s16
		Gui, MyWindow:Add, Text, x15 y33, Coming SOON!™
		Gui, Font
		
		Gui, Tab, Settings
		Gui, MyWindow:Add, CheckBox, vGetDetailsonStart, Get User Details on start?
		Gui, MyWindow:Add, CheckBox, vLaunchGameonStart, Launch game client on start?
		Gui, MyWindow:Add, CheckBox, vAlwaysSaveChests, Always save Chest Open Results to file?
		Gui, MyWindow:Add, CheckBox, vAlwaysSaveCodes, Always save Code Redeem Results to file?
		Gui, MyWindow:Add, Button, gSave_Settings, Save Settings
		
		Gui, Tab, Log
		Gui, MyWindow:Add, Edit, r12 vOutputText ReadOnly w360, %OutputText%
		this.Show()
	}
	
	Show() {
		;check if minimized if so leave it be
		WinGet, OutputVar , MinMax, IdleCombos v%VersionNumber%
		if (OutputVar = -1) {
			return
		}
		nW := this.Width
		nH := this.Height
		Gui, MyWindow:Show, w%nW% h%nH%, IdleCombos v%VersionNumber%
	}
	
	Hide() {
		Gui, MyWindow:Hide
	}
	
	Submit() {
		Gui, MyWindow:Submit, NoHide
	}
	
	Update() {
		GuiControl, , OutputText, % OutputText, w250 h210
		SendMessage, 0x115, 7, 0, Edit1
		GuiControl, , CrashProtectStatus, % CrashProtectStatus, w250 h210
		GuiControl, , AchievementInfo, % AchievementInfo, w250 h210
		GuiControl, , BlessingInfo, % BlessingInfo, w250 h210
		GuiControl, , LastUpdated, % LastUpdated, w250 h210
		;adventures
		GuiControl, , CurrentAdventure, % CurrentAdventure, w250 h210
		GuiControl, , CurrentPatron, % CurrentPatron, w250 h210
		;inventory
		GuiControl, , CurrentGems, % CurrentGems, w250 h210
		GuiControl, , SpentGems, % SpentGems, w250 h210
		GuiControl, , CurrentGolds, % CurrentGolds, w250 h210
		GuiControl, , CurrentSilvers, % CurrentSilvers, w250 h210
		GuiControl, , CurrentTGPs, % CurrentTGPs, w250 h210
		GuiControl, , NextTGPDrop, % NextTGPDrop, w250 h210
		GuiControl, , AvailableTGs, % AvailableTGs, w250 h210
		GuiControl, , AvailableGolds, % AvailableGolds, w250 h210
		GuiControl, , CurrentSmBounties, % CurrentSmBounties, w250 h210
		GuiControl, , CurrentMdBounties, % CurrentMdBounties, w250 h210
		GuiControl, , CurrentLgBounties, % CurrentLgBounties, w250 h210
		GuiControl, , AvailableTokens, % AvailableTokens, w250 h210
		GuiControl, , AvailableFPs, % AvailableFPs, w250 h210
		GuiControl, , CurrentTinyBS, % CurrentTinyBS, w250 h210
		GuiControl, , CurrentSmBS, % CurrentSmBS, w250 h210
		GuiControl, , CurrentMdBS, % CurrentMdBS, w250 h210
		GuiControl, , CurrentLgBS, % CurrentLgBS, w250 h210
		GuiControl, , AvailableBSLvs, % AvailableBSLvs, w250 h210
		;patrons
		GuiControl, , MirtVariants, % MirtVariants, w250 h210
		GuiControl, , MirtChallenges, % MirtChallenges, w250 h210
		GuiControl, , MirtFPCurrency, % MirtFPCurrency, w250 h210
		GuiControl, , VajraVariants, % VajraVariants, w250 h210
		GuiControl, , VajraChallenges, % VajraChallenges, w250 h210
		GuiControl, , VajraFPCurrency, % VajraFPCurrency, w250 h210
		GuiControl, , StrahdVariants, % StrahdVariants, w250 h210
		GuiControl, , StrahdChallenges, % StrahdChallenges, w250 h210
		GuiControl, , StrahdFPCurrency, % StrahdFPCurrency, w250 h210
		;settings
		GuiControl, , GetDetailsonStart, % GetDetailsonStart, w250 h210
		GuiControl, , LaunchGameonStart, % LaunchGameonStart, w250 h210
		GuiControl, , AlwaysSaveChests, % AlwaysSaveChests, w250 h210
		GuiControl, , AlwaysSaveCodes, % AlwaysSaveCodes, w250 h210
		;this.Show() - removed
	}
}

;Hotkeys
;$F9::Reload
;$F10::ExitApp

Update_Clicked:
{
	GetUserDetails()
	return
}

Reload_Clicked:
{
	Reload
	return
}

Exit_Clicked:
{
	ExitApp
	return
}

Crash_Toggle:
{
	switch CrashProtectStatus {
		case "Crash Protect`nDisabled": {
			CrashProtectStatus := "Crash Protect`nEnabled"
			oMyGUI.Update()
			SB_SetText("Crash Protect has been enabled!")
			CrashProtect()
		}
		case "Crash Protect`nEnabled": {
			CrashProtectStatus := "Crash Protect`nDisabled"
			CrashCount := 0
			oMyGUI.Update()
			SB_SetText("Crash Protect has been disabled.")
		}
	}
	return
}

CrashProtect() {
	loop {
		if (CrashProtectStatus == "Crash Protect`nDisabled") {
			return
		}
		While(Not WinExist("ahk_exe IdleDragons.exe")) {
			Sleep 2500
			Run, %GameClient%
			++CrashCount
			SB_SetText("Crash Protect has restarted your client.")
			UpdateLogTime()
			FileAppend, (%CurrentTime%) Restarts since enabling Crash Protect: %CrashCount%`n, %OutputLogFile%
			FileRead, OutputText, %OutputLogFile%
			oMyGUI.Update()
			Sleep 10000
		}
	}
	return
}

Save_Settings:
{
	oMyGUI.Submit()
	CurrentSettings.getdetailsonstart := GetDetailsonStart
	CurrentSettings.launchgameonstart := LaunchGameonStart
	CurrentSettings.alwayssavechests := AlwaysSaveChests
	CurrentSettings.alwayssavecodes := AlwaysSaveCodes
	newsettings := JSON.stringify(CurrentSettings)
	FileDelete, %SettingsFile%
	FileAppend, %newsettings%, %SettingsFile%
	SB_SetText("Settings have been saved.")
	return
}

About_Clicked:
{
	MsgBox, , About IdleCombos v%VersionNumber%, IdleCombos v%VersionNumber% by QuickMythril`n`nSpecial thanks to all the idle dragons who inspired and assisted me!
	return
}

Buy_Silver:
{
	Buy_Chests(1)
	return
}

Buy_Gold:
{
	Buy_Chests(2)
	return
}

Open_Silver:
{
	Open_Chests(1)
	return
}

Open_Gold:
{
	Open_Chests(2)
	return
}

Open_Codes:
{
	Gui, CodeWindow:New
	Gui, CodeWindow:+Resize -MaximizeBox
	Gui, CodeWindow:Show, w220 h220, Codes
	Gui, CodeWindow:Add, Edit, r12 vCodestoEnter w180 x20 y20, IDLE-CHAM-PION-SNOW
	Gui, CodeWindow:Add, Button, gRedeem_Codes, Submit
	Gui, CodeWindow:Add, Text, x+6 vCodesPending, Codes pending: 0
	Gui, CodeWindow:Add, Button, x+18 gClose_Codes, Close
	return
}

Redeem_Codes:
{
	Gui, CodeWindow:Submit, NoHide
	Gui, CodeWindow:Add, Text, x+45, Codes pending:
	CodeList := StrSplit(CodestoEnter, "`n")
	CodeCount := CodeList.Length()
	CodesPending := "Codes pending: " CodeCount
	GuiControl, , CodesPending, % CodesPending, w250 h210
	for k, v in CodeList
	{
		v := StrReplace(v, "`r")
		v := StrReplace(v, "`n")
		v := Trim(v)
		CurrentCode := v	
		sCode := RegExReplace(CurrentCode, "&", Replacement := "%26")
		if !UserID {
			MsgBox % "Need User ID & Hash."
			FirstRun()
		}
		codeparams := DummyData "&user_id=" UserID "&hash=" UserHash "&instance_id=" InstanceID "&code=" sCode
		rawresults := ServerCall("redeemcoupon", codeparams)
		CodeCount := % (CodeCount-1)
		if (CurrentSettings.alwayssavecodes) {
			FileAppend, %sCode%`n, %RedeemCodeLogFile%
			FileAppend, %rawresults%`n, %RedeemCodeLogFile%
		}
		else {
			InputBox, dummyvar, Code Results, Save to File?, , 250, 150, , , , , % rawresults
			dummyvar := ""
			if !ErrorLevel {
				FileAppend, %sCode%`n, %RedeemCodeLogFile%
				FileAppend, %rawresults%`n, %RedeemCodeLogFile%
			}
		}
		sleep, 2000
		CodesPending := "Codes pending: " CodeCount
		GuiControl, , CodesPending, % CodesPending, w250 h210
	}
	CodesPending := "Codes submitted!"
	GuiControl, , CodesPending, % CodesPending, w250 h210
	;GetUserDetails() ;not working?
	return
}

Briv_Calc:
{
	InputBox, BrivSlot4, Briv Slot 4, Please enter the percentage listed`non your Briv Slot 4 item., , 250, 150, , , , , %BrivSlot4%
	if (ErrorLevel=1) {
		return
	}
	InputBox, BrivZone, Area to Reset, Please enter the area you will reset at`nafter building up Steelbones stacks., , 250, 150, , , , , %BrivZone%
	if (ErrorLevel=1) {
		return
	}
	MsgBox, 0, BrivCalc Results, % SimulateBriv(10000)
	return
}

Close_Codes:
{
	Gui, CodeWindow:Destroy
	return
}

Clear_Log:
{
	MsgBox, 4, Clear Log, Are you sure?
	IfMsgBox, Yes
	{
		FileDelete, %OutputLogFile%
		OutputText := ""
		oMyGUI.Update()
		return
	}
	return
}

Buy_Chests(chestid) {
	if !UserID {
		MsgBox % "Need User ID & Hash."
		FirstRun()
	}
	if !CurrentGems {
		MsgBox, 4, , No gems detected.  Check server for user details?
		IfMsgBox, Yes
		{
			GetUserDetails()
		}
	}
	switch chestid
	{
		case 1: {
			maxbuy := Floor(CurrentGems/50)
			InputBox, count, Buying Chests, % "How many Silver Chests?`n(Max: " maxbuy ")", , 200, 180
			if ErrorLevel
				return
			if (count > maxbuy) {
				MsgBox, 4, , Insufficient gems detected for purchase.`nContinue anyway?
				IfMsgBox No
					return
			}
		}
		case 2: {
			maxbuy := Floor(CurrentGems/500)
			InputBox, count, Buying Chests, % "How many Gold Chests?`n(Max: " maxbuy ")", , 200, 180
			if ErrorLevel
				return
			if (count = "alpha5") {
				chestparams := DummyData "&user_id=" UserID "&hash=" UserHash "&instance_id=" InstanceID
				rawresults := ServerCall("alphachests", chestparams)
				MsgBox % rawresults
				GetUserDetails()
				SB_SetText("Ai yi yi, Zordon!")
				return
			}
			if (count > maxbuy) {
				MsgBox, 4, , Insufficient gems detected for purchase.`nContinue anyway?
				IfMsgBox No
					return
			}
		}
		default: {
			MsgBox, Invalid chest_id value.
			return
		}
	}
	chestparams := DummyData "&user_id=" UserID "&hash=" UserHash "&instance_id=" InstanceID "&chest_type_id=" chestid "&count="
	gemsspent := 0
	while (count > 0) {
		SB_SetText("Chests remaining to purchase: " count)
		if (count < 100) {
			rawresults := ServerCall("buysoftcurrencychest", chestparams count)
			count -= count
		}
		else {
			rawresults := ServerCall("buysoftcurrencychest", chestparams "99")
			count -= 99
		}
		chestresults := JSON.parse(rawresults)
		if (chestresults.success == "0") {
			MsgBox % "Error: " rawresults
			UpdateLogTime()
			FileAppend, (%CurrentTime%) Gems spent: %gemsspent%`n, %OutputLogFile%
			FileRead, OutputText, %OutputLogFile%
			oMyGUI.Update()
			GetUserDetails()
			SB_SetText("Chests remaining: " count " (Error: " chestresults.failure_reason ")")
			return
		}
		gemsspent += chestresults.currency_spent
		Sleep 1000
	}
	UpdateLogTime()
	FileAppend, (%CurrentTime%) Gems spent: %gemsspent%`n, %OutputLogFile%
	FileRead, OutputText, %OutputLogFile%
	oMyGUI.Update()
	GetUserDetails()
	SB_SetText("Chest purchase completed.")
	return
}

Open_Chests(chestid) {
	if !UserID {
		MsgBox % "Need User ID & Hash."
		FirstRun()
	}
	if (!CurrentGolds && !CurrentSilvers) {
		MsgBox, 4, , No chests detected.  Check server for user details?
		IfMsgBox, Yes
		{
			GetUserDetails()
		}
	}
	switch chestid
	{
		case 1: {
			InputBox, count, Opening Chests, % "How many Silver Chests?`n(Max: " CurrentSilvers ")", , 200, 180
			if ErrorLevel
				return
			if (count > CurrentSilvers) {
				MsgBox, 4, , Insufficient chests detected for opening.`nContinue anyway?
				IfMsgBox No
					return
			}
		}
		case 2: {
			InputBox, count, Opening Chests, % "How many Gold Chests?`n(Max: " CurrentGolds ")", , 200, 180
			if ErrorLevel
				return
			if (count > CurrentGolds) {
				MsgBox, 4, , Insufficient chests detected for opening.`nContinue anyway?
				IfMsgBox No
					return
			}
		}
		default: {
			MsgBox, Invalid chest_id value.
			return
		}
	}
	chestparams := "&gold_per_second=0&checksum=4c5f019b6fc6eefa4d47d21cfaf1bc68&user_id=" UserID "&hash=" UserHash "&instance_id=" InstanceID "&chest_type_id=" chestid "&game_instance_id=" ActiveInstance "&count="
	tempsavesetting := 0
	tempnosavesetting := 0
	while (count > 0) {
		SB_SetText("Chests remaining to open: " count)
		if (count < 100) {
			rawresults := ServerCall("opengenericchest", chestparams count)
			count -= count
		}
		else {
			rawresults := ServerCall("opengenericchest", chestparams "99")
			count -= 99
		}
		if (CurrentSettings.alwayssavechests || tempsavesetting) {
			FileAppend, %rawresults%`n, %ChestOpenLogFile%
		}
		else {
			if !tempnosavesetting {
				InputBox, dummyvar, Chest Results, Save to File?, , 250, 150, , , , , % rawresults
				dummyvar := ""
				if !ErrorLevel {
					FileAppend, %rawresults%`n, %ChestOpenLogFile%
					tempsavesetting := 1
				}
				if ErrorLevel {
					tempnosavesetting := 1
				}
			}
		}
		chestresults := JSON.parse(rawresults)
		if ((chestresults.success == "0") || (chestresults.loot_details == "0")) {
			MsgBox % "New Feats:`n" newfeats "New Shinies:`n" newshinies
			MsgBox % "Error: " rawresults
			switch chestid {
			case "1": chestsopened := (CurrentSilvers - chestresults.chests_remaining)
			case "2": chestsopened := (CurrentGolds - chestresults.chests_remaining)
			}
			UpdateLogTime()
			FileAppend, (%CurrentTime%) Chests Opened: %chestsopened%`n, %OutputLogFile%
			FileRead, OutputText, %OutputLogFile%
			oMyGUI.Update()
			GetUserDetails()
			SB_SetText("Chests remaining: " count " (Error)")
			return
		}
		lastfeat := ""
		newfeats := ""
		lastshiny := ""
		newshinies := ""
		for k, v in chestresults.loot_details {
			if (v.unlock_hero_feat) {
				lastfeat := (v.unlock_hero_feat "`n")
				newfeats := newfeats lastfeat
			}
			if (v.gilded) {
				lastshiny := (ChampFromID(v.hero_id) " (Slot " v.slot_id ")`n")
				newshinies := newshinies lastshiny
			}
		}
	}
	MsgBox % "New Feats:`n" newfeats "`nNew Shinies:`n" newshinies
	tempsavesetting := 0
	tempnosavesetting := 0
	switch chestid {
	case "1": chestsopened := (CurrentSilvers - chestresults.chests_remaining)
	case "2": chestsopened := (CurrentGolds - chestresults.chests_remaining)
	}
	UpdateLogTime()
	FileAppend, (%CurrentTime%) Chests Opened: %chestsopened%`n, %OutputLogFile%
	FileRead, OutputText, %OutputLogFile%
	oMyGUI.Update()
	GetUserDetails()
	SB_SetText("Chest opening completed.")
	return
}

LoadAdventure() {
	while !(CurrentAdventure == "-1") {
		MsgBox, 5, , Please end your current adventure first.
		IfMsgBox Cancel
			return
	}
	advtoload := 31
	patrontoload := 0
	InputBox, advtoload, Adventure to Load, Please enter the adventure_id`nyou would like to load., , 250, 150, , , , , %advtoload%
	if (ErrorLevel=1) {
		return
	}
	if !((advtoload > 0) && (advtoload < 999)) {
		MsgBox % "Invalid adventure_id: " advtoload
		return
	}
	InputBox, patrontoload, Patron to Load, Please enter the patron_id`nyou would like to load., , 250, 150, , , , , %patrontoload%
	if (ErrorLevel=1) {
		return
	}
	if !((patrontoload > -1) && (patrontoload < 4)) {
		MsgBox % "Invalid patron_id: " patrontoload
		return
	}
	advparams := DummyData "&patron_tier=0&user_id=" UserID "&hash=" UserHash "&instance_id=" InstanceID "&game_instance_id=" ActiveInstance "&adventure_id=" advtoload "&patron_id=" patrontoload
	sResult := ServerCall("setcurrentobjective", advparams)
	GetUserDetails()
	SB_SetText("Selected adventure has been loaded.")
	return
}

EndAdventure() {
	while (CurrentAdventure == "-1") {
		MsgBox, No current adventure active.
		return
	}
	advparams := DummyData "&user_id=" UserID "&hash=" UserHash "&instance_id=" InstanceID "&game_instance_id=" ActiveInstance
	sResult := ServerCall("softreset", advparams)
	GetUserDetails()
	SB_SetText("Current adventure has been ended.")
	return
	;&include_free_play_objectives=true
	;&abandon_objective=false
	;&ad_buff_enabled=false
	;&reset_number=4157
	;&manual_reset=1
}

FirstRun() {
	MsgBox, 4, , Get User ID and Hash from Steam webrequestlog.txt?
	IfMsgBox, Yes
	{
		GetIdFromWRL()
		UpdateLogTime()
		FileAppend, (%CurrentTime%) User ID: %UserID% & Hash: %UserHash% detected in WRL.`n, %OutputLogFile%
	}
	else
	{
		MsgBox, 4, , Choose install directory manually?
		IfMsgBox Yes
		{
			FileSelectFile, WRLFile, 1, webRequestLog.txt, Select webRequestLog file, webRequestLog.txt
			if ErrorLevel
				return
			GetIdFromWRL()
		}	
		else {
			InputBox, UserID, user_id, Please enter your "user_id" value., , 250, 125
			if ErrorLevel
				return
			InputBox, UserHash, hash, Please enter your "hash" value., , 250, 125
			if ErrorLevel
				return
		UpdateLogTime()
		FileAppend, (%CurrentTime%) User ID: %UserID% & Hash: %UserHash% manually entered.`n, %OutputLogFile%
		}
	}
	FileRead, OutputText, %OutputLogFile%
	oMyGUI.Update()
	CurrentSettings.user_id := UserID
	CurrentSettings.hash := UserHash
	CurrentSettings.firstrun := 1
	newsettings := JSON.stringify(CurrentSettings)
	FileDelete, %SettingsFile%
	FileAppend, %newsettings%, %SettingsFile%
	UpdateLogTime()
	FileAppend, (%CurrentTime%) IdleCombos setup completed.`n, %OutputLogFile%
	FileRead, OutputText, %OutputLogFile%
	oMyGUI.Update()
	SB_SetText("User ID & Hash ready.")
}

UpdateLogTime() {
	FormatTime, CurrentTime, , yyyy-MM-dd HH:mm:ss
}

GetIDFromWRL() {
	FileRead, oData, %WRLFile%
	if ErrorLevel {
		MsgBox, 4, , Could not find webRequestLog.txt file.`nChoose install directory manually?
		IfMsgBox Yes
		{
			FileSelectFile, WRLFile, 1, webRequestLog.txt, Select webRequestLog file, webRequestLog.txt
			if ErrorLevel
				return
			FileRead, oData, %WRLFile%
		}
		else
			return
	}
	FoundPos := InStr(oData, "getuserdetails&language_id=1&user_id=")
	oData2 := SubStr(oData, (FoundPos + 37))
	FoundPos := InStr(oData2, "&hash=")
	StringLeft, UserID, oData2, (FoundPos - 1)
	oData := SubStr(oData2, (FoundPos + 6))
	FoundPos := InStr(oData, "&instance_key=")
	StringLeft, UserHash, oData, (FoundPos - 1)
	oData  :=  ; Free the memory.
	oData2 :=  ; Free the memory.
	return
}
	
GetUserDetails() {
	SB_SetText("Please wait a moment...")
	getuserparams := "&instance_key=1&user_id=" UserID "&hash=" UserHash
	rawdetails := ServerCall("getuserdetails", getuserparams)
	FileDelete, %UserDetailsFile%
	FileAppend, %rawdetails%, %UserDetailsFile%
	UserDetails := JSON.parse(rawdetails)
	InstanceID := UserDetails.details.instance_id
	ActiveInstance := UserDetails.details.active_game_instance_id
	ParseAdventureData()
	ParseTimestamps()
	ParseInventoryData()
	ParsePatronData()
	ParseLootData()
	CheckAchievements()
	CheckBlessings()
	oMyGUI.Update()
	SB_SetText("User details available.")
	CheckPatronProgress()
	return
}

ParseAdventureData() {
	for k, v in UserDetails.details.game_instances
		if (v.game_instance_id == ActiveInstance) {
			CurrentAdventure := v.current_adventure_id
			CurrentPatron := v.current_patron_id
		}
	;
}

ParseTimestamps() {
	localdiff := (A_Now - A_NowUTC)
	if (localdiff < -250000) {
		localdiff += 760000
	}
	StringTrimRight, localdiffh, localdiff, 4
	localdiffm := SubStr(localdiff, -3)
	StringTrimRight, localdiffm, localdiffm, 2
	timestampvalue := "19700101000000"
	timestampvalue += UserDetails.current_time, s
	EnvAdd, timestampvalue, localdiffh, h
	EnvAdd, timestampvalue, localdiffm, m
	FormatTime, LastUpdated, % timestampvalue, MMM d`, h:mm tt
	tgptimevalue := "19700101000000"
	tgptimevalue += UserDetails.details.stats.time_gate_key_next_time, s
	EnvAdd, tgptimevalue, localdiffh, h
	EnvAdd, tgptimevalue, localdiffm, m
	FormatTime, NextTGPDrop, % tgptimevalue, MMM d`, h:mm tt
	if (UserDetails.details.stats.time_gate_key_next_time < UserDetails.current_time) {
		Gui, Font, cGreen
		GuiControl, Font, NextTGPDrop
	}
	else {
		Gui, Font, cBlack
		GuiControl, Font, NextTGPDrop
	}
}

ParseInventoryData() {
	CurrentGems := UserDetails.details.red_rubies
	SpentGems := UserDetails.details.red_rubies_spent
	CurrentGolds := UserDetails.details.chests.2
	CurrentSilvers := UserDetails.details.chests.1
	CurrentTGPs := UserDetails.details.stats.time_gate_key_pieces
	AvailableTGs := "= " Floor(CurrentTGPs/6) " Time Gates"
	for k, v in UserDetails.details.buffs
		switch v.buff_id
	{
		case 18: CurrentSmBounties := v.inventory_amount
		case 19: CurrentMdBounties := v.inventory_amount
		case 20: CurrentLgBounties := v.inventory_amount
		case 31: CurrentTinyBS := v.inventory_amount
		case 32: CurrentSmBS := v.inventory_amount
		case 33: CurrentMdBS := v.inventory_amount
		case 34: CurrentLgBS := v.inventory_amount
	}
	AvailableGolds := "= " Floor(CurrentGems/50) " Silver Chests"
	tokencount := (CurrentSmBounties*72)+(CurrentMdBounties*576)+(CurrentLgBounties*1152)
	AvailableTokens := "= " tokencount " Tokens"
	AvailableFPs := "(" Floor(tokencount/2500) " Free Plays)"
	AvailableBSLvs := "= " CurrentTinyBS+(CurrentSmBS*2)+(CurrentMdBS*6)+(CurrentLgBS*24) " Item Levels"
}

ParsePatronData() {
	for k, v in UserDetails.details.patrons
		switch v.patron_id
	{
		case 1: {
			for kk, vv in v.progress_bars
				switch vv.id
			{
				case "variants_completed":
				MirtVariantTotal := vv.goal
				MirtCompleted := vv.count
				MirtVariants := MirtCompleted " / " MirtVariantTotal
				case "free_play_limit": MirtFPCurrency := vv.count
				case "weekly_challenge_porgress": MirtChallenges := vv.count
			}
		}
		case 2: {
			for kk, vv in v.progress_bars
				switch vv.id
			{
				case "variants_completed":
				VajraVariantTotal := vv.goal
				VajraCompleted := vv.count
				VajraVariants := VajraCompleted " / " VajraVariantTotal
				case "free_play_limit": VajraFPCurrency := vv.count
				case "weekly_challenge_porgress": VajraChallenges := vv.count
			}
		}
		case 3: {
			for kk, vv in v.progress_bars
				switch vv.id
			{
				case "variants_completed":
				StrahdVariantTotal := vv.goal
				StrahdCompleted := vv.count
				StrahdVariants := StrahdCompleted " / " StrahdVariantTotal
				case "free_play_limit": StrahdFPCurrency := vv.count
				case "weekly_challenge_porgress": StrahdChallenges := vv.count
			}
		}
	}
}

ParseLootData() {
	EpicGearCount := 0
	for k, v in UserDetails.details.loot
		if (v.rarity == "4") {
			EpicGearCount += 1
		}
	for k, v in UserDetails.details.loot
		if ((v.hero_id == "58") && (v.slot_id == "4")) {
			brivrarity := v.rarity
			brivgild := v.gild
			brivenchant := v.enchant
		}
	switch brivrarity {
		case "0": BrivSlot4 := 0
		case "1": BrivSlot4 := 10
		case "2": BrivSlot4 := 30
		case "3": BrivSlot4 := 50
		case "4": BrivSlot4 := 100
	}
	BrivSlot4 += brivenchant*0.4
	BrivSlot4 *= 1+(brivgild*0.5)
	for k, v in UserDetails.details.modron_saves
		if (v.instance_id == ActiveInstance) {
			BrivZone := v.area_goal
		}
}

CheckPatronProgress() {
	if (MirtFPCurrency = "5000") {
		Gui, Font, cGreen
		GuiControl, Font, MirtFPCurrency
	}
	if (VajraFPCurrency = "5000") {
		Gui, Font, cGreen
		GuiControl, Font, VajraFPCurrency
	}
	if (StrahdFPCurrency = "5000") {
		Gui, Font, cGreen
		GuiControl, Font, StrahdFPCurrency
	}
	if (MirtChallenges = "10") {
		Gui, Font, cGreen
		GuiControl, Font, MirtChallenges
	}
	if (VajraChallenges = "10") {
		Gui, Font, cGreen
		GuiControl, Font, VajraChallenges
	}
	if (StrahdChallenges = "10") {
		Gui, Font, cGreen
		GuiControl, Font, StrahdChallenges
	}
	if (MirtCompleted = MirtVariantTotal) {
		Gui, Font, cGreen
		GuiControl, Font, MirtVariants
	}
	if (VajraCompleted = VajraVariantTotal) {
		Gui, Font, cGreen
		GuiControl, Font, VajraVariants
	}
	if (StrahdCompleted = StrahdVariantTotal) {
		Gui, Font, cGreen
		GuiControl, Font, StrahdVariants
	}
}

CheckAchievements() {
	if (UserDetails.details.stats.asharra_bonds < 3) {
		if !(UserDetails.details.stats.asharra_bond.human)
			ashexotic := " human"
		if !(UserDetails.details.stats.asharra_bond.elf)
			ashelf := " elf"
		if !(UserDetails.details.stats.asharra_bond.exotic)
			ashhuman := " exotic"
		todoasharra := "`nAsharra needs:" ashhuman ashelf ashexotic
	}
	if !((UserDetails.details.stats.area_175_gromma_spec_a + UserDetails.details.stats.area_175_gromma_spec_b + UserDetails.details.stats.area_175_gromma_spec_c) == 3) {
		if !(UserDetails.details.stats.area_175_gromma_spec_a == 1)
			groma := " mountain"
		if !(UserDetails.details.stats.area_175_gromma_spec_b == 1)
			gromb := " arctic"
		if !(UserDetails.details.stats.area_175_gromma_spec_c == 1)
			gromc := " swamp"
		todogromma := "`nGromma needs:" groma gromb gromc
	}
	if !((UserDetails.details.stats.krond_cantrip_1_kills > 99) && (UserDetails.details.stats.krond_cantrip_2_kills > 99) && (UserDetails.details.stats.krond_cantrip_3_kills > 99)) {
		if !(UserDetails.details.stats.krond_cantrip_1_kills > 99)
			krond1 := " thunderclap"
		if !(UserDetails.details.stats.krond_cantrip_2_kills > 99)
			krond2 := " shockinggrasp"
		if !(UserDetails.details.stats.krond_cantrip_3_kills > 99)
			krond3 := " firebolt"
		todokrond := "`nKrond needs:" krond1 krond2 krond3
	}
	if (UserDetails.details.stats.regis_specializations < 6) {
		if !(UserDetails.details.stats.regis_back_magic == 1)
			regis1 := " <-magic"
		if !(UserDetails.details.stats.regis_back_melee == 1)
			regis2 := " <-melee"
		if !(UserDetails.details.stats.regis_back_ranged == 1)
			regis3 := " <-ranged"
		if !(UserDetails.details.stats.regis_front_magic == 1)
			regis4 := " magic->"
		if !(UserDetails.details.stats.regis_front_melee == 1)
			regis5 := " melee->"
		if !(UserDetails.details.stats.regis_front_ranged == 1)
			regis6 := " ranged->"
		todoregis := "`nRegis needs:" regis1 regis2 regis3 regis4 regis5 regis6
	}
	AchievementInfo := "Locked Achievement Details" todoasharra todogromma todokrond todoregis
	if (AchievementInfo == "Locked Achievement Details") {
		AchievementInfo := "Locked Achievement Details: N/A"
	}
}

CheckBlessings() {
	epiccount := ""
	epicvalue := Round((1.02 ** EpicGearCount), 2)
	if (UserDetails.details.reset_upgrade_levels.44) { ;Helm-Slow and Steady (X Epics)
		epiccount := "Slow and Steady:`nx" epicvalue " damage (" EpicGearCount " epics)`n"
	}
	veterancount := ""
	veteranvalue := Round(1 + (0.1 * UserDetails.details.stats.completed_adventures_variants_and_patron_variants_c22), 2)
	if (UserDetails.details.reset_upgrade_levels.56) { ;Tiamat-Veterans of Avernus (X Adventures)
		veterancount := "Veterans of Avernus:`nx" veteranvalue " damage (" UserDetails.details.stats.completed_adventures_variants_and_patron_variants_c22 " adventures)`n"
	}
	BlessingInfo := "Blessing Details`n" epiccount veterancount
	if (BlessingInfo == "Blessing Details`n") {
		BlessingInfo := "Blessing Details: N/A"
	}
}

ServerCall(callname, parameters) {
	URLtoCall := "http://ps2.idlechampions.com/~idledragons/post.php?call=" callname parameters
	WR := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	WR.SetTimeouts("10000", "10000", "10000", "10000")
	Try {
		WR.Open("POST", URLtoCall, false)
		WR.SetRequestHeader("Content-Type","application/x-www-form-urlencoded")
		WR.Send()
		WR.WaitForResponse(-1)
		data := WR.ResponseText
	}
	UpdateLogTime()
	FileAppend, (%CurrentTime%) Server request: "%callname%"`n, %OutputLogFile%
	FileRead, OutputText, %OutputLogFile%
	oMyGUI.Update()
	return data
}

SimulateBriv(i) {
	SB_SetText("Calculating...")
	;Original version by Gladio Stricto - pastebin.com/Rd8wWSVC
	;Copied from updated version - github.com/Deatho0ne
	chance := ((BrivSlot4 / 100) + 1) * 0.25
	trueChance := chance
	skipLevels := 1
	if (chance > 2) {
		while chance >= 1 {
			skipLevels++
			chance /= 2
		}
		;trueChance := ((chance - Floor(chance)) / 2)
	} else {
		skipLevels := Floor(chance + 1)
		If (skipLevels > 1) {
			trueChance := 0.5 + ((chance - Floor(chance)) / 2)
		}
	}
	totalLevels := 0
	totalSkips := 0
	Loop % i {
		level := 0.0
		skips := 0.0
		Loop {
			Random, x, 0.0, 1.0
			If (x < trueChance) {
				level += skipLevels
				skips++
			}
			level++
		}
		Until level > BrivZone
		totalLevels += level
		totalSkips += skips
	}
	;chance := Round(chance, 2)
	if skipLevels < 3
		trueChance := Round(trueChance * 100, 2)
	else
		trueChance := Round(chance * 100, 2)
	avgSkips := Round(totalSkips / i, 2)
	avgSkipped := Round(avgSkips * skipLevels, 2)
	avgZones := Round(totalLevels / i, 2)
	avgSkipRate := Round((avgSkipped / avgZones) * 100, 2)
	avgStacks := Round((1.032**avgSkips) * 48, 2)
	multiplier := 0.1346894362, additve := 41.86396406
	roughTime := Round(((multiplier * avgStacks) + additve), 2)
	message = With Briv skip %skipLevels% until zone %BrivZone%`n(%trueChance%`% chance to skip %skipLevels% zones)`n`n%i% simulations produced an average:`n%avgSkips% skips (%avgSkipped% zones skipped)`n%avgZones% end zone`n%avgSkipRate%`% true skip rate`n%avgStacks% required stacks with`n%roughTime% time in secs to build said stacks very rough guess
	SB_SetText("Calculation has completed.")
	Return message
}

LaunchGame() {
	if (Not WinExist("ahk_exe IdleDragons.exe")) {
		Run, %GameClient%
		SB_SetText("Game client starting...")
		WinWait, "ahk_exe IdleDragons.exe"
		SB_SetText("Game client has started!")
	}
	else {
		if !FirstRun {
			SB_SetText("Game client is already running!")
		}
	}
	return
}

Open_Ticket:
{
	Run, % "https://help.idlechampions.com/?page=help&display=open_tickets&user_id=" UserID "&hash=" UserHash
	return
}

Discord_Clicked:
{
	Run, % "https://discord.com/invite/N3U8xtB"
	return
}

ChampFromID(id) {
	if (id < 21) {
		switch id {
			case "1": namefromid := "Bruenor"
			case "2": namefromid := "Celeste"
			case "3": namefromid := "Nayeli"
			case "4": namefromid := "Jarlaxle"
			case "5": namefromid := "Calliope"
			case "6": namefromid := "Asharra"
			case "7": namefromid := "Minsc"
			case "8": namefromid := "Delina"
			case "9": namefromid := "Makos"
			case "10": namefromid := "Tyril"
			case "11": namefromid := "Jamilah"
			case "12": namefromid := "Arkhan"
			case "13": namefromid := "Hitch"
			case "14": namefromid := "Stoki"
			case "15": namefromid := "Krond"
			case "16": namefromid := "Gromma"
			case "17": namefromid := "Dhadius"
			case "18": namefromid := "Drizzt"
			case "19": namefromid := "Barrowin"
			case "20": namefromid := "Regis"
		}
	return namefromid
	}
	else if (id < 41) {
		switch id {
			case "21": namefromid := "Birdsong"
			case "22": namefromid := "Zorbu"
			case "23": namefromid := "Strix"
			case "24": namefromid := "Nrakk"
			case "25": namefromid := "Catti-brie"
			case "26": namefromid := "Evelyn"
			case "27": namefromid := "Binwin"
			case "28": namefromid := "Deekin"
			case "29": namefromid := "Xander"
			case "30": namefromid := "Azaka"
			case "31": namefromid := "Ishi"
			case "32": namefromid := "Wulfgar"
			case "33": namefromid := "Farideh"
			case "34": namefromid := "Donaar"
			case "35": namefromid := "Vlahnya"
			case "36": namefromid := "Warden"
			case "37": namefromid := "Nerys"
			case "38": namefromid := "K'thriss"
			case "39": namefromid := "Paultin"
			case "40": namefromid := "Black Viper"
		}
	return namefromid
	}
	else if (id < 61) {
		switch id {
			case "41": namefromid := "Rosie"
			case "42": namefromid := "Aila"
			case "43": namefromid := "Spurt"
			case "44": namefromid := "Qillek"
			case "45": namefromid := "Korth"
			case "46": namefromid := "Walnut"
			case "47": namefromid := "Shandie"
			case "48": namefromid := "Jim"
			case "49": namefromid := "Turiel"
			case "50": namefromid := "Pwent"
			case "51": namefromid := "Avren"
			case "52": namefromid := "Sentry"
			case "53": namefromid := "Krull"
			case "54": namefromid := "Artemis"
			case "55": namefromid := "Môrgæn"
			case "56": namefromid := "Havilar"
			case "57": namefromid := "Sisaspia"
			case "58": namefromid := "Briv"
			case "59": namefromid := "Melf"
			case "60": namefromid := "Krydle"
			}
	return namefromid
	}
	else if (id < 81) {
		switch id {
			case "61": namefromid := "Jaheira"
			case "62": namefromid := "Nova"
			case "63": namefromid := "Freely"
			case "64": namefromid := "Beadle & Grimm"
			case "65": namefromid := "Omin"
			case "66": namefromid := "Lazaapz"
			case "67": namefromid := "Dragonbait"
			case "68": namefromid := "Ulkoria"
			case "69": namefromid := "Torogar"
			case "70": namefromid := "Ezmerelda"
			case "71": namefromid := "Y4E3"
			case "72": namefromid := "Y4E4"
			case "73": namefromid := "Y4E5"
			case "74": namefromid := "Y4E6"
			case "75": namefromid := "Y4E7"
			case "76": namefromid := "Y4E8"
			case "77": namefromid := "Y4E9"
			case "78": namefromid := "Y4E10"
			case "79": namefromid := "Y4E11"
			case "80": namefromid := "Y4E12"
		}
	return namefromid
	}
	else if (id < 86) {
		switch id {
			case "81": namefromid := "Y4E13"
			case "82": namefromid := "Y4E14"
			case "83": namefromid := "Y4E15"
			case "84": namefromid := "Y4E16"
			case "85": namefromid := "Y4E17"
		}
	return namefromid
	}
	else {
		namefromid := "UNKNOWN"
		return namefromid
	}
}