---
name: Skill Pipelines & Kombinasi Efisien
description: Referensi pipeline skill yang bisa saling terhubung untuk efisiensi kerja — termasuk installed plugins, built-in skills, dan combos yang paling berguna
type: reference
originSessionId: 38fcfed5-df71-4128-abf7-bc04f5331d92
---
# Skill Pipelines & Kombinasi Efisien

Berdasarkan investigasi lengkap per 2026-07-17. Gunakan ini sebagai panduan memilih dan menggabungkan skill sebelum mengerjakan task.

---

## Inventory Skill (3 Lapisan)

| Lapisan | Isi |
|---|---|
| **Installed plugins** | engineering-skills (32 skills), ponytail (6), superpowers (11+), frontend-design (1) |
| **Built-in .claude/skills** | ~60 skills: spec, ship, qa, review, browse, ios-*, plan-*, dll |
| **Syncfusion Blazor** | 40+ skills — per komponen UI, pakai saat kerja Blazor |

---

## Pipeline Utama

### 1. Pre-Development (Ideation → Plan)
```
superpowers:brainstorming → spec → superpowers:writing-plans → autoplan
```
Wajib sebelum mulai feature besar. `autoplan` = entry point tunggal untuk review plan dari semua angle (eng + design + devex + ceo), gantikan panggil 4 plan-* manual.

### 2. Core Dev Loop
```
superpowers:executing-plans
  + engineering-skills:senior-[backend/frontend/fullstack/architect]
  + superpowers:tdd-guide  (opsional, kalau TDD)
```
Ketiganya jalan bersamaan (bukan berurutan). `executing-plans` sebagai driver, `senior-*` sebagai domain persona.

### 3. Code Review (3 lapis, urutan penting)
```
ponytail:ponytail-review → engineering-skills:code-reviewer → engineering-skills:adversarial-reviewer
```
Jangan skip ke `adversarial-reviewer` dulu — bersihkan kompleksitas berlebih via `ponytail-review` lebih dulu.

### 4. Debug Pipeline
```
investigate → superpowers:systematic-debugging → superpowers:verification-before-completion
```
`investigate` untuk runtime/browser issues. `systematic-debugging` untuk root cause di code. `verification-before-completion` **wajib** di akhir sebelum declare done.

### 5. Quality & Cleanup
```
health → ponytail:ponytail-audit → ponytail:ponytail-debt → simplify
```
`health` = overview. `ponytail-audit` = scan codebase. `ponytail-debt` = lihat accumulated shortcuts. `simplify` = apply fix aktual.

### 6. Security Audit
```
security-review → engineering-skills:security-pen-testing → engineering-skills:cloud-security
  → engineering-skills:threat-detection → engineering-skills:adversarial-reviewer
```
Broad → tactical → infra-level → anomaly detection.

### 7. Shipping
```
qa → review → security-review → superpowers:finishing-a-development-branch → ship
```
Atau `land-and-deploy` untuk direct deploy tanpa PR flow.

### 8. Post-Deploy Monitoring
```
canary → health → loop
```
`loop` bisa jalankan `canary` + `health` secara recurring interval.

### 9. Parallel Execution (task besar)
```
superpowers:dispatching-parallel-agents → superpowers:subagent-driven-development
```
Gunakan ketika ada 3+ task independent yang bisa dikerjakan paralel.

### 10. Browser/Automation
```
connect-chrome → setup-browser-cookies → browse → scrape → skillify
```
`skillify` = codify scrape flow jadi permanent skill. Pakai setelah scrape pattern yang mungkin diulang.

### 11. iOS Pipeline (urutan baku)
```
ios-sync → ios-design-review → ios-fix → ios-qa → ios-clean
```

### 12. Context & Safety
```
context-save ↔ context-restore   (session continuity)
freeze + guard                    (restrict edit scope + safety layer)
freeze ↔ unfreeze                 (paired)
```

---

## Combos Underutilized (Sering Terlewat)

| Combo | Kapan pakai |
|---|---|
| `spec` + `diagram` | Spec hasilkan requirement → `diagram` visualisasi arsitektur sebelum coding |
| `ponytail-audit` sebelum `review` | Bersihkan over-engineering dulu, reviewer tidak komentar hal yang harusnya dihapus |
| `retro` + `health` | Retrospective lebih data-driven kalau ada code health dashboard |
| `skillify` setelah `scrape` | Automation berulang → jadi reusable skill permanent |
| `benchmark` + `canary` | Ukur baseline, lalu monitor post-deploy untuk regresi performance |
| `superpowers:brainstorming` sebelum `spec` | Explore intent dulu, jangan langsung spec dari asumsi |

---

## Yang TIDAK Perlu Digabung (Overlap)

- `qa` + `qa-only` → pilih salah satu (`qa` = fix, `qa-only` = report only)
- `investigate` + `systematic-debugging` → pilih berdasar konteks (browser vs code)
- `ship` + `land-and-deploy` → beda scope, tidak perlu duet

---

## Aturan Penggunaan

1. Sebelum task non-trivial → cek pipeline mana yang relevan dari sini
2. Kalau ada skill yang bisa di-combine → combine, jangan jalankan satu-satu tanpa alasan
3. Urutan dalam pipeline penting — terutama di review chain (ponytail dulu, baru code-reviewer, baru adversarial)
4. `autoplan` selalu lebih baik dari panggil `plan-eng-review + plan-design-review + ...` manual
5. `superpowers:verification-before-completion` wajib sebelum laporan "selesai" ke user
6. **Boleh dan dianjurkan gabung skill yang belum terpetakan** — kalau task butuh kombinasi baru yang belum ada di sini, eksekusi saja. Pipeline di atas adalah referensi, bukan batasan.
