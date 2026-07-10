---
type: concept
title: 上下文窗口
tags: [context-window, inference, week1]
depends_on: []
required_by: ["[[Concept_长上下文信息利用]]"]
sources: ["[[raw/Lost in the Middle How Language Models Use Long Contexts.pdf]]"]
timestamp: 2026-07-10
understanding: working
---

## 定义

上下文窗口（context window）是模型在一次前向计算中可接收和处理的 token 序列范围。它描述输入容量，不是跨请求保存事实的 Memory，也不是对窗口内任意信息的可靠检索保证。

## 机制

请求文本经 tokenizer 转成序列后，模型在其架构、位置编码和训练长度所允许的范围内计算 token 表示。不同模型的最大长度、训练时长度和实际可稳定使用的长度可能不同；同一段文本也会因 tokenizer 不同而占用不同数量的 token。

## 为什么这样设计

更长的输入可容纳长文档、会话历史或检索结果，使模型有机会把任务相关信息与当前问题一起处理。它也是 RAG、长文摘要和 Agent 上下文组装的基础资源约束。

## 边界与局限

- 最大窗口只说明“可输入”，不说明每个位置都被同等有效利用；位置鲁棒性是另一个问题，见 [[Concept_长上下文信息利用]]。
- 输入更长通常会带来更多 prefill 计算、KV Cache 占用、延迟和成本。
- 上下文仅在当前调用有效；跨会话的保存、检索、更新和冲突处理属于 Memory / State 系统。
- “支持 N token”不能脱离模型版本、prompt 模板、任务和评测指标比较。

## 理解演进

- [2026-07-10] 初始理解（来源：[[raw/Lost in the Middle How Language Models Use Long Contexts.pdf]]）：上下文窗口是容量上限；长上下文系统还必须验证模型对不同位置的信息利用是否稳定。

