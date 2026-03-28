# 05 - Skills 快速入门

> **30分钟掌握 Claude Skills 的核心概念并创建第一个技能**

**阅读时间**: 30分钟
**难度**: ⭐⭐ 新手友好
**重要性**: ⭐⭐⭐⭐⭐
**前置要求**: [02-core-features.md](02-core-features.md)

> **📌 文档版本**: 基于 Claude Code v3.0
> **✅ 验证状态**: ✅ 已验证

---

## 目录

- [什么是 Skills](#什么是-skills)
- [Skills 的核心价值](#skills-的核心价值)
- [创建第一个 Skill - Hello World](#创建第一个-skill---hello-world)
- [SKILL.md 基础结构](#skillmd-基础结构)
- [三种部署方式](#三种部署方式)
- [实战案例 2：待办事项技能](#实战案例-2待办事项技能)
- [Windows 专属指南](#windows-专属指南)
- [常见问题](#常见问题)
- [下一步](#下一步)

---

## 什么是 Skills

### 定义

**Skills（技能）** 是扩展 Claude Code 功能的自定义指令集合。通过创建 `SKILL.md` 文件，你可以:

- ✅ 创建自定义斜杠命令（如 `/review`、`/deploy`、`/greet`）
- ✅ 让 Claude 自动学习并应用特定的工作流程
- ✅ 编码可重复的开发模式和最佳实践
- ✅ 提升团队协作效率

### 核心特性

#### 1. 自动发现

Claude 可以根据描述自动决定何时使用相关技能:

```
你: "帮我解释这段代码"
Claude: [自动激活 explain-code 技能]
```

#### 2. 手动调用

通过 `/skill-name` 直接触发:

```
你: "/deploy"
Claude: [执行部署技能]
```

#### 3. 可组合性

支持模板、示例、脚本等辅助文件:

```
.claude/advanced/deploy/
├── SKILL.md
├── templates/
├── scripts/
└── examples/
```

### Skills 的两种类型

#### 类型 1: 参考内容型

**目的**: 提供知识库供 Claude 在工作中应用

**场景**: 编码规范、API 设计模式、项目约定

**示例**:

```markdown
---
name: api-conventions
description: API 设计模式和规范
---

# API 设计规范

编写 API 端点时：
- 使用 RESTful 命名约定
- 返回一致的错误格式
- 包含请求验证
```

#### 类型 2: 任务型

**目的**: 提供特定任务的分步指令

**场景**: 部署应用、运行测试、代码审查

**示例**:

```markdown
---
name: deploy
description: 部署应用到生产环境
context: fork
disable-model-invocation: true
---

# 部署流程

1. 运行测试套件
2. 构建应用
3. 推送到部署目标
```

**关键区别**:

| 特性 | 参考内容型 | 任务型 |
|------|-----------|--------|
| 调用方式 | Claude 自动调用 | 用户手动调用 |
| 使用场景 | 提供知识和规范 | 执行具体任务 |
| 配置 | 默认设置 | `disable-model-invocation: true` |
| 示例 | API 规范、代码风格 | 部署、测试、审查 |

---

## Skills 的核心价值

### 1. 提升效率 2-3 倍

```
❌ 没有 Skills:
每次都要详细解释部署流程
→ 重复劳动
→ 容易遗漏步骤
→ 效率低下

✅ 有 Skills:
/deploy
→ Claude 自动执行标准流程
→ 一致性高
→ 效率提升 2-3 倍
```

### 2. 编码团队知识

```
团队成员的最佳实践 → Skills
→ 新成员快速上手
→ 保持代码风格一致
→ 减少代码审查时间
```

### 3. 自动化工作流程

```
复杂的多步骤任务 → 技能封装
→ 一条命令完成
→ 减少人为错误
→ 可重复执行
```

### 4. 降低学习成本

```
新人: "如何部署?"
老手: "/deploy"
→ Claude 展示完整流程
→ 新人边看边学
→ 快速掌握最佳实践
```

---

## 创建第一个 Skill - Hello World

> **⏱️ 预计时间**: 10分钟
> **🎯 目标**: 创建一个简单的问候技能 `/greet`

### 步骤 1: 创建技能目录

#### Windows (PowerShell)

```powershell
# 创建技能目录
mkdir "$env:USERPROFILE\.claude\skills\greet"

# 验证目录创建
Test-Path "$env:USERPROFILE\.claude\skills\greet"
# 输出: True
```

#### macOS / Linux

```bash
# 创建技能目录
mkdir -p ~/.claude/advanced/greet

# 验证目录创建
ls -la ~/.claude/advanced/greet
```

### 步骤 2: 编写 SKILL.md

创建文件 `~/.claude/advanced/greet/SKILL.md` (Windows: `%USERPROFILE%\.claude\skills\greet\SKILL.md`):

```markdown
---
name: greet
description: 向用户致以友好的问候，介绍 Claude Code 的能力
---

# 问候技能

当用户调用 /greet 时，执行以下操作：

1. **友好问候**: 使用热情友好的语气问候用户
2. **介绍能力**: 简要介绍 Claude Code 的 3 个核心能力
3. **提供帮助**: 询问用户今天想完成什么任务
4. **保持简洁**: 问候不超过 3 句话

## 示例输出

"你好！👋 我是 Claude Code，你的 AI 编程助手。我可以帮你编写代码、调试问题、重构项目，今天想完成什么任务？"
```

### 步骤 3: 测试技能

#### 方法 1: 手动调用

在 Claude Code 中输入:

```
/greet
```

**预期输出**:

```
你好！👋 我是 Claude Code，你的 AI 编程助手。
我可以帮你编写代码、调试问题、重构项目。
今天想完成什么任务？
```

#### 方法 2: 让 Claude 自动调用

```
你能打个招呼吗？
```

Claude 可能会自动激活 greet 技能（取决于描述的清晰度）。

### 步骤 4: 验证成功

**✅ 成功标志**:
- 输入 `/greet` 后看到友好的问候
- 问候包含自我介绍和提供帮助
- 输出简洁（不超过 3 句话）

**❌ 如果失败**:
- 检查 SKILL.md 文件路径是否正确
- 确认 YAML frontmatter 格式正确（`---` 包围）
- 重启 Claude Code
- 查看 [常见问题](#常见问题) 章节

---

## SKILL.md 基础结构

### 完整结构

```markdown
---
name: skill-name           # 必需：技能名称（调用时使用）
description: 技能描述      # 必需：告诉 Claude 何时使用
context: fork              # 可选：子代理运行模式
disable-model-invocation: true  # 可选：仅手动调用
allowed-tools:            # 可选：限制工具访问
  - Bash
  - Edit
---

# 技能内容

Markdown 格式的指令内容...
```

### 核心字段详解

#### 1. name（必需）

**作用**: 技能名称，用于手动调用

**格式**: 小写字母、连字符、数字

**示例**:
```yaml
---
name: deploy-production
name: code-review
name: test-generator
```

**命名规范**:
- ✅ `greet`、`deploy-staging`、`api-designer`
- ❌ `Greet`、`Deploy_Staging`、`API Designer`

#### 2. description（必需）

**作用**: 告诉 Claude 何时使用此技能

**关键要素**:
1. **功能描述**: 技能做什么
2. **触发场景**: 何时使用
3. **目标用户**: 谁会使用

**好的描述示例**:

```yaml
# ✅ 好的描述
description: 在用户要求部署应用到生产环境时使用，包括测试、构建、推送的完整流程

# ✅ 好的描述
description: 解释代码如何工作，使用视觉图表和类比，适合教学和代码审查

# ❌ 不好的描述
description: 部署技能  # 太模糊，Claude 不知道何时使用
```

#### 3. disable-model-invocation（可选）

**作用**: 控制 Claude 是否可以自动调用此技能

| 值 | 效果 | 适用场景 |
|---|------|---------|
| `false` 或不设置 | Claude 和你都可以调用 | 参考内容型技能 |
| `true` | 只能通过 `/skill-name` 调用 | 任务型技能 |

**示例**:

```yaml
# 参考内容型 - Claude 自动调用
---
name: api-conventions
description: API 设计规范
---

# 任务型 - 仅手动调用
---
name: deploy
description: 部署应用到生产环境
disable-model-invocation: true
---
```

#### 4. context（可选）

**作用**: 指定技能运行模式

| 值 | 效果 |
|---|------|
| 不设置 | 在当前会话运行 |
| `fork` | 在子代理中运行 |

**何时使用 `context: fork`**:
- 需要独立运行的任务
- 不想污染当前会话
- 需要限制工具访问

**示例**:

```yaml
---
name: deploy
description: 部署应用
context: fork
disable-model-invocation: true
allowed-tools:
  - Bash
---
```

#### 5. allowed-tools（可选）

**作用**: 限制技能可以使用的工具

**示例**:

```yaml
---
name: test-runner
description: 运行测试套件
allowed-tools:
  - Bash      # 允许运行测试
  - Read      # 允许读取文件
  - Write     # 允许写入文件
# 其他工具（Edit、Browser 等）不可用
---
```

**使用场景**:
- 安全敏感的操作（部署、删除）
- 只读任务（代码审查）
- 特定用途限制（测试运行）

### Markdown 内容部分

**作用**: Claude 遵循的指令

**最佳实践**:

```markdown
# 技能名称（可选）

## 背景/目标（可选）

简要说明技能的目的和适用场景。

## 步骤（必需）

1. **步骤 1**: 清晰的指令
2. **步骤 2**: 具体操作
3. **步骤 3**: 注意事项

## 示例（推荐）

展示预期的输出格式或结果。

## 注意事项（可选）

常见陷阱和解决方案。
```

---

## 三种部署方式

### 方式对比

| 部署方式 | 路径 | 作用域 | 适用场景 | 示例 |
|---------|------|--------|---------|------|
| **个人级** | `~/.claude/advanced/` | 仅当前用户 | 个人常用技能 | greet、todo |
| **项目级** | `.claude/advanced/` | 当前项目 | 项目特定技能 | api-conventions |
| **插件级** | npm 包 | 全局分发 | 团队共享、开源发布 | @company/skills |

### 方式 1: 个人级技能（推荐新手）

**路径**:
- Windows: `%USERPROFILE%\.claude\skills\`
- macOS/Linux: `~/.claude/advanced/`

**特点**:
- ✅ 仅对当前用户可用
- ✅ 不依赖项目
- ✅ 适合个人工作流

**创建步骤**:

```powershell
# Windows PowerShell
mkdir "$env:USERPROFILE\.claude\skills\my-skill"
New-Item -Path "$env:USERPROFILE\.claude\skills\my-skill\SKILL.md" -ItemType File
```

```bash
# macOS/Linux
mkdir -p ~/.claude/advanced/my-skill
touch ~/.claude/advanced/my-skill/SKILL.md
```

**验证**:

```powershell
# Windows
ls "$env:USERPROFILE\.claude\skills"
```

```bash
# macOS/Linux
ls ~/.claude/skills
```

### 方式 2: 项目级技能

**路径**: `.claude/advanced/`（项目根目录）

**特点**:
- ✅ 项目团队成员共享
- ✅ 通过 Git 版本控制
- ✅ 项目特定约定和规范

**创建步骤**:

```powershell
# Windows PowerShell
mkdir ".claude/advanced/project-conventions"
New-Item -Path ".claude/advanced/project-conventions/SKILL.md" -ItemType File
```

```bash
# macOS/Linux
mkdir -p .claude/advanced/project-conventions
touch .claude/advanced/project-conventions/SKILL.md
```

**推荐项目技能**:
- API 设计规范
- 代码风格指南
- 项目测试约定
- 部署流程

### 方式 3: 插件级技能（高级）

**用途**: 打包分发到 npm registry 或团队内部仓库

**特点**:
- ✅ 易于分发和安装
- ✅ 版本管理
- ✅ 企业级共享

**基本结构**:

```
@my-company/advanced/
├── package.json
├── README.md
└── advanced/
    ├── deploy/
    │   └── SKILL.md
    └── test/
        └── SKILL.md
```

**package.json 示例**:

```json
{
  "name": "@my-company/skills",
  "version": "1.0.0",
  "description": "公司内部 Claude Skills 集合",
  "keywords": ["claude-code", "skills"],
  "files": ["skills"]
}
```

**安装**:

```bash
# 从 npm 安装
npm install -g @my-company/skills

# 从 Git 安装
npm install -g git+https://github.com/my-company/skills.git
```

**详细说明**: 详见 [advanced/d-skills-development/04-deployment-distribution.md](../advanced/d-skills-development/04-deployment-distribution.md)

---

## 实战案例 2: 待办事项技能

> **⏱️ 预计时间**: 15分钟
> **🎯 目标**: 创建一个实用的待办事项管理技能

### 需求

创建一个 `/todo` 技能，帮助用户管理待办事项:

1. 添加待办事项
2. 列出所有待办事项
3. 标记完成
4. 删除待办事项

### 步骤 1: 创建技能目录

```powershell
# Windows
mkdir "$env:USERPROFILE\.claude\skills\todo"
```

```bash
# macOS/Linux
mkdir -p ~/.claude/advanced/todo
```

### 步骤 2: 编写 SKILL.md

创建文件 `~/.claude/advanced/todo/SKILL.md`:

```markdown
---
name: todo
description: 管理待办事项。支持添加、列表、完成、删除操作。使用简单的文本文件存储
---

# 待办事项管理技能

## 存储位置

待办事项存储在用户主目录的 `.todo.md` 文件中:
- Windows: `%USERPROFILE%\.todo.md`
- macOS/Linux: `~/.todo.md`

## 操作

### 添加待办事项

**语法**: `/todo add <任务描述>`

**示例**:
```
/todo add 完成 Claude Code Skills 教程
```

**操作**:
1. 读取 `.todo.md` 文件（如果存在）
2. 添加新任务到列表末尾
3. 使用格式: `- [ ] <任务描述>`
4. 保存文件

### 列出待办事项

**语法**: `/todo list`

**操作**:
1. 读取 `.todo.md` 文件
2. 以友好的格式显示所有待办事项
3. 统计总数和完成数

**输出格式**:
```
待办事项 (3 个任务，1 个完成):

- [x] 已完成的任务
- [ ] 未完成的任务 1
- [ ] 未完成的任务 2
```

### 标记完成

**语法**: `/todo complete <任务编号>`

**示例**:
```
/todo complete 2
```

**操作**:
1. 读取 `.todo.md` 文件
2. 将第 N 个未完成任务标记为完成（`[ ]` → `[x]`）
3. 保存文件

### 删除待办事项

**语法**: `/todo delete <任务编号>`

**示例**:
```
/todo delete 1
```

**操作**:
1. 读取 `.todo.md` 文件
2. 删除第 N 个任务
3. 保存文件

## 注意事项

- 任务编号从 1 开始
- 如果文件不存在，创建新文件
- 标记完成和删除操作会提示用户确认
```

### 步骤 3: 测试技能

#### 测试 1: 添加任务

```
/todo add 学习 Claude Code Skills
```

**预期结果**: 在 `.todo.md` 中看到 `- [ ] 学习 Claude Code Skills`

#### 测试 2: 列出任务

```
/todo list
```

**预期结果**: 显示所有待办事项

#### 测试 3: 标记完成

```
/todo complete 1
```

**预期结果**: 第一个任务从 `[ ]` 变为 `[x]`

### 验证成功

**✅ 成功标志**:
- 所有操作都能正确执行
- 文件 `.todo.md` 正确创建和更新
- 输出格式清晰友好

---

## Windows 专属指南

### PowerShell 环境

**检查 PowerShell 版本**:

```powershell
$PSVersionTable.PSVersion
# 推荐 7.2 或更高
```

**安装 PowerShell 7** (如果需要):

```powershell
winget install Microsoft.PowerShell
```

### Windows 路径处理

#### Claude Code Skills 中的路径

**✅ 推荐: 使用正斜杠**

```powershell
# SKILL.md 中使用
$env:USERPROFILE/.claude/advanced/
```

**⚠️ 备选: 双反斜杠**

```powershell
$env:USERPROFILE\\.claude\\skills\\
```

**❌ 避免: 单反斜杠**

```powershell
$env:USERPROFILE\.claude\skills\  # 可能出错
```

#### 环境变量

**常用环境变量**:

| 变量 | 说明 | 示例值 |
|------|------|--------|
| `$env:USERPROFILE` | 用户主目录 | `C:\Users\YourName` |
| `$env:HOME` | 主目录（非标准） | 可能未设置 |
| `$env:PATH` | 可执行文件路径 | 系统路径列表 |

**最佳实践**:

```powershell
# ✅ 使用 USERPROFILE
$env:USERPROFILE\.claude\skills

# ❌ 避免硬编码
C:\Users\YourName\.claude\skills
```

### 文件权限

**检查技能目录权限**:

```powershell
# 查看目录权限
Get-Acl "$env:USERPROFILE\.claude\skills" | Format-List
```

**解决权限问题**:

```powershell
# 以管理员身份运行 PowerShell
# 然后设置权限
icacls "$env:USERPROFILE\.claude\skills" /grant "$($env:USERNAME):(F)"
```

### Windows 特定问题

#### 问题 1: 技能不被识别

**症状**: 输入 `/skill-name` 无反应

**可能原因**:
1. 文件路径错误
2. 文件名不是 `SKILL.md`（大写）
3. YAML frontmatter 格式错误

**解决方案**:

```powershell
# 检查文件是否存在
Test-Path "$env:USERPROFILE\.claude\skills\your-skill\SKILL.md"

# 检查文件名（必须大写）
Get-ChildItem "$env:USERPROFILE\.claude\skills\your-skill\"

# 验证 YAML 格式（文件前 3 行应该是 ---）
Get-Content "$env:USERPROFILE\.claude\skills\your-skill\SKILL.md" -First 3
```

#### 问题 2: PowerShell 执行策略

**症状**: 无法运行脚本

**解决方案**:

```powershell
# 查看当前执行策略
Get-ExecutionPolicy

# 临时允许脚本执行
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

# 或以管理员身份运行
Set-ExecutionPolicy RemoteSigned
```

#### 问题 3: 中文编码问题

**症状**: 中文显示乱码

**解决方案**:

```powershell
# 设置输出编码为 UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$env:LANG = "zh_CN.UTF-8"

# 或在 PowerShell 7 中
$OutputEncoding = [System.Text.Encoding]::UTF8
```

---

## 常见问题

### Q1: Skills 和之前的斜杠命令有什么区别？

**A**:

**旧系统** (斜杠命令):
- 路径: `.claude/commands/review.md`
- 功能: 创建自定义命令
- 限制: 功能较简单

**新系统** (Skills):
- 路径: `.claude/advanced/review/SKILL.md`
- 功能: 命令 + 目录 + 配置 + 自动加载
- 优势: 更强大、更灵活

**兼容性**: 旧命令仍然可用，但推荐迁移到 Skills

### Q2: 我的技能为什么不自动激活？

**A**: 检查以下几点:

1. **描述是否清晰**:

```yaml
# ❌ 不清晰
description: 代码审查技能

# ✅ 清晰
description: 在用户要求进行代码审查、检查代码质量或询问"这段代码有什么问题?"时使用
```

2. **是否设置了 `disable-model-invocation: true`**:

```yaml
# 如果设置了这个，Claude 不会自动调用
disable-model-invocation: true

# 移除它或设置为 false
disable-model-invocation: false
```

3. **YAML 格式是否正确**:

```markdown
---
name: my-skill
description: 描述
---  # ← 必须有这行

# 内容开始
```

### Q3: 如何调试技能？

**A**: 使用以下方法:

**方法 1: 查看技能列表**

```
/context  # 查看加载的技能
```

**方法 2: 强制手动调用**

```
/your-skill-name  # 直接调用，绕过自动判断
```

**方法 3: 逐步测试描述**

尝试不同的描述，看哪个触发率更高:

```yaml
# 测试版本 1
description: 帮助管理待办事项

# 测试版本 2
description: 在用户要求添加、列出或完成待办事项时使用

# 测试版本 3
description: 管理待办事项。支持添加、列表、完成、删除操作。使用 /todo 触发
```

### Q4: 可以在技能中引用其他文件吗？

**A**: 可以！技能目录可以包含辅助文件:

```
.claude/advanced/deploy/
├── SKILL.md              # 主技能文件
├── templates/            # 模板文件
│   ├── deploy.yml.j2
│   └── k8s-config.yml.j2
├── scripts/              # 脚本文件
│   ├── deploy.sh
│   └── rollback.sh
└── examples/             # 示例文件
    └── deployment.yml
```

在 SKILL.md 中引用:

```markdown
## 部署流程

1. 使用 `templates/deploy.yml.j2` 生成配置
2. 运行 `scripts/deploy.sh` 执行部署
3. 参考 `examples/deployment.yml` 验证配置
```

### Q5: 如何分享技能给团队？

**A**: 三种方式:

**方式 1: 项目级技能** (推荐)

```bash
# 将技能放入项目的 .claude/advanced/
git add .claude/advanced/
git commit -m "Add team skills"
git push
```

团队成员拉取项目后自动可用。

**方式 2: 创建 npm 包**

详见 [advanced/d-skills-development/04-deployment-distribution.md](../advanced/d-skills-development/04-deployment-distribution.md)

**方式 3: 直接分享文件**

```bash
# 打包技能目录
zip -r my-skill.zip .claude/advanced/my-skill/

# 分发给团队成员，让他们解压到自己的技能目录
```

### Q6: 技能可以调用其他技能吗？

**A**: 不直接支持，但可以:

**方法 1: 在描述中提及**

```markdown
---
name: deploy-production
description: 部署到生产环境，会先运行测试套件
---

## 部署流程

1. 运行测试（参考 test-runner 技能）
2. 构建应用
3. 部署到生产环境
```

**方法 2: 组合技能**

创建一个"主技能"，在内容中引导用户使用其他技能:

```markdown
---
name: full-deploy
description: 完整的部署流程，包括测试、构建、部署、验证
---

## 完整部署流程

### 步骤 1: 测试
建议使用 /test-runner 运行完整测试套件

### 步骤 2: 构建
运行构建命令...

### 步骤 3: 部署
使用 /deploy-staging 或 /deploy-production

### 步骤 4: 验证
使用 /health-check 检查应用状态
```

---

## 下一步

### 完成检查清单

完成以下任务，表示掌握了 Level 1 Skills:

- [ ] 理解什么是 Skills 以及两种类型
- [ ] 知道 SKILL.md 的基本结构
- [ ] 成功创建了第一个 Skill (`/greet`)
- [ ] 理解核心 frontmatter 字段（name, description, disable-model-invocation）
- [ ] 理解三种部署方式的区别
- [ ] 创建了第二个实用 Skill (`/todo`)
- [ ] 能手动调用技能并看到结果
- [ ] 了解 Windows 特定问题和解决方案

### 继续学习

**Level 2: Skills 开发实战** → [advanced/d-skills-development/](../advanced/d-skills-development/README.md)

**学习路径**:
1. [01-skill-fundamentals.md](../advanced/d-skills-development/01-skill-fundamentals.md) - 基础概念深入
2. [02-practical-skills.md](../advanced/d-skills-development/02-practical-skills.md) - 5 个实战案例 ⏳ 计划中
3. [03-advanced-features.md](../advanced/d-skills-development/03-advanced-features.md) - 高级特性 ⏳ 计划中
4. [04-deployment-distribution.md](../advanced/d-skills-development/04-deployment-distribution.md) - 部署和分发 ⏳ 计划中
5. [05-testing-validation.md](../advanced/d-skills-development/05-testing-validation.md) - 测试和验证 ⏳ 计划中

**预计学习时间**: 4-6 周（系统学习）或 1-2 周（快速浏览）

**学完后能够**:
- ✅ 独立设计实用 Skills
- ✅ 创建 60+ 行复杂技能
- ✅ 使用高级特性（子代理、Hooks、工具限制）
- ✅ 优化技能触发率到 80%+
- ✅ 打包和发布技能包

---

## 总结

### 核心要点

1. **Skills = 可重复的指令集合**
   - 自定义斜杠命令
   - 自动或手动调用
   - 编码团队知识

2. **两种类型**
   - 参考内容型: 提供知识和规范
   - 任务型: 执行特定操作

3. **SKILL.md 结构**
   - YAML frontmatter: 配置
   - Markdown 内容: 指令

4. **三种部署方式**
   - 个人级: `~/.claude/advanced/`
   - 项目级: `.claude/advanced/`
   - 插件级: npm 包

### 实战成果

完成本教程后，你已经:
- ✅ 创建了 2 个可用的 Skills
- ✅ 理解了核心概念
- ✅ 掌握了基本结构
- ✅ 准备好进入 Level 2

### 下一步行动

**立即行动**:
1. 创建 1-2 个个人常用技能
2. 测试手动和自动调用
3. 优化描述以提高触发率

**本周目标**:
- 完成 Level 2 的基础文档
- 创建 3-5 个实用技能
- 分享给团队或社区

**持续改进**:
- 收集使用反馈
- 优化技能性能
- 探索高级特性

---

**最后更新**: 2026-02-04
**文档版本**: v1.0
**验证状态**: ✅ 已验证（Windows 11 + Claude Code v3.0）
**下一文档**: [advanced/d-skills-development/README.md](../advanced/d-skills-development/README.md)
