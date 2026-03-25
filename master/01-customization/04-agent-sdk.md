# Agent SDK - Claude Code 编程扩展

> **用代码构建强大的 AI Agent**

**阅读时间**: 60分钟
**难度**: ⭐⭐⭐⭐⭐
**重要性**: ⭐⭐⭐⭐⭐
**前置要求**: [插件系统](../03-advanced-topics/02-plugins.md)

> **📌 文档版本**: v3.7 + Claude Opus 4.6
> **✅ 验证状态**: ✅ 已验证（2026-03-25）
> **🔄 最后更新**: 2026-03-25 - 同步官方 Agent SDK 重命名、query() API、Hooks 系统

> ⚠️ **重要变更**: Claude Code SDK 已重命名为 **Claude Agent SDK**（2026-02）。
> 如果你从旧版本迁移，请查看[官方迁移指南](https://platform.claude.com/docs/en/agent-sdk/migration-guide)。

---

## 目录

- [Agent SDK 概述](#agent-sdk-概述)
- [SDK 架构](#sdk-架构)
- [环境搭建](#环境搭建)
- [核心概念](#核心概念)
- [开发流程](#开发流程)
- [实战案例](#实战案例)
- [Agent Teams API](#agent-teams-api) ⭐ NEW
- [多智能体编程模式](#多智能体编程模式) ⭐ NEW
- [Subagent 配置](#subagent-配置) ⭐ NEW
- [Windows特定](#windows特定)
- [最佳实践](#最佳实践)
- [常见问题](#常见问题)
- [故障排查](#故障排查)

---

## Agent SDK 概述

### 什么是 Agent SDK？

**Agent SDK** 是 Claude Code 提供的编程接口，允许开发者：
- 用代码创建复杂的 AI Agent
- 直接调用 Claude API
- 自定义 Agent 行为和逻辑
- 集成到现有应用中
- 构建自动化工作流

**核心能力**：
```
Agent SDK
├─ 🤖 Agent 管理
│   ├─ 创建 Agent
│   ├─ 配置行为
│   └─ 生命周期管理
│
├─ 💬 对话控制
│   ├─ 发送消息
│   ├─ 接收响应
│   └─ 流式处理
│
├─ 🛠️ 工具调用
│   ├─ 文件操作
│   ├─ 命令执行
│   └─ 自定义工具
│
└─ 🔌 集成能力
    ├─ Webhook 集成
    ├─ API 集成
    └─ 事件处理
```

### 为什么使用 Agent SDK？

#### 1. 可编程控制

**场景**：需要精确控制 Agent 行为

```
命令行方式：
❌ 受限于预定义命令
❌ 无法处理复杂逻辑
❌ 难以集成到应用

SDK 方式：
✅ 完全编程控制
✅ 复杂逻辑实现
✅ 无缝应用集成
```

#### 2. 自动化工作流

**场景**：构建自动化流程

```typescript
// 代码审查自动化
const agent = new Agent({
  name: 'code-reviewer'
});

for (const pr of pullRequests) {
  const review = await agent.review(pr);
  await postComment(pr, review);

  if (review.score < 80) {
    await requestChanges(pr, review.issues);
  }
}
```

#### 3. 深度集成

**场景**：集成到现有系统

```typescript
// 集成到 IDE 插件
class VSCodeExtension {
  private agent: Agent;

  async activate() {
    this.agent = new Agent({
      context: this.getContext()
    });

    // 监听编辑器事件
    this.onDocumentSave(async (file) => {
      const suggestions = await this.agent.suggest(file);
      this.showSuggestions(suggestions);
    });
  }
}
```

### Agent SDK vs 命令行 vs 插件

| 维度 | 命令行 | 插件 | Agent SDK |
|------|--------|------|-----------|
| **控制粒度** | 低 | 中 | **高** |
| **灵活性** | 低 | 中 | **极高** |
| **集成难度** | N/A | 中等 | **高** |
| **学习曲线** | 低 | 中等 | **陡峭** |
| **适用场景** | 日常使用 | 功能扩展 | **系统构建** |
| **编程要求** | 无 | 中等 | **高** |

### 核心价值

| 价值维度 | 说明 | 效果 |
|---------|------|------|
| **可编程性** | 完整的编程控制 | **无限** 可能性 |
| **集成性** | 深度系统集成 | **原生** 体验 |
| **自动化** | 复杂工作流自动化 | **无人值守** 运行 |
| **定制化** | 完全自定义行为 | **精确** 控制 |
| **扩展性** | 构建上层应用 | **独立** 产品 |

---

## SDK 架构

### 架构层次

```
┌─────────────────────────────────────┐
│     应用层（Your Application）      │
├─────────────────────────────────────┤
│         Agent SDK（API 层）          │
│  ┌───────────────────────────────┐  │
│  │   Agent 管理                  │  │
│  │   对话控制                    │  │
│  │   工具调用                    │  │
│  │   事件处理                    │  │
│  └───────────────────────────────┘  │
├─────────────────────────────────────┤
│      Claude Code 核心（Core）       │
│  ┌───────────────────────────────┐  │
│  │   LLM 调用                    │  │
│  │   上下文管理                  │  │
│  │   工具执行                    │  │
│  └───────────────────────────────┘  │
├─────────────────────────────────────┤
│      Claude API（服务层）          │
└─────────────────────────────────────┘
```

### 核心模块

#### 1. Agent 模块

```typescript
import { Agent } from '@anthropic-ai/claude-sdk';

// 创建 Agent
const agent = new Agent({
  name: 'my-agent',
  model: 'claude-sonnet-4-5-20250929',
  instructions: '你是一个代码审查专家'
});

// 配置 Agent
agent.configure({
  temperature: 0.7,
  maxTokens: 4096,
  tools: ['file', 'command', 'web']
});
```

#### 2. Conversation 模块

```typescript
// 创建对话
const conversation = agent.createConversation({
  context: {
    project: 'my-app',
    language: 'typescript'
  }
});

// 添加消息
conversation.addMessage({
  role: 'user',
  content: '审查这段代码'
});

// 获取响应
const response = await conversation.getResponse();
```

#### 3. Tools 模块

```typescript
// 内置工具
const fileTool = new FileTool();
const commandTool = new CommandTool();
const webTool = new WebTool();

// 自定义工具
class CustomTool extends Tool {
  name = 'my-tool';
  description = '我的自定义工具';

  async execute(params: any): Promise<any> {
    // 工具逻辑
    return { success: true };
  }
}

// 注册工具
agent.registerTool(new CustomTool());
```

#### 4. Events 模块

```typescript
// 订阅事件
agent.on('message', async (message) => {
  console.log('收到消息:', message);
});

agent.on('error', async (error) => {
  console.error('发生错误:', error);
});

agent.on('tool.use', async (tool) => {
  console.log('使用工具:', tool.name);
});
```

---

## 环境搭建

### 系统要求

- **TypeScript**: Node.js 18+ 或 Bun Runtime
- **Python**: Python 3.10+（推荐使用 uv 包管理器）
- Claude API 密钥

### 安装 SDK

> ⚠️ **包名更新**: Claude Code SDK 已重命名为 **Claude Agent SDK**。

#### TypeScript

```bash
# npm
npm install @anthropic-ai/claude-agent-sdk

# yarn
yarn add @anthropic-ai/claude-agent-sdk

# pnpm
pnpm add @anthropic-ai/claude-agent-sdk

# bun（更快）
bun add @anthropic-ai/claude-agent-sdk
```

#### Python

```bash
# 使用 pip（需要先创建虚拟环境）
python3 -m venv .venv && source .venv/bin/activate
pip install claude-agent-sdk

# 使用 uv（推荐，自动管理虚拟环境）
uv init && uv add claude-agent-sdk
```

### 配置认证

#### 方式1：环境变量（推荐）

```bash
# ~/.bashrc 或 ~/.zshrc
export ANTHROPIC_API_KEY="your-api-key-here"

# Windows PowerShell
$env:ANTHROPIC_API_KEY="your-api-key-here"

# Windows 系统环境变量
# 控制面板 → 系统 → 高级系统设置 → 环境变量
```

#### 方式2：配置文件

```json
// ~/.claude/config.json
{
  "apiKey": "your-api-key-here",
  "baseUrl": "https://api.anthropic.com",
  "timeout": 60000
}
```

#### 方式3：代码配置

```typescript
import { ClaudeClient } from '@anthropic-ai/claude-sdk';

const client = new ClaudeClient({
  apiKey: 'your-api-key-here',
  baseUrl: 'https://api.anthropic.com',
  timeout: 60000
});
```

### 验证安装

```typescript
import { Agent } from '@anthropic-ai/claude-sdk';

async function testConnection() {
  const agent = new Agent({
    name: 'test-agent'
  });

  const response = await agent.sendMessage('Hello, Claude!');
  console.log('连接成功:', response.content);
}

testConnection().catch(console.error);
```

---

## 核心概念

### 1. Agent（智能体）

**Agent** 是具有特定角色和能力的 AI 实体。

```typescript
const agent = new Agent({
  // 基本配置
  name: 'code-reviewer',
  model: 'claude-sonnet-4-5-20250929',

  // 行为配置
  instructions: `
    你是一个专业的代码审查专家。
    你的任务是：
    1. 检查代码质量
    2. 发现潜在问题
    3. 提供改进建议
  `,

  // 能力配置
  tools: ['file', 'command', 'web'],

  // 参数配置
  temperature: 0.7,
  maxTokens: 4096
});
```

**Agent 生命周期**：
```
创建（Created）
    ↓
初始化（Initialized）
    ↓
激活（Active）
    ↓
暂停（Paused）
    ↓
停止（Stopped）
```

### 2. Conversation（对话）

**Conversation** 管理 Agent 与用户的交互。

```typescript
// 创建对话
const conversation = agent.createConversation({
  id: 'conv-123',
  context: {
    project: 'my-app',
    language: 'typescript',
    framework: 'react'
  }
});

// 添加用户消息
conversation.addUserMessage('审查这个组件：');

// 添加文件引用
conversation.addFileReference('src/components/Button.tsx');

// 获取 AI 响应
const response = await conversation.getResponse();
```

**对话状态**：
```typescript
interface ConversationState {
  id: string;
  messages: Message[];
  context: Record<string, any>;
  metadata: {
    createdAt: Date;
    updatedAt: Date;
    messageCount: number;
    tokenCount: number;
  };
}
```

### 3. Tool（工具）

**Tool** 是 Agent 可以调用的能力。

```typescript
// 工具接口
interface Tool {
  name: string;
  description: string;
  parameters?: ToolParameter[];
  execute(params: any): Promise<any>;
}

// 示例：文件读取工具
class FileReadTool implements Tool {
  name = 'file-read';
  description = '读取文件内容';

  parameters = [
    {
      name: 'path',
      description: '文件路径',
      type: 'string',
      required: true
    }
  ];

  async execute(params: { path: string }): Promise<string> {
    const content = await fs.readFile(params.path, 'utf-8');
    return content;
  }
}
```

### 4. Context（上下文）

**Context** 为 Agent 提供背景信息。

```typescript
const context = {
  // 项目信息
  project: {
    name: 'my-app',
    type: 'web-application',
    stack: ['react', 'typescript', 'node']
  },

  // 用户信息
  user: {
    name: 'developer',
    role: 'senior-engineer',
    preferences: {
      codeStyle: 'functional',
      testing: 'jest'
    }
  },

  // 会话信息
  session: {
    id: 'session-123',
    startTime: new Date(),
    previousActions: []
  }
};
```

### 5. Event（事件）

**Event** 系统监听和响应 Agent 行为。

```typescript
// 订阅事件
agent.on('message.before', async (message) => {
  console.log('准备发送消息:', message);
});

agent.on('message.after', async (response) => {
  console.log('收到响应:', response);
});

agent.on('tool.use', async (toolCall) => {
  console.log('使用工具:', toolCall.tool, toolCall.params);
});

agent.on('error', async (error) => {
  console.error('发生错误:', error);
});
```

---

## query() API - 核心流式接口 ⭐ NEW

### 什么是 query() API？

`query()` 是 Agent SDK 的核心流式接口，让你以最简洁的方式创建 Agent 并获取结果。

**与 Client SDK 的关键区别**：

```python
# Client SDK: 你需要自己实现工具循环
response = client.messages.create(...)
while response.stop_reason == "tool_use":
    result = your_tool_executor(response.tool_use)
    response = client.messages.create(tool_result=result, **params)

# Agent SDK: Claude 自动处理工具调用
async for message in query(prompt="Fix the bug in auth.py"):
    print(message)  # Claude 自动读取文件、分析问题、修复代码
```

### Python 示例

```python
import asyncio
from claude_agent_sdk import query, ClaudeAgentOptions

async def main():
    async for message in query(
        prompt="Find and fix the bug in auth.py",
        options=ClaudeAgentOptions(
            allowed_tools=["Read", "Edit", "Bash"]
        ),
    ):
        if hasattr(message, "result"):
            print(message.result)

asyncio.run(main())
```

### TypeScript 示例

```typescript
import { query } from "@anthropic-ai/claude-agent-sdk";

for await (const message of query({
  prompt: "Find and fix the bug in auth.py",
  options: {
    allowedTools: ["Read", "Edit", "Bash"]
  }
})) {
  if ("result" in message) console.log(message.result);
}
```

### ClaudeAgentOptions 配置

| 参数 | 类型 | 说明 |
|------|------|------|
| `allowed_tools` | string[] | 允许使用的工具列表 |
| `permission_mode` | string | 权限模式：`default`、`acceptEdits`、`bypassPermissions` |
| `resume` | string | 恢复会话的 session_id |
| `setting_sources` | string[] | 配置来源：`["project"]` 启用 Skills 等 |
| `mcp_servers` | object | MCP 服务器配置 |
| `hooks` | object | 生命周期钩子配置 |
| `agents` | object | Subagent 定义 |

### 内置工具列表

| 工具 | 功能 |
|------|------|
| **Read** | 读取工作目录中的文件 |
| **Write** | 创建新文件 |
| **Edit** | 精确编辑现有文件 |
| **Bash** | 运行终端命令、脚本、git 操作 |
| **Glob** | 按模式查找文件（`**/*.ts`） |
| **Grep** | 使用正则搜索文件内容 |
| **WebSearch** | 搜索网络获取最新信息 |
| **WebFetch** | 获取并解析网页内容 |
| **AskUserQuestion** | 向用户提问（带选项） |

### 只读 Agent 示例

```python
# 只读 Agent：搜索 TODO 注释
async for message in query(
    prompt="Find all TODO comments and create a summary",
    options=ClaudeAgentOptions(
        allowed_tools=["Read", "Glob", "Grep"]
    ),
):
    if hasattr(message, "result"):
        print(message.result)
```

---

## Hooks 系统 - 自定义 Agent 行为 ⭐ NEW

### 可用的 Hooks

| Hook | 触发时机 |
|------|---------|
| `PreToolUse` | 工具执行前 |
| `PostToolUse` | 工具执行后 |
| `Stop` | Agent 结束时 |
| `SessionStart` | 会话开始时 |
| `SessionEnd` | 会话结束时 |
| `UserPromptSubmit` | 用户提交输入时 |

### Python Hooks 示例

```python
import asyncio
from datetime import datetime
from claude_agent_sdk import query, ClaudeAgentOptions, HookMatcher

async def log_file_change(input_data, tool_use_id, context):
    """记录所有文件变更到审计日志"""
    file_path = input_data.get("tool_input", {}).get("file_path", "unknown")
    with open("./audit.log", "a") as f:
        f.write(f"{datetime.now()}: modified {file_path}\n")
    return {}

async def main():
    async for message in query(
        prompt="Refactor utils.py to improve readability",
        options=ClaudeAgentOptions(
            permission_mode="acceptEdits",
            hooks={
                "PostToolUse": [
                    HookMatcher(
                        matcher="Edit|Write",
                        hooks=[log_file_change]
                    )
                ]
            },
        ),
    ):
        if hasattr(message, "result"):
            print(message.result)

asyncio.run(main())
```

### TypeScript Hooks 示例

```typescript
import { query, HookCallback } from "@anthropic-ai/claude-agent-sdk";
import { appendFile } from "fs/promises";

const logFileChange: HookCallback = async (input) => {
  const filePath = (input as any).tool_input?.file_path ?? "unknown";
  await appendFile(
    "./audit.log",
    `${new Date().toISOString()}: modified ${filePath}\n`
  );
  return {};
};

for await (const message of query({
  prompt: "Refactor utils.py to improve readability",
  options: {
    permissionMode: "acceptEdits",
    hooks: {
      PostToolUse: [
        { matcher: "Edit|Write", hooks: [logFileChange] }
      ]
    }
  }
})) {
  if ("result" in message) console.log(message.result);
}
```

---

## Session Management - 会话管理 ⭐ NEW

### 跨查询保持上下文

使用 `session_id` 在多个查询之间保持上下文：

```python
import asyncio
from claude_agent_sdk import query, ClaudeAgentOptions

async def main():
    session_id = None

    # 第一次查询：获取 session_id
    async for message in query(
        prompt="Read the authentication module",
        options=ClaudeAgentOptions(allowed_tools=["Read", "Glob"]),
    ):
        if hasattr(message, "subtype") and message.subtype == "init":
            session_id = message.session_id

    # 恢复会话：Claude 记得上次读取的内容
    async for message in query(
        prompt="Now find all places that call it",
        options=ClaudeAgentOptions(resume=session_id),
    ):
        if hasattr(message, "result"):
            print(message.result)

asyncio.run(main())
```

**效果**：Claude 理解 "it" 指的是上一次查询中读取的认证模块。

---

## Permission Modes - 权限控制 ⭐ NEW

### 三种权限模式

| 模式 | 说明 |
|------|------|
| `default` | 每个操作都需要单独批准 |
| `acceptEdits` | 自动批准文件编辑 |
| `bypassPermissions` | 自动批准所有操作（谨慎使用） |

### 使用示例

```python
# 只读 Agent
options = ClaudeAgentOptions(
    allowed_tools=["Read", "Glob", "Grep"]
)

# 自动批准编辑
options = ClaudeAgentOptions(
    permission_mode="acceptEdits",
    allowed_tools=["Read", "Edit", "Bash"]
)

# 完全自动（生产环境慎用）
options = ClaudeAgentOptions(
    permission_mode="bypassPermissions",
    allowed_tools=["Read", "Write", "Edit", "Bash"]
)
```

---

## MCP Server 集成 ⭐ NEW

### 连接外部系统

通过 MCP 协议连接数据库、浏览器、API 等：

```python
import asyncio
from claude_agent_sdk import query, ClaudeAgentOptions

async def main():
    async for message in query(
        prompt="Open example.com and describe what you see",
        options=ClaudeAgentOptions(
            mcp_servers={
                "playwright": {
                    "command": "npx",
                    "args": ["@playwright/mcp@latest"]
                }
            }
        ),
    ):
        if hasattr(message, "result"):
            print(message.result)

asyncio.run(main())
```

### 常用 MCP 服务器

| 服务器 | 用途 |
|--------|------|
| `@playwright/mcp` | 浏览器自动化 |
| `@modelcontextprotocol/server-postgres` | PostgreSQL 数据库 |
| `@modelcontextprotocol/server-github` | GitHub API |
| `@modelcontextprotocol/server-slack` | Slack 集成 |

---

## Claude Code 功能集成

启用 `setting_sources=["project"]` 来使用 Claude Code 的文件系统配置：

| 功能 | 位置 |
|------|------|
| **Skills** | `.claude/skills/SKILL.md` |
| **Slash Commands** | `.claude/commands/*.md` |
| **Memory** | `CLAUDE.md` 或 `.claude/CLAUDE.md` |
| **Plugins** | 通过 `plugins` 选项配置 |

```python
options = ClaudeAgentOptions(
    setting_sources=["project"],
    allowed_tools=["Read", "Edit", "Bash"]
)
```

---

## 开发流程

### 第一步：创建 Agent

```typescript
import { Agent, Tools } from '@anthropic-ai/claude-sdk';

// 创建基础 Agent
const agent = new Agent({
  name: 'my-first-agent',
  model: 'claude-sonnet-4-5-20250929',
  instructions: '你是一个有帮助的助手',
  tools: [
    new Tools.FileTool(),
    new Tools.CommandTool(),
    new Tools.WebTool()
  ]
});

console.log('Agent 创建成功:', agent.name);
```

### 第二步：配置行为

```typescript
// 配置 Agent 行为
agent.configure({
  // 参数配置
  temperature: 0.7,        // 创造性（0-1）
  maxTokens: 4096,         // 最大输出
  topP: 0.9,              // 核采样
  topK: 40,               // Top-K 采样

  // 行为配置
  stopSequences: ['\n\n', 'DONE'],  // 停止序列
  stream: true,                       // 流式输出

  // 工具配置
  tools: {
    file: {
      allowedPaths: ['/safe/path'],
      deniedPaths: ['/etc', '/sys']
    },
    command: {
      allowedCommands: ['npm', 'git'],
      deniedCommands: ['rm', 'sudo']
    }
  }
});
```

### 第三步：创建对话

```typescript
// 创建对话会话
const conversation = agent.createConversation({
  id: 'conv-001',
  context: {
    project: 'demo-project',
    language: 'typescript'
  }
});

// 发送消息
const response = await conversation.sendMessage({
  role: 'user',
  content: '帮我创建一个 TypeScript 接口'
});

console.log('AI 响应:', response.content);
```

### 第四步：处理响应

```typescript
// 非流式响应
const response = await conversation.sendMessage(message);
console.log(response.content);

// 流式响应
const stream = await conversation.sendMessageStream(message);
for await (const chunk of stream) {
  process.stdout.write(chunk);
}

// 带回调的响应
await conversation.sendMessage(message, {
  onChunk: (chunk) => {
    console.log('收到片段:', chunk);
  },
  onComplete: (response) => {
    console.log('完成:', response.content);
  },
  onError: (error) => {
    console.error('错误:', error);
  }
});
```

### 第五步：使用工具

```typescript
// 内置工具
await agent.useTool('file-read', {
  path: 'src/index.ts'
});

// 自定义工具
class DatabaseTool extends Tools.BaseTool {
  name = 'database-query';
  description = '查询数据库';

  async execute(params: { query: string }) {
    const result = await db.query(params.query);
    return result;
  }
}

agent.registerTool(new DatabaseTool());

// 调用自定义工具
const result = await agent.useTool('database-query', {
  query: 'SELECT * FROM users'
});
```

---

## 实战案例

### 案例1：自动代码审查 Agent

**场景**：自动审查 Pull Request

```typescript
import { Agent, Tools } from '@anthropic-ai/claude-sdk';
import { GitHub } from '@octokit/rest';

class CodeReviewAgent {
  private agent: Agent;
  private github: GitHub;

  constructor() {
    // 创建 Agent
    this.agent = new Agent({
      name: 'code-reviewer',
      model: 'claude-sonnet-4-5-20250929',
      instructions: `
        你是一个专业的代码审查专家。
        审查重点：
        1. 代码质量和可读性
        2. 潜在的 bug 和边界情况
        3. 性能问题
        4. 安全漏洞
        5. 最佳实践违背

        输出格式：
        - 总体评分（1-10）
        - 问题列表（按严重程度排序）
        - 改进建议
      `,
      tools: [
        new Tools.FileTool(),
        new Tools.CommandTool()
      ]
    });

    // 初始化 GitHub
    this.github = new GitHub({
      auth: process.env.GITHUB_TOKEN
    });
  }

  async reviewPullRequest(owner: string, repo: string, prNumber: number) {
    // 获取 PR 信息
    const { data: pr } = await this.github.pulls.get({
      owner,
      repo,
      pull_number: prNumber
    });

    // 获取文件变更
    const { data: files } = await this.github.pulls.listFiles({
      owner,
      repo,
      pull_number: prNumber
    });

    // 创建审查会话
    const conversation = this.agent.createConversation({
      context: {
        project: `${owner}/${repo}`,
        pr: {
          number: prNumber,
          title: pr.title,
          author: pr.user.login
        }
      }
    });

    // 准备审查内容
    let reviewContent = `审查 PR #${prNumber}: ${pr.title}\n\n`;

    for (const file of files) {
      if (file.patch) {
        reviewContent += `\n## ${file.filename}\n\n${file.patch}\n`;
      }
    }

    // 发送审查请求
    const response = await conversation.sendMessage({
      role: 'user',
      content: reviewContent
    });

    // 解析审查结果
    const review = this.parseReview(response.content);

    // 发布审查评论
    await this.github.pulls.createReview({
      owner,
      repo,
      pull_number: prNumber,
      body: review.comment,
      event: review.score >= 7 ? 'APPROVE' : 'REQUEST_CHANGES'
    });

    return review;
  }

  private parseReview(content: string): ReviewResult {
    // 解析 AI 输出
    const lines = content.split('\n');
    const score = parseInt(lines[0].match(/\d+/)?.[0] || '5');
    const issues: Issue[] = [];

    // 解析问题列表
    // ... 解析逻辑

    return {
      score,
      issues,
      comment: content
    };
  }
}

// 使用
const reviewer = new CodeReviewAgent();
const review = await reviewer.reviewPullRequest('owner', 'repo', 123);
console.log('审查完成:', review);
```

---

### 案例2：文档生成 Agent

**场景**：自动生成 API 文档

```typescript
import { Agent, Tools } from '@anthropic-ai/claude-sdk';

class DocumentationGenerator {
  private agent: Agent;

  constructor() {
    this.agent = new Agent({
      name: 'doc-generator',
      model: 'claude-sonnet-4-5-20250929',
      instructions: `
        你是一个技术文档专家。
        任务：为代码生成清晰的 API 文档。

        文档格式：
        # 函数名

        ## 描述
        简要描述函数功能

        ## 参数
        - \`param1\`: 类型 - 描述
        - \`param2\`: 类型 - 描述

        ## 返回值
        类型 - 描述

        ## 示例
        \`\`\`typescript
        // 使用示例
        \`\`\`

        ## 注意事项
        重要提示
      `,
      tools: [new Tools.FileTool()]
    });
  }

  async generateForFile(filePath: string): Promise<string> {
    // 读取文件
    const sourceCode = await this.agent.useTool('file-read', {
      path: filePath
    });

    // 分析代码结构
    const functions = this.extractFunctions(sourceCode);

    // 为每个函数生成文档
    const docs: string[] = [];

    for (const func of functions) {
      const conversation = this.agent.createConversation();

      const response = await conversation.sendMessage({
        role: 'user',
        content: `
          为以下函数生成文档：

          \`\`\`typescript
          ${func.code}
          \`\`\`
        `
      });

      docs.push(response.content);
    }

    return docs.join('\n\n---\n\n');
  }

  async generateForProject(projectPath: string): Promise<void> {
    // 查找所有 TypeScript 文件
    const files = await this.agent.useTool('file-find', {
      path: projectPath,
      pattern: '**/*.ts'
    });

    // 为每个文件生成文档
    for (const file of files) {
      const docs = await this.generateForFile(file);

      // 保存文档
      const docPath = file.replace('.ts', '.md');
      await this.agent.useTool('file-write', {
        path: `docs/${docPath}`,
        content: docs
      });
    }
  }

  private extractFunctions(code: string): FunctionInfo[] {
    // 使用 AST 解析提取函数
    // 或使用正则表达式
    const functionRegex = /(?:function|const)\s+(\w+)\s*=\s*(?:async\s*)?\([^)]*\)\s*=>/g;
    const functions: FunctionInfo[] = [];
    let match;

    while ((match = functionRegex.exec(code)) !== null) {
      functions.push({
        name: match[1],
        code: this.extractFunctionBlock(code, match.index)
      });
    }

    return functions;
  }

  private extractFunctionBlock(code: string, startIndex: number): string {
    // 提取完整函数代码
    // ...
    return '';
  }
}

// 使用
const generator = new DocumentationGenerator();
await generator.generateForProject('./src');
console.log('文档生成完成');
```

---

### 案例3：测试生成 Agent

**场景**：自动生成单元测试

```typescript
import { Agent, Tools } from '@anthropic-ai/claude-sdk';

class TestGenerator {
  private agent: Agent;

  constructor() {
    this.agent = new Agent({
      name: 'test-generator',
      model: 'claude-sonnet-4-5-20250929',
      instructions: `
        你是一个测试工程师。
        任务：为代码生成完整的单元测试。

        测试框架：Jest + Testing Library

        测试覆盖：
        1. 正常情况
        2. 边界情况
        3. 错误处理
        4. 边缘条件

        代码风格：
        - 清晰的测试描述
        - Arrange-Act-Assert 模式
        - 合理的 mock 和 spy
      `,
      tools: [new Tools.FileTool()]
    });
  }

  async generateTests(sourceFile: string): Promise<string> {
    // 读取源代码
    const sourceCode = await this.agent.useTool('file-read', {
      path: sourceFile
    });

    // 分析需要测试的函数
    const functions = this.analyzeFunctions(sourceCode);

    // 生成测试代码
    const conversation = this.agent.createConversation({
      context: {
        file: sourceFile,
        framework: 'jest'
      }
    });

    const response = await conversation.sendMessage({
      role: 'user',
      content: `
        为以下代码生成完整的单元测试：

        \`\`\`typescript
        ${sourceCode}
        \`\`\`

        需要测试的函数：
        ${functions.map(f => `- ${f.name}`).join('\n')}
      `
    });

    return response.content;
  }

  async generateAndSave(sourceFile: string): Promise<void> {
    // 生成测试
    const tests = await this.generateTests(sourceFile);

    // 确定测试文件路径
    const testFile = sourceFile
      .replace('/src/', '/tests/')
      .replace('.ts', '.test.ts');

    // 确保目录存在
    await this.agent.useTool('file-mkdir', {
      path: testFile.split('/').slice(0, -1).join('/')
    });

    // 保存测试文件
    await this.agent.useTool('file-write', {
      path: testFile,
      content: tests
    });

    console.log(`测试已生成: ${testFile}`);
  }

  private analyzeFunctions(code: string): FunctionInfo[] {
    // 分析导出的函数
    const exports = code.match(/export\s+(?:const|function|class)\s+(\w+)/g) || [];
    return exports.map(exp => ({
      name: exp.split(' ').pop() || '',
      exported: true
    }));
  }
}

// 使用
const generator = new TestGenerator();
await generator.generateAndSave('./src/utils/helpers.ts');
```

---

### 案例4：自动化部署 Agent

**场景**：智能部署决策和执行

```typescript
import { Agent, Tools } from '@anthropic-ai/claude-sdk';

class DeploymentAgent {
  private agent: Agent;

  constructor() {
    this.agent = new Agent({
      name: 'deploy-manager',
      model: 'claude-sonnet-4-5-20250929',
      instructions: `
        你是一个 DevOps 专家。
        任务：管理应用的部署流程。

        部署前检查：
        1. 所有测试通过
        2. 代码覆盖率达标
        3. 无安全漏洞
        4. 性能基准通过

        部署策略：
        - 蓝绿部署
        - 金丝雀发布
        - 回滚机制
      `,
      tools: [
        new Tools.CommandTool(),
        new Tools.FileTool(),
        new Tools.WebTool()
      ]
    });
  }

  async deploy(environment: 'staging' | 'production'): Promise<DeploymentResult> {
    const conversation = this.agent.createConversation({
      context: {
        environment,
        timestamp: new Date().toISOString()
      }
    });

    // 1. 运行预检查
    console.log('运行预检查...');
    const preCheck = await this.runPreChecks(conversation);
    if (!preCheck.passed) {
      throw new Error('预检查失败: ' + preCheck.reason);
    }

    // 2. 构建应用
    console.log('构建应用...');
    const buildResult = await this.build(conversation);
    if (!buildResult.success) {
      throw new Error('构建失败');
    }

    // 3. 运行测试
    console.log('运行测试...');
    const testResult = await this.runTests(conversation);
    if (!testResult.success) {
      throw new Error('测试失败');
    }

    // 4. 决策部署策略
    console.log('决策部署策略...');
    const strategy = await this.decideStrategy(conversation, environment);

    // 5. 执行部署
    console.log(`执行部署: ${strategy}...`);
    const deployResult = await this.executeDeploy(
      conversation,
      environment,
      strategy
    );

    // 6. 验证部署
    console.log('验证部署...');
    const verification = await this.verify(conversation, environment);

    if (!verification.success) {
      // 回滚
      console.log('部署验证失败，回滚...');
      await this.rollback(conversation, environment);
      throw new Error('部署验证失败，已回滚');
    }

    return {
      success: true,
      environment,
      strategy,
      timestamp: new Date()
    };
  }

  private async runPreChecks(conversation: Conversation): Promise<CheckResult> {
    const response = await conversation.sendMessage({
      role: 'user',
      content: `
        运行部署前检查，检查以下项目：
        1. Git 状态（无未提交更改）
        2. 测试状态
        3. 代码覆盖率
        4. 安全扫描
      `
    });

    // 解析检查结果
    return this.parseCheckResult(response.content);
  }

  private async build(conversation: Conversation): Promise<any> {
    return await this.agent.useTool('command-exec', {
      command: 'npm run build'
    });
  }

  private async runTests(conversation: Conversation): Promise<any> {
    return await this.agent.useTool('command-exec', {
      command: 'npm test -- --coverage'
    });
  }

  private async decideStrategy(
    conversation: Conversation,
    environment: string
  ): Promise<string> {
    const response = await conversation.sendMessage({
      role: 'user',
      content: `
        环境: ${environment}

        请决定部署策略：
        - 蓝绿部署（Blue-Green）
        - 金丝雀发布（Canary）
        - 滚动更新（Rolling）

        考虑因素：
        - 环境重要性
        - 变更风险
        - 回滚难易度
      `
    });

    return response.content.trim();
  }

  private async executeDeploy(
    conversation: Conversation,
    environment: string,
    strategy: string
  ): Promise<any> {
    return await this.agent.useTool('command-exec', {
      command: `npm run deploy:${environment} --strategy=${strategy}`
    });
  }

  private async verify(
    conversation: Conversation,
    environment: string
  ): Promise<any> {
    // 健康检查
    const response = await this.agent.useTool('web-request', {
      method: 'GET',
      url: `https://${environment}.example.com/health`
    });

    return {
      success: response.status === 200
    };
  }

  private async rollback(conversation: Conversation, environment: string): Promise<void> {
    await this.agent.useTool('command-exec', {
      command: `npm run rollback:${environment}`
    });
  }

  private parseCheckResult(content: string): CheckResult {
    // 解析检查结果
    // ...
    return { passed: true };
  }
}

// 使用
const deployer = new DeploymentAgent();
const result = await deployer.deploy('staging');
console.log('部署成功:', result);
```

---

## Agent Teams API ⭐ NEW

### 官方说明

**Agent Teams** 是 Claude Opus 4.6 的重大新功能（2026-02-05 发布）：

```markdown
"You can now spin up multiple agents that work in parallel as a team
and coordinate autonomously—best for tasks that split into independent,
read-heavy work like codebase reviews."
```

### Agent Teams SDK 架构

```
AgentTeam
├─ 🤖 Agent Pool（智能体池）
│   ├─ 创建多个 Agent
│   ├─ 配置每个 Agent 的行为
│   └─ 管理 Agent 生命周期
│
├─ 📋 Task Scheduler（任务调度器）
│   ├─ 任务分解
│   ├─ 负载均衡
│   └─ 并行执行
│
├─ 🔄 Coordinator（协调器）
│   ├─ 智能体间通信
│   ├─ 结果汇总
│   └─ 冲突解决
│
└─ 🎮 Controller（控制器）
    ├─ 实时监控
    ├─ 人工介入
    └─ 动态调整
```

### 核心 API

#### 1. 创建 Agent Team

```typescript
import { AgentTeam, AgentConfig } from '@anthropic-ai/claude-sdk';

// 创建 Agent Team
const team = new AgentTeam({
  name: 'code-review-team',
  maxAgents: 4,           // 最大智能体数量
  coordinatorModel: 'claude-opus-4-6-20260205',

  // 全局配置
  globalConfig: {
    temperature: 0.2,
    maxTokens: 4000
  }
});

// 添加智能体
const agent1 = await team.addAgent({
  name: 'frontend-reviewer',
  description: '审查前端代码（React、Vue、样式）',
  specialization: 'frontend',
  allowedTools: ['Read', 'Grep', 'Glob'],
  model: 'claude-sonnet-4-5-20250929'
});

const agent2 = await team.addAgent({
  name: 'backend-reviewer',
  description: '审查后端代码（API、数据库、业务逻辑）',
  specialization: 'backend',
  allowedTools: ['Read', 'Grep', 'Glob', 'Bash'],
  model: 'claude-sonnet-4-5-20250929'
});

const agent3 = await team.addAgent({
  name: 'test-reviewer',
  description: '审查测试覆盖率和测试质量',
  specialization: 'testing',
  allowedTools: ['Read', 'Grep', 'Glob'],
  model: 'claude-sonnet-4-5-20250929'
});

const agent4 = await team.addAgent({
  name: 'doc-reviewer',
  description: '审查文档完整性',
  specialization: 'documentation',
  allowedTools: ['Read', 'Grep', 'Glob'],
  model: 'claude-sonnet-4-5-20250929'
});
```

#### 2. 任务分配与执行

```typescript
// 定义任务
interface ReviewTask {
  type: 'frontend' | 'backend' | 'testing' | 'documentation';
  files: string[];
  criteria: string[];
}

// 创建审查任务
const tasks: ReviewTask[] = [
  {
    type: 'frontend',
    files: ['src/components/**/*.tsx', 'src/styles/**/*.css'],
    criteria: ['代码质量', '性能优化', '可访问性']
  },
  {
    type: 'backend',
    files: ['src/api/**/*.ts', 'src/services/**/*.ts'],
    criteria: ['API设计', '安全性', '错误处理']
  },
  {
    type: 'testing',
    files: ['src/**/*.test.ts', 'src/**/*.spec.ts'],
    criteria: ['覆盖率', '测试质量', '边界情况']
  },
  {
    type: 'documentation',
    files: ['README.md', 'docs/**/*.md', 'src/**/*.md'],
    criteria: ['完整性', '准确性', '可读性']
  }
];

// 并行执行任务
const results = await team.executeParallel(tasks, {
  strategy: 'specialization-matching',  // 根据专长匹配
  timeout: 30 * 60 * 1000,              // 30分钟超时
  maxConcurrency: 4,                    // 最大并发数

  // 进度回调
  onProgress: (progress) => {
    console.log(`进度: ${progress.completed}/${progress.total}`);
    console.log(`Agent 1: ${progress.agents[0].status}`);
    console.log(`Agent 2: ${progress.agents[1].status}`);
  },

  // 错误处理
  onError: (error, task) => {
    console.error(`任务失败: ${task.type}`, error);
    return 'continue';  // 继续其他任务
  }
});
```

#### 3. 监控和控制 API

```typescript
// 实时监控
const monitor = team.createMonitor();

monitor.on('agent-status-change', (event) => {
  console.log(`Agent ${event.agentId}: ${event.status}`);
});

monitor.on('task-complete', (event) => {
  console.log(`任务完成: ${event.taskId}`);
  console.log(`结果摘要: ${event.summary}`);
});

// 获取所有 Agent 状态
const status = await team.getStatus();
console.log(status);
// {
//   totalAgents: 4,
//   activeAgents: 4,
//   completedTasks: 2,
//   pendingTasks: 2,
//   agents: [
//     { id: 'agent-1', status: 'working', progress: 75 },
//     { id: 'agent-2', status: 'completed', progress: 100 },
//     ...
//   ]
// }

// 暂停/恢复特定 Agent
await team.pauseAgent('agent-1');
await team.resumeAgent('agent-1');

// 人工介入
await team.intervene('agent-1', {
  action: 'provide-guidance',
  message: '重点关注性能优化问题'
});

// 动态调整任务
await team.reassignTask('task-3', 'agent-2');
```

#### 4. 结果汇总与报告

```typescript
// 汇总所有结果
const report = await team.generateReport({
  format: 'detailed',  // detailed | summary | json
  includeMetrics: true,
  includeSuggestions: true
});

console.log(report);
// {
//   summary: {
//     totalFiles: 150,
//     issuesFound: 23,
//     criticalIssues: 2,
//     recommendations: 15
//   },
//   byCategory: {
//     frontend: { issues: 8, suggestions: 5 },
//     backend: { issues: 10, suggestions: 6 },
//     testing: { issues: 3, suggestions: 2 },
//     documentation: { issues: 2, suggestions: 2 }
//   },
//   details: [...]
// }

// 导出为 Markdown
const markdownReport = await team.exportReport('markdown');
await fs.writeFile('review-report.md', markdownReport);
```

### 完整实战示例

```typescript
import { AgentTeam } from '@anthropic-ai/claude-sdk';
import * as fs from 'fs/promises';

class CodeReviewSystem {
  private team: AgentTeam;

  constructor() {
    this.team = new AgentTeam({
      name: 'comprehensive-reviewer',
      maxAgents: 6,
      coordinatorModel: 'claude-opus-4-6-20260205'
    });
  }

  async initialize() {
    // 添加不同类型的审查智能体
    await this.team.addAgent({
      name: 'security-expert',
      description: '专注于安全漏洞检查',
      specialization: 'security',
      model: 'claude-opus-4-6-20260205',
      instructions: `
        你是一个安全专家。审查代码时重点关注：
        1. SQL 注入漏洞
        2. XSS 攻击风险
        3. 身份验证问题
        4. 敏感数据泄露
        5. 不安全的依赖
      `
    });

    await this.team.addAgent({
      name: 'performance-expert',
      description: '专注于性能优化',
      specialization: 'performance',
      model: 'claude-sonnet-4-5-20250929',
      instructions: `
        你是一个性能优化专家。审查代码时关注：
        1. 算法复杂度
        2. 数据库查询优化
        3. 内存泄漏
        4. 不必要的重渲染
        5. 缓存策略
      `
    });

    await this.team.addAgent({
      name: 'architecture-expert',
      description: '专注于架构设计',
      specialization: 'architecture',
      model: 'claude-opus-4-6-20260205',
      instructions: `
        你是一个架构专家。审查代码时关注：
        1. 设计模式应用
        2. 代码组织
        3. 依赖关系
        4. 可维护性
        5. 可扩展性
      `
    });
  }

  async reviewProject(projectPath: string) {
    console.log('开始全面代码审查...');
    const startTime = Date.now();

    // 1. 分析项目结构
    const structure = await this.analyzeStructure(projectPath);

    // 2. 创建审查任务
    const tasks = this.createReviewTasks(structure);

    // 3. 并行执行审查
    const results = await this.team.executeParallel(tasks, {
      strategy: 'specialization-matching',
      timeout: 60 * 60 * 1000,  // 1小时超时

      onProgress: (progress) => {
        const elapsed = (Date.now() - startTime) / 1000;
        console.log(`[${elapsed.toFixed(1)}s] 进度: ${progress.percentage}%`);
      }
    });

    // 4. 生成综合报告
    const report = await this.generateComprehensiveReport(results);

    // 5. 保存报告
    await this.saveReport(report, projectPath);

    const duration = (Date.now() - startTime) / 1000;
    console.log(`审查完成！耗时: ${duration.toFixed(1)}秒`);

    return report;
  }

  private async analyzeStructure(projectPath: string) {
    // 分析项目结构，识别文件类型和模块
    const structure = {
      sourceFiles: [],
      testFiles: [],
      configFiles: [],
      documentation: []
    };
    // ... 实现细节
    return structure;
  }

  private createReviewTasks(structure: any) {
    return [
      {
        type: 'security',
        files: structure.sourceFiles,
        priority: 'high'
      },
      {
        type: 'performance',
        files: structure.sourceFiles,
        priority: 'medium'
      },
      {
        type: 'architecture',
        files: structure.sourceFiles,
        priority: 'medium'
      }
    ];
  }

  private async generateComprehensiveReport(results: any[]) {
    // 整合所有审查结果
    return {
      summary: this.generateSummary(results),
      security: results.find(r => r.type === 'security'),
      performance: results.find(r => r.type === 'performance'),
      architecture: results.find(r => r.type === 'architecture'),
      recommendations: this.prioritizeRecommendations(results)
    };
  }

  private async saveReport(report: any, projectPath: string) {
    const reportPath = `${projectPath}/review-report-${Date.now()}.md`;
    await fs.writeFile(reportPath, JSON.stringify(report, null, 2));
    console.log(`报告已保存: ${reportPath}`);
  }
}

// 使用示例
async function main() {
  const reviewer = new CodeReviewSystem();
  await reviewer.initialize();

  const report = await reviewer.reviewProject('./my-project');
  console.log('审查摘要:', report.summary);
}

main().catch(console.error);
```

### Windows 特定 API

```typescript
// Windows 上的 Agent Team 配置
const team = new AgentTeam({
  name: 'windows-compatible-team',

  // Windows 特定的路径处理
  pathHandler: {
    normalize: (path: string) => path.replace(/\\/g, '/'),
    resolve: (path: string) => require('path').resolve(path)
  },

  // Windows 特定的进程管理
  processManager: {
    shell: 'powershell',  // 或 'cmd'
    encoding: 'utf8'
  }
});

// PowerShell 命令执行
await team.executeCommand({
  agent: 'agent-1',
  command: 'Get-ChildItem -Recurse -File | Group-Object Extension',
  shell: 'powershell'
});

// Windows Terminal 集成
if (process.env.WT_SESSION) {
  await team.enableWindowsTerminalIntegration({
    splitPanes: true,
    paneCount: 4
  });
}
```

### 性能优化

```typescript
// Agent Pool 优化
const team = new AgentTeam({
  name: 'optimized-team',

  // 连接池配置
  poolConfig: {
    minAgents: 2,
    maxAgents: 8,
    idleTimeout: 5 * 60 * 1000,  // 5分钟空闲超时
    acquireTimeout: 30 * 1000     // 30秒获取超时
  },

  // 负载均衡策略
  loadBalancing: {
    strategy: 'round-robin',  // 轮询
    // 其他选项: 'least-connections', 'weighted', 'random'
  },

  // 缓存配置
  cacheConfig: {
    enabled: true,
    ttl: 60 * 60 * 1000,  // 1小时缓存
    maxSize: 100          // 最大缓存条目
  }
});
```

---

## 多智能体编程模式 ⭐ NEW

### 模式1：主从架构（Master-Worker）

```
Master Agent
    ├─ Worker 1: 任务A
    ├─ Worker 2: 任务B
    ├─ Worker 3: 任务C
    └─ Worker 4: 任务D
```

```typescript
class MasterWorkerPattern {
  private master: Agent;
  private workers: Agent[];

  constructor() {
    // 创建主控 Agent
    this.master = new Agent({
      name: 'master',
      model: 'claude-opus-4-6-20260205',
      instructions: `
        你是任务协调器。职责：
        1. 分析复杂任务
        2. 分解为子任务
        3. 分配给 Worker
        4. 汇总结果
      `
    });

    // 创建 Worker Agents
    this.workers = [
      new Agent({ name: 'worker-1', specialization: 'frontend' }),
      new Agent({ name: 'worker-2', specialization: 'backend' }),
      new Agent({ name: 'worker-3', specialization: 'database' }),
      new Agent({ name: 'worker-4', specialization: 'testing' })
    ];
  }

  async executeComplexTask(task: string) {
    // 1. Master 分析并分解任务
    const subtasks = await this.master.decompose(task);

    // 2. 分配给 Workers
    const assignments = this.assignToWorkers(subtasks);

    // 3. 并行执行
    const results = await Promise.all(
      assignments.map(async ({ worker, subtask }) => {
        return worker.execute(subtask);
      })
    );

    // 4. Master 汇总结果
    return this.master.synthesize(results);
  }
}
```

### 模式2：流水线架构（Pipeline）

```
Stage 1 → Stage 2 → Stage 3 → Stage 4
(分析)   (设计)    (实现)    (测试)
```

```typescript
class PipelinePattern {
  private stages: Agent[];

  constructor() {
    this.stages = [
      new Agent({
        name: 'analyzer',
        instructions: '分析需求和现有代码'
      }),
      new Agent({
        name: 'designer',
        instructions: '设计解决方案'
      }),
      new Agent({
        name: 'implementer',
        instructions: '实现代码'
      }),
      new Agent({
        name: 'tester',
        instructions: '编写测试并验证'
      })
    ];
  }

  async execute(input: string) {
    let data = input;

    for (const stage of this.stages) {
      console.log(`执行阶段: ${stage.name}`);
      data = await stage.process(data);
    }

    return data;
  }
}
```

### 模式3：协作架构（Collaborative）

```
Agent A ←→ Agent B
   ↑         ↓
Agent D ←→ Agent C
```

```typescript
class CollaborativePattern {
  private agents: Agent[];
  private sharedContext: SharedContext;

  constructor() {
    this.agents = [
      new Agent({ name: 'architect', role: '设计架构' }),
      new Agent({ name: 'developer', role: '实现功能' }),
      new Agent({ name: 'reviewer', role: '审查代码' }),
      new Agent({ name: 'tester', role: '验证质量' })
    ];

    this.sharedContext = new SharedContext();
  }

  async collaborate(task: string) {
    // 初始化共享上下文
    await this.sharedContext.initialize(task);

    // 多轮协作
    for (let round = 0; round < 5; round++) {
      console.log(`协作轮次: ${round + 1}`);

      // 每个 Agent 基于共享上下文贡献
      for (const agent of this.agents) {
        const contribution = await agent.contribute(
          this.sharedContext.getCurrentState()
        );

        await this.sharedContext.update(agent.name, contribution);
      }

      // 检查是否达成共识
      if (await this.reachedConsensus()) {
        break;
      }
    }

    return this.sharedContext.getFinalResult();
  }
}
```

### 任务分解策略

```typescript
// 按模块分解
function decomposeByModule(project: Project): Task[] {
  return project.modules.map(module => ({
    type: 'module',
    target: module.name,
    files: module.files,
    dependencies: module.dependencies
  }));
}

// 按功能维度分解
function decomposeByDimension(codebase: Codebase): Task[] {
  return [
    { dimension: 'security', focus: '漏洞检查' },
    { dimension: 'performance', focus: '性能优化' },
    { dimension: 'maintainability', focus: '可维护性' },
    { dimension: 'testability', focus: '可测试性' }
  ];
}

// 按时间范围分解
function decomposeByTimeRange(history: GitHistory): Task[] {
  return [
    { range: 'last-week', label: '最近一周的变更' },
    { range: 'last-month', label: '最近一个月的变更' },
    { range: 'legacy', label: '历史遗留代码' }
  ];
}
```

---

## Subagent 配置 ⭐ NEW

### 官方说明

```markdown
"Add `context: fork` to your frontmatter when you want a skill to run
in isolation. The skill content becomes the prompt that drives the
subagent. It won't have access to your conversation history."
```

### Subagent SDK 配置

```typescript
import { Subagent, AgentType } from '@anthropic-ai/claude-sdk';

// 创建 Subagent
const subagent = new Subagent({
  // 基础配置
  name: 'code-explorer',
  description: '代码库探索专家',

  // 执行模式
  context: 'fork',  // ⭐ 关键：隔离执行

  // Agent 类型
  agent: AgentType.Explore,  // Explore | Plan | GeneralPurpose

  // 模型配置
  model: {
    name: 'claude-sonnet-4-5-20250929',
    temperature: 0.2,
    maxTokens: 4000
  },

  // 工具权限
  allowedTools: [
    'Read',
    'Write',
    'Edit',
    'Bash',
    'Grep',
    'Glob'
  ],

  // 资源限制
  limits: {
    maxExecutionTime: 30 * 60 * 1000,  // 30分钟
    maxTokens: 100000,
    maxFileReads: 100
  }
});
```

### Agent 类型详解

```typescript
enum AgentType {
  // 探索型：只读，适合大规模代码库分析
  Explore = 'explore',

  // 规划型：结构化思考，适合生成计划
  Plan = 'plan',

  // 通用型：灵活，可读写，适合复杂任务
  GeneralPurpose = 'general-purpose',

  // 自定义型：用户定义行为
  Custom = 'custom'
}

// 使用示例
const exploreAgent = new Subagent({
  name: 'architecture-analyzer',
  agent: AgentType.Explore,
  allowedTools: ['Read', 'Grep', 'Glob'],  // 只读工具
  instructions: `
    分析项目架构：
    1. 识别主要组件
    2. 绘制依赖关系图
    3. 发现架构模式
  `
});

const planAgent = new Subagent({
  name: 'refaction-planner',
  agent: AgentType.Plan,
  allowedTools: ['Read', 'Grep', 'Glob'],
  instructions: `
    制定重构计划：
    1. 分析当前代码结构
    2. 识别改进点
    3. 生成详细执行步骤
  `
});

const generalAgent = new Subagent({
  name: 'feature-implementer',
  agent: AgentType.GeneralPurpose,
  allowedTools: ['Read', 'Write', 'Edit', 'Bash'],
  instructions: '实现新功能，包括代码编写和测试'
});
```

### 动态上下文注入

```typescript
// 使用 !command 语法
const subagent = new Subagent({
  name: 'git-analyzer',

  // 动态获取 Git 信息
  dynamicContext: {
    // 当前分支
    currentBranch: '!`git branch --show-current`',

    // 最近提交
    recentCommits: '!`git log -10 --oneline`',

    // 修改的文件
    changedFiles: '!`git diff --name-only HEAD~1`',

    // 未提交的变更
    uncommittedChanges: '!`git status --short`'
  },

  instructions: `
    基于当前 Git 状态进行分析：

    分支: {{currentBranch}}

    最近提交:
    {{recentCommits}}

    需要审查的文件:
    {{changedFiles}}
  `
});

// 执行时自动注入
const result = await subagent.execute({
  preprocess: true,  // 启用预处理
  injectContext: true  // 注入动态上下文
});
```

### 完整实战示例

```typescript
import { Subagent, AgentTeam } from '@anthropic-ai/claude-sdk';

class ParallelCodeAnalyzer {
  private team: AgentTeam;

  constructor() {
    this.team = new AgentTeam({ name: 'parallel-analyzer' });

    // 创建多个 Subagent，每个专注于不同维度
    this.initializeSubagents();
  }

  private async initializeSubagents() {
    // Subagent 1: 安全分析（隔离执行）
    await this.team.addSubagent({
      name: 'security-auditor',
      context: 'fork',
      agent: 'Explore',
      allowedTools: ['Read', 'Grep', 'Glob'],

      // 动态获取依赖信息
      dynamicContext: {
        dependencies: '!`cat package.json | jq ".dependencies"`',
        vulnerabilities: '!`npm audit --json 2>/dev/null || echo "{}"`'
      },

      instructions: `
        你是一个安全审计专家。

        当前项目依赖:
        {{dependencies}}

        已知漏洞:
        {{vulnerabilities}}

        任务：
        1. 搜索常见漏洞模式（SQL注入、XSS等）
        2. 检查不安全的依赖版本
        3. 审查身份验证实现
        4. 生成安全审计报告
      `
    });

    // Subagent 2: 性能分析
    await this.team.addSubagent({
      name: 'performance-analyzer',
      context: 'fork',
      agent: 'Explore',
      allowedTools: ['Read', 'Grep', 'Glob'],

      instructions: `
        你是一个性能优化专家。

        任务：
        1. 识别性能瓶颈
        2. 分析算法复杂度
        3. 检查数据库查询效率
        4. 发现内存泄漏风险
        5. 生成性能优化建议
      `
    });

    // Subagent 3: 架构分析
    await this.team.addSubagent({
      name: 'architecture-reviewer',
      context: 'fork',
      agent: 'Plan',
      allowedTools: ['Read', 'Grep', 'Glob'],

      instructions: `
        你是一个架构专家。

        任务：
        1. 分析项目结构
        2. 识别设计模式
        3. 评估耦合度
        4. 建议架构改进
        5. 生成架构文档
      `
    });
  }

  async analyzeProject(projectPath: string) {
    console.log('启动并行分析...');

    // 并行执行所有 Subagent
    const results = await this.team.executeParallel([
      { agent: 'security-auditor', target: projectPath },
      { agent: 'performance-analyzer', target: projectPath },
      { agent: 'architecture-reviewer', target: projectPath }
    ], {
      timeout: 20 * 60 * 1000,  // 20分钟超时

      // 每个 Subagent 在隔离环境中运行
      isolation: {
        enabled: true,
        shareResults: false  // 不共享中间结果
      }
    });

    // 汇总报告
    return {
      security: results[0],
      performance: results[1],
      architecture: results[2],
      summary: this.generateSummary(results)
    };
  }

  private generateSummary(results: any[]) {
    return {
      totalIssues: results.reduce((sum, r) => sum + r.issues.length, 0),
      criticalIssues: results.reduce((sum, r) =>
        sum + r.issues.filter((i: any) => i.severity === 'critical').length, 0
      ),
      recommendations: results.flatMap((r: any) => r.recommendations)
    };
  }
}

// 使用
const analyzer = new ParallelCodeAnalyzer();
const report = await analyzer.analyzeProject('./src');
console.log('安全 issues:', report.security.issues.length);
console.log('性能 issues:', report.performance.issues.length);
```

### Windows 特定配置

```typescript
// Windows 上的 Subagent 配置
const windowsSubagent = new Subagent({
  name: 'windows-compatible-agent',

  // Windows 特定的命令执行
  commandExecutor: {
    shell: 'powershell',
    encoding: 'utf8',
    windowsHide: false
  },

  // 路径处理
  pathConfig: {
    separator: '\\',
    normalize: true,
    useForwardSlash: true  // 内部使用正斜杠
  },

  // 动态上下文（Windows 命令）
  dynamicContext: {
    // PowerShell 命令
    fileList: '!`powershell -Command "Get-ChildItem -Recurse -File | Select-Object -First 20 FullName"`',

    // 系统信息
    systemInfo: '!`powershell -Command "Get-ComputerInfo | Select-Object WindowsVersion, TotalPhysicalMemory"`',

    // Git 信息（Git Bash 或 WSL）
    gitStatus: '!`git status --short`'
  }
});
```

---

## Windows特定

### Windows 路径处理

```typescript
import path from 'path';

class WindowsPathHandler {
  normalizePath(filePath: string): string {
    // Windows 路径标准化
    return filePath
      .split(path.sep)
      .join(path.posix.sep);
  }

  resolveShortPath(shortPath: string): string {
    // 解析 Windows 短路径
    // C:\Progra~1 → C:\Program Files
    const result = require('fs').realpathSync(shortPath);
    return result;
  }
}
```

### PowerShell 命令执行

```typescript
import { exec } from 'child_process';
import { promisify } from 'util';

const execAsync = promisify(exec);

class PowerShellExecutor {
  async execute(script: string): Promise<string> {
    const command = `powershell -Command "${script}"`;
    const { stdout, stderr } = await execAsync(command);

    if (stderr) {
      throw new Error(stderr);
    }

    return stdout;
  }

  async executeScript(scriptPath: string): Promise<string> {
    const command = `powershell -ExecutionPolicy Bypass -File "${scriptPath}"`;
    const { stdout, stderr } = await execAsync(command);

    if (stderr) {
      throw new Error(stderr);
    }

    return stdout;
  }
}
```

### Windows 服务集成

```typescript
class WindowsServiceManager {
  async startService(serviceName: string): Promise<void> {
    const executor = new PowerShellExecutor();
    await executor.execute(`Start-Service -Name '${serviceName}'`);
  }

  async stopService(serviceName: string): Promise<void> {
    const executor = new PowerShellExecutor();
    await executor.execute(`Stop-Service -Name '${serviceName}'`);
  }

  async getServiceStatus(serviceName: string): Promise<string> {
    const executor = new PowerShellExecutor();
    const status = await executor.execute(
      `(Get-Service -Name '${serviceName}').Status`
    );
    return status.trim();
  }

  async restartService(serviceName: string): Promise<void> {
    const executor = new PowerShellExecutor();
    await executor.execute(`Restart-Service -Name '${serviceName}'`);
  }
}
```

---

## 最佳实践

### 1. 错误处理

```typescript
class RobustAgent {
  private agent: Agent;
  private retryConfig = {
    maxRetries: 3,
    backoffMs: 1000
  };

  async safeExecute(fn: () => Promise<any>): Promise<any> {
    let lastError: Error;

    for (let attempt = 1; attempt <= this.retryConfig.maxRetries; attempt++) {
      try {
        return await fn();
      } catch (error) {
        lastError = error as Error;
        console.error(`尝试 ${attempt} 失败:`, error);

        if (attempt < this.retryConfig.maxRetries) {
          // 指数退避
          await this.delay(this.retryConfig.backoffMs * attempt);
        }
      }
    }

    throw lastError!;
  }

  private delay(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms));
  }
}
```

### 2. 性能优化

```typescript
class OptimizedAgent {
  private cache = new Map<string, any>();
  private responseCache = new Map<string, string>();

  async cachedResponse(prompt: string): Promise<string> {
    // 生成缓存键
    const cacheKey = this.hash(prompt);

    // 检查缓存
    if (this.responseCache.has(cacheKey)) {
      console.log('缓存命中');
      return this.responseCache.get(cacheKey)!;
    }

    // 调用 Agent
    const response = await this.agent.sendMessage(prompt);

    // 缓存结果
    this.responseCache.set(cacheKey, response.content);

    return response.content;
  }

  private hash(text: string): string {
    // 简单哈希函数
    let hash = 0;
    for (let i = 0; i < text.length; i++) {
      const char = text.charCodeAt(i);
      hash = ((hash << 5) - hash) + char;
      hash = hash & hash;
    }
    return hash.toString(36);
  }
}
```

### 3. 日志记录

```typescript
import winston from 'winston';

class LoggingAgent {
  private logger: winston.Logger;
  private agent: Agent;

  constructor() {
    this.logger = winston.createLogger({
      level: 'info',
      format: winston.format.json(),
      transports: [
        new winston.transports.File({ filename: 'agent.log' }),
        new winston.transports.Console()
      ]
    });

    this.setupLogging();
  }

  private setupLogging() {
    this.agent.on('message.before', (message) => {
      this.logger.info('发送消息', { message });
    });

    this.agent.on('message.after', (response) => {
      this.logger.info('收到响应', {
        length: response.content.length,
        tokens: response.usage
      });
    });

    this.agent.on('error', (error) => {
      this.logger.error('Agent 错误', { error });
    });
  }
}
```

### 4. 监控和指标

```typescript
class MonitoredAgent {
  private metrics = {
    messagesSent: 0,
    tokensUsed: 0,
    errors: 0,
    averageResponseTime: 0
  };

  private responseTimes: number[] = [];

  async sendMessageWithMetrics(message: string): Promise<string> {
    const startTime = Date.now();

    try {
      this.metrics.messagesSent++;

      const response = await this.agent.sendMessage(message);

      // 记录指标
      const duration = Date.now() - startTime;
      this.responseTimes.push(duration);
      this.metrics.tokensUsed += response.usage.totalTokens;
      this.updateAverageResponseTime();

      return response.content;
    } catch (error) {
      this.metrics.errors++;
      throw error;
    }
  }

  private updateAverageResponseTime() {
    const sum = this.responseTimes.reduce((a, b) => a + b, 0);
    this.metrics.averageResponseTime = sum / this.responseTimes.length;
  }

  getMetrics() {
    return { ...this.metrics };
  }
}
```

---

## 常见问题

### Q1: 如何选择合适的模型？

**A**: 根据任务复杂度选择

```typescript
// 简单任务 - 使用 Haiku（快速、便宜）
const simpleAgent = new Agent({
  model: 'claude-haiku'
});

// 中等任务 - 使用 Sonnet（平衡）
const mediumAgent = new Agent({
  model: 'claude-sonnet-4-5-20250929'
});

// 复杂任务 - 使用 Opus（最强）
const complexAgent = new Agent({
  model: 'claude-opus-4-5-20251101'
});
```

### Q2: 如何控制成本？

**A**: 使用 Token 限制和缓存

```typescript
const agent = new Agent({
  maxTokens: 1024,           // 限制输出
  temperature: 0.5           // 降低随机性
});

// 缓存常见响应
const cache = new Map();
async function cachedCall(prompt: string) {
  if (cache.has(prompt)) {
    return cache.get(prompt);
  }

  const response = await agent.sendMessage(prompt);
  cache.set(prompt, response);
  return response;
}
```

### Q3: 如何处理长对话？

**A**: 管理上下文窗口

```typescript
class ContextManager {
  private maxMessages = 50;
  private messages: Message[] = [];

  addMessage(message: Message) {
    this.messages.push(message);

    // 保留最近的 N 条消息
    if (this.messages.length > this.maxMessages) {
      this.messages = this.messages.slice(-this.maxMessages);
    }
  }

  getContext(): Message[] {
    return this.messages;
  }

  clear() {
    this.messages = [];
  }
}
```

### Q4: 如何调试 Agent 行为？

**A**: 启用详细日志

```typescript
const agent = new Agent({
  debug: true,              // 启用调试模式
  logLevel: 'verbose'       // 详细日志
});

// 订阅所有事件
agent.on('*', (event, data) => {
  console.log(`事件: ${event}`, data);
});
```

### Q5: 如何并行处理多个任务？

**A**: 使用 Promise.all

```typescript
const tasks = [
  agent.sendMessage('任务1'),
  agent.sendMessage('任务2'),
  agent.sendMessage('任务3')
];

const results = await Promise.all(tasks);
```

### Q6: 如何限制 Agent 的能力？

**A**: 使用工具白名单

```typescript
const agent = new Agent({
  tools: {
    allow: ['file-read'],     // 只允许读文件
    deny: ['file-write', 'command-exec']  // 禁止写和执行
  }
});
```

---

## 故障排查

### 问题1：API 密钥无效

**症状**：
```
Error: Invalid API key
```

**解决方案**：
```typescript
// 1. 检查环境变量
console.log(process.env.ANTHROPIC_API_KEY);

// 2. 验证密钥格式
// 应该是: sk-ant-api03-...

// 3. 重新设置密钥
export ANTHROPIC_API_KEY="sk-ant-api03-..."
```

### 问题2：Token 超限

**症状**：
```
Error: Maximum tokens exceeded
```

**解决方案**：
```typescript
// 减少上下文
agent.configure({
  maxTokens: 2048,           // 减少输出限制
  contextWindow: 100000      // 限制上下文窗口
});

// 清理历史消息
conversation.clear();
```

### 问题3：连接超时

**症状**：
```
Error: Request timeout
```

**解决方案**：
```typescript
// 增加超时时间
const agent = new Agent({
  timeout: 120000  // 2 分钟
});

// 或使用流式响应
const stream = await agent.sendMessageStream(message);
```

---

## 总结

### 关键要点

1. **Agent SDK 价值**
   - 完全编程控制
   - 深度系统集成
   - 自动化工作流

2. **核心概念**
   - Agent（智能体）
   - Conversation（对话）
   - Tool（工具）
   - Context（上下文）
   - Event（事件）

3. **开发流程**
   - 创建 Agent
   - 配置行为
   - 创建对话
   - 处理响应
   - 使用工具

4. **实战应用**
   - 代码审查
   - 文档生成
   - 测试生成
   - 自动部署

5. **最佳实践**
   - 错误处理
   - 性能优化
   - 日志记录
   - 监控指标

### 学习路径

```
Level 1: 基础使用
    ↓
创建简单 Agent
    ↓
Level 2: 对话管理
    ↓
处理复杂对话
    ↓
Level 3: 工具集成
    ↓
自定义工具
    ↓
Level 4: 高级应用
    ↓
构建自动化系统
```

### 相关资源

- [官方文档](https://docs.anthropic.com/claude-reference/agent-sdk)
- [API 参考](https://docs.anthropic.com/claude-reference/api)
- [示例代码](https://github.com/anthropics/claude-sdk-examples)

---

**最后更新**: 2026-03-25
**维护者**: Nyxifer 和他的 ClaudeCode (GLM4.7)
**反馈**: [GitHub Issues](https://github.com/anthropics/claude-code/issues)

---

## 📚 相关资源

### 官方文档
- [Agent SDK Overview](https://platform.claude.com/docs/en/agent-sdk/overview)
- [Agent SDK Quickstart](https://platform.claude.com/docs/en/agent-sdk/quickstart)
- [Agent Loop 原理](https://platform.claude.com/docs/en/agent-sdk/agent-loop)

### 示例代码
- [TypeScript SDK](https://github.com/anthropics/claude-agent-sdk-typescript)
- [Python SDK](https://github.com/anthropics/claude-agent-sdk-python)
- [示例 Agents](https://github.com/anthropics/claude-agent-sdk-demos)

### 迁移指南
- [Claude Code SDK → Agent SDK 迁移](https://platform.claude.com/docs/en/agent-sdk/migration-guide)
