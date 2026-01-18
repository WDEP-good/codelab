@echo off
setlocal enabledelayedexpansion

set DEFAULT_SOURCE_DIR=codelabs
set DEFAULT_OUTPUT_DIR=site\codelabs

if exist ".env" (
    echo [34mReading configuration from .env[0m
    
    for /f "tokens=1,2 delims==" %%a in ('type .env ^| findstr /B "CODELAB_SOURCE_DIR="') do (
        set ENV_SOURCE=%%b
        set ENV_SOURCE=!ENV_SOURCE:"=!
        set ENV_SOURCE=!ENV_SOURCE:'=!
        if not "!ENV_SOURCE!"=="" (
            set DEFAULT_SOURCE_DIR=!ENV_SOURCE!
            echo [32m  ✓ CODELAB_SOURCE_DIR: !ENV_SOURCE![0m
        )
    )
    
    for /f "tokens=1,2 delims==" %%a in ('type .env ^| findstr /B "CODELAB_OUTPUT_DIR="') do (
        set ENV_OUTPUT=%%b
        set ENV_OUTPUT=!ENV_OUTPUT:"=!
        set ENV_OUTPUT=!ENV_OUTPUT:'=!
        if not "!ENV_OUTPUT!"=="" (
            set DEFAULT_OUTPUT_DIR=!ENV_OUTPUT!
            echo [32m  ✓ CODELAB_OUTPUT_DIR: !ENV_OUTPUT![0m
        )
    )
    echo.
)

if "%~1"=="" (
    set SOURCE_DIR=!DEFAULT_SOURCE_DIR!
    set OUTPUT_DIR=!DEFAULT_OUTPUT_DIR!
) else (
    set SOURCE_DIR=%~1
    if "%~2"=="" (
        set OUTPUT_DIR=!DEFAULT_OUTPUT_DIR!
    ) else (
        set OUTPUT_DIR=%~2
    )
)

echo === Codelab Conversion ===
echo Source: %SOURCE_DIR%
echo Output: %OUTPUT_DIR%
echo.

if not exist "%SOURCE_DIR%" (
    echo [31mERROR: Source directory not found: %SOURCE_DIR%[0m
    exit /b 1
)

if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

set MD_COUNT=0
for /r "%SOURCE_DIR%" %%f in (*.md) do (
    set /a MD_COUNT+=1
)

if %MD_COUNT%==0 (
    echo [33mWARNING: No markdown files found in %SOURCE_DIR%[0m
    exit /b 0
)

echo [32mFound %MD_COUNT% markdown file(s)[0m
echo.

set SUCCESS=0
set FAILED=0

for /r "%SOURCE_DIR%" %%f in (*.md) do (
    echo Converting: %%~nxf
    
    claat export -o "%OUTPUT_DIR%" "%%f" >nul 2>&1
    if !errorlevel! equ 0 (
        set /a SUCCESS+=1
        echo   [32m✓ Success[0m
    ) else (
        set /a FAILED+=1
        echo   [31m✗ Failed[0m
    )
)

echo.
echo [32mConversion completed[0m
echo   Total:   %MD_COUNT%
echo   Success: %SUCCESS%
echo   Failed:  %FAILED%
echo.

if exist "%OUTPUT_DIR%" (
    echo Output directory contents:
    dir /b "%OUTPUT_DIR%"
)

echo.
echo [32mDone![0m

endlocal
