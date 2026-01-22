# 03 - First Project - 从零构建Todo应用

> **综合运用8个核心功能，完成第一个完整项目**

**阅读时间**: 30分钟
**难度**: ⭐⭐⭐
**项目时间**: 1-2小时
**前置要求**: 完成 [02-Core Features](./02-core-features.md)

---

## 项目概览

### 我们要构建什么？

一个功能完整的 **Todo List 应用**，包含：

- ✅ 添加、删除、编辑任务
- ✅ 标记完成/未完成
- ✅ 任务分类（工作/个人/学习）
- ✅ 数据持久化（LocalStorage）
- ✅ 响应式设计
- ✅ 完整的测试

### 技术栈

```
前端：React 18 + TypeScript
样式：TailwindCSS
状态：Zustand
构建：Vite
测试：Vitest + Testing Library
```

### 学习目标

通过这个项目，你将掌握：

1. ✅ 使用 @ 符号管理多文件项目
2. ✅ 使用 CLAUDE.md 指导开发
3. ✅ 使用 Plan 模式规划实施
4. ✅ 使用 Esc 撤销错误操作
5. ✅ 使用 ! 命令执行测试
6. ✅ 使用会话管理保存进度

---

## 步骤 1：项目初始化

### 1.1 创建项目目录

```powershell
# Windows
mkdir D:\Projects\my-todo-app
cd D:\Projects\my-todo-app

# macOS/Linux
mkdir ~/Projects/my-todo-app
cd ~/Projects/my-todo-app
```

### 1.2 启动 Claude Code 并初始化

```bash
claude --session todo-app
```

```
👤 你：/init

🤖 Claude：
正在分析项目...
这是一个空项目，建议从初始化开始。
```

### 1.3 创建项目结构（Plan模式）

```
👤 你：[Shift + Tab] 创建一个 React + TypeScript + Vite 的 Todo 应用项目结构

🤖 Claude：
=== PLAN ===

目标：初始化 React + TypeScript 项目

步骤：
1. 使用 Vite 创建项目
   !npm create vite@latest . -- --template react-ts
2. 安装依赖
   !npm install
3. 安装额外依赖
   - zustand (状态管理)
   - vitest (测试)
4. 配置 TailwindCSS
5. 创建基础目录结构
6. 创建 CLAUDE.md

预计时间：5-10分钟

确认执行吗？(yes/no)

👤 你：yes

🤖 Claude：
[执行步骤 1-6]
✅ 项目初始化完成
```

### 1.4 创建 CLAUDE.md

```
👤 你：创建 .claude/CLAUDE.md 文件，说明这是一个 Todo 应用项目

🤖 Claude：
[创建 .claude/CLAUDE.md]

内容：
```markdown
# Todo App - 项目说明

## 项目概述
一个功能完整的 Todo List 应用，用于学习和演示 Claude Code 的使用。

## 技术栈
- React 18 + TypeScript
- Vite (构建工具)
- TailwindCSS (样式)
- Zustand (状态管理)
- Vitest (测试框架)

## 项目结构
src/
├── components/      # React 组件
│   ├── TodoItem.tsx
│   ├── TodoList.tsx
│   └── TodoForm.tsx
├── store/          # Zustand 状态
│   └── todoStore.ts
├── types/          # TypeScript 类型
│   └── todo.ts
├── utils/          # 工具函数
│   └── localStorage.ts
└── App.tsx         # 主应用

## 代码规范
- 组件使用函数式组件 + Hooks
- 类型定义必须放在 types/ 目录
- 所有组件必须有 Props 类型定义
- 使用 TypeScript 严格模式
- 每个组件必须有对应的测试文件

## 重要约定
- 不修改 vite.config.ts（除非必要）
- 所有状态管理使用 Zustand
- 样式使用 TailwindCSS 类名
- 数据存储在 LocalStorage

## 测试要求
- 组件测试覆盖率 > 80%
- 所有工具函数必须有单元测试
```
```

---

## 步骤 2：核心数据结构

### 2.1 定义类型

```
👤 你：@src/types/todo.ts 创建 Todo 类型定义

🤖 Claude：
```typescript
// src/types/todo.ts

export interface Todo {
  id: string;
  text: string;
  completed: boolean;
  category: 'work' | 'personal' | 'study';
  createdAt: Date;
  updatedAt: Date;
}

