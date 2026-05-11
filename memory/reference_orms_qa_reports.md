---
name: ORMS QA Reports — Lokasi File
description: Lokasi 6 file QA report ORMS Bank Saqu (security + architecture + workflow + tracker + screenshots)
type: reference
---

**Base folder:** `D:\2. Office\BANK SAQU & BJJ\4. CODING\`

| File | Content | Phase |
|---|---|---|
| `QA_ORMS.md` | Static security audit — 23 findings code-level (SQL injection, plain password, weak crypto, CSP, CORS, dll) | Phase 0 |
| `QA_ModulORMS.md` | Architecture & module deep-dive — workflow, masterdata catalog, integration diagram | Phase 0.5 |
| `QA_ORMS_Workflow.md` | **MAIN** — Phase 1-7 live UI testing + 30 findings (W-1 to W-30) | Phase 1-7 |
| `QA_Progress_Tracker.md` | Live checkpoint log per ~10 menit selama QA execution | Tracker |

**Screenshot evidence:** `D:\claude-config\qa_orms_screenshots\` (46 PNG, gitignored — temporary per session)

**Cleanup SQL** untuk QA_TEST_ data: section 7.4 di `QA_ORMS_Workflow.md`

**Verdict singkat:** ORMS Production Readiness 25/100 — NOT READY. 10 critical production blockers harus fix dulu sebelum deploy. Estimasi 4-6 sprint dengan dedicated team.
