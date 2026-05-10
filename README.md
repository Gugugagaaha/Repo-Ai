# Claude Code — Personal Config Repo

Repo ini berisi konfigurasi Claude Code personal: global rules, custom slash commands (`/up`, `/history`, `/updateskills`), memory files, skill registry, setup script, dan hook untuk auto-track session.

---

## Untuk Manusia

### Setup di Perangkat Baru

**Prerequisite:**
- Claude Code CLI sudah terinstall (`claude --version` works)
- Git terinstall
- Developer Mode aktif (Windows Settings → System → For developers) — untuk symlinks
- Python 3.x (optional, untuk `token_counter.py`)

---

#### **Mode A — Otomatis via Claude Code** (Recommended)

1. Install Claude Code CLI di perangkat baru
2. Buka terminal, jalankan `claude`
3. Kasih prompt:

   > Setup Claude Code config dari https://github.com/Gugugagaaha/Repo-Ai

4. Claude akan fetch README ini, baca section "INSTRUCTIONS FOR CLAUDE" di bawah, lalu eksekusi setup otomatis. Akan ada 1 pertanyaan di akhir (mau migrate `~/.claude` ke partisi lain atau tidak).

---

#### **Mode B — Manual via PowerShell**

```powershell
# Clone repo ke lokasi default
git clone https://github.com/Gugugagaaha/Repo-Ai "D:\CLAUDE CODE\Config"

# Run bootstrap
cd "D:\CLAUDE CODE\Config"
.\bootstrap.ps1
```

`bootstrap.ps1` handle: prerequisite check, run `setup.ps1`, install Python deps, register hook, instruksi user untuk lanjut `/updateskills` via Claude, dan tanya migrasi di akhir.

---

### Setelah Setup Selesai

Restart Claude Code, lalu commands berikut ready:

| Command | Fungsi |
|---|---|
| `/history` | Restore konteks sesi sebelumnya (load memory + PROGRESS + SESSION_LOG 3 hari terakhir + token counter baseline) |
| `/up` | Full 2-way sync: pull → update SESSION_LOG/PROGRESS/memory → push → verify |
| `/updateskills` | Sync skills dua arah: local ↔ GitHub (custom skills + marketplace skills install) |

---

## INSTRUCTIONS FOR CLAUDE

> Jika kamu adalah Claude Code dan user kasih link repo ini, baca section ini dan eksekusi setup otomatis sesuai flow di bawah. Jangan skip step apapun. Konfirmasi ke user kalau ada yang ambigu.

### Flow Overview

```
Phase 1 — Prereq check (claude, git, python)
Phase 2 — Cek akses GitHub
Phase 3 — Clone repo ke default path D:\CLAUDE CODE\Config
Phase 4 — Run setup.ps1 (symlinks + register hook)
Phase 5 — Install Python deps (tiktoken)
Phase 6 — Auto-run /updateskills (install marketplace skills)
Phase 7 — Tanya user: migrate ~/.claude ke partisi lain? (di akhir, bukan di awal)
Phase 8 — Migrate kalau yes
Phase 9 — Verifikasi & laporan
```

---

### Phase 1 — Prerequisite Check

```powershell
claude --version
git --version
python --version
```

- `claude` ga ada → halt, suruh user install Claude Code CLI dulu
- `git` ga ada → halt, suruh user install Git
- `python` ga ada → flag warning, lanjut tanpa Python (token_counter.py jadi non-functional)

---

### Phase 2 — Cek Akses GitHub

```powershell
git ls-remote https://github.com/Gugugagaaha/Repo-Ai.git HEAD 2>&1
```

- Berhasil → lanjut
- Authentication error → suruh user login dulu via `! gh auth login` atau setup PAT, lalu ulangi

---

### Phase 3 — Clone Repo ke Default Path

Default path: `D:\CLAUDE CODE\Config`

```powershell
$repoPath = "D:\CLAUDE CODE\Config"
if (Test-Path "$repoPath\.git") {
    cd $repoPath
    git pull
} else {
    git clone https://github.com/Gugugagaaha/Repo-Ai.git $repoPath
}
```

> **Catatan:** path ini bisa di-override kalau user explicit minta path lain. Tapi default = `D:\CLAUDE CODE\Config` (bukan C: karena ada feedback rule "jangan ke C drive").

---

### Phase 4 — Run setup.ps1

```powershell
cd "D:\CLAUDE CODE\Config"
.\setup.ps1
```

`setup.ps1` akan:
- Bikin symlinks: `CLAUDE.md`, `commands/`, `memory/`, `custom-skills/*`
- Auto-detect `ProjectPath` dari `~/.claude/projects/` existing, fallback ke cwd
- Register hook `UserPromptSubmit` di `settings.json`

Kalau ada error permission denied → suruh user aktifin Developer Mode.

---

### Phase 5 — Install Python Deps

Kalau Python ada:

```powershell
pip install tiktoken
```

Verifikasi:
```powershell
python "D:\CLAUDE CODE\Config\token_counter.py" "test"
```

Output harus tampil token count. Kalau gagal, flag warning ke user — `/history` Step 6 (token counter) ga akan jalan, tapi command tetap functional.

---

### Phase 6 — Auto-run /updateskills

