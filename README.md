# Claude Code — Personal Config Repo

Repo ini berisi konfigurasi Claude Code personal: global rules, custom slash commands, memory files, skill registry, dan setup script untuk sync antar perangkat.

---

<!-- CLAUDE_SETUP_INSTRUCTIONS -->
## Instruksi untuk Claude Code

> Jika kamu adalah Claude Code dan user memberikan link repo ini, baca seluruh bagian ini lalu jalankan setup secara otomatis mengikuti urutan step di bawah. Jangan skip step apapun.

---

### Step 1 — Cek Status Instalasi Claude Code

Jalankan perintah ini untuk cek kondisi `~/.claude/`:

```powershell
Get-ChildItem "$env:USERPROFILE\.claude\" -ErrorAction SilentlyContinue
```

**Tentukan status:**

| Kondisi | Status |
|---|---|
| Folder tidak ada, atau hanya ada file default Claude Code (tanpa `CLAUDE.md` custom, tanpa `commands/` berisi custom command) | **Fresh install** |
| Ada `CLAUDE.md` custom, ada `commands/` berisi custom command, ada `memory/` | **Sudah ada config** |

Catat status ini — dipakai di Step 4.

---

### Step 2 — Tanya Path Tujuan

Tanya user:

> "Data Claude Code kamu saat ini tersimpan di `C:\Users\[username]\.claude\`. Supaya tidak ada data Claude di Local Disk C, data ini akan dipindahkan ke drive lain. Mau disimpan di mana? (contoh: `D:\.claude`)"

Tunggu jawaban → sebut sebagai `<NEW_CLAUDE_PATH>`.

---

### Step 3 — Pindahkan ~/.claude/ ke Path Baru

Jalankan secara berurutan:

```powershell
$source = "$env:USERPROFILE\.claude"
$dest = "<NEW_CLAUDE_PATH>"

# 1. Buat folder tujuan
New-Item -ItemType Directory -Path $dest -Force | Out-Null

# 2. Copy semua isi ke path baru (jika fresh install, folder mungkin kosong — tidak masalah)
if (Test-Path $source) {
    Copy-Item "$source\*" $dest -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item $source -Recurse -Force
}

# 3. Buat symlink ~/.claude/ → <NEW_CLAUDE_PATH>
New-Item -ItemType SymbolicLink -Path $source -Target $dest
```

Verifikasi symlink berhasil:

```powershell
Get-Item "$env:USERPROFILE\.claude" | Select-Object LinkType, Target
```

Output harus menunjukkan `LinkType: SymbolicLink` dan `Target: <NEW_CLAUDE_PATH>`.

> **Jika muncul error "permission denied":** Aktifkan Developer Mode → Windows Settings → System → For developers → aktifkan "Developer Mode". Lalu ulangi step ini.

---

### Step 4 — Cek Apakah Perlu Restart Claude Code

Lakukan tes sederhana — buat file di path baru dan cek via symlink:

```powershell
New-Item -Path "$env:USERPROFILE\.claude\__test_symlink__.tmp" -ItemType File -Force | Out-Null
$exists = Test-Path "<NEW_CLAUDE_PATH>\__test_symlink__.tmp"
Remove-Item "$env:USERPROFILE\.claude\__test_symlink__.tmp" -Force
Write-Host "Symlink aktif: $exists"
```

**Jika output `Symlink aktif: True` → tidak perlu restart, lanjut ke Step 5.**

**Jika symlink tidak aktif atau ada error:**

Simpan checkpoint ke `<NEW_CLAUDE_PATH>\setup-checkpoint.md`:

```markdown
# Setup Checkpoint
Status: Pindah path selesai — menunggu restart Claude Code
New Claude Path: <NEW_CLAUDE_PATH>
Next Step: Lanjut ke Step 5 — clone repo dan install config
Repo: https://github.com/Gugugagaaha/Repo-Ai

Instruksi setelah restart: ketik "lanjutkan setup Claude Code"
```

Lalu sampaikan ke user:

> "Symlink sudah dibuat. Tolong **restart Claude Code**, lalu ketik **lanjutkan setup Claude Code** untuk melanjutkan dari titik ini."

**Berhenti di sini sampai user restart.**

---

