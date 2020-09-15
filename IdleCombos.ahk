#include %A_ScriptDir%
#include JSON.ahk
;Fixed in 1.4.1
;-Clearing variables to prevent bad results when using only one core

;Added in 1.4
;-Shows active cores, reset area, and XP
;-Able to download Journal to file
;-Able to load WRL file from other platforms
;-(Tested: Android & iOS.)
;-Highest gear level also shows Champ and Slot

;Fixed in 1.4
;-Settings file will correct itself when new settings are added
;-Morgaen gold value is now a reasonable length

;Special thanks to all the idle dragons who inspired and assisted me!
global VersionNumber := "1.4.1"

;Local File globals
global OutputLogFile := "idlecombolog.txt"
global SettingsFile := "idlecombosettings.json"
global UserDetailsFile := "userdetails.json"
global ChestOpenLogFile := "chestopenlog.json"
global BlacksmithLogFile := "blacksmithlog.json"
global RedeemCodeLogFile := "redeemcodelog.json"
global JournalFile := "journal.json"
global CurrentSettings := []
global GameInstallDir := "C:\Program Files (x86)\Steam\steamapps\common\IdleChampions\"
global WRLFile := GameInstallDir "IdleDragons_Data\StreamingAssets\downloaded_files\webRequestLog.txt"
global GameClient := GameInstallDir "IdleDragons.exe"

;Settings globals
global GetDetailsonStart := 0
global LaunchGameonStart := 0
global FirstRun := 1
global AlwaysSaveChests := 0
global AlwaysSaveContracts := 0
global AlwaysSaveCodes := 0
global SettingsCheckValue := 9 ;used to check for outdated settings file
global NewSettings := JSON.stringify({"firstrun":0,"user_id":0,"hash":0,"instance_id":0,"getdetailsonstart":0,"launchgameonstart":0,"alwayssavechests":1,"alwayssavecontracts":1,"alwayssavecodes":1})

;Server globals
global DummyData := "&language_id=1&timestamp=0&request_id=0&network_id=11&mobile_client_version=999"
global CodestoEnter := ""

;User info globals
global UserID := 0
global UserHash := 0
global InstanceID := 0
global UserDetails := []
global ActiveInstance := 0
global CurrentAdventure := ""
global CurrentArea := ""
global CurrentPatron := ""
global BackgroundAdventure := ""
global BackgroundArea := ""
global BackgroundPatron := ""
global AchievementInfo := "This page intentionally left blank.`n`n`n`n`n`n"
global BlessingInfo := "`n`n`n`n`n`n"
global ChampDetails := ""
global TotalChamps := 0
;Inventory globals
global CurrentGems := ""
global AvailableChests := ""
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
global BrivSlot4 := 0
global BrivZone := 0
;Modron globals
global FGCore := "`n"
global BGCore := "`n"
;Patron globals
global MirtVariants := ""
global MirtCompleted := ""
global MirtVariantTotal := ""
global MirtFPCurrency := ""
global MirtChallenges := ""
global MirtRequires := ""
global MirtCosts := ""
global VajraVariants := ""
global VajraCompleted := ""
global VajraVariantTotal := ""
global VajraFPCurrency := ""
global VajraChallenges := ""
global VajraRequires := ""
global VajraCosts := ""
global StrahdVariants := ""
global StrahdCompleted := ""
global StrahdVariantTotal := ""
global StrahdFPCurrency := ""
global StrahdChallenges := ""
global StrahdRequires := ""
global StrahdCosts := ""

;GUI globals
global oMyGUI := ""
global OutputText := "Test"
global OutputStatus := "Welcome to IdleCombos v" VersionNumber
global CurrentTime := ""
global CrashProtectStatus := "Crash Protect`nDisabled"
global CrashCount := 0
global LastUpdated := "No data loaded."
global TrayIcon := systemroot "\system32\imageres.dll"
global LastBSChamp := ""

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
	FileAppend, %NewSettings%, %SettingsFile%
	UpdateLogTime()
	FileAppend, (%CurrentTime%) Settings file "idlecombosettings.json" created.`n, %OutputLogFile%
	FileRead, OutputText, %OutputLogFile%
	oMyGUI.Update()
}
FileRead, rawsettings, %SettingsFile%
CurrentSettings := JSON.parse(rawsettings)
if !(CurrentSettings.Count() == SettingsCheckValue) {
	FileDelete, %SettingsFile%
	FileAppend, %NewSettings%, %SettingsFile%
	UpdateLogTime()
	FileAppend, (%CurrentTime%) Settings file "idlecombosettings.json" created.`n, %OutputLogFile%
	FileRead, OutputText, %OutputLogFile%
	FileRead, rawsettings, %SettingsFile%
	CurrentSettings := JSON.parse(rawsettings)
	oMyGUI.Update()
	MsgBox, Your settings file has been deleted due to an update to IdleCombos.  Please verify that your settings are set as preferred.
}
if FileExist(A_ScriptDir "\webRequestLog.txt") {
	MsgBox, 4, , % "WRL File detected.  Use file?"
	IfMsgBox, Yes
	{
		WRLFile := A_ScriptDir "\webRequestLog.txt"
		FirstRun()
	}
}
if !(CurrentSettings.firstrun) {
	FirstRun()
}
if (CurrentSettings.user_id && CurrentSettings.hash) {
	UserID := CurrentSettings.user_id
	UserHash := CurrentSettings.hash
	InstanceID := CurrentSettings.instance_id
	SB_SetText("User ID & Hash ready.")
}
else {
	SB_SetText("User ID & Hash not found!")
}
;Loading current settings
GetDetailsonStart := CurrentSettings.getdetailsonstart
LaunchGameonStart := CurrentSettings.launchgameonstart
AlwaysSaveChests := CurrentSettings.alwayssavechests
AlwaysSaveContracts := CurrentSettings.alwayssavecontracts
AlwaysSaveCodes := CurrentSettings.alwayssavecodes
if (GetDetailsonStart == "1") {
	GetUserDetails()
}
if (LaunchGameonStart == "1") {
	LaunchGame()
}
oMyGUI.Update()
SendMessage, 0x115, 7, 0, Edit1, A
return
;END:	default run commands

