# Agent SDK - Claude Code 编程扩展

> **用代码构建强大的 AI Agent**

**阅读时间**: 40分钟
**难度**: ⭐⭐⭐⭐⭐
**重要性**: ⭐⭐⭐⭐⭐
**前置要求**: [插件系统](../03-advanced-topics/02-plugins.md)

---

## 目录

- [Agent SDK 概述](#agent-sdk-概述)
- [SDK 架构](#sdk-架构)
- [环境搭建](#环境搭建)
- [核心概念](#核心概念)
- [开发流程](#开发流程)
- [实战案例](#实战案例)
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

- Node.js 18+ 或 TypeScript 5.0+
- npm 或 yarn 或 pnpm
- Claude API 密钥

### 安装 SDK

```bash
# npm
npm install @anthropic-ai/claude-sdk

# yarn
yarn add @anthropic-ai/claude-sdk

# pnpm
pnpm add @anthropic-ai/claude-sdk
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

**最后更新**: 2026-01-18
**维护者**: knowknowcc 项目组
**反馈**: [GitHub Issues](https://github.com/anthropics/claude-code/issues)
