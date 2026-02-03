# 安全最佳实践 - Security Best Practices

> **保护数据和隐私，建立安全防线**

**阅读时间**: 50分钟
**难度**: ⭐⭐⭐⭐⭐
**适用场景**: 企业级应用、敏感数据处理、团队协作
**前置要求**: [Level 2 进阶提升](../../advanced/), [Level 2 完成](../../master/)

---

## 目录

- [安全概述](#安全概述)
- [数据隐私保护](#数据隐私保护)
- [访问控制](#访问控制)
- [凭证管理](#凭证管理)
- [通信安全](#通信安全)
- [代码安全](#代码安全)
- [审计和监控](#审计和监控)
- [合规性](#合规性)
- [实战案例](#实战案例)
- [安全检查清单](#安全检查清单)

---

## 安全概述

### 为什么安全很重要？

**安全的三大支柱**：

```
┌─────────────────────────────────────┐
│  CIA 三要素                          │
│                                     │
│  C - Confidentiality（机密性）       │
│      ├─ 防止未授权访问               │
│      └─ 保护敏感数据                 │
│                                     │
│  I - Integrity（完整性）             │
│      ├─ 防止数据篡改                 │
│      └─ 确保数据准确                 │
│                                     │
│  A - Availability（可用性）          │
│      ├─ 确保服务可用                 │
│      └─ 防止服务中断                 │
└─────────────────────────────────────┘
```

### Claude Code 安全模型

**架构**：

```
┌─────────────────────────────────────┐
│  Claude Code 客户端                 │
│  └─ 本地数据处理                     │
└──────────────┬──────────────────────┘
               ↓ 加密传输
┌──────────────┴──────────────────────┐
│  Anthropic API                      │
│  └─ 服务器端处理                     │
└─────────────────────────────────────┘
```

**安全边界**：

```
本地环境
├─ 文件系统访问
├─ 环境变量
├─ 配置文件
└─ 敏感数据

网络传输
├─ HTTPS/TLS
├─ API 密钥
└─ 请求内容

云端处理
├─ 数据存储
├─ 日志记录
└─ 隐私政策
```

---

## 数据隐私保护

### 原则1: 最小化数据收集

**实践**：

```markdown
# ❌ 不好：发送过多数据

👤 你：@src/ @tests/ @docs/ @node_modules/
分析整个项目

问题：
- 包含不必要的文件（node_modules）
- 暴露敏感配置（.env）
- 浪费 Token

# ✅ 好：精确发送

👤 你：@src/main.ts @src/app.ts
分析核心架构

优势：
- 只发送必要文件
- 保护敏感信息
- 节省成本
```

### 原则2: 敏感数据脱敏

**实践**：

```markdown
# ❌ 不好：发送真实密钥

👤 你：@.env
检查配置

问题：
- API 密钥泄露
- 数据库凭证暴露
- 安全风险

# ✅ 好：脱敏后再发送

👤 你：创建 .env.example
只包含非敏感配置

🤖 Claude：[创建示例文件]
```

### 原则3: 本地优先处理

**实践**：

```markdown
# ✅ 优先使用本地工具

# 敏感数据处理
├─ 使用本地脚本
├─ 避免发送云端
└─ 减少暴露风险

# 示例：日志分析
# ❌ 发送到云端
👤 你：@logs/app.log 分析错误

# ✅ 本地分析后提问
👤 你：本地分析日志，
发现 5 个错误模式
[只发送摘要]
这些模式的原因是什么？
```

### 原则4: 定期清理

**实践**：

```powershell
# 清理敏感数据

# 1. 清理历史记录
# PowerShell
Remove-Item (Get-PSReadlineOption).HistorySavePath

# 2. 清理缓存
Remove-Item "$env:TEMP\*" -Recurse -Force

# 3. 清理日志中的敏感信息
# 使用脚本脱敏

# 4. 清理会话数据
Remove-Item "$env:APPDATA\Claude Code\sessions\*" -Recurse -Force
```

---

## 访问控制

### 文件系统权限

**Windows 权限**：

```powershell
# 查看文件权限
Get-Acl "C:\Projects\secret.txt"

# 修改权限
$acl = Get-Acl "C:\Projects\secret.txt"
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
    $env:USERNAME,
    "Read",
    "Allow"
)
$acl.SetAccessRule($accessRule)
Set-Acl "C:\Projects\secret.txt" $acl

# 移除权限
$acl.RemoveAccessRule($accessRule)
Set-Acl "C:\Projects\secret.txt" $acl
```

### 环境变量保护

**敏感环境变量**：

```powershell
# ✅ 使用用户环境变量（而非系统）
[System.Environment]::SetEnvironmentVariable('API_KEY', 'xxx', 'User')

# ✅ 读取用户变量
$env:API_KEY

# ❌ 避免：硬编码在脚本中
$apiKey = "sk-1234567890"

# ✅ 推荐：从环境变量读取
$apiKey = $env:API_KEY

# ✅ 推荐：从文件读取（文件权限保护）
$apiKey = Get-Content "$env:USERPROFILE\.secrets\api_key.txt"
```

### Git 仓库安全

**.gitignore 配置**：

```gitignore
# .gitignore

# 敏感配置
.env
.env.local
.env.*.local
*.key
*.pem
secrets/

# 日志（可能包含敏感信息）
logs/
*.log

# 临时文件
.tmp/
temp/
*.tmp
```

**检查已提交的敏感信息**：

```bash
# 搜索可能的敏感信息
git log --all --full-history --source -- "*secret*"
git log --all --full-history --source -- "*password*"
git log --all --full-history --source -- "*api_key*"

# 使用工具
git-secrets scans
trufflehog git https://github.com/user/repo.git
```

---

## 凭证管理

### API 密钥管理

**最佳实践**：

```markdown
# ❌ 不好：硬编码

// config.ts
export const API_KEY = "sk-1234567890abcdef";

# ❌ 不好：明文配置

// .env
API_KEY=sk-1234567890abcdef
```

```markdown
# ✅ 好：环境变量

// .env（不提交）
API_KEY=sk-1234567890abcdef

// .env.example（提交）
API_KEY=your_api_key_here

// config.ts
export const API_KEY = process.env.API_KEY;

// .gitignore
.env
```

### 密钥轮换

**定期更换密钥**：

```
密钥轮换周期：
- API 密钥：30-90 天
- 数据库密码：60-90 天
- SSH 密钥：90-180 天
- 证书：1 年
```

**轮换流程**：

```markdown
1. 生成新密钥
   ↓
2. 配置新密钥（与旧密钥并存）
   ↓
3. 测试新密钥
   ↓
4. 切换到新密钥
   ↓
5. 等待一段时间（确保无问题）
   ↓
6. 撤销旧密钥
```

### 凭证存储

**安全的存储方式**：

```markdown
# 选项 1: 环境变量（推荐用于开发）
$env:API_KEY
优点：简单、方便
缺点：可能被进程转储泄露

# 选项 2: 密钥管理服务（推荐用于生产）
- AWS Secrets Manager
- Azure Key Vault
- HashiCorp Vault
优点：安全、可审计、轮换
缺点：复杂

# 选项 3: 加密配置文件
# 使用加密工具加密敏感信息
优点：可版本控制
缺点：需要管理加密密钥

# 选项 4: 本地密钥链
# Windows DPAPI
# macOS Keychain
# Linux Secret Service
优点：系统级保护
缺点：平台相关
```

---

## 通信安全

### HTTPS/TLS

**验证加密连接**：

```powershell
# 测试 HTTPS 连接
Test-NetConnection api.anthropic.com -Port 443

# 检查 TLS 版本
# 浏览器开发工具 → Security → 查看 TLS 版本

# Claude Code 使用 HTTPS
# 默认启用，无需配置
```

### 代理安全

**安全配置代理**：

```markdown
# ⚠️ 代理安全考虑

风险：
├─ 代理可以记录所有流量
├─ 中间人攻击风险
└─ 数据泄露风险

缓解措施：
├─ 使用可信代理
├─ 启用代理认证
├─ 检查代理证书
└─ 避免通过代理发送敏感数据
```

### API 安全

**API 密钥保护**：

```markdown
# ✅ 好实践

# 1. 限制权限
# 只授予必要的权限
# 例如：只读权限 vs 完全访问

# 2. IP 白名单
# 限制 API 密钥只能在特定 IP 使用

# 3. 使用率限制
# 设置合理的速率限制

# 4. 定期审查
# 定期检查 API 使用情况
# 撤销不再使用的密钥

# 5. 监控和告警
# 异常使用告警
# 可疑活动通知
```

---

## 代码安全

### 输入验证

**验证所有输入**：

```typescript
// ❌ 不好：不验证输入
function processUserInput(input: string) {
  // 直接使用
  return eval(input);
}

// ✅ 好：验证和清理
function processUserInput(input: string): string {
  // 1. 类型检查
  if (typeof input !== 'string') {
    throw new Error('Invalid input type');
  }

  // 2. 长度限制
  if (input.length > 1000) {
    throw new Error('Input too long');
  }

  // 3. 内容过滤
  const sanitized = input
    .replace(/<script>/gi, '')
    .replace(/javascript:/gi, '');

  // 4. 白名单验证
  if (!/^[a-zA-Z0-9_-]+$/.test(sanitized)) {
    throw new Error('Invalid characters');
  }

  return sanitized;
}
```

### SQL 注入防护

**使用参数化查询**：

```typescript
// ❌ 不好：SQL 注入风险
const query = `SELECT * FROM users WHERE id = ${userId}`;
await db.execute(query);

// ✅ 好：参数化查询
const query = 'SELECT * FROM users WHERE id = ?';
await db.execute(query, [userId]);

// ✅ 更好：使用 ORM
const user = await User.findByPk(userId);
```

### XSS 防护

**转义用户输入**：

```typescript
// ❌ 不好：直接渲染
function renderUserInput(input: string) {
  return `<div>${input}</div>`;
}

// ✅ 好：转义
import * as DOMPurify from 'dompurify';

function renderUserInput(input: string) {
  const clean = DOMPurify.sanitize(input);
  return `<div>${clean}</div>`;
}
```

### 敏感信息日志

**避免记录敏感信息**：

```typescript
// ❌ 不好：记录敏感信息
console.log('User logged in:', {
  email: user.email,
  password: user.password,  // 泄露！
  apiKey: user.apiKey       // 泄露！
});

// ✅ 好：只记录必要信息
console.log('User logged in:', {
  userId: user.id,
  timestamp: new Date().toISOString()
});
```

---

## 审计和监控

### 日志记录

**安全日志**：

```typescript
// security-logger.ts

interface SecurityEvent {
  timestamp: Date;
  event: string;
  userId?: string;
  ip?: string;
  details: Record<string, any>;
}

class SecurityLogger {
  private events: SecurityEvent[] = [];

  log(event: string, details: Record<string, any> = {}) {
    const logEntry: SecurityEvent = {
      timestamp: new Date(),
      event,
      userId: details.userId,
      ip: details.ip,
      details
    };

    this.events.push(logEntry);

    // 持久化到安全日志
    this.appendToSecureLog(logEntry);
  }

  private appendToSecureLog(entry: SecurityEvent) {
    // 写入安全日志文件（权限保护）
    // 或发送到 SIEM 系统
  }

  // 安全事件
  logLogin(userId: string, ip: string) {
    this.log('LOGIN', { userId, ip });
  }

  logLogout(userId: string) {
    this.log('LOGOUT', { userId });
  }

  logFailedLogin(email: string, ip: string) {
    this.log('FAILED_LOGIN', { email, ip });
  }

  logUnauthorizedAccess(userId: string, resource: string) {
    this.log('UNAUTHORIZED_ACCESS', { userId, resource });
  }

  logDataAccess(userId: string, resource: string) {
    this.log('DATA_ACCESS', { userId, resource });
  }
}
```

### 监控指标

**关键安全指标**：

```
访问监控
├─ 失败登录次数
├─ 异常 IP 访问
├─ 异常时间访问
└─ 异常操作频率

数据监控
├─ 敏感数据访问
├─ 大量数据导出
└─ 异常查询模式

系统监控
├─ API 调用频率
├─ 响应时间异常
└─ 错误率突增
```

### 告警机制

**安全告警**：

```typescript
// alert-manager.ts

class SecurityAlertManager {
  private thresholds = {
    failedLogins: 5,
    unauthorizedAttempts: 3,
    dataExportSize: 1000, // records
    apiRate: 100 // requests per minute
  };

  checkAlerts(metrics: SecurityMetrics) {
    // 检查失败登录
    if (metrics.failedLogins > this.thresholds.failedLogins) {
      this.sendAlert('HIGH_FAILED_LOGINS', {
        count: metrics.failedLogins
      });
    }

    // 检查未授权访问
    if (metrics.unauthorizedAttempts > this.thresholds.unauthorizedAttempts) {
      this.sendAlert('HIGH_UNAUTHORIZED_ACCESS', {
        attempts: metrics.unauthorizedAttempts
      });
    }

    // 检查数据导出
    if (metrics.dataExportSize > this.thresholds.dataExportSize) {
      this.sendAlert('LARGE_DATA_EXPORT', {
        size: metrics.dataExportSize
      });
    }
  }

  private sendAlert(type: string, data: any) {
    // 发送到告警系统
    // - Email
    // - Slack
    // - PagerDuty
    // - SIEM 系统
  }
}
```

---

## 合规性

### GDPR（欧盟）

**要**：

```markdown
✅ 获得用户同意
✅ 提供数据访问接口
✅ 支持数据删除（被遗忘权）
✅ 提供数据导出
✅ 数据最小化
✅ 实施数据保护
✅ 报告数据泄露（72小时内）
```

### SOC 2

**要**：

```markdown
✅ 访问控制
✅ 数据加密
✅ 变更管理
✅ 监控和日志
✅ 漏洞管理
✅ 事件响应
✅ 风险评估
```

### HIPAA（医疗）

**要**：

```markdown
✅ PHI（受保护健康信息）保护
✅ 访问审计
✅ 传输加密
✅ 存储加密
✅ 最小必要原则
✅ 业务连续性计划
```

---

## 实战案例

### 案例1: 企业级 API 密钥管理

**场景**：多环境、多服务的 API 密钥管理

**解决方案**：

```markdown
# 目录结构
project/
├── config/
│   ├── development.json
│   ├── staging.json
│   └── production.json
├── scripts/
│   └── setup-secrets.ps1
└── .gitignore

# config/development.json
{
  "database": {
    "host": "localhost",
    "port": 5432
  },
  "api": {
    "key": "dev_key_placeholder"
  }
}

# scripts/setup-secrets.ps1
param([string]$Environment)

switch ($Environment) {
  "development" {
    [System.Environment]::SetEnvironmentVariable('DB_HOST', 'localhost', 'User')
    [System.Environment]::SetEnvironmentVariable('API_KEY', 'dev_key_placeholder', 'User')
  }
  "production" {
    # 从密钥管理服务读取
    $apiKey = Read-Secret -Name "production-api-key"
    [System.Environment]::SetEnvironmentVariable('API_KEY', $apiKey, 'Process')
  }
}

# 使用
./scripts/setup-secrets.ps1 -Environment production
```

### 案例2: 敏感日志脱敏

**场景**：日志中包含敏感信息，需要脱敏

**解决方案**：

```typescript
// logger.ts

interface LogEntry {
  timestamp: Date;
  level: string;
  message: string;
  data?: Record<string, any>;
}

class SecureLogger {
  private sensitiveFields = [
    'password',
    'apiKey',
    'secret',
    'token',
    'creditCard'
  ];

  private sanitize(data: Record<string, any>): Record<string, any> {
    const sanitized = { ...data };

    for (const key of Object.keys(sanitized)) {
      for (const sensitive of this.sensitiveFields) {
        if (key.toLowerCase().includes(sensitive.toLowerCase())) {
          sanitized[key] = '[REDACTED]';
        }
      }
    }

    return sanitized;
  }

  log(level: string, message: string, data?: Record<string, any>) {
    const entry: LogEntry = {
      timestamp: new Date(),
      level,
      message,
      data: data ? this.sanitize(data) : undefined
    };

    // 写入日志
    console.log(JSON.stringify(entry));
  }
}

// 使用
const logger = new SecureLogger();
logger.log('info', 'User login', {
  email: 'user@example.com',
  password: 'secret123',  // 会被脱敏为 [REDACTED]
  apiKey: 'sk-123456'       // 会被脱敏为 [REDACTED]
});
```

### 案例3: Claude Code 安全配置

**场景**：确保 Claude Code 安全使用

**配置**：

```markdown
# .claude/settings.json

{
  "mcpServers": {
    "database": {
      "command": "node",
      "args": ["D:/projects/mcp-db-server/dist/index.js"],
      "env": {
        // ✅ 使用环境变量，不硬编码
        "DB_HOST": "${DB_HOST}",
        "DB_PASSWORD": "${DB_PASSWORD}"
      }
    }
  },

  // ✅ 限制文件访问
  "allowedPaths": [
    "D:/Projects/app",
    "D:/Projects/shared"
  ],

  // ✅ 禁用敏感命令
  "disabledCommands": [
    "eval",
    "exec"
  ],

  // ✅ 启用审计日志
  "auditLogging": true,
  "auditLogPath": "D:/Projects/app/logs/audit.json"
}

# .env（不提交）
DB_HOST=localhost
DB_PASSWORD=encrypted_password_here

# .gitignore
.env
.claude/settings.json
**/audit.json
```

---

## 安全检查清单

### 代码审查安全检查

```markdown
每次代码审查检查：

□ 敏感信息是否硬编码
□ 输入是否验证
□ SQL 是否参数化
□ 输出是否转义
□ 错误是否安全处理
□ 日志是否包含敏感信息
□ 权限是否最小化
□ 密钥是否轮换
□ 第三方依赖是否安全
□ 加密是否正确使用
```

### 部署前安全检查

```markdown
部署前检查：

□ 环境变量已配置
□ 密钥已轮换
□ .env 文件已添加到 .gitignore
□ 日志脱敏已启用
□ HTTPS 已启用
□ 防火墙规则已配置
□ 访问控制已设置
□ 审计日志已启用
□ 监控告警已配置
□ 备份已测试
□ 应急预案已准备
```

### 定期安全审查

```markdown
每月检查：

□ 访问日志审查
□ 异常活动分析
□ 密钥轮换状态
□ 依赖更新检查
□ 安全补丁状态
□ 合规性检查
□ 安全培训完成

每季度检查：

□ 渗透测试
□ 代码安全审计
□ 架构安全评审
□ 应急演练
□ 安全策略更新
```

---

## 总结

### 安全原则

```
1. 最小权限原则
   └─ 只授予必要的权限

2. 纵深防御
   └─ 多层安全措施

3. 安全左移
   └─ 在开发阶段考虑安全

4. 持续监控
   └─ 实时监控和告警

5. 定期审查
   └─ 定期安全评估
```

### 关键要点

```
数据保护
✅ 最小化收集
✅ 脱敏处理
✅ 本地优先
✅ 定期清理

访问控制
✅ 文件权限
✅ 环境变量
✅ Git 安全
✅ 密钥轮换

通信安全
✅ HTTPS/TLS
✅ 代理安全
✅ API 安全

代码安全
✅ 输入验证
✅ SQL 注入防护
✅ XSS 防护
✅ 日志脱敏

审计监控
✅ 安全日志
✅ 监控指标
✅ 告警机制

合规性
✅ GDPR
✅ SOC 2
✅ HIPAA
```

---

## 相关资源

### 项目文档
- [高级主题](../03-advanced-topics/) - 其他高级主题
- [最佳实践](../../guide/04-best-practices.md) - 通用最佳实践

### 外部资源
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [CWE Top 25](https://cwe.mitre.org/top25/)
- [安全编码规范](https://wiki.sei.cmu.edu/confluence/display/seccode/)

---

**最后更新**: 2026-02-04
**难度**: ⭐⭐⭐⭐⭐
**阅读时间**: 50分钟
**重要性**: ⭐⭐⭐⭐⭐