;BEGIN: GUI Defs
class MyGui {
	Width := "550"
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
		
		Menu, ChestsSubmenu, Add, Buy Gold, Buy_Gold
		Menu, ChestsSubmenu, Add, Buy Silver, Buy_Silver
		Menu, ChestsSubmenu, Add, Open Gold, Open_Gold
		Menu, ChestsSubmenu, Add, Open Silver, Open_Silver
		Menu, ToolsSubmenu, Add, &Chests, :ChestsSubmenu
		Menu, BlacksmithSubmenu, Add, Use Tiny Contracts, Tiny_Blacksmith
		Menu, BlacksmithSubmenu, Add, Use Small Contracts, Sm_Blacksmith
		Menu, BlacksmithSubmenu, Add, Use Medium Contracts, Med_Blacksmith
		Menu, BlacksmithSubmenu, Add, Use Large Contracts, Lg_Blacksmith
		Menu, ToolsSubmenu, Add, &Blacksmith, :BlacksmithSubmenu
		Menu, ToolsSubmenu, Add, &Redeem Codes, Open_Codes
		Menu, AdvSubmenu, Add, &Load New Adv, LoadAdventure
		Menu, AdvSubmenu, Add, &End Current Adv, EndAdventure
		Menu, AdvSubmenu, Add, Load New BG Adv, LoadBGAdventure
		Menu, AdvSubmenu, Add, End Current BG Adv, EndBGAdventure
		Menu, ToolsSubmenu, Add, &Adventure Manager, :AdvSubmenu
		Menu, ToolsSubmenu, Add, Briv &Stack Calculator, Briv_Calc
		Menu, IdleMenu, Add, &Tools, :ToolsSubmenu
		
		Menu, HelpSubmenu, Add, &Run Setup, FirstRun
		Menu, HelpSubmenu, Add, Clear &Log, Clear_Log
		Menu, HelpSubmenu, Add, Download &Journal, Get_Journal
		Menu, HelpSubmenu, Add, CNE &Support Ticket, Open_Ticket
		Menu, HelpSubmenu, Add
		Menu, HelpSubmenu, Add, &List Champ IDs, List_ChampIDs
		Menu, HelpSubmenu, Add, &About IdleCombos, About_Clicked
		Menu, HelpSubmenu, Add, &Discord Support Server, Discord_Clicked
		Menu, IdleMenu, Add, &Help, :HelpSubmenu
		Gui, Menu, IdleMenu
		
		col1_x := 5
		col2_x := 420
		col3_x := 480
		row_y := 5
		
		Gui, Add, StatusBar,, %OutputStatus%
		
		Gui, MyWindow:Add, Button, x%col2_x% y%row_y% w60 gReload_Clicked, Reload
		Gui, MyWindow:Add, Button, x%col3_x% y%row_y% w60 gExit_Clicked, Exit
		
		Gui, MyWindow:Add, Tab3, x%col1_x% y%row_y% w400, Summary|Adventures||Inventory|Patrons|Champions|Settings|Log|
		Gui, Tab
		
		row_y := row_y + 25
		;Gui, MyWindow:Add, Button, x%col3_x% y%row_y% w60 gUpdate_Clicked, Update
		
		row_y := row_y + 25
		Gui, MyWindow:Add, Text, x410 y53 vCrashProtectStatus, % CrashProtectStatus
		Gui, MyWindow:Add, Button, x%col3_x% y%row_y% w60 gCrash_Toggle, Toggle
		
		Gui, MyWindow:Add, Text, x410 y100, Data Timestamp:
		Gui, MyWindow:Add, Text, x410 y120 vLastUpdated w220, % LastUpdated
		Gui, MyWindow:Add, Button, x410 y140 w60 gUpdate_Clicked, Update
		
		Gui, Tab, Summary
		Gui, MyWindow:Add, Text, vAchievementInfo x15 y33 w300, % AchievementInfo
		Gui, MyWindow:Add, Text, vBlessingInfo x200 y33 w300, % BlessingInfo
		
		Gui, Tab, Adventures
		Gui, MyWindow:Add, Text, x15 y33 w120, Current Adventure:
		Gui, MyWindow:Add, Text, vCurrentAdventure x+2 w50, % CurrentAdventure
		Gui, MyWindow:Add, Text, x15 y+p w120, Current Patron:
		Gui, MyWindow:Add, Text, vCurrentPatron x+2 w50, % CurrentPatron
		Gui, MyWindow:Add, Text, x15 y+p w120, Current Area:
		Gui, MyWindow:Add, Text, vCurrentArea x+2 w50, % CurrentArea
		Gui, MyWindow:Add, Text, x15 y76 w120, Background Adventure:
		Gui, MyWindow:Add, Text, vBackgroundAdventure x+2 w50, % BackgroundAdventure
		Gui, MyWindow:Add, Text, x15 y+p w120, Background Patron:
		Gui, MyWindow:Add, Text, vBackgroundPatron x+2 w50, % BackgroundPatron
		Gui, MyWindow:Add, Text, x15 y+p w120, Background Area:
		Gui, MyWindow:Add, Text, vBackgroundArea x+2 w50, % BackgroundArea
		
		Gui, MyWindow:Add, Text, vFGCore x200 y33 w150, % FGCore
		Gui, MyWindow:Add, Text, vBGCore x200 y76 w150, % BGCore
		
		Gui, Tab, Inventory
		Gui, MyWindow:Add, Text, x15 y33 w70, Current Gems:
		Gui, MyWindow:Add, Text, vCurrentGems x+2 w75 right, % CurrentGems
		Gui, MyWindow:Add, Text, vAvailableChests x+10 w190, % AvailableChests
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
		Gui, MyWindow:Add, Text, x15 y33 w75, Mirt Variants:
		Gui, MyWindow:Add, Text, vMirtVariants x+p w75 right cRed, % MirtVariants
		Gui, MyWindow:Add, Text, x15 y+p w95, Mirt FP Currency:
		Gui, MyWindow:Add, Text, vMirtFPCurrency x+p w55 right cRed, % MirtFPCurrency
		Gui, MyWindow:Add, Text, vMirtRequires x+2 w200 right, % MirtRequires
		Gui, MyWindow:Add, Text, x15 y+p w95, Mirt Challenges:
		Gui, MyWindow:Add, Text, vMirtChallenges x+p w55 right cRed, % MirtChallenges
		Gui, MyWindow:Add, Text, vMirtCosts x+2 w200 right, % MirtCosts
		
