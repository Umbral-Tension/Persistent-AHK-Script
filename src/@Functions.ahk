{ ;SCRIPT BEHAVIOR
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode 2
detectHiddenWindows off
StringCaseSense off 
SetKeyDelay 10 ; Default is 10
}


	setupFunctions(loc, brow, upath){
		global location := loc  
		global browser := brow   
		global userPath := upath
		global paths := buildPaths(userPath) 
		global commandList := guiBuildList()
		guiBuild(commandList)
	}



{ ; PATHS
	buildPaths(uPath){
		programPaths :={} ;NOTE: THIS FUNCTION IS INCREDIBLY, YET INTENTIONALLY, UNREADABLE. REALLY WANTED TO REDUCE THE NUMBER OF LINES AS MUCH AS POSSIBLE
		Loop, Read, resources\paths.txt
		{
			qs := [InStr(trim(SubStr(A_LoopReadLine, instr(A_LoopReadLine,":")+1)), """", , ,1), InStr(trim(SubStr(A_LoopReadLine, instr(A_LoopReadLine,":")+1)), """", , ,2), InStr(trim(SubStr(A_LoopReadLine, instr(A_LoopReadLine,":")+1)), """", , ,3), InStr(trim(SubStr(A_LoopReadLine, instr(A_LoopReadLine,":")+1)), """", , ,4)]
			codes := {p32:"C:\Program Files (x86)\",		p64:"C:\Program Files\",		uPath:uPath, "":""}
			programPaths[StrReplace(A_LoopReadLine, ":" . SubStr(A_LoopReadLine, instr(A_LoopReadLine,":")+1), "")] := [codes[trim(strReplace(SubStr(trim(SubStr(A_LoopReadLine, instr(A_LoopReadLine,":")+1)), 2, qs[1]-2), ".", ""))] . SubStr(trim(SubStr(A_LoopReadLine, instr(A_LoopReadLine,":")+1)), qs[1] + 1, qs[2] - qs[1] - 1),SubStr(trim(SubStr(A_LoopReadLine, instr(A_LoopReadLine,":")+1)), qs[3]+1, qs[4]-qs[3]-1)]	
		}
		return programPaths
	}
}


open(program, args:=""){
	global paths
	global browser 
	args:= " " . args
	thePath := paths[program].1
	theTitle := paths[program].2
	theBrowser := paths[browser].1
	;WEBSITE OPENING
	if(instr(thePath, "http")){
		str := q(theBrowser) .  " " . q(thePath) 	
		run % str 	;note that this relies on the system's default browser setting to decide what program the site is opened in.
		return
	}
	
	if(!winExist(theTitle)){ 
		try{
			run % thePath . args
			winWait % theTitle, ,4
		}
		catch{
			msgbox % "Run command failed :( `n`nMake Sure path is correct.`npath:  " .  thePath
		}
	}
	winActivate % theTitle 
	winWaitActive, , ,2
}


saveReload(){
	winActivate Visual Studio Code   
	winWaitActive Visual Studio Code, ,1
	if winActive("Visual Studio Code") {
		 send ^ks
	}
	sleep 150
	reload
}


;DEBUGGING PRINT STATEMENT
test(v*){ 
	
	output=
	loop % v.maxIndex()
		output .= "Var" . A_index . "----" . v[A_index] . "`n`n"
	if output = 
		output = "here"
	msgbox %output%
}

slowProgression(delay, index:= "xx", arg:="here"){
	CoordMode tooltip, screen
	toolTip, %index%:: %arg%,100,100
	sleep %delay%
	CoordMode tooltip, screen
}

logError(filePath := "my AHK error log file.txt", errorMessage := "generic error"){
	formatTime, dateStamp, , MMM d,yyyy - h:mmt
	eFile := fileOpen(filePath ,"a`n")
	efile.writeLine(dateStamp)
	eFile.writeLine("    " . errorMessage)
	eFile.close()
}


q(str){ 
	return """" . str . """ "      
}

ifDoubleClick(exec:="none", arg*){
	if (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 300){
		%exec%()
		return 1
	}
	else{
		sendInput {%A_ThisHotkey%}
		return 0
	} 
}

; DOES NOT WORK FOR COMPOUND KEYS LIKE !SPACE
ifLongPress(exec:="none", timeout:=1){
 	keyWait, %A_ThisHotkey%, T%timeout%
	if ErrorLevel{
		%exec%()
		return 1
	}
	else{
		sendInput {%A_ThisHotkey%}
		return 0
	}	 
}


{ ;GUI RELATED FUNCTIONS
	guiShow(){
		blockinput on
		Gui, Show, center, Get Command 
		blockinput off
	}

	guiBuild(cdList){
		global commandSelection 
		global listCount 
		strReplace(cdList,"|","|",listCount)
		;listCount+=1 ;OFF BY ONE ERROR CORRECTION 
		itemHeight := A_screenHeight / 60
		Gui, +AlwaysOnTop  toolwindow -caption 
		Gui, Font,  q5 s%itemHeight%  
		Gui, Margin, 0,0
		Gui, Add, listbox,  r%listCount% w200  hwndmyList cBlack backgroundtrans gguiRespond  vcommandSelection, %cdList%
		winSet, transparent, 110, ahk_id %myList%
	}

	guiRespond(CtrlHwnd, GuiEvent, EventInfo, ErrLevel:=""){
		global commandSelection
		if (GuiEvent = "DoubleClick")
		{
			gui Submit
			if(subStr(commandSelection, 1) != "Exit"){ 
				open(subStr(commandSelection, 1))
			}
		}
	}

	guiBuildList(){
		;SPACER
		spacer = ⧟⧟⧟⧟⧟⧟⧟⧟⧟⧟⧟⧟⧟⧟⧟⧟⧟⧟⧟⧟⧟⧟⧟⧟⧟|
		;WEBSITES
		websites = Amazon|Artstation|Github|Gmail|Lichess|Reddit|Youtube|
		;PROGRAMS
		programs = Firefox|Controlpanel|Dopamine|Intellij|Visual Studio|Spotify|
		cdList := websites . spacer . programs . spacer . "Exit|"
		return cdList
	}
}