---
name: WAJIB Pakai Skill (Mandatory) — Multi-Skill Diperbolehkan
description: WAJIB invoke skill yang relevan untuk setiap task; cari skill baru jika tidak ada yang cukup. User sangat tidak menerima task yang dikerjakan tanpa skill.
type: feedback
---

**WAJIB (mandatory) — bukan opsi.** User secara eksplisit dan tegas menolak pekerjaan yang dilakukan tanpa skill yang relevan. Setiap task non-trivial WAJIB diawali dengan identifikasi & invoke skill yang membantu eksekusi.

## Aturan utama

1. **Setiap task** — pas analisa prompt, identifikasi minimal 1 skill yang membantu. Kalau ada beberapa yang relevan, invoke semuanya (multi-skill diperbolehkan).
2. **Plan harus include skill** — di bagian "skill/tool yang akan dipakai", sebut skill spesifik yang AKAN di-invoke. Bukan sekadar disebut di plan tapi tidak dieksekusi.
3. **EKSEKUSI sesuai plan** — jangan janjiin skill di plan tapi pas eksekusi langsung skip ke tools dasar (Read/Bash/Edit). User akan check apakah Skill tool benar-benar dipanggil.
4. **Kalau skill yang ada kurang** — WAJIB cari skill baru (lihat juga `feedback_skill_discovery.md`). Tanya user → cari di marketplace/GitHub/web → propose dengan command install. JANGAN langsung lanjut tanpa skill.
5. **Pengecualian sangat sempit** — hanya untuk pertanyaan singkat factual ("apa itu X?"), command sederhana (`/up`, `/history`, ls file), atau action trivial 1-langkah. Untuk segala task yang butuh review, analisa, generate kode, debugging, QA, security, architecture, dll — WAJIB pakai skill.

## Contoh konkrit

| Task | Skill WAJIB di-invoke |
|---|---|
| QA mendalam project | `engineering-skills:senior-qa` + `adversarial-reviewer` + (`senior-frontend` kalau React/Vue) |
| Review pull request | `engineering-skills:code-reviewer` + `adversarial-reviewer` |
| Security audit | `engineering-skills:senior-security` + `senior-secops` + (`security-pen-testing` kalau pen test) |
| Build fitur fullstack | `engineering-skills:senior-fullstack` + `tdd-guide` (test sambil build) |
| Bangun API backend | `engineering-skills:senior-backend` + `tdd-guide` |
| Design arsitektur | `engineering-skills:senior-architect` + `tech-stack-evaluator` |
| Frontend Next.js/React | `engineering-skills:senior-frontend` |
| Setup CI/CD, deploy | `engineering-skills:senior-devops` |
| Cloud architecture | `engineering-skills:aws-solution-architect` / `azure-cloud-architect` / `gcp-cloud-architect` |
| Test generation | `engineering-skills:senior-qa` + `tdd-guide` |
| Incident / SecOps | `engineering-skills:incident-commander` + `incident-response` + `threat-detection` |

## Why
User membayar/setup ekosistem skill ini supaya output berkualitas tinggi. Kalau gw skip skill dan langsung pakai tools dasar, output jadi setara dengan generic AI tanpa expertise — itu wasted setup.

## How to apply
1. **Setiap kali user kasih task non-trivial:**
   - Daftar skill mana yang relevan dari list yang available
   - Sebutkan di plan (bagian "skill/tool")
   - Pas eksekusi: BENAR-BENAR INVOKE via Skill tool atau Agent tool dengan subagent_type yang sesuai
2. **Saat eksekusi:**
   - Mulai dengan invoke skill yang paling primer untuk task itu
   - Skill akan kasih instructions tambahan — ikuti
   - Kombinasi beberapa skill kalau task multi-faceted (mis. QA + security review = 2 skill)
3. **Saat skill tidak ada/kurang:**
   - Aktifkan rule `feedback_skill_discovery.md` — cari skill baru
   - JANGAN langsung lanjut tanpa skill — itu violation rule ini
4. **Saat ragu skill apa yang dipakai:**
   - Tanya user — bukan asumsi
   - User lebih senang ditanya daripada gw skip skill

**Riwayat correction:** User pernah marah serius karena gw skip skill di task QA project (2026-05-10). Plan bilang akan pakai `senior-qa` + `adversarial-reviewer` + `senior-frontend`, tapi pas eksekusi gw langsung delegasi ke Explore agent + read files manual. Jangan terulang.
