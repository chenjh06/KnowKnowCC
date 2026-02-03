# 会话管理技巧 - 持久化和恢复对话

> **让你的工作可以随时随地继续**

**阅读时间**: 20分钟
**难度**: ⭐⭐
**重要性**: ⭐⭐⭐⭐
**前置要求**: 完成 [Level 1 核心掌握](../../guide/)

---

## 目录

- [会话管理概述](#会话管理概述)
- [基础操作](#基础操作)
- [命名和恢复](#命名和恢复)
- [会话持久化](#会话持久化)
- [高级技巧](#高级技巧)
- [最佳实践](#最佳实践)
- [常见问题](#常见问题)

---

## 会话管理概述

### 什么是会话管理？

**定义**：保存、恢复、命名 Claude Code 对话的能力，实现长期工作的持续性。

**解决的问题**：

```
❌ 没有会话管理：
- 终端关闭 → 对话丢失
- 笔记本没电 → 工作丢失
- 切换项目 → 上下文混乱
- 多个项目 → 难以管理

✅ 有会话管理：
- 终端关闭 → 随时恢复
- 多台设备 → 无缝切换
- 多个项目 → 清晰分离
- 长期工作 → 持续积累
```

---

## 基础操作

### 1. 启动带会话名的对话

#### 命令行参数

```bash
# 启动新会话
claude --session my-project

# 或简写
claude -s my-project
```

#### 在对话中命名

```
👤 你：/rename frontend-refactor

🤖 Claude：会话已重命名为 "frontend-refactor"

✓ 会话命名完成
```

### 2. 查看会话历史

#### 命令

```bash
# 列出所有会话
claude --resume

# 或使用斜杠命令
/resume
```

#### 输出示例

```
=== 可恢复的会话 ===

[最近会话]

ecommerce-dashboard (2小时前)
├─ 最后活动：2025-01-17 14:30
├─ 项目：D:\Projects\ecommerce
└─ 状态：进行中

bugfix-login (昨天)
├─ 最后活动：2025-01-16 09:15
├─ 项目：D:\Projects\myapp
└─ 状态：已完成

tutorial-first (3天前)
├─ 最后活动：2025-01-14 16:45
├─ 项目：D:\Projects\tutorial
└─ 状态：已完成

=== 选择会话 ===
使用方向键选择，按 Enter 恢复
或输入会话名称直接恢复
```

### 3. 恢复会话

#### 方式 1：交互式选择

```bash
claude --resume
# 从列表中选择
```

#### 方式 2：直接指定

```bash
claude --resume ecommerce-dashboard
```

#### 方式 3：继续上一次

```bash
# 直接继续上一次的会话
claude --continue
# 或简写
claude -c
```

---

## 命名和恢复

### 命名策略

#### 策略 1: 基于项目

```
✅ 推荐：
- project-name
- feature-name
- client-name-task

示例：
ecommerce-dashboard
user-auth-feature
payment-api-refactor
```

#### 策略 2: 基于时间

```
适合：长期项目或日常使用

示例：
daily-standup-2025-01-17
weekly-review-jan
sprint-planning-q1
```

#### 策略 3: 基于任务类型

```
适合：明确的功能开发

示例：
bugfix-login
feature-shopping-cart
refactor-database
performance-optimization
```

### 会话分组

#### 自动分组

```
会话会自动按项目分组：

同一项目路径的会话会自动分组
```

#### 实例

```
项目：D:\Projects\myapp
会话1：myapp-feature-auth
会话2：myapp-bugfix-login
会话3：myapp-refactor-db

→ 这些会被自动分组
```

---

## 会话持久化

### 持久化机制

```
对话进行中
    ↓
自动保存（每轮对话后）
    ↓
.session/ 目录
├─ session-id-1.jsonl
├─ session-id-2.jsonl
└── ...
    ↓
可随时恢复
```

### 会话文件位置

```
Windows:
C:\Users\<User>\.claude\sessions\

macOS/Linux:
~/.claude/sessions/
```

### 会话保留期限

#### 配置设置

```json
// .claude/settings.json
{
  "cleanupPeriodDays": 180
}
```

#### 含义

```
默认：30 天
你设置：180 天
特殊值：0 = 永不保留
```

#### 清理机制

```
自动清理：
- 超过 180 天的会话自动删除
- 手动删除不受影响
- 重要会话建议 /export
```

---

## 高级技巧

### 技巧 1: 会话转移

#### 场景：在多台电脑间切换

```
电脑 A（办公室）：
1. 工作一天
2. 结束前：/rename office-work
3. 关闭终端

电脑 B（家里）：
1. 启动：claude --resume office-work
2. 上下文完整恢复
3. 继续工作
```

#### Remote 会话（高级）

```
网页版启动：
在 claude.ai/code 网页启动会话

本地恢复：
claude --teleport session-abc123

适合：
- 云端工作
- 远程协作
```

---

### 技巧 2: 会话导出和导入

#### 导出会话

```
👤 你：/export

🤖 Claude：会话已导出到：
     D:\Projects\.claude\sessions\
     conversation-2025-01-17.md

✅ 导出完成
```

#### 导出内容包含

```
- 所有对话消息
- 工具调用记录
- 文件修改历史
- 时间戳
```

#### 重新导入

```
方法 1：在对话中
👤 你：这是之前会话的总结：
    [粘贴导出的关键内容]

方法 2：作为上下文
@conversation-2025-01-17.md
"根据这个导出的会话继续工作"
```

---

### 技巧 3: 会话分支

#### 场景：并行任务

```
主会话：feature-auth
├─ 开发认证功能

分支会话1：auth-tests
├─ 编写测试

分支会话2：auth-docs
├─ 编写文档

完成后合并回主会话
```

#### 实现

```
# 主会话
claude --session feature-auth

# 新终端窗口
# 分支会话1
claude --session feature-auth-tests

# 另一个终端窗口
# 分支会话2
claude --session feature-auth-docs
```

---

### 技巧 4: 会话清理

#### 定期清理策略

```
每周：
1. 导出重要会话
2. 删除不需要的会话
3. 整理会话命名
```

#### 批量删除

```bash
# 查看所有会话
claude --resume

# 手动删除会话文件：
Windows:
del %USERPROFILE%\.claude\sessions\<session-id>

macOS/Linux:
rm ~/.claude/sessions/<session-id>
```

#### 保留重要会话

```
标记重要会话：
命名时加前缀：
IMPORTANT-ecommerce-core
CRITICAL-bugfix-security

避免被清理
```

---

## 最佳实践

### 实践 1: 会话生命周期

```
项目开始：
├─ 启动：claude --session project-name
├─ 初始化：/init
└─ 开始开发

项目进行中：
├─ 每天工作：
│   ├─ claude --continue（继续）
│   ├─ 工作完成
│   └─ 关闭终端
├─ 定期：/context 检查
└─ 优化：清理历史

项目完成：
├─ /export（导出）
├─ /rename project-name-completed
└─ 归档
```

---

### 实践 2: 多项目管理

```
策略 1：项目级会话
claude --session ecommerce
# 所有电商相关工作

策略 2：功能级会话
claude --session ecommerce-payment
# 只处理支付功能

策略 3：任务级会话
claude --session bugfix-login
# 只修复登录 bug

推荐：策略 1 + 策略 2/3
```

---

### 实践 3: 团队协作

#### 共享会话

```
不推荐：
直接分享会话文件（包含敏感信息）

推荐：
1. 导出会话关键内容
2. 创建文档说明
3. 团队成员基于文档开始新会话
```

#### 会话移交

```
开发 A：
1. 完成初步工作
2. /export
3. 编写交接文档
4. 将会话重命名为移交-ready

开发 B：
1. claude --resume移交-ready
2. /context 检查状态
3. 继续工作
```

---

### 实践 4: 会话备份

#### 备份策略

```
自动备份：
- cleanupPeriodDays：180 天（你设置）
- 定期自动清理

手动备份：
- 重要节点：/export
- 关键决策：记录到文档
- 项目完成：完整导出
```

#### 备份内容

```
应该导出：
✅ 重要对话
✅ 架构决策
✅ 解决方案
✅ 测试结果

不需要导出：
❌ 日常调试
❌ 简单询问
❌ 临时尝试
```

---

### 实践 5: 会话性能优化

#### 保持会话流畅

```
问题：会话变慢
原因：历史累积

解决：
1. /context 检查
2. 如果历史 > 70%：
   a) 总结当前工作
   b) /export 保存
   c) 新建会话
   d) 重新加载核心上下文
```

#### 分阶段长期项目

```
阶段 1（第1-2周）：
会话：project-phase-1

阶段 2（第3-4周）：
总结阶段1
会话：project-phase-2

阶段 3（第5-6周）：
总结阶段2
会话：project-phase-3

✓ 每个阶段上下文干净、高效
```

---

## 常见问题

### Q1: 会话会在不同设备间同步吗？

**A**: 不会自动同步，需要手动转移：

```
方法 1：导出 → 导入
设备 A：/export
设备 B：基于导出继续

方法 2：使用云端路径
将项目放在云盘（OneDrive/Dropbox）
不同设备访问同一路径
```

---

### Q2: 会话文件很大怎么办？

**A**: 这是正常的，但可以优化：

```
优化方法：
1. 定期清理历史（/export 后新建会话）
2. 减少大型文件的引用
3. 使用 .claudeignore
```

---

### Q3: 会话安全吗？

**A**:

```
安全考虑：
✅ 会话文件存储在本地
✅ 包含 API Token（需要保护）
⚠️ 不要分享会话文件

建议：
- 保护好 ~/.claude/ 目录
- 不要提交到 Git
- 包含敏感信息会话要加密
```

---

### Q4: 如何迁移旧会话？

**A**:

```
方法 1：直接启动（如果路径相同）
$ claude

方法 2：指定会话 ID
$ claude --resume <session-id>

方法 3：重命名
$ claude --session old-name
> /rename new-name
```

---

### Q5: 会话数量有限制吗？

**A**: 没有硬性限制，但建议：

```
推荐数量：
- 活跃会话：5-10 个
- 历史会话：自动清理（180天）

原因：
- 太多会话难以管理
- 查找不便
- 占用磁盘空间
```

---

### Q6: cleanupPeriodDays 已设置为 180 天，会话何时清理？

**A**:

```
清理规则：
- 从会话最后一次活动开始计算
- 180 天后自动删除
- 活动 = 对话中的任何交互

例子：
会话最后活动：2025-01-17
清理日期：2025-07-16（180天后）

保护重要会话：
1. 导出会话
2. 重命名为会添加前缀：
   - IMPORTANT-xxx
   - KEEP-xxx
3. 手动管理这些会话
```

---

### Q7: 如何批量管理会话？

**A**:

```powershell
# Windows PowerShell

# 列出所有会话
Get-ChildItem $env:USERPROFILE\.claude\sessions\

# 查看特定时间之前的会话
Get-ChildItem $env:USERPROFILE\.claude\sessions\ |
    Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-30) }

# 列出所有会话名
Get-ChildItem $env:USERPROFILE\.claude\sessions\ -File |
    ForEach-Object {
        $session = Get-Content $_..FullName | ConvertFrom-Json
        Write-Output $session.slug
    }
```

---

## 总结

### 核心价值

```
✅ 持续性：工作可以随时继续
✅ 灵活性：多设备、多项目
✅ 组织性：清晰的命名和分组
✅ 安全性：重要对话可导出
```

### 学习检查清单

- [ ] 理解会话管理价值
- [ ] 掌握基础操作
- [ ] 会命名和恢复
- [ ] 会话持久化策略
- [ ] 高级技巧（转移、导出）
- [ ] 最佳实践
- [ ] 团队协作

### 快速参考卡

| 操作 | 命令 | 说明 |
|------|------|------|
| 启动新会话 | `claude --session name` | 创建命名会话 |
| 继续上一次 | `claude --continue` | 直接继续 |
| 恢复会话 | `claude --resume` | 列表选择 |
| 直接恢复 | `claude --resume name` | 指定恢复 |
| 重命名 | `/rename new-name` | 命名会话 |
| 查看统计 | `/stats` | 使用统计 |
| 导出会话 | `/export` | 保存会话 |
| 上下文检查 | `/context` | Token 分析 |

---

## 下一步

继续学习 Level 2 技能：

```
[03 - Keyboard Shortcuts](../a-productivity/03-keyboard-shortcuts.md)
[03 - Subagents](../b-code-quality/03-subagents.md)
[04 - Code Review](../b-code-quality/04-code-review.md)
[MCP Servers](../c-integration/01-mcp-servers.md)
```

---

**最后更新**: 2026-02-04
**难度**: ⭐⭐
**重要性**: ⭐⭐⭐⭐
