# Claude Code v2.1.41-v2.1.88 新功能指南

**文档日期**: 2026-03-31
**跟踪版本**: v2.1.41 → v2.1.88
**官方文档**: [Changelog](https://code.claude.com/docs/en/changelog)

---

## 📊 更新概览

### 版本里程碑

| 版本 | 发布日期 | 核心更新 |
|------|---------|---------|
| **v2.1.88** | 2026-03-31 | PermissionDenied Hook、无闪烁渲染、命名子Agent、Windows CRLF/语音修复、内存泄漏修复 |
| **v2.1.87** | 2026-03-29 | Cowork Dispatch 消息投递修复 |
| **v2.1.86** | 2026-03-27 | Session-Id 请求头、Jujutsu/Sapling VCS、性能优化（token/内存）、VSCode 修复 |
| **v2.1.85** | 2026-03-26 | Hooks 条件过滤、MCP 环境变量、PreToolUse 增强、性能优化 |
| **v2.1.84** | 2026-03-26 | PowerShell 工具（Windows 预览）、TaskCreated Hook、MCP 优化 |
| **v2.1.83** | 2026-03-25 | managed-settings.d/ 目录、Hooks 事件扩展、 transcripts 搜索 |
| **v2.1.81** | 2026-03-20 | `--bare` 标志、`--channels` 权限中继 |
| **v2.1.80** | 2026-03-19 | rate_limits 状态栏、`--channels` 研究预览 |
| **v2.1.79** | 2026-03-18 | `--console` 登录、回合时长显示 |
| **v2.1.78** | 2026-03-17 | StopFailure hook、插件数据持久化、行级流式输出 |
| **v2.1.76** | 2026-03-14 | MCP Elicitation、`/effort` 命令、worktree.sparsePaths |
| **v2.1.75** | 2026-03-13 | 1M 上下文窗口、`/color` 命令 |
| **v2.1.74** | 2026-03-12 | 改进的 `/context`、autoMemoryDirectory |
| **v2.1.73** | 2026-03-11 | modelOverrides 设置 |
| **v2.1.72** | 2026-03-10 | ExitWorktree 工具、简化的 effort |
| **v2.1.71** | 2026-03-07 | `/loop` 循环任务、Cron 调度 |
| **v2.1.70** | 2026-03-06 | VSCode spark 图标、Markdown 计划视图 |
| **v2.1.69** | 2026-03-05 | `/claude-api` skill、10 种新语音语言 |
| **v2.1.68** | 2026-03-04 | Opus 4.6 默认、ultrathink、1M 上下文 |
| **v2.1.63** | 2026-02-28 | `/simplify`、`/batch`、HTTP hooks |

---

## 🆕 v2.1.88 新功能速览 (2026-03-31)

### 🪝 PermissionDenied Hook ⭐⭐⭐⭐⭐

**重大更新**: Auto Mode 拒绝操作后，现在会触发 `PermissionDenied` Hook，可以返回 `{retry: true}` 让模型自动重试。

```json
// settings.json
{
  "hooks": {
    "PermissionDenied": [{
      "command": "handler.sh",
      "retry": true
    }]
  }
}
```

**应用场景**:
- Auto Mode 拒绝后自动降级为更安全操作
- 拒绝操作后发送通知
- 记录被拒绝的操作用于安全审计

### 🖥️ 无闪烁渲染 ⭐⭐⭐⭐

```bash
# 启用无闪烁模式
export CLAUDE_CODE_NO_FLICKER=1
```

使用虚拟滚动缓冲区替代传统 alt-screen 切换，消除终端闪烁。

### 📝 命名子 Agent @提及

`@` 补全建议中现在显示已命名的子 Agent，方便在多 Agent 协作中快速引用。

### 🔧 关键修复（Windows 用户重点关注）

| 修复 | 说明 |
|------|------|
| **Edit/Write CRLF** | Windows 上不再出现 CRLF 双倍问题 |
| **PowerShell 5.1 误报** | `git push` 等写 stderr 的命令不再被误判为失败 |
| **Shift+Enter** | Windows Terminal Preview 1.25 不再错误提交 |
| **语音模式 WebSocket** | Windows 不再报 "HTTP 101" 错误 |

### 🔧 关键修复（通用）

| 修复 | 说明 |
|------|------|
| Prompt Cache miss | 工具 schema 变化导致的缓存失效已修复 |
| 嵌套 CLAUDE.md 重复 | 长会话中不再重复注入数十次 |
| StructuredOutput 失败 | 多 schema 工作流 ~50% 失败率已修复 |
| 内存泄漏 | 大 JSON 输入作为 LRU cache key 的问题 |
| Edit 大文件 OOM | >1GiB 文件不再崩溃 |
| CJK/Emoji 历史丢失 | 4KB 边界截断问题已修复 |
| `/stats` 统计偏低 | 现在包含子 Agent/fork 用量 |

### 📝 行为变更

| 变更 | 说明 |
|------|------|
| 思考摘要默认关闭 | 需设 `showThinkingSummaries: true` 恢复 |
| Auto Mode 拒绝通知 | 被拒绝命令显示通知，出现在 `/permissions` |
| `/env` 作用域扩大 | 现在同时影响 PowerShell 工具命令 |

---

## 🆕 v2.1.87 修复 (2026-03-29)

### 🩹 Cowork Dispatch 消息投递

修复 Cowork Dispatch 消息无法投递的问题。Cowork Dispatch 是连接终端会话与 claude.ai/iOS/Android 的桥梁，修复后远程编排和多设备工作流恢复正常。

---

## 🆕 v2.1.86 新功能速览 (2026-03-28)

### 🤖 Auto Mode 自动模式 ⭐⭐⭐⭐⭐

**重大更新**: Claude Code 新增 Auto Mode，内置独立风险分类器判断操作安全性。

```bash
# 启用自动模式
claude --enable-auto-mode

# 效果：安全操作自动执行，危险操作自动拦截
# 不再需要 --dangerously-skip-permissions
```

**三种权限模式对比**:

| 模式 | 安全操作 | 危险操作 | 适用场景 |
|------|---------|---------|---------|
| **默认模式** | 需确认 | 需确认 | 初学者、敏感项目 |
| **Auto Mode** | 自动执行 | 自动拦截 | 日常开发 |
| **bypassPermissions** | 全自动 | 全自动 | CI/CD、受信任环境 |

---

### 📡 请求头与会话追踪

新增 `X-Claude-Code-Session-Id` 请求头，代理服务器可按会话聚合请求。

```bash
# 代理服务器可以通过此 header 聚合同一会话的所有请求
X-Claude-Code-Session-Id: <unique-session-id>
```

**用途**: 中转站/代理可精确统计每会话用量，无需解析请求体。

---

### 🧹 性能与稳定性优化

| 优化项 | 说明 |
|--------|------|
| **Read 紧凑行号** | 新格式减少 token 消耗 |
| **@引用优化** | 原始字符串不再 JSON 转义，减少 token 开销 |
| **内存泄漏修复** | 修复长会话 markdown/highlight 渲染缓存导致的内存增长 |
| **Windows 配置写入** | 修复不必要的磁盘写入，防止配置损坏 |
| **启动性能** | macOS keychain 缓存从 5s 延长至 30s |
| **VSCode "Not responding"** | 修复长时间操作误报 |
| **VSCode Max 用户** | 修复 token 刷新后默认 Sonnet 而非 Opus |
| **Bedrock/Vertex 缓存** | 移除工具描述中的动态内容，提高缓存命中率 |

---

### 🔧 其他修复

- 修复 `--resume` 在 v2.1.85 前创建的会话上失败
- 修复 Write/Edit/Read 对项目根目录外文件的处理
- 修复 `--bare` 模式丢失 MCP 工具
- 修复 OAuth URL 复制只截取约20个字符
- 修复隐藏输入（OAuth 代码粘贴）在窄终端泄漏
- 修复 `/plugin` 卸载对话框逻辑反转
- 修复 `/skills` 菜单按字母排序
- 修复 Memory 文件名可点击打开
- 修复 `ultrathink` 提示残留

---

## 🆕 v2.1.85 新功能速览 (2026-03-27)

### 🪝 Hooks 条件过滤 ⭐⭐⭐⭐⭐

**重大更新**: Hooks 新增 `if` 字段，使用权限规则语法过滤触发条件。

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "scripts/git-logger.sh",
            "if": "Bash(git *)"  // 只在 Git 命令时触发
          }
        ]
      }
    ]
  }
}
```

**价值**:
- 减少不必要的进程开销
- 更精细的 Hook 控制
- 按工具类型/命令模式过滤

### 🔗 MCP 环境变量

| 变量 | 用途 |
|------|------|
| `CLAUDE_CODE_MCP_SERVER_NAME` | headersHelper 脚本中识别当前服务器名 |
| `CLAUDE_CODE_MCP_SERVER_URL` | headersHelper 脚本中识别当前服务器 URL |

**价值**: 一个 headersHelper 脚本可服务多个 MCP 服务器

### 📋 PreToolUse Hooks 增强

- **AskUserQuestion 满足**: 可通过 `updatedInput` 满足 `AskUserQuestion`
- **Headless 集成**: 自定义 UI 收集答案后传递给 Claude

```json
{
  "permissionDecision": "allow",
  "updatedInput": {
    "answer": "用户选择的答案"
  }
}
```

### ⚡ 性能优化

- **@-mention 自动补全**: 大型仓库性能提升
- **滚动性能**: 纯 TypeScript 替代 WASM yoga-layout
- **压缩 UI**: 减少大型会话压缩时的卡顿
- **PowerShell**: 改进危险命令检测

### 🛡️ 企业安全

- **插件组织策略**: `managed-settings.json` 阻止的插件不能安装/启用
- **MCP OAuth RFC 9728**: 遵循 Protected Resource Metadata discovery

### 📋 其他改进

- **时间戳标记**: `/loop` 和 `CronCreate` 触发时在 transcripts 中添加时间戳
- **深度链接扩展**: `claude-cli://open?q=…` 支持最多 5,000 字符
- **OpenTelemetry**: `tool_parameters` 需要 `OTEL_LOG_TOOL_DETAILS=1`

