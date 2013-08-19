; coffeetimr.nsi
;
; This script is based on example1.nsi, but it remember the directory,
; has uninstall support and (optionally) installs start menu shortcuts.
;
; It will install into a directory that the user selects,

;--------------------------------

; The name of the installer
Name "Coffeetim.r"

; The file to write
OutFile "coffeetimr_setup.exe"

; The default installation directory
InstallDir $PROGRAMFILES\Coffeetimr

; Registry key to check for directory (so if you install again, it will
; overwrite the old one automatically)
InstallDirRegKey HKLM "Software\Coffeetimr" "Install_Dir"

; Request application privileges for Windows Vista
RequestExecutionLevel admin

;--------------------------------

; Pages

Page components
Page directory
Page instfiles

UninstPage uninstConfirm
UninstPage instfiles

;--------------------------------

; The stuff to install
Section "Coffeetim.r (required)"

  SectionIn RO

  ; Set output path to the installation directory.
  SetOutPath $INSTDIR

  ; Put file there
  File "coffeetimr.exe"
  File "coffeetimr.ini"
  File "y.ico"
  File "g.ico"
  File "r.ico"
  File "password generator.exe"

  ; Write the installation path into the registry
  WriteRegStr HKLM SOFTWARE\Coffeetimr "Install_Dir" "$INSTDIR"

  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Coffeetimr" "DisplayName" "Coffeetim.r"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Coffeetimr" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Coffeetimr" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Coffeetimr" "NoRepair" 1
  WriteUninstaller "uninstall.exe"

SectionEnd

; Optional sections (can be disabled by the user)
Section "Start Menu Shortcuts"

  CreateDirectory "$SMPROGRAMS\Coffeetimr"
  CreateShortCut "$SMPROGRAMS\Coffeetimr\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
  CreateShortCut "$SMPROGRAMS\Coffeetimr\Coffeetimr.lnk" "$INSTDIR\coffeetimr.exe" "" "$INSTDIR\coffeetimr.exe" 0
  CreateShortCut "$SMPROGRAMS\Coffeetimr\Pass generator.lnk" "$INSTDIR\password generator.exe" "" "$INSTDIR\password generator.exe" 0

SectionEnd

Section "Run at startup (are you sure?)"

 CreateShortCut "$SMPROGRAMS\Startup\Coffeetimr.lnk" "$INSTDIR\coffeetimr.exe" "" "$INSTDIR\coffeetimr.exe" 0

SectionEnd

;--------------------------------

; Uninstaller

Section "Uninstall"

  ; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Coffeetimr"
  DeleteRegKey HKLM SOFTWARE\Coffeetimr

  ; Remove files and uninstaller
  Delete $INSTDIR\Coffeetimr.nsi
  Delete $INSTDIR\uninstall.exe

  ; Remove shortcuts, if any
  Delete "$SMPROGRAMS\Coffeetimr\*.*"

  ; Remove directories used
  RMDir "$SMPROGRAMS\Coffeetimr"
  RMDir "$INSTDIR"

SectionEnd
