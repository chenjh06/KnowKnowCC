# 工作流自动化 - Workflow Automation

> **让重复性工作自动执行，释放你的时间**

**阅读时间**: 45分钟
**难度**: ⭐⭐⭐⭐⭐
**适用场景**: 重复性任务、批量操作、CI/CD集成、团队协作
**前置要求**: [Level 2 进阶提升](../../skills/), [Headless模式](./01-headless-mode.md)

---

## 目录

- [工作流自动化概述](#工作流自动化概述)
- [核心概念](#核心概念)
- [Claude Code 工作流能力](#claude-code-工作流能力)
- [触发器和条件](#触发器和条件)
- [实战案例](#实战案例)
- [Windows 专属](#windows-专属)
- [最佳实践](#最佳实践)
- [常见问题](#常见问题)
- [故障排查](#故障排查)

---

## 工作流自动化概述

### 什么是工作流自动化？

**定义**：工作流自动化是指将重复性、规律性的任务序列化，使其能够自动执行，无需人工干预。

```
手动执行：
任务1 → [等待] → 任务2 → [等待] → 任务3 → ...
❌ 浪费时间
❌ 容易出错
❌ 不可重复

自动化执行：
定义工作流 → 一键触发 → 自动完成所有任务
✅ 节省时间
✅ 准确可靠
✅ 可重复使用
```

### 为什么需要工作流自动化？

#### 1. 提升效率

```
手动操作：
部署应用 = 手动执行 10+ 个命令
耗时：15-20分钟
每天重复：浪费时间

自动化：
部署应用 = 执行一个工作流脚本
耗时：2-3分钟
每天节省：15分钟 × 5天 = 75分钟/周
```

#### 2. 减少错误

```
❌ 手动操作容易出错：
- 忘记某个步骤
- 命令参数错误
- 执行顺序错误
- 环境配置错误

✅ 自动化减少人为错误：
- 预定义所有步骤
- 验证每个操作
- 标准化流程
- 可追溯日志
```

#### 3. 团队协作

```
个人工作流：
只有你知道如何完成任务
❌ 知识孤岛
❌ 依赖个人
❌ 难以交接

团队工作流：
标准化流程文档化
✅ 知识共享
✅ 降低依赖
✅ 易于交接
```

#### 4. 持续集成

```
手动集成：
开发完成 → 手动测试 → 手动部署
❌ 周期长
❌ 反馈慢
❌ 风险高

自动化 CI/CD：
代码提交 → 自动测试 → 自动部署
✅ 快速反馈
✅ 频繁发布
✅ 降低风险
```

---

## 核心概念

### 工作流的组成

```
工作流 = 触发器 + 任务序列 + 条件判断 + 错误处理

┌─────────────────────────────────────────────┐
│  触发器 (Trigger)                           │
│  - 定时触发                                  │
│  - 事件触发（文件变化、Git提交等）            │
│  - 手动触发                                  │
└────────────────┬────────────────────────────┘
                 ↓
┌─────────────────────────────────────────────┐
│  任务序列 (Task Sequence)                   │
│  - 顺序执行                                  │
│  - 并行执行                                  │
│  - 条件分支                                  │
└────────────────┬────────────────────────────┘
                 ↓
┌─────────────────────────────────────────────┐
│  条件判断 (Conditional Logic)               │
│  - if/else 分支                             │
│  - 循环执行                                  │
│  - 错误处理                                  │
└────────────────┬────────────────────────────┘
                 ↓
┌─────────────────────────────────────────────┐
│  通知和日志 (Notification & Logging)        │
│  - 成功通知                                  │
│  - 失败告警                                  │
│  - 执行日志                                  │
└─────────────────────────────────────────────┘
```

### 工作流的类型

#### 1. 顺序工作流 (Sequential Workflow)

```
任务1 → 任务2 → 任务3 → 任务4

特点：
✅ 简单直观
✅ 易于理解
✅ 适合线性流程

适用场景：
- 部署流程
- 数据处理管道
- 文档生成
```

#### 2. 并行工作流 (Parallel Workflow)

```
         → 任务2 ─┐
任务1 ──→ 任务3 ───→ 任务5
         → 任务4 ─┘

特点：
✅ 节省时间
✅ 充分利用资源
⚠️ 需要处理并发

适用场景：
- 多项目构建
- 多环境测试
- 批量文件处理
```

#### 3. 条件工作流 (Conditional Workflow)

```
任务1 ──→ 判断条件
         ├─ 满足 → 任务2a
         └─ 不满足 → 任务2b

特点：
✅ 灵活性强
✅ 适应不同场景
⚠️ 逻辑复杂

适用场景：
- 多环境部署
- 条件编译
- 动态配置
```

---

## Claude Code 工作流能力

### 1. 脚本化工作流

Claude Code 可以通过脚本实现工作流自动化：

```bash
# workflow/deploy.sh

#!/bin/bash
# 部署工作流示例

echo "🚀 开始部署..."

# 任务1: 运行测试
echo "📋 任务1: 运行测试"
npm test
if [ $? -ne 0 ]; then
  echo "❌ 测试失败，终止部署"
  exit 1
fi

# 任务2: 构建应用
echo "🔨 任务2: 构建应用"
npm run build

# 任务3: 备份当前版本
echo "💾 任务3: 备份"
cp -r /var/www/app /var/www/app.backup

# 任务4: 部署新版本
echo "📦 任务4: 部署"
rsync -avz dist/ user@server:/var/www/app/

# 任务5: 验证部署
echo "✅ 任务5: 验证"
curl -f http://server/health || exit 1

echo "✨ 部署完成！"
```

**使用 Claude Code 创建工作流**：

```
👤 你：创建一个部署工作流脚本
    需求：
    1. 运行测试
    2. 构建项目
    3. 部署到服务器
    4. 发送通知

🤖 Claude：[创建完整的脚本]
    - 添加错误处理
    - 包含日志记录
    - 支持回滚
    - 发送 Slack 通知

✅ 结果：一个可靠的生产级部署脚本
```

### 2. 钩子（Hooks）驱动的工作流

Claude Code 支持钩子机制，可以在特定事件触发时自动执行操作：

```json
// .claude/settings.json

{
  "hooks": {
    "prePrompt": [
      {
        "match": "部署|deploy",
        "command": "git status"
      }
    ],
    "postResponse": [
      {
        "match": "已修复|fixed",
        "command": "git add . && git commit -m 'Auto commit: Fixed bug'"
      }
    ]
  }
}
```

**工作流示例**：

```
场景：每次修复 Bug 后自动提交

1. 你要求 Claude 修复 Bug
   ↓
2. [prePrompt] 自动检查 Git 状态
   ↓
3. Claude 修复 Bug
   ↓
4. [postResponse] 自动提交更改
   ↓
5. 完整的工作流自动执行
```

### 3. 会话工作流

利用 Claude Code 的会话持久化能力，可以构建复杂的多步骤工作流：

```markdown
# WORKFLOW.md

## Bug 修复工作流

### 步骤 1: 分析问题
@src/issue.js 分析这个文件中的问题

### 步骤 2: 生成修复方案
基于分析，提供修复方案

### 步骤 3: 实施修复
修复代码，并添加测试

### 步骤 4: 验证
运行测试确保修复有效

### 步骤 5: 提交
提交更改到 Git
```

**使用方式**：

```
👤 你：@WORKFLOW.md 按照 Bug 修复工作流处理 issue #123

🤖 Claude：
[读取工作流定义]
[执行步骤1：分析问题]
[执行步骤2：生成方案]
[执行步骤3：实施修复]
[执行步骤4：验证测试]
[执行步骤5：提交更改]
```

### 4. 组合工作流

将多个工具和服务组合成完整的工作流：

```
┌─────────────────────────────────────────────┐
│  Claude Code 工作流引擎                      │
└─────────────────────────────────────────────┘
         ↓           ↓           ↓
    ┌────────┐  ┌────────┐  ┌────────┐
    │ Git    │  │ NPM    │  │ Docker │
    └────────┘  └────────┘  └────────┘
         ↓           ↓           ↓
    ┌────────┐  ┌────────┐  ┌────────┐
    │ Tests  │  │ Build  │  │ Deploy │
    └────────┘  └────────┘  └────────┘
         ↓           ↓           ↓
    ┌────────────────────────────────┐
    │  通知（Slack/Email）            │
    └────────────────────────────────┘
```

---

## 触发器和条件

### 1. 时间触发器

**定时任务**：

```bash
# 使用 crontab (macOS/Linux)

# 每天早上9点运行代码检查
0 9 * * * cd /project && npm run lint

# 每小时运行数据库备份
0 * * * * /scripts/backup-db.sh

# 每周一凌晨2点运行完整测试
0 2 * * 1 cd /project && npm test
```

```powershell
# 使用 Windows 任务计划程序

# 创建定时任务
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-File C:\scripts\run-tests.ps1"
$trigger = New-ScheduledTaskTrigger -Daily -At "9:00AM"
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "Daily Code Check"
```

### 2. 事件触发器

**文件变化触发**：

```bash
# 使用 watchman (文件监控工具)

# 监控 src/ 目录，文件变化时运行测试
watchman -- trigger /project src 'run-tests' -- npm test

# 监控变化，自动格式化代码
watchman -- trigger /project src 'format-code' -- npx prettier --write .
```

**Git 事件触发**：

```bash
# .git/hooks/post-commit

#!/bin/bash
# 提交后自动运行工作流

echo "📝 Git commit detected, running workflow..."

# 更新文档
npm run docs:generate

# 发送通知
curl -X POST $SLACK_WEBHOOK -d "New commit: $(git log -1 --pretty=%B)"

# 触发 CI
git push
```

### 3. 手动触发

**命令行触发**：

```bash
# 一键部署
./scripts/deploy.sh production

# 快速修复
./scripts/quick-fix.sh $(git log -1 --pretty=%H)

# 完整工作流
npm run workflow:full
```

**Claude Code 触发**：

```
👤 你：执行完整的发布工作流

🤖 Claude：
✅ 运行测试
✅ 构建应用
✅ 生成变更日志
✅ 创建 Git 标签
✅ 推送到远程
✅ 发布到 NPM
✅ 发送通知
```

### 4. 条件判断

**基于分支的条件**：

```bash
# .git/hooks/pre-push

#!/bin/bash

# 只在 main 分支要求完整测试
BRANCH=$(git symbolic-ref --short HEAD)
if [ "$BRANCH" = "main" ]; then
  echo "🔍 Main branch detected, running full tests..."
  npm run test:full
else
  echo "🔍 Feature branch, running quick tests..."
  npm run test:quick
fi
```

**基于文件变化的条件**：

```bash
# 只在相关文件变化时运行特定测试

CHANGED_FILES=$(git diff --name-only HEAD~1)

if echo "$CHANGED_FILES" | grep -q "src/.*\.js$"; then
  echo "JavaScript 文件变化，运行测试..."
  npm run test:js
fi

if echo "$CHANGED_FILES" | grep -q "styles/.*\.css$"; then
  echo "CSS 文件变化，编译样式..."
  npm run build:css
fi
```

**基于时间的条件**：

```bash
# 工作时间 vs 非工作时间

HOUR=$(date +%H)
if [ $HOUR -ge 9 ] && [ $HOUR -lt 18 ]; then
  echo "工作时间，发送 Slack 通知"
  notify_slack "Job completed"
else
  echo "非工作时间，仅记录日志"
  log "Job completed"
fi
```

---

## 实战案例

### 案例 1: 自动化部署工作流

**场景**：一个 Web 应用需要自动化部署到多个环境

**需求**：
- 开发环境：每次提交自动部署
- 测试环境：每天晚上自动部署
- 生产环境：手动触发，需要审批

**解决方案**：

```bash
#!/bin/bash
# workflows/deploy.sh

set -e  # 遇到错误立即退出

# 配置
ENVIRONMENT=${1:-dev}
PROJECT_DIR="/var/www/app"
BACKUP_DIR="/var/www/backups"
NOTIFICATION_WEBHOOK="https://hooks.slack.com/..."

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# 1. 环境检查
log_info "检查环境配置..."
if [ ! -f ".env.$ENVIRONMENT" ]; then
  log_error "环境配置文件不存在: .env.$ENVIRONMENT"
  exit 1
fi

# 2. 运行测试
log_info "运行测试..."
npm run test:ci
if [ $? -ne 0 ]; then
  log_error "测试失败，终止部署"
  notify "❌ 部署失败（测试失败）到 $ENVIRONMENT"
  exit 1
fi

# 3. 构建
log_info "构建应用..."
npm run build

# 4. 备份（仅生产环境）
if [ "$ENVIRONMENT" = "production" ]; then
  log_info "备份当前版本..."
  BACKUP_NAME="backup-$(date +%Y%m%d-%H%M%S)"
  cp -r $PROJECT_DIR "$BACKUP_DIR/$BACKUP_NAME"
  log_info "备份完成: $BACKUP_NAME"
fi

# 5. 部署
log_info "部署到 $ENVIRONMENT..."
if [ "$ENVIRONMENT" = "production" ]; then
  # 生产环境需要确认
  read -p "确认部署到生产环境？(yes/no) " -r
  if [ ! "$REPLY" = "yes" ]; then
    log_warn "部署已取消"
    exit 0
  fi
fi

# 复制文件
rsync -avz --delete dist/ $PROJECT_DIR/

# 6. 健康检查
log_info "健康检查..."
sleep 5  # 等待服务启动
HEALTH_CHECK=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/health)
if [ "$HEALTH_CHECK" != "200" ]; then
  log_error "健康检查失败 (HTTP $HEALTH_CHECK)"

  # 回滚
  if [ "$ENVIRONMENT" = "production" ]; then
    log_warn "开始回滚..."
    rm -rf $PROJECT_DIR
    cp -r "$BACKUP_DIR/$BACKUP_NAME" $PROJECT_DIR
    log_info "回滚完成"
  fi

  notify "❌ 部署失败（健康检查未通过）到 $ENVIRONMENT"
  exit 1
fi

# 7. 清理旧备份
log_info "清理旧备份..."
find $BACKUP_DIR -name "backup-*" -mtime +7 -delete

# 8. 发送通知
notify "✅ 部署成功到 $ENVIRONMENT"

log_info "部署完成！"
```

**使用方式**：

```bash
# 开发环境
./workflows/deploy.sh dev

# 测试环境
./workflows/deploy.sh staging

# 生产环境
./workflows/deploy.sh production
```

**使用 Claude Code 创建**：

```
👤 你：创建一个多环境部署工作流脚本
    要求：
    1. 支持开发、测试、生产三个环境
    2. 包含测试、构建、备份、部署、验证步骤
    3. 生产环境需要手动确认
    4. 失败时自动回滚
    5. 发送 Slack 通知

🤖 Claude：[生成完整脚本]
    - 完整的错误处理
    - 彩色日志输出
    - 健康检查
    - 自动备份和回滚
    - 通知集成
```

---

### 案例 2: 代码审查自动化工作流

**场景**：每次 PR 创建时自动进行代码审查

**需求**：
- 检查代码风格
- 运行测试
- 生成覆盖率报告
- 检查安全性问题
- 生成审查报告

**解决方案**：

```yaml
# .github/workflows/code-review.yml

name: Code Review Workflow

on:
  pull_request:
    types: [opened, synchronize]

jobs:
  code-review:
    runs-on: ubuntu-latest

    steps:
      # 1. 检出代码
      - name: Checkout code
        uses: actions/checkout@v3
        with:
          fetch-depth: 0

      # 2. 设置 Node.js
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'

      # 3. 安装依赖
      - name: Install dependencies
        run: npm ci

      # 4. 代码风格检查
      - name: Lint code
        run: |
          npm run lint
          echo "## Lint 结果" >> $GITHUB_STEP_SUMMARY
          echo '```' >> $GITHUB_STEP_SUMMARY
          npm run lint >> $GITHUB_STEP_SUMMARY 2>&1 || true
          echo '```' >> $GITHUB_STEP_SUMMARY

      # 5. 类型检查
      - name: Type check
        run: |
          npm run type-check
          echo "## 类型检查结果" >> $GITHUB_STEP_SUMMARY
          echo '```' >> $GITHUB_STEP_SUMMARY
          npm run type-check >> $GITHUB_STEP_SUMMARY 2>&1 || true
          echo '```' >> $GITHUB_STEP_SUMMARY

      # 6. 运行测试
      - name: Run tests
        run: |
          npm run test:ci
          echo "## 测试结果" >> $GITHUB_STEP_SUMMARY
          echo '```' >> $GITHUB_STEP_SUMMARY
          npm run test:ci >> $GITHUB_STEP_SUMMARY 2>&1 || true
          echo '```' >> $GITHUB_STEP_SUMMARY

      # 7. 生成覆盖率报告
      - name: Coverage report
        run: |
          npm run test:coverage
          echo "## 覆盖率报告" >> $GITHUB_STEP_SUMMARY
          cat coverage/coverage-summary.txt >> $GITHUB_STEP_SUMMARY

      # 8. 安全检查
      - name: Security audit
        run: |
          npm audit --audit-level=moderate
          echo "## 安全检查结果" >> $GITHUB_STEP_SUMMARY
          npm audit --json >> $GITHUB_STEP_SUMMARY 2>&1 || true

      # 9. 代码复杂度分析
      - name: Complexity analysis
        run: |
          npx complexity-report -o complexity.json
          echo "## 复杂度分析" >> $GITHUB_STEP_SUMMARY
          cat complexity.json >> $GITHUB_STEP_SUMMARY

      # 10. 生成最终报告
      - name: Generate review report
        if: always()
        run: |
          echo "# 🔍 代码审查报告" >> $GITHUB_STEP_SUMMARY
          echo "" >> $GITHUB_STEP_SUMMARY
          echo "**分支**: ${{ github.head_ref }}" >> $GITHUB_STEP_SUMMARY
          echo "**提交**: ${{ github.sha }}" >> $GITHUB_STEP_SUMMARY
          echo "" >> $GITHUB_STEP_SUMMARY
          echo "## ✅ 通过的检查" >> $GITHUB_STEP_SUMMARY
          echo "- 代码风格检查" >> $GITHUB_STEP_SUMMARY
          echo "- 类型检查" >> $GITHUB_STEP_SUMMARY
          echo "- 单元测试" >> $GITHUB_STEP_SUMMARY
          echo "- 安全审计" >> $GITHUB_STEP_SUMMARY

      # 11. PR 评论
      - name: Comment on PR
        if: always()
        uses: actions/github-script@v6
        with:
          script: |
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: '🤖 自动代码审查完成！查看 [Summary](https://github.com/${{ github.repository }}/actions/runs/${{ github.run_id }}) 获取详细信息。'
            })
```

**使用 Claude Code 优化**：

```
👤 你：优化这个代码审查工作流
    当前问题：
    1. 运行太慢（10分钟+）
    2. 有些检查不必要
    3. 报告不够清晰

🤖 Claude：
[优化方案]
1. 并行化独立任务（节省 60% 时间）
2. 缓存依赖（加速 40%）
3. 只检查变化的文件
4. 改进报告格式
5. 添加评分机制

✅ 优化后：4 分钟完成，报告更清晰
```

---

### 案例 3: 文档自动生成工作流

**场景**：项目文档需要与代码保持同步

**解决方案**：

```bash
#!/bin/bash
# workflows/generate-docs.sh

set -e

echo "📚 开始生成文档..."

# 1. 提取 API 文档
echo "📝 提取 API 文档..."
npx typedoc --out docs/api src/

# 2. 生成变更日志
echo "📋 生成变更日志..."
npx conventional-changelog -p angular -i CHANGELOG.md -s

# 3. 生成 README 目录
echo "🗂️ 生成 README 目录..."
npx markdown-toc -i README.md

# 4. 生成架构图
echo "🔷 生成架构图..."
npx @mermaid-js/mermaid-cli -i docs/architecture.mmd -o docs/architecture.png

# 5. 检查文档链接
echo "🔗 检查文档链接..."
npx markdown-link-check docs/**/*.md

# 6. 生成文档索引
echo "📇 生成文档索引..."
cat > DOCS_INDEX.md << 'EOF'
# 文档索引

## API 文档
- [API Reference](docs/api/)

## 用户指南
- [Getting Started](docs/getting-started.md)
- [Advanced Usage](docs/advanced.md)

## 开发指南
- [Contributing](docs/contributing.md)
- [Architecture](docs/architecture.md)
EOF

echo "✅ 文档生成完成！"
```

**结合 Git Hooks**：

```bash
# .git/hooks/pre-commit

#!/bin/bash
# 提交前自动生成文档

echo "📚 检查文档..."

# 检查文档是否需要更新
if git diff --name-only HEAD~1 | grep -q "src/"; then
  echo "检测到代码变化，生成文档..."
  ./workflows/generate-docs.sh

  # 添加生成的文档
  git add docs/
  git add README.md
  git add CHANGELOG.md
fi
```

---

## Windows 专属

### PowerShell 工作流脚本

**基本语法**：

```powershell
# workflows/deploy.ps1

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("dev", "staging", "production")]
    [string]$Environment
)

# 错误处理
$ErrorActionPreference = "Stop"

# 日志函数
function Log-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Green
}

function Log-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

function Log-Warn {
    param([string]$Message)
    Write-Host "[WARN] $Message" -ForegroundColor Yellow
}

# 1. 环境检查
Log-Info "检查环境配置..."
$envFile = ".env.$Environment"
if (-not (Test-Path $envFile)) {
    Log-Error "环境配置文件不存在: $envFile"
    exit 1
}

# 2. 运行测试
Log-Info "运行测试..."
npm test
if ($LASTEXITCODE -ne 0) {
    Log-Error "测试失败，终止部署"
    exit 1
}

# 3. 构建
Log-Info "构建应用..."
npm run build

# 4. 部署
Log-Info "部署到 $Environment..."
$destPath = switch ($Environment) {
    "dev" { "D:/Projects/dev/app" }
    "staging" { "D:/Projects/staging/app" }
    "production" { "D:/Projects/production/app" }
}

Copy-Item -Path "dist/*" -Destination $destPath -Recurse -Force

Log-Info "部署完成！"
```

**使用方式**：

```powershell
# 开发环境
.\workflows\deploy.ps1 -Environment dev

# 测试环境
.\workflows\deploy.ps1 -Environment staging

# 生产环境
.\workflows\deploy.ps1 -Environment production
```

### Windows 任务计划程序

**创建定时任务**：

```powershell
# 创建每日代码检查任务

$action = New-ScheduledTaskAction `
    -Execute "powershell.exe" `
    -Argument "-File D:/scripts/run-tests.ps1" `
    -WorkingDirectory "D:/Projects/app"

$trigger = New-ScheduledTaskTrigger `
    -Daily `
    -At "9:00AM"

$principal = New-ScheduledTaskPrincipal `
    -UserId "DOMAIN\username" `
    -LogonType S4U `
    -RunLevel Highest

$settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable

Register-ScheduledTask `
    -TaskName "Daily Code Check" `
    -Action $action `
    -Trigger $trigger `
    -Principal $principal `
    -Settings $settings `
    -Description "每天早上9点运行代码测试"
```

**管理任务**：

```powershell
# 查看所有任务
Get-ScheduledTask

# 查看任务详情
Get-ScheduledTaskInfo -TaskName "Daily Code Check"

# 立即运行任务
Start-ScheduledTask -TaskName "Daily Code Check"

# 禁用任务
Disable-ScheduledTask -TaskName "Daily Code Check"

# 启用任务
Enable-ScheduledTask -TaskName "Daily Code Check"

# 删除任务
Unregister-ScheduledTask -TaskName "Daily Code Check" -Confirm:$false
```

### 文件系统监控

**使用 FileSystemWatcher**：

```powershell
# workflows/watch-files.ps1

$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = "D:/Projects/app/src"
$watcher.Filter = "*.*"
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $true

$action = {
    $path = $Event.SourceEventArgs.FullPath
    $changeType = $Event.SourceEventArgs.ChangeType
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    Write-Host "[$timestamp] 文件变化: $changeType - $path"

    # 自动格式化代码
    if ($path -match "\.(js|ts|jsx|tsx)$") {
        Write-Host "  → 格式化代码..."
        npx prettier --write $path
    }

    # 自动运行相关测试
    if ($path -match "\.test\.(js|ts)$") {
        Write-Host "  → 运行测试..."
        npm test -- $path
    }
}

# 注册事件
Register-ObjectEvent -InputObject $watcher -EventName Changed -Action $action
Register-ObjectEvent -InputObject $watcher -EventName Created -Action $action
Register-ObjectEvent -InputObject $watcher -EventName Deleted -Action $action

Write-Host "监控中... (Ctrl+C 退出)"
while ($true) { Start-Sleep -Seconds 1 }
```

### Windows 路径处理

**路径格式**：

```powershell
# ✅ 推荐：使用正斜杠
$path = "D:/Projects/app/src"

# ✅ 备选：使用 Join-Path（自动处理分隔符）
$path = Join-Path "D:" "Projects" "app" "src"

# ❌ 避免：硬编码反斜杠
# $path = "D:\Projects\app\src"  # 可能导致转义问题
```

**路径操作**：

```powershell
# 获取脚本所在目录
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# 转换为绝对路径
$absPath = Resolve-Path ".\relative\path"

# 检查路径是否存在
if (Test-Path $path) {
    # 路径存在
}

# 路径拼接
$fullPath = Join-Path $basePath "subfolder" "file.txt"

# 跨平台路径
# 使用 ${PWD} 或 $PSScriptRoot
$configPath = Join-Path $PSScriptRoot "config.json"
```

---

## 最佳实践

### 1. 工作流设计原则

#### 保持简单

```
❌ 过度复杂：
- 10+ 个步骤
- 复杂的条件判断
- 多层嵌套

✅ 简单有效：
- 3-5 个核心步骤
- 线性流程
- 清晰的逻辑
```

#### 单一职责

```
❌ 一个工作流做所有事：
部署 + 测试 + 监控 + 通知 + 清理...

✅ 每个工作流负责一件事：
- deploy.sh: 只负责部署
- test.sh: 只负责测试
- monitor.sh: 只负责监控
```

#### 可重复性

```
❌ 依赖特定环境：
- 硬编码路径
- 依赖特定用户
- 手动配置

✅ 环境无关：
- 配置文件
- 环境变量
- 自动发现
```

### 2. 错误处理

#### 设置错误处理

```bash
#!/bin/bash
# 遇到错误立即退出
set -e

# 遇到未定义变量报错
set -u

# 管道命令失败时退出
set -pipefail

# 捕获错误
trap 'echo "Error on line $LINENO"; exit 1' ERR
```

```powershell
# PowerShell
$ErrorActionPreference = "Stop"

try {
    # 工作流步骤
    npm test
    npm run build
}
catch {
    Write-Host "错误: $_" -ForegroundColor Red
    exit 1
}
```

#### 提供有用的错误信息

```bash
# ❌ 不好
if [ ! -f "config.json" ]; then
  exit 1
fi

# ✅ 好
if [ ! -f "config.json" ]; then
  echo "❌ 配置文件不存在: config.json"
  echo "请创建配置文件或运行: cp config.example.json config.json"
  exit 1
fi
```

### 3. 日志和监控

#### 结构化日志

```bash
#!/bin/bash

# 日志函数
log_info() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] [INFO] $1"
}

log_error() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] [ERROR] $1" >&2
}

