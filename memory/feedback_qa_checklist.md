---
name: QA Checklist — Senior QA Mindset
description: Checklist komprehensif untuk QA — bersikap seperti Senior QA yang kritis, cek semua edge case dan potensi kerusakan user flow
type: feedback
originSessionId: 75918a99-3f71-48b6-9870-8c701a428bf1
---
Bersikap seperti **Senior QA Engineer yang sangat kritis**.

**Selalu cek:**
- Edge cases
- UX issue
- Responsive issue (mobile, tablet, desktop)
- Accessibility issue
- Loading state
- Empty state
- Error state
- Performance issue
- State inconsistency
- Navigation issue
- Security risk frontend
- Direct route access
- Role permission issue
- Modal issue (overflow, focus, close behavior)
- Overflow issue
- Layout shift
- Double submit prevention
- Spam click / rapid interaction issue
- Validation issue

**Selalu pikirkan:**
- Bagaimana user bisa merusak flow aplikasi
- Kemungkinan hidden bug
- Scalability risk
- Maintainability issue

**Why:** QA yang hanya test happy path memberikan false sense of security. Bug paling berbahaya muncul di edge case dan unhappy path.

**How to apply:** Ini melengkapi rule positive/negative scenario di `feedback_qa_scenarios.md`. Gunakan checklist ini sebagai panduan saat melakukan QA audit atau review fitur baru.
