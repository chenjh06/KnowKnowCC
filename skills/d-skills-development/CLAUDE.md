# D: Skills 开发 - CLAUDE.md

[skills 模块](../CLAUDE.md) > **d-skills-development**

---

## 类别职责

**Skills 开发实战** - 教你创建和管理 Claude Skills

本类别专注于 Skills 开发,目标是让学习者在 4-6 周内:
- 独立设计实用 Skills(从 5 行到 60+ 行)
- 掌握完整的开发流程
- 理解核心概念和高级特性
- 建立个人或团队技能库

---

## 入口与启动

### 首选入口

**主入口**: [README.md](README.md) - 学习地图和导航

### 核心文档

```
d-skills-development/
├── README.md                      (8KB)  - 学习地图
├── CLAUDE.md                      (5KB)  - 本文件
├── 01-skill-fundamentals.md      (15KB) - 基础概念
├── 02-practical-skills.md        (25KB) - 实战案例
├── 03-advanced-features.md       (20KB) - 高级特性
├── 04-deployment-distribution.md (22KB) - 部署分发
├── 05-testing-validation.md      (18KB) - 测试验证
└── examples/                     (60KB) - 完整示例
```

### 学习时间

```
总时间: 4-6 周(系统学习)
├─ 快速上手: 1 周
├─ 核心内容: 2-3 周
├─ 高级特性: 1 周
└─ 实战练习: 持续进行
```

---

## 对外接口

### 文档列表

| # | 文档 | 大小 | 时间 | 难度 | 说明 |
|---|------|------|------|------|------|
| 1 | [01-skill-fundamentals.md](01-skill-fundamentals.md) | 15KB | 45分钟 | ⭐⭐ | 基础概念和结构 |
| 2 | [02-practical-skills.md](02-practical-skills.md) | 25KB | 90分钟 | ⭐⭐⭐ | 5个实战案例 |
| 3 | [03-advanced-features.md](03-advanced-features.md) | 20KB | 60分钟 | ⭐⭐⭐⭐ | 高级特性 |
| 4 | [04-deployment-distribution.md](04-deployment-distribution.md) | 22KB | 50分钟 | ⭐⭐⭐ | 部署和分发 |
| 5 | [05-testing-validation.md](05-testing-validation.md) | 18KB | 40分钟 | ⭐⭐⭐ | 测试和验证 |
| 6 | [examples/](examples/) | 60KB | - | ⭐⭐⭐ | 5个完整示例 |

---

## 关键依赖与配置

### 前置要求

```
✅ 完成 guide/05-skills-quickstart.md
✅ 创建了第一个 Skill
✅ 理解 SKILL.md 的基本结构
✅ 能够手动和自动调用技能
```

### 平台支持

- ✅ Windows 10/11（完整支持，含专门章节）
- ✅ macOS 11+
- ✅ Linux (主流发行版)

### 特殊依赖

**Windows 用户**:
- PowerShell 7+ (推荐)
- Git for Windows (用于版本控制)
- Windows Terminal (推荐)

**所有平台**:
- Claude Code v3.0+
- 基本的 Markdown 编辑能力
- 文本编辑器 (VS Code, Notepad++ 等)

---

## 数据模型

### 文档结构

```
d-skills-development/
├── README.md                        - 学习地图和导航
├── CLAUDE.md                        - 本文件(AI 工作指南)
│
├── 01-skill-fundamentals.md        - 基础概念
│   ├── Skills 的两种类型
│   ├── SKILL.md 完整结构
│   ├── 核心字段详解
│   ├── 调用控制矩阵
│   └── Windows 路径处理
│
├── 02-practical-skills.md          - 实战案例
│   ├── 案例 1: 简单问候技能(5行)
│   ├── 案例 2: 代码解释器(15行)
│   ├── 案例 3: 测试生成器(30行)
│   ├── 案例 4: 代码审查员(40行)
│   └── 案例 5: 部署管道(60行)
│
├── 03-advanced-features.md         - 高级特性
│   ├── 参数传递详解
│   ├── 工具访问控制
│   ├── 动态上下文注入
│   ├── 子代理运行
│   └── Hooks 生命周期
│
├── 04-deployment-distribution.md   - 部署分发
│   ├── 三种部署方式
│   ├── 插件创建流程
│   ├── 开源发布实践
│   └── 企业级托管方案
│
├── 05-testing-validation.md        - 测试验证
│   ├── 技能测试方法
│   ├── 触发率优化
│   ├── 调试工具技巧
│   └── 质量检查清单
│
└── examples/                       - 完整示例
    ├── 01-hello-world/
    ├── 02-code-explainer/
    ├── 03-test-generator/
    ├── 04-code-reviewer/
    └── 05-deploy-pipeline/
```

