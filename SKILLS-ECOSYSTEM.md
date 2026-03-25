# Skills 生态概览

> **📌 文档版本**: v3.5 + Agent Skills 开放标准
> **✅ 验证状态**: ✅ 已验证（2026-02-15）
> **🔄 最后更新**: 2026-02-15 - 同步 Claude Opus 4.6 重大功能
> **内容来源**: 官方文档 + 社区实践

---

## 什么是 Skills？

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

---

## Agent Skills 开放标准 ⭐ NEW

### 官方声明

**Claude Code Skills 现在遵循 Agent Skills 开放标准**：

```markdown
"Claude Code skills follow the Agent Skills open standard,
which works across multiple AI tools."
```

### 战略意义

**1. 跨工具兼容性**
- ✅ Skills 不再是 Claude Code 专属
- ✅ 可以在多个 AI 工具中使用相同的 Skill
- ✅ 标准化 = 生态系统爆发

**2. 社区生态**
- ✅ 社区 Skills 库将快速增长
- ✅ 可复用性大幅提升
- ✅ 跨平台 Skills 开发成为可能

**3. 开发价值**
- ✅ 一次开发，多平台使用
- ✅ 标准化的结构和配置
- ✅ 更广泛的适用范围

### 标准化内容

**统一的 SKILL.md 结构**：

```markdown
---
# YAML Frontmatter
name: skill-name
description: Standard description format
argument-hint: [param1] [param2]
allowed-tools: Read, Write
context: fork  # ⭐ NEW: Subagent 模式
agent: Explore # ⭐ NEW: Agent 类型
---

# Markdown Content
Standardized instructions...

## Dynamic Context ⭐ NEW
- Data: !`command`  # 动态上下文注入
```

**Claude Code 扩展功能**：
- 🔀 **Subagent 执行**：`context: fork` 在隔离环境中运行
- 💉 **动态上下文注入**：`!command` 预处理机制
- 🎯 **Agent 类型选择**：Explore、Plan、general-purpose
- 🛡️ **工具权限控制**：精细化的 `allowed-tools`

### 实际影响

**对现有项目**：
- ✅ 现有 Skills 继续有效
- ✅ 无需修改现有配置
- ✅ 自动符合新标准

**对未来开发**：
- ✅ 可以设计跨平台 Skills
- ✅ 参考标准化的最佳实践
- ✅ 贡献到社区生态

---

## Custom Slash Commands 合并说明 ⭐ NEW

### 官方变更

**Custom slash commands 已合并到 Skills**：

```markdown
"Custom slash commands have been merged into skills.
A file at .claude/commands/review.md and a skill at
.claude/skills/review/SKILL.md both create /review
and work the same way.

Your existing .claude/commands/ files keep working."
```

### 关键变化

**两种方式现在等价**：

```bash
# 方式 1: Commands（旧方式，仍然有效）
.claude/commands/
└── review.md

# 方式 2: Skills（新方式，推荐）
.claude/skills/
└── review/
    └── SKILL.md

# 两者都创建 /review 命令
/review  # ✅ 两种方式效果相同
```

### Skills 的额外优势

| 功能 | Commands | Skills |
|------|---------|--------|
| **创建 /command** | ✅ | ✅ |
| **Frontmatter 配置** | ✅ 有限 | ✅ 完整 |
| **Supporting files** | ❌ | ✅ 支持模板、示例、脚本 |
| **自动发现** | ❌ | ✅ Claude 可自动激活 |
| **Subagent 执行** | ❌ | ✅ `context: fork` |
| **动态上下文** | ❌ | ✅ `!command` 注入 |
| **工具限制** | ❌ | ✅ `allowed-tools` |

### 迁移建议

**推荐迁移到 Skills**：

```bash
# 步骤 1: 创建 Skills 目录
mkdir -p .claude/skills/review

# 步骤 2: 移动文件
mv .claude/commands/review.md .claude/skills/review/SKILL.md

# 步骤 3: 添加 frontmatter
---
name: review
description: 代码审查技能
---

# 原有内容...
```

**何时保留 Commands**：
- ⚠️ 简单的静态命令
- ⚠️ 不需要高级功能
- ⚠️ 快速原型测试

---

## Skills 新功能 ⭐ NEW

### 1. Subagent 执行模式 (`context: fork`)

**官方说明**：

```markdown
"Add `context: fork` to your frontmatter when you want a skill to run
in isolation. The skill content becomes the prompt that drives the
subagent. It won't have access to your conversation history."
```

**使用方法**：

```yaml
---
name: deep-research
description: Research a topic thoroughly
context: fork           # ⭐ 关键：启用 subagent 模式
agent: Explore          # ⭐ 指定 subagent 类型
allowed-tools: Read, Grep, Glob
---

Research $ARGUMENTS thoroughly:

1. Find relevant files using Glob and Grep
2. Read and analyze the code
3. Summarize findings with specific file references
```

**优势**：
- ✅ 上下文隔离（不污染主会话）
- ✅ 独立的工具权限
- ✅ 专注执行（减少干扰）

**适用场景**：
- ✅ 大规模代码库探索
- ✅ 批量只读分析
- ✅ 研究类任务