		Gui, MyWindow:Add, Text, x15 y+5+p w75, Vajra Variants:
		Gui, MyWindow:Add, Text, vVajraVariants x+p w75 right cRed, % VajraVariants
		Gui, MyWindow:Add, Text, x15 y+p w95, Vajra FP Currency:
		Gui, MyWindow:Add, Text, vVajraFPCurrency x+p w55 right cRed, % VajraFPCurrency
		Gui, MyWindow:Add, Text, vVajraRequires x+2 w200 right, % VajraRequires
		Gui, MyWindow:Add, Text, x15 y+p w95, Vajra Challenges:
		Gui, MyWindow:Add, Text, vVajraChallenges x+p w55 right cRed, % VajraChallenges
		Gui, MyWindow:Add, Text, vVajraCosts x+2 w200 right, % VajraCosts
		
		Gui, MyWindow:Add, Text, x15 y+5+p w75, Strahd Variants:
		Gui, MyWindow:Add, Text, vStrahdVariants x+p w75 right cRed, % StrahdVariants
		Gui, MyWindow:Add, Text, x15 y+p w95, Strahd FP Currency:
		Gui, MyWindow:Add, Text, vStrahdFPCurrency x+p w55 right cRed, % StrahdFPCurrency
		Gui, MyWindow:Add, Text, vStrahdRequires x+2 w200 right, % StrahdRequires
		Gui, MyWindow:Add, Text, x15 y+p w95, Strahd Challenges:
		Gui, MyWindow:Add, Text, vStrahdChallenges x+p w55 right cRed, % StrahdChallenges
		Gui, MyWindow:Add, Text, vStrahdCosts x+2 w200 right, % StrahdCosts
		
		Gui, Tab, Champions
		Gui, MyWindow:Add, Text, vChampDetails x15 y33 w300 h150, % ChampDetails
		
