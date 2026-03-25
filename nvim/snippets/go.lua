local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("go", {

  -- main function
  s("main", {
    t({ "func main() {", "\t" }), i(1), t({ "", "}" }),
  }),

  -- function
  s("fn", {
    t("func "), i(1, "name"), t("("), i(2), t(") "), i(3), t({ " {", "\t" }),
    i(4), t({ "", "}" }),
  }),

  -- function with error return
  s("fne", {
    t("func "), i(1, "name"), t("("), i(2), t(") ("), i(3), t({ ", error) {", "\t" }),
    i(4), t({ "", "\treturn ", }), i(5, "nil"), t({ ", nil", "}" }),
  }),

  -- if err != nil
  s("ife", {
    t({ "if err != nil {", "\t" }), i(1), t({ "", "}" }),
  }),

  -- log.Fatalf
  s("lf", {
    t('log.Fatalf("'), i(1, "message"), t(': %v", '), i(2, "err"), t(")"),
  }),

  -- fmt.Errorf with %w
  s("fe", {
    t('fmt.Errorf("'), i(1, "message"), t(': %w", '), i(2, "err"), t(")"),
  }),

  -- struct
  s("st", {
    t("type "), i(1, "Name"), t({ " struct {", "\t" }), i(2), t({ "", "}" }),
  }),

  -- custom error struct
  s("errt", {
    t({ "type " }), i(1, "Name"), t({ "Error struct {", "\t" }),
    i(2), t({ "", "}", "", "func (e *" }), i(3), t({ "Error) Error() string {", '\treturn fmt.Sprintf("' }),
    i(4, "message"), t({ '", ', "" }), i(5), t({ "", "}", }),
  }),

  -- for range
  s("forr", {
    t("for _, "), i(1, "v"), t(" := range "), i(2, "slice"), t({ " {", "\t" }),
    i(3), t({ "", "}" }),
  }),

  -- goroutine
  s("go", {
    t({ "go func() {", "\t" }), i(1), t({ "", "}()" }),
  }),

  -- select
  s("sel", {
    t({ "select {", "case " }), i(1), t({ ":", "\t" }), i(2), t({ "", "}" }),
  }),

  -- channel make
  s("mch", {
    t("make(chan "), i(1, "type"), t(", "), i(2, "0"), t(")"),
  }),

  -- header comment (your style)
  s("hdr", {
    t({ "// ============================================================================================", "" }),
    t("// "), i(1, "description"), t({ "", "" }),
    t("// author: abdellah el morabit"), t({ "", "" }),
    t({ "// ============================================================================================" }),
  }),

  -- TODO comment
  s("td", {
    t("// TODO(nasr): "), i(1),
  }),

  -- NOTE comment
  s("nt", {
    t("// NOTE(nasr): "), i(1),
  }),

 -- separator line
  s("sep", {
    t("// ============================================================================="),
  }),

})
