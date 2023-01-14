#NoEnv
#SingleInstance Force

instance = 3
totalNumber = 300

TempDir := A_Temp . "\_temp\"
if !FileExist(TempDir)
    FileCreateDir, % TempDir
	
if !instr(A_ScriptFullPath, TempDir) {
	if countThread(TempDir) < instance {
		loop %instance% {
			if !FileExist(TempDir . A_Index . A_ScriptName) {
				FileCopy, %A_ScriptFullPath%, % TempDir A_Index A_ScriptName
				pos := round(totalNumber/instance)
				ininfo := "[email]`npos=" pos*A_Index "`n" "limit=" pos
				FileAppend, % ininfo, % TempDir A_Index A_ScriptName ".ini"
			}
		}
	}
	if countThread(TempDir) = instance {
		threads := []
		loop %instance% {
			Run % TempDir A_Index A_ScriptName,,, pid
			threads[A_Index] := pid
			Sleep 1000
		}
	}
}else{
	inifile := A_ScriptDir "\" A_ScriptName ".ini"
	Loop 100 {
		IniRead, pos, % inifile, email, pos
		IniRead, limit, % inifile, email, limit
		MsgBox,, % pos , % limit, 5
		IniWrite, % pos+1, % inifile, email, pos
		IniWrite, % limit-1, % inifile, email, limit
		Sleep 500
	}
}

Esc::ExitApp
Return

ExitThreads(threads){
	loop threads.Length() {
		Process, Close, % threads[A_Index]
		Sleep 500
	}
}
countThread(TempDir){
	count = 0
	Loop % TempDir "*" A_ScriptName {
		if instr(A_LoopFileName, A_ScriptName)
		count := A_Index
	}
	return count
}
