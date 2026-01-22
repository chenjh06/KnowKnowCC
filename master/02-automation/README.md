# 02 - Automation & CI/CD

> **企业级自动化和工作流编排**

**目标**: 让 Claude Code 集成到你的自动化流程中

---

## 📚 内容目录

### 03 - Workflow Automation（工作流自动化）✅

**文件**: [03-workflow-automation.md](./03-workflow-automation.md)

**状态**: ✅ 已完成

**内容**:
- 工作流自动化概述
- MCP 协议基础
- 触发器和条件
- 实战案例：
  - 自动化部署工作流
  - 代码审查自动化
  - 文档自动生成
- Windows 专属工作流
- PowerShell 脚本集成
- 最佳实践和故障排查

**适合**: 需要自动化的团队、DevOps 工程师
**难度**: ⭐⭐⭐⭐⭐
**重要性**: ⭐⭐⭐⭐⭐

**字数**: ~25,000 字

---

### 01 - Headless Mode（脚本化使用）

**文件**: [01-headless-mode.md](./01-headless-mode.md)

**状态**: 📋 计划中

**内容**:
- Headless 模式概述
- 命令行参数
- 脚本化调用
- 批量处理
- CI/CD 集成
- 实战案例

**适合**: 需要脚本化使用的用户
**难度**: ⭐⭐⭐⭐
**重要性**: ⭐⭐⭐⭐⭐

---

### 02 - Testing Automation（测试自动化）✅

**文件**: [02-testing-automation.md](./02-testing-automation.md)

**状态**: ✅ 已完成

**内容**:
- 测试自动化概述
- 测试类型（单元、集成、E2E、性能）
- Claude Code 辅助测试（生成测试、诊断失败）
- 测试框架集成（Jest、Vitest、Playwright）
- 自动化测试策略（金字塔、覆盖率、组织）
- CI/CD 集成（GitHub Actions、GitLab CI）
- 3个实战案例：TDD、遗留代码、回归测试
- Windows 专属（PowerShell 测试脚本、任务计划）
- 最佳实践和故障排查

**适合**: 所有开发者、QA 工程师
**难度**: ⭐⭐⭐⭐
**重要性**: ⭐⭐⭐⭐

**字数**: ~26,000 字

---

### 02 - CI/CD Integration（持续集成集成）

**文件**: [02-ci-cd-integration.md](./02-ci-cd-integration.md)

**状态**: 📋 计划中

**内容**:
- CI/CD 概述
- GitHub Actions 集成
- GitLab CI 集成
- Jenkins 集成
- Azure DevOps 集成
- 最佳实践

**适合**: DevOps 工程师、需要 CI/CD 的团队
**难度**: ⭐⭐⭐⭐⭐
**重要性**: ⭐⭐⭐⭐

---

## 🎯 学习路径

### 路径 1: 自动化入门

```
03-Workflow Automation
    ├─ 理解工作流概念
    ├─ 创建简单自动化脚本
    └─ 实战部署工作流

目标：实现基本自动化
```

### 路径 2: 企业级 CI/CD

```
01-Headless Mode → 02-CI/CD Integration
    ├─ 脚本化使用
    ├─ CI/CD 平台集成
    └─ 生产环境部署

目标：构建企业级 CI/CD
```

---

## 📊 完成进度

```
02-automation/
├── 01-headless-mode.md        ✅ 已完成 (18,000字)
├── 02-testing-automation.md   ✅ 已完成 (26,000字)
├── 02-ci-cd-integration.md    📋 计划中
└── 03-workflow-automation.md  ✅ 已完成 (25,000字)

完成度: 100% (3/3) ✅
```

---

## 🔗 相关资源

### 前置要求
- [Level 2 进阶提升](../../skills/)
- [Plan 模式](../../skills/a-productivity/01-plan-mode.md)

### 相关文档
- [自定义和扩展](../01-customization/) - 定制化工具
- [高级主题](../03-advanced-topics/) - 深入主题

---

**最后更新**: 2026-01-18
**模块版本**: Automation v0.3
