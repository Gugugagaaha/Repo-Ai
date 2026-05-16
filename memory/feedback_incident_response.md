---
name: Incident Response — Jangan Percaya Claim Recovery Superficial
description: Kalau user kontak soal phishing/account compromise, JANGAN langsung accept claim "password udah diganti & 2FA aktif" — selalu probe ada download executable, dan asumsikan token grabber sampai terbukti tidak
type: feedback
---

Kalau user kontak dengan keluhan "kena phishing" / "akun di-hack" / "account compromise" / sejenisnya, **jangan langsung accept claim recovery yang mereka klaim sudah lakukan**.

User sering bilang "udah ganti password kok, udah pasang 2FA juga" dan menganggap selesai. Itu BIAS COMMON yang berbahaya — karena attack vector modern (infostealer, token grabber, browser cookie stealer) bypass password & 2FA dengan import session cookies/tokens langsung.

**Probe wajib di awal sebelum kasih advice apapun:**
1. **Vector serangan apa?** (DM phishing link / fake login page / download installer / fake QR scan)
2. **Apakah user download/run executable apapun?** (.exe, .msi, installer, "verification tool", "game", "mod")
3. **Apakah user scan QR code login Discord/Steam/etc dari source mencurigakan?**
4. **Apakah user input credential di halaman selain domain resmi?**
5. **Indicator post-compromise:** akun dipake spam DM? login dari device asing? mutasi/transaksi tidak dikenal?

**Kalau user jawab YA di pertanyaan #2 atau #3 → assume infostealer running di PC sampai terbukti tidak.** Lakukan discovery:
- Scheduled tasks dengan nama random/aneh (terutama yang LastRun recent)
- Registry Run keys + startup folder
- Folder mencurigakan di AppData (terutama `AppData\Local\History\History.IE5\<random-hex>\`, `AppData\Local\Temp`, embedded Python runtime di lokasi user)
- Process running dari user folder (pythonw, node, conhost dari Temp/AppData)
- Network connections dari proses suspicious
- Defender threat history (`Get-MpThreatDetection`) — kadang Defender udah detect tapi cuma block, gak hapus persistence

**Why:** Insiden 2026-05-16 — user awalnya bilang "udah recovery password sama pasang 2auth". Kalau gw langsung accept dan kasih advice generic "logout all devices", gw bakal miss bahwa malware infostealer (Ren'Py disguised Lumma variant) masih running aktif di PC user dengan scheduled task `Falcon Nigeria 5167-4120-500` yang re-trigger periodic. Defender sebenarnya sudah detect threat di 01:19 AM (Behavior:Win32/SuspEtherRpcConn.B severity 5) tapi cuma block process saat itu — persistence tetep jalan sampai gw cabut manual jam 11:32.

**How to apply:**
- Sebelum kasih recovery advice generik, selalu probe download executable & QR scan
- Kalau ada indicator infostealer → discovery di PC dulu (read-only paralel, baru destructive)
- Methodology cleanup: Discovery (read-only) → Disable/stop (reversible) → Save evidence ke D:\ → Delete (destructive) → Defender verify
- Sampaikan ke user: "password reset + 2FA TIDAK kill cookies/token yang sudah dicuri. Logout All Devices di setiap akun dari device clean WAJIB."
- Asumsi konservatif: kalau infostealer execute (DidThreatExecute=True), data exfil sudah terjadi → irreversible. Cleanup di PC bukan rollback data leak, hanya stop ongoing exfil.
