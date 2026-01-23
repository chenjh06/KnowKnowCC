# knowknowcc 项目 - AI 工作指南

**项目**: knowknowcc (看懂Claude Code)
**版本**: v3.0.0
**最后更新**: 2026-01-22
**当前状态**: Level 1-3 全部完成！✅ 新增 Skills 开发教学模块 D 类别

---

## 项目核心理念

**knowknowcc** 不是功能手册，而是精心设计的**学习体系**。

### 五大核心哲学

1. **少即是多** - 精选20%最核心内容，解决80%使用场景
2. **深度胜过广度** - 每个概念都讲透，原理+实践+案例
3. **由浅入深** - Level 1/2/3 三级体系，循序渐进
4. **实战导向** - 每个知识点都有真实案例和解决方案
5. **用户至上** - Windows 100%支持，多种学习路径

---

## 项目架构

### 三级知识体系

```
knowknowcc/
│
├── guide/          ← Level 1: 核心掌握（100% 完成 ✅）
│   └── 5个文档，50,000字，30+案例
│
├── skills/         ← Level 2: 进阶提升（100% 完成 ✅）
│   ├── a-productivity/  (生产力提升，4个文档)
│   ├── b-code-quality/  (代码质量，5个文档)
│   ├── c-integration/   (集成扩展，4个文档)
│   └── d-skills-development/ (Skills开发，6个文档+5个示例) ✨ 新增
│   └── 共17个文档，60,000+字，60+案例
│
├── master/         ← Level 3: 专家之道（100% 完成 ✅）
│   ├── 01-customization/ (自定义和扩展，4个文档)
│   ├── 02-automation/    (自动化和CI/CD，3个文档)
│   └── 03-advanced-topics/ (高级主题，4个文档)
│   └── 共16个文档，330,000字，40+案例
│
├── windows/        ← Windows 专属（100% 完成 ✅）
│   └── 4个文档，79,000字，10+案例
│
└── reference/      ← 快速参考（5% 框架完成 📋）
```

### 当前完成情况

| 级别 | 完成度 | 文档数 | 字数 | 状态 |
|------|--------|--------|------|------|
| Level 1 | 100% | 6 | ~60,000 | ✅ 完成 |
| Level 2 | 100% | 17 | ~230,000 | ✅ 完成 🎉 |
| Level 3 | 100% | 22 | ~430,000 | ✅ 完成 🎉 |
| Windows | 100% | 4 | ~79,000 | ✅ 完成 |
| Reference | 5% | 0 | - | 📋 框架 |

**总计**: 56个文档，~720,000字，140+案例，380+代码示例 ✨ 新增 Skills 开发模块

---

## 模块结构图

