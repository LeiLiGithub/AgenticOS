# Week1 阶段总结

## 本周读过的资料

- OpenAI Cookbook: How to count tokens with tiktoken
- Karpathy: Let's build the GPT Tokenizer

## 本周学到的关键知识

- Token 是文本进入模型前的编码单元，不等于字符或单词。
- tokenizer 的选择会影响 token 数、上下文占用、推理成本和延迟。
- Function calling / tool calling 也会占用上下文和 token 预算。

## 对 Agent Runtime 的理解变化

- Agent Runtime 需要把 token、context window 和成本当作运行时资源管理。
- Memory 不能简单等同于长上下文；长期信息需要外部存储、检索和压缩机制配合。

## 仍然不清楚的问题

- tokenizer 词表大小和压缩效率之间如何权衡？
- 不同模型的 function calling token 计算规则如何稳定评估？
- 在真实 Agent Runtime 中，哪些上下文应该保留原文，哪些应该压缩成摘要？
