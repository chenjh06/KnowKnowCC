# managed-settings.d/ 策略片段化管理

> **团队级配置的模块化管理方案**

**阅读时间**: 20分钟
**难度**: ⭐⭐⭐
**适用场景**: 团队协作、企业部署、多策略管理
**前置要求**: [Hooks 机制](./03-hooks.md), [Level 2 进阶提升](../../advanced/README.md)
**版本**: v2.1.83+

---

## 目录

- [概述](#概述)
- [配置文件位置](#配置文件位置)
- [工作原理](#工作原理)
- [合并规则详解](#合并规则详解)
- [文件排序与命名](#文件排序与命名)
- [实战案例](#实战案例)
- [Windows 专属](#windows-专属)
- [最佳实践](#最佳实践)
- [常见问题](#常见问题)

---

## 概述

### 什么是 managed-settings？

**定义**：`managed-settings.json` 是管理员级别的配置文件，用于统一部署 Claude Code 的安全策略、权限规则和 Hooks，用户无法通过本地设置覆盖。

```
设置优先级（从高到低）：

1. Managed Settings（最高优先级，用户无法覆盖）
   ├─ Server-managed（通过 Claude.ai 管理控制台）
   ├─ MDM/OS-level（macOS 配置描述文件 / Windows 注册表）
   └─ File-based（managed-settings.json + managed-settings.d/）
        ↓
2. 命令行参数
        ↓
3. .claude/settings.local.json  ← 用户本地项目设置
        ↓
4. .claude/settings.json        ← 项目共享设置
        ↓
5. ~/.claude/settings.json      ← 用户全局设置
```

### 为什么需要 managed-settings.d/？

```
传统方式：
managed-settings.json（单一文件）
├─ 所有团队策略混在一起
├─ 修改一个策略影响整个文件
├─ 多团队协调困难
└─ 无法独立部署

片段化方式：
managed-settings.d/
├── 10-telemetry.json      ← 监控团队管理
├── 20-security.json       ← 安全团队管理
├── 30-ci-cd.json          ← DevOps 团队管理
└── 40-team-defaults.json  ← 项目管理管理

✅ 各团队独立管理自己的策略
✅ 修改互不影响
✅ 按需组合
```

---

## 配置文件位置

### managed-settings.json 位置

| 平台 | 路径 |
|------|------|
| **macOS** | `/Library/Application Support/ClaudeCode/managed-settings.json` |
| **Linux/WSL** | `/etc/claude-code/managed-settings.json` |
| **Windows** | `C:/Program Files/ClaudeCode/managed-settings.json` |

### managed-settings.d/ 目录位置

| 平台 | 路径 |
|------|------|
| **macOS** | `/Library/Application Support/ClaudeCode/managed-settings.d/` |
| **Linux/WSL** | `/etc/claude-code/managed-settings.d/` |
| **Windows** | `C:/Program Files/ClaudeCode/managed-settings.d/` |

> **注意**: 这些是系统级目录，通常需要管理员/root 权限才能修改。

### 托管设置的四种投递机制

除了本文重点介绍的 File-based 方式外，Claude Code 还支持以下托管设置投递机制：

| 投递方式 | 平台 | 说明 |
|---------|------|------|
| **Server-managed** | 全平台 | 通过 Claude.ai 管理控制台远程推送，无需本地文件 |
| **MDM/OS-level** | macOS | 通过 `com.anthropic.claudecode` 配置描述文件部署 |
| **File-based** | 全平台 | `managed-settings.json` + `managed-settings.d/`（本文重点） |
| **Windows 注册表** | Windows | `HKLM\SOFTWARE\Policies\ClaudeCode` 或 `HKCU\SOFTWARE\Policies\ClaudeCode` |

> **重要**: 不同托管来源之间**不会合并**，只使用优先级最高的那一个。在同一来源层级内，才会进行合并。

### managed-mcp.json

除了 `managed-settings.json`，系统目录还支持 `managed-mcp.json`，用于管理员统一管理 MCP 服务器配置：

```
macOS:   /Library/Application Support/ClaudeCode/managed-mcp.json
Linux:   /etc/claude-code/managed-mcp.json
Windows: C:/Program Files/ClaudeCode/managed-mcp.json
```

与 `managed-settings.json` 类似，`managed-mcp.json` 也支持 `managed-mcp.d/` drop-in 目录进行模块化管理。

---

### 加载顺序

```
1. 加载 managed-settings.json（基础配置）
        ↓
2. 扫描 managed-settings.d/ 目录
        ↓
3. 按字母顺序排序 *.json 文件
   （忽略 . 开头的隐藏文件）
        ↓
4. 依次加载并合并到基础配置
        ↓
5. 最终生效的配置 = 合并后的结果
```

### 合并流程图

```
managed-settings.json          ← 基础
        ↓
+ 10-telemetry.json            ← 第一层覆盖
        ↓
+ 20-security.json             ← 第二层覆盖
        ↓
+ 30-ci-cd.json                ← 第三层覆盖
        ↓
= 最终生效配置
```

---

## 合并规则详解

### 规则 1：标量值（覆盖）

**字符串、数字、布尔值** — 后加载的覆盖先加载的

*managed-settings.json:*
```json
{
  "autoUpdaterStatus": "disabled"
}
```

*managed-settings.d/10-update.json:*
```json
{
  "autoUpdaterStatus": "enabled"
}
```

**最终结果**：`enabled`（后者覆盖前者）

### 规则 2：数组（连接并去重）

*managed-settings.json:*
```json
{
  "deny": ["Bash(rm -rf *)"]
}
```

*managed-settings.d/20-security.json:*
```json
{
  "deny": ["Bash(*production*)"]
}
```

**最终结果**：
```
deny = ["Bash(rm -rf *)", "Bash(*production*)"]
```

### 规则 3：对象（深度合并）

*managed-settings.json:*
```json
{
  "hooks": {
    "PreToolUse": [
      { "matcher": "Write", "hooks": ["..."] }
    ]
  }
}
```

*managed-settings.d/30-ci-cd.json:*
```json
{
  "hooks": {
    "PostToolUse": [
      { "matcher": "Bash", "hooks": ["..."] }
    ]
  }
}
```

**最终结果**：
```
hooks = {
  "PreToolUse": [...],   ← 来自基础
  "PostToolUse": [...]   ← 来自片段
}
```

### 规则 4：隐藏文件忽略

```
managed-settings.d/
├── .bak-settings.json    ← ❌ 被忽略（. 开头）
├── .old-rules.json       ← ❌ 被忽略
├── 10-telemetry.json     ← ✅ 正常加载
└── 20-security.json      ← ✅ 正常加载
```

---

## 文件排序与命名

### 排序规则

文件按**字母顺序**排序后依次加载。

### 推荐命名：数字前缀

```
✅ 推荐（数字前缀控制顺序）：
10-telemetry.json         ← 最先加载（基础监控）
20-security.json          ← 安全规则
30-ci-cd.json             ← CI/CD 规则
40-team-defaults.json     ← 团队默认值
50-experimental.json      ← 实验性规则（最后加载，可覆盖前面）

⚠️ 不推荐（纯字母排序）：
alpha-rules.json
beta-rules.json
security.json
team.json
（顺序依赖文件名本身，不直观）
```

### 命名约定

```
格式：<优先级>-<团队或功能>.json

示例：
10-telemetry.json          监控策略（优先加载）
20-security.json           安全策略
30-ci-cd.json              CI/CD 策略
40-compliance.json         合规策略
50-team-defaults.json      团队默认配置
60-override.json           覆盖配置（最后加载）
```

---

## 实战案例

### 案例 1: 多团队协作配置

**场景**: 3个团队共同管理 Claude Code 策略

**基础配置** (`managed-settings.json`):

```json
{
  "autoUpdaterStatus": "enabled",
  "permissions": {
    "deny": [
      "Bash(rm -rf *)"
    ]
  }
}
```

**监控策略** (`10-telemetry.json`):

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup",
        "hooks": [
          {
            "type": "command",
            "command": "/opt/scripts/log-session.sh"
          }
        ]
      }
    ]
  }
}
```

**安全策略** (`20-security.json`):

```json
{
  "permissions": {
    "deny": [
      "Bash(*production*)",
      "Bash(*deploy*)",
      "Bash(git push --force*)"
    ]
  },
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "/opt/scripts/security-audit.sh",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
```

**CI/CD 策略** (`30-ci-cd.json`):

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "/opt/scripts/auto-lint.sh",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

**最终合并结果**:

```
permissions.deny = [
  "Bash(rm -rf *)",              ← 基础配置
  "Bash(*production*)",          ← 安全策略
  "Bash(*deploy*)",              ← 安全策略
  "Bash(git push --force*)"      ← 安全策略
]

hooks = {
  SessionStart: [...],           ← 监控策略
  PreToolUse: [...],             ← 安全策略
  PostToolUse: [...]             ← CI/CD 策略
}
```

### 案例 2: 企业合规部署

**场景**: 在所有开发者机器上部署统一的合规策略

**部署脚本** (macOS):

```bash
#!/bin/bash
# deploy-compliance.sh

MANAGED_DIR="/Library/Application Support/ClaudeCode"
DROPIN_DIR="$MANAGED_DIR/managed-settings.d"

# 创建目录
sudo mkdir -p "$DROPIN_DIR"

# 部署基础配置
sudo cp managed-settings.json "$MANAGED_DIR/"

# 部署策略片段
sudo cp 10-telemetry.json "$DROPIN_DIR/"
sudo cp 20-security.json "$DROPIN_DIR/"
sudo cp 30-compliance.json "$DROPIN_DIR/"
sudo cp 40-audit.json "$DROPIN_DIR/"

# 设置权限
sudo chmod 644 "$MANAGED_DIR/managed-settings.json"
sudo chmod 644 "$DROPIN_DIR"/*.json

echo "合规策略部署完成"
```

### 案例 3: 禁用特定功能

**场景**: 禁用 Auto Mode 和远程控制

**配置** (`50-restrictions.json`):

```json
{
  "permissions": {
    "deny": [
      "Bash(claude --enable-auto-mode*)",
      "Bash(*remote-control*)"
    ]
  }
}
```

---

## Windows 专属

### Windows 目录权限

```powershell
# managed-settings.d/ 在 Windows 上的位置
$dropinDir = "C:\Program Files\ClaudeCode\managed-settings.d"

# 检查目录是否存在
Test-Path $dropinDir

# 创建目录（需要管理员权限）
New-Item -ItemType Directory -Path $dropinDir -Force

# 查看已部署的策略
Get-ChildItem $dropinDir -Filter "*.json"
```

### 部署脚本 (Windows)

```powershell
# deploy-compliance.ps1
# 需要以管理员身份运行

$managedDir = "C:\Program Files\ClaudeCode"
$dropinDir = "$managedDir\managed-settings.d"

# 创建目录
if (-not (Test-Path $dropinDir)) {
    New-Item -ItemType Directory -Path $dropinDir -Force
}

# 部署策略文件
$files = @(
    "managed-settings.json",
    "10-telemetry.json",
    "20-security.json",
    "30-ci-cd.json"
)

foreach ($file in $files) {
    $source = ".\policies\$file"
    if (Test-Path $source) {
        if ($file -eq "managed-settings.json") {
            Copy-Item $source $managedDir -Force
        } else {
            Copy-Item $source $dropinDir -Force
        }
        Write-Host "已部署: $file" -ForegroundColor Green
    }
}

# 验证部署
Write-Host "`n已部署的策略:" -ForegroundColor Cyan
Get-ChildItem $dropinDir -Filter "*.json" | ForEach-Object {
    Write-Host "  $($_.Name)"
}
```

### 路径注意事项

```
Windows 路径规则：
├─ 文档正文中使用正斜杠：C:/Program Files/ClaudeCode/
├─ PowerShell 代码块中可用反斜杠：C:\Program Files\ClaudeCode\
├─ Program Files 目录需要管理员权限
└─ 路径中包含空格时必须使用引号
```

### 旧路径迁移

> **重要**: v2.1.75 起，Windows 旧路径 `C:/ProgramData/ClaudeCode/` 已**废弃**。
> 如果你从旧版本升级，请将配置迁移到新路径 `C:/Program Files/ClaudeCode/`。

```powershell
# 检查是否使用了旧路径
$oldPath = "C:\ProgramData\ClaudeCode"
if (Test-Path $oldPath) {
    Write-Warning "检测到旧路径 $oldPath，请迁移到新路径"
    Write-Host "新路径: C:\Program Files\ClaudeCode\" -ForegroundColor Green
}
```

---

## 最佳实践

### 1. 使用数字前缀命名

```
✅ 好：
10-base.json → 20-security.json → 30-override.json
（顺序清晰，意图明确）

❌ 不好：
a-rules.json → b-rules.json → z-rules.json
（排序依赖字母，容易混乱）
```

### 2. 每个文件单一职责

```
✅ 好：
10-telemetry.json    ← 只管监控
20-security.json     ← 只管安全
30-ci-cd.json        ← 只管 CI/CD

❌ 不好：
all-rules.json       ← 所有规则混在一起
（失去了分文件的意义）
```

### 3. 利用隐藏文件禁用策略

```bash
# 临时禁用某个策略（重命名为 . 开头）
mv 20-security.json .20-security.json

# 恢复策略
mv .20-security.json 20-security.json
```

### 4. 保持 managed-settings.json 精简

```json
// managed-settings.json 只放最基础的配置
{
  "autoUpdaterStatus": "enabled"
}

// 具体策略放在 managed-settings.d/ 中
// 这样基础配置不会频繁变更
```

### 5. 版本控制策略文件

```
推荐结构：
policies/
├── managed-settings.json
├── 10-telemetry.json
├── 20-security.json
└── deploy.sh          ← 部署脚本

用 Git 管理策略变更历史
```

---

## 常见问题

### Q1: managed-settings.d/ 不生效？

**A**: 检查以下几点：

```
1. 目录路径是否正确（需要管理员权限的路径）
2. 文件扩展名是否为 .json
3. 文件名是否以 . 开头（隐藏文件被忽略）
4. JSON 格式是否正确
5. 是否重启了 Claude Code
```

### Q2: 如何查看最终生效的配置？

**A**: 使用配置查看命令：

```bash
# 方法1: 在 Claude Code 内使用 /status 查看活跃的设置来源
# 输入 /status 即可看到当前加载的配置层级

# 方法2: 直接检查原始文件（不会显示合并结果）
cat /etc/claude-code/managed-settings.json
ls /etc/claude-code/managed-settings.d/

# macOS
ls "/Library/Application Support/ClaudeCode/managed-settings.d/"

# Windows PowerShell
Get-Content "C:/Program Files/ClaudeCode/managed-settings.json"
Get-ChildItem "C:/Program Files/ClaudeCode/managed-settings.d/" -Filter "*.json"
```

### Q3: 片段之间有冲突怎么办？

**A**: 按加载顺序处理：

```
标量值：后加载的覆盖先加载的
数组值：连接合并，不会冲突
对象值：深度合并，同键则后者覆盖

建议：用数字前缀控制覆盖顺序
如需要覆盖基础配置，使用更大的数字前缀
```

### Q4: managed-settings.json 和 .d/ 哪个优先？

**A**: managed-settings.json 先加载，.d/ 中的文件后加载：

```
加载顺序：managed-settings.json → .d/*.json（按字母排序）

具体覆盖规则：
├─ 标量值（字符串/数字/布尔）：后加载的覆盖先加载的
├─ 数组：连接合并并去重，不会互相覆盖
└─ 对象：深度合并，同名键则后者覆盖

建议：用数字前缀控制覆盖行为
如需要覆盖基础配置，使用更大的数字前缀（如 50-override.json）
```

### Q5: 如何在不重启的情况下重新加载？

**A**: 目前需要重启 Claude Code 才能重新加载 managed-settings。

```bash
# 退出当前会话
/exit

# 重新启动
claude
```

### Q6: Windows 上无法创建 managed-settings.d/？

**A**: Program Files 目录需要管理员权限：

```powershell
# 以管理员身份运行 PowerShell
# 右键 → 以管理员身份运行

$dir = "C:\Program Files\ClaudeCode\managed-settings.d"
New-Item -ItemType Directory -Path $dir -Force

# 验证
Test-Path $dir
```

---

## 总结

### managed-settings.d/ 优势

```
模块化
├─ 各团队独立管理策略
├─ 单一职责原则
└─ 按需组合

安全性
├─ 管理员级目录保护
├─ 用户无法覆盖
└─ 版本控制友好

灵活性
├─ 数字前缀控制顺序
├─ 隐藏文件禁用策略
└─ 热插拔式管理
```

### 适用场景

```
✅ 企业多团队协作
✅ 合规策略统一部署
✅ 安全规则集中管理
✅ CI/CD 流程标准化
✅ 实验性策略隔离测试
✅ 多环境（dev/staging/prod）策略差异管理
```

---

## 相关资源

### 官方文档
- **[Managed Settings](https://docs.anthropic.com/en/docs/claude-code/settings)** — 设置管理
- **[Permission Modes](https://docs.anthropic.com/en/docs/claude-code/permission-modes)** — 权限模式

### 项目文档
- [Hooks 机制](./03-hooks.md) — 自动化触发器
- [Auto Mode](../../advanced/a-productivity/08-auto-mode.md) — 自动模式
- [MCP Elicitation](./05-mcp-elicitation.md) — 结构化输入请求

---

**最后更新**: 2026-03-28
**难度**: ⭐⭐⭐
**阅读时间**: 20分钟
**重要性**: ⭐⭐⭐⭐
**验证状态**: ✅ 已根据官方文档验证（Claude Code v2.1.83+）