log_warn() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] [WARN] $1"
}

# 使用
log_info "开始构建..."
log_warn "未找到缓存，重新下载..."
log_error "构建失败"
```

#### 日志持久化

```bash
#!/bin/bash

LOG_DIR="logs"
LOG_FILE="$LOG_DIR/workflow-$(date +%Y%m%d-%H%M%S).log"

# 创建日志目录
mkdir -p "$LOG_DIR"

# 重定向输出
exec > >(tee -a "$LOG_FILE")
exec 2>&1

echo "日志文件: $LOG_FILE"
```

### 4. 测试工作流

#### 本地测试

```bash
# 创建测试环境
mkdir -p /tmp/workflow-test
cd /tmp/workflow-test

# 测试工作流
./workflows/deploy.sh test

# 清理
cd -
rm -rf /tmp/workflow-test
```

#### 干运行（Dry Run）

```bash
#!/bin/bash

DRY_RUN=${DRY_RUN:-false}

# 模拟运行
run() {
  if [ "$DRY_RUN" = "true" ]; then
    echo "[DRY RUN] $*"
  else
    "$@"
  fi
}

# 使用
run npm test
run npm run build
run rsync -avz dist/ server:/app/
```

```bash
# 干运行
DRY_RUN=true ./workflows/deploy.sh production

