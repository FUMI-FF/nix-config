-- ========= nvim-cmp =========
local cmp = require("cmp")
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  snippet = { expand = function(a) luasnip.lsp_expand(a.body) end },
  mapping = {
    ["<CR>"]      = cmp.mapping.confirm({ select = true }),
    ["<Down>"]     = function(fb)
      if cmp.visible() then cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
      else fb() end
    end,
    ["<Up>"]   = function(fb)
      if cmp.visible() then cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then luasnip.jump(-1)
      else fb() end
    end,
  },
  sources = { { name = "nvim_lsp" }, { name = "path" }, { name = "buffer" }, { name = "luasnip" } },
})

---
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>d', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', vim.lsp.buf.format, bufopts)
end

-- ========= 各サーバ =========
-- Lua
vim.lsp.config("lua_ls", {
  on_attach = on_attach,
  settings = {
    Lua = {
      workspace = { checkThirdParty = false },
      diagnostics = { globals = { "vim" } },
      format = { enable = true },
    },
  },
})
vim.lsp.enable("lua_ls")

-- TypeScript / JavaScript
vim.lsp.config("tsserver", {on_attach=on_attach})
vim.lsp.enable("tsserver")

-- Python
vim.lsp.config("pyright", {
  on_attach = on_attach
})
vim.lsp.enable("pyright")

-- Go
vim.lsp.config("gopls", {
  on_attach = on_attach,
  settings = { gopls = { analyses = { unusedparams = true }, staticcheck = true } },
})
vim.lsp.enable("gopls")

-- Rust
vim.lsp.config("rust_analyzer", {
  on_attach = on_attach,
  settings = { ["rust-analyzer"] = { cargo = { allFeatures = true } } },
})
vim.lsp.enable("rust_analyzer")

-- 表示微調整
vim.diagnostic.config({
  virtual_text = { spacing = 2, prefix = "●" },
  float = { border = "rounded" },
})

