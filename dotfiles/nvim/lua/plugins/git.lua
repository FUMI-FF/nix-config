return {
  {
    "tpope/vim-fugitive"
  },
  {
    "airblade/vim-gitgutter",
    config = function()
      vim.opt.updatetime = 100
    end,
  }
}
