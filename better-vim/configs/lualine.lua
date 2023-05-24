return {
  options = {
    theme = "catppuccin",
    component_separators = { left = "", right = "" },
    section_separators = { left = " ", right = "" },
  },
  sections = {
    a = { "mode" },
    b = { "branch" },
    c = {
      { "diff", color = { bg = "#45475A" }, separator = { left = "", right = " " } },
      { "filename" },
    },
    x = { "encoding", "filetype" },
    y = { "progress" },
    z = { "location" },
  },
}
