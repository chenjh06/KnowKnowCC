# web-access Skill 详解

> **给 Claude Code 装上完整联网能力的扩展技能**

**阅读时间**: 20 分钟
**难度**: ⭐⭐⭐
**重要性**: ⭐⭐⭐⭐⭐
**GitHub**: https://github.com/eze-is/web-access
**作者**: 一泽 Eze

---

## 📖 概述

### 什么是 web-access？

**web-access** 是一个为 Claude Code 提供完整联网能力的第三方 Skill。Claude Code 原生有 WebSearch、WebFetch，但缺少：
- **调度策略**：何时用什么工具
- **浏览器自动化**：动态页面、交互操作
- **登录态支持**：访问需要登录的网站

web-access 补上的是：**联网策略 + CDP 浏览器操作 + 站点经验积累**。

### 核心价值

```
❌ 没有 web-access:
├─ 无法访问需要登录的网站
├─ 动态渲染页面内容获取困难
├─ 反爬站点（小红书、微信公众号等）无法处理
└─ 每次都要手动说明联网策略

✅ 使用 web-access:
├─ 直连用户日常 Chrome，天然携带登录态
├─ 支持动态页面、交互操作、视频截帧
├─ 自动选择最优联网工具链
└─ 站点经验积累，越用越聪明
```

---

## 🚀 v2.4 核心能力

| 能力 | 说明 |
|------|------|
| **联网工具自动选择** | WebSearch / WebFetch / curl / Jina / CDP，按场景自主判断 |
| **CDP Proxy 浏览器操作** | 直连用户日常 Chrome，天然携带登录态 |
| **三种点击方式** | `/click`（JS click）、`/clickAt`（CDP 真实鼠标）、`/setFiles`（文件上传） |
| **并行分治** | 多目标时分发子 Agent 并行执行，共享一个 Proxy |
| **站点经验积累** | 按域名存储操作经验，跨 session 复用 |
| **媒体提取** | 从 DOM 直取图片/视频 URL，或对视频任意时间点截帧 |

---

## 📦 安装

### 方式一：让 Claude 自动安装

```
帮我安装这个 skill：https://github.com/eze-is/web-access
```

### 方式二：手动安装

```bash
# Windows PowerShell
git clone https://github.com/eze-is/web-access $env:USERPROFILE\.claude\skills\web-access

# Linux/macOS
git clone https://github.com/eze-is/web-access ~/.claude/skills/web-access
```

---

## ⚙️ 前置配置（CDP 模式）

CDP 模式需要 **Node.js 22+** 和 Chrome 开启远程调试。

### 步骤 1：开启 Chrome 远程调试

1. Chrome 地址栏打开 `chrome://inspect/#remote-debugging`
2. 勾选 **"Allow remote debugging for this browser instance"**
3. 可能需要重启浏览器

### 步骤 2：运行环境检查

```bash
bash ~/.claude/skills/web-access/scripts/check-deps.sh
```

脚本会检查：
- Node.js 版本（需要 22+）
- Chrome 远程调试端口
- CDP Proxy 连接状态

---

## 🔧 工具链详解

### 联网工具选择策略

web-access 遵循 **"确保信息的真实性，一手信息优于二手信息"** 原则。

| 场景 | 工具 | 说明 |
|------|------|------|
| 搜索摘要或关键词结果 | **WebSearch** | 发现信息来源 |
| URL 已知，需要定向提取 | **WebFetch** | 拉取页面，由小模型提取 |
| 需要原始 HTML 源码 | **curl** | meta、JSON-LD 等结构化字段 |
| 非公开/反爬内容 | **CDP 浏览器** | 直接跳过静态层 |
| 需要登录态/交互操作 | **CDP 浏览器** | 天然携带登录态 |

### Jina 预处理（可选）

Jina 是第三方服务，可将网页转为 Markdown，大幅节省 token。

```bash
# 调用方式：URL 前加前缀
r.jina.ai/example.com
```

