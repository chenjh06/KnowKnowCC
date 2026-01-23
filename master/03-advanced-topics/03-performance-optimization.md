# 性能优化 - Performance Optimization

> **让 Claude Code 飞速运行**

**阅读时间**: 40分钟
**难度**: ⭐⭐⭐⭐
**适用场景**: 大型项目、频繁使用、性能敏感
**前置要求**: [Level 2 进阶提升](../../advanced/), [上下文优化](../../advanced/a-productivity/04-context-optimization.md)

---

## 目录

- [性能优化概述](#性能优化概述)
- [性能瓶颈识别](#性能瓶颈识别)
- [上下文管理优化](#上下文管理优化)
- [Token 使用优化](#token-使用优化)
- [缓存策略](#缓存策略)
- [并发处理](#并发处理)
- [系统资源优化](#系统资源优化)
- [实战案例](#实战案例)
- [Windows 专属](#windows-专属)
- [监控和诊断](#监控和诊断)
- [最佳实践](#最佳实践)

---

## 性能优化概述

### 为什么需要性能优化？

**性能优化的价值**：

```
优化前：
每次响应：5-10秒
大型项目：15-30秒
用户等待：😤 焦虑

优化后：
每次响应：1-3秒
大型项目：3-8秒
用户等待：😊 满意

提升：3-5倍
```

### 性能优化的维度

```
┌─────────────────────────────────────┐
│  Claude Code 性能优化                │
│                                     │
│  ├─ 上下文管理                      │
│  │  └─ 减少不必要的上下文            │
│  │                                   │
│  ├─ Token 使用                       │
│  │  └─ 优化 Token 消耗               │
│  │                                   │
│  ├─ 缓存策略                         │
│  │  └─ 重用已计算的结果              │
│  │                                   │
│  ├─ 并发处理                         │
│  │  └─ 并行执行独立任务              │
│  │                                   │
│  ├─ 系统资源                         │
│  │  └─ 优化 CPU 和内存使用           │
│  │                                   │
│  └─ 网络优化                         │
│     └─ 减少 API 调用延迟             │
└─────────────────────────────────────┘
```

### 性能指标

**关键指标**：

```
响应时间 (Response Time)
- 目标: < 3秒
- 可接受: 3-5秒
- 需优化: > 5秒

Token 使用 (Token Usage)
- 简单任务: < 1000 tokens
- 中等任务: 1000-5000 tokens
- 复杂任务: 5000-10000 tokens
- 需优化: > 10000 tokens

会话大小 (Session Size)
- 推荐: < 100KB
- 警告: 100-500KB
- 需优化: > 500KB
```

---

## 性能瓶颈识别

### 瓶颈类型

#### 1. 上下文过大

**症状**：
```
❌ 响应时间过长
❌ Token 消耗过高
❌ 出现截断
❌ 成本增加
```

**诊断**：

```markdown
# 检查上下文大小

# 方法1：查看会话统计
@<session>  # 查看当前会话大小

# 方法2：检查 Token 使用
@<stats>   # 查看 Token 统计

# 方法3：观察性能
- 大型文件：> 10秒
- 多文件引用：> 15秒
- 长会话：> 20秒
```

#### 2. 重复计算

**症状**：
```
❌ 相同问题重复询问
❌ 重复执行相同命令
❌ 没有利用缓存
```

**诊断**：

```markdown
# 识别重复模式

# 场景1：反复查看同一文件
@src/utils/helpers.js
# 5分钟后又问
@src/utils/helpers.js

# 场景2：重复执行测试
! npm test
# 修改一个小地方
! npm test

# 场景3：重复解释概念
"什么是闭包？"
# 10分钟后
"闭包是什么？"
```

#### 3. 网络延迟

**症状**：
```
❌ 首次响应慢
❌ API 调用超时
❌ 间歇性卡顿
```

**诊断**：

```powershell
# Windows
Test-Connection api.anthropic.com -Count 10

# 检查延迟
ping api.anthropic.com
```

#### 4. 系统资源不足

**症状**：
```
❌ CPU 占用高
❌ 内存不足
❌ 磁盘 I/O 高
```

**诊断**：

```powershell
# Windows 任务管理器
# 或 PowerShell
Get-Process | Sort-Object CPU -Descending | Select-Object -First 10

# 内存使用
Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 10
```

### 性能分析工具

#### 内置工具

```markdown
# Claude Code 内置

@<session>    # 查看会话信息
@<stats>      # 查看 Token 统计
@<history>    # 查看历史记录
```

#### 外部工具

```powershell
# 网络延迟
ping api.anthropic.com

# DNS 解析
nslookup api.anthropic.com

# 系统监控
# 任务管理器
# Resource Monitor
# Performance Monitor
```

---

## 上下文管理优化

### 原则1: 精确引用

**❌ 不好：引用整个目录**

```markdown
# 引用整个项目
@src/   # 可能包含数千个文件

结果：
- Token 消耗：10000+
- 响应时间：15-30秒
- 成本：高
```

**✅ 好：精确引用**

```markdown
# 只引用需要的文件
@src/utils/helpers.js
@src/components/Button.tsx

结果：
- Token 消耗：500-1000
- 响应时间：2-5秒
- 成本：低
```

### 原则2: 分阶段上下文

**❌ 不好：一次性加载所有上下文**

```markdown
👤 你：@src/ @tests/ @docs/ 分析整个项目架构

🤖 Claude：[处理 15000+ tokens]
[响应时间：20秒]
```

**✅ 好：逐步建立上下文**

```markdown
# 第1步：了解结构
👤 你：@src/ 列出目录结构

# 第2步：深入关键部分
👤 你：@src/main.ts @src/app.ts 解释架构

# 第3步：针对具体问题
👤 你：@src/components/Button.tsx 如何优化？

结果：
- 每步：500-1000 tokens
- 总时间：更短
- 更清晰的问题
```

### 原则3: 清理无用上下文

**会话过长时**：

```markdown
# 选项1：开始新会话
👤 你：新会话

# 选项2：明确切换话题
👤 你：让我们开始一个新话题

# 选项3：保存会话后清理
👤 你：保存当前进度到 session-summary.md
然后：新会话
```

### 原则4: 使用 CLAUDE.md

**项目级上下文**：

```markdown
# .claude/CLAUDE.md

# 项目架构
- 前端：React + TypeScript
- 后端：Node.js + Express
- 数据库：PostgreSQL

# 重要约定
- 组件放在 src/components/
- 工具函数放在 src/utils/
- 测试文件使用 .test.ts 后缀

# 开发规范
- 使用函数组件
- 状态管理使用 Zustand
- API 调用使用 axios
```

**优势**：
```
✅ 减少重复解释
✅ 自动加载项目上下文
✅ 保持一致性
✅ 节省 Token
```

---

## Token 使用优化

### Token 使用模式

#### 模式1: 长文本摘要

**❌ 不好：发送整个文档**

```markdown
👤 你：@README.md @CONTRIBUTING.md @ARCHITECTURE.md
阅读所有文档并总结

问题：
- 3个文档 = 3000+ tokens
- 阅读时间长
- 成本高
```

**✅ 好：分步总结**

```markdown
# 第1步：目录索引
👤 你：@README.md 列出主要章节

# 第2步：针对性阅读
👤 你：@README.md 只看"快速开始"部分

# 第3步：交叉验证
👤 你：@CONTRIBUTING.md 的贡献流程是否与 README 一致？

结果：
- 更快理解
- Token 使用更少
- 更好的交互
```

#### 模式2: 代码审查

**❌ 不好：一次性审查所有代码**

```markdown
👤 你：@src/ 审查所有代码

问题：
- Token 消耗巨大
- 失去焦点
- 质量下降
```

**✅ 好：分批审查**

```markdown
# 第1批：核心文件
👤 你：@src/main.ts @src/app.ts 审查架构

# 第2批：组件
👤 你：@src/components/ 审查组件设计

# 第3批：工具函数
👤 你：@src/utils/ 审查工具函数
```

#### 模式3: 代码生成

**优化策略**：

```markdown
# ✅ 策略1：生成框架后填充

# 第1步：生成结构
👤 你：创建一个 React 组件的骨架

# 第2步：填充细节
👤 你：为骨架添加状态管理

# 第3步：添加样式
👤 你：为组件添加 Tailwind 样式

# ✅ 策略2：生成后手动优化

👤 你：生成一个表单组件
[生成代码]

👤 你：优化这个组件的类型定义
[针对性优化]

👤 你：添加表单验证
[功能增强]
```

### Token 预算

**建议预算**：

```
简单任务：< 500 tokens
- 查询信息
- 简单修改
- 快速问答

中等任务：500-2000 tokens
- 代码生成
- 问题诊断
- 功能实现

复杂任务：2000-5000 tokens
- 架构设计
- 重构建议
- 完整功能

避免：> 10000 tokens
- 拆分为多个任务
- 分步处理
```

---

## 缓存策略

### 文件级缓存

**概念**：

```
第一次请求：
读取文件 → 处理 → 返回结果
         ↓
      保存到缓存

后续请求：
检查缓存 → 命中 → 立即返回结果
            ↓
         大幅提速
```

**实现**：

```markdown
# .claude/cache.md

# 缓存的文件和结果

## helpers.js
**最后更新**: 2026-01-18
**功能**: 工具函数集合
**主要函数**:
- debounce(func, delay)
- throttle(func, limit)
- formatDate(date)
- generateId()

## config.json
**最后更新**: 2026-01-18
**数据库**: PostgreSQL
**端口**: 5432
**环境**: development
```

**使用**：

```markdown
👤 你：@cache.md helpers.js 有哪些函数？

🤖 Claude：[从缓存快速读取]
debounce, throttle, formatDate, generateId
```

### 会话级缓存

**利用会话记忆**：

```markdown
# 第1次询问
👤 你：解释 React 的 useEffect

🤖 Claude：[详细解释]
...

# 第2次引用（无需重新解释）
👤 你：基于刚才的 useEffect 解释，
useLayoutEffect 有什么不同？

🤖 Claude：[利用上下文，无需重新解释 useEffect]
主要区别是时机...
```

### 命令结果缓存

**保存常用命令结果**：

```markdown
# scripts/save-results.sh

#!/bin/bash
# 保存命令结果到缓存

RESULT_FILE=".claude/results/$(date +%Y%m%d).txt"

# 执行命令并保存
npm test | tee $RESULT_FILE

echo "结果已保存到: $RESULT_FILE"
```

**使用**：

```markdown
👤 你：@.claude/results/20260118.txt
分析测试失败的用例

🤖 Claude：[读取缓存结果]
发现3个失败的测试...
```

---

## 并发处理

### 并行任务

**场景：同时处理多个独立文件**

```markdown
# ❌ 串行处理（慢）

👤 你：@src/components/Button.tsx 添加类型定义
[等待完成]

👤 你：@src/components/Input.tsx 添加类型定义
[等待完成]

👤 你：@src/components/Modal.tsx 添加类型定义
[等待完成]

总时间：3 × 5秒 = 15秒
```

```markdown
# ✅ 并行处理（快）

👤 你：为以下组件添加类型定义：
- @src/components/Button.tsx
- @src/components/Input.tsx
- @src/components/Modal.tsx

🤖 Claude：[并行处理3个文件]
总时间：~6秒（节省 60%）
```

### 批处理

**场景：批量修改**

```markdown
# ✅ 一次性批量操作

👤 你：为 src/components/ 下所有组件添加：
1. displayName 属性
2. PropTypes 类型定义
3. defaultProps

🤖 Claude：[批量处理所有组件]
完成！处理了15个组件
```

### 异步模式

**长任务异步化**：

```markdown
# ✅ 启动长任务后继续

👤 你：运行完整测试套件，并在后台继续

🤖 Claude：启动测试...
[测试运行中...]

👤 你：同时，帮我检查 @src/utils/config.js

🤖 Claude：[处理配置文件]
配置检查完成...

[后台] 测试完成，12个通过，1个失败

总时间：8秒（而非15秒）
```

---

## 系统资源优化

### CPU 优化

**减少 CPU 密集操作**：

```markdown
# ❌ 不好：大量字符串操作

👤 你：分析 1000 个日志文件中的错误模式

问题：
- 大量文件读取
- 复杂的正则匹配
- CPU 占用高

# ✅ 好：采样分析

👤 你：随机抽样分析 50 个日志文件
找出主要错误模式

👤 你：基于模式，扫描所有文件
但只统计计数，不详细分析
```

### 内存优化

**避免内存泄漏**：

```markdown
# ✅ 定期清理会话

# 长会话后
👤 你：总结当前进度到 session-summary.md
然后：新会话

# 从摘要恢复
👤 你：@session-summary.md
继续之前的工作
```

### 磁盘 I/O 优化

**减少磁盘访问**：

```markdown
# ✅ 使用内存缓存

# 第1次：读取
👤 你：@package.json 列出所有依赖

# 第2次：从缓存
👤 你：刚才的依赖列表中，
哪些是开发依赖？

✅ 无需重新读取文件
```

---

## 实战案例

### 案例1: 大型代码库分析

**场景**：分析包含 500+ 文件的项目

**❌ 不好：一次性加载**

```markdown
👤 你：@src/ 分析整个项目架构

问题：
- Token: 15000+
- 时间: 30秒+
- 成本: 高
```

**✅ 好：分阶段分析**

```markdown
# 第1阶段：目录结构
👤 你：@src/ 只显示目录结构（不读取文件）
Token: ~200
时间: ~2秒

# 第2阶段：关键文件
👤 你：@src/main.ts @src/app.ts 分析入口点
Token: ~800
时间: ~3秒

# 第3阶段：模块分析
👤 你：@src/components/ @src/utils/
分别列出主要模块和功能
Token: ~1500
时间: ~5秒

总Token: ~2500（节省 83%）
总时间: ~10秒（节省 67%）
```

### 案例2: 重构大型组件

**场景**：重构一个 1000+ 行的组件

**✅ 策略：模块化重构**

```markdown
# 第1步：分析结构
👤 你：@src/components/LargeComponent.tsx
分析组件的主要功能块

# 第2步：提取模块
👤 你：基于分析，创建：
1. hooks/useLargeComponentLogic.ts
2. utils/largeComponentHelpers.ts
3. types/largeComponent.types.ts

# 第3步：逐个实现
👤 你：实现 useLargeComponentLogic.ts
只包含状态管理和副作用

👤 你：实现 largeComponentHelpers.ts
只包含工具函数

# 第4步：组装
👤 你：重构 LargeComponent.tsx
使用新创建的模块

结果：
- Token: 每步 ~1000，总计 ~5000
- 质量：每个模块独立测试
- 可维护性：大幅提升
```

### 案例3: 批量代码审查

**场景**：审查多个 PR 的代码

**✅ 并行审查策略**

```markdown
# 一次请求多个审查

👤 你：审查以下 PR 的代码变更：
1. @pr-123/feature-A.tsx
2. @pr-124/fix-B.ts
3. @pr-125/refactor-C.tsx

重点检查：
- 代码质量
- 潜在 bug
- 性能问题

🤖 Claude：[并行处理3个文件]
**PR-123**: 发现2个问题...
**PR-124**: 发现1个问题...
**PR-125**: 发现3个问题...

总时间: ~8秒
（串行需要: 15秒）
```

### 案例4: 持续优化循环

**场景**：持续优化代码性能

```markdown
# 第1轮：识别瓶颈
👤 你：@src/app.ts
分析性能瓶颈

# 第2轮：针对性优化
👤 你：优化 identified issues
1. 减少不必要的重渲染
2. 优化数据获取
3. 添加缓存层

# 第3轮：验证
👤 你：@src/app.ts（优化后）
验证性能改进

# 第4轮：迭代
[根据结果继续优化]

持续改进，逐步提升
```

---

## Windows 专属

### PowerShell 性能优化

**使用 PowerShell 7**：

```powershell
# ✅ PowerShell 7（Core）
pwsh  # 更快的性能

# ❌ Windows PowerShell 5.x
powershell  # 较慢
```

**并行处理**：

```powershell
# PowerShell 7 支持并行

# ✅ 并行处理文件
$files = Get-ChildItem -Recurse -Filter "*.ts"
$files | ForEach-Object -Parallel {
    # 处理每个文件
} -ThrottleLimit 5
```

### Windows Terminal 优化

**硬件加速**：

```json
// settings.json
{
    "profiles": {
        "defaults": {
            "experimental.rendering.forceFullRepaint": true,
            "experimental.rendering.software": false
        }
    }
}
```

### 文件系统优化

**使用 SSD**：

```
HDD → SSD
性能提升：3-5倍
```

**禁用索引（某些场景）**：

```powershell
# 对开发目录禁用 Windows 搜索索引
# 减少磁盘 I/O
```

---

## 监控和诊断

### 性能监控

**内置监控**：

```markdown
# 定期检查

@<stats>  # 查看 Token 使用
@<session>  # 查看会话大小

# 建议频率
- 小项目：每周
- 大项目：每天
- 关键任务：每次
```

**自定义监控**：

```markdown
# .claude/performance-log.md

## 性能日志

### 2026-01-18

**任务**: 代码审查
**文件**: @src/app.ts
**Token**: 1250
**时间**: 4.2秒
**满意度**: ✅ 良好

---

**任务**: 架构分析
**文件**: @src/
**Token**: 8500
**时间**: 18秒
**满意度**: ⚠️ 需优化

**改进**: 下次分阶段分析
```

### 性能基准

**建立基准**：

```
简单查询：< 2秒
代码生成：< 5秒
代码审查：< 8秒
架构分析：< 15秒

超出基准需要优化
```

### 问题诊断

**诊断流程**：

```
1. 识别症状
   ├─ 响应慢
   ├─ Token 高
   └─ 错误频繁

2. 定位原因
   ├─ 上下文过大
   ├─ 重复计算
   ├─ 网络延迟
   └─ 资源不足

3. 应用优化
   ├─ 减少上下文
   ├─ 使用缓存
   ├─ 并行处理
   └─ 系统优化

4. 验证效果
   ├─ 对比基准
   ├─ 持续监控
   └─ 迭代改进
```

---

## 最佳实践

### 1. 精确引用原则

```markdown
✅ 好习惯：
- 只引用需要的文件
- 使用文件模式而非目录
- 分阶段加载上下文

❌ 避免习惯：
- 引用整个项目
- 重复引用相同文件
- 一次性加载所有上下文
```

### 2. 会话管理

```markdown
✅ 好习惯：
- 定期清理长会话
- 保存会话摘要
- 必要时开始新会话

❌ 避免习惯：
- 会话过长不清理
- 重复解释相同概念
- 无限积累上下文
```

### 3. 缓存策略

```markdown
✅ 好习惯：
- 利用会话记忆
- 保存常用结果
- 建立项目 CLAUDE.md

❌ 避免习惯：
- 重复执行相同命令
- 重复读取相同文件
- 重复解释相同概念
```

### 4. 批处理

```markdown
✅ 好习惯：
- 合并相似任务
- 并行处理独立任务
- 一次性批量操作

❌ 避免习惯：
- 逐个处理文件
- 串行执行独立任务
- 重复相同操作
```

### 5. 持续优化

```markdown
✅ 好习惯：
- 监控性能指标
- 定期审查使用模式
- 持续改进工作流

❌ 避免习惯：
- 忽视性能问题
- 固守低效方法
- 不总结经验
```

---

## 总结

### 性能优化检查清单

```
上下文管理
□ 精确引用文件
□ 分阶段加载
□ 清理无用上下文
□ 使用 CLAUDE.md

Token 优化
□ 长文本摘要
□ 分批审查
□ 代码生成策略
□ 控制 Token 预算

缓存策略
□ 文件级缓存
□ 会话级缓存
□ 命令结果缓存

并发处理
□ 并行任务
□ 批处理
□ 异步模式

系统优化
□ CPU 优化
□ 内存优化
□ 磁盘 I/O 优化

监控诊断
□ 性能监控
□ 基准测试
□ 问题诊断
```

### 优化效果预期

```
优化前：
平均响应：8-10秒
大型项目：20-30秒
Token 使用：8000+

优化后：
平均响应：2-3秒
大型项目：5-8秒
Token 使用：2000-3000

提升：3-5倍
```

---

## 相关资源

### 项目文档
- [上下文优化](../../advanced/a-productivity/04-context-optimization.md) - Token 使用优化
- [Plan 模式](../../advanced/a-productivity/01-plan-mode.md) - 任务规划优化
- [Windows 性能](../windows/03-performance.md) - Windows 系统优化

### 外部资源
- [Claude Code 官方文档](https://claude.ai/code/docs)
- [性能最佳实践](https://docs.anthropic.com/claude/reference/performance)

---

**最后更新**: 2026-01-18
**难度**: ⭐⭐⭐⭐
**阅读时间**: 40分钟
**重要性**: ⭐⭐⭐⭐
