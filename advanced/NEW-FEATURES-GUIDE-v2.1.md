# Claude Code v2.1 新功能指南

**文档版本**: v2.1.29
**最后更新**: 2026-02-04
**官方版本**: Claude Code v2.1.29 (2026-01-31)

---

## 📋 目录

- [概述](#概述)
- [Git PR 集成](#git-pr-集成)
- [任务管理系统](#任务管理系统)
- [PR 状态指示器](#pr-状态指示器)
- [权限系统变更](#权限系统变更)
- [性能改进](#性能改进)
- [Windows 修复](#windows-修复)

---

## 概述

Claude Code v2.1.x 系列版本引入了许多重要的新功能和改进。本指南详细说明这些新功能的使用方法。

### 版本时间线

```
v2.1.20 (2026-01-27) - 重大更新（任务管理系统）
     ↓
v2.1.22 (2026-01-28) - 结构化输出修复
     ↓
v2.1.23 (2026-01-29) - 重要更新（PR 状态、性能）
     ↓
v2.1.25 (2026-01-29) - Beta 验证修复
     ↓
v2.1.27 (2026-01-30) - 重要更新（--from-pr、Windows 修复）
     ↓
v2.1.29 (2026-01-31) - 性能改进
```

---

## Git PR 集成

### --from-pr 标志（v2.1.27 新增）

#### 功能说明

`--from-pr` 标志允许您恢复与特定 GitHub PR 关联的会话。这对于：
- 继续之前的 PR 审查工作
- 在 PR 讨论中保存和恢复上下文
- 多人协作时快速切换到特定 PR 的会话

#### 使用方法

**通过 PR 号码恢复**：
```bash
# 恢复与 PR #123 关联的会话
claude --from-pr 123

# 恢复与当前分支最新 PR 的会话
claude --from-pr
```

**通过 PR URL 恢复**：
```bash
# 完整 URL
claude --from-pr https://github.com/username/repo/pull/123

# 短 URL
claude --from-pr https://github.com/username/repo/pull/123
```

#### 自动 PR 链接

当使用 `gh pr create` 创建 PR 时，Claude Code 会话现在会自动链接到该 PR：

```bash
# 创建 PR
gh pr create --title "Add new feature" --body "Description"

# Claude Code 会话自动与此 PR 关联
# 下次可以使用 --from-pr 恢复
```

#### 实战案例

**案例 1: PR 审查工作流**

```bash
# 1. 开始审查 PR
gh pr checkout 123
claude --from-pr 123

# 2. Claude 会显示 PR 的上下文
# 3. 进行代码审查、提出修改建议
# 4. 保存会话并退出

# 5. 稍后恢复会话继续工作
claude --from-pr 123
```

**案例 2: 多 PR 协作**

```bash
# PR #123 - 功能开发
claude --from-pr 123
# 工作在功能 A...

# 切换到 PR #124 - Bug 修复
claude --from-pr 124
# 工作在 Bug 修复...

# 恢复之前的 PR #123
claude --from-pr 123
# 继续功能 A 的开发...
```

#### 相关命令

```bash
# 查看当前分支的 PR 状态
gh pr status

# 列出所有 PR
gh pr list

# 查看特定 PR
gh pr view 123
```

#### 注意事项

- ⚠️ PR 必须存在于当前仓库
- ⚠️ 需要安装 `gh` CLI 工具
- ⚠️ 需要先通过 `gh auth login` 进行身份验证

---

## 任务管理系统

### 系统概述（v2.1.20 重大更新）

Claude Code v2.1.20 引入了全新的任务管理系统，提供了更强大的任务组织和跟踪能力。

### 新增功能

#### 1. 依赖跟踪

任务现在可以声明依赖关系，确保任务按正确顺序执行：

```markdown
任务 B 依赖任务 A 的完成
```

**使用场景**：
- 多步骤代码重构
- 前置条件检查
- 分阶段实施

#### 2. 删除任务

现在可以通过 `TaskUpdate` 工具删除任务：

```python
# TaskUpdate 工具示例
{
  "taskId": "task-id",
  "status": "deleted"
}
```

**使用场景**：
- 取消不再需要的任务
- 清理过时的任务
- 重新组织工作流

#### 3. 改进的 UI

- 动态调整可见任务项（基于终端高度）
- 更清晰的任务状态显示
- 改进的任务列表导航

### 环境变量

**临时使用旧任务系统**：

```bash
# 禁用新任务系统
CLAUDE_CODE_ENABLE_TASKS=false claude

# 或导出为环境变量
export CLAUDE_CODE_ENABLE_TASKS=false
claude
```

**何时使用旧系统**：
- 迁移期间需要兼容性
- 测试和验证新系统
- 特定工作流需要旧系统行为

### 迁移指南

**从旧系统迁移**：

1. **评估当前使用情况**：
   ```bash
   # 检查是否有自定义任务配置
   ls -la .claude/tasks/
   ```

2. **测试新系统**：
   ```bash
   # 在测试分支中启用新系统
   git checkout -b test-new-tasks
   claude  # 新系统自动启用
   ```

3. **更新工作流**：
   - 更新任务创建流程
   - 利用新的依赖跟踪功能
   - 使用删除任务功能

4. **验证**：
   ```bash
   # 确保所有任务正常工作
   claude --list-tasks
   ```

### 最佳实践

**使用依赖跟踪**：
```python
# 示例：多步骤部署任务
TaskCreate(
  subject="测试代码",
  description="运行所有测试",
  dependencies=[]
)

TaskCreate(
  subject="构建项目",
  description="构建生产版本",
  dependencies=["测试代码"]  # 依赖测试任务
)

TaskCreate(
  subject="部署到生产",
  description="部署到生产环境",
  dependencies=["构建项目"]  # 依赖构建任务
)
```

**删除不需要的任务**：
```python
# 任务完成后删除
TaskUpdate(
  taskId="completed-task-id",
  status="deleted"
)
```

---

## PR 状态指示器

### 功能说明（v2.1.23 新增）

PR 状态指示器在提示符底部显示当前分支的 PR 状态，帮助您快速了解 PR 的审查进度。

### 状态类型

| 状态 | 颜色 | 说明 |
|------|------|------|
| **Approved** | 🟢 绿色 | PR 已批准，可以合并 |
| **Changes Requested** | 🔴 红色 | 审查者要求修改 |
| **Pending** | 🟡 黄色 | 等待审查 |
| **Draft** | ⚪ 灰色 | 草稿 PR |

### 显示位置

PR 状态指示器显示在提示符底部（footer）：

```
[Claude Code] 🟢 Approved (PR #123)
```

### 使用场景

**场景 1: 实时反馈**

```bash
# 提交 PR 后
gh pr create

# 提示符显示状态
[Claude Code] 🟡 Pending (PR #123)

# 等待审查...
# 审查者批准后
[Claude Code] 🟢 Approved (PR #123)
```

**场景 2: 快速判断**

```bash
# 在开始工作前查看状态
git checkout feature-branch

# 提示符显示 PR 状态
[Claude Code] 🔴 Changes Requested (PR #123)

# 知道需要先修改再继续
```

### 配置

**禁用 PR 状态指示器**（如果不需要）：

在 `.claude/config.json` 中配置：

```json
{
  "features": {
    "prStatusIndicator": false
  }
}
```

---

## 权限系统变更

### 重要变更（v2.1.27）

**权限系统现在尊重 content-level `ask` 而非 tool-level `allow`**

#### 变更说明

**之前的行为**（v2.1.26 及更早）：

```json
{
  "permissions": {
    "allow": ["Bash"],
    "ask": ["Bash(rm *)"]
  }
}
```

**结果**：
- ✅ 允许所有 Bash 命令（包括 `rm`）
- ❌ `ask` 规则被忽略

**现在的行为**（v2.1.27+）：

相同的配置：

```json
{
  "permissions": {
    "allow": ["Bash"],
    "ask": ["Bash(rm *)"]
  }
}
```

**结果**：
- ✅ 大部分 Bash 命令允许
- ✅ `rm *` 命令会提示权限
- ✅ `ask` 规则优先级更高

#### 配置示例

**示例 1: 允许 Bash 但询问危险命令**

```json
{
  "permissions": {
    "allow": ["Bash"],
    "ask": [
      "Bash(rm *)",
      "Bash(rmdir *)",
      "Bash(mv *)",
      "Bash(*force*)"
    ]
  }
}
```

**示例 2: 更细粒度的控制**

```json
{
  "permissions": {
    "allow": ["Read", "Edit", "Write"],
    "ask": ["Bash(*)"],
    "deny": ["Bash(rm -rf *)"]
  }
}
```

**示例 3: 按工具和内容混合**

```json
{
  "permissions": {
    "allow": ["Bash", "Edit"],
    "ask": [
      "Bash(rm *)",
      "Bash(sudo)",
      "Edit(*.config)"
    ]
  }
}
```

#### 迁移指南

**检查当前配置**：

```bash
# 查看权限配置
cat .claude/config.json | grep -A 10 permissions
```

**测试新行为**：

1. **保存当前配置**：
   ```bash
   cp .claude/config.json .claude/config.json.bak
   ```

2. **测试危险命令**：
   ```bash
   claude
   # 尝试执行 rm 命令
   # 应该会提示权限
   ```

3. **调整配置**（如果需要）：
   - 更新 `ask` 规则以匹配预期行为
   - 或添加 `allow` 规则以允许特定命令

4. **验证**：
   ```bash
   # 测试各种命令
   # 确保权限提示符合预期
   ```

---

## 性能改进

### 启动性能（v2.1.29）

**改进内容**：
- 修复恢复有 `saved_hook_context` 的会话时的启动性能问题
- 特别影响大型项目的会话恢复

**性能提升**：
- 大型项目会话恢复速度提升 30-50%
- 内存使用优化

**验证方法**：

```bash
# 测试会话恢复性能
time claude --resume

# 查看内存使用
# Windows
Get-Process claude

# macOS/Linux
ps aux | grep claude
```

### 终端渲染性能（v2.1.23）

**改进内容**：
- 优化的屏幕数据布局
- 更好的渲染性能

**性能提升**：
- 大量输出时的渲染速度提升
- 更流畅的滚动体验
- 减少 CPU 使用

### 搜索性能（v2.1.23）

**改进内容**：
- 修复 ripgrep 搜索超时问题
- 现在会正确报告错误而非静默返回空结果

**影响**：
- 大型代码库搜索更可靠
- 更准确的错误报告

---

## Windows 修复

### Bash 命令执行失败（v2.1.27 修复）✅

**症状**：
- PowerShell 中执行 bash 命令失败
- 误报错误信息

**解决方案**：
- 更新到 v2.1.27 或更高版本

**详细信息**：
- 参见 `windows/04-troubleshooting.md`

### 控制台窗口闪烁（v2.1.27 修复）✅

**症状**：
- 生成子进程时控制台窗口闪烁
- 影响用户体验

**解决方案**：
- 更新到 v2.1.27 或更高版本

**详细信息**：
- 参见 `windows/04-troubleshooting.md`

---

## 相关资源

### 官方文档

- [Claude Code 官方文档](https://claude.ai/code/docs)
- [官方 GitHub 仓库](https://github.com/anthropics/claude-code)
- [官方更新日志](https://github.com/anthropics/claude-code/releases)

### 项目文档

- [会话管理](./a-productivity/02-session-management.md)
- [Git/CI-CD 集成](./c-integration/04-practical-cases.md)
- [Windows 故障排查](../windows/04-troubleshooting.md)

---

## 更新记录

**v2.1.29** (2026-02-04)
- 初始版本
- 记录 v2.1.20-v2.1.29 的所有重要更新

---

**文档维护**: 本文档将随着官方版本更新持续维护
**下次更新**: 官方发布 v2.1.30 或更高版本时
