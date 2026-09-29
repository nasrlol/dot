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
        t("for (s32 "),
        i(1, "index"),
        t(" = 0; "),
        f(function(args) return args[1][1] end, { 1 }),
        t(" < "),
        i(2, "value"),
        t("; ++"),
        f(function(args) return args[1][1] end, { 1 }),
        t(")"),
        t({ "", "{", "\t" }),
        i(3),
        t({ "", "}" }),
    }),

    -- for loop (pointer traversal)
    s("forp", {
        t("for ("),
        i(1, "type"),
        t(" *"),
        i(2, "it"),
        t(" = "),
        i(3, "head"),
        t("; "),
        f(function(args) return args[1][1] end, { 2 }),
        t("; "),
        f(function(args) return args[1][1] end, { 2 }),
        t(" = "),
        f(function(args) return args[1][1] end, { 2 }),
        t("->"),
        i(4, "next"),
        t(")"),
        t({ "", "{", "    " }),
        i(5),
        t({ "", "}" }),
    }),

    -- while loop
    s("wh", {
        t("while ("),
        i(1, "condition"),
        t(")"),
        t({ "", "{", "    " }),
        i(2),
        t({ "", "}" }),
    }),

    -- do-while loop
    s("dow", {
        t({ "do", "{", "    " }),
        i(1),
        t({ "", "} while (" }),
        i(2, "condition"),
        t(");"),
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

    -- NULL check
    s("ifnull", {
        t("if ("),
        i(1, "ptr"),
        t(" == NULL)"),
        t({ "", "{", "    " }),
        i(2),
        t({ "", "}" }),
    }),

    -- NOT NULL check
    s("ifnot", {
        t("if (!"),
        i(1, "ptr"),
        t(")"),
        t({ "", "{", "    " }),
        i(2),
        t({ "", "}" }),
    }),

    -- ternary
    s("tern", {
        i(1, "condition"),
        t(" ? "),
        i(2, "true"),
        t(" : "),
        i(3, "false"),
    }),

    -- function
    s("fn", {
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

    -- static function
    s("sfn", {
        t("static "),
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
        f(function(args) return args[1][1] end, { 1 }),
        t(";"),
    }),

    -- enum
    s("enum", {
        t("typedef enum "),
        i(1, "name"),
        t({ " {", "    " }),
        i(2),
        t({ "", "} " }),
        f(function(args) return args[1][1] end, { 1 }),
        t(";"),
    }),

    -- union
    s("union", {
        t("typedef union "),
        i(1, "name"),
        t({ " {", "    " }),
        i(2),
        t({ "", "} " }),
        f(function(args) return args[1][1] end, { 1 }),
        t(";"),
    }),

    -- struct member
    s("member", {
        i(1, "type"),
        t(" "),
        i(2, "name"),
        t(";"),
    }),

    -- pointer member
    s("pmember", {
        i(1, "type"),
        t(" *"),
        i(2, "name"),
        t(";"),
    }),

    -- switch statement
    s("switch", {
        t("switch ("),
        i(1, "expr"),
        t(")"),
        t({ "", "{", "    case " }),
        i(2, "value"),
        t(":"),
        t({ "", "    {", "        " }),
        i(3),
        t({ "", "    } break;", "", "    default:", "    {", "        " }),
        i(4),
        t({ "", "    } break;", "}" }),
    }),

    -- case
    s("case", {
        t("case "),
        i(1, "value"),
        t(":"),
        t({ "", "{", "    " }),
        i(2),
        t({ "", "} break;" }),
    }),

    -- include system
    s("inc", {
        t("#include <"),
        i(1, "stdio.h"),
        t(">"),
    }),

    -- include local
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
        f(function(args) return args[1][1] end, { 1 }),
        t({ "", "", "" }),
        i(2),
        t({ "", "", "#endif /* " }),
        f(function(args) return args[1][1] end, { 1 }),
        t(" */"),
    }),

    -- define
    s("def", {
        t("#define "),
        i(1, "NAME"),
        t(" "),
        i(2, "value"),
    }),

    -- typedef
    s("td", {
        t("typedef "),
        i(1, "type"),
        t(" "),
        i(2, "alias"),
        t(";"),
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

    -- printf
    s("pr", {
        t('printf("'),
        i(1, "%s\\n"),
        t('"'),
        i(2),
        t(");"),
    }),

    -- fprintf stderr
    s("epr", {
        t('fprintf(stderr, "'),
        i(1, "error: %s\\n"),
        t('"'),
        i(2),
        t(");"),
    }),

    -- malloc
    s("mal", {
        i(1, "type"),
        t(" *"),
        i(2, "ptr"),
        t(" = malloc(sizeof("),
        f(function(args) return args[1][1] end, { 1 }),
        t("));"),
    }),

    -- calloc
    s("cal", {
        i(1, "type"),
        t(" *"),
        i(2, "ptr"),
        t(" = calloc("),
        i(3, "count"),
        t(", sizeof("),
        f(function(args) return args[1][1] end, { 1 }),
        t("));"),
    }),

    -- free and null
    s("fr", {
        t("free("),
        i(1, "ptr"),
        t(");"),
        t({ "", "" }),
        f(function(args) return args[1][1] end, { 1 }),
        t(" = NULL;"),
    }),

    -- sizeof
    s("sz", {
        t("sizeof("),
        i(1, "type"),
        t(")"),
    }),

    -- cast
    s("cast", {
        t("("),
        i(1, "type"),
        t(")("),
        i(2, "expr"),
        t(")"),
    }),

    -- TODO comment
    s("todo", {
        t("// TODO(nasr): "),
        i(1, "description"),
    }),

    -- NOTE comment
    s("note", {
        t("// NOTE(nasr): "),
        i(1, "description"),
    }),

    -- separator
    s("sep", {
        t("///////////////////////////////////////////////////////////////////////////////"),
    }),

    -- section banner
    s("ban", {
        t({ "///////////////////////////////////////////////////////////////////////////////", "// " }),
        i(1, "Section"),
        t({ "", "///////////////////////////////////////////////////////////////////////////////", "" }),
    }),
}
