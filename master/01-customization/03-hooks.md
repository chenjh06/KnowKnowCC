# Hooks 机制 - Hooks Mechanism

> **自动化工作流的触发器**

**阅读时间**: 50分钟
**难度**: ⭐⭐⭐⭐⭐
**适用场景**: 自动化工作流、自定义行为、团队协作
**前置要求**: [Level 2 进阶提升](../../advanced/), [工作流自动化](../02-automation/03-workflow-automation.md)

---

## 目录

- [Hooks 概述](#hooks-概述)
- [Hook 事件类型](#hook-事件类型)
- [配置 Hooks](#配置-hooks)
- [Hook 类型](#hook-类型)
- [高级用法](#高级用法)
- [实战案例](#实战案例)
- [Windows 专属](#windows-专属)
- [最佳实践](#最佳实践)
- [常见问题](#常见问题)

---

## Hooks 概述

### 什么是 Hooks？

**定义**：Hooks 是在特定事件发生时自动触发的自定义脚本或命令，用于自动化工作流程。

```
传统模式：
操作 → 手动执行后续步骤 → 容易遗忘

Hooks 模式：
操作 → Hook 自动触发 → 自动执行后续步骤
    ↓
流程自动化、标准化、可追踪
```

### Hooks 的价值

```
1. 自动化
   ├─ 减少手动操作
   ├─ 消除人为错误
   └─ 节省时间

2. 标准化
   ├─ 统一流程
   ├─ 团队一致性
   └─ 可追溯

3. 可扩展
   ├─ 自定义行为
   ├─ 集成外部工具
   └─ 构建生态系统
```

### 配置文件位置

```
用户设置: ~/.claude/settings.json
项目设置: .claude/settings.json
本地设置: .claude/settings.local.json
托管设置: managed-settings.json

```

> **v2.1.83+**: 扦托管设置现在支持 `managed-settings.d/` drop-in 目录，实现分文件策略片段合并

```
managed-settings.d/ (v2.1.83+)
├── macOS: `/Library/Application Support/ClaudeCode/managed-settings.d/`
├── Linux/WSL: `/etc/claude-code/managed-settings.d/`
├── Windows: `C:\Program Files\ClaudeCode\managed-settings.d\`
```

工作方式：
- 先加载 `managed-settings.json` 作为基础
- 按字母顺序排序加载 `managed-settings.d/*.json` 文件
- 后加载的文件覆盖先加载的标量值
- 数组连接并去重
- 对象深度合并
- 以 `.` 开头的隐藏文件被忽略
- 可用数字前缀控制顺序：如 `10-telemetry.json`、`20-security.json`

**用途**: 让不同团队独立部署策略片段，无需协调编辑单一文件
```

---

## Hook 事件类型

Claude Code 支持以下官方 Hook 事件：

### 工具相关事件

#### 1. PreToolUse

**触发时机**：在 Claude 创建工具参数之后和处理工具调用之前

**常见匹配器**：
- `Task` - Subagent 任务
- `Bash` - Shell 命令
- `Glob` - 文件模式匹配
- `Grep` - 内容搜索
- `Read` - 文件读取
- `Edit` - 文件编辑
- `Write` - 文件写入
- `WebFetch`、`WebSearch` - Web 操作

**用途**：
- ✅ 验证工具参数
- ✅ 自动批准某些工具
- ✅ 记录工具使用
- ✅ 阻止危险操作

#### 2. PermissionRequest

**触发时机**：在向用户显示权限对话框时运行

**用途**：
- ✅ 自动允许/拒绝权限
- ✅ 修改工具参数
- ✅ 提供默认决策

#### 3. PostToolUse

**触发时机**：在工具成功完成后立即运行

**用途**：
- ✅ 自动提交代码
- ✅ 生成文档
- ✅ 发送通知
- ✅ 运行 linter/formatter

#### 4. Notification

**触发时机**：在 Claude Code 发送通知时运行

**常见匹配器**：
- `permission_prompt` - 权限请求
- `idle_prompt` - 空闲提示
- `auth_success` - 认证成功
- `elicitation_dialog` - MCP 工具引出

### 会话相关事件

#### 5. UserPromptSubmit

**触发时机**：在用户提交提示时运行，在 Claude 处理之前

**用途**：
- ✅ 验证提示内容
- ✅ 添加额外上下文
- ✅ 阻止特定提示

#### 6. Stop

**触发时机**：在主 Claude Code agent 完成响应时运行

**用途**：
- ✅ 智能判断是否继续
- ✅ 检查任务完成度
- ✅ 自动继续工作

#### 7. SubagentStop

**触发时机**：在 Claude Code subagent（Task 工具调用）完成响应时运行

**输入字段** *(v2.1.145+)*：除标准字段外，还包含 `background_tasks`（后台任务列表）和 `session_crons`（会话定时任务列表）

**用途**：
- ✅ 评估 subagent 结果
- ✅ 决定是否需要更多上下文
- ✅ 检查后台任务和定时任务状态（v2.1.145+）

#### 7.6 MessageDisplay ✨ v2.1.152+

**触发时机**：助手消息文本显示时

**用途**：
- ✅ 转换或隐藏助手消息文本
- ✅ 自定义消息显示格式

#### 7.7 PreCompact *(v2.1.105+)*

**触发时机**：在上下文压缩（compact）即将执行前运行

**用途**：
- ✅ 阻止压缩（退出码 2 或返回 `{"decision":"block"}`）
- ✅ 在压缩前保存关键上下文
- ✅ 记录压缩事件

**阻止压缩示例**：
```json
{
  "hooks": {
    "PreCompact": [
      {
        "matcher": "",
        "hooks": ["node save-context.js"]
      }
    ]
  }
}
```

> **注意**: `PreCompact` 只在手动 `/compact` 或自动压缩时触发。如果 hook 以退出码 2 退出或返回 `{"decision":"block"}`，压缩将被取消。

#### 8. SessionStart

**触发时机**：在 Claude Code 启动新会话或恢复现有会话时运行

**匹配器**：
- `startup` - 从启动调用
- `resume` - 从 --resume、--continue 或 /resume 调用
- `clear` - 从 /clear 调用
- `compact` - 从自动或手动压缩调用

**输出字段** *(v2.1.152+)*：`reloadSkills: true` 重新扫描 Skill 目录；`hookSpecificOutput.sessionTitle` 设置会话标题

**用途**：
- ✅ 加载开发上下文
- ✅ 安装依赖项
- ✅ 设置环境变量
- ✅ 持久化环境配置

#### 9. SessionEnd

**触发时机**：在 Claude Code 会话结束时运行

**用途**：
- ✅ 清理任务
- ✅ 记录会话统计
- ✅ 保存会话状态

### 系统事件

#### 10. TaskCreated ✨ v2.1.84

**触发时机**：在通过 `TaskCreate` 工具创建任务时运行

**环境变量**：
- `TASK_NAME` - 任务名称
- `TASK_DESCRIPTION` - 任务描述
- `TASK_ID` - 任务 ID

**用途**：
- ✅ 记录任务创建
- ✅ 自动分配任务
- ✅ 发送任务通知
- ✅ 触发外部工作流

**实战案例**：见 [案例5：TaskCreated 任务创建通知](#案例5-taskcreated-任务创建通知--v2184)

#### 11. PreCompact

**触发时机**：在 Claude Code 即将运行压缩操作之前

**匹配器**：
- `manual` - 从 /compact 调用
- `auto` - 从自动压缩调用

**用途**：
- ✅ 优化压缩内容
- ✅ 保存重要信息

---

## 配置 Hooks

### 基本结构

Hooks 按匹配器组织，其中每个匹配器可以有多个 hooks：

```json
{
  "hooks": {
    "EventName": [
      {
        "matcher": "ToolPattern",
        "hooks": [
          {
            "type": "command",
            "command": "your-command-here"
          }
        ]
      }
    ]
  }
}
```

### Hook 类型

Hooks 支持两种调用方式：

**1. 命令类型** (`type: "command"`)：
```json
{
  "type": "command",
  "command": "your-script.sh"
}
```

**2. MCP 工具类型** (`type: "mcp_tool"`, v2.1.118+):
```json
{
  "type": "mcp_tool",
  "server_name": "my-server",
  "tool_name": "send-notification"
}
```

> **说明**: `type: "mcp_tool"` 允许 hooks 直接调用已连接的 MCP 服务器工具，无需通过外部脚本。这在需要集成外部服务（如通知、日志、CI）时非常方便。

### Hook 可用环境信息

Hooks 执行时可获取以下信息：

| 信息 | JSON 输入字段 | 环境变量 | 版本 |
|------|-------------|---------|------|
| Effort 级别 | `effort.level` | `$CLAUDE_EFFORT` | v2.1.133+ |
| 插件根目录 | — | `$CLAUDE_PLUGIN_ROOT` | — |
| 会话标题 | `hookSpecificOutput.sessionTitle` | — | v2.1.94+ |

### Hook 输出字段 ✨ v2.1.141+

**`terminalSequence`**: Hooks 可通过 JSON 输出发送终端控制序列，无需控制终端即可：

```json
{
  "hookSpecificOutput": {
    "terminalSequence": {
      "notify": "任务完成",
      "title": "Claude Code - 编译中...",
      "bell": true
    }
  }
}
```

> **用途**: 发送桌面通知、设置窗口标题、响铃提醒。适用于后台任务完成通知。

### 字段说明

#### matcher（匹配器）

用于匹配工具名称的模式，区分大小写（仅适用于 PreToolUse、PermissionRequest 和 PostToolUse）：

```
简单字符串精确匹配：
  "Write" 仅匹配 Write 工具

正则表达式：
  "Edit|Write" 匹配 Edit 或 Write
  "Notebook.*" 匹配所有 Notebook 开头的工具

匹配所有工具：
  "*" 或 "" 或省略
```

#### hooks（Hook 数组）

当模式匹配时要执行的 hooks 数组：

```json
{
  "type": "command",  // 或 "prompt" 用于基于 LLM 的评估
  "command": "your-command",
  "timeout": 30  // 可选：超时时间（秒）
}
```

### 配置示例

#### PreToolUse Hook

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "echo 'File modification detected'"
          }
        ]
      }
    ]
  }
}
```

#### PostToolUse Hook

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/format.sh"
          }
        ]
      }
    ]
  }
}
```

### 条件过滤 ✨ v2.1.85

**新功能**: Hooks 新增 `if` 字段，使用权限规则语法过滤触发条件，只有匹配 `if` 条件的 Hook 才会执行，减少进程开销。



#### UserPromptSubmit Hook

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "/path/to/prompt-validator.py"
          }
        ]
      }
    ]
  }
}
```

#### SessionStart Hook（持久化环境变量）

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup",
        "hooks": [
          {
            "type": "command",
            "command": "./scripts/setup-env.sh"
          }
        ]
      }
    ]
  }
}
```

---

### 条件过滤 `if` 字段 ✨ v2.1.85

**新功能**: Hooks 新增 `if` 字段，使用权限规则语法过滤触发条件，只有匹配的 Hook 才会执行。

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "scripts/git-logger.sh",
            "if": "Bash(git push*)"
          }
        ]
      }
    ]
  }
}
```

