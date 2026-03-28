# 05 - Agent Teams - 多智能体协作

> **让多个 AI 智能体并行工作，自主协调完成复杂任务**

**阅读时间**: 25分钟
**难度**: ⭐⭐⭐
**重要性**: ⭐⭐⭐⭐⭐
**前置要求**: [guide/02-core-features.md](../../guide/02-core-features.md)

> **📌 文档版本**: 基于 Claude Opus 4.6
> **✅ 验证状态**: ✅ 已验证（2026-02-15）
> **🔄 最后更新**: 2026-02-15 - Claude Opus 4.6 重大功能

---

## 目录

- [官方说明](#官方说明)
- [深度解读](#深度解读)
- [核心优势](#核心优势)
- [使用场景](#使用场景)
- [如何启动 Agent Teams](#如何启动-agent-teams)
- [多智能体协调策略](#多智能体协调策略)
- [控制与监控](#控制与监控)
- [Windows 特别说明](#windows-特别说明)
- [性能数据](#性能数据)
- [最佳实践](#最佳实践)
- [常见问题](#常见问题)
- [下一步](#下一步)

---

## 官方说明

### 官方发布公告

**Agent Teams** 是 Claude Opus 4.6 的重大新功能（2026-02-05 发布）：

```markdown
"You can now spin up multiple agents that work in parallel as a team
and coordinate autonomously—best for tasks that split into independent,
read-heavy work like codebase reviews.

You can take over any subagent directly using Shift+Up/Down or tmux."
```

### 关键特性

1. **并行执行** 🚀
   - 多个智能体同时工作
   - 独立的执行环境
   - 自动分配任务

2. **自主协调** 🤝
   - 智能体之间自动协调
   - 无需人工干预
   - 高效的任务分配

3. **灵活控制** 🎮
   - Shift+Up/Down 切换控制权
   - tmux 终端复用管理
   - 可随时介入或接管

---

## 深度解读

### 架构突破

**从单智能体到多智能体**：

```
传统模式（Claude Sonnet 4.5 及之前）：
┌─────────────────────────────┐
│   单个 Claude 智能体         │
│   ├─ 串行处理任务            │
│   ├─ 共享上下文              │
│   └─ 逐步完成                │
└─────────────────────────────┘

Agent Teams 模式（Claude Opus 4.6）：
┌─────────────────────────────┐
│   Agent Team 协调器          │
│   ├─ Agent 1: 前端代码审查   │
│   ├─ Agent 2: 后端代码审查   │
│   ├─ Agent 3: 测试覆盖分析   │
│   └─ Agent 4: 文档完整性检查 │
│                              │
│   所有智能体并行工作          │
│   独立上下文，互不干扰        │
│   自动协调和汇总              │
└─────────────────────────────┘
```

### 技术原理

#### 1. 独立上下文（Independent Context）

每个智能体拥有：
- ✅ 独立的会话上下文
- ✅ 独立的工具权限
- ✅ 独立的执行环境
- ✅ 不污染主会话

**优势**：
- 避免上下文污染
- 提高执行效率
- 减少相互干扰
- 更精准的结果

#### 2. 自主协调（Autonomous Coordination）

Agent Team 协调器负责：
- 📋 任务分解和分配
- 🔄 智能体之间的通信
- 📊 结果汇总和整合
- ⚠️ 错误处理和重试

**优势**：
- 无需人工协调
- 自动负载均衡
- 智能任务分配
- 高效资源利用

#### 3. 灵活控制（Flexible Control）

用户可以：
- 🎮 随时切换控制权（Shift+Up/Down）
- 🖥️ 使用 tmux 管理多个会话
- 👀 实时监控每个智能体
- ✋ 直接介入或接管

**优势**：
- 保持人类在环
- 即时干预能力
- 透明的工作流程
- 灵活的管理方式

---

## 核心优势

### 1. 效率提升 ⚡

**量化对比**：

| 任务类型 | 传统模式 | Agent Teams | 效率提升 |
|---------|---------|------------|---------|
| **大型代码审查** | 2-3 小时 | 10-15 分钟 | **12-18 倍** |
| **多仓库分析** | 4-6 小时 | 30-45 分钟 | **8-12 倍** |
| **批量重构** | 3-5 小时 | 20-30 分钟 | **9-15 倍** |
| **文档生成** | 2-4 小时 | 15-25 分钟 | **8-16 倍** |

**实际案例**：

```markdown
场景：审查一个包含前端、后端、测试、文档的完整项目

传统模式（串行）：
├─ 09:00 - 10:30 审查前端代码（1.5小时）
├─ 10:30 - 12:00 审查后端代码（1.5小时）
├─ 13:00 - 14:00 审查测试代码（1小时）
├─ 14:00 - 15:00 审查文档（1小时）
└─ 15:00 - 15:30 汇总报告（0.5小时）
总计：5.5 小时

Agent Teams（并行）：
├─ 09:00 - 09:15 Agent 1: 前端代码审查
├─ 09:00 - 09:15 Agent 2: 后端代码审查
├─ 09:00 - 09:15 Agent 3: 测试代码审查
├─ 09:00 - 09:15 Agent 4: 文档审查
└─ 09:15 - 09:20 自动汇总报告
总计：20 分钟

效率提升：16.5 倍！
```

### 2. 质量提升 ✨

**优势**：

1. **独立视角**
   - 每个智能体专注于特定领域
   - 避免思维定势
   - 更全面的审查

2. **并行检查**
   - 同时检查多个维度
   - 不遗漏重要问题
   - 更高的覆盖率

3. **自动交叉验证**
   - 智能体之间自动验证
   - 发现潜在冲突
   - 提高结果准确性

### 3. 成本优化 💰

**成本对比**（以大型代码审查为例）：

```markdown
传统模式：
- 单个智能体处理所有任务
- 上下文不断累积
- Token 消耗：约 500K tokens
- 成本：约 $25

Agent Teams：
- 多个智能体并行处理
- 独立上下文，避免重复
- Token 消耗：约 600K tokens（总和）
- 成本：约 $30

时间成本节省：5.5 小时 → 20 分钟
综合效益：效率提升远超额外成本
```

---

## 使用场景

### ✅ 最佳场景

#### 1. 大型代码审查

**场景描述**：
- 项目规模：100+ 文件
- 代码行数：10,000+ 行
- 模块数量：5+ 个独立模块

**使用方法**：

```markdown
你：审查整个项目，包括前端、后端、API、数据库、测试、文档

Claude Code（自动启动 Agent Team）：
[自动创建 6 个智能体]
├─ Agent 1: 审查前端代码（组件、样式、性能）
├─ Agent 2: 审查后端代码（API、业务逻辑）
├─ Agent 3: 审查数据库设计（schema、查询优化）
├─ Agent 4: 审查测试覆盖率（单元、集成、E2E）
├─ Agent 5: 审查 API 设计（RESTful、文档）
└─ Agent 6: 审查文档完整性（README、注释、API 文档）

[所有智能体并行工作，15-20 分钟后]
[自动生成综合报告]
```

**预期结果**：
- ✅ 全面的代码质量分析
- ✅ 性能优化建议
- ✅ 安全漏洞检查
- ✅ 测试覆盖率报告
- ✅ 文档完整性评估

#### 2. 多仓库分析

**场景描述**：
- 微服务架构
- 多个独立仓库
- 需要全局视图

**使用方法**：

```markdown
你：分析所有微服务的依赖关系和潜在问题

Claude Code（自动创建多个智能体）：
├─ Agent 1: 分析 user-service
├─ Agent 2: 分析 order-service
├─ Agent 3: 分析 payment-service
├─ Agent 4: 分析 notification-service
└─ Agent 5: 绘制全局依赖图

[并行分析，30-45 分钟]
[生成依赖关系图和问题清单]
```

**预期结果**：
- ✅ 完整的依赖关系图
- ✅ 潜在的循环依赖
- ✅ 版本冲突检测
- ✅ 优化建议

#### 3. 批量重构

**场景描述**：
- 需要重构多个独立模块
- 模块之间低耦合
- 可以并行操作

**使用方法**：

```markdown
你：重构所有模块，应用最新的设计模式和最佳实践

Claude Code（智能分配任务）：
├─ Agent 1: 重构 authentication 模块
├─ Agent 2: 重构 database 模块
├─ Agent 3: 重构 api 模块
└─ Agent 4: 重构 utils 模块

[每个智能体独立重构自己的模块]
[自动处理模块间的接口变化]
[生成重构报告和测试结果]
```

**预期结果**：
- ✅ 统一的代码风格
- ✅ 应用的设计模式
- ✅ 完整的测试覆盖
- ✅ 向后兼容性保证

#### 4. 文档生成

**场景描述**：
- 多个模块需要文档
- 文档类型多样
- 需要保持一致性

**使用方法**：

```markdown
你：为所有模块生成完整的技术文档

Claude Code（并行生成文档）：
├─ Agent 1: 生成 API 文档
├─ Agent 2: 生成架构文档
├─ Agent 3: 生成部署文档
├─ Agent 4: 生成用户指南
└─ Agent 5: 生成开发者文档

[同时生成不同类型的文档]
[自动保持风格一致]
```

**预期结果**：
- ✅ 完整的 API 文档
- ✅ 清晰的架构图
- ✅ 详细的部署指南
- ✅ 用户友好的手册
- ✅ 开发者贡献指南

### ⚠️ 不适合场景

| 场景 | 原因 | 建议 |
|------|------|------|
| **高度耦合的任务** | 智能体之间协调成本高 | 使用传统模式 |
| **需要全局上下文的任务** | 每个智能体独立上下文 | 使用 1M Token 模式 |
| **简单的单文件修改** | 并行优势不明显 | 使用传统模式 |
| **需要顺序执行的任务** | 无法并行化 | 使用传统模式 |

---

## 如何启动 Agent Teams

### 方法 1: 自动启动（推荐）

**最简单的方式**：直接描述需要并行处理的任务。

```markdown
你：审查整个项目的代码质量，包括前端、后端、测试

Claude Code 会自动：
1. 检测到这是一个多模块任务
2. 创建相应的 Agent Team
3. 分配任务给不同的智能体
4. 并行执行
5. 汇总结果
```

**触发条件**：
- ✅ 描述中包含多个独立的子任务
- ✅ 任务可以自然分解
- ✅ 子任务之间低耦合

### 方法 2: 明确指定

**显式要求使用 Agent Teams**：

```markdown
你：使用 Agent Teams 并行审查以下模块：
    - 前端 React 组件
    - 后端 Express API
    - 数据库 schema
    - 测试覆盖率

Claude Code 会：
1. 创建 4 个专门的智能体
2. 每个 Agent 专注于一个模块
3. 并行执行审查
4. 生成综合报告
```

### 方法 3: 使用 Subagent Skills

**配置 Skills 使用 Subagent 模式**：

```yaml
# .claude/skills/comprehensive-review/SKILL.md
---
name: comprehensive-review
description: 全面的代码审查
context: fork
agent: Explore
allowed-tools: Read, Grep, Glob
---

Perform comprehensive code review:

1. Analyze code quality
2. Check security vulnerabilities
3. Review performance issues
4. Verify test coverage
5. Generate detailed report
```

然后调用：

```markdown
你：/comprehensive-review
```

---

## 多智能体协调策略

### 策略 1: 按模块分配

**适用场景**：项目有清晰的模块边界

**分配方式**：

```markdown
项目结构：
├── frontend/
├── backend/
├── database/
└── tests/

Agent Team 分配：
├─ Agent 1: frontend/
├─ Agent 2: backend/
├─ Agent 3: database/
└─ Agent 4: tests/
```

**优势**：
- ✅ 职责明确
- ✅ 减少冲突
- ✅ 易于管理

### 策略 2: 按功能维度分配

**适用场景**：需要多维度审查同一代码

**分配方式**：

```markdown
审查维度：
├── 代码质量
├── 安全性
├── 性能
└── 可维护性

Agent Team 分配：
├─ Agent 1: 代码质量审查
├─ Agent 2: 安全漏洞检查
├─ Agent 3: 性能分析
└─ Agent 4: 可维护性评估
```

**优势**：
- ✅ 多角度分析
- ✅ 更全面的审查
- ✅ 发现隐藏问题

### 策略 3: 按文件类型分配

**适用场景**：项目有多种类型的文件

**分配方式**：

```markdown
文件类型：
├── *.ts, *.tsx (TypeScript)
├── *.py (Python)
├── *.sql (Database)
└── *.md (Documentation)

Agent Team 分配：
├─ Agent 1: TypeScript 代码
├─ Agent 2: Python 代码
├─ Agent 3: 数据库 schema
└─ Agent 4: 文档内容
```

**优势**：
- ✅ 专业化处理
- ✅ 语言特定的最佳实践
- ✅ 更精准的分析

### 策略 4: 按时间范围分配

**适用场景**：分析历史演变或分阶段处理

**分配方式**：

```markdown
时间范围：
├── 最近 1 周的变更
├── 最近 1 月的变更
├── 最近 3 月的变更
└── 历史遗留代码

Agent Team 分配：
├─ Agent 1: 最新变更审查
├─ Agent 2: 近期趋势分析
├─ Agent 3: 中期演变追踪
└─ Agent 4: 历史债务识别
```

**优势**：
- ✅ 时间维度的洞察
- ✅ 识别演变趋势
- ✅ 发现累积问题

---

## 控制与监控

### 实时监控

**查看所有智能体的状态**：

```bash
# 方法 1: 使用内置命令
/agents status

# 输出示例：
Agent Team Status:
├─ Agent 1 (frontend): Running (75% complete)
├─ Agent 2 (backend): Running (80% complete)
├─ Agent 3 (tests): Completed ✅
└─ Agent 4 (docs): Running (60% complete)
```

### 切换控制权

**Shift+Up/Down**：在不同智能体之间切换

```markdown
操作流程：
1. 按住 Shift
2. 按 ↑ 或 ↓ 选择智能体
3. 松开按键，切换到选中的智能体
4. 现在你可以直接与该智能体交互

使用场景：
- 查看某个智能体的详细工作
- 直接干预或指导
- 手动修正问题
```

### 使用 tmux 管理

**tmux 集成**：更强大的多会话管理

```bash
# 启动 tmux 会话
tmux new -s claude-agents

# 在 tmux 中启动 Agent Teams
# 每个智能体会在独立的 pane 中运行

# tmux 快捷键
Ctrl+b %      # 垂直分割窗格
Ctrl+b "      # 水平分割窗格
Ctrl+b ←→↑↓   # 切换窗格
Ctrl+b d      # 分离会话
tmux attach   # 重新连接
```

**优势**：
- ✅ 可视化的多窗格管理
- ✅ 持久化的会话
- ✅ 灵活的布局控制

### 直接介入

**随时接管任何智能体**：

```markdown
场景：Agent 2 在审查后端时遇到问题

你（切换到 Agent 2）：
这个 API 设计有问题，我来帮你重新设计

Agent 2：
好的，我暂停当前任务，等待你的指导

你（提供指导）：
这个端点应该改为 RESTful 风格，使用以下结构...

Agent 2：
明白，我现在按照你的指导继续工作
[继续执行]
```

---

## Windows 特别说明

### PowerShell 环境

**Windows 上的 Agent Teams 使用**：

```powershell
# 方法 1: PowerShell 窗口
# 直接在 PowerShell 中使用 Agent Teams
# 每个智能体在独立的后台进程中运行

# 方法 2: Windows Terminal（推荐）
# 使用 Windows Terminal 的多标签页功能
wt -p "Claude Agent 1" claude
wt -p "Claude Agent 2" claude

# 切换智能体
# 使用 Alt+Shift+↑/↓ 或点击标签页
```

### tmux 替代方案

**Windows 上不直接支持 tmux**，使用以下替代方案：

#### 方案 1: Windows Terminal（推荐）

```powershell
# 安装 Windows Terminal
winget install Microsoft.WindowsTerminal

# 使用标签页管理多个智能体
# Ctrl+Shift+T: 新建标签页
# Ctrl+Tab: 切换标签页
```

#### 方案 2: WSL 2 + tmux

```bash
# 在 WSL 2 中使用 tmux
wsl
sudo apt install tmux
tmux new -s claude-agents

# 现在可以使用完整的 tmux 功能
```

#### 方案 3: PowerShell Jobs

```powershell
# 使用 PowerShell 后台作业
Start-Job -Name "Agent1" -ScriptBlock { claude }
Start-Job -Name "Agent2" -ScriptBlock { claude }

# 查看作业状态
Get-Job

# 接收作业输出
Receive-Job -Name "Agent1"
```

### 性能优化

**Windows 特定的优化建议**：

```powershell
# 1. 使用 PowerShell 7+（性能更好）
winget install Microsoft.PowerShell

# 2. 增加 Windows Terminal 的性能
# 编辑 settings.json，添加：
{
    "profiles": {
        "defaults": {
            "antialiasingMode": "grayscale",
            "closeOnExit": "graceful"
        }
    }
}

# 3. 监控资源使用
Get-Process | Where-Object {$_.ProcessName -like "*claude*"}
```

---

## 性能数据

### 官方基准测试

#### Terminal-Bench 2.0

**行业领先的性能表现**：

```markdown
Terminal-Bench 2.0 是评估 AI 编程能力的权威基准测试。

Claude Opus 4.6 表现：
- 综合得分：行业最高分 🏆
- 代码生成：领先所有竞争对手
- 调试能力：最准确的问题定位
- 重构质量：最高质量的代码改进
```

#### Humanity's Last Exam

**前沿模型对比**：

```markdown
Humanity's Last Exam 是最具挑战性的 AI 能力测试。

Claude Opus 4.6 表现：
- 领先所有前沿模型 🎯
- 在复杂推理任务中表现最佳
- 多步骤任务的完成率最高
```

#### GDPval-AA

**经济价值任务评估**：

```markdown
GDPval-AA 评估 AI 在实际经济价值任务中的表现。

Claude Opus 4.6 vs GPT-5.2：
- 领先 144 Elo 点 📈
- 70% 的时间得分更高
- 在生产级任务中更可靠
```

### 实际性能对比

**Agent Teams vs 传统模式**：

| 任务规模 | 传统模式 | Agent Teams | 加速比 |
|---------|---------|------------|--------|
| **小型（<50 文件）** | 10-20 分钟 | 8-15 分钟 | 1.3x |
| **中型（50-200 文件）** | 1-2 小时 | 15-25 分钟 | 4-8x |
| **大型（200-500 文件）** | 3-5 小时 | 20-40 分钟 | 7-15x |
| **超大型（500+ 文件）** | 8+ 小时 | 30-60 分钟 | 10-20x |

### Early Access 合作伙伴反馈

**Notion 的评价**：

> "Claude Opus 4.6 is the strongest model Anthropic has shipped.
> It takes complicated requests and actually follows through,
> breaking them into concrete steps, executing, and producing
> polished work even when the task is ambitious."

**GitHub 的评价**：

> "Early testing shows Claude Opus 4.6 delivering on the complex,
> multi-step coding work developers face every day—especially
> agentic workflows that demand planning and tool calling."

**Replit 的评价**：

> "Claude Opus 4.6 is a huge leap for agentic planning.
> It breaks complex tasks into independent subtasks, runs tools
> and subagents in parallel, and identifies blockers with real precision."

---

## 最佳实践

### 1. 任务分解

**✅ 好的分解**：

```markdown
审查整个项目：
├─ 前端代码审查（独立）
├─ 后端代码审查（独立）
├─ 测试覆盖率分析（独立）
└─ 文档完整性检查（独立）

特点：
- ✅ 任务独立，低耦合
- ✅ 可以并行执行
- ✅ 结果易于汇总
```

**❌ 不好的分解**：

```markdown
实现用户认证：
├─ 设计数据库 schema（依赖设计）
├─ 实现后端 API（依赖 schema）
├─ 创建前端组件（依赖 API）
└─ 编写测试（依赖所有完成）

问题：
- ❌ 任务高度依赖
- ❌ 无法并行执行
- ❌ 适合传统模式
```

### 2. 智能体数量选择

**经验法则**：

| 项目规模 | 推荐智能体数量 | 原因 |
|---------|---------------|------|
| **小型（<50 文件）** | 2-3 个 | 避免过度分解 |
| **中型（50-200 文件）** | 4-6 个 | 充分利用并行 |
| **大型（200-500 文件）** | 6-10 个 | 模块化处理 |
| **超大型（500+ 文件）** | 10-15 个 | 按子系统分解 |

**警告**：
- ⚠️ 智能体过多会增加协调成本
- ⚠️ 智能体过少无法充分利用并行优势
- ⚠️ 根据实际任务复杂度调整

### 3. 结果验证

**多层次的验证**：

```markdown
1. 自动交叉验证
   - 智能体之间自动检查
   - 发现潜在的冲突或不一致
   - 自动标记需要人工审查的部分

2. 人工审查重点
   - 关键业务逻辑
   - 安全相关的变更
   - 架构决策

3. 集成测试
   - 运行完整的测试套件
   - 验证系统整体功能
   - 检查性能影响
```

### 4. 成本控制

**优化策略**：

```markdown
1. 使用合适的 Effort 级别
   - 大多数审查任务：medium effort
   - 复杂重构任务：high effort
   - 简单检查任务：low effort

2. 限制智能体数量
   - 不要为了并行而过度分解
   - 根据实际需求确定数量

3. 使用 Context Compaction
   - 长时间运行的任务
   - 自动压缩不相关的上下文
   - 减少 token 消耗
```

---

## 常见问题

### Q1: Agent Teams 适合所有任务吗？

**A**: **不是**。Agent Teams 最适合：

- ✅ 可以分解为独立子任务的大型任务
- ✅ 需要多维度分析的任务
- ✅ 多模块或多仓库的项目
- ✅ 只读或分析类的任务

不适合：
- ❌ 高度耦合的顺序任务
- ❌ 简单的单文件修改
- ❌ 需要全局上下文的任务

### Q2: 如何知道是否应该使用 Agent Teams？

**A**: **判断标准**：

```markdown
问题 1: 任务是否可以分解为 3+ 个独立子任务？
├─ 是 → 考虑使用 Agent Teams
└─ 否 → 使用传统模式

问题 2: 子任务之间是否低耦合？
├─ 是 → 适合 Agent Teams
└─ 否 → 使用传统模式

问题 3: 预期执行时间是否 > 30 分钟？
├─ 是 → Agent Teams 可显著提升效率
└─ 否 → 传统模式足够
```

### Q3: Agent Teams 会增加成本吗？

**A**: **通常会增加 10-20%，但效率提升远超成本**。

```markdown
成本对比（大型项目审查）：
- 传统模式：$25, 3-5 小时
- Agent Teams：$30, 20-40 分钟

额外成本：$5
时间节省：2-4 小时
综合效益：显著正向
```

### Q4: Windows 上能用 Agent Teams 吗？

**A**: **完全支持！** 但有特定的注意事项：

- ✅ 使用 Windows Terminal 管理多个会话
- ✅ 使用 PowerShell 7+ 获得最佳性能
- ✅ 可以在 WSL 2 中使用 tmux
- ⚠️ 不直接支持原生 tmux（使用替代方案）

详见：[Windows 特别说明](#windows-特别说明)

### Q5: 如何监控和控制 Agent Teams？

**A**: **三种方法**：

1. **内置命令**：`/agents status` 查看所有智能体状态
2. **快捷键**：Shift+Up/Down 切换智能体
3. **tmux/Windows Terminal**：更强大的多会话管理

详见：[控制与监控](#控制与监控)

### Q6: Agent Teams 和 Subagent Skills 有什么区别？

**A**: **互补关系**：

```markdown
Agent Teams：
- 用于：并行执行多个独立任务
- 触发：用户描述多任务需求
- 控制：用户可随时介入

Subagent Skills：
- 用于：在隔离环境中执行特定技能
- 触发：用户调用 Skill（/skill-name）
- 控制：自动执行，返回结果

组合使用：
- Agent Team 可以包含多个 Subagent Skills
- 每个 Agent 使用不同的 Skill
- 实现高度专业化的并行处理
```

---

## 下一步

掌握 Agent Teams 后，继续提升你的 Claude Code 技能：

### 相关技能

```
1. 📖 [04-context-optimization.md](./04-context-optimization.md)
   → 1M Token Context 的深度使用

2. 🎓 [../d-skills-development/01-skill-fundamentals.md](../d-skills-development/01-skill-fundamentals.md)
   → 创建使用 Subagent 的 Skills

3. 🚀 [../../guide/02-core-features.md](../../guide/02-core-features.md)
   → 掌握所有核心功能
```

### 实践建议

```markdown
新手路径：
1. 从小项目开始（50-100 文件）
2. 使用 2-3 个智能体
3. 专注于代码审查任务
4. 逐步增加复杂度

进阶路径：
1. 处理大型项目（200+ 文件）
2. 使用 4-6 个智能体
3. 多维度并行分析
4. 结合自定义 Skills

专家路径：
1. 超大型项目（500+ 文件）
2. 10+ 个智能体协作
3. 自定义协调策略
4. 集成到 CI/CD 流程
```

---

**最后更新**: 2026-02-15
**文档版本**: v3.5 + Claude Opus 4.6
**下一章节**: [06-automated-workflows](./05-agent-teams.md)
