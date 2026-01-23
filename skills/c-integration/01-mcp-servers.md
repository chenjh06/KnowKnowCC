# 01 - MCP Servers - MCP 服务器精选和配置

> **通过 MCP 协议扩展 Claude Code 的能力边界**

**阅读时间**: 45分钟
**难度**: ⭐⭐⭐⭐
**重要性**: ⭐⭐⭐⭐⭐
**前置要求**: [Level 1 核心掌握](../../guide/)

---

## 目录

- [什么是 MCP 协议](#什么是-mcp-协议)
- [为什么需要 MCP 服务器](#为什么需要-mcp-服务器)
- [MCP 协议工作原理](#mcp-协议工作原理)
- [官方和社区服务器精选](#官方和社区服务器精选)
- [配置指南](#配置指南)
- [多服务器集成](#多服务器集成)
- [优化和调试](#优化和调试)
- [实战案例](#实战案例)
- [Windows 专属](#windows-专属)
- [最佳实践](#最佳实践)
- [常见问题](#常见问题)
- [故障排查](#故障排查)

---

## 什么是 MCP 协议

### 定义

**MCP (Model Context Protocol)** 是一个开放标准协议，用于连接 AI 模型（如 Claude）与外部数据源和工具。

```
传统方式：
AI 模型 → 只能访问训练数据和用户提供的文本

MCP 方式：
AI 模型 → MCP 协议 → 外部世界
                  ├─ 文件系统
                  ├─ 数据库
                  ├─ API 服务
                  ├─ 知识库
                  └─ 自定义工具
```

### 核心特性

#### 1. 标准化接口

```
❌ 传统方式：
每个工具都有自己的 API
→ 学习成本高
→ 集成复杂
→ 难以维护

✅ MCP 方式：
统一的协议标准
→ 学习一次，处处使用
→ 配置简单
→ 易于维护
```

#### 2. 双向通信

```
Claude Code  ←→  MCP Server  ←→  外部服务
     ↓              ↓               ↓
  发送请求      转换和处理        执行操作
     ↓              ↓               ↓
  接收结果      格式化返回        获取数据
```

#### 3. 安全可控

```
安全特性：
✅ 明确的权限控制
✅ 可审计的操作日志
✅ 数据访问范围限制
✅ 错误处理和恢复
```

### MCP 的价值

#### 对用户的价值

```
1. 扩展能力边界
   Claude Code 原生能力
      ↓
   通过 MCP 访问外部工具
      ↓
   成为工作流的核心枢纽

2. 提升工作效率
   手动切换工具
      ↓
   统一的操作界面
      ↓
   效率提升 3-5 倍

3. 个性化定制
   通用的 AI 助手
      ↓
   根据需求配置服务器
      ↓
   专属的工作环境
```

#### 对开发者的价值

```
1. 降低集成成本
   传统方式：每个工具都要开发集成
   MCP 方式：配置即可使用

2. 快速迭代
   标准化协议
   → 易于更新和维护
   → 快速响应用户需求

3. 生态共享
   社区贡献服务器
   → 互相学习和复用
   → 共同建设生态
```

---

## 为什么需要 MCP 服务器

### 传统方式的痛点

#### 痛点 1：工具碎片化

```
❌ 传统工作流：
开发流程涉及多个工具
├─ 代码编辑器（VS Code）
├─ 终端（PowerShell/Bash）
├─ 数据库客户端（DBeaver）
├─ API 测试工具（Postman）
├─ 知识库（Obsidian）
└─ 浏览器（Chrome）

问题：
- 频繁切换上下文
- 数据无法共享
- 操作流程割裂
```

#### 痛点 2：数据孤岛

```
❌ 传统方式：
每个工具都是数据孤岛
├─ 代码在 Git 仓库
├─ 文档在 Wiki
├─ 笔记在 Obsidian
├─ 数据在数据库
└─ 日志在文件系统

AI 无法访问这些数据
→ 只能手动复制粘贴
→ 容易遗漏信息
→ 效率低下
```

#### 痛点 3：能力受限

```
❌ Claude Code 原生限制：
- 只能访问文件系统
- 无法连接数据库
- 无法调用外部 API
- 无法集成知识库

→ 无法成为完整的工作流工具
```

### MCP 解决方案

#### 解决 1：统一工作流

```
✅ MCP 集成工作流：
Claude Code（统一界面）
    ↓
MCP Servers（集成层）
    ├─ 文件系统 MCP
    ├─ 数据库 MCP
    ├─ API MCP
    ├─ Obsidian MCP
    └─ 浏览器 MCP
    ↓
所有工具通过一个界面操作

优势：
- 无缝切换
- 数据共享
- 流程连贯
```

#### 解决 2：打破数据孤岛

```
✅ MCP 数据访问：
Claude Code
    ↓
根据需要动态连接
├─ 搜索代码库
├─ 查询数据库
├─ 检索知识库
└─ 调用 API
    ↓
整合所有相关信息
→ 上下文完整
→ 回答精准
```

#### 解决 3：无限扩展

```
✅ MCP 扩展能力：
核心能力（文件系统）
    ↓
添加 MCP 服务器
├─ SQLite MCP → 数据库操作
├─ Obsidian MCP → 知识管理
├─ Puppeteer MCP → 浏览器自动化
├─ GitHub MCP → 代码仓库
└─ 自定义 MCP → 任何工具
    ↓
能力边界无限扩展
```

### 实际应用场景

#### 场景 1：全栈开发

```
需求：开发一个 CRUD 应用

❌ 传统方式：
1. VS Code 写代码
2. Postman 测试 API
3. DBeaver 查看数据库
4. 浏览器查看前端
5. 反复切换工具

✅ MCP 方式：
Claude Code：
"创建一个用户管理 API，包括：
- 后端：Node.js + Express
- 数据库：SQLite
- 前端：React
- 测试：自动化测试"

Claude 自动：
1. 生成代码（文件系统）
2. 创建数据库（SQLite MCP）
3. 测试 API（Browser MCP）
4. 查询数据（Database MCP）

全程在一个界面完成！
```

#### 场景 2：知识库写作

```
需求：写一篇技术文章，引用个人笔记

❌ 传统方式：
1. Obsidian 搜索笔记
2. 手动复制内容
3. 粘贴到编辑器
4. 重复多次

✅ MCP 方式：
Claude Code：
"我要写一篇关于微服务架构的文章，
请参考我的 Obsidian 笔记"

Claude 自动：
1. 搜索相关笔记（Obsidian MCP）
2. 提取关键内容
3. 整合到文章
4. 保持引用关系

一键完成！
```

#### 场景 3：数据分析

```
需求：分析数据库中的用户行为数据

❌ 传统方式：
1. DBeaver 连接数据库
2. 手动写 SQL
3. 导出 CSV
4. Excel 分析
5. 生成图表

✅ MCP 方式：
Claude Code：
"分析上个月的用户注册趋势，
生成可视化报告"

Claude 自动：
1. 连接数据库（PostgreSQL MCP）
2. 执行查询
3. 分析数据
4. 生成图表（代码）
5. 输出报告

全自动化！
```

---

## MCP 协议工作原理

### 系统架构

```
┌─────────────────────────────────────────────┐
│          Claude Code（客户端）               │
│                                              │
│  ┌────────────────────────────────────────┐ │
│  │   你的对话                              │ │
│  │   "查询数据库中的用户数据"              │ │
│  └──────────────┬─────────────────────────┘ │
└─────────────────┼───────────────────────────┘
                  ↓
         ┌────────────────┐
         │  MCP 协议层    │  ← 统一的通信标准
         └────────┬───────┘
                  ↓
┌─────────────────────────────────────────────┐
│       MCP Server（服务器端）                 │
│                                              │
│  ┌────────────────────────────────────────┐ │
│  │   协议处理器                            │ │
│  │   - 解析请求                            │ │
│  │   - 调用工具                            │ │
│  │   - 格式化响应                          │ │
│  └──────────────┬─────────────────────────┘ │
│                 ↓                            │
│  ┌────────────────────────────────────────┐ │
│  │   工具集（Tools）                       │ │
│  │   ├── query_database                   │ │
│  │   ├── read_file                        │ │
│  │   ├── write_file                       │ │
│  │   └── ...                              │ │
│  └──────────────┬─────────────────────────┘ │
└─────────────────┼───────────────────────────┘
                  ↓
┌─────────────────────────────────────────────┐
│         外部服务（资源层）                    │
│                                              │
│  ├── 文件系统                               │
│  ├── 数据库                                 │
│  ├── API 服务                               │
│  └── 其他工具                               │
└─────────────────────────────────────────────┘
```

### 通信流程

```
1. 用户发起请求
   你："查询数据库中的用户数据"

2. Claude Code 识别需求
   - 需要数据库访问
   - 确定 MCP 服务器
   - 构造 MCP 请求

3. MCP 协议传输
   {
     "server": "database-mcp",
     "tool": "query",
     "params": {
       "sql": "SELECT * FROM users"
     }
   }

4. MCP Server 处理
   - 接收请求
   - 验证权限
   - 执行操作
   - 返回结果

5. 结果返回 Claude
   {
     "success": true,
     "data": [...],
     "meta": {...}
   }

6. Claude 生成回答
   "找到 100 个用户..."
```

### 核心组件

#### 1. MCP Client（Claude Code）

**职责**：
- 发起 MCP 请求
- 管理服务器连接
- 处理响应数据
- 错误处理和重试

**位置**：内置在 Claude Code 中

#### 2. MCP Server

**职责**：
- 实现 MCP 协议
- 提供工具集（Tools）
- 处理业务逻辑
- 管理外部资源

**类型**：
- 官方服务器（Anthropic 维护）
- 社区服务器（第三方贡献）
- 自定义服务器（自己开发）

#### 3. MCP Protocol

**核心方法**：

```
tools/list
├─ 列出可用工具
└─ 返回工具描述

tools/call
├─ 调用特定工具
└─ 传递参数和接收结果

resources/list
├─ 列出可用资源
└─ 返回资源描述

resources/read
├─ 读取资源内容
└─ 返回数据

prompts/list
├─ 列出可用提示
└─ 返回提示描述

prompts/get
├─ 获取提示内容
└─ 返回完整提示
```

### 数据流向

```
┌─────────────────────────────────────────────────┐
│                  数据流向图                      │
└─────────────────────────────────────────────────┘

用户输入
    ↓
Claude Code 理解意图
    ↓
判断：需要外部数据？
    ├─ 否 → 直接回答
    └─ 是 → 发起 MCP 请求
           ↓
      选择 MCP 服务器
           ↓
      调用工具（tools/call）
           ↓
      MCP Server 执行
           ├─ 读取文件
           ├─ 查询数据库
           ├─ 调用 API
           └─ 其他操作
           ↓
      返回结果（JSON）
           ↓
      Claude Code 整合
           ↓
      生成最终回答
           ↓
      呈现给用户
```

---

## 官方和社区服务器精选

### 服务器分类

```
MCP 服务器生态
├─ 官方服务器（由 Anthropic 维护）
│   ├─ 文件系统（filesystem）
│   ├─ SQLite（sqlite）
│   └─ 其他官方工具
│
├─ 社区服务器（由社区贡献）
│   ├─ 数据库类
│   ├─ 知识管理类
│   ├─ 开发工具类
│   ├─ API 集成类
│   └─ 自动化类
│
└─ 自定义服务器
    └─ 根据需求开发
```

### 官方服务器

#### 1. Filesystem MCP（文件系统）

**用途**：访问本地文件系统

**能力**：
```
✅ 读取文件
✅ 写入文件
✅ 列出目录
✅ 搜索文件
✅ 文件元数据
```

**适用场景**：
- 代码分析和生成
- 配置文件管理
- 日志分析
- 批量文件操作

**配置示例**：
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "D:/Projects"]
    }
  }
}
```

#### 2. SQLite MCP

**用途**：访问 SQLite 数据库

**能力**：
```
✅ 执行 SQL 查询
✅ 读取表结构
✅ 创建/修改表
✅ 事务处理
```

**适用场景**：
- 本地数据存储
- 应用数据管理
- 数据分析
- 快速原型

**配置示例**：
```json
{
  "mcpServers": {
    "sqlite": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sqlite", "--db-path", "./data.db"]
    }
  }
}
```

### 社区服务器精选

#### 数据库类

##### 1. PostgreSQL MCP ⭐⭐⭐⭐⭐

**仓库**：`modelcontextprotocol/servers/tree/main/src/postgres`

**用途**：访问 PostgreSQL 数据库

**能力**：
```
✅ 执行 SQL 查询
✅ 读取表结构
✅ 查看表关系
✅ 性能监控
```

**适用场景**：
- 生产数据库查询
- 数据分析
- 报表生成
- 数据库维护

**配置示例**：
```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "POSTGRES_CONNECTION_STRING": "postgresql://user:password@localhost:5432/dbname"
      }
    }
  }
}
```

**优先级**：⭐⭐⭐⭐⭐（最常用）

---

##### 2. MySQL MCP ⭐⭐⭐⭐

**仓库**：`modelcontextprotocol/servers/tree/main/src/mysql`

**用途**：访问 MySQL/MariaDB 数据库

**能力**：
```
✅ 执行 SQL 查询
✅ 读取表结构
✅ 查看索引
✅ 慢查询分析
```

**配置示例**：
```json
{
  "mcpServers": {
    "mysql": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-mysql"],
      "env": {
        "MYSQL_CONNECTION_STRING": "mysql://user:password@localhost:3306/dbname"
      }
    }
  }
}
```

---

#### 知识管理类

##### 3. Obsidian Knowledge MCP ⭐⭐⭐⭐⭐

**仓库**：[参考本项目完整方案](../../Obsidian知识库集成完整方案.md)

**用途**：集成 Obsidian 知识库

**能力**：
```
✅ 全文搜索（Fuse.js）
✅ 标签检索
✅ 链接追踪
✅ 上下文注入
✅ 知识图谱
```

**适用场景**：
- 学习助手
- 写作辅助
- 工作支持
- 知识管理

**优先级**：⭐⭐⭐⭐⭐（详见 `02-obsidian-integration.md`）

---

#### 开发工具类

##### 4. GitHub MCP ⭐⭐⭐⭐

**仓库**：`modelcontextprotocol/servers/tree/main/src/github`

**用途**：访问 GitHub API

**能力**：
```
✅ 搜索代码
✅ 读取仓库文件
✅ 查看 Issues/PRs
✅ 管理仓库
```

**适用场景**：
- 代码搜索
- 开源项目协作
- 仓库管理
- CI/CD 集成

**配置示例**：
```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "your_github_token"
      }
    }
  }
}
```

---

##### 5. Git MCP ⭐⭐⭐

**仓库**：`modelcontextprotocol/servers/tree/main/src/git`

**用途**：访问 Git 仓库

**能力**：
```
✅ 查看提交历史
✅ 比较分支差异
✅ 读取文件内容
✅ 搜索代码
```

**适用场景**：
- 代码审查
- 版本管理
- 历史分析

---

#### API 集成类

##### 6. Puppeteer/Playwright MCP ⭐⭐⭐⭐

**仓库**：`modelcontextprotocol/servers/tree/main/src/puppeteer`

**用途**：浏览器自动化

**能力**：
```
✅ 自动化浏览
✅ 截图和 PDF
✅ 表单填充
✅ 数据抓取
✅ 自动化测试
```

**适用场景**：
- Web 自动化测试
- 数据抓取
- UI 截图
- 表单自动化

**优先级**：⭐⭐⭐⭐（详见 `03-browser-automation.md`）

---

##### 7. Brave Search MCP ⭐⭐⭐

**仓库**：`modelcontextprotocol/servers/tree/main/src/brave-search`

**用途**：网络搜索

**能力**：
```
✅ 网页搜索
✅ 新闻搜索
✅ 搜索结果摘要
```

**适用场景**：
- 实时信息查询
- 新闻检索
- 资料收集

---

#### 自动化类

##### 8. Memory MCP ⭐⭐⭐⭐

**仓库**：`modelcontextprotocol/servers/tree/main/src/memory`

**用途**：持久化对话记忆

**能力**：
```
✅ 保存对话
✅ 检索记忆
✅ 语义搜索
✅ 记忆管理
```

**适用场景**：
- 长期项目跟踪
- 知识积累
- 上下文保持

---

### 服务器选择建议

#### 按使用场景

```
开发场景：
├─ 文件系统 MCP（必需）✅
├─ Git MCP（代码管理）
└─ GitHub MCP（协作）