**`if` 字段语法**（与权限规则语法相同）:
```
ToolPattern(pattern)        # 例如: Bash(git *), Edit(write)
```

**常用示例**:
| `if` 值 | 匹配目标 |
|---------|---------|
| `Bash(git *)` | 只匹配 git 开头的 Bash 命令 |
| `Bash(git push --force)` | 只匹配强制推送（危险操作） |
| `Bash(npm *)` | 只匹配 npm 开头的命令 |
| `Edit\|Write` | 只匹配 Edit 或 Write 操作 |
| `Bash(git commit*)` | 只匹配 git commit 命令 |

**效果**: 只有匹配 `if` 条件的 Hook 才执行，减少不必要的进程调用开销。

---

## Hook 类型

### 1. Command Hooks（命令 Hooks）

**type: "command"** - 执行 bash 命令

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "npm run format",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

**环境变量**：
- `$CLAUDE_PROJECT_DIR` - 项目根目录的绝对路径
- `$CLAUDE_CODE_REMOTE` - 在远程（web）环境为 "true"，本地未设置

### 2. Prompt Hooks（基于提示的 Hooks）

**type: "prompt"** - 使用 LLM 评估是否允许或阻止操作

目前仅支持 `Stop` 和 `SubagentStop` hooks：

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Evaluate if Claude should stop: $ARGUMENTS. Check if all tasks are complete."
          }
        ]
      }
    ]
  }
}
```

**LLM 响应格式**：
```json
{
  "ok": true | false,
  "reason": "Explanation"
}
```

### 两种 Hook 类型对比

| 特性 | Command Hooks | Prompt Hooks |
|------|---------------|--------------|
| **执行** | 运行 bash 脚本 | 查询 LLM |
| **决策逻辑** | 代码实现 | LLM 评估上下文 |
| **设置复杂性** | 需要脚本文件 | 配置提示 |
| **上下文感知** | 受脚本逻辑限制 | 自然语言理解 |
| **性能** | 快速（本地执行） | 较慢（API 调用） |
| **用例** | 确定性规则 | 上下文感知决策 |

---

## 高级用法

### Hook 输出控制

#### 退出代码控制

Hooks 通过退出代码传达状态：

- **退出代码 0**：成功
  - `stdout` 在详细模式（Ctrl+O）中显示
  - `UserPromptSubmit` 和 `SessionStart` 的 `stdout` 被添加为上下文
  - `stdout` 中的 JSON 被解析为结构化控制

- **退出代码 2**：阻止错误
  - 仅使用 `stderr` 作为错误消息
  - 阻止工具调用或提示处理

- **其他退出代码**：非阻止错误
  - `stderr` 在详细模式中显示

#### JSON 输出（高级控制）

Hooks 可以返回结构化 JSON 进行复杂控制：

```json
{
  "continue": true,
  "stopReason": "string",
  "suppressOutput": true,
  "systemMessage": "string"
}
```

**PreToolUse 决策控制**：

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "allow",
    "permissionDecisionReason": "Auto-approved",
    "updatedInput": {
      "field_to_modify": "new value"
    }
  }
}
```

