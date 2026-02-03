# 02 - Core Features - 8个核心功能详解

> **掌握20%最常用的功能，解决80%的使用场景**

**阅读时间**: 15分钟
**难度**: ⭐⭐ 初级
**前置要求**: 完成 [01-Quickstart](./01-quickstart.md)

---

## 目录

- [功能概览](#功能概览)
- [1. @符号上下文](#1-符号上下文)
- [2. !命令执行](#2-命令执行)
- [3. CLAUDE.md项目上下文](#3-claudemd项目上下文)
- [4. Esc后悔药](#4-esc后悔药)
- [5. Plan模式基础](#5-plan模式基础)
- [6. 会话管理基础](#6-会话管理基础)
- [7. Ctrl+R历史](#7-ctrl r历史)
- [8. /init项目初始化](#8-init项目初始化)
- [功能组合使用](#功能组合使用)

---

## 功能概览

### 为什么是这8个功能？

我们精选了**使用频率最高、价值最大**的核心功能：

| # | 功能 | 使用频率 | 价值 | 难度 |
|---|------|---------|------|------|
| 1 | @符号上下文 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | 简单 |
| 2 | !命令执行 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | 简单 |
| 3 | CLAUDE.md | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | 中等 |
| 4 | Esc后悔药 | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | 简单 |
| 5 | Plan模式 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | 中等 |
| 6 | 会话管理 | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | 简单 |
| 7 | Ctrl+R | ⭐⭐⭐ | ⭐⭐⭐⭐ | 简单 |
| 8 | /init | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | 简单 |

**学习策略**：
1. **立即掌握**：功能 1, 2, 4（5分钟）
2. **重点学习**：功能 3, 5（20分钟）
3. **按需使用**：功能 6, 7, 8（随用随查）

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

---

## 总结

### 学习检查清单

- [ ] 能使用 @ 符号引用文件
- [ ] 能使用 ! 执行命令
- [ ] 创建了项目的 CLAUDE.md
- [ ] 理解 Esc 撤销功能
- [ ] 掌握 Plan 模式基本用法
- [ ] 会创建和管理会话
- [ ] 能使用 Ctrl+R 查找历史
- [ ] 使用 /init 理解新项目

### 下一步

**实战项目** → [03 - First Project](./03-first-project.md)

在真实项目中综合运用这些功能！

---

**最后更新**: 2026-02-04
**下一章节**: [03 - First Project](./03-first-project.md)