- **优点**：节省 token
- **限制**：20 RPM，可能有信息损耗
- **适用**：文章、博客、文档、PDF
- **不适用**：数据面板、商品页等非文章结构

---

## 🌐 CDP Proxy API

CDP Proxy 通过 WebSocket 直连 Chrome，提供 HTTP API。

### 基础信息

- **地址**：`http://localhost:3456`
- **启动**：`node ~/.claude/skills/web-access/scripts/cdp-proxy.mjs &`
- **特点**：启动后持续运行，不建议主动停止

### 核心 API 端点

```bash
# 列出已打开的 tab
curl -s http://localhost:3456/targets

# 创建新后台 tab（自动等待加载）
curl -s "http://localhost:3456/new?url=https://example.com"

# 页面信息
curl -s "http://localhost:3456/info?target=ID"

# 执行任意 JS
curl -s -X POST "http://localhost:3456/eval?target=ID" -d 'document.title'

# 截图（含视频当前帧）
curl -s "http://localhost:3456/screenshot?target=ID&file=/tmp/shot.png"

# 导航、后退
curl -s "http://localhost:3456/navigate?target=ID&url=URL"
curl -s "http://localhost:3456/back?target=ID"
```

### 三种点击方式

| 方式 | API | 说明 |
|------|-----|------|
| **JS 点击** | `/click` | `el.click()`，简单快速，覆盖大多数场景 |
| **真实鼠标点击** | `/clickAt` | CDP `Input.dispatchMouseEvent`，能触发文件对话框 |
| **文件上传** | `/setFiles` | 直接设置 file input 路径，绕过文件对话框 |

```bash
# JS 点击
curl -s -X POST "http://localhost:3456/click?target=ID" -d 'button.submit'

# 真实鼠标点击
curl -s -X POST "http://localhost:3456/clickAt?target=ID" -d 'button.upload'

# 文件上传
curl -s -X POST "http://localhost:3456/setFiles?target=ID" \
  -d '{"selector":"input[type=file]","files":["/path/to/file.png"]}'
```

---

## 🧭 浏览哲学

web-access 的核心设计理念：**像人一样思考，兼顾高效与适应性**。

### 四步工作流

```
① 拿到请求 → 定义成功标准
② 选择起点 → 最可能直达的方式
③ 过程校验 → 每一步都是证据
④ 完成判断 → 对照成功标准确认
```

### 程序化 vs GUI 交互

| 方式 | 优点 | 缺点 |
|------|------|------|
| **程序化**（eval 操作 DOM） | 速度快、精确 | 容易触发反爬 |
| **GUI 交互**（点击/滚动） | 确定性最高 | 步骤多、速度慢 |

**策略**：当程序化方式受阻时，GUI 交互是可靠的兜底。

---

## 🔄 并行调研：子 Agent 分治

当任务包含多个**独立**调研目标时，web-access 支持分治给子 Agent 并行执行。

### 好处

- **速度**：多子 Agent 并行，总耗时 ≈ 单个子任务时长
- **上下文保护**：抓取内容不进入主 Agent 上下文

### 分治判断标准

| 适合分治 | 不适合分治 |
|----------|-----------|
| 目标相互独立 | 目标有依赖关系 |
| 每个子任务量足够大 | 简单单页查询 |
| 需要 CDP 浏览器 | 几次 WebSearch 就能完成 |

### 子 Agent Prompt 写法

```
# ✅ 正确：目标导向
"获取这三个产品的官网信息"

# ❌ 错误：步骤指令（暗示执行方式）
"搜索这三个产品的官网"
```

**关键**：必须在子 Agent prompt 中写 `必须加载 web-access skill 并遵循指引`。

---

## 📚 站点经验系统

web-access 支持按域名积累操作经验。

### 存储位置

```
~/.claude/skills/web-access/references/site-patterns/
├── xiaohongshu.md    # 小红书
├── weixin.md         # 微信公众号
└── ...
```

