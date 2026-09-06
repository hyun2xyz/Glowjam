<# :
@echo off
title Glow Jam 자동 설치 마법사
net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
powershell -NoProfile -ExecutionPolicy Bypass -Command "Invoke-Expression ([System.IO.File]::ReadAllText('%~f0', [System.Text.Encoding]::UTF8))"
exit /b
#>

Add-Type -AssemblyName System.Windows.Forms

# 1. Check if After Effects is running
if (Get-Process -Name "AfterFX" -ErrorAction SilentlyContinue) {
    [System.Windows.Forms.MessageBox]::Show(
        "애프터이펙트가 현재 실행 중입니다.`n`n작업 중인 프로젝트를 저장하고 애프터이펙트를 완전히 종료한 뒤 다시 실행해 주세요.",
        "Glow Jam 설치 안내",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Warning
    )
    exit 1
}

Write-Host "Adobe After Effects 설치 경로를 검색 중입니다..."

# 2. Intelligent Target Detection (Safe Drive Detection - ignores empty removable drives)
$TargetMediaCoreDirs = @()

# Check fixed drive letters for Adobe MediaCore
Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Used -gt 0 } | ForEach-Object {
    $driveRoot = $_.Root
    $mediaCoreCandidate = Join-Path $driveRoot "Program Files\Adobe\Common\Plug-ins\7.0\MediaCore\glow_jam"
    $adobeCommonCandidate = Join-Path $driveRoot "Adobe\Common\Plug-ins\7.0\MediaCore\glow_jam"
    
    if (Test-Path (Split-Path $mediaCoreCandidate) -ErrorAction SilentlyContinue) {
        $TargetMediaCoreDirs += $mediaCoreCandidate
    }
    if (Test-Path (Split-Path $adobeCommonCandidate) -ErrorAction SilentlyContinue) {
        $TargetMediaCoreDirs += $adobeCommonCandidate
    }
}

# Fallback default if nothing found
if ($TargetMediaCoreDirs.Count -eq 0) {
    $TargetMediaCoreDirs += "C:\Program Files\Adobe\Common\Plug-ins\7.0\MediaCore\glow_jam"
}

# 3. Clean legacy duplicate plugins safely
Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Used -gt 0 } | ForEach-Object {
    $driveRoot = $_.Root
    $aeCandidates = @(
        (Join-Path $driveRoot "Program Files\Adobe\Adobe After Effects *"),
        (Join-Path $driveRoot "Adobe\Adobe After Effects *")
    )
    foreach ($pattern in $aeCandidates) {
        Get-ChildItem -Path $pattern -ErrorAction SilentlyContinue | ForEach-Object {
            $legacyPlugin = Join-Path $_.FullName "Support Files\Plug-ins\glow_jam"
            $legacyScript = Join-Path $_.FullName "Support Files\Scripts\ScriptUI Panels\GlowJam.jsx"
            if (Test-Path $legacyPlugin) { Remove-Item -Path $legacyPlugin -Recurse -Force -ErrorAction SilentlyContinue }
            if (Test-Path $legacyScript) { Remove-Item -Path $legacyScript -Force -ErrorAction SilentlyContinue }
        }
    }
}

# 4. Deploy Plugins (.aex)
$SourcePluginDir = Join-Path $PSScriptRoot "glow_jam"
if (-not (Test-Path $SourcePluginDir)) {
    $SourcePluginDir = Join-Path $PSScriptRoot "Glow_Jam_Windows_0.12.0\glow_jam"
}

foreach ($targetDir in $TargetMediaCoreDirs) {
    if (-not (Test-Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    }
    Copy-Item -Path "$SourcePluginDir\*.aex" -Destination $targetDir -Force
    Get-ChildItem -Path "$targetDir\*.aex" -ErrorAction SilentlyContinue | Unblock-File
}

# 5. Deploy AI Weights and ONNX Runtime to ProgramData
$ProgramDataGlowJam = Join-Path $env:ProgramData "glow_jam"
if (-not (Test-Path $ProgramDataGlowJam)) {
    New-Item -ItemType Directory -Path $ProgramDataGlowJam -Force | Out-Null
}

$SourceModelsDir = Join-Path $PSScriptRoot "models"
if (-not (Test-Path $SourceModelsDir)) {
    $SourceModelsDir = Join-Path $PSScriptRoot "Glow_Jam_Windows_0.12.0\models"
}

if (Test-Path $SourceModelsDir) {
    Copy-Item -Path $SourceModelsDir -Destination $ProgramDataGlowJam -Recurse -Force
    Get-ChildItem -Path "$ProgramDataGlowJam\models" -Recurse -File -ErrorAction SilentlyContinue | Unblock-File
}

[System.Windows.Forms.MessageBox]::Show(
    "Glow Jam 설치가 완료되었습니다!`n`n★ 감지된 어도비 경로:`n" + ($TargetMediaCoreDirs -join "`n") + "`n`n★ AI 가중치 모델 및 DirectML 런타임 동시 적용 완료`n`n이제 애프터이펙트를 실행하시면 AI 깊이 연산이 즉시 동작합니다.",
    "Glow Jam 설치 완료",
    [System.Windows.Forms.MessageBoxButtons]::OK,
    [System.Windows.Forms.MessageBoxIcon]::Information
)