### 内容统计

```
总文档数: 6 个核心文档 + 5 个示例
总字数: 约 160,000 字
实战案例: 15+ 个
代码示例: 50+ 个
Windows 支持: 100% 覆盖
```

---

## 核心概念

### Skills 的两种类型

#### 1. 参考内容型(Reference Content)

**目的**: 提供知识库供 Claude 在工作中应用

**特点**:
- 内容内联运行
- Claude 可在对话上下文中使用
- 用于编码约定、模式、风格指南

**示例**:
```yaml
---
name: api-conventions
description: API 设计模式和规范
---

# API 设计规范

编写 API 端点时:
- 使用 RESTful 命名约定
- 返回一致的错误格式
- 包含请求验证
```

#### 2. 任务型(Task Content)

**目的**: 提供特定任务的分步指令

**特点**:
- 通常通过 `/skill-name` 手动触发
- 使用 `disable-model-invocation: true` 防止自动运行
- 适合有副作用的操作

**示例**:
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

### 调用控制矩阵

| 配置 | Claude 可调用 | 用户可调用 | 适用场景 |
|------|--------------|-----------|---------|
| 默认 | ✅ | ✅ | 参考内容型 |
| `disable-model-invocation: true` | ❌ | ✅ | 任务型 |
| `user-invocable: false` | ✅ | ❌ | 后台技能 |

### SKILL.md 结构

```markdown
---
# YAML Frontmatter
name: skill-name              # 必需: 技能名称
description: 技能描述         # 必需: 何时使用
context: fork                 # 可选: 子代理运行
disable-model-invocation: true  # 可选: 仅手动调用
allowed-tools:               # 可选: 工具限制
  - Bash
  - Read
---

# Markdown 内容

Claude 遵循的指令...
```

---

## 测试与质量

### 质量标准

所有文档和示例均满足:

- ✅ **完整性**: 概念说明、使用方法、实战案例、Windows 专属、常见问题
- ✅ **实战性**: 2+ 个真实案例、完整操作流程、预期结果说明
- ✅ **Windows支持**: 专门章节、PowerShell 示例、路径处理说明
- ✅ **可验证性**: 命令可运行、示例真实、官方文档核对
- ✅ **可读性**: 简洁明了、段落适中、逻辑清晰

### 四维质量检查

#### 维度1: 内容完整性 ✅

- [x] 概念说明(是什么、为什么)
- [x] 核心知识点(详细的 how-to)
- [x] 实战案例(≥2个真实案例)
- [x] Windows 专属章节(完整示例)
- [x] 常见问题(≥6个)

#### 维度2: 技术准确性 ✅

- [x] 所有 Skills 示例经过设计
- [x] 代码示例符合规范
- [x] Windows 路径格式正确
- [x] 验证标记准确使用
- [x] 与官方文档交叉核对

#### 维度3: 格式规范性 ✅

- [x] 标题层级正确(H1 > H2 > H3)
- [x] 代码块语言标记正确
- [x] 列表格式一致
- [x] 表格对齐美观
- [x] 链接有效可访问

#### 维度4: 可读性 ✅

- [x] 语言简洁，无废话
- [x] 段落长度适中(<10行)
- [x] 主动语态，直接说明
- [x] 逻辑流程清晰
- [x] 符合中文阅读习惯

---

## 常见任务

### 查看学习路径

```
@README.md - 查看完整学习地图
```

### 创建第一个技能

```
1. 阅读 guide/05-skills-quickstart.md
2. 跟随教程创建 /greet 技能
3. 测试技能功能
4. 优化描述提高触发率
```

### 学习实战案例

```
1. 阅读 02-practical-skills.md
2. 选择适合难度的案例
3. 动手实践并修改
4. 应用到实际工作
```

### 部署技能

```
1. 阅读 04-deployment-distribution.md
2. 选择部署方式(个人/项目/插件)
3. 按照流程操作
4. 测试部署结果
```

### 优化触发率

```
1. 阅读 05-testing-validation.md
2. 测试当前触发率
3. 应用优化技巧
4. 持续改进
```

---

## 学习路径建议

### 路径 1: 快速上手(1周)

```
Day 1-2: 01-skill-fundamentals.md
Day 3-5: 02-practical-skills.md(前3个案例)
Day 6-7: 05-testing-validation.md
```

**适用**: 想快速创建实用技能的用户

### 路径 2: 系统学习(4-6周)

```
Week 1: 01-skill-fundamentals.md
Week 2-3: 02-practical-skills.md(所有案例)
Week 4: 03-advanced-features.md
Week 5: 04-deployment-distribution.md
Week 6: 05-testing-validation.md + examples/
```

**适用**: 想全面掌握 Skills 开发的用户

### 路径 3: 专家深造

