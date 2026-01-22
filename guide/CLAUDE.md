# guide 模块 - Level 1 核心掌握

[根目录](../CLAUDE.md) > **guide**

---

## 模块职责

**Level 1: 核心掌握** - 新手友好的入门课程

本模块提供 Claude Code 的核心知识，目标是让新用户在 1-2 周内：
- 理解 Claude Code 的核心价值和能力
- 掌握 20% 最常用的功能，解决 80% 的使用场景
- 完成第一个完整实战项目
- 避免新手常见的 10 个错误

---

## 入口与启动

### 首选入口

**推荐阅读顺序**：
1. [00-introduction.md](00-introduction.md) - 理解价值和定位
2. [01-quickstart.md](01-quickstart.md) - 10 分钟快速上手
3. [02-core-features.md](02-core-features.md) - 掌握 8 个核心功能
4. [03-first-project.md](03-first-project.md) - 完整实战项目
5. [04-best-practices.md](04-best-practices.md) - 避免常见错误

### 学习时间

```
总时间：1-2 周
├─ 快速浏览：2-3 小时
├─ 深度学习：5-7 小时
└─ 实战练习：5-10 小时
```

---

## 对外接口

### 核心功能覆盖

本模块涵盖 Claude Code 的 8 个核心功能：

| # | 功能 | 说明 | 文档章节 |
|---|------|------|---------|
| 1 | @符号上下文 | 引用文件、目录到对话 | [02-core-features.md](02-core-features.md#1-符号上下文) |
| 2 | !命令 | 运行 shell 命令 | [02-core-features.md](02-core-features.md#2-命令) |
| 3 | CLAUDE.md | 项目上下文配置 | [02-core-features.md](02-core-features.md#3-claudemd项目上下文) |
| 4 | Esc后悔药 | 撤销上一次操作 | [02-core-features.md](02-core-features.md#4-esc后悔药) |
| 5 | Plan模式 | 复杂任务的规划 | [02-core-features.md](02-core-features.md#5-plan模式基础) |
| 6 | 会话管理 | 持久化和恢复对话 | [02-core-features.md](02-core-features.md#6-会话管理基础) |
| 7 | Ctrl+R历史 | 复用之前的提示词 | [02-core-features.md](02-core-features.md#7-ctrlr历史) |
| 8 | /init | 项目初始化和理解 | [02-core-features.md](02-core-features.md#8-init项目初始化) |

---

## 关键依赖与配置

### 前置要求

```
✅ 无需编程经验
✅ 无需 AI 背景知识
✅ 基本的计算机操作能力
```

### 平台支持

- ✅ Windows 10/11（完整支持，含专门章节）
- ✅ macOS 11+
- ✅ Linux (Ubuntu 20.04+, Debian 11+, Fedora 35+)

### 安装指南

详见：[01-quickstart.md](01-quickstart.md#安装)

---

## 数据模型

### 文档结构

```
guide/
├── 00-introduction.md        (11KB) - 是什么、为什么、核心能力
├── 01-quickstart.md          (8KB)  - 安装、配置、第一次对话
├── 02-core-features.md       (19KB) - 8个核心功能详解
├── 03-first-project.md       (16KB) - 完整 Todo 应用实战
└── 04-best-practices.md      (20KB) - 10个常见错误详解
```

### 内容统计

```
总字数：~50,000 字
实战案例：30+ 个
代码示例：80+ 个
Windows 支持：100% 覆盖
```

---

## 测试与质量

### 质量标准

所有文档均满足：

- ✅ **完整性**：是什么、为什么、如何使用、何时使用、注意什么
- ✅ **实战性**：真实场景、完整流程、预期结果、常见问题
- ✅ **Windows支持**：每个功能都有 Windows 专门说明
- ✅ **可验证性**：所有命令经过设计，案例可实际运行
- ✅ **可读性**：简洁明了，段落适中，逻辑清晰

### 验证状态

- ✅ 命令示例已设计
- ✅ Windows PowerShell 示例完整
- ✅ 实战案例逻辑验证
- ✅ 链接有效性检查

---

## 常见问题 (FAQ)

### Q1: 我应该从哪个文档开始？

**A**: 按顺序阅读：
1. 如果完全不了解：从 [00-introduction.md](00-introduction.md) 开始
2. 如果想快速上手：直接看 [01-quickstart.md](01-quickstart.md)
3. 如果已经安装：重点看 [02-core-features.md](02-core-features.md)

### Q2: 需要多长时间掌握？

**A**:
- 快速浏览：2-3 小时
- 深度学习：5-7 小时
- 实战练习：5-10 小时
- **总计：1-2 周可掌握核心内容**

### Q3: 学完本模块后能达到什么水平？

**A**:
- ✅ 能够独立使用 Claude Code 完成日常开发任务
- ✅ 掌握 8 个核心功能的 80% 使用场景
- ✅ 避免新手常见的错误
- ✅ 具备进入 Level 2 学习的基础

### Q4: Windows 用户需要注意什么？

**A**:
- ✅ 每个功能都有 Windows 专门章节
- ✅ 所有示例都有 PowerShell 版本
- ✅ 路径处理有详细说明（正斜杠 vs 反斜杠）
- ✅ 详见各文档中的"Windows 专属"章节

### Q5: 遇到问题怎么办？

**A**:
1. 查看对应文档的"常见问题"章节
2. 查看 [04-best-practices.md](04-best-practices.md) 中的错误分析
3. 查看 [windows/](../windows/README.md) Windows 专属指南
4. 查看 [reference/troubleshooting.md](../reference/troubleshooting.md) 问题诊断

### Q6: 必须按顺序阅读吗？

**A**:
- **推荐顺序**：00 → 01 → 02 → 03 → 04
- **灵活调整**：
  - 有基础：跳过 00，从 01 开始
  - 已安装：直接看 02 核心功能
  - 遇到问题：查看 04 最佳实践

---

## 相关文件清单

### 核心文档

- [00-introduction.md](00-introduction.md) - Claude Code 介绍和核心价值
- [01-quickstart.md](01-quickstart.md) - 10 分钟快速上手
- [02-core-features.md](02-core-features.md) - 8 个核心功能详解
- [03-first-project.md](03-first-project.md) - 完整实战项目
- [04-best-practices.md](04-best-practices.md) - 新手常见错误

### 相关模块

- [skills/](../skills/CLAUDE.md) - Level 2 进阶提升
- [windows/](../windows/CLAUDE.md) - Windows 专属支持
- [reference/](../reference/CLAUDE.md) - 快速参考

---

## 变更记录 (Changelog)

### 2026-01-18

**新增**:
- ✨ 创建 guide 模块 CLAUDE.md
- ✨ 添加模块职责说明
- ✨ 添加入口与启动指南
- ✨ 添加常见问题解答

### 2025-01-17

**状态**:
- ✅ 100% 完成（5/5 文档）
- ✅ 总字数 ~50,000 字
- ✅ 30+ 实战案例
- ✅ 100% Windows 支持

---

**最后更新**: 2026-01-18
**模块版本**: Level 1 v1.0
**维护者**: knowknowcc 项目组
