# Windows 用户专属指南

> **Windows 平台的完整支持和最佳实践**

**适合人群**: Windows 10/11 用户
**覆盖内容**: 安装、配置、优化、问题解决

---

## 欢迎Windows用户！

Claude Code 对 Windows 有完整的支持，但有些地方需要特别注意。本指南将帮助你：

- ✅ 快速安装和配置
- ✅ 解决路径问题
- ✅ 优化性能
- ✅ 处理常见问题
- ✅ 与工具集成

---

## 📚 内容目录

### 01 - Getting Started（入门指南）

**文件**: [01-getting-started.md](./01-getting-started.md)

**内容**:
- Windows 安装方法（winget、scoop、手动）
- 环境变量配置
- 首次启动和配置
- Windows Terminal 设置
- 验证安装

**适合**: 新安装 Claude Code 的用户

---

### 02 - Path Handling（路径处理完整指南）✅

**文件**: [02-path-handling.md](./02-path-handling.md)

**状态**: ✅ 已完成

**内容**:
- Windows 路径格式问题
- 反斜杠 vs 正斜杠
- PowerShell 路径处理
- 环境变量中的路径
- Claude Code 中的路径使用
- 常见路径错误
- 5种路径格式详解
- 实战案例和故障排查

**适合**: 所有 Windows 用户（必读）

**重要性**: ⭐⭐⭐⭐⭐

**字数**: ~18,000 字

---

### 03 - Performance（性能优化）✅

**文件**: [03-performance.md](./03-performance.md)

**状态**: ✅ 已完成

**内容**:
- 性能概述（价值、因素、指标）
- 终端优化（Windows Terminal、字体、主题）
- PowerShell 优化（PowerShell 7、Profile 优化、模块加载）
- 文件系统优化（SSD vs HDD、碎片整理、服务禁用）
- 网络优化（DNS、网络适配器、代理）
- Claude Code 优化（会话管理、缓存清理、配置简化）
- 监控和调优（性能监控、瓶颈分析、基准测试）
- 2个实战案例：优化启动时间、优化文件处理
- 性能基准（启动、响应、内存指标）

**适合**: 追求最佳性能的用户
**重要性**: ⭐⭐⭐⭐

**字数**: ~19,000 字

---

### 04 - Troubleshooting（常见问题）✅

**文件**: [04-troubleshooting.md](./04-troubleshooting.md)

**状态**: ✅ 已完成

**内容**:
- 故障排查概述（方法论、快速诊断工具）
- 常见错误类型（6大类：命令、权限、路径、网络、编码、模块）
- 诊断流程（标准流程、Claude Code 辅助）
- 命令问题（npm、Git、Python 找不到）
- 权限问题（管理员权限、文件占用）
- 路径问题（空格、长路径、相对路径）
- 性能问题（终端响应、磁盘 I/O）
- 网络问题（代理、DNS、连接）
- 环境问题（Node.js、Python 版本冲突）
- 3个实战案例：启动失败、npm 失败、Git 失败
- 快速参考（诊断命令、修复清单）

**适合**: 所有 Windows 用户（必备！）
**重要性**: ⭐⭐⭐⭐⭐

**字数**: ~24,000 字

---

## 🎯 快速导航

### 我想...

```
安装 Claude Code      → [01 - Getting Started](./01-getting-started.md)
解决路径问题          → [02 - Path Handling](./02-path-handling.md)
提升性能              → [03 - Performance](./03-performance.md)
解决错误              → [04 - Troubleshooting](./04-troubleshooting.md)
```

---

## 🔧 Windows 特殊说明

### 路径格式（最重要）

```powershell
# ✅ 推荐：使用正斜杠
C:/Users/Name/Documents
src/config.json

# ⚠️ 备选：双反斜杠
C:\\Users\\Name\\Documents

# ❌ 避免：单反斜杠
C:\Users\Name\Documents  # \t 可能被解释为制表符
```

### PowerShell vs CMD

```powershell
# ✅ 推荐：PowerShell 7
# 更好的性能
# 跨平台一致性
# 新语法特性

# ⚠️ 备选：Windows PowerShell 5.x
# 系统自带
# 功能较旧

# ❌ 不推荐：CMD
# 功能有限
# 已过时
```

### Windows Terminal

```powershell
# 强烈推荐
winget install Microsoft.WindowsTerminal

# 优势：
- 多标签页
- 更好渲染
- PowerShell 7 集成
- 自定义配置
```

---

## 💡 Windows 最佳实践

