---
type: concept
title: Agent记忆
tags: [agent-memory, memory, context-engineering, agent-runtime]
depends_on: ["[[Concept_上下文窗口]]", "[[Concept_上下文工程]]"]
required_by: []
sources: ["[[raw/Anthropic Effective Context Engineering for AI Agents.html]]"]
timestamp: 2026-07-16
understanding: working
---

## 定义

Agent 记忆是在 Context Window 之外持久化信息，并在后续任务或后续上下文窗口中按需读回的系统能力。本文把结构化笔记作为最小、可解释的实现：Agent 定期写入关键进度、决定、依赖和待办，后续再把相关笔记放回当前上下文。

## 机制

    任务事件 / 决策 / 进度
      -> 判断是否值得写入
      -> 保存笔记及来源、时间、范围
      -> 后续任务检索或直接读取
      -> 与当前任务状态一起组装进上下文
      -> 更新、过期、纠正或删除

记忆可以保存用户偏好、项目决定、已验证结论和长期任务进度。原始对话、工具输出和外部文档不应不加区分地全部写入；它们往往需要压缩、索引或保留为可追溯的原始记录。

## 为什么这样设计

上下文窗口在单次推理后不会自动成为可靠的跨会话状态。长任务若只保留完整历史，会增加 token 成本和上下文污染；若只做摘要，又可能丢失后来才显得重要的细节。结构化笔记以较低的 token 成本保留可恢复的任务骨架。

## 边界与局限

- Agent 记忆不等于 [[Concept_检索增强生成]]。RAG 优先解决“当前问题需要哪些外部证据”；记忆还要处理写入、更新、冲突、权限和删除。
- Agent 记忆不等于 Context Window 或 KV Cache：前者是跨窗口的信息治理，后两者分别是当前调用容量与推理加速状态。
- “写入更多”不一定更好。错误、陈旧或越权写入会在后续任务中被反复放大，因此需要来源、时间、作用域、可编辑/删除和冲突策略。
- 本页只建立工程边界，不主张某种唯一存储后端或记忆分类法；具体实现应根据任务、隐私和评测确定。

## 与 Agent Runtime 的关系

Memory Store 需要与 Context Manager、Event Log 和权限策略协作：Event Log 保存可追溯的原始过程，Memory 保存可复用的提炼信息，Context Manager 决定本轮实际带回哪些内容。

## 理解演进

- [2026-07-16] 初始理解（来源：[[raw/Anthropic Effective Context Engineering for AI Agents.html]]）：结构化笔记是 Agent 在有限上下文之外维持长任务连续性的简单 Memory 模式。它的价值不在“存得多”，而在保存少量能恢复目标、进度和关键决定的信息。

