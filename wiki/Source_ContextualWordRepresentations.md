---
type: source
title: Contextual Word Representations: A Contextual Introduction
source_file: "[[raw/Contextual Word Representations A Contextual Introduction.pdf]]"
tags: [embedding, contextual-representation, week1]
timestamp: 2026-07-10
key_concepts: ["[[Concept_WordToken与WordType]]", "[[Concept_词嵌入]]", "[[Concept_分布式语义]]", "[[Concept_上下文化词表示]]"]
---

## 来源定位

Noah A. Smith 于 2020 年写给具备基础编程知识读者的 NLP 导读。它不提供具体算法或完整模型实现，而是解释“如何把词放进计算机”：从离散标识，演进到静态词向量，再到依赖具体上下文的词 token 向量。

本文的历史时间点是 2020 年。ELMo、BERT、GPT-2 等例子用于说明表示学习的演进，文中的 benchmark 数字和“最新模型”判断不应视为当前结论。

## 核心论点

1. `word token` 是文本中一次出现，`word type` 是抽象的词类；不能将它们混为一谈。
2. 整数 ID 或 one-hot 只能区分“是否相同”，不能表达相似性，也难以把从一个词学到的规律迁移到相近词。
3. 词向量可来自人工特征或语料中的上下文分布；分布式表示中的语义通常分散在整个向量中，而非可由单一维度直接解释。
4. 单个静态词向量难以承载一词多义。把每次出现的 token 表示为由上下文动态生成的向量，能更好地针对当前语义建模。
5. 表示能力提升不等于语言理解已被解决：训练语料中的偏见、基准评价的局限，以及句法、语义和语用等问题仍然存在。

## 与 LLM 的对应

本文使用的是以 `word` 为中心的术语，现代 LLM 多以 subword token 为输入；两者可用于建立直觉，但不能一一等同。

```text
token ID（离散索引）
    -> embedding table（初始静态向量）
    -> Transformer / 语言模型的上下文计算
    -> contextual hidden states（与当前位置和上下文相关的表示）
```

对 Agent Runtime 而言，这说明 prompt 会改变模型在本次调用中的内部表示；但它不意味着模型获得了可靠的跨会话记忆。相关边界见 [[Context Window 为什么不是 Memory]]。

## 阅读重点与延伸

- 优先掌握第 1、3、4、5 节：token/type、向量、分布式语义、上下文化词表示。
- 第 6 节的偏见与评价边界应保留，不能只吸收“表示更强”的主结论。
- 已有面向 Week1 的讲解见 [[Contextual Word Representations 论文解读]]；本页和关联 Concept 页是按当前 schema 整理的稳定知识入口。

