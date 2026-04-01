# Jujutsu Workflow

- NEVER use git unless jj has no way to do the thing. Always use jj. jj status, jj diff, jj diff -r @-, jj log, etc. to view a file at a revision, use `jj file show <path> -r <rev>` (not `jj cat`). to exclude paths from a jj command, use fileset syntax: `jj diff '~dir1 & ~dir2'` or `jj restore '~package-lock.json'`
- prefer squash workflow in jj over editing, where if you're trying to update rev A, work in a rev on top of A and periodically squash what you've done into A
- for parallel approaches, use `jj new <base>` to create siblings from a common base, implement each approach, then compare. bookmarks are unnecessary for this workflow
- Non-destructive jj operations are generally allowlisted. When working on a complex change, use `jj new` or `jj commit` (equiv do jj desc + jj new) after chunks of work to snapshot each step in a reviewable way
- when using `jj squash`, avoid the editor popup with `-m 'msg'` or `-u` to keep the destination message. These flags are mutually exclusive.
- don't try to run destructive `jj` ops like squash or abandon unprompted. intermediate commits are fine; just note when cleanup might be needed

# External Files

- When the user refers to files, projects, or code that are not in the current workspace, check `$HOME/Dev` first before assuming the files are unavailable.
