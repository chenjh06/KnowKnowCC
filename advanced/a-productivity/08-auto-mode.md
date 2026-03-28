# Auto Mode 自动模式 - Auto Mode

> **让 Claude 自主执行安全操作，减少确认弹窗**

**阅读时间**: 25分钟
**难度**: ⭐⭐⭐⭐
**适用场景**: 日常开发、批量操作、自动化工作流
**前置要求**: Team 或 Enterprise 计划、Claude Sonnet 4.6 或 Opus 4.6
**版本**: v2.1.84+

---

## 目录

- [Auto Mode 概述](#auto-mode-概述)
- [启用方式](#启用方式)
- [风险分类器原理](#风险分类器原理)
- [决策流程](#决策流程)
- [默认规则](#默认规则)
- [自定义规则](#自定义规则)
- [实战案例](#实战案例)
- [Windows 专属](#windows-专属)
- [最佳实践](#最佳实践)
- [常见问题](#常见问题)

---

## Auto Mode 概述

### 什么是 Auto Mode？

**定义**：Auto Mode 是 Claude Code 的自动执行模式，内置风险分类器自动判断操作安全性，安全操作直接执行，风险操作仍需确认。

```
默认模式：
操作请求 → 弹出确认对话框 → 用户手动批准 → 执行
（每个操作都需要确认，效率低）

Auto Mode：
操作请求 → 内置分类器判断 → 安全操作自动执行
                        → 风险操作仍需确认
（安全操作无需等待，效率大幅提升）
```

### 为什么需要 Auto Mode？

```
1. 效率提升
   ├─ 安全操作自动执行，无需等待确认
   ├─ 批量操作不再逐个审批
   └─ 开发流程更流畅

2. 智能判断
   ├─ 独立分类器模型评估风险
   ├─ 基于上下文理解操作意图
   └─ 持续保护安全边界

3. 灵活控制
   ├─ 可自定义 allow/deny 规则
   ├─ 支持团队级统一配置
   └─ 回退机制防止失控
```

### 前置条件

| 条件 | 要求 | 说明 |
|------|------|------|
| **计划类型** | Team 或 Enterprise | Starter/Pro 不支持 |
| **模型** | Sonnet 4.6 或 Opus 4.6 | 不支持 Haiku、claude-3 模型 |
| **管理员启用** | 需要预先开启 | Claude Code admin settings 中启用 |
| **平台** | 不支持第三方提供商 | Bedrock、Vertex、Foundry 暂不支持 |

> **注意**: 如果你的计划或模型不满足条件，`--enable-auto-mode` 不会生效。

---

## 启用方式

### 方式 1：启动参数（推荐）

```bash
# 启动时直接启用
claude --enable-auto-mode
```

### 方式 2：Shift+Tab 切换

```
在会话中按 Shift+Tab 循环切换模式：
Default → Auto → Plan → Default → ...
```

### 方式 3：配置文件

```json
// settings.json
{
  "permissions": {
    "allow": [],
    "deny": []
  },
  "autoMode": true
}
```

---

## 风险分类器原理

### 架构

```
用户消息 + 工具调用
        ↓
┌─────────────────────┐
│  独立分类器模型      │  ← 运行在 Claude Sonnet 4.6 上
│  (与主模型分离)      │
└─────────────────────┘
        ↓
   允许 / 阻止
```

### 关键设计

| 特性 | 说明 |
|------|------|
| **独立模型** | 分类器与主 Claude 模型分离，运行在 Sonnet 4.6 上 |
| **输入范围** | 只接收用户消息和工具调用（不包括 Claude 的文本输出和工具结果） |
| **CLAUDE.md 感知** | 分类器会读取 CLAUDE.md 内容辅助判断 |
| **防注入** | 工具结果不传给分类器，文件/网页中的恶意内容无法操纵判断 |

### 分类器处理流程

```
1. 接收用户消息和工具调用参数
       ↓
2. 读取 CLAUDE.md 中的自定义规则
       ↓
3. 基于安全策略评估操作
       ↓
4. 返回决策：允许 / 阻止（附原因）
```

---

## 决策流程

### 完整决策链

```
操作请求
    ↓
[Step 1] 匹配 allow/deny 规则？
    ├─ 匹配 allow → 自动批准 ✅
    └─ 匹配 deny  → 阻止 ❌
    ↓ 未匹配
[Step 2] 只读操作或工作目录内文件编辑？
    ├─ 是 → 自动批准 ✅
    └─ 否 → 继续
    ↓
[Step 3] 交给分类器评估
    ├─ 分类器允许 → 自动执行 ✅
    └─ 分类器阻止 → Claude 收到原因，尝试替代方案
```

### 回退机制

```
连续被阻止 3 次  → Auto Mode 暂停
总计被阻止 20 次 → Auto Mode 暂停
    ↓
恢复逐个提示确认模式
    ↓
用户可以手动重新启用 Auto Mode
```

---

## 默认规则

### 默认允许的操作

| 操作类型 | 示例 | 说明 |
|----------|------|------|
| **本地文件读写** | 编辑 `src/app.ts` | 工作目录内的文件操作 |
| **已声明的依赖安装** | `npm install` | lock 文件或 manifest 中已有的包 |
| **.env 读取** | 读取 `.env` | 将凭据发送到匹配的 API |
| **只读 HTTP** | `GET /api/status` | 不修改外部状态 |
| **分支推送** | `git push origin feature/xxx` | 推送到当前分支或 Claude 创建的分支 |

### 默认阻止的操作

| 操作类型 | 示例 | 说明 |
|----------|------|------|
| **下载执行** | `curl URL \| bash` | 下载并执行远程代码 |
| **数据外传** | 发送到未知端点 | 发送敏感数据到外部 |
| **生产部署** | `deploy to production` | 生产环境操作 |
| **批量删除** | 删除云存储文件 | 云存储上的批量删除 |
| **权限授予** | IAM 权限操作 | 授予 IAM 或仓库权限 |
| **基础设施修改** | 修改共享配置 | 修改共享基础设施 |
| **不可逆文件销毁** | `rm -rf /important` | 销毁会话前存在的文件 |
| **破坏性 Git** | `git push --force` | force push 或推送到 main |

---

## 自定义规则

### 查看规则

```bash
# 查看内置默认规则
claude auto-mode defaults

# 查看实际生效的规则（含自定义）
claude auto-mode config

# AI 审查你的自定义规则
claude auto-mode critique
```

### 配置 allow/deny 规则

```json
// settings.json
{
  "permissions": {
    "allow": [
      "Bash(npm run *)",
      "Bash(git commit*)",
      "Read",
      "Edit",
      "Write"
    ],
    "deny": [
      "Bash(git push --force*)",
      "Bash(rm -rf *)"
    ]
  }
}
```

### 规则语法

```
ToolPattern              # 匹配工具名: Read, Edit, Write
Tool(pattern)            # 匹配工具+参数: Bash(npm *)
Tool(pattern1|pattern2)  # 多模式: Bash(git *|npm *)
*                        # 匹配所有
```

---

## 实战案例

### 案例 1: 日常开发

**场景**: 日常前端开发，需要频繁编辑文件、运行测试

**配置**:

```json
{
  "permissions": {
    "allow": [
      "Edit",
      "Write",
      "Read",
      "Bash(npm run *)",
      "Bash(npm test*)"
    ]
  }
}
```

**效果**:
- 编辑文件 → 自动执行
- 运行测试 → 自动执行
- 安装新包 → 分类器判断
- 删除文件 → 分类器判断

### 案例 2: 安全敏感项目

**场景**: 后端 API 项目，需要严格控制数据库和部署操作

**配置**:

```json
{
  "permissions": {
    "allow": [
      "Read",
      "Edit",
      "Bash(npm test*)",
      "Bash(git commit*)"
    ],
    "deny": [
      "Bash(*production*)",
      "Bash(*deploy*)",
      "Bash(*database*)",
      "Bash(mongod*)",
      "Bash(psycopg*)"
    ]
  }
}
```

### 案例 3: Windows 开发环境

**场景**: Windows 开发者使用 PowerShell + Node.js

**配置**:

```json
{
  "permissions": {
    "allow": [
      "Edit",
      "Write",
      "Read",
      "Bash(npm *)",
      "Bash(pwsh *)"
    ]
  }
}
```

**注意**:
- Auto Mode **不支持 PowerShell 工具**（v2.1.84 预览限制）
- `pwsh` 命令通过 Bash 工具执行可以工作
- Windows 驱动器根目录的危险删除有额外保护

---

## Windows 专属

### Windows 兼容性

| 功能 | 状态 | 说明 |
|------|------|------|
| Auto Mode 核心 | ✅ 支持 | 正常工作 |
| PowerShell 工具集成 | ❌ 不支持 | Auto Mode 不支持 PowerShell 工具（预览限制） |
| 驱动器根目录保护 | ✅ 增强 | v2.1.84 改进了 `C:\`、`C:\Windows` 等危险删除检测 |
| Git Bash 执行 | ✅ 支持 | 通过 Bash 工具执行 pwsh 命令可用 |

### Windows 配置示例

```powershell
# 检查当前规则
claude auto-mode config

# 查看默认规则
claude auto-mode defaults

# 启动 Auto Mode
claude --enable-auto-mode
```

### 路径安全

```
Auto Mode 在 Windows 上的额外保护：
├─ 阻止删除 C:\ 根目录
├─ 阻止删除 C:\Windows
├─ 阻止删除 C:\Program Files
├─ 阻止删除 C:\Users（非工作目录）
└─ 工作目录内的操作正常自动批准
```

---

## 最佳实践

### 1. 从保守配置开始

```json
// 先只允许基本操作
{
  "permissions": {
    "allow": ["Read", "Edit"],
    "deny": []
  }
}
```

逐步放宽，观察分类器行为后再增加 allow 规则。

### 2. 明确 deny 危险操作

```json
{
  "permissions": {
    "deny": [
      "Bash(git push --force*)",
      "Bash(*production*)",
      "Bash(*deploy*)"
    ]
  }
}
```

### 3. 使用 critique 审查规则

```bash
# 让 AI 审查你的规则配置
claude auto-mode critique
```

### 4. 定期检查配置

```bash
# 查看实际生效规则
claude auto-mode config
```

### 5. 团队统一配置

通过 `managed-settings.json` 或 `managed-settings.d/` 部署团队级规则，确保一致性。

---

## 常见问题

### Q1: Auto Mode 不可用？

**A**: 检查前置条件：

```
1. 确认计划类型（需 Team 或 Enterprise）
2. 确认模型（需 Sonnet 4.6 或 Opus 4.6）
3. 确认管理员已启用
4. 确认不是通过 Bedrock/Vertex/Foundry 使用
```

### Q2: 操作被意外阻止？

**A**: 检查决策链：

```bash
# 查看实际规则
claude auto-mode config

# 添加明确的 allow 规则
# 在 settings.json 的 permissions.allow 中添加
```

### Q3: Auto Mode 自动暂停了？

**A**: 触发了回退机制：

```
原因 1: 连续被阻止 3 次
原因 2: 总计被阻止 20 次

解决:
- 检查被阻止的操作是否合理
- 调整 allow/deny 规则
- 手动重新启用 Auto Mode
```

### Q4: 分类器判断不准确？

**A**: 优化策略：

```
1. 在 CLAUDE.md 中添加项目特定规则
   分类器会读取 CLAUDE.md 辅助判断

2. 使用明确的 allow/deny 规则
   精确匹配比依赖分类器更可靠

3. 使用 critique 命令审查
   claude auto-mode critique
```

### Q5: Auto Mode 和 PowerShell 工具能同时使用？

**A**: 不能。Auto Mode 不支持 PowerShell 工具（v2.1.84 预览限制）。

替代方案：通过 Bash 工具执行 `pwsh -Command "..."` 可以在 Auto Mode 下工作。

### Q6: 如何恢复到默认模式？

**A**: 按 `Shift+Tab` 循环切换回 Default 模式，或退出重启时不加 `--enable-auto-mode`。

---

## 总结

### Auto Mode 适用场景

```
✅ 日常开发（编辑、测试、Git 操作）
✅ 代码重构（批量文件修改）
✅ 自动化工作流
✅ CI/CD 管道集成
❌ 生产环境操作（建议保持默认模式）
❌ 敏感数据处理（建议自定义 deny 规则）
```

### 关键要点

```
1. 分类器独立于主模型，防止上下文操纵
2. 默认规则覆盖常见安全场景
3. allow/deny 规则优先级最高
4. 回退机制防止失控
5. 团队可通过 managed-settings 统一配置
```

---

## 相关资源

### 官方文档
- **[Permission Modes](https://docs.anthropic.com/en/docs/claude-code/permission-modes)** — 权限模式详解
- **[Permissions](https://docs.anthropic.com/en/docs/claude-code/permissions)** — 权限规则语法

### 项目文档
- [Plan 模式](./01-plan-mode.md) — Plan 模式深度指南
- [上下文优化](./04-context-optimization.md) — Token 使用优化
- [Hooks 机制](../../master/01-customization/03-hooks.md) — 自动化触发器

---

**最后更新**: 2026-03-28
**难度**: ⭐⭐⭐⭐
**阅读时间**: 25分钟
**重要性**: ⭐⭐⭐⭐⭐
**版本**: v2.1.84+
**验证状态**: ✅ 已根据官方文档验证
