# Claude Code — Personal Config Repo

Repo ini berisi konfigurasi Claude Code personal: global rules, custom slash commands, memory files, skill registry, dan setup script untuk sync antar perangkat.

---

<!-- CLAUDE_SETUP_INSTRUCTIONS -->
## Instruksi untuk Claude Code

> Jika kamu adalah Claude Code dan user memberikan link repo ini, baca bagian ini dan jalankan setup secara otomatis.

### Apa isi repo ini?

| Folder/File | Isi |
|-------------|-----|
| `CLAUDE.md` | Global rules & behavior untuk semua sesi Claude Code |
| `commands/` | Custom slash commands (`/lv`, `/updateskills`) |
| `memory/` | Memory files yang persisten antar sesi |
| `custom-skills/` | Custom skills yang dibackup dari perangkat |
| `skills-registry.md` | Daftar semua sumber skill yang diinstall |
| `setup.ps1` | Script otomatis untuk membuat symlinks di perangkat baru |
| `SETUP_PROMPT.md` | Instruksi setup lengkap (referensi detail) |

### Yang harus dilakukan saat user memberikan link repo ini

Lakukan langkah berikut secara berurutan:

**1. Tanya dua hal kepada user:**
- "Di drive/folder mana repo ini mau disimpan? (contoh: `D:\`) — folder `claude-config` akan dibuat otomatis"
- "Di mana project utama kamu? (contoh: `D:\2. Office\5. Ai\Claude`) — untuk symlink memory"

Tunggu jawaban. Sebut hasilnya sebagai `<BASE_PATH>` dan `<PROJECT_PATH>`.
Tentukan: `<REPO_PATH>` = `<BASE_PATH>\claude-config`

**2. Clone repo:**
```
git clone https://github.com/Gugugagaaha/Repo-Ai.git <REPO_PATH>
```
Jika folder sudah ada dan sudah berisi repo → `git pull` saja.

**3. Jalankan setup script:**
```powershell
cd <REPO_PATH>
.\setup.ps1 -ProjectPath "<PROJECT_PATH>"
```

**4. Verifikasi symlinks:**
- `C:\Users\<username>\.claude\CLAUDE.md` → symlink ke `<REPO_PATH>\CLAUDE.md`
- `C:\Users\<username>\.claude\commands\` → symlink ke `<REPO_PATH>\commands\`
- `<PROJECT_PATH>\.claude\projects\<encoded>\memory\` → symlink ke `<REPO_PATH>\memory\`
- `C:\Users\<username>\.claude\skills\notion-design\` → symlink ke `<REPO_PATH>\custom-skills\notion-design\`

**5. Laporkan hasil** dan beritahu user untuk restart Claude Code.

### Error handling

| Error | Solusi |
|-------|--------|
| Permission denied saat buat symlink | Aktifkan Developer Mode: Windows Settings → System → For developers |
| Git credential error | Jalankan `gh auth login` atau setup personal access token |
| `setup.ps1` tidak bisa dieksekusi | Jalankan `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser` |

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
|---------|--------|
| `/lv` | Backup ringkasan sesi ke PROGRESS.md + auto push ke GitHub |
| `/updateskills` | Sync skills dua arah: local ↔ GitHub |

### Tambah skill baru

Bilang ke Claude:
> "Saya baru install skill dari github.com/xxx/yyy, tambahkan ke registry dan push"

Claude akan update `skills-registry.md` dan push otomatis.
