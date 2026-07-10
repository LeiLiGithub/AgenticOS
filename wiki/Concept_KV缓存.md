---
type: concept
title: KV 缓存
tags: [KV-cache, attention, inference, week1]
depends_on: []
required_by: ["[[Concept_KV缓存存储策略]]"]
sources: ["[[raw/Hugging Face Transformers Caching.md]]"]
timestamp: 2026-07-10
understanding: working
---

## 定义

KV 缓存（KV Cache）是在自回归推理时，按 Transformer layer 保存历史 token 的 attention Key 与 Value 张量的状态。它的目标是复用不会再变化的历史 K/V，避免每生成一个 token 都重算整个前缀。

## 机制

对当前 token，注意力层计算新的 `q_t`、`k_t`、`v_t`；将 `k_t`、`v_t` 追加到该层的历史缓存，再由当前 query 对完整的 K/V 序列进行注意力计算。

因果 mask 确保过去 token 不能看未来 token，所以历史 K/V 对未来 token 是稳定的。缓存的常见单层形状为：

```text
[batch_size, num_heads, seq_len, head_dim]
```

其中 `seq_len` 会随输入和生成长度增长。每层都有各自的 K cache 与 V cache，而不是一张全局键值字典。

## 为什么这样设计

无缓存时，解码第 `t` 个 token 会重复为前 `t-1` 个 token 计算 K/V；有缓存后，只需为新 token 计算 K/V。它以随序列长度增长的显存占用，换取减少重复前缀计算的推理效率。

## 边界与局限

- KV 中的 Key/Value 是 attention 的特征张量，不是 HashMap 的查询键和值，也不直接缓存自然语言答案。
- 当前 token 的 Q 仍要与历史 K 计算注意力，因此 KV Cache 不会消除随上下文变长而增长的单步注意力和显存成本。
- 只适用于 inference；训练期间开启 cache 可能破坏预期计算或产生错误。
- 自定义 generation loop 必须让 attention mask 覆盖 past 与 current token；否则缓存长度和 mask 不匹配。

## 理解演进

- [2026-07-10] 初始理解（来源：[[raw/Hugging Face Transformers Caching.md]]）：KV Cache 是逐层、按时间追加的中间张量状态；它复用历史 K/V，而非通过 key 直接取回 value。

