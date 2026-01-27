((comment) @comment.todo
  (#match? @comment.todo "(?i)\\b(TODO|FIXME)\\b"))

((comment) @comment.note
  (#match? @comment.note "(?i)\\b(NOTE|INFO)\\b"))

((comment) @comment.warning
  (#match? @comment.warning "(?i)\\b(HACK|WARNING|DEPRECATED)\\b"))

((comment) @comment.error
  (#match? @comment.error "(?i)\\b(BUG|ERROR|XXX)\\b"))

((comment) @comment.author
  (#match? @comment.author "@\\w+|Author:\\s*\\w+"))

((comment) @comment.reference
  (#match? @comment.reference "#\\d+|[A-Z]+-\\d+"))

((comment) @comment.url
  (#match? @comment.url "https?://[^\\s]+"))