```mermaid
graph TD
    Root["<b>knowknowcc</b><br/>看懂Claude Code"]

    Root --> Guide["<b>guide/</b><br/>Level 1: 核心掌握<br/>✅ 100%"]
    Root --> Skills["<b>skills/</b><br/>Level 2: 进阶提升<br/>✅ 100%"]
    Root --> Master["<b>master/</b><br/>Level 3: 专家之道<br/>📋 5%"]
    Root --> Windows["<b>windows/</b><br/>Windows 专属<br/>📋 10%"]
    Root --> Reference["<b>reference/</b><br/>快速参考<br/>📋 5%"]

    Guide --> G1["00-introduction.md"]
    Guide --> G2["01-quickstart.md"]
    Guide --> G3["02-core-features.md"]
    Guide --> G4["03-first-project.md"]
    Guide --> G5["04-best-practices.md"]
    Guide --> G6["05-skills-quickstart.md"]

    Skills --> AProd["<b>a-productivity/</b><br/>生产力提升<br/>✅ 100%"]
    Skills --> BQuality["<b>b-code-quality/</b><br/>代码质量<br/>✅ 100%"]
    Skills --> CInteg["<b>c-integration/</b><br/>集成扩展<br/>✅ 100%"]
    Skills --> DSkills["<b>d-skills-development/</b><br/>Skills开发<br/>✅ 100% ✨"]

    AProd --> AP1["01-plan-mode.md"]
    AProd --> AP2["02-session-management.md"]
    AProd --> AP3["03-keyboard-shortcuts.md"]
    AProd --> AP4["04-context-optimization.md"]

    BQuality --> BQ1["01-claude-md-guide.md"]
    BQuality --> BQ2["02-prompt-engineering.md"]
    BQuality --> BQ3["03-subagents.md"]
    BQuality --> BQ4["04-code-review.md"]

    CInteg --> CI1["01-mcp-servers.md"]
    CInteg --> CI2["02-obsidian-integration.md"]
    CInteg --> CI3["03-browser-automation.md"]

    Master --> M1["<b>01-customization/</b><br/>自定义和扩展"]
    Master --> M2["<b>02-automation/</b><br/>自动化和CI/CD"]
    Master --> M3["<b>03-advanced-topics/</b><br/>高级主题"]

    Windows --> W1["01-getting-started.md"]
    Windows --> W2["02-path-handling.md"]
    Windows --> W3["03-performance.md"]
    Windows --> W4["04-troubleshooting.md"]

    Reference --> R1["commands.md"]
    Reference --> R2["shortcuts.md"]
    Reference --> R3["troubleshooting.md"]
    Reference --> R4["changelog.md"]

    click Guide "./guide/CLAUDE.md" "查看 guide 模块文档"
    click Skills "./skills/CLAUDE.md" "查看 skills 模块文档"
    click Master "./master/CLAUDE.md" "查看 master 模块文档"
    click Windows "./windows/CLAUDE.md" "查看 windows 模块文档"
    click Reference "./reference/CLAUDE.md" "查看 reference 模块文档"
```

---

## 模块索引

| 模块 | 路径 | 职责 | 完成度 | 入口文件 |
|------|------|------|--------|----------|
| **guide** | `guide/` | Level 1 核心掌握，新手入门 | ✅ 100% | [00-introduction.md](guide/00-introduction.md) |
| **skills** | `skills/` | Level 2 进阶提升，效率优化 | ✅ 100% | [README.md](skills/README.md) |
| ├─ a-productivity | `skills/a-productivity/` | 生产力提升技能 | ✅ 100% | [01-plan-mode.md](skills/a-productivity/01-plan-mode.md) |
| ├─ b-code-quality | `skills/b-code-quality/` | 代码质量提升 | ✅ 100% | [README.md](skills/b-code-quality/README.md) |
| ├─ c-integration | `skills/c-integration/` | 集成和扩展 | ✅ 100% | [README.md](skills/c-integration/README.md) |
| └─ d-skills-development | `skills/d-skills-development/` | Skills 开发教学 | ✅ 100% ✨ | [README.md](skills/d-skills-development/README.md) |
| **master** | `master/` | Level 3 专家之道，深度定制 | 📋 5% | [README.md](master/README.md) |
| **windows** | `windows/` | Windows 平台专属支持 | 📋 10% | [README.md](windows/README.md) |
| **reference** | `reference/` | 快速参考和速查表 | 📋 5% | [README.md](reference/README.md) |

---

## 运行与开发

### 快速开始

```bash
# 1. 了解项目
查看 README.md 获取项目概览

# 2. 选择学习路径
新手: guide/ → skills/ → master/
进阶: skills/ → 选择需要的技能
专家: master/ → 深入高级主题

# 3. Windows 用户
windows/ → 查看 Windows 专属指南

# 4. 遇到问题
reference/ → 快速查找解决方案
```

### 创建新文档

```bash
# 1. 确定位置
选择: guide/ 或 skills/ 或 master/

# 2. 遵循模板
包含: 概念、价值、方法、案例、Windows支持、FAQ

# 3. 质量检查
四维检查: 完整性、准确性、规范性、可读性

# 4. 验证信息
确保: 命令可运行、示例真实、链接有效
```

### 质量标准

每个文档必须满足：

- ✅ **完整性**: 是什么、为什么、如何使用、何时使用、注意什么
- ✅ **实战性**: 真实场景、完整流程、预期结果、常见问题
- ✅ **Windows支持**: 专门章节、PowerShell示例、路径说明
- ✅ **可验证性**: 验证标记、官方核对、实际测试
- ✅ **可读性**: 简洁明了、段落适中、逻辑清晰

