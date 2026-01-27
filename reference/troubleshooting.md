# Claude Code 问题诊断和解决

> **快速定位和解决问题的完整指南**

**使用场景**:
- 遇到错误时快速诊断
- 按流程图排查问题
- 找到对应的解决方案
- 获取额外的帮助资源

---

## 📋 目录

- [快速诊断流程图](#快速诊断流程图)
- [安装问题](#安装问题)
- [启动和配置问题](#启动和配置问题)
- [文件和路径问题](#文件和路径问题)
- [命令执行问题](#命令执行问题)
- [性能问题](#性能问题)
- [网络和API问题](#网络和api问题)
- [会话管理问题](#会话管理问题)
- [平台特定问题](#平台特定问题)
- [错误代码索引](#错误代码索引)
- [获取帮助](#获取帮助)

---

## 快速诊断流程图

### 主诊断流程

```
遇到问题
    ↓
是什么类型的症状？
    ↓
┌─────────────────────────────────────────┐
│ 无法安装/启动     → 安装问题             │
│ 文件/命令不工作   → 使用问题             │
│ 速度慢/卡顿       → 性能问题             │
│ 网络/API错误      → 网络问题             │
│ 其他错误信息      → 错误代码索引         │
└─────────────────────────────────────────┘
    ↓
按照对应章节的步骤排查
    ↓
问题解决？
    ├─ 是 → 完成 ✅
    └─ 否 → 获取帮助（联系支持/查看社区）
```

### Windows 诊断流程

```
Windows 用户遇到问题
    ↓
┌─────────────────────────────────────────┐
│ 路径相关 → 检查是否使用正斜杠 /        │
│ 权限相关 → 以管理员身份运行            │
│ 性能相关 → 检查是否使用 SSD            │
│ 编码相关 → 设置 UTF-8 编码             │
│ PowerShell → 使用 PowerShell 7         │
└─────────────────────────────────────────┘
    ↓
详见 [平台特定问题](#平台特定问题)
```

---

## 安装问题

### 💡 推荐安装方法（2025+）

**官方推荐**：使用原生安装器（**无需 Node.js**）

#### Windows 原生安装（推荐）

**优势**：
- ✅ 不需要 Node.js
- ✅ 开箱即用
- ✅ 更好的 Windows 集成
- ✅ 自动更新支持

**安装步骤**：
```powershell
# PowerShell（以管理员身份运行）
irm https://claude.ai/install.ps1 | iex

# 验证安装
claude --version
```

#### macOS/Linux 原生安装

**优势**：
- ✅ 不需要 Node.js
- ✅ 简化安装流程
- ✅ 系统级集成

**安装步骤**：
```bash
# 使用安装脚本
curl -fsSL https://claude.ai/install.sh | bash

# 验证安装
claude --version
```

#### Homebrew 安装（macOS）

```bash
# 安装
brew install --cask claude-code

# 验证
claude --version
```

**何时使用传统 npm 安装**：
- ❌ 原生安装失败时
- ❌ 需要特定版本时
- ❌ 开发和测试 Claude Code 本身

---

### 问题 1.1：无法安装 Claude Code

#### Windows 用户

**症状**：
- `winget install` 失败
- 提示"包未找到"
- 下载后安装失败

**诊断步骤**：

```powershell
# 1. 检查 Windows 版本
systeminfo | findstr /C:"OS"

# 要求：Windows 10 21H2+ 或 Windows 11

# 2. 更新 winget
winget upgrade --id Microsoft.AppInstaller

# 3. 检查网络连接
Test-Connection github.com

# 4. 尝试手动安装
# 访问：https://claude.ai/code
# 下载 .exe 安装包
```

**解决方案**：

| 方案 | 适用场景 | 步骤 |
|------|---------|------|
| 使用 winget | Windows 10 21H2+ / Windows 11 | `winget install Anthropic.ClaudeCode` |
| 使用 scoop | 已安装 Scoop | `scoop bucket add extras && scoop install claude-code` |
| 手动安装 | 以上都失败 | 下载 .exe 运行安装程序 |
| 使用 WSL | Linux 环境偏好 | 在 WSL 中安装 Linux 版本 |

**验证安装**：
```powershell
claude --version
# 应显示版本号
```

#### macOS 用户

**症状**：
- `brew install` 失败
- 提示"cask not found"

**诊断步骤**：

```bash
# 1. 更新 Homebrew
brew update

# 2. 搜索 cask
brew search claude

# 3. 尝试安装
brew install --cask claude-code
```

**解决方案**：

| 方案 | 适用场景 | 步骤 |
|------|---------|------|
| Homebrew Cask | 标准 macOS 安装 | `brew install --cask claude-code` |
| 手动安装 | Homebrew 失败 | 下载 .dmg 安装 |
| npm 全局安装 | 开发者环境 | `npm install -g @anthropic-ai/claude-code` |

#### Linux 用户

**症状**：
- 包管理器找不到包
- npm 安装失败

**诊断步骤**：

```bash
# 1. 检查 Node.js 版本
node --version  # 要求 Node.js 16+

# 2. 检查 npm 版本
npm --version   # 要求 npm 7+

# 3. 尝试 npm 安装
npm install -g @anthropic-ai/claude-code
```

**解决方案**：

| 发行版 | 包管理器 | 命令 |
|--------|---------|------|
| Ubuntu/Debian | apt | `sudo apt install claude-code` |
| Fedora/RHEL | dnf | `sudo dnf install claude-code` |
| Arch Linux | yay | `yay -S claude-code` |
| 通用 | npm | `npm install -g @anthropic-ai/claude-code` |

---

### 问题 1.2：安装后无法启动

**症状**：
- 输入 `claude` 提示"命令未找到"
- 提示"不是内部或外部命令"

#### Windows 用户

**诊断步骤**：

```powershell
# 1. 检查 PATH 环境变量
$env:Path -split ';'

# 2. 查找 Claude Code 安装位置
where.exe claude

# 3. 如果找到，显示完整路径
# 如果未找到，继续排查
```

**解决方案**：

**方案 1：重启终端**
```powershell
# 关闭并重新打开终端
# 环境变量会重新加载
```

**方案 2：手动添加到 PATH**
```powershell
# 临时添加（当前会话）
$env:Path += ";C:\Users\<YourName>\AppData\Local\Programs\Claude Code"

# 永久添加
[System.Environment]::SetEnvironmentVariable(
    'Path',
    [System.Environment]::GetEnvironmentVariable('Path', 'User') + ';C:\Users\<YourName>\AppData\Local\Programs\Claude Code',
    'User'
)

# 重启终端
```

**方案 3：使用完整路径**
```powershell
& "C:\Users\<YourName>\AppData\Local\Programs\Claude Code\claude.exe"
```

#### macOS/Linux 用户

**诊断步骤**：

```bash
# 1. 检查 PATH
echo $PATH

# 2. 查找 Claude Code
which claude

# 3. 如果未找到
# 检查 npm 全局路径
npm config get prefix
```

**解决方案**：

**方案 1：重启终端**
```bash
# 关闭并重新打开终端
```

**方案 2：添加到 PATH**
```bash
# 编辑 shell 配置文件
nano ~/.zshrc      # macOS 默认
# 或
nano ~/.bashrc     # Linux 默认

# 添加以下行
export PATH="$PATH:$(npm config get prefix)/bin"

# 保存并重新加载
source ~/.zshrc
```

---

## 启动和配置问题

### 问题 2.1：Claude Code 启动缓慢

**症状**：
- 启动时间 > 10 秒
- 卡在"正在连接"
- 首次响应慢

**诊断步骤**：

```powershell
# 1. 检查网络连接
Test-Connection api.anthropic.com -Count 4

# 2. 检查延迟
ping api.anthropic.com

# 3. 检查代理设置
netsh winhttp show proxy

# 4. 检查系统资源
taskmgr  # 打开任务管理器
```

**解决方案**：

| 方案 | 适用场景 | 步骤 |
|------|---------|------|
| 优化 DNS | 网络慢 | 将 DNS 改为 1.1.1.1 或 8.8.8.8 |
| 配置代理 | 企业网络/需要代理 | 设置 HTTP_PROXY 环境变量 |
| 关闭后台应用 | 系统资源不足 | 关闭不必要的应用 |
| 清理缓存 | 首次启动慢 | 删除 `%LOCALAPPDATA%\Claude Code\cache` |

### 问题 2.2：API 密钥配置问题

**症状**：
- 提示"API key invalid"
- 提示"Authentication failed"
- 无法登录

**诊断步骤**：

```bash
# 1. 查看当前配置
claude config list

# 2. 检查 API 密钥格式
# 应该以 sk-ant- 开头

# 3. 验证 API 密钥
# 访问：https://console.anthropic.com
```

**解决方案**：

**方案 1：重新设置 API 密钥**
```bash
claude config set api_key YOUR_NEW_API_KEY
```

**方案 2：从环境变量读取**
```powershell
# 设置环境变量
$env:ANTHROPIC_API_KEY = "your-api-key"

# 永久设置
[System.Environment]::SetEnvironmentVariable(
    'ANTHROPIC_API_KEY',
    'your-api-key',
    'User'
)
```

**方案 3：创建 .env 文件**
```bash
# 在项目根目录创建 .env
ANTHROPIC_API_KEY=your-api-key
```

---

## 文件和路径问题

### 问题 3.1：无法引用文件 (@)

**症状**：
- `@文件名` 不工作
- 显示"文件未找到"
- 路径被误解析

#### Windows 用户 - 路径格式问题

**常见错误**：

```powershell
# ❌ 错误：使用反斜杠
@src\config.json
@C:\Projects\MyApp\src

# ✅ 正确：使用正斜杠
@src/config.json
@C:/Projects/MyApp/src

# ✅ 或使用双反斜杠转义
@src\\config.json
@C:\\Projects\\MyApp\\src
```

**诊断步骤**：

```powershell
# 1. 检查文件是否存在
Test-Path "C:/Projects/MyApp/src/config.json"

# 2. 检查权限
Get-Acl "C:/Projects/MyApp/src/config.json" | Format-List

# 3. 测试路径格式
@C:/Projects/MyApp/src/config.json
```

**解决方案**：

| 问题 | 解决方案 | 示例 |
|------|---------|------|
| 反斜杠问题 | 使用正斜杠 `/` | `@src/file.js` |
| 空格路径 | 使用引号 | `@"C:/My Projects/file.js"` |
| 相对路径 | 使用相对于工作目录的路径 | `@src/config.json` |
| 绝对路径 | 使用完整路径 | `@C:/Projects/MyApp/src/file.js` |

**详细参考**：[Windows 路径处理](../windows/02-path-handling.md)

### 问题 3.2：文件编码问题

**症状**：
- 中文显示为乱码
- 特殊字符显示异常
- 报错"invalid encoding"

#### Windows 用户

**诊断步骤**：

```powershell
# 1. 检查当前编码
chcp  # 应显示 65001 (UTF-8)

# 2. 检查文件编码
# 使用 VS Code 或 Notepad++ 查看

# 3. 测试 UTF-8 输出
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
echo "测试中文"
```

**解决方案**：

**方案 1：设置 PowerShell 编码**
```powershell
# 临时设置
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
chcp 65001

# 永久设置（添加到 PowerShell Profile）
notepad.exe $PROFILE

# 添加以下行
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
chcp 65001
```

**方案 2：Windows Terminal 设置**
```
1. 打开 Windows Terminal
2. 设置 → 默认值
3. 配置文件 → 高级
4. 编码 → UTF-8
```

**方案 3：保存文件为 UTF-8**
```
使用 VS Code：
1. 文件 → 另存为
2. 编码 → UTF-8
3. 保存
```

---

## 命令执行问题

### 问题 4.1：无法执行命令 (!)

**症状**：
- `!命令` 不工作
- 显示"命令未找到"
- 命令执行失败

**诊断步骤**：

```powershell
# 1. 测试命令是否在 PATH 中
where.exe npm
where.exe git
where.exe python

# 2. 检查 PATH 环境变量
$env:Path -split ';'

# 3. 手动测试命令
npm --version
git --version
```

**解决方案**：

| 问题 | 解决方案 | 示例 |
|------|---------|------|
| 命令未安装 | 安装对应工具 | `winget install OpenJS.NodeJS` |
| PATH 未配置 | 添加到 PATH | 见[安装问题](#问题-12安装后无法启动) |
| 使用完整路径 | 使用绝对路径 | `!"C:/Program Files/nodejs/npm.exe"` |
| PowerShell 别名 | 使用命令原名称 | 使用 `npm` 而非 `npm.exe` |

### 问题 4.2：命令执行权限不足

**症状**：
- 提示"Access denied"
- 提示"Permission denied"
- 命令执行失败

#### Windows 用户

**诊断步骤**：

```powershell
# 1. 检查当前权限
# 查看是否是管理员
([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# 2. 测试写权限
Test-Path "C:/Projects/MyApp"
```

**解决方案**：

**方案 1：以管理员身份运行**
```powershell
# 方法 1：右键以管理员身份运行
# 右键 PowerShell/Windows Terminal → 以管理员身份运行

# 方法 2：启动新的管理员会话
Start-Process powershell -Verb RunAs
```

**方案 2：修改文件夹权限**
```powershell
# 获取所有权
takeown /f "C:\Projects\MyApp" /r /d y

# 添加完全控制权限
icacls "C:\Projects\MyApp" /grant "$($env:USERNAME):(OI)(CI)F" /T
```

**方案 3：使用用户目录**
```powershell
# 在用户目录下工作
cd $env:USERPROFILE\Projects
```

---

## 性能问题

### 问题 5.1：Claude Code 响应慢

**症状**：
- 回复时间长（>10 秒）
- Token 使用过多
- 操作卡顿

**诊断步骤**：

```powershell
# 1. 检查网络延迟
Test-Connection api.anthropic.com -Count 4

# 2. 检查会话大小
# Claude Code 会显示 Token 数

# 3. 检查系统资源
taskmgr  # 查看 CPU、内存使用
```

**解决方案**：

| 方案 | 适用场景 | 步骤 |
|------|---------|------|
| 优化网络 | 网络延迟高 | 使用 VPN、优化 DNS、配置代理 |
| 清理会话 | 会话过大 | 删除旧会话、分阶段处理 |
| 精简提示词 | Token 使用多 | 减少上下文、明确需求 |
| 升级网络 | 网络不稳定 | 使用有线网络、升级带宽 |

### 问题 5.2：内存占用过高

**症状**：
- Claude Code 占用大量内存
- 系统变慢
- 内存泄漏

**诊断步骤**：

```powershell
# 1. 查看内存使用
taskmgr
# 找到 Claude Code 进程

# 2. 检查会话数量
ls $env:USERPROFILE\.claude\sessions

# 3. 检查缓存大小
ls $env:LOCALAPPDATA\Claude Code\cache -Recurse | Measure-Object -Property Length -Sum
```

**解决方案**：

**方案 1：清理缓存**
```powershell
# 删除缓存
Remove-Item -Path "$env:LOCALAPPDATA\Claude Code\cache" -Recurse -Force
```

**方案 2：删除旧会话**
```powershell
# 删除 30 天前的会话
$oldSessions = Get-ChildItem $env:USERPROFILE\.claude\sessions | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-30) }
$oldSessions | Remove-Item -Force
```

**方案 3：重启 Claude Code**
```powershell
# 完全退出并重新启动
exit
claude
```

### 问题 5.3：文件处理慢

**症状**：
- 大文件读取慢
- 多文件操作慢
- 搜索慢

**诊断步骤**：

```powershell
# 1. 检查磁盘类型
Get-PhysicalDisk

# 2. 检查文件大小
ls -Recurse | Measure-Object -Property Length -Sum

# 3. 测试读取速度
Measure-Command { Get-Content largefile.txt }
```

**解决方案**：

| 方案 | 适用场景 | 步骤 |
|------|---------|------|
| 使用 SSD | HDD 性能差 | 升级到 SSD |
| 分批处理 | 文件过多 | 分批次处理文件 |
| 优化搜索 | 搜索慢 | 使用具体路径而非通配符 |
| 禁用索引 | Windows 索引影响 | 关闭 Windows 索引服务 |

---

## 网络和API问题

### 问题 6.1：网络连接失败

**症状**：
- 提示"Connection refused"
- 提示"Timeout"
- 提示"Network error"

**诊断步骤**：

```powershell
# 1. 检查网络连接
Test-Connection api.anthropic.com

# 2. 检查 DNS 解析
Resolve-DnsName api.anthropic.com

# 3. 检查代理设置
netsh winhttp show proxy

# 4. 测试 HTTP 连接
curl https://api.anthropic.com -UseBasicParsing
```

**解决方案**：

| 问题 | 解决方案 | 步骤 |
|------|---------|------|
| DNS 解析慢 | 优化 DNS | 将 DNS 改为 1.1.1.1 |
| 需要代理 | 配置代理 | 设置 HTTP_PROXY 环境变量 |
| 防火墙阻止 | 配置防火墙 | 允许 Claude Code 通过 |
| 网络不稳定 | 重启网络 | 重启路由器/调制解调器 |

**配置代理**：
```powershell
# 设置代理
$env:HTTP_PROXY = "http://proxy.example.com:8080"
$env:HTTPS_PROXY = "http://proxy.example.com:8080"

# 永久设置
[System.Environment]::SetEnvironmentVariable('HTTP_PROXY', 'http://proxy.example.com:8080', 'User')
[System.Environment]::SetEnvironmentVariable('HTTPS_PROXY', 'http://proxy.example.com:8080', 'User')
```

### 问题 6.2：API 限制和配额

**症状**：
- 提示"Rate limit exceeded"
- 提示"Quota exceeded"
- 请求被拒绝

**诊断步骤**：

```bash
# 1. 查看当前配额使用
# 访问：https://console.anthropic.com

# 2. 查看使用统计
claude config show | findstr usage
```

**解决方案**：

| 方案 | 适用场景 | 步骤 |
|------|---------|------|
| 等待重置 | 速率限制 | 等待 1 分钟后重试 |
| 升级配额 | 配额不足 | 联系 Anthropic 销售 |
| 优化请求 | 频繁请求 | 减少请求频率、合并请求 |
| 使用缓存 | 重复请求 | 缓存常见响应 |

---

## 会话管理问题

### 问题 7.1：会话丢失

**症状**：
- 会话未保存
- 重启后上下文丢失
- 历史记录消失

**诊断步骤**：

```powershell
# 1. 检查会话目录
ls $env:USERPROFILE\.claude\sessions

# 2. 检查会话文件
Get-Content $env:USERPROFILE\.claude\sessions\*.json

# 3. 检查磁盘空间
Get-PSDrive C
```

**解决方案**：

| 问题 | 解决方案 | 步骤 |
|------|---------|------|
| 未命名会话 | 使用命名会话 | `claude --session my-project` |
| 会话未保存 | 手动保存 | 使用 `/save` 命令 |
| 会话损坏 | 删除损坏的会话 | 删除对应的 .json 文件 |
| 磁盘空间不足 | 清理磁盘 | 删除旧会话和缓存 |

### 问题 7.2：会话恢复失败

**症状**：
- `/continue` 不工作
- 会话加载失败
- 上下文不完整

**诊断步骤**：

```powershell
# 1. 查看会话列表
claude --sessions

# 2. 检查会话文件完整性
Test-Path $env:USERPROFILE\.claude\sessions\my-session.json

# 3. 尝试手动加载
claude --resume my-session
```

**解决方案**：

**方案 1：重新加载会话**
```bash
claude --resume session-name
```

**方案 2：导出并导入**
```bash
# 导出会话
claude --session backup --export session-backup.json

# 导入会话
claude --import session-backup.json
```

**方案 3：创建新会话**
```bash
# 如果会话无法恢复
claude --session new-session
```

---

## 平台特定问题

### Windows 特定问题

| 问题 | 症状 | 快速解决方案 | 详细参考 |
|------|------|-------------|---------|
| 路径格式错误 | `@` 不工作 | 使用正斜杠 `/` | [路径处理](../windows/02-path-handling.md) |
| 权限错误 | "Access denied" | 以管理员身份运行 | [故障排查](../windows/04-troubleshooting.md) |
| 性能慢 | 启动/响应慢 | 使用 SSD + PowerShell 7 | [性能优化](../windows/03-performance.md) |
| 编码问题 | 中文乱码 | 设置 UTF-8 编码 | [故障排查](../windows/04-troubleshooting.md) |
| 长路径 | >260 字符错误 | 使用 `subst` 映射 | [路径处理](../windows/02-path-handling.md) |

### macOS 特定问题

| 问题 | 症状 | 快速解决方案 |
|------|------|-------------|
| 权限错误 | "Permission denied" | 使用 `sudo` 安装 |
| 路径问题 | 文件未找到 | 使用 `$HOME` 而非 `~` |
| 性能问题 | 卡顿 | Activity Monitor 检查 |
| 快捷键冲突 | 快捷键不工作 | 系统偏好设置 → 键盘 → 修改快捷键 |

### Linux 特定问题

| 问题 | 症状 | 快速解决方案 |
|------|------|-------------|
| 权限错误 | "Permission denied" | 使用 `sudo` 安装 |
| 依赖问题 | 缺少依赖 | 使用包管理器安装依赖 |
| 路径问题 | 文件未找到 | 使用 `~` 或绝对路径 |
| 终端兼容性 | 显示异常 | 使用 GNOME Terminal 或 Kitty |

---

## 错误代码索引

### 常见系统错误代码

| 错误代码 | 含义 | 常见原因 | 快速解决方案 |
|---------|------|---------|-------------|
| `EACCES` | Permission denied | 权限不足 | 以管理员身份运行 |
| `ENOENT` | No such file or directory | 文件不存在 | 检查路径和文件名 |
| `ETIMEDOUT` | Connection timed out | 连接超时 | 检查网络和代理 |
| `ECONNREFUSED` | Connection refused | 连接被拒绝 | 检查防火墙 |
| `ENOSPC` | No space left on device | 磁盘空间不足 | 清理磁盘空间 |
| `EADDRINUSE` | Address already in use | 端口被占用 | 关闭占用端口的进程 |

### Claude Code 特定错误

| 错误信息 | 含义 | 常见原因 | 解决方案 |
|---------|------|---------|---------|
| "File not found" | 文件未找到 | 路径错误或文件不存在 | 检查路径格式（Windows 使用 `/`） |
| "Command not found" | 命令未找到 | 命令不在 PATH 中 | 添加到 PATH 或使用完整路径 |
| "Network error" | 网络错误 | 网络连接失败 | 检查网络、配置代理 |
| "API key invalid" | API 密钥无效 | 密钥错误或过期 | 重新配置 API 密钥 |
| "Rate limit exceeded" | 超过速率限制 | 请求过于频繁 | 等待 1 分钟后重试 |
| "Quota exceeded" | 超过配额 | Token 配额用尽 | 升级配额或等待重置 |
| "Session not found" | 会话未找到 | 会话文件丢失或损坏 | 检查会话目录或创建新会话 |

---

## 获取帮助

### 内置帮助命令

```bash
# 显示帮助信息
/help

# 查看文档
/docs

# 发送反馈
/feedback

# 查看版本
claude --version

# 查看配置
claude config list
```

### 诊断命令

```powershell
# Windows 诊断
# 1. 检查安装
claude --version

# 2. 检查配置
claude config list

# 3. 检查网络
Test-Connection api.anthropic.com

# 4. 检查日志
# %LOCALAPPDATA%\Claude Code\logs
```

### 社区资源

**官方资源**：
- **官方文档**: [docs.anthropic.com](https://docs.anthropic.com)
- **GitHub**: [github.com/anthropics/claude-code](https://github.com/anthropics/claude-code)
- **GitHub Issues**: [提交问题](https://github.com/anthropics/claude-code/issues)

**社区资源**：
- **Discord**: [discord.gg/claude](https://discord.gg/claude)
- **Reddit**: [r/Claude](https://reddit.com/r/Claude)
- **Stack Overflow**: [claude-code tag](https://stackoverflow.com/questions/tagged/claude-code)

### 项目文档资源

**快速参考**：
- [commands.md](./commands.md) - 命令速查表
- [shortcuts.md](./shortcuts.md) - 快捷键速查表

**核心指南**：
- [guide/01-quickstart.md](../guide/01-quickstart.md) - 快速上手
- [guide/02-core-features.md](../guide/02-core-features.md) - 核心功能详解

**Windows 专属**：
- [windows/02-path-handling.md](../windows/02-path-handling.md) - 路径处理
- [windows/03-performance.md](../windows/03-performance.md) - 性能优化
- [windows/04-troubleshooting.md](../windows/04-troubleshooting.md) - 故障排查

---

## 诊断检查清单

### 安装检查清单

- [ ] 系统版本符合要求（Windows 10 21H2+ / macOS 11+ / Linux 主流发行版）
- [ ] 网络连接正常
- [ ] 有足够的磁盘空间（> 500MB）
- [ ] 已安装所有依赖（Node.js 16+, npm 7+）
- [ ] 安装后可执行 `claude --version`

### 启动检查清单

- [ ] Claude Code 已正确安装
- [ ] 环境变量 PATH 已配置
- [ ] 没有防火墙阻止
- [ ] 有足够的系统资源（内存、CPU）
- [ ] API 密钥已配置

### 使用检查清单

- [ ] 路径格式正确（Windows 使用正斜杠 `/`）
- [ ] 文件/命令存在
- [ ] 权限足够（管理员身份运行）
- [ ] 网络连接正常
- [ ] 编码设置正确（UTF-8）

### 性能检查清单

- [ ] 使用 SSD 而非 HDD
- [ ] 内存充足（> 8GB 推荐）
- [ ] CPU 使用正常（< 80%）
- [ ] 网络延迟低（< 100ms）
- [ ] 会话大小合理（定期清理）

---

## 快速参考卡片

### Windows 用户快速参考

```
常见问题 → 快速解决

路径问题 → 使用正斜杠 /
  @src/file.json  ✅
  @src\file.json  ❌

权限问题 → 以管理员身份运行
  右键 → 以管理员身份运行

性能慢 → SSD + PowerShell 7
  升级到 SSD
  安装 PowerShell 7

乱码 → 设置 UTF-8 编码
  chcp 65001
  [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
```

### 新手用户快速参考

```
遇到问题？

1. 查看本文档相应章节
2. 尝试 Esc 撤销操作
3. 使用 Ctrl+R 搜索历史
4. 查阅 [核心功能](../guide/02-core-features.md)
5. 查看内置帮助 /help
```

### 高级用户快速参考

```
深入排查？

1. 查看日志文件
   Windows: %LOCALAPPDATA%\Claude Code\logs
   macOS/Linux: ~/.claude/logs

2. 检查系统资源
   taskmgr / htop / Activity Monitor

3. 测试网络连接
   Test-Connection / ping / curl

4. GitHub Issues 搜索
   https://github.com/anthropics/claude-code/issues
```

---

## 预防性维护

### 日常维护

```powershell
# 1. 定期清理缓存（每周）
Remove-Item -Path "$env:LOCALAPPDATA\Claude Code\cache" -Recurse -Force

# 2. 删除旧会话（每月）
$oldSessions = Get-ChildItem $env:USERPROFILE\.claude\sessions | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-30) }
$oldSessions | Remove-Item -Force

# 3. 检查更新
claude --version
# 对比官网版本
```

### 性能优化

```powershell
# 1. 使用 SSD（如果可能）
# 2. 定期清理磁盘
# 3. 关闭不必要的后台应用
# 4. 使用有线网络（而非 WiFi）
# 5. 优化 DNS 设置
```

---

**最后更新**: 2026-01-19
**版本**: v1.0
**验证状态**: ✅ 已基于官方文档验证

**提示**:
- 大多数问题都可以通过重启解决
- 检查路径格式（Windows 使用 `/`）
- 保持 Claude Code 更新到最新版本
- 定期清理缓存和旧会话
- 使用内置 `/help` 命令查看帮助
