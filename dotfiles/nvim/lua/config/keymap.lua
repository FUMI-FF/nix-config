-- タブ切り替え
vim.keymap.set("n", "gl", ":tabnext<CR>", { silent = true, desc = "Next tab" })
vim.keymap.set("n", "gh", ":tabprevious<CR>", { silent = true, desc = "Previous tab" })
-- no search
vim.keymap.set("n", "<ESC><ESC>", ":nohlsearch<CR>", {silent = true, desc = "reset highlight"})
