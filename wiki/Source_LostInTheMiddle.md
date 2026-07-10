---
type: source
title: Lost in the Middle: How Language Models Use Long Contexts
source_file: "[[raw/Lost in the Middle How Language Models Use Long Contexts.pdf]]"
tags: [long-context, RAG, context-management, week1]
timestamp: 2026-07-10
key_concepts: ["[[Concept_上下文窗口]]", "[[Concept_长上下文信息利用]]"]
---

## 来源定位

Nelson F. Liu 等人发表于 2023 年的实证研究，考察语言模型能否稳定地访问和使用长输入中的相关信息。它评测的是论文所列模型、版本和任务设置，而非对所有当前模型的普遍定律。

论文的关键区分是：模型的最大 context window 表示它能接收多少 token，不代表模型能同样可靠地使用窗口中每个位置的信息。

## 研究设计与证据

1. **多文档问答**：输入一条问题、一个含答案的段落和多个干扰段落；只改变答案段落的位置与文档数量。多组模型在相关段落位于开头或结尾时表现较好，位于中间时明显下降，形成 U 形位置曲线。
2. **合成 key-value 检索**：以随机 UUID 的 JSON 键值对排除自然语言语义干扰，只改变目标键值对的位置和总量。部分模型能稳定完成，但另一些模型同样在中间位置出现较低准确率。
3. **开放域问答案例**：检索器的 recall 随文档数继续上升，而 reader 的答题准确率更早趋于饱和。原文中超过 20 篇检索文档带来的收益很小，却会增加输入长度、延迟和成本。

这些实验共同支持“可放入”与“可稳定利用”是不同能力；它们不证明位置偏差只由某一个机制造成。

## 对成因的限定结论

论文做了三项初步分析，而非给出唯一根因：

- encoder-decoder 模型在不超过训练时序列长度的条件下，对位置变化相对更稳；超过训练长度后也会出现中间位置退化。
- 将 query 同时放在数据前后，可让合成 key-value 检索接近完美，但对多文档问答的趋势改善很小。
- 指令微调不是 U 形曲线的唯一来源：基础模型也会出现同类位置趋势。

因此，不能仅凭“使用 attention”“模型支持长窗口”或“把 query 重复一次”就断言长上下文检索会可靠。

## 与 RAG 和 Agent Runtime 的关系

长上下文应被当作受成本和有效利用率约束的运行时资源。对检索增强任务，更可靠的工作流是：先检索，再去重、重排、截断和组织上下文，并以目标模型和真实任务验证不同位置的表现。

原文建议探索有效重排（让相关信息靠近上下文开头）和 ranked-list truncation；这不是“任何信息都应放首尾”的通用规则，而是应随 prompt 结构、模型和任务验证的工程假设。

## 与现有笔记的关系

已有 [[Context Window 为什么不是 Memory]] 面向 Week1 解释 Context Window、Memory 与 RAG 的关系。本页和关联 Concept 页保留原文的实验范围、反例与时效边界，作为 schema 规范的知识入口。

