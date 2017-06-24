; _FiletypeAssociation('.test', 'test', 'notepad "%1"', 'test description')

Func _FiletypeAssociation($extension, $type, $program, $description = '')
    ; e.g. _FiletypeAssociation('.pdf', 'FoxitReader.Document', '"%ProgramFiles%\FoxitReader.exe" "%1"')
    $exitcode = RunWait(@ComSpec & ' /c ftype ' & $type & '=' & $program & _
             ' && assoc ' & $extension & '=' & $type, '', @SW_HIDE)
    If $description And Not $exitcode Then
        Return RegWrite('HKCR\' & $type, '', 'Reg_sz', $description)
    EndIf
    Return Not $exitcode
EndFunc
