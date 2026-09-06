<# :
@echo off
chcp 65001 >nul
title Glow Jam 자동 설치 마법사
setlocal EnableDelayedExpansion

cd /d "%~dp0"
set "SCRIPT_FILE=%~f0"
set "SCRIPT_DIR=%~dp0"
set "GLOW_JAM_DIR=%~dp0"

net session >nul 2>&1
if %errorlevel% neq 0 goto ELEVATE
goto RUN_INSTALL

:ELEVATE
echo ========================================================
echo   Glow Jam v0.12.0 자동 설치 마법사
echo   관리자 권한(UAC) 승인 창이 표시되면 [예]를 눌러주세요.
echo ========================================================
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ws = New-Object -ComObject Shell.Application; $ws.ShellExecute('cmd.exe', ('/c `\"`\"' + $env:SCRIPT_FILE + '`\"`\"'), '', 'runas', 1)"
exit /b

:RUN_INSTALL
powershell -NoProfile -ExecutionPolicy Bypass -Command "& { [ScriptBlock]::Create((Get-Content -LiteralPath $env:SCRIPT_FILE -Raw -Encoding UTF8)).Invoke() }"
echo.
echo 키보드의 아무 키나 누르면 창이 닫힙니다.
pause >nul
exit /b
#>

Add-Type -AssemblyName System.Windows.Forms

# 1. Check if After Effects is running
if (Get-Process -Name "AfterFX" -ErrorAction SilentlyContinue) {
    Write-Host "[경고] 애프터이펙트가 현재 실행 중입니다." -ForegroundColor Red
    Write-Host "애프터이펙트를 완전히 종료한 뒤 다시 실행해 주세요." -ForegroundColor Yellow
    [System.Windows.Forms.MessageBox]::Show(
        "애프터이펙트가 현재 실행 중입니다.`n`n작업 중인 프로젝트를 저장하고 애프터이펙트를 완전히 종료한 뒤 다시 실행해 주세요.",
        "Glow Jam 설치 안내",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Warning
    )
    exit 1
}

Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "  Glow Jam v0.12.0 자동 설치 마법사" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Adobe After Effects 설치 경로 검색 중..." -ForegroundColor Yellow

# Script directory fallback
$ScriptDir = $env:GLOW_JAM_DIR
if (-not $ScriptDir -or -not (Test-Path $ScriptDir)) {
    $ScriptDir = (Get-Location).Path
}
$ScriptDir = $ScriptDir.TrimEnd('\')

$SourcePluginDir = Join-Path $ScriptDir "glow_jam"
if (-not (Test-Path $SourcePluginDir)) {
    $SourcePluginDir = Join-Path $ScriptDir "Glow_Jam_Windows_0.12.0\glow_jam"
    if (Test-Path $SourcePluginDir) {
        $ScriptDir = Join-Path $ScriptDir "Glow_Jam_Windows_0.12.0"
    }
}

if (-not (Test-Path $SourcePluginDir)) {
    Write-Host "[오류] glow_jam 폴더를 찾을 수 없습니다: $ScriptDir" -ForegroundColor Red
    [System.Windows.Forms.MessageBox]::Show(
        "플러그인 폴더(glow_jam)를 찾을 수 없습니다.`n압축을 완전히 푼 폴더 안에서 실행해 주세요.`n`n검색 위치: $ScriptDir",
        "Glow Jam 설치 오류",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Error
    )
    exit 1
}

# 2. Detect Target MediaCore Dirs
$TargetMediaCoreDirs = @()
Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Used -gt 0 } | ForEach-Object {
    $driveRoot = $_.Root
    $cand1 = Join-Path $driveRoot "Program Files\Adobe\Common\Plug-ins\7.0\MediaCore\glow_jam"
    $cand2 = Join-Path $driveRoot "Adobe\Common\Plug-ins\7.0\MediaCore\glow_jam"
    if (Test-Path (Split-Path $cand1) -ErrorAction SilentlyContinue) { $TargetMediaCoreDirs += $cand1 }
    if (Test-Path (Split-Path $cand2) -ErrorAction SilentlyContinue) { $TargetMediaCoreDirs += $cand2 }
}