数据场景：
├─ SQLite MCP（本地数据）
├─ PostgreSQL MCP（生产数据）
└─ MySQL MCP（备选）

知识管理：
└─ Obsidian MCP（强烈推荐）✅

自动化：
├─ Puppeteer MCP（浏览器）
└─ Memory MCP（对话记忆）
```

#### 按优先级

```
🥇 第一优先（立即安装）：
✅ Filesystem MCP（文件系统）
✅ Obsidian MCP（知识管理）

🥈 第二优先（按需安装）：
⭐ PostgreSQL/MySQL MCP（数据库）
⭐ GitHub MCP（代码协作）

🥉 第三优先（可选）：
⭐ Puppeteer MCP（浏览器自动化）
⭐ Memory MCP（对话记忆）
```

---

## 配置指南

### 基础配置

#### 配置文件位置

```
Windows:
%USERPROFILE%\.claude\mcp_servers.json

macOS/Linux:
~/.claude/mcp_servers.json
```

#### 配置文件结构

```json
{
  "mcpServers": {
    "server-name": {
      "command": "运行命令",
      "args": ["参数数组"],
      "env": {
        "环境变量": "值"
      }
    }
  }
}
```

### 配置示例

#### 示例 1：单服务器配置

**Filesystem MCP**：

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "D:/Projects"]
    }
  }
}
```

