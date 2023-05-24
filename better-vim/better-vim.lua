local plugins  = require "better-vim.configs.plugins"
local lualine  = require "better-vim.configs.lualine"
local mappings = require "better-vim.configs.mappings"

return {
	mappings = mappings,
	plugins = plugins,
	lualine = lualine,
	theme = {
		name = "catppuccin",
		catppuccin_flavour = "mocha"
	},
	lsps = {
		prismals = {},
		astro = {},
		tailwindcss = {}
	},
	formatters = {
		blade_formatter = {},
	},
	treesitter = "all",
	flags = {
		format_on_save = true
	},
	hooks = {
		after_setup = function()
			require "better-vim.configs.devicons"
			require "better-vim.configs.signs"
			vim.cmd [[
				nnoremap <A-Down> :m .+1<CR>==
				nnoremap <A-Up> :m .-2<CR>==
				inoremap <A-Down> <Esc>:m .+1<CR>==gi
				inoremap <A-Up> <Esc>:m .-2<CR>==gi
				vnoremap <A-Down> :m '>+1<CR>gv=gv
				vnoremap <A-Up> :m '<-2<CR>gv=gv
			]]
		end
	}
}
