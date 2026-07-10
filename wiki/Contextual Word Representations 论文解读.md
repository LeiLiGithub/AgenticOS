# Contextual Word Representations 论文解读

原文：

-   [[Contextual Word Representations A Contextual Introduction.pdf]]
-   <https://arxiv.org/abs/1902.06006>

## 1. 这篇论文要解决什么问题

这篇论文不是在讲某一个具体模型，也不是在讲向量数据库。

它主要回答一个基础问题：

```text
自然语言里的词，应该如何放进计算机里，让模型可以计算、比较和泛化？
```

它的主线可以概括为：

```text
离散词 / token id
    -> one-hot / 人工特征
    -> 静态 word vector
    -> contextual word vector
```

对 Week1 来说，这篇论文最重要的价值是帮助理解：

-   token id 本身没有语义。
-   embedding 是模型可计算的向量表示。
-   向量里的语义来自大规模语料中的上下文模式。
-   静态 embedding 只是入口，真正强的表示来自上下文建模后的 hidden state。

需要注意：论文主要讲的是 word representation，而现代 LLM 通常处理的是 token / subword representation。阅读时可以类比，但不要把 word 和 tokenizer 里的 token 完全等同。

## 2. Section 3：Words as Vectors

这一节讲的是：为什么不能只把词表示成整数 ID。

例如：

```text
cat = 123
dog = 9876
table = 1024
```

这些数字只是索引。它们方便程序查表，但数字大小本身没有语义。

`cat` 和 `dog` 在现实语义上更接近，`cat` 和 `table` 更远；但从 `123`、`9876`、`1024` 这些编号上看不出这种关系。

所以需要把词表示成向量：

```text
cat   = [0.2, 0.8, -0.1, ...]
dog   = [0.3, 0.7, -0.2, ...]
table = [-0.5, 0.1, 0.9, ...]
```

向量的好处是可以表达相似性。两个词如果在向量空间中更接近，模型就可以把从一个词上学到的东西迁移到另一个相似词上。

这一节的关键理解是：

```text
整数 ID 只能表达“是不是同一个词”。
向量可以表达“两个词有多相似、在哪些方面相似”。
```

对应到 LLM：

```text
token id 本身没有语义。
embedding vector 才是模型真正拿来计算的输入。
```

例如 GPT-2 tokenizer 可以把文本编码成 `50257` 规模词表里的 token id，但这些 id 只是查表索引。模型内部还需要一张 embedding table，把 token id 转成连续向量。

## 3. Section 4：Words as Distributional Vectors

这一节讲的是：词向量里的意义从哪里来。

核心思想是：

```text
一个词的意义，可以从它经常出现的上下文中推出来。
```

如果不知道 `blicket` 是什么意思，但看到：

```text
I ate a strawberry blicket for dessert.
```

大概率可以猜出它和甜点、食物、可食用的东西有关。这个判断不是来自词典，而是来自上下文。

这就是 distributional view：

```text
经常出现在相似上下文里的词，往往有相似的意义或用法。
```

例如：

```text
I drink coffee.
I drink tea.
I drink juice.
```

`coffee`、`tea`、`juice` 都经常出现在类似上下文里，所以它们在向量空间中可能更接近。

早期方法可以为每个词统计周围出现过哪些词：

```text
某个词旁边出现过多少次 drink
某个词旁边出现过多少次 eat
某个词旁边出现过多少次 hot
某个词旁边出现过多少次 cold
...
```

这样每个词就可以变成一个很长的上下文统计向量。后续再通过降维、训练或神经网络方法，把它压缩成更短、更密集的向量。

这一节的关键理解是：

```text
embedding 不是人为规定出来的。
它是从大量文本里的共现关系和上下文模式中学出来的。
```

还需要区分两个容易混淆的词：

-   distributional representation：来源是上下文分布。
-   distributed representation：意义分散存储在整个向量里。

