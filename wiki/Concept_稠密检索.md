---
type: concept
title: 稠密检索
tags: [retrieval, dense-retrieval, vector-index, RAG, week1]
depends_on: ["[[Concept_词嵌入]]"]
required_by: ["[[Concept_检索增强生成]]"]
sources: ["[[raw/Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks.pdf]]"]
timestamp: 2026-07-12
understanding: working
---

## 定义

稠密检索（dense retrieval）把 query 和候选文档编码为连续向量，以向量相似度而非词面重合来排序和返回候选文档。它是 RAG 在生成前访问外部文本知识的候选召回层，不是生成器本身，也不保证返回内容真实或足以支撑最终答案。

## 机制

以本文使用的 DPR 为例：

1. query encoder 将输入 `x` 编为向量 `q(x)`，document encoder 将每个段落 `z` 编为向量 `d(z)`；二者是可分别编码的 bi-encoder。
2. 用内积 `d(z)^T q(x)` 为文档打分，并由 softmax 形成检索分布 `pη(z|x)`。
3. 文档向量可离线预计算并写入索引；在线阶段只需编码 query，再用 MIPS 在大量向量中近似查找 top-K，因此比让 query 与每份文档做昂贵的交叉编码更适合大规模候选库。
4. RAG 将 top-K 段落交给生成器，并在不同段落条件下的生成概率间做边缘化。原论文微调 query encoder，但固定 document encoder 和索引，避免训练中反复重建索引。

## 为什么这样设计

把文档编码离线化换取在线召回速度，使系统能将可更新的外部语料作为知识来源，而不必把全部事实压进模型参数。相较只看关键词重叠，稠密向量有机会召回措辞不同但语义相关的段落；相较“先检索后直接摘取”，它还能服务于自由生成、问答、验证等多种下游任务。

## 边界与局限

- 向量相似度是候选排序信号，不是事实真值、因果关系或引用证明；返回 top-K 后仍需重排、阅读、证据校验和生成约束。
- 召回质量受 query 表达、切块方式、语料覆盖、embedding／encoder 版本和索引近似误差共同影响。没有被召回的证据，生成器通常无法借由当前检索流程使用。
- 稠密检索不在所有任务上都优于词项检索。本文 FEVER 实验中 BM25 优于其稠密检索配置，说明实体词匹配强的任务需要实际比较而非默认选择。
- 文档 encoder 更新后，已有向量索引会过期，需要重新编码和构建索引；“向量库可热更新”不等于无需版本、数据质量和删除治理。

## 理解演进

- [2026-07-12] 初始理解（来源：[[raw/Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks.pdf]]）：稠密检索负责从可更新的外部语料中高效召回候选段落；RAG 通过 query 条件下的文档概率把这一步与生成目标连接，但检索分数不能代替证据验证。