**UserPromptSubmit 决策控制**：

```json
{
  "decision": "block",
  "reason": "Security policy violation",
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": "Additional context here"
  }
}
```

### MCP 工具 Hooks

MCP 工具遵循模式 `mcp__<server>__<tool>`：

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "mcp__memory__.*",
        "hooks": [
          {
            "type": "command",
            "command": "echo 'Memory operation' >> ~/mcp.log"
          }
        ]
      },
      {
        "matcher": "mcp__.*__write.*",
        "hooks": [
          {
            "type": "command",
            "command": "/home/user/scripts/validate-mcp-write.py"
          }
        ]
      }
    ]
  }
}
```

### 插件 Hooks

插件可以提供与用户和项目 hooks 无缝集成的 hooks：

```json
{
  "description": "Automatic code formatting",
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/scripts/format.sh",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

**插件环境变量**：
- `${CLAUDE_PLUGIN_ROOT}` - 插件目录的绝对路径
- `${CLAUDE_PROJECT_DIR}` - 项目根目录

### Skills、Agents 和 Slash Commands 中的 Hooks

Hooks 可以直接在组件中定义（使用 frontmatter）：

**Skill 中的示例**：

```markdown
---
name: secure-operations
description: Perform operations with security checks
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/security-check.sh"
---
```

**支持的事件**：`PreToolUse`、`PostToolUse` 和 `Stop`

**额外选项**：`once` - 在每个会话中仅运行一次 hook

---

## 实战案例

### 案例1: 自动代码格式化

**场景**：每次修改文件后自动运行格式化工具

**配置**：

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/format.sh",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

**脚本实现**：

```bash
#!/bin/bash
# .claude/hooks/format.sh

# 获取修改的文件路径
FILE_PATH=$(jq -r '.tool_input.file_path' < /proc/self/fd/0)

# 根据文件类型运行格式化
case "$FILE_PATH" in
    *.py)
        black "$FILE_PATH"
        ;;
    *.js|*.ts|*.tsx)
        prettier --write "$FILE_PATH"
        ;;
    *.go)
        gofmt -w "$FILE_PATH"
        ;;
esac

exit 0
```

### 案例2: 智能停止判断

**场景**：使用 LLM 判断 Claude 是否应该停止工作

**配置**：

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "prompt",
            "prompt": "You are evaluating whether Claude should stop working. Context: $ARGUMENTS\n\nAnalyze the conversation and determine if:\n1. All user-requested tasks are complete\n2. Any errors need to be addressed\n3. Follow-up work is needed\n\nRespond with JSON: {\"ok\": true} to allow stopping, or {\"ok\": false, \"reason\": \"your explanation\"} to continue working.",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

### 案例3: 环境变量持久化

**场景**：在会话开始时设置开发环境

**配置**：

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup",
        "hooks": [
          {
            "type": "command",
            "command": "./scripts/setup-dev-env.sh"
          }
        ]
      }
    ]
  }
}
```

**脚本实现**：

```bash
#!/bin/bash
# scripts/setup-dev-env.sh

