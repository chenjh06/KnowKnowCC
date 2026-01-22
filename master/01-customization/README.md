# 01 - Customization & Extension

> **打造适合你的定制化 Claude Code**

**目标**: 深度定制 Claude Code，满足特定需求

---

## 📚 内容目录

### 02 - Custom MCP Servers（自定义 MCP 服务器）✅

**文件**: [02-custom-mcp-servers.md](./02-custom-mcp-servers.md)

**状态**: ✅ 已完成

**内容**:
- MCP 服务器概述
- MCP 协议基础
- 开发环境搭建
- 创建第一个 MCP 服务器
- 高级功能：
  - 数据库集成
  - 文件资源
  - 提示模板
- 实战案例：
  - 企业知识库 MCP 服务器
  - Git 操作 MCP 服务器
  - 监控告警 MCP 服务器
- Windows 专属开发
- 部署和发布
- 最佳实践

**适合**: 需要扩展 Claude Code 能力的开发者
**难度**: ⭐⭐⭐⭐⭐
**重要性**: ⭐⭐⭐⭐⭐

**字数**: ~28,000 字

---

### 01 - Custom Commands（自定义命令）

**文件**: [01-custom-commands.md](./01-custom-commands.md)

**状态**: 📋 计划中

**内容**:
- 自定义命令概述
- 命令创建方法
- 命令参数和选项
- 命令链和组合
- 实战案例
- Windows 特定命令

**适合**: 所有用户
**难度**: ⭐⭐⭐⭐
**重要性**: ⭐⭐⭐⭐

---

### 03 - Hooks（钩子机制）⭐⭐⭐⭐⭐

**文件**: [03-hooks.md](./03-hooks.md)

**状态**: ✅ 已完成

**内容**:
- Hooks 概述（定义、价值、使用场景）
- Hook 类型（prePrompt、postResponse、preCommand、postCommand）
- 配置 Hooks（基本配置、match、command、条件）
- 高级用法（条件、动态命令、上下文感知、Hook 链）
- 实战案例（自动审查、自动文档、自动提交通知）
- Windows 专属（PowerShell Hooks、路径处理、权限）
- 最佳实践（精确匹配、幂等性、错误处理、日志记录）

**适合**: 需要自动化工作流的用户
**难度**: ⭐⭐⭐⭐⭐
**重要性**: ⭐⭐⭐⭐

**字数**: ~23,000 字

**内容**:
- Hooks 概述
- prePrompt Hooks
- postResponse Hooks
- Hooks 配置
- 实战案例
- 高级用法
- 最佳实践

**适合**: 需要自动化工作流的用户
**难度**: ⭐⭐⭐⭐⭐
**重要性**: ⭐⭐⭐⭐⭐

---

### 04 - Agent SDK（Agent SDK 使用）

**文件**: [04-agent-sdk.md](./04-agent-sdk.md)

**状态**: 📋 计划中

**内容**:
- Agent SDK 概述
- SDK 架构
- 开发自定义 Agent
- 集成和部署
- 实战案例
- 最佳实践

**适合**: 高级开发者
**难度**: ⭐⭐⭐⭐⭐
**重要性**: ⭐⭐⭐

---

## 🎯 学习路径

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
02-Custom MCP Servers → 04-Agent SDK
    ├─ 理解 MCP 协议
    ├─ 开发自定义服务器
    └─ 构建复杂集成

目标：扩展能力边界
```

### 路径 3: 自动化工作流

```
03-Hooks → 02-Custom MCP Servers
    ├─ 配置 Hooks
    ├─ 自动触发操作
    └─ 集成外部系统

目标：完全自动化工作流
```

---

## 📊 完成进度

```
01-customization/
├── 01-custom-commands.md       📋 计划中
├── 02-custom-mcp-servers.md    ✅ 已完成 (28,000字)
├── 03-hooks.md                 ✅ 已完成 (23,000字)
└── 04-agent-sdk.md             📋 计划中

完成度: 50% (2/4)
```

---

## 🔗 相关资源

### 前置要求
- [Level 2 进阶提升](../../skills/)
- [MCP 服务器精选](../../skills/c-integration/01-mcp-servers.md)

### 相关文档
- [自动化和 CI/CD](../02-automation/) - 工作流自动化
- [高级主题](../03-advanced-topics/) - 深入主题

### 外部资源
- [MCP 协议文档](https://modelcontextprotocol.io)
- [MCP TypeScript SDK](https://github.com/modelcontextprotocol/typescript-sdk)

---

**最后更新**: 2026-01-18
**模块版本**: Customization v0.25