---

## 🆕 v2.1.84 新功能速览 (2026-03-26)

### 🪟 PowerShell 工具（Windows 预览）⭐⭐⭐⭐⭐

**重大更新**: Windows 用户专属的 PowerShell 工具，目前为选择加入预览。

```powershell
# 启用预览
# 文档: https://code.claude.com/docs/en/tools-reference#powershell-tool
```

**价值**:
- 原生 Windows PowerShell 支持
- 无需 bash 兼容层
- 更好的 Windows 集成

### 🔧 新增环境变量

| 变量 | 用途 |
|------|------|
| `ANTHROPIC_DEFAULT_{OPUS,SONNET,HAIKU}_MODEL_SUPPORTS` | 覆盖第三方提供商的 effort/thinking 检测 |
| `ANTHROPIC_DEFAULT_*_MODEL_NAME`/`_DESCRIPTION` | 自定义 /model 选择器标签 |
| `CLAUDE_STREAM_IDLE_TIMEOUT_MS` | 流式空闲看门狗阈值（默认 90s） |

### 🪝 Hooks 扩展

- **TaskCreated**: `TaskCreate` 创建任务时触发
- **WorktreeCreate HTTP**: 支持 `type: "http"`，通过 `hookSpecificOutput.worktreePath` 返回路径

