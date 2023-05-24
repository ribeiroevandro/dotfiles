return {
	leader = ",",
	custom = {
		["<c-w>"] = { ":bd<CR>", "Close file" },
		["<c-q>"] = { ":q!<CR>", " Quit" },
		["<leader>s"] = { "s", "勒Reload Neovim Config" },
		["<leader>e"] = { "<cmd>NvimTreeToggle<CR>", " Toggle explorer" },
		["<leader>zm"] = { "<cmd>ZenMode<CR>", "ZenMode" },
	}
}
