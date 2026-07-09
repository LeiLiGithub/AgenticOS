# Agent Runtime 学习计划（3个月验证版）

> 状态：历史验证计划。根目录 [[学习规划]] 为当前权威主线；本文件保留此前的周级目标和验证问题，供后续回顾与比较。

## 目标定位

本计划不是为了在3个月内完成转型，而是为了验证未来3年的职业投资方向：

> Agent Runtime 是否值得长期投入。

3个月结束时，需要回答：

1. 我是否真正喜欢 Agent Runtime？
2. Android经验是否能够迁移到 Agent Runtime？
3. 市场是否存在真实机会？
4. 我是否愿意未来1~3年持续投入？

---

## 学习原则

### 不追求

- CUDA
- 分布式训练
- 模型训练工程
- FlashAttention源码
- RLHF实现细节

### 必须掌握

- Transformer基本思想
- Attention机制
- Context Window
- Token
- Tool Calling
- Agent
- Agent Framework
- Agent Runtime

---

# 第一阶段（第1个月）

目标：建立Agent世界观

## Week1：LLM基础认知

学习：

- Token
- Embedding
- Attention
- Context Window
- KV Cache

验收：

- 为什么LLM有上下文限制？
- 为什么长上下文会变慢？
- 为什么Agent需要Memory？

输出：

《LLM基础认知笔记》

## Week2：Agent基础

学习：

- Planning
- Tool Calling
- Reflection
- Memory

验收：

- Agent与ChatGPT区别
- Agent与普通AI应用区别

输出：

Agent架构图

## Week3：Agent Framework

学习：

- LangGraph
- OpenAI Agents SDK

重点：State、Graph、Workflow

输出：

Framework对比文档

## Week4：Multi-Agent

学习：

- AutoGen
- OpenManus

输出：

Android Bug Fix Team协作架构图

---

# 第二阶段（第2个月）

目标：理解Agent Runtime

## Week5：OpenCode分析

关注：

- Task
- Planner
- Tool Registry
- Memory
- Session

输出：

OpenCode架构图

## Week6：OpenManus分析

关注：

- 多Agent协作
- 生命周期
- 状态管理

输出：

OpenManus运行时分析

## Week7：Task Runtime

设计：

- Task
- State
- Retry
- Timeout

输出：

Task Model设计文档

## Week8：Lifecycle

设计状态机：

- Created
- Running
- Waiting
- Completed
- Failed

输出：

Lifecycle设计图

---

# 第三阶段（第3个月）

目标：形成自己的Runtime理解

## Week9：Scheduler

研究：

- 任务调度
- 优先级
- 恢复机制

输出：

Scheduler设计文档

## Week10：Memory

研究：

- 短期记忆
- 长期记忆
- Context压缩

输出：

Memory Architecture

## Week11：Tool Runtime

研究：

- Tool注册
- Tool发现
- Tool权限
- Tool调用

输出：

Tool Registry设计图

## Week12：总结

完成：

《Android Agent Runtime v1.0》

包含：

- Task
- Lifecycle
- Scheduler
- Memory
- Tool Registry
- Agent Communication

---

# 最终验收

能够解释：

- Agent
- Agent Framework
- Agent Runtime
- Agentic OS

并完成：

1. OpenCode架构图
2. OpenManus分析文档
3. Task Model设计
4. Lifecycle设计图
5. Scheduler设计
6. Memory设计
7. Android Agent Runtime v1.0

最终给出结论：

- 继续投入
- 暂缓投入
- 放弃方向
