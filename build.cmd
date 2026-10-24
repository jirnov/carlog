@echo off
setlocal enabledelayedexpansion

where fvm >nul 2>&1
if errorlevel 1 (
    echo [ERROR] fvm not found in PATH
    exit /b 1
)

echo === Flutter clean ===
call fvm flutter clean
if errorlevel 1 goto :fail

echo === Remove build ===
if exist build (
    rmdir /s /q build
    if exist build (
        echo [ERROR] Failed to remove build folder ^(locked by IDE/explorer/AV?^)
        exit /b 1
    )
)

echo === Flutter pub get ===
call fvm flutter pub get
if errorlevel 1 goto :fail

echo === Google Play (AAB) ===
call fvm flutter build appbundle --release --flavor googleplay
if errorlevel 1 goto :fail

echo === RuStore (APK) ===
call fvm flutter build apk --release --flavor rustore
if errorlevel 1 goto :fail

echo === Done ===
exit /b 0

:fail
echo [ERROR] Build step failed with code %ERRORLEVEL%
exit /b %ERRORLEVEL%