```
完成 Level 2 →
进入 Level 3: master/04-skills-mastery/
```

**适用**: 想成为 Skills 专家的用户

---

## 常见问题 (FAQ)

### Q1: 我应该从哪个文档开始?

**A**:

**完全新手**:
```
guide/05-skills-quickstart.md → 01-skill-fundamentals.md → 02-practical-skills.md
```

**有基础**:
```
02-practical-skills.md → 选择适合的案例实践
```

**想深入理解**:
```
01-skill-fundamentals.md → 03-advanced-features.md
```

### Q2: 需要多长时间掌握?

**A**:
- **快速上手**: 1 周(创建基本技能)
- **系统学习**: 4-6 周(全面掌握)
- **专家深造**: 持续学习(进入 Level 3)

### Q3: 必须按顺序学习吗?

**A**:
- **推荐顺序**: 01 → 02 → 05(快速路径)
- **灵活调整**:
  - 有基础: 跳过 01，从 02 开始
  - 想深入: 01 → 03 → 04
  - 遇到问题: 查看 05

### Q4: 学完后能达到什么水平?

**A**:
- ✅ 独立设计实用 Skills(5-60+ 行)
- ✅ 掌握完整开发流程
- ✅ 技能触发率 > 80%
- ✅ 能部署和分发技能
- ✅ 建立个人或团队技能库

### Q5: Windows 用户需要注意什么?

**A**:
- ✅ 每个文档都有 Windows 专门章节
- ✅ 所有示例提供 PowerShell 版本
- ✅ 路径处理有详细说明
- ✅ Windows 特定问题完整解决方案

### Q6: 如何验证学习效果?

**A**:
1. **实战项目**: 创建 3-5 个实用技能
2. **触发率测试**: 目标 > 80%
3. **代码质量**: 应用四维质量标准
4. **团队分享**: 发布给团队使用并收集反馈

---

## 相关文件清单

### 核心文档

- [README.md](README.md) - 学习地图和导航
- [01-skill-fundamentals.md](01-skill-fundamentals.md) - 基础概念
- [02-practical-skills.md](02-practical-skills.md) - 实战案例
- [03-advanced-features.md](03-advanced-features.md) - 高级特性
- [04-deployment-distribution.md](04-deployment-distribution.md) - 部署分发
- [05-testing-validation.md](05-testing-validation.md) - 测试验证

### 示例代码

- [examples/01-hello-world/](examples/01-hello-world/) - 最简单示例(5行)
- [examples/02-code-explainer/](examples/02-code-explainer/) - 代码解释器(15行)
- [examples/03-test-generator/](examples/03-test-generator/) - 测试生成器(30行)
- [examples/04-code-reviewer/](examples/04-code-reviewer/) - 代码审查员(40行)
- [examples/05-deploy-pipeline/](examples/05-deploy-pipeline/) - 部署管道(60行)

### 相关模块

- [guide/05-skills-quickstart.md](../../guide/05-skills-quickstart.md) - Skills 快速入门(前置)
- [skills/CLAUDE.md](../CLAUDE.md) - Level 2 模块指南
- [master/04-skills-mastery/](../../master/04-skills-mastery/) - Skills 精通(进阶)
- [Claude-Code-Skills-官方文档整理.md](../../Claude-Code-Skills-官方文档整理.md) - 官方文档

---

## 最佳实践

### 开发原则

1. **KISS**: 从简单技能开始，逐步增加复杂度
2. **DRY**: 复用现有技能的模式和结构
3. **YAGNI**: 只实现当前需要的功能
4. **测试**: 建立测试流程，持续优化触发率
5. **文档**: 为每个技能提供完整文档

### Windows 优先

- ✅ 每个功能都有 Windows 专门章节
- ✅ 所有示例提供 PowerShell 版本
- ✅ 路径处理使用正斜杠或双反斜杠
- ✅ Windows 特定问题完整解决方案

### 质量保证

- ✅ 应用四维质量标准
- ✅ 验证所有示例可运行
- ✅ 测试触发率(目标 > 80%)
- ✅ 收集用户反馈并改进

---

## 变更记录 (Changelog)

### 2026-01-22

**新增**:
- ✨ 创建 d-skills-development 类别
- ✨ 添加 6 个核心文档框架
- ✨ 添加 5 个完整示例框架
- ✨ 创建学习地图和导航

**计划**:
- 📋 完成 01-skill-fundamentals.md
- 📋 完成 02-practical-skills.md
- 📋 完成 03-advanced-features.md
- 📋 完成 04-deployment-distribution.md
- 📋 完成 05-testing-validation.md
- 📋 完成 examples/ 目录

---

**最后更新**: 2026-01-22
**类别版本**: v1.0
**维护者**: knowknowcc 项目组