### 2. 动态上下文注入 (`!command`)

**官方说明**：

```markdown
"The `!`command` syntax runs shell commands before the skill content
is sent to Claude. The command output replaces the placeholder, so
Claude receives actual data, not the command itself.

This is preprocessing, not something Claude executes."
```

**使用方法**：

```yaml
---
name: pr-summary
description: Summarize changes in a pull request
allowed-tools: Bash(gh *)
---

## Pull request context

- PR diff: !`gh pr diff`
- PR comments: !`gh pr view --comments`
- Changed files: !`gh pr diff --name-only`

## Your task
Summarize this pull request...
```

**执行流程**：

```
1. Skill 被调用
2. 预处理执行（!command）
3. 命令输出替换占位符
4. 完整内容发送给 Claude
5. Claude 看到实际数据
```

**优势**：
- ✅ 实时数据获取
- ✅ 外部工具集成
- ✅ 简化提示词

**适用场景**：
- ✅ Git/GitHub 集成
- ✅ 系统信息获取
- ✅ 项目依赖分析

**详细教程**: 📚 [Skills 基础概念](advanced/d-skills-development/01-skill-fundamentals.md)

---

## Skills 生态系统

### 官方 Skills

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

### 第三方 Skills（社区精选）

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

### 使用场景

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

---

## Skills vs 其他扩展方式 ⭐ UPDATED

### 对比表格

| 特性 | Skills ⭐ | MCP | Commands ⚠️ |
|------|----------|-----|-------------|
| **运行位置** | 本地或云端 | 本地或云端 | 本地 |
| **主要用途** | 封装工作流 + 智能推理 | 外部服务调用 | 固定命令 |
| **开发难度** | ⭐⭐ 自然语言 | ⭐⭐⭐⭐⭐ 需要开发 | ⭐⭐⭐ 配置 |
| **灵活性** | ⭐⭐⭐⭐⭐ AI 推理 + Subagent | ⭐⭐⭐ 中等 | ⭐ 低（固定） |
| **Subagent 执行** | ✅ `context: fork` | ❌ | ❌ |
| **动态上下文** | ✅ `!command` | ❌ | ❌ |
| **Supporting Files** | ✅ 模板、示例、脚本 | ⚠️ 有限 | ❌ |
| **自动发现** | ✅ Claude 可自动激活 | ❌ | ❌ |
| **跨工具兼容** | ✅ Agent Skills 标准 | ❌ | ❌ |
| **状态** | 🟢 **推荐** | 🟡 特定场景 | 🟡 已合并到 Skills |

**重要更新**：
- ⚠️ **Commands 已合并到 Skills**：现有 Commands 继续工作，但推荐迁移到 Skills
- ⭐ **Skills 是首选**：功能最完整，灵活性最高

### 迁移趋势

**Commands → Skills**（官方推荐）：

```bash
# 所有 Commands 都可以迁移到 Skills
.claude/commands/review.md
    ↓
.claude/skills/review/SKILL.md

# 优势：
✅ Supporting files 支持
✅ Subagent 执行模式
✅ 动态上下文注入
✅ 自动发现和激活
```

---

## 如何获取 Skills？

### 官方渠道

```
1. GitHub 官方仓库
   https://github.com/anthropics/skills

2. skill-creator（推荐）
   使用 skill-creator skill
   自动安装和配置

3. skillsmp.com
   技能市场（社区）
```

### 自主创建

```
1. 使用 skill-creator
2. 编写 SKILL.md
3. 测试优化
4. 分享发布
```

**详细教程**: 📚 [Skills 开发教学](advanced/d-skills-development/)

---

## Skills 趋势洞察

> **基于社区实践分析** (2026-01-23)

### 三大迁移趋势

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

### 技术趋势

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

---

## 11 个常用 Skills

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

**详细教程**: 📚 [Skills 深度教程](advanced/d-skills-development/06-skills-best-practices.md)

---

## 最佳实践

### DO ✅

```
✅ 从简单 Skill 开始
✅ 保持 SKILL.md 简洁
✅ Scripts 代码优先
✅ 版本控制管理
✅ 遵循渐进式披露机制
✅ 添加验证标记
```

### DON'T ❌

```
❌ 过度复杂化
❌ 忽略性能优化
❌ 硬编码动态内容
❌ 忽略用户体验
❌ 超出 5000 tokens 限制
```

---

## 相关资源

- **官方文档**: https://claude.ai/code/docs
- **GitHub**: https://github.com/anthropics/claude-code
- **Skills 教学**: [Skills 开发教学](advanced/d-skills-development/)
- **社区分享**: skillsmp.com

---

**最后更新**: 2026-02-15
**文档版本**: v3.5 + Agent Skills 开放标准
**维护者**: Nyxifer 和他的 ClaudeCode (GLM4.7)

**重大更新**：
- ⭐ Agent Skills 开放标准（跨工具兼容）
- ⭐ Custom Slash Commands 合并到 Skills
- ⭐ Subagent 执行模式（`context: fork`）
- ⭐ 动态上下文注入（`!command`）
