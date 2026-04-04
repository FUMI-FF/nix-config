return {
  {
    "tpope/vim-surround"
  },
  {
    "tpope/vim-commentary"
  },
  {
    "junegunn/vim-easy-align",
    keys = {
      {"ga", "<Plug>(EasyAlign)", mode = { "n", "x" }}
    },
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true
  },
}
