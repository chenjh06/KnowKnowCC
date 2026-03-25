# 02 - Core Features - 11个核心功能详解

> **掌握20%最常用的功能，解决80%的使用场景**

**阅读时间**: 30分钟
**难度**: ⭐⭐ 初级
**前置要求**: 完成 [01-Quickstart](./01-quickstart.md)

> **📌 文档版本**: 基于 Claude Code v3.5 + Claude Opus 4.6
> **✅ 验证状态**: ✅ 已验证（2026-02-15）
> **🔄 最后更新**: 2026-02-15 - 同步 Claude Opus 4.6 重大功能

---

## 目录

- [功能概览](#功能概览)
- [1. @符号上下文](#1-符号上下文)
- [2. !命令执行](#2-命令执行)
- [3. CLAUDE.md项目上下文](#3-claudemd项目上下文)
- [4. Esc后悔药](#4-esc后悔药)
- [5. Plan模式基础](#5-plan模式基础)
- [6. 会话管理基础](#6-会话管理基础)
- [7. Ctrl+R历史](#7-ctrlr历史)
- [8. /init项目初始化](#8-init项目初始化)
- [9. Agent Teams多智能体协作](#9-agent-teams多智能体协作) ⭐ NEW
- [10. Effort控制与成本优化](#10-effort控制与成本优化) ⭐ NEW
- [11. 1M Token大规模上下文](#11-1m-token大规模上下文) ⭐ NEW
- [功能组合使用](#功能组合使用)

---

## 功能概览

### 为什么是这11个功能？

我们精选了**使用频率最高、价值最大**的核心功能，包括最新的 Claude Opus 4.6 特性：

| # | 功能 | 使用频率 | 价值 | 难度 | 版本 |
|---|------|---------|------|------|------|
| 1 | @符号上下文 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | 简单 | v1.0+ |
| 2 | !命令执行 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | 简单 | v1.0+ |
| 3 | CLAUDE.md | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | 中等 | v1.0+ |
| 4 | Esc后悔药 | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | 简单 | v1.0+ |
| 5 | Plan模式 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | 中等 | v1.0+ |
| 6 | 会话管理 | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | 简单 | v1.0+ |
| 7 | Ctrl+R | ⭐⭐⭐ | ⭐⭐⭐⭐ | 简单 | v1.0+ |
| 8 | /init | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | 简单 | v1.0+ |
| 9 | Agent Teams | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | 中等 | v3.5+ ⭐ |
| 10 | Effort控制 | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | 简单 | v3.5+ ⭐ |
| 11 | 1M Token | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | 中等 | v3.5+ ⭐ |

**学习策略**：
1. **立即掌握**：功能 1, 2, 4, 10（10分钟）
2. **重点学习**：功能 3, 5, 9（30分钟）
3. **进阶使用**：功能 11（大型项目必需）
4. **按需使用**：功能 6, 7, 8（随用随查）

**Claude Opus 4.6 新功能** 🔥：
- **Agent Teams**（功能9）：多智能体并行协作，效率提升10-20倍
- **Effort 控制**（功能10）：精准控制成本和质量平衡
- **1M Token**（功能11）：超大规模上下文，理解整个代码库

---

## 1. @符号上下文

### 概念说明

**@符号**让 Claude Code 直接读取文件或目录内容，作为对话的上下文。

**解决的问题**：
- ❌ 不需要手动复制粘贴代码
- ❌ 不需要描述"我的文件在哪里"
- ✅ 直接让 AI 看到完整内容

### 使用方法

#### 基本语法

```
@文件路径
@目录路径/
@文件模式
```

#### 实战案例

**案例 1：引用单个文件**

```
👤 你：@src/utils/helpers.js 解释这个文件中的 debounce 函数

🤖 Claude：
[读取文件]
[定位 debounce 函数]
[解释工作原理]
[提供使用示例]
```

**案例 2：引用目录**

```
👤 你：@src/components/ 分析所有 React 组件的结构

🤖 Claude：
[扫描目录]
[列出所有组件]
[分析组件关系]
[提供架构建议]
```

**案例 3：文件模式**

```
👤 你：@*.test.js 检查所有测试文件的命名规范

🤖 Claude：
[查找所有 .test.js 文件]
[检查命名一致性]
[报告不符合规范的文件]
```

### Windows 特别说明

**路径格式**：

```powershell
# ✅ 推荐格式
@src/config.json
@C:/Projects/MyProject/src/utils
@src/**/*.js

# ❌ 避免使用
@src\config.json           # 反斜杠可能被误解
@C:\Projects\MyProject\src # 反斜杠问题
```

**驱动器路径**：

```powershell
# 引用其他驱动器的文件
@D:/Documents/file.txt
@E:/Projects/config.json
```

### 常见问题

**Q: @符号和"读取"命令有什么区别？**

A: 功能相同，@符号是快捷方式：
```
@file.txt        # 快捷方式
读取 file.txt     # 完整命令
```

**Q: 可以引用多个文件吗？**

A: 可以！
```
@file1.js @file2.js @file3.js 比较这三个文件的差异
```

**Q: 文件太大怎么办？**

A: Claude Code 会自动处理：
- 大文件只读取关键部分
- 建议先用 @ 引用，再说明重点关注哪部分

---

## 2. !命令执行

### 概念说明

**!命令**让你在对话中直接运行 shell 命令，无需切换终端。

**解决的问题**：
- ✅ 无缝集成命令执行
- ✅ 查看命令结果
- ✅ 基于结果继续对话

### 使用方法

#### 基本语法

```
!命令 [参数]
```

#### 实战案例

**案例 1：安装依赖**

```
👤 你：!npm install lodash

🤖 Claude：
[执行 npm install lodash]
[显示安装进度]
[显示完成信息]

已成功安装 lodash@4.17.21
需要我更新 package.json 吗？
```

**案例 2：查看文件**

```
👤 你：!ls -la

🤖 Claude：
[执行 ls -la]
[显示目录内容]

total 24
drwxr-xr-x  5 user  staff   160 Jan 17 10:00 .
drwxr-xr-x  3 user  staff    96 Jan 17 09:00 ..
-rw-r--r--  1 user  staff  1024 Jan 17 10:00 package.json
```

**案例 3：Git 操作**

```
👤 你：!git status

🤖 Claude：
[显示 Git 状态]

On branch main
Changes not staged for commit:
  modified:   src/App.js

需要提交这些更改吗？
```

### Windows 特别说明

**PowerShell 命令**：

```powershell
# ✅ PowerShell 原生命令
!Get-ChildItem
!Get-Process
!Test-Path "C:/Projects"

# ✅ Unix 风格命令（Git Bash / WSL）
!ls -la
!pwd
!git status
```

**路径引号**：

```powershell
# 包含空格的路径必须用引号
!dir "C:/Program Files/MyApp"

# 使用正斜杠或双反斜杠
!type "C:/Users/Name/file.txt"
!type "C:\\Users\\Name\\file.txt"
```

### 常见问题

**Q: 命令执行失败怎么办？**

A: 检查以下几点：
1. 命令是否在 PATH 中
2. 是否需要管理员权限
3. 路径格式是否正确

**Q: 可以执行多个命令吗？**

A: 可以用 && 或 ; 连接：
```
!mkdir build && cd build && pwd
```

**Q: 如何查看命令历史？**

A: 使用 Ctrl+R（见功能7）

---

## 3. CLAUDE.md项目上下文

### 概念说明

**CLAUDE.md** 是项目的"说明书"，告诉 Claude Code 你的项目信息、技术栈、代码规范。

**解决的问题**：
- ✅ AI 理解你的项目架构
- ✅ 遵循你的代码风格
- ✅ 避免重复说明项目信息

### 使用方法

#### 文件位置

```
项目根目录/
└── .claude/
    └── CLAUDE.md
```

#### 模板结构

```markdown
# 项目说明

## 项目概述
[项目名称、目的、核心功能]

## 技术栈
- 前端：[框架、版本]
- 后端：[语言、框架]
- 数据库：[类型、版本]

## 代码规范
- 命名约定：[规则]
- 文件组织：[结构]
- 注释风格：[要求]

## 重要约定
- 不要修改的目录：[列表]
- 特殊配置说明：[说明]
- 测试要求：[要求]

## 开发工作流
1. [步骤1]
2. [步骤2]
3. [步骤3]
```

#### 实战案例

**案例：React 项目**

```markdown
# E-Commerce Dashboard

## 项目概述
电商后台管理系统，包含商品管理、订单处理、数据分析功能

## 技术栈
- React 18 + TypeScript
- Vite (构建工具)
- TailwindCSS (样式)
- React Query (数据获取)
- Zustand (状态管理)

## 代码规范
- 组件使用 PascalCase：UserProfile.tsx
- 工具函数使用 camelCase：formatDate.ts
- 常量使用 UPPER_SNAKE_CASE：API_BASE_URL
- 所有组件必须有 TypeScript 类型

## 重要约定
- src/api/ 目录的所有 API 函数必须添加错误处理
- components/ 目录按功能模块组织子目录
- 不要修改 core/ 目录，这是共享库
- 所有新组件必须添加单元测试

## API 规范
- 基础 URL：/api/v1
- 所有请求需要认证（除了 /auth/login）
- 错误格式：{ error: string, code: number }

## Git 工作流
- main 分支：生产环境
- develop 分支：开发环境
- feature/ 功能名：功能分支
- 提交信息格式：feat: 描述 或 fix: 描述
```

### Windows 特别说明

**文件创建（PowerShell）**：

```powershell
# 创建 .claude 目录
New-Item -ItemType Directory -Path .claude

# 创建 CLAUDE.md
New-Item -ItemType File -Path .claude/CLAUDE.md

# 编辑文件
notepad.exe .claude/CLAUDE.md
# 或
code .claude/CLAUDE.md
```

**路径引用**：

```markdown
# CLAUDE.md 中使用正斜杠
## 项目结构
- src/components/     # 组件目录
- src/utils/          # 工具函数
- C:/Projects/shared/ # 共享库
```

### 最佳实践

#### 1. 保持简洁

```markdown
❌ 太详细：
## 历史演变
本项目始于2020年，经历了3次重大重构...

✅ 简洁有效：
## 项目概述
电商后台管理系统 v2.0
```

#### 2. 聚焦约定

```markdown
✅ 好：
## 代码规范
- 组件命名：PascalCase
- 测试覆盖率：> 80%

❌ 差：
## 代码规范
（整个团队的编程手册）
```

#### 3. 及时更新

```
项目变更 → 更新 CLAUDE.md → Claude Code 理解最新架构
```

### 常见问题

**Q: CLAUDE.md 会影响性能吗？**

A: 不会，Claude Code 只在需要时读取。

**Q: 可以有多个上下文文件吗？**

A: 可以使用子目录：
```
.claude/
├── CLAUDE.md           # 主文件
├── frontend.md         # 前端专项
└── backend.md          # 后端专项
```

**Q: 敏感信息怎么办？**

A: 使用环境变量：
```markdown
## 环境配置
- API 密钥：从 .env 读取
- 数据库：使用环境变量 DB_HOST
```

---

## 4. Esc后悔药

### 概念说明

**Esc 键**可以撤销 Claude Code 的上一次操作，给你"后悔"的机会。

**解决的问题**：
- ✅ 鼓励探索和实验
- ✅ 快速恢复到之前状态
- ✅ 降低试错成本

### 使用方法

#### 何时有效

Esc 键可以撤销以下操作：
- ✅ 创建文件
- ✅ 编辑文件
- ✅ 运行命令（在某些配置下）
- ❌ 对话内容（无法撤销）

#### 实战案例

**案例 1：撤销文件创建**

```
👤 你：创建一个名为 config.json 的配置文件

🤖 Claude：
[创建 config.json]
✅ 已创建

👤 你：[按 Esc 键]

🤖 Claude：
已撤销：创建 config.json
```

**案例 2：连续撤销**

```
操作历史：
1. 创建 file1.js
2. 编辑 file2.js
3. 创建 file3.js

按 1 次 Esc → 撤销操作 3
按 2 次 Esc → 撤销操作 2
按 3 次 Esc → 撤销操作 1
```

### Windows 特别说明

**终端兼容性**：

```powershell
# Windows Terminal / PowerShell
Esc 键正常工作

# 某些终端可能需要配置：
# 设置 → 键盘 → 确保 Esc 键未绑定其他功能
```

### 最佳实践

#### 1. 勇于尝试

```
不用担心出错，有 Esc 键保护：
- 尝试新的重构方案
- 测试不熟悉的命令
- 实验不同的实现方式
```

#### 2. 结合 Git 使用

```
Claude Code 操作 → Git 提交 → 出问题 → Esc 撤销 → Git 恢复
```

### 常见问题

**Q: 可以撤销多久之前的操作？**

A: 只能撤销最近的一次操作。

**Q: Esc 键不响应怎么办？**

A: 检查：
1. 终端是否捕获了 Esc 键
2. 是否有其他程序占用
3. 尝试使用 `Ctrl + C` 中断

**Q: 如何查看可以撤销的操作？**

A: Claude Code 会在操作后显示"可撤销"提示。

---

## 5. Plan模式基础

### 概念说明

**Plan 模式**让 Claude Code 在执行前先制定计划，你确认后再实施。

**解决的问题**：
- ✅ 避免大范围误操作
- ✅ 理解 AI 的思路
- ✅ 逐步审查和调整

### 使用方法

#### 进入 Plan 模式

**方式 1：快捷键（推荐）**

```
Shift + Tab
```

**方式 2：明确要求**

```
请先用 Plan 模式规划这个任务
```

#### Plan 模式流程

```
1. 描述任务
   ↓
2. Claude 进入 Plan 模式
   ↓
3. 生成详细计划
   ↓
4. 你审查计划
   ↓
5. 确认或修改
   ↓
6. 执行实施
```

#### 实战案例

**案例：重构项目结构**

```
👤 你：[Shift + Tab] 将这个项目从 JavaScript 迁移到 TypeScript

🤖 Claude：
=== PLAN ===

目标：将 JavaScript 项目迁移到 TypeScript

步骤：
1. 安装 TypeScript 和类型定义
   - npm install --save-dev typescript @types/node @types/react
2. 初始化 tsconfig.json
   - 配置编译选项
3. 重命名文件：.js → .ts / .tsx
4. 添加类型注解
   - 从 entry 文件开始
   - 逐步处理依赖关系
5. 修复类型错误
6. 更新构建脚本

预计时间：30-60分钟

=== END PLAN ===

确认执行吗？(yes/no/modify)

👤 你：yes

🤖 Claude：
[开始执行计划...]
```

### Windows 特别说明

无特殊说明，所有平台行为一致。

### 最佳实践

#### 1. 何时使用 Plan 模式

```
✅ 推荐使用：
- 大规模重构
- 多文件修改
- 架构调整
- 迁移/升级

❌ 不需要使用：
- 简单文件创建
- 单个函数修改
- 查询类任务
```

#### 2. 审查计划

```
关注点：
1. 步骤完整性（是否遗漏重要步骤）
2. 执行顺序（是否合理）
3. 风险评估（是否有破坏性操作）
```

#### 3. 迭代优化

```
可以要求修改计划：
"修改计划，先处理核心模块"
"添加测试步骤"
"调整执行顺序"
```

### 与直接模式对比

| 维度 | Plan 模式 | 直接模式 |
|------|----------|---------|
| 适用场景 | 复杂任务 | 简单任务 |
| 安全性 | 高（先确认） | 中（直接执行） |
| 速度 | 慢（规划+执行） | 快（直接执行） |
| 控制力 | 高（逐步确认） | 低（一次性完成） |

### 常见问题

**Q: Plan 模式会额外收费吗？**

A: 会，因为规划过程也使用 Token。但能避免错误操作，总体更经济。

**Q: 可以在执行中回到 Plan 模式吗？**

A: 可以，随时按 `Shift + Tab`。

**Q: Plan 模式生成的计划可以保存吗？**

A: 会话中会保留，可以要求 Claude "重新显示计划"。

---

## 6. 会话管理基础

### 概念说明

**会话管理**让你保存、恢复、命名对话，实现长期协作。

**解决的问题**：
- ✅ 跨天继续工作
- ✅ 管理多个项目对话
- ✅ 保留重要对话历史

### 使用方法

#### 启动带会话名的对话

```bash
claude --session my-project-session
```

#### 会话命令

```
/continue        # 继续上一个会话
/resume <name>   # 恢复指定会话
/sessions        # 列出所有会话
/save <name>     # 保存当前会话
```

#### 实战案例

**案例 1：创建命名会话**

```bash
# 启动新会话
claude --session ecommerce-dashboard

# 进行对话...
👤 你：创建登录组件
🤖 Claude：[创建组件]

# 退出但保存会话
👤 你：exit
```

**案例 2：恢复会话**

```bash
# 第二天继续工作
claude --resume ecommerce-dashboard

# Claude 记得上下文
🤖 Claude：欢迎回来！上次我们创建了登录组件。

👤 你：继续创建注册组件
🤖 Claude：[创建注册组件，保持一致的代码风格]
```

### Windows 特别说明

**会话存储位置**：

```powershell
# 默认位置
$env:USERPROFILE\.claude\sessions

# 查看会话文件
Get-ChildItem $env:USERPROFILE\.claude\sessions
```

**会话命名**：

```powershell
# 使用描述性名称
claude --session "ecommerce-feature-auth"

# 包含日期
claude --session "project-2025-01-17"
```

### 最佳实践

#### 1. 会话命名策略

```
✅ 好的命名：
- project-name-feature
- client-name-task
- date-task-description

❌ 差的命名：
- session1
- temp
- test
```

#### 2. 定期清理

```
# 删除旧会话
claude --session cleanup-old
# 或手动删除会话文件
```

#### 3. 项目级别会话

```
项目根目录/
├── .claude/
│   ├── session-dev.md
│   ├── session-feature-auth.md
│   └── session-bugfix-123.md
```

### 常见问题

**Q: 会话会过期吗？**

A: 不会永久保存，建议定期备份重要内容到文档。

**Q: 可以导出会话吗？**

A: 可以要求 Claude "将本次对话总结为 Markdown 文档"。

**Q: 多个终端可以共享会话吗？**

A: 不建议，可能导致冲突。

---

## 7. Ctrl+R历史

### 概念说明

**Ctrl+R** 让你搜索和复用之前的命令和提示词。

**解决的问题**：
- ✅ 快速复用复杂提示词
- ✅ 查找历史命令
- ✅ 提升重复任务效率

### 使用方法

#### 基本操作

```
1. 按 Ctrl + R
2. 输入关键词
3. 选择匹配项
4. 按回车执行
```

#### 实战案例

**案例 1：复用提示词**

```
历史提示词：
"为所有 React 组件添加 PropTypes"

按 Ctrl+R → 输入 "PropTypes" → 选择并执行
```

**案例 2：查找命令**

```
历史命令：
npm run build:production
npm run test:watch
npm run lint:fix

按 Ctrl+R → 输入 "build" → 找到构建命令
```

### Windows 特别说明

**PowerShell 兼容**：

```powershell
# PowerShell 历史搜索
Ctrl+R  # 内置功能

# 查看所有历史
Get-History

# 搜索历史
Get-History | Where-Object {$_.CommandLine -like "*npm*"}
```

### 最佳实践

#### 1. 提示词模板化

```
常用提示词保存为"技能"：
"为当前函数编写单元测试，覆盖率>90%"
```

#### 2. 命令别名

```
复杂命令：
npm run build:production && npm run test:all

保存为脚本或使用 Ctrl+R 快速找到
```

### 常见问题

**Q: 历史记录保存多久？**

A: 取决于配置，默认保存较长时间。

**Q: 可以清除历史吗？**

A: 可以，具体方法取决于终端配置。

---

## 8. /init项目初始化

### 概念说明

**/init** 命令让 Claude Code 快速理解新项目。

**解决的问题**：
- ✅ 快速上手新项目
- ✅ 理解项目结构
- ✅ 识别技术栈

### 使用方法

#### 基本用法

```
/init
```

#### 实战案例

```
👤 你：[在新项目中]
/init

🤖 Claude：
正在分析项目...

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

=== END ===

准备就绪！有什么可以帮你的？
```

### Windows 特别说明

无特殊说明，所有平台行为一致。

### 最佳实践

#### 何时使用 /init

```
✅ 使用场景：
- 接手新项目
- Clone 代码库后
- 第一次使用 Claude Code

❌ 不需要：
- 熟悉的项目
- 已经有 CLAUDE.md 的项目
```

### 与 CLAUDE.md 的关系

```
/init        → 快速了解项目（一次性）
CLAUDE.md    → 持续指导开发（长期）
```

建议：运行 /init 后，根据结果创建 CLAUDE.md

---

## 9. Agent Teams多智能体协作 ⭐ NEW

### 官方说明

**Agent Teams** 是 Claude Opus 4.6 的重大新功能（2026-02-05 发布）：

```markdown
"You can now spin up multiple agents that work in parallel as a team
and coordinate autonomously—best for tasks that split into independent,
read-heavy work like codebase reviews."
```

### 概念说明

**Agent Teams** 让多个 AI 智能体同时工作，自主协调完成任务。

**解决的问题**：
- ✅ 大型任务并行处理（效率提升10-20倍）
- ✅ 多模块同时分析
- ✅ 自动协调和汇总
- ✅ 独立上下文，避免干扰

### 使用方法

#### 自动启动（推荐）

**最简单的方式**：直接描述需要并行处理的任务。

```
👤 你：审查整个项目，包括前端、后端、测试、文档

🤖 Claude Code：
[自动检测到多任务需求]
[启动 Agent Team]

Agent Team 分配：
├─ Agent 1: 审查前端代码
├─ Agent 2: 审查后端代码
├─ Agent 3: 审查测试覆盖率
└─ Agent 4: 审查文档完整性

[所有智能体并行工作，15-20 分钟]
[自动生成综合报告]
```

#### 手动触发

**明确要求使用 Agent Teams**：

```
👤 你：使用 Agent Teams 并行处理以下任务：
    1. 分析 src/frontend 的性能问题
    2. 审查 src/backend 的安全性
    3. 检查测试覆盖率

🤖 Claude Code：
[创建 3 个专门的智能体]
[并行执行分析]
[汇总结果]
```

### 实战案例

**案例 1：大型代码审查**

```
任务：审查 100+ 文件的项目

传统方式（单智能体）：
├─ 审查前端：1.5 小时
├─ 审查后端：1.5 小时
├─ 审查测试：1 小时
└─ 审查文档：0.5 小时
总计：4.5 小时

Agent Teams（多智能体）：
├─ Agent 1-4 并行工作
└─ 总时间：15-20 分钟

效率提升：13-18 倍！
```

**案例 2：微服务架构分析**

```
👤 你：分析所有微服务的依赖关系

🤖 Claude Code：
[自动启动 Agent Team]
├─ Agent 1: 分析 user-service
├─ Agent 2: 分析 order-service
├─ Agent 3: 分析 payment-service
└─ Agent 4: 分析 notification-service

[并行分析，30-45 分钟]
[生成依赖关系图和问题清单]
```

### 控制与监控

#### Shift+Up/Down 切换

```
操作：按住 Shift + ↑/↓
功能：在不同智能体之间切换

使用场景：
- 查看某个智能体的详细工作
- 直接干预或指导
- 手动修正问题
```

#### tmux 集成

```bash
# 启动 tmux 会话
tmux new -s claude-agents

# 每个智能体在独立窗格运行
Ctrl+b %      # 垂直分割窗格
Ctrl+b ←→↑↓   # 切换窗格
```

### Windows 特别说明

**Windows Terminal**（推荐）：

```powershell
# 使用 Windows Terminal 的多标签页
wt -p "Claude Agent 1" claude
wt -p "Claude Agent 2" claude

# Ctrl+Shift+T: 新建标签页
# Ctrl+Tab: 切换标签页
```

**WSL 2 + tmux**：

```bash
# 在 WSL 2 中使用完整 tmux 功能
wsl
sudo apt install tmux
tmux new -s claude-agents
```

### 何时使用 Agent Teams

**✅ 推荐场景**：
- ✅ 大型代码审查（100+ 文件）
- ✅ 多模块并行分析
- ✅ 批量重构任务
- ✅ 多仓库分析
- ✅ 文档生成（多类型）

**❌ 不推荐场景**：
- ❌ 简单的单文件修改
- ❌ 高度耦合的顺序任务
- ❌ 需要全局上下文的任务

### 最佳实践

**1. 任务分解**

```
✅ 好的分解：
审查项目：
├─ 前端代码审查（独立）
├─ 后端代码审查（独立）
├─ 测试覆盖分析（独立）
└─ 文档完整性检查（独立）

❌ 不好的分解：
实现认证：
├─ 设计数据库（依赖设计）
├─ 实现后端（依赖数据库）
└─ 创建前端（依赖后端）
```

**2. 智能体数量**

| 项目规模 | 推荐数量 | 原因 |
|---------|---------|------|
| 小型（<50 文件） | 2-3 个 | 避免过度分解 |
| 中型（50-200 文件） | 4-6 个 | 充分并行 |
| 大型（200-500 文件） | 6-10 个 | 模块化处理 |

### 常见问题

**Q: Agent Teams 会增加成本吗？**

A: 通常增加 10-20%，但效率提升远超成本。
```
成本对比（大型项目审查）：
- 传统模式：$25, 3-5 小时
- Agent Teams：$30, 20-40 分钟

额外成本：$5
时间节省：2-4 小时
综合效益：显著正向
```

**Q: 如何知道是否应该使用 Agent Teams？**

A: 判断标准：
1. 任务是否可以分解为 3+ 个独立子任务？ → 是
2. 子任务之间是否低耦合？ → 是
3. 预期执行时间是否 > 30 分钟？ → 是

**Q: Windows 上能用 Agent Teams 吗？**

A: **完全支持！** 使用 Windows Terminal 或 WSL 2。

**详细文档**：[advanced/a-productivity/05-agent-teams.md](../advanced/a-productivity/05-agent-teams.md)

---

## 10. Effort控制与成本优化 ⭐ NEW

### 官方说明

**Effort 控制**是 Claude Opus 4.6 的核心机制：

```markdown
四个 Effort 级别：
- low：快速响应，成本最低
- medium：平衡模式
- high（默认）：自动判断何时深度思考
- max：最大推理能力，成本最高
```

### 概念说明

**Effort 控制**让你精准调整 AI 的推理深度，平衡成本、速度和质量。

**解决的问题**：
- ✅ 简单任务不过度思考（节省成本）
- ✅ 复杂任务获得足够推理（保证质量）
- ✅ 灵活控制响应速度
- ✅ 透明的成本控制

### 四个 Effort 级别

#### 1. low effort

**特点**：
- ⚡ **最快响应**
- 💰 **最低成本**
- 🎯 适合简单任务

**适用场景**：
```markdown
✅ 适合：
- 格式转换
- 简单查询
- 文档生成
- 代码注释
- 语法检查

❌ 不适合：
- 复杂逻辑
- 架构设计
- 性能优化
```

**示例**：

```
👤 你：格式化这个 JSON 文件

🤖 Claude（low effort）：
[快速格式化]
完成！
```

#### 2. medium effort

**特点**：
- ⚡⚡ **平衡响应**
- 💰💰 **适中成本**
- 🎯 适合常规任务

**适用场景**：
```markdown
✅ 适合：
- 常规开发
- Bug 修复
- 小重构
- 单元测试编写
```

#### 3. high effort（默认）

**特点**：
- ⚡ **适中响应**
- 💰💰💰 **较高成本**
- 🎯 **Adaptive Thinking**（自动判断）

**核心机制**：
```markdown
Adaptive Thinking：
模型自己决定何时需要深度推理

- 简单任务 → 快速处理（节省成本）
- 复杂任务 → 深度思考（保证质量）
- 自动优化 → 无需手动干预
```

**推荐**：大多数场景使用默认的 high effort。

#### 4. max effort

**特点**：
- 🐢 **最慢响应**
- 💰💰💰💰 **最高成本**
- 🎯 **最强推理能力**

**适用场景**：
```markdown
✅ 适合：
- 架构设计
- 复杂重构
- 性能优化
- 安全审计
- 多系统集成

❌ 不适合：
- 简单任务（浪费资源）
- 时间紧迫（响应慢）
```

**示例**：

```
👤 你：设计一个高可用的分布式系统架构

🤖 Claude（max effort）：
[深度思考...]
[考虑所有边界情况...]
[生成最优方案...]
```

### 使用方法

#### 方法 1: 在 CLAUDE.md 中设置默认级别

```markdown
# 项目配置

## 默认 Effort 级别
本项目使用 medium effort，平衡成本和质量。
```

#### 方法 2: 在 Skill 中指定

```yaml
---
name: quick-format
description: 快速格式化代码
model: haiku
# 使用 haiku 模型，相当于 low effort
---
```

#### 方法 3: 在对话中明确要求

```
👤 你：使用 max effort 设计这个 API

🤖 Claude：[使用最大推理能力]
```

### 成本对比

**实际案例**：重构一个大型模块

| Effort | 响应时间 | 成本 | 质量 | 推荐度 |
|--------|---------|------|------|--------|
| low | 30秒 | $1 | ⭐⭐ | ❌ 不推荐 |
| medium | 1分钟 | $2 | ⭐⭐⭐ | ⚠️ 够用 |
| high | 2分钟 | $3 | ⭐⭐⭐⭐ | ✅ 推荐 |
| max | 5分钟 | $5 | ⭐⭐⭐⭐⭐ | ✅ 最佳 |

### 最佳实践

**1. 根据任务复杂度选择**

```markdown
简单任务 → low effort
- 格式转换
- 文档生成
- 简单查询

常规任务 → medium/high effort
- Bug 修复
- 功能开发
- 代码审查

复杂任务 → max effort
- 架构设计
- 大规模重构
- 性能优化
```

**2. 使用默认的 high effort**

```markdown
原因：
- ✅ Adaptive Thinking 自动优化
- ✅ 大多数场景都能很好处理
- ✅ 避免手动判断复杂度
```

**3. 结合 Agent Teams**

```markdown
场景：大型代码审查

策略：
- 使用 Agent Teams 并行处理
- 每个 Agent 使用 medium effort
- 总成本可控，效率最大化
```

### 常见问题

**Q: Effort 和模型选择有什么区别？**

A: 互补关系：
```markdown
模型选择（model: haiku/sonnet/opus）：
- 决定基础能力
- 影响上下文大小

Effort 控制：
- 调整推理深度
- 控制成本质量平衡
```

**Q: 如何知道当前使用的 Effort 级别？**

A: 默认是 high effort，除非明确指定其他级别。

**Q: 可以在会话中动态调整吗？**

A: 可以，直接在对话中要求：
```
"这个任务使用 max effort"
"后续任务使用 low effort"
```

---

## 11. 1M Token大规模上下文 ⭐ NEW

### 官方数据

```markdown
1M Token Context Window（Beta）
- 8-needle 1M MRCR v2：Opus 4.6 得分 76%
- Sonnet 4.5 得分：18.5%
- 这是质的飞跃，不是简单数量增加
```

### 概念说明

**1M Token 上下文**让你处理超大规模的代码库，理解整个项目。

**解决的问题**：
- ✅ 大型项目完整分析
- ✅ 多文件复杂重构
- ✅ 长期会话保持
- ✅ 完整代码库理解

### 技术突破

**MRCR v2 基准测试**：

```markdown
什么是 MRCR v2？
- 测试 AI 在百万 token 中精准定位信息的能力
- 最权威的长上下文基准

结果对比：
- Claude Opus 4.6：76%
- Claude Sonnet 4.5：18.5%
- 其他模型：< 10%

这意味着：
✅ 在百万 token 中精准记忆
✅ 解决了"context rot"（上下文衰减）
✅ 百万 token 下仍保持峰值性能
```

### 定价

**官方定价**：

```markdown
标准定价：
- $5 / $25 per million tokens

超 200k tokens：
- $10 / $37.50 per million tokens
```

### 使用方法

#### 自动使用

**Claude Opus 4.6 自动使用 1M Token 上下文**：

```
👤 你：分析整个微服务架构的所有服务

🤖 Claude：
[自动使用 1M Token 上下文]
[读取所有相关文件]
[理解完整的项目结构]
[生成全局视图]
```

#### 适用场景

**场景 1：单体应用分析**

```markdown
传统模式：
- 上下文限制：~200K tokens
- 只能理解：单个模块
- 问题：分析不完整

1M Token 模式：
- 完整分析：整个应用
- 理解：所有模块关系
- 优势：全局视图
```

**场景 2：微服务架构理解**

```
👤 你：分析所有微服务的依赖关系

🤖 Claude：
[加载所有微服务代码]
[理解服务间关系]
[绘制依赖图]
[识别循环依赖]
```

**场景 3：大型重构**

```markdown
场景：重构 500+ 文件的代码库

1M Token 优势：
- ✅ 理解所有文件关系
- ✅ 识别影响范围
- ✅ 保证重构安全性
- ✅ 避免破坏性变更
```

### 性能表现

**实际对比**：

| 项目规模 | 传统模式 | 1M Token | 优势 |
|---------|---------|----------|------|
| 小型（<50 文件） | ✅ 完整 | ✅ 完整 | 无明显差异 |
| 中型（50-200 文件） | ⚠️ 部分理解 | ✅ 完整 | 理解更全面 |
| 大型（200-500 文件） | ❌ 不足 | ✅ 完整 | 质的飞跃 |
| 超大型（500+ 文件） | ❌ 严重不足 | ✅ 完整 | 必需 |

### 成本优化

**Context Compaction**（自动压缩）：

```markdown
功能：自动压缩不相关的上下文
触发：长期运行任务
效果：减少 token 消耗

使用场景：
- CI/CD 流程
- 持续监控
- 长会话开发
```

### Windows 特别说明

**性能优化**：

```powershell
# 1. 使用 SSD 存储项目（提升读取速度）
# 2. 关闭不必要的后台应用（释放内存）
# 3. 使用 PowerShell 7+（更好的性能）

# 监控内存使用
Get-Process | Where-Object {$_.ProcessName -like "*claude*"}
```

### 最佳实践

**1. 何时使用 1M Token**

```markdown
✅ 推荐：
- 大型项目分析（200+ 文件）
- 微服务架构理解
- 复杂重构任务
- 历史代码审查

❌ 不需要：
- 小型项目（< 50 文件）
- 简单的单文件任务
- 快速查询
```

**2. 结合 Agent Teams**

```markdown
场景：超大型项目（1000+ 文件）

策略：
1. 使用 Agent Teams 分解任务
2. 每个 Agent 处理 200-500 文件
3. 1M Token 确保每个 Agent 的理解完整

优势：
- ✅ 并行处理（效率）
- ✅ 完整理解（质量）
- ✅ 成本可控（优化）
```

**3. 成本控制**

```markdown
策略 1：分阶段处理
- 第一阶段：快速扫描（low effort）
- 第二阶段：重点分析（high effort）
- 第三阶段：深度优化（max effort）

策略 2：选择性加载
- 只加载相关文件
- 使用 @ 符号精确引用

策略 3：使用 Context Compaction
- 长会话自动压缩
- 减少 token 消耗
```

### 常见问题

**Q: 1M Token 会显著增加成本吗？**

A: 取决于使用方式：
```markdown
智能使用：
- 只在需要时使用
- 结合 Agent Teams 分解
- 使用 Context Compaction

成本可控：
- 比多次小上下文更高效
- 避免重复读取
```

**Q: 如何知道当前使用了多少 token？**

A: 使用 `/context` 命令查看。

**Q: 1M Token 适合所有任务吗？**

A: 不是。适合：
- ✅ 大型项目
- ✅ 复杂分析
- ✅ 长期会话

不适合：
- ❌ 简单任务（浪费资源）
- ❌ 快速查询（不必要）

---

## 功能组合使用

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

### 场景 4：大型项目审查 ⭐ NEW

**使用 Agent Teams + 1M Token + Effort 控制**：

```
1. 评估项目规模
   - 如果 > 200 文件：使用 1M Token
   - 如果 > 3 个独立模块：使用 Agent Teams

2. 配置 Effort 级别
   - 快速扫描：medium effort
   - 详细审查：high effort（默认）
   - 深度优化：max effort

3. 启动 Agent Teams
   👤 你：使用 Agent Teams 审查整个项目，
         包括前端、后端、API、数据库、测试

   🤖 Claude：
   [自动创建多个智能体]
   [每个 Agent 独立上下文]
   [并行分析]

4. 监控和控制
   - Shift+Up/Down：切换智能体
   - /agents status：查看进度

5. 汇总报告
   [自动整合所有智能体的结果]
   [生成综合报告]
```

**效率对比**：
```
传统方式：
- 串行审查：4-6 小时
- 成本：$25-30

Agent Teams + 1M Token：
- 并行审查：20-40 分钟
- 成本：$30-35
- 效率提升：8-12 倍
```

### 场景 5：微服务架构分析 ⭐ NEW

**使用 Agent Teams + 1M Token**：

```
1. 启动大规模分析
   👤 你：分析所有微服务的依赖关系和潜在问题

   🤖 Claude：
   [自动检测到多服务架构]
   [使用 1M Token 加载所有服务]
   [启动 Agent Teams 并行分析]

2. Agent 分配（示例）
   ├─ Agent 1: user-service（用户服务）
   ├─ Agent 2: order-service（订单服务）
   ├─ Agent 3: payment-service（支付服务）
   └─ Agent 4: notification-service（通知服务）

3. 并行分析
   [每个 Agent 独立分析自己的服务]
   [同时处理]

4. 结果汇总
   - 依赖关系图
   - 潜在循环依赖
   - 版本冲突检测
   - 优化建议

总时间：30-45 分钟
传统方式：4-6 小时
```

### 场景 6：成本优化项目 ⭐ NEW

**使用 Effort 控制 + Agent Teams**：

```
场景：预算有限的大项目

策略 1：分级处理
- 第一轮：low effort + Agent Teams（快速扫描）
  成本：$5，时间：15 分钟
  目的：识别重点区域

- 第二轮：medium effort（重点区域详细分析）
  成本：$10，时间：30 分钟
  目的：深入分析问题区域

- 第三轮：max effort（关键问题深度优化）
  成本：$5，时间：20 分钟
  目的：解决最关键问题

总成本：$20
总时间：65 分钟
传统方式（全部 high effort）：$30，3 小时

节省：33% 成本，65% 时间
```

---

---

## 总结

### 学习检查清单

#### 基础功能（必须掌握）
- [ ] 能使用 @ 符号引用文件
- [ ] 能使用 ! 执行命令
- [ ] 创建了项目的 CLAUDE.md
- [ ] 理解 Esc 撤销功能
- [ ] 掌握 Plan 模式基本用法
- [ ] 会创建和管理会话
- [ ] 能使用 Ctrl+R 查找历史
- [ ] 使用 /init 理解新项目

#### 进阶功能（Claude Opus 4.6 新特性）⭐
- [ ] 理解 Agent Teams 的使用场景
- [ ] 会启动和控制 Agent Teams
- [ ] 了解 4 个 Effort 级别及其适用场景
- [ ] 知道何时使用 1M Token 上下文
- [ ] 能组合使用多个新功能

### 核心要点

#### 传统功能（v1.0+）
```
@ 符号：文件引用
! 命令：执行 shell
Esc：撤销操作
Plan 模式：先规划后执行
```

#### 新功能（v3.5+）⭐
```
Agent Teams：多智能体并行（效率提升 10-20 倍）
Effort 控制：成本质量平衡（精准控制）
1M Token：超大规模上下文（完整理解）
```

### 功能选择指南

#### 根据任务规模选择

```markdown
小型任务（< 50 文件）：
- 使用传统功能
- @ 符号 + Plan 模式
- Effort: low/medium

中型任务（50-200 文件）：
- 考虑 Agent Teams（2-4 个 Agent）
- Effort: medium/high
- 1M Token: 可选

大型任务（200-500 文件）：
- Agent Teams（4-8 个 Agent）
- Effort: high/max
- 1M Token: 推荐

超大型任务（500+ 文件）：
- Agent Teams（8-15 个 Agent）
- Effort: high/max
- 1M Token: 必需
```

#### 根据任务类型选择

```markdown
代码审查：
- 小项目：Plan 模式 + @ 符号
- 大项目：Agent Teams + 1M Token

功能开发：
- 简单功能：传统功能
- 复杂功能：Plan 模式 + max effort

重构优化：
- 小重构：Plan 模式
- 大重构：Agent Teams + 1M Token

架构设计：
- max effort
- 1M Token
- 可能需要 Agent Teams
```

### 效率提升总结

| 任务类型 | 传统方式 | 新功能组合 | 效率提升 |
|---------|---------|-----------|---------|
| **小项目审查** | 30 分钟 | 20 分钟 | 1.5x |
| **中项目审查** | 2 小时 | 25 分钟 | 4.8x |
| **大项目审查** | 5 小时 | 35 分钟 | 8.6x |
| **超大项目审查** | 8+ 小时 | 50 分钟 | 9.6x+ |
| **微服务分析** | 6 小时 | 40 分钟 | 9x |
| **大型重构** | 1 天 | 2 小时 | 12x |

### 下一步

**实战项目** → [03 - First Project](./03-first-project.md)

在真实项目中综合运用这些功能，包括最新的 Agent Teams、Effort 控制和 1M Token！

**进阶学习**：
- Agent Teams 深入指南：[advanced/a-productivity/05-agent-teams.md](../advanced/a-productivity/05-agent-teams.md)
- Skills 开发：[advanced/d-skills-development/01-skill-fundamentals.md](../advanced/d-skills-development/01-skill-fundamentals.md)
- 上下文优化：[advanced/a-productivity/04-context-optimization.md](../advanced/a-productivity/04-context-optimization.md)

---

**最后更新**: 2026-02-15
**文档版本**: v3.5 + Claude Opus 4.6
**下一章节**: [03 - First Project](./03-first-project.md)
