# Token 个人学习笔记

## 我读过的资料

- OpenAI Cookbook: How to count tokens with tiktoken  
  <https://cookbook.openai.com/examples/how_to_count_tokens_with_tiktoken>
- Karpathy: Let's build the GPT Tokenizer  
  <https://karpathy.ai/zero-to-hero.html>

## 我学到的知识

- Token 用来将人类自然语言转换成模型可以处理的编码单元。
- Token 不是字符，也不一定是单词；它依赖具体 tokenizer 的编码算法。
- 同一句话在不同 tokenizer 下可能得到不同 token 序列，token 数量也可能不同。
- 不同 LLM 使用的 tokenizer 可能不同，因此同一段文本在不同模型上的 token 成本不一定相同。
- tokenizer 可以理解为一套文本和 token id 之间的映射规则。
- `tiktoken` 是 OpenAI 提供的开源 tokenizer 工具。
- Function calling / tool calling 也会消耗 token，而且不同模型的计算规则可能不一样。
- 空格通常会和后面的单词组成一个 token，这会影响英文和代码的 token 数。
- <https://tiktokenizer.vercel.app/> 可以用于 token 可视化。例如 `Attention is all you need` 在 GPT-4o tokenizer 下会被转换成 13 个 token。

![[posts/assets/PixPin_2026-06-25_00-08-59.png]]

## 还没搞懂的问题

- 是否存在一种绝对最佳的 tokenizer，能够适用于所有模型？
- Token 查找表是越大越好吗？
- 对一句话做 tokenization 时，得到的 token 序列越短就越好吗？

## 对 Agent Runtime 的影响

- Token 数直接影响上下文窗口占用、调用成本和响应延迟。
- Runtime 不能只把所有历史都塞进 prompt，需要做 context management、summary 和 retrieval。
- 设计 tool schema、日志和任务报告时，也要考虑 token 成本。
