## [2026-07-10] ingest | Contextual Word Representations: A Contextual Introduction
- 深度：standard
- 触达页面：Source_ContextualWordRepresentations、Concept_WordToken与WordType、Concept_词嵌入、Concept_分布式语义、Concept_上下文化词表示
- 新增概念页：Concept_WordToken与WordType、Concept_词嵌入、Concept_分布式语义、Concept_上下文化词表示
- 说明：保留既有 [[Contextual Word Representations 论文解读]] 作为 Week1 学习解读；本次新增页面遵循 schema，且标注原文 2020 年的时效边界。

## [2026-07-10] ingest | Lost in the Middle: How Language Models Use Long Contexts
- 深度：standard
- 触达页面：Source_LostInTheMiddle、Concept_上下文窗口、Concept_长上下文信息利用、index
- 新增概念页：Concept_上下文窗口、Concept_长上下文信息利用
- 新增导航：wiki 页数超过 10，创建 [[index]] 作为查询入口。
- 说明：保留既有 [[Context Window 为什么不是 Memory]] 作为 Week1 学习笔记；新页限定原文结论仅适用于其评测模型、版本和任务，未把 U 形位置曲线写成普遍定律。

## [2026-07-10] ingest | Hugging Face Transformers: Caching
- 深度：standard
- 触达页面：Source_HuggingFaceTransformersCaching、Concept_KV缓存、Concept_KV缓存存储策略、index
- 新增概念页：Concept_KV缓存、Concept_KV缓存存储策略
- 更新导航：登记 Source 页和两个 Concept 页。
- 说明：复用不可变 raw 快照 [[raw/Hugging Face Transformers Caching.md]]，并对照当前 `main` 文档；概念结论已固化，具体 `Cache` API 仍应随 Transformers 版本复核。

## [2026-07-12] ingest | Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks
- 深度：deep
- 触达页面：Source_RetrievalAugmentedGeneration、Concept_检索增强生成、Concept_稠密检索、Concept_词嵌入、Concept_上下文窗口、Concept_长上下文信息利用、index
- 新增概念页：Concept_检索增强生成、Concept_稠密检索
- 更新概念页：Concept_词嵌入（区分 token embedding 与检索向量）、Concept_上下文窗口（检索仍受上下文装配约束）、Concept_长上下文信息利用（top-K 的任务相关取舍）
- 说明：论文基于 DPR、BART 与 2018 Wikipedia；保留“检索候选不等于可验证引用”“RAG 不等于 Agent 长期记忆”的边界，未把其早期分数或 K 值写成现代生产默认值。

## [2026-07-16] ingest | Effective context engineering for AI agents
- 深度：standard
- 原始快照：[[raw/Anthropic Effective Context Engineering for AI Agents.html]]
- 触达页面：Source_EffectiveContextEngineering、Concept_上下文工程、Concept_Agent记忆、Concept_上下文窗口、Concept_检索增强生成、Concept_长上下文信息利用、index
- 新增概念页：Concept_上下文工程、Concept_Agent记忆
- 更新概念页：Concept_上下文窗口（把窗口视为需管理的运行时预算）、Concept_检索增强生成（预先召回与按需探索的取舍）、Concept_长上下文信息利用（压缩、笔记、子 Agent 的工程关系）
- 说明：本文是 Anthropic 的工程经验文章，不把 Claude Code 的具体工具模式或产品行为视为跨模型的普适结论；保留“Context Window、RAG、Memory / State”彼此不等同的边界。
