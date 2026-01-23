# windows 模块 - Windows 专属支持

[根目录](../CLAUDE.md) > **windows**

---

## 模块职责

**Windows 专属支持** - Windows 平台的完整支持和最佳实践

本模块为 Windows 用户提供：
- 快速安装和配置指南
- Windows 特定问题的解决方案
- 性能优化建议
- 与 Windows 工具的集成

---

## 入口与启动

### 首选入口

**主入口**: [README.md](README.md) - Windows 用户专属指南

### 四个专题

```
windows/
├── 01-getting-started.md      ← 入门指南
├── 02-path-handling.md        ← 路径处理（重要！）
├── 03-performance.md          ← 性能优化
└── 04-troubleshooting.md      ← 常见问题
```

---

## 对外接口

### 01 - Getting Started（入门指南）

**文件**: [01-getting-started.md](01-getting-started.md)

**内容**:
- Windows 安装方法（winget、scoop、手动）
- 环境变量配置
- 首次启动和配置
- Windows Terminal 设置
- 验证安装

**适合**: 新安装 Claude Code 的用户

### 02 - Path Handling（路径处理完整指南）

**文件**: [02-path-handling.md](02-path-handling.md)

**内容**:
- Windows 路径格式问题
- 反斜杠 vs 正斜杠
- PowerShell 路径处理
- 环境变量中的路径
- Claude Code 中的路径使用
- 常见路径错误

**适合**: 所有 Windows 用户（**必读**）
**重要性**: ⭐⭐⭐⭐⭐

### 03 - Performance（性能优化）

**文件**: [03-performance.md](03-performance.md)

**内容**:
- Windows Terminal 优化
- PowerShell 7 vs Windows PowerShell 5.x
- WSL 集成
- 性能调优技巧
- 内存和 CPU 优化
- 终端渲染优化

**适合**: 追求最佳性能的用户
**重要性**: ⭐⭐⭐⭐

### 04 - Troubleshooting（常见问题）

**文件**: [04-troubleshooting.md](04-troubleshooting.md)

**内容**:
- 命令找不到
- 权限问题
- 编码问题
- 换行符问题
- 长路径问题
- 兼容性问题

**适合**: 遇到问题的用户
**重要性**: ⭐⭐⭐⭐⭐

---

## 关键依赖与配置

### 平台要求

```
✅ Windows 10 (版本 21H2+)
✅ Windows 11 (所有版本)
⚠️ Windows 8.1 及以下不推荐
```

### 推荐工具

```
必装：
├── Windows Terminal (强烈推荐)
├── PowerShell 7 (跨平台，性能更好)
└─ Claude Code

可选：
├── WSL 2 (Linux 子系统)
├── Git for Windows
└─ Visual Studio Code
```

---

## 数据模型

### 文档结构

```
windows/
├── README.md                   (7KB)  - Windows用户指南
├── 01-getting-started.md       (计划 10-12KB) - 入门指南
├── 02-path-handling.md         (计划 8-10KB)  - 路径处理
├── 03-performance.md           (计划 8-10KB)  - 性能优化
└── 04-troubleshooting.md       (计划 10-12KB) - 常见问题
```

### 内容统计

```
当前状态：框架完成
计划文档数：4 个
预计字数：30,000-40,000 字
```

---

## 测试与质量

### Windows 特殊说明

#### 路径格式（最重要）

```powershell
# ✅ 推荐：使用正斜杠
C:/Users/Name/Documents
src/config.json

# ⚠️ 备选：双反斜杠
C:\\Users\\Name\\Documents

# ❌ 避免：单反斜杠
C:\Users\Name\Documents  # \t 可能被解释为制表符
```

#### PowerShell vs CMD

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

#### Windows Terminal

```powershell
# 强烈推荐
winget install Microsoft.WindowsTerminal

# 优势：
- 多标签页
- 更好渲染
- PowerShell 7 集成
- 自定义配置
```

### 质量标准

所有文档将满足：

- ✅ **完整性**：Windows 特定问题完整覆盖
- ✅ **实战性**：PowerShell 完整示例、真实场景
- ✅ **Windows深度**：不仅说明差异，更提供解决方案
- ✅ **可验证性**：在 Windows 环境测试
- ✅ **可读性**：Windows 用户友好的语言

---

## 常见问题 (FAQ)

### Q1: Windows 和 macOS/Linux 有什么不同？

**A**: 主要差异：

