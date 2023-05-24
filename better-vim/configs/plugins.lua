local presence = require "better-vim.configs.presence"

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
  {
    "andweeb/presence.nvim",
    opts = presence
  },
  { "lewis6991/gitsigns.nvim" },
  { "f-person/git-blame.nvim" },
  { "wuelnerdotexe/vim-astro" },
}