# 实际运行
./workflows/deploy.sh production
```

### 5. 文档和版本控制

#### 工作文档

```markdown
<!-- workflows/README.md -->

# 工作流文档

## deploy.sh

**用途**: 部署应用到不同环境

**用法**:
```bash
./workflows/deploy.sh <environment>
```

**环境**:
- `dev`: 开发环境（自动部署）
- `staging`: 测试环境（每日部署）
- `production`: 生产环境（手动触发）

**步骤**:
1. 运行测试
2. 构建应用
3. 备份当前版本（仅生产）
4. 部署新版本
5. 健康检查
6. 清理旧备份

**依赖**:
- npm
- rsync
- curl

**环境变量**:
- `SERVER_HOST`: 服务器地址
- `SERVER_USER`: SSH 用户
- `SLACK_WEBHOOK`: 通知 Webhook
```

#### 版本控制

```bash
# 工作流文件纳入版本控制
git add workflows/
git commit -m "Add deployment workflow"

# 不要提交敏感配置
echo "*.env" >> .gitignore
echo "workflows/.secrets" >> .gitignore
```

---

## 常见问题

### Q1: 工作流运行失败后如何调试？

**A**: 使用以下调试步骤：

1. **查看日志**
   ```bash
   # 查看最近的日志
   tail -f logs/workflow-*.log

   # 搜索错误
   grep "ERROR" logs/workflow-*.log
   ```

2. **单独测试每个步骤**
   ```bash
   # 手动运行失败的命令
   npm test
   npm run build
   ```

3. **启用调试模式**
   ```bash
   # Bash
   bash -x ./workflows/deploy.sh production

   # PowerShell
   Set-PSDebug -Trace 1
   .\workflows\deploy.ps1 -Environment production
   ```

4. **使用干运行**
   ```bash
   DRY_RUN=true ./workflows/deploy.sh production
   ```

### Q2: 如何处理工作流中的敏感信息？

**A**: 不要在脚本中硬编码敏感信息：

**❌ 不好**：
```bash
#!/bin/bash
API_KEY="sk-1234567890abcdef"
PASSWORD="my-secret-password"
```

**✅ 好**：
```bash
#!/bin/bash
# 从环境变量读取
API_KEY=${API_KEY}
PASSWORD=${PASSWORD}