**说明**：
- `command`: 运行命令（`npx`）
- `args`: 参数数组
  - `-y`: 自动确认安装
  - 服务器包名
  - 服务器参数（项目路径）

---

#### 示例 2：多服务器配置

**完整配置**：

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "D:/Projects"]
    },
    "sqlite": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sqlite", "--db-path", "./data.db"]
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "POSTGRES_CONNECTION_STRING": "postgresql://user:password@localhost:5432/dbname"
      }
    },
    "obsidian": {
      "command": "node",
      "args": ["D:/AIWork/claude_code/work/knowknowcc/obsidian-knowledge-base/dist/index.js"],
      "env": {
        "VAULT_PATH": "C:\\Users\\YourName\\Documents\\MyVault"
      }
    }
  }
}
```

---

### 环境变量配置

#### 常用环境变量

| 服务器 | 环境变量 | 说明 | 示例 |
|--------|---------|------|------|
| PostgreSQL | `POSTGRES_CONNECTION_STRING` | 数据库连接字符串 | `postgresql://user:pass@localhost:5432/db` |
| MySQL | `MYSQL_CONNECTION_STRING` | 数据库连接字符串 | `mysql://user:pass@localhost:3306/db` |
| GitHub | `GITHUB_TOKEN` | GitHub 个人访问令牌 | `ghp_xxxxxxxxxxxx` |
| Obsidian | `VAULT_PATH` | Vault 路径 | `C:\\Users\\...\\MyVault` |

#### 安全建议

```
❌ 避免：
- 直接在配置文件中写入敏感信息
- 将配置文件提交到 Git

✅ 推荐：
- 使用环境变量文件（.env）
- 系统环境变量
- 密钥管理工具
```

**Windows 环境变量设置**：

```powershell
# 设置用户环境变量
[System.Environment]::SetEnvironmentVariable('POSTGRES_CONNECTION_STRING', 'postgresql://user:password@localhost:5432/dbname', 'User')

# 设置系统环境变量（需要管理员权限）
[System.Environment]::SetEnvironmentVariable('POSTGRES_CONNECTION_STRING', 'postgresql://user:password@localhost:5432/dbname', 'Machine')
```

---

### 高级配置选项

#### 选项 1：自定义服务器路径

```json
{
  "mcpServers": {
    "custom-server": {
      "command": "node",
      "args": ["D:/Projects/my-mcp-server/dist/index.js"],
      "cwd": "D:/Projects/my-mcp-server"
    }
  }
}
```

**说明**：
- `command`: 使用 `node` 运行本地服务器
- `args`: 服务器文件路径
- `cwd`: 工作目录（可选）

---

#### 选项 2：多工作目录

```json
{
  "mcpServers": {
    "filesystem-project-a": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "D:/Projects/Project-A"]
    },
    "filesystem-project-b": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "D:/Projects/Project-B"]
    }
  }
}
```

---

#### 选项 3：条件配置

```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "POSTGRES_CONNECTION_STRING": {
          "production": "postgresql://user:pass@prod-host:5432/db",
          "development": "postgresql://user:pass@localhost:5432/db"
        }
      }
    }
  }
}
```

---

## 多服务器集成

### 集成策略

#### 策略 1：功能互补

```
场景：全栈开发工作流

服务器组合：
├─ Filesystem MCP（代码操作）
├─ SQLite MCP（本地数据）
├─ Obsidian MCP（知识库）
└─ Puppeteer MCP（测试）

工作流：
1. Filesystem: 创建项目文件
2. SQLite: 初始化数据库
3. Obsidian: 查询最佳实践
4. Puppeteer: 自动化测试
```

#### 策略 2：数据源整合

```
场景：综合数据分析

服务器组合：
├─ PostgreSQL MCP（生产数据）
├─ MySQL MCP（历史数据）
├─ Filesystem MCP（日志文件）
└─ Memory MCP（历史分析）

工作流：
1. PostgreSQL: 查询当前数据
2. MySQL: 对比历史数据
3. Filesystem: 分析日志
4. Memory: 参考之前的分析
```

#### 策略 3：环境隔离

