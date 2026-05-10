# setup.ps1 — Claude Code Config Sync
# Jalankan sekali di perangkat baru setelah clone repo ini.
# Script ini membuat symlinks dari ~/.claude/ ke repo ini.
#
# Usage:
#   .\setup.ps1                                          # auto-detect ProjectPath dari folder existing
#   .\setup.ps1 -ProjectPath "D:\path\ke\project\utama"  # specify manual
#   .\setup.ps1 -RepoPath "D:\custom\path\claude-config" -ProjectPath "..."

param(
    [string]$RepoPath = $PSScriptRoot,
    [string]$ProjectPath = ""
)

$claudeConfig = "$env:USERPROFILE\.claude"
$encodedPath = ""

# === Resolve project path: param > auto-detect > fallback cwd ===
if ($ProjectPath) {
    # User pass manual → encode normally
    $encodedPath = $ProjectPath -replace '[:\\]', '-' -replace '\s', '-' -replace '--+', '-'
} else {
    $projectsDir = "$claudeConfig\projects"
    if (Test-Path $projectsDir) {
        $existingProjects = Get-ChildItem $projectsDir -Directory -ErrorAction SilentlyContinue
        if ($existingProjects.Count -eq 1) {
            # Pakai encoded folder name langsung — decode/re-encode lossy karena " " dan "\" sama-sama jadi "-"
            $encodedPath = $existingProjects[0].Name
            $ProjectPath = "<auto-detected: $encodedPath>"
            Write-Host "[auto-detect] Encoded folder: $encodedPath" -ForegroundColor Yellow
        } elseif ($existingProjects.Count -gt 1) {
            Write-Host "Ada beberapa project terdeteksi di $projectsDir :" -ForegroundColor Yellow
            $existingProjects | ForEach-Object { Write-Host "  - $($_.Name)" }
            Write-Error "Multiple projects ditemukan. Specify -ProjectPath manual."
            exit 1
        }
    }

    if (-not $encodedPath) {
        # Fallback: pakai working directory saat ini sebagai project default
        $ProjectPath = (Get-Location).Path
        $encodedPath = $ProjectPath -replace '[:\\]', '-' -replace '\s', '-' -replace '--+', '-'
        Write-Host "[fallback] ProjectPath: $ProjectPath (current working dir)" -ForegroundColor Yellow
    }
}

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
# $encodedPath sudah diset di atas (auto-detect atau encode dari ProjectPath)
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

# 5. Register UserPromptSubmit hook di settings.json
$hookScript = "$RepoPath\hooks\prompt_counter.ps1"
$settingsPath = "$claudeConfig\settings.json"

if (Test-Path $hookScript) {
    $hookCommand = "powershell.exe -NoProfile -ExecutionPolicy Bypass -File `"$hookScript`""

    # Read existing settings (or empty hash)
    $settings = @{}
    if (Test-Path $settingsPath) {
        try {
            $existing = Get-Content $settingsPath -Raw | ConvertFrom-Json
            # Convert to hashtable manually (PS 5.1 ga ada -AsHashtable)
            $existing.PSObject.Properties | ForEach-Object { $settings[$_.Name] = $_.Value }
        } catch {
            Write-Host "[WARN] settings.json existing rusak, akan di-overwrite" -ForegroundColor Yellow
        }
    }

    # Inject hooks
    if (-not $settings.ContainsKey("hooks")) { $settings["hooks"] = @{} }
    $settings["hooks"] = @{
        "UserPromptSubmit" = @(
            @{
                matcher = ""
                hooks = @(
                    @{
                        type = "command"
                        command = $hookCommand
                    }
                )
            }
        )
    }

    $settings | ConvertTo-Json -Depth 10 | Out-File $settingsPath -Encoding utf8
    Write-Host "[OK] hook UserPromptSubmit registered di settings.json" -ForegroundColor Green
} else {
    Write-Host "[skip] hook script tidak ditemukan di $hookScript" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Setup selesai! Restart Claude Code jika sedang berjalan." -ForegroundColor Cyan
Write-Host ""
Write-Host "Untuk install marketplace skills, baca: skills-registry.md" -ForegroundColor Yellow
