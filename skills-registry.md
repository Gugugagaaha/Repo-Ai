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
| [nexu-io/open-design](https://github.com/nexu-io/open-design) | folder `skills/` | Design skills | ✅ Installed |
| [ComposioHQ/awesome-claude-skills](https://github.com/ComposioHQ/awesome-claude-skills) | skills at repo root + `composio-skills/*` (864 per-app automation connectors) | Koleksi skills dari Composio | ✅ Installed |
| [garrytan/gstack](https://github.com/garrytan/gstack) | skills scattered at repo root (each `SKILL.md` in its own top-level folder, 59 total) | Skills dari CEO YC (CEO, Designer, Eng Manager, Release Manager, Doc Engineer, QA) | ✅ Installed |
| [garrytan/gbrain](https://github.com/garrytan/gbrain) | folder `skills/` | 34 skills Garry Tan (25 curated) | ✅ Installed |
| [Orchestra-Research/AI-Research-SKILLs](https://github.com/Orchestra-Research/AI-Research-SKILLs) | skills at repo root under numbered category folders (e.g. `01-model-architecture/litgpt`), no top-level `skills/` | AI Research skills | ✅ Installed |
| [Lum1104/Understand-Anything](https://github.com/Lum1104/Understand-Anything) | folder `understand-anything-plugin/skills/` | Understanding/analysis skills | ✅ Installed |

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
# Repos yang skill-nya ada di folder skills/ standar
$standardRepos = @(
    "kostja94/marketing-skills",
    "coreyhaines31/marketingskills",
    "AgriciDaniel/claude-seo",
    "nexu-io/open-design",
    "garrytan/gbrain"
)

# Repos yang skill-nya tersebar (setiap folder berisi SKILL.md, bukan di bawah skills/)
$scatteredRepos = @(
    "garrytan/gstack",
    "Orchestra-Research/AI-Research-SKILLs",
    "ComposioHQ/awesome-claude-skills"
)

# Repo dengan path skill custom
$customPathRepos = @{
    "Lum1104/Understand-Anything" = "understand-anything-plugin/skills"
}

$tempDir = "$env:TEMP\claude-skills-install"
$skillsDir = "$env:USERPROFILE\.claude\skills"

foreach ($repo in $standardRepos) {
    $repoName = $repo.Split("/")[1]
    $cloneDir = "$tempDir\$repoName"
    Write-Host "Installing $repo..."
    git clone "https://github.com/$repo.git" $cloneDir --depth 1 --quiet
    if (Test-Path "$cloneDir\skills") {
        Copy-Item "$cloneDir\skills\*" $skillsDir -Recurse -Force
    }
}

foreach ($repo in $scatteredRepos) {
    $repoName = $repo.Split("/")[1]
    $cloneDir = "$tempDir\$repoName"
    Write-Host "Installing $repo..."
    git clone "https://github.com/$repo.git" $cloneDir --depth 1 --quiet
    Get-ChildItem $cloneDir -Recurse -Filter "SKILL.md" | ForEach-Object {
        Copy-Item $_.Directory.FullName (Join-Path $skillsDir $_.Directory.Name) -Recurse -Force
    }
}

foreach ($repo in $customPathRepos.Keys) {
    $repoName = $repo.Split("/")[1]
    $cloneDir = "$tempDir\$repoName"
    $subPath = $customPathRepos[$repo]
    Write-Host "Installing $repo..."
    git clone "https://github.com/$repo.git" $cloneDir --depth 1 --quiet
    if (Test-Path "$cloneDir\$subPath") {
        Copy-Item "$cloneDir\$subPath\*" $skillsDir -Recurse -Force
    }
}

Write-Host "Done! Restart Claude Code."
```