export type TodoCategory = Todo['category'];

export interface TodoFilter {
  category?: TodoCategory;
  completed?: boolean;
  search?: string;
}
```
✅ 已创建 src/types/todo.ts
```

### 2.2 创建状态管理

```
👤 你：[Shift+Tab] 创建 Zustand store，管理 Todo 状态

🤖 Claude：
=== PLAN ===

目标：创建 Todo store

步骤：
1. 创建 src/store/todoStore.ts
2. 实现以下功能：
   - 添加 Todo
   - 删除 Todo
   - 切换完成状态
   - 编辑 Todo
   - 过滤 Todo
3. 集成 LocalStorage 持久化
4. 创建对应的单元测试

确认执行吗？

👤 你：yes

🤖 Claude：
```typescript
// src/store/todoStore.ts
import { create } from 'zustand';
import { persist } from 'zustand/middleware';
import type { Todo, TodoFilter } from '../types/todo';

interface TodoStore {
  todos: Todo[];
  addTodo: (text: string, category: Todo['category']) => void;
  deleteTodo: (id: string) => void;
  toggleTodo: (id: string) => void;
  editTodo: (id: string, text: string) => void;
  filteredTodos: (filter: TodoFilter) => Todo[];
}

export const useTodoStore = create<TodoStore>()(
  persist(
    (set, get) => ({
      todos: [],

      addTodo: (text, category) => {
        const newTodo: Todo = {
          id: Date.now().toString(),
          text,
          completed: false,
          category,
          createdAt: new Date(),
          updatedAt: new Date(),
        };
        set({ todos: [...get().todos, newTodo] });
      },

      deleteTodo: (id) => {
        set({ todos: get().todos.filter((todo) => todo.id !== id) });
      },

      toggleTodo: (id) => {
        set({
          todos: get().todos.map((todo) =>
            todo.id === id
              ? { ...todo, completed: !todo.completed, updatedAt: new Date() }
              : todo
          ),
        });
      },

      editTodo: (id, text) => {
        set({
          todos: get().todos.map((todo) =>
            todo.id === id
              ? { ...todo, text, updatedAt: new Date() }
              : todo
          ),
        });
      },

      filteredTodos: (filter) => {
        let todos = get().todos;

        if (filter.category) {
          todos = todos.filter((todo) => todo.category === filter.category);
        }

        if (filter.completed !== undefined) {
          todos = todos.filter((todo) => todo.completed === filter.completed);
        }

        if (filter.search) {
          todos = todos.filter((todo) =>
            todo.text.toLowerCase().includes(filter.search!.toLowerCase())
          );
        }

        return todos;
      },
    }),
    {
      name: 'todo-storage',
    }
  )
);
```
✅ 已创建 src/store/todoStore.ts
```

---

## 步骤 3：创建组件

### 3.1 TodoItem 组件

```
👤 你：@src/components/TodoItem.tsx 创建单个任务项组件

🤖 Claude：
```typescript
// src/components/TodoItem.tsx
import type { Todo } from '../types/todo';
import { useTodoStore } from '../store/todoStore';

interface TodoItemProps {
  todo: Todo;
}

export function TodoItem({ todo }: TodoItemProps) {
  const { toggleTodo, deleteTodo, editTodo } = useTodoStore();

  const handleEdit = () => {
    const newText = prompt('编辑任务:', todo.text);
    if (newText && newText.trim()) {
      editTodo(todo.id, newText.trim());
    }
  };

  return (
    <div className="flex items-center gap-3 p-4 bg-white rounded-lg shadow-sm hover:shadow-md transition-shadow">
      <input
        type="checkbox"
        checked={todo.completed}
        onChange={() => toggleTodo(todo.id)}
        className="w-5 h-5 text-blue-600 rounded focus:ring-2 focus:ring-blue-500"
      />

      <div className="flex-1">
        <p
          className={`text-lg ${
            todo.completed ? 'line-through text-gray-400' : 'text-gray-800'
          }`}
        >
          {todo.text}
        </p>
        <span className="text-sm text-gray-500">
          {todo.category} • {new Date(todo.createdAt).toLocaleDateString()}
        </span>
      </div>

      <div className="flex gap-2">
        <button
          onClick={handleEdit}
          className="px-3 py-1 text-blue-600 hover:bg-blue-50 rounded"
        >
          编辑
        </button>
        <button
          onClick={() => deleteTodo(todo.id)}
          className="px-3 py-1 text-red-600 hover:bg-red-50 rounded"
        >
          删除
        </button>
      </div>
    </div>
  );
}
```
✅ 已创建 src/components/TodoItem.tsx
```

