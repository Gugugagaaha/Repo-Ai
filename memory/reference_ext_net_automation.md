---
name: Ext.NET Form Automation Pattern (via gstack browse)
description: Gotchas + workaround untuk QA automation aplikasi berbasis Ext.NET (gstack/Playwright) — PasswordMask, dialog YES, combobox load, dll
type: reference
---

**Konteks:** Ext.NET 4.8.x widget library tidak follow standard HTML form behavior. Tools automation standar (Playwright, Selenium, gstack `fill`) bisa miss penting field values. Pattern di bawah ini reusable untuk QA app Ext.NET lain.

## Gotcha 1: PasswordMask Plugin Breaks `fill`

**Problem:** `ext:PasswordMask` plugin replace input value dengan dots (●) di DOM. Form submission kirim dots, bukan password asli.

**Workaround:**
```powershell
# JANGAN: $B fill '@e_password' '12345'  ← akan kirim password kosong
# LAKUKAN: pakai type event (trigger keydown listener PasswordMask)
$B click '@e_password'
$B type '12345'   # type per-char, trigger keydown
```

**Alternative via JS:**
```javascript
var pm = Ext.getCmp('txtPassword').plugins[0];
pm.hiddenField.value = '12345';  // direct set hidden field
```

## Gotcha 2: Combobox `setValue` Tidak Trigger Form Update

**Problem:** Setelah `cmb.setValue('0020')`, value Ext OK tapi DOM input tetap kosong di POST.

**Workaround:** Lookup field ID first, then setValue + force render:
```javascript
var c = Ext.ComponentQuery.query('combobox[fieldLabel*=RISK TYPE]')[0];
if (c) c.setValue('0020');
```

## Gotcha 3: MessageBox YES/NO Button Click

**Problem:** Ext.MessageBox dialog tidak punya `getDialog()` method, dan tombol "YES" tidak di-trigger via text matching.

**Workaround:**
```javascript
var btns = Ext.ComponentQuery.query('messagebox button[itemId=yes]');
if (btns[0] && !btns[0].hidden) {
  document.getElementById(btns[0].id + '-btnEl').click();
}
```

## Gotcha 4: Combobox Store Inspection

**Problem:** Saat QA negative scenarios, perlu tahu valid values combobox.

**Pattern:**
```javascript
var c = Ext.getCmp('cmbRiskType2');
JSON.stringify(c.getStore().getData().items.slice(0, 5).map(r => r.data))
```

## Gotcha 5: Refs Invalidated After Navigation

**Problem:** `@e1, @e2, ...` refs gstack invalidate setelah `goto` atau modal/popup open.

**Pattern:** Always `snapshot -i` ulang setelah:
- Navigation (goto)
- Modal open/close
- Iframe switch
- Background server restart

## Gotcha 6: Multi-Frame Pages

**Problem:** Aplikasi ASP.NET WebForms sering pakai iframe (`mainV2.aspx` di iframe). Refs di outer frame ≠ refs di inner frame.

**Pattern:**
```powershell
$B frame --url "mainV2.aspx"   # switch to iframe context
# ... do stuff ...
$B frame main                   # switch back to outer
```

## Gotcha 7: Notification Polling Re-Triggers

**Problem:** Notification popup auto-re-display setiap 10s (TaskManager interval) menghalangi form interaction.

**Workaround:** Close popup + invoke action via JS (bypass DOM click yang blocked overlay):
```javascript
var btn = Ext.ComponentQuery.query('button')[5];
btn.fireEvent('click', btn);
```

## Gotcha 8: AppConnString Static Race Condition

**Problem:** Some Ext.NET apps use static `AppConnString` set during page initialization. Direct URL navigation bypass init → save throws "ConnectionString property has not been initialized".

**Workaround:** Navigate via parent page (main aspx) first, lalu iframe redirect ke target form. Ensures session connection initialized.

---

**Tools setup di PC ini (2026-05-11):**
- `bun 1.3.13` installed at `C:\Users\USER\.bun\bin\bun.exe`
- gstack browse binary built at `D:\2. Office\5. Ai\Claude\.claude\skills\gstack\browse\dist\browse.exe`
- gstack screenshot output restricted ke `C:\Users\USER\AppData\Local\Temp` atau `D:\claude-config` (security policy)
