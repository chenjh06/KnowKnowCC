# 01 - Customization & Extension

> **打造适合你的定制化 Claude Code**

**目标**: 深度定制 Claude Code，满足特定需求

---

## 内容目录

| # | 文档 | 状态 | 难度 | 说明 |
|---|------|------|------|------|
| 01 | [Custom Commands](./01-custom-commands.md) | 📋 计划中 | ⭐⭐⭐⭐ | 自定义命令 |
| 02 | [Custom MCP Servers](./02-custom-mcp-servers.md) | ✅ 已完成 | ⭐⭐⭐⭐⭐ | 自定义 MCP 服务器 (~28,000字) |
| 03 | [Hooks](./03-hooks.md) | ✅ 已完成 | ⭐⭐⭐⭐⭐ | Hooks 机制 (~23,000字) |
| 04 | [Agent SDK](./04-agent-sdk.md) | 📋 计划中 | ⭐⭐⭐⭐⭐ | Agent SDK 开发 |
| 05 | [MCP Elicitation](./05-mcp-elicitation.md) | ✅ 已完成 | ⭐⭐⭐⭐ | 结构化输入请求 (~8,000字) |
| 06 | Plugins 系统 | 📋 计划中 | ⭐⭐⭐⭐ | 插件扩展 (v2.1.83+) |
| 07 | [managed-settings.d/](./07-managed-settings.md) | ✅ 已完成 | ⭐⭐⭐ | 策略片段化管理 (v2.1.83+) |
| 08 | [Auto Mode](./08-auto-mode.md) | ✅ 已完成 | ⭐⭐⭐⭐ | 自动模式 (v2.1.84+) |

**完成度**: 62% (5/8)

---

## 学习路径

### 路径 1: 快速定制

```
01-Custom Commands
    ├─ 创建简单命令
    ├─ 参数处理
    └─ 命令组合

目标：日常使用自动化
```

### 路径 2: 深度扩展

```
02-Custom MCP Servers → 05-MCP Elicitation → 04-Agent SDK
    ├─ 理解 MCP 协议
    ├─ 开发自定义服务器
    └─ 构建复杂集成

目标：扩展能力边界
```

### 路径 3: 自动化工作流

```
03-Hooks → 07-managed-settings.d/ → 08-Auto Mode
    ├─ 配置 Hooks 自动触发
    ├─ 团队级策略管理
    └─ 自动执行安全操作

目标：完全自动化工作流
```

---

## 相关资源

### 前置要求
- [Level 2 进阶提升](../../advanced/)
- [MCP 服务器精选](../../advanced/c-integration/01-mcp-servers.md)

### 相关文档
- [自动化和 CI/CD](../02-automation/) - 工作流自动化
- [高级主题](../03-advanced-topics/) - 深入主题

### 外部资源
- [MCP 协议文档](https://modelcontextprotocol.io)
- [MCP TypeScript SDK](https://github.com/modelcontextprotocol/typescript-sdk)

---

**最后更新**: 2026-03-28
**模块版本**: Customization v0.27
