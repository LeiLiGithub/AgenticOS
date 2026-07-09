# KV Cache 不是 HashMap

## 1. 学习时的疑惑

读完 Hugging Face Transformers 的 Caching 文档后，一个很自然的理解是：

```text
KV Cache 就是通过维护键值对缓存，提升大模型推理速度。
这听起来类似 Java 里的 HashMap。
```

这个理解抓住了表层结论：

```text
KV Cache 确实是在缓存历史 token 的 key / value，
目的是避免重复计算，从而提升生成速度。
```

但把它类比成 HashMap 容易产生误解。

## 2. 为什么 KV Cache 不像 HashMap

HashMap 的工作方式是：

```text
给一个 key，直接查到一个 value。
```

但 attention 里的 key / value 不是字典键值对。

在 self-attention 中：

```text
Query：当前 token 想找什么。
Key：历史 token 提供的匹配特征。
Value：历史 token 提供的内容信息。
```

生成下一个 token 时，模型不是用某个 key 直接查 value，而是：

```text
当前 token 的 query
    -> 和所有历史 token 的 key 做相似度计算
    -> 得到 attention weights
    -> 对所有历史 token 的 value 加权求和
```

所以 KV Cache 更准确的理解是：

```text
按 layer、按 attention head、按时间顺序追加的中间张量缓存。
```

它缓存的是历史 token 在每一层 attention 中已经计算好的 `K` 和 `V`。

## 3. KV Cache 缓存的到底是什么

在 decoder-only Transformer 中，每一层 self-attention 都会为 token 计算：

```text
Q = query projection
K = key projection
V = value projection
```

对于已经处理过的历史 token，它们的 `K` 和 `V` 不会因为未来 token 到来而改变。

原因是 causal attention 有约束：

```text
过去 token 不能看未来 token。
```

因此，历史 token 的 `K/V` 可以缓存起来，后续生成新 token 时直接复用。

一次 decode step 可以理解为：

```text
1. 为当前新 token 计算 Q/K/V。
2. 把当前新 token 的 K/V 追加进 KV Cache。
3. 用当前 token 的 Q 和历史所有 K 计算 attention weights。
4. 用 attention weights 对历史所有 V 加权求和。
5. 得到当前 token 的上下文表示，用于预测下一个 token。
```

## 4. KV Cache 为什么能加速

没有 KV Cache 时，每生成一个新 token，都需要重新处理整个前缀：

```text
第 1 步：处理 token 1..N
第 2 步：重新处理 token 1..N+1
第 3 步：重新处理 token 1..N+2
```

这会重复计算大量历史 token 的 `K/V`。

有 KV Cache 后：

```text
prefill 阶段：一次性处理 prompt，并生成初始 KV Cache。
decode 阶段：每次只处理新 token，复用历史 K/V。
```

它本质上是：

```text
用显存换计算。
```

## 5. KV Cache 没有解决什么

KV Cache 并不意味着生成成本变成 O(1)。

它避免的是：

```text
重复计算历史 token 的 K/V。
```

但当前 token 的 query 仍然要和历史所有 key 做 attention。

所以 decode 阶段的单步计算仍然和上下文长度有关：

```text
上下文越长，
当前 token 需要对比的历史 K 越多，
KV Cache 占用的显存也越大。
```

因此，KV Cache 不能消除长上下文的代价，只是把不可接受的重复计算降下来。

## 6. KV Cache 是按层保存的

KV Cache 不是一份全局 Map，而是每一层都有自己的缓存：

```text
Layer 1: K cache, V cache
Layer 2: K cache, V cache
...
Layer N: K cache, V cache
```

每一层的缓存又会按 batch、head、sequence length、head dimension 组织。

常见形状可以理解为：

```text
[batch_size, num_heads, seq_len, head_dim]
```

因为同时要保存 Key 和 Value，所以内存规模大致和下面因素相关：

```text
KV cache size
    ~= 2
       * num_layers
       * batch_size
       * num_heads
       * seq_len
       * head_dim
       * bytes_per_value
```

这里的 `2` 是因为要分别保存 Key 和 Value。

## 7. 对 Agent Runtime 的意义

KV Cache 让生成更快，但也让长上下文和多并发变成资源管理问题。

从 Agent Runtime 角度，需要特别关注：

-   长 prompt 会增加 prefill 成本。
-   长会话会持续扩大 KV Cache。
-   多任务并发会同时占用多份 KV Cache。
-   输出越长，decode 阶段追加的缓存越多。
-   相同 prefix 如果能复用，可以减少重复 prefill。

所以 Runtime 不能简单依赖：

```text
把所有历史都塞进 prompt。
```

更合理的方向是：

-   控制上下文长度。
-   对历史进行摘要。
-   只检索当前任务相关内容。
-   把高价值内容放进上下文。
-   复用可复用的 prompt prefix。
-   管理并发任务的 KV Cache 占用。

## 8. 一句话总结

```text
KV Cache 不是 HashMap 式的答案缓存，
而是自回归生成中对历史 token attention 中间结果的逐层缓存。
```

它的核心价值是：

```text
用显存换计算，
减少重复计算历史 token 的 K/V，
但不会消除长上下文带来的线性 attention 和内存压力。
```