### 🎯 用户体验改进

- **空闲返回提示**: 75+ 分钟后返回时建议 `/clear`，减少 token 重缓存
- **深度链接优化**: `claude-cli://` 在首选终端打开
- **paths frontmatter**: Rules 和 Skills 支持 YAML glob 列表

### 🔌 MCP 优化

- **工具描述限制**: 2KB 上限，防止 OpenAPI 服务器膨胀上下文
- **服务器去重**: 本地和 claude.ai 连接器同时配置时，本地配置优先

---

## 🚀 核心新功能详解

### 1. `/loop` - 循环任务调度 ⭐⭐⭐⭐⭐

**版本**: v2.1.71
**价值**: 将 Claude Code 转变为持续运行的后台工作器

#### 基本语法

```bash
# 每 5 分钟检查部署状态
/loop 5m check if the staging environment deployment was successful

# 每 30 分钟检查 PR
/loop 30m check all open PRs and notify me if there are new comments

# 每小时生成代码质量报告
/loop 1h scan the src/ directory for code quality and summarize potential issues

# 默认间隔 10 分钟
/loop monitor CI pipeline status
```

#### 限制说明

- 每个会话最多 50 个并发定时任务
- 任务 3 天后自动过期
- 会话关闭时所有任务终止
- 可通过环境变量禁用: `CLAUDE_CODE_DISABLE_CRON`

#### 最佳使用场景

| 场景 | 命令示例 | 价值 |
|------|---------|------|
| **PR 监控** | `/loop 15m check if PRs have new comments` | 自动化 Code Review 跟进 |
| **部署监控** | `/loop 5m check deploy status` | 实时检测部署失败 |
| **代码质量** | `/loop 1h scan new code for security issues` | 持续安全审计 |
| **日报生成** | `/loop 24h summarize yesterday's code changes` | 自动化团队日报 |