---

## Skills 生态概览 ✨

> **验证状态**: ✅ 已验证
> **内容来源**: 微信文章分析 (2026-01-23)
> **可信度**: 95%

### 什么是 Skills？

**Skills** 是 Claude Code 的模块化能力扩展包，让 AI Agent 能够：

- 📦 处理特定领域的任务
- 🛠️ 使用专业工具和脚本
- 📋 遵循既定的工作流程
- 🔄 复用知识和经验

**核心价值**:

```
✅ 零代码开发
   - 用自然语言描述
   - 无需编程经验
   - 人人可创建

✅ 灵活性强
   - 突破预设限制
   - 应对边缘情况
   - 智能推理决策

✅ 易于维护
   - 版本控制友好
   - 模块化管理
   - 持续迭代
```

### Skills 生态系统

#### 官方 Skills

```
✅ skill-creator
   - 创建 Skills 的 Skill
   - 一键生成 Skill 框架
   - 自动优化 SKILL.md

✅ pdf
   - PDF 处理工具包
   - 提取、分析、转换

✅ brand-guidelines
   - 官方品牌设计规范
   - Anthropic 品牌标准

✅ pptx
   - PPT 生成工具
   - HTML 转 PPT

✅ obsidian-skills
   - Obsidian 官方集成包
   - 维护者：Obsidian CEO
```

#### 第三方 Skills（社区精选）

```
✅ agent-browser
   - 浏览器自动化
   - Token 消耗降低 90%
   - Vercel Labs 出品

✅ Context7
   - 技能搜索引擎
   - 24,000+ 技能
   - 快速安装使用

✅ article-copilot
   - 文章写作助手
   - 内容生成优化

✅ AI-Partner
   - 个性化 AI 伴侣
   - 学习助手
```

#### 使用场景

```
📚 知识管理
   └─ obsidian-skills（官方）
   └─ 智能笔记整理

✍️ 内容创作
   └─ pptx（PPT 生成）
   └─ article-copilot（写作）

🤖 自动化
   └─ agent-browser（浏览器）
   └─ 定时任务（工作流）

💼 开发支持
   └─ Context7（技能搜索）
   └─ code-review（代码审查）
```

### Skills vs 其他扩展方式

| 特性 | Skills | MCP | Commands |
|------|--------|-----|----------|
| **运行位置** | 本地或云端 | 本地或云端 | 本地 |
| **主要用途** | 封装工作流 | 外部服务调用 | 固定命令 |
| **开发难度** | ⭐⭐ 自然语言 | ⭐⭐⭐⭐⭐ 需要开发 | ⭐⭐⭐ 配置 |
| **灵活性** | ⭐⭐⭐⭐⭐ AI 推理 | ⭐⭐⭐ 中等 | ⭐ 低（固定） |
| **性能** | 依赖模型推理 | 可优化 | 快速 |

### 如何获取 Skills？

#### 官方渠道

```
1. GitHub 官方仓库
   https://github.com/anthropics/skills

2. skill-creator（推荐）
   使用 skill-creator skill
   自动安装和配置

3. skillsmp.com
   技能市场（社区）
```

#### 自主创建

```
1. 使用 skill-creator
2. 编写 SKILL.md
3. 测试优化
4. 分享发布
```

**详细教程**: 📚 [Skills 开发教学](skills/d-skills-development/)

### Skills 趋势洞察

> **基于社区实践分析** (2026-01-23)

#### 三大迁移趋势

**1. MCP → Skills**
```
Playwright MCP → agent-browser Skill
Search MCP → Context7 Skills
优势：Token 降低 90%，易用性提升
```

**2. Command → Skills**
```
git-commit Command → auto-commit Skill
所有 Commands 可转化为 Skills
优势：智能分析，上下文理解
```

**3. Workflow → Skills**
```
N8N Workflow → Skills
扣子 Workflow → Skills
优势：自然语言驱动，更灵活
```

#### 技术趋势

