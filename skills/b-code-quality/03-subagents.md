# Subagents - 子代理使用指南

> **规模化任务处理的分身术**

**阅读时间**: 35分钟
**难度**: ⭐⭐⭐⭐
**重要性**: ⭐⭐⭐⭐⭐
**前置要求**:
- 完成 [Level 1 核心掌握](../../guide/)
- 熟练掌握 Claude Code 基础功能
- 有处理复杂任务的经验

---

## 目录

- [Subagents 概述](#subagents-概述)
- [核心概念](#核心概念)
- [创建 Subagent](#创建-subagent)
- [管理 Subagents](#管理-subagents)
- [实战案例](#实战案例)
- [最佳实践](#最佳实践)
- [高级应用](#高级应用)

---

## Subagents 概述

### 什么是 Subagents？

**定义**：Subagents 是 Claude Code 的"分身"，每个都有独立的 200K 上下文窗口，可以并行处理任务。

**核心能力**：

```
主 Claude（你）
    ↓ 分配任务
Subagent 1 → 处理任务 A（独立 200K 上下文）
Subagent 2 → 处理任务 B（独立 200K 上下文）
Subagent 3 → 处理任务 C（独立 200K 上下文）
    ↓ 汇总结果
主 Claude（你）
```

### 为什么使用 Subagents？

#### 1. 并行处理

```
❌ 串行：
任务 A（10分钟）→ 任务 B（15分钟）→ 任务 C（8分钟）
总计：33 分钟

✅ 并行：
任务 A、B、C 同时进行
总计：15 分钟（最长的任务）
```

#### 2. 规模化处理

```
场景：分析 50 个组件文件

❌ 主 Claude：
需要逐个分析
上下文窗口可能不够
速度慢

✅ Subagents：
5 个 Subagent 并行
每个处理 10 个组件
速度快 3-5 倍
```

#### 3. 专项处理

```
每个 Subagent 专注一类任务：
- Subagent 1：代码审查
- Subagent 2：测试生成
- Subagent 3：文档编写

专业化，效率高
```

---

## 核心概念

### Subagent vs 主 Claude

| 维度 | 主 Claude | Subagent |
|------|----------|-----------|
| **上下文** | 共享 200K | 独立 200K |
| **任务类型** | 所有类型 | 专门任务 |
| **可见性** | 你直接交互 | 在后台运行 |
| **持久化** | 当前会话 | 任务期间存在 |
| **控制** | 你控制 | Claude 自动管理 |

### Subagent 生命周期

```
创建
    ↓
分配任务
    ↓
执行任务
    ├─ 读取文件
    ├─ 调用工具
    ├─ 分析处理
    └─ 生成结果
    ↓
返回结果
    ↓
销毁
```

---

## 创建 Subagent

### 方式 1：自动创建（最常用）

#### 使用 Task 工具

```
👤 你：使用 Task 工具，创建一个 Subagent
    分析 src/components/ 目录的所有组件，
    找出性能问题

🤖 Claude：
[创建 Subagent]
[Subagent 工作中...]

[完成后返回结果]
```

#### Task 工具的优势

```
✅ 自动管理
✅ 自动分配 200K 上下文
✅ 自动清理（任务完成后）
✅ 结果汇总
```

---

### 方式 2：明确要求（推荐）

```
👤 你：创建一个 Subagent 来完成以下任务：
    1. 读取 tests/auth.test.ts
    2. 分析覆盖率
    3. 生成测试报告
    使用 Read 和 Grep 工具

🤖 Claude：
[创建 Subagent]
[执行任务...]

✅ 完成
```

---

### 方式 3：自定义 Subagent（高级）

#### 配置 Subagent

```
👤 你：创建一个专门的代码审查 Subagent：
    - 名称为 "code-reviewer"
    - 专门用于审查 TypeScript 代码
    - 使用 ESLint 和 TypeScript 编译器
    - 检查：类型错误、代码风格、潜在 bug

🤖 Claude：
[创建并配置 Subagent]
✅ Subagent 已创建
```

---

## 管理 Subagents

### 查看 Subagents

```
👤 你：有多少 Subagents 在运行？

🤖 Claude：
当前运行的 Subagents：
- Subagent-1：分析 src/components/（运行中）
- Subagent-2：生成测试（运行中）

[等它们完成后可以查看结果]
```

### 控制 Subagents

#### 终止 Subagent

```
👤 你：终止 Subagent-1

🤖 Claude：
[终止 Subagent-1]
✓ 已终止
```

#### 等待所有完成

```
👤 你：等待所有 Subagents 完成后再继续

🤖 Claude：
[等待中...]

[所有 Subagent 完成]
✓ 所有任务完成，返回结果汇总
```

---

## 实战案例

### 案例 1：并行代码审查

**场景**：需要审查 3 个大型文件

```
❌ 串行审查：
读取文件 A → 审查（5分钟）
读取文件 B → 审查（8分钟）
读取文件 C → 审查（6分钟）
总计：19 分钟

✅ 并行审查：
创建 3 个 Subagents
同时审查 3 个文件
总计：8 分钟（最长的）
```

#### 操作示例

```
👤 你：使用 Task 工具创建 3 个 Subagents：
    Subagent 1：审查 @src/api/users.ts
    Subagent 2：审查 @src/services/auth.ts
    Subagent 3：审查 @src/utils/data.ts

    每个检查：
    - 类型错误
    - 代码风格
    - 潜在 bug
    - 性能问题

🤖 Claude：
[创建 3 个 Subagents]
[并行运行...]

[15分钟后]

✅ Subagent 1 完成：
  users.ts：发现 3 个类型错误，1 个性能问题
✅ Subagent 2 完成：
  auth.ts：代码风格良好，无问题
✅ Subagent 3 完成：
  data.ts：发现 2 个潜在 bug

[汇总报告]
```

---

### 案例 2：批量测试生成

**场景**：为 10 个组件生成测试

```
👤 你：为以下组件生成单元测试：
    @src/components/Button.tsx
    @src/components/Input.tsx
    @src/components/Modal.tsx
    [... 等等]

    每个 Subagent 负责 2-3 个组件
    使用 Vitest 和 Testing Library

🤖 Claude：
[创建 5 个 Subagents]
[并行生成...]

[20分钟后]

✅ 全部完成
总共生成：10 个测试文件
覆盖：所有核心路径
```

---

### 案例 3：大规模代码重构

**场景**：重构 20 个组件以使用新 API

```
👤 你：重构 src/components/ 中所有组件，
    从旧 API 迁移到新 API

    创建 4 个 Subagents：
    - Subagent 1：重构认证相关组件（5个）
    - Subagent 2：重构表单组件（5个）
    - Subagent 3：重构数据展示组件（5个）
    - Subagent 4：重构布局组件（5个）

    每个 Subagent：
    1. 读取组件
    2. 更新 API 调用
    3. 更新类型定义
    4. 验证功能

🤖 Claude：
[创建 4 个 Subagents]
[并行处理...]

[30分钟后]

✅ 完成
20 个组件全部重构完成
所有测试通过
```

---

### 案例 4：文档生成

**场景**：为项目生成完整文档

```
👤 你：创建 3 个 Subagents：
    Subagent 1：API 文档
        - 分析 @src/api/ 路由
        - 提取端点信息
        - 生成 OpenAPI 规范

    Subagent 2：组件文档
        - 分析 @src/components/
        - 提取组件 props
        - 生成使用文档

    Subagent 3：架构文档
        - 分析项目结构
        - 绘制架构图
        - 生成设计文档

🤖 Claude：
[创建 3 个 Subagents]
[并行生成...]

[25分钟后]

✅ 完成
生成：
- api-docs/openapi.yaml
- docs/components.md
- docs/architecture.md
```

---

## 最佳实践

### 实践 1: 明确任务目标

```
❌ 模糊：
"帮我处理这些文件"

✅ 明确：
"创建 Subagent：
1. 读取 @tests/ 目录
2. 运行所有测试
3. 收集失败案例
4. 生成测试报告"
```

---

### 实践 2: 合理分配任务

#### 原则

```
每个 Subagent 任务：
- 时间：5-15 分钟
- 复杂度：中等
- 文件数：2-5 个
- 独立性：尽量减少依赖

避免：
- 超大任务（>30 分钟）
- 高度依赖的任务
- 不明确边界的工作
```

---

### 实践 3: 使用合适的工具

```
给 Subagent 分配工具权限：

常用工具：
✅ Read（读取文件）
✅ Grep（搜索代码）
✅ Glob（查找文件）
✅ Write（写入文件）
✅ Edit（编辑文件）
✅ Bash（运行命令）

谨慎工具：
⚠️ Task（创建更多 Subagents）
⚠️ KillShell（终止进程）
⚠️ BashOutput（大量输出）
```

---

### 实践 4: 监控和汇总

```
监控进度：
👤 你：每完成一个组件就告诉我

🤖 Claude：
✅ Component 1/10 完成
✅ Component 2/10 完成
...

最终汇总：
👤 你：汇总所有结果，生成完整报告

🤖 Claude：
[汇总所有 Subagent 结果]
✅ 总共处理 10 个文件
✅ 发现 15 个问题
✅ 生成 1 份报告
```

---

### 实践 5: 错误处理

```
Subagent 失败时：

方案 1：重试
👤 你：Subagent-2 失败了，重试一次

方案 2：调整任务
👤 你：Subagent-3 的任务太复杂，
    简化为只分析不修改

方案 3：手动处理
👤 你：Subagent-4 失败，我来手动处理这部分
```

---

## 高级应用

### 应用 1：CI/CD 集成

```bash
# 在 CI 脚本中使用 Subagents

# 代码质量检查
claude -p "使用 Task 创建 Subagent
审查 src/ 代码，
使用 ESLint 和 TypeScript，
生成质量报告"

# 自动化测试
claude -p "创建 Subagent
运行所有测试，
收集结果，
生成测试报告"
```

---

### 应用 2：批量文件处理

```
场景：更新 100 个配置文件

👤 你：创建 10 个 Subagents，
    每个 Subagent 处理 10 个文件，
    统一更新 API 版本号

🤖 Claude：
[创建 10 个 Subagents]
[并行处理...]

✅ 效率：10倍提升
时间：30 分钟 vs 5 小时
```

---

### 应用 3：多语言处理

```
场景：处理多语言项目

👤 你：创建 3 个 Subagents：
    Subagent 1：处理 Python 文件
    Subagent 2：处理 TypeScript 文件
    Subagent 3：处理 Go 文件

统一执行：
- 添加错误处理
- 更新文档
- 格式化代码
```

---

## 常见问题

### Q1: Subagent 和主 Claude 的上下文是共享的吗？

**A**: **不是**，每个 Subagent 有独立的 200K 上下文窗口：

```
主 Claude：200K tokens
Subagent 1：200K tokens（独立）
Subagent 2：200K tokens（独立）
...

总上下文：主 Claude + 所有 Subagents
```

---

### Q2: 最多可以同时运行多少个 Subagents？

**A**: 没有硬性限制，但建议：

```
推荐数量：3-5 个

原因：
- 系统资源限制
- 管理复杂度
- 成本考虑

更多 Subagents 可能：
- 性能下降
- 成本增加
- 难以管理
```

---

### Q3: Subagent 失败了怎么办？

**A**:

```
1. 查看错误信息
2. 分析失败原因
3. 选择处理方式：
   a) 重试
   b) 简化任务
   c) 手动处理
```

---

### Q4: 可以在 Subagent 中使用 MCP 工具吗？

**A**: **可以**！Subagent 可以使用所有 MCP 工具：

```
👤 你：创建 Subagent 使用 mcp-ide
    分析项目结构，
    使用 LSP 功能

🤖 Claude：
[创建 Subagent]
[Subagent 使用 mcp-ide 工具]
✅ 完成
```

---

### Q5: Subagent 会自动清理吗？

**A**: **会的**，任务完成后自动销毁：

```
生命周期：
创建 → 执行 → 返回结果 → 销毁

✅ 自动清理
✅ 不占用资源
✅ 不需要手动管理
```

---

### Q6: 如何查看 Subagent 的执行过程？

**A**: 目前没有直接的监控界面，但可以：

```
方法 1：在任务中要求进度报告
👤 你：每完成一个文件就报告

方法 2：使用 /context 查看状态
/context 会显示活跃的工具和 Subagents

方法 3：等待完成后查看汇总
👤 你：完成后，详细汇总每个步骤
```

---

## 总结

### 核心价值

```
✅ 并行处理：效率提升 3-5 倍
✅ 规模化：处理大任务
✅ 专业化：专项处理
✅ 自动化：自动管理和清理
```

### 适用场景

```
✅ 最适合：
- 并行处理多个独立任务
- 大规模代码分析
- 批量文件操作
- 专业化任务

⚠️ 不适合：
- 简单单步任务
- 高度依赖的任务
- 需要频繁交互的任务
```

### 学习检查清单

- [ ] 理解 Subagents 概念
- [ ] 掌握创建方法
- [ ] 学会管理 Subagents
- [ ] 实践并行处理
- [ ] 应用到实际项目
- [ ] 处理错误情况

### 效果预期

```
优化前：处理 50 个文件需要 2-3 小时
优化后：使用 5 个 Subagents，30-40 分钟

效率提升：3-5 倍
```

---

## 下一步

继续学习 Level 2 技能：

```
[04 - Code Review](../b-code-quality/04-code-review.md)
[MCP Servers](../c-integration/01-mcp-servers.md)
[03 - Keyboard Shortcuts](../a-productivity/03-keyboard-shortcuts.md)
```

---

**最后更新**: 2025-01-17
**难度**: ⭐⭐⭐⭐
**重要性**: ⭐⭐⭐⭐⭐