```
场景：多环境开发

服务器组合：
├─ postgres-dev（开发环境）
├─ postgres-staging（测试环境）
└─ postgres-prod（生产环境）

使用方式：
你："查询开发环境的用户数据"
Claude：[使用 postgres-dev]

你："查询生产环境的用户数据"
Claude：[使用 postgres-prod]
```

### 实战集成案例

#### 案例 1：开发工作流集成

**目标**：完整的开发流程自动化

**服务器配置**：

```json
{
  "mcpServers": {
    "fs-code": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "D:/Projects/myapp"]
    },
    "db-dev": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sqlite", "--db-path", "./dev.db"]
    },
    "obsidian-kb": {
      "command": "node",
      "args": ["D:/.../obsidian-knowledge-base/dist/index.js"],
      "env": {
        "VAULT_PATH": "C:\\Users\\...\\MyVault"
      }
    }
  }
}
```

**使用示例**：

```
你："创建一个用户管理 API，参考我的笔记"

Claude：
1. [Obsidian] 搜索"REST API 最佳实践"
   → 找到 3 篇相关笔记

2. [Filesystem] 创建项目结构
   ├── src/
   │   ├── routes/users.js
   │   ├── controllers/userController.js
   │   └── models/User.js
   └── tests/

3. [SQLite] 初始化数据库
   CREATE TABLE users (
     id INTEGER PRIMARY KEY,
     name TEXT,
     email TEXT UNIQUE
   );

4. [Obsidian] 查询"常见安全问题"
   → 找到 SQL 注入防护笔记

5. [Filesystem] 生成安全代码
   → 参数化查询
   → 输入验证
   → 错误处理

完成！✅
```

---

#### 案例 2：知识库 + 数据库集成

**目标**：基于知识库的智能数据分析

**服务器配置**：

```json
{
  "mcpServers": {
    "postgres-analytics": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "POSTGRES_CONNECTION_STRING": "postgresql://analytics:password@localhost:5432/analytics"
      }
    },
    "obsidian-reports": {
      "command": "node",
      "args": ["D:/.../obsidian-knowledge-base/dist/index.js"],
      "env": {
        "VAULT_PATH": "C:\\Users\\...\\ReportsVault"
      }
    }
  }
}
```

**使用示例**：

```
你："生成上个月的用户增长报告，参考之前的报告格式"

Claude：
1. [Obsidian] 搜索"用户增长报告"
   → 找到之前的报告模板

2. [PostgreSQL] 查询数据
   SELECT
     DATE(created_at) as date,
     COUNT(*) as new_users
   FROM users
   WHERE created_at >= NOW() - INTERVAL '1 month'
   GROUP BY DATE(created_at);

3. [Obsidian] 查询"数据可视化最佳实践"
   → 找到图表推荐

4. 生成报告
   - 数据表格
   - 趋势图（生成 Python/Matplotlib 代码）
   - 分析结论
   - 对比历史数据

完成！✅
```

---

### 服务器协作模式

#### 模式 1：串行协作

```
步骤 1 → 服务器 A
    ↓
步骤 2 → 服务器 B
    ↓
步骤 3 → 服务器 C
```

**示例**：
```
1. Obsidian: 搜索最佳实践
2. Filesystem: 创建代码文件
3. SQLite: 初始化数据
```

#### 模式 2：并行协作

```
      ┌─ 服务器 A
      ↓
步骤 1
      ↓
      ├─ 服务器 B
      └─ 服务器 C
```

**示例**：
```
你："搜索所有可用的信息"

Claude 并行调用：
1. Obsidian: 搜索笔记
2. Filesystem: 搜索代码
3. PostgreSQL: 查询数据

整合结果：✅
```

#### 模式 3：条件分支

```
条件判断
    ├─ 满足 → 服务器 A
    └─ 不满足 → 服务器 B
```

**示例**：
```
你："这个功能在哪个环境有问题？"

Claude 判断：
1. 如果是开发环境 → 查询 dev-server 日志
2. 如果是生产环境 → 查询 prod-server 日志
3. 如果都不确定 → 并行查询所有环境
```

---

## 优化和调试

### 性能优化

#### 优化 1：减少服务器数量

```
❌ 过度配置：
10+ 个 MCP 服务器
→ 内存占用高
→ 启动慢
→ 管理复杂

✅ 合理配置：
3-5 个核心服务器
→ 快速响应
→ 易于维护
```

**建议**：
- 只保留常用的服务器
- 按需启用/禁用
- 使用条件配置

---

#### 优化 2：缓存策略

```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "POSTGRES_CONNECTION_STRING": "postgresql://user:pass@localhost:5432/db",
        "CACHE_ENABLED": "true",
        "CACHE_TTL": "300"
      }
    }
  }
}
```

**说明**：
- `CACHE_ENABLED`: 启用缓存
- `CACHE_TTL`: 缓存过期时间（秒）

---

#### 优化 3：连接池

```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "POSTGRES_CONNECTION_STRING": "postgresql://user:pass@localhost:5432/db",
        "POOL_SIZE": "10",
        "CONNECTION_TIMEOUT": "30"
      }
    }
  }
}
```

**说明**：
- `POOL_SIZE`: 连接池大小
- `CONNECTION_TIMEOUT`: 连接超时（秒）

---

### 调试技巧

#### 技巧 1：启用调试日志

**PowerShell（Windows）**：
```powershell
# 设置环境变量
$env:DEBUG = "mcp:*"

# 启动 Claude Code
claude-code
```

**日志输出示例**：
```
[mcp:filesystem] Connecting to server...
[mcp:filesystem] Server connected
[mcp:filesystem] Tool called: read_file
[mcp:filesystem] File read successfully: 1024 bytes
```

---

#### 技巧 2：测试服务器连接

**手动测试**：

```powershell
# 测试 PostgreSQL MCP
npx -y @modelcontextprotocol/server-postgres

# 测试 Filesystem MCP
npx -y @modelcontextprotocol/server-filesystem D:/Projects

# 测试 Obsidian MCP
node D:/.../obsidian-knowledge-base/dist/index.js
```

---

#### 技巧 3：验证配置

**JSON 验证工具**：

```powershell
# 验证 JSON 格式
Get-Content $env:USERPROFILE\.claude\mcp_servers.json | ConvertFrom-Json

# 如果有错误，会显示详细信息
```

**常见错误**：
- 缺少逗号
- 路径引号错误
- 环境变量格式错误

---

### 错误处理

#### 错误 1：服务器启动失败

**症状**：
```
Error: Failed to start MCP server
```

**诊断步骤**：

1. **检查命令是否正确**
   ```powershell
   npx -y @modelcontextprotocol/server-filesystem
   ```

2. **检查参数是否有效**
   ```powershell
   Test-Path "D:/Projects"  # 应该返回 True
   ```

3. **查看详细日志**
   ```powershell
   $env:DEBUG = "mcp:*"
   claude-code
   ```

**解决方案**：
- 修正命令或参数
- 重新安装服务器包
- 检查权限设置

---

#### 错误 2：连接超时

**症状**：
```
Error: Connection timeout
```

**原因**：
- 服务器启动慢
- 网络延迟
- 资源不足

**解决方案**：

**方案 1：增加超时时间**
```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "CONNECTION_TIMEOUT": "60"  // 增加到 60 秒
      }
    }
  }
}
```

**方案 2：优化服务器性能**
- 升级硬件
- 减少并发连接
- 使用缓存

---

#### 错误 3：权限拒绝

