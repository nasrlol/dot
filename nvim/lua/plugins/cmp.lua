 return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-buffer",       
    "hrsh7th/cmp-path",         
    "hrsh7th/cmp-calc",         
    "L3MON4D3/LuaSnip",         
    "saadparwaiz1/cmp_luasnip", 
    "onsails/lspkind.nvim",     
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      formatting = {
        format = lspkind.cmp_format({
          mode = 'symbol_text', 
          menu = ({
            buffer   = "[Buf]",
            path     = "[Path]",
            luasnip  = "[Snip]",
            calc     = "[Calc]",
          })
        }),
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Don't auto-select first item
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = cmp.config.sources({
        { name = "luasnip", priority = 1000 }, -- Snippets first
        { name = "path",    priority = 750 },  -- Paths second
        { 
          name = "buffer", 
          priority = 500,
          option = {
            get_bufnrs = function()
              return vim.api.nvim_list_bufs() -- Complete from ALL open buffers, not just current
            end
          }
        },
        { name = "calc",    priority = 250 },  -- Type "1+1=" to get 2
      }),
    })
  end,
}
