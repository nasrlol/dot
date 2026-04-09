local ls = require("luasnip")
local s  = ls.snippet
local t  = ls.text_node
local i  = ls.insert_node
local f  = ls.function_node

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

  -- for loop (pointer traversal) - common in your code
  s("forp", {
    t("for ("),
    i(1, "node_type"),
    t(" *"),
    i(2, "Node"),
    t(" = "),
    i(3, "Root"),
    t("; "),
    f(function(args) return args[1][1] end, { 2 }),
    t("; "),
    f(function(args) return args[1][1] end, { 2 }),
    t(" = "),
    f(function(args) return args[1][1] end, { 2 }),
    t("->"),
    i(4, "Next"),
    t(")"),
    t({ "", "{", "    " }),
    i(5),
    t({ "", "}" }),
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

  -- NULL pointer check (very common in your code)
  s("ifnull", {
    t("if ("),
    i(1, "ptr"),
    t(" == NULL)"),
    t({ "", "{", "    " }),
    i(2, "continue;"),
    t({ "", "}" }),
  }),

  -- NOT NULL check
  s("ifnot", {
    t("if (!"),
    i(1, "ptr"),
    t(")"),
    t({ "", "{", "    " }),
    i(2, "continue;"),
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

  -- internal function (your convention)
  s("ifn", {
    t("internal "),
    i(1, "void"),
    t(" "),
    i(2, "function_name"),
    t("("),
    i(3),
    t(")"),
    t({ "", "{", "    " }),
    i(4),
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

  -- pointer struct member (common pattern)
  s("member", {
    i(1, "type"),
    t(" *"),
    i(2, "name"),
    t(";"),
  }),

  -- switch statement (used in Parse function)
  s("switch", {
    t("switch ("),
    i(1, "expr"),
    t(")"),
    t({ "", "{", "    case " }),
    i(2, "value"),
    t(":"),
    t({ "", "    {", "        " }),
    i(3),
    t({ "", "    }", "    break;", "", "}" }),
  }),

  -- case statement
  s("case", {
    t("case "),
    i(1, "value"),
    t(":"),
    t({ "", "{", "    " }),
    i(2),
    t({ "", "}", "break;" }),
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

  -- parent traversal (Recursive_Peek pattern)
  s("whileparent", {
    t("for (; "),
    i(1, "Node"),
    t("; "),
    f(function(args) return args[1][1] end, { 1 }),
    t(" = "),
    f(function(args) return args[1][1] end, { 1 }),
    t("->Parent)"),
    t({ "", "{", "    " }),
    i(2),
    t({ "", "}" }),
  }),

  -- TODO comment (used throughout your code)
  s("todo", {
    t("// TODO("),
    i(1, "nasr"),
    t("): "),
    i(2, "description"),
  }),

  -- NOTE comment
  s("note", {
    t("// NOTE("),
    i(1, "nasr"),
    t("): "),
    i(2, "description"),
  }),

  -- bitwise flag operation (seen in Token->Flags)
  s("flag", {
    i(1, "Var"),
    t(" = ("),
    i(2, "type"),
    t(")("),
    f(function(args) return args[1][1] end, { 1 }),
    t(" | "),
    i(3, "Flag"),
    t(");"),
  }),

  -- PushStruct allocation pattern
  s("push", {
    i(1, "type"),
    t(" *"),
    i(2, "var"),
    t(" = PushStruct("),
    i(3, "Arena"),
    t(", "),
    f(function(args) return args[1][1] end, { 1 }),
    t(");"),
  }),

  -- MemoryZero pattern
  s("mzero", {
    t("MemoryZero("),
    i(1, "ptr"),
    t(");"),
  }),

  -- linked list append (First/Last pattern from your code)
  s("append", {
    t({ "if (" }),
    i(1, "Parent"),
    t("->First == NULL)"),
    t({ "", "{", "    " }),
    f(function(args) return args[1][1] end, { 1 }),
    t("->First = "),
    i(2, "Child"),
    t(";"),
    t({ "", "    " }),
    f(function(args) return args[1][1] end, { 1 }),
    t("->Last  = "),
    f(function(args) return args[1][1] end, { 2 }),
    t(";"),
    t({ "", "}", "else", "{", "    " }),
    f(function(args) return args[1][1] end, { 1 }),
    t("->Last->NextNode = "),
    f(function(args) return args[1][1] end, { 2 }),
    t(";"),
    t({ "", "    " }),
    f(function(args) return args[1][1] end, { 1 }),
    t("->Last           = "),
    f(function(args) return args[1][1] end, { 2 }),
    t(";"),
    t({ "", "}" }),
  }),

  -- cast with check
  s("castchk", {
    t("if ("),
    i(1, "Node"),
    t("->Token->Type != (token_type)"),
    i(2, "TokenType"),
    t(")"),
    t({ "", "{", "    " }),
    i(3, "Token->Flags |= FlagDirty;"),
    t({ "", "}" }),
  }),

  -- token type check (common pattern)
  s("toktype", {
    t("if ("),
    i(1, "Token"),
    t("->Type == "),
    i(2, "TokenIdentifier"),
    t(")"),
    t({ "", "{", "    " }),
    i(3),
    t({ "", "}" }),
  }),

  -- assignment operator
  s("assign", {
    i(1, "var"),
    t(" = "),
    i(2, "value"),
    t(";"),
  }),

  s("sep", {
    t("///////////////////////////////////////////////////////////////////////////////"),
  }),

  -- double pointer dereference
  s("deref", {
    i(1, "ptr"),
    t("->"),
    i(2, "member"),
  }),
}