**症状**：
```
Error: Permission denied
```

**解决方案**：

**Windows**：
```powershell
# 以管理员身份运行
# 或者添加文件夹权限
$acl = Get-Acl "D:/Projects"
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
    $env:USERNAME,
    "FullControl",
    "Allow"
)
$acl.SetAccessRule($accessRule)
Set-Acl "D:/Projects" $acl
```

---

## 实战案例

### 案例 1：全栈应用开发 ⭐⭐⭐⭐⭐

#### 场景描述

开发一个完整的 Todo 应用，包括：
- 前端：React
- 后端：Node.js + Express
- 数据库：PostgreSQL
- 测试：自动化测试

#### 服务器配置

```json
{
  "mcpServers": {
    "fs-project": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "D:/Projects/todo-app"]
    },
    "db-dev": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "POSTGRES_CONNECTION_STRING": "postgresql://todo:password@localhost:5432/todo_dev"
      }
    },
    "obsidian-kb": {
      "command": "node",
      "args": ["D:/.../obsidian-knowledge-base/dist/index.js"],
      "env": {
        "VAULT_PATH": "C:\\Users\\...\\MyVault"
      }
    }
  }
}
```

#### 实施步骤

**步骤 1：项目初始化**

```
你："创建一个 Todo 应用的项目结构，参考最佳实践"

Claude：
1. [Obsidian] 搜索"Node.js 项目结构"
   → 找到《Node.js 最佳实践》笔记

2. [Filesystem] 创建目录结构
   todo-app/
   ├── src/
   │   ├── routes/
   │   ├── controllers/
   │   ├── models/
   │   └── middleware/
   ├── tests/
   ├── package.json
   └── README.md

3. [Filesystem] 生成 package.json
   {
     "name": "todo-app",
     "version": "1.0.0",
     "dependencies": {
       "express": "^4.18.0",
       "pg": "^8.11.0"
     },
     "devDependencies": {
       "jest": "^29.0.0",
       "supertest": "^6.3.0"
     }
   }

完成！✅
```

---

**步骤 2：数据库设计**

```
你："设计数据库表结构"

Claude：
1. [Obsidian] 搜索"数据库设计规范"
   → 找到《数据库范式和最佳实践》

2. [PostgreSQL] 创建表
   CREATE TABLE todos (
     id SERIAL PRIMARY KEY,
     title VARCHAR(255) NOT NULL,
     description TEXT,
     completed BOOLEAN DEFAULT FALSE,
     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
     updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
   );

3. [PostgreSQL] 添加索引
   CREATE INDEX idx_todos_completed ON todos(completed);
   CREATE INDEX idx_todos_created_at ON todos(created_at);

完成！✅
```

---

**步骤 3：API 开发**

```
你："创建 CRUD API，参考安全最佳实践"

Claude：
1. [Obsidian] 搜索"REST API 安全"
   → 找到《API 安全检查清单》

2. [Filesystem] 创建路由文件
   src/routes/todos.js
   ├── GET    /api/todos        # 列表
   ├── GET    /api/todos/:id    # 详情
   ├── POST   /api/todos        # 创建
   ├── PUT    /api/todos/:id    # 更新
   └── DELETE /api/todos/:id    # 删除

3. [Filesystem] 创建控制器
   src/controllers/todoController.js
   - 参数验证
   - SQL 注入防护（参数化查询）
   - 错误处理

4. [Filesystem] 创建测试
   tests/api.test.js
   - 单元测试
   - 集成测试

完成！✅
```

---

**步骤 4：前端开发**

```
你："创建 React 前端，包括组件和状态管理"

Claude：
1. [Obsidian] 搜索"React 项目结构"
   → 找到《React 最佳实践》

2. [Filesystem] 创建 React 组件
   src/
   ├── components/
   │   ├── TodoList.js
   │   ├── TodoItem.js
   │   └── TodoForm.js
   ├── hooks/
   │   └── useTodos.js
   └── App.js

3. [Filesystem] 实现状态管理
   - 使用 React Context
   - 自定义 Hook（useTodos）
   - API 调用封装

完成！✅
```

---

#### 效果对比

| 维度 | 传统方式 | MCP 集成方式 |
|------|---------|-------------|
| **工具切换** | VS Code → DBeaver → Postman | Claude Code 统一界面 |
| **知识查询** | Google 搜索 → 手动筛选 | Obsidian 自动检索 |
| **代码生成** | 手动编写 | AI 自动生成 |
| **数据库操作** | DBeaver 手动执行 | PostgreSQL MCP |
| **测试** | 手动编写和运行 | AI 生成测试代码 |
| **总时间** | 4-6 小时 | 1-2 小时 |

**效率提升**：⚡ 3-5 倍

---

### 案例 2：数据分析和报告 ⭐⭐⭐⭐

#### 场景描述

分析电商平台的用户行为数据，生成可视化报告。

#### 服务器配置

```json
{
  "mcpServers": {
    "postgres-analytics": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "POSTGRES_CONNECTION_STRING": "postgresql://analytics:password@localhost:5432/ecommerce"
      }
    },
    "obsidian-reports": {
      "command": "node",
      "args": ["D:/.../obsidian-knowledge-base/dist/index.js"],
      "env": {
        "VAULT_PATH": "C:\\Users\\...\\ReportsVault"
      }
    },
    "fs-outputs": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "D:/Reports"]
    }
  }
}
```

#### 实施步骤

**步骤 1：数据查询**

```
你："分析上个月的用户注册和购买行为"

Claude：
1. [PostgreSQL] 查询注册数据
   SELECT
     DATE(created_at) as date,
     COUNT(*) as new_users
   FROM users
   WHERE created_at >= DATE_TRUNC('month', CURRENT_DATE)
   GROUP BY DATE(created_at)
   ORDER BY date;

   结果：
   date        | new_users
   ------------+-----------
   2024-12-01  | 45
   2024-12-02  | 52
   ...

2. [PostgreSQL] 查询购买数据
   SELECT
     DATE(o.created_at) as date,
     COUNT(*) as orders,
     SUM(o.total_amount) as revenue
   FROM orders o
   WHERE o.created_at >= DATE_TRUNC('month', CURRENT_DATE)
   GROUP BY DATE(o.created_at)
   ORDER BY date;

   结果：
   date        | orders | revenue
   ------------+--------+--------
   2024-12-01  | 23     | 3450.00
   2024-12-02  | 31     | 4650.00
   ...
```

---

**步骤 2：参考报告模板**

```
你："参考之前的报告格式"

Claude：
1. [Obsidian] 搜索"用户行为报告"
   → 找到《2024年11月用户行为分析报告》

2. [Obsidian] 提取报告结构
   - 执行摘要
   - 用户增长趋势
   - 购买行为分析
   - 关键指标
   - 可视化图表
   - 结论和建议
```

---

**步骤 3：生成可视化**

```
你："生成数据可视化代码"

Claude：
1. [Obsidian] 搜索"数据可视化最佳实践"
   → 找到《Python 数据可视化》笔记

2. [Filesystem] 生成 Python 代码
   import matplotlib.pyplot as plt
   import pandas as pd

   # 数据
   dates = ['2024-12-01', '2024-12-02', ...]
   new_users = [45, 52, ...]
   revenue = [3450, 4650, ...]

   # 创建图表
   fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(12, 10))

   # 用户增长趋势
   ax1.plot(dates, new_users, marker='o')
   ax1.set_title('Daily New Users')
   ax1.set_xlabel('Date')
   ax1.set_ylabel('Count')

   # 收入趋势
   ax2.plot(dates, revenue, marker='s', color='green')
   ax2.set_title('Daily Revenue')
   ax2.set_xlabel('Date')
   ax2.set_ylabel('Amount ($)')
   ax2.format_xdata = lambda x: f"${x:,.0f}"

   plt.tight_layout()
   plt.savefig('user_behavior_report.png')

完成！✅
```

