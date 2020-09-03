; ***** Script Settings ***** ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Include, ExternalFiles/AutoXYWH.ahk


; ***** Auto Execute block ***** ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Icon for test file
Menu, Tray, Icon, Icons\MainIcon\sharp_text_snippet_black_36.png
Menu, Tray, Add, Draw Gui, L_MainGui          



; ***** Global Script Variables ***** ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; What is this category? 
V_EditMode := false
V_TextData := ""
; Arrays for UI elements (plan to be used to dynamically size the elements based on window size)
V_TTM_Main_UI_Elements := Array()
V_TTM_Options_UI_Elements := Array()


; Location variables
;directoryPath = %A_MyDocuments%\XsearchScript    ; Build the directory path of the script
directoryPath = %A_ScriptDir%                    ; For local testing


; MainGui variables
V_MainGui_ID := ""
; Sizing specific (update later)
V_MainGui_Width := 0
V_MainGui_Height := 0
V_MainGui_TV_Width := 0
V_MainGui_TV_Height := 0
V_MainGui_Edit_Width := 0
V_MainGui_Edit_Height := 0
; TreeView specific
V_ImageList := 0


; OptionGui variables
V_OptionsGui_ID := ""
; Sizing specific
V_OptionsGui_Width := 0
V_OptionsGui_Height := 0
; Actual option variables
V_AlwaysOnTop := 0
V_SingleClickCopy := 0
V_AutoHide := 0
V_TaskTray_Closed := 0
V_TaskTray_Opened := 0
V_AutoPaste := 0
V_RestoreClipboard := 0
V_DynamicEditor_CloseWithEnter := 0
; Dummy button variables on option Screen
V_OptionsGui_Reset := ""
V_OptionsGui_Ok := ""
V_OptionsGui_Cancel := ""


; Status Bar messages
V_Status_ProgramStart := "Welcome to Text Template Manager."
V_Status_OptionsSaved := "Changes to Options were saved."
V_Status_OptionsReset := "Options were reset to default values."
V_Status_OptionsCancel := "Changes to Options were cancelled."
V_Status_DataLoaded := "Data was successfully loaded."
V_Status_DataNotLoaded := "Data was not loaded."
V_Status_DataSaved := "Data was successfully saved."
V_Status_DataNotSaved := "Data was not saved. Warning, you may lose your progress!"
V_Status_FolderCreated := "New Folder Created."
V_Status_FolderNotCreated := "Folder was not created successfully."
V_Status_TemplateCreated := "New empty Template created."
V_Status_TemplateNotCreated := "Template was not created successfully."
V_Status_Edit := "Entered Edit mode."
V_Status_Undo := "Undo executed."
V_Status_Redo := "Redo executed."
V_Status_Search := "Search mode."
V_Status_Delete_Success := "Item was deleted."
V_Status_Delete_Cancel := "Deletion was cancelled."

V_Status_Test := "Test status text."
V_Status_CurrentText := ""



; ***** Function Calls ***** ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Prepare ini file, read values
checkAndReadIni()

; ***** Hotkeys ***** ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Key lexicon: 
;   #   Win (Windows logo key)
;   !   Alt
;   ^   Control
;   +   Shift

Hotkey, +!r, reloadScript                ;  reload the script

; Ensure that there is a Return statement here so that the auto-execute block ends
; In order to designate hotkeys in this way, it is actually part of the auto-execute block
Return

; ***** Functions ***** ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

