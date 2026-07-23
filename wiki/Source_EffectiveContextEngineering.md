---
type: source
title: Effective context engineering for AI agents
source_file: "[[raw/Anthropic Effective Context Engineering for AI Agents.html]]"
tags: [context-engineering, agent-memory, retrieval, agent-runtime]
timestamp: 2026-07-16
key_concepts: ["[[Concept_上下文工程]]", "[[Concept_Agent记忆]]", "[[Concept_上下文窗口]]", "[[Concept_检索增强生成]]", "[[Concept_长上下文信息利用]]"]
---

## 来源定位

Anthropic 于 2025-09-29 发布的工程文章。它不是一篇受控实验论文，而是基于其 Agent 实践提出的 Context Engineering 心智模型：把 Context 视为有限资源，在每次推理时从不断增长的信息集合中挑选最有信号的部分。

本文依据 Vault 中的不可变 HTML 快照；网页实现、产品名称和 Claude Code 的具体行为会随时间变化。可复用的是设计原则与取舍，不是文章中的模型、工具或产品细节。

## 核心机制

1. Context Engineering 不只优化 system prompt，而是管理一次推理中所有进入模型的 token：指令、工具定义、示例、消息历史、外部资料和工具结果。
2. 目标不是把上下文尽量填满，而是为当前目标保留尽量小、但信号足够强的 token 集合。
3. 检索可分为预先召回和运行时按需探索。后者保留文件路径、链接或查询等轻量引用，再通过工具逐步加载内容；实际系统可采用混合策略。
4. 长任务的三种互补手段是：压缩历史、结构化笔记，以及把深度探索隔离到子 Agent。它们分别降低历史冗余、保存跨窗口关键信息和隔离局部搜索上下文。

## 与 Memory / RAG 的边界

- 文章所说的 structured note-taking 是一种 Agent Memory：Agent 将进度、决定和依赖写到上下文之外，再在后续任务中读回。
- RAG 是为当前问题取外部证据的机制；它可成为 Context Engineering 的输入之一，但不自动处理用户偏好、任务状态、写入规则或冲突。
- Context Window 仍是每次推理的容量上限。压缩、检索和笔记的价值在于提高有限窗口中信息的有效性，而不是让模型拥有无限、可靠的记忆。

## 与既有知识的关系

[[Concept_上下文窗口]] 说明容量与长上下文利用边界；[[Concept_检索增强生成]] 说明预先检索的基本架构；[[Concept_上下文工程]] 将这些能力组织为每轮推理的上下文选择过程；[[Concept_Agent记忆]] 则聚焦跨窗口持久化的结构化笔记。

