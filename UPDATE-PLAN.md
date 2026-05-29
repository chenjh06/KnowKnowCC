# KnowKnowCC 版本追赶计划

**创建日期**: 2026-05-29
**当前跟踪**: Claude Code v2.1.91 | **目标最新**: v2.1.156
**待处理版本数**: 54 个 | **计划批次数**: 12

---

## 信息密度分析

| 密度 | 说明 | 版本数 |
|------|------|--------|
| **S** (30+条) | 超大版本，含多个新功能 | 13 |
| **A** (15-29条) | 大版本，含新功能+修复 | 5 |
| **C** (1-4条) | 纯修复，无新功能 | 8 |

**关键规则**:
- S级版本单独一批或与C级合批
- A级版本最多2个一批
- C级版本合并到前后的S/A级批次
- 每批只关注"影响知识库的功能性变更"，跳过纯bug fix

---

## 分批方案

### 第1批: v2.1.92
- **版本**: v2.1.92 (A, 21条, 2026-04-04)
- **核心主题**: `/cost` 成本追踪、seccomp 安全策略、会话命名
- **工作量**: 低
- **知识库影响**: reference/commands.md, master/安全文档
- **知知版本**: v3.12.0

### 第2批: v2.1.94 ~ v2.1.98
- **版本**: v2.1.94(A), v2.1.96(C), v2.1.97(S), v2.1.98(C)
- **核心主题**: Skills frontmatter 扩展、`/effort` 改进、Mantle 支持
- **工作量**: 中
- **知识库影响**: advanced/d-skills-development/, reference/commands.md
- **知知版本**: v3.13.0

### 第3批: v2.1.100 ~ v2.1.105
- **版本**: v2.1.100(C), v2.1.101(S), v2.1.104(C), v2.1.105(S)
- **核心主题**: Plugin 系统、enterprise managed settings、MCP 增强
- **工作量**: 中高
- **知识库影响**: master/01-customization/, master/03-advanced-topics/plugins.md
- **知知版本**: v3.14.0

### 第4批: v2.1.107 ~ v2.1.114
- **版本**: v2.1.107~v2.1.113(C×7) + v2.1.110(S) + v2.1.114(C)
- **核心主题**: Background Agents、Chrome 集成、auto mode
- **工作量**: 中（大部分C级可跳过）
- **知识库影响**: advanced/a-productivity/, advanced/c-integration/
- **知知版本**: v3.15.0

### 第5批: v2.1.116 ~ v2.1.123
- **版本**: v2.1.116~v2.1.117(C×2) + v2.1.118(S) + v2.1.119~v2.1.123(C×4+1)
- **核心主题**: Agent Teams、PowerShell 增强、Vim 模式
- **工作量**: 中
- **知识库影响**: advanced/a-productivity/agent-teams.md, windows/
- **知知版本**: v3.16.0

### 第6批: v2.1.126 ~ v2.1.133
- **版本**: v2.1.126(C), v2.1.128(S), v2.1.129~v2.1.132(C×4), v2.1.133(A)
- **核心主题**: `/usage` 改进、Session 恢复、Managed MCP
- **工作量**: 中
- **知知版本**: v3.17.0

### 第7批: v2.1.136 ~ v2.1.140
- **版本**: 全C (5个纯修复版本)
- **核心主题**: Windows IDE 修复、稳定性
- **工作量**: 低（大部分可跳过，仅需更新版本号）
- **知知版本**: v3.18.0

### 第8批: v2.1.141 ~ v2.1.143 ⚠️ 大批
- **版本**: v2.1.141(S, 61条), v2.1.142(A, 24条), v2.1.143(S, 33条)
- **核心主题**: Plugin Marketplace、Agent JSON 输出、OTEL、大量 Windows 修复
- **工作量**: 高
- **知识库影响**: master/03-advanced-topics/plugins.md, windows/
- **知知版本**: v3.19.0

### 第9批: v2.1.144 ~ v2.1.146 ⚠️ 大批
- **版本**: v2.1.144(S, 50条), v2.1.145(C), v2.1.146(C)
- **核心主题**: `/simplify`→`/code-review` 重命名、disallowed-tools、MessageDisplay hook
- **工作量**: 高
- **知识库影响**: reference/commands.md, master/01-customization/hooks.md
- **知知版本**: v3.20.0

### 第10批: v2.1.147 ⚠️ 超大 — Opus 4.8 + Workflows
- **版本**: v2.1.147 (S, 33条重磅功能)
- **核心主题**: **Opus 4.8 发布**、**Dynamic Workflows 系统**、Fast Mode、lean prompt 默认
- **工作量**: 高
- **知识库影响**: 可能需**新增** Workflows 文档, 更新多个模块
- **知知版本**: v4.0.0（重大更新）

### 第11批: v2.1.148 ~ v2.1.150
- **版本**: v2.1.148(C), v2.1.149(A, 26条), v2.1.150(C)
- **核心主题**: Background Sessions 重构、pinned sessions、/model 改进
- **工作量**: 中高
- **知识库影响**: advanced/a-productivity/session-management.md
- **知知版本**: v4.1.0

### 第12批: v2.1.152 ~ v2.1.156（收尾）
- **版本**: v2.1.152(S), v2.1.153(S), v2.1.154(S), v2.1.156(C)
- **核心主题**: /usage 分类明细、安全修复、Opus 4.8 最终完善
- **工作量**: 高
- **知识库影响**: reference/commands.md, 全局版本号更新
- **知知版本**: v4.2.0

---

## 执行流程（每批）

```
1. 读取 context seed → 恢复工作上下文
2. 抓取该批版本的 GitHub release notes
3. 过滤: 只关注"影响知识库的功能性变更"
4. 确定需要更新/新增的文档
5. 更新文档内容
6. 更新 CHANGELOG.md
7. 更新 PROJECT-STATUS.md 版本号
8. 在 KnowKnowCC/ 内 git commit
9. 压缩上下文 (/compact)
10. 下一批
```

## 版本号映射

知知版本递增规则：
- 常规批次: +0.1
- 重大新主题（如 Workflows）: +1.0
- 路径: v3.11.0 → v3.12.0 → ... → v3.20.0 → **v4.0.0** (第10批) → v4.1.0 → v4.2.0

---

## 信息来源

| 来源 | URL | 用途 |
|------|-----|------|
| GitHub Releases | https://github.com/anthropics/claude-code/releases | 版本详情（首选） |
| Official Changelog | https://code.claude.com/docs/en/changelog | 官方文档 |
| claudefa.st | https://claudefa.st/blog/guide/changelog | 第三方完整记录 |

---

**最后更新**: 2026-05-29
