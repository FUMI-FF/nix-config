return {
  {
    "junegunn/fzf.vim",
    dependencies = { "junegunn/fzf" },
    keys = {
      { "<Space>p", "<cmd>Files<CR>", mode = { "n", "x" }, desc = "Find files (fzf)" },
    },
  },
  {
    "stevearc/oil.nvim",
    dependencies = {
      { "nvim-mini/mini.icons", opts = {} },
    },
    keys = {
      { "<Space>e", "<cmd>Oil<CR>", desc = "Open Oil file explorer" },
       -- Git ルートを Oil で開く
      {
        "<Space>o",
        function()
          local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
          if git_root and vim.fn.isdirectory(git_root) == 1 then
            vim.cmd("tabnew") -- 新しいタブで開く
            require("oil").open(git_root)
          else
            vim.notify("Not in a git repository", vim.log.levels.WARN)
          end
        end,
        desc = "Open Oil at Git root",
    },
    },
    opts = {
      default_file_explorer = true,
      view_options = {
        show_hidden = true,
      },
      skip_confirm_for_simple_edits = true,
    },
    lazy = false, -- 起動時にすぐ読み込む
  },
}
