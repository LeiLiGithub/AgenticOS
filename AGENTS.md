# AgenticOS Repository Instructions

This repository is the standalone knowledge base for Agentic OS and Agent Runtime learning. This file is the authoritative domain workflow and page-convention reference. Follow it before creating, ingesting, querying, or revising notes.

## 1. Directory Responsibilities

```text
AgenticOS/
├── AGENTS.md        # This file: domain workflow and maintenance rules
├── 学习规划.md       # Career direction, six-month learning plan, and current-stage detail
├── raw/             # Immutable learning sources: papers, articles, and source notes
├── wiki/            # Structured, reusable knowledge distilled from raw material
└── posts/           # Personal Feynman outputs, plans, and reviews
```

| Layer | Responsibility | Primary author |
| --- | --- | --- |
| `raw/` | Original material and the source of truth; never rewrite it | User |
| `wiki/` | Structured, reusable knowledge derived from `raw/` | LLM |
| `posts/` | Personal Feynman outputs that build on, but evolve independently from, `wiki/` | User, with LLM assistance |

## 2. General Working Rules

- Do not overwrite raw material with a derived note.
- Keep stable conclusions in `wiki/`, cite their raw sources, and mark unverified claims explicitly.
- Put personal views, learning plans, and retrospective notes in `posts/`.
- Before answering a knowledge question, read relevant wiki pages first; return to raw material only when verification is needed.
- Do not commit credentials, tokens, private keys, local editor state, or generated temporary files.

## 3. Wiki Page Types

### Concept pages

Define one independent technical concept.

- Filename: `Concept_<概念名>.md`
- Frontmatter:

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

- Body sections: definition, mechanism, design motivation, boundaries and limitations, and an evolving understanding log:
  - `[YYYY-MM-DD] 初始理解：...`
  - `[YYYY-MM-DD] 深化（来源：xxx）：...`
  - `[YYYY-MM-DD] 修正（来源：yyy）：...`

### Synthesis pages

Capture a reusable cross-concept analysis produced by a query.

- Filename: `Synthesis_<主题>.md`
- Frontmatter:

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

### Source pages

Summarize one raw source in a structured form; they are the direct output of ingest.

- Filename: `Source_<源标题简称>.md`
- Frontmatter:

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

## 4. Concept Dependency Rules

- Organize `wiki/` by concept dependency, not by weekly directories; weeks belong only in frontmatter tags.
- Every Concept page declares both `depends_on` and `required_by` to maintain bidirectional links.
- During lint, report a concept mentioned three or more times without its own page as a coverage gap.
- When a queried concept is unclear, trace `depends_on` backward to its prerequisites.

## 5. Ingest Workflow

Trigger: the user has read a raw source and asks to `ingest <文件名>`.

1. Read the raw source.
2. Discuss key points with the user when useful.
3. Create a Source page in `wiki/`.
4. Create or update Concept pages for the concepts involved.
5. Update related `depends_on` and `required_by` links.
6. Append a dated entry to the relevant Concept page's understanding log when the source refines or contradicts an earlier conclusion.
7. Append a `log.md` entry.
8. Report the pages touched.

The user chooses the ingest depth:

- `quick`: Source page only, in 3–5 lines.
- `standard`: Source page plus relevant Concept-page updates.
- `deep`: Source page, Concept pages, cross-links, and contradiction detection.

## 6. Query Workflow

1. Read `wiki/index.md`, if it exists, to locate relevant pages.
2. Read the related wiki pages and check their `timestamp` and `understanding` fields.
3. When `understanding: surface`, state that limitation in the answer.
4. Synthesize an answer with references to the wiki pages or raw files used.
5. If the answer is reusable cross-concept knowledge, ask the user whether to archive it as a Synthesis page.

## 7. Lint Workflow

Trigger lint monthly or whenever 10 new raw sources have been added.

Check for:

1. Broken Concept dependencies.
2. Coverage gaps.
3. Orphan wiki pages with no incoming links.
4. Inconsistent descriptions of the same concept.
5. Pages with `understanding: surface` that may need deepening.
6. Contradictory claims across pages.

Write lint findings to `log.md`. Do not delete or substantially rewrite pages without the user's confirmation.

## 8. Posts Rules

- Filename: `YYYY-MM-DD-标题.md`.
- Frontmatter:

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

- Posts depend on wiki through `based_on`; wiki pages do not depend on posts.
- If writing reveals a knowledge gap, fill the wiki gap before continuing the post.
- The LLM may polish posts, check their reasoning, and flag outdated `based_on` links, but must not rewrite post content proactively.
- Write for a reader who has completed the prerequisite concepts but has not yet learned the present topic.
- A suggested, non-mandatory sequence is: motivation → core mechanism → design rationale → boundaries and limitations → related concepts.

## 9. Navigation and Log Files

### `log.md`

- Location: `AgenticOS/log.md`; create it on the first ingest.
- It is append-only. Start every entry with `## [YYYY-MM-DD] <操作类型> | <对象>`.
- Valid operation types: `ingest`, `query`, `lint`, `post`.

Example:

```markdown
## [2026-07-09] ingest | Attention Is All You Need
- 深度：deep
- 触达页面：Source_AttentionIsAllYouNeed, Concept_Attention, Concept_ContextWindow
- 新增概念页：Concept_Attention
- 更新概念页：Concept_ContextWindow（深化：attention 计算复杂度）
```

### `index.md`

- Location: `AgenticOS/index.md`; create it once the wiki has more than 10 pages.
- Group entries by page type and use one line per page.

```markdown
## Concept 页
- [[Concept_Attention]] | Q/K/V 加权求和机制 | deep | 2026-07-09
- [[Concept_ContextWindow]] | 模型一次推理的 token 范围 | working | 2026-07-08

## Source 页
- [[Source_AttentionIsAllYouNeed]] | Transformer 原论文 | 2026-07-09

## Synthesis 页
- [[Synthesis_ReAct_vs_Reflexion]] | 两种 agent 范式对比 | 2026-07-15
```
