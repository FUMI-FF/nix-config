return {
  -- LSP/Tool インストーラ
  {
    "mason-org/mason.nvim",
    opts = {}
  },
  -- LSP 本体
  { "neovim/nvim-lspconfig" },
  -- 補完まわり
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
  },
}
