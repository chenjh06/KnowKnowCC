# MCP 服务器配置指南

**项目**: knowknowcc
**文档版本**: 1.0.0
**最后更新**: 2026-02-04
**用途**: 为 knowknowcc 项目配置 MCP 服务器以支持文档验证工作

---

## 📋 概述

本项目已配置多个 MCP（Model Context Protocol）服务器，用于验证官方文档、搜索社区资源和访问 GitHub 仓库。

### 已配置的 MCP 服务器

| 服务器 | 状态 | 用途 | 需要API Key | 免费额度 |
|--------|------|------|-------------|----------|
| **Tavily** | ✅ 已配置 | 网页搜索 | ✅ 是 | 1000次/月 |
| **EXA** | 🔄 待配置 | 高质量搜索 | ✅ 是 | 1000次/月 |
| **GitHub** | 🔄 待配置 | GitHub访问 | ✅ 是 | 5000次/小时 |
| **Jina Reader** | 📋 可选 | 网页读取 | ✅ 是 | 免费 |
| **Read Website Fast** | ✅ 可用 | 快速网页读取 | ❌ 否 | 无限制 |

---

## 🚀 快速开始

### Step 1: 复制示例配置

```bash
# 复制示例配置为实际配置
cp .claude/settings.example.json .claude/settings.json
```

### Step 2: 配置 API Keys

按照下面的说明获取所需的 API Keys，并更新 `.claude/settings.json`。

### Step 3: 验证配置

重启 Claude Code 并测试 MCP 工具。

```bash
# 退出 Claude Code
exit

# 重新启动
claude

# 测试 MCP 工具（在会话中）
# 尝试使用 Tavily 搜索
```

---

## 🔑 API Key 获取指南

### 1. Tavily API Key（必需）

**用途**: 网页搜索，获取最新信息

**获取步骤**:

1. 访问 https://tavily.com
2. 点击 "Sign Up" 注册账号
3. 注册后登录到 https://tavily.com/home/api-key
4. 复制 API Key

**配置方法**:

编辑 `.claude/settings.json`:

```json
{
  "mcpServers": {
    "tavily": {
      "command": "npx",
      "args": ["-y", "@tavily/mcp-server"],
      "env": {
        "TAVILY_API_KEY": "tvly-你的API密钥"
      }
    }
  },
  "env": {
    "TAVILY_API_KEY": "tvly-你的API密钥"
  }
}
```

**免费额度**: 1000 次搜索/月

**文档**: https://docs.tavily.com/docs/tavily-api/introduction

---

### 2. EXA API Key（推荐）

**用途**: 高质量的代码和技术文档搜索

**获取步骤**:

1. 访问 https://console.exa.ai
2. 使用 Google 或 GitHub 账号登录
3. 导航到 "API Keys" 页面
4. 点击 "Create New Key"
5. 复制生成的 API Key

**配置方法**:

编辑 `.claude/settings.json`:

```json
{
  "mcpServers": {
    "exa": {
      "command": "npx",
      "args": ["-y", "@extragon/exa-mcp"],
      "env": {
        "EXA_API_KEY": "你的EXA密钥"
      }
    }
  },
  "env": {
    "EXA_API_KEY": "你的EXA密钥"
  }
}
```

**免费额度**: 1000 次搜索/月

**文档**: https://docs.exa.ai

---

### 3. GitHub Personal Access Token（推荐）

**用途**: 访问 GitHub 仓库、Issues 和文档

**获取步骤**:

1. 访问 https://github.com/settings/tokens
2. 点击 "Generate new token" → "Generate new token (classic)"
3. 设置 Token 名称（例如: "claude-code-knowknowcc"）
4. 选择权限（scopes）:
   - ✅ `repo` (完整仓库访问权限)
   - ✅ `read:org` (读取组织信息)
5. 点击 "Generate token"
6. **重要**: 立即复制 Token（只显示一次！）

**配置方法**:

编辑 `.claude/settings.json`:

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@github/github-mcp-server"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_你的Token"
      }
    }
  },
  "env": {
    "GITHUB_TOKEN": "ghp_你的Token"
  }
}
```

**免费额度**: 5000 次/小时

**文档**: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens

---

### 4. Jina AI API Key（可选）

**用途**: 增强的网页读取能力

**获取步骤**:

1. 访问 https://jina.ai
2. 注册账号
3. 登录后访问 https://cloud.jina.ai/api-keys
4. 创建新的 API Key

**配置方法**:

编辑 `.claude/settings.json`:

```json
{
  "mcpServers": {
    "jina-reader": {
      "command": "npx",
      "args": ["-y", "@jina-ai/mcp-server"],
      "env": {
        "JINA_API_KEY": "你的Jina密钥"
      }
    }
  },
  "env": {
    "JINA_API_KEY": "你的Jina密钥"
  }
}
```

**免费额度**: 需要查看官网最新信息

**文档**: https://jina.ai/reader

---

## ✅ 验证配置

### 方法 1: 检查 MCP 服务器状态

在 Claude Code 会话中：

```bash
# 列出所有可用的 MCP 工具
# （Claude Code 会自动加载已配置的 MCP 服务器）
```

如果配置正确，你应该能看到这些工具：
- `mcp__tavily__webSearchPrime`
- `mcp__exa__web_search_exa`
- `mcp__github__*`
- `mcp__read-website-fast__*`
- `mcp__jina-reader__*`

### 方法 2: 测试搜索功能

在 Claude Code 中测试搜索：

```
使用 Tavily 搜索 "Claude Code 最新特性"
```

如果返回搜索结果，说明配置成功！

---

## 🔧 故障排查

### 问题 1: MCP 工具不可用

**症状**: 找不到 `mcp__` 开头的工具

**可能原因**:
- ❌ `settings.json` 语法错误
- ❌ MCP 服务器未正确配置
- ❌ API Key 无效

**解决方案**:

1. 检查 JSON 语法:
```bash
# 使用 Python 验证 JSON
python -m json.tool .claude/settings.json
```

2. 查看 Claude Code 日志:
```bash
# 日志位置
~/.claude/debug/
```

3. 重新启动 Claude Code:
```bash
exit
claude
```

---

### 问题 2: API Key 错误

**症状**: "401 Unauthorized" 或 "Invalid API Key"

**解决方案**:

1. 验证 API Key 是否正确复制
2. 检查 API Key 是否过期
3. 确认 API Key 有足够的额度
4. 重新生成 API Key 并更新配置

---

### 问题 3: MCP 服务器启动失败

**症状**: 工具调用超时或无响应

**可能原因**:
- ❌ 网络连接问题
- ❌ npx 包下载失败
- ❌ MCP 服务器依赖问题

**解决方案**:

1. 检查网络连接:
```bash
# 测试网络
ping google.com
```

2. 手动安装 MCP 服务器:
```bash
# 手动安装 EXA MCP
npx -y @extragon/exa-mcp
```

3. 清理 npx 缓存:
```bash
# Windows (PowerShell)
npm cache clean --force