```
🌟 本地隐私 + AI 能力
   - 数据永远在你手里
   - 零上传、零外泄

💰 国产模型降低成本
   - GLM 4.7：54元/季
   - 性能相当，成本降低 85%

🚀 Skills 生态快速成熟
   - 社区贡献活跃
   - 官方持续更新
   - 工具链完善

🔄 持续创新实践
   - 新 Skills 不断涌现
   - 使用场景持续扩展
   - 最佳实践不断沉淀
```

### 11 个常用 Skills

> **基于社区实践总结** (2026-01-23)

| # | Skill | 功能 | 难度 | 推荐度 |
|---|-------|------|------|--------|
| 1 | 文章自动配图 | 自动生成插图 | ⭐⭐⭐ | ⭐⭐⭐⭐ |
| 2 | auto-commit | 自动 Git 提交 | ⭐⭐ | ⭐⭐⭐⭐⭐ |
| 3 | agent-browser | 浏览器自动化 | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| 4 | 小红书发布 | 自动发布内容 | ⭐⭐⭐ | ⭐⭐⭐ |
| 5 | planning-with-files | 持久化计划 | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| 6 | obsidian-skills | Obsidian 集成 | ⭐⭐ | ⭐⭐⭐⭐⭐ |
| 7 | 定时任务 | 定时执行 | ⭐⭐⭐ | ⭐⭐⭐ |
| 8 | Context7 | 技能搜索 | ⭐⭐ | ⭐⭐⭐⭐ |
| 9 | 视频转录字幕 | 视频处理 | ⭐⭐⭐ | ⭐⭐⭐⭐ |
| 10 | PPT 生成 | PPT 自动生成 | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| 11 | skill-creator | 创建 Skills | ⭐⭐ | ⭐⭐⭐⭐⭐ |

**详细教程**: 📚 [Skills 深度教程](skills/d-skills-development/06-skills-best-practices.md)

### 最佳实践

#### DO ✅

```
✅ 从简单 Skill 开始
✅ 保持 SKILL.md 简洁
✅ Scripts 代码优先
✅ 版本控制管理
✅ 遵循渐进式披露机制
✅ 添加验证标记
```

#### DON'T ❌

```
❌ 过度复杂化
❌ 忽略性能优化
❌ 硬编码动态内容
❌ 忽略用户体验
❌ 超出 5000 tokens 限制
```

### 相关资源

- **官方文档**: https://claude.ai/code/docs
- **GitHub**: https://github.com/anthropics/claude-code
- **Skills 教学**: [Skills 开发教学](skills/d-skills-development/)
- **社区分享**: skillsmp.com

---

## 测试策略

### 内容验证

- ✅ 所有命令经过测试
- ✅ 代码示例可运行
- ✅ Windows 示例在 PowerShell 7 验证
- ✅ 官方文档交叉核对

### 质量检查

- ✅ 四维质量检查（完整性、准确性、规范性、可读性）
- ✅ Windows 支持 100% 覆盖（已完成内容）
- ✅ 实战案例真实可运行
- ✅ 完整的故障排查章节

---

## 编码规范

### 文件命名

```
格式: XX-<descriptive-name>.md

✅ 好的命名:
01-plan-mode.md
02-session-management.md
03-browser-automation.md

❌ 避免:
feature1.md
PlanMode.md
plan-mode
```

### 路径处理

```markdown
# 文档内链接（使用相对路径）
[快速上手](../guide/01-quickstart.md)  ✅
[Plan模式](./01-plan-mode.md)          ✅

# ❌ 避免绝对路径
[快速上手](D:/Projects/knowknowcc/guide/01-quickstart.md)
```

### Windows 路径

```powershell
# ✅ 推荐：使用正斜杠
cd "D:/Projects/MyApp"

# ⚠️ 备选：双反斜杠
cd "D:\\Projects\\MyApp"

# ❌ 避免：单反斜杠
cd "D:\Projects\MyApp"
```

### 代码块语言标记

```markdown
# PowerShell
```powershell
Get-ChildItem
```

# Bash
```bash
ls -la
```

# TypeScript
```typescript
const x: string = "hello";
```
```

---

## AI 使用指引

### 项目定位

**knowknowcc** = **看懂Claude Code**

