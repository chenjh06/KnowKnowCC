# 文档审查发现 — 待修复清单

**审查日期**: 2026-03-28
**状态**: 待修复
**关联 MEMORY**: 见 memory/audit-findings.md

---

## 修复进度

- [x] P0-prev: managed-settings.md 内容质量修复（优先级/投递机制/路径等）
- [x] P0-prev: README 无效链接修复
- [x] P0: 创建 guide/README.md
- [x] P0: 创建 advanced/a-productivity/README.md
- [x] P1: advanced/d-skills-development/ 缺失文件标记为"⏳ 计划中"
- [x] P2: advanced/ 下引用 master/ 的路径修正（6处）
- [x] P3: 根目录路径错误（4处）
- [x] P4: 文件名拼写错误（4处）
- [x] P5: 指向不存在文件的链接（3处，改为内部/官方链接）
- [x] P6: NEW-FEATURES-GUIDE 路径修正（3处）
- [x] P7: 路径层级过多（3处）

---

## 详细清单

### P0: 缺失 README 文件

#### guide/README.md（被5处引用）
```
advanced/README.md:7       → ../guide/README.md
advanced/README.md:380     → ../guide/README.md
master/README.md:375       → ../guide/README.md
README.md:33               → ./guide/README.md
windows/README.md:351      → ../guide/README.md
```
**修复方案**: 创建 guide/README.md，参考 advanced/README.md 的格式

#### advanced/a-productivity/README.md（被3处引用）
```
advanced/README.md:88      → ./a-productivity/README.md
advanced/README.md:366     → ./a-productivity/README.md
windows/01-getting-started.md:1024 → ../advanced/a-productivity/README.md
```
**修复方案**: 创建该 README，参考 b-code-quality/README.md 格式

---

### P1: 缺失内容文件（advanced/d-skills-development/）

以下4个文件在 guide/05-skills-quickstart.md 和 d-skills 内部被引用但不存在：
- 02-practical-skills.md
- 03-advanced-features.md
- 04-deployment-distribution.md
- 05-testing-validation.md

**受影响引用（11处）**:
```
guide/05-skills-quickstart.md:559,975    → 04-deployment-distribution.md
guide/05-skills-quickstart.md:1053       → 02-practical-skills.md
guide/05-skills-quickstart.md:1054       → 03-advanced-features.md
guide/05-skills-quickstart.md:1055       → 04-deployment-distribution.md
guide/05-skills-quickstart.md:1056       → 05-testing-validation.md
d-skills/01-skill-fundamentals.md:1829   → 03-advanced-features.md
d-skills/01-skill-fundamentals.md:2574   → 02-practical-skills.md
d-skills/01-skill-fundamentals.md:2738   → 02-practical-skills.md
d-skills/01-skill-fundamentals.md:2820   → 02-practical-skills.md
d-skills/06-skills-best-practices.md:1277→ 02-practical-skills.md
d-skills/README.md:581,603               → master/04-skills-mastery/README.md（目录不存在）
```
**修复方案**: 先标记为"计划中"，后续创建内容

---

### P2: 跨目录路径错误（advanced/ 引用 master/）

advanced/ 下的文件用 `../01-customization/` 等路径，实际应为 `../../master/01-customization/`。

| 文件 | 行号 | 错误链接 | 正确路径 |
|------|------|---------|---------|
| advanced/c-integration/01-mcp-servers.md | 3119 | `../01-customization/README.md` | `../../master/01-customization/README.md` |
| advanced/c-integration/02-obsidian-integration.md | 3261 | `../01-customization/README.md` | `../../master/01-customization/README.md` |
| advanced/c-integration/03-browser-automation.md | 1422 | `../01-customization/README.md` | `../../master/01-customization/README.md` |
| advanced/c-integration/03-browser-automation.md | 1423 | `../02-automation/README.md` | `../../master/02-automation/README.md` |
| advanced/c-integration/03-browser-automation.md | 1424 | `../03-advanced-topics/README.md` | `../../master/03-advanced-topics/README.md` |
| advanced/b-code-quality/04-code-review.md | 2513 | `../01-customization/README.md` | `../../master/01-customization/README.md` |

---

### P3: 根目录文件路径错误

| 文件 | 行号 | 错误链接 | 正确路径 |
|------|------|---------|---------|
| CLAUDE.md | 67 | `../guide/01-quickstart.md` | `./guide/01-quickstart.md` |
| CHANGELOG.md | 336 | `./advanced/NEW-FEATURES-GUIDE-v2.1.84.md` | 文件不存在（有v2.1和v2.1.85） |
| reference/README.md | 72,97 | `./changelog.md` | `../CHANGELOG.md` |
| reference/README.md | 326 | `../../modules-archive/...` | 目录不存在，删除 |

---

### P4: 文件名拼写错误

| 文件 | 行号 | 错误链接 | 正确文件名 |
|------|------|---------|-----------|
| master/02-automation/02-ci-cd-integration.md | 1303 | `./01-headless.md` | `./01-headless-mode.md` |
| master/03-advanced-topics/README.md | 77 | `./04-security-models.md` | `./04-security-best-practices.md` |

---

### P5: 指向不存在的文件

| 文件 | 行号 | 无效链接 |
|------|------|---------|
| advanced/c-integration/01-mcp-servers.md | 908 | `../../Obsidian知识库集成完整方案.md` |
| advanced/d-skills-development/01-skill-fundamentals.md | 2575 | `../../Claude-Code-Skills-官方文档整理.md` |
| advanced/d-skills-development/README.md | 582 | `../../Claude-Code-Skills-官方文档整理.md` |
| advanced/a-productivity/05-agent-teams.md | 1003 | `./06-automated-workflows.md` |

---

### P6: NEW-FEATURES-GUIDE-v2.1.md 路径修正

| 行号 | 错误链接 | 正确路径 |
|------|---------|---------|
| 540 | `../a-productivity/02-session-management.md` | `./a-productivity/02-session-management.md` |
| 541 | `../c-integration/04-practical-cases.md` | `./c-integration/04-practical-cases.md` |
| 542 | `../../windows/04-troubleshooting.md` | `../windows/04-troubleshooting.md` |

---

### P7: 路径层级错误

| 文件 | 行号 | 错误链接 | 正确路径 |
|------|------|---------|---------|
| d-skills/01-skill-fundamentals.md | 2572 | `../../../guide/05-skills-quickstart.md` | `../../guide/05-skills-quickstart.md` |
| master/03-advanced-topics/03-performance.md | 1094 | `../windows/03-performance.md` | `../../windows/03-performance.md` |
| advanced/a-productivity/06-loop.md | 411 | `../07-voice.md` | `./07-voice.md` |
