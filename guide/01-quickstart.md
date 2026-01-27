# 01 - Quickstart - 10分钟快速上手

> **快速体验 Claude Code 的核心功能**

**阅读时间**: 10分钟
**难度**: ⭐ 新手友好
**目标**: 完成安装、配置、第一个对话

---

## 目录

- [安装 Claude Code](#安装-claude-code)
- [启动和配置](#启动和配置)
- [第一个对话](#第一个对话)
- [核心操作](#核心操作)
- [常见问题](#常见问题)
- [下一步](#下一步)

---

## 安装 Claude Code

### Windows 用户 🪟

> **⏱️ 预计时间**: 3分钟

#### 方式 1：使用官方安装脚本（推荐）

```powershell
# 以管理员身份打开 PowerShell 或 Windows Terminal
irm https://claude.ai/install.ps1 | iex

# 验证安装
claude --version
```

#### 方式 2：使用 winget

```powershell
# 以管理员身份打开 PowerShell 或 Windows Terminal
winget install Anthropic.ClaudeCode

# 验证安装
claude --version
```

#### 方式 3：使用 scoop

```powershell
# 安装 scoop（如果未安装）
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
irm get.scoop.sh | iex

# 安装 Claude Code
scoop bucket add extras
scoop install claude-code
```

#### 方式 3：手动安装

1. 访问 [Claude Code 官网](https://claude.ai/code)
2. 下载 Windows 安装包（.exe）
3. 运行安装程序
4. 按照向导完成安装

**Windows 路径配置**（如果需要）：

```powershell
# 查看 Claude Code 安装路径
where.exe claude

# 通常在：
# C:\Users\<YourName>\AppData\Local\Programs\Claude Code

# 添加到 PATH（如果未自动添加）
[System.Environment]::SetEnvironmentVariable(
    'Path',
    [System.Environment]::GetEnvironmentVariable('Path', 'User') + ';C:\Users\<YourName>\AppData\Local\Programs\Claude Code',
    'User'
)
```

### macOS 用户

```bash
# 使用 Homebrew
brew install claude-code

# 验证安装
claude --version
```

### Linux 用户

```bash
# 使用安装脚本
curl -fsSL https://claude.ai/install.sh | bash

# 或使用包管理器（Ubuntu）
sudo apt install claude-code
```

---

## 启动和配置

### 1. 首次启动

```bash
# 在任意目录启动
claude

# 或指定项目目录
claude /path/to/your/project
```

**首次启动时**：

```
Welcome to Claude Code!

Please sign in to continue:
→ 打开浏览器完成授权
→ 配置 API 密钥（如果需要）
→ 选择模型（推荐：claude-sonnet-4-5-20250929）
```

### 2. 配置 API 密钥

**方式1：使用 /login 登录（推荐）** ⭐

首次启动 Claude Code 时，系统会自动提示登录：

```bash
claude
# 首次使用时系统会提示您登录
```

按照提示完成登录流程，自动配置API密钥。

**方式2：手动设置 API 密钥（高级用户）**

```bash
# 设置 API 密钥
claude config set api_key YOUR_API_KEY_HERE

# 验证配置
claude config list
```

**获取 API 密钥**：
1. 访问 [Anthropic Console](https://console.anthropic.com)
2. 创建 API 密钥
3. 复制密钥

### 3. 模型选择 ✨

> **验证状态**: ✅ 已验证
> **内容来源**: 微信文章分析 (2026-01-23)

#### 选项1: 使用 Claude 官方模型（推荐新手）

**优点**:
- ✅ 推理能力最强
- ✅ 功能完整支持
- ✅ 稳定可靠

**成本**: $20/月 (约¥145)

#### 选项2: 使用国产模型（推荐日常使用）⭐

**GLM 4.7**（智谱 AI）

**优点**:
- 💰 成本低：54元/季（约¥18/月）
- ⚡ 响应快：国内服务器，延迟低
- 🇨🇳 中文好：中文理解优秀
- ✅ 完全兼容：Claude Code 功能完整支持

**适用场景**:
- ✅ 日常开发
- ✅ 代码生成
- ✅ 文档写作
- ✅ 学习项目

**快速配置 GLM 4.7**:

```powershell
# 方法1: 使用配置工具（推荐）- Windows
npx @z_ai/coding-helper

# 按提示输入 API Key
# API Key 获取：https://open.bigmodel.cn/
# 选择套餐：Coding Lite（54元/季）
```

**其他国产模型**:

| 模型 | 特点 | 价格 | 推荐度 |
|------|------|------|--------|
| **GLM 4.7** | 性价比最高 | 54元/季 | ⭐⭐⭐⭐⭐ |
| MiniMax M2.1 | Coding 优化 | 按需 | ⭐⭐⭐⭐ |
| Kimi K2 | 长文本/Thinking | 按需 | ⭐⭐⭐⭐ |
| Qwen Plus | 企业级稳定 | 按需 | ⭐⭐⭐ |

**详细配置指南**: 📚 [国产模型配置指南](../advanced/c-integration/03-domestic-models-guide.md)

**模型选择建议**:

```
新手学习：
→ Claude 官方（体验最佳）

日常开发：
→ GLM 4.7（性价比最高）

企业项目：
→ 国产模型（数据合规）

复杂推理：
→ Claude 官方（能力最强）

混合使用：
→ 日常 GLM 4.7
→ 复杂任务切换 Claude 官方
```

### 4. Windows 配置文件位置

```powershell
# 查看配置目录
$env:USERPROFILE\.claude

# 配置文件
# C:\Users\<YourName>\.claude\config.json
```

---

## 第一个对话

### 场景：创建 Python Hello World

#### 步骤 1：启动 Claude Code

```powershell
# Windows (PowerShell)
cd D:\Projects\MyFirstProject
claude

# macOS/Linux
cd ~/Projects/MyFirstProject
claude
```

#### 步骤 2：输入第一个指令

```
👤 你：你好！请帮我创建一个 Python 的 Hello World 程序
```

#### 步骤 3：观察 Claude 的响应

```
🤖 Claude：好的！我将为您创建一个简单的 Python Hello World 程序。

[使用 Write 工具创建 hello.py]

✅ 已创建文件：hello.py
内容：
```python
def main():
    """主函数"""
    print("Hello, World!")

if __name__ == "__main__":
    main()
```

现在您可以运行这个程序：
```bash
python hello.py
```

需要我帮您运行吗？
```

#### 步骤 4：继续交互

```
👤 你：是的，请运行

🤖 Claude：
[使用 Bash 工具执行 python hello.py]

输出：
Hello, World!

程序执行成功！
```

### 🎉 恭喜！

你已经完成了：
- ✅ 安装 Claude Code
- ✅ 启动和配置
- ✅ 第一个对话
- ✅ 创建文件
- ✅ 执行命令

---

## 核心操作

### 操作 1：读取文件

```
👤 你：读取 README.md

🤖 Claude：
[读取文件内容]
[显示文件摘要]
```

**快捷方式**：
```
@README.md
```

### 操作 2：创建文件

```
👤 你：创建一个 .gitignore 文件，包含 node_modules 和 .env

🤖 Claude：
[创建 .gitignore]
[添加内容]
```

### 操作 3：编辑文件

```
👤 你：在 hello.py 顶部添加版权注释

🤖 Claude：
[编辑文件]
[添加注释]
```

### 操作 4：运行命令

```
👤 你：运行 npm install

🤖 Claude：
[执行命令]
[显示输出]
```

**快捷方式**：
```
!npm install
```

### 操作 5：搜索代码

```
👤 你：搜索所有包含 TODO 的文件

🤖 Claude：
[搜索文件]
[显示结果列表]
```

---

## 实战小练习

### 练习 1：创建配置文件（2分钟）

```
👤 你：创建 package.json，包含以下内容：
- 项目名称：my-first-project
- 版本：1.0.0
- 描述：我的第一个项目
- 依赖：lodash
```

**预期结果**：
- Claude 创建 package.json
- 包含正确的 JSON 格式
- 添加 lodash 到 dependencies

### 练习 2：运行 Git 命令（2分钟）

```
👤 你：初始化 Git 仓库并创建首次提交

🤖 Claude：
[执行 git init]
[执行 git add .]
[执行 git commit -m "Initial commit"]
```

### 练习 3：查看项目结构（1分钟）

```
👤 你：显示当前目录的文件树

🤖 Claude：
[执行命令显示目录结构]
```

---

## 常见问题

### Q1: 命令找不到

**症状**：
```
'claude' 不是内部或外部命令
```

**解决方案**：

```powershell
# 1. 检查 PATH
$env:Path -split ';'

# 2. 添加 Claude Code 到 PATH（临时）
$env:Path += ";C:\Users\<YourName>\AppData\Local\Programs\Claude Code"

# 3. 永久添加
[System.Environment]::SetEnvironmentVariable(
    'Path',
    [System.Environment]::GetEnvironmentVariable('Path', 'User') + ';C:\Users\<YourName>\AppData\Local\Programs\Claude Code',
    'User'
)

# 4. 重启终端
```

### Q2: API 密钥错误

**症状**：
```
Error: Invalid API key
```

**解决方案**：

```bash
# 重新设置 API 密钥
claude config set api_key YOUR_NEW_API_KEY

# 验证
claude config list
```

### Q3: 权限错误（Windows）

**症状**：
```
Access Denied
```

**解决方案**：

```powershell
# 以管理员身份运行 PowerShell
Start-Process powershell -Verb runAs

# 或使用用户目录
cd $env:USERPROFILE\Projects
```

### Q4: 如何退出

```bash
# 方式 1：Ctrl + D
# 方式 2：输入 exit 然后回车
# 方式 3：Ctrl + C（中断当前操作）
```

---

## 下一步

### 🎯 你已经掌握了基础！

现在你可以：

1. ✅ 安装和配置 Claude Code
2. ✅ 启动对话
3. ✅ 创建、编辑、读取文件
4. ✅ 运行命令
5. ✅ 搜索代码

### 📚 继续学习

```
[02 - Core Features](./02-core-features.md)
→ 掌握 8 个核心功能
→ 提升使用效率
→ 理解高级特性
```

### 🚀 实战项目

```
[03 - First Project](./03-first-project.md)
→ 从零构建完整应用
→ 综合运用核心功能
→ 最佳实践演示
```

### 💡 小贴士

**使用技巧**：

1. **明确描述需求**
   ```
   ❌ 帮我写个函数
   ✅ 创建一个计算斐波那契数列的函数，使用递归实现
   ```

2. **分步进行**
   ```
   不要一次性要求太多，分步骤完成
   ```

3. **使用 Esc 撤销**
   ```
   如果不满意，按 Esc 撤销上一次操作
   ```

4. **善用 @ 和 !**
   ```
   @filename   # 引用文件
   !command    # 运行命令
   ```

---

## 快速参考卡

### 常用命令

| 操作 | 命令 | 说明 |
|------|------|------|
| 启动 | `claude` | 在当前目录启动 |
| 指定目录 | `claude /path/to/project` | 在指定目录启动 |
| 配置 | `claude config set key value` | 设置配置 |
| 版本 | `claude --version` | 查看版本 |
| 帮助 | `claude --help` | 查看帮助 |

### 快捷键

| 快捷键 | 功能 |
|--------|------|
| `Ctrl + C` | 中断操作 |
| `Ctrl + D` | 退出会话 |
| `Ctrl + R` | 搜索历史命令 |
| `Esc` | 撤销上一次操作 |
| `Tab` | 自动补全 |

### @ 符号用法

| 用法 | 示例 | 说明 |
|------|------|------|
| `@file` | `@README.md` | 引用文件 |
| `@dir/` | `@src/` | 引用目录 |
| `@*.ext` | `@*.json` | 引用所有匹配文件 |

---

**最后更新**: 2025-01-17
**下一章节**: [02 - Core Features](./02-core-features.md)