---

**步骤 4：生成完整报告**

```
你："整合所有内容，生成完整报告"

Claude：
1. [整合数据]
   - 用户增长：+23%
   - 收入增长：+31%
   - 转化率：2.3%

2. [生成分析结论]
   - 用户增长稳定
   - 收入增长超过用户增长
   - 转化率有提升空间

3. [Filesystem] 保存报告
   D:/Reports/2024-12-user-behavior-analysis.md

4. [PostgreSQL] 保存到数据库（可选）
   INSERT INTO reports (name, created_at, file_path)
   VALUES ('2024年12月用户行为分析', NOW(), 'D:/Reports/...');

完成！✅
```

---

### 案例 3：知识库驱动的开发 ⭐⭐⭐⭐⭐

#### 场景描述

基于个人知识库的经验，快速解决技术问题。

#### 服务器配置

```json
{
  "mcpServers": {
    "obsidian-kb": {
      "command": "node",
      "args": ["D:/.../obsidian-knowledge-base/dist/index.js"],
      "env": {
        "VAULT_PATH": "C:\\Users\\...\\MyVault"
      }
    },
    "fs-current": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "D:/Projects/current-project"]
    },
    "github-search": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "your_token"
      }
    }
  }
}
```

#### 实施步骤

**步骤 1：遇到问题**

```
你："Node.js 高并发场景下，内存泄漏怎么办？"

Claude：
1. [Obsidian] 搜索"内存泄漏"
   → 找到《Node.js 性能优化实战》笔记

2. [Obsidian] 注入笔记内容（1,234 tokens）
   《Node.js 性能优化实战》

   问题背景：
   在处理 10,000 QPS 的并发请求时，
   内存使用率持续增长...

   常见原因：
   1. 未清理的事件监听器
   2. 闭包导致的大对象引用
   3. 缓存无限增长

   解决方案：
   ...
```

---

**步骤 2：应用解决方案**

```
你："帮我排查当前项目的内存泄漏"

Claude：
1. [Filesystem] 检查代码
   - 搜索未清理的事件监听器
   - 检查缓存实现
   - 查找大对象引用

2. [基于 Obsidian 笔记]
   发现问题：
   ❌ EventEmitter 未移除监听器
   ❌ LRU Cache 未设置最大大小

3. [Filesystem] 生成修复代码
   // 修复前
   eventEmitter.on('data', handleData);

   // 修复后
   const handleDataWrapper = (...args) => handleData(...args);
   eventEmitter.on('data', handleDataWrapper);
   // 清理时
   eventEmitter.off('data', handleDataWrapper);

   // 修复前
   const cache = new LRU.Cache();

   // 修复后
   const cache = new LRU.Cache({
     max: 500,  // 最大 500 条
     ttl: 1000 * 60 * 5  // 5 分钟过期
   });

完成！✅
```

---

**步骤 3：验证和测试**

```
你："生成内存泄漏测试代码"

Claude：
1. [Obsidian] 搜索"内存测试"
   → 找到《Node.js 测试最佳实践》

2. [Filesystem] 生成测试代码
   const memoryLeaks = require('memory-leaks');

   describe('Memory Leak Tests', () => {
     it('should not leak memory in event handler', async () => {
       const initialMemory = process.memoryUsage().heapUsed;

       // 创建和销毁 1000 次
       for (let i = 0; i < 1000; i++) {
         const handler = createHandler();
         handler.cleanup();
       }

       const finalMemory = process.memoryUsage().heapUsed;
       const increase = finalMemory - initialMemory;

       // 内存增长应 < 10MB
       expect(increase).toBeLessThan(10 * 1024 * 1024);
     });
   });

完成！✅
```

---

#### 效果对比

| 维度 | 传统方式 | 知识库驱动 |
|------|---------|-----------|
| **问题诊断** | Google → 尝试多种方案 | 直接检索个人经验 |
| **解决方案** | 通用方案（可能不适合） | 已验证的方案 |
| **代码修复** | 手动编写 | 基于笔记生成 |
| **测试验证** | 手动编写 | AI 生成测试 |
| **总时间** | 2-4 小时 | 30-60 分钟 |

**效率提升**：⚡ 3-5 倍

---

## Windows 专属

### Windows 路径配置

#### 路径格式

**推荐格式**：

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "D:/Projects"]
    }
  }
}
```

**格式对比**：

| 格式 | 示例 | 推荐度 | 说明 |
|------|------|--------|------|
| 正斜杠 | `D:/Projects` | ⭐⭐⭐⭐⭐ | 跨平台兼容 |
| 双反斜杠 | `D:\\Projects` | ⭐⭐⭐⭐ | JSON 标准 |
| 单反斜杠 | `D:\Projects` | ❌ | 需要转义，避免使用 |

---

### PowerShell 安装脚本

#### 一键安装多个服务器

**保存为 `install-mcp-servers.ps1`**：

```powershell
# MCP 服务器一键安装脚本
# 使用方法：.\install-mcp-servers.ps1

Write-Host "=== MCP 服务器安装脚本 ===" -ForegroundColor Cyan
Write-Host ""

# 检查 Node.js
Write-Host "1. 检查 Node.js..." -ForegroundColor Yellow
try {
    $nodeVersion = node --version
    Write-Host "✅ Node.js 版本: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ 未安装 Node.js" -ForegroundColor Red
    exit 1
}

# 创建配置目录
Write-Host ""
Write-Host "2. 创建配置目录..." -ForegroundColor Yellow
$configDir = "$env:USERPROFILE\.claude"
if (-not (Test-Path $configDir)) {
    New-Item -ItemType Directory -Path $configDir | Out-Null
    Write-Host "✅ 创建配置目录" -ForegroundColor Green
} else {
    Write-Host "✅ 配置目录已存在" -ForegroundColor Green
}

# 创建配置文件
Write-Host ""
Write-Host "3. 创建 MCP 配置..." -ForegroundColor Yellow
$configFile = "$configDir\mcp_servers.json"

$config = @{
    mcpServers = @{
        "filesystem" = @{
            command = "npx"
            args = @("-y", "@modelcontextprotocol/server-filesystem", "D:/Projects")
        }
        "sqlite" = @{
            command = "npx"
            args = @("-y", "@modelcontextprotocol/server-sqlite", "--db-path", "./data.db")
        }
        "postgres" = @{
            command = "npx"
            args = @("-y", "@modelcontextprotocol/server-postgres")
            env = @{
                POSTGRES_CONNECTION_STRING = "postgresql://user:password@localhost:5432/dbname"
            }
        }
    }
}

# 保存配置
$config | ConvertTo-Json -Depth 10 | Out-File -FilePath $configFile -Encoding utf8

Write-Host "✅ 配置文件已创建: $configFile" -ForegroundColor Green

# 测试服务器
Write-Host ""
Write-Host "4. 测试服务器..." -ForegroundColor Yellow

