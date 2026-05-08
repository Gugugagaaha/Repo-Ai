# Claude Code — Setup Perangkat Baru

Paste seluruh isi file ini ke Claude Code di perangkat baru.

---

Hei Claude, ini adalah sesi setup Claude Code di perangkat baru. Tolong lakukan langkah-langkah berikut secara berurutan:

**Konteks:**
Saya punya config Claude Code yang tersimpan di GitHub: `https://github.com/Gugugagaaha/Repo-Ai`
Isinya: global rules (CLAUDE.md), custom slash commands, dan memory files.
Setup ini menggunakan symlinks agar semua perubahan otomatis ter-sync ke repo.

**Yang perlu dilakukan:**

1. **Tanya user** dua hal sebelum mulai:
   - "Di drive/folder mana repo config mau disimpan? (contoh: `D:\` atau `C:\Users\nama\Documents`) — folder `claude-config` akan dibuat otomatis di dalamnya"
   - "Di mana project utama kamu? (contoh: `D:\2. Office\5. Ai\Claude`) — ini untuk symlink memory"
   Tunggu jawaban user. Lalu tentukan: `<REPO_PATH>` = `<BASE_PATH>\claude-config`, `<PROJECT_PATH>` = jawaban kedua.

2. **Clone repo config** ke `<REPO_PATH>`:
   ```
   git clone https://github.com/Gugugagaaha/Repo-Ai.git <REPO_PATH>
   ```
   Jika folder `<REPO_PATH>` sudah ada dan sudah berisi repo → lakukan `git pull` saja di dalamnya.

3. **Jalankan setup script** untuk membuat symlinks:
   ```
   cd <REPO_PATH>
   .\setup.ps1 -ProjectPath "<PROJECT_PATH>"
   ```
   (`-RepoPath` tidak perlu diisi — script otomatis pakai folder tempat ia berada via `$PSScriptRoot`)

4. **Verifikasi symlinks** berhasil dibuat:
   - `C:\Users\<username>\.claude\CLAUDE.md` → harus symlink ke `<REPO_PATH>\CLAUDE.md`
   - `C:\Users\<username>\.claude\commands\` → harus symlink ke `<REPO_PATH>\commands\`
   - `<PROJECT_PATH>\.claude\projects\<encoded-path>\memory\` → harus symlink ke `<REPO_PATH>\memory\`

4. **Cek isi** file CLAUDE.md dan memory sudah terbaca dengan benar.

5. **Laporkan** hasilnya: apa yang berhasil, apa yang gagal, dan langkah selanjutnya jika ada error.

**Catatan penting:**
- Jika muncul error "permission denied" saat buat symlink → aktifkan Developer Mode di Windows Settings → System → For developers, lalu ulangi dari step 2.
- Jika muncul error git credential → user perlu login GitHub dulu via `gh auth login` atau masukkan token.
- Jangan modifikasi file di `C:\Users\<username>\.claude\` langsung — selalu edit melalui `D:\claude-config\` agar perubahan masuk ke git.
