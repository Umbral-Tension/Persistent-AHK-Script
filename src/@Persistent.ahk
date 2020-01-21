 
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
		open("random") ;cmd := "FormatFactory -> MP3 VBR High quality Source_File_Name [Dest_Folder_or_File_Name] [/hide]"
	return 

jWinActivate(windowTitle, waitLength, notify:=1){
	WinWait, %windowTitle%, ,%waitLength%
	WinActivate, %windowTitle%
	WinWaitActive, %windowTitle%, ,%waitLength%
	if (winExist(windowTitle) and WinActive(windowTitle))
		return 1
	else 
		if (notify)
			msgbox "Window inactive or non-existant"
		return 0
}

;OPENERS/CLOSERS
	    
	XButton2::			
	capslock & m:: 		guiShow()
	PgDn::				open("calculator")

	;!numpadadd:: 		reserved for everything search, but the actual hotkey is handled by the program itself.
	!backspace::		send !{f4} 
	!enter:: 			
	!numpadenter::		open(browser)
	
	!1::
	!numpad1:: 			open("musicbee")
	
	!2::
	!numpad2:: 			open("onenote")
	
	!3::
	!numpad3:: 			open("powershell", "-noexit -command cd C:\users\jeremy\desktop")
	^!numpad3::			open("powershell", "-noexit -command python")
	
	!4::
	!numpad4::			open("taskmanager")
	
	!5::
	!numpad5::			open("vscode")
	^!numpad5::			open("vscode",q(A_ScriptFullPath) . q(A_scriptdir . "\Resources\paths.txt") . q(A_ScriptDir . "\@Functions.ahk") )
	
	!8::
	!numpad8::			open("help")
	^!numpad8::			open("windowspy")
	

;REMAPS

	#w::#e	;open explorer
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
	capslock & space::AppsKey
	capslock & backspace::delete
	capslock & n::end
	capslock & h::home
	capslock & e::esc
	
;TEXT EDITTING
	; Some text fields interpret ctrl+backspace as some kind of special character, rather than as a 'whole-word-deltion'.
	; this sends keystrokes to do a manual version of that.
	^+backspace:: send ^+{left}{delete}

;OTHER
	!p:: suspend
	capslock & r:: saveReload()
	capslock & c:: csharpSearch()
	



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
	

	guiReload(){
		GUI, Destroy
		saveReload()
	}
;CONTEXTUAL HOTKEYS
	#IfWinActive OneNote
	^l:: send ^e	;search

	;allow keyboard to manipulate the AHK GUI
	#IfWinActive, Get Command ahk_exe AutoHotkey.exe 
	Esc:: guiReload()
	capslock & e:: guiReload()
	numpadEnter::
	Enter:: 
		gui submit	
		open(subStr(commandSelection, 1))
	return

	#IfWinActive, PyCharm
		!r:: send +{f10} 	;run last configuration
		^+r:: send +{f6} 	;Refactor->Rename
		^n:: send ^{f12}	;navigate
		capslock & t:: send !{f12}	;toggle terminal
		
	#IfWinActive,  - Visual Studio Code
		capslock & tv:: send ^`` ;toggles terminal 

/*	currently unused	
	#IfWinActive, ahk_exe Evernote.exe
		^r:: send ^h
		^l:: send ^q

	#IfWinActive, Microsoft Visual Studio
		!r:: send {f5}
		^+r:: send {f2}
	#IfWinActive	;Calling this without parameters cancels contextualization
*/
	

;SubRoutines
	Quarter_Hourly:
		try ; The try block is necessary because 'clipboard=' throws an exception when the computer is locked
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



