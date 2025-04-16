-- local presence = require "better-vim.configs.presence"

return {
  { "wakatime/vim-wakatime" },
  { "styled-components/vim-styled-components", branch = "develop" },
  { "posva/vim-vue" },
  { "vim-syntastic/syntastic" },
  { "mtscout6/syntastic-local-eslint.vim" },
  { "leafOfTree/vim-vue-plugin" },
  { "dart-lang/dart-vim-plugin" },
  { "thosakwe/vim-flutter" },
  { "joshdick/onedark.vim" },
  { "jwalton512/vim-blade" },
  { "wojciechkepka/vim-github-dark" },
  { "rescript-lang/vim-rescript" },
  { "github/copilot.vim" },
  { "nvim-tree/nvim-web-devicons", opts = {} },
  -- {
  --   "andweeb/presence.nvim",
  --   opts = presence
  -- },
  { "lewis6991/gitsigns.nvim" },
  { "f-person/git-blame.nvim" },
  { "wuelnerdotexe/vim-astro" },
  { "prisma/vim-prisma" },
  "mg979/vim-visual-multi",
  {
    "marilari88/twoslash-queries.nvim",
    opts = {
      multi_line = true,    -- to print types in multi line mode
      highlight = "Type",   -- to set up a highlight group for the virtual text
    },
  },
  "voldikss/vim-floaterm",
}