drawMainGui() {
    Global
    ;Menu, MenuBar, Add, New Folder, Label_NewFolder
    Menu, MenuBar, Add, New Folder, L_MainGui_NewFolder
    ;Menu, MenuBar, Icon, New Folder, Icons\NewFolder.ico,, 0
    Menu, MenuBar, Icon, New Folder, Icons\NewFolder\sharp_create_new_folder_black_24.png,, 0
    
    Menu, MenuBar, Add, New Template, L_MainGui_NewTemplate
    ;Menu, MenuBar, Icon, New Template, Icons\NewTemplate.ico,, 0
    Menu, MenuBar, Icon, New Template, Icons\NewTemplate\sharp_article_black_24.png,, 0
    
    Menu, MenuBar, Add, Edit, L_MainGui_Edit
    ;Menu, MenuBar, Icon, Edit, Icons\Edit.ico,, 0
    Menu, MenuBar, Icon, Edit, Icons\Edit\sharp_create_black_24.png,, 0
    
    Menu, MenuBar, Add, Undo, L_MainGui_Undo
    ;Menu, MenuBar, Icon, Undo, Icons\Undo.ico,, 0
    Menu, MenuBar, Icon, Undo, Icons\Undo\sharp_undo_black_24.png,, 0
    
    Menu, MenuBar, Add, Redo, L_MainGui_Redo
    ;Menu, MenuBar, Icon, Redo, Icons\Redo.ico,, 0
    Menu, MenuBar, Icon, Redo, Icons\Redo\sharp_redo_black_24.png,, 0
    
    Menu, MenuBar, Add, Search, L_MainGui_Search
    ;Menu, MenuBar, Icon, Search, Icons\Search.ico,, 0
    Menu, MenuBar, Icon, Search, Icons\Search\sharp_search_black_24.png,, 0
    
    Menu, MenuBar, Add, Delete, L_MainGui_Delete
    ;Menu, MenuBar, Icon, Delete, Icons\Delete.ico,, 0
    Menu, MenuBar, Icon, Delete, Icons\Delete\sharp_delete_forever_black_24.png,, 0
    
    Menu, MenuBar, Add, Options, L_MainGui_Options
    ;Menu, MenuBar, Icon, Options, Icons\Options.ico,, 0
    Menu, MenuBar, Icon, Options, Icons\Options\sharp_settings_black_24.png,, 0
    
    Gui, TTM_Main:New,, Text Template Manager
    Gui, TTM_Main:Default
    Gui, TTM_Main:+Resize
    Gui, TTM_Main:+HwndV_MainGui_ID
    Gui, Menu, MenuBar
    
    populateImageList()
    Gui, Add, TreeView, ImageList%V_ImageList% W200 
    
    ; Testing adding folders and using the "Folder" and "Text file" icons
    ;P1 := TV_Add("First parent", 0, "Icon1")   ; Uses folder Icon
    ;P1C1 := TV_Add("Child item", P1, "Icon2")  ; Uses Text file Icon
    
    
    ;Gui, Add, Edit, R10 xp+250 W200 WantTab +ReadOnly, Test text
    Gui, Add, Edit, xp+220 WantTab +ReadOnly, Test text
    
    Gui, Add, StatusBar, vMainStatusBar,
    updateCurrentStatus(V_Status_ProgramStart)
    ;SB_SetText(V_Status_CurrentText)
    
    Gui, Show, W650 H200,
}

calculateMainGuiSizes() {
}

populateImageList() {
    Global
    
    ; Icons for ImageList in the TreeView
    ; http://help4windows.com/windows_7_shell32_dll.shtml
    ; https://www.sysmiks.com/icon-number-of-icon-list-shell32-dll-imageres-dll/
        ; shell32.dll and imageres.dll both contain windows system icons
    
    ; TODO Consider updating the image list with standard windows symbols for new, save, etc.
    V_ImageList := IL_Create(2) 
    IL_Add(V_ImageList, "shell32.dll", 4)
    IL_Add(V_ImageList, "shell32.dll", 71)
}

drawOptionsGui() {
    Global
    
    ; Disable all controls in MainGui
    ; Flash Options Gui if User tries to select MainGui
    Gui, TTM_Options:New,, Options
    Gui, TTM_Options:+Resize -MinimizeBox -MaximizeBox
    
    Gui, TTM_Options:+OwnerTTM_Main
    Gui, TTM_Options:+LabelL_OptionsGui_On
    Gui, TTM_Main:+Disabled
    
    ; Master HotKey to open the gui
    ; Make up of up to 5 keys (ctrl, shift, winkey, alt, and any number/alphabet key)
    ; 5 drop downs
    
    ; Checkbox : Always on top
    Gui, Add, Checkbox, vV_AlwaysOnTop, Always On Top
    GuiControl,, V_AlwaysOnTop, %V_AlwaysOnTop%
    
    ; Checkbox : Single Click copy / Double click copy
    Gui, Add, Checkbox, vV_SingleClickCopy, Single Click Copy
    GuiControl,, V_SingleClickCopy, %V_SingleClickCopy%
    
    ; Checkbox : Auto hide after template copy
    Gui, Add, Checkbox, vV_AutoHide, Automatically hide after copying template
    GuiControl,, V_AutoHide, %V_AutoHide%
    
    ; Checkbox : Keep in task tray when closed
    Gui, Add, Checkbox, vV_TaskTray_Closed, Keep active in task tray when closed
    GuiControl,, V_TaskTray_Closed, %V_TaskTray_Closed%
    
    ; Checkbox : Run in task tray when started (GUI not displayed upon start up)
    Gui, Add, Checkbox, vV_TaskTray_Opened, Run directly in task tray when started
    GuiControl,, V_TaskTray_Opened, %V_TaskTray_Opened%
    
    ; Checkbox : Auto paste into last active window
    Gui, Add, Checkbox, vV_AutoPaste, Automatically paste into last active window
    GuiControl,, V_AutoPaste, %V_AutoPaste%
    
    ; Checkbox : restore clipboard after auto-paste
    Gui, Add, Checkbox, vV_RestoreClipboard, Restore clipboard after auto-paste
    GuiControl,, V_RestoreClipboard, %V_RestoreClipboard%
    
    ; Checkbox : "Enter" closes dynamic editor
    Gui, Add, Checkbox, vV_DynamicEditor_CloseWithEnter, 'Enter' key closes dynamic editor
    GuiControl,, V_DynamicEditor_CloseWithEnter, %V_DynamicEditor_CloseWithEnter%
    
    F_width := 50
    Gui, Add, Button, V_OptionsGui_Reset gL_OptionsGui_Reset W50, Reset
    Gui, Add, Button, V_OptionsGui_Ok gL_OptionsGui_Ok W50 xp+50, OK
    Gui, Add, Button, V_OptionsGui_Cancel gL_OptionsGui_Cancel W50 xp+50, Cancel
    
    Gui, Show, W230 H200,
}

