---
name: Boleh Pakai Multi-Skill Sekaligus
description: User mengizinkan invoke lebih dari 1 skill bersamaan jika memang ada yang relevan
type: feedback
---

User secara eksplisit mengizinkan penggunaan lebih dari 1 skill dalam satu sesi/task.

Jika ada task yang bisa dibantu oleh beberapa skill sekaligus, invoke semua yang relevan — tidak perlu minta izin per skill.

**Why:** User ingin output yang lebih optimal; tidak mau dibatasi 1 skill kalau ada skill lain yang genuinely membantu.

**How to apply:** Saat analisa prompt, identifikasi semua skill yang relevan (bukan hanya yang paling cocok). Invoke semuanya jika ada lebih dari 1 yang berguna. Contoh kombinasi wajar:
- `senior-fullstack` + `senior-secops` → implementasi fitur + review security sekaligus
- `senior-fullstack` + `code-reviewer` → build fitur + langsung review kualitas kodenya
- `senior-backend` + `tdd-guide` → bangun service + tulis test bersamaan