# 从配置文件读取
source .env.workflows
```

**使用加密**：
```bash
# 使用加密工具
echo "my-secret" | openssl enc -aes-256-cbc -a -salt -pass pass:mykey

# 解密
SECRET=$(echo "U2FsdGVkX1..." | openssl enc -aes-256-cbc -d -a -pass pass:mykey)
```

### Q3: 工作流运行太慢怎么办？

**A**: 优化工作流性能：

1. **并行化独立任务**
   ```bash
   # ❌ 顺序执行
   npm run lint
   npm run type-check
   npm run test

   # ✅ 并行执行
   npm run lint & \
   npm run type-check & \
   npm run test & \
   wait
   ```

2. **缓存依赖**
   ```yaml
   # GitHub Actions
   - name: Cache node modules
     uses: actions/cache@v3
     with:
       path: node_modules
       key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
   ```

3. **只处理变化的部分**
   ```bash
   # 只测试变化的文件
   CHANGED_FILES=$(git diff --name-only HEAD~1)
   echo "$CHANGED_FILES" | grep "\.test\.js$" | xargs npm test --
   ```

4. **使用增量构建**
   ```bash
   # 使用增量编译
   npm run build -- --incremental
   ```

### Q4: 如何实现工作流的回滚？

**A**: 添加回滚机制：

```bash
#!/bin/bash

