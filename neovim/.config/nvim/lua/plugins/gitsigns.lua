return {
  "lewis6991/gitsigns.nvim",
  config = function()
    require("gitsigns").setup()
    vim.keymap.set("n", "<leader>gd", ":Gitsigns preview_hunk_inline<CR>", {})
    vim.keymap.set("n", "<leader>hr", ":Gitsigns reset_hunk<CR>", {})
    vim.keymap.set("n", "<leader>gr", ":Gitsigns reset_buffer<CR>", {})
  end,
}
