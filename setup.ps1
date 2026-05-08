# setup.ps1 — Claude Code Config Sync
# Jalankan sekali di perangkat baru setelah clone repo ini.
# Script ini membuat symlinks dari ~/.claude/ ke repo ini.
#
# Usage:
#   .\setup.ps1
#   .\setup.ps1 -RepoPath "D:\custom\path\claude-config" -ProjectPath "D:\path\ke\project\utama"

param(
    [string]$RepoPath = $PSScriptRoot,
    [string]$ProjectPath = "D:\2. Office\5. Ai\Claude"
)

$claudeConfig = "$env:USERPROFILE\.claude"

Write-Host "=== Claude Code Config Setup ===" -ForegroundColor Cyan
Write-Host "Repo   : $RepoPath"
Write-Host "Claude : $claudeConfig"
Write-Host "Project: $ProjectPath"
Write-Host ""

# 1. CLAUDE.md
$claudeMdTarget = "$claudeConfig\CLAUDE.md"
if (Test-Path $claudeMdTarget) { Remove-Item $claudeMdTarget -Force }
New-Item -ItemType SymbolicLink -Path $claudeMdTarget -Target "$RepoPath\CLAUDE.md" | Out-Null
Write-Host "[OK] CLAUDE.md symlink" -ForegroundColor Green

# 2. commands/ folder
$commandsTarget = "$claudeConfig\commands"
if (Test-Path $commandsTarget) { Remove-Item $commandsTarget -Recurse -Force }
New-Item -ItemType SymbolicLink -Path $commandsTarget -Target "$RepoPath\commands" | Out-Null
Write-Host "[OK] commands/ symlink" -ForegroundColor Green

# 3. memory/ folder (project-specific)
# Encode project path ke format yang digunakan Claude Code
$encodedPath = $ProjectPath -replace '[:\\]', '-' -replace '\s', '-' -replace '--+', '-'
$memoryDir = "$claudeConfig\projects\$encodedPath"
if (-not (Test-Path $memoryDir)) { New-Item -ItemType Directory -Path $memoryDir -Force | Out-Null }

$memoryTarget = "$memoryDir\memory"
if (Test-Path $memoryTarget) { Remove-Item $memoryTarget -Recurse -Force }
New-Item -ItemType SymbolicLink -Path $memoryTarget -Target "$RepoPath\memory" | Out-Null
Write-Host "[OK] memory/ symlink -> $memoryTarget" -ForegroundColor Green

# 4. Custom skills symlinks
$customSkillsPath = "$RepoPath\custom-skills"
if (Test-Path $customSkillsPath) {
    $skillsDir = "$env:USERPROFILE\.claude\skills"
    if (-not (Test-Path $skillsDir)) { New-Item -ItemType Directory -Path $skillsDir -Force | Out-Null }
    Get-ChildItem $customSkillsPath -Directory | ForEach-Object {
        $target = "$skillsDir\$($_.Name)"
        if (Test-Path $target) { Remove-Item $target -Recurse -Force }
        New-Item -ItemType SymbolicLink -Path $target -Target $_.FullName | Out-Null
        Write-Host "[OK] custom skill symlink: $($_.Name)" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "Setup selesai! Restart Claude Code jika sedang berjalan." -ForegroundColor Cyan
Write-Host ""
Write-Host "Untuk install marketplace skills, baca: skills-registry.md" -ForegroundColor Yellow
