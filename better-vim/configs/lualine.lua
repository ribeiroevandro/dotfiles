local terminal_opened_status = function()
    local terminals = vim.inspect(vim.api.nvim_call_function("floaterm#buflist#gather", {}))
    local is_terminal_opened = #terminals > 2
    return is_terminal_opened and "󰆍" or ""
  end
  
  return {
    options = {
      theme = "catppuccin",
      component_separators = { left = "", right = "" },
      section_separators = { left = " ", right = "" },
    },
    sections = {
      a = { "mode" },
      b = {
        { "branch" },
        { "diff", color = { bg = "#45475A" }, separator = { left = "", right = " " } },
      },
      c = { "filename", terminal_opened_status },
      x = { "encoding", "filetype" },
      y = { "progress" },
      z = { "location" },
    },
  }