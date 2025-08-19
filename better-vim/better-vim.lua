local plugins   = require "better-vim.configs.plugins"
local lualine   = require "better-vim.configs.lualine"
local mappings  = require "better-vim.configs.mappings"
local noice     = require "better-vim.configs.noice"
local nvim_tree = require "better-vim.configs.nvim_tree"
-- local dashboard_headers = require "better-vim.configs.headers"

return {
  mappings = mappings,
  plugins = plugins,
  lualine = lualine,
  noice = noice,
  nvim_tree = nvim_tree,
  theme = {
    name = "catppuccin",
    catppuccin_flavour = "mocha"
  },
  -- dashboard = {
  --   header = dashboard_headers.buser_with_name,
  -- },
  lsps = {
    biome = {},
    prismals = {},
    astro = {},
    tailwindcss = {},
    bashls = {
      settings = {
        allowlist = { "sh", "bash" },
      },
    },
    tsserver = {
      on_attach = function(client, bufnr)
        require "twoslash-queries".attach(client, bufnr)
      end,
    },
  },
  formatters = {
    blade_formatter = {},
  },
  treesitter_ignore = { "ipkg" },
  treesitter = "all",
  flags = {
    format_on_save = true,
    experimental_tsserver = true
  },
  hooks = {
    after_setup = function()
      -- require "better-vim.configs.devicons"
      require "better-vim.configs.signs"
      vim.o.backupdir = "/tmp/.nvim/backup"
      vim.o.directory = "/tmp/.nvim/swap"
      vim.o.undodir = "/tmp/.nvim/undo"
      vim.cmd [[
				nnoremap <A-Down> :m .+1<CR>==
				nnoremap <A-Up> :m .-2<CR>==
				inoremap <A-Down> <Esc>:m .+1<CR>==gi
				inoremap <A-Up> <Esc>:m .-2<CR>==gi
				vnoremap <A-Down> :m '>+1<CR>gv=gv
				vnoremap <A-Up> :m '<-2<CR>gv=gv
			]]
      -- colorcolumn from 80 to the end of the buffer width
      vim.cmd [[ let &colorcolumn=join(range(81,999),",") ]]
    end
  }
}