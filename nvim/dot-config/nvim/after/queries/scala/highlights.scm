; extends

; Match-arm constructor / extractor / type names red (e.g. `Foo` in `case Foo(a, b)`,
; including nested ones like `Bar` in `case Foo(Bar(x))`). A `type_identifier` is
; always a name, never a binding, so binding variables (a, b, x) are left untouched.
; priority 200 beats Metals' LSP semantic tokens (125).
((case_class_pattern
   type: (type_identifier) @scala.matcharm)
 (#set! "priority" 200))

; Bare capitalized patterns: `case None =>`, `case Nil =>`. These parse as a plain
; (identifier); Scala treats a Capitalized identifier in a pattern as a stable
; reference (a constant/object), while lowercase is a binding. Match ^[A-Z] so
; `case n =>` style bindings stay their normal color.
((case_clause
   pattern: (identifier) @scala.matcharm)
 (#match? @scala.matcharm "^[A-Z]")
 (#set! "priority" 200))