### 3.2 TodoForm 组件

```
👤 你：@src/components/TodoForm.tsx 创建添加任务表单

🤖 Claude：
```typescript
// src/components/TodoForm.tsx
import { useState } from 'react';
import { useTodoStore } from '../store/todoStore';
import type { TodoCategory } from '../types/todo';

export function TodoForm() {
  const [text, setText] = useState('');
  const [category, setCategory] = useState<TodoCategory>('personal');
  const addTodo = useTodoStore((state) => state.addTodo);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (text.trim()) {
      addTodo(text.trim(), category);
      setText('');
    }
  };

  return (
    <form onSubmit={handleSubmit} className="mb-6">
      <div className="flex gap-3">
        <input
          type="text"
          value={text}
          onChange={(e) => setText(e.target.value)}
          placeholder="添加新任务..."
          className="flex-1 px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
        />

        <select
          value={category}
          onChange={(e) => setCategory(e.target.value as TodoCategory)}
          className="px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
        >
          <option value="work">工作</option>
          <option value="personal">个人</option>
          <option value="study">学习</option>
        </select>

        <button
          type="submit"
          className="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
        >
          添加
        </button>
      </div>
    </form>
  );
}
```
✅ 已创建 src/components/TodoForm.tsx
```

### 3.3 TodoList 组件

```
👤 你：@src/components/TodoList.tsx 创建任务列表

🤖 Claude：
```typescript
// src/components/TodoList.tsx
import { useTodoStore } from '../store/todoStore';
import { TodoItem } from './TodoItem';

export function TodoList() {
  const todos = useTodoStore((state) => state.todos);

  if (todos.length === 0) {
    return (
      <div className="text-center py-12 text-gray-500">
        <p className="text-lg">暂无任务</p>
        <p className="text-sm">添加一个新任务开始吧！</p>
      </div>
    );
  }

  return (
    <div className="space-y-3">
      {todos.map((todo) => (
        <TodoItem key={todo.id} todo={todo} />
      ))}
    </div>
  );
}
```
✅ 已创建 src/components/TodoList.tsx
```

---

## 步骤 4：主应用

### 4.1 更新 App.tsx

```
👤 你：@src/App.tsx 整合所有组件

🤖 Claude：
```typescript
// src/App.tsx
import { TodoForm } from './components/TodoForm';
import { TodoList } from './components/TodoList';

function App() {
  return (
    <div className="min-h-screen bg-gray-100 py-8">
      <div className="max-w-2xl mx-auto px-4">
        <h1 className="text-4xl font-bold text-center mb-8 text-gray-800">
          My Todo App
        </h1>

        <div className="bg-white rounded-lg shadow-lg p-6">
          <TodoForm />
          <TodoList />
        </div>

        <div className="mt-4 text-center text-sm text-gray-600">
          使用 Claude Code 构建 • {new Date().getFullYear()}
        </div>
      </div>
    </div>
  );
}

export default App;
```
✅ 已更新 src/App.tsx
```

---

## 步骤 5：测试和运行

### 5.1 运行开发服务器

```
👤 你：!npm run dev

🤖 Claude：
[执行 npm run dev]

VITE v5.0.0  ready in 500 ms

➜  Local:   http://localhost:5173/
➜  Network: use --host to expose

✅ 开发服务器已启动

在浏览器中打开 http://localhost:5173/ 查看应用
```

### 5.2 创建测试

```
👤 你：为 todoStore 创建单元测试

🤖 Claude：
```typescript
// src/store/todoStore.test.ts
import { describe, it, expect, beforeEach } from 'vitest';
import { useTodoStore } from './todoStore';

