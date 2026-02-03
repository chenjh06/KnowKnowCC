# Claude Code Skills 官方文档完整整理

> 本文档汇总了 Claude Code 官方发布的所有关于 Skills 的内容
> 最后更新：2026-02-04

## 📚 目录

- [什么是 Skills](#什么是-skills)
- [核心概念](#核心概念)
- [快速开始](#快速开始)
- [Skills 存放位置](#skills-存放位置)
- [配置详解](#配置详解)
- [高级功能](#高级功能)
- [最佳实践](#最佳实践)
- [故障排查](#故障排查)
- [社区资源](#社区资源)

---

## 什么是 Skills

### 定义

**Skills（技能）** 是扩展 Claude Code 功能的自定义指令集合。通过创建 `SKILL.md` 文件，你可以：

- 创建自定义斜杠命令（如 `/review`、`/deploy`）
- 让 Claude 自动学习并应用特定的工作流程
- 编码可重复的开发模式和最佳实践

### 核心特性

1. **自动发现**：Claude 可以根据描述自动决定何时使用相关技能
2. **手动调用**：通过 `/skill-name` 直接触发
3. **可组合性**：支持模板、示例、脚本等辅助文件
4. **遵循开放标准**：基于 [Agent Skills](https://agentskills.io/) 开放标准

### 与命令的关系

**重要变更**：自定义斜杠命令已合并到 Skills 系统。

- 旧路径：`.claude/commands/review.md`
- 新路径：`.claude/skills/review/SKILL.md`
- 两者都创建 `/review` 命令，工作方式相同
- Skills 添加了额外功能：支持目录、frontmatter 配置、自动加载

---

## 核心概念

### Skill 的两种类型

#### 1. 参考内容型（Reference Content）

提供知识库供 Claude 在当前工作中应用：

```yaml
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

**特点**：
- 内容内联运行
- Claude 可在对话上下文中使用
- 用于编码约定、模式、风格指南

#### 2. 任务型（Task Content）

提供特定任务的分步指令：

```yaml
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

**特点**：
- 通常通过 `/skill-name` 手动触发
- 使用 `disable-model-invocation: true` 防止自动运行
- 适合有副作用的操作（部署、提交、发送通知）

### 调用方式

| 方式 | 说明 | 配置 |
|------|------|------|
| 双向调用 | 你和 Claude 都可以触发 | 默认设置 |
| 仅手动调用 | 只能通过 `/skill-name` 触发 | `disable-model-invocation: true` |
| 仅自动调用 | 只有 Claude 可以触发 | `user-invocable: false` |

---

## 快速开始

### 创建第一个 Skill

#### 步骤 1：创建技能目录

```bash
mkdir -p ~/.claude/skills/explain-code
```

#### 步骤 2：编写 SKILL.md

每个 Skill 需要两部分：
1. **YAML frontmatter**（`---` 之间）：告诉 Claude 何时使用
2. **Markdown 内容**：Claude 遵循的指令

创建 `~/.claude/skills/explain-code/SKILL.md`：

```markdown
---
name: explain-code
description: 使用视觉图表和类比解释代码工作原理。在解释代码如何工作、教授代码库或用户问"这是如何工作的？"时使用
---

# 代码解释技能

解释代码时始终包含：

1. **以类比开始**：将代码比作日常生活中的事物
2. **绘制图表**：使用 ASCII 艺术展示流程、结构或关系
3. **逐步讲解**：解释每一步发生什么
4. **强调陷阱**：常见错误或误解是什么？

保持对话风格。对于复杂概念，使用多个类比。
```

#### 步骤 3：测试技能

**方式一：让 Claude 自动调用**

```
How does this code work?
```

**方式二：直接调用**

```
/explain-code src/auth/login.ts
```

两种方式都会让 Claude 在解释中包含类比和 ASCII 图表。

---

## Skills 存放位置

### 四个作用域

| 位置 | 路径 | 适用范围 |
|------|------|----------|
| **企业级** | 通过托管设置配置 | 组织内所有用户 |
| **个人级** | `~/.claude/skills/<skill-name>/SKILL.md` | 所有你的项目 |
| **项目级** | `.claude/skills/<skill-name>/SKILL.md` | 仅当前项目 |
| **插件级** | `<plugin>/skills/<skill-name>/SKILL.md` | 插件启用的地方 |

### 优先级规则

- **项目技能覆盖个人技能**（同名时）
- Skills 优先于 `.claude/commands/` 中的同名命令
- `.claude/commands/` 文件继续工作

### 自动发现嵌套目录

在子目录中工作时，Claude Code 自动从嵌套的 `.claude/skills/` 目录发现技能。

**示例：** 在 `packages/frontend/` 中工作时，也会查找：
```
packages/frontend/.claude/skills/
```

**支持 Monorepo**：每个包可以有自己的技能集。

### 目录结构示例

```
my-skill/
├── SKILL.md           # 主指令（必需）
├── template.md        # Claude 填充的模板
├── examples/
│   └── sample.md      # 显示预期格式的示例输出
└── scripts/
    └── validate.sh    # Claude 可执行的脚本
```

- `SKILL.md`：必需，包含主要指令
- 其他文件：可选，用于构建更强大的技能
- 在 `SKILL.md` 中引用其他文件，让 Claude 知道内容和加载时机

---

## 配置详解

### Frontmatter 完整参考

在 `SKILL.md` 顶部使用 YAML frontmatter 配置行为：

```yaml
---
name: my-skill
description: 这个技能做什么
argument-hint: [filename]
disable-model-invocation: true
user-invocable: false
allowed-tools: Read, Grep, Bash
model: sonnet
context: fork
agent: Explore
hooks:
  ToolStart:
    - type: command
      command: echo "Starting skill"
---

技能指令内容...
```

### 所有字段说明

| 字段 | 必需 | 说明 |
|------|------|------|
| `name` | 否 | 技能显示名称。省略时使用目录名。仅小写字母、数字和连字符（最多 64 字符） |
| `description` | **推荐** | 技能功能和使用时机。Claude 用它决定何时应用。省略时使用第一段 |
| `argument-hint` | 否 | 自动完成时显示的参数提示。例：`[issue-number]` 或 `[filename] [format]` |
| `disable-model-invocation` | 否 | 设为 `true` 防止 Claude 自动加载。用于手动触发的任务。默认：`false` |
| `user-invocable` | 否 | 设为 `false` 从 `/` 菜单隐藏。用于后台知识。默认：`true` |
| `allowed-tools` | 否 | 技能激活时 Claude 无需许可即可使用的工具列表 |
| `model` | 否 | 技能激活时使用的模型 |
| `context` | 否 | 设为 `fork` 在分叉的子代理上下文中运行 |
| `agent` | 否 | `context: fork` 时使用的子代理类型 |
| `hooks` | 否 | 作用域为此技能生命周期的钩子。参见 [Hooks 文档](https://code.claude.com/docs/en/hooks) |

### 调用控制矩阵

| Frontmatter | 可手动调用 | 可自动调用 | 何时加载到上下文 |
|-------------|-----------|-----------|------------------|
| （默认） | 是 | 是 | 描述始终在上下文，完整技能在调用时加载 |
| `disable-model-invocation: true` | 是 | 否 | 描述不在上下文，完整技能在你调用时加载 |
| `user-invocable: false` | 否 | 是 | 描述始终在上下文，完整技能在调用时加载 |

### 字符串替换

Skills 支持动态值的字符串替换：

| 变量 | 说明 |
|------|------|
| `$ARGUMENTS` | 调用时传递的所有参数 |
| `${CLAUDE_SESSION_ID}` | 当前会话 ID |

**示例：**

```markdown
---
name: session-logger
description: 记录此会话的活动
---

将以下内容记录到 logs/${CLAUDE_SESSION_ID}.log：

$ARGUMENTS
```

---

## 高级功能

### 1. 传递参数

#### 参数传递示例

```markdown
---
name: fix-issue
description: 修复 GitHub 问题
disable-model-invocation: true
---

# 修复 GitHub 问题

修复问题 $ARGUMENTS，遵循我们的编码标准：

1. 阅读问题描述
2. 理解需求
3. 实现修复
4. 编写测试
5. 创建提交
```

**调用：** `/fix-issue 123`
**结果：** Claude 收到 "修复问题 123，遵循我们的编码标准..."

**注意：** 如果技能不包含 `$ARGUMENTS`，Claude Code 会将 `ARGUMENTS: <your input>` 附加到内容末尾。

### 2. 限制工具访问

使用 `allowed-tools` 限制技能激活时可用的工具：

```markdown
---
name: safe-reader
description: 只读文件，不做修改
allowed-tools: Read, Grep, Glob
---

这是一个只读模式技能，只能查看文件和搜索内容。
```

### 3. 添加辅助文件

Skills 可在目录中包含多个文件，保持 `SKILL.md` 简洁：

```
my-skill/
├── SKILL.md (必需 - 概述和导航)
├── reference.md (详细 API 文档 - 按需加载)
├── examples.md (使用示例 - 按需加载)
└── scripts/
    └── helper.py (实用脚本 - 执行，不加载)
```

**在 SKILL.md 中引用：**

```markdown
## 附加资源

- 完整 API 详情，参见 [reference.md](reference.md)
- 使用示例，参见 [examples.md](examples.md)
```

**建议：** 保持 `SKILL.md` 在 500 行以下。将详细参考材料移到单独文件。

### 4. 动态上下文注入

使用 `!command` 语法在技能内容发送到 Claude 之前运行 shell 命令：

```markdown
---
name: pr-summary
description: 总结 pull request 的变更
context: fork
agent: Explore
allowed-tools: Bash(gh:*)
---

# Pull Request 上下文

- PR 差异：!`gh pr diff`
- PR 评论：!`gh pr view --comments`
- 变更文件：!`gh pr diff --name-only`

## 你的任务

总结这个 pull request...
```

**工作流程：**

1. 每个 `!command` 立即执行（Claude 看到任何东西之前）
2. 输出替换占位符
3. Claude 收到完全渲染的提示和实际 PR 数据

**注意：** 这是预处理，不是 Claude 执行的内容。Claude 只看到最终结果。

**启用扩展思考：** 在技能内容中任何地方包含单词 "ultrathink"。

### 5. 在子代理中运行 Skills

添加 `context: fork` 到 frontmatter 在隔离环境中运行技能：

```markdown
---
name: deep-research
description: 彻底研究主题
context: fork
agent: Explore
---

# 深度研究

彻底研究 $ARGUMENTS：

1. 使用 Glob 和 Grep 查找相关文件
2. 阅读和分析代码
3. 用具体文件引用总结发现
```

**工作原理：**

1. 创建新的隔离上下文
2. 子代理接收技能内容作为提示
3. `agent` 字段决定执行环境（模型、工具、权限）
4. 结果总结并返回到主对话

**Skills 与 Subagents 的对比：**

| 方法 | 系统提示 | 任务 | 也加载 |
|------|---------|------|--------|
| Skill with `context: fork` | From agent type | SKILL.md 内容 | CLAUDE.md |
| Subagent with `skills` field | Subagent's body | Claude's delegation | Preloaded skills + CLAUDE.md |

### 6. 控制Claude的技能访问

#### 默认行为

Claude 可以调用任何没有设置 `disable-model-invocation: true` 的技能。

内置命令如 `/compact` 和 `/init` 不能通过 Skill 工具使用。

#### 三种控制方法

**方法 1：禁用所有技能**

在 `/permissions` 中拒绝 Skill 工具：

```yaml
# 添加到拒绝规则：
Skill
```

**方法 2：允许或拒绝特定技能**

使用权限规则：

```yaml
# 只允许特定技能
Skill(commit)
Skill(review-pr:*)

# 拒绝特定技能
Skill(deploy:*)
```

权限语法：
- `Skill(name)` - 精确匹配
- `Skill(name:*)` - 带任何参数的前缀匹配

**方法 3：隐藏单个技能**

在 frontmatter 中添加 `disable-model-invocation: true`。

**注意：** `user-invocable` 只控制菜单可见性，不控制 Skill 工具访问。使用 `disable-model-invocation: true` 阻止程序化调用。

### 7. 生成视觉输出

Skills 可以捆绑和运行任何语言的脚本，提供超越单个提示的功能。强大模式之一是生成视觉输出。

**示例：代码库可视化工具**

创建技能目录：

```bash
mkdir -p ~/.claude/skills/codebase-visualizer/scripts
```

创建 `SKILL.md`：

```markdown
---
name: codebase-visualizer
description: 生成交互式可折叠树形可视化图。在探索新仓库、理解项目结构或识别大文件时使用
allowed-tools: Bash(python:*)
---

# 代码库可视化器

生成交互式 HTML 树形图，显示项目文件结构和可折叠目录。

## 使用方法

从项目根目录运行可视化脚本：

```bash
python ~/.claude/skills/codebase-visualizer/scripts/visualize.py .
```

这会在当前目录创建 `codebase-map.html` 并在默认浏览器中打开。

## 可视化显示内容

- **可折叠目录**：点击文件夹展开/折叠
- **文件大小**：每个文件旁显示
- **颜色**：不同文件类型用不同颜色
- **目录总计**：显示每个文件夹的聚合大小
```

**Python 脚本示例**（131 行，使用内置库）：

```python
#!/usr/bin/env python3
"""生成代码库的交互式可折叠树可视化。"""

import json
import sys
import webbrowser
from pathlib import Path
from collections import Counter

IGNORE = {'.git', 'node_modules', '__pycache__', '.venv', 'venv', 'dist', 'build'}

def scan(path: Path, stats: dict) -> dict:
    result = {"name": path.name, "children": [], "size": 0}
    try:
        for item in sorted(path.iterdir()):
            if item.name in IGNORE or item.name.startswith('.'):
                continue
            if item.is_file():
                size = item.stat().st_size
                ext = item.suffix.lower() or '(no ext)'
                result["children"].append({"name": item.name, "size": size, "ext": ext})
                result["size"] += size
                stats["files"] += 1
                stats["extensions"][ext] += 1
                stats["ext_sizes"][ext] += size
            elif item.is_dir():
                stats["dirs"] += 1
                child = scan(item, stats)
                if child["children"]:
                    result["children"].append(child)
                    result["size"] += child["size"]
    except PermissionError:
        pass
    return result

# ... (完整的 HTML 生成代码)
```

**此模式适用于：**
- 依赖关系图
- 测试覆盖率报告
- API 文档
- 数据库架构可视化

### 8. 共享 Skills

#### 项目技能

将 `.claude/skills/` 提交到版本控制。

#### 插件

在[插件](https://code.claude.com/docs/en/plugins)中创建 `skills/` 目录。

#### 托管

通过[托管设置](https://code.claude.com/docs/en/iam#managed-settings)在组织内部署。

---

## 最佳实践

### 技能描述最佳实践

**好的描述：**

```
✓ 在解释代码如何工作、教授代码库或用户问"这是如何工作的？"时使用
✓ 在部署到生产环境之前运行测试和构建
✓ 当用户询问表单处理、数据加载或服务器操作时使用
```

**不好的描述：**

```
✗ 代码解释
✗ 部署
✗ SvelteKit 技能
```

**关键点：**
- 包含用户会说的关键词
- 说明何时使用
- 如果适用，提及具体的触发场景

### 技能内容组织

1. **保持 SKILL.md 简洁**（< 500 行）
2. **将详细参考移到单独文件**
3. **在 SKILL.md 中引用其他文件**
4. **使用清晰的标题和结构**

### 何时使用不同配置

| 场景 | 配置 |
|------|------|
| 部署、提交等有副作用的操作 | `disable-model-invocation: true` |
| 后台知识、约定 | `user-invocable: false` |
| 复杂研究任务 | `context: fork`, `agent: Explore` |
| 只读操作 | `allowed-tools: Read, Grep, Glob` |
| 生成报告 | `allowed-tools: Bash(python:*)` |

---

## 故障排查

### 技能未触发

**症状：** Claude 没有按预期使用技能

**解决方案：**

1. ✅ 检查描述是否包含用户会自然说的关键词
2. ✅ 验证技能出现在 "What skills are available?" 中
3. ✅ 尝试重新表述请求以更匹配描述
4. ✅ 如果技能可用户调用，直接用 `/skill-name` 调用

### 技能触发太频繁

**症状：** Claude 在你不想它使用时使用技能

**解决方案：**

1. ✅ 使描述更具体
2. ✅ 如果只想手动调用，添加 `disable-model-invocation: true`

### Claude 看不到所有技能

**症状：** 某些技能不出现或被忽略

**原因：** 技能描述加载到上下文以便 Claude 知道可用内容。如果有很多技能，可能超过字符预算（默认 15,000 字符）。

**解决方案：**

1. ✅ 运行 `/context` 检查是否有关于排除技能的警告
2. ✅ 设置 `SLASH_COMMAND_TOOL_CHAR_BUDGET` 环境变量增加限制

### 调试技巧

- 使用 `/context` 查看当前加载的技能
- 检查技能描述是否清晰明确
- 测试不同的描述措辞
- 使用直接调用 `/skill-name` 测试技能是否工作

---

## 社区资源

### 官方资源

1. **[官方文档 - Extend Claude with skills](https://code.claude.com/docs/en/skills)**

2. **[Agent Skills 开放标准](https://agentskills.io/)**

### 教程和指南

1. **[Claude Skills Explained - Step-by-Step Tutorial for Beginners](https://www.youtube.com/watch?v=wO8EboopboU)**
   - Kevin Stratvert 的 YouTube 教程
   - 涵盖技能创建、自定义和自动化

2. **[How to Use Claude Code: A Guide to Slash Commands, Agents, Skills, and Plug-Ins](https://www.producttalk.org/how-to-use-claude-code-features/)**
   - Teresa Torres 的深度指南
   - 解释如何有效使用 Claude Code 的所有构建块

3. **[Claude Skills Explained in 23 Minutes](https://www.youtube.com/watch?v=vEvytl7wrGM)**
   - Shaw Talebi 的视频教程
   - 详细解释技能工作原理和具体示例

4. **[How I Use Every Claude Code Feature](https://blog.sshh.io/p/how-i-use-every-claude-code-feature)**
   - Shrivu Shankar 的实践经验分享
   - 介绍所有功能的使用方式

5. **[How to Make Claude Code Skills Activate Reliably](https://scottspence.com/posts/how-to-make-claude-code-skills-activate-reliably)**
   - Scott Spence 的深度研究
   - 通过 200+ 测试找出 80-84% 成功率的方法

### 相关文档

- **[Subagents](https://code.claude.com/docs/en/sub-agents)** - 委派任务给专门代理
- **[Plugins](https://code.claude.com/docs/en/plugins)** - 打包和分发技能
- **[Hooks](https://code.claude.com/docs/en/hooks-guide)** - 自动化工作流
- **[Memory](https://code.claude.com/docs/en/memory)** - 管理 CLAUDE.md 文件
- **[Interactive Mode](https://code.claude.com/docs/en/interactive-mode#built-in-commands)** - 内置命令
- **[Permissions](https://code.claude.com/docs/en/iam)** - 控制工具和技能访问

---

## 附录

### 常见用例示例

#### 1. 代码审查技能

```markdown
---
name: review
description: 审查代码更改，检查安全、性能和可维护性问题
---

# 代码审查

审查此代码更改：

1. **安全性**：检查漏洞、注入风险、敏感数据暴露
2. **性能**：识别瓶颈、不必要的计算、内存泄漏
3. **可维护性**：评估代码清晰度、注释、命名约定
4. **测试**：验证测试覆盖率和测试质量

提供具体的改进建议。
```

#### 2. 文档生成技能

```markdown
---
name: docs
description: 为代码生成文档
---

# 文档生成

为以下代码生成文档：

- 描述函数/类的作用
- 列出参数及其类型
- 说明返回值
- 提供使用示例
- 注意事项和限制
```

#### 3. 测试生成技能

```markdown
---
name: test-gen
description: 为代码生成单元测试
---

# 测试生成

为以下代码生成单元测试：

- 测试正常路径
- 测试边界条件
- 测试错误情况
- 使用适当的断言
- 包含设置和清理代码
```

### 技能模板

#### 最小模板

```markdown
---
name: my-skill
description: 简短描述何时使用此技能
---

# 技能标题

技能指令内容...
```

#### 完整模板

```markdown
---
name: my-skill
description: 详细描述技能功能和使用场景
argument-hint: [optional-args]
disable-model-invocation: false
allowed-tools: Read, Write, Bash
context: inline
---

# 技能标题

## 概述
技能做什么...

## 步骤
1. 第一步
2. 第二步
3. 第三步

## 参考
- [详细文档](reference.md)
- [示例](examples.md)

## 注意事项
- 注意点 1
- 注意点 2
```

---

## 版本历史

- **2026-01-22**：初始版本，汇总官方文档和社区资源
- 持续更新...

---

**整理者注：** 本文档基于 Claude Code 官方文档和社区资源整理，旨在提供 Skills 功能的完整参考。如有更新或补充，请参考官方文档获取最新信息。
