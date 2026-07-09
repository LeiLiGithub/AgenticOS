# AgenticOS Repository Instructions

This repository is the standalone knowledge base for Agentic OS and Agent Runtime learning. Read `schema.md` before creating, ingesting, querying, or revising notes.

## Structure

- `raw/`: immutable source materials. Keep original files and source captures intact.
- `wiki/`: structured, reusable knowledge derived from `raw/`.
- `posts/`: personal Feynman notes, plans, reviews, and other personal outputs.
- `schema.md`: the authoritative domain workflow and page conventions.

## Working Rules

- Do not overwrite raw material with a derived note.
- Keep stable conclusions in `wiki/`, cite their raw sources, and mark unverified claims explicitly.
- Put personal views, learning plans, and retrospective notes in `posts/`.
- Follow the ingest, query, and lint processes defined in `schema.md`.
- Before answering a knowledge question, read the relevant wiki pages first and return to raw material only when verification is needed.
- Do not commit credentials, tokens, private keys, local editor state, or generated temporary files.
