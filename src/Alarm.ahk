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
#SingleInstance
}

wakeHour = 0
wakeMinute = 0
ampmSelection = AM
minLeadingZero =
SetTimer, update, 28000

InputBox, wakeHour , , Enter wakeup hour:
InputBox, ampm, ,AM = 0`nPM = 1:
InputBox, wakeMinute, ,Enter wakeup minute (no leading zero):
if (ampm != 0){
	ampmSelection = PM
	if(wakeHour != 12)
		wakeHour += 12
}
if (wakeMinute < 10)
	minLeadingZero = 0
msgbox Alarm set for %wakeHour%:%minLeadingZero%%wakeMinute% %ampmSelection%





rand(min, max){
Random, out, %min%, %max%
return out
}


ringAlarm(){
	vol = 10
	formatTime, tOld, , m
	dur = 0
	while(dur < 30){
		SoundSet %vol%
		loop 6{
			soundBeep, 1500,300
		}
		loop 10{
			soundBeep,rand(800,2500),rand(100,1100)
			sleep 50
		}
		formatTime, tNew, , m
		if (tOld != tNew){
			dur += 1
			tOld := tNew
		}
		vol += 5
	}
	soundSet, 100
	exitApp
}


^+t::ringAlarm()
^+k::exitApp
^r::
	winMenuSelectItem, Notepad++,,File,Save
	reload
return


update:
	FormatTime,hour, ,H
	FormatTime,minute, ,m
	if(hour = wakeHour AND minute = wakeMinute){
		ringAlarm()
		setTimer, update, delete
	}
return
