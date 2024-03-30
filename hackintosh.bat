@echo off
setlocal enabledelayedexpansion
set ver=1.0.0
for /f "tokens=4 delims= " %%i in ('ver') do set "winv=%%i"
for /f "tokens=1,2 delims=." %%a in ("%winv%") do (
    set "winvm=%%a"
)
if %winvm% lss 10 (
    echo Only Windows 10 and newer are supported.
    echo Press any key to quit...
    pause >nul
    goto end
)
if exist "%APPDATA%\..\Local\Programs\Python" (
    set is_py=true
)
:main
set page=Menu
cls
echo.
echo [90m----------------------[0m
echo [34;1mEasyHackintosh[0m [97mv%ver%[0m
echo [90m----------------------[0m
echo.   
echo [90mD -[0m Download Recovery Image
echo [90mC -[0m Create Installer USB
echo [90mO -[0m Configure OpenCore
echo.
echo [90mQ -[0m Quit
echo.
choice /c:dcoq >nul
set m=%errorlevel%
if %m% equ 1 goto dl
if %m% equ 2 goto efi
if %m% equ 3 goto config
if %m% equ 4 goto end
:dl
set page=Download Recovery Image
cls
echo.
echo [90m----------------------------------------------[0m
echo [34;1mEasyHackintosh[0m [97mv%ver%[0m [90m/[0m %page%
echo [90m----------------------------------------------[0m
echo.
echo [90m1 -[0m Ventura
echo [90m2 -[0m Monterey
echo [90m3 -[0m Big Sur
echo [90m4 -[0m Catalina
echo [90m5 -[0m Mojave
echo [90m6 -[0m High Sierra
echo [90m7 -[0m Sierra
echo [90m8 -[0m El Capitan
echo [90m9 -[0m Yosemite
echo [90mM -[0m Mavericks
echo [90mO -[0m Mountain Lion
echo [90mL -[0m Lion
echo.
echo [90mQ -[0m Back
echo.
choice /c:123456789molq >nul
set v=%errorlevel%
if "%v%"=="13" (
    goto main
) else (
    if "%v%"=="1" (
        set dl_name=Ventura
    )
    goto dl__start
)
:dl__start
cls
echo.
echo [90m----------------------------------------------[0m
echo [34;1mEasyHackintosh[0m [97mv%ver%[0m [90m/[0m %page%
echo [90m----------------------------------------------[0m
echo.
if not "%is_py%"=="true" (
    echo [31mPython must be installed to proceed.[0m
    pause >nul
    goto main
)
if not exist "temp" (
    mkdir temp
)
set tmp="temp"
echo Downloading [32;1mOpenCore[0m...
curl -# -L -o "%tmp%\OpenCore.zip" -g --create-dirs --progress-bar "https://github.com/acidanthera/OpenCorePkg/releases/download/0.9.9/OpenCore-0.9.9-RELEASE.zip"
echo Extracting archive...
if not exist "%tmp%/EFI" (
    mkdir %tmp%/EFI
)
tar -xf "%tmp%\OpenCore.zip" -C "%tmp%/EFI"
if not exist "%tmp%/macrecovery" (
    mkdir %tmp%/macrecovery
)
copy "%tmp%\EFI\Utilities\macrecovery\*" "%tmp%\macrecovery\" /y >nul
echo Cleaning up...
del "%tmp%\OpenCore.zip" >nul
:end