;calculateOptionsGuiSizes() {
;    ; Revisit this, there are many bugs when it is used
;    ; Investigate using different parameters
;    AutoXYWH("xywh", "V_AlwaysOnTop")
;    AutoXYWH("xywh", "V_SingleClickCopy")
;    AutoXYWH("xywh", "V_AutoHide")
;    AutoXYWH("xywh", "V_TaskTray_Closed")
;    AutoXYWH("xywh", "V_TaskTray_Opened")
;    AutoXYWH("xywh", "V_AutoPaste")
;    AutoXYWH("xywh", "V_RestoreClipboard")
;    AutoXYWH("xywh", "V_DynamicEditor_CloseWithEnter")
;    AutoXYWH("xywh", "V_OptionsGui_Reset")
;    AutoXYWH("xywh", "V_OptionsGui_Ok")
;    AutoXYWH("xywh", "V_OptionsGui_Cancel")
;}

readSavedData() {
}

writeSavedData() {
}

escapeJSON() {
}

; Method to check for and read an existing ini file
checkAndReadIni() {
    ; Access to Global variables
    Global
    
    ; If the ini file does not exist, create with the default values
    ifNotExist, %directoryPath%\Data\Settings.ini 
    {
        ; Create ini file with default settings for future
        writeOptionsToIni()
    }
    ; If the ini file does exist, read the data within
    IfExist, %directoryPath%\Data\Settings.ini
    {
        IniRead, V_AlwaysOnTop, %directoryPath%\Data\Settings.ini, options, V_AlwaysOnTop, %V_AlwaysOnTop%
        IniRead, V_SingleClickCopy, %directoryPath%\Data\Settings.ini, options, V_SingleClickCopy, %V_SingleClickCopy%
        IniRead, V_AutoHide, %directoryPath%\Data\Settings.ini, options, V_AutoHide, %V_AutoHide%
        IniRead, V_TaskTray_Closed, %directoryPath%\Data\Settings.ini, options, V_TaskTray_Closed, %V_TaskTray_Closed%
        IniRead, V_TaskTray_Opened, %directoryPath%\Data\Settings.ini, options, V_TaskTray_Opened, %V_TaskTray_Opened%
        IniRead, V_AutoPaste, %directoryPath%\Data\Settings.ini, options, V_AutoPaste, %V_AutoPaste%
        IniRead, V_RestoreClipboard, %directoryPath%\Data\Settings.ini, options, V_RestoreClipboard, %V_RestoreClipboard%
    }
}

writeOptionsToIni() {
    ; Access to Global variables
    Global
    
    IniWrite, %V_AlwaysOnTop%, %directoryPath%\Data\Settings.ini, options, V_AlwaysOnTop
    IniWrite, %V_SingleClickCopy%, %directoryPath%\Data\Settings.ini, options, V_SingleClickCopy
    IniWrite, %V_AutoHide%, %directoryPath%\Data\Settings.ini, options, V_AutoHide
    IniWrite, %V_TaskTray_Closed%, %directoryPath%\Data\Settings.ini, options, V_TaskTray_Closed
    IniWrite, %V_TaskTray_Opened%, %directoryPath%\Data\Settings.ini, options, V_TaskTray_Opened
    IniWrite, %V_AutoPaste%, %directoryPath%\Data\Settings.ini, options, V_AutoPaste
    IniWrite, %V_RestoreClipboard%, %directoryPath%\Data\Settings.ini, options, V_RestoreClipboard
}

updateCurrentStatus(newText) {
    passedText := newText
    ErrorFlag := SB_SetText(passedText)
    Return ErrorFlag
}



; ***** Labels ***** ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

L_MainGui:
    drawMainGui()
Return

L_MainGui_NewFolder: 
    Gui, TTM_Main:+OwnDialogs
    ;MsgBox, New Folder
    
    SB_SetText(V_Status_FolderCreated)
