# Claude Code — Setup Perangkat Baru

Paste seluruh isi file ini ke Claude Code di perangkat baru.

---

Hei Claude, ini adalah sesi setup Claude Code di perangkat baru. Tolong lakukan langkah-langkah berikut secara berurutan:

**Konteks:**
Saya punya config Claude Code yang tersimpan di GitHub: `https://github.com/Gugugagaaha/Repo-Ai`
Isinya: global rules (CLAUDE.md), custom slash commands, dan memory files.
Setup ini menggunakan symlinks agar semua perubahan otomatis ter-sync ke repo.

**Yang perlu dilakukan:**

1. **Clone repo config** ke `D:\claude-config\`:
   ```
   git clone https://github.com/Gugugagaaha/Repo-Ai.git D:\claude-config
   ```
   Jika folder `D:\claude-config` sudah ada → lakukan `git pull` saja di dalamnya.

2. **Jalankan setup script** untuk membuat symlinks:
   ```
   cd D:\claude-config
   .\setup.ps1
   ```
   Default project path: `D:\2. Office\5. Ai\Claude`
   Jika project di perangkat ini ada di path lain, jalankan:
   ```
   .\setup.ps1 -ProjectPath "D:\path\ke\project\utama"
   ```

3. **Verifikasi symlinks** berhasil dibuat:
   - `C:\Users\<username>\.claude\CLAUDE.md` → harus symlink ke `D:\claude-config\CLAUDE.md`
   - `C:\Users\<username>\.claude\commands\` → harus symlink ke `D:\claude-config\commands\`
   - `<ProjectPath>\.claude\projects\<encoded-path>\memory\` → harus symlink ke `D:\claude-config\memory\`

4. **Cek isi** file CLAUDE.md dan memory sudah terbaca dengan benar.

5. **Laporkan** hasilnya: apa yang berhasil, apa yang gagal, dan langkah selanjutnya jika ada error.

**Catatan penting:**
- Jika muncul error "permission denied" saat buat symlink → aktifkan Developer Mode di Windows Settings → System → For developers, lalu ulangi dari step 2.
- Jika muncul error git credential → user perlu login GitHub dulu via `gh auth login` atau masukkan token.
- Jangan modifikasi file di `C:\Users\<username>\.claude\` langsung — selalu edit melalui `D:\claude-config\` agar perubahan masuk ke git.
