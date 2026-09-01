; extends

; Match-arm constructor / extractor / type names red (e.g. `Foo` in `case Foo(a, b)`,
; including nested ones like `Bar` in `case Foo(Bar(x))`). A `type_identifier` is
; always a name, never a binding, so binding variables (a, b, x) are left untouched.
; priority 200 beats Metals' LSP semantic tokens (125).
; Named @type.matcharm (not @scala.matcharm) so that under a colorscheme which
; doesn't define it -- e.g. stock `:colorscheme nord` -- it falls back to @type
; rather than going unhighlighted (:help treesitter-highlight-groups).
((case_class_pattern
   type: (type_identifier) @type.matcharm)
 (#set! "priority" 200))

; Bare capitalized patterns: `case None =>`, `case Nil =>`. These parse as a plain
; (identifier); Scala treats a Capitalized identifier in a pattern as a stable
; reference (a constant/object), while lowercase is a binding. Match ^[A-Z] so
; `case n =>` style bindings stay their normal color.
; @variable.matcharm, not @type.matcharm: a bare pattern (identifier) is stock
; @variable, so that is the group it must fall back to under plain nord.
((case_clause
   pattern: (identifier) @variable.matcharm)
 (#match? @variable.matcharm "^[A-Z]")
 (#set! "priority" 200))