Return

L_MainGui_NewTemplate:
    Gui, TTM_Main:+OwnDialogs
    ;MsgBox, New Template
    SB_SetText(V_Status_TemplateCreated)
Return

L_MainGui_Edit:
    Gui, TTM_Main:+OwnDialogs
    ;MsgBox, Edit
    SB_SetText(V_Status_Edit)
Return

L_MainGui_Undo:
    Gui, TTM_Main:+OwnDialogs
    ;MsgBox, Undo
    SB_SetText(V_Status_Undo)
Return

L_MainGui_Redo:
    Gui, TTM_Main:+OwnDialogs
    ;MsgBox, Redo
    SB_SetText(V_Status_Redo)
Return

L_MainGui_Search:
    Gui, TTM_Main:+OwnDialogs
    ;MsgBox, Search
    SB_SetText(V_Status_Search)
Return

L_MainGui_Delete:
    Gui, TTM_Main:+OwnDialogs
    MsgBox, 36, Delete Selection?, Are you sure that you want to delete the selected item?
    IfMsgBox Yes 
    {
        ; Delete the item from the List
        
        ; Commit the change to the saved data file
        
        
        SB_SetText(V_Status_Delete_Success)
    }
    Else 
    {
        ; do nothing, just close the dialog and hide the options gui
        SB_SetText(V_Status_Delete_Cancel)
    }    
Return

L_MainGui_Options:
    ; Check if differenter parameters could be passed to the function, depending on x/y changes
    drawOptionsGui()
Return

;L_MainGui_TV_Events:
;    if(A_GuiEvent = DoubleClick){
;    
;    }
;Return


L_OptionsGui_Reset:
    Gui, TTM_Options:+OwnDialogs
    MsgBox, 36,, Are you sure that you want to reset options?
    IfMsgBox Yes 
    {
        ; Reset option variables, then write them to the ini
        V_AlwaysOnTop := 0
        V_SingleClickCopy := 0
        V_AutoHide := 0
        V_TaskTray_Closed := 0
        V_TaskTray_Opened := 0
        V_AutoPaste := 0
        V_RestoreClipboard := 0
        V_DynamicEditor_CloseWithEnter := 0
        writeOptionsToIni()
        
        Gui, TTM_Options:Hide
        Gui, TTM_Main:Show
        Gui, TTM_Main:-Disabled 
        Gui, TTM_Main:Default ; Flags to system that the "TTM_Main" is the default window, and will update it with status data
        
        test := updateCurrentStatus(V_Status_OptionsReset)
    }
    Else 
    {
        ; do nothing, just close the dialog and hide the options gui
    }    
    ;Gui, TTM_Main:-Disabled
    ;Gui, TTM_Options:hide
Return

L_OptionsGui_Ok:
    ;Gui, TTM_Options:+OwnDialogs
    Gui, Submit 
    writeOptionsToIni()
    ;Gui, TTM_Options:Hide
    Gui, Destroy
    Gui, TTM_Main:Show
    Gui, TTM_Main:-Disabled
    Gui, TTM_Main:Default ; Flags to system that the "TTM_Main" is the default window, and will update it with status data
    
    test := updateCurrentStatus(V_Status_OptionsSaved)
    ;MsgBox, L_OptionsGui_Ok: %test%
Return

L_OptionsGui_Cancel:

    Gui, TTM_Options:Hide
    Gui, TTM_Main:+OwnDialogs
    Gui, TTM_Main:Show
    Gui, TTM_Main:-Disabled
    Gui, TTM_Main:Default ; Flags to system that the "TTM_Main" is the default window, and will update it with status data
    
    
    test := updateCurrentStatus(V_Status_OptionsCancel)
    ;MsgBox, L_OptionsGui_Cancel 4: Gui: %A_Gui%
    ;MsgBox, %A_DefaultGui%
Return

L_OptionsGui_OnClose:
;https://www.autohotkey.com/docs/commands/Gui.htm#Labels
    Gui, TTM_Options:Hide
    Gui, TTM_Main:Show
    Gui, TTM_Main:-Disabled
    Gui, TTM_Main:Default ; Flags to system that the "TTM_Main" is the default window, and will update it with status data
    test := updateCurrentStatus(V_Status_OptionsCancel)
    ;MsgBox, L_OptionsGui_OnClose: %test%
Return

;L_OptionsGui_OnSize:
;    calculateOptionsGuiSizes()
;Return


reloadScript:
  Reload
  Sleep 1000 ; If successful, the reload will close this instance during the Sleep, so the line below will never be reached.
  MsgBox, The script could not be reloaded.`nPlease exit the script and re-execute it manually.
Return
