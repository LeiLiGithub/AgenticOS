---
type: concept
title: 上下文化词表示
tags: [contextual-representation, embedding, language-model, week1]
depends_on: ["[[Concept_WordToken与WordType]]", "[[Concept_词嵌入]]", "[[Concept_分布式语义]]"]
required_by: []
sources: ["[[raw/Contextual Word Representations A Contextual Introduction.pdf]]"]
timestamp: 2026-07-10
understanding: working
---

## 定义

上下文化词表示（contextual word representation）是针对某个具体 word token、由其周围语境动态生成的向量。同一个 word type 在不同句子中可以得到不同表示，以刻画当次出现的具体含义和用法。

## 机制

静态词向量为每个 type 保留一个固定向量，这要求一个向量同时承载所有词义。上下文化方法以 type 级向量为输入，再通过序列模型把附近上下文编码进每个 token 的新向量。

原文以 ELMo 为例：它预训练左右两个方向的语言模型，为每个 token 产生依赖上下文的向量，并可迁移到问答、语义角色标注、命名实体识别等下游任务。BERT 和 GPT-2 是文中列出的后续代表，但其预训练目标与可见上下文方向并不相同。

对现代 Transformer 的近似映射是：token 的初始 embedding 经 attention 层加工后得到的 hidden state，会随上下文变化；decoder-only 模型在自回归生成时只能使用左侧前缀。相关推理链路见 [[Decoder-only Transformer 预测下一个 Token 流程图]]。

## 为什么这样设计

一个词在不同上下文中含义不同。例如 `bank` 可指河岸或金融机构；在具体句子中，周围词会提供消歧线索。与其让一个 type 向量压缩所有可能含义，不如只让每个 token 向量表示其当前语义。

这也让大规模语言模型预训练的上下文特征可以迁移到不同任务，而不必为每个任务从零学习全部词义结构。

## 边界与局限

- 上下文化表示改善了词义消歧和多项 NLP 基准，但不等于完整的语言理解；句法、语义、语用与任务评价仍是独立问题。
- 上下文相关不代表跨会话持久。它只说明本次模型调用中输入内容会改变表示；长期信息仍需要 Memory、State 与检索治理，见 [[Context Window 为什么不是 Memory]]。
- 训练语料中的偏见可延续到上下文化表示；表示更细并不会自动消除不当关联。
- 本文的性能数字和“最新模型”均停留在 2020 年，不能作为当前模型能力比较的依据。

## 理解演进

- [2026-07-10] 初始理解（来源：[[raw/Contextual Word Representations A Contextual Introduction.pdf]]）：上下文化表示把“从上下文获得意义”的原则从 type 的全局统计，推进到 token 的局部、动态表示；它是理解 Transformer hidden state 的有效直觉，但不应被误当作长期记忆机制。

