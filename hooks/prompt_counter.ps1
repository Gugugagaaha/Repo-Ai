# prompt_counter.ps1 — UserPromptSubmit hook
# Auto-increment prompt_counter.txt setiap user submit prompt.
# Trigger reminder ke Claude kalau counter >= 10.
#
# Output ke stdout akan masuk ke conversation context (visible Claude).
# Silent fail kalau ada error — jangan block prompt submission.

$ErrorActionPreference = "SilentlyContinue"

try {
    # Auto-detect config repo (same logic seperti /up Step 0)
    # Primary: script ini fisiknya selalu ada di dalam config repo -> parent dari $PSScriptRoot = repo root
    $configRepo = Split-Path $PSScriptRoot -Parent
    if (-not (Test-Path "$configRepo\.git")) { $configRepo = $null }

    if (-not $configRepo) {
        $commandsItem = Get-Item "$env:USERPROFILE\.claude\commands" -ErrorAction SilentlyContinue
        $claudeItem = Get-Item "$env:USERPROFILE\.claude" -ErrorAction SilentlyContinue
        $candidates = @()
        if ($commandsItem.LinkType -eq "SymbolicLink") {
            $candidates += Split-Path $commandsItem.Target -Parent
        }
        if ($claudeItem.LinkType -eq "SymbolicLink") {
            $candidates += Join-Path $claudeItem.Target "Config"
        }
        $candidates += "D:\Claude\Config", "D:\CLAUDE CODE\Config", "D:\claude-config", "$env:USERPROFILE\.claude\Config"
        $configRepo = $candidates | Where-Object { $_ -and (Test-Path "$_\.git") } | Select-Object -First 1
    }

    if (-not $configRepo) { exit 0 }

    $counterFile = Join-Path $configRepo "prompt_counter.txt"

    # Initialize kalau belum ada
    if (-not (Test-Path $counterFile)) {
        "0" | Out-File -FilePath $counterFile -Encoding utf8 -NoNewline
    }

    # Read, increment, write back
    $count = 0
    $raw = (Get-Content $counterFile -Raw).Trim()
    if ($raw -match '^\d+$') { $count = [int]$raw }
    $count++
    "$count" | Out-File -FilePath $counterFile -Encoding utf8 -NoNewline

    # Trigger reminder kalau >= 10
    if ($count -ge 10) {
        Write-Output "[SESSION_LOG REMINDER] Sudah $count prompt sejak SESSION_LOG terakhir. WAJIB update SESSION_LOG.md sekarang sebelum lanjut task user. Lihat feedback_session_log.md untuk format."
        # Reset counter
        "0" | Out-File -FilePath $counterFile -Encoding utf8 -NoNewline
    }
}
catch {
    # Silent fail — jangan block user prompt
    exit 0
}

exit 0