# 捕获环境变更
ENV_BEFORE=$(export -p | sort)

# 激活虚拟环境
source .venv/bin/activate

# 设置项目特定变量
export NODE_ENV=development
export API_URL=http://localhost:3000

# 持久化所有环境变更
if [ -n "$CLAUDE_ENV_FILE" ]; then
  ENV_AFTER=$(export -p | sort)
  comm -13 <(echo "$ENV_BEFORE") <(echo "$ENV_AFTER") >> "$CLAUDE_ENV_FILE"
fi

exit 0
```

### 案例4: 安全验证

**场景**：阻止包含敏感信息的提示

**配置**：

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "/path/to/security-check.py"
          }
        ]
      }
    ]
  }
}
```

**脚本实现**：

```python
#!/usr/bin/env python3
import json
import re
import sys

# 从 stdin 加载输入
input_data = json.load(sys.stdin)
prompt = input_data.get("prompt", "")

# 检查敏感模式
sensitive_patterns = [
    (r"(?i)\b(password|secret|key|token)\s*[:=]", "提示包含潜在的敏感信息"),
]

for pattern, message in sensitive_patterns:
    if re.search(pattern, prompt):
        # 使用 JSON 输出阻止提示
        output = {
            "decision": "block",
            "reason": f"安全策略违规：{message}。请重新表述您的请求，不要包含敏感信息。"
        }
        print(json.dumps(output))
        sys.exit(0)

# 允许提示继续进行
sys.exit(0)
```

