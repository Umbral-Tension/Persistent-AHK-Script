 
{ ;SCRIPT BEHAVIOR
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
CoordMode mouse, window
SetTitleMatchMode 2
detectHiddenWindows off
StringCaseSense off 
SetKeyDelay 10 ; Default is 10
#SingleInstance force
}

{ ;INITIALIZATION CODE
	#include %A_ScriptDir%\@Functions.ahk
	SetNumLockState AlwaysOn
	setCapslockState AlwaysOff
	
	q = "           ;" <- Need this dumbass quote to trick the syntax highlighter. This q variable is for appending a literal quote to a string.  
	location = home
	browser = firefox
	EnvGet, uPath, USERPROFILE
	uPath .= "\"
	setupFunctions(location, browser, uPath)
	setTimer Quarter_Hourly, 900000 
	setTimer Daily,  86400000
} 

;TESTING HOTKEY
	capslock & g:: 
	PgUp:: 
		winActivate Notepad
		mywinWait("Notepad", 2)
		send {home 2}
		send +{end}
		send ^c
		send {right} --{down}
		winActivate Deezloader 
		myWinWait("Deezloader", 2)
		click 250, 316
		sleep 50
		send ^a
		sleep 50
		send ^v
		sleep 50
		send {enter}
	return 

myWinWait(windowTitle, waitLength, notify:=1){
	WinWait, %windowTitle%, ,%waitLength%
	WinWaitActive, %windowTitle%, ,%waitLength%
	if (winExist(windowTitle) and WinActive(windowTitle))
		return 1
	else 
		if (notify)
			msgbox "Window inactive or non-existant"
		closeAud()
		return 0
}

closeAud(){
	Loop, 5
		{
			winclose ahk_exe audacity.exe
			sleep 500
		}
}

;specific to mom's computer 
#if location = "mom" 
	mbutton::			ifLongPress("guiShow")
#if


;OPENERS/CLOSERS
	    
	XButton2::		
	capslock & m:: 		guiShow()
	^numpadsub:: 		veraClose() 
	PgDn::				open("calculator")
	!x::				send {f6}
	;!numpadadd:: 		RESERVED FOR EVERYTHING, BUT THE ACTUAL HOTKEY IS HANDLED BY THE PROGRAM ITSELF.
	!backspace::		send !{f4}
	!enter:: 			
	!numpadenter::		open(browser)
	!numpad0::
	!1::
	!numpad1:: 			open("dopamine")
	
	!2::
	!numpad2:: 			open("explorer","shell:AppsFolder\Microsoft.Office.OneNote_8wekyb3d8bbwe!microsoft.onenoteim")
	
	!3::
	!numpad3:: 			open("powershell", "-noexit -command cd C:\users\jeremy\desktop")
	^!3::				
	^!numpad3::			open("powershell", "-noexit -command python")
	
	!4::
	!numpad4::			open("taskmanager")
	
	!5::
	!numpad5::			open("vscode")
	^!5::
	^!numpad5::			open("vscode",q(A_ScriptFullPath) . q(A_scriptdir . "\Resources\paths.txt") . q(A_ScriptDir . "\@Functions.ahk") )
	
	!7::
	!numpad7::			open("alarm")
	
	!8::
	!numpad8::			open("help")
	^!8::				
	^!numpad8::			open("windowspy")

	^!numpad9::			

	


;REMAPS

	#w::#e
	insert::home 
	F1::F2
	;MEDIA Keys
		f10::Media_Play_Pause
		f11::Media_Prev  
		f12::Media_Next
	;ARROW Keys
		capslock & k::down
		capslock & I::up
		capslock & j::left
		capslock & l::right
	capslock & e::esc
	capslock & space::AppsKey
	capslock & backspace::delete
	capslock & n::end
	capslock & h::home
	
;TEXT EDITTING
	^+home::
	^+insert::
		send {home 2}
		send +{end} 
	return
	^+backspace:: send ^+{left}{delete}

;OTHER
	!p:: suspend
	capslock & r:: saveReload()

	



; SET VOLUME
	^numpad0:: soundset, 0
	^numpad1:: soundset, 10
	^numpad2:: soundset, 20
	^numpad3:: soundset, 30
	^numpad4:: soundset, 40
	^numpad5:: soundset, 50
	^numpad6:: soundset, 60
	^numpad7:: soundset, 70
	^numpad8:: soundset, 80
	^numpad9:: soundset, 90
	

;CONTEXTUAL HOTKEYS
	#IfWinActive OneNote
	^l:: send ^e

	#IfWinActive, Get Command ahk_exe AutoHotkey.exe 
	Esc:: Gui, destroy
	numpadEnter::
	Enter:: 
		gui submit	
		open(subStr(commandSelection, 1))
	return
	#IfWinActive ahk_exe idea64.exe
		!r:: send +{f10}
		^n:: send ^!+n
		^+r:: send +{f6}
		!y:: send !{enter}
	#IfWinActive,  - Visual Studio Code
		capslock & t:: send ^``

	#IfWinActive, Eclipse IDE
		!r:: send ^{f11}
		^g:: send {f3}
		^+r:: send !+r
	#IfWinActive	;Calling this without parameters cancels contextualization

	

;SubRoutines
	Quarter_Hourly:
		try ;NECESSARY BECAUSE 'CLIPBOARD=' THROWS EXCEPTION WHEN THE COMPUTER IS LOCKED
			clipboard = 
	 	fileRemoveDir %uPath%\Documents\Custom Office Templates\ 1
		fileRemoveDir %uPath%\Documents\Unified Remote\, 1
		FileRemoveDir %uPath%Google Drive\Pics\Saved Pictures\, 1
		FileRemoveDir %uPath%Google Drive\Pics\Camera Roll\, 1
	return

	Daily:
		formatTime t, ,ddd
		if( t = "mon"){
			msgbox, media census disabled while the new computer storage situation is being figured out. 
			;run %uPath%\Google Drive\Coding\AHK\Media Census.ahk
			;msgbox Media Census Executed
		}
	return



