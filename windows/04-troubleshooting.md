# 故障排查 - Troubleshooting

> **快速诊断和解决 Windows 问题**

**阅读时间**: 40分钟
**难度**: ⭐⭐⭐
**适用场景**: 遇到错误、问题诊断、快速解决
**前置要求**: [Windows 入门](./01-getting-started.md), [路径处理](./02-path-handling.md)

---

## 目录

- [故障排查概述](#故障排查概述)
- [常见错误类型](#常见错误类型)
- [诊断流程](#诊断流程)
- [命令问题](#命令问题)
- [权限问题](#权限问题)
- [路径问题](#路径问题)
- [性能问题](#性能问题)
- [网络问题](#网络问题)
- [环境问题](#环境问题)
- [实战案例](#实战案例)
- [快速参考](#快速参考)

---

## 故障排查概述

### 故障排查方法论

**系统化方法**：

```
1. 识别问题
   ├─ 症状是什么？
   ├─ 何时发生？
   └─ 如何重现？

2. 隔离原因
   ├─ 最可能的原因是什么？
   ├─ 最近有什么变化？
   └─ 是否有相关错误？

3. 应用解决方案
   ├─ 尝试最可能的解决方案
   ├─ 验证是否有效
   └─ 记录结果

4. 预防措施
   ├─ 如何避免再次发生？
   ├─ 需要什么监控？
   └─ 更新文档
```

### 快速诊断工具

**PowerShell 命令**：

```powershell
# 系统信息
Get-ComputerInfo
$PSVersionTable

# 环境变量
Get-ChildItem Env:

# 路径
$env:PATH -split ';'
Get-Command npm

# 进程
Get-Process | Where-Object {$_.ProcessName -like "*node*"}

# 服务
Get-Service | Where-Object {$_.Status -eq "Running"}
```

---

## 常见错误类型

### 类型 1: 命令找不到

**症状**：

```
npm : The term 'npm' is not recognized as the name of a cmdlet, function, script file...
```

**原因**：

```
1. 未安装
2. 未加入 PATH
3. 路径配置错误
4. 需要重启终端
```

**解决方案**：

```powershell
# 诊断 1: 检查是否安装
Get-Command npm

# 如果未找到，检查安装位置
Get-ChildItem "C:/Program Files/nodejs" -Filter npm.exe

# 诊断 2: 检查 PATH
$env:PATH -split ';' | Select-String node

# 解决方案 1: 重新安装
winget install OpenJS.NodeJS

# 解决方案 2: 添加到 PATH
$env:PATH += ";C:\Program Files\nodejs"
# 永久添加：
[System.Environment]::SetEnvironmentVariable('Path', $env:PATH, 'User')

# 解决方案 3: 重启终端
# 或使用:
$env:PATH = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path', 'User')
```

**Claude Code 辅助诊断**：

```markdown
👤 你：命令 'claude' 找不到，帮我诊断

🤖 Claude：[诊断流程]
1. ✅ 检查安装
   - Claude Code 是否已安装？
   - 安装在哪里？

2. ✅ 检查 PATH
   - $env:PATH 包含 Claude Code 路径吗？
   - 路径是否正确？

3. ✅ 验证
   - 尝试完整路径运行
   - C:\Users\Username\AppData\Local\Programs\Claude Code\claude.exe

4. ✅ 修复
   - 重新安装或添加到 PATH
```

### 类型 2: 权限错误

**症状**：

```
Access to the path 'C:\Program Files\...' is denied.
```

**原因**：

```
1. 需要管理员权限
2. 文件被占用
3. NTFS 权限限制
```

**解决方案**：

```powershell
# 解决方案 1: 以管理员身份运行
# 右键 PowerShell → "以管理员身份运行"

# 解决方案 2: 检查文件权限
Get-Acl "C:\Program Files\MyApp" | Format-List

# 解决方案 3: 修改权限（谨慎）
$acl = Get-Acl "C:\Program Files\MyApp"
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
    $env:USERNAME,
    "FullControl",
    "Allow"
)
$acl.SetAccessRule($accessRule)
Set-Acl "C:\Program Files\MyApp" $acl

# 解决方案 4: 检查文件占用
Get-Process | Where-Object {
    $_.Modules.FileName -like "*MyApp*"
}

# 或使用 Handle 工具
handle.exe "C:\Program Files\MyApp\file.txt"
```

### 类型 3: 路径错误

**症状**：

```
The system cannot find the path specified.
```

**常见原因**：

```
1. 路径包含空格未加引号
2. 使用了单反斜杠
3. 路径不存在
4. 相对路径错误
5. 大小写问题（通常不区分，但某些工具区分）
```

**解决方案**：

```powershell
# ✅ 正确：使用引号
cd "C:\Program Files\MyApp"

# ✅ 正确：使用正斜杠
cd "C:/Program Files/MyApp"

# ✅ 正确：使用 Tab 补全
cd C:\Prog[Tab]

# ✅ 验证路径存在
Test-Path "C:\Program Files\MyApp"

# ✅ 解析相对路径
Resolve-Path ".\relative\path"

# ✅ 检查符号链接
Get-ChildItem | Where-Object {$_.LinkType -eq "SymbolicLink"}
```

### 类型 4: 网络问题

**症状**：

```
Failed to connect to api.anthropic.com
Connection timeout
```

**诊断**：

```powershell
# 测试连接
Test-Connection api.anthropic.com -Count 4

# 测试 DNS 解析
Resolve-DnsName api.anthropic.com

# 测试端口
Test-NetConnection api.anthropic.com -Port 443

# 检查代理
netsh winhttp show proxy

# 测试 curl
curl -I https://api.anthropic.com
```

**解决方案**：

```powershell
# 方案 1: 清除 DNS 缓存
Clear-DnsClientCache

# 方案 2: 重置网络
netsh winsock reset
netsh int ip reset all
Restart-Computer

# 方案 3: 检查防火墙
Get-NetFirewallRule | Where-Object {$_.Enabled -eq 'True'}

# 方案 4: 配置代理
$env:HTTP_PROXY = "http://proxy.example.com:8080"
$env:HTTPS_PROXY = "http://proxy.example.com:8080"
```

### 类型 5: 编码问题

**症状**：

```
乱码显示：ćłą
字符显示错误
```

**解决方案**：

```powershell
# 检查当前编码
[Console]::OutputEncoding.EncodingName
chcp

# 设置为 UTF-8（推荐）
chcp 65001
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$env:LANG = 'zh_CN.UTF-8'

# PowerShell Core 默认 UTF-8
pwsh  # 使用 PowerShell Core
```

### 类型 6: 模块加载失败

**症状**：

```
Import-Module: The specified module 'xxx' was not loaded
```

**诊断**：

```powershell
# 检查模块路径
$env:PSModulePath -split ';'

# 列出已安装模块
Get-Module -ListAvailable

# 检查特定模块
Get-Module -ListAvailable | Where-Object {$_.Name -like "*Azure*"}
```

**解决方案**：

```powershell
# 方案 1: 安装模块
Install-Module -Name ModuleName -Force

# 方案 2: 更新模块
Update-Module -Name ModuleName

# 方案 3: 指定模块路径
Import-Module "C:\Modules\MyModule"

# 方案 4: 信任 PSGallery
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
```

---

## 诊断流程

### 标准诊断流程

```
┌─────────────────────────────────────┐
│  1. 明确问题                         │
│  - 具体错误信息                       │
│  - 重现步骤                           │
│  - 最近变化                           │
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│  2. 收集信息                         │
│  - 完整错误信息                       │
│  - 系统信息                           │
│  - 环境变量                           │
│  - 日志文件                           │
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│  3. 分析可能原因                     │
│  - 列出所有可能                       │
│  - 按概率排序                         │
│  - 逐一排查                           │
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│  4. 尝试解决方案                     │
│  - 从最可能开始                       │
│  - 一次尝试一个                       │
│  - 验证结果                           │
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│  5. 预防和记录                       │
│  - 记录问题和解决方案                 │
│  - 更新文档                           │
│  - 建立监控                           │
└─────────────────────────────────────┘
```

### Claude Code 辅助诊断

**完整诊断流程**：

```markdown
👤 你：Claude Code 启动失败，帮我诊断

错误信息：
"C:\Program Files\Claude Code\claude.exe" 无法运行

🤖 Claude：[系统化诊断]

**步骤 1: 验证文件存在**
```powershell
Test-Path "C:\Program Files\Claude Code\claude.exe"
```

如果返回 False：
→ 检查安装位置
→ 重新安装

**步骤 2: 检查依赖**
```powershell
# 检查 Node.js
Get-Command node

# 检查 VC++ Redistributable
Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -like "*Visual C++*"}
```

如果缺少依赖：
→ 安装 Node.js
→ 安装 VC++ Redistributable

**步骤 3: 检查权限**
```powershell
# 以管理员身份运行
# 右键 → 以管理员身份运行
```

**步骤 4: 查看日志**
```powershell
# 查看应用日志
Get-EventLog -LogName Application -Newest 50 | Where-Object {$_.Source -like "*Claude*"}
```

**步骤 5: 重装**
```powershell
# 完全卸载
winget uninstall ClaudeCode

# 清理残留
Remove-Item "$env:APPDATA\Claude Code" -Recurse -Force

# 重新安装
winget install Anthropic.ClaudeCode
```
```

---

## 命令问题

### 问题 1: npm 命令找不到

**完整诊断和修复**：

```powershell
# === 诊断 ===

# 1. 检查 Node.js 安装
Get-Command node
Get-Command npm

# 2. 检查安装位置
Get-ChildItem "C:\Program Files\nodejs"
Get-ChildItem "C:\Program Files (x86)\nodejs"

# 3. 检查 PATH
$env:PATH -split ';' | Select-String node

# 4. 测试完整路径
& "C:\Program Files\nodejs\npm.exe" --version

# === 修复 ===

# 方案 1: 重装 Node.js（推荐）
winget install OpenJS.NodeJS

# 方案 2: 添加到 PATH
$nodePath = "C:\Program Files\nodejs"
$env:PATH += ";$nodePath"
# 永久添加：
[System.Environment]::SetEnvironmentVariable('Path', $env:PATH, 'User')

# 方案 3: 使用 nvm-windows（管理多版本）
winget install CoreyButler.NVMforWindows
nvm install 18
nvm use 18

# === 验证 ===
# 重启终端后
node --version
npm --version
```

### 问题 2: Git 命令找不到

**诊断和修复**：

```powershell
# === 诊断 ===
Get-Command git
Get-Command git-config

# === 修复 ===

# 方案 1: 安装 Git
winget install Git.Git

# 方案 2: 添加到 PATH
$gitPath = "C:\Program Files\Git\cmd"
$env:PATH += ";$gitPath"
[System.Environment]::SetEnvironmentVariable('Path', $env:PATH, 'User')

# === 验证 ===
git --version
git config --list
```

### 问题 3: Python 命令找不到

**多版本问题**：

```powershell
# === 诊断 ===
Get-Command python
Get-Command python3
Get-Command py

# Python Launcher (py) 是 Windows 推荐方式
py --list

# === 修复 ===

# 方案 1: 使用 Python Launcher
py -3.11  # 指定版本
py -3      # 最新 Python 3

# 方案 2: 安装 Python
winget search python
winget install Python.Python.3.11

# 方案 3: 添加别名
# 在 $PROFILE 中添加
function python { py -3 $args }
function pip { py -3 -m pip $args }

# === 验证 ===
py --version
py -m pip --version
```

---

## 权限问题

### 问题 1: 需要管理员权限

**症状**：

```
Access denied
You do not have sufficient permissions
```

**解决方案**：

```powershell
# 方案 1: 以管理员身份运行
# 右键 PowerShell → "以管理员身份运行"

# 验证管理员权限
([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# 方案 2: 使用 UAC 提升权限
Start-Process powershell -Verb RunAs

# 方案 3: 修改文件权限
$acl = Get-Acl "C:\Path\ToFile"
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
    $env:USERNAME,
    "FullControl",
    "Allow"
)
$acl.SetAccessRule($accessRule)
Set-Acl "C:\Path\ToFile" $acl

# 方案 4: 使用 runas
runas /user:Administrator "cmd.exe /c command"
```

### 问题 2: 文件被占用

**症状**：

```
The process cannot access the file because it is being used by another process
```

**诊断和解决**：

```powershell
# === 诊断 ===

# 查找占用文件的进程
$filePath = "C:\Path\To\File.txt"
Get-Process | Where-Object {
    try {
        $_.Modules.FileName -like "*$filePath*"
    } catch {}
}

# 或使用 handle 工具（需要下载）
# https://docs.microsoft.com/sysinternals/downloads/handle
handle.exe $filePath

# === 解决方案 ===

# 方案 1: 关闭占用进程
Stop-Process -Name "Notepad" -Force

# 方案 2: 解锁工具（需要下载）
# https://docs.microsoft.com/sysinternals/downloads/handle
handle.exe -a $filePath

# 方案 3: 重启资源
Stop-Service -Name "ServiceName" -Force
Start-Service -Name "ServiceName"

# 方案 4: 删除时重启计算机
Remove-Item $filePath -Force -Recurse
```

---

## 路径问题

### 问题 1: 路径包含空格

**解决方案**：

```powershell
# ❌ 错误
cd C:\Program Files\MyApp

# ✅ 正确：使用引号
cd "C:\Program Files\MyApp"

# ✅ 正确：使用 Tab 补全
cd C:\Prog[Tab]  # 自动补全并加引号

# ✅ 正确：使用短文件名
cd C:\PROGRA~1\MYAPP~1

# 编程中：
# ❌ 错误
exec('cd C:\Program Files\MyApp');

# ✅ 正确
exec('cd "C:\Program Files\MyApp"');

# ✅ 更好：使用正斜杠
exec('cd "C:/Program Files/MyApp"');
```

### 问题 2: 路径太长

**解决方案**：

```powershell
# === 启用长路径支持（需要管理员） ===

# 通过注册表
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v LongPathsEnabled /t REG_DWORD /d 1 /f

# 或通过组策略
# 计算机配置 → 管理模板 → 系统 → 文件系统
# 启用"启用 Win32 长路径"

# === 使用替代方案 ===

# 方案 1: 映射驱动器
subst X: "C:\Very\Long\Path\To\Project"
cd X:\

# 方案 2: 使用 symbolic link
New-Item -ItemType SymbolicLink -Path "C:\ShortLink" -Target "C:\Very\Long\Path"

# 方案 3: 使用相对路径
cd "C:\Very\Long\Path\To\Project"
.\script.ps1  # 而不是 C:\Very\Long\Path\To\Project\script.ps1
```

### 问题 3: 相对路径错误

**解决方案**：

```powershell
# === 检查当前工作目录 ===
Get-Location
$PWD

# === 使用绝对路径 ===
$scriptPath = "D:\Projects\myscript.ps1"
& $scriptPath

# === 使用 $PSScriptRoot ===
# 在脚本中
$scriptDir = $PSScriptRoot
$configPath = Join-Path $scriptDir "config.json"

# === 使用 Resolve-Path ===
$relativePath = ".\config\settings.json"
$absolutePath = Resolve-Path $relativePath

# === 使用环境变量 ===
$projectRoot = $env:PROJECT_ROOT
$configPath = Join-Path $projectRoot "config.json"
```

---

## 性能问题

### 问题 1: 终端响应慢

**诊断**：

```powershell
# 检查 PowerShell 版本
$PSVersionTable

# PowerShell 7 更快
pwsh  # 使用 PowerShell Core
```

**解决方案**：

```powershell
# 方案 1: 使用 PowerShell 7（Core）
winget install Microsoft.PowerShell

# 方案 2: 优化 Profile
# 检查 $PROFILE
# 移除耗时操作

# 方案 3: 使用 Windows Terminal
winget install Microsoft.WindowsTerminal

# 方案 4: 减少输出
# 使用 | Select-Object First 10
Get-Process | Select-Object -First 10
```

### 问题 2: 磁盘 I/O 慢

**诊断**：

```powershell
# 检查磁盘活动
Get-Counter '\\PhysicalDisk(_Total)\% Disk Time'

# 检查磁盘空间
Get-PSDrive C

# 优化建议：
# - 使用 SSD
# - 清理临时文件
# - 禁用索引（某些场景）
# - 定期碎片整理（HDD）
```

---

## 网络问题

### 问题 1: 代理配置

**症状**：

```
Failed to connect to proxy
```

**解决方案**：

```powershell
# === 检查代理设置 ===

# 系统代理
netsh winhttp show proxy

# 环境变量
Get-ChildItem Env: | Where-Object {$_.Name -like "*PROXY*"}

# === 设置代理 ===

# 临时设置
$env:HTTP_PROXY = "http://proxy.example.com:8080"
$env:HTTPS_PROXY = "http://proxy.example.com:8080"

# 永久设置
[System.Environment]::SetEnvironmentVariable('HTTP_PROXY', 'http://proxy.example.com:8080', 'User')
[System.Environment]::SetEnvironmentVariable('HTTPS_PROXY', 'http://proxy.example.com:8080', 'User')

# Git 代理
git config --global http.proxy http://proxy.example.com:8080
git config --global https.proxy http://proxy.example.com:8080

# npm 代理
npm config set proxy http://proxy.example.com:8080
npm config set https-proxy http://proxy.example.com:8080

# === 清除代理 ===

# 清除环境变量
$env:HTTP_PROXY = $null
$env:HTTPS_PROXY = $null

# 清除 Git 代理
git config --global --unset http.proxy
git config --global --unset https.proxy

# 清除 npm 代理
npm config delete proxy
npm config delete https-proxy
```

### 问题 2: DNS 解析问题

**解决方案**：

```powershell
# === 清除 DNS 缓存 ===
Clear-DnsClientCache

# === 更换 DNS 服务器 ===
# 设置为 Google DNS
Set-DnsClientServerAddress -InterfaceAlias "Wi-Fi" -ServerAddresses 8.8.8.8, 8.8.4.4

# 或设置为 Cloudflare DNS
Set-DnsClientServerAddress -InterfaceAlias "Wi-Fi" -ServerAddresses 1.1.1.1, 1.0.0.1

# === 刷新 DNS ===
ipconfig /flushdns
ipconfig /registerdns
```

---

## 环境问题

### 问题 1: Node.js 版本冲突

**解决方案**：

```powershell
# === 使用 nvm-windows ===

# 安装 nvm-windows
winget install CoreyButler.NVMforWindows

# 列出已安装版本
nvm list

# 安装特定版本
nvm install 18
nvm install 20

# 切换版本
nvm use 18

# 设置默认版本
nvm alias default 18

# === 验证 ===
node --version
npm --version
```

### 问题 2: Python 版本冲突

**解决方案**：

```powershell
# === 使用 Python Launcher ===

# 查看已安装版本
py --list

# 使用特定版本
py -3.11
py -3.10

# === 设置默认版本 ===
# 在 Python Launcher 中设置

# === 使用虚拟环境 ===
python -m venv .venv
.\.venv\Scripts\Activate.ps1
```

---

## 已知问题（官方已修复）

以下问题在 Claude Code 官方版本中已修复。如果您遇到这些问题，请更新到最新版本。

### 问题 1: Bash 命令执行失败（v2.1.27 修复）✅

**症状**：
- PowerShell 中执行 bash 命令失败
- 误报错误信息
- 命令无法正常执行

**影响版本**：
- v2.1.26 及更早版本

**原因**：
- 用户的 `.bashrc` 文件导致命令执行失败
- Windows 和 bash 环境之间的兼容性问题

**解决方案**：

1. **更新 Claude Code**（推荐）：
   ```powershell
   # 检查当前版本
   claude --version

   # 更新到最新版本（如果使用安装脚本）
   # Windows 会自动更新
   ```

2. **临时解决方案**（如果无法更新）：
   ```powershell
   # 临时重命名 .bashrc 文件
   mv ~/.bashrc ~/.bashrc.bak

   # 测试命令是否正常
   # 如果正常，说明是 .bashrc 配置问题
   ```

3. **验证修复**：
   ```powershell
   # 在 Claude Code 中测试 bash 命令
   echo "test" | bash
   ```

**官方修复版本**：v2.1.27 (2026-01-30)
**验证状态**：✅ 官方已修复并验证

---

### 问题 2: 控制台窗口闪烁（v2.1.27 修复）✅

**症状**：
- 生成子进程时控制台窗口闪烁
- 频繁的窗口弹出和关闭
- 影响用户体验

**影响版本**：
- v2.1.26 及更早版本

**原因**：
- Windows 子进程创建机制问题
- 控制台窗口继承属性设置不当

**解决方案**：

1. **更新 Claude Code**（推荐）：
   ```powershell
   # Windows 安装版本会自动更新
   # 手动检查更新
   winget upgrade Anthropic.ClaudeCode
   ```

2. **验证修复**：
   ```powershell
   # 运行会生成子进程的命令
   claude
   # 观察：应该不再有窗口闪烁
   ```

**官方修复版本**：v2.1.27 (2026-01-30)
**验证状态**：✅ 官方已修复并验证

---

### 其他已知问题和解决方案

如果您遇到其他问题，请：

1. **检查版本**：
   ```powershell
   claude --version
   ```

2. **查看最新更新**：
   - [官方更新日志](https://github.com/anthropics/claude-code/releases)
   - 项目 CHANGELOG.md 中有官方版本更新记录

3. **报告问题**：
   - [GitHub Issues](https://github.com/anthropics/claude-code/issues)
   - [官方支持](https://support.claude.com/)

---

## 实战案例

### 案例1: Claude Code 无法启动

**症状**：

```
双击 Claude Code 图标无反应
```

**诊断和修复**：

```markdown
**步骤 1: 检查进程**
```powershell
Get-Process | Where-Object {$_.ProcessName -like "*claude*"}
```
如果进程在运行但无界面：
→ 可能是 GUI 问题

**步骤 2: 尝试命令行启动**
```powershell
& "C:\Users\Username\AppData\Local\Programs\Claude Code\claude.exe"
```
查看错误信息

**步骤 3: 检查依赖**
```powershell
# 检查 VC++ Redistributable
Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -like "*Visual C++*"}
```
如果缺失：
→ 下载安装 VC++ Redistributable

**步骤 4: 检查日志**
```powershell
# 查看应用日志
$logs = "$env:LOCALAPPDATA\Claude Code\logs"
Get-ChildItem $logs -Filter "*.log" | Sort-Object LastWriteTime -Descending | Select-Object -First 1 | Get-Content
```

**步骤 5: 重新安装**
```powershell
winget uninstall ClaudeCode
Remove-Item "$env:APPDATA\Claude Code" -Recurse -Force
winget install Anthropic.ClaudeCode
```
```

### 案例2: npm install 持续失败

**症状**：

```
npm ERR! network request failed
```

**诊断和修复**：

```markdown
**诊断 1: 检查网络**
```powershell
Test-Connection registry.npmjs.org
Test-NetConnection registry.npmjs.org -Port 443
```

**诊断 2: 检查代理**
```powershell
npm config get proxy
npm config get https-proxy
```

**解决方案 1: 清除缓存**
```powershell
npm cache clean --force
```

**解决方案 2: 切换镜像**
```powershell
# 使用淘宝镜像
npm config set registry https://registry.npmmirror.com

# 或使用官方镜像
npm config set registry https://registry.npmjs.org
```

**解决方案 3: 配置代理**
```powershell
npm config set proxy http://proxy.example.com:8080
npm config set https-proxy http://proxy.example.com:8080
```

**解决方案 4: 使用 yarn**
```powershell
npm install -g yarn
yarn install
```
```

### 案例3: Git 操作失败

**症状**：

```
fatal: unable to access 'https://github.com/...': Failed to connect to github.com
```

**诊断和修复**：

```markdown
**诊断 1: 测试连接**
```powershell
Test-Connection github.com
Test-NetConnection github.com -Port 443
```

**诊断 2: 检查 Git 配置**
```powershell
git config --list
git config --global http.proxy
```

**解决方案 1: 配置代理**
```powershell
git config --global http.proxy http://proxy.example.com:8080
git config --global https.proxy http://proxy.example.com:8080
```

**解决方案 2: 取消代理**
```powershell
git config --global --unset http.proxy
git config --global --unset https.proxy
```

**解决方案 3: 使用 SSH**
```powershell
git remote set-url origin git@github.com:user/repo.git
```

**解决方案 4: 增加超时**
```powershell
git config --global http.lowSpeedLimit 0
git config --global http.postBuffer 1048576000
```
```

---

## 快速参考

### 常用诊断命令

```powershell
# 系统信息
Get-ComputerInfo
$PSVersionTable

# 环境变量
Get-ChildItem Env:
$env:PATH -split ';'

# 进程
Get-Process | Sort-Object CPU -Descending | Select-Object -First 10

# 服务
Get-Service | Where-Object {$_.Status -eq "Stopped"}

# 网络
Test-Connection google.com
Test-NetConnection api.anthropic.com -Port 443

# 磁盘
Get-PSDrive
Get-ChildItem C:\ -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum

# 路径
Test-Path "C:\Path"
Resolve-Path ".\relative"
```

### 快速修复清单

```
命令找不到
├─ 检查安装: Get-Command
├─ 检查 PATH: $env:PATH
├─ 重装工具: winget install
└─ 添加 PATH: [System.Environment]::SetEnvironmentVariable

权限错误
├─ 以管理员身份运行
├─ 检查 UAC: 控制面板 → 用户账户控制
├─ 修改权限: Get-Acl / Set-Acl
└─ 关闭占用进程: Stop-Process

路径错误
├─ 使用引号: "path with spaces"
├─ 使用正斜杠: C:/Path/File
├─ 使用 Tab 补全: [Tab]
└─ 检查存在: Test-Path

网络问题
├─ 测试连接: Test-Connection
├─ 清除 DNS: Clear-DnsClientCache
├─ 检查代理: netsh winhttp show proxy
└─ 配置代理: $env:HTTP_PROXY
```

---

## 总结

### 故障排查原则

```
1. 系统化方法
   ├─ 明确问题
   ├─ 收集信息
   ├─ 分析原因
   ├─ 尝试解决
   └─ 预防记录

2. 从简单开始
   ├─ 最常见的问题
   ├─ 最简单的解决方案
   └─ 逐步增加复杂度

3. 一次只改一个
   ├─ 隔离变量
   ├─ 验证效果
   └─ 继续或回退

4. 记录和分享
   ├─ 问题记录
   ├─ 解决方案
   └─ 更新文档
```

### 获取帮助

```
1. 本指南
   ├─ 相关章节
   ├─ 快速参考
   └─ 实战案例

2. Claude Code
   └─ 帮助诊断和解决

3. 官方文档
   ├─ PowerShell 文档
   ├─ Windows 文档
   └─ 工具文档

4. 社区
   ├─ Stack Overflow
   ├─ GitHub Issues
   └─ 技术论坛
```

---

## 相关资源

### 项目文档
- [Windows 入门](./01-getting-started.md) - 基础配置
- [路径处理](./02-path-handling.md) - 路径问题
- [性能优化](./03-performance.md) - 性能问题

### 核心文档
- [快速参考](../reference/troubleshooting.md) - 通用问题

### 外部资源
- [PowerShell 文档](https://docs.microsoft.com/en-us/powershell/)
- [Windows 故障排查](https://support.microsoft.com/windows)

---

**最后更新**: 2026-02-04
**难度**: ⭐⭐⭐
**阅读时间**: 40分钟
**重要性**: ⭐⭐⭐⭐⭐ (必备！)
