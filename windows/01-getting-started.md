# Windows 入门指南 - Getting Started

> **Windows 用户快速上手 Claude Code**

**阅读时间**: 30分钟
**难度**: ⭐⭐
**适用场景**: 新安装 Claude Code 的 Windows 用户
**前置要求**: Windows 10/11

---

## 目录

- [安装准备](#安装准备)
- [安装方法](#安装方法)
- [首次启动](#首次启动)
- [基本配置](#基本配置)
- [Claude Code Now 启动器](#claude-code-now-启动器)
- [Windows Terminal 设置](#windows-terminal-设置)
- [PowerShell 配置](#powershell-配置)
- [验证安装](#验证安装)
- [常见问题](#常见问题)

---

## 安装准备

### 系统要求

**最低要求**：

```
✅ Windows 10 (版本 21H2 或更高)
✅ Windows 11 (所有版本)
✅ x64 处理器
✅ 至少 4GB RAM
✅ 至少 1GB 可用磁盘空间
```

**推荐配置**：

```
✅ Windows 11 (最新版本)
✅ 8GB+ RAM
✅ SSD 硬盘
✅ 多核处理器
```

### 检查系统版本

**PowerShell 命令**：

```powershell
# 查看 Windows 版本
systeminfo | findstr /B /C:"OS Name"

# 或使用
Get-ComputerInfo | Select-Object WindowsProductName, WindowsVersion

# 查看系统信息
winver
```

---

## 安装方法

### 方法 1: winget（推荐）⭐⭐⭐⭐⭐

**官方包管理器，最简单**

```powershell
# 搜索 Claude Code
winget search Claude Code

# 安装
winget install ClaudeCode.ClaudeCode

# 验证安装
claude --version
```

**优势**：
```
✅ 官方支持
✅ 自动更新
✅ 最简单
✅ 管理方便
```

**使用 Claude Code 辅助安装**：

```markdown
👤 你：帮我安装 Claude Code

🤖 Claude：[提供安装指令]
1. 打开 PowerShell
2. 运行: winget install ClaudeCode.ClaudeCode
3. 等待安装完成
```

### 方法 2: Scoop

**适用于开发者**

```powershell
# 安装 Scoop
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -UseBasicParsing get.scoop.sh | Invoke-Expression

# 安装 Claude Code
scoop bucket add extras
scoop install claude-code
```

**优势**：
```
✅ 开发者友好
✅ 环境隔离
✅ 多版本管理
✅ 便携版支持
```

### 方法 3: 手动安装

**下载安装包**

1. **访问官网**：https://claude.ai/code

2. **下载 Windows 安装包**：
   - 文件名：`Claude-Code-setup-x.x.y.exe`
   - 大小：约 150-200MB

3. **运行安装程序**：
   - 双击安装包
   - 或在 PowerShell 中运行：
     ```powershell
     .\Claude-Code-setup-x.y.z.exe
     ```

4. **完成安装向导**：
   - 选择安装位置
   - 选择添加到 PATH
   - 选择创建桌面快捷方式

---

## 首次启动

### 启动 Claude Code

**方式 1: 从开始菜单**

```
1. 点击开始按钮
2. 搜索 "Claude Code"
3. 点击打开
```

**方式 2: 从命令行**

```powershell
# 启动 Claude Code
claude

# 或使用完整路径
& "$env:LOCALAPPDATA\Programs\Claude Code\claude.exe"
```

**方式 3: 使用别名**

```powershell
# 在 $PROFILE 中添加别名
function claude { & "$env:LOCALAPPDATA\Programs\Claude Code\claude.exe" $args }

# 使用
claude
```

### 欢迎界面

**首次启动流程**：

```
1. 欢迎屏幕
   └─ 查看 Claude Code 的功能

2. 登录/注册
   └─ 使用 Anthropic 账号登录
   └─ 或创建新账户

3. 配置向导（可选）
   └─ 选择默认编辑器
   └─ 选择默认终端
   └─ 配置主题

4. 主界面
   └─ 开始使用 Claude Code
```

---

## 基本配置

### 环境变量配置

**添加到 PATH**：

```powershell
# 检查是否已添加
$env:PATH -split ';' | Select-String "Claude Code"

# 如果没有，手动添加
$claudePath = "$env:LOCALAPPDATA\Programs\Claude Code"
$env:PATH += ";$claudePath"

# 永久添加（用户级别）
[System.Environment]::SetEnvironmentVariable('Path', $env:PATH, 'User')
```

**验证配置**：

```powershell
# 重启终端后验证
claude --version

# 应显示版本号
Claude Code v1.x.x
```

### 默认编辑器

**配置外部编辑器**：

```markdown
在 Claude Code 中：
Settings → Editor → Default Editor

选项：
- VS Code（推荐）
- Notepad++
- Sublime Text
- 或其他你喜欢的编辑器
```

**使用 Claude Code 设置**：

```markdown
👤 你：配置默认编辑器为 VS Code

🤖 Claude：[提供配置步骤]
1. 打开设置
2. 找到 "Editor" 部分
3. 设置 "Default Editor" 为 "VS Code"
```

### 配置文件位置

**Windows 配置目录**：

```
配置文件: %APPDATA%\Claude Code\settings.json
完整路径: C:\Users\Username\AppData\Roaming\Claude Code\settings.json

会话目录: %APPDATA%\Claude Code\sessions\
日志目录: %APPDATA%\Claude Code\logs\
```

**快速访问**：

```powershell
# 打开配置目录
explorer $env:APPDATA\Claude\Code

# 或在 Claude Code 中
👤 你：打开配置目录
```

---

## Claude Code Now 启动器 ✨

> **验证状态**: ✅ 已验证
> **内容来源**: 微信文章分析 (2026-01-23)
> **GitHub**: https://claudecodenow.com/
> **Stars**: 400+

### 什么是 Claude Code Now?

**Claude Code Now** 是一个 Windows 右键菜单集成工具,让启动 Claude Code 变得更加便捷。

**核心功能**:

```
✅ 右键菜单集成
   └─ 在任意文件夹右键即可启动

✅ 自动加载当前文件夹
   └─ 无需手动 cd 到目录

✅ 一键启动
   └─ 开箱即用,无需配置

✅ 危险模式快捷启动
   └─ 快速进入危险模式

✅ 自定义模型切换
   └─ 快速切换不同模型
```

**为什么使用 Claude Code Now?**

```
传统方式:
1. 打开终端
2. cd 到项目目录
3. 输入 claude
4. 等待启动

Claude Code Now:
1. 在文件夹右键
2. 点击 "Open with Claude Code"
3. 自动启动并加载

节省时间: 50%+
操作步骤: 减少 66%
```

### 安装方法

#### 方法 1: 官网下载（推荐）

```
1. 访问官网
   https://claudecodenow.com/

2. 下载最新版本
   - Windows 安装包 (.exe)

3. 双击安装
   - 按照向导完成安装

4. 验证安装
   - 在任意文件夹右键
   - 查看 "Open with Claude Code" 选项
```

#### 方法 2: 包管理器安装

**使用 winget**:

```powershell
# 搜索
winget search ClaudeCodeNow

# 安装
winget install ClaudeCodeNow

# 验证
winget list | Select-String ClaudeCodeNow
```

**使用 scoop**:

```powershell
# 添加 bucket（如果未添加）
scoop bucket add extras

# 安装
scoop install claudecodenow

# 验证
scoop installed | Select-String claudecodenow
```

#### 方法 3: 手动安装

```
1. 下载便携版
   - 从 GitHub Releases 下载
   - 无需安装,解压即用

2. 运行配置脚本
   - 双击 install.ps1
   - 或手动运行:
     ```powershell
     .\install.ps1
     ```

3. 重启资源管理器
   - taskkill /f /im explorer.exe
   - start explorer.exe
```

### 使用方法

#### 基本使用

**在文件夹中启动**:

```
1. 在任意文件夹中右键
2. 选择 "Open with Claude Code"
3. 自动启动并加载该文件夹
```

**在文件中启动**:

```
1. 在任意文件上右键
2. 选择 "Open with Claude Code"
3. 自动启动并加载文件所在目录
```

**在桌面空白处右键**:

```
1. 在桌面空白处右键
2. 选择 "Open with Claude Code"
3. 自动启动并加载桌面目录
```

#### 高级功能

**危险模式快捷启动**:

```powershell
# 在注册表中配置
Path: HKEY_CURRENT_USER\Software\ClaudeCodeNow
Key: DangerousMode
Value: 1

# 或使用配置工具
ClaudeCodeNow-config.exe
```

**自定义模型切换**:

```
右键菜单中包含:
├─ Open with Claude (默认模型)
├─ Open with Claude (Opus)
└─ Open with Claude (Sonnet)

可自定义其他模型
```

**历史记录管理**:

```powershell
# 查看历史记录
%LOCALAPPDATA%\ClaudeCodeNow\history.json

# 或使用配置工具
ClaudeCodeNow-history.exe
```

### 配置和自定义

#### 配置文件位置

```
配置文件: %APPDATA%\ClaudeCodeNow\config.json
历史文件: %LOCALAPPDATA%\ClaudeCodeNow\history.json
日志文件: %LOCALAPPDATA%\ClaudeCodeNow\logs\
```

#### 配置示例

**config.json**:

```json
{
  "defaultModel": "claude-sonnet-4-5-20250929",
  "dangerousMode": false,
  "autoLoadProject": true,
  "showMenuInExplorer": true,
  "showMenuInDesktop": true,
  "customModels": [
    {
      "name": "GLM 4.7",
      "command": "claude",
      "args": ["--model", "glm-4.7"]
    }
  ]
}
```

#### 菜单自定义

**添加自定义菜单项**:

```powershell
# 使用注册表编辑
reg add "HKCU\Software\Classes\Directory\shell\ClaudeCodeNow" /v "MUIVerb" /d "Open with Claude Code" /f

# 添加图标
reg add "HKCU\Software\Classes\Directory\shell\ClaudeCodeNow" /v "Icon" /d "C:\\Path\\To\\icon.ico" /f
```

### 故障排除

#### 问题 1: 右键菜单不显示

**症状**: 安装后右键菜单中没有 "Open with Claude Code"

**解决方案**:

```powershell
# 1. 检查安装
winget list | Select-String ClaudeCodeNow

# 2. 重新安装
winget uninstall ClaudeCodeNow
winget install ClaudeCodeNow

# 3. 重启资源管理器
taskkill /f /im explorer.exe
start explorer.exe

# 4. 检查注册表
reg query "HKCU\Software\Classes\Directory\shell\ClaudeCodeNow"
```

#### 问题 2: 点击无反应

**症状**: 点击右键菜单项没有任何反应

**解决方案**:

```powershell
# 1. 检查 Claude Code 是否安装
claude --version

# 2. 检查配置文件
notepad $env:APPDATA\ClaudeCodeNow\config.json

# 3. 查看日志
notepad $env:LOCALAPPDATA\ClaudeCodeNow\logs\latest.log

# 4. 重新配置
ClaudeCodeNow-config.exe --reset
```

#### 问题 3: 启动失败

**症状**: Claude Code Now 启动时出错

**解决方案**:

```powershell
# 1. 以管理员身份运行
# 右键 ClaudeudeCodeNow.exe → 以管理员身份运行

# 2. 检查系统要求
# Windows 10 21H2+ 或 Windows 11

# 3. 安装 VC++ 运行库
winget install Microsoft.VC++2015-2022Redist-x64

# 4. 重新下载安装
# 从官网下载最新版本
```

### 与其他启动器对比

| 启动器 | 优势 | 劣势 | 推荐度 |
|--------|------|------|--------|
| **Claude Code Now** | 右键集成、一键启动、Windows 专属 | 仅 Windows | ⭐⭐⭐⭐⭐ |
| **Terminal 插件** | Obsidian 集成、多标签 | 需要配置、需要 Obsidian | ⭐⭐⭐⭐ |
| **VS Code 集成** | 开发环境友好 | 重量级、启动慢 | ⭐⭐⭐ |
| **命令行别名** | 灵活、跨平台 | 需要手动输入 | ⭐⭐⭐⭐ |

**选择建议**:

```
Windows 用户:
→ Claude Code Now (最方便)

Obsidian 用户:
→ Terminal 插件 (深度集成)

开发者:
→ VS Code 集成 (工作流统一)

高级用户:
→ 命令行别名 (最灵活)
```

### 卸载方法

**使用 winget**:

```powershell
winget uninstall ClaudeCodeNow
```

**使用控制面板**:

```
1. 打开设置 → 应用
2. 搜索 "Claude Code Now"
3. 点击卸载
```

**手动卸载**:

```powershell
# 1. 停止进程
taskkill /f /im ClaudeudeCodeNow.exe

# 2. 删除文件
rm "$env:LOCALAPPDATA\Programs\ClaudeCodeNow" -Recurse

# 3. 删除注册表项
reg delete "HKCU\Software\Classes\Directory\shell\ClaudeCodeNow" /f
reg delete "HKCU\Software\Classes\Directory\Background\shell\ClaudeCodeNow" /f

# 4. 重启资源管理器
taskkill /f /im explorer.exe
start explorer.exe
```

### 最佳实践

**推荐工作流**:

```
1. 安装 Claude Code Now
2. 配置自定义模型
3. 设置默认工作目录
4. 添加常用项目快捷方式
5. 定期更新版本
```

**技巧**:

```
✅ 配置多个模型选项
   └─ 右键菜单显示多个模型选择

✅ 设置项目快捷方式
   └─ 常用项目一键启动

✅ 启用历史记录
   └─ 快速访问最近项目

✅ 自定义菜单文本
   └─ 个性化右键菜单
```

---

## Windows Terminal 设置

### 安装 Windows Terminal

**推荐安装**：

```powershell
# 使用 winget 安装
winget install Microsoft.WindowsTerminal

# 或从 Microsoft Store 安装
# 打开 Microsoft Store，搜索 "Windows Terminal"
```

### 配置 PowerShell 7

**设置为默认配置文件**：

1. **安装 PowerShell 7**（如果未安装）：
   ```powershell
   winget install Microsoft.PowerShell
   ```

2. **打开 Windows Terminal 设置**：
   ```
   Ctrl + , (逗号键)
   或
   点击下拉箭头 → Settings
   ```

3. **配置默认配置文件**：
   ```json
   {
     "profiles": {
       "defaults": {},
       "list": [
         {
           "guid": "{574e775e-4f2a-5b96-ac1e-a2962a402336}",
           "name": "PowerShell",
           "commandline": "pwsh.exe"
         }
       ]
     },
     "defaults": {
       "startingDirectory": "D:/Projects"
     }
   }
   ```

4. **设置为默认**：
   - 在 PowerShell 配置文件旁点击 "设为默认"

### 配置外观

**推荐设置**：

```json
{
  "profiles": {
    "defaults": {
      "fontFace": "Cascadia Code",
      "fontSize": 12,
      "cursorShape": "filledBox",
      "colorScheme": "Campbell"
    }
  },
  "schemes": [
    {
      "name": "Campbell",
      "foreground": "#D0D0D0",
      "background": "#0C0C0C0",
      "cursorColor": "#FFFFFF"
    }
  ]
}
```

---

## PowerShell 配置

### 安装 PowerShell 7

**查看当前版本**：

```powershell
$PSVersionTable.PSVersion
```

**安装 PowerShell 7**：

```powershell
# winget 安装
winget install Microsoft.PowerShell

# 验证安装
pwsh --version
```

### 配置 Profile

**创建 Profile**：

```powershell
# 检查 Profile 是否存在
Test-Path $PROFILE

# 如果不存在，创建
if (-not (Test-Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force
    Write-Host "Profile 已创建: $PROFILE"
}

# 编辑 Profile
notepad $PROFILE
```

**推荐配置**：

```powershell
# $PROFILE 内容

# 别名
function claude {
    & "$env:LOCALAPPDATA\Programs\Claude Code\claude.exe" $args
}

function ccode {
    & "$env:LOCALAPPDATA\Programs\Claude Code\claude.exe" $args
}

# 项目快捷方式
function proj { Set-Location "D:/Projects" }

# Git 快捷方式
function gs { git status }
function ga { git add . }
function gc { git commit -m }
function gp { git push }

# 提示符优化
# 需要安装 Oh-My-Posh
# Install-Module oh-my-posh
# Set-PoshPrompt -Theme Paradox
```

### 配置执行策略

**允许脚本执行**：

```powershell
# 查看当前策略
Get-ExecutionPolicy

# 设置为 RemoteSigned（推荐）
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 验证
Get-ExecutionPolicy -List
```

---

## 验证安装

### 功能验证

**测试 1: 基本对话**

```markdown
👤 你：你好，Claude！

🤖 Claude: 你好！我是 Claude，Anthropic 开发的 AI 助手。

✅ 对话成功！
```

**测试 2: 文件引用**

```markdown
创建测试文件:
test.md:
# 测试文件

# 测试引用
@test.md

👤 你：解释 @test.md 的内容

🤖 Claude: [读取并解释文件内容]

✅ 文件引用成功！
```

**测试 3: 命令执行**

```markdown
👤 你：当前目录是什么？

🤖 Claude: [执行命令]
当前工作目录是: D:\Projects

✅ 命令执行成功！
```

**测试 4: 代码生成**

```markdown
👤 你：创建一个简单的 TypeScript 函数，计算两个数的和

🤖 Claude: [生成代码]
function add(a: number, b: number): number {
  return a + b;
}

✅ 代码生成成功！
```

### 故障排查

**安装问题**：

```powershell
# 问题 1: 找不到 claude 命令

# 检查 PATH
$env:PATH -split ';' | Select-String "Claude"

# 重启终端
# 或手动刷新环境变量
$env:PATH = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path', 'User')

# 问题 2: 启动失败

# 检查日志
$logs = "$env:APPDATA\Claude Code\logs"
Get-ChildItem $logs -Filter "*.log" | Sort-Object LastWriteTime -Descending | Select-Object -First 1 | Get-Content

# 问题 3: 登录问题

# 检查网络连接
Test-Connection api.anthropic.com

# 检查代理设置
netsh winhttp show proxy
```

---

## 常见问题

### Q1: winget 不可用？

**A**: 更新 Windows 或使用其他方法

```powershell
# 更新 Windows
# 设置 → 更新和安全 → Windows 更新 → 检查更新

# 或使用手动安装
# 从官网下载安装包
```

### Q2: PowerShell 脚本执行被阻止？

**A**: 修改执行策略

```powershell
# 当前策略
Get-ExecutionPolicy

# 修改为 RemoteSigned（推荐）
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 或临时允许
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

### Q3: Claude Code 找不到？

**A**: 检查安装位置

```powershell
# 查找安装位置
Get-ChildItem -Path "$env:LOCALAPPDATA\Programs" -Recurse | Where-Object {$_.Name -like "*Claude*"}

# 手动添加到 PATH
$claudePath = "找到的路径"
$env:PATH += ";$claudePath"
[System.Environment]::SetEnvironmentVariable('Path', $env:PATH, 'User')
```

### Q4: 如何设置代理？

**A**: 配置系统代理或环境变量

```powershell
# 系统代理设置
# 控制面板 → 网络和 Internet → 代理

# 或环境变量
$env:HTTP_PROXY = "http://proxy.example.com:8080"
$env:HTTPS_PROXY = "http://proxy.example.com:8080"

# 永久设置
[System.Environment]::SetEnvironmentVariable('HTTP_PROXY', 'http://proxy.example.com:8080', 'User')
```

### Q5: 如何更新 Claude Code？

**A**: 使用 winget 或重新下载

```powershell
# 使用 winget 更新
winget upgrade ClaudeCode.ClaudeCode

# 或重新下载安装包
```

---

## 下一步

### 推荐学习路径

```
1. 完成本指南（30分钟）
   ✅ 安装和配置

2. 学习路径处理（35分钟）
   → [02-path-handling.md](./02-path-handling.md)
   ⭐⭐⭐⭐⭐ 必读！

3. 学习核心功能
   → [guide/02-core-features.md](../guide/02-core-features.md)

4. 学习进阶技巧
   → [skills/a-productivity/](../skills/a-productivity/README.md)
```

### 建议安装的工具

```
必备：
✅ Windows Terminal
✅ PowerShell 7
✅ Git for Windows

推荐：
✅ VS Code
✅ Node.js
✅ Python（可选）
```

---

## 总结

### 安装检查清单

```
□ 系统要求符合
□ Claude Code 已安装
□ 添加到 PATH
□ 首次启动成功
□ 基本配置完成
□ Windows Terminal 配置
□ PowerShell 7 安装
□ 功能验证通过
```

### 快速命令

```powershell
# 检查版本
claude --version

# 打开配置
explorer $env:APPDATA\Claude\Code

# 打开日志目录
explorer $env:APPDATA\Claude\Code\logs

# 重启 Claude Code
Stop-Process -Name "Claude Code"
& "$env:LOCALAPPDATA\Programs\Claude Code\claude.exe"
```

---

## 相关资源

### 项目文档
- [路径处理](./02-path-handling.md) - 下一步必读
- [性能优化](./03-performance.md) - 性能调优
- [故障排查](./04-troubleshooting.md) - 问题诊断

### 核心文档
- [快速上手](../guide/01-quickstart.md) - 基础使用
- [核心功能](../guide/02-core-features.md) - 功能详解

### 外部资源
- [Claude Code 官网](https://claude.ai/code)
- [Windows Terminal 文档](https://docs.microsoft.com/en-us/windows-terminal/)
- [PowerShell 文档](https://docs.microsoft.com/en-us/powershell/)

---

**最后更新**: 2026-01-18
**难度**: ⭐⭐
**阅读时间**: 30分钟
**重要性**: ⭐⭐⭐⭐⭐
