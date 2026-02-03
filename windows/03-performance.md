# Windows 性能优化 - Performance

> **让 Claude Code 在 Windows 上飞快运行**

**阅读时间**: 35分钟
**难度**: ⭐⭐⭐
**适用场景**: 追求最佳性能的 Windows 用户
**前置要求**: [Windows 入门](./01-getting-started.md), [路径处理](./02-path-handling.md)

---

## 目录

- [性能概述](#性能概述)
- [终端优化](#终端优化)
- [PowerShell 优化](#powershell-优化)
- [文件系统优化](#文件系统优化)
- [网络优化](#网络优化)
- [Claude Code 优化](#claude-code-优化)
- [监控和调优](#监控和调优)
- [实战案例](#实战案例)
- [性能基准](#性能基准)

---

## 性能概述

### Windows 性能因素

```
┌─────────────────────────────────────┐
│  Claude Code 性能影响因素             │
│                                     │
│  ├─ 终端模拟器                       │
│  │  ├─ Windows Terminal vs CMD        │
│  │  └─ PowerShell 版本                │
│  │                                   │
│  ├─ 文件系统                         │
│  │  ├─ HDD vs SSD                     │
│  │  ├─ 磁盘碎片                       │
│  │  └─ 文件索引                       │
│  │                                   │
│  ├─ 网络连接                         │
│  │  ├─ 带宽                           │
│  │  ├─ 延迟                           │
│  │  └─ 代理                           │
│  │                                   │
│  └─ 系统资源                         │
│     ├─ CPU                           │
│     ├─ 内存                          │
│     └─ 后台进程                      │
└─────────────────────────────────────┘
```

### 性能指标

**关键指标**：

```
响应时间
- 目标: < 2秒
- 可接受: 2-5秒
- 需优化: > 5秒

启动时间
- 目标: < 3秒
- 可接受: 3-8秒
- 需优化: > 8秒

内存使用
- 正常: 100-300MB
- 警告: 300-500MB
- 需优化: > 500MB

CPU 使用
- 正常: 5-15%
- 警告: 15-30%
- 需优化: > 30%
```

---

## 终端优化

### Windows Terminal

**安装和配置**：

```powershell
# 安装 Windows Terminal
winget install Microsoft.WindowsTerminal

# 启动 Windows Terminal
wt
```

**性能配置**：

```json
// settings.json

{
  "profiles": {
    "defaults": {
      // ✅ 硬件加速
      "experimental.rendering.forceFullRepaint": true,
      "experimental.rendering.software": false,

      // ✅ 颜测渲染
      "experimental.rendering.forceFullRepaint": true,

      // ✅ 颜测光标
      "experimental.rendering.cursorBlink": true
    }
  },

  // ✅ 禁用不必要的动画
  "animations": false,

  // ✅ 更新的渲染器
  "integrated": {
    "useWin32kConhostMode": true
  }
}
```

### 字体优化

**推荐字体**：

```markdown
✅ Cascadia Code
   - 专为代码设计
   - 支持连字特性
   - 支持编程字符

✅ Cascadia Mono
   - 等宽字体
   - 高可读性

✅ JetBrains Mono
   - 开发者友好
   - 多语言支持
```

**配置**：

```json
{
  "profiles": {
    "defaults": {
      "fontFace": "Cascadia Code",
      "fontSize": 12
    }
  }
}
```

### 颜色主题

**选择高对比主题**：

```json
{
  "schemes": [
    {
      "name": "High Contrast",
      "background": "#000000",
      "foreground": "#FFFFFF",
      "cursorColor": "#FFFFFF",
      "selectionBackground": "#FFFFFF",
      "selectionForeground": "#000000"
    }
  ]
}
```

---

## PowerShell 优化

### 使用 PowerShell 7 (Core)

**性能对比**：

```
Windows PowerShell 5.1:
- 启动时间: 2-3秒
- 内存使用: 150-200MB
- 性能: 基准

PowerShell 7 (Core):
- 启动时间: 0.5-1秒 (快3倍)
- 内存使用: 80-120MB (省40%)
- 性能: 1.5-2x 更快
```

**安装**：

```powershell
# winget 安装
winget install Microsoft.PowerShell

# 验证安装
pwsh --version
```

### 优化 Profile

**减少 Profile 加载时间**：

```powershell
# 检查 Profile 加载时间
Measure-Command { . $PROFILE }

# 如果超过 500ms，优化 Profile 内容

# ❌ 避免：繁重的初始化
# 以下操作会显著增加启动时间：
# - Get-ChildItem -Recurse (递归搜索)
# - 复杂的函数定义
# - 网络请求
# - 大量模块导入

# ✅ 推荐：延迟加载
# 按需加载函数和模块
```

**示例优化**：

```powershell
# $PROFILE

# ❌ 不好：每次加载都执行
Get-ChildItem "D:\Projects" -Recurse

# ✅ 好：按需加载
function Get-Projects {
    Get-ChildItem "D:\Projects" -Recurse
}

# 只在需要时调用
# Get-Projects
```

### 模块加载优化

**使用模块自动加载**：

```powershell
# PowerShell 7 默认启用模块自动加载
$PSModuleAutoLoadingPreference = 'All'

# 优势：
# - 按需加载模块
# - 减少启动时间
# - 自动发现命令
```

---

## 文件系统优化

### SSD vs HDD

**性能对比**：

```
HDD (机械硬盘):
- 读取速度: 100-150 MB/s
- 随机访问: 慢
- 碎片影响: 大

SSD (固态硬盘):
- 读取速度: 500-3000 MB/s
- 随机访问: 快
- 碎片影响: 小

性能提升: 5-20倍
```

**推荐**：

```markdown
✅ 使用 SSD 作为系统盘
✅ Claude Code 和项目放 SSD
✅ HDD 用于存储和备份

检查:
Get-PSDrive C
# 查看媒体类型
```

### 磁盘碎片整理

**HDD 需要，SSD 不需要**：

```powershell
# 检查是否需要碎片整理
defrag C: /A

# 手动碎片整理
# 此电脑 → 右键 C: → 属性 → 工具选项卡 → 优化

# 或使用命令
Optimize-Volume -DriveLetter C -Defrag -Verbose
```

### 禁用不必要的服务

**Windows Search 索引**：

```markdown
# 对开发项目目录禁用索引

1. 右键项目文件夹 → 属性 → 高级
2. 取消"除了文件属性外..."
3. 确认
```

**禁用 Windows Defender 实时保护**（谨慎）：

```markdown
⚠️ 仅在安全的环境中使用

1. Windows 安全中心 → 病毒和威胁防护
2. 管理设置 → 关闭实时保护

# 临时禁用（管理员）
Set-MpPreference -DisableRealtimeMonitoring $true -Force

# 恢复
Set-MpPreference -DisableRealtimeMonitoring $false -Force
```

### 清理临时文件

**定期清理**：

```powershell
# 清理临时文件
$tempFolders = @(
    "$env:TEMP",
    "$env:TMP",
    "C:\Windows\Temp"
)

foreach ($folder in $tempFolders) {
    if (Test-Path $folder) {
        Write-Host "清理: $folder"
        Remove-Item "$folder\*" -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# 清理回收站
Clear-RecycleBin -Force

# 清理 Claude Code 缓存
Remove-Item "$env:APPDATA\Claude Code\cache" -Recurse -Force -ErrorAction SilentlyContinue
```

---

## 网络优化

### DNS 优化

**使用快速 DNS**：

```powershell
# 设置为 Cloudflare DNS (1.1.1.1)
Set-DnsClientServerAddress -InterfaceAlias "Wi-Fi" -ServerAddresses 1.1.1.1, 1.0.0.1

# 或 Google DNS (8.8.8.8)
Set-DnsClientServerAddress -InterfaceAlias "Wi-Fi" -ServerAddresses 8.8.8.8, 8.8.4.4

# 清除 DNS 缓存
Clear-DnsClientCache

# 刷新 DNS
ipconfig /flushdns
```

### 网络适配器设置

**禁用不必要的协议**：

```markdown
1. 控制面板 → 网络和 Internet → 网络连接
2. 以太网属性 → 配置
3. 取消不必要的协议:
   - QoS 数据包计划程序
   - Internet 协议版本 6 (TCP/IPv6)（如果不用）
```

### 代理优化

**如果必须使用代理**：

```markdown
✅ 使用自动配置脚本 (PAC)
✅ 使用本地代理
✅ 配置代理例外列表

不需要代理的地址:
- localhost
- 127.0.0.1
- *.local
```

---

## Claude Code 优化

### 会话管理

**清理旧会话**：

```powershell
# 列出所有会话
Get-ChildItem "$env:APPDATA\Claude Code\sessions"

# 删除 7 天前的会话
$cutoffDate = (Get-Date).AddDays(-7)
Get-ChildItem "$env:APPDATA\Claude Code\sessions" |
    Where-Object { $_.LastWriteTime -lt $cutoffDate } |
    Remove-Item -Force

# 或使用 Claude Code 内置清理
# Claude Code 会自动清理过期会话
```

### 缓存优化

**清理缓存**：

```powershell
# 清理 Claude Code 缓存
$cachePath = "$env:APPDATA\Claude Code\cache"
if (Test-Path $cachePath) {
    Remove-Item -Recurse -Force $cachePath
}
```

### 配置优化

**简化配置**：

```json
// settings.json

{
  // ❌ 不好：过多自定义
  "customThemes": [...],
  "customFonts": [...],
  "experimental": {...}

  // ✅ 好：保持默认配置
  // 使用默认主题和字体
}
```

---

## 监控和调优

### 性能监控

**实时监控**：

```powershell
# 监控 CPU 和内存
Start-Process taskmgr -WindowName "Performance"

# 使用 PowerShell 监控
while ($true) {
    $cpu = Get-Counter '\Processor(_Total)\% Processor Time'
    $mem = Get-Counter '\Memory\Available MBytes'

    Write-Host "CPU: $cpu%, Memory: $mem MB"

    Start-Sleep -Seconds 5
}
```

### 性能瓶颈分析

**识别瓶颈**：

```markdown
CPU 高:
- 检查后台进程
- 检查杀毒软件
- 检查 Windows Update

内存高:
- 关闭其他应用
- 清理缓存
- 检查内存泄漏

磁盘高:
- 检查索引服务
- 清理临时文件
- 磁盘碎片整理

网络慢:
- 测试网络速度
- 检查 DNS
- 检查代理
```

### 基准测试

**运行基准测试**：

```markdown
👤 你：帮我测试 Claude Code 的性能

测试项:
1. 启动时间
2. 大型文件处理
3. 复杂对话响应

🤖 Claude：[运行测试]

启动时间:
- 平均: 2.5秒
- 最快: 1.8秒
- 最慢: 3.2秒

大文件处理 (10000行):
- 平均: 4.5秒
- 最快: 3.2秒
- 最慢: 6.1秒

复杂对话:
- 平均: 3.2秒
- Token: 2500
```

---

## 实战案例

### 案例1: 优化启动时间

**问题**：Claude Code 启动需要 10 秒

**诊断**：

```powershell
# 检查 Profile 加载时间
Measure-Command { . $PROFILE }

# 检查启动进程
Get-Process | Where-Object {$_.Name -like "*Claude*"}

# 检查网络连接
Test-Connection api.anthropic.com -Count 2
```

**解决方案**：

```powershell
# 1. 优化 Profile
# 移除耗时操作

# 2. 清理缓存
Remove-Item "$env:APPDATA\Claude Code\cache" -Recurse -Force

# 3. 检查网络
# 优化 DNS 设置
```

**结果**：启动时间从 10 秒降至 2.5 秒

### 案例2: 优化文件处理

**问题**：处理大文件很慢

**诊断**：

```markdown
👤 你：为什么处理 @src/app.ts 这么慢？

文件信息：
- 10000 行代码
- 大小: 300KB

🤖 Claude：[分析原因]

可能原因:
1. 文件内容大
2. 复杂的导入关系
3. 上下文需要理解更多

解决方案:
1. 使用部分引用
2. 分段处理
3. 简化文件
```

**优化**：

```markdown
# ❌ 不好：引用整个大文件
@app.ts 分析整个文件

# ✅ 好：分段处理
@app.ts 只看类定义部分
@app.ts 只看导入部分

# ✅ 更好：引用特定部分
@app.ts 导出了哪些类？
```

### 案例3: 优化响应时间

**问题**：Claude 响应时间 10+ 秒

**诊断**：

```markdown
诊断步骤:
1. 检查网络连接: Test-Connection api.anthropic.com
2. 检查代理设置: netsh winhttp show proxy
3. 检查会话大小: 统计 Token 数
4. 检查系统资源: CPU/内存使用
```

**解决方案**：

```powershell
# 1. 清理会话
# 删除旧会话，减少上下文

# 2. 优化网络
# 配置快速 DNS
# 使用有线网络

# 3. 优化提示词
# 精确描述，减少 Token

# 4. 关闭后台应用
# 释放系统资源
```

---

## 性能基准

### 基准指标

**启动性能**：

```
冷启动（首次启动）: 3-5 秒
温启动（已运行）: 1-2 秒
```

**响应性能**：

```
简单查询（< 500 tokens）: 1-2 秒
中等查询（500-2000 tokens）: 2-4 秒
复杂查询（2000-5000 tokens）: 4-8 秒
大型查询（> 5000 tokens）: 8-15 秒
```

**内存使用**：

```
空闲: 100-150 MB
正常使用: 200-300 MB
处理大文件: 400-500 MB
```

### 优化前后对比

```
优化前:
├─ 启动: 10 秒
├─ 简单查询: 5 秒
├─ 内存: 500 MB

优化后:
├─ 启动: 2 秒
├─ 简单查询: 2 秒
└─ 内存: 250 MB

提升: 2-5倍
```

---

## 总结

### 优化优先级

```
高优先级:
├─ 使用 SSD ⭐⭐⭐⭐⭐
├─ Windows Terminal ⭐⭐⭐⭐
├─ PowerShell 7 ⭐⭐⭐⭐
└─ 清理缓存 ⭐⭐⭐⭐

中优先级:
├─ 禁用索引 ⭐⭐⭐
├─ DNS 优化 ⭐⭐⭐
└─ 文件清理 ⭐⭐⭐

低优先级:
├─ 禁用服务 ⭐⭐
├─ 颜色主题 ⭐
└─ 字体选择 ⭐
```

### 快速优化清单

```
必做（30分钟）:
□ 安装 Windows Terminal
□ 安装 PowerShell 7
□ 设置为默认
□ 清理缓存
□ 配置字体

推荐（1小时）:
□ 更换 SSD（如果没有）
□ 优化 DNS
□ 清理临时文件
□ 禁用索引
□ 优化 Profile

可选（按需）:
□ 禁用 Defender（谨慎）
□ 配置主题
□ 调整字体
□ 监控性能
```

---

## 相关资源

### 项目文档
- [Windows 入门](./01-getting-started.md) - 基础配置
- [路径处理](./02-path-handling.md) - 路径问题
- [故障排查](./04-troubleshooting.md) - 问题诊断

### 核心文档
- [性能优化](../master/03-advanced-topics/03-performance-optimization.md) - 通用性能优化

### 外部资源
- [Windows Terminal 文档](https://docs.microsoft.com/en-us/windows-terminal/)
- [PowerShell 文档](https://docs.microsoft.com/en-us/powershell/)

---

**最后更新**: 2026-02-04
**难度**: ⭐⭐⭐
**阅读时间**: 35分钟
**重要性**: ⭐⭐⭐⭐
