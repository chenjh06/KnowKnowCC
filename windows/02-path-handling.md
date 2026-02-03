# Windows 路径处理 - Path Handling

> **彻底解决 Windows 路径问题**

**阅读时间**: 35分钟
**难度**: ⭐⭐⭐
**适用场景**: 所有 Windows 用户，必读！
**前置要求**: [Windows 入门](./01-getting-started.md)

---

## 目录

- [Windows 路径概述](#windows-路径概述)
- [路径格式详解](#路径格式详解)
- [常见路径问题](#常见路径问题)
- [最佳实践](#最佳实践)
- [工具和环境中的路径](#工具和环境中的路径)
- [实战案例](#实战案例)
- [PowerShell 路径处理](#powershell-路径处理)
- [故障排查](#故障排查)

---

## Windows 路径概述

### 为什么路径问题这么重要？

在 Windows 上使用 Claude Code 和命令行工具时，**路径问题是第一大痛点**：

```
❌ 常见问题：
- 路径包含空格导致命令失败
- 反斜杠被误解释为转义字符
- 相对路径找不到文件
- 路径长度超过限制（260字符）
- 大小写不敏感导致的混淆
- Unicode 字符显示问题

✅ 解决这些问题后：
- 命令执行成功率提升 90%
- 减少大量调试时间
- 工作流更顺畅
```

### Windows 文件系统特点

#### 1. 驱动器字母

```
C:\  - 系统盘
D:\  - 数据盘
E:\  - 移动设备
```

#### 2. 反斜杠分隔符

```
Windows 传统：
C:\Users\Username\Documents\file.txt
     ↑
   反斜杠 \
```

#### 3. 不区分大小写

```
❌ 不好：
C:\Users\Documents\file.txt
C:\users\documents\FILE.TXT
↑ 这两个是同一个文件，但容易混淆

✅ 好的做法：
保持大小写一致性，统一使用一种格式
```

---

## 路径格式详解

### 格式 1: 反斜杠（传统 Windows）

```powershell
# 传统 Windows 格式
C:\Users\Username\Documents\file.txt

特点：
✅ Windows 原生格式
✅ 文件资源管理器显示
❌ 在编程中需要转义
❌ 跨平台兼容性差
```

**问题示例**：

```javascript
// ❌ 错误：\t 被解释为制表符
const path = "C:\temp\file.txt";
// 实际路径：C:    empfile.txt

// ❌ 错误：\n 被解释为换行符
const path = "C:\new\file.txt";
// 实际路径：C:new
                            ile.txt
```

### 格式 2: 双反斜杠（转义）

```javascript
// ✅ 正确：使用双反斜杠转义
const path = "C:\\Users\\Username\\Documents\\file.txt";

特点：
✅ 在字符串中正确表示
✅ Windows 原生格式
⚠️ 需要手动转义，容易遗漏
```

**PowerShell 中的情况**：

```powershell
# PowerShell 中单反斜杠通常可以
$path = "C:\Users\Username\Documents\file.txt"

# 但有时仍然需要转义
$path = "C:\\Users\\Username\\Documents\\file.txt"
```

### 格式 3: 正斜杠（推荐）⭐

```powershell
# ✅ 推荐：使用正斜杠
C:/Users/Username/Documents/file.txt

特点：
✅ 无需转义
✅ 跨平台一致
✅ Claude Code 推荐
✅ 大多数工具支持
✅ 更易读
```

**为什么推荐正斜杠？**

```javascript
// ✅ 正斜杠无需转义
const path = "C:/Users/Username/Documents/file.txt";

// ✅ 在代码中直接可用
// ✅ 在命令行中直接可用
// ✅ 在配置文件中直接可用
// ✅ 跨平台兼容
```

### 格式 4: 原始字符串（编程）

```javascript
// JavaScript 模板字符串
const path = `C:\Users\Username\Documents\file.txt`;

// 但仍然不推荐，因为可能有问题
```

---

## 常见路径问题

### 问题 1: 空格路径

**症状**：

```powershell
# ❌ 错误：命令无法识别路径
cd C:\Program Files\MyApp
# 错误：系统无法找到路径
```

**原因**：

```
C:\Program Files\MyApp
           ↑
        空格导致参数被截断
实际执行：cd C:\Program
```

**解决方案**：

```powershell
# ✅ 方案 1：使用引号（推荐）
cd "C:\Program Files\MyApp"

# ✅ 方案 2：使用 Tab 补全
cd C:\Prog[Tab]  # 自动补全并添加引号

# ✅ 方案 3：使用短文件名
cd C:\PROGRA~1\MYAPP~1
```

**编程中处理**：

```javascript
// ❌ 错误
exec('cd C:\\Program Files\\MyApp');

// ✅ 正确
exec('cd "C:\\Program Files\\MyApp"');

// ✅ 更好：使用正斜杠
exec('cd "C:/Program Files/MyApp"');
```

### 问题 2: 路径长度限制

**症状**：

```
错误：路径名太长
错误：文件名过长或无效
```

**原因**：

```
Windows 传统限制：MAX_PATH = 260 字符
```

**解决方案**：

```powershell
# ✅ 方案 1：使用长路径前缀
\\?\C:\very\long\path\...  # 支持 32,767 字符

# ✅ 方案 2：启用长路径支持
# Windows 10 版本 1607+ 可启用
# 需要管理员权限

# 通过注册表启用
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v LongPathsEnabled /t REG_DWORD /d 1 /f

# 或通过组策略启用
# 计算机配置 > 管理模板 > 系统 > 文件系统
# 启用"启用 Win32 长路径"
```

**编程中处理**：

```javascript
// Node.js
const path = require('path');

// ✅ 使用 path 模块处理
const longPath = path.join('C:', 'very', 'long', 'path', '...');
```

### 问题 3: 相对路径错误

**症状**：

```
错误：找不到文件
错误：系统无法找到指定的路径
```

**原因**：

```powershell
# ❌ 相对路径依赖于当前工作目录
node script.js
cd scripts
node ../script.js  # 可能失败
```

**解决方案**：

```powershell
# ✅ 方案 1：使用绝对路径
$scriptPath = "D:/Projects/myscript.js"
node $scriptPath

# ✅ 方案 2：基于脚本目录的相对路径
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
node "$scriptDir\script.js"

# ✅ 方案 3：使用环境变量
cd $PSScriptRoot  # 脚本所在目录
```

### 问题 4: Unicode 路径

**症状**：

```
乱码显示：C:\Users\用戶名\Documents\
无法访问：路径包含特殊字符
```

**解决方案**：

```powershell
# ✅ 使用 UTF-8 编码
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$env:LANG = 'zh_CN.UTF-8'

# ✅ PowerShell Core (pwsh) 默认支持 UTF-8
pwsh  # 使用 PowerShell Core

# ✅ 使用短文件名（如果可用）
dir ~  # 查看短文件名
```

### 问题 5: 网络路径

**症状**：

```
UNC 路径访问问题
映射驱动器不稳定
```

**解决方案**：

```powershell
# ✅ UNC 路径格式
\\server\share\folder\file.txt

# ✅ 使用正斜杠（某些工具支持）
//server/share/folder/file.txt

# ✅ 映射网络驱动器
New-PSDrive -Name "P" -PSProvider FileSystem -Root "\\server\share"
cd P:\

# ✅ 使用 Push-Location
Push-Location \\server\share
# 执行操作
Pop-Location
```

---

## 最佳实践

### 1. 使用正斜杠 ⭐⭐⭐⭐⭐

```powershell
# ✅ 推荐
C:/Users/Username/Documents/file.txt
D:/Projects/app/src/index.js

# ❌ 避免
C:\Users\Username\Documents\file.txt
```

**原因**：
- 无需转义
- 跨平台一致
- 减少错误
- 更易读

### 2. 使用引号包裹路径

```powershell
# ✅ 好习惯
cd "C:/Program Files/MyApp"
npm run build -- "C:/My Documents/project"

# ❌ 容易出错
cd C:/Program Files/MyApp
```

### 3. 使用 Tab 补全

```powershell
# 输入部分路径后按 Tab
cd C:/Prog[Tab]
# 自动补全为：cd "C:\Program Files"

# 继续按 Tab 切换匹配项
```

### 4. 规范化路径

```powershell
# ✅ 使用 PowerShell 命令
$path = "C:/Users/../Users/Username/./Documents"
$normalized = Resolve-Path $path
# 结果：C:\Users\Username\Documents

# ✅ 使用 .NET 方法
$normalized = [System.IO.Path]::GetFullPath($path)
```

### 5. 检查路径存在性

```powershell
# ✅ 执行操作前检查
$path = "C:/Users/Username/Documents"

if (Test-Path $path) {
  cd $path
} else {
  Write-Error "路径不存在: $path"
}
```

### 6. 使用环境变量

```powershell
# ✅ 使用标准环境变量
$HOME              # 用户主目录
$USERPROFILE       # 用户配置文件目录
$APPDATA           # 应用数据目录
$LOCALAPPDATA      # 本地应用数据目录
$PROGRAMFILES      # Program Files
$PROGRAMFILES(X86) # Program Files (x86)

# 示例
cd $HOME/Documents
cd $env:APPDATA/MyApp
```

---

## 工具和环境中的路径

### Claude Code

```markdown
# ✅ 在 Claude Code 中使用正斜杠

@C:/Users/Username/project/src
@D:/Projects/app

# ✅ 或使用双反斜杠
@C:\\Users\\Username\\project\\src

# ❌ 避免单反斜杠
@C:\Users\Username\project\src  # 可能出错
```

### Git Bash

```bash
# Git Bash 自动转换路径
# Windows 路径自动转换为 Unix 风格

cd C:/Users/Username/Documents
# 自动转换为：/c/Users/Username/Documents

# ✅ 使用 Unix 风格
cd ~/Documents
cd /c/Users/Username/Documents
```

### Node.js / npm

```javascript
// ✅ 使用 path 模块
const path = require('path');

const fullPath = path.join('C:', 'Users', 'Username', 'Documents');
// 结果：C:\Users\Username\Documents

const dir = path.dirname('C:/Users/Username/Documents/file.txt');
// 结果：C:\Users\Username\Documents

// ✅ 使用 __dirname（脚本所在目录）
const scriptDir = __dirname;
const filePath = path.join(scriptDir, 'data.json');
```

```powershell
# npm 脚本中使用正斜杠
npm run build -- --output "C:/Projects/app/dist"

# package.json
{
  "scripts": {
    "build": "webpack --mode production",
    "serve": "serve C:/Projects/app/dist"
  }
}
```

### VS Code

```json
// settings.json
{
  "terminal.integrated.cwd": "C:/Users/Username/projects/app",
  "typescript.tsdk": "C:/Users/Username/node_modules/typescript/lib"
}
```

### Docker

```dockerfile
# Dockerfile 中使用正斜杠
COPY C:/Projects/app/src /usr/src/app
WORKDIR /usr/src/app

# docker-compose.yml
volumes:
  - C:/Users/Username/data:/data
```

### Python

```python
# ✅ 使用 pathlib（Python 3.4+）
from pathlib import Path

path = Path("C:/Users/Username/Documents/file.txt")
print(path.parent)  # C:\Users\Username\Documents
print(path.name)    # file.txt
print(path.stem)    # file
print(path.suffix)  # .txt

# ✅ 或使用 os.path
import os
path = os.path.join("C:", "Users", "Username", "Documents", "file.txt")
```

---

## 实战案例

### 案例 1: Claude Code 项目路径

**场景**：在 Claude Code 中引用项目文件

```markdown
# ❌ 错误示例

@C:\Users\Username\project\src
# 问题：反斜杠可能被转义

@C:/Users/Username/project/src
# 正确：使用正斜杠

# ✅ 最佳实践

# 使用项目根目录相对路径
@./src
@./components/Button.tsx

# 使用环境变量
@~/projects/myapp

# 使用 Tab 补全
@C:/Users/Username/my[Tab]
# 自动补全并添加引号
```

### 案例 2: 批量处理文件

**场景**：批量处理文件夹中的所有文件

```powershell
# ❌ 不好：容易出错
$path = C:\Users\Username\Documents\Files
Get-ChildItem $path | ForEach-Object { ... }

# ✅ 好：使用引号和正斜杠
$path = "C:/Users/Username/Documents/Files"
Get-ChildItem $path | ForEach-Object { ... }

# ✅ 更好：使用相对路径
$scriptDir = $PSScriptRoot
$filesPath = Join-Path $scriptDir "files"
Get-ChildItem $filesPath | ForEach-Object { ... }

# ✅ 最佳：使用 Resolve-Path 验证
$basePath = "C:/Users/Username/Documents/Files"
if (Test-Path $basePath) {
  $fullPath = Resolve-Path $basePath
  Get-ChildItem $fullPath | ForEach-Object {
    Write-Host "Processing: $_.FullName"
  }
}
```

### 案例 3: Webpack 配置

**场景**：配置 Webpack 构建路径

```javascript
// webpack.config.js

const path = require('path');

// ❌ 不好：硬编码反斜杠
module.exports = {
  entry: 'C:\\Projects\\app\\src\\index.js',
  output: {
    path: 'C:\\Projects\\app\\dist'
  }
};

// ✅ 好：使用 path 模块
module.exports = {
  entry: path.join(__dirname, 'src', 'index.js'),
  output: {
    path: path.join(__dirname, 'dist'),
    filename: 'bundle.js'
  }
};

// ✅ 最佳：跨平台兼容
module.exports = {
  entry: path.resolve(__dirname, 'src', 'index.js'),
  output: {
    path: path.resolve(__dirname, 'dist'),
    publicPath: '/'  // 使用正斜杠
  }
};
```

### 案例 4: PowerShell 脚本

**场景**：编写可重用的 PowerShell 脚本

```powershell
# script.ps1

# ✅ 获取脚本所在目录
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# ✅ 构建相对路径
$DataPath = Join-Path $ScriptDir "data"
$ConfigPath = Join-Path $ScriptDir "config.json"

# ✅ 检查路径存在
if (-not (Test-Path $DataPath)) {
  Write-Error "数据目录不存在: $DataPath"
  exit 1
}

# ✅ 读取配置
if (Test-Path $ConfigPath) {
  $Config = Get-Content $ConfigPath -Raw | ConvertFrom-Json
} else {
  Write-Warn "配置文件不存在，使用默认配置"
  $Config = @{ DefaultSetting = $true }
}

# ✅ 使用路径
Write-Host "数据目录: $DataPath"
Write-Host "配置文件: $ConfigPath"

# ✅ 处理文件
Get-ChildItem $DataPath -Filter "*.json" | ForEach-Object {
  Write-Host "处理文件: $_.FullName"
  # 处理逻辑...
}
```

### 案例 5: Claude Code 工作流

**场景**：使用 Claude Code 自动化处理文件

```markdown
# 在 Claude Code 中

# ✅ 使用 @ 符号引用目录
@D:/Projects/app/src

# ✅ 结合相对路径
创建一个测试文件，放在 D:/Projects/app/src/tests 目录下

# ✅ 使用环境变量
在 %USERPROFILE%/Documents 创建备份脚本

# ✅ 批量操作
处理 D:/Projects/app/src/components 下的所有 .tsx 文件
```

---

## PowerShell 路径处理

### 基础命令

```powershell
# 获取当前路径
Get-Location
# 或
pwd

# 切换目录
Set-Location "C:/Users/Username/Documents"
# 或
cd "C:/Users/Username/Documents"

# 返回上级目录
cd ..
# 或
Set-Location ..

# 返回主目录
cd ~
# 或
Set-Location ~
```

### 路径操作

```powershell
# 路径拼接
$base = "C:/Users/Username"
$full = Join-Path $base "Documents"
# 结果：C:\Users\Username\Documents

# 路径分割
$path = "C:/Users/Username/Documents/file.txt"
$parent = Split-Path $path
# 结果：C:\Users\Username\Documents

$leaf = Split-Path $path -Leaf
# 结果：file.txt

# 获取扩展名
$ext = [System.IO.Path]::GetExtension($path)
# 结果：.txt

# 获取文件名（不含扩展名）
$name = [System.IO.Path]::GetFileNameWithoutExtension($path)
# 结果：file
```

### 路径测试

```powershell
# 测试路径是否存在
Test-Path "C:/Users/Username/Documents"
# 结果：True 或 False

# 测试是否为文件
Test-Path "C:/Users/Username/file.txt" -PathType Leaf

# 测试是否为目录
Test-Path "C:/Users/Username/Documents" -PathType Container

# 测试通配符
Test-Path "C:/Users/Username/Documents/*.txt"
```

### 路径解析

```powershell
# 解析相对路径为绝对路径
Resolve-Path ".\file.txt"
# 结果：C:\Users\Username\file.txt

# 获取规范路径
$canonical = (Get-Item "C:/Users/../Users/Username/Documents").FullName
# 结果：C:\Users\Username\Documents
```

### 路径遍历

```powershell
# 遍历目录
Get-ChildItem "C:/Users/Username/Documents" -Recurse

# 只遍历文件
Get-ChildItem "C:/Users/Username/Documents" -Recurse -File

# 按扩展名过滤
Get-ChildItem "C:/Users/Username/Documents" -Filter "*.txt"

# 递归查找
Get-ChildItem "C:/Users/Username" -Recurse -Filter "config.json"
```

---

## 故障排查

### 问题 1: 路径中的空格导致命令失败

**症状**：

```powershell
cd C:\Program Files\MyApp
# 错误：系统无法找到路径
```

**诊断**：

```powershell
# 检查路径是否包含空格
$path = "C:\Program Files\MyApp"
$path -match ' '  # 返回 True
```

**解决方案**：

```powershell
# ✅ 使用引号
cd "C:\Program Files\MyApp"

# ✅ 使用 Tab 补全
cd C:\Prog[Tab]  # 自动补全并添加引号

# ✅ 使用 & 操作符
& "C:\Program Files\MyApp\app.exe"
```

### 问题 2: 相对路径找不到文件

**症状**：

```
错误：找不到文件或目录
```

**诊断**：

```powershell
# 检查当前工作目录
Get-Location

# 检查文件是否存在
Test-Path ".\file.txt"

# 查看完整路径
Resolve-Path ".\file.txt"
```

**解决方案**：

```powershell
# ✅ 使用绝对路径
$fullPath = Join-Path $PSScriptRoot "file.txt"

# ✅ 使用 $PSScriptRoot
$scriptPath = Join-Path $PSScriptRoot "data.json"

# ✅ 使用环境变量
$configPath = Join-Path $HOME "config.json"
```

### 问题 3: 路径太长

**症状**：

```
错误：路径名太长
```

**诊断**：

```powershell
# 检查路径长度
$path.Length

# 检查是否超过 260 字符
$path.Length -gt 260
```

**解决方案**：

```powershell
# ✅ 启用长路径支持（需要管理员权限）
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v LongPathsEnabled /t REG_DWORD /d 1 /f

# ✅ 使用相对路径缩短路径
cd C:\Very\Long\Path\To\Project
node script.js

# ✅ 使用subst命令映射短路径
subst X: C:\Very\Long\Path\To\Project
cd X:\

# ✅ 使用 symbolic link
New-Item -ItemType SymbolicLink -Path "C:\ShortLink" -Target "C:\Very\Long\Path"
```

### 问题 4: 网络路径无法访问

**症状**：

```
错误：无法访问网络路径
```

**诊断**：

```powershell
# 测试网络连接
Test-Connection server-name

# 测试路径访问
Test-Path "\\server\share"

# 查看映射的驱动器
Get-PSDrive
```

**解决方案**：

```powershell
# ✅ 使用完整 UNC 路径
\\server\share\folder\file.txt

# ✅ 映射网络驱动器
New-PSDrive -Name "P" -PSProvider FileSystem -Root "\\server\share"

# ✅ 使用凭据
$cred = Get-Credential
New-PSDrive -Name "P" -PSProvider FileSystem -Root "\\server\share" -Credential $cred

# ✅ 使用 Push-Location
Push-Location "\\server\share"
# 执行操作
Pop-Location
```

### 问题 5: PowerShell 中反斜杠被转义

**症状**：

```powershell
$path = "C:\new\file.txt"
Write-Host $path
# 输出：C:
#       ewfile.txt
```

**诊断**：

```powershell
# 检查特殊字符
$path -match '[\r\n\t]'  # 检查是否包含转义字符
```

**解决方案**：

```powershell
# ✅ 使用正斜杠
$path = "C:/new/file.txt"

# ✅ 使用双反斜杠
$path = "C:\\new\\file.txt"

# ✅ 使用原始字符串
$path = 'C:\new\file.txt'

# ✅ 使用 Here-String
$path = @"
C:\new\file.txt
"@
```

---

## 快速参考

### 路径格式速查表

| 格式 | 示例 | 优点 | 缺点 | 推荐度 |
|------|------|------|------|--------|
| 正斜杠 | `C:/Users/file.txt` | 无需转义、跨平台 | 非Windows原生 | ⭐⭐⭐⭐⭐ |
| 双反斜杠 | `C:\\Users\\file.txt` | Windows原生、可转义 | 需手动转义 | ⭐⭐⭐⭐ |
| 单反斜杠 | `C:\Users\file.txt` | Windows原生 | 需转义、易出错 | ⭐⭐ |
| 环境变量 | `$HOME/file.txt` | 动态、可移植 | 依赖于环境 | ⭐⭐⭐⭐ |
| 相对路径 | `./file.txt` | 简洁 | 依赖工作目录 | ⭐⭐⭐⭐ |

### 常用命令

```powershell
# 路径操作
Join-Path "C:" "Users" "file.txt"           # 拼接路径
Split-Path "C:\Users\file.txt" -Parent     # 获取父目录
Split-Path "C:\Users\file.txt" -Leaf       # 获取文件名
Resolve-Path ".\file.txt"                  # 解析为绝对路径

# 路径测试
Test-Path "C:\Users\file.txt"              # 测试存在
Test-Path "C:\Users" -PathType Container   # 测试是否为目录

# 环境变量
$HOME                    # 用户主目录
$USERPROFILE             # 用户配置文件
$APPDATA                 # 应用数据目录
$LOCALAPPDATA            # 本地应用数据目录
$PSScriptRoot            # 脚本所在目录

# 文件系统
Get-ChildItem "C:\Users" -Recurse         # 递归遍历
Get-Item "C:\Users\file.txt"              # 获取文件信息
New-Item -ItemType File -Path "C:\new.txt" # 创建文件
```

### 最佳实践清单

```
✅ 使用正斜杠
   C:/Users/Username/Documents/file.txt

✅ 使用引号包裹包含空格的路径
   "C:/Program Files/MyApp"

✅ 使用 Tab 补全
   cd C:/Prog[Tab]

✅ 使用环境变量
   cd $HOME/Documents

✅ 使用相对路径
   @./src/components

✅ 使用 path 模块（编程时）
   path.join(__dirname, 'src', 'index.js')

✅ 检查路径存在性
   if (Test-Path $path) { ... }

✅ 规范化路径
   Resolve-Path ".\file.txt"
```

---

## 总结

### 核心要点

1. **使用正斜杠** ⭐⭐⭐⭐⭐
   ```
   C:/Users/Username/Documents/file.txt
   ```

2. **引号包裹路径**
   ```powershell
   cd "C:/Program Files/MyApp"
   ```

3. **利用 Tab 补全**
   ```powershell
   cd C:/Prog[Tab]
   ```

4. **使用环境变量**
   ```powershell
   cd $HOME/Documents
   ```

5. **检查路径存在**
   ```powershell
   if (Test-Path $path) { ... }
   ```

### 学习路径

```
1. 基础（5分钟）
   ├─ 理解路径格式
   ├─ 学会使用正斜杠
   └─ 掌握引号包裹

2. 进阶（15分钟）
   ├─ 环境变量使用
   ├─ 相对路径处理
   └─ 路径验证

3. 专家（30分钟）
   ├─ PowerShell 高级操作
   ├─ 编程中路径处理
   └─ 故障排查
```

### 下一步

1. **实践练习**
   - 在日常工作中使用正斜杠
   - 练习 Tab 补全
   - 编写路径处理脚本

2. **深入学习**
   - [Windows 入门](./01-getting-started.md)
   - [PowerShell 性能](./03-performance.md)
   - [故障排查](./04-troubleshooting.md)

3. **工具配置**
   - 配置 Claude Code 路径
   - 配置开发环境路径
   - 创建路径别名

---

## 相关资源

### 项目文档
- [Windows 入门](./01-getting-started.md) - Windows 基础
- [Windows 性能](./03-performance.md) - 性能优化
- [Windows 故障排查](./04-troubleshooting.md) - 问题诊断

### 核心文档
- [快速上手](../guide/01-quickstart.md) - Claude Code 基础
- [会话管理](../advanced/a-productivity/02-session-management.md) - 会话技巧

### 外部资源
- [PowerShell 文档](https://docs.microsoft.com/en-us/powershell/)
- [Windows 文件系统](https://docs.microsoft.com/en-us/windows/win32/fileio/maximum-file-path-limitation)

---

**最后更新**: 2026-02-04
**难度**: ⭐⭐⭐
**阅读时间**: 35分钟
**重要性**: ⭐⭐⭐⭐⭐ (必读！)