Write-Host "测试 Filesystem MCP..." -ForegroundColor Cyan
try {
    npx -y @modelcontextprotocol/server-filesystem --help 2>$null | Out-Null
    Write-Host "✅ Filesystem MCP 可用" -ForegroundColor Green
} catch {
    Write-Host "⚠️ Filesystem MCP 测试失败" -ForegroundColor Yellow
}

Write-Host "测试 SQLite MCP..." -ForegroundColor Cyan
try {
    npx -y @modelcontextprotocol/server-sqlite --help 2>$null | Out-Null
    Write-Host "✅ SQLite MCP 可用" -ForegroundColor Green
} catch {
    Write-Host "⚠️ SQLite MCP 测试失败" -ForegroundColor Yellow
}

Write-Host "测试 PostgreSQL MCP..." -ForegroundColor Cyan
try {
    npx -y @modelcontextprotocol/server-postgres --help 2>$null | Out-Null
    Write-Host "✅ PostgreSQL MCP 可用" -ForegroundColor Green
} catch {
    Write-Host "⚠️ PostgreSQL MCP 测试失败" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=== 安装完成 ===" -ForegroundColor Green
Write-Host "下一步：重启 Claude Code" -ForegroundColor Cyan
```

#### 使用方法

```powershell
# 1. 以管理员身份运行 PowerShell
# 2. 允许脚本执行
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 3. 运行安装脚本
.\install-mcp-servers.ps1
```

---

### Windows 性能优化

#### 优化 1：使用 WSL2

**原因**：Windows 文件系统 I/O 较慢

**解决方案**：

```bash
# 在 WSL2 中运行 MCP 服务器
# Windows 配置
{
  "mcpServers": {
    "filesystem": {
      "command": "wsl",
      "args": ["-e", "node", "/mnt/d/Projects/mcp-server/dist/index.js"]
    }
  }
}
```

---

#### 优化 2：调整缓冲区大小

**PowerShell**：
```powershell
# 增加管道缓冲区
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
```

---

### 常见 Windows 问题

#### 问题 1：路径长度限制

**症状**：
```
Error: Path too long
```

**解决方案**：

```powershell
# 启用长路径支持
# 需要管理员权限
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" `
    -Name "LongPathsEnabled" `
    -Value 1 `
    -PropertyType DWORD `
    -Force
```

---

#### 问题 2：权限问题

**症状**：
```
Error: EACCES: permission denied
```

**解决方案**：

```powershell
# 以管理员身份运行 PowerShell
# 检查文件夹权限
$acl = Get-Acl "D:/Projects"
$acl.Access

# 添加完全控制权限
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
    $env:USERNAME,
    "FullControl",
    "Allow"
)
$acl.SetAccessRule($accessRule)
Set-Acl "D:/Projects" $acl
```

---

## 最佳实践

### 服务器选择

#### 原则 1：按需配置

```
❌ 过度配置：
配置所有可用的 MCP 服务器
→ 资源浪费
→ 管理复杂
→ 性能下降

✅ 按需配置：
只配置当前需要的服务器
→ 快速响应
→ 易于维护
→ 性能优化
```

---

#### 原则 2：核心优先

```
第一优先（必备）：
✅ Filesystem MCP（文件系统）
✅ Obsidian MCP（知识管理）

第二优先（推荐）：
⭐ PostgreSQL/MySQL MCP（数据库）
⭐ GitHub MCP（代码协作）

第三优先（可选）：
⭐ Puppeteer MCP（浏览器）
⭐ Memory MCP（对话记忆）
```

---

#### 原则 3：环境隔离

```
开发环境：
├─ 文件系统：项目目录
├─ 数据库：开发库
└─ 日志：调试级别

生产环境：
├─ 数据库：生产库（只读）
├─ 日志：错误级别
└── 权限：受限访问
```

---

### 安全建议

#### 建议 1：敏感信息保护

```
❌ 避免：
- 直接在配置文件中写入密码
- 将配置文件提交到 Git

✅ 推荐：
- 使用环境变量
- 使用密钥管理工具
- 配置文件加入 .gitignore
```

**Windows 环境变量**：

```powershell
# 设置用户环境变量
[System.Environment]::SetEnvironmentVariable('DB_PASSWORD', 'your_password', 'User')

# 配置文件中使用
{
  "env": {
    "POSTGRES_CONNECTION_STRING": "postgresql://user:${env:DB_PASSWORD}@localhost:5432/db"
  }
}
```

---

#### 建议 2：权限控制

```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "POSTGRES_CONNECTION_STRING": "postgresql://readonly_user:password@localhost:5432/db"
      }
    }
  }
}
```

**说明**：
- 使用只读用户
- 限制访问权限
- 审计所有操作

---

#### 建议 3：访问审计

```
启用日志记录：
1. 记录所有 MCP 调用
2. 记录访问的数据
3. 定期审计日志
4. 发现异常行为
```

---

### 性能优化

#### 优化 1：减少服务器数量

```
推荐配置：
3-5 个核心服务器

原因：
✅ 启动快
✅ 内存占用低
✅ 响应迅速
✅ 易于维护
```

---

#### 优化 2：使用缓存

```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "POSTGRES_CONNECTION_STRING": "postgresql://user:pass@localhost:5432/db",
        "CACHE_ENABLED": "true",
        "CACHE_TTL": "300"
      }
    }
  }
}
```

---

#### 优化 3：连接池

```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "POSTGRES_CONNECTION_STRING": "postgresql://user:pass@localhost:5432/db",
        "POOL_SIZE": "10",
        "CONNECTION_TIMEOUT": "30"
      }
    }
  }
}
```

---

### 维护建议

#### 建议 1：定期更新

```
# 更新所有 MCP 服务器
npm update -g @modelcontextprotocol/server-*

# 检查更新版本
npm outdated -g
```

---

#### 建议 2：备份配置

```powershell
# 备份配置文件
Copy-Item "$env:USERPROFILE\.claude\mcp_servers.json" -Destination "D:\Backups\mcp_servers.json"

# 定期备份（Windows 任务计划程序）
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "D:\Scripts\backup-mcp-config.ps1"
$trigger = New-ScheduledTaskTrigger -Daily -At "2:00AM"
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "Backup MCP Config"
```

---

#### 建议 3：监控性能

```
关键指标：
- 服务器启动时间
- 响应延迟
- 内存占用
- 错误率

监控工具：
- Claude Code 内置日志
- Windows 性能监视器
- 自定义脚本
```

---

## 常见问题

### Q1: MCP 服务器会消耗多少资源？

**A**: 资源占用情况：

| 服务器 | 内存占用 | CPU 占用 | 启动时间 |
|--------|---------|---------|---------|
| Filesystem | ~20MB | <1% | <1秒 |
| SQLite | ~30MB | <1% | <1秒 |
| PostgreSQL | ~50MB | <1% | 1-2秒 |
| Obsidian | ~50-150MB | <1% | 2-3秒 |

**总计**：5 个服务器约 150-300MB 内存

---

### Q2: 可以同时使用多个相同类型的服务器吗？

**A**: ✅ 可以，但需要使用不同的名称：

```json
{
  "mcpServers": {
    "postgres-dev": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "POSTGRES_CONNECTION_STRING": "postgresql://user:pass@localhost:5432/dev"
      }
    },
    "postgres-prod": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "POSTGRES_CONNECTION_STRING": "postgresql://user:pass@prod-host:5432/prod"
      }
    }
  }
}
```

---

### Q3: 如何禁用某个 MCP 服务器？

**A**: 有两种方式：

**方式 1：删除配置**
```json
// 删除服务器的配置条目
{
  "mcpServers": {
    // "filesystem": { ... }  // 注释或删除
  }
}
```

**方式 2：重命名**
```json
{
  "mcpServers": {
    "filesystem-disabled": {  // 重命名
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "D:/Projects"]
    }
  }
}
```

---

### Q4: MCP 服务器支持哪些操作系统？

**A**: 支持情况：

| 操作系统 | 支持状态 | 说明 |
|---------|---------|------|
| Windows 10/11 | ✅ 完全支持 | 优先支持 |
| macOS 12+ | ✅ 完全支持 | 功能一致 |
| Linux | ✅ 完全支持 | 需要手动安装 Node.js |

**最低要求**：
- Node.js 18+
- 2GB 内存
- 100MB 磁盘空间

---

### Q5: 如何开发自定义 MCP 服务器？

**A**: 基本步骤：

```
1. 初始化项目
   npm init
   npm install @modelcontextprotocol/sdk

2. 创建服务器
   import { Server } from '@modelcontextprotocol/sdk/server/index.js';
   import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';

3. 实现工具
   server.setRequestHandler(CallToolRequestSchema, async (request) => {
     // 处理工具调用
   });

4. 启动服务器
   const transport = new StdioServerTransport();
   await server.connect(transport);

5. 配置 Claude Code
   {
     "mcpServers": {
       "my-server": {
         "command": "node",
         "args": ["./dist/index.js"]
       }
     }
   }
```

**详细文档**：[MCP SDK 文档](https://github.com/modelcontextprotocol/servers)

---

### Q6: MCP 服务器的数据安全吗？

**A**: 安全措施：

```
✅ 内置安全特性：
- 明确的权限控制
- 可审计的操作日志
- 数据访问范围限制

✅ 用户责任：
- 使用环境变量存储敏感信息
- 定期更新服务器版本
- 监控访问日志
- 使用只读账户（如果可能）
```

---

### Q7: 如何排查 MCP 服务器问题？

**A**: 诊断流程：

```
1. 检查配置文件
   → JSON 格式是否正确
   → 路径是否有效
   → 环境变量是否设置

2. 测试服务器
   → 手动运行服务器
   → 查看错误信息

3. 启用调试日志
   → $env:DEBUG = "mcp:*"
   → 查看详细日志

4. 查看文档
   → 官方文档
   → GitHub Issues
   → 社区讨论
```

---

### Q8: 可以在 Docker 中运行 MCP 服务器吗？

**A**: ✅ 可以：

**Dockerfile**：
```dockerfile
FROM node:18-alpine

RUN npm install -g @modelcontextprotocol/server-postgres

CMD ["npx", "-y", "@modelcontextprotocol/server-postgres"]
```

**配置**：
```json
{
  "mcpServers": {
    "postgres": {
      "command": "docker",
      "args": ["run", "-i", "--rm", "mcp-postgres"],
      "env": {
        "POSTGRES_CONNECTION_STRING": "postgresql://user:pass@host.docker.internal:5432/db"
      }
    }
  }
}
```

---

## 故障排查

### 诊断流程

```
遇到问题
    ↓
1. 检查配置文件
    ├─ JSON 格式
    ├─ 路径有效性
    └─ 环境变量
    ↓
2. 测试服务器
    ├─ 手动运行
    ├─ 查看错误
    └─ 验证功能
    ↓
3. 查看日志
    ├─ 启用 DEBUG 模式
    ├─ 分析错误信息
    └─ 搜索解决方案
    ↓
4. 重启和重建
    ├─ 重启 Claude Code
    ├─ 清除缓存
    └─ 重新安装
    ↓
5. 寻求帮助
    ├─ 查看文档
    ├─ 提交 Issue
    └─ 社区求助
```

---

### 常见错误及解决

#### 错误 1：服务器启动失败

**症状**：
```
Error: Failed to start MCP server
```

**诊断步骤**：

```powershell
# 1. 验证 Node.js
node --version

# 2. 手动测试服务器
npx -y @modelcontextprotocol/server-filesystem D:/Projects

# 3. 检查路径
Test-Path "D:/Projects"

# 4. 查看日志
$env:DEBUG = "mcp:*"
claude-code
```

**解决方案**：
- 修正路径或参数
- 重新安装服务器包
- 检查权限设置

---

#### 错误 2：连接超时

**症状**：
```
Error: Connection timeout
```

**解决方案**：

**方案 1：增加超时时间**
```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "CONNECTION_TIMEOUT": "60"
      }
    }
  }
}
```

**方案 2：优化性能**
- 升级硬件
- 减少并发连接
- 使用缓存

---

#### 错误 3：权限拒绝

**症状**：
```
Error: EACCES: permission denied
```

**解决方案**：

```powershell
# 添加文件夹权限
$acl = Get-Acl "D:/Projects"
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
    $env:USERNAME,
    "FullControl",
    "Allow"
)
$acl.SetAccessRule($accessRule)
Set-Acl "D:/Projects" $acl
```

---

### 日志查看方法

#### 启用调试日志

**Windows（PowerShell）**：
```powershell
# 启用所有 MCP 日志
$env:DEBUG = "mcp:*"

# 启用特定服务器日志
$env:DEBUG = "mcp:filesystem,mcp:postgres"

# 启动 Claude Code
claude-code
```

#### 日志级别

| 级别 | 说明 | 使用场景 |
|------|------|---------|
| `error` | 错误信息 | 生产环境 |
| `warn` | 警告信息 | 生产环境 |
| `info` | 一般信息 | 开发/调试 |
| `debug` | 调试信息 | 开发/故障排查 |
| `*` | 所有信息 | 深度调试 |

#### 保存日志到文件

```powershell
# 重定向日志到文件
$env:DEBUG = "mcp:*"
claude-code > mcp-debug.log 2>&1

# 查看日志
Get-Content mcp-debug.log | Select-Object -Last 100
```

---

## 总结

### 核心价值回顾

通过 MCP 服务器，你的 Claude Code 将能够：

```
1. 扩展能力边界 ⚡
   - 访问外部工具和服务
   - 集成多种数据源
   - 自动化复杂流程

2. 提升工作效率 🚀
   - 统一的操作界面
   - 减少工具切换
   - 效率提升 3-5 倍

3. 个性化定制 🎯
   - 根据需求配置
   - 构建专属工作流
   - 持续优化改进
```

### 学习检查清单

完成本学习后，你应该能够：

- [ ] 理解 MCP 协议的核心概念和价值
- [ ] 选择合适的 MCP 服务器
- [ ] 配置和优化服务器
- [ ] 集成多个服务器
- [ ] 排查常见问题
- [ ] 应用到实际工作流程

### 下一步学习

继续提升你的 Claude Code 技能：

```
Level 2 其他技能：
[02 - Obsidian Integration](./02-obsidian-integration.md) - 知识库集成
[03 - Browser Automation](./03-browser-automation.md) - 浏览器自动化实战

Level 3 专家之道：
[Master 01 - Customization](../01-customization/README.md) - 自定义和扩展
```

---

**最后更新**: 2025-01-17
**难度**: ⭐⭐⭐⭐
**重要性**: ⭐⭐⭐⭐⭐
**验证状态**: ✅ 已验证（基于官方 MCP 文档）
