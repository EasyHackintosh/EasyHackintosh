@echo off
setlocal enabledelayedexpansion
set ver=1.0.0
set tmp="temp"
set img="images"
if not exist "images" (
    mkdir images
)
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
echo [90mE -[0m EFI Creation (USB)
echo [90mO -[0m Configure OpenCore
echo.
echo [90mQ -[0m Quit
echo.
choice /c:deoq >nul
set m=%errorlevel%
if %m% equ 1 goto dl
if %m% equ 2 goto efi
if %m% equ 3 goto config
if %m% equ 4 goto end
:dl
set page=Download Recovery Image
cls
echo.
echo [90m------------------------------------------------[0m
echo [34;1mEasyHackintosh[0m [97mv%ver%[0m [90m/[0m %page%
echo [90m------------------------------------------------[0m
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
echo [90m------------------------------------------------[0m
echo [34;1mEasyHackintosh[0m [97mv%ver%[0m [90m/[0m %page%
echo [90m------------------------------------------------[0m
echo.
if not "%is_py%"=="true" (
    echo [31mPython must be installed to proceed.[0m
    pause >nul
    goto main
)
if not exist "temp" (
    mkdir temp
    attrib +h "temp"
)
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
rd /s /q "%tmp%\EFI" >nul
:dl__mr
cls
echo.
echo [90m------------------------------------------------[0m
echo [34;1mEasyHackintosh[0m [97mv%ver%[0m [90m/[0m %page%
echo [90m------------------------------------------------[0m
echo.
cd %tmp%\macrecovery
if not "%is_py%"=="true" (
    echo [31mPython must be installed to proceed.[0m
    pause >nul
    goto main
)
if "%v%"=="1" (
    python macrecovery.py -b Mac-B4831CEBD52A0C4C -m 00000000000000000 download
    set error_level=%errorlevel%
)
if "%v%"=="2" (
    python macrecovery.py -b Mac-E43C1C25D4880AD6 -m 00000000000000000 download
    set error_level=%errorlevel%
)
if "%v%"=="3" (
    python macrecovery.py -b Mac-2BD1B31983FE1663 -m 00000000000000000 download
    set error_level=%errorlevel%
)
if "%v%"=="4" (
    python macrecovery.py -b Mac-00BE6ED71E35EB86 -m 00000000000000000 download
    set error_level=%errorlevel%
)
if "%v%"=="5" (
    python macrecovery.py -b Mac-7BA5B2DFE22DDD8C -m 00000000000KXPG00 download
    set error_level=%errorlevel%
)
if "%v%"=="6" (
    python macrecovery.py -b Mac-BE088AF8C5EB4FA2 -m 00000000000J80300 download
    set error_level=%errorlevel%
)
if "%v%"=="7" (
    python macrecovery.py -b Mac-77F17D7DA9285301 -m 00000000000J0DX00 download
    set error_level=%errorlevel%
)
if "%v%"=="8" (
    python macrecovery.py -b Mac-FFE5EF870D7BA81A -m 00000000000GQRX00 download
    set error_level=%errorlevel%
)
if "%v%"=="9" (
    python macrecovery.py -b Mac-E43C1C25D4880AD6 -m 00000000000GDVW00 download
    set error_level=%errorlevel%
)
if "%v%"=="10" (
    python macrecovery.py -b Mac-F60DEB81FF30ACF6 -m 00000000000FNN100 download
    set error_level=%errorlevel%
)
if "%v%"=="11" (
    python macrecovery.py -b Mac-7DF2A3B5E5D671ED -m 00000000000F65100 download
    set error_level=%errorlevel%
)
if "%v%"=="12" (
    python macrecovery.py -b Mac-C3EC7CD22292981F -m 00000000000F0HM00 download
    set error_level=%errorlevel%
)
REM Skip validation (for now)
:: if not %error_level% equ 0 (
::    echo [31mImage download failed.[0m
::    echo Cleaning up...
::    rd /s /q "%tmp%\macrecovery" >nul
::    goto main
::)
REM Hard-coded paths to make sure the images are moved
move "temp\macrecovery\com.apple.recovery.boot\*" "images\" >nul
echo Cleaning up...
rd /s /q "%tmp%\macrecovery" >nul
goto main
:efi
set page=EFI Creation
cls
echo.
echo [90m-------------------------------------[0m
echo [34;1mEasyHackintosh[0m [97mv%ver%[0m [90m/[0m %page%
echo [90m-------------------------------------[0m
echo.
pause >nul
:end
if exist "temp" (
    rd /s /q "temp" >nul
)