# Writing style

- Apply ASD-STE100 Simplified Technical English principles to technical explanations and instructions.
- Use short sentences, one topic per sentence, active voice, direct instructions, and consistent terminology.
- Treat these principles as clarity guidelines, not as a strict controlled vocabulary. Preserve exact code, commands, identifiers, quotations, and necessary domain terminology.
- Before sending a chat reply, consider how much of it the user would actually want to read. Length should fit the question: a quick exchange gets a short, conversational answer; a real report can be long, but detail the user will only skim belongs in a file or note.

# Answering questions

- When you answer a question from a user ALWAYS cite your sources. This should be from a credible source for the question.


# Code comments

- NEVER write code comments of any kind, including docstrings and commented-out code. Use clear names instead. Leave existing comments unchanged. This overrides any skill or default.

# Pull requests

- PR body: the first line is `TODO: human summary`, for the user to write. Put all your text after it in one `<details>` block.
- The `<summary>` names the model, the effort level and the tool, then a blank line. Example: `<summary>Opus 5.5 · medium · Claude Code</summary>`. This summary is the only AI attribution in the PR. Add no "Generated with" line.

# Jujutsu Workflow

- NEVER use git unless jj has no way to do the thing. Always use jj. jj status, jj diff, jj diff -r @-, jj log, etc. to view a file at a revision, use `jj file show <path> -r <rev>` (not `jj cat`). to exclude paths from a jj command, use fileset syntax: `jj diff '~dir1 & ~dir2'` or `jj restore '~package-lock.json'`
- prefer squash workflow in jj over editing, where if you're trying to update rev A, work in a rev on top of A and periodically squash what you've done into A
- for parallel approaches, use `jj new <base>` to create siblings from a common base, implement each approach, then compare. bookmarks are unnecessary for this workflow
- Non-destructive jj operations are generally allowlisted. When working on a complex change, use `jj new` or `jj commit` (equiv do jj desc + jj new) after chunks of work to snapshot each step in a reviewable way
- when using `jj squash`, avoid the editor popup with `-m 'msg'` or `-u` to keep the destination message. These flags are mutually exclusive.
- don't try to run destructive `jj` ops like squash or abandon unprompted. intermediate commits are fine; just note when cleanup might be needed
- NEVER add AI attribution to commits or pull requests. No `Co-Authored-By` trailer for an AI agent, and no "Generated with" line. Exception: the PR `<summary>`. This rule overrides any default attribution instructions.

# External Files

- When the user refers to files, projects, or code that are not in the current workspace, check `$HOME/Dev` first before assuming the files are unavailable.