### 1. 使用 PowerShell 7

```powershell
# 安装
winget install Microsoft.PowerShell

# 设置为默认
# Windows Terminal → 设置 → PowerShell 7 → 默认配置文件
```

### 2. 配置别名

```powershell
# $PROFILE
function ccode { & 'C:\Users\Name\AppData\Local\Programs\Claude Code\claude.exe' $args }

# 使用
ccode
ccode --session my-project
```

### 3. 环境变量

```powershell
# 永久设置
[System.Environment]::SetEnvironmentVariable('MY_PROJECT', 'D:/Projects', 'User')

# 读取
$env:MY_PROJECT
```

### 4. 使用 Windows Terminal

```json
// settings.json
{
    "profiles": {
        "defaults": {
            "fontFace": "Cascadia Code",
            "fontSize": 12,
            "cursorShape": "filledBox"
        }
    }
}
```

---

## 🔗 与其他指南的关系

### 核心指南（guide/）

所有核心指南都包含 Windows 说明：

```
guide/01-quickstart.md       → Windows 安装章节
guide/02-core-features.md    → 每个功能的 Windows 说明
guide/03-first-project.md    → Windows 特定的命令
```

### 进阶技能（advanced/）

进阶内容也包含 Windows 专门说明：

```
advanced/a-productivity/       → PowerShell 特定技巧
advanced/c-integration/        → Windows 集成注意事项
```

---

## 🆘 获取帮助

### 问题排查顺序

```
1. 查看本指南的 04-Troubleshooting
2. 搜索核心指南的相关章节
3. 查看 reference/troubleshooting.md
4. 搜索官方文档
5. 提交 Issue
```

### 常见问题快速链接

| 问题 | 解决方案 |
|------|---------|
| 路径错误 | [02 - Path Handling](./02-path-handling.md) |
| 权限错误 | [04 - Troubleshooting](./04-troubleshooting.md#权限问题) |
| 性能慢 | [03 - Performance](./03-performance.md) |
| 编码问题 | [04 - Troubleshooting](./04-troubleshooting.md#编码问题) |

---

## ✅ Windows 用户检查清单

### 安装和配置
- [ ] 安装 Claude Code
- [ ] 安装 Windows Terminal
- [ ] 安装 PowerShell 7
- [ ] 配置环境变量
- [ ] 验证安装

### 优化
- [ ] 配置 Windows Terminal
- [ ] 优化 PowerShell 配置
- [ ] 设置常用别名
- [ ] 配置字体和主题

### 学习
- [ ] 理解路径处理
- [ ] 掌握 PowerShell 基础
- [ ] 了解 WSL（如需要）
- [ ] 熟悉常见问题解决

---

## 📊 Windows vs 其他平台

### 功能对比

| 功能 | Windows | macOS | Linux |
|------|---------|-------|-------|
| 基础功能 | ✅ | ✅ | ✅ |
| 性能 | ✅ | ✅ | ✅ |
| 路径处理 | ⚠️ 特殊 | ✅ | ✅ |
| Shell | ⚠️ 多种 | ✅ zsh | ✅ bash |
| 终端 | ⚠️ 推荐 WT | ✅ Terminal | ✅ 多选择 |
| 包管理 | ⚠️ 多种 | ✅ Homebrew | ✅ apt/dnf |

### Windows 特殊之处

```
┌─────────────────────────────────────┐
│  Windows 需要注意的地方              │
│  └─ 路径格式（\ vs /）               │
│  └─ 多种 Shell（CMD/PS/Core）       │
│  └─ 权限系统（UAC）                 │
│  └─ 编码问题（UTF-8 vs GBK）         │
│  └─ 换行符（CRLF vs LF）            │
└─────────────────────────────────────┘
```

---

## 🎉 开始使用

### 新用户

```
1. 阅读 [01 - Getting Started](./01-getting-started.md)
2. 完成安装和配置
3. 阅读 [02 - Path Handling](./02-path-handling.md)
4. 开始使用 Claude Code
```

### 有问题

```
1. 查看 [04 - Troubleshooting](./04-troubleshooting.md)
2. 搜索解决方案
3. 提交 Issue（附上详细日志）
```

---

## 📝 贡献

如果你发现了 Windows 特定的问题或解决方案，欢迎贡献！

详见：请通过 GitHub Issues 或 Pull Requests 提交你的建议。

---

**最后更新**: 2026-01-23
**相关**: [Level 1 核心掌握](../guide/README.md) | [快速参考](../reference/README.md)
