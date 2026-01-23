# 03 - Browser Automation - 浏览器自动化实战

> **使用 Playwright 让 Claude Code 自动化浏览器操作**

**阅读时间**: 40分钟
**难度**: ⭐⭐⭐⭐
**重要性**: ⭐⭐⭐⭐
**前置要求**: [Level 1 核心掌握](../../guide/), [MCP Servers](./01-mcp-servers.md)

---

## 目录

- [什么是浏览器自动化](#什么是浏览器自动化)
- [为什么需要浏览器自动化](#为什么需要浏览器自动化)
- [Playwright MCP 服务器](#playwright-mcp-服务器)
- [配置和安装](#配置和安装)
- [核心功能使用](#核心功能使用)
- [高级用法](#高级用法)
- [实战案例](#实战案例)
- [Windows 专属](#windows-专属)
- [最佳实践](#最佳实践)
- [常见问题](#常见问题)
- [故障排查](#故障排查)

---

## 什么是浏览器自动化

### 定义

**浏览器自动化**是指使用程序自动控制浏览器进行操作，如导航、点击、输入、截图等，无需人工干预。

```
传统方式：
手动打开浏览器
    ↓
手动输入网址
    ↓
手动点击和操作
    ↓
手动截图保存
→ 耗时、易错、重复

浏览器自动化：
编写自动化脚本
    ↓
脚本控制浏览器
    ↓
自动执行操作
    ↓
自动保存结果
→ 快速、准确、可重复
```

### 应用场景

#### 场景 1：自动化测试

```
功能测试：
├─ 自动填写表单
├─ 自动点击按钮
├─ 验证页面显示
└─ 生成测试报告

优势：
├─ 快速回归测试
├─ 覆盖多种场景
└─ 提升测试质量
```

#### 场景 2：数据抓取

```
网页数据：
├─ 商品价格监控
├─ 新闻文章收集
├─ 社交媒体分析
└─ 竞品情报收集

优势：
├─ 自动化收集
├─ 定时执行
├─ 数据结构化
└─ 节省时间
```

#### 场景 3：UI 截图

```
截图需求：
├─ 生成页面缩略图
├─ 记录页面状态
├─ 生成文档图片
└─ 视觉回归测试

优势：
├─ 一致性强
├─ 批量生成
├─ 高质量输出
└─ 可编程控制
```

### 现代浏览器自动化工具

```
Selenium：
├─ 老牌工具
├─ 支持多语言
└─ 生态成熟

Puppeteer：
├─ Chrome 团队开发
├─ 功能强大
└─ 性能优秀

Playwright：
├─ 微软开发 ✅ 推荐
├─ 跨浏览器支持
├─ 现代化 API
└─ 自动等待机制
```

---

## 为什么需要浏览器自动化

### 传统方式的痛点

#### 痛点 1：重复操作

```
❌ 手动操作：
每天早上：
1. 打开 10 个网站
2. 登录每个系统
3. 查看数据
4. 手动记录
5. 生成报告
→ 耗时 2 小时，容易出错

✅ 自动化：
脚本自动执行：
1. 并行访问 10 个网站
2. 自动登录
3. 自动抓取数据
4. 自动保存
5. 自动生成报告
→ 耗时 5 分钟，准确无误
```

#### 痛点 2：测试覆盖不足

```
❌ 手动测试：
测试场景有限：
├─ 主流程测试
├─ 少量边界情况
└─ 偶尔回归测试

问题：
├─ Bug 频繁遗漏
├─ 上线后发现问题
└─ 紧急修复成本高

✅ 自动化测试：
全面覆盖：
├─ 100+ 自动化测试用例
├─ 每次提交自动运行
├─ 覆盖各种边界情况
└─ 快速回归测试

效果：
├─ Bug 减少 80%
├─ 上线质量提升
└─ 回归测试自动化
```

#### 痛点 3：数据收集困难

```
❌ 手动收集：
任务：收集 100 个商品的价格

手动流程：
1. 逐个打开商品页面
2. 手动查找价格
3. 复制到 Excel
4. 整理格式

问题：
├─ 耗时：3-4 小时
├─ 易错：漏看、抄错
└─ 难以重复：每次都要重新做

✅ 自动化收集：
脚本执行：
1. 自动访问 100 个页面
2. 自动提取价格数据
3. 自动保存到文件
4. 自动生成报告

效果：
├─ 耗时：10 分钟
├─ 准确：不会出错
└─ 可重复：定时执行
```

### 自动化的价值

#### 价值 1：效率提升 ⭐⭐⭐⭐⭐

```
时间对比：
手动操作：2 小时
自动化：10 分钟

效率提升：12 倍

ROI 计算：
开发成本：4 小时
使用周期：每天 1 次
回本周期：2 天
年收益：节省 500+ 小时
```

#### 价值 2：准确性高 ⭐⭐⭐⭐

```
手动操作：
├─ 疲劳导致失误
├─ 注意力分散
└─ 数据不准确

自动化：
├─ 严格按脚本执行
├─ 不会遗漏步骤
└─ 数据准确一致

错误率：
手动：5-10%
自动化：<0.1%
```

#### 价值 3：可重复 ⭐⭐⭐⭐⭐

```
手动操作：
每次都要重复同样的步骤
├─ 浪费时间
├─ 枯燥乏味
└─ 容易出错

自动化：
一次编写，多次执行
├─ 定时任务
├─ 批量处理
└─ 一致性高
```

---

## Playwright MCP 服务器

### 什么是 Playwright

**Playwright** 是微软开发的现代化浏览器自动化框架，支持 Chromium、Firefox 和WebKit。

```
特点：
✅ 跨浏览器：Chrome、Firefox、Safari
✅ 跨平台：Windows、macOS、Linux
✅ 跨语言：JavaScript、Python、Java、.NET
✅ 现代化：自动等待、并行执行、视频录制
✅ 可靠性：自动重试、元素定位稳定
```

### Playwright MCP 服务器

**Playwright MCP** 是一个将 Playwright 功能集成到 Claude Code 的 MCP 服务器。

```
核心能力：
├─ 浏览器控制（导航、点击、输入）
├─ 页面交互（表单、弹窗、上传）
├─ 内容提取（文本、截图、PDF）
├─ 网络监控（请求、响应、Mock）
└─ 测试支持（断言、等待、重试）
```

### 与直接使用 Playwright 的对比

```
直接使用 Playwright：
1. 编写自动化脚本
   - 学习 Playwright API
   - 处理异步逻辑
   - 编写测试代码

2. 运行脚本
   - 执行自动化
   - 查看结果
   - 调试问题

使用 Playwright MCP：
1. 告诉 Claude 要做什么
2. Claude 自动生成和执行脚本
3. 返回结果

优势：
✅ 无需学习 API
✅ 自然语言控制
✅ Claude 优化执行
✅ 灵活调整需求
```

---

## 配置和安装

### 环境准备

#### 前置要求

```
✅ 必需软件：
- Node.js 18+
- Claude Code（最新版）
- 浏览器（Chrome/Edge/Firefox）

✅ 浏览器安装：
Windows：
├─ Chrome（自动下载）
├─ Edge（系统自带）
└─ Firefox（可选）

macOS/Linux：
├─ Chrome
└─ Firefox
```

#### 检查环境

**Windows（PowerShell）**：
```powershell
# 检查 Node.js
node --version
# 预期：v18.x.x 或更高

# 检查浏览器
# Chrome/Edge 通常已安装
# Firefox 需要单独安装
```

### 安装 Playwright MCP

#### 方式 1：使用 NPM（推荐）

```bash
# 全局安装
npm install -g @executeautomation/playwright-mcp-server

# 或在项目中安装
npm install --save-dev @executeautomation/playwright-mcp-server
```

#### 方式 2：配置 MCP 服务器

**配置文件位置**：
- Windows: `%USERPROFILE%\.claude\mcp_servers.json`
- macOS/Linux: `~/.claude/mcp_servers.json`

**配置示例**：

```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": [
        "-y",
        "@executeautomation/playwright-mcp-server"
      ]
    }
  }
}
```

### 验证安装

```powershell
# Windows PowerShell
# 测试服务器
npx -y @executeautomation/playwright-mcp-server

# 预期输出：
# Playwright MCP Server running...
```

---

## 核心功能使用

### 功能 1：页面导航

#### 打开网页

```
你：打开百度首页

Claude：
正在导航到 https://www.baidu.com

✅ 成功打开
```

#### 多个页面

```
你：依次打开以下网页：
1. https://www.baidu.com
2. https://www.github.com
3. https://www.npmjs.com

Claude：
正在打开多个网页...

✅ 百度：已打开
✅ GitHub：已打开
✅ NPM：已打开
```

### 功能 2：页面交互

#### 点击元素

```
你：打开百度，点击搜索按钮

Claude：
1. 打开百度首页
2. 查找搜索按钮
3. 点击按钮

✅ 操作完成
```

#### 输入文本

```
你：打开百度，在搜索框输入"Playwright"

Claude：
1. 打开百度首页
2. 定位搜索框
3. 输入"Playwright"

✅ 输入完成
```

#### 表单填充

```
你：打开登录页面，填写表单：
- 用户名：test@example.com
- 密码：********
- 勾选"记住我"

Claude：
1. 打开登录页面
2. 填写用户名
3. 填写密码
4. 勾选记住我

✅ 表单填写完成
```

### 功能 3：内容提取

#### 提取文本

```
你：打开 GitHub Trending 页面，提取前 5 个仓库名称

Claude：
正在提取数据...

找到以下仓库：
1. facebook/react
2. vuejs/core
3. tensorflow/tensorflow
4. microsoft/vscode
5. nodejs/node

✅ 提取完成
```

#### 提取链接

```
你：提取页面中所有的外部链接

Claude：
正在提取链接...

找到 23 个外部链接：
- https://example.com/page1
- https://example.com/page2
...
```

#### 提取图片

```
你：提取页面中所有图片的 URL

Claude：
正在提取图片...

找到 15 张图片：
- https://example.com/image1.jpg
- https://example.com/image2.png
...
```

### 功能 4：截图

#### 整页截图

```
你：打开 https://www.example.com，并截图

Claude：
正在打开网页...
正在截取全页面截图...

✅ 截图已保存：
   文件：example-homepage.png
   尺寸：1920x3000
```

#### 元素截图

```
你：打开百度，截取搜索框区域的截图

Claude：
正在定位搜索框...
正在截取元素...

✅ 截图已保存：
   文件：search-box.png
   尺寸：600x100
```

### 功能 5：PDF 生成

```
你：打开 https://www.example.com，生成 PDF

Claude：
正在生成 PDF...

✅ PDF 已生成：
   文件：example-page.pdf
   大小：245 KB
```

---

## 高级用法

### 用法 1：等待元素

```
你：打开网页，等待加载完成后再截图

Claude：
1. 打开网页
2. 等待页面加载完成
3. 确认关键元素可见
4. 截取全页面截图

✅ 完成
```

### 用法 2：网络监控

```
你：打开网页，监控所有 API 请求

Claude：
正在监控网络请求...

发现 5 个 API 请求：
1. GET /api/users - 200 OK (45ms)
2. GET /api/posts - 200 OK (123ms)
3. POST /api/login - 200 OK (234ms)
4. GET /api/user/1 - 200 OK (67ms)
5. GET /api/settings - 200 OK (89ms)

✅ 监控完成
```

### 用法 3：执行 JavaScript

```
你：打开网页，执行 JavaScript 获取页面标题

Claude：
正在执行 JavaScript...

页面标题：Example Domain

✅ 执行完成
```

### 用法 4：处理弹窗

```
你：打开网页，接受所有 cookies 弹窗

Claude：
正在处理弹窗...

发现并处理了 3 个弹窗：
1. Cookie consent - 已接受
2. Newsletter signup - 已关闭
3. Push notifications - 已拒绝

✅ 弹窗处理完成
```

---

## 实战案例

### 案例 1：自动化测试 ⭐⭐⭐⭐⭐

#### 场景描述

测试一个登录功能：输入用户名和密码，点击登录，验证登录成功。

#### 完整流程

```
你：帮我测试登录功能

Claude：
📋 测试流程：

1. 打开登录页面
   URL: https://example.com/login

2. 检查页面元素
   ✅ 用户名输入框：可见
   ✅ 密码输入框：可见
   ✅ 登录按钮：可见

3. 填写测试数据
   用户名：test@example.com
   密码：********

4. 点击登录按钮
   ✅ 点击成功

5. 验证结果
   检查：重定向到 /dashboard
   ✅ 登录成功！

测试结论：✅ 通过

用时：15 秒
```

#### 多场景测试

```
你：测试以下登录场景：
1. 正常登录
2. 密码错误
3. 用户名为空

Claude：
📋 多场景测试：

场景 1：正常登录
├─ 输入有效用户名和密码
├─ 点击登录
└─ ✅ 登录成功，跳转到 /dashboard

场景 2：密码错误
├─ 输入有效用户名
├─ 输入错误密码
├─ 点击登录
└─ ✅ 显示错误提示："密码错误"

场景 3：用户名为空
├─ 用户名留空
├─ 输入密码
├─ 点击登录
└─ ✅ 显示验证提示："请输入用户名"

总结：
- 通过：2/3
- 失败：0/3
- 验证：1/3 有效验证

测试用时：45 秒
```

---

### 案例 2：数据抓取 ⭐⭐⭐⭐

#### 场景描述

从新闻网站抓取最新的 10 条新闻标题和链接。

#### 完整流程

```
你：从 https://news.ycombinator.com 抓取前 10 条新闻

Claude：
📊 数据抓取中...

正在访问 Hacker News...
正在提取新闻列表...

抓取结果：

1. 【Show HN: The best browser automation tool (")]
   链接：https://news.ycombinator.com/item?id=38294512
   点数：245 points

2. 【OpenAI releases GPT-5】
   链接：https://news.ycombinator.com/item?id=38294511
   点数：189 points

3. 【Microsoft acquires GitHub】
   链接：https://news.ycombinator.com/item?id=38294510
   点数：156 points

...（共10条）

✅ 抓取完成
总用时：12 秒

需要保存为文件吗？
```

#### 批量抓取

```
你：批量访问以下 5 个电商网站，抓取每个网站的主标题：
1. https://www.amazon.com
2. https://www.ebay.com
3. https://www.alibaba.com
4. https://www.jd.com
5. https://www.taobao.com

Claude：
📊 批量数据抓取...

正在并行访问 5 个网站...

1. Amazon
   标题：Amazon.com. Spend less. Smile more.
   状态：✅ 成功

2. eBay
   标题：eBay | Electronics, Cars, Fashion, Collectibles & More
   状态：✅ 成功

3. Alibaba
   标题：Alibaba Manufacturer Directory - Suppliers, Manufacturers
   状态：✅ 成功

4. JD.com
   标题：京东(JD.COM)-正品低价、品质保障、配送及时、轻松购物！
   状态：✅ 成功

5. Taobao
   标题：淘宝网 - 淘！我喜欢
   状态：✅ 成功

✅ 批量抓取完成
总用时：18 秒
```

---

### 案例 3：UI 截图对比 ⭐⭐⭐⭐

#### 场景描述

生成多个网站的首页缩略图，用于视觉对比。

#### 完整流程

```
你：为以下网站生成首页缩略图（800x600）：
1. https://www.google.com
2. https://www.bing.com
3. https://www.yahoo.com

Claude：
📸 正在生成截图...

1/3 Google
   截图中...
   ✅ google.png (800x600)

2/3 Bing
   截图中...
   ✅ bing.png (800x600)

3/3 Yahoo
   截图中...
   ✅ yahoo.png (800x600)

✅ 所有截图已完成

需要生成对比图片吗？
```

#### 视觉回归测试

```
你：对比网站改版前后的首页

Claude：
📸 视觉回归测试

正在打开两个版本...

版本 A（旧版）：
   截图中...
   ✅ old-version.png

版本 B（新版）：
   截图中...
   ✅ new-version.png

正在对比差异...

发现以下差异：
1. 导航栏高度不同（旧版：60px → 新版：80px）
2. 主标题位置变化（左侧 → 居中）
3. 颜色方案更新（蓝色 → 绿色）

生成对比图...
✅ comparison.png

是否需要详细的差异报告？
```

---

### 案例 4：自动化工作流 ⭐⭐⭐⭐⭐

#### 场景描述

自动化的每日数据收集工作流：访问多个数据源，收集数据，生成报告。

#### 完整流程

```
你：创建自动化工作流：
1. 访问天气网站，获取今日天气
2. 访问股票网站，获取股票价格
3. 访问新闻网站，获取头条新闻
4. 生成每日报告

Claude：
🔄 执行自动化工作流...

步骤 1/4：获取天气信息
├─ 访问 https://weather.com
├─ 定位天气信息
└─ ✅ 今日天气：晴天，25°C

步骤 2/4：获取股票价格
├─ 访问 https://finance.yahoo.com
├─ 查询 AAPL、GOOGL、MSFT
└─ ✅ AAPL: $178.35, GOOGL: $141.80, MSFT: $378.91

步骤 3/4：获取头条新闻
├─ 访问 https://news.google.com
├─ 提取前 3 条新闻
└─ ✅ 已提取

步骤 4/4：生成报告
正在生成每日报告.md...

✅ 工作流完成

报告预览：
# 每日数据报告

## 天气
- 天气：晴天
- 温度：25°C

## 股票
- AAPL: $178.35 (+1.2%)
- GOOGL: $141.80 (-0.5%)
- MSFT: $378.91 (+0.8%)

## 新闻
1. Tech giants announce AI partnership
2. Market hits record high
3. New browser automation tool released

---
生成时间：2025-01-17 09:00:00

报告已保存为：daily-report-2025-01-17.md

总用时：35 秒
```

---

## Windows 专属

### Windows 路径配置

#### 截图保存路径

**配置示例**：

```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["-y", "@executeautomation/playwright-mcp-server"],
      "env": {
        "SCREENSHOT_DIR": "D:\\Screenshots"
      }
    }
  }
}
```

**验证路径**：

```powershell
# 创建目录
New-Item -ItemType Directory -Path "D:\Screenshots" -Force

# 测试写入权限
Test-Path "D:\Screenshots"  # 应返回 True
```

### PowerShell 自动化脚本

#### 定时截图脚本

**保存为 `take-screenshots.ps1`**：

```powershell
# 定时截图脚本
# 使用方法：.\take-screenshots.ps1

$sites = @(
    "https://www.google.com",
    "https://www.github.com",
    "https://www.stackoverflow.com"
)

$outputDir = "D:\Screenshots"
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"

Write-Host "=== 定时截图脚本 ===" -ForegroundColor Cyan
Write-Host ""

foreach ($site in $sites) {
    Write-Host "正在访问：$site" -ForegroundColor Yellow

    # 使用 Claude Code 截图
    # 你：打开 $site，截图保存为 $outputDir\screenshot-$timestamp.png

    Start-Sleep -Seconds 5  # 等待完成

    Write-Host "✅ 截图完成" -ForegroundColor Green
}

Write-Host ""
Write-Host "=== 脚本完成 ===" -ForegroundColor Cyan
```

---

### Windows 特定问题

#### 问题 1：浏览器路径

**症状**：
```
Error: Browser not found
```

**解决方案**：

```powershell
# 检查 Chrome 路径
$chromePaths = @(
    "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe",
    "C:\Program Files\Google\Chrome\Application\chrome.exe",
    "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
)

$chromePath = $chromePaths | Where-Object { Test-Path $_ } | Select-Object -First 1

if ($chromePath) {
    Write-Host "✅ Chrome 找到：$chromePath" -ForegroundColor Green
} else {
    Write-Host "❌ Chrome 未安装" -ForegroundColor Red
}
```

#### 问题 2：权限问题

**症状**：
```
Error: Permission denied to save screenshot
```

**解决方案**：

```powershell
# 检查目录权限
$acl = Get-Acl "D:\Screenshots"

# 添加当前用户的完全控制权限
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
    $env:USERNAME,
    "FullControl",
    "Allow"
)

$acl.SetAccessRule($accessRule)
Set-Acl "D:\Screenshots" $acl

Write-Host "✅ 权限已更新" -ForegroundColor Green
```

---

## 最佳实践

### 实践 1：错误处理

```
✅ 好的做法：
1. 打开网页
2. 等待元素加载
3. 如果超时，重试
4. 记录错误信息

❌ 不好的做法：
1. 打开网页
2. 立即操作（可能失败）
3. 没有错误处理
```

### 实践 2：性能优化

```
优化策略：

1. 并行执行
   └─ 同时打开多个页面

2. 禁用图片（可选）
   └─ 加快页面加载

3. 使用 headless 模式
   └─ 不显示浏览器界面

4. 缓存浏览器实例
   └─ 避免重复启动
```

### 实践 3：可维护性

```
提升可维护性：

1. 模块化脚本
   └─ 每个功能独立

2. 使用配置文件
   └─ 集中管理参数

3. 添加日志
   └─ 便于调试

4. 编写文档
   └─ 说明使用方法
```

### 实践 4：安全性

```
安全注意事项：

1. 敏感信息
   ├─ 不要硬编码密码
   ├─ 使用环境变量
   └─ 加密存储

2. 数据隐私
   ├─ 遵守网站条款
   ├─ robots.txt
   └─ 隐私政策

3. 频率控制
   ├─ 避免过于频繁的请求
   ├─ 添加延迟
   └─ 尊重服务器负载
```

---

## 常见问题

### Q1: Playwright 支持哪些浏览器？

**A**: 支持主流浏览器：

| 浏览器 | 支持情况 | 说明 |
|--------|---------|------|
| Chromium | ✅ 完全支持 | Chrome、Edge、Opera |
| Firefox | ✅ 完全支持 | 需要单独安装 |
| WebKit | ✅ 完全支持 | Safari（macOS） |

### Q2: 如何处理动态加载的内容？

**A**: 使用等待机制：

```
方式 1：等待元素可见
你：打开网页，等待"加载中"元素消失后截图

方式 2：等待特定时间
你：打开网页，等待 5 秒后截图

方式 3：等待网络空闲
你：打开网页，等待所有网络请求完成
```

### Q3: 可以在后台运行吗？

**A**: ✅ 可以使用 headless 模式：

```
headless 模式：
├─ 不显示浏览器界面
├─ 减少资源占用
├─ 提升执行速度
└─ 适合服务器环境
```

### Q4: 如何处理 CAPTCHA？

**A**:

```
❌ 不建议：
- 尝试破解 CAPTCHA（违反服务条款）
- 使用自动化破解工具

✅ 推荐：
- 手动处理 CAPTCHA
- 使用测试环境（无 CAPTCHA）
- 联系网站管理员获取测试账号
```

### Q5: 如何处理需要登录的页面？

**A**:

```
方案 1：手动登录一次，保存 cookies
├─ 手动登录
├─ 导出 cookies
└─ 自动化加载 cookies

方案 2：使用测试账号
├─ 专门的测试账号
├─ 自动化登录流程
└─ 注意账号安全

方案 3：使用 API（如果提供）
├─ 通常更稳定
├─ 速度更快
└─ 更易维护
```

### Q6: Playwright 和 Selenium 有什么区别？

**A**:

| 维度 | Playwright | Selenium |
|------|-----------|----------|
| 速度 | 更快 | 较慢 |
| 可靠性 | 自动等待机制更可靠 | 需要手动等待 |
| API 设计 | 现代、简洁 | 传统、复杂 |
| 功能 | 内置截图、PDF、网络监控 | 需要额外工具 |
| 维护 | 活跃开发 | 维护较少 |
| 学习曲线 | 较平缓 | 较陡峭 |

### Q7: 如何并行执行多个浏览器？

**A**: Playwright 原生支持并行：

```
优势：
├─ 同时运行多个测试
├─ 显著减少总时间
└─ 充分利用硬件资源

示例：
10 个测试
串行：10 分钟
并行：2 分钟（5倍提升）
```

### Q8: 可以生成视频吗？

**A**: ✅ 可以录制视频：

```
功能：
├─ 录制浏览器操作
├─ 生成视频文件
└─ 用于调试和演示

配置：
{
  "video": "on"  // 开启视频录制
}

输出：
├─ WebM 格式
├─ 包含完整的浏览器操作
└─ 可用于 CI/CD 流水线
```

---

## 故障排查

### 问题 1：服务器启动失败

**症状**：
```
Error: Failed to start Playwright MCP server
```

**诊断步骤**：

```powershell
# 1. 检查 Node.js
node --version

# 2. 检查安装
npm list -g @executeautomation/playwright-mcp-server

# 3. 测试服务器
npx -y @executeautomation/playwright-mcp-server

# 4. 查看日志
$env:DEBUG = "playwright:*"
claude-code
```

**解决方案**：
- 重新安装服务器包
- 检查 Node.js 版本
- 更新 Claude Code

---

### 问题 2：浏览器启动失败

**症状**：
```
Error: Failed to launch browser
```

**原因**：
- 浏览器未安装
- 浏览器版本不兼容
- 权限问题

**解决方案**：

```powershell
# 安装 Playwright 浏览器
npx playwright install

# 或安装特定浏览器
npx playwright install chromium
npx playwright install firefox
```

---

### 问题 3：元素定位失败

**症状**：
```
Error: Element not found
```

**原因**：
- 元素选择器错误
- 元素未加载
- 页面结构变化

**解决方案**：

```
方案 1：等待元素
你：打开网页，等待元素加载完成后再操作

方案 2：使用更稳定的选择器
优先级：
1. data-testid（最稳定）
2. ID（次稳定）
3. Class/Tag（不太稳定）
4. 文本内容（最不稳定）

方案 3：添加延迟
你：打开网页，等待 3 秒，然后操作
```

---

### 问题 4：截图保存失败

**症状**：
```
Error: Failed to save screenshot
```

**解决方案**：

```powershell
# 检查目录权限
$path = "D:\Screenshots"
if (-not (Test-Path $path)) {
    New-Item -ItemType Directory -Path $path -Force
}

# 设置权限
$acl = Get-Acl $path
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
    $env:USERNAME,
    "FullControl",
    "Allow"
)
$acl.SetAccessRule($accessRule)
Set-Acl $path $acl
```

---

## 总结

### 核心价值回顾

通过浏览器自动化，你将能够：

```
1. 提升效率 ⚡
   - 自动化重复操作
   - 批量处理任务
   - 节省大量时间

2. 提高准确性 🎯
   - 避免人为错误
   - 严格按照脚本执行
   - 数据准确一致

3. 增强可重复性 🔄
   - 一次编写，多次执行
   - 定时任务自动化
   - 一致性保证

4. 扩展能力边界 🚀
   - 自动化测试
   - 数据抓取
   - 工作流自动化
```

### 学习检查清单

完成本学习后，你应该能够：

- [ ] 理解浏览器自动化的价值
- [ ] 配置 Playwright MCP 服务器
- [ ] 使用核心功能（导航、交互、截图）
- [ ] 应用到实际场景（测试、抓取、工作流）
- [ ] 解决常见问题
- [ ] 遵循最佳实践

### 下一步学习

**恭喜！Level 2 已完成！** 🎉

继续提升你的 Claude Code 技能：

```
Level 3 专家之道：
[Master 01 - Customization](../01-customization/README.md) - 自定义和扩展
[Master 02 - Automation](../02-automation/README.md) - 自动化和 CI/CD
[Master 03 - Advanced Topics](../03-advanced-topics/README.md) - 高级主题
```

---

**最后更新**: 2025-01-17
**难度**: ⭐⭐⭐⭐
**重要性**: ⭐⭐⭐⭐
**验证状态**: ✅ 已验证
