# MCP Elicitation - 结构化输入请求

> **让 MCP 服务器在工具执行中请求用户输入**

**阅读时间**: 25分钟
**版本**: v2.1.76+
**前置要求**: [自定义 MCP 服务器](./02-custom-mcp-servers.md)、[Hooks 机制](./03-hooks.md)

---

## 目录

- [什么是 MCP Elicitation？](#什么是-mcp-elicitation)
- [工作原理](#工作原理)
- [Elicitation Hooks](#elcitation-hooks)
- [使用场景](#使用场景)
- [实现示例](#实现示例)
- [最佳实践](#最佳实践)
- [常见问题](#常见问题)

---

## 什么是 MCP Elicitation？

### 核心概念

**MCP Elicitation** 是 Claude Code v2.1.76 引入的功能，允许 MCP 服务器在工具执行期间**正式请求结构化输入**。

```
传统工作流:
┌─────────────┐     工具执行     ┌─────────────┐
│  MCP 服务器  │ ───────────────▶ │ Claude Code │
└─────────────┘                  └─────────────┘
                                      │
                                      │ 缺少数据
                                      ▼
                               ⚠️ 工具失败或返回不完整

Elicitation 工作流:
┌─────────────┐     工具执行     ┌─────────────┐
│  MCP 服务器  │ ───────────────▶ │ Claude Code │
└─────────────┘                  └─────────────┘
                                      │
                                      │ Elicitation 请求
                                      ▼
                               ┌─────────────┐
                               │  请求用户输入 │
                               │  (表单/URL)  │
                               └─────────────┘
                                      │
                                      │ 用户提供数据
                                      ▼
                               ┌─────────────┐
                               │  继续执行   │
                               └─────────────┘
```

### 与传统参数的区别

| 方面 | 传统参数 | Elicitation |
|------|---------|-------------|
| **触发时机** | 工具调用前 | 工具执行中 |
| **数据来源** | 预设默认值 | 运行时用户输入 |
| **交互方式** | 无 | 交互式表单/浏览器 |
| **工作流** | 中断式 | 非中断式 |
| **适用场景** | 固定参数 | 动态/复杂数据 |

---

## 工作原理

### Elicitation 请求流程

```
1. MCP 服务器执行工具
2. 发现需要用户输入
3. 发送 elicitation 请求
4. Claude Code 显示表单/打开 URL
5. 用户提供输入
6. 输入传递给 MCP 服务器
7. 工具继续执行
```

### 支持的输入类型

#### 1. 交互式表单

MCP 服务器可以请求显示表单，收集用户输入：

```json
{
  "method": "tools/call",
  "params": {
    "name": "request_user_input",
    "arguments": {
      "formSchema": {
        "type": "object",
        "properties": {
          "ticket_id": {
            "type": "string",
            "description": "Jira 工单 ID"
          },
          "priority": {
            "type": "string",
            "enum": ["low", "medium", "high", "critical"]
          },
          "description": {
            "type": "string",
            "description": "问题描述"
          }
        },
        "required": ["ticket_id", "priority"]
      }
    }
  }
}
```

#### 2. URL 打开

MCP 服务器可以请求在浏览器中打开 URL：

```json
{
  "method": "tools/call",
  "params": {
    "name": "oauth_authenticate",
    "arguments": {
      "openUrl": "https://oauth.provider.com/authorize?client_id=xxx",
      "description": "请在浏览器中完成授权"
    }
  }
}
```

---

## Elicitation Hooks

### 新增的 Hook 类型

v2.1.76 引入了两个新的 Hook：

| Hook | 触发时机 | 用途 |
|------|---------|------|
| `Elicitation` | MCP 请求输入时 | 拦截/处理输入请求 |
| `ElicitationResult` | 用户完成输入后 | 处理/验证用户输入 |

### 配置方式

在 `settings.json` 中配置：

```json
{
  "hooks": {
    "Elicitation": "path/to/handler.sh",
    "ElicitationResult": "path/to/result-handler.sh"
  }
}
```

### Elicitation Hook 示例

```bash
#!/bin/bash
# elicitation-handler.sh

# 接收到的环境变量：
# - ELICITATION_METHOD: 请求的方法名
# - ELICITATION_PARAMS: 请求参数的 JSON 字符串

echo "Received elicitation request for: $ELICITATION_METHOD"
echo "Params: $ELICITATION_PARAMS"

# 可以在这里实现：
# - 自定义表单渲染
# - URL 验证
# - 输入预处理
# - 日志记录

# 返回 0 表示继续默认处理
# 返回非 0 并输出 JSON 表示覆盖响应
exit 0
```

### ElicitationResult Hook 示例

```bash
#!/bin/bash
# result-handler.sh

# 环境变量：
# - ELICITATION_METHOD: 请求的方法名
# - ELICITATION_RESULT: 用户输入结果的 JSON

echo "User provided input for: $ELICITATION_METHOD"
echo "Result: $ELICITATION_RESULT"

# 可以实现：
# - 结果验证
# - 数据转换
# - 审计日志
# - 通知发送

exit 0
```

---

## 使用场景

### 场景 1: OAuth 认证流程

```javascript
// MCP 服务器请求 GitHub OAuth
{
  "method": "tools/call",
  "params": {
    "name": "github_auth",
    "arguments": {
      "openUrl": "https://github.com/login/oauth/authorize?client_id=xxx",
      "description": "请在浏览器中授权 GitHub 访问"
    }
  }
}
```

**工作流**:
1. Claude Code 打开浏览器窗口
2. 用户在浏览器中完成 GitHub OAuth
3. 授权码返回给 MCP 服务器
4. 工具继续执行 API 操作

### 场景 2: 工单系统集成

```javascript
// 创建 JIRA 工单时请求缺失信息
{
  "method": "tools/call",
  "params": {
    "name": "create_jira_ticket",
    "arguments": {
      "formSchema": {
        "type": "object",
        "properties": {
          "title": { "type": "string" },
          "project": {
            "type": "string",
            "enum": ["PROJ", "ENG", "SEC"]
          },
          "labels": {
            "type": "array",
            "items": { "type": "string" }
          }
        },
        "required": ["title", "project"]
      }
    }
  }
}
```

### 场景 3: 数据库确认

```javascript
// 危险操作前的确认
{
  "method": "tools/call",
  "params": {
    "name": "execute_sql",
    "arguments": {
      "confirmation": {
        "message": "即将执行 DELETE 操作，这将从 users 表中删除所有记录",
        "dangerous": true,
        "requiresTyping": "DELETE"
      }
    }
  }
}
```

### 场景 4: 外部服务 Webhook

```javascript
// 等待外部服务回调
{
  "method": "tools/call",
  "params": {
    "name": "payment_process",
    "arguments": {
      "waitForWebhook": {
        "timeout": 300,
        "url": "https://your-app.com/webhook/payment/{transaction_id}",
        "description": "请完成支付，支付完成后页面会自动跳转"
      }
    }
  }
}
```

---

## 实现示例

### MCP 服务器端实现（Node.js）

```javascript
// github-mcp-server/index.js
const { Server } = require('@modelcontextprotocol/sdk/server');
const { CallToolRequestSchema } = require('@modelcontextprotocol/sdk/types');

const server = new Server(
  {
    name: 'github-mcp-server',
    version: '1.0.0',
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

// 声明支持 elicitation
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  if (name === 'create_pull_request') {
    // 检查是否缺少必要信息
    if (!args.title || !args.body) {
      // 返回 elicitation 请求
      return {
        content: [
          {
            type: 'text',
            text: JSON.stringify({
              elicitation: {
                formSchema: {
                  type: 'object',
                  properties: {
                    title: {
                      type: 'string',
                      description: 'PR 标题'
                    },
                    body: {
                      type: 'string',
                      description: 'PR 描述（支持 Markdown）'
                    },
                    targetBranch: {
                      type: 'string',
                      description: '目标分支'
                    }
                  },
                  required: ['title']
                }
              }
            })
          }
        ]
      };
    }

    // 正常执行
    return await createPR(args);
  }

  throw new Error(`Unknown tool: ${name}`);
});

server.start();
```

### 完整示例：JIRA 工单 MCP

```javascript
// jira-mcp-server/index.js
const { Server } = require('@modelcontextprotocol/sdk/server');

const server = new Server({ /* ... */ }, { /* ... */ });

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  switch (name) {
    case 'create_ticket':
      // 验证必填字段
      const missing = [];
      if (!args.summary) missing.push('summary');
      if (!args.project) missing.push('project');

      if (missing.length > 0) {
        // 请求缺失信息
        return {
          content: [{
            type: 'text',
            text: JSON.stringify({
              elicitation: {
                formSchema: {
                  type: 'object',
                  properties: {
                    summary: { type: 'string' },
                    project: {
                      type: 'string',
                      enum: ['PROJ', 'ENG', 'SEC']
                    },
                    description: { type: 'string' },
                    assignee: { type: 'string' }
                  },
                  required: missing
                }
              }
            })
          }]
        };
      }

      return await createJiraTicket(args);

    case 'comment_issue':
      if (!args.issueKey || !args.comment) {
        return {
          content: [{
            type: 'text',
            text: JSON.stringify({
              elicitation: {
                formSchema: {
                  type: 'object',
                  properties: {
                    issueKey: { type: 'string' },
                    comment: { type: 'string' }
                  },
                  required: ['issueKey', 'comment']
                }
              }
            })
          }]
        };
      }
      return await addComment(args);

    default:
      throw new Error(`Unknown tool: ${name}`);
  }
});

server.start();
```

---

## 最佳实践

### 1. 最小化请求

只请求**真正需要**用户提供的信息：

```javascript
// ❌ 过度请求
{
  "formSchema": {
    "properties": {
      "name": { "type": "string" },
      "email": { "type": "string" },
      "phone": { "type": "string" },
      "address": { "type": "string" },
      "company": { "type": "string" },
      "jobTitle": { "type": "string" },
      "department": { "type": "string" }
    }
  }
}

// ✅ 只请求必需的
{
  "formSchema": {
    "properties": {
      "ticketId": { "type": "string" }
    },
    "required": ["ticketId"]
  }
}
```

### 2. 提供合理的默认值

```javascript
// ✅ 使用默认值减少用户输入
{
  "formSchema": {
    "properties": {
      "project": {
        "type": "string",
        "default": "ENG"
      },
      "priority": {
        "type": "string",
        "enum": ["low", "medium", "high"],
        "default": "medium"
      }
    }
  }
}
```

### 3. 清晰的描述

```javascript
// ✅ 描述清晰，帮助用户理解
{
  "formSchema": {
    "properties": {
      "rollbackMode": {
        "type": "boolean",
        "description": "启用后，将创建数据库备份并可随时回滚"
      }
    }
  }
}
```

### 4. 危险操作确认

```javascript
// ✅ 危险操作需要明确确认
{
  "confirmation": {
    "message": "即将执行不可逆的数据库迁移操作",
    "dangerous": true,
    "requiresTyping": "MIGRATE"
  }
}
```

### 5. 超时处理

```javascript
// ✅ 为需要用户交互的操作设置超时
{
  "waitForWebhook": {
    "timeout": 600,  // 10 分钟
    "description": "请在 10 分钟内完成支付"
  }
}
```

---

## 常见问题

### Q1: Elicitation 和普通参数有什么区别？

**A**: 普通参数在工具调用前提供，Elicitation 在工具**执行中**请求。如果工具需要动态数据或用户在工具执行时才能确定的信息，使用 Elicitation。

### Q2: 如何处理用户取消输入？

**A**: 如果用户取消，ElicitationResult Hook 会收到 `cancelled` 状态。MCP 服务器应该优雅处理这种情况。

```javascript
// result-handler.sh
if [ "$ELICITATION_STATUS" = "cancelled" ]; then
  echo "User cancelled the request"
  # 清理资源、通知等
  exit 1
fi
```

### Q3: Elicitation 支持哪些输入类型？

**A**: 支持：
- 文本输入
- 下拉选择
- 复选框
- URL 打开（浏览器）
- 确认对话框

### Q4: 如何调试 Elicitation 请求？

**A**: 使用 Elicitation Hook 记录所有请求：

```bash
#!/bin/bash
# debug-elicitation.sh
echo "$(date): $ELICITATION_METHOD - $ELICITATION_PARAMS" >> ~/elicitation-debug.log
exit 0
```

### Q5: Elicitation 是否支持嵌套对象？

**A**: 是的，JSON Schema 支持完整的嵌套对象定义：

```json
{
  "formSchema": {
    "type": "object",
    "properties": {
      "user": {
        "type": "object",
        "properties": {
          "name": { "type": "string" },
          "email": { "type": "string" }
        }
      },
      "permissions": {
        "type": "array",
        "items": {
          "type": "object",
          "properties": {
            "resource": { "type": "string" },
            "actions": {
              "type": "array",
              "items": { "type": "string" }
            }
          }
        }
      }
    }
  }
}
```

### Q6: 可以自定义表单样式吗？

**A**: 目前不支持自定义表单样式。使用 Claude Code 原生表单组件，保证一致的用户体验。

---

## 相关资源

- [官方文档](https://code.claude.com/docs/en/mcp)
- [MCP 协议规范](https://modelcontextprotocol.io)
- [自定义 MCP 服务器](./02-custom-mcp-servers.md)
- [Hooks 机制](./03-hooks.md)

---

**最后更新**: 2026-03-26
**版本**: v3.7.3