---

### 2. Voice Mode - 语音编程模式 ⭐⭐⭐⭐⭐

**版本**: v2.1.69-v2.1.71
**状态**: 滚动发布中（约 5% 用户）

#### 基本使用

```bash
# 激活语音模式
/voice
```

**工作机制**:
- **Push-to-Talk**: 按住空格键说话，松开发送
- **非持续监听**: 不是"始终监听"模式，更加精确可控
- **可自定义键位**: 通过 `keybindings.json` 配置（`voice:pushToTalk`）

#### 支持的语言（20 种）

**之前支持（10 种）**:
- English, Spanish, French, German, Italian
- Portuguese, Japanese, Korean, Chinese, Hindi

**2026 年 3 月新增（10 种）**:
- Russian, Polish, Turkish, Dutch, Ukrainian
- Greek, Czech, Danish, Swedish, Norwegian

#### 优化特性

- 针对技术术语和仓库名称优化转录
- 支持组合键绑定（如 `meta+k`）
- Windows/WSL 支持改进

---

### 3. 1M Token 上下文窗口 ⭐⭐⭐⭐⭐

**版本**: v2.1.75
**计划要求**: Max, Team, Enterprise

#### 功能说明

- **默认启用**: Opus 4.6 模型自动使用 1M token 上下文
- **巨大飞跃**: 从之前的 200K 限制提升到 1M
- **完整代码库**: 可以在上下文中处理整个代码库

#### 使用场景

```bash
# 大型项目完整分析
@src/ 请分析整个源代码目录的架构

# 多文件复杂重构
@src/ 帮我重构整个认证模块

# 长期会话保持
# 不用担心过早的上下文压缩
```

---

### 4. `/effort` - 控制分析深度 ⭐⭐⭐⭐

**版本**: v2.1.76

#### 三个级别

| 级别 | 符号 | 使用场景 |
|------|------|---------|
| **Low** | ○ | 快速回答、简单问题、常规操作 |
| **Medium** | ◐ | 平衡默认、标准开发 |
| **High** | ● | 深度分析、复杂调试、架构设计 |

#### 使用方法

```bash
# 设置 effort 级别
/effort high

# 使用 ultrathink 关键词临时激活最大努力
请深入分析这个性能问题 ultrathink
```

**注意**: "max" 级别已移除，使用 `ultrathink` 关键词代替。

---

### 5. MCP Elicitation - 结构化输入 ⭐⭐⭐⭐

**版本**: v2.1.76

#### 功能说明

MCP 服务器现在可以在任务执行中请求结构化输入:
- 显示交互式表单
- 在浏览器中打开 URL 收集数据
- 不中断工作流

#### 新增 Hooks

```json
{
  "hooks": {
    "Elicitation": "path/to/script.sh",
    "ElicitationResult": "path/to/script.sh"
  }
}
```

**用途**: 拦截和覆盖响应，实现高级交互式自动化。

---

### 6. Opus 4.6 默认模型 ⭐⭐⭐⭐⭐

**版本**: v2.1.68

#### 重要变更

- **Opus 4.6** 现在是默认模型（Max/Team 用户使用 "medium" effort）
- **Opus 4 和 4.1** 已从 API 移除，用户自动迁移到 4.6
- **"ultrathink"** 关键词重新引入，用于激活 "high" effort

#### 输出能力

- **默认**: 64K token 输出
- **最大**: 128K token 输出

---

### 7. Computer Use 远程桌面控制 ⭐⭐⭐⭐

**状态**: 研究预览
**计划要求**: Pro, Max

#### 功能说明

当 Claude Code 内置工具不足时，可以直接控制 Mac 桌面:
- 移动鼠标、点击按钮
- 浏览网页、填写表单
- 打开文件管理器和编辑器
- 操作系统级应用程序

#### 与 Remote Control 结合

通过手机 Claude App 发送指令，Claude Code 自动执行桌面操作:
- 代码和文件不离开本地
- 仅通过加密通道传输聊天消息

**限制**: 仅限 macOS，需要终端保持打开。

---

### 8. 新命令速查

| 命令 | 版本 | 功能 |
|------|------|------|
| `/loop` | v2.1.71 | 循环任务调度 |
| `/voice` | v2.1.69 | 语音模式 |
| `/effort` | v2.1.76 | 控制分析深度 |
| `/color` | v2.1.75 | 设置会话颜色 |
| `/simplify` | v2.1.63 | 简化代码 |
| `/batch` | v2.1.63 | 批量文件操作 |
| `/remote-control` | v2.1.79 | 远程控制会话 |