这是一个:
- 📖 **系统的学习指南**：从新手到专家的完整路径
- 🛠️ **实用的工具手册**：解决实际问题的方案集合
- 🚀 **效率提升引擎**：让 AI 成为得力助手
- 🤝 **协作的平台**：社区共建的知识库

### 核心工作原则

1. **中文优先**
   - 所有内容使用简体中文
   - 面向中文用户
   - 符合中文阅读习惯

2. **Windows优先**
   - 优先考虑 Windows 用户
   - 每个功能都有 Windows 说明
   - 提供 PowerShell 示例

3. **实战导向**
   - 优先创建可立即应用的内容
   - 每个知识点都有真实案例
   - 包含"坑"和解决方案

4. **质量优先**
   - 宁可内容少，也要保证质量
   - 每个知识点都讲透
   - 避免信息过载

5. **持续验证**
   - 添加验证标记
   - 保持内容准确性
   - 更新验证报告

### 常见任务

#### 查看项目当前状态
```
@PROJECT-STATUS.md（最新综合状态）
@PROJECT-SUMMARY.md（实施总结）
@README.md（项目总览）
```

#### 创建新内容
```
1. 确定文档位置（Level 1/2/3）
2. 遵循文档模板结构
3. 包含所有必需章节
4. 添加 Windows 支持
5. 添加验证标记
6. 四维质量检查
7. 验证技术信息
8. 更新进度文档
```

#### 质量检查清单
```
维度1: 内容完整性
- [ ] 概念说明（是什么、为什么）
- [ ] 使用方法（语法、参数、结果）
- [ ] 实战案例（≥2个，详细步骤）
- [ ] Windows专属（完整章节）
- [ ] 常见问题（≥6个，解决方案）

维度2: 技术准确性
- [ ] 所有命令已测试
- [ ] 代码示例可运行
- [ ] 路径格式正确
- [ ] 验证标记准确
- [ ] 官方文档已核对

维度3: 格式规范性
- [ ] 标题层级正确（H1 > H2 > H3）
- [ ] 代码块语言标记正确
- [ ] 列表格式一致（- 或 *）
- [ ] 表格对齐正确
- [ ] 链接有效可访问

维度4: 可读性
- [ ] 语言简洁，无废话
- [ ] 段落长度适中（<10行）
- [ ] 主动语态，直接说明
- [ ] 没有重复内容
- [ ] 逻辑流程清晰
```

---

## 变更记录 (Changelog)

### 2026-01-18

**新增**:
- ✨ 创建根级 CLAUDE.md AI 工作指南
- ✨ 添加 Mermaid 模块结构图
- ✨ 创建模块级 CLAUDE.md 文档
- ✨ 生成 .claude/index.json 索引文件

**更新**:
- 📝 完善项目架构说明
- 📝 添加模块索引表格
- 📝 补充运行和开发指南

### 2025-01-17

**重大里程碑**:
- 🎉 Level 2 进阶技能 100% 完成
- ✨ 新增 5 个技能文档（Obsidian、MCP、代码审查、浏览器自动化、README）
- 📊 总计 27 个文档，112,000 字

---

## 相关资源

### 项目文档
- [README.md](README.md) - 项目总入口
- [PROJECT-STATUS.md](PROJECT-STATUS.md) - 项目状态与未来规划
- [PROJECT-SUMMARY.md](PROJECT-SUMMARY.md) - 项目实施总结
- [CHANGELOG.md](CHANGELOG.md) - 版本更新日志

### 模块文档
- [guide/CLAUDE.md](guide/CLAUDE.md) - Level 1 模块指南
- [skills/CLAUDE.md](skills/CLAUDE.md) - Level 2 模块指南
- [master/CLAUDE.md](master/CLAUDE.md) - Level 3 模块指南
- [windows/CLAUDE.md](windows/CLAUDE.md) - Windows 模块指南
- [reference/CLAUDE.md](reference/CLAUDE.md) - 参考模块指南

### 官方资源
- [Claude Code 官网](https://claude.ai/code)
- [官方文档](https://claude.ai/code/docs)
- [MCP 协议](https://modelcontextprotocol.io)

---

**最后更新**: 2026-01-18
**项目版本**: v3.0.0
**维护者**: Nyxifer 和 Claude Code (GLM4.7版)
