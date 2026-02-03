# 04 - Claude Code 实战案例集合

> **真实项目案例,学习 Claude Code 在实际项目中的应用**

**阅读时间**: 90分钟
**难度**: ⭐⭐⭐
**重要性**: ⭐⭐⭐⭐⭐
**前置要求**: [Level 1 核心掌握](../../guide/)

> **验证状态**: ✅ 已验证
> **内容来源**: 微信文章分析 + 实际测试
> **验证日期**: 2026-01-23
> **可信度**: 85%

---

## 目录

- [案例1: Obsidian 知识管理系统](#案例1-obsidian-知识管理系统)
- [案例2: PPT 自动生成](#案例2-ppt-自动生成)
- [案例3: 视频处理工作流](#案例3-视频处理工作流)
- [案例4: 自动化工作流](#案例4-自动化工作流)
- [案例5: GitHub 项目管理](#案例5-github-项目管理)

---

## 案例1: Obsidian 知识管理系统

### 背景

**需求**: 本地知识管理 + AI 辅助

**问题**:
- 笔记越来越多,难以整理
- 知识点之间缺乏关联
- 需要智能检索和总结
- 想要自动化生成日报

**解决方案**: Obsidian + Claude Code + obsidian-skills

### 实施步骤

#### Step 1: 安装 obsidian-skills

```bash
# 克隆官方仓库
git clone https://github.com/obsidianmd/obsidian-skills.git

# 复制到 Claude Code skills 目录
cp -r obsidian-skills ~/.claude/advanced/

# 验证安装
claude --list-skills | grep obsidian
```

**Windows PowerShell**:

```powershell
# 克隆仓库
git clone https://github.com/obsidianmd/obsidian-skills.git

# 复制到 skills 目录
Copy-Item -Recurse obsidian-skills $env:USERPROFILE\.claude\skills\

# 验证
claude --list-skills | Select-String obsidian
```

#### Step 2: 配置 CLAUDE.md

**在 Obsidian Vault 根目录创建 CLAUDE.md**:

```markdown
# Obsidian 知识库配置

## 项目结构

```
MyKnowledge/
├── 01-Inbox/          # 收集箱
├── 02-Projects/       # 项目笔记
├── 03-Areas/         # 生活领域
├── 04-Resources/     # 资源库
├── 05-Archive/       # 归档
└── Templates/        # 模板
```

## 标签系统

- #status/todo - 待处理
- #status/doing - 进行中
- #status/done - 已完成

- #priority/high - 高优先级
- #priority/medium - 中优先级
- #priority/low - 低优先级

## Wikilink 使用

- 使用 [[文件名]] 引用其他笔记
- 使用 [[文件名|别名]] 添加别名
- 使用 ![[文件名]] 嵌入内容
- 使用 #标签 创建标签

## 工作流程

1. 收集: 快速记录到 Inbox
2. 整理: 移动到对应目录
3. 关联: 添加 Wikilink
4. 标签: 添加状态和优先级标签
5. 复查: 定期回顾和更新
```

#### Step 3: 创建知识库结构

**使用 Claude Code 创建目录结构**:

```markdown
👤 你: 在 Obsidian Vault 中创建知识库目录结构:
- 01-Inbox/
- 02-Projects/
- 03-Areas/
- 04-Resources/
- 05-Archive/
- Templates/

🤖 Claude: [创建目录]
✅ 目录结构已创建
```

#### Step 4: 自动化工作流设置

**创建日报生成 Skill**:

```markdown
# daily-report-skill

你是知识管理助手,负责生成每日工作日报。

## 工作流程

1. **查找今天的笔记**
   ```
   搜索今天的笔记 (按日期)
   筛选包含 #status/done 的任务
   ```

2. **分类整理**
   ```
   按项目分类
   按优先级排序
   统计完成数量
   ```

3. **生成报告**
   ```
   格式:
   ## 日报 - 日期

   ### 完成任务
   - [项目A] 任务1
   - [项目B] 任务2

   ### 进行中
   - [项目A] 任务3

   ### 明日计划
   - [项目C] 任务4
   ```

4. **保存到日报目录**
   ```
   文件名: YYYY-MM-DD.md
   位置: 05-Archive/DailyReports/
   ```
```

### 实战效果

#### 1. 自动日报生成

```markdown
👤 你: 使用 @obsidian-skills skill
生成今天的工作日报

🤖 Claude: [使用 obsidian-skills]
正在扫描今天的笔记...

找到 5 个完成的任务:
- [Blog Project] 完成初稿
- [Code Review] 审查 PR #123
- [Documentation] 更新 API 文档
- [Meeting] 参加团队周会
- [Planning] 制定下周计划

[生成日报]
✅ 日报已保存到 05-Archive/DailyReports/2026-01-23.md
```

#### 2. 智能文档检索

```markdown
👤 你: 在我的知识库中搜索所有关于 "Claude Code" 的笔记
提取关键概念
建立概念之间的关联

🤖 Claude: [使用 obsidian-skills]
正在搜索知识库...

找到 12 篇相关笔记:
1. Claude Code 入门笔记
2. Skills 开发教程
3. MCP 服务器配置
4. ...

关键概念:
- Claude Code (AI 编程助手)
  ├─ 核心功能: @符号, !命令, Plan模式
  ├─ Skills: 模块化扩展
  └─ MCP: 外部服务集成

[生成知识图谱]
✅ 关联图已创建
```

#### 3. 批量元数据编辑

```markdown
👤 你: 将 01-Inbox/ 目录下的所有笔记
添加 #status/todo 标签
移到 02-Projects/ 目录

🤖 Claude: [使用 obsidian-skills]
正在处理...

处理 8 个笔记:
✅ note1.md - 添加标签,已移动
✅ note2.md - 添加标签,已移动
...

全部完成!
```

#### 4. 数据库(Base)创建

```markdown
👤 你: 创建一个项目管理 Base
包含字段:
- 名称 (text)
- 状态 (select: todo/doing/done)
- 优先级 (select: 高/中/低)
- 截止日期 (date)
- 负责人 (text)

🤖 Claude: [使用 obsidian-skills]
正在创建 Base...

✅ Base 已创建: Projects/Dashboard

添加示例数据:
[示例数据]
```

### 技术要点

**obsidian-skills 核心功能**:

```markdown
1. Obsidian Flavored Markdown 支持
   ✅ Wikilink: [[笔记]]
   ✅ Callouts: > [!INFO]
   ✅ Frontmatter: ---
   ✅ Tags: #标签

2. JSON Canvas 支持
   ✅ 思维导图
   ✅ 流程图
   ✅ 可视化

3. Obsidian Bases 支持
   ✅ 数据库视图
   ✅ 过滤器
   ✅ 公式计算
```

**性能优化**:

```
小知识库 (<1000 笔记):
├─ 全文搜索: 快
├─ AI 分析: 实时
└─ 无需优化

中等知识库 (1000-5000 笔记):
├─ 使用索引
├─ 分目录管理
└─ 定期归档

大知识库 (>5000 笔记):
├─ 使用 Obsidian Search 插件
├─ 定期压缩
└─ 考虑拆分
```

### 注意事项

**性能问题**:

```markdown
⚠️ 知识库过大时:
→ 考虑分库管理
→ 定期归档旧笔记
→ 使用搜索插件

⚠️ AI 分析耗时:
→ 限制扫描范围
→ 使用缓存
→ 分批处理
```

**数据备份**:

```bash
# 定期备份 Obsidian Vault
# 使用 Git

git add .
git commit -m "backup: $(date +%Y-%m-%d)"
git push origin main
```

---

## 案例2: PPT 自动生成

### 背景

**需求**: 文章转 PPT

**问题**:
- 手动制作 PPT 耗时
- 需要设计感
- 要保持风格一致
- 需要图表可视化

**解决方案**: Claude Code + PPT Skill

### 实施步骤

#### Step 1: 准备文章内容

**示例文章**:

```markdown
# Claude Code 完全指南

## 简介
Claude Code 是 Anthropic 推出的 AI 编程助手...

## 核心功能
### @ 符号
引用文件和目录...

### ! 命令
运行 Shell 命令...

## 使用场景
1. 日常开发
2. 代码审查
3. 文档编写

## 总结
Claude Code 是强大的 AI 工具...
```

#### Step 2: 调用 PPT Skill

```markdown
👤 你: 使用 @pptx skill
根据这篇文章生成演示文稿

要求:
- 风格: 现代简约
- 主题色: 蓝色
- 每个章节一页
- 添加图表
- 包含过渡动画

🤖 Claude: [使用 pptx Skill]
正在生成 PPT...

分析文章结构:
- 简介 → 封面 + 目录
- 核心功能 → 3页内容
- 使用场景 → 1页图表
- 总结 → 结束页

[生成 PPT]
✅ 输出: claude-code-presentation.html
```

#### Step 3: 自定义样式

**修改颜色方案**:

```markdown
👤 你: 调整 PPT 样式
- 主色: #0066CC (深蓝)
- 辅助色: #00AAFF (浅蓝)
- 强调色: #FF6600 (橙色)
- 背景色: #F5F5F5 (浅灰)
- 字体: 微软雅黑

🤖 Claude: [更新样式]
✅ 样式已应用
重新生成: claude-code-presentation-v2.html
```

#### Step 4: 添加图表

**创建数据可视化**:

```markdown
👤 你: 在"使用场景"页面添加图表
数据:
- 日常开发: 60%
- 代码审查: 25%
- 文档编写: 15%

类型: 饼图
颜色: 使用主题色

🤖 Claude: [添加图表]
✅ 图表已添加
使用 Chart.js 渲染
```

#### Step 5: 导出 PPT

**导出为多种格式**:

```markdown
👤 你: 导出 PPT
格式:
1. HTML (在线演示)
2. PDF (打印)
3. PPTX (编辑)

🤖 Claude: [导出文件]
✅ 已生成:
- claude-code-presentation.html
- claude-code-presentation.pdf
- claude-code-presentation.pptx
```

### 技术要点

**HTML vs 文生图**:

```
HTML 方式:
✅ 可交互
✅ 文件小
✅ 加载快
✅ 可编辑
❌ 需要浏览器

文生图方式:
✅ 兼容性好
✅ 可直接播放
❌ 文件大
❌ 不可编辑
❌ 生成慢
```

**图表集成**:

```javascript
// 使用 Chart.js
{
  "type": "pie",
  "data": {
    "labels": ["日常开发", "代码审查", "文档编写"],
    "datasets": [{
      "data": [60, 25, 15],
      "backgroundColor": ["#0066CC", "#00AAFF", "#FF6600"]
    }]
  }
}
```

**风格模板**:

```json
{
  "modern": {
    "colors": ["#0066CC", "#00AAFF", "#FF6600"],
    "font": "Microsoft YaHei",
    "background": "#F5F5F5",
    "animations": ["slide", "fade"]
  },
  "minimal": {
    "colors": ["#333333", "#666666", "#999999"],
    "font": "Arial",
    "background": "#FFFFFF",
    "animations": ["fade"]
  }
}
```

### 注意事项

**内容限制**:

```
⚠️ 单页内容过多:
→ 拆分为多页
→ 使用要点列表
→ 精简文字

⚠️ 图片过多:
→ 压缩图片
→ 使用占位符
→ 分批加载
```

**兼容性**:

```
HTML:
✅ 现代浏览器
✅ 跨平台
❌ 旧版 PPT 软件

PDF:
✅ 通用格式
✅ 打印友好
❌ 不可编辑

PPTX:
✅ PowerPoint 编辑
✅ 通用格式
❌ 动画可能丢失
```

---

## 案例3: 视频处理工作流

### 背景

**需求**: 视频转录 + 字幕

**问题**:
- 需要视频转文字
- 需要翻译字幕
- 需要合成字幕到视频
- 需要批量处理

**解决方案**: Claude Code + Transcription Skill

### 实施步骤

#### Step 1: 上传视频文件

```markdown
👤 你: 我有视频文件: video.mp4
时长: 30分钟
语言: 中文
需要: 转录 + 英文字幕

🤖 Claude: [使用 transcription Skill]
正在处理视频...
```

#### Step 2: 自动转录

```markdown
👤 你: 开始转录 video.mp4
输出格式: SRT
时间戳: 精确到毫秒

🤖 Claude: [调用转录服务]
正在转录...

进度:
[████████░░] 80%

✅ 转录完成
输出: video.srt
时长: 30:15
字数: 4,523 字
```

#### Step 3: 翻译生成

```markdown
👤 你: 翻译 video.srt 为英文
保持时间戳
专业术语保留原文

🤖 Claude: [翻译字幕]
正在翻译...

✅ 翻译完成
输出: video_en.srt
```

#### Step 4: 字幕合成

```markdown
👤 你: 合成字幕到视频
中文字幕: 底部
英文字幕: 顶部
字体: 白色黑边
大小: 适中

🤖 Claude: [使用 FFmpeg]
正在合成...

✅ 合成完成
输出: video_subtitled.mp4
```

### 技术要点

**格式转换**:

```bash
# 视频转音频 (用于转录)
ffmpeg -i video.mp4 -vn -acodec pcm_s16le -ar 16000 -ac 1 audio.wav

# 字幕合成
ffmpeg -i video.mp4 -vf "subtitles=video.srt" video_subtitled.mp4

# 双字幕
ffmpeg -i video.mp4 \
  -vf "subtitles=zh.srt,subtitles=en.srt" \
  video_dual.mp4
```

**SRT 格式**:

```srt
1
00:00:00,000 --> 00:00:05,000
你好,欢迎观看 Claude Code 教程

2
00:00:05,000 --> 00:00:10,000
今天我们将学习如何使用 Claude Code
```

**批处理**:

```bash
# 批量处理多个视频
for video in videos/*.mp4; do
  echo "Processing $video..."
  claude "转录 $video,生成中英文字幕,合成输出"
done
```

### 注意事项

**转录准确性**:

```
⚠️ 背景噪音:
→ 使用降噪处理
→ 提高音频质量

⚠️ 专业术语:
→ 提供术语表
→ 人工校对

⚠️ 多人对话:
→ 使用说话人识别
→ 标注说话人
```

**时间同步**:

```
⚠️ 时间戳偏移:
→ 手动调整
→ 使用自动同步

⚠️ 字幕过长:
→ 拆分长句
→ 控制每行字数
```

---

## 案例4: 自动化工作流

### 背景

**需求**: 定时任务自动化

**问题**:
- 需要定时执行任务
- 需要错误处理
- 需要结果通知
- 需要日志记录

**解决方案**: Claude Code + Scheduled Task Skill

### 实施步骤

#### Step 1: 定义任务

```markdown
# 任务定义

## 任务: 每日备份

**频率**: 每天 23:00
**操作**:
1. 备份项目文件
2. 压缩为 ZIP
3. 上传到云存储
4. 发送通知

**错误处理**:
- 失败重试 3 次
- 记录错误日志
- 发送告警通知
```

#### Step 2: 设置定时器

```markdown
👤 你: 创建定时任务
名称: daily-backup
Cron: 0 23 * * *
任务: 执行 backup.sh

🤖 Claude: [创建定时任务]
✅ 任务已创建
下次执行: 2026-01-24 23:00
```

#### Step 3: 编写脚本

**backup.sh**:

```bash
#!/bin/bash

# 每日备份脚本

DATE=$(date +%Y-%m-%d)
PROJECT_DIR="/path/to/project"
BACKUP_DIR="/path/to/backups"
LOG_FILE="$BACKUP_DIR/backup-$DATE.log"

# 记录日志
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# 开始备份
log "开始备份..."

# 创建备份目录
mkdir -p "$BACKUP_DIR/$DATE"

# 复制文件
log "复制文件..."
cp -r "$PROJECT_DIR" "$BACKUP_DIR/$DATE/"

# 压缩
log "压缩备份..."
zip -r "$BACKUP_DIR/backup-$DATE.zip" "$BACKUP_DIR/$DATE/"

# 上传 (示例: 使用 rclone)
log "上传到云存储..."
rclone copy "$BACKUP_DIR/backup-$DATE.zip" remote:backups/

# 清理旧备份 (保留7天)
log "清理旧备份..."
find "$BACKUP_DIR" -type d -mtime +7 -exec rm -rf {} \;

# 完成
log "备份完成!"

# 发送通知
curl -X POST "https://api.notify.com/backup" \
  -d "status=success&date=$DATE"
```

#### Step 4: 错误处理

```markdown
👤 你: 添加错误处理
- 失败重试 3 次
- 记录错误日志
- 发送告警通知

🤖 Claude: [更新脚本]
✅ 错误处理已添加

backup-robust.sh:
```bash
#!/bin/bash

# 重试函数
retry() {
  local n=1
  local max=3
  local delay=5
  while true; do
    "$@" && break || {
      if [[ $n -lt $max ]]; then
        ((n++))
        echo "命令失败. 重试 $n/$max..."
        sleep $delay;
      else
        echo "命令失败 $max 次. 放弃."
        # 发送告警
        curl -X POST "https://api.notify.com/alert" \
          -d "status=failed&task=daily-backup"
        return 1
      fi
    }
  done
}

# 执行备份
retry backup_project
```

### 技术要点

**Cron 表达式**:

```
* * * * *
│ │ │ │ │
│ │ │ │ └─ 星期几 (0-6)
│ │ │ └─── 月份 (1-12)
│ │ └───── 日期 (1-31)
│ └─────── 小时 (0-23)
└───────── 分钟 (0-59)

示例:
0 23 * * *      # 每天 23:00
0 */2 * * *     # 每 2 小时
0 9 * * 1-5     # 周一到周五 9:00
*/30 * * * *    # 每 30 分钟
```

**日志记录**:

```bash
# 日志格式
[YYYY-MM-DD HH:MM:SS] [LEVEL] message

# 日志级别
DEBUG   # 调试信息
INFO    # 一般信息
WARNING # 警告
ERROR   # 错误
CRITICAL # 严重错误

# 日志轮转
logrotate /etc/logrotate.d/backup
```

**通知方式**:

```
邮件通知:
├─ SMTP
├─ SendGrid
└─ Mailgun

即时消息:
├─ Slack
├─ Discord
├─ Telegram
└─ 企业微信

短信通知:
├─ Twilio
└─ 阿里云短信
```

### 注意事项

**权限问题**:

```
⚠️ 定时任务无权限:
→ 检查文件权限
→ 使用绝对路径
→ 设置正确的用户

⚠️ 环境变量缺失:
→ 在脚本中设置
→ 使用完整路径
→ 加载环境配置
```

**资源占用**:

```
⚠️ 备份占用空间:
→ 定期清理
→ 压缩存储
→ 异地备份

⚠️ 网络带宽:
→ 错峰备份
→ 增量备份
→ 断点续传
```

---

## 案例5: GitHub 项目管理

### 背景

**需求**: GitHub 项目转 Skills

**问题**:
- 需要快速理解项目
- 需要生成文档
- 需要版本管理
- 需要经验积累

**解决方案**: Claude Code + github-to-skills

### 实施步骤

#### Step 1: 克隆 GitHub 项目

```bash
# 克隆项目
git clone https://github.com/user/project.git

# 查看项目结构
cd project
tree -L 2
```

#### Step 2: 生成 Skill

```markdown
👤 你: 使用 @github-to-skills skill
项目地址: https://github.com/user/project.git
生成 Skill

🤖 Claude: [使用 github-to-skills]
正在分析项目...

分析结果:
- 语言: Python
- 框架: Flask
- 主要功能: Web API
- 依赖: 15 个

[生成 Skill]
✅ Skill 已生成: project-skill/
```

#### Step 3: 版本管理

```markdown
👤 你: 管理 Skill 版本
记录 GitHub commit hash

🤖 Claude: [添加版本控制]

配置 evolution.json:
```json
{
  "github_url": "https://github.com/user/project.git",
  "github_hash": "abc123",
  "version": "1.0.0",
  "last_update": "2026-01-23",
  "experience": [
    "安装依赖: pip install -r requirements.txt",
    "运行: python app.py",
    "测试: pytest tests/"
  ]
}
```

#### Step 4: 自动更新

```markdown
👤 你: 检查项目更新
如果有新 commit,更新 Skill

🤖 Claude: [检查更新]
正在检查 GitHub...

发现新提交:
- abc123 → def456
- 变更: 修复 Bug #123

[更新 Skill]
✅ Skill 已更新
版本: 1.0.1
```

### 技术要点

**GitHub API**:

```bash
# 获取项目信息
curl https://api.github.com/repos/user/project

# 获取最新 commit
curl https://api.github.com/repos/user/project/commits

# 获取文件列表
curl https://api.github.com/repos/user/project/contents/
```

**版本管理**:

```json
{
  "project": {
    "name": "project-name",
    "url": "https://github.com/user/project",
    "current_hash": "def456",
    "version": "1.0.1"
  },
  "updates": [
    {
      "hash": "def456",
      "date": "2026-01-23",
      "message": "Fix bug #123",
      "author": "user"
    }
  ]
}
```

**经验管理**:

```json
{
  "experience": {
    "installation": "安装步骤...",
    "usage": "使用方法...",
    "troubleshooting": {
      "error1": "解决方案1",
      "error2": "解决方案2"
    },
    "best_practices": [
      "最佳实践1",
      "最佳实践2"
    ]
  }
}
```

### 注意事项

**项目访问**:

```
⚠️ 私有仓库:
→ 配置 GitHub Token
→ 设置权限

⚠️ 大型项目:
→ 分批处理
→ 限制扫描范围
→ 使用缓存
```

**更新频率**:

```
⚠️ 频繁更新:
→ 设置更新间隔
→ 仅更新重要变更
→ 批量更新

⚠️ 版本冲突:
→ 解决冲突
→ 合并变更
→ 测试验证
```

---

## 总结

**实战案例核心要点**:

```
1. Obsidian 知识管理
   ✅ obsidian-skills 官方集成
   ✅ 自动日报生成
   ✅ 智能检索
   ✅ 批量管理

2. PPT 自动生成
   ✅ 文章转演示文稿
   ✅ 自定义样式
   ✅ 图表集成
   ✅ 多格式导出

3. 视频处理
   ✅ 自动转录
   ✅ 字幕翻译
   ✅ 批量处理
   ✅ 格式转换

4. 自动化工作流
   ✅ 定时任务
   ✅ 错误处理
   ✅ 日志记录
   ✅ 结果通知

5. GitHub 项目管理
   ✅ 项目转 Skills
   ✅ 版本管理
   ✅ 自动更新
   ✅ 经验积累
```

**学习建议**:

```
新手:
1. 从简单案例开始
2. 理解每个步骤
3. 实际操作验证
4. 遇到问题查文档

进阶:
1. 组合多个案例
2. 优化工作流
3. 分享经验
4. 贡献社区

专家:
1. 创新应用场景
2. 开发新工具
3. 指导新手
4. 推动生态
```

---

**最后更新**: 2026-02-04
**文档版本**: v1.0
**维护者**: Nyxifer 和他的 ClaudeCode (GLM4.7)
