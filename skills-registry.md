# Skills Registry

Daftar semua sumber skill yang diinstall. Update file ini setiap kali ada skill baru ditambahkan.

Untuk install skill di perangkat baru, clone masing-masing repo lalu copy isi folder `skills/` ke `~/.claude/skills/`.

---

## Marketplace Plugin (via Claude Code settings)

| Repo | Keterangan | Status |
|------|-----------|--------|
| [alirezarezvani/claude-skills](https://github.com/alirezarezvani/claude-skills) | Marketplace utama — engineering skills, devops, security, dll. Plugin ID: `engineering-skills@claude-code-skills` | ✅ Installed |

> Install via `settings.json` → `enabledPlugins` + `extraKnownMarketplaces` (sudah tersimpan di repo ini)

---

## Manual Skills (copy ke `~/.claude/skills/`)

| Repo | Cari / Folder | Keterangan | Status |
|------|--------------|-----------|--------|
| [kostja94/marketing-skills](https://github.com/kostja94/marketing-skills) | folder `skills/` | Marketing skills | ✅ Installed |
| [coreyhaines31/marketingskills](https://github.com/coreyhaines31/marketingskills) | folder `skills/` | Marketing skills (alternatif) | ✅ Installed |
| [AgriciDaniel/claude-seo](https://github.com/AgriciDaniel/claude-seo) | folder `skills/` | SEO skills | ✅ Installed |
| [zubair-trabzada/geo-seo-claude-skills](https://github.com/zubair-trabzada/geo-seo-claude-skills) | folder `skills/` | Geo + SEO skills | ✅ Installed |
| [nexu-io/open-design](https://github.com/nexu-io/open-design) | folder `skills/` | Design skills | ✅ Installed |
| [ComposioHQ/awesome-claude-skills](https://github.com/ComposioHQ/awesome-claude-skills) | cari: `brand-build-skills` | Koleksi skills dari Composio | ✅ Installed |
| [garrytan/gstack](https://github.com/garrytan/gstack) | folder `skills/` | 23 skills dari CEO YC (CEO, Designer, Eng Manager, Release Manager, Doc Engineer, QA) | ✅ Installed |
| [garrytan/gbrain](https://github.com/garrytan/gbrain) | folder `skills/` | 34 skills Garry Tan (25 curated) | ✅ Installed |
| [Orchestra-Research/AI-Research-SKILLs](https://github.com/Orchestra-Research/AI-Research-SKILLs) | folder `skills/` | AI Research skills | ✅ Installed |
| [VoltAgent/awesome-agent-skills](https://github.com/VoltAgent/awesome-agent-skills) | folder `skills/` | 1000+ agent skills kurasi komunitas | ✅ Installed |
| [Lum1104/Understand-Anything](https://github.com/Lum1104/Understand-Anything) | folder `skills/` | Understanding/analysis skills | ✅ Installed |

---

## Custom Skills (ada di repo ini)

| Skill | Path di repo | Keterangan |
|-------|-------------|-----------|
| notion-design | `custom-skills/notion-design/` | Design system skill untuk Notion — dark theme, Noto Sans Arabic, 4px grid |

> Setelah clone repo ini, symlink custom skills:
> ```powershell
> New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.claude\skills\notion-design" -Target "D:\claude-config\custom-skills\notion-design"
> ```

---

## Cara Tambah Skill Baru

Setiap kali install skill baru, minta Claude untuk update file ini:
> "Claude, saya baru install skill dari github.com/xxx/yyy, tolong tambahkan ke skills-registry.md dan push ke GitHub"

Claude akan tambahkan entri baru di tabel yang sesuai dan push otomatis.

---

## Cara Install Ulang di Perangkat Baru

```powershell
# Clone semua skill repos dan copy ke ~/.claude/skills/
$skillRepos = @(
    "kostja94/marketing-skills",
    "coreyhaines31/marketingskills",
    "AgriciDaniel/claude-seo",
    "zubair-trabzada/geo-seo-claude-skills",
    "nexu-io/open-design",
    "ComposioHQ/awesome-claude-skills",
    "garrytan/gstack",
    "garrytan/gbrain",
    "Orchestra-Research/AI-Research-SKILLs",
    "VoltAgent/awesome-agent-skills",
    "Lum1104/Understand-Anything"
)

$tempDir = "$env:TEMP\claude-skills-install"
$skillsDir = "$env:USERPROFILE\.claude\skills"

foreach ($repo in $skillRepos) {
    $repoName = $repo.Split("/")[1]
    $cloneDir = "$tempDir\$repoName"
    Write-Host "Installing $repo..."
    git clone "https://github.com/$repo.git" $cloneDir --depth 1 --quiet
    if (Test-Path "$cloneDir\skills") {
        Copy-Item "$cloneDir\skills\*" $skillsDir -Recurse -Force
    }
}

Write-Host "Done! Restart Claude Code."
```
