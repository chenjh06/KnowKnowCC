# CLAUDE.md 编写完整指南

> **让 Claude Code 深度理解你的项目**

**阅读时间**: 30分钟
**难度**: ⭐⭐
**重要性**: ⭐⭐⭐⭐⭐
**前置要求**: 完成 [Level 1 核心掌握](../../guide/)

---

## 目录

- [CLAUDE.md 概述](#claudemd-概述)
- [文件位置和结构](#文件位置和结构)
- [核心内容要素](#核心内容要素)
- [模板和示例](#模板和示例)
- [高级技巧](#高级技巧)
- [最佳实践](#最佳实践)
- [维护和更新](#维护和更新)

---

## CLAUDE.md 概述

### 什么是 CLAUDE.md？

**定义**：CLAUDE.md 是项目的"说明书"，告诉 Claude Code 你的项目信息、技术栈、代码规范。

**作用**：
```
没有 CLAUDE.md：
    ↓
每次对话都要重复说明
    ↓
"我的项目使用 React 18"
"组件放在 src/components/"
"命名要用 PascalCase"
...
    ↓
浪费时间，容易遗漏

有 CLAUDE.md：
    ↓
自动加载上下文
    ↓
Claude 理解项目
    ↓
生成符合规范的代码
```

### 价值分析

#### 1. 节省时间

```
每次对话节省：2-3分钟
每天对话：10次
每天节省：20-30分钟
每月节省：10-15小时
```

#### 2. 提高质量

```
规范明确 → Claude 遵循规范 → 代码质量一致
```

#### 3. 降低错误

```
明确约定 → 避免常见错误 → 减少修复时间
```

#### 4. 团队协作

```
团队共享 CLAUDE.md → 所有成员获得一致的AI协助
```

---

## 文件位置和结构

### 标准位置

```
项目根目录/
├── .claude/
│   ├── CLAUDE.md           # 主文件（必需）
│   ├── frontend.md         # 前端专项（可选）
│   ├── backend.md          # 后端专项（可选）
│   └── testing.md          # 测试专项（可选）
```

**为什么使用 .claude 目录？**

1. 集中管理所有AI相关配置
2. 不污染项目根目录
3. 易于版本控制
4. 符合约定

### 文件命名

```markdown
# 主文件（必需）
.claude/CLAUDE.md

# 专项文件（可选）
.claude/frontend.md     # 前端相关
.claude/backend.md      # 后端相关
.claude/database.md     # 数据库相关
.claude/deployment.md   # 部署相关

# 模块文件（大型项目）
.claude/modules/auth.md      # 认证模块
.claude/modules/payment.md   # 支付模块
```

---

## 核心内容要素

### 最小版本（必需）

```markdown
# 项目说明

## 项目概述
[1-2句话描述项目]

## 技术栈
[主要技术和版本]

## 代码规范
[基本的命名和结构规范]
```

**时间**: 5分钟
**适用**: 个人项目、原型

### 推荐版本（标准）

```markdown
# 项目说明

## 项目概述
[详细描述项目目的、功能、特点]

## 技术栈
- 前端：[框架和版本]
- 后端：[语言和框架]
- 数据库：[类型和版本]
- 其他工具：[列表]

## 项目结构
[目录树和说明]

## 代码规范
- 命名约定
- 文件组织
- 注释要求
- 错误处理

## 重要约定
- 不要修改的目录
- 特殊配置说明
- 测试要求

## API 规范
[接口标准和约定]
```

**时间**: 10-15分钟
**适用**: 大多数项目

### 完整版本（大型项目）

```markdown
# 项目说明

## 项目概述
- 项目名称和版本
- 项目目的和目标
- 核心功能列表
- 业务领域

## 技术栈
### 前端
- 框架：[名称和版本]
- 状态管理：[名称]
- UI库：[名称]
- 构建工具：[名称]

### 后端
- 语言：[名称和版本]
- 框架：[名称和版本]
- API规范：[REST/GraphQL]

### 数据库
- 类型：[PostgreSQL/MySQL/...]
- ORM：[Prisma/TypeORM/...]

### 开发工具
- 测试：[Jest/Vitest/...]
- 代码质量：[ESLint/Prettier]
- 版本控制：[Git]

## 项目结构
### 目录说明
```
src/
├── components/      # React组件
├── hooks/          # 自定义Hooks
├── utils/          # 工具函数
├── services/       # API服务
├── types/          # TypeScript类型
└── App.tsx         # 入口文件
```

### 模块说明
- components/: [说明]
- hooks/: [说明]
- ...

## 代码规范

### 命名约定
- 组件：PascalCase (UserProfile.tsx)
- 工具函数：camelCase (formatDate.ts)
- 常量：UPPER_SNAKE_CASE (API_BASE_URL)
- 类型：PascalCase + 'I' 前缀 (IUser)

### 文件组织
- 一个文件一个组件/函数
- 相关文件放在同一目录
- 使用 index.ts 导出

### 注释要求
- 公共API必须有JSDoc注释
- 复杂逻辑必须说明
- TODO标记需要说明原因

### 错误处理
- 所有async函数必须有try-catch
- 错误消息要清晰
- 记录错误日志

## 重要约定

### 不要修改
- src/core/ 目录是共享库，不要修改
- public/lib/ 是第三方库，不要手动修改

### 特殊配置
- 环境变量从 .env 读取
- API基础URL使用 REACT_APP_API_BASE_URL
- 开发模式使用 http://localhost:3000

### 测试要求
- 所有组件必须有测试
- 测试覆盖率 > 80%
- 使用 testing-library

## API 规范

### REST API
- 基础URL：/api/v1
- 认证：Bearer Token
- 错误格式：{ error: string, code: number }

### 响应格式
成功：{ data: T, message: string }
失败：{ error: string, code: number }

## 开发工作流

### 本地开发
1. npm install
2. npm run dev
3. 访问 http://localhost:3000

### 代码提交
1. git checkout -b feature/xxx
2. 开发和测试
3. git commit -m "feat: xxx"
4. git push origin feature/xxx
5. 创建 Pull Request

### 代码审查
- 至少一人审查
- 检查测试覆盖率
- 确认符合规范

## Git 工作流

### 分支策略
- main: 生产环境
- develop: 开发环境
- feature/*: 功能分支
- hotfix/*: 紧急修复

### 提交信息格式
- feat: 新功能
- fix: Bug修复
- docs: 文档更新
- style: 代码格式
- refactor: 重构
- test: 测试相关
- chore: 构建/工具

## 常见问题

### 端口冲突
如果3000端口被占用，修改 PORT 环境变量

### 依赖安装问题
删除 node_modules 和 package-lock.json，重新安装

### 热更新不工作
检查防火墙设置，确保允许localhost连接

## 相关资源
- 项目文档：[链接]
- API文档：[链接]
- Wiki：[链接]
```

**时间**: 30-45分钟
**适用**: 大型项目、团队项目

---

## 模板和示例

### 模板 1: React + TypeScript 项目

```markdown
# React Todo App - 项目说明

## 项目概述
一个功能完整的 Todo List 应用，演示 React 最佳实践。

核心功能：
- 任务CRUD
- 任务分类
- 数据持久化

## 技术栈
- React 18 + TypeScript
- Vite
- TailwindCSS
- Zustand
- Vitest

## 项目结构
src/
├── components/      # React组件
│   ├── TodoItem.tsx
│   ├── TodoList.tsx
│   └── TodoForm.tsx
├── store/          # Zustand状态
│   └── todoStore.ts
├── types/          # TypeScript类型
│   └── todo.ts
├── utils/          # 工具函数
│   └── localStorage.ts
└── App.tsx

## 代码规范

### 命名约定
- 组件：PascalCase + .tsx (TodoItem.tsx)
- 工具函数：camelCase + .ts (formatDate.ts)
- 类型：PascalCase (Todo)
- 常量：UPPER_SNAKE_CASE (MAX_TODOS)

### 组件规范
- 使用函数式组件 + Hooks
- Props必须有类型定义
- 组件必须有默认导出
- 使用 TypeScript 严格模式

### 测试规范
- 每个组件必须有测试
- 测试文件命名：Component.test.tsx
- 使用 testing-library
- 覆盖率 > 80%

## 重要约定

### 状态管理
- 所有全局状态使用 Zustand
- 本地状态使用 useState
- 不使用 Context API（除非必要）

### 样式
- 使用 TailwindCSS 类名
- 不使用 CSS Modules
- 不使用 inline styles（除了动态值）

### 数据持久化
- 使用 LocalStorage
- 使用 Zustand 的 persist middleware
- 敏感数据不要持久化

## 开发工作流

### 启动开发
npm install
npm run dev

### 运行测试
npm run test

### 构建
npm run build

## 常见问题

### LocalStorage 不工作
检查浏览器隐私设置，确保允许 LocalStorage

### TypeScript 类型错误
运行 npm run type-check 查看详细错误
```

### 模板 2: Node.js + Express API

```markdown
# E-Commerce API - 项目说明

## 项目概述
电商后台API，提供商品、订单、用户管理功能。

## 技术栈
- Node.js 18+
- Express 4.x
- TypeScript
- PostgreSQL
- Prisma
- JWT 认证

## 项目结构
src/
├── routes/          # API路由
│   ├── auth.ts
│   ├── products.ts
│   └── orders.ts
├── services/        # 业务逻辑
│   ├── auth.service.ts
│   └── product.service.ts
├── models/          # 数据模型
│   └── prisma/schema.prisma
├── middleware/      # 中间件
│   └── auth.middleware.ts
├── utils/           # 工具函数
│   └── validation.ts
└── app.ts           # 应用入口

## 代码规范

### 命名约定
- 路由：kebab-case (auth.routes.ts)
- 服务：camelCase + .service (authService.ts)
- 中间件：kebab-case + .middleware (auth.middleware.ts)
- 类型：PascalCase + 'I' (IUser)

### API 规范
- RESTful API
- 路由使用复数：/api/v1/products
- 使用 HTTP 状态码
- 统一错误格式

### 错误处理
```typescript
// 所有路由必须使用错误处理中间件
try {
  // 业务逻辑
} catch (error) {
  next(error); // 传递给错误处理中间件
}
```

### 验证
- 所有输入必须验证
- 使用 validation.ts 中的验证函数
- 返回清晰的错误消息

## 重要约定

### 认证
- 除了 /auth/login 和 /auth/register，所有路由需要认证
- 使用 Bearer Token
- Token 有效期：24小时

### 数据库
- 使用 Prisma ORM
- 所有查询使用 prepared statements
- 不要使用 raw SQL（除非必要）

### 安全
- 密码使用 bcrypt 加密
- 敏感数据记录日志时脱敏
- API 速率限制：100 req/min

## API 端点

### 认证
POST /api/v1/auth/register
POST /api/v1/auth/login
POST /api/v1/auth/refresh

### 商品
GET    /api/v1/products
GET    /api/v1/products/:id
POST   /api/v1/products (需要认证)
PUT    /api/v1/products/:id (需要认证)
DELETE /api/v1/products/:id (需要认证)

### 订单
GET    /api/v1/orders (需要认证)
POST   /api/v1/orders (需要认证)
GET    /api/v1/orders/:id (需要认证)

## 开发工作流

### 环境变量
复制 .env.example 到 .env
配置数据库连接

### 数据库迁移
npx prisma migrate dev
npx prisma db seed

### 启动
npm install
npm run dev

### 测试
npm run test
npm run test:e2e
```

### 模板 3: Python 项目

```markdown
# Data Pipeline - 项目说明

## 项目概述
数据处理管道，ETL流程自动化。

## 技术栈
- Python 3.10+
- Pandas
- SQLAlchemy
- PostgreSQL
- Apache Airflow

## 项目结构
src/
├── extractors/     # 数据提取
├── transformers/   # 数据转换
├── loaders/        # 数据加载
├── models/         # 数据模型
├── utils/          # 工具函数
└── main.py         # 入口文件

tests/
├── test_extractors.py
├── test_transformers.py
└── test_loaders.py

## 代码规范

### 命名约定
- 函数：snake_case (process_data)
- 类：PascalCase (DataProcessor)
- 常量：UPPER_SNAKE_CASE (MAX_RETRIES)
- 私有方法：前缀下划线 (_internal_method)

### 类型提示
```python
def process_data(data: pd.DataFrame) -> pd.DataFrame:
    pass
```

### 文档字符串
```python
def process_data(data: pd.DataFrame) -> pd.DataFrame:
    \"\"\"
    Process the input DataFrame.

    Args:
        data: Input DataFrame

    Returns:
        Processed DataFrame

    Raises:
        ValueError: If data is empty
    \"\"\"
    pass
```

## 重要约定

### 错误处理
- 记录所有错误
- 不要吞掉异常
- 提供有意义的错误消息

### 日志
- 使用 logging 模块
- 日志级别：DEBUG/INFO/WARNING/ERROR
- 生产环境使用 INFO 级别

### 测试
- 使用 pytest
- 测试覆盖率 > 80%
- 每个函数必须有测试

## 开发工作流

### 虚拟环境
python -m venv venv
source venv/bin/activate  # Linux/Mac
venv\Scripts\activate     # Windows

### 安装依赖
pip install -r requirements.txt

### 运行
python src/main.py

### 测试
pytest
pytest --cov=src
```

---

## 高级技巧

### 技巧 1: 条件化说明

```markdown
## 环境特定说明

### 开发环境
- 使用开发数据库
- 启用详细日志
- 热更新开启

### 生产环境
- 使用生产数据库
- 日志级别 INFO
- 缓存启用

### 测试环境
- 使用内存数据库
- 禁用外部调用
- Mock 所有依赖
```

### 技巧 2: 分模块说明

**大型项目**可以分模块：

```
.claude/
├── CLAUDE.md          # 总览和通用规范
├── auth.md           # 认证模块详细
├── payment.md        # 支付模块详细
└── notification.md   # 通知模块详细
```

**CLAUDE.md（主文件）**：
```markdown
# 项目说明

## 模块概览
本项目包含多个模块，详见各模块文件：
- 认证系统：.claude/auth.md
- 支付系统：.claude/payment.md
- 通知系统：.claude/notification.md

## 通用规范
[适用于所有模块的规范]
```

**auth.md**：
```markdown
# 认证模块

## 功能
用户注册、登录、密码重置、JWT管理

## 技术实现
- JWT 认证
- bcrypt 加密
- 会话管理

## API 端点
[详细的认证API]

## 安全要求
- 密码强度要求
- Token 过期时间
- 速率限制
```

### 技巧 3: 使用代码块

```markdown
## 组件模板

```typescript
// 组件的标准模板
import React from 'react';

interface Props {
  // props定义
}

export function ComponentName({ props }: Props) {
  // 组件实现
  return (
    // JSX
  );
}
```

所有组件必须遵循此模板。
```

### 技巧 4: 示例代码

```markdown
## API调用示例

```typescript
// 正确的API调用方式
import { apiClient } from '@/services/api';

export async function getUser(id: string) {
  try {
    const response = await apiClient.get(`/users/${id}`);
    return response.data;
  } catch (error) {
    logger.error('Failed to fetch user', error);
    throw error;
  }
}
```

所有API调用必须遵循此模式。
```

### 技巧 5: 决策树

```markdown
## 组件设计决策

```
是否需要状态？
├─ 是 → 全局状态？
│   ├─ 是 → 使用 Zustand store
│   └─ 否 → 使用 useState
└─ 否 → 纯展示组件
```

## 样式决策

```
是否需要动态样式？
├─ 是 → 使用 style 对象
└─ 否 → 使用 TailwindCSS 类名
```
```

---

## 最佳实践

### 实践 1: 保持简洁

```markdown
❌ 太详细：
## 历史演变
本项目始于2020年，经历了3次重大重构...
（项目历史不是Claude需要的）

✅ 简洁有效：
## 项目概述
电商管理系统v2.0，React + TypeScript
```

### 实践 2: 聚焦约定

```markdown
❌ 包含教程：
## 如何使用React
React是一个用于构建用户界面的JavaScript库...

✅ 说明约定：
## React使用规范
- 使用函数式组件
- Hooks 优先于类组件
- 遵循React官方最佳实践
```

### 实践 3: 及时更新

```
项目变更 → 更新 CLAUDE.md → Git提交

示例：
1. 添加新功能
2. 更新 CLAUDE.md 中的功能列表
3. git add .claude/CLAUDE.md
4. git commit -m "docs: update CLAUDE.md for new feature"
```

### 实践 4: 团队协作

```markdown
# 团队 CLAUDE.md 维护规范

## 更新流程
1. 修改代码规范前，先讨论
2. 更新 CLAUDE.md
3. 团队审查
4. 合并到主分支
5. 通知所有成员

## 审查清单
- [ ] 规范清晰明确
- [ ] 有示例代码
- [ ] 所有成员理解
- [ ] 文档已更新
```

### 实践 5: 版本控制

```markdown
## 版本说明

CLAUDE.md 版本：2.0
最后更新：2026-02-04
更新内容：添加新的代码规范章节

重要变更：
- 新增 TypeScript 严格模式要求
- 更新组件命名规范
```

---

## 维护和更新

### 何时更新

```markdown
✅ 必须更新：
- 添加新的技术栈
- 修改代码规范
- 变更项目结构
- 添加重要约定

⚠️ 建议更新：
- 发现常见错误模式
- 添加新的示例
- 优化现有说明

❌ 不需要更新：
- 日常bug修复
- 小的代码调整
- 临时性变更
```

### 更新流程

```
1. 识别需要更新的内容
2. 草拟更新
3. 测试（Claude是否理解）
4. 团队审查（如适用）
5. 提交更新
6. 通知团队成员
```

### 验证有效性

```
方法1：测试对话
更新 CLAUDE.md 后，测试几个对话，验证Claude是否遵循新规范

方法2：代码审查
检查生成的代码是否符合CLAUDE.md中的规范

方法3：团队反馈
收集团队成员的使用反馈
```

---

## 常见问题

### Q1: CLAUDE.md 会影响性能吗？

**A**: 不会显著影响。Claude Code只在需要时读取，而且缓存机制会优化重复读取。

### Q2: 可以有多个CLAUDE.md吗？

**A**: 可以，但推荐使用主文件+子文件的方式：

```
.claude/
├── CLAUDE.md      # 主文件
├── frontend.md    # 前端专项
└── backend.md     # 后端专项
```

### Q3: 敏感信息怎么办？

**A**: 不要包含在CLAUDE.md中：

```markdown
❌ 不要：
## API密钥
OPENAI_API_KEY=sk-xxx

✅ 应该：
## 环境变量
- API密钥从环境变量读取
- 使用 .env 文件
- .env.example 提供模板
```

### Q4: CLAUDE.md 太长怎么办？

**A**: 拆分为多个文件：

```
.claude/
├── CLAUDE.md          # 总览和最重要信息
├── conventions.md     # 代码规范
├── structure.md       # 项目结构
└── workflows.md       # 工作流程
```

### Q5: 如何确保团队遵循CLAUDE.md？

**A**:

1. **代码审查**：检查生成的代码是否符合规范
2. **自动化检查**：使用ESLint等工具强制规范
3. **定期回顾**：团队会议讨论规范执行情况
4. **CI检查**：CI流程中验证代码规范

---

## 总结

### CLAUDE.md 的价值

```
时间节省：⭐⭐⭐⭐⭐
代码质量：⭐⭐⭐⭐⭐
团队协作：⭐⭐⭐⭐
维护成本：⭐⭐⭐
```

### 学习检查清单

- [ ] 理解 CLAUDE.md 的价值
- [ ] 掌握文件位置和结构
- [ ] 学会编写核心内容
- [ ] 了解高级技巧
- [ ] 建立维护习惯
- [ ] 团队协作流程

### 快速模板

复制这个快速开始：

```markdown
# [项目名称] - 项目说明

## 项目概述
[1-2句话]

## 技术栈
- [主要技术]

## 项目结构
[目录树]

## 代码规范
- [规范1]
- [规范2]

## 重要约定
- [约定1]
- [约定2]
```

### 下一步

继续学习：

```
[02 - Prompt Engineering](../b-code-quality/02-prompt-engineering.md)
[03 - Subagents](../b-code-quality/03-subagents.md)
[04 - Code Review](../b-code-quality/04-code-review.md)
```

---

**最后更新**: 2026-02-04
**难度**: ⭐⭐
**重要性**: ⭐⭐⭐⭐⭐
