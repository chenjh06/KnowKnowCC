# 插件系统 - Claude Code 扩展生态

> **构建和发现强大的插件**

**阅读时间**: 35分钟
**难度**: ⭐⭐⭐⭐
**重要性**: ⭐⭐⭐⭐
**前置要求**: [自定义命令](../01-customization/01-custom-commands.md)

---

## 目录

- [插件系统概述](#插件系统概述)
- [插件架构](#插件架构)
- [插件开发](#插件开发)
- [插件管理](#插件管理)
- [社区插件](#社区插件)
- [实战案例](#实战案例)
- [Windows特定](#windows特定)
- [最佳实践](#最佳实践)
- [常见问题](#常见问题)
- [故障排查](#故障排查)

---

## 插件系统概述

### 什么是插件？

**插件（Plugin）** 是扩展 Claude Code 功能的独立模块，可以：
- 添加新的命令和功能
- 集成外部服务和 API
- 自定义工作流程
- 扩展 Claude 的能力边界

**示例**：
```
插件类型：
├─ 语言支持（Python、Go、Rust）
├─ 框架集成（React、Vue、Django）
├─ 工具集成（Docker、Kubernetes）
├─ 服务连接（AWS、Azure、GCP）
└─ 自定义功能（团队工具、内部服务）
```

### 为什么需要插件？

#### 1. 功能扩展

**场景**：添加特定语言支持
```
原生命令：
缺少对特定语言/框架的深度支持

插件解决方案：
安装 Python 插件 → 获得完整的 Python 开发支持
├─ 虚拟环境管理
├─ 依赖管理（pip、poetry）
├─ 测试框架集成（pytest）
└─ 代码质量工具（black、ruff）
```

#### 2. 团队定制

**场景**：集成团队内部工具
```
插件可以：
├─ 连接内部 API
├─ 集成监控系统
├─ 自动化工作流
└─ 统一开发规范
```

#### 3. 生态共享

**场景**：使用社区最佳实践
```
社区插件提供：
├─ 行业标准工具
├─ 最佳实践封装
├─ 即用型解决方案
└─ 持续更新维护
```

### 插件 vs 自定义命令

| 维度 | 自定义命令 | 插件 |
|------|-----------|------|
| **复杂度** | 简单到中等 | 复杂 |
| **可重用性** | 项目特定 | 跨项目/跨团队 |
| **分发** | Git 共享 | 插件市场 |
| **维护** | 手动 | 版本管理 |
| **功能** | 命令封装 | 完整功能扩展 |
| **依赖** | 无 | 可依赖其他插件 |

### 插件的核心价值

| 价值维度 | 说明 | 效果 |
|---------|------|------|
| **能力扩展** | 添加新功能 | **无限** 扩展可能 |
| **生态共享** | 社区贡献 | **1000+** 插件可用 |
| **团队定制** | 内部工具集成 | **完美** 适配需求 |
| **维护性** | 独立版本管理 | **清晰** 责任边界 |
| **性能** | 按需加载 | **最小** 性能影响 |

---

## 插件架构

### 架构概览

```
Claude Code 核心
    ↓
插件系统（Plugin System）
    ↓
├─ 插件管理器（Plugin Manager）
│   ├─ 发现（Discovery）
│   ├─ 安装（Installation）
│   ├─ 加载（Loading）
│   └─ 生命周期（Lifecycle）
│
├─ 插件 API（Plugin API）
│   ├─ 命令注册（Command Registration）
│   ├─ 事件订阅（Event Subscription）
│   ├─ 配置管理（Configuration）
│   └─ 数据存储（Data Storage）
│
└─ 插件沙箱（Plugin Sandbox）
    ├─ 隔离执行（Isolation）
    ├─ 权限控制（Permission）
    └─ 资源限制（Resource Limit）
```

### 插件生命周期

```
1. 发现（Discovery）
   ├─ 本地插件扫描
   ├─ 插件市场搜索
   └─ 依赖解析

2. 安装（Installation）
   ├─ 下载插件包
   ├─ 安装依赖
   └─ 初始化配置

3. 激活（Activation）
   ├─ 加载插件代码
   ├─ 注册命令和功能
   └─ 订阅事件

4. 运行（Runtime）
   ├─ 响应命令
   ├─ 处理事件
   └─ 维护状态

5. 停用（Deactivation）
   ├─ 保存状态
   ├─ 清理资源
   └─ 注销注册

6. 卸载（Uninstallation）
   ├─ 删除文件
   ├─ 清理配置
   └─ 移除依赖
```

### 插件 API

#### 命令注册 API

```typescript
import { Plugin } from '@anthropic-ai/claude-code-plugin';

export default class MyPlugin implements Plugin {
  name = 'my-plugin';
  version = '1.0.0';

  registerCommands(commands: CommandRegistry) {
    commands.register({
      name: 'my-command',
      handler: async (context) => {
        // 命令逻辑
        return { success: true };
      }
    });
  }
}
```

#### 事件订阅 API

```typescript
export default class MyPlugin implements Plugin {
  subscribe(events: EventRegistry) {
    events.on('file.save', async (file) => {
      // 文件保存时的处理
      await this.formatFile(file);
    });

    events.on('command.before', async (command) => {
      // 命令执行前的处理
      await this.logCommand(command);
    });
  }
}
```

#### 配置管理 API

```typescript
export default class MyPlugin implements Plugin {
  async activate(config: PluginConfig) {
    // 读取配置
    const apiKey = config.get('apiKey');
    const timeout = config.get('timeout', 5000);

    // 设置默认值
    config.defaults({
      timeout: 5000,
      retries: 3
    });
  }
}
```

### 插件沙箱

**隔离机制**：
```typescript
// 插件运行在独立的上下文中
{
  "sandbox": {
    "isolation": "vm",           // 虚拟机隔离
    "permissions": [             // 权限控制
      "read:files",
      "write:files",
      "network:request"
    ],
    "limits": {                  // 资源限制
      "memory": "512MB",
      "cpu": "50%",
      "timeout": "30s"
    }
  }
}
```

---

## 插件开发

### 开发环境准备

#### 1. 安装 CLI 工具

```bash
# 全局安装插件开发工具
npm install -g @anthropic-ai/claude-plugin-cli

# 验证安装
claude-plugin --version
```

#### 2. 创建插件项目

```bash
# 创建新插件
claude-plugin create my-awesome-plugin

# 选择模板
? 选择模板：
  ❯ 命令插件（Command Plugin）
    事件插件（Event Plugin）
    语言插件（Language Plugin）
    集成插件（Integration Plugin）

# 生成的项目结构
my-awesome-plugin/
├── package.json
├── README.md
├── src/
│   ├── index.ts         ← 插件入口
│   ├── commands.ts      ← 命令定义
│   └── config.ts        ← 配置管理
├── tests/               ← 测试
└── .claude/             ← 配置
    └── plugin.json      ← 插件清单
```

### 插件清单

**`.claude/plugin.json`**:
```json
{
  "name": "my-awesome-plugin",
  "version": "1.0.0",
  "description": "我的第一个 Claude Code 插件",
  "author": "Your Name",
  "license": "MIT",
  "main": "dist/index.js",
  "types": "dist/index.d.ts",
  "claude": {
    "minVersion": "3.0.0",
    "permissions": [
      "read:files",
      "write:files",
      "network:request"
    ],
    "commands": [
      {
        "name": "awesome-do",
        "description": "执行超酷的操作"
      }
    ],
    "events": [
      "file.save",
      "command.after"
    ],
    "config": {
      "apiKey": {
        "type": "string",
        "description": "API 密钥",
        "required": true,
        "secret": true
      },
      "timeout": {
        "type": "number",
        "description": "超时时间（毫秒）",
        "default": 5000
      }
    }
  },
  "dependencies": {
    "@anthropic-ai/claude-plugin-api": "^3.0.0"
  }
}
```

### 实现插件

#### 类型1：命令插件

**`src/commands.ts`**:
```typescript
import { CommandContext, CommandResult } from '@anthropic-ai/claude-plugin-api';

export async function doAwesome(context: CommandContext): Promise<CommandResult> {
  const { args, config, workspace } = context;

  // 读取配置
  const timeout = config.get<number>('timeout', 5000);

  // 获取参数
  const target = args.get('target', '.');
  const force = args.get<boolean>('force', false);

  try {
    // 执行操作
    const result = await processTarget(target, { force, timeout });

    return {
      success: true,
      message: `成功处理 ${target}`,
      data: result
    };
  } catch (error) {
    return {
      success: false,
      message: `处理失败: ${error.message}`,
      error: error
    };
  }
}

async function processTarget(target: string, options: any) {
  // 实际处理逻辑
  return { processed: true };
}
```

**`src/index.ts`**:
```typescript
import { Plugin, CommandRegistry } from '@anthropic-ai/claude-plugin-api';
import * as commands from './commands';

export default class AwesomePlugin implements Plugin {
  name = 'my-awesome-plugin';
  version = '1.0.0';

  registerCommands(registry: CommandRegistry) {
    registry.register({
      name: 'awesome-do',
      description: '执行超酷的操作',
      handler: commands.doAwesome,
      parameters: [
        {
          name: 'target',
          description: '目标路径',
          required: false,
          default: '.'
        },
        {
          name: 'force',
          description: '强制执行',
          type: 'boolean',
          default: false
        }
      ]
    });
  }
}
```

#### 类型2：事件插件

**`src/events.ts`**:
```typescript
import { EventContext } from '@anthropic-ai/claude-plugin-api';

export async function onFileSave(context: EventContext) {
  const { file, workspace } = context;

  // 只处理特定类型文件
  if (file.path.endsWith('.ts')) {
    // 自动格式化 TypeScript 文件
    await formatTypeScript(file);

    // 运行 linter
    await runLinter(file);
  }
}

export async function onCommandAfter(context: EventContext) {
  const { command, result } = context;

  // 命令执行后记录日志
  await logCommand(command, result);
}
```

**`src/index.ts`**:
```typescript
import { Plugin, EventRegistry } from '@anthropic-ai/claude-plugin-api';
import * as events from './events';

export default class AwesomePlugin implements Plugin {
  name = 'my-awesome-plugin';
  version = '1.0.0';

  subscribeEvents(registry: EventRegistry) {
    registry.on('file.save', events.onFileSave);
    registry.on('command.after', events.onCommandAfter);
  }
}
```

#### 类型3：语言插件

**`src/language.ts`**:
```typescript
import { LanguageSupport } from '@anthropic-ai/claude-plugin-api';

export default class PythonPlugin implements LanguageSupport {
  language = 'python';
  extensions = ['.py', '.pyw'];

  async detect(file: string): Promise<boolean> {
    return file.endsWith('.py');
  }

  async analyze(file: string): Promise<Analysis> {
    const content = await readFile(file);

    return {
      imports: this.extractImports(content),
      functions: this.extractFunctions(content),
      classes: this.extractClasses(content),
      dependencies: this.extractDependencies(content)
    };
  }

  async run(file: string, args: string[]): Promise<RunResult> {
    // 运行 Python 脚本
    return execute(`python ${file} ${args.join(' ')}`);
  }

  async test(file: string): Promise<TestResult> {
    // 运行测试
    return execute(`pytest ${file}`);
  }
}
```

### 构建和测试

#### 构建插件

```bash
# 开发模式构建
npm run build:dev

# 生产模式构建
npm run build

# 监视模式
npm run build:watch
```

#### 本地测试

```bash
# 链接到 Claude Code
npm link

# 在项目中测试
claude plugin link ../my-awesome-plugin

# 运行插件命令
claude awesome-do --target ./src

# 查看日志
claude plugin logs my-awesome-plugin
```

#### 单元测试

**`tests/commands.test.ts`**:
```typescript
import { describe, it, expect } from 'vitest';
import { doAwesome } from '../src/commands';

describe('doAwesome', () => {
  it('should process target successfully', async () => {
    const context = {
      args: new Map([['target', '.']]),
      config: new Map([['timeout', 5000]]),
      workspace: '/tmp/test'
    };

    const result = await doAwesome(context);

    expect(result.success).toBe(true);
    expect(result.message).toContain('成功');
  });

  it('should handle errors gracefully', async () => {
    const context = {
      args: new Map([['target', '/invalid/path']]),
      config: new Map([['timeout', 5000]]),
      workspace: '/tmp/test'
    };

    const result = await doAwesome(context);

    expect(result.success).toBe(false);
    expect(result.error).toBeDefined();
  });
});
```

---

## 插件管理

### 安装插件

#### 从插件市场安装

```bash
# 搜索插件
claude plugin search python
claude plugin search docker
claude plugin search react

# 安装插件
claude plugin install @claude-plugins/python-support

# 查看详情
claude plugin info @claude-plugins/python-support

# 安装特定版本
claude plugin install @claude-plugins/python-support@2.1.0
```

#### 从 Git 安装

```bash
# 从 GitHub 安装
claude plugin install https://github.com/user/my-plugin

# 从 GitLab 安装
claude plugin install https://gitlab.com/user/my-plugin

# 从特定分支安装
claude plugin install https://github.com/user/my-plugin#develop
```

#### 本地安装

```bash
# 从本地路径安装
claude plugin install ./my-plugin

# 链接开发中的插件
claude plugin link ../my-plugin
```

### 配置插件

#### 全局配置

```json
// ~/.claude/config.json
{
  "plugins": {
    "@claude-plugins/python-support": {
      "pythonPath": "python3",
      "venvPath": ".venv",
      "autoActivate": true
    },
    "@claude-plugins/docker": {
      "dockerPath": "docker",
      "composePath": "docker-compose"
    }
  }
}
```

#### 项目配置

```json
// .claude/settings.json
{
  "plugins": {
    "@claude-plugins/python-support": {
      "enabled": true,
      "testFramework": "pytest",
      "linter": "ruff"
    }
  }
}
```

### 管理已安装插件

#### 列出插件

```bash
# 列出所有插件
claude plugin list

# 查看已启用插件
claude plugin list --enabled

# 查看待更新插件
claude plugin list --outdated
```

#### 更新插件

```bash
# 更新所有插件
claude plugin update

# 更新特定插件
claude plugin update @claude-plugins/python-support

# 更新到主版本
claude plugin update @claude-plugins/python-support --major
```

#### 卸载插件

```bash
# 卸载插件
claude plugin uninstall @claude-plugins/python-support

# 卸载并清理配置
claude plugin uninstall @claude-plugins/python-support --purge
```

#### 启用/禁用插件

```bash
# 禁用插件
claude plugin disable @claude-plugins/python-support

# 启用插件
claude plugin enable @claude-plugins/python-support

# 临时禁用（当前会话）
claude plugin disable @claude-plugins/python-support --session
```

### 插件调试

#### 查看插件日志

```bash
# 查看所有插件日志
claude plugin logs

# 查看特定插件日志
claude plugin logs @claude-plugins/python-support

# 实时查看日志
claude plugin logs --follow

# 查看最近100行
claude plugin logs --tail 100
```

#### 诊断插件问题

```bash
# 检查插件状态
claude plugin doctor @claude-plugins/python-support

# 检查所有插件
claude plugin doctor

# 详细诊断
claude plugin doctor --verbose
```

---

## 社区插件

### 热门插件

#### 开发工具类

**@claude-plugins/python-support** ⭐⭐⭐⭐⭐
```
Python 开发完整支持
├─ 虚拟环境管理（venv、conda、poetry）
├─ 依赖管理（pip、poetry、pipenv）
├─ 测试框架（pytest、unittest）
├─ 代码质量（black、ruff、mypy）
└─ Jupyter Notebook 支持
```

**@claude-plugins/docker-manager** ⭐⭐⭐⭐⭐
```
Docker 容器管理
├─ 容器创建和启动
├─ 镜像构建和管理
├─ Docker Compose 集成
├─ 容器日志查看
└─ 资源监控
```

**@claude-plugins/kubernetes-helper** ⭐⭐⭐⭐
```
Kubernetes 集群管理
├─ Pod 部署和管理
├─ Service 和 Ingress 配置
├─ ConfigMap 和 Secret 管理
├─ 日志流查看
└─ 资源监控
```

#### 框架集成类

**@claude-plugins/react-devtools** ⭐⭐⭐⭐⭐
```
React 开发增强
├─ 组件快速生成
├─ Hooks 模板库
├─ 性能分析工具
├─ Redux 集成
└─ Next.js 支持
```

**@claude-plugins/vue-helper** ⭐⭐⭐⭐
```
Vue.js 开发支持
├─ 组件脚手架
├─ Composition API 模板
├─ Vuex 集成
├─ Nuxt.js 支持
└─ Vue Router 配置
```

#### 云服务类

**@claude-plugins/aws-toolkit** ⭐⭐⭐⭐⭐
```
AWS 服务集成
├─ S3 文件管理
├─ Lambda 函数部署
├─ EC2 实例管理
├─ RDS 数据库操作
└─ CloudWatch 监控
```

**@claude-plugins/github-integration** ⭐⭐⭐⭐⭐
```
GitHub 深度集成
├─ PR 创建和管理
├─ Issue 自动分类
├─ Actions 工作流触发
├─ 代码审查辅助
└─ Release 管理
```

### 插件质量评估

#### 评估标准

| 维度 | 标准 | 权重 |
|------|------|------|
| **功能性** | 是否解决实际问题 | 30% |
| **稳定性** | 是否稳定可靠 | 25% |
| **维护性** | 是否持续更新 | 20% |
| **文档** | 是否有完善文档 | 15% |
| **社区** | 是否活跃社区 | 10% |

#### 查看插件质量

```bash
# 查看插件评分
claude plugin info @claude-plugins/python-support

# 输出示例：
Plugin: @claude-plugins/python-support
Version: 2.5.0
Rating: ⭐⭐⭐⭐⭐ (4.8/5.0)
Downloads: 125,000
Last Updated: 2025-01-10
Maintainer: Claude Team
License: MIT

Quality Metrics:
├─ Functionality: ⭐⭐⭐⭐⭐
├─ Stability: ⭐⭐⭐⭐⭐
├─ Maintenance: ⭐⭐⭐⭐⭐
├─ Documentation: ⭐⭐⭐⭐
└─ Community: ⭐⭐⭐⭐⭐
```

### 插件贡献

#### 发布插件

```bash
# 登录插件市场
claude plugin login

# 发布插件
claude plugin publish

# 发布特定版本
claude plugin publish --version 1.0.0

# 从 CI/CD 发布
claude plugin publish --token $CLAUDE_PLUGIN_TOKEN
```

#### 插件清单验证

```bash
# 验证 plugin.json
claude plugin validate

# 输出示例：
✅ plugin.json 格式正确
✅ 所有必需字段存在
✅ 权限声明合理
✅ 命令定义有效
✅ 事件订阅有效
✅ 配置模式有效
⚠️ 建议添加图标
⚠️ 建议添加更多示例
```

---

## 实战案例

### 案例1：开发团队内部工具插件

**场景**：团队需要集成内部工具链

**插件功能**：
- 代码规范检查
- 内部 API 调用
- 监控系统上报
- 自动化部署

**实现**：

**`src/commands.ts`**:
```typescript
import { CommandContext } from '@anthropic-ai/claude-plugin-api';

export async function teamCheck(context: CommandContext): Promise<CommandResult> {
  const { workspace } = context;

  // 1. 运行团队 linter
  const linterResult = await runTeamLinter(workspace);

  // 2. 检查内部规范
  const standardResult = await checkInternalStandard(workspace);

  // 3. 上报到监控系统
  await reportToMonitoring({
    type: 'code-check',
    results: { linter: linterResult, standard: standardResult }
  });

  return {
    success: true,
    message: '团队规范检查完成',
    data: {
      linter: linterResult,
      standard: standardResult
    }
  };
}

export async function teamDeploy(context: CommandContext): Promise<CommandResult> {
  const { args, workspace } = context;

  const env = args.get('env', 'staging');
  const service = args.get('service', 'all');

  // 1. 检查是否通过 CI
  const ciStatus = await checkCIStatus(workspace);
  if (!ciStatus.passed) {
    return {
      success: false,
      message: 'CI 未通过，无法部署'
    };
  }

  // 2. 调用内部部署 API
  const deployResult = await callDeployAPI({
    env,
    service,
    workspace
  });

  // 3. 上报部署事件
  await reportToMonitoring({
    type: 'deploy',
    env,
    service,
    result: deployResult
  });

  return {
    success: true,
    message: `已部署 ${service} 到 ${env}`,
    data: deployResult
  };
}
```

**`src/internal-api.ts`**:
```typescript
export async function callDeployAPI(config: DeployConfig): Promise<DeployResult> {
  const response = await fetch('https://internal-api.company.com/deploy', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${process.env.INTERNAL_API_KEY}`
    },
    body: JSON.stringify(config)
  });

  return response.json();
}

export async function reportToMonitoring(event: MonitoringEvent): Promise<void> {
  await fetch('https://monitoring.company.com/events', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${process.env.MONITORING_KEY}`
    },
    body: JSON.stringify(event)
  });
}
```

**使用**：
```bash
/team-check                    # 运行团队规范检查
/team deploy staging backend   # 部署后端到测试环境
/team deploy production all    # 部署所有服务到生产环境
```

---

### 案例2：代码审查自动化插件

**场景**：自动执行代码审查流程

**插件功能**：
- 自动运行检查工具
- 生成审查报告
- 标记潜在问题
- 提供修复建议

**实现**：

**`src/review.ts`**:
```typescript
import { CommandContext } from '@anthropic-ai/claude-plugin-api';

export interface ReviewResult {
  category: string;
  tool: string;
  passed: boolean;
  issues: Issue[];
  score: number;
}

export interface Issue {
  severity: 'error' | 'warning' | 'info';
  file: string;
  line: number;
  message: string;
  suggestion?: string;
}

export async function autoReview(context: CommandContext): Promise<CommandResult> {
  const { workspace } = context;

  const results: ReviewResult[] = [];

  // 1. 代码风格检查
  const styleResult = await checkStyle(workspace);
  results.push(styleResult);

  // 2. 类型检查
  const typeResult = await checkTypes(workspace);
  results.push(typeResult);

  // 3. 安全扫描
  const securityResult = await scanSecurity(workspace);
  results.push(securityResult);

  // 4. 性能分析
  const perfResult = await analyzePerformance(workspace);
  results.push(perfResult);

  // 5. 生成报告
  const report = generateReport(results);

  return {
    success: true,
    message: '代码审查完成',
    data: { results, report }
  };
}

function generateReport(results: ReviewResult[]): string {
  let report = '# 代码审查报告\n\n';

  results.forEach(result => {
    report += `## ${result.category} (${result.tool})\n\n`;
    report += `状态: ${result.passed ? '✅ 通过' : '❌ 未通过'}\n`;
    report += `评分: ${result.score}/100\n\n`;

    if (result.issues.length > 0) {
      report += '### 发现的问题\n\n';
      result.issues.forEach(issue => {
        const icon = issue.severity === 'error' ? '❌' :
                    issue.severity === 'warning' ? '⚠️' : 'ℹ️';
        report += `${icon} **${issue.file}:${issue.line}**\n`;
        report += `${issue.message}\n`;
        if (issue.suggestion) {
          report += `💡 建议: ${issue.suggestion}\n`;
        }
        report += '\n';
      });
    }
  });

  return report;
}
```

**使用**：
```bash
/review                      # 运行完整审查
/review --fix                # 自动修复可修复的问题
/review --output review.md   # 生成报告文件
```

---

### 案例3：多语言项目插件

**场景**：支持多语言技术栈

**支持的语言**：
- TypeScript/JavaScript
- Python
- Go
- Rust

**实现**：

**`src/language-support.ts`**:
```typescript
import { LanguageSupport } from '@anthropic-ai/claude-plugin-api';

class MultiLanguagePlugin {
  private languages: Map<string, LanguageSupport> = new Map();

  constructor() {
    this.languages.set('typescript', new TypeScriptSupport());
    this.languages.set('python', new PythonSupport());
    this.languages.set('go', new GoSupport());
    this.languages.set('rust', new RustSupport());
  }

  detectLanguage(file: string): string | null {
    for (const [lang, support] of this.languages) {
      if (support.detect(file)) {
        return lang;
      }
    }
    return null;
  }

  async runTests(file: string): Promise<TestResult> {
    const lang = this.detectLanguage(file);
    if (!lang) {
      throw new Error(`无法识别语言: ${file}`);
    }

    const support = this.languages.get(lang)!;
    return support.test(file);
  }

  async formatCode(file: string): Promise<void> {
    const lang = this.detectLanguage(file);
    if (!lang) {
      throw new Error(`无法识别语言: ${file}`);
    }

    const support = this.languages.get(lang)!;
    return support.format(file);
  }

  async analyzeDependencies(file: string): Promise<Dependency[]> {
    const lang = this.detectLanguage(file);
    if (!lang) {
      throw new Error(`无法识别语言: ${file}`);
    }

    const support = this.languages.get(lang)!;
    return support.analyze(file);
  }
}
```

**使用**：
```bash
/test                        # 自动检测语言并运行测试
/format                      # 自动格式化代码
/deps                        # 分析依赖关系
/lang-info                   # 显示项目语言统计
```

---

## Windows特定

### Windows 插件开发

#### 路径处理

```typescript
// Windows 路径特殊处理
export function normalizePath(path: string): string {
  // 转换反斜杠为正斜杠
  return path.replace(/\\/g, '/');
}

export function resolveWindowsPath(path: string): string {
  // 处理 Windows 路径缩写
  if (path.match(/^[A-Z]:~1/)) {
    // C:\Progra~1 → C:\Program Files
    return expandShortPath(path);
  }
  return path;
}
```

#### PowerShell 集成

```typescript
export async function runPowerShell(script: string): Promise<string> {
  const result = await execute({
    command: 'powershell',
    args: ['-Command', script],
    windows: true
  });

  return result.stdout;
}

// 使用示例
await runPowerShell('Get-ChildItem -Path "C:/Projects"');
```

#### Windows 服务集成

```typescript
export class WindowsServiceManager {
  async start(serviceName: string): Promise<void> {
    await runPowerShell(`Start-Service -Name '${serviceName}'`);
  }

  async stop(serviceName: string): Promise<void> {
    await runPowerShell(`Stop-Service -Name '${serviceName}'`);
  }

  async getStatus(serviceName: string): Promise<string> {
    const output = await runPowerShell(
      `(Get-Service -Name '${serviceName}').Status`
    );
    return output.trim();
  }
}
```

### Windows 插件示例

#### IIS 管理插件

```typescript
export class IISPlugin implements Plugin {
  name = 'iis-manager';
  version = '1.0.0';

  async listSites(): Promise<Site[]> {
    const output = await runPowerShell(
      'Get-Website | Select-Object Name, State, PhysicalPath | ConvertTo-Json'
    );
    return JSON.parse(output);
  }

  async startSite(siteName: string): Promise<void> {
    await runPowerShell(`Start-Website -Name '${siteName}'`);
  }

  async stopSite(siteName: string): Promise<void> {
    await runPowerShell(`Stop-Website -Name '${siteName}'`);
  }

  async createAppPool(name: string, runtime: string): Promise<void> {
    await runPowerShell(`
      New-WebAppPool -Name '${name}' -Force
      Set-ItemProperty -Path "IIS:\\AppPools\\${name}" -Name "managedRuntimeVersion" -Value '${runtime}'
    `);
  }
}
```

---

## 最佳实践

### 1. 插件设计原则

#### 单一职责

```
✅ 好的插件：
- Python 支持插件：只处理 Python 相关
- Docker 管理插件：只处理 Docker 操作

❌ 避免：
- 全能插件：什么都做，什么都不精
```

#### 最小权限

```json
{
  "claude": {
    "permissions": [
      "read:files",          // 只请求需要的权限
      "write:files"
      // ❌ 避免 "network:request" 如果不需要
    ]
  }
}
```

#### 清晰的 API

```typescript
// ✅ 好的 API 设计
export async function processFile(
  file: string,
  options: ProcessOptions
): Promise<ProcessResult>

// ❌ 避免
export async function p(
  f: string,
  o?: any
): Promise<any>
```

### 2. 性能优化

#### 懒加载

```typescript
export default class MyPlugin implements Plugin {
  private heavyModule?: any;

  async activate() {
    // 不在激活时加载
    // this.heavyModule = await import('./heavy');
  }

  async doWork() {
    // 只在需要时加载
    if (!this.heavyModule) {
      this.heavyModule = await import('./heavy');
    }
    return this.heavyModule.work();
  }
}
```

#### 缓存结果

```typescript
export class CacheManager {
  private cache = new Map<string, any>();

  async get(key: string): Promise<any> {
    if (this.cache.has(key)) {
      return this.cache.get(key);
    }

    const value = await this.fetch(key);
    this.cache.set(key, value);
    return value;
  }
}
```

### 3. 错误处理

#### 优雅降级

```typescript
export async function analyzeCode(file: string): Promise<Analysis> {
  try {
    return await deepAnalysis(file);
  } catch (error) {
    // 降级到简单分析
    return await simpleAnalysis(file);
  }
}
```

#### 详细错误信息

```typescript
export class PluginError extends Error {
  constructor(
    message: string,
    public code: string,
    public details?: any
  ) {
    super(message);
    this.name = 'PluginError';
  }
}

// 使用
throw new PluginError(
  '无法解析文件',
  'PARSE_ERROR',
  { file, line: 42, column: 10 }
);
```

### 4. 文档和测试

#### 完善的 README

```markdown
# My Awesome Plugin

## 简介
一句话描述插件功能

## 安装
\`\`\`bash
claude plugin install my-awesome-plugin
\`\`\`

## 使用
\`\`\`bash
my-command --help
\`\`\`

## 配置
说明配置选项

## 示例
提供实际使用案例
```

#### 充分的测试

```typescript
describe('MyPlugin', () => {
  it('应该正确处理输入', async () => {
    const result = await myPlugin.process('input');
    expect(result).toBeDefined();
  });

  it('应该优雅处理错误', async () => {
    await expect(
      myPlugin.process(null)
    ).rejects.toThrow(PluginError);
  });
});
```

---

## 常见问题

### Q1: 插件加载失败怎么办？

**A**: 诊断步骤

```bash
# 1. 检查插件是否安装
claude plugin list

# 2. 查看错误日志
claude plugin logs <plugin-name>

# 3. 验证插件清单
claude plugin validate

# 4. 尝试重新安装
claude plugin reinstall <plugin-name>
```

**常见原因**：
- 依赖版本冲突
- 权限不足
- 配置文件错误
- API 不兼容

### Q2: 如何调试插件？

**A**: 使用调试工具

```bash
# 启用调试模式
claude plugin debug <plugin-name>

# 查看详细日志
claude plugin logs --follow --verbose

# 在 VS Code 中调试
# 添加 launch.json 配置
```

**VS Code 配置**：
```json
{
  "type": "node",
  "request": "attach",
  "name": "调试插件",
  "port": 9229,
  "skipFiles": ["<node_internals>/**"]
}
```

### Q3: 插件间如何通信？

**A**: 使用事件系统

```typescript
// 插件 A 发布事件
export class PluginA {
  async doWork() {
    const result = await process();
    context.events.emit('work.done', { result });
  }
}

// 插件 B 订阅事件
export class PluginB {
  subscribe(events: EventRegistry) {
    events.on('work.done', async (data) => {
      await this.handleResult(data);
    });
  }
}
```

### Q4: 如何处理插件依赖？

**A**: 在清单中声明

```json
{
  "claude": {
    "dependencies": {
      "@claude-plugins/python-support": "^2.0.0",
      "@claude-plugins/docker": "^1.5.0"
    }
  }
}
```

**安装时自动解析**：
```bash
claude plugin install my-plugin
# 自动安装依赖的插件
```

### Q5: 插件可以访问文件系统吗？

**A**: 需要声明权限

```json
{
  "claude": {
    "permissions": [
      "read:files",
      "write:files",
      "read:config"
    ]
  }
}
```

**使用 API**：
```typescript
import { FileSystem } from '@anthropic-ai/claude-plugin-api';

export class MyPlugin {
  async readConfig(fs: FileSystem): Promise<any> {
    const content = await fs.readFile('.claude/settings.json');
    return JSON.parse(content);
  }
}
```

### Q6: 如何更新插件到新版本？

**A**: 检查变更日志

```bash
# 查看更新内容
claude plugin info <plugin-name> --changelog

# 测试新版本
claude plugin install <plugin-name>@beta

# 更新到主版本
claude plugin update <plugin-name> --major
```

### Q7: 插件影响性能怎么办？

**A**: 优化策略

```typescript
// 1. 懒加载
async onCommand() {
  const module = await import('./heavy');
}

// 2. 缓存结果
private cache = new Map();
async get(key) {
  if (this.cache.has(key)) return this.cache.get(key);
}

// 3. 异步处理
async process() {
  await this.queue.add(task);
}

// 4. 限制资源
{
  "limits": {
    "memory": "256MB",
    "timeout": "30s"
  }
}
```

### Q8: 如何贡献插件到社区？

**A**: 发布流程

```bash
# 1. 准备发布
npm run build
npm test

# 2. 验证清单
claude plugin validate

# 3. 发布到市场
claude plugin publish

# 4. 持续维护
- 回复 Issue
- 修复 Bug
- 更新文档
```

---

## 故障排查

### 问题1：插件无法加载

**症状**：
```
Error: Failed to load plugin 'my-plugin'
```

**诊断**：
```bash
# 检查插件状态
claude plugin doctor my-plugin

# 查看详细错误
claude plugin logs my-plugin --tail 50
```

**解决方案**：
- ✅ 检查依赖是否安装
- ✅ 验证清单文件格式
- ✅ 检查 API 版本兼容性
- ✅ 重新安装插件

### 问题2：命令未找到

**症状**：
```
Command not found: my-command
```

**诊断**：
```bash
# 列出插件命令
claude plugin commands my-plugin

# 检查插件是否启用
claude plugin list --enabled
```

**解决方案**：
- ✅ 启用插件：`claude plugin enable my-plugin`
- ✅ 检查命令名称拼写
- ✅ 重新加载插件

### 问题3：权限错误

**症状**：
```
Permission denied: write:files
```

**诊断**：
```bash
# 检查插件权限
claude plugin info my-plugin --permissions

# 查看当前权限配置
claude plugin permissions
```

**解决方案**：
- ✅ 更新清单文件，添加所需权限
- ✅ 重新发布插件
- ✅ 用户重新安装以接受新权限

---

## 总结

### 关键要点

1. **插件系统价值**
   - 无限扩展能力
   - 生态共享
   - 团队定制

2. **插件类型**
   - 命令插件
   - 事件插件
   - 语言插件
   - 集成插件

3. **开发流程**
   - 创建项目
   - 实现功能
   - 测试验证
   - 发布分享

4. **最佳实践**
   - 单一职责
   - 最小权限
   - 性能优化
   - 完善文档

5. **社区生态**
   - 1000+ 插件
   - 持续更新
   - 质量保证
   - 活跃社区

### 学习路径

```
Level 1: 使用插件
    ↓
安装和使用社区插件
    ↓
Level 2: 开发简单插件
    ↓
命令插件、事件插件
    ↓
Level 3: 开发复杂插件
    ↓
语言插件、集成插件
    ↓
Level 4: 插件生态
    ↓
发布插件、社区贡献
```

### 相关资源

- [自定义命令](../01-customization/01-custom-commands.md)
- [Agent SDK](../01-customization/04-agent-sdk.md)
- [插件市场](https://claude.ai/code/plugins)

---

**最后更新**: 2026-01-18
**维护者**: knowknowcc 项目组
**反馈**: [GitHub Issues](https://github.com/anthropics/claude-code/issues)
