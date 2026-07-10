---
type: source
title: Hugging Face Transformers: Caching
source_file: "[[raw/Hugging Face Transformers Caching.md]]"
tags: [KV-cache, inference, transformers, week1]
timestamp: 2026-07-10
key_concepts: ["[[Concept_KV缓存]]", "[[Concept_KV缓存存储策略]]"]
---

## 来源定位

Hugging Face Transformers 的官方 Caching 文档，说明自回归生成中 KV Cache 的注意力原理、`Cache` 类的调用约束，以及缓存的层级存储实现。本文依据 Vault 中不可变的 raw 快照；已于 2026-07-10 对照该页面的 `main` 版本，核心内容一致。

`main` 文档对应开发中版本，类名、构造参数和示例代码可能随 Transformers 发布而变化。因此，概念结论可复用，具体 API 应以使用时的目标版本文档为准。

## 核心机制

1. 自回归生成逐 token 进行。若不缓存，每一步都会重新计算历史 token 的 K/V 投影。
2. 因果注意力禁止历史 token 关注未来 token，因此已处理 token 的 K/V 不会因后续 token 到来而改变，可以复用；当前 token 的 K/V 则追加到缓存。
3. 缓存按 Transformer layer 独立保存。每层都有 key tensor 和 value tensor，常见形状为 `[batch_size, num_heads, seq_len, head_dim]`。
4. `Cache` 的更新必须使 attention 使用“历史 + 当前”的 K/V；自定义生成循环中，attention mask 的长度也必须覆盖 past 与 current 的总长度。`generate()` 通常会处理此细节。

## Cache storage implementation

- `DynamicLayer`：随生成通过拼接增长 `seq_len`，直观但形状会动态变化。
- `StaticLayer`：创建时预分配固定序列长度，形状稳定，适合 `torch.compile`。
- `StaticSlidingWindowLayer`：同样预分配固定长度；新 token 到来时会移出更早 token，以固定窗口换取有界缓存。

这三类策略的差异主要在序列长度的管理和更新方式，不改变“按层缓存 K/V、用当前 Q 对历史 K/V 做注意力”的基本语义。

## 边界与工程含义

- 文档明确建议只在 inference 启用 cache；训练中启用可能引发非预期错误。
- KV Cache 避免重复计算历史 K/V，但当前 Q 仍需与历史 K 计算注意力；它不是 O(1) 的答案缓存。
- Cache 是一次生成状态的一部分，不等同于跨会话长期 Memory，也不自动实现跨请求 prefix 复用。
- Runtime 应将缓存的创建、增长、窗口淘汰和释放纳入会话生命周期与显存治理；长上下文的有效利用边界见 [[Concept_长上下文信息利用]]。

## 与既有笔记的关系

[[KV Cache 不是 HashMap]] 解释了概念误区和推理成本；本页及关联 Concept 页补充 Hugging Face `Cache` 的接口约束与 Dynamic / Static / Sliding Window 的存储实现。

