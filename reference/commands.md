# Claude Code 命令速查手册

> **所有命令的快速参考 - 按功能分类，随时查阅**

**使用场景**:
- 忘记命令语法时快速查阅
- 查找特定功能的命令
- 复制命令示例直接使用

---

## 📋 目录

- [文件操作命令](#文件操作命令)
- [命令执行](#命令执行)
- [会话管理](#会话管理)
- [配置命令](#配置命令)
- [撤销操作](#撤销操作)
- [Plan 模式](#plan-模式)
- [项目初始化](#项目初始化)
- [斜杠命令](#斜杠命令)
- [Commands vs Skills 选择指南](#commands-vs-skills-选择指南)
- [搜索和查找](#搜索和查找)
- [Git 集成](#git-集成)
- [Windows 专属](#windows-专属)

---

## 文件操作命令

### @ 符号 - 引用文件/目录

**语法**：
```
@文件路径
@目录路径/
@文件模式
```

**示例**：

| 操作 | 命令 | 说明 |
|------|------|------|
| 引用单个文件 | `@README.md` | 读取文件内容作为上下文 |
| 引用目录 | `@src/components/` | 读取目录下所有文件 |
| 引用多个文件 | `@file1.js @file2.js` | 同时引用多个文件 |
| 文件模式 | `@*.test.js` | 引用所有匹配的文件 |
| 嵌套目录 | `@src/**/*.tsx` | 引用所有嵌套的 .tsx 文件 |

**Windows 路径格式**：
```powershell
# ✅ 推荐：正斜杠
@src/config.json
@C:/Projects/MyProject/src/utils

# ❌ 避免：单反斜杠
@src\config.json
```

### 读取文件

**语法**：
```
读取 <文件路径>
```

**示例**：
```
读取 package.json
读取 src/App.tsx
读取 .env
```

**与 @ 符号的区别**：
- 功能相同，`@` 是快捷方式
- `@file.txt` = `读取 file.txt`

### 查看文件

**语法**：
```
查看 <文件路径>
```

**示例**：
```
查看 config.json
查看 .gitignore
```

**用途**：快速预览文件内容

---

## 命令执行

### ! 符号 - 运行 Shell 命令

**语法**：
```
!命令 [参数]
```

**常用示例**：

| 操作 | 命令 | 说明 |
|------|------|------|
| 安装依赖 | `!npm install` | 安装 npm 包 |
| 运行测试 | `!npm test` | 运行测试套件 |
| 构建 | `!npm run build` | 执行构建脚本 |
| Git 状态 | `!git status` | 查看 Git 状态 |
| 列出文件 | `!ls -la` | 列出目录内容（macOS/Linux） |
| 列出文件 | `!dir` | 列出目录内容（Windows） |

**PowerShell 命令（Windows）**：
```powershell
# ✅ PowerShell 原生命令
!Get-ChildItem
!Get-Process
!Test-Path "C:/Projects"

# ✅ Git Bash / WSL
!ls -la
!pwd
!git status
```

**路径引号（包含空格时必须使用）**：
```powershell
!dir "C:/Program Files/MyApp"
!type "C:/Users/Name/file.txt"
```

### 连续执行多个命令

**语法**：
```
!命令1 && 命令2 && 命令3
```

**示例**：
```
!mkdir build && cd build && pwd
!npm install && npm run build && npm test
```

---

## 会话管理

### 启动带会话名的对话

**语法**：
```bash
claude --session <会话名>
```

**示例**：
```bash
claude --session my-project-session
claude --session ecommerce-feature-auth
```

### 会话命令

| 命令 | 说明 | 示例 |
|------|------|------|
| `/continue` | 继续上一个会话 | `/continue` |
| `/resume <name>` | 恢复指定会话（含后台会话，标记 `bg`，v2.1.144+） | `/resume my-project` |
| `/sessions` | 列出所有会话 | `/sessions` |
| `/save <name>` | 保存当前会话 | `/save backup-01` |

**会话存储位置（Windows）**：
```powershell
# 默认位置
$env:USERPROFILE\.claude\sessions

# 查看会话文件
Get-ChildItem $env:USERPROFILE\.claude\sessions
```

---

## 配置命令

### 设置配置

**语法**：
```bash
claude config set <key> <value>
```

**常用配置**：

| 配置项 | 命令 | 说明 |
|--------|------|------|
| API 密钥 | `claude config set api_key YOUR_KEY` | 设置 API 密钥 |
| 默认模型 | `claude config set model claude-sonnet-4-5-20250929` | 设置默认模型 |
| 输出样式 | `claude config set output_style engineer-professional` | 设置输出风格 |
| 温度 | `claude config set temperature 0.7` | 设置随机性（0-1） |

### 查看配置

**语法**：
```bash
claude config list
```

**输出示例**：
```
api_key: sk-ant-...
model: claude-sonnet-4-5-20250929
temperature: 0.7
output_style: engineer-professional
```

### 配置文件位置

**Windows**：
```powershell
# 配置目录
$env:USERPROFILE\.claude

# 配置文件
C:\Users\<YourName>\.claude\config.json
```

**macOS/Linux**：
```bash
# 配置目录
~/.claude

# 配置文件
~/.claude/config.json
```

---

## 撤销操作

### Esc 键 - 撤销上一次操作

**何时有效**：
- ✅ 创建文件
- ✅ 编辑文件
- ✅ 运行命令（某些配置下）
- ❌ 对话内容（无法撤销）

**使用方式**：
```
[操作后] 按 Esc 键
```

**连续撤销**：
```
按 1 次 Esc → 撤销最近 1 次操作
按 2 次 Esc → 撤销最近 2 次操作
按 3 次 Esc → 撤销最近 3 次操作
```

**Windows 终端兼容性**：
```powershell
# Windows Terminal / PowerShell
Esc 键正常工作

# 如果 Esc 键不响应：
# 设置 → 键盘 → 确保 Esc 键未绑定其他功能
```

---

## Plan 模式

### 进入 Plan 模式

**方式 1：快捷键（推荐）**
```
Shift + Tab
```

**方式 2：明确要求**
```
请先用 Plan 模式规划这个任务
```

### Plan 模式流程

```
1. 描述任务
   ↓
2. Claude 进入 Plan 模式
   ↓
3. 生成详细计划
   ↓
4. 你审查计划
   ↓
5. 确认 (yes) 或修改 (modify)
   ↓
6. 执行实施
```

**何时使用**：
- ✅ 大规模重构
- ✅ 多文件修改
- ✅ 架构调整
- ✅ 迁移/升级

**何时不使用**：
- ❌ 简单文件创建
- ❌ 单个函数修改
- ❌ 查询类任务

### ⚠️ Windows 用户注意（已知 Bug）

**问题**：
- Windows 2.1.3 版本中，`Shift+Tab` 可能无法切换到 Plan 模式
- 症状：只能切换到 Auto-accept 模式，Plan 模式缺失

**解决方案**：
- ✅ 使用 `/plan` 命令直接进入 Plan 模式
- ✅ 或明确要求："请先用 Plan 模式规划"
- ✅ 或等待版本更新修复

**Bug 详情**：
- GitHub Issue: [#17344](https://github.com/anthropics/claude-code/issues/17344)
- 影响版本：Claude Code 2.1.3 (Windows)
- 状态：已知问题，等待修复

**替代命令**：
```
/plan                    # 直接进入 Plan 模式
请规划这个任务            # 明确要求规划
```

---

## 项目初始化

### /init - 理解新项目

**语法**：
```
/init
```

**功能**：
- 分析项目结构
- 识别技术栈
- 检测包管理器
- 提供建议

**何时使用**：
- ✅ 接手新项目
- ✅ Clone 代码库后
- ✅ 第一次使用 Claude Code

**何时不使用**：
- ❌ 熟悉的项目
- ❌ 已经有 CLAUDE.md 的项目

### /init 输出示例

```
=== 项目概览 ===
类型：React + TypeScript 项目
构建工具：Vite
包管理器：npm
主要依赖：React 18, React Query, Zustand

=== 项目结构 ===
src/
├── components/      # React 组件
├── hooks/          # 自定义 Hooks
├── utils/          # 工具函数
└── App.tsx         # 入口文件

=== 建议 ===
1. 已检测到 package.json，可以开始开发
2. 建议创建 CLAUDE.md 说明项目规范
3. 已配置 TypeScript，保持类型安全
```

---

## 斜杠命令

斜杠命令（Slash Commands）用于快速执行特定操作和配置 Claude Code 行为。

### 会话管理命令

| 命令 | 说明 | 示例 |
|------|------|------|
| `/clear` | 清除对话历史 | `/clear` |
| `/continue` | 继续上一个会话 | `/continue` |
| `/resume <name>` | 恢复指定会话（含后台会话，标记 `bg`，v2.1.144+） | `/resume my-project` |
| `/sessions` | 列出所有会话 | `/sessions` |
| `/save <name>` | 保存当前会话 | `/save backup-01` |
| `/compact` | 压缩对话上下文 | `/compact` |
| `/export [file]` | 导出对话到文件 | `/export chat.md` |

### v2.1.71+ 循环任务命令

| 命令 | 说明 | 示例 |
|------|------|------|
| `/loop <interval> <task>` | 设置循环任务调度 | `/loop 5m check PR status` |

### v2.1.69+ 语音命令

| 命令 | 说明 | 示例 |
|------|------|------|
| `/voice` | 激活语音编程模式 | `/voice` |

### 诊断和帮助命令

| 命令 | 说明 | 示例 |
|------|------|------|
| `/help` | 获取使用帮助 | `/help` |
| `/doctor` | 诊断安装健康（按 `f` 自动修复） | `/doctor` |
| `/usage` | 统一用量面板（合并原 /cost 和 /stats，按模型/缓存命中细分） | `/usage` |
| `/cost` | `/usage` 的快捷入口（跳转到用量面板） | `/cost` |
| `/stats` | `/usage` 的快捷入口（跳转到统计标签） | `/stats` |
| `/usage-credits` | 查看 usage credits（原 `/extra-usage`，v2.1.144+） | `/usage-credits` |
| `/context` | 可视化上下文使用 | `/context` |
| `/release-notes` | 交互式选择版本查看更新日志 | `/release-notes` |
| `/feedback` | 反馈报告（可包含近 24h/7d 会话，v2.1.141+） | `/feedback` |
| `/team-onboarding` | 生成团队上手指南（基于本地 Claude Code 使用习惯） | `/team-onboarding` |
| `/proactive` | `/loop` 的别名，设置循环任务 | `/proactive 5m check status` |

### 模式控制命令

| 命令 | 说明 | 示例 |
|------|------|------|
| `/plan` | 进入 Plan 模式 | `/plan` |
| `/model` | 选择模型（仅当前会话生效）；按 `d` 设为新会话默认值（v2.1.144+） | `/model` |
| `/output-style [style]` | 设置输出风格 | `/output-style professional` |
| `/permissions` | 查看或更新权限 | `/permissions` |
| `/tui` | 切换渲染模式（如 `/tui fullscreen` 无闪烁） | `/tui fullscreen` |
| `/focus` | 切换焦点视图（仅显示 prompt + 工具摘要 + 最终回复） | `/focus` |
| `/effort` | 控制分析深度（默认 medium，API/Bedrock/Team/Enterprise 用户默认 high） | `/effort medium` |
| `/color` | 设置会话颜色标识 (v2.1.75) | `/color blue` |
| `--enable-auto-mode` | 启用 Auto Mode 自动模式 (v2.1.84) | `claude --enable-auto-mode` |

### 配置和管理命令

| 命令 | 说明 | 示例 |
|------|------|------|
| `/config` | 打开设置界面 | `/config` |
| `/theme` | 创建/切换自定义主题（`~/.claude/themes/`） | `/theme` |
| `/memory` | 编辑 CLAUDE.md 文件 | `/memory` |
| `/hooks` | 管理 hook 配置 | `/hooks` |
| `/plugin` | 管理插件（含依赖管理，v2.1.143+） | `/plugin` |
| `/agents` | 管理自定义 AI 子代理 | `/agents` |

### `claude agents` 后台会话命令 ✨ v2.1.142+

> **说明**: `claude agents` 支持 Dash 访问后台会话，可配置调度会话的默认参数。

```bash
# 启动 agents 仪表板
claude agents

# 指定工作目录范围
claude agents --cwd <path>              # 仅显示该目录的会话 (v2.1.141+)

# 配置调度会话默认参数 (v2.1.142+)
claude agents --add-dir ../libs
claude agents --settings ./settings.json
claude agents --mcp-config ./mcp.json
claude agents --plugin-dir ./plugins
claude agents --permission-mode auto
claude agents --model claude-sonnet-4-5-20250929
claude agents --effort high
claude agents --dangerously-skip-permissions
claude agents --json                     # 列出会话 JSON（脚本集成，v2.1.145+）
```

### `/bg` 后台化命令

> **v2.1.143+**: `/bg` 现在保留 `--mcp-config`、`--settings`、`--add-dir`、`--plugin-dir`、`--strict-mcp-config`、`--fallback-model` 标志，后台化会话在 respawn 后保持 MCP 服务器和设置。

```bash
# 后台化当前会话
/bg

# 后台化并附带自定义配置
/bg --mcp-config ./mcp.json --model opus
```

### MCP 服务器命令

| 命令 | 说明 | 示例 |
|------|------|------|
| `/mcp` | 管理 MCP 服务器连接 | `/mcp` |

### 远程和协作命令

| 命令 | 说明 | 示例 |
|------|------|------|
| `/remote-control` | 让当前会话可从 claude.ai 远程控制 (v2.1.79+) | `/remote-control` |
| `/rc` | `/remote-control` 的别名 | `/rc` |

### Bundled Skills（内置技能）

> **说明**: Bundled Skills 是随 Claude Code 附带的基于提示的技能，不是内置命令。它们给 Claude 详细的操作手册，让 Claude 用自己的工具编排工作。

| 命令 | 说明 | 示例 |
|------|------|------|
| `/code-review [effort]` | 审查最近更改的文件，检查代码复用、质量和效率问题并修复（原 `/simplify`，v2.1.146+ 重命名） | `/code-review high` |
| `/batch <instruction>` | 编排大规模并行变更。将工作分解为独立单元，每个在隔离 git worktree 中执行并开 PR | `/batch migrate from Solid to React` |

**`/code-review` vs `/batch` 区别**：

| 维度 | `/code-review` | `/batch` |
|------|-------------|----------|
| **目标** | 审查优化已有代码 | 大规模迁移/变更 |
| **范围** | 最近修改的文件 | 整个代码库 |
| **并行度** | 3 个审查代理 | 5-30 个独立单元 |
| **输出** | 直接修复 | 每个单元开 PR |
| **需要 Git** | 否 | 是 |
| **effort** | `/code-review high` | N/A |

> **历史**: v2.1.146 前 `/code-review` 名为 `/simplify`（旧名仍可用）。

### 其他命令

| 命令 | 说明 | 示例 |
|------|------|------|
| `/add-dir` | 添加额外工作目录 | `/add-dir ../libs` |
| `/bashes` | 列出和管理后台任务 | `/bashes` |
| `/bug` | 报告 bug | `/bug` |
| `/exit` | 退出 REPL | `/exit` |
| `/init` | 初始化项目 | `/init` |
| `/install-github-app` | 设置 GitHub Actions | `/install-github-app` |
| `/login` | 切换 Anthropic 账户 | `/login` |
| `/logout` | 登出账户 | `/logout` |
| `/ide` | 管理 IDE 集成 | `/ide` |
| `/pr-comments` | 查看 PR 评论 | `/pr-comments` |
| `/privacy-settings` | 查看隐私设置 | `/privacy-settings` |

**Windows 路径处理**：
```powershell
# 添加目录（使用正斜杠）
/add-dir "D:/Projects/shared-libs"
/add-dir "../libs"

# 查看会话
/sessions

# 保存会话
/save "feature-auth-v1"
```

**常见使用场景**：

```
1. 开始新项目
   /init                    # 初始化项目
   /save "project-name"      # 保存会话

2. 查看状态
   /cost                    # 查看 token 使用
   /context                 # 查看上下文使用
   /permissions             # 查看权限

3. 调整配置
   /model                   # 切换模型
   /output-style compact    # 设置输出风格
   /plan                    # 进入 Plan 模式

4. 问题诊断
   /doctor                  # 诊断问题
   /help                    # 获取帮助

5. 清理会话
   /compact                 # 压缩上下文
   /clear                   # 清除历史
   /export backup.md        # 导出对话
```

---

## Commands vs Skills 选择指南 ✨

> **验证状态**: ✅ 趋势已验证
> **内容来源**: 微信文章分析 (2026-01-23)
> **可信度**: 90%

### 背景说明

**重要演进**: Claude Code 的扩展方式正在从 Commands 向 Skills 迁移

```
传统路径:
Commands (斜杠命令)
    ↓
配置文件 (commands.json)
    ↓
固定逻辑执行

现代路径:
Skills (技能包)
    ↓
自然语言描述
    ↓
AI 智能执行
```

**为什么迁移到 Skills?**

| Commands | Skills |
|----------|--------|
| 固定逻辑 | 智能推理 |
| 需要配置代码 | 自然语言描述 |
| 上下文理解有限 | 完整上下文感知 |
| 难以组合 | 可自由组合 |
| 维护成本高 | 易于维护 |

### Slash Commands 的优势

**Slash Commands 仍然有它的优势:**

```
✅ 快速执行
   └─ 简单命令,立即响应

✅ 确定性高
   └─ 固定行为,可预测

✅ 系统级操作
   └─ /plan, /clear, /config 等

✅ 轻量级
   └─ 无需额外上下文
```

**适用场景:**

```
系统管理:
├─ /clear           # 清除对话
├─ /sessions        # 会话管理
├─ /config          # 配置设置
└─ /doctor          # 诊断问题

快速操作:
├─ /help            # 获取帮助
├─ /cost            # 查看成本
└─ /context         # 上下文信息
```

### Skills 的优势

**Skills 提供更强大的能力:**

```
✅ AI 驱动
   └─ 智能理解,灵活执行

✅ 上下文完整
   └─ 理解整个对话历史

✅ 可组合
   └─ 多 Skills 协同工作

✅ 易扩展
   └─ 自然语言添加新功能

✅ 易维护
   └─ 版本控制,持续迭代
```

**适用场景:**

```
复杂任务:
├─ 代码审查         # code-review Skill
├─ 文章生成         # article-copilot Skill
└─ PPT 制作         # pptx Skill

工作流:
├─ 自动提交         # auto-commit Skill
├─ 浏览器自动化     # agent-browser Skill
└─ 数据处理         #数据处理 Skills
```

### 如何选择?

#### 决策流程

```
需要执行任务
    ↓
是系统级操作?
YES → 使用 Slash Command ✅
NO  → 继续
    ↓
需要快速执行,无复杂逻辑?
YES → 使用 Slash Command ✅
NO  → 继续
    ↓
需要智能推理和上下文理解?
YES → 使用 Skills ✅
NO  → 使用 Slash Command
```

#### 具体建议

**使用 Slash Commands 当:**

```markdown
1. 系统管理操作
   /clear
   /sessions
   /config

2. 快速查看信息
   /cost
   /context
   /help

3. 模式切换
   /plan
   /model

4. 简单固定操作
   /export chat.md
   /compact
```

**使用 Skills 当:**

```markdown
1. 需要智能分析
   使用 auto-commit 分析代码变更
   使用 code-review 审查代码质量

2. 需要复杂工作流
   使用 agent-browser 自动化浏览器操作
   使用 pptx 生成演示文稿

3. 需要上下文理解
   使用 article-copilot 持续写作
   使用 obsidian-skills 管理知识库

4. 需要多步骤任务
   使用 planning-with-files 持久化计划
   使用 video-transcription 处理视频
```

### 迁移案例

#### 案例 1: Git 提交

**Slash Command 方式:**

```bash
# 传统 Commands 方式
!git add .
!git commit -m "固定提交信息"
```

**Skills 方式:**

```markdown
# 使用 auto-commit Skill
分析当前代码变更,生成规范的中文提交信息,自动提交

优势:
✅ 智能分析代码变更
✅ 生成有意义的提交信息
✅ 遵循提交规范
✅ 上下文完整理解
```

**对比:**

| 维度 | Command | Skills |
|------|---------|--------|
| 智能性 | ❌ 固定信息 | ✅ 分析代码 |
| 规范性 | ❌ 不一致 | ✅ 遵循规范 |
| 上下文 | ❌ 无 | ✅ 完整理解 |
| 维护性 | ❌ 需要修改 | ✅ 自动优化 |

#### 案例 2: 文档生成

**Slash Command 方式:**

```bash
# 传统方式
!pandoc input.md -o output.pdf
```

**Skills 方式:**

```markdown
# 使用 pptx Skill
使用 @pptx skill,根据这篇文章生成演示文稿,使用现代风格

优势:
✅ 智能内容组织
✅ 自动应用风格
✅ 格式优化
✅ 可迭代调整
```

### 混合使用策略

**最佳实践: Commands + Skills**

```
系统管理:
使用 Slash Commands
├─ /clear          # 清理会话
├─ /sessions       # 管理会话
└─ /config         # 配置设置

任务执行:
使用 Skills
├─ auto-commit     # 自动提交
├─ code-review     # 代码审查
└─ agent-browser   # 浏览器自动化

信息查看:
使用 Slash Commands
├─ /cost           # 查看成本
├─ /context        # 上下文信息
└─ /doctor         # 诊断状态
```

### 迁移指南

#### 从 Commands 迁移到 Skills

**Step 1: 识别可迁移的 Commands**

```markdown
迁移条件:
✅ 需要智能判断的任务
✅ 需要上下文理解的操作
✅ 需要灵活配置的功能
✅ 经常使用的复杂命令

不适合迁移:
❌ 系统级操作 (/clear, /config)
❌ 简单查看 (/cost, /help)
❌ 模式切换 (/plan, /model)
```

**Step 2: 创建 Skill 替代方案**

```markdown
1. 使用 skill-creator 创建 Skill
2. 将 Command 逻辑转为 SKILL.md
3. 添加智能判断和上下文理解
4. 测试和优化
```

**Step 3: 逐步迁移**

```markdown
1. 保留 Command (向后兼容)
2. 添加 Skill 替代方案
3. 文档说明推荐使用 Skill
4. 收集反馈
5. 逐步废弃 Command
```

### 未来展望

**趋势预测:**

```
2024: Commands 为主
    ↓
2025: Skills 崛起
    ↓
2026: Commands + Skills 并存
    ↓
未来: Skills 成为主流
```

**建议:**

```
✅ 新功能优先使用 Skills
✅ 复杂任务使用 Skills
✅ 系统操作保留 Commands
✅ 简单任务可保留 Commands
✅ 持续关注生态发展
```

### 相关资源

**Slash Commands 参考:**
- [官方斜杠命令文档](https://claude.ai/code/docs)
- [本命令速查表](#斜杠命令)

**Skills 参考:**
- [Skills 生态概览](../CLAUDE.md#skills-生态概览)
- [Skills 开发教程](../advanced/d-skills-development/README.md)

---

## 搜索和查找

### Grep - 搜索文件内容

**语法**：
```
搜索 <关键词>
grep <模式>
```

**示例**：

| 操作 | 命令 | 说明 |
|------|------|------|
| 搜索文本 | `搜索 TODO` | 在所有文件中搜索 TODO |
| 正则表达式 | `grep function\s+\w+` | 使用正则表达式搜索 |
| 忽略大小写 | `搜索 -i error` | 忽略大小写 |
| 指定文件类型 | `grep "import React" *.tsx` | 在 .tsx 文件中搜索 |

### Find - 查找文件

**语法**：
```
查找 <文件名>
```

**示例**：
```
查找 package.json
查找 *.config.js
查找 **/*.test.ts
```

---

## Git 集成

### 常用 Git 命令

| 操作 | 命令 | 说明 |
|------|------|------|
| 查看状态 | `!git status` | 查看工作区状态 |
| 查看日志 | `!git log --oneline -10` | 查看最近 10 条提交 |
| 创建提交 | `!git commit -m "message"` | 创建提交 |
| 查看分支 | `!git branch -a` | 查看所有分支 |
| 切换分支 | `!git checkout <branch>` | 切换分支 |

### Git 工作流

**完整工作流示例**：
```
# 1. 查看状态
!git status

# 2. 添加文件
!git add .

# 3. 创建提交
!git commit -m "feat: 添加用户认证功能"

# 4. 推送到远程
!git push origin feature/auth
```

---

## Windows 专属

### PowerShell 常用命令

| 操作 | PowerShell | 说明 |
|------|-----------|------|
| 列出文件 | `Get-ChildItem` | 等同于 `ls` |
| 创建目录 | `New-Item -ItemType Directory` | 等同于 `mkdir` |
| 删除文件 | `Remove-Item` | 等同于 `rm` |
| 复制文件 | `Copy-Item` | 等同于 `cp` |
| 移动文件 | `Move-Item` | 等同于 `mv` |
| 获取内容 | `Get-Content` | 等同于 `cat` |
| 测试路径 | `Test-Path` | 检查路径是否存在 |

### Windows 路径处理

**推荐格式**：
```powershell
# ✅ 正斜杠（推荐）
@src/config.json
@C:/Projects/MyProject/src/utils

# ✅ 双反斜杠（备选）
@src\\config.json
@C:\\Projects\\MyProject\\src\\utils

# ❌ 避免单反斜杠
@src\config.json  # 可能被误解
```

**驱动器路径**：
```powershell
# 引用其他驱动器的文件
@D:/Documents/file.txt
@E:/Projects/config.json
```

### 环境变量

**查看环境变量**：
```powershell
# 查看所有
$env:Path -split ';'

# 查看特定变量
$env:USERPROFILE
```

**设置环境变量**：
```powershell
# 临时设置（当前会话）
$env:MY_VAR = "value"

# 永久设置
[System.Environment]::SetEnvironmentVariable(
    'MY_VAR',
    'value',
    'User'
)
```

---

## 其他常用命令

### 帮助命令

| 命令 | 说明 |
|------|------|
| `claude --help` | 查看帮助信息 |
| `claude --version` | 查看版本信息 |

### 退出命令

| 命令 | 说明 |
|------|------|
| `exit` | 退出 Claude Code |
| `Ctrl + D` | 快速退出 |
| `Ctrl + C` | 中断当前操作 |

### 历史命令

| 命令 | 说明 |
|------|------|
| `Ctrl + R` | 搜索历史命令 |
| `上箭头` | 上一条命令 |
| `下箭头` | 下一条命令 |

---

## 命令组合使用示例

### 场景 1：接手新项目

```
1. /init                    # 了解项目
2. !npm install             # 安装依赖
3. @README.md               # 阅读文档
4. 创建 CLAUDE.md           # 记录项目规范
5. :session project-name    # 保存会话
```

### 场景 2：开发新功能

```
1. @requirements.md         # 引用需求文档
2. Shift+Tab                # 进入 Plan 模式
3. 审查并确认计划
4. 执行实施
5. !npm test                # 运行测试
6. Esc（如有问题）          # 撤销错误操作
```

### 场景 3：修复 Bug

```
1. @error.log               # 引用错误日志
2. @src/problematic.js      # 引用问题文件
3. 描述问题
4. Claude 定位并修复
5. !npm test                # 验证修复
```

### 场景 4：代码审查

```
1. @src/**/*.tsx           # 引用所有组件
2. "检查代码规范"
3. Claude 分析并提供建议
4. 根据建议修改
```

---

## 常见问题

### Q1: @符号和"读取"命令有什么区别？

**A**: 功能相同，@符号是快捷方式：
```
@file.txt        # 快捷方式
读取 file.txt     # 完整命令
```

### Q2: 可以引用多个文件吗？

**A**: 可以！
```
@file1.js @file2.js @file3.js 比较这三个文件的差异
```

### Q3: 文件太大怎么办？

**A**: Claude Code 会自动处理：
- 大文件只读取关键部分
- 建议先用 @ 引用，再说明重点关注哪部分

### Q4: 命令执行失败怎么办？

**A**: 检查以下几点：
1. 命令是否在 PATH 中
2. 是否需要管理员权限
3. 路径格式是否正确

### Q5: 如何查看命令历史？

**A**: 使用 Ctrl+R 搜索历史命令

### Q6: Esc 键不响应怎么办？

**A**: 检查：
1. 终端是否捕获了 Esc 键
2. 是否有其他程序占用
3. 尝试使用 `Ctrl + C` 中断

---

## 快速参考卡

### 必记的 10 个命令

| # | 命令 | 功能 | 频率 |
|---|------|------|------|
| 1 | `@file` | 引用文件 | ⭐⭐⭐⭐⭐ |
| 2 | `!command` | 运行命令 | ⭐⭐⭐⭐⭐ |
| 3 | `Esc` | 撤销操作 | ⭐⭐⭐⭐⭐ |
| 4 | `Shift+Tab` | Plan 模式 | ⭐⭐⭐⭐ |
| 5 | `/init` | 项目初始化 | ⭐⭐⭐⭐ |
| 6 | `/continue` | 继续会话 | ⭐⭐⭐⭐ |
| 7 | `/sessions` | 列出会话 | ⭐⭐⭐ |
| 8 | `Ctrl+R` | 历史搜索 | ⭐⭐⭐⭐ |
| 9 | `搜索 关键词` | 搜索内容 | ⭐⭐⭐⭐ |
| 10 | `查找 文件名` | 查找文件 | ⭐⭐⭐ |

### 常用组合

| 场景 | 命令组合 |
|------|---------|
| 快速查看 | `@file.txt` |
| 运行并查看 | `!npm test` |
| 撤销错误 | `Esc` |
| 规划任务 | `Shift+Tab` |
| 继续工作 | `/continue` |

---

## 相关资源

### 详细文档

- [guide/01-quickstart.md](../guide/01-quickstart.md) - 10分钟快速上手
- [guide/02-core-features.md](../guide/02-core-features.md) - 8个核心功能详解
- [advanced/a-productivity/01-plan-mode.md](../advanced/a-productivity/01-plan-mode.md) - Plan 模式深度指南

### 其他速查表

- [shortcuts.md](./shortcuts.md) - 快捷键速查
- [troubleshooting.md](./troubleshooting.md) - 问题诊断

---

**最后更新**: 2026-04-04
**版本**: v1.3
**验证状态**: ✅ 已基于官方文档验证（Claude Code v2.1.146）
