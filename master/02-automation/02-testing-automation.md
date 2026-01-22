# 测试自动化 - Testing Automation

> **让测试自动运行，让质量自动保障**

**阅读时间**: 45分钟
**难度**: ⭐⭐⭐⭐
**适用场景**: 自动化测试、CI/CD 集成、质量保障
**前置要求**: [Level 2 进阶提升](../../skills/), [工作流自动化](./03-workflow-automation.md)

---

## 目录

- [测试自动化概述](#测试自动化概述)
- [测试类型](#测试类型)
- [Claude Code 辅助测试](#claude-code-辅助测试)
- [测试框架集成](#测试框架集成)
- [自动化测试策略](#自动化测试策略)
- [CI/CD 集成](#cicd-集成)
- [实战案例](#实战案例)
- [Windows 专属](#windows-专属)
- [最佳实践](#最佳实践)
- [常见问题](#常见问题)
- [故障排查](#故障排查)

---

## 测试自动化概述

### 什么是测试自动化？

**定义**：测试自动化是指使用软件工具自动执行测试用例，比较实际结果与预期结果，并生成测试报告。

```
手动测试：
编写测试用例 → 手动执行 → 记录结果
    ↓
耗时、易错、不可重复

自动化测试：
编写测试脚本 → 自动执行 → 自动报告
    ↓
快速、可靠、可重复、持续
```

### 为什么需要测试自动化？

#### 1. 提升效率

```
手动测试：
- 100个测试用例
- 每个用例5分钟
- 总耗时：500分钟（8小时+）

自动化测试：
- 首次编写：2小时
- 每次运行：5分钟
- 100次运行：500分钟 = 首次手动时间
- 第101次起：净节省时间
```

#### 2. 提高质量

```
手动测试：
- 容易遗漏
- 执行不一致
- 疲劳导致错误

自动化测试：
- 全面覆盖
- 执行一致
- 可靠准确
```

#### 3. 快速反馈

```
开发流程：
代码修改 → 自动测试 → 立即反馈
    ↓
快速发现问题
快速修复问题
快速迭代
```

#### 4. 回归保护

```
新增功能：
可能破坏旧功能
    ↓
自动化测试
    ↓
立即发现回归问题
```

---

## 测试类型

### 1. 单元测试 (Unit Testing)

**定义**：测试最小的可测试单元（函数、方法、类）

**特点**：
```
✅ 快速（毫秒级）
✅ 隔离（不依赖外部）
✅ 可靠（稳定一致）
✅ 便宜（易于维护）
```

**示例**：

```typescript
// math.ts
export function add(a: number, b: number): number {
  return a + b;
}

// math.test.ts
import { add } from './math';

describe('add', () => {
  it('should add two numbers', () => {
    expect(add(1, 2)).toBe(3);
  });

  it('should handle negative numbers', () => {
    expect(add(-1, -2)).toBe(-3);
  });

  it('should handle zero', () => {
    expect(add(0, 5)).toBe(5);
  });
});
```

**Claude Code 辅助**：

```markdown
👤 你：为 @src/utils/helpers.ts
编写完整的单元测试

要求：
- 覆盖所有函数
- 包含边界情况
- 使用 Jest

🤖 Claude：[生成测试代码]
✅ 完整的测试套件
✅ 边界情况覆盖
✅ Mock 和 Stub
```

### 2. 集成测试 (Integration Testing)

**定义**：测试多个单元组合后的行为

**特点**：
```
⚠️ 较慢（秒级）
⚠️ 依赖外部（数据库、API）
✅ 真实场景
✅ 发现集成问题
```

**示例**：

```typescript
// user.integration.test.ts
import { UserService } from './user.service';
import { Database } from './database';

describe('UserService Integration', () => {
  let service: UserService;
  let db: Database;

  beforeAll(async () => {
    db = new Database();
    await db.connect();
    service = new UserService(db);
  });

  afterAll(async () => {
    await db.disconnect();
  });

  it('should create and retrieve user', async () => {
    const user = await service.create({
      name: 'Alice',
      email: 'alice@example.com'
    });

    const retrieved = await service.findById(user.id);
    expect(retrieved.name).toBe('Alice');
  });
});
```

**Claude Code 辅助**：

```markdown
👤 你：为 @src/services/auth.service.ts
编写集成测试

场景：
- 用户注册和登录
- Token 生成和验证
- 权限检查

🤖 Claude：[生成集成测试]
✅ 真实数据库
✅ 完整流程
✅ 清理逻辑
```

### 3. 端到端测试 (E2E Testing)

**定义**：测试完整的应用流程

**特点**：
```
❌ 最慢（分钟级）
❌ 最难维护
✅ 最真实
✅ 用户视角
```

**示例**：

```typescript
// e2e/login.spec.ts
import { test, expect } from '@playwright/test';

test.describe('Login Flow', () => {
  test('should login successfully', async ({ page }) => {
    await page.goto('/login');
    await page.fill('[name="email"]', 'user@example.com');
    await page.fill('[name="password"]', 'password');
    await page.click('button[type="submit"]');

    await expect(page).toHaveURL('/dashboard');
    await expect(page.locator('h1')).toContainText('Welcome');
  });

  test('should show error for invalid credentials', async ({ page }) => {
    await page.goto('/login');
    await page.fill('[name="email"]', 'invalid@example.com');
    await page.fill('[name="password"]', 'wrong');
    await page.click('button[type="submit"]');

    await expect(page.locator('.error')).toContainText('Invalid credentials');
  });
});
```

**Claude Code 辅助**：

```markdown
👤 你：为用户注册流程编写 E2E 测试

步骤：
1. 访问注册页面
2. 填写表单
3. 提交
4. 验证邮件发送
5. 点击验证链接
6. 确认注册成功

🤖 Claude：[生成 Playwright 测试]
✅ 完整流程
✅ 等待和断言
✅ 错误处理
```

### 4. 性能测试 (Performance Testing)

**定义**：测试系统性能指标

**类型**：

```markdown
**负载测试**：
- 正常负载下的表现

**压力测试**：
- 极限负载下的表现

**基准测试**：
- 性能基准对比
```

**示例**：

```typescript
// performance/benchmark.test.ts
import { performance } from 'perf_hooks';

describe('Performance Benchmarks', () => {
  it('should process 1000 items in < 100ms', () => {
    const start = performance.now();

    // 执行操作
    processItems(1000);

    const duration = performance.now() - start;
    expect(duration).toBeLessThan(100);
  });

  it('should handle concurrent requests', async () => {
    const requests = Array(100).fill(null).map(() =>
      fetch('/api/data')
    );

    const start = performance.now();
    await Promise.all(requests);
    const duration = performance.now() - start;

    expect(duration).toBeLessThan(5000);
  });
});
```

---

## Claude Code 辅助测试

### 1. 生成测试代码

**单元测试**：

```markdown
👤 你：为这个函数生成单元测试

@src/utils/validation.ts

函数：validateEmail(email: string): boolean

要求：
- 有效邮箱返回 true
- 无效邮箱返回 false
- 包含边界情况

🤖 Claude：[生成 Jest 测试]
```typescript
describe('validateEmail', () => {
  it('should return true for valid emails', () => {
    expect(validateEmail('user@example.com')).toBe(true);
    expect(validateEmail('user.name@example.co.uk')).toBe(true);
  });

  it('should return false for invalid emails', () => {
    expect(validateEmail('invalid')).toBe(false);
    expect(validateEmail('@example.com')).toBe(false);
    expect(validateEmail('user@')).toBe(false);
  });

  it('should handle edge cases', () => {
    expect(validateEmail('')).toBe(false);
    expect(validateEmail(null)).toBe(false);
    expect(validateEmail(undefined)).toBe(false);
  });
});
```
```

### 2. 生成测试数据

**Mock 数据**：

```markdown
👤 你：生成用户 API 的测试数据

需要：
- 10个有效用户
- 5个无效用户
- 各种边界情况

🤖 Claude：[生成测试数据]
```typescript
// test-data/users.ts
export const validUsers = [
  { id: 1, name: 'Alice', email: 'alice@example.com', age: 25 },
  { id: 2, name: 'Bob', email: 'bob@example.com', age: 30 },
  // ...
];

export const invalidUsers = [
  { id: -1, name: '', email: 'invalid', age: -1 },
  { id: 0, name: null, email: null, age: null },
  // ...
];

export const boundaryCases = [
  { id: Number.MAX_SAFE_INTEGER, name: 'A'.repeat(255), ... },
  { id: 1, name: '用户名', email: '用户@example.com', ... },
];
```
```

### 3. 生成测试场景

**场景描述**：

```markdown
👤 你：为购物车功能生成测试场景

功能：
- 添加商品
- 修改数量
- 删除商品
- 计算总价

🤖 Claude：[生成测试场景]
```typescript
describe('Shopping Cart', () => {
  describe('Add to Cart', () => {
    it('should add item to empty cart');
    it('should add item to existing cart');
    it('should increment quantity if item exists');
    it('should handle out of stock items');
  });

  describe('Update Quantity', () => {
    it('should update item quantity');
    it('should remove item when quantity is 0');
    it('should not allow negative quantity');
    it('should not exceed available stock');
  });

  describe('Remove from Cart', () => {
    it('should remove item from cart');
    it('should clear cart when all items removed');
    it('should handle non-existent item');
  });

  describe('Calculate Total', () => {
    it('should calculate correct total');
    it('should apply discount code');
    it('should calculate tax');
    it('should handle free shipping');
  });
});
```
```

### 4. 诊断测试失败

**失败分析**：

```markdown
👤 你：这个测试失败了，帮我分析

@tests/unit/user.test.ts

失败信息：
  Expected: "Alice"
  Received: "undefined"

🤖 Claude：[分析失败原因]
可能的原因：
1. ✅ 最可能：User 对象未正确初始化
2. ✅ 数据库查询未返回数据
3. ✅ Mock 未正确设置

建议修复：
```typescript
beforeEach(() => {
  // ✅ 添加初始化
  userService = new UserService(mockDb);
  jest.clearAllMocks();
});

it('should return user name', async () => {
  // ✅ Mock 数据库返回
  mockDb.findById.mockResolvedValue({
    id: 1,
    name: 'Alice'
  });

  const user = await userService.findById(1);
  expect(user.name).toBe('Alice');
});
```
```

---

## 测试框架集成

### Jest

**配置**：

```json
// jest.config.js
module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'node',
  roots: ['<rootDir>/src'],
  testMatch: ['**/__tests__/**/*.ts', '**/?(*.)+(spec|test).ts'],
  moduleNameMapper: {
    '^@/(.*)$': '<rootDir>/src/$1'
  },
  collectCoverageFrom: [
    'src/**/*.ts',
    '!src/**/*.d.ts',
    '!src/**/*.test.ts',
    '!src/**/__tests__/**'
  ],
  coverageThreshold: {
    global: {
      branches: 80,
      functions: 80,
      lines: 80,
      statements: 80
    }
  }
};
```

**使用 Claude Code 配置**：

```markdown
👤 你：为我的 TypeScript 项目配置 Jest

项目结构：
- src/: 源代码
- tests/: 测试文件

要求：
- TypeScript 支持
- 覆盖率 80%
- 路径别名 @/

🤖 Claude：[生成完整配置]
✅ jest.config.js
✅ package.json scripts
✅ tsconfig.json
```

### Vitest

**优势**：

```
✅ 更快（原生 ESM）
✅ 与 Vite 集成
✅ 兼容 Jest API
```

**配置**：

```typescript
// vitest.config.ts
import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    globals: true,
    environment: 'node',
    include: ['**/*.{test,spec}.{ts,tsx}'],
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html'],
      thresholds: {
        lines: 80,
        functions: 80,
        branches: 80,
        statements: 80
      }
    }
  }
});
```

### Playwright (E2E)

**配置**：

```typescript
// playwright.config.ts
import { defineConfig } from '@playwright/test';

export default defineConfig({
  testDir: './e2e',
  timeout: 30000,
  retries: process.env.CI ? 2 : 0,
  use: {
    baseURL: 'http://localhost:3000',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
  },
  projects: [
    {
      name: 'chromium',
      use: { browserName: 'chromium' },
    },
    {
      name: 'firefox',
      use: { browserName: 'firefox' },
    },
  ],
});
```

**Claude Code 生成测试**：

```markdown
👤 你：为登录页面生成 Playwright 测试

@src/pages/Login.tsx

测试场景：
- 成功登录
- 密码错误
- 邮箱格式错误
- 记住我功能

🤖 Claude：[生成 E2E 测试]
✅ 完整流程
✅ 断言验证
✅ 错误处理
```

---

## 自动化测试策略

### 测试金字塔

```
           /\
          /  \
         / E2E \        少量
        /------\
       /        \
      /集成测试 \      中等
     /----------\
    /            \
   /  单元测试    \    大量
  /----------------\
```

**原则**：

```
✅ 70-80% 单元测试
   - 快速、便宜、可靠

✅ 15-20% 集成测试
   - 真实场景、发现问题

✅ 5-10% E2E 测试
   - 关键流程、用户视角

❌ 避免倒金字塔
   - 大量 E2E 测试
   - 慢、贵、难维护
```

### 测试覆盖率

**合理目标**：

```
核心业务逻辑：90-100%
   - 支付、安全、数据

通用功能代码：70-80%
   - 工具函数、组件

UI/展示代码：50-70%
   - 样式、布局

配置文件：30-50%
   - 简单配置
```

**Claude Code 分析覆盖率**：

```markdown
👤 你：分析 @src/ 的测试覆盖率

找出：
1. 未测试的文件
2. 未覆盖的分支
3. 建议优先测试的模块

🤖 Claude：[分析报告]
**未测试文件**：
- src/services/payment.ts（高优先级）
- src/utils/formatter.ts（中优先级）

**未覆盖分支**：
- src/auth/login.ts:45（错误处理）
- src/api/client.ts:78（重试逻辑）

**建议**：
优先为支付和认证模块补充测试
```

### 测试组织

**目录结构**：

```
project/
├── src/
│   ├── components/
│   │   └── Button.tsx
│   └── utils/
│       └── helpers.ts
│
└── tests/
    ├── unit/
    │   ├── components/
    │   │   └── Button.test.tsx
    │   └── utils/
    │       └── helpers.test.ts
    ├── integration/
    │   └── auth.flow.test.ts
    └── e2e/
        └── user.spec.ts
```

**或 colocated**：

```
src/
├── components/
│   ├── Button.tsx
│   └── Button.test.tsx
└── utils/
    ├── helpers.ts
    └── helpers.test.ts
```

---

## CI/CD 集成

### GitHub Actions

**工作流**：

```yaml
# .github/workflows/test.yml

name: Test Suite

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  test:
    runs-on: ubuntu-latest

    strategy:
      matrix:
        node-version: [18.x, 20.x]

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: ${{ matrix.node-version }}
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Run linter
        run: npm run lint

      - name: Run type check
        run: npm run type-check

      - name: Run unit tests
        run: npm run test:unit -- --coverage

      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          files: ./coverage/lcov.info

      - name: Run integration tests
        run: npm run test:integration

      - name: Run E2E tests
        run: npm run test:e2e

      - name: Upload test results
        if: always()
        uses: actions/upload-artifact@v3
        with:
          name: test-results-${{ matrix.node-version }}
          path: test-results/
```

**使用 Claude Code 创建**：

```markdown
👤 你：创建 CI/CD 工作流

要求：
- 多 Node 版本测试
- 运行所有测试类型
- 上传覆盖率到 Codecov
- 失败时上传测试结果

🤖 Claude：[生成 workflow 文件]
✅ 完整的 GitHub Actions 配置
✅ 测试矩阵
✅ 覆盖率上传
✅ 结果归档
```

### GitLab CI

**配置**：

```yaml
# .gitlab-ci.yml

stages:
  - test
  - report

variables:
  NODE_ENV: test

cache:
  key: ${CI_COMMIT_REF_SLUG}
  paths:
    - node_modules/

unit-tests:
  stage: test
  image: node:18
  script:
    - npm ci
    - npm run test:unit -- --coverage
  coverage: '/All files[^|]*\|[^|]*\s+([\d\.]+)/'
  artifacts:
    reports:
      coverage_report:
        coverage_format: cobertura
        path: coverage/cobertura-coverage.xml
    paths:
      - coverage/

integration-tests:
  stage: test
  image: node:18
  services:
    - postgres:15
    - redis:7
  variables:
    POSTGRES_DB: test_db
    POSTGRES_USER: test_user
    POSTGRES_PASSWORD: test_pass
  script:
    - npm ci
    - npm run test:integration

e2e-tests:
  stage: test
  image: mcr.microsoft.com/playwright:v1.40.0
  script:
    - npm ci
    - npx playwright install --with-deps
    - npm run test:e2e
  artifacts:
    when: always()
    paths:
      - playwright-report/
      - test-results/
```

### 并行测试

**加速策略**：

```javascript
// jest.config.js
module.exports = {
  maxWorkers: '50%',
  // 或
  maxWorkers: 4,
};
```

```markdown
👤 你：优化我的测试运行速度

当前问题：
- 500个测试，运行时间5分钟
- CI 经常超时

🤖 Claude：[优化方案]
1. ✅ 并行运行：maxWorkers: 4
2. ✅ 测试分片：按文件分组
3. ✅ 减少不必要的等待
4. ✅ 使用 mock 替代真实数据库

预期：5分钟 → 1分钟
```

---

## 实战案例

### 案例1: TDD 开发流程

**场景**：使用测试驱动开发实现功能

**流程**：

```markdown
# 第1步：编写失败的测试

👤 你：创建一个测试，验证用户注册功能

@tests/unit/user.service.test.ts

测试：
- 邮箱格式验证
- 密码强度检查
- 重复邮箱检测

🤖 Claude：[生成测试代码]
```typescript
describe('User Registration', () => {
  it('should validate email format', async () => {
    await expect(
      userService.register({ email: 'invalid', password: 'Pass123!' })
    ).rejects.toThrow('Invalid email');
  });

  it('should check password strength', async () => {
    await expect(
      userService.register({ email: 'user@example.com', password: 'weak' })
    ).rejects.toThrow('Weak password');
  });

  it('should detect duplicate email', async () => {
    await userService.register({
      email: 'user@example.com',
      password: 'Pass123!'
    });

    await expect(
      userService.register({
        email: 'user@example.com',
        password: 'Pass123!'
      })
    ).rejects.toThrow('Email already exists');
  });
});
```

# 第2步：运行测试（失败）
! npm test

# 第3步：编写最小代码使测试通过

👤 你：实现用户注册功能，使测试通过

@src/services/user.service.ts

🤖 Claude：[实现功能]
```typescript
async register(data: RegisterData): Promise<User> {
  // 验证邮箱
  if (!this.isValidEmail(data.email)) {
    throw new Error('Invalid email');
  }

  // 检查密码强度
  if (!this.isStrongPassword(data.password)) {
    throw new Error('Weak password');
  }

  // 检查重复
  const existing = await this.findByEmail(data.email);
  if (existing) {
    throw new Error('Email already exists');
  }

  // 创建用户
  return this.userRepository.create(data);
}
```

# 第4步：重构（测试仍然通过）

👤 你：优化代码结构，提取验证逻辑

🤖 Claude：[重构代码]
✅ 提取验证类
✅ 改进错误处理
✅ 添加类型定义

# 第5步：重复
继续下一个功能...
```

### 案例2: 遗留代码添加测试

**场景**：为没有测试的旧代码添加测试

**策略**：

```markdown
# 第1步：识别关键功能

👤 你：分析 @src/legacy/payment.ts

找出：
1. 公共接口
2. 关键逻辑
3. 依赖关系

🤖 Claude：[分析代码]
**公共接口**：
- processPayment(amount, card)
- refund(transactionId)
- getStatus(transactionId)

**关键逻辑**：
- 卡号验证
- 支付网关调用
- 交易状态更新

**依赖**：
- PaymentGateway
- TransactionRepository
- Logger

# 第2步：制定测试计划

👤 你：为支付模块制定测试计划

优先级：
1. 高：processPayment（核心功能）
2. 中：refund（常见操作）
3. 低：getStatus（简单查询）

🤖 Claude：[生成测试计划]
✅ 测试场景列表
✅ 测试数据准备
✅ Mock 策略

# 第3步：逐步添加测试

👤 你：为 processPayment 添加测试

使用 Mock 隔离外部依赖

🤖 Claude：[生成测试]
```typescript
describe('processPayment', () => {
  it('should process valid payment', async () => {
    const mockGateway = {
      charge: jest.fn().mockResolvedValue({
        success: true,
        transactionId: 'txn_123'
      })
    };

    const payment = new PaymentService(mockGateway);
    const result = await payment.processPayment(100, cardDetails);

    expect(result.success).toBe(true);
    expect(result.transactionId).toBe('txn_123');
  });

  it('should handle payment failure', async () => {
    const mockGateway = {
      charge: jest.fn().mockResolvedValue({
        success: false,
        error: 'Insufficient funds'
      })
    };

    const payment = new PaymentService(mockGateway);

    await expect(
      payment.processPayment(100, cardDetails)
    ).rejects.toThrow('Insufficient funds');
  });

  // 更多测试...
});
```

# 第4步：提高覆盖率

👤 你：分析覆盖率报告
补充未覆盖的分支

🤖 Claude：[补充测试]
✅ 边界情况
✅ 错误处理
✅ 异常流程

# 第5步：重构优化

👤 你：基于测试信心，重构代码

🤖 Claude：[安全重构]
✅ 提取函数
✅ 改进命名
✅ 优化结构
（测试保证功能不变）
```

### 案例3: 自动化回归测试

**场景**：每次代码提交自动运行回归测试

**配置**：

```markdown
# .github/workflows/regression.yml

name: Regression Tests

on:
  push:
    paths:
      - 'src/**'
      - 'tests/**'

jobs:
  regression:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3
        with:
          fetch-depth: 0  # 获取完整历史

      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: 18

      - name: Install dependencies
        run: npm ci

      - name: Identify changed files
        id: changed
        run: |
          FILES=$(git diff --name-only ${{ github.event.before }} ${{ github.sha }})
          echo "files=$FILES" >> $GITHUB_OUTPUT

      - name: Run affected tests
        run: |
          echo "Running tests for: ${{ steps.changed.outputs.files }}"
          npm run test -- --onlyChanged --coverage

      - name: Compare coverage
        run: |
          npm run test:coverage-compare
        # 检查覆盖率是否下降

      - name: Run regression suite
        run: npm run test:regression
        # 运行关键功能测试

      - name: Notify on failure
        if: failure()
        uses: actions/github-script@v6
        with:
          script: |
            github.rest.issues.create({
              owner: context.repo.owner,
              repo: context.repo.repo,
              title: '❌ Regression Test Failed',
              body: '回归测试失败，请立即检查！',
              labels: ['bug', 'regression']
            })
```

**Claude Code 生成**：

```markdown
👤 你：创建回归测试工作流

关键功能：
- 用户认证
- 支付处理
- 数据访问

要求：
- 只运行受影响的测试
- 覆盖率对比
- 失败时通知

🤖 Claude：[生成完整工作流]
✅ 智能测试选择
✅ 覆盖率保护
✅ 自动通知
```

---

## Windows 专属

### PowerShell 测试脚本

**运行测试**：

```powershell
# scripts/run-tests.ps1

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet('unit', 'integration', 'e2e', 'all')]
    [string]$TestType = 'all'
)

# 颜色输出
function Write-ColorOutput($ForegroundColor) {
    $fc = $host.UI.RawUI.ForegroundColor
    $host.UI.RawUI.ForegroundColor = $ForegroundColor
    if ($args) {
        Write-Output $args
    }
    $host.UI.RawUI.ForegroundColor = $fc
}

# 运行单元测试
function Run-UnitTests {
    Write-ColorOutput Green "运行单元测试..."
    npm run test:unit

    if ($LASTEXITCODE -eq 0) {
        Write-ColorOutput Green "✅ 单元测试通过"
    } else {
        Write-ColorOutput Red "❌ 单元测试失败"
        exit 1
    }
}

# 运行集成测试
function Run-IntegrationTests {
    Write-ColorOutput Green "运行集成测试..."
    npm run test:integration

    if ($LASTEXITCODE -eq 0) {
        Write-ColorOutput Green "✅ 集成测试通过"
    } else {
        Write-ColorOutput Red "❌ 集成测试失败"
        exit 1
    }
}

# 运行 E2E 测试
function Run-E2ETests {
    Write-ColorOutput Green "运行 E2E 测试..."
    npm run test:e2e

    if ($LASTEXITCODE -eq 0) {
        Write-ColorOutput Green "✅ E2E 测试通过"
    } else {
        Write-ColorOutput Red "❌ E2E 测试失败"
        exit 1
    }
}

# 主逻辑
switch ($TestType) {
    'unit' { Run-UnitTests }
    'integration' { Run-IntegrationTests }
    'e2e' { Run-E2ETests }
    'all' {
        Run-UnitTests
        Run-IntegrationTests
        Run-E2ETests
    }
}

Write-ColorOutput Green "所有测试完成！"
```

### Windows 任务计划

**定时运行测试**：

```powershell
# 创建定时测试任务

$action = New-ScheduledTaskAction -Execute 'pwsh.exe' -Argument '-File "D:/scripts/run-tests.ps1 -TestType all"'
$trigger = New-ScheduledTaskTrigger -Daily -At '2:00AM'
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

Register-ScheduledTask -Action $action -Trigger $trigger -Settings $settings -TaskName 'Daily Regression Tests'
```

### 路径处理

**测试路径规范化**：

```powershell
# 确保路径正确

$projectRoot = "D:/Projects/app"
$testDir = Join-Path $projectRoot "tests"

# 使用正斜杠
$testDir = $testDir.Replace('\', '/')

# 运行测试
Set-Location $testDir
npm test
```

---

## 最佳实践

### 1. 测试命名

**清晰的命名**：

```typescript
// ✅ 好：描述性强
it('should return user when email exists', async () => {});
it('should throw error when email is invalid', async () => {});

// ❌ 不好：模糊不清
it('works', async () => {});
it('test2', async () => {});
```

### 2. AAA 模式

**Arrange-Act-Assert**：

```typescript
it('should calculate discount', () => {
  // Arrange（准备）
  const price = 100;
  const discount = 0.2;
  const calculator = new PriceCalculator();

  // Act（执行）
  const result = calculator.applyDiscount(price, discount);

  // Assert（断言）
  expect(result).toBe(80);
});
```

### 3. 独立性

**每个测试独立**：

```typescript
// ✅ 好：独立设置
describe('UserService', () => {
  beforeEach(() => {
    // 每个测试前重置
    userService = new UserService();
  });

  it('test 1', () => {
    // 不依赖其他测试
  });

  it('test 2', () => {
    // 不依赖其他测试
  });
});

// ❌ 不好：相互依赖
it('test 1', () => {
  globalState = 'modified';
});

it('test 2', () => {
  // 依赖 test 1 的状态
  expect(globalState).toBe('modified');
});
```

### 4. 快速反馈

**单元测试要快**：

```typescript
// ✅ 快速：使用 Mock
it('should save user', async () => {
  mockDb.save.mockResolvedValue({ id: 1 });
  const result = await service.save({ name: 'Alice' });
  expect(result.id).toBe(1);
});

// ❌ 慢：真实数据库
it('should save user', async () => {
  const result = await service.save({ name: 'Alice' });
  // 真实数据库操作，慢
});
```

### 5. 有意义的断言

**精确的断言**：

```typescript
// ✅ 好：精确
expect(user.name).toBe('Alice');
expect(user.age).toBeGreaterThan(0);

// ❌ 不好：模糊
expect(user).toBeTruthy();
```

---

## 常见问题

### Q1: 测试运行太慢怎么办？

**A**: 优化策略

1. **并行运行**
   ```javascript
   maxWorkers: 4
   ```

2. **只运行相关测试**
   ```bash
   npm test -- --onlyChanged
   ```

3. **使用 Mock**
   ```typescript
   // 避免真实 I/O
   mockFs.readFile.mockResolvedValue('data');
   ```

4. **分离快慢测试**
   ```typescript
   // fast.test.ts
   // slow.test.ts
   ```

### Q2: Mock 太多怎么办？

**A**: 平衡 Mock 和真实测试

```
✅ 适合 Mock：
- 外部 API
- 数据库
- 文件系统

✅ 适合真实：
- 业务逻辑
- 数据转换
- 组件集成
```

### Q3: 测试脆弱，经常失败？

**A**: 提高稳定性

1. **等待策略**
   ```typescript
   await waitFor(() => {
     expect(element).toBeVisible();
   });
   ```

2. **重试机制**
   ```typescript
   jest.retryTimes(3);
   ```

3. **隔离测试**
   ```typescript
   beforeEach(() => {
     jest.clearAllMocks();
   });
   ```

---

## 故障排查

### 问题 1: 测试超时

**症状**：
```
Timeout: Async callback was not invoked within the 5000ms timeout
```

**解决方案**：

```typescript
// ✅ 增加超时
it('test', async () => {
  // ...
}, 10000);

// ✅ 或使用 Promise.race
it('test', async () => {
  const result = await Promise.race([
    operation(),
    delay(5000).then(() => { throw new Error('Timeout'); })
  ]);
});
```

### 问题 2: Mock 未生效

**症状**：
```
Expected: "mocked value"
Received: "real value"
```

**解决方案**：

```typescript
// ✅ 检查 Mock 位置
beforeEach(() => {
  // ✅ 在测试前设置
  mockFunction.mockResolvedValue('mocked');
});

it('test', async () => {
  // 使用 Mock
  const result = await mockFunction();
  expect(result).toBe('mocked');
});
```

### 问题 3: Windows 路径问题

**症状**：
```
Cannot find module 'C:\Projects\app\tests'
```

**解决方案**：

```powershell
# ✅ 使用正斜杠
$testPath = "C:/Projects/app/tests"

# ✅ 或 Join-Path
$testPath = Join-Path "C:" "Projects" "app" "tests"
```

---

## 总结

### 测试自动化价值

```
手动测试 → 自动化
    ↓
快速反馈
    ↓
早期发现问题
    ↓
降低修复成本
    ↓
提升代码质量
```

### 下一步

1. **开始实践**
   - 为现有代码添加测试
   - 使用 TDD 开发新功能
   - 集成到 CI/CD

2. **持续改进**
   - 监控测试覆盖率
   - 优化测试速度
   - 改进测试质量

3. **团队协作**
   - 建立测试规范
   - 代码审查包含测试
   - 知识分享

---

## 相关资源

### 项目文档
- [工作流自动化](./03-workflow-automation.md) - 工作流基础
- [CI/CD 集成](./02-ci-cd-integration.md) - 持续集成

### 测试框架
- [Jest 文档](https://jestjs.io/)
- [Vitest 文档](https://vitest.dev/)
- [Playwright 文档](https://playwright.dev/)

---

**最后更新**: 2026-01-18
**难度**: ⭐⭐⭐⭐
**阅读时间**: 45分钟
**重要性**: ⭐⭐⭐⭐
