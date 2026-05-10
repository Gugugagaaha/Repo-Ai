# bootstrap.ps1 — Full setup untuk perangkat baru (Mode B manual)
# Jalankan dari config repo path setelah clone.
#
# Flow:
#   1. Prereq check (claude, git, python)
#   2. Run setup.ps1 (symlinks + hook registration)
#   3. Install Python deps (tiktoken)
#   4. Instruksi user untuk /updateskills via Claude
#   5. Tanya migrate ~/.claude ke partisi lain
#   6. Migrate kalau yes
#   7. Verify

param(
    [switch]$SkipMigrationPrompt
)

$ErrorActionPreference = "Stop"
$RepoPath = $PSScriptRoot
$claudeConfig = "$env:USERPROFILE\.claude"

Write-Host "=== Claude Code Bootstrap ===" -ForegroundColor Cyan
Write-Host "Repo: $RepoPath"
Write-Host ""

# === Phase 1 — Prereq Check ===
Write-Host "[Phase 1] Prerequisite check..." -ForegroundColor Yellow

$hasClaude = $null -ne (Get-Command claude -ErrorAction SilentlyContinue)
$hasGit    = $null -ne (Get-Command git -ErrorAction SilentlyContinue)
$hasPython = $null -ne (Get-Command python -ErrorAction SilentlyContinue)

if (-not $hasClaude) {
    Write-Error "Claude Code CLI tidak ditemukan. Install dulu: https://docs.claude.com/claude-code"
    exit 1
}
if (-not $hasGit) {
    Write-Error "git tidak ditemukan. Install Git for Windows dulu."
    exit 1
}
if (-not $hasPython) {
    Write-Host "[WARN] Python tidak ditemukan. token_counter.py ga akan jalan, tapi setup tetap lanjut." -ForegroundColor Yellow
}

Write-Host "  [OK] claude, git ditemukan" -ForegroundColor Green
if ($hasPython) { Write-Host "  [OK] python ditemukan" -ForegroundColor Green }
Write-Host ""

# === Phase 2 — Run setup.ps1 ===
Write-Host "[Phase 2] Run setup.ps1 (symlinks + hook)..." -ForegroundColor Yellow
& "$RepoPath\setup.ps1"
Write-Host ""

# === Phase 3 — Install Python deps ===
if ($hasPython) {
    Write-Host "[Phase 3] Install tiktoken..." -ForegroundColor Yellow
    pip install tiktoken --quiet
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  [OK] tiktoken installed" -ForegroundColor Green
    } else {
        Write-Host "  [WARN] tiktoken install gagal — token_counter.py mungkin error saat dijalankan" -ForegroundColor Yellow
    }
    Write-Host ""
} else {
    Write-Host "[Phase 3] Skip — Python tidak ada" -ForegroundColor Yellow
    Write-Host ""
}

# === Phase 4 — Instruksi /updateskills ===
Write-Host "[Phase 4] Marketplace skills install" -ForegroundColor Yellow
Write-Host "  Bootstrap script tidak bisa invoke /updateskills (butuh Claude session)."
Write-Host "  Silakan:"
Write-Host "    1. Restart Claude Code" -ForegroundColor Cyan
Write-Host "    2. Jalankan /updateskills di sesi Claude" -ForegroundColor Cyan
Write-Host ""

# === Phase 5 — Tanya migrate ===
if (-not $SkipMigrationPrompt) {
    Write-Host "[Phase 5] Migration prompt" -ForegroundColor Yellow

    $sourceItem = Get-Item $claudeConfig -ErrorAction SilentlyContinue
    if ($sourceItem.LinkType -eq "SymbolicLink") {
        Write-Host "  ~/.claude sudah symlink ke $($sourceItem.Target). Skip migration." -ForegroundColor Green
    } else {
        Write-Host ""
        Write-Host "  Data Claude Code (~/.claude) saat ini di C:."
        Write-Host "  Mau pindahin ke partisi lain (misal D:\) supaya tidak ada data Claude di C:?"
        Write-Host ""
        $answer = Read-Host "  Pindahin? [y/N]"

        if ($answer -match '^[yY]') {
            $target = Read-Host "  Path target (contoh: D:\CLAUDE CODE)"
            if (-not $target) {
                Write-Host "  [skip] Path kosong" -ForegroundColor Yellow
            } else {
                Write-Host ""
                Write-Host "  ⚠️  PERINGATAN:" -ForegroundColor Red
                Write-Host "  - Pastikan tidak ada Claude Code lain yang jalan"
                Write-Host "  - Backup akan dibuat di ~/.claude.bak sebelum migrate"
                Write-Host "  - Setelah migrate, semua sesi Claude harus restart"
                Write-Host ""
                $confirm = Read-Host "  Lanjut migrate? [y/N]"

                if ($confirm -match '^[yY]') {
                    try {
                        # Backup
                        $backup = "$claudeConfig.bak"
                        if (Test-Path $backup) { Remove-Item $backup -Recurse -Force }
                        Copy-Item $claudeConfig $backup -Recurse -Force
                        Write-Host "  [OK] Backup dibuat di $backup" -ForegroundColor Green

                        # Buat target
                        if (-not (Test-Path $target)) { New-Item -ItemType Directory -Path $target -Force | Out-Null }

                        # Move
                        Get-ChildItem $claudeConfig -Force | Move-Item -Destination $target -Force
                        Remove-Item $claudeConfig -Force -Recurse
                        New-Item -ItemType SymbolicLink -Path $claudeConfig -Target $target | Out-Null

                        Write-Host "  [OK] Migrate selesai. ~/.claude → $target" -ForegroundColor Green
                        Write-Host "  Backup masih di $backup — hapus manual setelah verifikasi"
                    } catch {
                        Write-Host "  [ERROR] Migrate gagal: $_" -ForegroundColor Red
                        Write-Host "  Cek backup di $backup untuk recovery"
                    }
                }
            }
        }
    }
    Write-Host ""
}

# === Phase 6 — Verify ===
Write-Host "[Phase 6] Verifikasi..." -ForegroundColor Yellow
$checks = @(
    "$claudeConfig\CLAUDE.md",
    "$claudeConfig\commands",
    "$claudeConfig\settings.json"
)
foreach ($path in $checks) {
    $item = Get-Item $path -ErrorAction SilentlyContinue
    if ($item) {
        $type = if ($item.LinkType -eq "SymbolicLink") { "symlink → $($item.Target)" } else { "file" }
        Write-Host "  [OK] $path ($type)" -ForegroundColor Green
    } else {
        Write-Host "  [MISSING] $path" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "=== Bootstrap selesai ===" -ForegroundColor Cyan
Write-Host "Next steps:"
Write-Host "  1. Restart Claude Code" -ForegroundColor Yellow
Write-Host "  2. Jalankan /updateskills untuk install marketplace skills" -ForegroundColor Yellow
Write-Host "  3. Jalankan /history di sesi baru untuk restore konteks" -ForegroundColor Yellow