Setelah setup symlinks selesai dan settings.json punya hook, **restart Claude Code** atau invoke `/updateskills` langsung untuk install marketplace skills dari registry.

**PENTING:** Restart Claude Code dulu sebelum invoke `/updateskills` supaya commands & hook ke-load.

```
/updateskills
```

Wait sampai selesai. Skills akan ke-symlink dari config repo (custom) dan di-clone dari registry (marketplace).

---

### Phase 7 — Tanya User Migrasi (DI AKHIR)

Setelah semua install selesai dan working, baru tanya user:

```
Tanya pakai AskUserQuestion:
"Data Claude Code (~/.claude) saat ini di C:. Mau pindahin ke partisi lain
supaya tidak ada data Claude di C:?"

Options:
- Tidak, biarkan di C: (Recommended kalau user happy dengan default)
- Ya, pindahin ke partisi lain (kasih input path target)
```

Kalau user pilih **Tidak** → skip ke Phase 9 (verifikasi).

---

### Phase 8 — Migrate ~/.claude (Optional)

⚠️ **Warning ke user dulu:**
- Claude Code harus di-exit dulu (kecuali kita yang sedang jalan — beri tahu user untuk close session ini setelah migrate)
- Backup akan dibuat di `~/.claude.bak` sebelum migrate
- Migrate butuh Developer Mode aktif

```powershell
$source = "$env:USERPROFILE\.claude"
$target = "<USER_INPUT_PATH>"  # misal "D:\CLAUDE CODE"

# 1. Resolve real path (kalau source udah symlink, target-nya yang sebenarnya)
$sourceItem = Get-Item $source
if ($sourceItem.LinkType -eq "SymbolicLink") {
    Write-Host "[INFO] ~/.claude sudah symlink ke $($sourceItem.Target). Migrate akan re-point."
    $realSource = $sourceItem.Target
} else {
    $realSource = $source
}

# 2. Buat target folder
if (-not (Test-Path $target)) { New-Item -ItemType Directory -Path $target -Force }

# 3. Move content
Get-ChildItem $realSource -Force | Move-Item -Destination $target -Force

# 4. Hapus old symlink/folder, buat new symlink
Remove-Item $source -Force -Recurse
New-Item -ItemType SymbolicLink -Path $source -Target $target

# 5. Verifikasi
Get-Item $source | Select-Object LinkType, Target
```

Kalau migrate gagal di tengah → restore dari backup, laporkan error ke user.

---

### Phase 9 — Verifikasi & Laporan

```powershell
@(
    "$env:USERPROFILE\.claude",
    "$env:USERPROFILE\.claude\CLAUDE.md",
    "$env:USERPROFILE\.claude\commands",
    "$env:USERPROFILE\.claude\settings.json"
) | ForEach-Object {
    $item = Get-Item $_ -ErrorAction SilentlyContinue
    [PSCustomObject]@{
        Path = $_
        Exists = ($null -ne $item)
        IsSymlink = ($item.LinkType -eq "SymbolicLink")
        Target = $item.Target
    }
} | Format-Table -AutoSize
```

Laporkan ke user:
- ✅ Setup berhasil
- ✅ Symlinks valid
- ✅ Hook registered
- ✅ Marketplace skills installed
- (kalau migrate) ✅ ~/.claude di `<target>`
- Suruh restart Claude Code untuk aktivasi semua

---

### Error Handling

| Error | Solusi |
|---|---|
| Permission denied saat symlink | Aktifkan Developer Mode di Windows Settings |
| Git auth failed | `! gh auth login` atau setup PAT |
| setup.ps1 ga bisa execute | `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser` |
| Hook ga jalan setelah restart | Cek `settings.json` punya `hooks.UserPromptSubmit`, path absolute valid |
| `/updateskills` ga ditemukan | Restart Claude Code dulu — commands baru ke-load setelah symlink |

---

## Isi Repo

| Folder/File | Isi |
|---|---|
| `CLAUDE.md` | Global rules & behavior untuk semua sesi Claude |
| `commands/` | Custom slash commands (`/up`, `/history`, `/updateskills`) |
| `memory/` | Memory files yang persisten antar sesi (feedback, user, project, reference) |
| `custom-skills/` | Custom skills (di-symlink ke `~/.claude/skills/`) |
| `hooks/prompt_counter.ps1` | Hook UserPromptSubmit — auto-increment counter, trigger reminder per 10 prompt |
| `skills-registry.md` | Daftar marketplace skills yang di-install via `/updateskills` |
| `setup.ps1` | Script bikin symlinks + register hook (dipanggil bootstrap atau manual) |
| `bootstrap.ps1` | Full bootstrap script untuk Mode B manual setup |
| `token_counter.py` | Tool estimasi token via tiktoken (dipakai `/history` baseline) |
| `prompt_counter.txt` | Counter file (auto-incremented oleh hook, tidak ikut sync — di-`.gitignore`) |
| `SESSION_LOG.md` | Log granular per ~10 prompt — auto-append oleh `/up` |
| `PROGRESS.md` | Milestone besar / keputusan penting (global, lintas project) |

---

## Tambah Skill Baru

Bilang ke Claude:
> Saya install skill baru dari github.com/xxx/yyy, tambahkan ke registry dan push

Claude akan update `skills-registry.md` dan push otomatis via `/up`.
