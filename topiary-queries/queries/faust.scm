[(comment)] @append_hardline

(global_metadata) @leaf
(function_metadata) @leaf
(parameters) @leaf
[(string) (fstring)] @leaf


((function_metadata)
  .
  ";"
  @append_hardline) @leaf


["with" 
 "=" 
 ] @prepend_space @append_space


["{" ","] @append_space

(with_environment
  "with" @prepend_hardline @prepend_indent_start
  local_environment: 
  (environment
    "{" @append_indent_start
    "}" @append_indent_end
  )
)

[(function_definition) (definition) ";" @append_hardline]
