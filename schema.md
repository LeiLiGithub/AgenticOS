# AgenticOS 领域 Schema

> 本文件是 AgenticOS 领域的 wiki 维护规范，LLM 在执行 ingest / query / lint 时必须遵循。
> 全局总纲见根目录 `AGENTS.md`。

## 一、目录结构

```
AgenticOS/
├── schema.md        # 本文件
├── 学习规划.md      # 职业方向 + 6个月学习计划 + 当前阶段细化
├── raw/             # 原始学习材料（论文、文章、视频笔记原文），不可变
├── wiki/            # LLM 从 raw 提炼的结构化知识，按概念依赖图组织
└── posts/           # 个人费曼输出（你写的博客文章），基于 wiki 但独立演化
```

### 三层职责

| 层 | 职责 | 谁写 |
|---|---|---|
| `raw/` | 原始材料，source of truth，不可变 | 你放入 |
| `wiki/` | LLM 从 raw 提炼的结构化知识 | LLM 写 |
| `posts/` | 你的费曼输出，基于 wiki 但独立演化 | 你写，LLM 辅助 |

## 二、wiki 页面类型

### 1. Concept 页（概念页）

定义一个独立的技术概念。

命名：`Concept_<概念名>.md`

frontmatter：
```yaml
---
type: concept
title: <概念名>
tags: [<主题>, week<N>]
depends_on: ["[[Concept_前置概念]]"]
required_by: ["[[Concept_后续概念]]"]
sources: ["[[raw/源文件名]]"]
timestamp: YYYY-MM-DD
understanding: surface | working | deep
---
```

正文结构：
- 定义：一句话说清是什么
- 机制：怎么工作
- 为什么这样设计：设计动机
- 边界与局限：什么时候不适用
- 理解演进：按时间记录认知迭代
  - `[YYYY-MM-DD] 初始理解：...`
  - `[YYYY-MM-DD] 深化（来源：xxx）：...`
  - `[YYYY-MM-DD] 修正（来源：yyy）：...`

### 2. Synthesis 页（综合页）

由 query 产生的跨概念综合分析，LLM 生成。

命名：`Synthesis_<主题>.md`

frontmatter：
```yaml
---
type: synthesis
title: <主题>
tags: [<主题>]
derived_from_query: YYYY-MM-DD
based_on: ["[[Concept_xx]]", "[[Concept_yy]]"]
sources: ["[[raw/源文件名]]"]
timestamp: YYYY-MM-DD
---
```

### 3. Source 页（源摘要页）

对一篇 raw 的结构化摘要，是 ingest 的直接产物。

命名：`Source_<源标题简称>.md`

frontmatter：
```yaml
---
type: source
title: <源标题>
source_file: "[[raw/文件名]]"
tags: [<主题>, week<N>]
timestamp: YYYY-MM-DD
key_concepts: ["[[Concept_xx]]"]
---
```

## 三、依赖图规则

- wiki 内部**不按周次组织目录**，按概念依赖图组织。周次只作为 frontmatter 的 tag。
- 每个 Concept 页必须声明 `depends_on` 和 `required_by`，形成双向依赖。
- 提到某概念 3 次以上且无独立页时，lint 应报告为"覆盖缺口"。
- 查询某概念不理解时，沿 `depends_on` 回溯到前置概念。

## 四、ingest 流程

触发：你读完一篇 raw 后，告诉 LLM "ingest <文件名>"。

LLM 执行步骤：
1. 读取 raw 文件
2. 与你讨论关键要点（可选）
3. 写 Source 摘要页到 `wiki/`
4. 识别文中涉及的概念，为每个新概念创建 Concept 页，或更新已有 Concept 页
5. 更新所有相关 Concept 页的 `depends_on` / `required_by` 交叉引用
6. 如果新源与旧结论矛盾或深化，在相关 Concept 页的"理解演进"小节追加记录
7. 追加 `log.md` 条目
8. 报告本次 ingest 触达了哪些页

ingest 深度分级（由你声明）：
- `quick`：仅写 Source 摘要页，3-5 行
- `standard`：Source 页 + 更新相关 Concept 页
- `deep`：Source 页 + Concept 页 + 交叉引用 + 矛盾检测

## 五、query 流程

1. LLM 先读 `wiki/index.md`（若存在）定位相关页
2. 读取相关 wiki 页，检查 `timestamp` 和 `understanding` 字段
3. 若 `understanding: surface`，回答时加免责声明
4. 综合回答，引用来源（wiki 页或 raw 文件）
5. 若回答产生了有复用价值的综合分析，询问你是否归档为 Synthesis 页

## 六、lint 流程

触发：每月一次，或 raw 新增 10 篇后一次。

检查项：
1. **依赖完整性**：Concept 页的 `depends_on` 指向的页面是否存在
2. **覆盖缺口**：被多次提及但无独立页的概念
3. **孤儿页**：零入链的 wiki 页
4. **理解一致性**：同一概念在不同页面描述是否一致
5. **理解深度**：`understanding: surface` 的页面，提示是否需要深化
6. **矛盾检测**：不同页面对同一事实的描述是否冲突

lint 结果写入 `log.md`，修复需你确认，LLM 不擅自删页或重写。

## 七、posts 规范

### 命名
`YYYY-MM-DD-标题.md`，日期在前便于排序。

### frontmatter
```yaml
---
type: post
title: <标题>
date: YYYY-MM-DD
tags: [<主题>, week<N>]
based_on: ["[[Concept_xx]]", "[[Concept_yy]]"]
status: draft | published
---
```

### 与 wiki 的关系
- **单向依赖**：posts 依赖 wiki（`based_on`），wiki 不依赖 posts。
- **双向反哺**：写 post 时发现 wiki 有 gap，先补 wiki 再继续写。
- LLM 对 posts 只做辅助（润色、检查逻辑、提示 based_on 过期），**不主动重写 post 内容**。

### 受众假设
写给"刚学完前置概念但还没学本主题的人"。

### 结构建议（非强制）
问题动机 → 核心机制 → 为什么这样设计 → 边界与局限 → 与相关概念的关系

## 八、log.md 规范

位置：`AgenticOS/log.md`（首次 ingest 时创建）

格式：append-only，每条以 `## [YYYY-MM-DD] <操作类型> | <对象>` 开头。

操作类型：`ingest` | `query` | `lint` | `post`

示例：
```
## [2026-07-09] ingest | Attention Is All You Need
- 深度：deep
- 触达页面：Source_AttentionIsAllYouNeed, Concept_Attention, Concept_ContextWindow
- 新增概念页：Concept_Attention
- 更新概念页：Concept_ContextWindow（深化：attention 计算复杂度）
```

## 九、index.md 规范

位置：`AgenticOS/index.md`（wiki 页超过 10 篇时创建）

格式：每页一行，按类型分组。

```
## Concept 页
- [[Concept_Attention]] | Q/K/V 加权求和机制 | deep | 2026-07-09
- [[Concept_ContextWindow]] | 模型一次推理的 token 范围 | working | 2026-07-08

## Source 页
- [[Source_AttentionIsAllYouNeed]] | Transformer 原论文 | 2026-07-09

## Synthesis 页
- [[Synthesis_ReAct_vs_Reflexion]] | 两种 agent 范式对比 | 2026-07-15
```