| 功能 | Windows | macOS | Linux |
|------|---------|-------|-------|
| 基础功能 | ✅ | ✅ | ✅ |
| 性能 | ✅ | ✅ | ✅ |
| 路径处理 | ⚠️ 特殊 | ✅ | ✅ |
| Shell | ⚠️ 多种 | ✅ zsh | ✅ bash |
| 终端 | ⚠️ 推荐 WT | ✅ Terminal | ✅ 多选择 |
| 包管理 | ⚠️ 多种 | ✅ Homebrew | ✅ apt/dnf |

### Q2: 我应该使用 PowerShell 还是 CMD？

**A**:
- ✅ **强烈推荐：PowerShell 7**
  - 性能更好
  - 跨平台一致
  - 现代语法
  - Claude Code 示例都用 PS7

- ⚠️ **备选：Windows PowerShell 5.x**
  - 系统自带
  - 功能较旧
  - 仍可使用

- ❌ **不推荐：CMD**
  - 功能有限
  - 已过时
  - 避免使用

### Q3: 路径问题怎么解决？

**A**: 遵循三大原则：

```powershell
# 原则1：使用正斜杠（推荐）✅
cd "D:/Projects/MyApp"

# 原则2：双反斜杠（备选）⚠️
cd "D:\\Projects\\MyApp"

# 原则3：避免单反斜杠（错误）❌
cd "D:\Projects\MyApp"
```

详见：[02-path-handling.md](02-path-handling.md)

### Q4: 需要安装 Windows Terminal 吗？

**A**: **强烈推荐**！

```powershell
# 安装
winget install Microsoft.WindowsTerminal

# 优势：
✅ 多标签页
✅ 更好渲染
✅ PowerShell 7 集成
✅ 自定义配置
✅ 持续更新
```

### Q5: Windows 上的性能如何？

**A**:
- ✅ Claude Code 在 Windows 上性能优秀
- ✅ 使用 PowerShell 7 和 Windows Terminal 可进一步提升
- ✅ 详见 [03-performance.md](03-performance.md) 性能优化建议

### Q6: 遇到问题怎么办？

**A**: 问题排查顺序：

```
1. 查看 04-Troubleshooting
2. 搜索核心指南的相关章节
3. 查看 reference/troubleshooting.md
4. 搜索官方文档
5. 提交 Issue
```

---

## Windows 最佳实践

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

## Windows vs 其他平台

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

### 快速导航

```
我想...
├─ 安装 Claude Code      → [01 - Getting Started](01-getting-started.md)
├─ 解决路径问题          → [02 - Path Handling](02-path-handling.md)
├─ 提升性能              → [03 - Performance](03-performance.md)
└─ 解决错误              → [04 - Troubleshooting](04-troubleshooting.md)
```

---

## 相关文件清单

### 核心文档

- [README.md](README.md) - Windows 用户专属指南

### 专题文档

- [01-getting-started.md](01-getting-started.md) - 入门指南（框架）
- [02-path-handling.md](02-path-handling.md) - 路径处理（框架）
- [03-performance.md](03-performance.md) - 性能优化（框架）
- [04-troubleshooting.md](04-troubleshooting.md) - 常见问题（框架）

### 相关模块

- [guide/](../guide/CLAUDE.md) - Level 1 核心掌握（所有文档含 Windows 支持）
- [advanced/](../advanced/CLAUDE.md) - Level 2 进阶提升（所有文档含 Windows 支持）
- [reference/](../reference/CLAUDE.md) - 快速参考

---

## 变更记录 (Changelog)

### 2026-01-18

**新增**:
- ✨ 创建 windows 模块 CLAUDE.md
- ✨ 添加模块职责说明
- ✨ 添加 Windows 最佳实践
- ✨ 添加常见问题解答

### 2025-01-17

**状态**:
- 📋 框架完成（README.md）
- 📋 详细内容待开发（10%）
- 📋 预计 4 个专题文档

---

## 下一步建议

### 优先级 P0（必须完成）

1. **02-path-handling.md** ⭐⭐⭐⭐⭐
   - Windows 用户痛点
   - 路径问题最常见

2. **04-troubleshooting.md** ⭐⭐⭐⭐⭐
   - 问题快速查找
   - 实用性强

### 优先级 P1（短期规划）

3. **01-getting-started.md** ⭐⭐⭐
4. **03-performance.md** ⭐⭐⭐

---

**最后更新**: 2026-01-18
**模块版本**: Windows v0.10（框架完成）
**维护者**: knowknowcc 项目组
