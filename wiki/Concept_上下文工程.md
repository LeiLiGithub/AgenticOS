---
type: concept
title: 上下文工程
tags: [context-engineering, agent-runtime, memory, retrieval]
depends_on: ["[[Concept_上下文窗口]]", "[[Concept_检索增强生成]]", "[[Concept_长上下文信息利用]]"]
required_by: ["[[Concept_Agent记忆]]"]
sources: ["[[raw/Anthropic Effective Context Engineering for AI Agents.html]]"]
timestamp: 2026-07-16
understanding: working
---

## 定义

上下文工程（Context Engineering）是在每次模型推理前和推理之间，从指令、历史、工具、外部资料与运行时观察结果中，选择、压缩和组织最适合当前任务的一组 token 的系统设计过程。

它比 Prompt Engineering 更宽：Prompt Engineering 主要关心如何写指令；上下文工程还关心哪些信息应进入、以何种顺序进入、哪些信息应在窗口外保留为可检索引用。

## 机制

    候选信息
      -> 选择：当前任务需要什么
      -> 检索：预先召回或运行时按需探索
      -> 压缩：摘要、清理冗余工具输出
      -> 组织：指令、证据、历史、任务状态的结构化拼装
      -> Model Call

长任务中，上述过程会反复执行。压缩保持对话连续性；结构化笔记持久化关键决定和进度；子 Agent 将局部探索放在独立窗口中，只返回压缩后的结果。

## 为什么这样设计

上下文窗口是有限的运行时资源，放入更多文本会增加成本和干扰，且不保证模型会稳定使用中间信息。相比无差别堆叠历史，按当前目标选择高信号内容更有利于质量、延迟和可控性。

运行时按需探索还可利用文件路径、目录、时间戳和元数据等结构信号，避免把整个动态环境预先向量化后一次性塞进 prompt。

## 边界与局限

- 上下文工程不是某个固定框架或单一向量数据库；RAG、关键词搜索、文件工具和结构化笔记都可能参与其中。
- “最小上下文”不等于机械追求短 prompt。信息必须足以让模型遵守任务约束并完成当前步骤。
- 预先检索通常更快；运行时探索通常更贴近动态环境。二者的取舍依赖任务、数据变化速度、工具质量和延迟预算。
- Anthropic 的文章是工程经验，不是所有模型、所有 Agent 都会复现的普适性能结论；具体策略需以目标任务评测。

## 与 Agent Runtime 的关系

Context Manager 的职责不只是拼接字符串，而是管理上下文预算、检索、压缩、排序、来源和任务状态。它连接 [[Concept_检索增强生成]]、[[Concept_Agent记忆]] 与 Tool / Event Loop，是 Agent Runtime 的核心边界层。

## 理解演进

- [2026-07-16] 初始理解（来源：[[raw/Anthropic Effective Context Engineering for AI Agents.html]]）：可靠 Agent 的问题不只是“如何写好 prompt”，而是每轮推理前如何从持续增长的信息中选出少量高信号 token，并通过检索、压缩、笔记和子 Agent 控制上下文污染。

