#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


;This script makes a list of all music and stand up audio so that I can remember what I had
;in the event that I lose it and have to try to get it all back. :I 

EnvGet, userpath, USERPROFILE
FileDelete, %userpath%\Google Drive\Documents\Media Census\Music.txt
FileDelete, %userpath%\Google Drive\Documents\Media Census\Stand-Up Audio.txt
FileDelete, %userpath%\Google Drive\Documents\Media Census\Audiobooks.txt
FileDelete, %userpath%\Google Drive\Documents\Media Census\Videos.txt

Loop, %userpath%\Music\*.*, 2, 1
{
	FileAppend %A_LoopFileLongPath%`n, %userpath%\Google Drive\Documents\Media Census\Music.txt
}

Loop, %userpath%\Documents\Comedy\*.*, 2, 1
{
	FileAppend %A_LoopFileLongPath%`n, %userpath%\Google Drive\Documents\Media Census\Stand-Up Audio.txt
}

Loop, D:\Audio Books\*.*, 2, 1
{
	FileAppend %A_LoopFileLongPath%`n, %userpath%\Google Drive\Documents\Media Census\Audiobooks.txt
}

Loop, D:\Videos\*.*, 0, 1
{
	FileAppend %A_LoopFileLongPath%`n, %userpath%\Google Drive\Documents\Media Census\Videos.txt
}