### Step 4b — Lanjutkan Setelah Restart

Jika user mengetik *"lanjutkan setup Claude Code"*:

1. Baca `~/.claude/setup-checkpoint.md` untuk ambil `<NEW_CLAUDE_PATH>` dan status terakhir
2. Hapus file checkpoint setelah dibaca
3. Lanjutkan dari Step 5

---

### Step 5 — Tanya Info untuk Clone Repo

Tanya user dua hal:

1. "Di drive/folder mana repo config mau disimpan? (contoh: `D:\`) — folder `claude-config` akan dibuat otomatis di dalamnya"
2. "Di mana project utama kamu? (contoh: `D:\2. Office\5. Ai\Claude`) — untuk symlink memory"

Tunggu jawaban. Tentukan:
- `<REPO_PATH>` = `<BASE_PATH>\claude-config`
- `<PROJECT_PATH>` = jawaban kedua

---

### Step 6 — Clone & Install Config dari Repo

```powershell
# Clone repo (atau pull jika sudah ada)
if (Test-Path "<REPO_PATH>\.git") {
    cd "<REPO_PATH>"
    git pull
} else {
    git clone https://github.com/Gugugagaaha/Repo-Ai.git "<REPO_PATH>"
}
```

```powershell
# Jalankan setup script
cd "<REPO_PATH>"
.\setup.ps1 -ProjectPath "<PROJECT_PATH>"
```

> Jika `setup.ps1` gagal dieksekusi: jalankan `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser` lalu ulangi.

---

### Step 7 — Verifikasi Akhir

Cek semua symlinks sudah benar:

```powershell
@(
    "$env:USERPROFILE\.claude",
    "$env:USERPROFILE\.claude\CLAUDE.md",
    "$env:USERPROFILE\.claude\commands",
    "$env:USERPROFILE\.claude\skills\notion-design"
) | ForEach-Object {
    $item = Get-Item $_ -ErrorAction SilentlyContinue
    [PSCustomObject]@{
        Path     = $_
        Exists   = ($null -ne $item)
        IsSymlink = ($item.LinkType -eq "SymbolicLink")
        Target   = $item.Target
    }
} | Format-Table -AutoSize
```

Laporkan hasil ke user:
- Symlink mana yang berhasil ✅
- Symlink mana yang gagal ❌ beserta solusinya
- Instruksikan restart Claude Code untuk aktivasi config baru

---

### Error Handling

| Error | Solusi |
|---|---|
| Permission denied saat buat symlink | Aktifkan Developer Mode: Windows Settings → System → For developers |
| Git credential error saat clone | Jalankan `git credential-manager` atau setup PAT di GitHub |
| `setup.ps1` tidak bisa dieksekusi | `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser` |
| Symlink test gagal setelah dibuat | Restart Claude Code, lalu ketik "lanjutkan setup Claude Code" |

---

## Isi Repo

| Folder/File | Isi |
|---|---|
| `CLAUDE.md` | Global rules & behavior untuk semua sesi Claude Code |
| `commands/` | Custom slash commands (`/lv`, `/updateskills`) |
| `memory/` | Memory files yang persisten antar sesi |
| `custom-skills/` | Custom skills yang dibackup dari perangkat |
| `skills-registry.md` | Daftar semua sumber skill yang diinstall |
| `setup.ps1` | Script otomatis untuk membuat symlinks di perangkat baru |
| `SETUP_PROMPT.md` | Instruksi setup lengkap (referensi detail) |

---

## Untuk Manusia

### Cara setup di perangkat baru

Cukup buka Claude Code dan ketik:

```
Setup Claude Code dari repo ini: https://github.com/Gugugagaaha/Repo-Ai
```

Claude akan fetch README ini dan menjalankan setup secara otomatis.

### Commands tersedia setelah setup

| Command | Fungsi |
|---|---|
| `/lv` | Backup ringkasan sesi ke PROGRESS.md + auto push ke GitHub |
| `/updateskills` | Sync skills dua arah: local ↔ GitHub |

### Tambah skill baru

Bilang ke Claude:
> "Saya baru install skill dari github.com/xxx/yyy, tambahkan ke registry dan push"

Claude akan update `skills-registry.md` dan push otomatis.
