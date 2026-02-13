local ls = require("luasnip")
local s  = ls.snippet
local t  = ls.text_node
local i  = ls.insert_node
local f  = ls.function_node

local function filename()
  return vim.fn.expand("%:t")
end

return {
  -- main()
  s("main", {
    t({ "#include <stdio.h>", "", "int main(int argc, char **argv)", "{", "    " }),
    i(1, "return 0;"),
    t({ "", "}" }),
  }),

  -- for loop (index-based)
s("fori", {
  t("for (i32 "),
  i(1, "index"),
  t(" = 0;"),
  t({ "", "" }),
  f(function(args) return args[1][1] end, { 1 }),
  t(" < "),
  i(2, "value"),
  t(";"),
  t({ "", "" }),
  t("++"),
  f(function(args) return args[1][1] end, { 1 }),
  t(")"),
  t({ "", "{", "", "" }),
  i(3),
  t({ "", "", "}" }),
}),
  -- if statement
  s("if", {
    t("if ("),
    i(1, "condition"),
    t(")"),
    t({ "", "{", "    " }),
    i(2),
    t({ "", "}" }),
  }),

  -- if / else
  s("ife", {
    t("if ("),
    i(1, "condition"),
    t(")"),
    t({ "", "{", "    " }),
    i(2),
    t({ "", "}", "else", "{", "    " }),
    i(3),
    t({ "", "}" }),
  }),

  -- function
  s("fn", {
    i(1, "static"),
    t(" "),
    i(2, "void"),
    t(" "),
    i(3, "function_name"),
    t("("),
    i(4),
    t(")"),
    t({ "", "{", "    " }),
    i(5),
    t({ "", "}" }),
  }),

  -- struct
  s("struct", {
    t("typedef struct "),
    i(1, "name"),
    t({ " {", "    " }),
    i(2),
    t({ "", "} " }),
    f(function(args) return args[1][1] end, {1}),
    t(";"),
  }),

  -- include (system)
  s("inc", {
    t("#include <"),
    i(1, "stdio.h"),
    t(">"),
  }),

  -- include (local)
  s("incl", {
    t('#include "'),
    i(1, "file.h"),
    t('"'),
  }),

  -- header guard
  s("guard", {
    t("#ifndef "),
    i(1, "HEADER_H"),
    t({ "", "#define " }),
    f(function(args) return args[1][1] end, {1}),
    t({ "", "", "" }),
    i(2),
    t({ "", "", "#endif /* " }),
    f(function(args) return args[1][1] end, {1}),
    t(" */"),
  }),

  -- assert-style check
  s("check", {
    t("if (!("),
    i(1, "expr"),
    t("))"),
    t({ "", "{", "    " }),
    i(2, "return -1;"),
    t({ "", "}" }),
  }),
}
