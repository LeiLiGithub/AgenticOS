## Concept 页

- [[Concept_WordToken与WordType]] | 区分文本中的一次出现与抽象词类 | working | 2026-07-10
- [[Concept_词嵌入]] | 将 token ID 映射到连续向量的参数表 | working | 2026-07-10
- [[Concept_分布式语义]] | 从语料上下文分布学习词间相似性 | working | 2026-07-10
- [[Concept_上下文化词表示]] | 为具体 token 生成依赖上下文的表示 | working | 2026-07-10
- [[Concept_上下文窗口]] | 单次模型调用可处理的 token 容量范围 | working | 2026-07-10
- [[Concept_长上下文信息利用]] | 在不同位置稳定检索和使用长输入证据的能力 | working | 2026-07-10
- [[Concept_KV缓存]] | 自回归推理中逐层复用历史 K/V 的状态 | working | 2026-07-10
- [[Concept_KV缓存存储策略]] | 动态、静态与滑动窗口缓存的运行时取舍 | working | 2026-07-10

## Source 页

- [[Source_ContextualWordRepresentations]] | 词表示从离散 ID 到上下文化向量的演进 | 2026-07-10
- [[Source_LostInTheMiddle]] | 长上下文位置鲁棒性与 RAG reader 饱和研究 | 2026-07-10
- [[Source_HuggingFaceTransformersCaching]] | KV Cache 原理、接口约束与层级存储实现 | 2026-07-10

## 既有学习笔记

- [[Contextual Word Representations 论文解读]] | 面向 Week1 的词嵌入与上下文化表示讲解 | 2026-07-10
- [[Decoder-only Transformer 预测下一个 Token 流程图]] | decoder-only 模型单步生成链路 | 2026-07-10
- [[Context Window 为什么不是 Memory]] | Context Window、Memory 与 RAG 的工程边界 | 2026-07-10
- [[KV Cache 不是 HashMap]] | 自回归生成中的逐层 K/V 缓存 | 2026-07-10
