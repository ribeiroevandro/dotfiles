return {
  mappings = {
   leader = ",",
   custom = {
    ["<c-w>"] = { ":bd<CR>", "Close file" },
    ["<c-q>"] = { ":q!<CR>", " Quit" },
    ["<leader>s"] = { "s", "勒Reload Neovim Config" },
    ["<leader>e"] = { "<cmd>NvimTreeToggle<CR>", " Toggle explorer" },
    ["<leader>zm"] = { "<cmd>ZenMode<CR>", "ZenMode" },
   }
 },
  theme = {
    name = "catppuccin",
    catppuccin_flavour = "mocha"
  },
  lualine = {
    options = {
      theme = "catppuccin"
    },
    sections = {
      b = {'branch'},
      c = {
        {'diff', color = { bg = '#45475A' }, separator = { left = '', right = '' }},
        {'filename'}
      },
      x = {
        {'diagnostics', separator = { left = '|', right = '|' } },
        {'filetype'},
      },
      y = {'progress'},
      z = {'location'}
    },
  }
}

