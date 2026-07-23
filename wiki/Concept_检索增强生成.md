---
type: concept
title: 检索增强生成
tags: [RAG, retrieval, memory, agent-runtime, week1]
depends_on: ["[[Concept_稠密检索]]", "[[Concept_上下文窗口]]", "[[Concept_长上下文信息利用]]"]
required_by: ["[[Concept_上下文工程]]"]
sources: ["[[raw/Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks.pdf]]", "[[raw/Anthropic Effective Context Engineering for AI Agents.html]]"]
timestamp: 2026-07-12
understanding: working
---

## 定义

检索增强生成（Retrieval-Augmented Generation，RAG）是在生成前从外部知识库召回相关文本，并让生成模型以输入和检索文本为条件产出结果的架构。本文中的 RAG 将生成模型参数视为参数化记忆，将可替换的文档向量索引视为非参数化记忆，并把检索文档视为需要边缘化的隐变量。

## 机制

```text
输入 x
  -> query encoder
  -> 文档向量索引的 top-K 检索
  -> x 与候选段落 z 组成生成上下文
  -> generator 为每个 z 计算生成概率
  -> 以检索概率 p(z|x) 加权边缘化
  -> 输出 y
```

- **RAG-Sequence**：一个隐变量文档负责整段输出，先为每个 top-K 文档计算整段序列概率，再求和。它需要专门的解码近似，计算会随候选数和输出长度增加。
- **RAG-Token**：每个输出 token 都可在 top-K 文档间边缘化，能在同一答案中利用不同段落；其 token 级混合可用常规自回归 beam decoding。
- 在原论文训练中，query encoder 和 BART 生成器按输出似然共同学习，而文档 encoder／索引固定。这是“端到端优化检索目标”的特定工程折中，不代表所有现代 RAG 都采用相同训练方式。

## 为什么这样设计

纯参数化模型中的事实难以精确更新，也难提供可检查的外部知识来源。把可编辑、可重建的文档索引接到生成过程，使系统可以：

- 在当前任务中访问模型参数以外的文本；
- 用替换索引的方式更新可访问知识；
- 让多段文档共同影响自由生成，而不局限于抽取式答案。

## 边界与局限

- RAG 不是“保证正确”或“自动带可靠引用”。检索段落可能无关、过时或冲突，生成器也可能混入参数化知识；需按高风险程度加入来源展示、引用绑定、重排、验证或拒答机制。
- RAG 不等于长期 Memory。它解决的是当前请求如何从外部知识取回文本；跨会话保存用户偏好、任务进度、写入策略、冲突处理和权限仍属于 Memory／State 系统。
- top-K、chunk 长度、重排、上下文拼装和模型窗口会共同影响结果。检索更多段落会改变 recall、延迟、成本和 reader 可用性，必须以目标模型与真实任务评测。
- 本文的实验基于 2018 Wikipedia、DPR 和 BART；它说明架构原理与早期实证结果，不构成对当前模型、企业数据源或生产配置的性能承诺。
- 预先向量检索不是唯一模式。动态环境可保留路径、链接或查询等轻量引用，再由 Agent 运行时通过工具逐步读取；实践中可与预先召回组合，见 [[Concept_上下文工程]]。

## 理解演进

- [2026-07-12] 初始理解（来源：[[raw/Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks.pdf]]）：RAG 的关键不只是“检索后拼接”，而是在检索候选与生成概率之间建立可学习的概率连接；其可更新性来自外部索引，但可信性仍需额外的证据与系统治理。
- [2026-07-16] 深化（来源：[[raw/Anthropic Effective Context Engineering for AI Agents.html]]）：检索方式可从预先向量召回扩展为运行时按需探索。其工程价值在于渐进披露动态环境，而代价是更高的工具调用延迟和更强的工具设计要求。
