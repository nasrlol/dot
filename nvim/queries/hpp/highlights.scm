; TODO/FIXME/ISSUE comments
((comment) @comment.todo
  (#match? @comment.todo "(?i)\\b(TODO|FIXME|ISSUE)\\b"))

; NOTE/INFO comments
((comment) @comment.note
  (#match? @comment.note "(?i)\\b(NOTE|INFO|FYI)\\b"))

; HACK/WARNING/DEPRECATED comments
((comment) @comment.warning
  (#match? @comment.warning "(?i)\\b(HACK|WARNING|DEPRECATED|WIP|EXPERIMENTAL)\\b"))

; BUG/ERROR/CRITICAL comments
((comment) @comment.error
  (#match? @comment.error "(?i)\\b(BUG|ERROR|XXX|CRITICAL|BROKEN|SEGFAULT)\\b"))

; Author/Contributor markers
((comment) @comment.author
  (#match? @comment.author "\\(\\s*(?:nasr|NASR|luca|LUCA|\\w+)\\s*\\)|@(?:nasr|luca|\\w+)|Author:\\s*\\w+"))

; Issue/Ticket references (e.g., #123, PROJ-456)
((comment) @comment.reference
  (#match? @comment.reference "#\\d+|[A-Z][A-Z0-9]+-\\d+"))

; URL references
((comment) @comment.url
  (#match? @comment.url "https?://[^\\s)]+"))

; OPTIMIZATION/PERF comments
((comment) @comment.performance
  (#match? @comment.performance "(?i)\\b(OPTIMIZE|PERF|PERFORMANCE|SPEED|SLOW)\\b"))

; REFACTOR comments
((comment) @comment.refactor
  (#match? @comment.refactor "(?i)\\b(REFACTOR|REFACTORING|CLEANUP|SIMPLIFY|REWRITE)\\b"))

; SECURITY comments
((comment) @comment.security
  (#match? @comment.security "(?i)\\b(SECURITY|UNSAFE|EXPLOIT|VULNERABILITY|CVE)\\b"))

; DOCUMENTATION comments
((comment) @comment.documentation
  (#match? @comment.documentation "(?i)\\b(DOC|DOCUMENT|DOCUMENTATION|EXPLAIN|CLARIFY)\\b"))

; QUESTION/UNCERTAIN comments (like in your code - "figure out what to do here")
((comment) @comment.question
  (#match? @comment.question "(?i)\\b(QUESTION|UNCERTAIN|WHAT|HOW|WHY|UNCLEAR|INVESTIGATE)\\b|figure\\s+out|need\\s+to\\s+decide"))

; TEMPORARY/REMOVE comments
((comment) @comment.temporary
  (#match? @comment.temporary "(?i)\\b(TEMPORARY|TEMP|REMOVE|DELETE|STUB|PLACEHOLDER)\\b"))

; INVARIANT/CONSTRAINT comments
((comment) @comment.constraint
  (#match? @comment.constraint "(?i)\\b(INVARIANT|CONSTRAINT|MUST|REQUIRE|ASSUME|GUARANTEE)\\b"))

; INCREMENTAL/FUTURE work comments
((comment) @comment.future
  (#match? @comment.future "(?i)\\b(INCREMENTAL|FUTURE|LATER|EVENTUALLY|WHEN|IF)\\b"))

; CODE BLOCK/SECTION comments (for organization)
((comment) @comment.section
  (#match? @comment.section "^\\s*//\\s*=+\\s*|^\\s*//\\s*-{3,}\\s*|^\\s*/\\*\\s*[-=]{10,}"))