BACKUP_DIR="/var/www/backups"

# 部署前备份
backup() {
  TIMESTAMP=$(date +%Y%m%d-%H%M%S)
  BACKUP_PATH="$BACKUP_DIR/backup-$TIMESTAMP"

  echo "💾 备份到: $BACKUP_PATH"
  cp -r /var/www/app "$BACKUP_PATH"
  echo "$BACKUP_PATH" > .last-backup
}

# 回滚到上次备份
rollback() {
  if [ -f .last-backup ]; then
    BACKUP_PATH=$(cat .last-backup)
    echo "🔄 回滚到: $BACKUP_PATH"

    rm -rf /var/www/app
    cp -r "$BACKUP_PATH" /var/www/app

    echo "✅ 回滚完成"
  else
    echo "❌ 未找到备份"
    exit 1
  fi
}

# 使用
trap 'rollback' ERR  # 出错时自动回滚
backup
# ... 部署步骤 ...
```

### Q5: 如何在团队中共享工作流？

**A**: 标准化工作流：

1. **纳入版本控制**
   ```bash
   workflows/
   ├── deploy.sh
   ├── test.sh
   └── README.md
   ```

2. **提供安装脚本**
   ```bash
   # scripts/setup-workflows.sh
   #!/bin/bash
   # 复制工作流到系统路径
   cp workflows/*.sh /usr/local/bin/
   chmod +x /usr/local/bin/*.sh
   ```

3. **编写文档**
   ```markdown
   # 团队工作流使用指南
   ## 安装
   ./scripts/setup-workflows.sh

   ## 使用
   deploy.sh production
   ```

4. **Code Review**
   - 工作流变更需要 PR
   - 团队审查和测试
   - 文档同步更新

### Q6: 工作流如何在不同的 CI/CD 平台上使用？

**A**: 编写平台无关的工作流：

```yaml
# .github/workflows/ci.yml (GitHub Actions)
name: CI
on: [push]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: npm ci
      - run: npm test
```

```yaml
# .gitlab-ci.yml (GitLab CI)
stages:
  - test

test:
  stage: test
  script:
    - npm ci
    - npm test
```

```yaml
# azure-pipelines.yml (Azure Pipelines)
trigger:
  - main

pool:
  vmImage: 'ubuntu-latest'

steps:
  - script: npm ci
  - script: npm test
```

**通用脚本**：
```bash
#!/bin/bash
# scripts/test.sh
# 可以在任何平台上使用

npm ci
npm test
```

---

## 故障排查

### 问题 1: 权限错误

**症状**：
```
Permission denied: ./workflows/deploy.sh
```

**解决方案**：
```bash
# 添加执行权限
chmod +x ./workflows/deploy.sh

# Windows PowerShell
Unblock-File .\workflows\deploy.ps1
```

### 问题 2: 环境变量未找到

**症状**：
```
Error: Environment variable not set: API_KEY
```

**解决方案**：
```bash
# 检查环境变量
echo $API_KEY

# 加载 .env 文件
source .env

# 或使用 direnv
echo "source .env" > .envrc
direnv allow
```

### 问题 3: 路径问题（Windows）

**症状**：
```
Error: The system cannot find the path specified.
```

**解决方案**：
```powershell
# 使用正斜杠
$path = "D:/Projects/app"

# 或使用 Join-Path
$path = Join-Path "D:" "Projects" "app"

# 转义反斜杠
$path = "D:\\Projects\\app"
```

### 问题 4: 工作流卡住

**症状**：
工作流一直运行，没有输出

**诊断**：
```bash
# 检查进程
ps aux | grep workflow

# 检查网络连接
netstat -an | grep ESTABLISHED

# 添加超时
timeout 300 ./workflows/deploy.sh production
```

### 问题 5: 磁盘空间不足

**症状**：
```
Error: No space left on device
```

**解决方案**：
```bash
# 检查磁盘空间
df -h

# 清理旧备份
find /var/www/backups -name "backup-*" -mtime +7 -delete

# 清理日志
find logs -name "*.log" -mtime +30 -delete

# 清理 npm 缓存
npm cache clean --force
```

---

## 总结

### 工作流自动化的价值

```
手动操作 → 自动化
    ↓
节省时间：数小时/天
减少错误：80-90%
提高质量：标准化流程
增强协作：知识共享
```

### 下一步

1. **识别自动化机会**
   - 重复性任务
   - 容易出错的流程
   - 耗时长的操作

2. **从简单开始**
   - 小型工作流
   - 单一职责
   - 逐步扩展

3. **持续改进**
   - 监控性能
   - 收集反馈
   - 优化流程

4. **团队推广**
   - 文档化
   - 分享经验
   - 标准化

---

## 相关资源

### 项目文档
- [Headless模式](./01-headless-mode.md) - 脚本化使用
- [CI/CD集成](./02-ci-cd-integration.md) - 持续集成
- [Plan模式](../../skills/a-productivity/01-plan-mode.md) - 任务规划

### 外部资源
- [GitHub Actions 文档](https://docs.github.com/en/actions)
- [GitLab CI 文档](https://docs.gitlab.com/ee/ci/)
- [PowerShell 文档](https://docs.microsoft.com/en-us/powershell/)

---

**最后更新**: 2026-01-18
**难度**: ⭐⭐⭐⭐⭐
**阅读时间**: 45分钟
**前置要求**: [Level 2 进阶提升](../../skills/), [Headless模式](./01-headless-mode.md)
