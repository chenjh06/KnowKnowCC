# 自定义 MCP 服务器 - Custom MCP Servers

> **扩展 Claude Code 的能力边界**

**阅读时间**: 50分钟
**难度**: ⭐⭐⭐⭐⭐
**适用场景**: 定制化工具、团队集成、特殊数据源、内部系统
**前置要求**: [Level 2 进阶提升](../../skills/), [MCP 服务器精选](../../skills/c-integration/01-mcp-servers.md), Node.js 基础

---

## 目录

- [MCP 服务器概述](#mcp-服务器概述)
- [MCP 协议基础](#mcp-协议基础)
- [开发环境搭建](#开发环境搭建)
- [创建第一个 MCP 服务器](#创建第一个-mcp-服务器)
- [高级功能](#高级功能)
- [实战案例](#实战案例)
- [Windows 专属](#windows-专属)
- [部署和发布](#部署和发布)
- [最佳实践](#最佳实践)
- [常见问题](#常见问题)
- [故障排查](#故障排查)

---

## MCP 服务器概述

### 什么是 MCP 服务器？

**MCP (Model Context Protocol)** 是一个开放协议，允许 Claude Code 与外部工具和数据源进行交互。

```
Claude Code
    ↓ (MCP 协议)
MCP 服务器
    ↓
外部工具/数据源
```

**核心价值**：

```
✅ 扩展能力
   - 访问外部 API
   - 操作数据库
   - 调用内部系统

✅ 定制化
   - 满足特定需求
   - 集成团队工具
   - 保护数据隐私

✅ 可重用
   - 一次开发，多处使用
   - 团队共享
   - 社区贡献
```

### 为什么需要自定义 MCP 服务器？

#### 1. 内部系统集成

```
场景：公司内部有多个系统
- 用户管理系统
- 文档管理系统
- 项目管理系统

问题：Claude Code 无法直接访问

解决：开发 MCP 服务器作为桥梁
```

#### 2. 特殊数据源

```
场景：需要访问特殊数据
- 内部数据库
- 私有 API
- 本地文件系统（特殊格式）

解决：MCP 服务器提供统一接口
```

#### 3. 定制化工具

```
场景：团队有特定工作流
- 代码审查流程
- 部署流程
- 测试流程

解决：MCP 服务器封装这些流程
```

---

## MCP 协议基础

### 协议架构

```
┌─────────────────────────────────────────────┐
│  Claude Code (客户端)                       │
└──────────────┬──────────────────────────────┘
               ↓ JSON-RPC 2.0
┌──────────────┴──────────────────────────────┐
│  MCP 服务器                                 │
│  ├─ 工具 (Tools)                            │
│  ├─ 资源 (Resources)                        │
│  └─ 提示 (Prompts)                          │
└──────────────┬──────────────────────────────┘
               ↓
┌──────────────┴──────────────────────────────┐
│  外部系统                                   │
│  ├─ APIs                                    │
│  ├─ 数据库                                  │
│  └─ 文件系统                                │
└─────────────────────────────────────────────┘
```

### 核心概念

#### 1. 工具 (Tools)

工具是可供 Claude 调用的函数。

```typescript
{
  name: "get_weather",
  description: "获取指定城市的天气信息",
  inputSchema: {
    type: "object",
    properties: {
      city: {
        type: "string",
        description: "城市名称"
      }
    },
    required: ["city"]
  }
}
```

#### 2. 资源 (Resources)

资源是可供 Claude 读取的数据。

```typescript
{
  uri: "file:///project/README.md",
  name: "项目 README",
  description: "项目的说明文档",
  mimeType: "text/markdown"
}
```

#### 3. 提示 (Prompts)

提示是预定义的提示模板。

```typescript
{
  name: "code-review",
  description: "代码审查提示模板",
  arguments: [
    {
      name: "file",
      description: "要审查的文件",
      required: true
    }
  ]
}
```

### JSON-RPC 通信

**请求格式**：

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "tools/call",
  "params": {
    "name": "get_weather",
    "arguments": {
      "city": "北京"
    }
  }
}
```

**响应格式**：

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": {
    "content": [
      {
        "type": "text",
        "text": "北京今天晴，温度 15-25°C"
      }
    ]
  }
}
```

---

## 开发环境搭建

### 环境要求

```
✅ Node.js 18+ (推荐使用 LTS 版本)
✅ npm 或 yarn
✅ TypeScript (可选，但推荐)
✅ Git
```

### 安装 MCP SDK

```bash
# 创建项目目录
mkdir my-mcp-server
cd my-mcp-server

# 初始化项目
npm init -y

# 安装 MCP SDK
npm install @modelcontextprotocol/sdk

# 安装开发依赖
npm install --save-dev typescript @types/node tsx
```

### 项目结构

```
my-mcp-server/
├── src/
│   ├── index.ts          # 服务器入口
│   ├── tools/            # 工具定义
│   │   ├── weather.ts
│   │   └── database.ts
│   ├── resources/        # 资源定义
│   │   └── files.ts
│   └── prompts/          # 提示模板
│       └── review.ts
├── package.json
├── tsconfig.json
└── README.md
```

### 配置文件

**package.json**:

```json
{
  "name": "my-mcp-server",
  "version": "1.0.0",
  "description": "我的自定义 MCP 服务器",
  "main": "dist/index.js",
  "type": "module",
  "scripts": {
    "build": "tsc",
    "start": "node dist/index.js",
    "dev": "tsx src/index.ts"
  },
  "bin": {
    "my-mcp-server": "dist/index.js"
  },
  "dependencies": {
    "@modelcontextprotocol/sdk": "^1.0.0"
  },
  "devDependencies": {
    "@types/node": "^20.0.0",
    "typescript": "^5.0.0",
    "tsx": "^4.0.0"
  }
}
```

**tsconfig.json**:

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "Node16",
    "moduleResolution": "Node16",
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules"]
}
```

---

## 创建第一个 MCP 服务器

### 步骤 1: 基础服务器

创建 `src/index.ts`:

```typescript
#!/usr/bin/env node

import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from '@modelcontextprotocol/sdk/types.js';

// 创建服务器实例
const server = new Server(
  {
    name: 'my-mcp-server',
    version: '1.0.0',
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

// 注册工具列表处理器
server.setRequestHandler(ListToolsRequestSchema, async () => {
  return {
    tools: [
      {
        name: 'hello',
        description: '向世界打招呼',
        inputSchema: {
          type: 'object',
          properties: {
            name: {
              type: 'string',
              description: '要问候的名字',
            },
          },
          required: ['name'],
        },
      },
    ],
  };
});

// 注册工具调用处理器
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  if (name === 'hello') {
    const greeting = `你好，${args.name}！`;
    return {
      content: [
        {
          type: 'text',
          text: greeting,
        },
      ],
    };
  }

  throw new Error(`未知工具: ${name}`);
});

// 启动服务器
async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error('MCP 服务器已启动');
}

main().catch((error) => {
  console.error('服务器启动失败:', error);
  process.exit(1);
});
```

### 步骤 2: 测试服务器

```bash
# 构建项目
npm run build

# 在 Claude Code 配置中添加服务器
```

**配置文件** (`~/.claude/settings.json`):

```json
{
  "mcpServers": {
    "my-server": {
      "command": "node",
      "args": ["D:/Projects/my-mcp-server/dist/index.js"]
    }
  }
}
```

### 步骤 3: 使用服务器

在 Claude Code 中：

```
👤 你：使用 hello 工具向张三打招呼

🤖 Claude：[调用 hello 工具]
[结果] "你好，张三！"
```

---

## 高级功能

### 1. 添加数据库工具

创建 `src/tools/database.ts`:

```typescript
import { Pool } from 'pg';

// 数据库连接池
const pool = new Pool({
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT || '5432'),
  database: process.env.DB_NAME || 'mydb',
  user: process.env.DB_USER || 'user',
  password: process.env.DB_PASSWORD || 'pass',
});

// 查询工具
export const queryTool = {
  name: 'db_query',
  description: '执行数据库查询（只读）',
  inputSchema: {
    type: 'object',
    properties: {
      sql: {
        type: 'string',
        description: 'SQL 查询语句',
      },
    },
    required: ['sql'],
  },
};

export async function handleQuery(args: any) {
  const { sql } = args;

  // 安全检查：只允许 SELECT 查询
  if (!sql.trim().toLowerCase().startsWith('select')) {
    throw new Error('只允许 SELECT 查询');
  }

  try {
    const result = await pool.query(sql);
    return {
      content: [
        {
          type: 'text',
          text: JSON.stringify(result.rows, null, 2),
        },
      ],
    };
  } catch (error) {
    return {
      content: [
        {
          type: 'text',
          text: `查询错误: ${error}`,
        },
      ],
      isError: true,
    };
  }
}
```

在 `src/index.ts` 中注册：

```typescript
import { queryTool, handleQuery } from './tools/database.js';

server.setRequestHandler(ListToolsRequestSchema, async () => {
  return {
    tools: [
      {
        name: queryTool.name,
        description: queryTool.description,
        inputSchema: queryTool.inputSchema,
      },
    ],
  };
});

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  if (name === 'db_query') {
    return await handleQuery(args);
  }

  throw new Error(`未知工具: ${name}`);
});
```

### 2. 添加文件资源

创建 `src/resources/files.ts`:

```typescript
import { ReadableResource } from '@modelcontextprotocol/sdk/types.js';
import fs from 'fs/promises';
import path from 'path';

// 资源列表
export async function listResources() {
  const projectDir = process.cwd();
  const files = await fs.readdir(projectDir);

  return files
    .filter((f) => f.endsWith('.md'))
    .map((file) => ({
      uri: `file://${path.join(projectDir, file)}`,
      name: file,
      description: `Markdown 文件: ${file}`,
      mimeType: 'text/markdown',
    }));
}

// 读取资源
export async function readResource(uri: string) {
  const filePath = uri.replace('file://', '');

  try {
    const content = await fs.readFile(filePath, 'utf-8');
    return {
      contents: [
        {
          uri,
          mimeType: 'text/markdown',
          text: content,
        },
      ],
    };
  } catch (error) {
    throw new Error(`无法读取文件: ${filePath}`);
  }
}
```

在 `src/index.ts` 中注册：

```typescript
import { ListResourcesRequestSchema, ReadResourceRequestSchema } from '@modelcontextprotocol/sdk/types.js';
import { listResources, readResource } from './resources/files.js';

// 注册资源列表处理器
server.setRequestHandler(ListResourcesRequestSchema, async () => {
  return {
    resources: await listResources(),
  };
});

// 注册资源读取处理器
server.setRequestHandler(ReadResourceRequestSchema, async (request) => {
  const { uri } = request.params;
  return await readResource(uri);
});
```

### 3. 添加提示模板

创建 `src/prompts/review.ts`:

```typescript
// 代码审查提示
export const reviewPrompt = {
  name: 'code_review',
  description: '代码审查提示模板',
  arguments: [
    {
      name: 'file',
      description: '要审查的文件路径',
      required: true,
    },
    {
      name: 'focus',
      description: '审查重点（可选）',
      required: false,
    },
  ],
};

export async function getReviewPrompt(args: any) {
  const { file, focus } = args;

  let prompt = `请审查以下代码文件: ${file}\n\n`;

  if (focus) {
    prompt += `审查重点: ${focus}\n\n`;
  }

  prompt += `
请检查：
1. 代码质量和可读性
2. 潜在的 bug 和问题
3. 性能优化建议
4. 安全性问题
5. 最佳实践建议
`;

  return {
    messages: [
      {
        role: 'user',
        content: {
          type: 'text',
          text: prompt,
        },
      },
    ],
  };
}
```

在 `src/index.ts` 中注册：

```typescript
import { ListPromptsRequestSchema, GetPromptRequestSchema } from '@modelcontextprotocol/sdk/types.js';
import { reviewPrompt, getReviewPrompt } from './prompts/review.js';

// 注册提示列表处理器
server.setRequestHandler(ListPromptsRequestSchema, async () => {
  return {
    prompts: [reviewPrompt],
  };
});

// 注册提示获取处理器
server.setRequestHandler(GetPromptRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  if (name === 'code_review') {
    return await getReviewPrompt(args || {});
  }

  throw new Error(`未知提示: ${name}`);
});
```

---

## 实战案例

### 案例 1: 企业知识库 MCP 服务器

**场景**：公司有内部文档系统，需要让 Claude 能够访问

**需求**：
- 搜索内部文档
- 读取文档内容
- 提供文档摘要

**解决方案**：

```typescript
// src/tools/knowledge.ts

import axios from 'axios';

const KNOWLEDGE_API = process.env.KNOWLEDGE_API || 'http://knowledge.internal/api';

// 搜索文档
export const searchTool = {
  name: 'knowledge_search',
  description: '搜索企业知识库',
  inputSchema: {
    type: 'object',
    properties: {
      query: {
        type: 'string',
        description: '搜索关键词',
      },
      category: {
        type: 'string',
        description: '文档类别（可选）',
        enum: ['技术', '产品', '运营', 'HR'],
      },
    },
    required: ['query'],
  },
};

export async function handleSearch(args: any) {
  const { query, category } = args;

  try {
    const response = await axios.post(`${KNOWLEDGE_API}/search`, {
      query,
      filters: category ? { category } : {},
      limit: 10,
    });

    const results = response.data.results.map((r: any) => ({
      title: r.title,
      url: r.url,
      excerpt: r.excerpt,
      score: r.score,
    }));

    return {
      content: [
        {
          type: 'text',
          text: `找到 ${results.length} 个相关文档:\n\n${JSON.stringify(results, null, 2)}`,
        },
      ],
    };
  } catch (error) {
    return {
      content: [
        {
          type: 'text',
          text: `搜索失败: ${error}`,
        },
      ],
      isError: true,
    };
  }
}

// 读取文档
export const readTool = {
  name: 'knowledge_read',
  description: '读取知识库文档内容',
  inputSchema: {
    type: 'object',
    properties: {
      url: {
        type: 'string',
        description: '文档 URL',
      },
    },
    required: ['url'],
  },
};

export async function handleRead(args: any) {
  const { url } = args;

  try {
    const response = await axios.get(`${KNOWLEDGE_API}/document`, {
      params: { url },
    });

    const doc = response.data;

    return {
      content: [
        {
          type: 'text',
          text: `# ${doc.title}\n\n${doc.content}`,
        },
      ],
    };
  } catch (error) {
    return {
      content: [
        {
          type: 'text',
          text: `读取失败: ${error}`,
        },
      ],
      isError: true,
    };
  }
}
```

**使用示例**：

```
👤 你：搜索关于"微服务架构"的技术文档

🤖 Claude：[调用 knowledge_search]
找到 8 个相关文档：
1. 微服务架构设计指南 (评分: 0.95)
2. 微服务最佳实践 (评分: 0.87)
3. ...

你想查看哪篇文档的详细内容？
```

### 案例 2: Git 操作 MCP 服务器

**场景**：自动化 Git 工作流

```typescript
// src/tools/git.ts

import { exec } from 'child_process';
import { promisify } from 'util';

const execAsync = promisify(exec);

// Git 工具
export const gitTools = [
  {
    name: 'git_status',
    description: '查看 Git 状态',
    inputSchema: {
      type: 'object',
      properties: {},
    },
  },
  {
    name: 'git_diff',
    description: '查看代码差异',
    inputSchema: {
      type: 'object',
      properties: {
        file: {
          type: 'string',
          description: '文件路径（可选）',
        },
      },
    },
  },
  {
    name: 'git_commit',
    description: '提交更改',
    inputSchema: {
      type: 'object',
      properties: {
        message: {
          type: 'string',
          description: '提交信息',
        },
        files: {
          type: 'array',
          items: { type: 'string' },
          description: '要提交的文件',
        },
      },
      required: ['message', 'files'],
    },
  },
];

export async function handleGitCommand(tool: string, args: any) {
  try {
    let command = '';

    switch (tool) {
      case 'git_status':
        command = 'git status';
        break;
      case 'git_diff':
        command = args.file ? `git diff ${args.file}` : 'git diff';
        break;
      case 'git_commit':
        const files = args.files.join(' ');
        command = `git add ${files} && git commit -m "${args.message}"`;
        break;
      default:
        throw new Error(`未知命令: ${tool}`);
    }

    const { stdout, stderr } = await execAsync(command);

    return {
      content: [
        {
          type: 'text',
          text: stdout || stderr,
        },
      ],
    };
  } catch (error) {
    return {
      content: [
        {
          type: 'text',
          text: `执行失败: ${error}`,
        },
      ],
      isError: true,
    };
  }
}
```

**使用示例**：

```
👤 你：查看当前 Git 状态

🤖 Claude：[调用 git_status]
On branch main
Changes not staged for commit:
  modified:   src/app.ts
  modified:   src/utils.ts

需要提交这些更改吗？
```

### 案例 3: 监控告警 MCP 服务器

**场景**：集成监控系统，实时查询告警信息

```typescript
// src/tools/monitoring.ts

import axios from 'axios';

const MONITORING_API = process.env.MONITORING_API || 'http://monitoring.internal/api';

// 告警工具
export const alertTool = {
  name: 'get_alerts',
  description: '获取监控告警',
  inputSchema: {
    type: 'object',
    properties: {
      severity: {
        type: 'string',
        description: '告警级别',
        enum: ['critical', 'warning', 'info'],
      },
      timeRange: {
        type: 'string',
        description: '时间范围',
        enum: ['1h', '6h', '24h', '7d'],
      },
    },
  },
};

export async function handleGetAlerts(args: any) {
  const { severity, timeRange = '24h' } = args;

  try {
    const response = await axios.get(`${MONITORING_API}/alerts`, {
      params: {
        severity,
        time_range: timeRange,
      },
    });

    const alerts = response.data.alerts;

    // 格式化输出
    const formatted = alerts.map((alert: any) => ({
      id: alert.id,
      severity: alert.severity,
      message: alert.message,
      service: alert.service,
      time: alert.timestamp,
    }));

    return {
      content: [
        {
          type: 'text',
          text: `找到 ${formatted.length} 个告警:\n\n${JSON.stringify(formatted, null, 2)}`,
        },
      ],
    };
  } catch (error) {
    return {
      content: [
        {
          type: 'text',
          text: `获取失败: ${error}`,
        },
      ],
      isError: true,
    };
  }
}

// 确认告警
export const acknowledgeTool = {
  name: 'acknowledge_alert',
  description: '确认告警',
  inputSchema: {
    type: 'object',
    properties: {
      alertId: {
        type: 'string',
        description: '告警 ID',
      },
      message: {
        type: 'string',
        description: '确认信息',
      },
    },
    required: ['alertId'],
  },
};

export async function handleAcknowledge(args: any) {
  const { alertId, message } = args;

  try {
    await axios.post(`${MONITORING_API}/alerts/${alertId}/acknowledge`, {
      message,
    });

    return {
      content: [
        {
          type: 'text',
          text: `告警 ${alertId} 已确认`,
        },
      ],
    };
  } catch (error) {
    return {
      content: [
        {
          type: 'text',
          text: `确认失败: ${error}`,
        },
      ],
      isError: true,
    };
  }
}
```

---

## Windows 专属

### PowerShell 集成

**使用 PowerShell 脚本作为工具**：

```typescript
// src/tools/powershell.ts

import { exec } from 'child_process';
import { promisify } from 'util';

const execAsync = promisify(exec);

export const powershellTool = {
  name: 'run_powershell',
  description: '执行 PowerShell 命令',
  inputSchema: {
    type: 'object',
    properties: {
      command: {
        type: 'string',
        description: 'PowerShell 命令',
      },
    },
    required: ['command'],
  },
};

export async function handlePowerShell(args: any) {
  const { command } = args;

  try {
    // Windows 上使用 PowerShell
    const { stdout, stderr } = await execAsync(`powershell.exe -Command "${command}"`);

    return {
      content: [
        {
          type: 'text',
          text: stdout || stderr,
        },
      ],
    };
  } catch (error) {
    return {
      content: [
        {
          type: 'text',
          text: `执行失败: ${error}`,
        },
      ],
      isError: true,
    };
  }
}
```

### Windows 服务管理

```typescript
// src/tools/windows-services.ts

export const serviceTools = [
  {
    name: 'list_services',
    description: '列出 Windows 服务',
    inputSchema: {
      type: 'object',
      properties: {},
    },
  },
  {
    name: 'start_service',
    description: '启动 Windows 服务',
    inputSchema: {
      type: 'object',
      properties: {
        name: {
          type: 'string',
          description: '服务名称',
        },
      },
      required: ['name'],
    },
  },
  {
    name: 'stop_service',
    description: '停止 Windows 服务',
    inputSchema: {
      type: 'object',
      properties: {
        name: {
          type: 'string',
          description: '服务名称',
        },
      },
      required: ['name'],
    },
  },
];

export async function handleServiceCommand(tool: string, args: any) {
  try {
    let command = '';

    switch (tool) {
      case 'list_services':
        command = 'Get-Service | Format-Table -AutoSize';
        break;
      case 'start_service':
        command = `Start-Service -Name "${args.name}"`;
        break;
      case 'stop_service':
        command = `Stop-Service -Name "${args.name}" -Force`;
        break;
      default:
        throw new Error(`未知命令: ${tool}`);
    }

    const { exec } = require('child_process');
    const { stdout, stderr } = await new Promise((resolve, reject) => {
      exec(`powershell.exe -Command "${command}"`, (error: any, stdout: string, stderr: string) => {
        if (error) reject(error);
        else resolve({ stdout, stderr });
      });
    });

    return {
      content: [
        {
          type: 'text',
          text: stdout || stderr,
        },
      ],
    };
  } catch (error) {
    return {
      content: [
        {
          type: 'text',
          text: `执行失败: ${error}`,
        },
      ],
      isError: true,
    };
  }
}
```

### Windows 路径处理

```typescript
// src/utils/paths.ts

export function normalizePath(path: string): string {
  // Windows 路径规范化
  if (process.platform === 'win32') {
    // 转换为正斜杠
    path = path.replace(/\\/g, '/');

    // 处理盘符
    path = path.replace(/^([A-Z]):\//i, '/$1/');
  }

  return path;
}

export function resolvePath(path: string): string {
  if (process.platform === 'win32') {
    // Windows 路径
    if (/^[A-Z]:/i.test(path)) {
      return path;
    }
  }

  return path;
}
```

---

## 部署和发布

### 本地部署

**步骤 1: 构建项目**

```bash
npm run build
```

**步骤 2: 配置 Claude Code**

编辑 `~/.claude/settings.json`:

```json
{
  "mcpServers": {
    "my-server": {
      "command": "node",
      "args": ["D:/Projects/my-mcp-server/dist/index.js"],
      "env": {
        "API_KEY": "your-api-key",
        "DB_HOST": "localhost"
      }
    }
  }
}
```

### npm 发布

**步骤 1: 准备 package.json**

```json
{
  "name": "@your-scope/your-mcp-server",
  "version": "1.0.0",
  "description": "Your MCP Server",
  "main": "dist/index.js",
  "bin": {
    "your-mcp-server": "dist/index.js"
  },
  "files": [
    "dist",
    "README.md"
  ],
  "keywords": [
    "mcp",
    "model-context-protocol",
    "claude"
  ]
}
```

**步骤 2: 添加 README**

```markdown
# Your MCP Server

## 安装

\`\`\`bash
npm install -g @your-scope/your-mcp-server
\`\`\`

## 配置

\`\`\`json
{
  "mcpServers": {
    "your-server": {
      "command": "your-mcp-server"
    }
  }
}
\`\`\`

## 工具

- \`tool1\`: 工具描述
- \`tool2\`: 工具描述
```

**步骤 3: 发布**

```bash
# 登录 npm
npm login

# 发布
npm publish --access public
```

### Docker 部署

**Dockerfile**:

```dockerfile
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY . .
RUN npm run build

ENTRYPOINT ["node", "dist/index.js"]
```

**docker-compose.yml**:

```yaml
version: '3.8'

services:
  mcp-server:
    build: .
    environment:
      - API_KEY=${API_KEY}
      - DB_HOST=db
    ports:
      - "3000:3000"
```

---

## 最佳实践

### 1. 错误处理

```typescript
// ✅ 好的错误处理
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  try {
    // 工具逻辑
    const result = await someOperation();
    return {
      content: [{ type: 'text', text: result }],
    };
  } catch (error) {
    // 记录错误
    console.error('Tool execution error:', error);

    // 返回用户友好的错误信息
    return {
      content: [
        {
          type: 'text',
          text: `操作失败: ${error.message}`,
        },
      ],
      isError: true,
    };
  }
});
```

### 2. 输入验证

```typescript
// ✅ 验证输入
function validateInput(args: any, schema: any): void {
  if (!args) {
    throw new Error('缺少参数');
  }

  for (const field of schema.required || []) {
    if (!args[field]) {
      throw new Error(`缺少必需参数: ${field}`);
    }
  }

  // 类型检查
  if (schema.properties) {
    for (const [key, prop] of Object.entries(schema.properties)) {
      if (args[key] && typeof args[key] !== (prop as any).type) {
        throw new Error(`参数 ${key} 类型错误`);
      }
    }
  }
}

// 使用
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  validateInput(request.params.arguments, tool.inputSchema);

  // 继续处理...
});
```

### 3. 资源管理

```typescript
// ✅ 使用连接池
import { Pool } from 'pg';

const pool = new Pool({
  max: 20,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000,
});

// ✅ 清理资源
process.on('SIGINT', async () => {
  await pool.end();
  process.exit(0);
});
```

### 4. 日志记录

```typescript
// src/utils/logger.ts

export enum LogLevel {
  DEBUG = 'DEBUG',
  INFO = 'INFO',
  WARN = 'WARN',
  ERROR = 'ERROR',
}

export function log(level: LogLevel, message: string, data?: any) {
  const timestamp = new Date().toISOString();
  const logEntry = {
    timestamp,
    level,
    message,
    ...(data && { data }),
  };

  // 输出到 stderr（避免干扰 MCP 通信）
  console.error(JSON.stringify(logEntry));
}

// 使用
import { log, LogLevel } from './utils/logger.js';

log(LogLevel.INFO, '服务器启动');
log(LogLevel.ERROR, '工具执行失败', { error: err.message });
```

### 5. 安全考虑

```typescript
// ✅ 验证权限
function checkPermission(user: string, resource: string): boolean {
  // 实现权限检查逻辑
  return true;
}

// ✅ 限制资源访问
const ALLOWED_PATHS = ['/safe/path1', '/safe/path2'];

function isPathAllowed(path: string): boolean {
  return ALLOWED_PATHS.some(allowed => path.startsWith(allowed));
}

// ✅ 敏感数据脱敏
function sanitize(data: any): any {
  if (typeof data === 'string' && data.includes('password')) {
    return '***REDACTED***';
  }
  return data;
}
```

---

## 常见问题

### Q1: MCP 服务器无法启动？

**A**: 检查以下几点：

1. **查看日志**
   ```bash
   # 启动时应该有输出
   node dist/index.js
   ```

2. **检查依赖**
   ```bash
   npm install
   ```

3. **检查构建**
   ```bash
   npm run build
   ```

4. **查看 Claude Code 日志**
   ```bash
   # macOS/Linux
   tail -f ~/Library/Logs/Claude-Code/*.log

   # Windows
   type %APPDATA%\Claude-Code\logs\*.log
   ```

### Q2: 工具调用没有响应？

**A**: 可能的原因：

1. **工具未注册**
   ```typescript
   // 确保注册了工具
   server.setRequestHandler(CallToolRequestSchema, async (request) => {
     // 处理逻辑
   });
   ```

2. **返回格式错误**
   ```typescript
   // 必须返回正确的格式
   return {
     content: [
       {
         type: 'text',
         text: '结果',
       },
     ],
   };
   ```

3. **异常未捕获**
   ```typescript
   // 添加错误处理
   try {
     // 工具逻辑
   } catch (error) {
     return {
       content: [{ type: 'text', text: `错误: ${error}` }],
       isError: true,
     };
   }
   ```

### Q3: 如何调试 MCP 服务器？

**A**: 使用以下方法：

1. **添加日志**
   ```typescript
   console.error('Debug: Request received', request);
   ```

2. **使用调试器**
   ```bash
   # 使用 Node.js 调试器
   node --inspect dist/index.js
   ```

3. **测试工具**
   ```typescript
   // 创建测试脚本
   const testRequest = {
     params: {
       name: 'my_tool',
       arguments: { /* 测试参数 */ },
     },
   };

   const response = await handler(testRequest);
   console.log('Response:', response);
   ```

### Q4: 如何处理异步操作？

**A**: 使用 async/await：

```typescript
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  // ✅ 使用 async/await
  const result1 = await asyncOperation1();
  const result2 = await asyncOperation2(result1);

  return {
    content: [{ type: 'text', text: result2 }],
  };
});

// ✅ 并行执行
const [r1, r2] = await Promise.all([
  asyncOperation1(),
  asyncOperation2(),
]);
```

### Q5: 如何添加身份验证？

**A**: 实现认证机制：

```typescript
// 简单的 API Key 认证
const VALID_KEYS = new Set(process.env.VALID_API_KEYS?.split(',') || []);

function authenticate(request: any): boolean {
  const apiKey = request.params?.apiKey;
  return VALID_KEYS.has(apiKey);
}

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  if (!authenticate(request)) {
    return {
      content: [{ type: 'text', text: '认证失败' }],
      isError: true,
    };
  }

  // 继续处理...
});
```

### Q6: 如何优化性能？

**A**: 性能优化技巧：

1. **缓存结果**
   ```typescript
   const cache = new Map();

   async function getCachedData(key: string) {
     if (cache.has(key)) {
       return cache.get(key);
     }

     const data = await fetchData(key);
     cache.set(key, data);
     return data;
   }
   ```

2. **使用连接池**
   ```typescript
   import { Pool } from 'pg';
   const pool = new Pool({ max: 20 });
   ```

3. **并行处理**
   ```typescript
   const results = await Promise.all(
     items.map(item => processItem(item))
   );
   ```

---

## 故障排查

### 问题 1: "Cannot find module" 错误

**症状**：
```
Error: Cannot find module './tools/database'
```

**解决方案**：
```bash
# 检查文件扩展名
# ✅ 正确
import { foo } from './tools/database.js';

# ❌ 错误
import { foo } from './tools/database';

# 或者在 tsconfig.json 中配置
{
  "compilerOptions": {
    "moduleResolution": "Node16",
    "allowImportingTsExtensions": false
  }
}
```

### 问题 2: 工具列表为空

**症状**：Claude Code 中看不到工具

**诊断**：
```typescript
// 添加调试日志
server.setRequestHandler(ListToolsRequestSchema, async () => {
  const tools = [/* ... */];
  console.error('Tools:', JSON.stringify(tools, null, 2));
  return { tools };
});
```

**解决方案**：
```typescript
// 确保 capabilities 中声明了 tools
const server = new Server(
  { name, version },
  {
    capabilities: {
      tools: {},  // ✅ 必须声明
    },
  }
);
```

### 问题 3: Windows 路径问题

**症状**：文件操作失败

**解决方案**：
```typescript
// 使用正斜杠或 path.join
import path from 'path';

const filePath = path.join('D:', 'Projects', 'file.txt');

// 或规范化路径
const normalized = filePath.replace(/\\/g, '/');
```

---

## 总结

### MCP 服务器的价值

```
自定义 MCP 服务器
    ↓
扩展 Claude Code 能力
    ↓
集成外部系统和数据
    ↓
实现定制化工作流
    ↓
提升团队效率
```

### 学习路径

```
1. 基础服务器
   ├─ 理解 MCP 协议
   ├─ 创建简单工具
   └─ 测试和调试

2. 进阶功能
   ├─ 数据库集成
   ├─ API 调用
   └─ 文件操作

3. 企业级应用
   ├─ 身份验证
   ├─ 错误处理
   ├─ 性能优化
   └─ 部署和发布
```

### 下一步

1. **实践项目**
   - 创建自己的 MCP 服务器
   - 解决实际问题
   - 分享给团队

2. **深入学习**
   - MCP 协议规范
   - TypeScript 高级特性
   - 系统架构设计

3. **社区参与**
   - 分享你的服务器
   - 贡献开源项目
   - 帮助其他开发者

---

## 相关资源

### 官方资源
- [MCP 协议文档](https://modelcontextprotocol.io)
- [MCP SDK](https://github.com/modelcontextprotocol/typescript-sdk)
- [Claude Code 文档](https://claude.ai/code/docs)

### 项目文档
- [MCP 服务器精选](../../skills/c-integration/01-mcp-servers.md) - 现有服务器
- [集成扩展](../../skills/c-integration/) - 更多集成案例

### 示例项目
- [GitHub MCP 服务器](https://github.com/modelcontextprotocol/servers)
- [社区贡献的服务器](https://github.com/topics/mcp-server)

---

**最后更新**: 2026-01-18
**难度**: ⭐⭐⭐⭐⭐
**阅读时间**: 50分钟
**前置要求**: [Level 2 进阶提升](../../skills/), [MCP 服务器精选](../../skills/c-integration/01-mcp-servers.md)
