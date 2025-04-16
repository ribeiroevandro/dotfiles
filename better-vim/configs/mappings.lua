return {
	leader = ",",
	custom = {
		["<c-w>"] = { ":bd<CR>", "Close file" },
		["<c-q>"] = { ":q!<CR>", " Quit" },
		["<leader>s"] = { "s", "勒Reload Neovim Config" },
		["<leader>e"] = { "<cmd>NvimTreeToggle<CR>", " Toggle explorer" },
		["<leader>zm"] = { "<cmd>ZenMode<CR>", "ZenMode" },
		K = { "<leader>cd", " Show documentation", remap = true },
		["<leader>t"] = { "<cmd>FloatermNew --width=0.8 --height=0.8<cr>", "Open terminal" },
		["<c-\\>"] = { "<cmd>FloatermToggle!<cr>", "Toggle Terminal", mode = { "t", "n" } },
	}
}