---

## 🔧 配置更新

### 新增设置项

#### managed-settings.d/ 目录 (v2.1.83)

```bash
# 允许独立团队部署独立策略片段
~/.claude/managed-settings.d/
├── team-a.json
├── team-b.json
└── security.json
```

文件按字母顺序合并。

#### worktree.sparsePaths (v2.1.76)

```json
{
  "worktree": {
    "sparsePaths": ["src/core", "src/utils", "tests"]
  }
}
```

大型 monorepo 中只检出必要目录。

#### autoMemoryDirectory (v2.1.74)

```json
{
  "autoMemoryDirectory": "~/.claude/custom-memory/"
}
```

#### modelOverrides (v2.1.73)

```json
{
  "modelOverrides": {
    "opus": "arn:aws:bedrock:us-east-1::foundation-model/anthropic.claude-3-opus"
  }
}
```

---

## 🪝 Hooks 更新

### 新增 Hook 事件

| 事件 | 版本 | 触发时机 |
|------|------|---------|
| `CwdChanged` | v2.1.83 | 工作目录变更 |
| `FileChanged` | v2.1.83 | 文件变更 |
| `StopFailure` | v2.1.78 | API 错误导致回合结束 |
| `Elicitation` | v2.1.76 | MCP 请求输入 |
| `ElicitationResult` | v2.1.76 | 输入响应 |
| `PostCompact` | v2.1.76 | 压缩完成 |

### HTTP Hooks (v2.1.63)

```json
{
  "hooks": {
    "PreToolUse": {
      "url": "https://api.example.com/hook",
      "method": "POST"
    }
  }
}
```

发送 POST JSON 到 URL，接收 JSON 响应。

---

## 🔒 安全更新

### 环境变量清理 (v2.1.83)

```bash
# 剥离子进程中的敏感凭证
export CLAUDE_CODE_SUBPROCESS_ENV_SCRUB=1
```

### 沙盒改进 (v2.1.78)

```json
{
  "sandbox": {
    "enabled": true,
    "failIfUnavailable": true
  }
}
```

当沙盒启用但无法启动时退出，而不是无沙盒运行。

---

## 📱 VS Code 扩展更新

### 新功能

- **会话标签页**: 自动生成 AI 标题
- **Remote Control**: 通过浏览器/手机继续会话
- **Rewind 选择器**: 双击 Esc 打开键盘导航的回退选择器
- **计划预览**: 使用计划标题而非"Claude's Plan"

### 修复

- Windows PATH 继承问题
- 登录屏幕闪烁
- 模型下拉框 1M 上下文选项

---

## ⚡ 性能改进

### 启动优化

- macOS 启动快 ~60ms（并行读取 keychain）
- `--resume` 快 45%，内存减少 100-150MB
- `--bare -p` 快 14%

### 内存优化

- 大型仓库启动减少 ~80MB
- 滚动重置从每回合一次减少到每 ~50 条消息一次

### 其他改进

- 非流式回退 token 上限: 21k → 64k
- 超时: 120s → 300s（本地）
- WebFetch 峰值内存减少

---

## 🐛 重要 Bug 修复

### 稳定性

- 修复 API 流中的内存泄漏
- 修复 macOS 退出挂起
- 修复空闲后屏幕闪烁
- 修复大文件 diff 超时

### Windows

- 修复非 ASCII 剪贴板（CJK、emoji）
- 修复 WSL2 + WSLg 语音模式
- 修复 npm 安装的语音模式

### 远程控制

- 修复会话在空闲时静默死亡
- 修复会话标题不更新
- 修复 JWT 刷新后重投递

---

## 📋 升级建议

### 立即更新

```bash
# npm 更新
npm update -g @anthropic-ai/claude-code

# 检查版本
claude --version
```

### 推荐配置

```json
{
  "effort": "medium",
  "voiceEnabled": true,
  "sandbox": {
    "enabled": true,
    "failIfUnavailable": true
  }
}
```

### 学习路径

1. **新用户**: 从 `/voice` 语音模式开始体验
2. **进阶用户**: 使用 `/loop` 设置自动化任务
3. **专家用户**: 探索 MCP Elicitation 和自定义 Hooks

---

## 🔗 相关资源

