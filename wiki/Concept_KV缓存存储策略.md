---
type: concept
title: KV 缓存存储策略
tags: [KV-cache, inference, runtime, week1]
depends_on: ["[[Concept_KV缓存]]"]
required_by: []
sources: ["[[raw/Hugging Face Transformers Caching.md]]"]
timestamp: 2026-07-10
understanding: working
---

## 定义

KV 缓存存储策略决定缓存的 `seq_len` 如何增长或受限，以及推理框架怎样更新其 K/V 张量。它是缓存基础语义之上的内存布局与运行时取舍。

## 机制

- **DynamicLayer**：把新 K/V 沿 sequence 轴拼接到已有张量，逻辑简单，但每轮生成后的张量形状会增长。
- **StaticLayer**：预先分配固定最大长度，写入位置随生成推进，形状保持不变。
- **StaticSlidingWindowLayer**：固定长度的滑动窗口；缓存满后，保留最近 token 并移出更早 token。

Hugging Face 的 `Cache` 由模型 `forward` 调用管理。无论选用何种 layer，attention 都必须把当前 K/V 与适用的历史 K/V 结合起来计算。

## 为什么这样设计

动态增长适合长度未知或原型代码；静态形状可降低编译优化障碍，`StaticLayer` 因而可与 `torch.compile` 协作。滑动窗口可让 KV 占用有上界，适合上下文不断增长但业务只需近期历史的场景。

## 边界与局限

- 静态分配需在生成前选择上限，过大浪费内存，过小会限制可生成长度。
- 滑动窗口会丢弃较早 token 的 K/V，不是“无损压缩”；能否接受取决于模型架构、任务和上下文策略。
- 此页记录的是 Transformers `main` 文档的实现模型；不同版本或 serving 系统可能使用不同 API、分块和内存管理方式。
- 存储策略解决的是计算与内存布局，不会自动解决长上下文中间信息的利用质量问题。

## 理解演进

- [2026-07-10] 初始理解（来源：[[raw/Hugging Face Transformers Caching.md]]）：Dynamic、Static 与 Sliding Window 的核心差异是缓存长度和张量形状的管理，而不是 K/V 的注意力含义。

