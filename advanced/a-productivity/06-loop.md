# /loop 循环任务调度

> **让 Claude Code 成为持续运行的后台工作器**

**阅读时间**: 15分钟
**版本**: v2.1.71
**难度**: ⭐⭐⭐

---

## 目录

- [概述](#概述)
- [基本语法](#基本语法)
- [时间格式](#时间格式)
- [实战场景](#实战场景)
- [限制与注意事项](#限制与注意事项)
- [最佳实践](#最佳实践)
- [常见问题](#常见问题)

---

## 概述

### 什么是 /loop？

`/loop` 是 Claude Code v2.1.71 引入的循环任务调度命令，让你设置定期执行的后台任务。

```
传统模式：
你 → 执行一次 → 得到结果 → 结束

/loop 模式：
你 → 设置任务 → Claude 定期执行 → 持续监控 → 结果推送
```

### 核心价值

| 价值 | 说明 |
|------|------|
| 自动化监控 | 持续监控部署、CI、PR 等状态变化 |
| 主动通知 | 状态变化时主动推送结果 |
| 资源节约 | 无需手动轮询，让 AI 持续工作 |

---

## 基本语法

### 简单用法

```bash
# 默认 10 分钟间隔
/loop monitor CI pipeline status

# 指定间隔
/loop 5m check if the staging deployment was successful

# 小时为单位
/loop 1h scan src/ for code quality issues

# 天为单位
/loop 24h summarize all code changes from yesterday
```

### 语法结构

```
/loop <间隔> <任务描述>
```

| 参数 | 必需 | 说明 |
|------|------|------|
| 间隔 | 否 | 时间间隔，默认为 10 分钟 |
| 任务描述 | 是 | 要执行的自然语言任务 |

---

## 时间格式

### 支持的时间单位

| 单位 | 缩写 | 示例 |
|------|------|------|
| 分钟 | `m` | `5m` = 5分钟 |
| 小时 | `h` | `1h` = 1小时 |
| 天 | `d` | `1d` = 24小时 |

### 常见间隔设置

```bash
# 快速监控（1-5分钟）
/loop 1m check if build is still running
/loop 2m monitor error rates in logs

# 普通监控（10-30分钟）
/loop 10m check PR comments
/loop 15m monitor staging environment
/loop 30m verify database replication status

# 长周期任务（1小时以上）
/loop 1h generate code quality report
/loop 6h check disk space usage
/loop 24h backup important files
```

---

## 实战场景

### 场景 1: PR 监控

```bash
/loop 15m check if there are new comments on my open PRs
```

**工作流程**:
1. 设置后每 15 分钟自动检查 PR 状态
2. 发现新评论时主动通知你
3. 你可以立即响应 Code Review 意见

**适用人群**: 经常进行代码审查的开发者

---

### 场景 2: 部署监控

```bash
/loop 5m check if the staging deployment was successful
```

**工作流程**:
1. 触发部署后立即设置监控
2. 每 5 分钟检查部署状态
3. 部署成功/失败时主动报告
4. 失败时附带错误日志摘要

**Windows PowerShell 示例**:

```powershell
# 设置部署后监控
/loop 5m check staging deployment status

# 查看部署日志
Get-Content "D:/deployments/staging.log" -Tail 50
```

**适用人群**: DevOps 工程师、后端开发者

---

### 场景 3: 持续安全审计

```bash
/loop 1h scan the codebase for potential security vulnerabilities
```

**工作流程**:
1. 每小时自动扫描代码库
2. 发现新的潜在漏洞时报告
3. 包含修复建议

**适用人群**: 安全意识强的团队

---

### 场景 4: 自动化日报

```bash
/loop 24h summarize all code changes from the last day
```

**工作流程**:
1. 每天自动生成代码变更摘要
2. 包含新增功能、修复 Bug、性能优化等
3. 方便团队同步进度

**适用人群**: 技术lead、团队管理者

---

### 场景 5: CI/CD 管道监控

```bash
/loop 10m monitor CI pipeline and notify me of any failures
```

**Windows 示例**:

```powershell
# 检查 CI 状态
$ciStatus = Invoke-RestMethod "https://ci.example.com/api/status"

if ($ciStatus.status -eq "failed") {
    Write-Host "CI Failed: $($ciStatus.message)"
}
```

---

### 场景 6: 数据库监控

```bash
/loop 30m check database replication lag
```

**监控指标**:
- 复制延迟是否超过阈值
- 主从同步状态
- 慢查询数量

---

## 限制与注意事项

### 硬性限制

| 限制 | 说明 | 解决方案 |
|------|------|----------|
| 并发任务数 | 每会话最多 50 个 | 合并相似任务 |
| 任务有效期 | 3 天后自动过期 | 重新设置 |
| 会话依赖 | 关闭会话后任务终止 | 使用持久化方案 |

### 环境变量

```bash
# 禁用所有定时任务
export CLAUDE_CODE_DISABLE_CRON=true
```

### 任务过期机制

```
任务创建 → 72小时后自动过期 → 需要重新设置
```

**注意**: 任务过期前不会主动提醒，建议在任务描述中包含重置指令。

---

## 最佳实践

### 1. 合理设置间隔

```
❌ 间隔太短（<1分钟）
   → 产生过多通知，浪费资源

❌ 间隔太长（>24小时）
   → 失去实时性，任务容易过期

✅ 合理间隔
   → 根据场景选择：5m-30m 适合监控
   → 1h-24h 适合报告类任务
```

### 2. 清晰的任务描述

```bash
# ✅ 描述清晰
/loop 10m check if anyone commented on PR #1234

# ❌ 描述模糊
/loop 10m check PR
```

### 3. 组合键绑定

可以设置快捷键快速启动常用监控任务：

```bash
# 在 keybindings.json 中设置
{
  "keys": ["ctrl", "l"],
  "command": "clipboard",
  "args": "/loop 15m check PR status"
}
```

### 4. 任务分组

对于多维度监控，使用任务分组：

```bash
# 部署监控组
/loop 5m check backend deployment
/loop 5m check frontend deployment
/loop 5m check database migration

# 代替创建一个复杂的任务
# /loop 5m check all deployments at once
```

### 5. Windows 注意事项

```powershell
# Windows 环境使用正斜杠路径
/loop 10m check logs in D:/app/logs/

# 避免使用反斜杠（可能导致解析错误）
# ❌ /loop 10m check D:\app\logs\
```

---

## 常见问题

### Q1: 任务没有执行怎么办？

**检查项**:
1. 会话是否保持打开状态
2. 任务是否超过 3 天过期
3. 网络连接是否正常
4. 环境变量 `CLAUDE_CODE_DISABLE_CRON` 是否设置

**解决方法**:

```bash
# 重新设置任务
/loop 5m check deployment status

# 如果被禁用，重新启用
unset CLAUDE_CODE_DISABLE_CRON
```

---

### Q2: 如何停止一个正在运行的任务？

**方法**: 回复 `stop` 或 `取消` 即可停止当前循环任务

```bash
# 启动任务
/loop 10m check CI status

# 回复以下内容停止
stop
# 或
取消
```

---

### Q3: 可以监控多个目标吗？

**可以**，创建多个独立的 /loop 任务：

```bash
# 监控 3 个不同的目标
/loop 5m check backend health
/loop 5m check frontend build
/loop 15m check database connections
```

**注意**: 总任务数不超过 50 个

---

### Q4: 任务执行失败会通知我吗？

**会**。当任务执行失败时，Claude Code 会主动报告错误信息。

```bash
# 如果检查的文件不存在，会报告
# Error: File D:/logs/app.log not found
```

---

### Q5: /loop 和 Cron 有什么区别？

| 特性 | /loop | Cron |
|------|-------|------|
| 语法 | 自然语言 | 定时表达式 |
| 交互性 | 可对话、可调整 | 纯自动执行 |
| 上下文 | 保留会话上下文 | 无上下文 |
| 复杂度 | 简单 | 复杂 |
| 适用场景 | 智能监控 | 固定任务 |

---

### Q6: Windows 上 /loop 是否稳定？

**稳定**。/loop 在 Windows 上正常工作，包括：
- PowerShell 命令执行
- 文件系统监控
- 网络请求

**建议**: Windows 用户使用 PowerShell 原生命令，路径使用正斜杠。

---

## 总结

### 核心要点

```
/loop = 持续监控 + 主动通知 + 自动化执行
```

### 使用场景速查

| 场景 | 推荐间隔 |
|------|----------|
| 紧急监控（部署、错误） | 1-5m |
| 普通监控（PR、CI） | 10-30m |
| 报告生成 | 1h-24h |
| 数据备份 | 12h-24h |

### 下一步

- 学习 [/voice 语音模式](./07-voice.md) 实现 hands-free 编程
- 了解 [Plan 模式](./01-plan-mode.md) 进行复杂任务规划
- 探索 [Agent Teams](./05-agent-teams.md) 多Agent协作

---

**验证信息**:
- ✅ 版本: v2.1.71
- ✅ 官方文档: claude.ai/code/docs/loop-command
- ✅ 实测: Windows 11 + PowerShell