### 案例5: TaskCreated 任务创建通知 ✨ v2.1.84

**场景**：在创建 Subagent 任务时自动发送通知（如 Slack/邮件）

**配置**：

```json
{
  "hooks": {
    "TaskCreated": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/task-notify.sh"
          }
        ]
      }
    ]
  }
}
```

**脚本实现**：

```bash
#!/bin/bash
# .claude/hooks/task-notify.sh

# 从 stdin 加载 TaskCreate 输入
INPUT=$(cat /dev/stdin)
TASK_NAME=$(echo "$INPUT" | jq -r '.task_name // "未命名任务"')
TASK_DESCRIPTION=$(echo "$INPUT" | jq -r '.description // "无描述"')
TASK_ID=$(echo "$INPUT" | jq -r '.task_id // "unknown"')

# 发送到 Slack
SLACK_WEBHOOK="https://hooks.slack.com/services/YOUR/WEBHOOK/URL"

curl -s -X POST "$SLACK_WEBHOOK" \
  -H 'Content-Type: application/json' \
  -d "{
    \"text\": \"📋 新任务已创建\",
    \"attachments\": [{
      \"color\": \"#36a64f\",
      \"fields\": [
        { \"title\": \"任务名称\", \"value\": \"$TASK_NAME\", \"short\": true },
        { \"title\": \"任务ID\", \"value\": \"$TASK_ID\", \"short\": true },
        { \"title\": \"描述\", \"value\": \"$TASK_DESCRIPTION\" }
      ]
    }]
  }"

exit 0
```

**Windows PowerShell 版本**：