describe('TodoStore', () => {
  beforeEach(() => {
    // 重置 store
    useTodoStore.setState({ todos: [] });
  });

  it('should add a todo', () => {
    const store = useTodoStore.getState();
    store.addTodo('Test task', 'work');

    expect(store.todos).toHaveLength(1);
    expect(store.todos[0].text).toBe('Test task');
    expect(store.todos[0].category).toBe('work');
  });

  it('should toggle todo completion', () => {
    const store = useTodoStore.getState();
    store.addTodo('Test task', 'personal');
    const todoId = store.todos[0].id;

    store.toggleTodo(todoId);
    expect(store.todos[0].completed).toBe(true);

    store.toggleTodo(todoId);
    expect(store.todos[0].completed).toBe(false);
  });

  it('should delete a todo', () => {
    const store = useTodoStore.getState();
    store.addTodo('Test task', 'study');
    const todoId = store.todos[0].id;

    store.deleteTodo(todoId);
    expect(store.todos).toHaveLength(0);
  });

  it('should filter todos by category', () => {
    const store = useTodoStore.getState();
    store.addTodo('Work task', 'work');
    store.addTodo('Personal task', 'personal');

    const workTodos = store.filteredTodos({ category: 'work' });
    expect(workTodos).toHaveLength(1);
    expect(workTodos[0].category).toBe('work');
  });
});
```
✅ 已创建 src/store/todoStore.test.ts
```

### 5.3 运行测试

```
👤 你：!npm run test

🤖 Claude：
[执行 npm run test]

✓ src/store/todoStore.test.ts (4)
  ✓ TodoStore (4)
    ✓ should add a todo
    ✓ should toggle todo completion
    ✓ should delete a todo
    ✓ should filter todos by category

Test Files  1 passed (1)
Tests  4 passed (4)

✅ 所有测试通过！
```

---

## 步骤 6：优化和部署

### 6.1 构建生产版本

```
👤 你：!npm run build

🤖 Claude：
[执行 npm run build]

vite v5.0.0 building for production...
✓ 45 modules transformed.
dist/index.html                  0.45 kB
dist/assets/index-abc123.css     25.12 kB
dist/assets/index-def456.js      75.34 kB

✅ 构建完成！
```

### 6.2 Git 提交

```
👤 你：初始化 Git 并创建首次提交

🤖 Claude：
!git init
!git add .
!git commit -m "feat: 初始化 Todo 应用

- 使用 React + TypeScript + Vite
- Zustand 状态管理
- TailwindCSS 样式
- 完整单元测试

使用 Claude Code 构建"
```

---

## 项目总结

### 我们学到了什么？

1. **@ 符号上下文** ✅
   - 引用多个文件创建组件
   - 快速查看和编辑代码

2. **CLAUDE.md** ✅
   - 指导整个开发过程
   - 保持代码规范一致性

3. **Plan 模式** ✅
   - 规划项目结构
   - 分步骤执行

4. **Esc 撤销** ✅
   - 尝试不同实现方案
   - 快速恢复错误操作

5. **! 命令执行** ✅
   - 运行开发服务器
   - 执行测试
   - Git 操作

6. **会话管理** ✅
   - 保存开发进度
   - 下次继续工作

### 功能检查

- [x] 添加任务
- [x] 删除任务
- [x] 编辑任务
- [x] 标记完成
- [x] 任务分类
- [x] 数据持久化
- [x] 响应式设计
- [x] 单元测试

### 扩展建议

```
可以继续添加：
1. 任务优先级
2. 截止日期
3. 任务搜索和过滤
4. 拖拽排序
5. 主题切换
6. 任务导出功能
```

---

## 常见问题

### Q: 组件样式不对？

A: 检查 TailwindCSS 配置：
```
@tailwind base;
@tailwind components;
@tailwind utilities;
```

### Q: LocalStorage 不工作？

A: 确保使用了 zustand 的 persist middleware：
```typescript
persist(
  (set, get) => ({ /* store */ }),
  { name: 'todo-storage' }
)
```

### Q: 测试失败？

A: 检查 vitest.config.ts 配置，确保正确设置测试环境。

---

## 下一步

**最佳实践** → [04 - Best Practices](./04-best-practices.md)

学习如何避免常见错误！

---

**恭喜你完成了第一个项目！** 🎉

**最后更新**: 2025-01-17
**下一章节**: [04 - Best Practices](./04-best-practices.md)
