---
type: concept
title: 长上下文信息利用
tags: [long-context, RAG, evaluation, week1]
depends_on: ["[[Concept_上下文窗口]]"]
required_by: ["[[Concept_检索增强生成]]"]
sources: ["[[raw/Lost in the Middle How Language Models Use Long Contexts.pdf]]", "[[raw/Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks.pdf]]"]
timestamp: 2026-07-12
understanding: working
---

## 定义

长上下文信息利用是指模型在较长输入中定位、取用并据此完成任务的能力。它需要和“模型可接受的最大 token 数”分开评估：前者关注有效性与位置鲁棒性，后者只关注容量。

## 机制

《Lost in the Middle》通过固定正确答案、干扰项和期望输出，只改变相关信息在输入中的位置或输入长度，观察模型表现是否变化。论文在多文档问答和部分合成 key-value 检索结果中观察到 U 形曲线：相关信息位于开头（primacy）或结尾（recency）时较易被利用，位于中间时较差。

该现象说明 Transformer 的 attention 具有“可连接任意 token”的结构能力，不等于模型在真实任务上能稳定检索和使用任意位置的信息。

## 为什么这样设计

若只报告最大 context window 或平均任务分数，会掩盖最坏位置的失败。位置扰动测试能检验模型是否真正利用了长输入中的证据，也能暴露 RAG 中“retriever 找到了，reader 却没有用到”的问题。

对 Runtime 而言，检索到的内容需要经过选择、去重、重排、截断和结构化，才能成为模型更可能正确使用的上下文。

## 边界与局限

- U 形曲线是论文在特定模型、版本、长度和任务上的观察结果，不应外推为所有现有模型的固定规律；目标模型与 prompt 必须单独测试。
- 某些模型在随机 UUID 的 key-value 检索上表现完美，说明“中间信息一定不可用”并不成立。
- query-aware contextualization 对合成检索帮助很大，但未显著解决多文档问答；不能把重复 query 当作普适修复。
- 增加检索文档数可能提升候选答案覆盖率，却不一定提升最终准确率；应同时衡量 retriever recall、reader accuracy、延迟和成本。

## 理解演进

- [2026-07-10] 初始理解（来源：[[raw/Lost in the Middle How Language Models Use Long Contexts.pdf]]）：长上下文质量要看“相关证据位于不同位置时的性能差”，而非只看最大窗口或把更多文档塞入 prompt。
- [2026-07-12] 深化（来源：[[raw/Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks.pdf]]）：RAG 的 top-K 是模型和任务相关的取舍：原论文中增加 K 对 RAG-Sequence 的 NQ 有益，但 RAG-Token 约在 K=10 达峰。候选召回变多不保证生成器对新增上下文的利用更好。