```powershell
# .claude/hooks/task-notify.ps1
$INPUT = Get-Content -Raw
$TASK_NAME = ($INPUT | ConvertFrom-Json).task_name ?? "未命名任务"
$TASK_DESCRIPTION = ($INPUT | ConvertFrom-Json).description ?? "无描述"
$TASK_ID = ($INPUT | ConvertFrom-Json).task_id ?? "unknown"

$SLACK_WEBHOOK = "https://hooks.slack.com/services/YOUR/WEBHOOK/URL"
$BODY = @{
    text = "📋 新任务已创建"
    attachments = @(@{
        color = "#36a64f"
        fields = @(
            @{ title = "任务名称"; value = $TASK_NAME; short = $true },
            @{ title = "任务ID"; value = $TASK_ID; short = $true },
            @{ title = "描述"; value = $TASK_DESCRIPTION }
        )
    })
} | ConvertTo-Json -Depth 10

Invoke-RestMethod -Uri $SLACK_WEBHOOK -Method Post -Body $BODY -ContentType "application/json"
exit 0
```

**使用场景**：
- ✅ 团队协作通知
- ✅ 项目管理集成（JIRA、Trello）
- ✅ 自动化工作流触发
- ✅ 任务审计日志

---

## Windows 专属

### PowerShell Hooks

**Windows 特定配置**：

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "pwsh -File \"$CLAUDE_PROJECT_DIR\"\\.claude\\hooks\\format.ps1\""
          }
        ]
      }
    ]
  }
}
```

**PowerShell 脚本**：

```powershell
# .claude/hooks/format.ps1

param(
    [string]$ProjectDir
)

Write-Host "Running format hook..." -ForegroundColor Cyan

# 获取当前 Git 状态
$status = git status
if ($status -match "modified") {
    Write-Host "检测到未提交的更改" -ForegroundColor Yellow
}

# 运行格式化工具
npm run format

if ($LASTEXITCODE -ne 0) {
    Write-Error "格式化失败"
    exit 1
}

Write-Host "格式化完成" -ForegroundColor Green
exit 0
```

### Windows 路径处理

**使用正斜杠（推荐）**：

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "pwsh -File D:/Projects/app/scripts/check.ps1"
          }
        ]
      }
    ]
  }
}
```

### 权限问题

**确保 Hooks 有执行权限**：

```powershell
# 检查脚本权限
Get-Content scripts\check.ps1 | Select-String -Pattern "pwsh"

# 如果需要，设置执行策略
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---

## 最佳实践

### 1. Hook 匹配精确

```json
// ❌ 不好：太宽泛
{
  "matcher": "代码"
}

// ✅ 好：精确匹配
{
  "matcher": "重构.*代码|优化.*代码"
}
```

### 2. 命令幂等性

```json
// ❌ 不好：可能重复提交
{
  "command": "git commit -m 'Auto commit'"
}

// ✅ 好：先检查再提交
{
  "command": "git diff --quiet && git diff --staged --quiet || git commit -m 'Auto commit'"
}
```

### 3. 错误处理

```json
// ❌ 不好：忽略错误
{
  "command": "npm test || true"
}

// ✅ 好：处理错误
{
  "command": "npm test || echo 'Tests failed'"
}
```

### 4. 使用超时

```json
// ✅ 好：设置合理的超时
{
  "type": "command",
  "command": "npm run format",
  "timeout": 30
}
```

### 5. 安全考虑

- ✅ 验证和清理输入
- ✅ 始终引用 shell 变量 `"$VAR"`
- ✅ 阻止路径遍历
- ✅ 使用绝对路径
- ✅ 跳过敏感文件

---

## 常见问题

### Q1: Hook 没有触发？

**A**: 检查配置

```markdown
1. 检查配置文件路径
   Windows: %APPDATA%\Claude Code\settings.json
   验证: Test-Path $env:APPDATA\Claude\Code\settings.json

2. 检查 JSON 格式
   验证: Get-Content settings.json | ConvertFrom-Json

3. 检查匹配规则
   确保工具名称精确匹配（区分大小写）

4. 重启 Claude Code
   配置更改后需要重启