		Gui, Tab, Settings
		Gui, MyWindow:Add, CheckBox, vGetDetailsonStart, Get User Details on start?
		Gui, MyWindow:Add, CheckBox, vLaunchGameonStart, Launch game client on start?
		Gui, MyWindow:Add, CheckBox, vAlwaysSaveChests, Always save Chest Open Results to file?
		Gui, MyWindow:Add, CheckBox, vAlwaysSaveContracts, Always save Blacksmith Results to file?
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
		GuiControl, MyWindow:, OutputText, % OutputText, w250 h210
		SendMessage, 0x115, 7, 0, Edit1
		GuiControl, MyWindow:, CrashProtectStatus, % CrashProtectStatus, w250 h210
		GuiControl, MyWindow:, AchievementInfo, % AchievementInfo, w250 h210
		GuiControl, MyWindow:, BlessingInfo, % BlessingInfo, w250 h210
		GuiControl, MyWindow:, LastUpdated, % LastUpdated, w250 h210
		;adventures
		GuiControl, MyWindow:, CurrentAdventure, % CurrentAdventure, w250 h210
		GuiControl, MyWindow:, CurrentArea, % CurrentArea, w250 h210
		GuiControl, MyWindow:, CurrentPatron, % CurrentPatron, w250 h210
		GuiControl, MyWindow:, BackgroundAdventure, % BackgroundAdventure, w250 h210
		GuiControl, MyWindow:, BackgroundArea, % BackgroundArea, w250 h210
		GuiControl, MyWindow:, BackgroundPatron, % BackgroundPatron, w250 h210
		GuiControl, MyWindow:, FGCore, % FGCore, w250 h210
		GuiControl, MyWindow:, BGCore, % BGCore, w250 h210
		;inventory
		GuiControl, MyWindow:, CurrentGems, % CurrentGems, w250 h210
		GuiControl, MyWindow:, SpentGems, % SpentGems, w250 h210
		GuiControl, MyWindow:, CurrentGolds, % CurrentGolds, w250 h210
		GuiControl, MyWindow:, CurrentSilvers, % CurrentSilvers, w250 h210
		GuiControl, MyWindow:, CurrentTGPs, % CurrentTGPs, w250 h210
		GuiControl, MyWindow:, NextTGPDrop, % NextTGPDrop, w250 h210
		GuiControl, MyWindow:, AvailableTGs, % AvailableTGs, w250 h210
		GuiControl, MyWindow:, AvailableChests, % AvailableChests, w250 h210
		GuiControl, MyWindow:, CurrentSmBounties, % CurrentSmBounties, w250 h210
		GuiControl, MyWindow:, CurrentMdBounties, % CurrentMdBounties, w250 h210
		GuiControl, MyWindow:, CurrentLgBounties, % CurrentLgBounties, w250 h210
		GuiControl, MyWindow:, AvailableTokens, % AvailableTokens, w250 h210
		GuiControl, MyWindow:, AvailableFPs, % AvailableFPs, w250 h210
		GuiControl, MyWindow:, CurrentTinyBS, % CurrentTinyBS, w250 h210
		GuiControl, MyWindow:, CurrentSmBS, % CurrentSmBS, w250 h210
		GuiControl, MyWindow:, CurrentMdBS, % CurrentMdBS, w250 h210
		GuiControl, MyWindow:, CurrentLgBS, % CurrentLgBS, w250 h210
		GuiControl, MyWindow:, AvailableBSLvs, % AvailableBSLvs, w250 h210
		;patrons
		GuiControl, MyWindow:, MirtVariants, % MirtVariants, w250 h210
		GuiControl, MyWindow:, MirtChallenges, % MirtChallenges, w250 h210
		GuiControl, MyWindow:, MirtFPCurrency, % MirtFPCurrency, w250 h210
		GuiControl, MyWindow:, MirtRequires, % MirtRequires, w250 h210
		GuiControl, MyWindow:, MirtCosts, % MirtCosts, w250 h210
		GuiControl, MyWindow:, VajraVariants, % VajraVariants, w250 h210
		GuiControl, MyWindow:, VajraChallenges, % VajraChallenges, w250 h210
		GuiControl, MyWindow:, VajraFPCurrency, % VajraFPCurrency, w250 h210
		GuiControl, MyWindow:, VajraRequires, % VajraRequires, w250 h210
		GuiControl, MyWindow:, VajraCosts, % VajraCosts, w250 h210
		GuiControl, MyWindow:, StrahdVariants, % StrahdVariants, w250 h210
		GuiControl, MyWindow:, StrahdChallenges, % StrahdChallenges, w250 h210
		GuiControl, MyWindow:, StrahdFPCurrency, % StrahdFPCurrency, w250 h210
		GuiControl, MyWindow:, StrahdRequires, % StrahdRequires, w250 h210
		GuiControl, MyWindow:, StrahdCosts, % StrahdCosts, w250 h210
		;champions
		GuiControl, MyWindow:, ChampDetails, % ChampDetails, w250 h210
		;settings
		GuiControl, MyWindow:, GetDetailsonStart, % GetDetailsonStart, w250 h210
		GuiControl, MyWindow:, LaunchGameonStart, % LaunchGameonStart, w250 h210
		GuiControl, MyWindow:, AlwaysSaveChests, % AlwaysSaveChests, w250 h210
		GuiControl, MyWindow:, AlwaysSaveContracts, % AlwaysSaveContracts, w250 h210
		GuiControl, MyWindow:, AlwaysSaveCodes, % AlwaysSaveCodes, w250 h210
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
	CurrentSettings.alwayssavecontracts := AlwaysSaveContracts
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
	Gui, CodeWindow:Show, w230 h220, Codes
	Gui, CodeWindow:Add, Edit, r12 vCodestoEnter w190 x20 y20, IDLE-CHAM-PION-SNOW
	Gui, CodeWindow:Add, Button, gRedeem_Codes, Submit
	Gui, CodeWindow:Add, Text, w100 x+6 vCodesPending, Codes pending: 0
	Gui, CodeWindow:Add, Button, x+4 gClose_Codes, Close
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
	usedcodes := ""
	expiredcodes := ""
	codegolds := 0
	otherchests := ""
	tempsavesetting := 0
	tempnosavesetting := 0
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
		coderesults := JSON.parse(rawresults)
		rawactions := JSON.stringify(coderesults.actions)
		StringTrimLeft, rawactions, rawactions, 1
		StringTrimRight, rawactions, rawactions, 1
		codeactions := JSON.parse(rawactions)
		if (coderesults.failure_reason == "Outdated instance id") {
			MsgBox, 4, , % "Outdated instance id. Update from server?"
			IfMsgBox, Yes
			{
				GetUserDetails()
				Gui, CodeWindow:Default
				while (InstanceID == 0) {
					sleep, 2000
				}
				codeparams := DummyData "&user_id=" UserID "&hash=" UserHash "&instance_id=" InstanceID "&code=" sCode
				rawresults := ServerCall("redeemcoupon", codeparams)
				coderesults := JSON.parse(rawresults)
			}
			else {
				return
			}
		}
		if (coderesults.failure_reason == "You have already redeemed this combination.") {
			usedcodes := usedcodes sCode "`n"
		}
		else if (coderesults.failure_reason == "This offer has expired") {
			expiredcodes := expiredcodes sCode "`n"
		}
		else if (codeactions.chest_type_id == 2) {
			codegolds += codeactions.count
		}
		else if (otherchests codeactions.chest_type_id) {
			otherchests := otherchests codeactions.chest_type_id ", "
		}			
		CodeCount := % (CodeCount-1)
		if (CurrentSettings.alwayssavecodes || tempsavesetting) {
			FileAppend, %sCode%`n, %RedeemCodeLogFile%
			FileAppend, %rawresults%`n, %RedeemCodeLogFile%
		}
		else if !(tempnosavesetting) {
			MsgBox, 4, , "Save to File?"
			IfMsgBox, Yes
			{
				tempsavesetting := 1
				FileAppend, %sCode%`n, %RedeemCodeLogFile%
				FileAppend, %rawresults%`n, %RedeemCodeLogFile%
			}
			else IfMsgBox, No
			{
				tempnosavesetting := 1
			}
		}
		sleep, 2000
		CodesPending := "Codes pending: " CodeCount
		GuiControl, , CodesPending, % CodesPending, w250 h210
	}
	CodesPending := "Codes submitted!"
	codemessage := ""
	if !(usedcodes == "") {
		codemessage := codemessage "Already used:`n" usedcodes "`n"
	}
	if !(expiredcodes == "") {
		codemessage := codemessage "Expired:`n" expiredcodes "`n"
	}
	if (codegolds > 0) {
		codemessage := codemessage "Gold Chests:`n" codegolds "`n"
	}
	if !(otherchests == "") {
		codemessage := codemessage "Other chests:`n" otherchests "`n"
	}
	if (codemessage == "") {
		codemessage := "No Results."
	}
	GuiControl, , CodesPending, % CodesPending, w250 h210
	GetUserDetails()
	oMyGUI.Update()
	MsgBox % codemessage
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