# 或删除 npx 缓存目录
rm -rf ~/.npm/_npx
```

---

## 📊 MCP 工具使用建议

### 优先级策略

**主要工具（推荐优先使用）**:

1. **Tavily 搜索** ⭐⭐⭐⭐⭐
   - 用途: 通用搜索，获取最新信息
   - 场景: 搜索官方文档、社区讨论、技术文章

2. **EXA 搜索** ⭐⭐⭐⭐⭐
   - 用途: 高质量代码和技术文档搜索
   - 场景: 搜索 API 文档、代码示例、最佳实践

3. **GitHub MCP** ⭐⭐⭐⭐
   - 用途: 访问 GitHub 仓库和 Issues
   - 场景: 查看源代码、问题讨论、PR

**辅助工具**:

4. **Read Website Fast** ⭐⭐⭐
   - 用途: 快速读取网页内容
   - 场景: 读取在线文档、博客文章

5. **Jina Reader** ⭐⭐
   - 用途: 增强的网页读取
   - 场景: 复杂网页、动态内容

### 使用优化

**批量读取策略**:

```markdown
1. 一次性读取多个相关页面
2. 将重要信息保存到本地文件
3. 避免重复请求相同内容
```

**缓存利用**:

```markdown
1. 使用 Read 工具保存关键信息
2. 避免频繁搜索相同内容
3. 优先使用本地缓存
```

---

## 🔐 安全注意事项

### 保护 API Keys

**✅ 推荐做法**:

- 使用环境变量存储 API Keys
- 将 `settings.json` 添加到 `.gitignore`
- 定期轮换 API Keys
- 使用最小权限原则

**❌ 避免做法**:

- 将 API Keys 提交到 Git 仓库
- 在公开文档中暴露 API Keys
- 与他人共享 API Keys
- 使用生产环境 Keys 用于开发

### .gitignore 配置

项目已配置 `.gitignore` 忽略敏感文件：

```gitignore
# Claude Code 敏感配置
.claude/settings.json
.claude/settings.local.json
```

**提交前检查**:

```bash
# 检查是否有敏感文件被跟踪
git status

# 确认 settings.json 未被添加
git ls-files | grep settings.json
```

---

## 📚 相关资源

### 官方文档

- **Claude Code 官网**: https://claude.ai/code
- **Claude Code 文档**: https://claude.ai/code/docs
- **MCP 协议**: https://modelcontextprotocol.io

### MCP 服务器文档

- **EXA**: https://github.com/modelcontextprotocol/servers/tree/main/src/exa
- **Tavily**: https://github.com/modelcontextprotocol/servers/tree/main/src/tavily
- **GitHub**: https://github.com/modelcontextprotocol/servers/tree/main/src/github
- **Jina Reader**: https://github.com/modelcontextprotocol/servers/tree/main/src/jina
- **Read Website Fast**: https://github.com/just-every/mcp-read-website-fast

### API 提供商

- **EXA Console**: https://console.exa.ai
- **Tavily**: https://tavily.com
- **GitHub Tokens**: https://github.com/settings/tokens
- **Jina AI**: https://jina.ai

---

## 📝 更新日志

### 2026-01-19

**新增**:
- ✨ 创建 MCP 配置指南
- ✨ 添加 API Key 获取说明
- ✨ 配置 5 个 MCP 服务器
- ✨ 添加故障排查章节
- ✨ 创建 .gitignore 保护敏感配置

**更新**:
- 📝 补充安全注意事项
- 📝 添加使用建议和最佳实践

---

## 🆘 需要帮助？

如果遇到问题：

1. **检查日志**: `~/.claude/debug/`
2. **查看文档**: 上面列出的官方文档
3. **验证配置**: 使用 `python -m json.tool` 检查 JSON 语法
4. **重新安装**: 清理缓存并重新安装 MCP 服务器

---

**文档维护**: knowknowcc 项目团队
**最后更新**: 2026-02-04
**文档版本**: 1.0.0
