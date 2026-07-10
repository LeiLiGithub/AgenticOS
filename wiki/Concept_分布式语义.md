---
type: concept
title: 分布式语义
tags: [embedding, distributional-semantics, week1]
depends_on: ["[[Concept_词嵌入]]"]
required_by: ["[[Concept_上下文化词表示]]"]
sources: ["[[raw/Contextual Word Representations A Contextual Introduction.pdf]]"]
timestamp: 2026-07-10
understanding: working
---

## 定义

分布式语义（distributional semantics）用词在语料中出现的上下文分布来推断其用法和相关性：在相似上下文中出现的词，往往具有可迁移的相似属性。

## 机制

- 可以统计词与附近词、左右位置或其他上下文模式的共现频率，形成高维的分布向量。
- Brown clustering 等方法可按上下文把词分组；降维可将稀疏、冗余的统计向量压缩为更短的密集向量。
- 神经网络方法把向量值视为参数，用梯度优化拟合语料中的词序列模式。`word2vec` 是这类可扩展方法的代表之一。

这些方法都试图从文本数据中获取词之间的相似性，而不是完全依赖人工词典或手工特征。

## 为什么这样设计

人工维护所有词义、关系和新词成本很高，且难以覆盖领域语料中的实际用法。分布式方法可使用新闻、医学文本或社交媒体等特定语料重建表示，并自然覆盖语料中已出现的词。

## 边界与局限

- `distributional` 表示信息来自上下文分布；`distributed` 表示语义分散编码在多个向量维度中。二者相关但不是同义词。
- 降维后的单个维度通常不可直接解释；最近邻或向量算术只能提供经验性证据。
- 语料中的共现会带入文化偏见和领域偏差，不能据此把统计关联误认为规范判断。
- 聚合一个 word type 的所有上下文仍会混合不同词义；这个局限推动了 [[Concept_上下文化词表示]]。

## 理解演进

- [2026-07-10] 初始理解（来源：[[raw/Contextual Word Representations A Contextual Introduction.pdf]]）：静态词向量从“所有出现的上下文”学习 type 级规律；上下文化词表示把同一原则下沉到某一次具体出现的局部语境。

