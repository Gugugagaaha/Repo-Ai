---
name: ORMS Bank Saqu — Status Project
description: ORMS (Operational Risk Management System) Bank Saqu — banking-grade risk management app yang sudah di-QA full scope dengan 53 critical findings; not production-ready
type: project
---

**Stack:**
- ASP.NET WebForms .NET 4.8 (RMOnline @ port 3272) + ASP.NET Web API .NET 4.8 (RMSupportApi @ port 52797)
- Ext.NET 4.8.3 + Telerik UI + Telerik Reporting + iTextSharp 5.0.4 + OWIN OAuth
- SQL Server 2022 di `Indotek-Enzu` (RMBD_BJJ + orms_prod_user + ST_BJJ)
- ISO 31000 + Basel II Operational Risk compliance

**Project Path:** `D:\2. Office\BANK SAQU & BJJ\4. CODING\`
- RMOnline: `RMOnline_NEW2 (Update)\RMOnline_NEW2 (Update)\RMOnline_NEW2\RMOnline_NEW2\RMOnline\`
- RMSupportApi: `RMSupportApi NEW\RMSupportApi\RMSupportApi\`

**Test Credentials (kalau lanjut testing):**
- Admin: `admin` / `P@ssw0rd123$`
- Maker: `maker3.bjj` / `12345` (SID=0004, Dept 0127 IT Risk Management)
- Checker: `checker3.bjj` / `P@ssw0rd123$` (SID=0003)
- Approver: `approver3.bjj` / `P@ssw0rd123$` (SID=0002)
- ⚠️ Final approver flow butuh SID=0024 (Hendra Budiawan) — kredensial tidak tersedia

**Modules:** RCSA, KRI/KORI, LED, Action Plan, Risk Evaluation, Dashboard, Reports — total 280+ tabel

**Status QA per 2026-05-11:**
- **53 bugs found** — 10 critical production blockers
- **Production Readiness:** 25/100 — NOT READY
- **Reports:** Lihat `reference_orms_qa_reports.md`

**Top Critical Issues:**
1. **W-9/W-25/W-28:** Save platform-wide silent failure di RCSA/KRI/LED master save (empty catch swallowing exception)
2. **W-22:** Stack trace exposed exposing server path (CWE-209 information disclosure)
3. **W-23:** `clsGeneral.AppConnString` static = race condition multi-tenant
4. **W-3:** Identical password hash admin+checker+approver tanpa salt
5. **W-1:** Ext.NET PasswordMask plugin breaks form submission + automation + accessibility

**QA_TEST Data Need Cleanup:**
- MSRISKTYPEC: ID=`0020` (`QA_TEST_RiskType_Operational`)
- TRREGRISKHDRC: `BSQ-ITRM-OPS-2026050002`
- TRFLOWC + TRREGNOTIFLOGC: orphan records untuk risk tsb
- Cleanup SQL ada di `QA_ORMS_Workflow.md` section 7.4

**Workflow Engine Hidden Complexity:**
User mengira flow Maker→Checker→Approver (3 stage). Sebenarnya 4 stage: Maker→Checker→Approver1→Approver2 (Hendra SID 0024 di Level 2). FlowId 0015, FormId 0001.
