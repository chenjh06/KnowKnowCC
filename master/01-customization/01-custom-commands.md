# 自定义命令 - Claude Code 定制化指南

> **扩展 Claude Code 的能力边界**

**阅读时间**: 35分钟
**难度**: ⭐⭐⭐⭐
**重要性**: ⭐⭐⭐⭐⭐
**前置要求**: [核心功能详解](../../guide/02-core-features.md)

---

## 目录

- [自定义命令概述](#自定义命令概述)
- [命令创建方法](#命令创建方法)
- [命令参数和选项](#命令参数和选项)
- [命令链和组合](#命令链和组合)
- [实战案例](#实战案例)
- [Windows特定命令](#windows特定命令)
- [最佳实践](#最佳实践)
- [常见问题](#常见问题)
- [故障排查](#故障排查)

---

## 自定义命令概述

### 什么是自定义命令？

**自定义命令** 是用户根据自身需求定义的专用命令，用于：
- 封装重复性操作
- 自动化复杂工作流
- 扩展 Claude Code 原生功能
- 集成外部工具和服务

**示例**：
```
原生命令：
!npm test

自定义命令：
/test-backend        → 运行后端测试套件
/deploy-prod         → 部署到生产环境
/review-pr           → 审查 Pull Request
/generate-docs       → 生成项目文档
```

### 为什么需要自定义命令？

#### 1. 提高效率

**场景**：每次都要输入长命令
```powershell
# ❌ 每次都要输入完整命令
!cd "D:/Projects/MyApp/backend" && npm run test:unit && npm run test:integration

# ✅ 使用自定义命令
/test-backend
```

#### 2. 减少错误

**场景**：复杂命令容易输错
```powershell
# ❌ 容易出错
!git checkout -b feature/new-functionality && git push -u origin feature/new-functionality

# ✅ 自定义命令，一次定义，反复使用
/new-branch new-functionality
```

#### 3. 标准化流程

**场景**：团队统一操作规范
```
团队统一命令：
/build          → 标准构建流程
/deploy-staging → 部署到测试环境
/clean-cache    → 清理项目缓存
```

#### 4. 封装最佳实践

**场景**：将复杂最佳实践封装为简单命令
```powershell
# ✅ 封装代码审查最佳实践
/review-code
  → 运行 linter
  → 运行测试
  → 检查代码覆盖率
  → 生成审查报告
```

### 自定义命令的核心价值

| 价值维度 | 说明 | 效果 |
|---------|------|------|
| **效率提升** | 减少重复输入 | **10倍** 效率提升 |
| **错误减少** | 封装复杂逻辑 | **90%** 减少人为错误 |
| **流程标准化** | 统一团队规范 | **100%** 一致性 |
| **知识沉淀** | 最佳实践固化 | 持续积累 |
| **协作增强** | 共享命令库 | 团队协同 |

### 自定义命令的类型

#### 类型1：别名命令（Alias）

**定义**：为现有命令创建简短别名
```
定义：
alias test = !npm test

使用：
/test  → 等同于 !npm test
```

#### 类型2：组合命令（Composite）

**定义**：组合多个命令形成工作流
```
定义：
command build-and-test = {
  !npm run build
  !npm run test
  !npm run lint
}

使用：
/build-and-test  → 依次执行构建、测试、检查
```

#### 类型3：参数化命令（Parameterized）

**定义**：接受参数的动态命令
```
定义：
command deploy = (environment) {
  !npm run build
  !npm run deploy:$environment
}

使用：
/deploy staging   → 部署到测试环境
/deploy production → 部署到生产环境
```

#### 类型4：智能命令（Intelligent）

**定义**：包含条件判断的复杂命令
```
定义：
command smart-deploy = {
  if (git.has_uncommitted_changes()) {
    git.commit()
  }
  npm.run('test')
  if (tests.passed()) {
    npm.run('deploy')
  }
}

使用：
/smart-deploy  → 自动检查、测试、部署
```

### 自定义命令 vs 原生功能

| 维度 | 原生命令 | 自定义命令 |
|------|---------|-----------|
| **通用性** | 适用所有场景 | 特定使用场景 |
| **灵活性** | 固定功能 | 完全定制 |
| **复杂度** | 简单直接 | 可复杂可简单 |
| **维护** | 自动更新 | 需要手动维护 |
| **学习曲线** | 低 | 中等 |

---

## 命令创建方法

### 方法1：使用配置文件（推荐）✅

**配置文件位置**：
```
项目根目录/.claude/
├── commands.json        ← 命令定义
└── settings.json        ← 全局设置
```

**基本语法**：
```json
{
  "commands": [
    {
      "name": "test",
      "description": "运行测试套件",
      "action": "!npm test"
    },
    {
      "name": "build",
      "description": "构建项目",
      "action": "!npm run build"
    }
  ]
}
```

**完整示例**：
```json
{
  "version": "1.0",
  "commands": [
    {
      "name": "test-backend",
      "description": "运行后端测试",
      "action": "!cd backend && npm test",
      "parameters": [],
      "scope": "project"
    },
    {
      "name": "deploy",
      "description": "部署到指定环境",
      "action": "!npm run deploy:${env}",
      "parameters": [
        {
          "name": "env",
          "description": "目标环境",
          "required": true,
          "values": ["dev", "staging", "production"]
        }
      ],
      "scope": "project"
    }
  ]
}
```

**字段说明**：
- `name`: 命令名称（必需）
- `description`: 命令描述（推荐）
- `action`: 执行动作（必需）
- `parameters`: 参数列表（可选）
- `scope`: 作用域（project/global）

### 方法2：使用 CLI 创建

**创建别名命令**：
```bash
# 创建简单别名
claude command add test "!npm test"

# 创建带描述的命令
claude command add build \
  --description "构建项目" \
  --action "!npm run build"
```

**创建参数化命令**：
```bash
claude command add deploy \
  --description "部署到指定环境" \
  --action "!npm run deploy:${env}" \
  --parameters "env:Environment:required:dev,staging,production"
```

**创建组合命令**：
```bash
claude command add ci \
  --description "CI 流程" \
  --actions \
    "!npm install", \
    "!npm run build", \
    "!npm run test", \
    "!npm run lint"
```

### 方法3：使用脚本文件

**脚本文件位置**：
```
.claude/scripts/
├── build.sh           ← 构建脚本
├── deploy.sh          ← 部署脚本
└── test.sh            ← 测试脚本
```

**脚本示例**（`build.sh`）：
```bash
#!/bin/bash
# 项目构建脚本

set -e  # 遇到错误立即退出

echo "🔨 开始构建..."

# 清理旧构建
echo "🧹 清理旧构建..."
rm -rf dist/

# 安装依赖
echo "📦 安装依赖..."
npm ci

# 运行 linter
echo "🔍 运行 linter..."
npm run lint

# 运行测试
echo "🧪 运行测试..."
npm run test

# 构建
echo "🏗️ 构建项目..."
npm run build

echo "✅ 构建完成！"
```

**配置脚本命令**：
```json
{
  "commands": [
    {
      "name": "build",
      "description": "完整构建流程",
      "action": "!bash .claude/scripts/build.sh",
      "scope": "project"
    }
  ]
}
```

### 方法4：编程方式（高级）

**使用 Claude Code Agent SDK**：
```typescript
import { CommandRegistry } from '@anthropic-ai/claude-code-sdk';

// 注册自定义命令
CommandRegistry.register({
  name: 'analyze',
  description: '分析代码质量',
  handler: async (context) => {
    const files = await context.getFiles();
    const analysis = await analyzeCode(files);

    return {
      output: analysis.report,
      artifacts: analysis.artifacts
    };
  },
  parameters: {
    depth: {
      type: 'number',
      default: 1,
      description: '分析深度'
    }
  }
});
```

详见：[Agent SDK 使用指南](./04-agent-sdk.md)

---

## 命令参数和选项

### 基本参数使用

#### 必需参数

**定义**：
```json
{
  "name": "deploy",
  "action": "!npm run deploy:${env}",
  "parameters": [
    {
      "name": "env",
      "description": "部署环境",
      "required": true,
      "values": ["dev", "staging", "production"]
    }
  ]
}
```

**使用**：
```bash
/deploy dev
/deploy staging
/deploy production
```

#### 可选参数

**定义**：
```json
{
  "name": "test",
  "action": "!npm test --${coverage}",
  "parameters": [
    {
      "name": "coverage",
      "description": "是否生成覆盖率报告",
      "required": false,
      "default": "coverage",
      "values": ["coverage", "no-coverage"]
    }
  ]
}
```

**使用**：
```bash
/test              # 使用默认值（coverage）
/test coverage     # 显式指定
/test no-coverage  # 不生成覆盖率
```

### 高级参数选项

#### 参数验证

**定义验证规则**：
```json
{
  "name": "release",
  "action": "!npm run release:${version}",
  "parameters": [
    {
      "name": "version",
      "description": "发布版本号",
      "required": true,
      "validation": {
        "pattern": "^\\d+\\.\\d+\\.\\d+$",
        "message": "版本号格式必须是 x.y.z"
      }
    }
  ]
}
```

**使用**：
```bash
/release 1.2.3      # ✅ 有效
/release v1.2.3     # ❌ 无效
/release 1.2        # ❌ 无效
```

#### 多值参数

**定义**：
```json
{
  "name": "test",
  "action": "!npm test --${tests}",
  "parameters": [
    {
      "name": "tests",
      "description": "要运行的测试",
      "required": true,
      "multiple": true,
      "delimiter": ","
    }
  ]
}
```

**使用**：
```bash
/test login,auth,user     # 运行多个测试
/test all                # 运行所有测试
```

#### 标志参数

**定义**：
```json
{
  "name": "build",
  "action": "!npm run build ${flags}",
  "parameters": [
    {
      "name": "flags",
      "description": "构建选项",
      "type": "flags",
      "options": [
        { "name": "watch", "flag": "-w" },
        { "name": "verbose", "flag": "-v" },
        { "name": "production", "flag": "-p" }
      ]
    }
  ]
}
```

**使用**：
```bash
/build                    # 默认构建
/build -w                # 监视模式
/build -v -p             # 详细输出 + 生产模式
/build -w -v -p          # 组合标志
```

### 参数默认值和别名

**默认值**：
```json
{
  "name": "lint",
  "action": "!npm run lint --${format}",
  "parameters": [
    {
      "name": "format",
      "description": "输出格式",
      "default": "json",
      "values": ["json", "table", "verbose"],
      "aliases": {
        "j": "json",
        "t": "table",
        "v": "verbose"
      }
    }
  ]
}
```

**使用**：
```bash
/lint          # 使用默认值（json）
/lint json     # 显式指定
/lint j        # 使用别名
```

---

## 命令链和组合

### 顺序命令链

**定义**：依次执行多个命令
```json
{
  "name": "full-build",
  "description": "完整构建流程",
  "commands": [
    "!npm install",
    "!npm run lint",
    "!npm run test",
    "!npm run build"
  ]
}
```

**使用**：
```bash
/full-build
# 依次执行：
# 1. npm install
# 2. npm run lint
# 3. npm run test
# 4. npm run build
```

### 条件命令链

**定义**：根据条件执行不同命令
```json
{
  "name": "smart-deploy",
  "description": "智能部署",
  "condition": {
    "if": "${git.status} == 'clean'",
    "then": [
      "!npm run build",
      "!npm run deploy"
    ],
    "else": [
      "!echo '请先提交更改'",
      "!git status"
    ]
  }
}
```

**使用**：
```bash
/smart-deploy
# 如果 git 状态干净 → 构建并部署
# 如果有未提交更改 → 提示并显示状态
```

### 并行命令执行

**定义**：同时执行多个独立命令
```json
{
  "name": "test-all",
  "description": "运行所有测试",
  "parallel": [
    "!npm run test:unit",
    "!npm run test:integration",
    "!npm run test:e2e"
  ]
}
```

**使用**：
```bash
/test-all
# 并行执行：
# - 单元测试
# - 集成测试
# - E2E 测试
```

### 错误处理

**失败停止**：
```json
{
  "name": "build",
  "description": "构建（任何错误都会停止）",
  "commands": [
    "!npm run lint",      // 如果失败，停止
    "!npm run test",      // 如果失败，停止
    "!npm run build"      // 如果失败，停止
  ],
  "errorHandling": "stop"
}
```

**继续执行**：
```json
{
  "name": "check-all",
  "description": "检查所有（即使失败也继续）",
  "commands": [
    "!npm run lint",
    "!npm run test",
    "!npm run audit"
  ],
  "errorHandling": "continue"
}
```

### 命令输出捕获

**保存输出**：
```json
{
  "name": "test-report",
  "description": "生成测试报告",
  "commands": [
    {
      "action": "!npm test",
      "output": {
        "file": "test-results.json",
        "format": "json"
      }
    }
  ]
}
```

**传递输出**：
```json
{
  "name": "test-and-deploy",
  "description": "测试并部署",
  "commands": [
    {
      "name": "test",
      "action": "!npm test",
      "output": {
        "variable": "testResults"
      }
    },
    {
      "name": "deploy",
      "condition": "${testResults.success} == true",
      "action": "!npm run deploy"
    }
  ]
}
```

---

## 实战案例

### 案例1：项目快速启动命令

**场景**：每次启动项目需要多个步骤

**传统方式**：
```powershell
# ❌ 繁琐的启动流程
cd "D:/Projects/MyApp/backend"
npm install
npm run migrate
npm run seed
npm run dev

# 另一个终端
cd "D:/Projects/MyApp/frontend"
npm install
npm run dev
```

**自定义命令**：
```json
{
  "name": "start",
  "description": "启动完整开发环境",
  "commands": [
    {
      "name": "backend",
      "action": "!cd backend && npm install && npm run migrate && npm run seed && npm run dev",
      "background": true
    },
    {
      "name": "frontend",
      "action": "!cd frontend && npm install && npm run dev",
      "background": true
    }
  ],
  "parallel": true
}
```

**使用**：
```bash
/start
# ✅ 一键启动前后端
```

**效果**：
- ⏱️ 时间节省：从 5分钟 → 10秒
- 🎯 减少错误：避免遗漏步骤
- 😊 提升体验：一键启动

---

### 案例2：智能代码审查命令

**场景**：PR 前需要执行多项检查

**传统方式**：
```powershell
# ❌ 手动执行各项检查
npm run lint
npm run format-check
npm run test
npm run build
npm run type-check
npm run audit
```

**自定义命令**：
```json
{
  "name": "review",
  "description": "完整代码审查流程",
  "commands": [
    {
      "name": "lint",
      "action": "!npm run lint",
      "output": { "variable": "lintResults" }
    },
    {
      "name": "format",
      "action": "!npm run format-check",
      "output": { "variable": "formatResults" }
    },
    {
      "name": "test",
      "action": "!npm run test",
      "output": { "variable": "testResults" }
    },
    {
      "name": "build",
      "action": "!npm run build",
      "output": { "variable": "buildResults" }
    },
    {
      "name": "type-check",
      "action": "!npm run type-check",
      "output": { "variable": "typeResults" }
    },
    {
      "name": "audit",
      "action": "!npm run audit",
      "output": { "variable": "auditResults" }
    },
    {
      "name": "summary",
      "action": "!echo '审查完成：\\nLint: ${lintResults.success}\\nFormat: ${formatResults.success}\\nTest: ${testResults.success}\\nBuild: ${buildResults.success}\\nType: ${typeResults.success}\\nAudit: ${auditResults.success}'"
    }
  ],
  "errorHandling": "continue"
}
```

**使用**：
```bash
/review
# ✅ 自动执行所有检查并生成报告
```

**输出示例**：
```
审查完成：
Lint: ✅ 通过
Format: ✅ 通过
Test: ✅ 通过 (覆盖率 85%)
Build: ✅ 通过
Type: ✅ 通过
Audit: ⚠️ 发现 3 个低危漏洞
```

---

### 案例3：多环境部署命令

**场景**：需要部署到不同环境

**自定义命令**：
```json
{
  "name": "deploy",
  "description": "部署到指定环境",
  "parameters": [
    {
      "name": "env",
      "description": "目标环境",
      "required": true,
      "values": ["dev", "staging", "production"]
    }
  ],
  "commands": [
    {
      "name": "build",
      "action": "!npm run build:${env}",
      "output": { "variable": "buildOutput" }
    },
    {
      "name": "test",
      "condition": "${env} != 'dev'",
      "action": "!npm run test:${env}",
      "output": { "variable": "testOutput" }
    },
    {
      "name": "deploy",
      "action": "!npm run deploy:${env}",
      "condition": {
        "if": "${env} == 'production'",
        "then": "!echo '⚠️ 即将部署到生产环境，确认继续？' && !read -p '确认？[y/N] ' && !npm run deploy:${env}",
        "else": "!npm run deploy:${env}"
      }
    },
    {
      "name": "notify",
      "action": "!echo '✅ 部署到 ${env} 环境完成！'"
    }
  ]
}
```

**使用**：
```bash
/deploy dev          # 部署到开发环境
/deploy staging      # 部署到测试环境
/deploy production   # 部署到生产环境（需要确认）
```

**效果**：
- 🚀 一键部署到任意环境
- ✅ 自动执行环境特定检查
- ⚠️ 生产环境二次确认
- 📊 部署状态反馈

---

### 案例4：文档生成命令

**场景**：自动生成项目文档

**自定义命令**：
```json
{
  "name": "docs",
  "description": "生成项目文档",
  "parameters": [
    {
      "name": "type",
      "description": "文档类型",
      "required": false,
      "default": "all",
      "values": ["api", "readme", "all"]
    }
  ],
  "commands": [
    {
      "name": "api-docs",
      "condition": "${type} == 'api' || ${type} == 'all'",
      "action": "!npm run docs:api",
      "output": { "file": "docs/api.md" }
    },
    {
      "name": "readme",
      "condition": "${type} == 'readme' || ${type} == 'all'",
      "action": "!npm run docs:readme",
      "output": { "file": "README.md" }
    },
    {
      "name": "serve",
      "action": "!npx http-server docs/ -p 8080",
      "background": true
    },
    {
      "name": "open",
      "action": "!start http://localhost:8080"
    }
  ]
}
```

**使用**：
```bash
/docs           # 生成所有文档并在浏览器中打开
/docs api       # 只生成 API 文档
/docs readme    # 只生成 README
```

---

## Windows特定命令

### Windows 命令特点

#### PowerShell 特定语法

**使用 PowerShell 变量**：
```json
{
  "name": "ps-info",
  "description": "显示系统信息",
  "action": "!powershell -Command \"Write-Host 'PowerShell版本:' $PSVersionTable.PSVersion\""
}
```

**使用 Windows 环境变量**：
```json
{
  "name": "env-check",
  "description": "检查环境变量",
  "action": "!echo %PATH% && echo %NODE_ENV% && echo %APPDATA%"
}
```

#### Windows 路径处理

**正确使用路径**：
```json
{
  "name": "clean-cache",
  "description": "清理缓存",
  "action": "!Remove-Item -Recurse -Force \"$env:LOCALAPPDATA\\npm-cache\""
}
```

**路径参数**：
```json
{
  "name": "open-project",
  "description": "打开项目目录",
  "parameters": [
    {
      "name": "path",
      "description": "项目路径",
      "required": true
    }
  ],
  "action": "!explorer \"${path}\""
}
```

#### Windows 服务管理

**管理 Windows 服务**：
```json
{
  "name": "service",
  "description": "管理服务",
  "parameters": [
    {
      "name": "action",
      "description": "操作",
      "required": true,
      "values": ["start", "stop", "restart", "status"]
    },
    {
      "name": "name",
      "description": "服务名称",
      "required": true
    }
  ],
  "action": "!powershell -Command \"${action}-Service -Name '${name}'\""
}
```

**使用**：
```bash
/service start MongoDB
/service stop MySQL
/service status nginx
```

### Windows 特定命令示例

#### 清理系统临时文件

```json
{
  "name": "cleanup-temp",
  "description": "清理 Windows 临时文件",
  "commands": [
    {
      "name": "user-temp",
      "action": "!Remove-Item -Recurse -Force \"$env:TEMP\\*\" -ErrorAction SilentlyContinue"
    },
    {
      "name": "system-temp",
      "action": "!Remove-Item -Recurse -Force \"C:\\Windows\\Temp\\*\" -ErrorAction SilentlyContinue"
    },
    {
      "name": "prefetch",
      "action": "!Remove-Item -Recurse -Force \"C:\\Windows\\Prefetch\\*\" -ErrorAction SilentlyContinue"
    },
    {
      "name": "recycle",
      "action": "!Clear-RecycleBin -Force"
    }
  ]
}
```

#### 网络诊断

```json
{
  "name": "net-diag",
  "description": "网络诊断",
  "commands": [
    {
      "name": "dns",
      "action": "!powershell -Command \"Resolve-DnsName google.com\""
    },
    {
      "name": "ping",
      "action": "!ping -n 4 google.com"
    },
    {
      "name": "trace",
      "action": "!tracert google.com"
    },
    {
      "name": "proxy",
      "action": "!netsh winhttp show proxy"
    }
  ]
}
```

#### Git 操作增强

```json
{
  "name": "git-clean",
  "description": "清理 Git 工作区",
  "commands": [
    {
      "name": "status",
      "action": "!git status"
    },
    {
      "name": "clean",
      "action": "!git clean -fd"
    },
    {
      "name": "reset",
      "action": "!git reset --hard HEAD"
    }
  ]
}
```

---

## 最佳实践

### 命令命名规范

#### 1. 使用动词开头

```
✅ 好的命名：
/build
/test
/deploy
/review

❌ 避免：
builder
testing
deployment
reviewer
```

#### 2. 使用连字符分隔

```
✅ 好的命名：
/build-production
/test-integration
/deploy-staging

❌ 避免：
build_production
testIntegration
deploystaging
```

#### 3. 保持简短但清晰

```
✅ 好的命名：
/test-backend
/deploy-prod
/gen-docs

❌ 避免：
/runBackendTests
/deployToProductionEnvironment
/generateAllDocumentation
```

### 命令组织结构

#### 按功能分类

```
项目根目录/.claude/commands/
├── build/              ← 构建相关
│   ├── dev.json
│   ├── staging.json
│   └── production.json
├── test/               ← 测试相关
│   ├── unit.json
│   ├── integration.json
│   └── e2e.json
├── deploy/             ← 部署相关
│   ├── dev.json
│   ├── staging.json
│   └── production.json
└── tools/              ← 工具相关
    ├── lint.json
    ├── format.json
    └── docs.json
```

#### 使用命名空间

```json
{
  "name": "test:unit",
  "namespace": "test",
  "description": "运行单元测试"
}

{
  "name": "test:integration",
  "namespace": "test",
  "description": "运行集成测试"
}

{
  "name": "deploy:staging",
  "namespace": "deploy",
  "description": "部署到测试环境"
}
```

### 参数设计原则

#### 1. 提供合理的默认值

```json
{
  "name": "test",
  "parameters": [
    {
      "name": "coverage",
      "default": true,
      "description": "是否生成覆盖率报告"
    }
  ]
}
```

#### 2. 使用枚举限制选项

```json
{
  "name": "deploy",
  "parameters": [
    {
      "name": "env",
      "values": ["dev", "staging", "production"],
      "description": "部署环境"
    }
  ]
}
```

#### 3. 提供清晰的描述

```json
{
  "name": "release",
  "parameters": [
    {
      "name": "version",
      "description": "版本号，格式：x.y.z",
      "example": "1.2.3"
    }
  ]
}
```

### 错误处理策略

#### 1. 提供有用的错误信息

```json
{
  "name": "deploy",
  "commands": [
    {
      "name": "check",
      "action": "!npm run build",
      "onError": {
        "message": "构建失败，无法部署",
        "action": "!exit 1"
      }
    }
  ]
}
```

#### 2. 使用回退机制

```json
{
  "name": "install",
  "commands": [
    {
      "name": "npm",
      "action": "!npm install",
      "onError": {
        "fallback": "!yarn install"
      }
    }
  ]
}
```

#### 3. 记录详细日志

```json
{
  "name": "deploy",
  "commands": [
    {
      "name": "build",
      "action": "!npm run build",
      "logging": {
        "level": "verbose",
        "file": "logs/deploy.log"
      }
    }
  ]
}
```

### 文档和注释

#### 1. 添加详细描述

```json
{
  "name": "deploy",
  "description": "部署应用到指定环境",
  "longDescription": `
    部署应用到指定环境。

    流程：
    1. 运行测试
    2. 构建应用
    3. 部署到目标环境
    4. 健康检查
    5. 发送通知

    示例：
    /deploy staging
    /deploy production
  `
}
```

#### 2. 提供使用示例

```json
{
  "name": "test",
  "examples": [
    {
      "command": "/test",
      "description": "运行所有测试"
    },
    {
      "command": "/test unit",
      "description": "只运行单元测试"
    },
    {
      "command": "/test integration --coverage",
      "description": "运行集成测试并生成覆盖率"
    }
  ]
}
```

#### 3. 记录变更历史

```json
{
  "name": "deploy",
  "changelog": [
    {
      "version": "2.0.0",
      "date": "2025-01-15",
      "changes": [
        "添加健康检查",
        "改进错误处理"
      ]
    }
  ]
}
```

---

## 常见问题

### Q1: 自定义命令不工作怎么办？

**A**: 检查以下几点：

```powershell
# 1. 检查配置文件是否存在
Test-Path ".claude/commands.json"

# 2. 检查 JSON 格式是否正确
Get-Content ".claude/commands.json" | ConvertFrom-Json

# 3. 检查命令语法
claude command list

# 4. 查看详细错误
claude command test <your-command>
```

**常见原因**：
- JSON 格式错误
- 命令名称冲突
- 语法错误
- 文件路径错误

### Q2: 如何调试自定义命令？

**A**: 使用调试模式

```bash
# 运行时查看详细输出
claude command run <command> --verbose

# 查看命令定义
claude command inspect <command>

# 测试命令语法
claude command validate <command>
```

**调试技巧**：
```json
{
  "name": "debug-test",
  "commands": [
    {
      "name": "step1",
      "action": "!echo '步骤1'",
      "debug": true
    },
    {
      "name": "step2",
      "action": "!echo '步骤2'",
      "debug": true
    }
  ]
}
```

### Q3: 如何共享自定义命令？

**A**: 三种方式

**方式1：项目内共享**（推荐）
```json
// .claude/commands.json
// 命令定义提交到 Git
git add .claude/commands.json
git commit -m "添加自定义命令"
```

**方式2：命令包**
```bash
# 创建命令包
claude command package export my-commands.tar.gz

# 导入命令包
claude command package import my-commands.tar.gz
```

**方式3：命令仓库**
```bash
# 发布到 npm
npm publish @my-org/claude-commands

# 安装命令
npm install -g @my-org/claude-commands
```

### Q4: 自定义命令会影响性能吗？

**A**: 通常不会

**性能优化技巧**：
```json
{
  "name": "fast-command",
  "performance": {
    "cache": true,           // 缓存结果
    "parallel": true,        // 并行执行
    "timeout": 30000         // 超时时间
  }
}
```

**避免的情况**：
- 过度使用嵌套命令
- 不必要的文件 I/O
- 阻塞操作

### Q5: 如何处理敏感信息？

**A**: 使用环境变量

```json
{
  "name": "deploy-prod",
  "action": "!npm run deploy --api-key ${API_KEY}",
  "parameters": [
    {
      "name": "API_KEY",
      "type": "env",
      "required": true,
      "secret": true
    }
  ]
}
```

**设置环境变量**：
```powershell
# Windows
$env:API_KEY="your-api-key"

# macOS/Linux
export API_KEY="your-api-key"
```

### Q6: 如何迁移旧命令到新版本？

**A**: 使用迁移工具

```bash
# 自动迁移
claude command migrate --from v1 --to v2

# 手动迁移
claude command export old-format.json
claude command import new-format.json
```

**迁移检查清单**：
- [ ] 语法兼容性
- [ ] 参数变化
- [ ] 输出格式
- [ ] 错误处理

### Q7: 如何回滚命令变更？

**A**: 使用版本控制

```bash
# Git 方式
git diff .claude/commands.json
git checkout .claude/commands.json

# 快照方式
claude command snapshot save before-change
claude command snapshot restore before-change
```

### Q8: 命令冲突如何处理？

**A**: 使用优先级和别名

```json
{
  "commands": [
    {
      "name": "test",
      "priority": 100,           // 高优先级
      "namespace": "local"
    },
    {
      "name": "test",
      "priority": 50,            // 低优先级
      "namespace": "global"
    }
  ]
}
```

**使用别名避免冲突**：
```json
{
  "name": "test",
  "aliases": ["t", "test-local"]
}
```

---

## 故障排查

### 问题1：命令无法识别

**症状**：
```
Command not found: /my-command
```

**诊断步骤**：
```powershell
# 1. 检查命令文件
Test-Path ".claude/commands.json"

# 2. 验证 JSON 格式
Get-Content ".claude/commands.json" | ConvertFrom-Json

# 3. 列出所有命令
claude command list

# 4. 搜索命令
claude command list | Select-String "my-command"
```

**解决方案**：
- ✅ 检查文件路径是否正确
- ✅ 验证 JSON 语法
- ✅ 重新加载命令：`claude command reload`
- ✅ 检查命令名称拼写

### 问题2：命令执行失败

**症状**：
```
Error: Command failed with exit code 1
```

**诊断步骤**：
```powershell
# 1. 查看详细错误
claude command run <command> --verbose

# 2. 检查日志
Get-Content ".claude/logs/command.log"

# 3. 测试单个命令
!npm test  # 测试实际命令
```

**解决方案**：
- ✅ 检查命令语法
- ✅ 验证参数传递
- ✅ 查看错误日志
- ✅ 测试基础命令

### 问题3：参数传递错误

**症状**：
```
Parameter 'env' is required but not provided
```

**诊断步骤**：
```json
{
  "name": "test-deploy",
  "description": "测试部署",
  "parameters": [
    {
      "name": "env",
      "required": true
    }
  ]
}
```

**检查调用**：
```bash
# ❌ 缺少参数
/deploy

# ✅ 提供参数
/deploy staging
```

**解决方案**：
- ✅ 提供所有必需参数
- ✅ 检查参数格式
- ✅ 验证参数值
- ✅ 使用默认值

### 问题4：权限问题

**症状**：
```
Access denied: Unable to execute command
```

**诊断步骤**：
```powershell
# 检查文件权限
Get-Acl ".claude/commands.json"

# 检查执行权限
Test-Path ".claude/scripts/deploy.sh"
```

**解决方案**：
```powershell
# 以管理员身份运行
Start-Process powershell -Verb RunAs

# 修改文件权限
icacls ".claude/commands.json" /grant "$env:USERNAME:F"

# 修改脚本权限
chmod +x .claude/scripts/*.sh
```

### 问题5：路径问题（Windows）

**症状**：
```
Error: Path not found: D:\Projects\MyApp
```

**解决方案**：
```json
{
  "name": "my-command",
  "action": "!cd 'D:/Projects/MyApp' && npm test"
}
```

**最佳实践**：
- ✅ 使用正斜杠 `/`
- ✅ 使用单引号包裹路径
- ✅ 避免空格（或使用引号）
- ✅ 使用相对路径

---

## 进阶主题

### 命令模板

**创建可重用模板**：
```json
{
  "templates": [
    {
      "name": "deploy-template",
      "description": "标准部署流程",
      "variables": [
        { "name": "ENV", "description": "环境" },
        { "name": "SERVICE", "description": "服务名" }
      ],
      "template": `
        !npm run build:${ENV}
        !npm run test:${ENV}
        !npm run deploy:${ENV} --service ${SERVICE}
      `
    }
  ]
}
```

**使用模板**：
```json
{
  "name": "deploy-backend",
  "template": "deploy-template",
  "variables": {
    "ENV": "staging",
    "SERVICE": "backend"
  }
}
```

### 命令钩子

**定义生命周期钩子**：
```json
{
  "name": "deploy",
  "hooks": {
    "before": [
      "!echo '开始部署前检查'",
      "!npm run check"
    ],
    "after": [
      "!echo '部署完成，清理临时文件'",
      "!npm run cleanup"
    ],
    "onError": [
      "!echo '部署失败，回滚'",
      "!npm run rollback"
    ]
  }
}
```

### 命令条件

**复杂条件判断**：
```json
{
  "name": "smart-build",
  "condition": {
    "and": [
      { "fileExists": "package.json" },
      { "gitBranch": "main" },
      { "envVar": { "name": "CI", "value": "true" } }
    ]
  },
  "commands": [
    "!npm run build"
  ]
}
```

---

## 总结

### 关键要点

1. **自定义命令的价值**
   - 提高效率 10 倍
   - 减少 90% 错误
   - 标准化团队流程

2. **四种创建方法**
   - 配置文件（推荐）
   - CLI 创建
   - 脚本文件
   - 编程方式（高级）

3. **参数化设计**
   - 必需/可选参数
   - 参数验证
   - 默认值和别名

4. **命令组合**
   - 顺序执行
   - 条件执行
   - 并行执行
   - 错误处理

5. **最佳实践**
   - 命名规范
   - 参数设计
   - 错误处理
   - 文档注释

### 学习路径

```
Level 1: 基础命令
    ↓
创建简单别名
    ↓
Level 2: 参数化命令
    ↓
动态参数和验证
    ↓
Level 3: 复杂命令链
    ↓
条件、并行、错误处理
    ↓
Level 4: 命令生态
    ↓
模板、钩子、插件
```

### 相关资源

- [Agent SDK 使用指南](./04-agent-sdk.md)
- [插件系统](../03-advanced-topics/02-plugins.md)
- [CI/CD 集成](../02-automation/02-ci-cd-integration.md)

---

**最后更新**: 2026-01-18
**维护者**: knowknowcc 项目组
**反馈**: [GitHub Issues](https://github.com/anthropics/claude-code/issues)
