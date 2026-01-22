# LSP 集成 - 语言服务器协议

> **统一语言工具，提升开发体验**

**阅读时间**: 40分钟
**难度**: ⭐⭐⭐⭐⭐
**重要性**: ⭐⭐⭐⭐
**前置要求**: [插件系统](../03-advanced-topics/02-plugins.md)

---

## 目录

- [LSP 概述](#lsp-概述)
- [LSP 协议](#lsp-协议)
- [配置 LSP 服务器](#配置-lsp-服务器)
- [常见 LSP 服务器](#常见-lsp-服务器)
- [自定义 LSP 服务器](#自定义-lsp-服务器)
- [实战案例](#实战案例)
- [Windows特定](#windows特定)
- [最佳实践](#最佳实践)
- [常见问题](#常见问题)
- [故障排查](#故障排查)

---

## LSP 概述

### 什么是 LSP？

**LSP（Language Server Protocol）** 是语言服务器和编辑器之间的标准化协议，定义了：
- 自动完成
- 诊断（错误和警告）
- 代码跳转（转到定义）
- 悬停信息
- 代码格式化
- 符号搜索
- 代码重构

**历史背景**：
```
传统模式：
每个编辑器 × 每种语言 = 独立实现
VSCode Python、VSCode Go、Vim Python、Vim Go...
→ 大量重复工作

LSP 模式：
语言服务器 ↔ 编辑器
一次实现，多处使用
→ 提高效率
```

### LSP 架构

```
┌──────────────────────────────────────┐
│         客户端（Client）             │
│  （编辑器：VSCode、Vim、Emacs）      │
│                                      │
│  ┌────────────────────────────────┐ │
│  │     LSP 客户端实现            │ │
│  │  - 消息发送/接收              │ │
│  │  - 功能调用                   │ │
│  │  - UI 显示                    │ │
│  └────────────────────────────────┘ │
└──────────────┬───────────────────────┘
               │ JSON-RPC
               │ stdio / TCP
               ↓
┌──────────────────────────────────────┐
│        服务器（Server）              │
│  （语言分析工具）                    │
│                                      │
│  ┌────────────────────────────────┐ │
│  │     LSP 服务器实现            │ │
│  │  - 代码分析                   │ │
│  │  - 功能实现                   │ │
│  │  - 结果返回                   │ │
│  └────────────────────────────────┘ │
└──────────────────────────────────────┘
```

### LSP 的核心价值

| 价值维度 | 说明 | 效果 |
|---------|------|------|
| **标准化** | 统一协议 | **一次实现，多处使用** |
| **解耦** | 语言工具与编辑器分离 | **独立演进** |
| **性能** | 服务器可独立优化 | **更好的性能** |
| **生态** | 丰富的服务器实现 | **覆盖几乎所有语言** |
| **体验** | 一致的开发体验 | **跨编辑器一致** |

### Claude Code 与 LSP

**为什么 Claude Code 需要 LSP**？

```
增强代码理解能力：

1. 语法高亮和结构
   → 更准确的代码分析

2. 符号信息
   → 理解函数、类、变量

3. 类型信息
   → 类型推断和检查

4. 错误诊断
   → 发现代码问题

5. 代码引用
   → 理解代码关系
```

**LSP 在 Claude Code 中的应用**：
```typescript
// 使用 LSP 增强代码理解
const lspClient = new LSPClient({
  language: 'typescript',
  serverPath: 'typescript-language-server',
  rootPath: projectPath
});

// 获取符号定义
const definition = await lspClient.goToDefinition(file, position);

// 获取诊断信息
const diagnostics = await lspClient.getDiagnostics(file);

// 获取代码补全
const completions = await lspClient.getCompletions(file, position);
```

---

## LSP 协议

### 通信机制

#### 传输层

**stdio（标准输入输出）**：
```
编辑器 ──stdin──→ 服务器
编辑器 ←─stdout── 服务器
```

**TCP（网络通信）**：
```
编辑器 ──TCP──→ 服务器
编辑器 ←─TCP── 服务器
```

#### 消息格式

**JSON-RPC 2.0 格式**：
```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "textDocument/completion",
  "params": {
    "textDocument": {
      "uri": "file:///path/to/file.ts"
    },
    "position": {
      "line": 10,
      "character": 5
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
    "isIncomplete": false,
    "items": [
      {
        "label": "console.log",
        "kind": 3,
        "detail": "function",
        "documentation": "打印输出到控制台"
      }
    ]
  }
}
```

### 核心功能

#### 1. 初始化（Initialize）

**请求**：
```json
{
  "id": 1,
  "method": "initialize",
  "params": {
    "processId": 12345,
    "rootUri": "file:///path/to/project",
    "capabilities": {
      "textDocument": {
        "completion": {
          "dynamicRegistration": true
        },
        "hover": {
          "contentFormat": ["markdown", "plaintext"]
        }
      }
    }
  }
}
```

**响应**：
```json
{
  "id": 1,
  "result": {
    "capabilities": {
      "completionProvider": {
        "resolveProvider": true,
        "triggerCharacters": ["."]
      },
      "hoverProvider": true,
      "definitionProvider": true,
      "referencesProvider": true,
      "documentFormattingProvider": true
    }
  }
}
```

#### 2. 代码补全（Completion）

**请求**：
```json
{
  "id": 2,
  "method": "textDocument/completion",
  "params": {
    "textDocument": {
      "uri": "file:///path/to/file.ts"
    },
    "position": {
      "line": 5,
      "character": 10
    },
    "context": {
      "triggerKind": 2
    }
  }
}
```

**响应**：
```json
{
  "id": 2,
  "result": {
    "isIncomplete": false,
    "items": [
      {
        "label": "getData",
        "kind": 3,
        "detail": "function",
        "documentation": {
          "kind": "markdown",
          "value": "获取数据"
        },
        "sortText": "a",
        "filterText": "getData",
        "insertText": "getData()",
        "insertTextFormat": 1
      }
    ]
  }
}
```

#### 3. 转到定义（Go to Definition）

**请求**：
```json
{
  "id": 3,
  "method": "textDocument/definition",
  "params": {
    "textDocument": {
      "uri": "file:///path/to/file.ts"
    },
    "position": {
      "line": 10,
      "character": 15
    }
  }
}
```

**响应**：
```json
{
  "id": 3,
  "result": [
    {
      "uri": "file:///path/to/definition.ts",
      "range": {
        "start": { "line": 5, "character": 0 },
        "end": { "line": 5, "character": 20 }
      }
    }
  ]
}
```

#### 4. 悬停信息（Hover）

**请求**：
```json
{
  "id": 4,
  "method": "textDocument/hover",
  "params": {
    "textDocument": {
      "uri": "file:///path/to/file.ts"
    },
    "position": {
      "line": 8,
      "character": 12
    }
  }
}
```

**响应**：
```json
{
  "id": 4,
  "result": {
    "contents": {
      "kind": "markdown",
      "value": "```typescript\nfunction getData(): Promise<Data>\n```\n\n获取数据的函数"
    },
    "range": {
      "start": { "line": 8, "character": 10 },
      "end": { "line": 8, "character": 18 }
    }
  }
}
```

#### 5. 诊断（Diagnostics）

**通知**（服务器 → 客户端）：
```json
{
  "method": "textDocument/publishDiagnostics",
  "params": {
    "uri": "file:///path/to/file.ts",
    "diagnostics": [
      {
        "range": {
          "start": { "line": 10, "character": 5 },
          "end": { "line": 10, "character": 15 }
        },
        "severity": 1,
        "code": "2322",
        "source": "TypeScript",
        "message": "类型不匹配"
      }
    ]
  }
}
```

#### 6. 代码格式化（Formatting）

**请求**：
```json
{
  "id": 5,
  "method": "textDocument/formatting",
  "params": {
    "textDocument": {
      "uri": "file:///path/to/file.ts"
    },
    "options": {
      "tabSize": 2,
      "insertSpaces": true
    }
  }
}
```

**响应**：
```json
{
  "id": 5,
  "result": [
    {
      "range": {
        "start": { "line": 0, "character": 0 },
        "end": { "line": 0, "character": 10 }
      },
      "newText": "const x = 1;"
    }
  ]
}
```

---

## 配置 LSP 服务器

### 配置文件

**`.claude/lsp.json`**:
```json
{
  "servers": [
    {
      "name": "typescript",
      "language": "typescript",
      "command": "typescript-language-server",
      "args": ["--stdio"],
      "filetypes": ["typescript", "typescriptreact"],
      "settings": {
        "typescript": {
          "format": {
            "enabled": true
          }
        }
      }
    },
    {
      "name": "python",
      "language": "python",
      "command": "pylsp",
      "args": ["-v"],
      "filetypes": ["python"],
      "settings": {
        "plugins": {
          "pylint": {
            "enabled": true
          }
        }
      }
    }
  ]
}
```

### 配置选项

#### 基本配置

```typescript
interface LSPServerConfig {
  // 服务器名称
  name: string;

  // 支持的语言
  language: string;

  // 启动命令
  command: string;

  // 命令参数
  args?: string[];

  // 支持的文件类型
  filetypes: string[];

  // 工作目录
  cwd?: string;

  // 环境变量
  env?: Record<string, string>;

  // 服务器设置
  settings?: Record<string, any>;

  // 初始化选项
  initializationOptions?: any;
}
```

#### 高级配置

```json
{
  "servers": [
    {
      "name": "rust-analyzer",
      "command": "rust-analyzer",
      "args": [],
      "filetypes": ["rust"],
      "settings": {
        "rust-analyzer": {
          "cargo": {
            "loadOutDirsFromCheck": true
          },
          "procMacro": {
            "enable": true
          },
          "diagnostics": {
            "enable": true,
            "experimental": {
              "enable": false
            }
          }
        }
      },
      "initializationOptions": {
        "cachePriming": {
          "enable": true
        }
      }
    }
  ]
}
```

---

## 常见 LSP 服务器

### TypeScript/JavaScript

**typescript-language-server**

```json
{
  "name": "typescript",
  "command": "typescript-language-server",
  "args": ["--stdio"],
  "filetypes": ["typescript", "typescriptreact", "javascript", "javascriptreact"],
  "settings": {
    "typescript": {
      "format": {
        "enabled": true,
        "indentSize": 2
      },
      "lint": {
        "enabled": true
      },
      "suggest": {
        "autoImports": true
      }
    }
  }
}
```

**安装**：
```bash
npm install -g typescript typescript-language-server
```

### Python

**pylsp**

```json
{
  "name": "python",
  "command": "pylsp",
  "args": ["-v"],
  "filetypes": ["python"],
  "settings": {
    "plugins": {
      "pylint": {
        "enabled": true,
        "args": ["--max-line-length=120"]
      },
      "pydocstyle": {
        "enabled": true,
        "convention": "pep257"
      },
      "mypy": {
        "enabled": true,
        "live_mode": true
      },
      "isort": {
        "enabled": true
      },
      "black": {
        "enabled": true
      }
    }
  }
}
```

**安装**：
```bash
pip install 'python-lsp-server[all]'
```

### Go

**gopls**

```json
{
  "name": "go",
  "command": "gopls",
  "filetypes": ["go"],
  "settings": {
    "gopls": {
      "analyses": {
        "unusedparams": true,
        "shadow": true
      },
      "staticcheck": true,
      "gofumpt": true
    }
  }
}
```

**安装**：
```bash
go install golang.org/x/tools/gopls@latest
```

### Rust

**rust-analyzer**

```json
{
  "name": "rust",
  "command": "rust-analyzer",
  "filetypes": ["rust"],
  "settings": {
    "rust-analyzer": {
      "cargo": {
        "loadOutDirsFromCheck": true
      },
      "procMacro": {
        "enable": true
      },
      "checkOnSave": {
        "command": "clippy"
      }
    }
  }
}
```

**安装**：
```bash
rustup component add rust-analyzer
```

### C/C++

**clangd**

```json
{
  "name": "c_cpp",
  "command": "clangd",
  "args": ["--background-index"],
  "filetypes": ["c", "cpp", "objc", "objcpp"],
  "settings": {
    "clangd": {
      "arguments": [
        "-std=c++17",
        "-I/path/to/includes"
      ],
      "compilationDatabasePath": "build"
    }
  }
}
```

**安装**：
```bash
# macOS
brew install llvm

# Linux
sudo apt install clangd-12

# Windows
# 下载预编译版本
```

---

## 自定义 LSP 服务器

### 基础服务器实现

```typescript
import {
  createConnection,
  TextDocuments,
  ProposedFeatures,
  InitializeParams,
  DidChangeConfigurationNotification,
  CompletionItem,
  CompletionItemKind,
  TextDocumentPositionParams,
  TextDocumentSyncKind,
  InitializeResult
} from 'vscode-languageserver/node';

import {
  TextDocument
} from 'vscode-languageserver-textdocument';

// 创建连接
const connection = createConnection(ProposedFeatures.all);

// 创建文档管理器
const documents: TextDocuments<TextDocument> = new TextDocuments(TextDocument);

// 服务器配置
interface ServerSettings {
  maxNumberOfProblems: number;
}

// 全局配置
let settings: ServerSettings = {
  maxNumberOfProblems: 100
};

// 监听配置变更
connection.onDidChangeConfiguration((change) => {
  if (settings.haveConfigurationCapability) {
    settings.maxNumberOfProblems =
      change.settings.languageServerExample.maxNumberOfProblems;
  }
});

// 内容监听器
documents.onDidChangeContent((change) => {
  validateTextDocument(change.document);
});

// 文档验证
function validateTextDocument(textDocument: TextDocument): void {
  const diagnostics = [];
  const lines = textDocument.getText().split(/\r\n|\n/g/);

  lines.forEach((line, i) => {
    if (line.includes('TODO')) {
      diagnostics.push({
        severity: 1, // Error
        range: {
          start: { line: i, character: line.indexOf('TODO') },
          end: { line: i, character: line.indexOf('TODO') + 4 }
        },
        message: 'TODO 注释',
        source: 'ex-ls'
      });
    }
  });

  // 发送诊断信息
  connection.sendDiagnostics({
    uri: textDocument.uri,
    diagnostics
  });
}

// 代码补全
connection.onCompletion(
  (_textDocumentPosition: TextDocumentPositionParams): CompletionItem[] => {
    return [
      {
        label: 'TypeScript',
        kind: CompletionItemKind.Text,
        data: 1
      },
      {
        label: 'JavaScript',
        kind: CompletionItemKind.Text,
        data: 2
      }
    ];
  }
);

// 补全解析
connection.onCompletionResolve((item: CompletionItem): CompletionItem => {
  if (item.data === 1) {
    item.detail = 'TypeScript details';
    item.documentation = 'TypeScript documentation';
  }
  return item;
});

// 初始化处理
connection.onInitialize((params: InitializeParams): InitializeResult => {
  return {
    capabilities: {
      textDocumentSync: TextDocumentSyncKind.Incremental,
      completionProvider: {
        resolveProvider: true
      }
    }
  };
});

// 监听文档
documents.listen(connection);

// 监听连接
connection.listen();
```

### 高级功能实现

#### 符号提供器

```typescript
import {
  DocumentSymbol,
  SymbolInformation,
  SymbolKind
} from 'vscode-languageserver/node';

// 文档符号
connection.onDocumentSymbol((params) => {
  const document = documents.get(params.textDocument.uri);
  if (!document) return [];

  const text = document.getText();
  const symbols: DocumentSymbol[] = [];

  // 解析函数
  const functionRegex = /function\s+(\w+)\s*\(/g;
  let match;
  while ((match = functionRegex.exec(text)) !== null) {
    symbols.push({
      name: match[1],
      kind: SymbolKind.Function,
      range: {
        start: document.positionAt(match.index),
        end: document.positionAt(match.index + match[0].length)
      },
      detail: '函数'
    });
  }

  return symbols;
});

// 工作区符号
connection.onWorkspaceSymbol((params) => {
  const symbols: SymbolInformation[] = [];

  documents.all().forEach(doc => {
    const text = doc.getText();
    const matches = text.matchAll(/function\s+(\w+)/g);

    for (const match of matches) {
      symbols.push({
        name: match[1],
        kind: SymbolKind.Function,
        location: {
          uri: doc.uri,
          range: {
            start: doc.positionAt(match.index),
            end: doc.positionAt(match.index + match[0].length)
          }
        }
      });
    }
  });

  return symbols;
});
```

#### 定义提供器

```typescript
connection.onDefinition((params) => {
  const document = documents.get(params.textDocument.uri);
  if (!document) return;

  const text = document.getText();
  const position = params.position;
  const offset = document.offsetAt(position);

  // 查找当前位置的单词
  const wordRegex = /\w+/g;
  let match;
  while ((match = wordRegex.exec(text)) !== null) {
    if (offset >= match.index && offset <= match.index + match[0].length) {
      const word = match[0];

      // 在文件中搜索定义
      const definitionRegex = new RegExp(
        `(function|const|let|var)\\s+${word}\\b`
      );
      const defMatch = definitionRegex.exec(text);

      if (defMatch) {
        return {
          uri: document.uri,
          range: {
            start: document.positionAt(defMatch.index),
            end: document.positionAt(
              defMatch.index + defMatch[0].length
            )
          }
        };
      }
    }
  }
});
```

#### 引用提供器

```typescript
connection.onReferences((params) => {
  const document = documents.get(params.textDocument.uri);
  if (!document) return [];

  const text = document.getText();
  const position = params.position;
  const offset = document.offsetAt(position);

  // 获取当前单词
  const range = getWordRangeAtPosition(text, offset);
  const word = text.slice(range.start, range.end);

  // 查找所有引用
  const references: Location[] = [];
  const regex = new RegExp(`\\b${word}\\b`, 'g');
  let match;

  while ((match = regex.exec(text)) !== null) {
    references.push({
      uri: document.uri,
      range: {
        start: document.positionAt(match.index),
        end: document.positionAt(match.index + match[0].length)
      }
    });
  }

  return references;
});
```

---

## 实战案例

### 案例1：集成自定义语言服务器

**场景**：为自定义文件格式创建 LSP 支持

```typescript
import { LSPClient } from '@anthropic-ai/claude-lsp';

class CustomLanguageServer {
  private client: LSPClient;

  constructor(projectPath: string) {
    this.client = new LSPClient({
      command: 'my-lang-server',
      args: ['--stdio'],
      cwd: projectPath,
      initializationOptions: {
        customSetting: 'value'
      }
    });
  }

  async initialize() {
    await this.client.start();

    // 发送初始化请求
    await this.client.sendRequest('initialize', {
      processId: process.pid,
      rootUri: `file://${this.projectPath}`,
      capabilities: {
        textDocument: {
          completion: true,
          hover: true,
          definition: true
        }
      }
    });

    // 通知初始化完成
    await this.client.sendNotification('initialized');
  }

  async getCompletions(file: string, line: number, char: number) {
    return await this.client.sendRequest('textDocument/completion', {
      textDocument: { uri: file },
      position: { line, character: char }
    });
  }

  async getDiagnostics(file: string) {
    return await this.client.sendRequest('textDocument/diagnostic', {
      textDocument: { uri: file }
    });
  }
}

// 使用
const server = new CustomLanguageServer('/path/to/project');
await server.initialize();

const completions = await server.getCompletions('file.my', 10, 5);
console.log('补全建议:', completions);
```

---

### 案例2：多语言 LSP 管理器

**场景**：管理多个语言服务器

```typescript
class LSPManager {
  private servers: Map<string, LSPClient> = new Map();

  registerLanguage(language: string, config: LSPConfig) {
    const client = new LSPClient(config);
    this.servers.set(language, client);
  }

  async startAll() {
    const startups = Array.from(this.servers.entries()).map(
      async ([lang, client]) => {
        try {
          await client.start();
          console.log(`✅ ${lang} 服务器已启动`);
        } catch (error) {
          console.error(`❌ ${lang} 服务器启动失败:`, error);
        }
      }
    );

    await Promise.all(startups);
  }

  async getLanguageServer(language: string): Promise<LSPClient> {
    let client = this.servers.get(language);

    if (!client) {
      // 尝试自动检测语言
      client = await this.detectAndStartServer(language);
    }

    return client;
  }

  private async detectAndStartServer(language: string): Promise<LSPClient> {
    // 根据语言检测并启动对应服务器
    const configs: Record<string, LSPConfig> = {
      typescript: {
        command: 'typescript-language-server',
        args: ['--stdio']
      },
      python: {
        command: 'pylsp',
        args: ['-v']
      },
      go: {
        command: 'gopls'
      }
    };

    const config = configs[language];
    if (!config) {
      throw new Error(`不支持的语言: ${language}`);
    }

    const client = new LSPClient(config);
    await client.start();
    this.servers.set(language, client);

    return client;
  }

  async stopAll() {
    const shutdowns = Array.from(this.servers.values()).map(
      client => client.stop()
    );

    await Promise.all(shutdowns);
    this.servers.clear();
  }
}

// 使用
const manager = new LSPManager();

manager.registerLanguage('typescript', {
  command: 'typescript-language-server',
  args: ['--stdio']
});

manager.registerLanguage('python', {
  command: 'pylsp',
  args: ['-v']
});

await manager.startAll();

const tsServer = await manager.getLanguageServer('typescript');
const completions = await tsServer.sendRequest('textDocument/completion', {
  textDocument: { uri: 'file.ts' },
  position: { line: 5, character: 10 }
});
```

---

### 案例3：LSP 增强的代码审查

**场景**：使用 LSP 提供更准确的代码审查

```typescript
class LSPEnhancedCodeReview {
  private lspManager: LSPManager;

  constructor() {
    this.lspManager = new LSPManager();
  }

  async reviewFile(filePath: string): Promise<ReviewResult> {
    // 检测语言
    const language = this.detectLanguage(filePath);
    const server = await this.lspManager.getLanguageServer(language);

    // 打开文件
    await server.sendNotification('textDocument/didOpen', {
      textDocument: {
        uri: filePath,
        languageId: language,
        version: 1,
        text: await fs.readFile(filePath, 'utf-8')
      }
    });

    // 获取诊断信息
    const diagnostics = await server.sendRequest(
      'textDocument/diagnostic',
      {
        textDocument: { uri: filePath }
      }
    );

    // 分析诊断信息
    const issues = diagnostics.map(diag => ({
      severity: this.severityToString(diag.severity),
      message: diag.message,
      line: diag.range.start.line,
      column: diag.range.start.character,
      source: diag.source
    }));

    return {
      file: filePath,
      language,
      issues,
      summary: this.generateSummary(issues)
    };
  }

  async reviewProject(projectPath: string): Promise<ProjectReview> {
    const files = await this.getAllSourceFiles(projectPath);
    const reviews: ReviewResult[] = [];

    for (const file of files) {
      const review = await this.reviewFile(file);
      reviews.push(review);
    }

    return {
      project: projectPath,
      files: reviews.length,
      totalIssues: reviews.reduce((sum, r) => sum + r.issues.length, 0),
      reviews
    };
  }

  private detectLanguage(filePath: string): string {
    const ext = path.extname(filePath);
    const languageMap: Record<string, string> = {
      '.ts': 'typescript',
      '.tsx': 'typescript',
      '.js': 'javascript',
      '.jsx': 'javascript',
      '.py': 'python',
      '.go': 'go',
      '.rs': 'rust'
    };

    return languageMap[ext] || 'plaintext';
  }

  private severityToString(severity: number): string {
    const map = {
      1: 'error',
      2: 'warning',
      3: 'info',
      4: 'hint'
    };
    return map[severity] || 'unknown';
  }

  private generateSummary(issues: Issue[]): string {
    const errors = issues.filter(i => i.severity === 'error').length;
    const warnings = issues.filter(i => i.severity === 'warning').length;

    return `${errors} 个错误, ${warnings} 个警告`;
  }

  private async getAllSourceFiles(projectPath: string): Promise<string[]> {
    // 递归查找所有源代码文件
    const files: string[] = [];
    const entries = await fs.readdir(projectPath, { withFileTypes: true });

    for (const entry of entries) {
      const fullPath = path.join(projectPath, entry.name);

      if (entry.isDirectory()) {
        if (!['node_modules', '.git', 'dist'].includes(entry.name)) {
          const subFiles = await this.getAllSourceFiles(fullPath);
          files.push(...subFiles);
        }
      } else {
        const ext = path.extname(entry.name);
        if (['.ts', '.js', '.py', '.go', '.rs'].includes(ext)) {
          files.push(fullPath);
        }
      }
    }

    return files;
  }
}

// 使用
const reviewer = new LSPEnhancedCodeReview();
const review = await reviewer.reviewProject('/path/to/project');
console.log('项目审查完成:', review.summary);
```

---

## Windows特定

### Windows 上的 LSP 服务器

#### 安装 TypeScript 服务器

```powershell
# 使用 npm 安装
npm install -g typescript typescript-language-server

# 验证安装
typescript-language-server --version
```

#### 安装 Python 服务器

```powershell
# 使用 pip 安装
pip install python-lsp-server

# 验证安装
pylsp --help
```

#### Windows 路径处理

```typescript
class WindowsLSPAdapter {
  normalizePath(filePath: string): string {
    // Windows 路径转换为 URI 格式
    const normalized = filePath
      .replace(/\\/g, '/')
      .replace(/^([A-Z]):/, (_match, drive) => `${drive.toLowerCase()}:`);

    return `file:///${normalized}`;
  }

  uriToPath(uri: string): string {
    // URI 转换为 Windows 路径
    return uri
      .replace(/^file:\/\/\//, '')
      .replace(/\//g, '\\');
  }
}
```

### PowerShell 集成

```powershell
# 启动 LSP 服务器的辅助函数
function Start-LSPServer {
    param(
        [string]$Language,
        [string]$Command,
        [string[]]$Args = @()
    )

    $processInfo = New-Object System.Diagnostics.ProcessStartInfo
    $processInfo.FileName = $Command
    $processInfo.Arguments = $Args -join ' '
    $processInfo.UseShellExecute = $false
    $processInfo.RedirectStandardInput = $true
    $processInfo.RedirectStandardOutput = $true
    $processInfo.RedirectStandardError = $true

    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $processInfo
    $process.Start() | Out-Null

    return $process
}

# 使用示例
$tsServer = Start-LSPServer -Language "typescript" -Command "typescript-language-server" -Args @("--stdio")
```

---

## 最佳实践

### 1. 性能优化

```typescript
class OptimizedLSPClient {
  private requestCache = new Map<string, any>();
  private debounceTimer: NodeJS.Timeout | null = null;

  async getCompletionsDebounced(file: string, line: number, char: number) {
    const key = `${file}:${line}:${char}`;

    // 防抖
    if (this.debounceTimer) {
      clearTimeout(this.debounceTimer);
    }

    return new Promise((resolve) => {
      this.debounceTimer = setTimeout(async () => {
        if (this.requestCache.has(key)) {
          resolve(this.requestCache.get(key));
          return;
        }

        const result = await this.client.sendRequest(
          'textDocument/completion',
          { textDocument: { uri: file }, position: { line, character: char } }
        );

        this.requestCache.set(key, result);
        resolve(result);
      }, 100);
    });
  }
}
```

### 2. 错误处理

```typescript
class RobustLSPManager {
  private reconnectAttempts = 3;
  private reconnectDelay = 1000;

  async connectWithRetry(config: LSPConfig): Promise<LSPClient> {
    let lastError: Error;

    for (let attempt = 1; attempt <= this.reconnectAttempts; attempt++) {
      try {
        const client = new LSPClient(config);
        await client.start();
        return client;
      } catch (error) {
        lastError = error as Error;
        console.error(`连接尝试 ${attempt} 失败:`, error);

        if (attempt < this.reconnectAttempts) {
          await this.delay(this.reconnectDelay * attempt);
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

### 3. 日志记录

```typescript
class LSPLogger {
  private logFile: fs.WriteStream;

  constructor() {
    this.logFile = fs.createWriteStream('lsp-debug.log');
  }

  log(method: string, params: any) {
    const entry = {
      timestamp: new Date().toISOString(),
      direction: 'client → server',
      method,
      params
    };

    this.logFile.write(JSON.stringify(entry) + '\n');
  }

  logResponse(method: string, result: any) {
    const entry = {
      timestamp: new Date().toISOString(),
      direction: 'server → client',
      method,
      result
    };

    this.logFile.write(JSON.stringify(entry) + '\n');
  }
}
```

---

## 常见问题

### Q1: LSP 服务器无法启动？

**A**: 检查以下几点

```bash
# 1. 检查服务器是否安装
which typescript-language-server
which pylsp

# 2. 检查路径是否在 PATH 中
echo $PATH

# 3. 手动测试服务器
typescript-language-server --stdio

# 4. 查看日志
tail -f lsp-debug.log
```

### Q2: 诊断信息不显示？

**A**: 确保通知功能已启用

```json
{
  "capabilities": {
    "textDocument": {
      "diagnostic": {
        "dynamicRegistration": true
      }
    }
  }
}
```

### Q3: 代码补全不工作？

**A**: 检查补全提供器配置

```typescript
// 确保在初始化时声明了能力
connection.onInitialize((params) => {
  return {
    capabilities: {
      completionProvider: {
        resolveProvider: true,
        triggerCharacters: ['.']
      }
    }
  };
});
```

### Q4: 如何调试 LSP 服务器？

**A**: 启用详细日志

```typescript
const connection = createConnection(ProposedFeatures.all, {
  // 启用调试日志
  trace: 'verbose'
});

// 记录所有消息
connection.onNotification((method, params) => {
  console.log('通知:', method, params);
});

connection.onRequest((method, params) => {
  console.log('请求:', method, params);
});
```

### Q5: 如何支持大文件？

**A**: 使用增量同步

```typescript
connection.onInitialize((params) => {
  return {
    capabilities: {
      textDocumentSync: {
        openClose: true,
        change: TextDocumentSyncKind.Incremental,
        willSave: true,
        willSaveWaitUntil: true
      }
    }
  };
});
```

---

## 故障排查

### 问题1：服务器崩溃

**症状**：
```
LSP server crashed unexpectedly
```

**解决方案**：
```typescript
class CrashRecoveryLSPClient {
  private watchdogTimer: NodeJS.Timeout | null = null;
  private crashCount = 0;

  async start() {
    await super.start();
    this.startWatchdog();
  }

  private startWatchdog() {
    this.watchdogTimer = setInterval(async () => {
      const alive = await this.ping();

      if (!alive) {
        this.crashCount++;
        console.error(`服务器崩溃，尝试重启 (${this.crashCount}/3)`);

        if (this.crashCount < 3) {
          await this.restart();
        } else {
          console.error('服务器反复崩溃，停止尝试');
          this.stop();
        }
      }
    }, 5000);
  }

  private async ping(): Promise<boolean> {
    try {
      await this.sendRequest('ping', {});
      return true;
    } catch {
      return false;
    }
  }
}
```

### 问题2：性能缓慢

**症状**：
```
LSP requests taking too long
```

**解决方案**：
```typescript
// 限制并发请求数
class LSPRateLimiter {
  private semaphore: Semaphore;

  constructor(maxConcurrent: number = 5) {
    this.semaphore = new Semaphore(maxConcurrent);
  }

  async request(method: string, params: any): Promise<any> {
    await this.semaphore.acquire();
    try {
      return await this.client.sendRequest(method, params);
    } finally {
      this.semaphore.release();
    }
  }
}
```

---

## 总结

### 关键要点

1. **LSP 价值**
   - 标准化协议
   - 解耦语言工具和编辑器
   - 一次实现，多处使用

2. **核心功能**
   - 代码补全
   - 转到定义
   - 悬停信息
   - 诊断信息
   - 代码格式化

3. **配置和使用**
   - 配置 LSP 服务器
   - 常见服务器实现
   - 自定义服务器开发

4. **实战应用**
   - 集成自定义语言
   - 多语言管理
   - 代码审查增强

5. **最佳实践**
   - 性能优化
   - 错误处理
   - 日志记录

### 学习路径

```
Level 1: 理解 LSP
    ↓
了解协议和架构
    ↓
Level 2: 配置服务器
    ↓
使用现有 LSP 服务器
    ↓
Level 3: 集成到 Claude Code
    ↓
实现 LSP 客户端
    ↓
Level 4: 开发服务器
    ↓
创建自定义 LSP 服务器
```

### 相关资源

- [LSP 规范](https://microsoft.github.io/language-server-protocol/)
- [vscode-languageserver-node](https://github.com/microsoft/vscode-languageserver-node)
- [语言服务器列表](https://langserver.org/)

---

**最后更新**: 2026-01-18
**维护者**: knowknowcc 项目组
**反馈**: [GitHub Issues](https://github.com/anthropics/claude-code/issues)
