# Headless 模式 - Headless Mode

> **脚本化使用 Claude Code，实现自动化工作流**

**阅读时间**: 35分钟
**难度**: ⭐⭐⭐⭐
**适用场景**: 自动化脚本、CI/CD 集成、批处理
**前置要求**: [Level 2 进阶提升](../../advanced/), [工作流自动化](./03-workflow-automation.md)

---

## 目录

- [Headless 模式概述](#headless-模式概述)
- [命令行参数](#命令行参数)
- [脚本化调用](#脚本化调用)
- [批处理操作](#批处理操作)
- [CI/CD 集成](#cicd-集成)
- [实战案例](#实战案例)
- [Windows 专属](#windows-专属)
- [最佳实践](#最佳实践)
- [常见问题](#常见问题)

---

## Headless 模式概述

### 什么是 Headless 模式？

**定义**：Headless 模式是指在没有交互式界面的情况下使用 Claude Code，通过命令行参数和脚本进行自动化操作。

```
交互式模式：
用户 → 图形界面 → Claude Code → 结果
    ↓
  手动操作

Headless 模式：
脚本 → 命令行 → Claude Code → 输出文件
    ↓
  自动化执行
```

### 为什么需要 Headless 模式？

#### 1. 自动化工作流

```
手动模式：
打开 Claude Code → 输入提示词 → 等待结果 → 复制结果
    ↓
耗时、容易出错

Headless 模式：
脚本 → 一键执行 → 自动完成 → 结果保存
    ↓
快速、可靠、可重复
```

#### 2. CI/CD 集成

```yaml
# GitHub Actions 示例
- name: Code Review with Claude
  run: |
    claude --prompt "Review this PR" \
           --file @pr-changes.diff \
           --output review-result.txt
```

#### 3. 批处理

```bash
# 批量处理多个文件
for file in src/**/*.ts; do
  claude --refactor "$file" --output "${file%.ts}.refactored.ts"
done
```

---

## 命令行参数

### 基本参数

```bash
# 基本用法
claude [options]

# 常用参数
--prompt, -p <text>     # 提示词
--file, -f <path>       # 文件路径
--output, -o <path>     # 输出文件
--session <name>        # 会话名称
--model <model>         # 模型选择
--timeout <seconds>     # 超时时间
--verbose, -v           # 详细输出
--help, -h              # 帮助信息
--version              # 版本信息
```

### 参数详解

#### 1. 提示词参数

```bash
# 简单提示
claude --prompt "解释这段代码"

# 多行提示
claude --prompt "
分析以下代码的优缺点：
1. 代码质量
2. 性能
3. 安全性
"

# 从文件读取提示
claude --prompt @prompt.txt
```

#### 2. 文件参数

```bash
# 单个文件
claude --file src/app.ts --prompt "重构这个文件"

# 多个文件
claude --file src/app.ts --file src/utils.ts --prompt "分析依赖关系"

# 目录
claude --file src/ --prompt "生成文档"

# 文件模式
claude --file "src/**/*.test.ts" --prompt "运行测试"
```

#### 3. 输出参数

```bash
# 输出到文件
claude --prompt "生成 README" --output README.md

# 输出格式
claude --prompt "分析结果" --output result.json --format json

# 附加模式
claude --prompt "补充文档" --output README.md --append
```

#### 4. 会话参数

```bash
# 新建会话
claude --session my-project --prompt "初始化项目"

# 继续会话
claude --session my-project --prompt "添加新功能"

# 列出会话
claude --list-sessions

# 删除会话
claude --delete-session my-project
```

---

## 脚本化调用

### PowerShell 脚本

**基础脚本**：

```powershell
# scripts/refactor.ps1

param(
    [Parameter(Mandatory=$true)]
    [string]$FilePath,

    [Parameter(Mandatory=$true)]
    [string]$OutputPath
)

# 检查文件存在
if (-not (Test-Path $FilePath)) {
    Write-Error "文件不存在: $FilePath"
    exit 1
}

Write-Host "正在重构: $FilePath"

# 调用 Claude Code
$result = & claude `
    --prompt "重构这段代码，提高可读性和性能" `
    --file $FilePath `
    --output $OutputPath

if ($LASTEXITCODE -eq 0) {
    Write-Host "重构完成: $OutputPath" -ForegroundColor Green
} else {
    Write-Error "重构失败"
    exit 1
}
```

**使用方式**：

```powershell
# 基本用法
.\scripts\refactor.ps1 -FilePath "src\app.ts" -OutputPath "src\app.refactored.ts"

# 批量处理
Get-ChildItem "src\*.ts" | ForEach-Object {
    .\scripts\refactor.ps1 -FilePath $_.FullName -OutputPath "$($_.DirectoryName)\$($_.BaseName).refactored.ts"
}
```

### Bash 脚本

**自动化脚本**：

```bash
#!/bin/bash
# scripts/auto-docs.sh

# 生成 API 文档
echo "生成 API 文档..."

for file in src/api/*.ts; do
    echo "处理: $file"

    claude --prompt "生成 JSDoc 注释" \
          --file "$file" \
          --output "${file%.ts}.docs.md"

    if [ $? -eq 0 ]; then
        echo "✓ 完成: $file"
    else
        echo "✗ 失败: $file"
        exit 1
    fi
done

echo "所有文档生成完成！"
```

### Node.js 脚本

**程序化调用**：

```javascript
// scripts/claude-helper.js

const { execSync } = require('child_process');

class ClaudeHelper {
  constructor(options = {}) {
    this.claudePath = options.claudePath || 'claude';
    this.timeout = options.timeout || 30000;
  }

  async refactor(filePath, options = {}) {
    const args = [
      '--prompt', options.prompt || '重构代码',
      '--file', filePath,
      '--output', options.output || `${filePath}.refactored`
    ];

    return this.execute(args);
  }

  async generateDocs(filePattern, outputDir) {
    const files = this.findFiles(filePattern);

    for (const file of files) {
      const outputPath = path.join(outputDir, `${path.basename(file, '.ts')}.md`);
      await this.execute([
        '--prompt', '生成文档',
        '--file', file,
        '--output', outputPath
      ]);
    }
  }

  execute(args) {
    const command = `${this.claudePath} ${args.join(' ')}`;

    try {
      const result = execSync(command, {
        encoding: 'utf-8',
        timeout: this.timeout
      });
      return { success: true, output: result };
    } catch (error) {
      return {
        success: false,
        error: error.message,
        output: error.stdout
      };
    }
  }

  findFiles(pattern) {
    const glob = require('glob');
    return glob.sync(pattern);
  }
}

// 导出
module.exports = ClaudeHelper;

// 使用示例
if (require.main === module) {
  const helper = new ClaudeHelper();

  // 重构单个文件
  helper.refactor('src/app.ts', { output: 'src/app.refactored.ts' })
    .then(result => {
      if (result.success) {
        console.log('重构成功！');
        console.log(result.output);
      } else {
        console.error('重构失败:', result.error);
        process.exit(1);
      }
    });
}
```

---

## 批处理操作

### 批量代码审查

```powershell
# scripts/batch-review.ps1

$files = Get-ChildItem "src\**\*.ts" -Recurse

foreach ($file in $files) {
    Write-Host "审查: $($file.Name)"

    & claude `
        --prompt "代码审查：检查质量、性能、安全" `
        --file $file.FullName `
        --output "reviews\$($file.BaseName).review.txt"

    Start-Sleep -Seconds 2  # 避免请求过快
}

Write-Host "所有文件审查完成！"
```

### 批量生成测试

```bash
#!/bin/bash
# scripts/generate-tests.sh

TEST_DIR="tests/generated"

mkdir -p "$TEST_DIR"

# 查找所有需要测试的文件
files=$(find src -name "*.ts" -type f)

for file in $files; do
    relative_path=${file#src/}
    test_file="$TEST_DIR/${relative_path%.ts}.test.ts"

    echo "生成测试: $relative_path"

    claude --prompt "为 $(basename $file) 生成完整的单元测试" \
          --file "$file" \
          --output "$test_file"
done

echo "测试生成完成！"
```

### 批量重构

```javascript
// scripts/batch-refactor.js

const glob = require('glob');
const { execSync } = require('child_process');

const pattern = 'src/**/*.ts';
const files = glob.sync(pattern);

async function batchRefactor() {
  const results = [];

  for (const file of files) {
    console.log(`处理: ${file}`);

    try {
      const output = execSync(
        `claude --prompt "重构代码：提高可读性和性能" --file "${file}"`,
        { encoding: 'utf-8', timeout: 30000 }
      );

      results.push({ file, success: true, output });
    } catch (error) {
      results.push({ file, success: false, error: error.message });
    }

    // 避免请求过快
    await new Promise(resolve => setTimeout(resolve, 1000));
  }

  // 生成报告
  const success = results.filter(r => r.success).length;
  const failed = results.filter(r => !r.success).length;

  console.log(`\n批处理完成:`);
  console.log(`✓ 成功: ${success}`);
  console.log(`✗ 失败: ${failed}`);

  if (failed > 0) {
    console.log('\n失败的文件:');
    results.filter(r => !r.success).forEach(r => {
      console.log(`  - ${r.file}: ${r.error}`);
    });
  }
}

batchRefactor().catch(console.error);
```

---

## CI/CD 集成

### GitHub Actions

**工作流配置**：

```yaml
# .github/workflows/claude-review.yml

name: Claude Code Review

on:
  pull_request:
    types: [opened, synchronize]

jobs:
  code-review:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Install Claude Code
        run: |
          npm install -g @anthropic-ai/claude-code

      - name: Run Claude review
        run: |
          claude --session pr-review \
                --prompt "审查此 PR 的代码变更" \
                --file pr-changes.diff \
                --output review-result.txt

      - name: Upload review result
        uses: actions/upload-artifact@v3
        with:
          name: claude-review
          path: review-result.txt

      - name: Comment on PR
        uses: actions/github-script@v6
        with:
          script: |
            const fs = require('fs');
            const result = fs.readFileSync('review-result.txt', 'utf8');
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: `🤖 Claude Code 审查结果:\n\n${result}`
            });
```

### GitLab CI

**配置**：

```yaml
# .gitlab-ci.yml

stages:
  - review

claude-review:
  stage: review
  image: node:18

  before_script:
    - npm install -g @anthropic-ai/claude-code

  script:
    - claude --session "ci-$CI_PIPELINE_ID" \
          --prompt "审查合并请求 $CI_MERGE_REQUEST_IID" \
          --file diff.txt \
          --output review.txt

  artifacts:
    paths:
      - review.txt
    expire_in: 1 week

  only:
    - merge_requests
```

### Jenkins Pipeline

**Jenkinsfile**：

```groovy
// Jenkinsfile

pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Claude Review') {
            steps {
                script {
                    sh '''
                        claude --session "jenkins-${env.BUILD_NUMBER}" \
                              --prompt "代码审查和安全性检查" \
                              --file src/ \
                              --output claude-review.txt
                    '''
                }
            }
        }

        stage('Upload Results') {
            steps {
                archiveArtifacts artifacts: 'claude-review.txt'
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
```

---

## 实战案例

### 案例1: 自动化代码审查

**场景**：每次 PR 自动进行代码审查

**PowerShell 脚本**：

```powershell
# scripts/pr-review.ps1

param(
    [Parameter(Mandatory=$true)]
    [string]$PRNumber,

    [Parameter(Mandatory=$false)]
    [string]$RepoPath = "."
)

# 获取 PR 变更
$diffFile = "pr-$PRNumber.diff"
git diff HEAD~1 HEAD > $diffFile

# 运行 Claude 审查
Write-Host "正在审查 PR #$PRNumber..."

& claude `
    --session "pr-review-$PRNumber" `
    --prompt "审查此 PR 的代码：
1. 代码质量和可读性
2. 潜在的 bug 和问题
3. 性能优化建议
4. 安全性检查
5. 最佳实践建议" `
    --file $diffFile `
    --output "review-$PRNumber.md"

# 提取关键问题
$review = Get-Content "review-$PRNumber.md" -Raw
if ($review -match "(问题|错误|警告|建议)") {
    Write-Host "发现需要关注的问题！" -ForegroundColor Yellow

    # 可选：添加 PR 标签
    # gh pr edit $PRNumber --add-label "needs-review"
} else {
    Write-Host "代码审查通过！" -ForegroundColor Green
    # gh pr edit $PRNumber --add-label "approved"
}

Write-Host "审查完成！查看详细报告: review-$PRNumber.md"
```

### 案例2: 文档自动生成

**场景**：代码变更后自动更新文档

**Shell 脚本**：

```bash
#!/bin/bash
# scripts/update-docs.sh

set -e

echo "检测代码变更..."

# 获取变更的文件
CHANGED_FILES=$(git diff --name-only HEAD~1 HEAD)

# 过滤需要生成文档的文件
NEEDS_DOC=$(echo "$CHANGED_FILES" | grep -E '\.(ts|js)$' || true)

if [ -z "$NEEDS_DOC" ]; then
    echo "没有需要生成文档的文件"
    exit 0
fi

echo "以下文件需要更新文档:"
echo "$NEEDS_DOC"

# 为每个文件生成文档
for file in $NEEDS_DOC; do
    if [ ! -f "$file" ]; then
        echo "文件已删除: $file"
        continue
    fi

    # 生成文档文件
    doc_file="docs/${file%.*}.md"
    mkdir -p "$(dirname "$doc_file")"

    echo "生成文档: $doc_file"

    claude --prompt "为 $(basename $file) 生成完整的 API 文档，包括：
1. 文件描述
2. 导出的函数/类
3. 参数说明
4. 返回值
5. 使用示例
6. 注意事项" \
          --file "$file" \
          --output "$doc_file"

    if [ $? -eq 0 ]; then
        echo "✓ 生成成功: $doc_file"
    else
        echo "✗ 生成失败: $doc_file"
        exit 1
    fi
done

# 提交文档
git add docs/
if ! git diff --cached --quiet; then
    git commit -m "docs: 自动更新文档 [skip ci]"
    echo "文档已提交"
fi
```

### 案例3: 批量重构

**场景**：重构整个项目中的某个模式

**Node.js 脚本**：

```javascript
// scripts/batch-refactor.js

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

class BatchRefactor {
  constructor(options = {}) {
    this.pattern = options.pattern || 'src/**/*.ts';
    this.refactorType = options.refactorType || 'convert-to-arrow-functions';
    this.dryRun = options.dryRun || false;
  }

  async refactor() {
    const files = this.findFiles();
    console.log(`找到 ${files.length} 个文件`);

    const results = [];

    for (const file of files) {
      console.log(`\n处理: ${file}`);

      const prompt = this.getRefactorPrompt(this.refactorType);

      try {
        if (this.dryRun) {
          console.log(`[DRY RUN] 会执行: claude --prompt "${prompt}" --file "${file}"`);
          results.push({ file, dryRun: true });
        } else {
          const output = execSync(
            `claude --prompt "${prompt}" --file "${file}"`,
            { encoding: 'utf-8', stdio: 'inherit' }
          );

          results.push({ file, success: true });
        }

        // 避免请求过快
        await this.delay(2000);

      } catch (error) {
        console.error(`✗ 失败: ${file}`);
        console.error(`  错误: ${error.message}`);
        results.push({ file, success: false, error: error.message });
      }
    }

    this.printSummary(results);
  }

  getRefactorPrompt(type) {
    const prompts = {
      'convert-to-arrow-functions': '将所有函数转换为箭头函数',
      'add-typescript-types': '添加完整的 TypeScript 类型注解',
      'convert-to-async-await': '将 Promise 链转换为 async/await',
      'extract-constants': '提取魔法数字为命名常量',
      'error-handling': '添加完整的错误处理'
    };

    return prompts[type] || type;
  }

  findFiles() {
    const glob = require('glob');
    return glob.sync(this.pattern);
  }

  async delay(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }

  printSummary(results) {
    const total = results.length;
    const success = results.filter(r => r.success).length;
    const failed = results.filter(r => r && !r.success).length;
    const dryRun = results.filter(r => r.dryRun).length;

    console.log('\n' + '='.repeat(50));
    console.log('批处理摘要:');
    console.log(`  总计: ${total}`);
    console.log(`  成功: ${success}`);
    console.log(`  失败: ${failed}`);
    if (dryRun > 0) {
      console.log(`  DRY RUN: ${dryRun}`);
    }
    console.log('='.repeat(50));
  }
}

// CLI 接口
if (require.main === module) {
  const args = process.argv.slice(2);
  const options = {};

  for (let i = 0; i < args.length; i++) {
    switch (args[i]) {
      case '--pattern':
        options.pattern = args[++i];
        break;
      case '--type':
        options.refactorType = args[++i];
        break;
      case '--dry-run':
        options.dryRun = true;
        break;
    }
  }

  const refactor = new BatchRefactor(options);
  refactor.refactor().catch(console.error);
}

module.exports = BatchRefactor;
```

---

## Windows 专属

### PowerShell 集成

**与 PowerShell 深度集成**：

```powershell
# 使用 PowerShell 配置文件

# $PROFILE

# Claude Code 别名
function claude {
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    $claudePath = "$env:LOCALAPPDATA\Programs\Claude Code\claude.exe"

    if (Test-Path $claudePath) {
        & $claudePath $Arguments
    } else {
        Write-Error "Claude Code 未找到"
    }
}

# 使用别名
claude --prompt "帮助"
```

### Windows 任务计划

**定时任务**：

```powershell
# 创建每日文档生成任务

$action = New-ScheduledTaskAction -Execute 'pwsh.exe' -Argument `
    "-File `"D:\Projects\scripts\update-docs.ps1`""

$trigger = New-ScheduledTaskTrigger -Daily -At '2:00AM'

Register-ScheduledTask `
    -Action $action `
    -Trigger $trigger `
    -TaskName 'Daily Documentation Update' `
    -Description '使用 Claude Code 自动更新文档'
```

### Windows 特定配置

**路径处理**：

```powershell
# Headless 模式使用正斜杠

claude `
    --prompt "分析项目" `
    --file "D:/Projects/app/src" `
    --output "D:/Projects/app/analysis.md"

# ✅ 正确
# 使用正斜杠避免转义问题
```

**权限问题**：

```powershell
# 以管理员身份运行
# 右键 → 以管理员身份运行

# 或使用 UAC 提示
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "此脚本需要管理员权限"
    Start-Process powershell -Verb RunAs "-File `"$PSCommandPath`""
    exit
}
```

---

## 最佳实践

### 1. 错误处理

```powershell
# 完善的错误处理

try {
    & claude --prompt "生成代码" --file input.ts --output output.ts

    if ($LASTEXITCODE -eq 0) {
        Write-Host "成功！" -ForegroundColor Green
    } else {
        Write-Error "Claude Code 返回错误代码: $LASTEXITCODE"
        exit $LASTEXITCODE
    }
}
catch {
    Write-Error "执行失败: $_"
    exit 1
}
```

### 2. 日志记录

```powershell
# 添加日志

$LogDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$LogFile = "claude-$(Get-Date -Format 'yyyyMMdd').log"

function Log-Write {
    param([string]$Message)

    $logEntry = "[$LogDate] $Message"
    Add-Content -Path $LogFile -Value $logEntry
    Write-Host $Message
}

Log-Write "开始批处理"
# ... 执行任务
Log-Write "批处理完成"
```

### 3. 进度显示

```powershell
# 显示进度

$files = Get-ChildItem "src\*.ts"
$total = $files.Count
$current = 0

foreach ($file in $files) {
    $current++
    $percent = [math]::Round(($current / $total) * 100, 1)

    Write-Progress -Activity "代码审查" `
        -Status "处理 $current/$total" `
        -PercentComplete $percent `
        -CurrentOperation $file.Name

    & claude --prompt "审查代码" --file $file.FullName
}

Write-Progress -Activity "代码审查" -Completed
```

### 4. 资源清理

```powershell
# 清理临时文件

$tempDir = "temp"
if (Test-Path $tempDir) {
    Remove-Item -Recurse -Force $tempDir
    Write-Host "临时文件已清理"
}

# 清理会话
Get-ChildItem "$env:APPDATA\Claude Code\sessions\*" |
    Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-7) } |
    Remove-Item -Force
```

---

## 常见问题

### Q1: Headless 模式找不到文件？

**A**: 检查文件路径

```powershell
# ❌ 相对路径可能有问题
claude --file src/app.ts

# ✅ 使用绝对路径
claude --file "D:/Projects/app/src/app.ts"

# ✅ 或使用正斜杠
claude --file "D:/Projects/app/src/app.ts"
```

### Q2: 超时问题？

**A**: 增加超时时间

```powershell
# 默认 30 秒
claude --prompt "复杂任务" --file large-file.ts

# 增加到 120 秒
claude --prompt "复杂任务" --file large-file.ts --timeout 120
```

### Q3: 如何处理大文件？

**A**: 分批处理

```markdown
# ❌ 不好：一次处理整个大文件
claude --file "huge-file.ts"

# ✅ 好：分部分处理
claude --file "huge-file.ts" --prompt "只读取前 100 行"
claude --file "huge-file.ts" --prompt "只读取类定义"
claude --file "huge-file.ts" --prompt "只读取导出部分"
```

---

## 总结

### Headless 模式的价值

```
交互式 → Headless
    ↓
手动 → 自动化
    ↓
单次 → 可重复
    ↓
孤立 → 可集成
```

### 使用场景

```
✅ 自动化脚本
✅ CI/CD 集成
✅ 批处理操作
✅ 定时任务
✅ DevOps 流程
```

---

## 相关资源

### 项目文档
- [工作流自动化](./03-workflow-automation.md) - 工作流基础
- [测试自动化](./02-testing-automation.md) - CI/CD 测试

### 外部资源
- [Claude Code 文档](https://claude.ai/code/docs)
- [GitHub Actions 文档](https://docs.github.com/en/actions)

---

**最后更新**: 2026-01-18
**难度**: ⭐⭐⭐⭐
**阅读时间**: 35分钟
**重要性**: ⭐⭐⭐⭐