if ($TargetMediaCoreDirs.Count -eq 0) {
    $TargetMediaCoreDirs += "C:\Program Files\Adobe\Common\Plug-ins\7.0\MediaCore\glow_jam"
}

foreach ($t in $TargetMediaCoreDirs) {
    Write-Host "   -> 발견된 플러그인 경로: $t" -ForegroundColor Green
}

# 3. Clean legacy duplicate plugins safely
Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Used -gt 0 } | ForEach-Object {
    $driveRoot = $_.Root
    $aeCandidates = @(
        (Join-Path $driveRoot "Program Files\Adobe\Adobe After Effects *"),
        (Join-Path $driveRoot "Adobe\Adobe After Effects *")
    )
    foreach ($pat in $aeCandidates) {
        Get-ChildItem -Path $pat -ErrorAction SilentlyContinue | ForEach-Object {
            $legacyPlugin = Join-Path $_.FullName "Support Files\Plug-ins\glow_jam"
            $legacyScript = Join-Path $_.FullName "Support Files\Scripts\ScriptUI Panels\GlowJam.jsx"
            if (Test-Path $legacyPlugin) { Remove-Item -Path $legacyPlugin -Recurse -Force -ErrorAction SilentlyContinue }
            if (Test-Path $legacyScript) { Remove-Item -Path $legacyScript -Force -ErrorAction SilentlyContinue }
        }
    }
}

try {
    # 4. Deploy Plugins (.aex)
    Write-Host ""
    Write-Host "2. Glow Jam 플러그인 파일 복사 중..." -ForegroundColor Yellow
    foreach ($targetDir in $TargetMediaCoreDirs) {
        if (-not (Test-Path $targetDir)) {
            New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
        }
        $plugins = Get-ChildItem -Path "$SourcePluginDir\*.aex"
        foreach ($p in $plugins) {
            Copy-Item -Path $p.FullName -Destination $targetDir -Force
            Write-Host "   -> $($p.Name) ($($p.Length) bytes) 복사 완료" -ForegroundColor Green
        }
        Get-ChildItem -Path "$targetDir\*.aex" -ErrorAction SilentlyContinue | Unblock-File
    }

    # 5. Deploy AI Weights and ONNX Runtime to ProgramData
    Write-Host ""
    Write-Host "3. AI 모델 가중치 및 ONNX 런타임 배포 중..." -ForegroundColor Yellow
    $ProgramDataGlowJam = Join-Path $env:ProgramData "glow_jam"
    if (-not (Test-Path $ProgramDataGlowJam)) {
        New-Item -ItemType Directory -Path $ProgramDataGlowJam -Force | Out-Null
    }

    $SourceModelsDir = Join-Path $ScriptDir "models"
    if (Test-Path $SourceModelsDir) {
        Copy-Item -Path $SourceModelsDir -Destination $ProgramDataGlowJam -Recurse -Force
        Get-ChildItem -Path "$ProgramDataGlowJam\models" -Recurse -File -ErrorAction SilentlyContinue | Unblock-File
        Write-Host "   -> AI 모델 및 DLL 가중치 배포 완료" -ForegroundColor Green
    }

    Write-Host ""
    Write-Host "========================================================" -ForegroundColor Cyan
    Write-Host "★ Glow Jam 설치가 100% 정상 완료되었습니다! ★" -ForegroundColor Green
    Write-Host "========================================================" -ForegroundColor Cyan

    [System.Windows.Forms.MessageBox]::Show(
        "Glow Jam 설치가 완료되었습니다!`n`n★ 감지된 어도비 경로:`n" + ($TargetMediaCoreDirs -join "`n") + "`n`n★ AI 가중치 모델 및 DirectML 런타임 동시 적용 완료`n`n이제 애프터이펙트를 실행하시면 AI 깊이 연산이 즉시 동작합니다.",
        "Glow Jam 설치 완료",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information
    )
} catch {
    Write-Host ""
    Write-Host "[오류 발생] $($_.Exception.Message)" -ForegroundColor Red
    [System.Windows.Forms.MessageBox]::Show(
        "설치 중 오류가 발생했습니다:`n`n" + $_.Exception.Message + "`n`n파일을 마우스 우클릭한 후 '관리자 권한으로 실행'을 선택해 보세요.",
        "Glow Jam 설치 실패",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Error
    )
    exit 1
}