```

### Q2: Hook 命令执行失败？

**A**: 调试技巧

```powershell
# 1. 手动测试命令
npm test

# 2. 检查命令路径
Get-Command npm

# 3. 检查工作目录
Get-Location

# 4. 检查环境变量
$env:PATH
```

### Q3: 如何调试 Hooks？

**A**: 使用调试模式

```bash
# 启用调试模式
claude --debug

# 查看详细输出
# [DEBUG] Executing hooks for PostToolUse:Write
# [DEBUG] Found 1 hook matchers in settings
# [DEBUG] Matched 1 hooks for query "Write"
```

### Q4: Stop hook 无限循环？

**A**: 检查 `stop_hook_active`，以及 block cap 限制

```json
// Stop hook 输入中包含
{
  "stop_hook_active": true
}

// 检查此值以防止无限循环
```

> **v2.1.143+**: Stop hook 连续阻止超过 8 次后，turn 会自动结束并显示警告。可通过环境变量 `CLAUDE_CODE_STOP_HOOK_BLOCK_CAP` 调整上限。

### Q5: SessionStart hook 中环境变量不持久化？

**A**: 必须使用 `CLAUDE_ENV_FILE`

```bash
#!/bin/bash

# ❌ 不好：直接 export 不持久
export MY_VAR=value

# ✅ 好：写入 CLAUDE_ENV_FILE
if [ -n "$CLAUDE_ENV_FILE" ]; then
  echo 'export MY_VAR=value' >> "$CLAUDE_ENV_FILE"
fi
```

---

## 总结

### Hooks 价值总结

```
自动化
├─ 减少手动操作
├─ 消除人为错误
└─ 节省时间

标准化
├─ 统一流程
├─ 团队一致性
└─ 可追溯

可扩展
├─ 自定义行为
├─ 集成外部工具
└─ 构建生态系统
```

### 使用场景

```
✅ 自动代码格式化
✅ 自动测试执行
✅ 自动提交推送
✅ 团队通知
✅ 工作流集成
✅ 安全验证
✅ 环境配置
✅ 智能决策
```

### 官方 Hook 事件总览

| 事件 | 触发时机 | 用途 |
|------|---------|------|
| **PreToolUse** | 工具调用前 | 验证、批准、记录 |
| **PermissionRequest** | 权限对话框 | 自动决策 |
| **PostToolUse** | 工具调用后 | 格式化、提交、通知 |
| **Notification** | 通知时 | 自定义通知处理 |
| **UserPromptSubmit** | 提交提示时 | 验证、添加上下文 |
| **Stop** | Claude 完成时 | 智能判断是否继续 |
| **SubagentStop** | Subagent 完成时 | 评估结果 |
| **SessionStart** | 会话开始 | 环境设置、加载上下文 |
| **SessionEnd** | 会话结束时 | 清理、记录 |
| **PreCompact** | 压缩前 | 优化压缩内容 |
| **CwdChanged** | 目录变化时 (v2.1.83+) | 噺应式环境管理 (direnv) |
| **FileChanged** | 文件变更时 (v2.1.83+) | 响应文件变更通知 |
| **TaskCreated** | 任务创建时 (v2.1.84+) | 任务通知、自动化 |

---

## 相关资源

### 官方文档
- **[Hooks 参考文档](https://code.claude.com/docs/zh-CN/hooks)** ⭐⭐⭐⭐⭐
- [Hooks 入门指南](https://code.claude.com/docs/zh-CN/hooks-guide)
- [插件参考](https://code.claude.com/docs/zh-CN/plugins-reference#hooks)

### 项目文档
- [工作流自动化](../02-automation/03-workflow-automation.md) - 工作流基础
- [自定义命令](./01-custom-commands.md) - 自定义命令
- [Plugins 系统](../03-advanced-topics/02-plugins.md) - 插件 hooks

---

**最后更新**: 2026-05-30
**难度**: ⭐⭐⭐⭐⭐
**阅读时间**: 50分钟
**重要性**: ⭐⭐⭐⭐⭐

**验证状态**: ✅ 已根据官方文档验证
**官方文档版本**: Claude Code v2.1.156
