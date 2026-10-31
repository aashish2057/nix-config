;; extends

; Highlight a Lua string as fish if its first line is `# fish`.
(string
  content: _ @injection.content
  (#lua-match? @injection.content "^%s*# fish\n")
  (#set! injection.language "fish"))
