# Hooks 机制 - Hooks Mechanism

> **自动化工作流的触发器**

**阅读时间**: 45分钟
**难度**: ⭐⭐⭐⭐⭐
**适用场景**: 自动化工作流、自定义行为、团队协作
**前置要求**: [Level 2 进阶提升](../../skills/), [工作流自动化](../02-automation/03-workflow-automation.md)

---

## 目录

- [Hooks 概述](#hooks-概述)
- [Hook 类型](#hook-类型)
- [配置 Hooks](#配置-hooks)
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

---

## Hook 类型

### 1. prePrompt Hook

**触发时机**：在发送提示词到 Claude 之前

**用途**：

```markdown
✅ 检查 Git 状态
✅ 更新上下文
✅ 验证前置条件
✅ 记录日志
```

**示例**：

```json
// .claude/settings.json

{
  "hooks": {
    "prePrompt": [
      {
        "match": "部署|deploy",
        "command": "git status"
      },
      {
        "match": "审查|review",
        "command": "git diff HEAD~1"
      }
    ]
  }
}
```

### 2. postResponse Hook

**触发时机**：在 Claude 返回响应之后

**用途**：

```markdown
✅ 自动提交代码
✅ 生成文档
✅ 发送通知
✅ 更新状态
```

**示例**：

```json
{
  "hooks": {
    "postResponse": [
      {
        "match": "已修复|fixed",
        "command": "git add . && git commit -m 'Auto commit: Fixed bug'"
      },
      {
        "match": "已生成|generated",
        "command": "node scripts/update-docs.js"
      }
    ]
  }
}
```

### 3. preCommand Hook

**触发时机**：在执行 Claude Code 命令之前

**用途**：

```markdown
✅ 环境检查
✅ 依赖验证
✅ 配置更新
✅ 资源准备
```

### 4. postCommand Hook

**触发时机**：在执行 Claude Code 命令之后

**用途**：

```markdown
✅ 清理临时文件
✅ 保存日志
✅ 资源释放
✅ 状态同步
```

---

## 配置 Hooks

### 基本配置

**配置文件位置**：

```
Windows: %APPDATA%\Claude Code\settings.json
macOS: ~/Library/Application Support/Claude Code/settings.json
Linux: ~/.config/Claude Code/settings.json
```

**配置格式**：

```json
{
  "hooks": {
    "prePrompt": [
      {
        "match": "关键词",
        "command": "命令"
      }
    ],
    "postResponse": [
      {
        "match": "关键词",
        "command": "命令"
      }
    ]
  }
}
```

### Hook 配置详解

#### match 属性

**匹配模式**：

```json
{
  "hooks": {
    "prePrompt": [
      {
        "match": "测试|test",
        "command": "npm test"
      },
      {
        "match": "构建|build",
        "command": "npm run build"
      },
      {
        "match": "部署.*生产环境",
        "command": "scripts/check-prod.sh"
      }
    ]
  }
}
```

**正则表达式支持**：

```json
{
  "hooks": {
    "prePrompt": [
      {
        "match": "^生成.*文档$",
        "command": "node scripts/check-docs.js"
      },
      {
        "match": "(?i)error|warning",
        "command": "scripts/log-issue.sh"
      }
    ]
  }
}
```

#### command 属性

**简单命令**：

```json
{
  "command": "git status"
}
```

**复杂命令（带参数）**：

```json
{
  "command": "node scripts/update-docs.js --output docs/"
}
```

**PowerShell 命令**：

```json
{
  "command": "pwsh -File scripts/check.ps1"
}
```

**链式命令**：

```json
{
  "command": "git add . && git commit -m 'Auto commit'"
}
```

---

## 高级用法

### 条件 Hooks

**基于条件执行**：

```json
{
  "hooks": {
    "prePrompt": [
      {
        "match": "部署",
        "condition": {
          "env": {
            "ENVIRONMENT": "production"
          }
        },
        "command": "scripts/prod-check.sh"
      }
    ]
  }
}
```

### 动态命令

**使用环境变量**：

```json
{
  "hooks": {
    "postResponse": [
      {
        "match": "提交|commit",
        "command": "git commit -m 'Auto: ${PROMPT_TEXT}'"
      }
    ]
  }
}
```

### 上下文感知 Hooks

**基于项目类型**：

```json
{
  "hooks": {
    "prePrompt": [
      {
        "match": "运行测试",
        "condition": {
          "fileExists": "package.json"
        },
        "command": "npm test"
      },
      {
        "match": "运行测试",
        "condition": {
          "fileExists": "pom.xml"
        },
        "command": "mvn test"
      }
    ]
  }
}
```

### Hook 链

**多个 Hooks 顺序执行**：

```json
{
  "hooks": {
    "prePrompt": [
      {
        "match": "部署",
        "command": "scripts/check-status.sh"
      },
      {
        "match": "部署",
        "command": "scripts/run-tests.sh"
      },
      {
        "match": "部署",
        "command": "scripts/build.sh"
      }
    ]
  }
}
```

---

## 实战案例

### 案例1: 自动代码审查工作流

**场景**：每次请求代码审查时自动执行检查

**配置**：

```json
{
  "hooks": {
    "prePrompt": [
      {
        "match": "审查|review",
        "command": "git diff HEAD~1 > /tmp/pr-changes.diff"
      },
      {
        "match": "审查|review",
        "command": "npm run lint"
      },
      {
        "match": "审查|review",
        "command": "npm run test:quick"
      }
    ],
    "postResponse": [
      {
        "match": "审查完成",
        "command": "scripts/save-review.sh"
      }
    ]
  }
}
```

**使用**：

```markdown
👤 你：审查这段代码的变更

[执行流程]
1. [prePrompt] 获取 Git diff
2. [prePrompt] 运行 linter
3. [prePrompt] 运行快速测试
4. [Claude] 执行代码审查
5. [postResponse] 保存审查结果

✅ 完整的自动化工作流
```

### 案例2: 自动文档生成

**场景**：代码修改后自动更新文档

**配置**：

```json
{
  "hooks": {
    "postResponse": [
      {
        "match": "已生成.*函数|已添加.*方法",
        "command": "node scripts/update-api-docs.js"
      },
      {
        "match": "已修改.*README",
        "command": "node scripts/validate-readme.js"
      }
    ]
  }
}
```

**脚本实现**：

```javascript
// scripts/update-api-docs.js

const fs = require('fs');
const { execSync } = require('child_process');

function extractAPIInfo(output) {
  // 从 Claude 响应中提取 API 信息
  const apiRegex = /(?:函数|方法|function|method)\s+(\w+)/g;
  const apis = new Set();
  let match;

  while ((match = apiRegex.exec(output)) !== null) {
    apis.add(match[1]);
  }

  return Array.from(apis);
}

function updateDocs(apis) {
  const readmePath = 'docs/API.md';
  let content = '';

  if (fs.existsSync(readmePath)) {
    content = fs.readFileSync(readmePath, 'utf8');
  }

  // 添加新的 API 文档
  const timestamp = new Date().toISOString();
  content += `\n\n## 更新时间: ${timestamp}\n\n`;
  content += '### 新增/修改的 API\n\n';

  apis.forEach(api => {
    content += `- \`${api}\`\n`;
  });

  fs.writeFileSync(readmePath, content);
  console.log(`文档已更新: ${readmePath}`);
}

// 从环境变量或参数获取 Claude 响应
const claudeOutput = process.env.CLAUDE_RESPONSE || '';
const apis = extractAPIInfo(claudeOutput);

if (apis.length > 0) {
  updateDocs(apis);
}
```

### 案例3: 自动提交和通知

**场景**：修复 Bug 后自动提交并通知团队

**配置**：

```json
{
  "hooks": {
    "postResponse": [
      {
        "match": "已修复.*bug|bug.*已修复",
        "command": "git add . && git commit -m 'fix: Auto commit - Bug fixed by Claude Code'"
      },
      {
        "match": "已修复.*bug|bug.*已修复",
        "command": "git push"
      },
      {
        "match": "已修复.*bug|bug.*已修复",
        "command": "scripts/notify-slack.sh 'Bug 已修复，已推送'"
      }
    ]
  }
}
```

**通知脚本**：

```bash
#!/bin/bash
# scripts/notify-slack.sh

WEBHOOK_URL="https://hooks.slack.com/services/YOUR/WEBHOOK"
MESSAGE="$1"

curl -X POST -H 'Content-type: application/json' \
  --data "{\"text\":\"${MESSAGE}\"}" \
  "$WEBHOOK_URL"
```

---

## Windows 专属

### PowerShell Hooks

**Windows 特定配置**：

```json
{
  "hooks": {
    "prePrompt": [
      {
        "match": "构建|build",
        "command": "pwsh -File scripts\\check.ps1"
      }
    ]
  }
}
```

**PowerShell 脚本**：

```powershell
# scripts/check.ps1

param(
    [string]$MatchText
)

Write-Host "Hook 触发: $MatchText" -ForegroundColor Cyan

# 检查 Git 状态
$status = git status
if ($status -match "modified") {
    Write-Host "检测到未提交的更改" -ForegroundColor Yellow
}

# 运行 linter
Write-Host "运行 linter..."
npm run lint

if ($LASTEXITCODE -ne 0) {
    Write-Error "Lint 失败，终止操作"
    exit 1
}

Write-Host "检查完成" -ForegroundColor Green
```

### Windows 路径处理

**使用正斜杠**：

```json
{
  "hooks": {
    "prePrompt": [
      {
        "match": "测试|test",
        "command": "pwsh -File D:/Projects/app/scripts/check.ps1"
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
  "match": "代码"
}

// ✅ 好：精确匹配
{
  "match": "重构.*代码|优化.*代码"
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

### 4. 日志记录

```json
// ✅ 添加日志
{
  "command": "pwsh -File scripts/hook-log.ps1 -Match '部署' -Command 'prePrompt'"
}
```

```powershell
# scripts/hook-log.ps1

param([string]$Match, [string]$Command)

$LogFile = ".claude/hooks.log"
$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$Entry = "[$Timestamp] Hook: $Command (match: '$Match')"

Add-Content -Path $LogFile -Value $Entry
```

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
   确保关键词能匹配到你的提示词

4. 重启 Claude Code
   配置更改后需要重启
```

### Q2: Hook 命令执行失败？

**A**: 调试技巧

```powershell
# 手动测试命令

# 1. 在终端直接运行命令
npm test

# 2. 检查命令路径
Get-Command npm

# 3. 检查工作目录
Get-Location

# 4. 检查环境变量
$env:PATH
```

### Q3: 如何调试 Hooks？

**A**: 使用日志

```json
{
  "hooks": {
    "prePrompt": [
      {
        "match": ".*",
        "command": "echo 'Pre-prompt hook triggered' >> .claude/hooks.log"
      }
    ]
  }
}
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
✅ 自动代码审查
✅ 自动文档生成
✅ 自动测试执行
✅ 自动提交推送
✅ 团队通知
✅ 工作流集成
```

---

## 相关资源

### 项目文档
- [工作流自动化](../02-automation/03-workflow-automation.md) - 工作流基础
- [自定义命令](./01-custom-commands.md) - 自定义命令

### 外部资源
- [Git Hooks](https://git-scm.com/book/githooks/)
- [Webhooks](https://en.wikipedia.org/wiki/Webhook)

---

**最后更新**: 2026-01-18
**难度**: ⭐⭐⭐⭐⭐
**阅读时间**: 45分钟
**重要性**: ⭐⭐⭐⭐
