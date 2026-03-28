# CI/CD 集成 - 持续集成和持续部署

> **将 Claude Code 集成到企业级 CI/CD 流程**

**阅读时间**: 40分钟
**难度**: ⭐⭐⭐⭐⭐
**重要性**: ⭐⭐⭐⭐⭐
**适用场景**: DevOps工程师、自动化团队、企业级应用
**前置要求**: [Headless 模式](./01-headless-mode.md), [工作流自动化](./03-workflow-automation.md)

---

## 目录

- [CI/CD 概述](#cicd-概述)
- [CI/CD 平台对比](#cicd-平台对比)
- [GitHub Actions 集成](#github-actions-集成)
- [GitLab CI 集成](#gitlab-ci-集成)
- [Jenkins 集成](#jenkins-集成)
- [Azure DevOps 集成](#azure-devops-集成)
- [实战案例](#实战案例)
- [Windows 专属](#windows-专属)
- [最佳实践](#最佳实践)
- [常见问题](#常见问题)
- [故障排查](#故障排查)

---

## CI/CD 概述

### 什么是 CI/CD？

**CI (Continuous Integration - 持续集成)**：
- 频繁地将代码集成到主干
- 自动化构建和测试
- 快速发现和修复错误

**CD (Continuous Deployment/Delivery - 持续部署/交付)**：
- 自动将代码部署到生产环境
- 减少手动操作
- 加快交付速度

### Claude Code 在 CI/CD 中的角色

```
CI/CD 流程中的 Claude Code：
┌─────────────────────────────────────────┐
│  1. 代码审查自动化                         │
│     ├─ 自动审查 Pull Request              │
│     ├─ 生成审查报告                        │
│     └─ 检测代码问题                        │
│                                           │
│  2. 文档自动生成                           │
│     ├─ API 文档生成                        │
│     ├─ README 更新                         │
│     └─ 变更日志生成                        │
│                                           │
│  3. 代码质量检查                           │
│     ├─ 安全漏洞扫描                        │
│     ├─ 性能分析                            │
│     └─ 代码规范检查                        │
│                                           │
│  4. 测试自动化                             │
│     ├─ 生成测试用例                         │
│     ├─ 测试数据分析                        │
│     └─ 失败用例诊断                        │
│                                           │
│  5. 部署自动化                             │
│     ├─ 生成部署脚本                         │
│     ├─ 配置文件生成                         │
│     └─ 回滚方案规划                         │
└─────────────────────────────────────────┘
```

### 核心价值

**为什么在 CI/CD 中使用 Claude Code？**

1. **自动化审查**: 24/7 自动代码审查
2. **效率提升**: 减少人工审查时间
3. **一致性**: 统一的审查标准
4. **快速反馈**: 实时发现问题
5. **知识积累**: 学习最佳实践

---

## CI/CD 平台对比

### 主流平台特性对比

| 平台 | 难度 | 集成方式 | 优势 | 适用场景 |
|------|------|---------|------|---------|
| **GitHub Actions** | ⭐⭐⭐ | YAML配置 | 无需额外服务器，免费额度大 | 开源项目，GitHub仓库 |
| **GitLab CI** | ⭐⭐⭐⭐ | YAML配置 | 内置CI/CD，一体化 | GitLab用户 |
| **Jenkins** | ⭐⭐⭐⭐⭐ | 插件系统 | 高度可定制，生态丰富 | 复杂流程，企业级 |
| **Azure DevOps** | ⭐⭐⭐⭐ | YAML/GUI | 微软生态完整 | Azure/Windows环境 |
| **CircleCI** | ⭐⭐⭐ | YAML配置 | 简单易用，快速配置 | Docker支持 |

### 选择建议

```
GitHub 项目
├─ 小型团队 (< 10人)
├─ 开源项目
└─ 已使用 GitHub
→ 优先选择 GitHub Actions

GitLab 用户
├─ 中大型团队
├─ 需要 DevOps 一体化
└─ 已使用 GitLab
→ 优先选择 GitLab CI

企业级定制
├─ 复杂工作流
├─ 自定义需求
└─ 本地部署
→ 优先选择 Jenkins

微软生态
├─ Azure 项目
├─ Windows 环境
└─ 微软工具链
→ 优先选择 Azure DevOps
```

---

## GitHub Actions 集成

### 基础配置

**1. 创建工作流文件**

```yaml
# .github/workflows/claude-review.yml

name: Claude Code Review

on:
  pull_request:
    types: [opened, synchronize, reopened]
  push:
    branches: [main, develop]

jobs:
  claude-review:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v3
      with:
        fetch-depth: 0

    - name: Install Claude Code
      run: |
        npm install -g @anthropic-ai/claude-code

    - name: Run Claude Code Review
      env:
        ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
      run: |
        claude --prompt "审查以下 Pull Request 的代码变更，重点关注：
        1. 代码质量
        2. 潜在bug
        3. 安全问题
        4. 最佳实践

        PR 描述：${{ github.event.pull_request.title }}

        变更文件：$(git diff --name-only origin/${{ github.base_ref }} ${{ github.sha }})"

        claude --prompt "审查这些文件：$(git diff origin/${{ github.base_ref }} ${{ github.sha }})"
```

**2. 配置 Secrets**

```bash
# GitHub 仓库设置
Settings → Secrets and variables → Actions
→ New repository secret
Name: ANTHROPIC_API_KEY
Value: your-api-key-here
```

### 高级用法

**条件执行**

```yaml
- name: Run Claude Code Review
  if: github.event_name == 'pull_request'
  run: |
    claude --prompt "审查PR #${{ github.event.pull_request.number }}"
```

**矩阵构建**

```yaml
strategy:
  matrix:
    node-version: [14.x, 16.x, 18.x]

steps:
  - name: Review for Node ${{ matrix.node-version }}
    run: |
      claude --prompt "检查 Node.js ${{ matrix.node-version }} 兼容性"
```

**缓存优化**

```yaml
- name: Cache Claude Code
  uses: actions/cache@v3
  with:
    path: ~/.claude-code
    key: claude-code-${{ runner.os }}
```

### 实战示例

**完整的 PR 审查工作流**

```yaml
name: Complete PR Workflow

on:
  pull_request:
    branches: [main, develop]

jobs:
  code-review:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3

    - name: Claude Code Review
      env:
        ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
      run: |
        echo "=== Claude Code 审查开始 ==="

        # 获取PR信息
        PR_NUMBER="${{ github.event.pull_request.number }}"
        PR_TITLE="${{ github.event.pull_request.title }}"
        PR_BODY="${{ github.event.pull_request.body }}"

        # 获取变更文件
        CHANGED_FILES=$(git diff --name-only origin/${{ github.base_ref }} ${{ github.sha }})

        # 运行审查
        claude --prompt "
        作为资深代码审查专家，请审查以下 PR：

        PR #${PR_NUMBER}: ${PR_TITLE}

        变更文件：
        ${CHANGED_FILES}

        请：
        1. 检查代码质量
        2. 识别潜在问题
        3. 提供改进建议
        4. 评估是否可以合并

        以JSON格式输出审查结果：
        {
          \"approved\": true/false,
          \"comments\": [\"comment1\", \"comment2\"],
          \"issues\": [\"issue1\", \"issue2\"],
          \"suggestions\": [\"suggestion1\"]
        }
        "

    - name: Post Review Comment
      uses: actions/github-script@v7
      with:
        github-token: ${{ secrets.GITHUB_TOKEN }}
        script: |
          github.rest.issues.createComment({
            issue_number: context.issue.number,
            owner: context.repo.owner,
            repo: context.repo.name,
            body: '🤖 Claude Code 审查完成！\n\n详见工作流日志。'
          })
```

---

## GitLab CI 集成

### 基础配置

**1. 创建 .gitlab-ci.yml**

```yaml
# .gitlab-ci.yml

stages:
  - review
  - test
  - deploy

claude_review:
  stage: review
  image: node:18

  before_script:
    - npm install -g @anthropic-ai/claude-code

  script:
    - echo "=== Claude Code 代码审查 ==="
    - |
      claude --prompt "
      审查以下提交的代码变更：

      提交信息：${CI_COMMIT_TITLE}
      提交者：${GITLAB_USER_NAME}
      分支：${CI_COMMIT_REF_NAME}

      变更文件：
      $(git diff --name-only ${CI_MERGE_REQUEST_DIFF_BASE_SHA} ${CI_COMMIT_SHA})

      请重点检查：
      1. 代码质量和规范
      2. 潜在的bug和问题
      3. 安全漏洞
      4. 性能问题
      "

  rules:
    - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'

  artifacts:
    paths:
      - claude-review-output.json
    expire_in: 1 week

claude_test:
  stage: test
  image: node:18

  before_script:
    - npm install -g @anthropic-ai/claude-code

  script:
    - |
      claude --prompt "
      分析测试失败的原因：

      测试报告：tests/report.xml
      代码覆盖率：coverage/coverage.json

      请：
      1. 识别失败的测试用例
      2. 分析失败原因
      3. 提供修复建议
      "

  rules:
    - if: '$CI_JOB_STATUS == "failed"'
```

### 高级用法

**多阶段流水线**

```yaml
stages:
  - review
  - test
  - build
  - deploy

review:
  stage: review
  script:
    - claude --prompt "快速代码审查"

test:
  stage: test
  needs: [review]
  script:
    - npm test
  artifacts:
    reports:
      junit: tests/report.xml

build:
  stage: build
  needs: [test]
  script:
    - npm run build
  artifacts:
    paths:
      - dist/

deploy:
  stage: deploy
  needs: [build]
  script:
    - claude --prompt "生成部署脚本"
    - npm run deploy
  when: manual
```

### 实战示例

**自动生成合并请求描述**

```yaml
auto_mr_description:
  stage: review

  script:
    - |
      # 获取变更信息
      CHANGES=$(git diff --name-only origin/main...HEAD)

      # 使用 Claude Code 生成描述
      claude --prompt "
      基于以下代码变更，生成专业的合并请求描述：

      变更文件：
      ${CHANGES}

      变更内容：
      $(git diff origin/main...HEAD)

      请生成包含以下内容的描述：
      1. 变更概述
      2. 主要功能点
      3. 测试说明
      4. 相关Issue
      5. 审查要点
      " > mr-description.md

  artifacts:
    paths:
      - mr-description.md
```

---

## Jenkins 集成

### 基础配置

**1. 创建 Jenkinsfile**

```groovy
// Jenkinsfile

pipeline {
    agent any

    environment {
        ANTHROPIC_API_KEY = credentials('anthropic-api-key')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Claude Code') {
            steps {
                sh 'npm install -g @anthropic-ai/claude-code'
            }
        }

        stage('Code Review') {
            steps {
                script {
                    echo "=== Claude Code 审查开始 ==="

                    // 获取变更文件
                    def changedFiles = sh(
                        script: "git diff --name-only ${GIT_PREVIOUS_COMMIT} ${GIT_COMMIT}",
                        returnStdout: true
                    ).trim().split('\n')

                    // 准备审查提示词
                    def prompt = """
                    作为资深代码审查专家，请审查以下代码变更：

                    变更文件：${changedFiles.join(', ')}

                    请检查：
                    1. 代码质量和规范
                    2. 潜在问题
                    3. 安全漏洞
                    4. 性能问题
                    """

                    // 执行 Claude Code 审查
                    sh """
                        claude --prompt "${prompt}" > claude-review.txt
                    cat claude-review.txt
                    """
                }
            }
        }

        stage('Generate Documentation') {
            steps {
                script {
                    sh """
                        claude --prompt "
                        为以下代码生成 API 文档：

                        $(git diff ${GIT_PREVIOUS_COMMIT} ${GIT_COMMIT})

                        生成 OpenAPI/Swagger 格式文档。
                        " > api-docs.md
                    """
                }
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'claude-review.txt,api-docs.md', fingerprint: true
        }
    }
}
```

### 高级用法

**参数化构建**

```groovy
pipeline {
    parameters {
        string(name: 'REVIEW_TYPE', defaultValue: 'full', description: '审查类型')
        booleanParam(name: 'RUN_TESTS', defaultValue: true, description: '是否运行测试')
    }

    stages {
        stage('Review') {
            steps {
                script {
                    def prompt = params.REVIEW_TYPE == 'full'
                        ? "全面代码审查，包括架构、性能、安全"
                        : "快速代码审查，仅关注关键问题"

                    sh "claude --prompt '${prompt}'"
                }
            }
        }
    }
}
```

**多节点并行构建**

```groovy
pipeline {
    agent none

    stages {
        stage('Parallel Review') {
            parallel {
                stage('Frontend Review') {
                    agent { label 'frontend' }
                    steps {
                        sh "claude --prompt '审查前端代码'"
                    }
                }
                stage('Backend Review') {
                    agent { label 'backend' }
                    steps {
                        sh "claude --prompt '审查后端代码'"
                    }
                }
            }
        }
    }
}
```

### 实战示例

**完整的 CI/CD 流水线**

```groovy
pipeline {
    agent any

    stages {
        stage('Checkout & Setup') {
            steps {
                checkout scm
                sh 'npm install'
            }
        }

        stage('Claude Code Review') {
            steps {
                script {
                    def reviewResult = sh(
                        script: """
                            claude --prompt "
                            CI/CD 自动代码审查：

                            提交：${env.CHANGE_ID}
                            分支：${env.BRANCH_NAME}

                            变更：$(git diff HEAD~1 HEAD)

                            请输出：
                            - approved: true/false
                            - score: 0-100
                            - comments: []
                            " | jq '.'
                        """,
                        returnStdout: true
                    ).trim()

                    def approval = readJSON text: reviewResult

                    if (approval.approved == false) {
                        error "代码审查未通过：${approval.score}/100"
                    }
                }
            }
        }

        stage('Build') {
            steps {
                sh 'npm run build'
            }
        }

        stage('Test') {
            steps {
                sh 'npm test'
            }
        }

        stage('Deploy') {
            when {
                branch 'main'
            }
            steps {
                sh 'npm run deploy'
            }
        }
    }

    notifications {
        email {
            recipients: 'team@example.com'
            subject: "Jenkins 构建${env.JOB_NAME} - ${currentBuild.result}"
            body: """
                构建状态：${currentBuild.result}
                审查结果：详见附件
            """
        }
    }
}
```

---

## Azure DevOps 集成

### 基础配置

**1. 创建 Azure Pipeline**

```yaml
# azure-pipelines.yml

trigger:
  branches:
    include:
      - main
      - develop
  paths:
    include:
      - 'src/**'
      - '**.ts'
      - '**.js'

pool:
  vmImage: 'ubuntu-latest'

variables:
  ANTHROPIC_API_KEY: $(anthropic-api-key)

steps:
- checkout: self

- script: |
    npm install -g @anthropic-ai/claude-code
  displayName: 'Install Claude Code'

- script: |
    echo "=== Claude Code 审查 ==="
    claude --prompt "
    审查此构建的代码：

    构建号：$(Build.BuildId)
    分支：$(Build.SourceBranch)
    提交：$(Build.SourceVersion)

    变更文件：
    $(git diff HEAD~1 HEAD --name-only)

    请提供：
    1. 代码质量评估
    2. 问题清单
    3. 改进建议
    "
  displayName: 'Run Claude Code Review'
```

### 高级用法

**多阶段流水线**

```yaml
stages:
- stage: review
  jobs:
  - job: claude_review
    pool:
      vmImage: 'ubuntu-latest'
    steps:
    - script: |
        claude --prompt "快速审查代码"

- stage: test
  dependsOn: review
  jobs:
  - job: test
    pool:
      vmImage: 'ubuntu-latest'
    steps:
    - script: npm test
      failOnError: true

- stage: deploy
  dependsOn: test
  condition: and(succeeded(), eq(variables['Build.SourceBranch'], 'refs/heads/main'))
  jobs:
  - job: deploy
    pool:
      vmImage: 'ubuntu-latest'
    steps:
    - script: |
        claude --prompt "生成部署脚本"
        npm run deploy
```

### 实战示例

**带审批的部署流程**

```yaml
stages:
- stage: review
  jobs:
  - job: claude_review
    steps:
    - script: |
        claude --prompt "代码安全和性能审查"

- stage: deploy_approval
  dependsOn: review
  jobs:
  - deployment: app
    environment: 'production'
    strategy:
      runOnce:
        deploy:
          steps:
          - script: |
              claude --prompt "生成部署计划和回滚方案"

          - task: ManualValidation@1
            inputs:
              notes: "请审查 Claude Code 生成的部署计划"

          - script: |
              npm run deploy
```

---

## 实战案例

### 案例1: PR 自动审查

**场景**: 每次 PR 提交时自动审查代码

**GitHub Actions 实现**:

```yaml
name: PR Auto Review

on:
  pull_request:
    types: [opened, synchronize, reopened]

jobs:
  auto_review:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3
      with:
        fetch-depth: 0

    - name: Install Claude Code
      run: npm install -g @anthropic-ai/claude-code

    - name: Run Auto Review
      env:
        ANTHROPIC_API_KEY: ${{ secrets.ANTROPIC_API_KEY }}
      run: |
        # 获取PR信息
        PR_NUM="${{ github.event.pull_request.number }}"
        PR_URL="${{ github.event.pull_request.html_url }}"

        # 获取变更
        git fetch origin ${{ github.base_ref }}
        CHANGED_FILES=$(git diff --name-only origin/${{ github.base_ref }} ${{ github.sha }})
        CHANGED_CONTENT=$(git diff origin/${{ github.base_ref }} ${{ github.sha }})

        # 审查代码
        REVIEW_RESULT=$(claude --prompt "
        作为代码审查专家，请审查以下 PR：

        PR: ${PR_NUM}
        URL: ${PR_URL}

        变更文件：${CHANGED_FILES}

        变更内容：${CHANGED_CONTENT}

        审查要点：
        1. 代码质量（0-10分）
        2. 安全问题
        3. 性能问题
        4. 最佳实践

        请以JSON格式输出：
        {
          \"score\": 8,
          \"approved\": true,
          \"comments\": [
            \"Good code structure\",
            \"Consider adding error handling\"
          ],
          \"issues\": []
        }
        ")

        echo "${REVIEW_RESULT}" > review.json

        # 解析结果
        SCORE=$(jq -r '.score' review.json)
        APPROVED=$(jq -r '.approved' review.json)

        if [ "$APPROVED" != "true" ]; then
          echo "❌ 审查未通过，得分：$SCORE/10"
          exit 1
        fi

        echo "✅ 审查通过，得分：$SCORE/10"

    - name: Comment on PR
      if: success()
      uses: actions/github-script@v7
      with:
        github-token: ${{ secrets.GITHUB_TOKEN }}
        script: |
          const fs = require('fs');
          const review = JSON.parse(fs.readFileSync('review.json', 'utf8'));

          github.rest.issues.createComment({
            issue_number: context.issue.number,
            owner: context.repo.owner,
            repo: context.repo.name,
            body: `🤖 Claude Code 审查报告\n\n**得分**: ${review.score}/10\n\n**意见**:\n${review.comments.join('\\n')}\n\n**状态**: ${review.approved ? '✅ 通过' : '❌ 未通过'}`
          });
```

**结果**：
- ✅ 自动审查每个PR
- ✅ 提供量化评分
- ✅ 自动添加评论
- ✅ 阻止低质量代码合并

---

### 案例2: 测试失败诊断

**场景**: 测试失败时自动诊断原因

**GitLab CI 实现**:

```yaml
test_failure_analysis:
  stage: test
  image: node:18

  before_script:
    - npm install
    - npm install -g @anthropic-ai/claude-code

  script:
    - npm test 2>&1 | tee test.log
    - |
      TEST_EXIT_CODE=$?

      if [ $TEST_EXIT_CODE -ne 0 ]; then
        echo "=== 测试失败，Claude Code 诊断中 ==="

        claude --prompt "
        测试执行失败，请分析原因：

        测试日志：
        $(cat test.log)

        代码变更：
        $(git diff HEAD~1 HEAD)

        请：
        1. 识别失败的测试用例
        2. 分析失败原因
        3. 提供修复建议
        4. 预估修复时间
        "

        exit $TEST_EXIT_CODE
      fi

  allow_failure: true

  artifacts:
    paths:
      - test.log
      - claude-diagnosis.txt
    when: on_failure
```

**结果**：
- ✅ 自动识别失败的测试
- ✅ 分析失败原因
- ✅ 提供修复建议
- ✅ 保存诊断报告

---

### 案例3: 文档自动生成

**场景**: 代码变更时自动更新文档

**Jenkins Pipeline**:

```groovy
stage('Documentation Update') {
    when {
        anyOf {
            changeset "src/api/**"
            changeset "README.md"
        }
    }

    steps {
        script {
            // 1. 使用 Claude Code 生成 API 文档
            sh """
                claude --prompt "
                分析 src/ 目录下的 API 代码，
                生成 OpenAPI 3.0 规范文档。

                输出到 docs/api-spec.yaml
                " < docs/api-spec.yaml
            """

            // 2. 生成 README
            sh """
                claude --prompt "
                基于 src/ 代码和 docs/api-spec.yaml，
                更新 README.md 中的 API 文档章节。
                " < README.md
            """

            // 3. 提交变更
            sh """
                git config user.name "Claude Code Bot"
                git config user.email "claude-bot@example.com"

                git add docs/api-spec.yaml README.md
                git commit -m "docs: 自动更新 API 文档 [skip ci]"
                git push
            """
        }
    }
}
```

**结果**：
- ✅ 自动生成 API 文档
- ✅ 更新 README
- ✅ 自动提交文档变更

---

## Windows 专属

### Windows 环境 CI/CD

**Azure DevOps + Windows Agent**:

```yaml
pool:
  vmImage: 'windows-latest'

steps:
- checkout: self

- script: |
    PowerShell Install-Module -Force
    # 使用 PowerShell 安装 Claude Code

- script: |
    claude --prompt "Windows 环境代码审查"
  shell: pwsh

- script: |
    npm test
  shell: cmd
```

### Jenkins Windows Agent

```groovy
pipeline {
    agent {
        label 'windows-agent'
    }

    stages {
        stage('Review') {
            steps {
                bat 'claude --prompt "代码审查"'
            }
        }
    }
}
```

### PowerShell 脚本

```powershell
# Windows CI/CD PowerShell 脚本

# 1. 安装 Claude Code
npm install -g @anthropic-ai/claude-code

# 2. 代码审查
claude --prompt "审查 Windows 项目代码" | Out-File -FilePath review.txt

# 3. 生成文档
claude --prompt "生成文档" | Out-File -FilePath docs.md

# 4. 部署
claude --prompt "生成 PowerShell 部署脚本" | Out-File -FilePath deploy.ps1
```

---

## 最佳实践

### 1. 安全性

**保护 API 密钥**:

```yaml
# ✅ 正确：使用 Secrets
env:
  ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}

# ❌ 错误：硬编码
env:
  ANTHROPIC_API_KEY: sk-ant-xxx
```

**权限控制**:
- 只读权限（CI/CD 不需要写入权限）
- 最小权限原则
- 定期轮换密钥

### 2. 性能优化

**缓存机制**:

```yaml
- name: Cache Claude Code
  uses: actions/cache@v3
  with:
    path: ~/.claude-code
    key: claude-code-${{ runner.os }}
```

**并行处理**:

```yaml
strategy:
  matrix:
    module: [frontend, backend, api]

steps:
  - name: Review ${{ matrix.module }}
    run: |
      claude --prompt "审查 ${{ matrix.module }} 模块"
```

### 3. 错误处理

**失败重试**:

```yaml
- name: Review with Retry
  uses: nick-intrama/retry-action@v2
  with:
    timeout_minutes: 10
    max_attempts: 3
    retry_on: error
    command: |
      claude --prompt "代码审查"
```

**超时控制**:

```yaml
- name: Review
  timeout-minutes: 15
  run: |
    claude --prompt "代码审查" || echo "审查超时，继续流程"
```

### 4. 日志记录

**详细日志**:

```yaml
- name: Review with Logging
  run: |
    echo "=== 开始审查 ===" | tee -a review.log
    claude --prompt "审查代码" | tee -a review.log
    echo "=== 审查完成 ===" | tee -a review.log
```

**结构化输出**:

```yaml
- name: Review
  run: |
    claude --prompt "以JSON格式输出审查结果" | jq '.' > review.json
```

---

## 常见问题

### Q1: Claude Code 超时怎么办？

**A**:
- 增加超时时间（`timeout-minutes`）
- 简化提示词，减少 Token
- 使用缓存避免重复操作
- 检查网络连接

### Q2: 如何减少 CI/CD 成本？

**A**:
- 只审查关键分支（main、develop）
- 只审查变更文件，不审查全量
- 使用缓存避免重复安装
- 设置合理的超时时间

### Q3: Claude Code 审查准确吗？

**A**:
- Claude Code 是辅助工具，不是替代人工
- 建议人工抽查结果
- 可以使用"双盲审查"对比
- 持续优化提示词

### Q4: 如何处理敏感信息？

**A**:
- 不要在提示词中包含敏感信息
- 使用环境变量存储配置
- 审查后的输出可能需要过滤
- 遵守企业安全策略

### Q5: 支持哪些 CI/CD 平台？

**A**:
- ✅ GitHub Actions
- ✅ GitLab CI
- ✅ Jenkins
- ✅ Azure DevOps
- ✅ CircleCI
- ✅ Travis CI
- ✅ Bitbucket Pipelines

---

## 故障排查

### 问题诊断流程

```
CI/CD 失败
    ↓
1. 检查 Claude Code 是否安装
   which claude
   claude --version

2. 检查 API 密钥
   echo $ANTHROPIC_API_KEY

3. 测试 Claude Code
   claude --prompt "测试"

4. 检查日志
   # 查看工作流日志
   # 查看 Claude Code 输出

5. 检查网络
   # 测试 API 连接
   # 检查代理设置
```

### 常见错误

**错误 1: Command not found**

```
症状：claude: command not found

原因：Claude Code 未安装

解决：
- 添加安装步骤
- 使用完整路径
- 检查环境变量
```

**错误 2: API key invalid**

```
症状：Invalid API key

原因：API 密钥错误或过期

解决：
- 检查 Secrets 配置
- 验证密钥有效性
- 更新密钥
```

**错误 3: Timeout**

```
症状：Claude Code 响应超时

原因：网络问题或提示词过长

解决：
- 增加超时时间
- 简化提示词
- 使用本地缓存
```

---

## 相关资源

### 官档链接

- [Claude Code 官方文档](https://docs.anthropic.com)
- [GitHub Actions 文档](https://docs.github.com/en/actions)
- [GitLab CI 文档](https://docs.gitlab.com/ee/ci/)
- [Jenkins 文档](https://www.jenkins.io/doc/)

### 项目文档

- [Headless 模式](./01-headless-mode.md) - 脚本化使用
- [工作流自动化](./03-workflow-automation.md) - 工作流设计
- [测试自动化](./02-testing-automation.md) - 测试集成

### Windows 专属

- [Windows 专属](../../windows/)
- [Windows 入门](../../windows/01-getting-started.md)
- [Windows 故障排查](../../windows/04-troubleshooting.md)

---

## 总结

### 核心要点

1. **平台选择**
   - GitHub: 最简单，开源项目首选
   - GitLab: 一体化DevOps
   - Jenkins: 企业级定制

2. **集成方式**
   - YAML配置
   - CLI参数
   - 环境变量

3. **最佳实践**
   - 安全性：保护API密钥
   - 性能：缓存和并行
   - 可靠性：重试和超时
   - 日志：详细记录

4. **实战建议**
   - 从简单场景开始
   - 逐步增加复杂度
   - 持续优化提示词
   - 监控和调优

### 学习路径

```
第1周：基础集成
├─ GitHub Actions 简单工作流
├─ 基础代码审查
└─ 理解 CI/CD 流程

第2周：高级功能
├─ 多阶段流水线
├─ 并行处理
├─ 条件执行
└─ 错误处理

第3周：平台对比
├─ 尝试不同平台
├─ 选择最适合的平台
└─ 深度定制

第4周：优化改进
├─ 性能优化
├─ 安全加固
├─ 监控告警
└─ 持续改进
```

---

**最后更新**: 2026-02-04
**难度**: ⭐⭐⭐⭐⭐
**阅读时间**: 40分钟
**重要性**: ⭐⭐⭐⭐⭐