也就是说，向量中的某一个维度通常不能简单解释成“是不是动物”或“是不是食物”。语义被分散编码在整个向量中。

## 4. Section 5：Contextual Word Vectors

前面的静态词向量还有一个问题：一个词通常只有一个固定向量。

例如：

```text
bank = [固定向量]
```

但 `bank` 可以表示银行，也可以表示河岸：

```text
I deposited money in the bank.
I sat on the bank of the river.
```

如果 `bank` 永远只有一个固定向量，它就必须同时承载“金融机构”和“河岸”两种意义。这会让表示变得混杂。

Section 5 的关键转变是：

```text
不要只给 word type 一个固定向量。
要给每一次具体出现的 word token 一个上下文相关的向量。
```

也就是：

```text
bank in "money bank" -> 更偏金融语境的向量
bank in "river bank" -> 更偏地理语境的向量
```

这就是 contextual word representation。

对应到现代 LLM，可以这样理解：

```text
第一步：token id 查 embedding table，得到初始 token embedding。
第二步：经过 Transformer attention，每个 token 吸收上下文信息。
第三步：每一层输出的 hidden state，都是更上下文相关的表示。
```

所以，同一个 token 在刚查表时可能得到同一个静态 embedding；但经过上下文计算后，它在不同句子里的 hidden state 会不同。

例如：

```text
Apple released a new chip.
I ate an apple.
```

`apple` 的初始 embedding 可以相同或相近，但经过上下文建模后，第一个更接近公司、芯片、科技语境，第二个更接近水果、食物语境。

这一节的关键理解是：

```text
embedding table 只是静态入口。
LLM 真正强的地方，是通过上下文建模把静态 token embedding 变成上下文相关的 hidden state。
```

## 5. 和 LLM 推理链路的对应关系

把论文里的概念映射到 LLM，可以得到下面这条链路：

```text
文本
    -> tokenizer
    -> token ids
    -> embedding table
    -> token embeddings
    -> Transformer blocks
    -> contextual hidden states
    -> logits
    -> next token
```

其中：

| 阶段                             | 含义                   |
| ------------------------------ | -------------------- |
| token id                       | 离散编号，只是索引            |
| embedding table                | 把 token id 映射为向量的参数表 |
| token embedding                | token 的初始静态向量表示      |
| attention / transformer blocks | 让 token 表示吸收上下文      |
| hidden state                   | 上下文相关的 token 表示      |
| logits                         | 对下一个 token 的预测分数     |

对 Agent Runtime 来说，理解这条链路很重要，因为它解释了：

-   为什么上下文内容会影响模型理解。
-   为什么同一个词在不同 prompt 中可能产生不同效果。
-   为什么 Context Window 是运行时资源。
-   为什么 Memory 不能简单等同于把所有历史塞进 prompt。

## 6. 建议阅读重点

建议精读：

-   Section 3：理解整数 ID 和向量表示的区别。
-   Section 4：理解向量语义来自上下文分布。
-   Section 5：理解静态 embedding 和 contextual representation 的区别。

可以略读：

-   Brown clustering 的具体细节。
-   ELMo、BERT 的 benchmark 数字。
-   各种实验提升比例。
-   Section 6 之后的扩展讨论。

Week1 阶段不需要掌握训练公式，重点是能用自己的话讲清楚：

```text
token id 为什么没有语义？
embedding 为什么是向量？
embedding 的语义从哪里来？
为什么同一个 token 在不同上下文中需要不同表示？
Transformer hidden state 和初始 embedding 有什么区别？
```

## 7. 一句话总结

这篇论文的核心价值是把 embedding 讲成一条清晰的演化路线：

```text
从“词是一个离散编号”
到“词是一个可比较的向量”
再到“词在具体上下文中才有具体表示”。
```

这正好对应 LLM 的基础认知：

```text
token id 不是语义。
embedding 是入口表示。
contextual hidden state 才是模型结合上下文后的内部理解。
```
