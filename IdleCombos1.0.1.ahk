#include JSON.ahk
;To do list:
;-parse server responses
;-blacksmithing
;-bounties
;-install dir picker
;-expand switches?
;-log redeemed codes. prevent duplicate uses.

;Special thanks to all the idle dragons who inspired and assisted me!
global VersionNumber := "1.0.1"

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
;Inventory globals
global CurrentGems := 0
global AvailableGolds := ""
global SpentGems := 0
global CurrentGolds := 0
global CurrentSilvers := 0
global CurrentTGPs := 0
global AvailableTGs := ""
global CurrentSmBounties := 0
global CurrentMdBounties := 0
global CurrentLgBounties := 0
global AvailableTokens := ""
global AvailableFPs := ""
global CurrentTinyBS := 0
global CurrentSmBS := 0
global CurrentMdBS := 0
global CurrentLgBS := 0
global AvailableBSLvs := ""
;Briv globals
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

;BEGIN:	default run commands
UpdateLogTime()
FileAppend, (%CurrentTime%) IdleCombos v%VersionNumber% started.`n, %OutputLogFile%
FileRead, OutputText, %OutputLogFile%
if (!oMyGUI) {
	oMyGUI := new MyGui()
}
;First run checks and setup
if !FileExist(SettingsFile) {
	newsettings := JSON.stringify({"firstrun":0,"user_id":0,"hash":0,"getdetailsonstart":0,"launchgameonstart":0,"alwayssavechests":0,"alwayssavecodes":0})
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
		Menu, FileSubmenu, Add, &GetUserDetails, GetUserDetails
		Menu, FileSubmenu, Add, &Reload (F9), Reload_Clicked
		Menu, FileSubmenu, Add, E&xit (F10), Exit_Clicked
		Menu, IdleMenu, Add, &File, :FileSubmenu
		
		Menu, BuyChestsSubmenu, Add, &Gold, Buy_Gold
		Menu, BuyChestsSubmenu, Add, &Silver, Buy_Silver
		Menu, ToolsSubmenu, Add, &Buy Chests, :BuyChestsSubmenu
		Menu, OpenChestsSubmenu, Add, &Gold, Open_Gold
		Menu, OpenChestsSubmenu, Add, &Silver, Open_Silver
		Menu, ToolsSubmenu, Add, &Open Chests, :OpenChestsSubmenu
		Menu, ToolsSubmenu, Add, &Redeem Codes, Open_Codes
		Menu, ToolsSubmenu, Add, &Adventure Selector, LoadAdventure
		Menu, ToolsSubmenu, Add, &End Current Adventure, EndAdventure
		Menu, ToolsSubmenu, Add, BrivStack &Calculator, Briv_Calc
		Menu, IdleMenu, Add, &Tools, :ToolsSubmenu
		
		Menu, HelpSubmenu, Add, &Run Setup, FirstRun
		Menu, HelpSubmenu, Add, Clear Log, Clear_Log
		Menu, HelpSubmenu, Add, &About IdleCombos, About_Clicked
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
		Gui, MyWindow:Add, Button, x%col3_x% y%row_y% w60 gUpdate_Clicked, Update
		
		row_y := row_y + 25
		Gui, MyWindow:Add, Text, x390 y53 vCrashProtectStatus, % CrashProtectStatus
		Gui, MyWindow:Add, Button, x%col3_x% y%row_y% w60 gCrash_Toggle, Toggle
		
		Gui, Tab, Summary
		Gui, MyWindow:Add, Text, x15 y33, This page intentionally left blank.
		
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
		Gui, MyWindow:Add, Text, x15 y+p w110, Time Gate Pieces:
		Gui, MyWindow:Add, Text, vCurrentTGPs x+2 w35 right, % CurrentTGPs
		Gui, MyWindow:Add, Text, vAvailableTGs x+10 w185, % AvailableTGs
		
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
		GuiControl, , CrashProtectStatus, % CrashProtectStatus, w250 h210
		;adventures
		GuiControl, , CurrentAdventure, % CurrentAdventure, w250 h210
		GuiControl, , CurrentPatron, % CurrentPatron, w250 h210
		;inventory
		GuiControl, , CurrentGems, % CurrentGems, w250 h210
		GuiControl, , SpentGems, % SpentGems, w250 h210
		GuiControl, , CurrentGolds, % CurrentGolds, w250 h210
		GuiControl, , CurrentSilvers, % CurrentSilvers, w250 h210
		GuiControl, , CurrentTGPs, % CurrentTGPs, w250 h210
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
		;this.Show()
	}
}

;Hotkeys
$F9::Reload
$F10::ExitApp

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
	Gui, CodeWindow:Add, Button, x+18 gClose_Codes, Cancel
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
		CodesPending := "Codes pending: " CodeCount
		GuiControl, , CodesPending, % CodesPending, w250 h210
		if (CurrentSettings.alwayssavecodes) {
			FileAppend, %rawresults%`n, %RedeemCodeLogFile%
		}
		else {
			InputBox, dummyvar, Code Results, Save to File?, , 250, 150, , , , , % rawresults
			dummyvar := ""
			if !ErrorLevel {
				FileAppend, %rawresults%`n, %RedeemCodeLogFile%
			}
		}
		sleep, 2000
	}
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
			InputBox, count, Buying Chests, % "How many Silver Chests?`n(Max: " maxbuy ")`n(Limit: 99)", , 200, 180
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
			InputBox, count, Buying Chests, % "How many Gold Chests?`n(Max: " maxbuy ")`n(Limit: 99)", , 200, 180
			if ErrorLevel
				return
			if (count = "alpha") {
				chestparams := DummyData "&user_id=" UserID "&hash=" UserHash "&instance_id=" InstanceID
				rawresults := ServerCall("alphachests", chestparams)
				MsgBox % rawresults
				GetUserDetails()
				SB_SetText("Got 5 Free Daily Alpha Chests!")
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
	chestparams := DummyData "&user_id=" UserID "&hash=" UserHash "&instance_id=" InstanceID "&chest_type_id=" chestid "&count=" count
	rawresults := ServerCall("buysoftcurrencychest", chestparams)
	chestresults := JSON.parse(rawresults)
	gemsspent := chestresults.currency_spent
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
			InputBox, count, Buying Chests, % "How many Silver Chests?`n(Max: " CurrentSilvers ")`n(Limit: 99)", , 200, 180
			if ErrorLevel
				return
			if (count > CurrentSilvers) {
				MsgBox, 4, , Insufficient chests detected for opening.`nContinue anyway?
				IfMsgBox No
					return
			}
		}
		case 2: {
			InputBox, count, Buying Chests, % "How many Gold Chests?`n(Max: " CurrentGolds ")`n(Limit: 99)", , 200, 180
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
	chestparams := "&gold_per_second=0&checksum=4c5f019b6fc6eefa4d47d21cfaf1bc68&user_id=" UserID "&hash=" UserHash "&instance_id=" InstanceID "&chest_type_id=" chestid "&count=" count "&game_instance_id=" ActiveInstance
	rawresults := ServerCall("opengenericchest", chestparams)
	if (CurrentSettings.alwayssavechests) {
		FileAppend, %rawresults%`n, %ChestOpenLogFile%
	}
	else {
		InputBox, dummyvar, Chest Results, Save to File?, , 250, 150, , , , , % rawresults
		dummyvar := ""
		if !ErrorLevel {
			FileAppend, %rawresults%`n, %ChestOpenLogFile%
		}
	}
	chestresults := JSON.parse(rawresults)
	chestsopened := chestresults.currency_spent
	UpdateLogTime()
	FileAppend, (%CurrentTime%) Chests Opened: %count%`n, %OutputLogFile%
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
	SB_SetText("Selected adventure has been loaded.")
	GetUserDetails()
	return
}

EndAdventure() {
	while (CurrentAdventure == "-1") {
		MsgBox, No current adventure active.
		return
	}
	advparams := DummyData "&user_id=" UserID "&hash=" UserHash "&instance_id=" InstanceID "&game_instance_id=" ActiveInstance
	sResult := ServerCall("softreset", advparams)
	SB_SetText("Current adventure has been ended.")
	GetUserDetails()
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
		InputBox, UserID, user_id, Please enter your "user_id" value., , 250, 125
		if ErrorLevel
			return
		InputBox, UserHash, hash, Please enter your "hash" value., , 250, 125
		if ErrorLevel
			return
		UpdateLogTime()
		FileAppend, (%CurrentTime%) User ID: %UserID% & Hash: %UserHash% manually entered.`n, %OutputLogFile%
		
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
	if not ErrorLevel {
		FoundPos := InStr(oData, "getuserdetails&language_id=1&user_id=")
		oData2 := SubStr(oData, (FoundPos + 37))
		FoundPos := InStr(oData2, "&hash=")
		StringLeft, UserID, oData2, (FoundPos - 1)
		oData := SubStr(oData2, (FoundPos + 6))
		FoundPos := InStr(oData, "&instance_key=")
		StringLeft, UserHash, oData, (FoundPos - 1)
	}
	else {
		MsgBox, Error Reading WebRequestLog.txt
	}
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
	ParseInventoryData()
	ParsePatronData()
	ParseBrivData()
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
}

ParseInventoryData() {
	CurrentGems := UserDetails.details.red_rubies
	SpentGems := UserDetails.details.red_rubies_spent
	CurrentGolds := UserDetails.details.chests.2
	CurrentSilvers := UserDetails.details.chests.1
	CurrentTGPs := UserDetails.details.time_gates.time_gate_key_pieces
	AvailableTGs := "(" Floor(CurrentTGPs/6) " Time Gates)"
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
	AvailableGolds := "(" Floor(CurrentGems/500) " Gold Chests)"
	tokencount := (CurrentSmBounties*72)+(CurrentMdBounties*576)+(CurrentLgBounties*1152)
	AvailableTokens := "(" tokencount " Tokens)"
	AvailableFPs := "(" Floor(tokencount/2500) " Free Plays)"
	AvailableBSLvs := "(" CurrentTinyBS+(CurrentSmBS*2)+(CurrentMdBS*6)+(CurrentLgBS*24) " Item Levels)"
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

ParseBrivData() {
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