### 经验文件格式

```markdown
---
domain: example.com
aliases: [示例, Example]
updated: 2026-03-27
---
## 平台特征
架构、反爬行为、登录需求、内容加载方式等

## 有效模式
已验证的 URL 模式、操作策略、选择器

## 已知陷阱
什么会失败以及为什么
```

### 使用流程

1. 确定目标网站后，检查是否有对应经验文件
2. 读取经验获取先验知识
3. 如果发现新模式，主动更新经验文件

---

## 💡 使用示例

### 示例 1：搜索最新信息

```
帮我搜索 Claude Code 最新版本更新
```

web-access 会自动：
1. 使用 WebSearch 发现信息来源
2. 定位一手来源（官网、官方博客）
3. 返回核实后的信息

### 示例 2：访问需要登录的网站

```
去小红书搜索 xxx 的账号
```

web-access 会自动：
1. 检测到小红书是反爬站点
2. 启动 CDP 模式直连用户 Chrome
3. 利用已有的登录态访问

### 示例 3：并行调研多个产品

```
同时调研这 5 个产品的官网，给我对比摘要
```

web-access 会自动：
1. 分治给 5 个子 Agent
2. 并行获取各产品信息
3. 汇总返回对比摘要

### 示例 4：发布内容到平台

```
帮我在创作者平台发一篇图文
```

web-access 会自动：
1. 使用 CDP 模式打开创作者平台
2. 通过 GUI 交互完成发布流程
3. 处理可能的弹窗和确认

---

## ⚠️ 注意事项

### 技术事实

1. **页面存在大量隐藏内容**：轮播非当前帧图片、折叠区块文字、懒加载占位元素等存在于 DOM 中但不可见
2. **滚动触发懒加载**：提取图片 URL 前应先滚动到底部
3. **站点内 URL 更可靠**：站点生成的链接自带完整上下文，手动构造可能缺失参数
4. **平台错误提示不可信**："内容不存在"可能是访问方式问题，而非内容本身问题

### 安全建议

1. **最小侵入**：不主动操作用户已有 tab，所有操作在后台 tab 进行
2. **环境整洁**：任务完成后关闭自己创建的 tab
3. **Proxy 持续运行**：不建议主动停止，重启需 Chrome 重新授权

---

## 🔗 相关资源

### 官方资源

- [GitHub 仓库](https://github.com/eze-is/web-access)
- [介绍文章：Web Access：一个 Skill，拉满 Agent 联网和浏览器能力](https://mp.weixin.qq.com/s/rps5YVB6TchT9npAaIWKCw)

### 本项目相关文档

- [01-skill-fundamentals.md](./01-skill-fundamentals.md) - Skills 基础概念
- [official-skills-guide.md](./official-skills-guide.md) - 官方 Skills 文档
- [06-skills-best-practices.md](./06-skills-best-practices.md) - Skills 最佳实践

---

## 📊 总结

### web-access vs 原生工具

| 能力 | 原生工具 | web-access |
|------|---------|------------|
| WebSearch | ✅ | ✅ |
| WebFetch | ✅ | ✅ |
| 登录态支持 | ❌ | ✅ |
| 动态页面 | ❌ | ✅ |
| 反爬站点 | ❌ | ✅ |
| 浏览器自动化 | ❌ | ✅ |
| 站点经验积累 | ❌ | ✅ |

### 何时使用 web-access

- ✅ 需要访问需要登录的网站
- ✅ 需要处理反爬站点（小红书、微信公众号等）
- ✅ 需要浏览器自动化操作
- ✅ 需要并行调研多个目标
- ✅ 需要像人一样在网页中导航

### 何时不需要 web-access

- 简单的网页抓取（原生 WebFetch 足够）
- 不需要登录态的公开信息
- 静态页面内容提取

---

**最后更新**: 2026-03-27
**文档版本**: v1.0
**Skill 版本**: v2.4