Buy_Extra_Chests(chestid,extracount) {
	chestparams := DummyData "&user_id=" UserID "&hash=" UserHash "&instance_id=" InstanceID "&chest_type_id=" chestid "&count="
	gemsspent := 0
	while (extracount > 0) {
		SB_SetText("Chests remaining to purchase: " extracount)
		if (extracount < 100) {
			rawresults := ServerCall("buysoftcurrencychest", chestparams extracount)
			extracount -= extracount
		}
		else {
			rawresults := ServerCall("buysoftcurrencychest", chestparams "99")
			extracount -= 99
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
	SB_SetText("Chest purchase completed.")
	return gemsspent
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
	if (!CurrentGolds && !CurrentSilvers && !CurrentGems) {
		MsgBox, 4, , No chests or gems detected.  Check server for user details?
		IfMsgBox, Yes
		{
			GetUserDetails()
		}
	}
	switch chestid
	{
		case 1: {
			InputBox, count, Opening Chests, % "How many Silver Chests?`n(Owned: " CurrentSilvers ")`n(Max: " (CurrentSilvers + Floor(CurrentGems/50)) ")", , 200, 180
			if ErrorLevel
				return
			if (count > CurrentSilvers) {
				MsgBox, 4, , % "Spend " ((count - CurrentSilvers)*50) " gems to purchase " (count - CurrentSilvers) " chests before opening?"
				extracount := (count - CurrentSilvers)
				IfMsgBox, Yes
					extraspent := Buy_Extra_Chests(1,extracount)
				else {
					return
				}
			}
		}
		case 2: {
			InputBox, count, Opening Chests, % "How many Gold Chests?`n(Owned: " CurrentGolds ")`n(Max: " (CurrentGolds + Floor(CurrentGems/500)) ")", , 200, 180
			if ErrorLevel
				return
			if (count > CurrentGolds) {
				MsgBox, 4, , % "Spend " ((count - CurrentGolds)*500) " gems to purchase " (count - CurrentGolds) " chests before opening?"
				extracount := (count - CurrentGolds)
				IfMsgBox, Yes
					extraspent := Buy_Extra_Chests(2,extracount)
				else {
					return
				}
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
			switch chestid
		{
			case "1": {
				chestsopened := ((CurrentSilvers - chestresults.chests_remaining) + (extraspent/50))
				MsgBox % "New Shinies:`n" newshinies
			}
			case "2": {
				chestsopened := ((CurrentGolds - chestresults.chests_remaining) + (extraspent/500))
				MsgBox % "New Feats:`n" newfeats "`nNew Shinies:`n" newshinies
			}
		}
			MsgBox % "Error: " rawresults
			UpdateLogTime()
			FileAppend, % "(" CurrentTime ") Chests Opened: " Floor(chestsopened) "`n", %OutputLogFile%
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
	tempsavesetting := 0
	tempnosavesetting := 0
	switch chestid
{
	case "1": {
		chestsopened := ((CurrentSilvers - chestresults.chests_remaining) + (extraspent/50))
		MsgBox % "New Shinies:`n" newshinies
	}
	case "2": {
		chestsopened := ((CurrentGolds - chestresults.chests_remaining) + (extraspent/500))
		MsgBox % "New Feats:`n" newfeats "`nNew Shinies:`n" newshinies
	}
}
	UpdateLogTime()
	FileAppend, % "(" CurrentTime ") Chests Opened: " Floor(chestsopened) "`n", %OutputLogFile%
	FileRead, OutputText, %OutputLogFile%
	oMyGUI.Update()
	GetUserDetails()
	SB_SetText("Chest opening completed.")
	return
}

Tiny_Blacksmith:
{
	UseBlacksmith(31)
	return
}

Sm_Blacksmith:
{
	UseBlacksmith(32)
	return
}

Med_Blacksmith:
{
	UseBlacksmith(33)
	return
}

Lg_Blacksmith:
{
	UseBlacksmith(34)
	return
}

UseBlacksmith(buffid) {
	if !UserID {
		MsgBox % "Need User ID & Hash."
		FirstRun()
	}
	switch buffid
{
	case 31: currentcontracts := CurrentTinyBS
	case 32: currentcontracts := CurrentSmBS
	case 33: currentcontracts := CurrentMdBS
	case 34: currentcontracts := CurrentLgBS
}	
	if !(currentcontracts) {
		MsgBox, 4, , No Blacksmith Contracts of that size detected.  Check server for user details?
		IfMsgBox, Yes
		{
			GetUserDetails()
		}
	}
	InputBox, count, Blacksmithing, % "How many Blacksmith Contracts?`n(Max: " currentcontracts ")", , 200, 180, , , , , %currentcontracts%
	if ErrorLevel
		return
	if (count > currentcontracts) {
		MsgBox, 4, , Insufficient blacksmith contracts detected for use.`nContinue anyway?
		IfMsgBox No
			return
	}
	heroid := "error"
	InputBox, heroid, Blacksmithing, % "Use contracts on which Champ? (Enter ID)", , 200, 180, , , , , %LastBSChamp%
	if ErrorLevel
		return
	while !(heroid is number) {
		InputBox, heroid, Blacksmithing, % "Please enter a valid Champ ID number.", , 200, 180, , , , , %LastBSChamp%
		if ErrorLevel
			return
	}
	while !((heroid > 0) && (heroid < 100)) {
		InputBox, heroid, Blacksmithing, % "Please enter a valid Champ ID number.", , 200, 180, , , , , %LastBSChamp%
		if ErrorLevel
			return
	}
	MsgBox, 4, , % "Use " count " contracts on " ChampFromID(heroid) "?"
	IfMsgBox No
		return
	LastBSChamp := heroid
	bscontractparams := "&user_id=" UserID "&hash=" UserHash "&instance_id=" InstanceID "&buff_id=" buffid "&hero_id=" heroid "&num_uses="
	tempsavesetting := 0
	tempnosavesetting := 0
	while (count > 0) {
		SB_SetText("Contracts remaining to use: " count)
		if (count < 100) {
			rawresults := ServerCall("useserverbuff", bscontractparams count)
			count -= count
		}
		else {
			rawresults := ServerCall("useserverbuff", bscontractparams "99")
			count -= 99
		}
		if (CurrentSettings.alwayssavecontracts || tempsavesetting) {
			FileAppend, %rawresults%`n, %BlacksmithLogFile%
		}
		else {
			if !tempnosavesetting {
				InputBox, dummyvar, Contracts Results, Save to File?, , 250, 150, , , , , % rawresults
				dummyvar := ""
				if !ErrorLevel {
					FileAppend, %rawresults%`n, %ContractLogFile%
					tempsavesetting := 1
				}
				if ErrorLevel {
					tempnosavesetting := 1
				}
			}
		}
		blacksmithresults := JSON.parse(rawresults)
		if ((blacksmithresults.success == "0") || (blacksmithresults.okay == "0")) {
			MsgBox % ChampFromID(heroid) " levels gained:`nSlot 1: " slot1lvs "`nSlot 2: " slot2lvs "`nSlot 3: " slot3lvs "`nSlot 4: " slot4lvs "`nSlot 5: " slot5lvs "`nSlot 6: " slot6lvs
			MsgBox % "Error: " rawresults
			switch buffid
		{
			case 31: contractsused := (CurrentTinyBS - blacksmithresults.buffs_remaining)
			case 32: contractsused := (CurrentSmBS - blacksmithresults.buffs_remaining)
			case 33: contractsused := (CurrentMdBS - blacksmithresults.buffs_remaining)
			case 34: contractsused := (CurrentLgBS - blacksmithresults.buffs_remaining)
		}
			UpdateLogTime()
			FileAppend, % "(" CurrentTime ") Contracts Used: " Floor(contractsused) "`n", %OutputLogFile%
			FileRead, OutputText, %OutputLogFile%
			oMyGUI.Update()
			GetUserDetails()
			SB_SetText("Contracts remaining: " count " (Error)")
			return
		}
		rawactions := JSON.stringify(blacksmithresults.actions)
		blacksmithactions := JSON.parse(rawactions)
		slot1lvs := 0
		slot2lvs := 0
		slot3lvs := 0
		slot4lvs := 0
		slot5lvs := 0
		slot6lvs := 0
		for k, v in blacksmithactions
		{
			switch v.slot_id
		{
			case 1: slot1lvs += v.amount
			case 2: slot2lvs += v.amount
			case 3: slot3lvs += v.amount
			case 4: slot4lvs += v.amount
			case 5: slot5lvs += v.amount
			case 6: slot6lvs += v.amount
		}
		}
	}
	MsgBox % ChampFromID(heroid) " levels gained:`nSlot 1: " slot1lvs "`nSlot 2: " slot2lvs "`nSlot 3: " slot3lvs "`nSlot 4: " slot4lvs "`nSlot 5: " slot5lvs "`nSlot 6: " slot6lvs
	tempsavesetting := 0
	tempnosavesetting := 0
	switch buffid {
		case 31: contractsused := (CurrentTinyBS - blacksmithresults.buffs_remaining)
		case 32: contractsused := (CurrentSmBS - blacksmithresults.buffs_remaining)
		case 33: contractsused := (CurrentMdBS - blacksmithresults.buffs_remaining)
		case 34: contractsused := (CurrentLgBS - blacksmithresults.buffs_remaining)
	}
	UpdateLogTime()
	FileAppend, % "(" CurrentTime ") Contracts used on " ChampFromID(heroid) ": " Floor(contractsused) "`n", %OutputLogFile%
	FileRead, OutputText, %OutputLogFile%
	oMyGUI.Update()
	GetUserDetails()
	SB_SetText("Blacksmith use completed.")
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

LoadBGAdventure() {
	if (ActiveInstance == "2") {
		bginstance := 1
	}
	else {
		bginstance := 2
	}
	while !(BackgroundAdventure == "-1") {
		MsgBox, 5, , Please end your background adventure first.
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
	advparams := DummyData "&patron_tier=0&user_id=" UserID "&hash=" UserHash "&instance_id=" InstanceID "&game_instance_id=" bginstance "&adventure_id=" advtoload "&patron_id=" patrontoload
	sResult := ServerCall("setcurrentobjective", advparams)
	GetUserDetails()
	SB_SetText("Selected background adventure has been loaded.")
	return
}

EndAdventure() {
	while (CurrentAdventure == "-1") {
		MsgBox, No current adventure active.
		return
	}
	MsgBox, 4, , % "Are you sure you want to end your current adventure?`nParty: " ActiveInstance " AdvID: " CurrentAdventure " Patron: " CurrentPatron
	IfMsgBox, No
	{
		return
	}
	advparams := DummyData "&user_id=" UserID "&hash=" UserHash "&instance_id=" InstanceID "&game_instance_id=" ActiveInstance
	sResult := ServerCall("softreset", advparams)
	GetUserDetails()
	SB_SetText("Current adventure has been ended.")
	return
}

EndBGAdventure() {
	if (ActiveInstance == "2") {
		bginstance := 1
	}
	else {
		bginstance := 2
	}
	while (BackgroundAdventure == "-1") {
		MsgBox, No background adventure active.
		return
	}
	MsgBox, 4, , % "Are you sure you want to end your background adventure?`nParty: " bginstance " AdvID: " BackgroundAdventure " Patron: " BackgroundPatron
	IfMsgBox, No
	{
		return
	}
	advparams := DummyData "&user_id=" UserID "&hash=" UserHash "&instance_id=" InstanceID "&game_instance_id=" bginstance
	sResult := ServerCall("softreset", advparams)
	GetUserDetails()
	SB_SetText("Background adventure has been ended.")
	return
}

FirstRun() {
	MsgBox, 4, , Get User ID and Hash from webrequestlog.txt?
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
	Gui, MyWindow:Default
	SB_SetText("Please wait a moment...")
	getuserparams := "&instance_key=1&user_id=" UserID "&hash=" UserHash
	rawdetails := ServerCall("getuserdetails", getuserparams)
	FileDelete, %UserDetailsFile%
	FileAppend, %rawdetails%, %UserDetailsFile%
	UserDetails := JSON.parse(rawdetails)
	InstanceID := UserDetails.details.instance_id
	CurrentSettings.instance_id := InstanceID
	ActiveInstance := UserDetails.details.active_game_instance_id
	newsettings := JSON.stringify(CurrentSettings)
	FileDelete, %SettingsFile%
	FileAppend, %newsettings%, %SettingsFile%
	ParseChampData()
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
			CurrentArea := v.current_area
			CurrentPatron := PatronFromID(v.current_patron_id)
		}
		else {
			BackgroundAdventure := v.current_adventure_id
			BackgroundArea := v.current_area
			BackgroundPatron := PatronFromID(v.current_patron_id)
		}
	;
	FGCore := "`n"
	BGCore := "`n"
	for k, v in UserDetails.details.modron_saves
		if (v.instance_id == ActiveInstance) {
			if (v.core_id == 1) {
				FGCore := "Core: Modest"
			}
			else if (v.core_id == 2) {
				FGCore := "Core: Strong"
			}
			if (v.properties.toggle_preferences.reset == true) {
				FGCore := FGCore " (Reset at " v.area_goal ")"
			}
			FGCore := FGCore "`nXP: " v.exp_total
		}
		else if !(v.instance_id == ActiveInstance) {
			if (v.core_id == 1) {
				BGCore := "Core: Modest"
			}
			else if (v.core_id == 2) {
				BGCore := "Core: Strong"
			}
			if (v.properties.toggle_preferences.reset == true) {
				BGCore := BGCore " (Reset at " v.area_goal ")"
			}
			BGCore := BGCore "`nXP: " v.exp_total
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
	AvailableChests := "= " Floor(CurrentGems/50) " Silver Chests"
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
			if v.unlocked == False {
				MirtVariants := "Locked"
				MirtFPCurrency := "Requires:"
				MirtChallenges := "Costs:"
				MirtRequires := UserDetails.details.stats.total_hero_levels "/2000 Item Levels && " TotalChamps "/20 Champs"
				if ((UserDetails.details.stats.total_hero_levels > 1999) && (TotalChamps > 19)) {
					Gui, Font, cGreen
					GuiControl, Font, MirtFPCurrency
				}
				MirtCosts := CurrentTGPs "/3 TGPs && " CurrentSilvers "/10 Silver Chests"
				if ((CurrentTGPs > 2) && (CurrentSilvers > 9)) {
					Gui, Font, cGreen
					GuiControl, Font, MirtChallenges
				}
			}
			else for kk, vv in v.progress_bars
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
			if v.unlocked == False {
				VajraVariants := "Locked"
				VajraFPCurrency := "Requires:"
				VajraChallenges := "Costs:"
				VajraRequires := UserDetails.details.stats.completed_adventures_variants_and_patron_variants_c15 "/15 WD:DH Advs && " TotalChamps "/30 Champs"
				if ((UserDetails.details.stats.completed_adventures_variants_and_patron_variants_c15 > 14) && (TotalChamps > 29)) {
					Gui, Font, cGreen
					GuiControl, Font, VajraFPCurrency
				}
				VajraCosts := CurrentGems "/2500 Gems && " CurrentSilvers "/15 Silver Chests"
				if ((CurrentGems > 2499) && (CurrentSilvers > 14)) {
					Gui, Font, cGreen
					GuiControl, Font, VajraChallenges
				}
			}
			else for kk, vv in v.progress_bars
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
			if v.unlocked == False {
				StrahdVariants := "Locked"
				StrahdFPCurrency := "Requires:"
				StrahdChallenges := "Costs:"
				StrahdRequires := UserDetails.details.stats.highest_area_completed_ever_c413 "/250 in Adventure 413 && " TotalChamps "/40 Champs"
				if ((UserDetails.details.stats.highest_area_completed_ever_c413 > 249) && (TotalChamps > 39)) {
					Gui, Font, cGreen
					GuiControl, Font, StrahdFPCurrency
				}
				StrahdCosts := CurrentLgBounties "/10 Lg Bounties && " CurrentSilvers "/20 Silver Chests"
				if ((CurrentLgBounties > 9) && (CurrentSilvers > 19)) {
					Gui, Font, cGreen
					GuiControl, Font, StrahdChallenges
				}
			}
			else for kk, vv in v.progress_bars
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
	todogear := "`nHighest Gear Level:" UserDetails.details.stats.highest_level_gear
	for k, v in UserDetails.details.loot {
		if (v.rarity == "4") {
			EpicGearCount += 1
		}
		if ((v.hero_id == "58") && (v.slot_id == "4")) {
			brivrarity := v.rarity
			brivgild := v.gild
			brivenchant := v.enchant
		}
		if ((v.enchant + 1) = UserDetails.details.stats.highest_level_gear) {
			todogear := todogear "`n(" ChampFromID(v.hero_id) " Slot " v.slot_id ")"
		}
	}
	AchievementInfo := "Achievement Details`n" todogear
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

ParseChampData() {
	TotalChamps := 0
	for k, v in UserDetails.details.heroes
		if (v.owned == 1) {
			TotalChamps += 1
		}
	;
	ChampDetails := ""
	if (UserDetails.details.stats.black_viper_total_gems) {
		ChampDetails := ChampDetails "Black Viper Red Gems: " UserDetails.details.stats.black_viper_total_gems "`n`n"
	}
	if (UserDetails.details.stats.total_paid_up_front_gold) {
		morgaengold := SubStr(UserDetails.details.stats.total_paid_up_front_gold, 1, 4)
		epos := InStr(UserDetails.details.stats.total_paid_up_front_gold, "E")
		morgaengold := morgaengold SubStr(UserDetails.details.stats.total_paid_up_front_gold, epos)
		ChampDetails := ChampDetails "Môrgæn Gold Collected: " morgaengold "`n`n"
	}
	if (UserDetails.details.stats.zorbu_lifelong_hits_beast || UserDetails.details.stats.zorbu_lifelong_hits_undead || UserDetails.details.stats.zorbu_lifelong_hits_drow) {
		ChampDetails := ChampDetails "Zorbu Kills:`n(Humanoid)`t" UserDetails.details.stats.zorbu_lifelong_hits_humanoid "`n(Beast)`t`t" UserDetails.details.stats.zorbu_lifelong_hits_beast "`n(Undead)`t" UserDetails.details.stats.zorbu_lifelong_hits_undead "`n(Drow)`t`t" UserDetails.details.stats.zorbu_lifelong_hits_drow
	}
}

CheckPatronProgress() {
	if !(MirtVariants == "Locked") {
		if (MirtFPCurrency = "5000") {
			Gui, Font, cGreen
			GuiControl, Font, MirtFPCurrency
		}
		else {
			Gui, Font, cRed
			GuiControl, Font, MirtFPCurrency
		}
		if (MirtChallenges = "10") {
			Gui, Font, cGreen
			GuiControl, Font, MirtChallenges
		}
		else {
			Gui, Font, cRed
			GuiControl, Font, MirtChallenges
		}
		if (MirtCompleted = MirtVariantTotal) {
			Gui, Font, cGreen
			GuiControl, Font, MirtVariants
		}
		else {
			Gui, Font, cRed
			GuiControl, Font, MirtVariants
		}
	}
	if !(VajraVariants == "Locked") {
		if (VajraFPCurrency = "5000") {
			Gui, Font, cGreen
			GuiControl, Font, VajraFPCurrency
		}
		else {
			Gui, Font, cRed
			GuiControl, Font, VajraFPCurrency
		}
		if (VajraChallenges = "10") {
			Gui, Font, cGreen
			GuiControl, Font, VajraChallenges
		}
		else {
			Gui, Font, cRed
			GuiControl, Font, VajraChallenges
		}
		if (VajraCompleted = VajraVariantTotal) {
			Gui, Font, cGreen
			GuiControl, Font, VajraVariants
		}
		else {
			Gui, Font, cRed
			GuiControl, Font, VajraVariants
		}
	}
	if !(StrahdVariants == "Locked") {
		if (StrahdChallenges = "10") {
			Gui, Font, cGreen
			GuiControl, Font, StrahdChallenges
		}
		else {
			Gui, Font, cRed
			GuiControl, Font, StrahdChallenges
		}
		if (StrahdFPCurrency = "5000") {
			Gui, Font, cGreen
			GuiControl, Font, StrahdFPCurrency
		}
		else {
			Gui, Font, cRed
			GuiControl, Font, StrahdFPCurrency
		}
		if (StrahdCompleted = StrahdVariantTotal) {
			Gui, Font, cGreen
			GuiControl, Font, StrahdVariants
		}
		else {
			Gui, Font, cRed
			GuiControl, Font, StrahdVariants
		}
	}
}

CheckAchievements() {
	if (UserDetails.details.stats.asharra_bonds < 3) {
		if !(UserDetails.details.stats.asharra_bond_human)
			ashexotic := " human"
		if !(UserDetails.details.stats.asharra_bond_elf)
			ashelf := " elf"
		if !(UserDetails.details.stats.asharra_bond_exotic)
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
	AchievementInfo := AchievementInfo todoasharra todogromma todokrond todoregis
}

CheckBlessings() {
	epiccount := ""
	epicvalue := Round((1.02 ** EpicGearCount), 2)
	if (UserDetails.details.reset_upgrade_levels.44) { ;Helm-Slow and Steady (X Epics)
		epiccount := "Slow and Steady:`nx" epicvalue " damage (" EpicGearCount " epics)`n`n"
	}
	veterancount := ""
	veteranvalue := Round(1 + (0.1 * UserDetails.details.stats.completed_adventures_variants_and_patron_variants_c22), 2)
	if (UserDetails.details.reset_upgrade_levels.56) { ;Tiamat-Veterans of Avernus (X Adventures)
		veterancount := "Veterans of Avernus:`nx" veteranvalue " damage (" UserDetails.details.stats.completed_adventures_variants_and_patron_variants_c22 " adventures)`n`n"
	}
	BlessingInfo := "Blessing Details`n`n" epiccount veterancount
	if (BlessingInfo == "Blessing Details`n`n") {
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

Get_Journal:
{
	if !UserID {
		MsgBox % "Need User ID & Hash."
		FirstRun()
	}
	if (InstanceID = 0) {
		MsgBox, 4, , No Instance ID detected.  Check server for user details?
		IfMsgBox, Yes
		{
			GetUserDetails()
		}
		else
			return
	}
	journalparams := "&user_id=" UserID "&hash=" UserHash "&instance_id=" InstanceID "&page="
	InputBox, pagecount, Journal, % "How many pages of Journal to retreive?`n`n(This will overwrite any previous download.)", , 350, 180
	if ErrorLevel
		return
	pagenum := 1
	FileDelete, %JournalFile%
	while !(pagenum > pagecount) {
		SB_SetText("Journal pages remaining to download: " ((pagecount - pagenum) + 1))
		rawresults := ServerCall("getPlayHistory", journalparams pagenum)
		FileAppend, %rawresults%`n, %JournalFile%
		pagenum += 1
		sleep 1000
	}
	UpdateLogTime()
	FileAppend, % "(" CurrentTime ") Journal pages downloaded: " (pagenum - 1) "`n", %OutputLogFile%
	FileRead, OutputText, %OutputLogFile%
	oMyGUI.Update()
	SB_SetText("Journal download completed.")
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

PatronFromID(patronid) {
	switch patronid {
		case "0": namefromid := "None"
		case "1": namefromid := "Mirt"
		case "2": namefromid := "Vajra"
		case "3": namefromid := "Strahd"
		case "4": namefromid := "Zariel"
	}
	return namefromid
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
			case "64": namefromid := "B & G"
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

List_ChampIDs:
{
	id := 1
	champidlist := ""
	while (id < 69) {
		champidlist := champidlist id ": " ChampFromID(id) " `t"
		if ((id = 9) or (id = 13) or (id = 37) or (id = 41) or (id = 45) or (id = 49) or (id = 53) or (id = 65)) {
			champidlist := champidlist "`t"
		}
		id += 1
		champidlist := champidlist id ": " ChampFromID(id) " `t"
		if ((id = 2) or (id = 10) or (id = 14) or (id = 18) or (id = 30) or (id = 42) or (id = 58) or (id = 62)) {
			champidlist := champidlist "`t"
		}
		id += 1
		champidlist := champidlist id ": " ChampFromID(id) " `t"
		if ((id = 3) or (id = 7) or (id = 23) or (id = 31) or (id = 30) or (id = 43) or (id = 51) or (id = 59) or (id = 63)) {
			champidlist := champidlist "`t"
		}
		id += 1
		champidlist := champidlist id ": " ChampFromID(id) "`n"
		id += 1
	}
	MsgBox, , Champ ID List, % champidlist
	return	
}