- [官方 Changelog](https://code.claude.com/docs/en/changelog)
- [Claude Code 官网](https://claude.ai/code)
- [Agent SDK 文档](https://platform.claude.com/docs/en/agent-sdk/overview)
- [Anthropic Academy 免费课程](https://code.claude.com/docs/en/academy)

---

---

## 💡 最佳实践 (2026)

### 性能优化

| 策略 | 实现 | 效果 |
|------|------|------|
| **频繁使用 /clear** | 切换任务时清空上下文 | 维持性能，减少混乱 |
| **使用 /compact** | 长对话时压缩 | 节省上下文窗口 |
| **委托给子代理** | 使用 Task 工具处理冗长操作 | 减少主会话负担 |
| **明确指令** | 避免模糊请求，提供清晰提示 | 更准确的结果 |

### 成本管理

| 策略 | 实现 | 影响 |
|------|------|------|
| **监控使用** | 使用 `/cost` 命令 | 实时追踪消费 |
| **减少 thinking tokens** | `MAX_THINKING_TOKENS=8000` | 简单任务降低成本 |
| **大多数任务用 Sonnet** | `/model sonnet` | 比 Opus 节省 40% |
| **复杂工作才用 Opus** | 仅架构决策 | 优化成本/质量权衡 |

### 订阅建议

**Claude Max ($100-200/月)** 提供无限使用，推荐重度用户。
混合方案：订阅用于交互工作，API 用于自动化。

### 安全最佳实践

#### 沙盒模式

```bash
# 启用沙盒增强安全
/sandbox
```

**沙盒优势**:
- **文件系统隔离**: 仅访问特定目录
- **网络隔离**: 只能访问批准的服务器
- **84% 减少权限提示**: 预批准安全操作
- **OS 级安全**: Linux bubblewrap, macOS Seatbelt

#### 安全建议

1. **最小权限**: 只授予 Claude 实际需要的权限
2. **使用拒绝规则**: 用显式拒绝规则限制网络命令
3. **外部扫描**: 在 CI/CD 管道中实现 SAST/DAST
4. **生产环境保持权限模式**: 不要在生产环境绕过安全

### 高效提示技巧

**专业提示**:
- 使用文件引用 (`@file.ts`) 而非粘贴代码
- 明确你想要什么: "重构以提高可读性" vs "修复这个"
- 提供上下文: "这是一个处理...的 React 组件"
- 将复杂任务分解为更小的步骤
- 使用 `/init` 引导项目上下文

### 自动运行模式

对于希望 Claude 自主工作无需确认提示的资深用户:

#### 方法 1: 跳过权限 (CLI 标志)

```bash
# 自动接受所有权限
claude --dangerously-skip-permissions
# 或简写
claude -y
```

**警告**: 此模式绕过所有安全提示。仅在可信环境中使用。

#### 方法 2: 白名单特定命令

```json
// .claude/settings.local.json
{
  "permissions": {
    "allow": [
      "Bash(git *)",
      "Bash(npm run *)",
      "Bash(npx *)",
      "Read",
      "Write",
      "Edit",
      "Glob",
      "Grep"
    ]
  }
}
```

#### 方法 3: VS Code 自动接受

1. 打开 Claude Code 面板
2. 点击设置齿轮
3. 启用 "Auto-accept edits"

#### 方法 4: Headless CI/CD

```bash
# 非交互模式
claude -p "run tests and fix any failures" --output-format stream-json

# 全自动
claude -p "refactor auth module" -y --output-format json
```

| 模式 | 标志/设置 | 使用场景 | 安全级别 |
|------|----------|---------|---------|
| **全自动** | `-y` | 可信本地开发 | 低 |
| **白名单** | `permissions.allow` | 团队环境 | 中 |
| **VS Code 自动** | Auto-accept 切换 | IDE 工作流 | 中 |
| **Headless** | `-p` 配合 `-y` | CI/CD 管道 | 低 |
| **正常** | 默认 | 生产、学习 | 高 |

---

## 🔗 相关资源

- [官方 Changelog](https://code.claude.com/docs/en/changelog)
- [Claude Code 官网](https://claude.ai/code)
- [Agent SDK 文档](https://platform.claude.com/docs/en/agent-sdk/overview)
- [Anthropic Academy 免费课程](https://code.claude.com/docs/en/academy)
- [MCP 协议文档](https://modelcontextprotocol.io)
- [GitHub 最佳实践](https://github.com/shanraisshan/claude-code-best-practice)

---

**最后更新**: 2026-03-28
**文档版本**: v1.2
**维护者**: knowknowcc 项目组
