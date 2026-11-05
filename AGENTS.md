# Working notes

## Code structure

- Apply these rules whenever writing code. Follow IMPLEMENTATION_PLAN.az.md §4 boundaries.
- Split code by responsibility into appropriate modules, packages, folders, classes and UI components; do not collect unrelated logic in an Activity, screen or utility class.
- Keep engine models and rules pure Kotlin, independent of Android, UI, databases and providers. UI calls feature state holders/repository interfaces; adapters own SDK and persistence calls.
- Keep one cohesive responsibility per class/file. Extract reusable components when they have a real shared use; avoid empty modules and speculative abstractions.
- Place tests beside the owning module and test rules and failure boundaries. Preserve existing billing and design harness isolation.
- Before extending scope, follow the Context growth and Continuity rules below; keep the current handoff short and factual.

## Visual work

When a task touches how something looks, use the `ui-craft` skill — it carries
the token, contrast and screenshot workflow. Two things hold regardless of it:

- **Find the token file before writing a value.** Inventing a colour, spacing or
  radius next to a palette that already names one is the most common way an
  interface drifts, and it never looks broken enough to get caught in review.
- **Don't report a visual change as working without having rendered it and
  looked at the image.** If rendering wasn't possible, say that plainly instead
  of implying the result was checked.

# Context growth

Optimize for minimum necessary context. One chat = one logical task.

## Warn and hand off when ANY is true

1. Chat completed 2+ distinct subtasks/features
2. Substantial implementation across 3+ files more than once
3. Long multi-step plan continuing in the same chat
4. History full of large diffs/tool output and next step is another big change
5. Topic switch (auth → payments → export → refactor) in the same chat

## Required actions (do not skip)

1. Finish only the current small logical unit if almost done
2. Update `docs/context/current-task.md` with: Completed / Current state / Decisions / Remaining work / Relevant files / Checks performed / Exact next step
3. Tell the user explicitly:
   `Context böyüyür — bu tapşırığı yeni chatdə davam et.`
   Then give a short continuation prompt (goal + key files + plan path if any)
4. Do not stack another large unrelated step in this chat after the warning

## Do not

- Rescan the whole repo when scoped files are enough
- Dump full conversations into context files — keep them short and reusable
- Start implementing a large planned feature in a chat that already did research + planning

## Continuity

- At the start of a continuation chat, read `docs/context/current-task.md` if present, then inspect only the referenced files needed for the task.
- Keep the handoff factual: include checks performed, unresolved issues, and the exact next step; do not invent completed work or context-usage percentages.
- Recommend a new chat without creating one automatically. If the user chooses to continue here, respect that choice and keep the handoff current.

