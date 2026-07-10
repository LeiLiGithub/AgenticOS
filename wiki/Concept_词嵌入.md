---
type: concept
title: 词嵌入
tags: [embedding, representation-learning, week1]
depends_on: ["[[Concept_WordToken与WordType]]"]
required_by: ["[[Concept_分布式语义]]", "[[Concept_上下文化词表示]]"]
sources: ["[[raw/Contextual Word Representations A Contextual Introduction.pdf]]"]
timestamp: 2026-07-10
understanding: working
---

## 定义

词嵌入（word embedding）是把一个 word type 映射到连续数值向量的表示。相比整数 ID，它让模型能计算两个词在向量空间中的接近程度，并将从一个词学到的规律迁移到相似词。

## 机制

1. one-hot 也能把词变成向量，但每个维度只表示“是不是该词”，本质上仍是离散编号。
2. 人工特征可显式编码词性、形态或语义类别；它们可解释，但依赖人工设计。
3. 学习型词向量把各维数值当作待优化参数，可由语料预训练、在下游任务中微调，或从任务数据中直接学习。

现代 LLM 的 embedding table 可看作这一思想在 subword token 上的实现：token ID 查到初始向量后，模型才开始连续空间中的计算。

## 为什么这样设计

NLP 任务通常需要从有限样本泛化。若只使用离散 ID，模型很难共享“`peas`、`sprouts`、`chicken` 都可填入食物语境”这样的规律。向量表示提供了可学习的相似性结构。

## 边界与局限

- 向量接近通常表示在特定训练目标或语料下的相似，不能当作词义真值或逻辑蕴含关系。
- 向量语义不等于向量数据库；本文讨论的是模型内部的表示，而非检索系统。
- 初始 embedding 是静态的 type 级表示，难以区分多义词在不同语境中的具体含义；这需要 [[Concept_上下文化词表示]]。
- 预训练语料会把其统计偏见带入向量表示。

## 理解演进

- [2026-07-10] 初始理解（来源：[[raw/Contextual Word Representations A Contextual Introduction.pdf]]）：embedding 解决的是离散 ID 无法表达和共享相似性的局限；它是语言模型输入表示的起点，不是模型已结合上下文后的最终理解。

