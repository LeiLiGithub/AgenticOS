---
type: concept
title: Word Token 与 Word Type
tags: [token, embedding, week1]
depends_on: []
required_by: ["[[Concept_词嵌入]]", "[[Concept_上下文化词表示]]"]
sources: ["[[raw/Contextual Word Representations A Contextual Introduction.pdf]]"]
timestamp: 2026-07-10
understanding: working
---

## 定义

- `word token`：一个词在具体文本中的一次出现。
- `word type`：抽象的、去重后的词；每个 word token 属于某个 type。

例如同一句中出现两次 `word`，是两个 token，但只对应一个 word type。

## 机制

传统系统常先为每个 word type 分配一个唯一整数，再用这个整数访问词表、计数或其他数据。这个整数只是在数据结构中定位的索引：两个 ID 的数值差距既不表示词义距离，也不表示词之间的关系。

上下文化表示把关注点从“这个 type 的唯一表示”转向“这个 token 在这次出现中的表示”。同一个 type 的不同 token 可以因所在句子的不同而得到不同向量。

## 为什么这样设计

区分 type 和 token 能说明两件不同的事：

- 管理词表、查表和统计时，系统需要稳定的 type。
- 理解某一次出现的具体语义时，系统需要包含上下文的 token 表示。

这是理解“初始 embedding 可相同，而 Transformer hidden state 可不同”的前置概念。

## 边界与局限

- 原文为讲解方便，把英语中的分词近似视为已解决；真实的 tokenization 在不同语言中并不简单。
- LLM 常使用 subword token，而不是语言学意义上的完整 word。本文的 word token/type 术语只能帮助建立表示学习直觉，不能直接替代 tokenizer 的精确定义。
- `token ID` 不是语义向量；它只是后续查询 embedding table 的离散索引。

## 理解演进

- [2026-07-10] 初始理解（来源：[[raw/Contextual Word Representations A Contextual Introduction.pdf]]）：type 适合表示词表中的“同一类”，token 适合表示一次具体出现；上下文化表示的对象是 token，而非脱离语境的 type。

