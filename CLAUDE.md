# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## 项目概述

**knowknowcc（看懂Claude Code）** 是一个 Claude Code 中文知识体系，不是功能手册，而是精心设计的学习体系。

**版本**: v3.7.2 | **跟踪官方**: Claude Code v2.1.84 | **状态**: 100% 完成

### 核心哲学

1. **少即是多** - 精选20%最核心内容，解决80%使用场景
2. **深度胜过广度** - 每个概念都讲透，原理+实践+案例
3. **由浅入深** - Level 1/2/3 三级体系
4. **实战导向** - 真实案例和解决方案
5. **Windows优先** - 100%支持，每个功能都有Windows章节

---

## 架构

```
knowknowcc/
├── guide/              ← Level 1: 核心掌握 (6个文档)
├── advanced/           ← Level 2: 进阶提升 (17个文档)
│   ├── a-productivity/     生产力提升
│   ├── b-code-quality/     代码质量
│   ├── c-integration/      集成扩展
│   └── d-skills-development/ Skills开发
├── master/             ← Level 3: 专家之道 (16个文档)
├── windows/            ← Windows 专属 (4个文档)
└── reference/          ← 快速参考 (3个文档)

总计: 56个核心文档, ~805,000字
```

---

## 内容创建标准

### 五维质量标准

| 维度 | 要求 |
|------|------|
| 完整性 | 是什么、为什么、如何使用、何时使用、注意什么 |
| 实战性 | 真实场景、完整流程、预期结果、常见问题(≥6个) |
| Windows支持 | 专门章节、PowerShell示例、路径说明 |
| 可验证性 | 验证标记、官方核对、实际测试 |
| 可读性 | 简洁明了、段落适中(<10行)、逻辑清晰 |

### 文件命名

```
格式: XX-<descriptive-name>.md

✅ 01-plan-mode.md, 02-session-management.md
❌ feature1.md, PlanMode.md
```

### 路径处理

```markdown
# 文档链接 - 使用相对路径
[快速上手](../guide/01-quickstart.md)  ✅

# Windows路径 - 使用正斜杠
cd "D:/Projects/MyApp"  ✅
cd "D:\\Projects\\MyApp"  ⚠️ 备选
cd "D:\Projects\MyApp"  ❌ 避免单反斜杠
```

### 代码块标记

正确标记语言: `powershell`, `bash`, `typescript`, `json`, `markdown`

---

## 关键配置

- **Git远程**: `https://github.com/chenjh06/KnowKnowCC.git` (HTTPS，非SSH)
- **默认分支**: `main`
- **内存文件**: `C:\Users\cjh\.claude\projects\D--AIWork-claude-code-work-knowknowcc\MEMORY.md`

---

## 相关文件

| 文件 | 用途 |
|------|------|
| README.md | 项目总入口 |
| PROJECT-STATUS.md | 项目状态与待办 |
| CHANGELOG.md | 版本更新日志 |
| MEMORY.md | 跨会话持久化上下文 |

---

## Web搜索策略

1. **open-websearch** (90%): 免费，Bing/DDG/Brave，广度探索
2. **Exa/Tavily** (10%): 付费，深度研究和语义理解

**语言**: 灵活选择中英文，可并行搜索

---

**最后更新**: 2026-03-26
